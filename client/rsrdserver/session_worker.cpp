
#include "include.h"



class CWinStation
{
          HWINSTA h_old;
          HWINSTA h_new;
          BOOL b_set;

  public:
          CWinStation(const char *name,int access=MAXIMUM_ALLOWED);
          ~CWinStation();

          static BOOL WaitForWinStation(const char *name,unsigned delta_ms,int trycount);
};


CWinStation::CWinStation(const char *name,int access)
{
  h_old = GetProcessWindowStation();
  h_new = OpenWindowStation(name,FALSE,access);
  b_set = h_new ? SetProcessWindowStation(h_new) : FALSE;
}


CWinStation::~CWinStation()
{
  if ( b_set )
     {
       SetProcessWindowStation(h_old);
     }

  if ( h_new )
     {
       CloseWindowStation(h_new);
     }
}


BOOL CWinStation::WaitForWinStation(const char *name,unsigned delta_ms,int trycount)
{
  BOOL rc = FALSE;
  
  for ( int n = 0; n < trycount; n++ )
      {
        HWINSTA ws = OpenWindowStation(name,FALSE,GENERIC_READ);
        if ( ws )
           {
             CloseWindowStation(ws);
             rc = TRUE;
             break;
           }
        else
           {
             Sleep(delta_ms);
           }
      }

  return rc;
}


/////////////////////////////


class CDesktop
{
          HDESK h_old;
          HDESK h_new;
          BOOL b_set;

  public:
          CDesktop(const char *name=NULL,int access=MAXIMUM_ALLOWED);
          ~CDesktop();

          static BOOL WaitForDesktop(const char *name,unsigned delta_ms,int trycount);
};


CDesktop::CDesktop(const char *name,int access)
{
  h_old = GetThreadDesktop(GetCurrentThreadId());
  h_new = IsStrEmpty(name) ? OpenInputDesktop(0,FALSE,access) : OpenDesktop(name,0,FALSE,access);
  b_set = h_new ? SetThreadDesktop(h_new) : FALSE;
}


CDesktop::~CDesktop()
{
  if ( b_set )
     {
       SetThreadDesktop(h_old);
     }

  if ( h_new )
     {
       CloseDesktop(h_new);
     }
}


BOOL CDesktop::WaitForDesktop(const char *name,unsigned delta_ms,int trycount)
{
  BOOL rc = FALSE;
  
  for ( int n = 0; n < trycount; n++ )
      {
        HDESK dsk = IsStrEmpty(name) ? OpenInputDesktop(0,FALSE,GENERIC_READ) : OpenDesktop(name,0,FALSE,GENERIC_READ);
        if ( dsk )
           {
             CloseDesktop(dsk);
             rc = TRUE;
             break;
           }
        else
           {
             Sleep(delta_ms);
           }
      }

  return rc;
}


/////////////////////////////


void DisableScreenSaver(unsigned& last_time)
{
  if ( GetTickCount() - last_time > 1000 )
     {
       SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,FALSE,NULL,0);
       last_time = GetTickCount();
     }
}


void UpdateThreadState()
{
  SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
}



typedef struct {
HANDLE h_pipe;
CScreenProcessing *screen;
CEvents *events;
CDynBuff *dynbuff;
CRITICAL_SECTION *cs;
} THREADINFO;


