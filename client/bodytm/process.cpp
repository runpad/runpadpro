
#include "include.h"



CSessionProcessList::CSessionProcessList()
{
  snap.handle = INVALID_HANDLE_VALUE;
  snap.first = TRUE;

  wts.our_sid = -1;
  wts.list = NULL;
  wts.count = 0;
  wts.curr = 0;

  if ( is_wtsenumproc_bug_present ||
       !ProcessIdToSessionId(GetCurrentProcessId(),&wts.our_sid) ||
       !WTSEnumerateProcesses(WTS_CURRENT_SERVER_HANDLE,0,1,&wts.list,&wts.count) ||
       !wts.list )
     {
       snap.handle = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);  // we are in win2000
     }
}


CSessionProcessList::~CSessionProcessList()
{
  if ( wts.list )
     {
       WTSFreeMemory(wts.list);
       wts.list = NULL;
     }

  if ( snap.handle != INVALID_HANDLE_VALUE )
     {
       CloseHandle(snap.handle);
       snap.handle = INVALID_HANDLE_VALUE;
     }
}


BOOL CSessionProcessList::GetNext(int *_pid,char *_filename)
{
  BOOL rc = FALSE;
  
  if ( _pid )
     *_pid = -1;
  if ( _filename )
     _filename[0] = 0;
  
  if ( wts.list )
     {
       for ( ; wts.curr < wts.count; wts.curr++ )
           {
             const WTS_PROCESS_INFO *i = &wts.list[wts.curr];

             if ( i->SessionId == wts.our_sid )
                {
                  if ( _pid )
                     *_pid = i->ProcessId;
                  if ( _filename )
                     {
                       if ( i->pProcessName && i->pProcessName[0] )
                          lstrcpyn(_filename,i->pProcessName,MAX_PATH);
                       else
                          lstrcpy(_filename,"[System Process]");
                     }

                  wts.curr++;  // go next
                  rc = TRUE;
                  break;
                }
           }
     }
  else
  if ( snap.handle != INVALID_HANDLE_VALUE )
     {
       PROCESSENTRY32 i;
       ZeroMemory(&i,sizeof(i));
       i.dwSize = sizeof(i);

       if ( snap.first )
          {
            if ( Process32First(snap.handle,&i) )
               {
                 snap.first = FALSE;  // go next
                 rc = TRUE;
               }
          }
       else
          {
            if ( Process32Next(snap.handle,&i) )
               {
                 rc = TRUE;
               }
          }

       if ( rc )
          {
            if ( _pid )
               *_pid = i.th32ProcessID;
            if ( _filename )
               lstrcpyn(_filename,i.szExeFile,MAX_PATH);
          }
     }

  return rc;
}


BOOL StdTerminateProcess(int pid)
{
  BOOL rc = FALSE;

  HANDLE ph = OpenProcess(PROCESS_TERMINATE,FALSE,pid);
  if ( ph )
     {
       rc = TerminateProcess(ph,0);
       CloseHandle(ph);
     }

  return rc;
}


BOOL MyTerminateProcess(int pid)
{
  BOOL rc = StdTerminateProcess(pid);
  
  if ( !rc )   
     {
       typedef BOOL (WINAPI *TWinStationTerminateProcess)( HANDLE hServer, ULONG ProcessId, ULONG ExitCode);

       HINSTANCE lib = GetModuleHandle("winsta.dll");
       if ( !lib )
          lib = LoadLibrary("winsta.dll");

       TWinStationTerminateProcess pWinStationTerminateProcess = (TWinStationTerminateProcess)GetProcAddress(lib,"WinStationTerminateProcess");
       if ( pWinStationTerminateProcess )
          {
            rc = pWinStationTerminateProcess(NULL,pid,0);
          }
     }

  return rc;
}

