
#include "include.h"



CiButton::CiButton()
{
  h_lib = NULL;

  pTMExtendedStartSession = NULL;
  pTMEndSession = NULL;
  pTMFirst = NULL;
  pTMNext = NULL;
  pTMRom = NULL;
  pTMSetup = NULL;
  pTMGetTypeVersion = NULL;

  InitializeCriticalSection(&o_cs);

  r_seed = GetTickCount();

  b_device_detection = TRUE;  // at startup we must detect device first
  i_port_num = -1;
  i_port_type = -1;

  b_event = FALSE;
  s_rom[0] = 0;

  u_last_event_time = GetTickCount() - 60000;
  b_last_state = TRUE;  // ignore already connected iButton at startup

  h_event_thread_stop = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = MyCreateThreadSelectedCPU(ThreadProcWrapper,this);
}


CiButton::~CiButton()
{
  SetEvent(h_event_thread_stop);
  if ( WaitForSingleObject(h_thread,1000) == WAIT_TIMEOUT )
     TerminateThread(h_thread,1);
  CloseHandle(h_thread);
  CloseHandle(h_event_thread_stop);

  DeleteCriticalSection(&o_cs);
}


int CiButton::RandomSeed()
{
  r_seed = r_seed * 0x41C64E6D + 0x3039;
  return (r_seed >> 16) & 0xFFFF;
}


BOOL CiButton::IsDeviceDetection(BOOL &_is_present)
{
  CCSGuard oGuard(o_cs);

  if ( b_device_detection )
     {
       _is_present = FALSE;
       return TRUE;
     }
  else
     {
       _is_present = (i_port_num != -1 && i_port_type != -1);
       return FALSE;
     }
}


BOOL CiButton::IsEvent(char *id,int max)
{
  CCSGuard oGuard(o_cs);

  if ( id )
     id[0] = 0;

  if ( b_event )
     {
       if ( id )
          lstrcpyn(id,s_rom,max);
       b_event = FALSE; //reset event flag
       return TRUE;
     }
  else
     {
       return FALSE;
     }
}


BOOL CiButton::CatchSession(long &_session,int port_type,int port_num)
{
  _session = 0;

  if ( port_type == -1 )
     port_type = i_port_type;
  if ( port_num == -1 )
     port_num = i_port_num;

  unsigned elapsed_time = 0;
  
  do {

    long rc = pTMExtendedStartSession(port_num,port_type,NULL);

    if ( rc > 0 )
       {
         _session = rc;
         return TRUE;
       }
    else
    if ( rc < 0 )
       {
         return FALSE;
       }
    else
       {
         unsigned d = (RandomSeed() % 15) + 5;
         Sleep(d);
         elapsed_time += d;
       }

  } while ( elapsed_time < 200 );
  
  return FALSE;
}


void CiButton::CloseSession(long session)
{
  pTMEndSession(session);
}


BOOL CiButton::IsButtonConnected(long session,char *state_buffer)
{
  return pTMFirst(session,state_buffer) == 1;
}


BOOL CiButton::ReadROM8(long session,char *state_buffer,unsigned char *_rom8)
{
  BOOL rc = FALSE;
  
  short i_rom[9];

  i_rom[0] = 0; // set direction
  if ( pTMRom(session,state_buffer,i_rom) == 1 )
     {
       for ( int n = 0; n < 8; n++ )
           {
             _rom8[n] = (i_rom[n] & 0xFF);
           }

       rc = TRUE;
     }

  return rc;
}