DWORD WINAPI CommThreadProc(LPVOID lpParameter)
{
  THREADINFO *i = (THREADINFO*)lpParameter;

  if ( i )
     {
       HANDLE h_pipe = i->h_pipe;
       CScreenProcessing *screen = i->screen;
       CEvents *events = i->events;
       CDynBuff *dynbuff = i->dynbuff;
       CRITICAL_SECTION *cs = i->cs;

       SAFESYSFREE(i);
       
       while ( 1 )
       {
         UpdateThreadState();

         char rbuff[128];
         DWORD read_bytes = 0;
         if ( !ReadFile(h_pipe,rbuff,sizeof(rbuff),&read_bytes,NULL) || read_bytes < sizeof(unsigned) )
            break;

         unsigned cmd = *(unsigned*)rbuff;
            
         if ( cmd == CMD_INPUTEVENT )
            {
              const struct _S_INPUTEVENT {
               unsigned cmd;
               int message,wParam,lParam;
               unsigned time;
              } *p = (struct _S_INPUTEVENT*)rbuff;

              if ( read_bytes == sizeof(*p) )
                 {
                   {
                     CDesktop desk(NULL);
                     events->OnInputEvent(p->message,p->wParam,p->lParam,p->time);
                   }

                   DWORD written_bytes = 0;
                   int answer = 1;
                   if ( !WriteFile(h_pipe,&answer,sizeof(answer),&written_bytes,NULL) || written_bytes != sizeof(answer) )
                      break;
                 }
              else
                 {
                   break;
                 }
            }
         else
         if ( cmd == CMD_SCREENREQ_RLE7B_GRAY || cmd == CMD_SCREENREQ_RLE7B_COLOR )
            {
              const struct _S_SCREENREQ {
               unsigned cmd;
               BOOL session_changed;
              } *p = (struct _S_SCREENREQ*)rbuff;

              if ( read_bytes == sizeof(*p) )
                 {
                   CCSGuard g(*cs);

                   void *buff = NULL;
                   int size = 0;
                   int w = 0;
                   int h = 0;

                   {
                     CDesktop desk(NULL);
                     screen->PrepareFrame(p->session_changed,cmd==CMD_SCREENREQ_RLE7B_GRAY,&buff,&size,&w,&h);
                   }

                   dynbuff->Clear();
                   dynbuff->AddInt(cmd);
                   dynbuff->AddInt(w);
                   dynbuff->AddInt(h);
                   dynbuff->AddInt(size);
                   dynbuff->AddBuff(buff,size);  // maybe NULL
                   
                   DWORD written_bytes = 0;
                   if ( !WriteFile(h_pipe,dynbuff->GetBuffPtr(),dynbuff->GetBuffSize(),&written_bytes,NULL) || written_bytes != dynbuff->GetBuffSize() )
                      break;
                 }
              else
                 {
                   break;
                 }
            }
         else
            {
              break;
            }
       };

       FlushFileBuffers(h_pipe);
       DisconnectNamedPipe(h_pipe);
       CloseHandle(h_pipe);
     }

  return 1;
}


void CreateRSRDMutex()
{
  SECURITY_ATTRIBUTES sa;
  sa.nLength = sizeof(sa);
  sa.lpSecurityDescriptor = AllocateSDWithNoDACL();
  sa.bInheritHandle = FALSE;
  CreateMutex(&sa,FALSE,RSRD_MUTEX);
  FreeSD(sa.lpSecurityDescriptor);
}


void Processing_NeverReturns()
{
  DWORD sid = 0;
  ProcessIdToSessionId(GetCurrentProcessId(),&sid);
  char pipe_name[MAX_PATH];
  sprintf(pipe_name,PIPENAME_FMT,sid);

  CScreenProcessing *screen = new CScreenProcessing();
  CEvents *events = new CEvents();
  CDynBuff *dynbuff = new CDynBuff();
  CRITICAL_SECTION *cs = new CRITICAL_SECTION;
  InitializeCriticalSection(cs);

  unsigned last_ss_time = GetTickCount() - 10000;

  while ( 1 )
  {
    DisableScreenSaver(last_ss_time);
    UpdateThreadState();

    HANDLE h_pipe = CreateNamedPipe(pipe_name,
                    PIPE_ACCESS_DUPLEX,
                    PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
                    PIPE_UNLIMITED_INSTANCES,
                    4096,4096,
                    NMPWAIT_USE_DEFAULT_WAIT,
                    NULL);

    if ( h_pipe != INVALID_HANDLE_VALUE )
       {
         BOOL rc = ConnectNamedPipe(h_pipe,NULL);
         if ( !rc && GetLastError() == ERROR_PIPE_CONNECTED )
            {
              rc = TRUE;
            }

         if ( rc )
            {
              THREADINFO *i = (THREADINFO*)sys_alloc(sizeof(THREADINFO));
              i->h_pipe = h_pipe;
              i->screen = screen;
              i->events = events;
              i->dynbuff = dynbuff;
              i->cs = cs;
              HANDLE h_commthread = CreateThread(NULL,0,CommThreadProc,i,0,NULL);
              CloseHandle(h_commthread);
            }
         else
            {
              CloseHandle(h_pipe);
              Sleep(30);
            }
       }
    else
       {
         Sleep(100);
       }
  };

  // never got here!
  //DeleteCriticalSection(cs);
  //SAFEDELETE(cs);
  //SAFEDELETE(dynbuff);
  //SAFEDELETE(events);
  //SAFEDELETE(screen);
}



void SessionWorker()
{
  CreateMutex(NULL,FALSE,"Local\\rsrdSessionMutex");
  if ( GetLastError() != ERROR_ALREADY_EXISTS )
     {
       SetProcessShutdownParameters(2,SHUTDOWN_NORETRY);  // needed?

       if ( CWinStation::WaitForWinStation("WinSta0",50,40) )
          {
            CWinStation winsta("WinSta0");

            if ( CDesktop::WaitForDesktop(NULL,50,40) )
               {
                 CDesktop desk(NULL);
                 GdiSetBatchLimit(1); // any GDI or USER function to assign winstation and desktop
                 CreateRSRDMutex();
                 Processing_NeverReturns();
               }
          }
     }
}


