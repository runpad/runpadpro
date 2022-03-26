
#include "include.h"



CExecutor::CExecutor()
{
  m_last_sid = -2;
  *(void**)&pWTSGetActiveConsoleSessionId = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"WTSGetActiveConsoleSessionId");
}


CExecutor::~CExecutor()
{
  for ( int n = 0; n < m_processes.size(); n++ )
      {
        HANDLE h = m_processes[n];
        m_processes[n] = NULL;
        if ( WaitForSingleObject(h,0) == WAIT_TIMEOUT )
           {
             TerminateProcess(h,0);
             WaitForSingleObject(h,5000/*INFINITE*/);
           }
        CloseHandle(h);
      }

  m_processes.clear();
}


BOOL CExecutor::Prepare(DWORD& _session,BOOL& _session_changed)
{
  BOOL rc = FALSE;
  _session_changed = FALSE;

  DWORD console_sid = pWTSGetActiveConsoleSessionId ? pWTSGetActiveConsoleSessionId() : 0;
  if ( console_sid != 0xFFFFFFFF )
     {
       _session = console_sid;
       if ( console_sid != m_last_sid )
          {
            _session_changed = TRUE;
            m_last_sid = console_sid;
          }
       
       char our_exe[MAX_PATH] = "";
       GetModuleFileName(NULL,our_exe,MAX_PATH);
       PathRemoveUNCPrefix(our_exe);

       rc = (FindProcess(console_sid,our_exe,FALSE) != -1);
       if ( !rc )
          {
            HANDLE token = GetSessionToken(console_sid);
            if ( token )
               {
                 char cmdline[MAX_PATH];
                 sprintf(cmdline,"\"%s\" %s",our_exe,PARM_PROCESS);

                 STARTUPINFO si;
                 PROCESS_INFORMATION pi;
                 ZeroMemory(&si,sizeof(si));
                 si.cb = sizeof(si);
                 if ( CreateProcessAsUser(token,NULL,cmdline,NULL,NULL,FALSE,CREATE_NO_WINDOW,NULL,NULL,&si,&pi) )
                    {
                      CloseHandle(pi.hThread);
                      m_processes.push_back(pi.hProcess);
                      rc = TRUE;
                    }

                 CloseHandle(token);
               }
          }
     }

  return rc;
}


BOOL CExecutor::Exec(DWORD session,const void *inbuff,unsigned insize,void *outbuff,unsigned maxsize,unsigned& _outsize,unsigned timeout)
{
  char pipe_name[MAX_PATH];
  sprintf(pipe_name,PIPENAME_FMT,session);

  _outsize = 0;
  return CallPipe(pipe_name,inbuff,insize,outbuff,maxsize,_outsize,3000,timeout);
}


BOOL CExecutor::CallPipe(const char* pipe_name,
                         const void *inbuff,unsigned insize,void *outbuff,unsigned maxsize,unsigned& _outsize,
                         unsigned timeout_wait,unsigned timeout_call)
{
  BOOL exit_code = FALSE;
  _outsize = 0;

  unsigned starttime = GetTickCount();

  do {
    BOOL rc = CallNamedPipe(pipe_name,(LPVOID)inbuff,insize,outbuff,maxsize,(LPDWORD)&_outsize,timeout_call);
    if ( !rc )
       {
         int err = GetLastError();
         if ( err == ERROR_FILE_NOT_FOUND || err == ERROR_PIPE_BUSY )
            {
              Sleep(10);
            }
         else
            {
              break;
            }
       }
    else
       {
         exit_code = TRUE;
         break;
       }

  } while ( GetTickCount() - starttime < timeout_wait );

  return exit_code;
}


HANDLE CExecutor::GetSessionToken(DWORD sid)
{
  HANDLE token = NULL;

  HANDLE orig = NULL;
  OpenProcessToken(GetCurrentProcess(),TOKEN_QUERY|TOKEN_DUPLICATE,&orig);
  if ( orig )
     {
       DuplicateTokenEx(orig,MAXIMUM_ALLOWED,NULL,SecurityIdentification,TokenPrimary,&token);

       if ( token )
          {
            SetTokenInformation(token,TokenSessionId,&sid,sizeof(sid));
          }
       
       CloseHandle(orig);
     }

  return token;
}


int CExecutor::FindProcess(int session,const char *path,BOOL is_short)
{
  int rc = -1;

  HANDLE list = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);

  if ( list != INVALID_HANDLE_VALUE )
     {
       PROCESSENTRY32 i;
       ZeroMemory(&i,sizeof(i));
       i.dwSize = sizeof(i);
       
       BOOL cont = Process32First(list,&i);
       while ( cont )
       {
         int pid = i.th32ProcessID;
         int sid = 0;
         ProcessIdToSessionId(pid,(DWORD*)&sid);
         
         if ( session == sid && pid != GetCurrentProcessId() )
            {
              BOOL equ;
              
              if ( is_short )
                 {
                   equ = !lstrcmpi(PathFindFileName(i.szExeFile),PathFindFileName(path));
                 }
              else
                 {
                   char fullpath[MAX_PATH] = "";
                   GetExePathByPid(pid,fullpath);

                   equ = !lstrcmpi(fullpath,path);
                 }

              if ( equ )
                 {
                   rc = pid;
                   break;
                 }
            }

         cont = Process32Next(list,&i);
       }

       CloseHandle(list);
     }

  return rc;
}


char* CExecutor::GetExePathByPid(int pid,char *_path)
{
  if ( _path )
     {
       _path[0] = 0;

       HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION|PROCESS_VM_READ,FALSE,pid);
       if ( h )
          {
            if ( !GetModuleFileNameEx(h,NULL,_path,MAX_PATH) )
               {
                 _path[0] = 0; // needed
               }

            PathRemoveUNCPrefix(_path);
            CloseHandle(h);
          }
     }

  return _path;
}


char* CExecutor::PathRemoveUNCPrefix(char *inout)
{
  if ( !IsStrEmpty(inout) )
     {
       if ( !StrCmpNI(inout,"\\\\?\\UNC\\",8) || !StrCmpNI(inout,"\\??\\UNC\\",8) )
          {
            MoveMemory(inout+1,inout+7,(lstrlen(inout)+1-7)*sizeof(inout[0]));
          }
       else
       if ( !StrCmpNI(inout,"\\\\?\\",4) || !StrCmpNI(inout,"\\??\\",4) )
          {
            MoveMemory(inout,inout+4,(lstrlen(inout)+1-4)*sizeof(inout[0]));
          }
     }
                            
  return inout;
}