BOOL CiButton::DetectDevice()
{
  static const int port_types[] =
  {
    1, // COM DS9097E
    5, // COM DS90907U
//    2, // LPT
//    6, // USB
  };

  int find_type = -1, find_port = -1;

  for ( int n = 0; n < sizeof(port_types)/sizeof(port_types[0]); n++ )
      {
        int curr_type = port_types[n];

        char tver[200] = "";
        if ( pTMGetTypeVersion(curr_type,tver) > 0 )  //load driver
           {
             for ( int curr_port = 0; curr_port <= 15; curr_port++ )
                 {
                   long session = 0;
                   if ( CatchSession(session,curr_type,curr_port) )
                      {
                        int code = pTMSetup(session);
                        CloseSession(session);

                        if ( code == 1 || code == 2 /*really?*/ )
                           {
                             find_type = curr_type;
                             find_port = curr_port;
                             break;
                           }
                      }
                 }
           }

        if ( find_type != -1 && find_port != -1 )
           break;
      }
  
  { // store results
    CCSGuard oGuard(o_cs);
    
    i_port_num = find_port;
    i_port_type = find_type;
    b_device_detection = FALSE;
  }

  return find_type != -1 && find_port != -1;
}


DWORD WINAPI CiButton::ThreadProcWrapper(LPVOID lpParameter)
{
  CiButton *obj = (CiButton*)lpParameter;
  return obj->ThreadProc();
}


DWORD CiButton::ThreadProc()
{
  h_lib = LoadLibrary("ibfs32.dll");

  *(void**)&pTMExtendedStartSession = (void*)GetProcAddress(h_lib,"TMExtendedStartSession");
  *(void**)&pTMEndSession =           (void*)GetProcAddress(h_lib,"TMEndSession");
  *(void**)&pTMFirst =                (void*)GetProcAddress(h_lib,"TMFirst");
  *(void**)&pTMNext =                 (void*)GetProcAddress(h_lib,"TMNext");
  *(void**)&pTMRom =                  (void*)GetProcAddress(h_lib,"TMRom");
  *(void**)&pTMSetup =                (void*)GetProcAddress(h_lib,"TMSetup");
  *(void**)&pTMGetTypeVersion =       (void*)GetProcAddress(h_lib,"TMGetTypeVersion");

  if ( pTMExtendedStartSession && pTMEndSession && pTMFirst && pTMNext && pTMRom && pTMSetup && pTMGetTypeVersion )
     {
       // first detect device
       if ( DetectDevice() )  // we do not support hot-plug devices, so exit if not find
          {
            // main loop
            do {

              if ( GetTickCount() - u_last_event_time > 1500 ) // защита от дребезга
                 {
                   long session = 0;
                   if ( CatchSession(session) )
                      {
                        if ( IsButtonConnected(session,drv_state_buffer) )
                           {
                             if ( !b_last_state )
                                {
                                  unsigned char i_rom[8];
                                  if ( ReadROM8(session,drv_state_buffer,i_rom) )
                                     {
                                       b_last_state = TRUE;
                                       u_last_event_time = GetTickCount();

                                       AddEvent(i_rom);
                                     }
                                }
                           }
                        else
                           {
                             b_last_state = FALSE;
                           }

                        CloseSession(session);
                      }
                 }

              if ( WaitForSingleObject(h_event_thread_stop,100) == WAIT_OBJECT_0 )
                 break;

            } while (1);
          }
     }
  else
     {
       CCSGuard oGuard(o_cs);
       b_device_detection = FALSE;
     }

  if ( h_lib )
     FreeLibrary(h_lib);
  h_lib = NULL;

  pTMExtendedStartSession = NULL;
  pTMEndSession = NULL;
  pTMFirst = NULL;
  pTMNext = NULL;
  pTMRom = NULL;
  pTMSetup = NULL;
  pTMGetTypeVersion = NULL;

  return 1;
}


// we support only one event (events FIFO is not implemented)
void CiButton::AddEvent(const unsigned char *rom8)
{
  CCSGuard oGuard(o_cs);

  wsprintf(s_rom,"iButton_%02X%02X%02X%02X%02X%02X%02X%02X",rom8[7],rom8[6],rom8[5],rom8[4],rom8[3],rom8[2],rom8[1],rom8[0]);
  b_event = TRUE;
}


