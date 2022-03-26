


static BOOL InjectDLLIntoProcessInternal(int pid,const char *dll_path)
{
  BOOL rc = FALSE;
  
  HANDLE h_process = OpenProcess(PROCESS_CREATE_THREAD | PROCESS_QUERY_INFORMATION | PROCESS_VM_OPERATION | PROCESS_VM_WRITE | PROCESS_VM_READ,FALSE,pid);
  if ( h_process )
     {
       char *s = (char*)VirtualAllocEx(h_process,NULL,lstrlen(dll_path)+1,MEM_COMMIT | MEM_TOP_DOWN,PAGE_READWRITE);
       if ( s )
          {
            BOOL can_free = TRUE;

            DWORD written = 0;
            if ( WriteProcessMemory(h_process,s,dll_path,lstrlen(dll_path)+1,&written) && written == lstrlen(dll_path)+1 )
               {
                 void *p_loadlibrary = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"LoadLibraryA");
                 if ( p_loadlibrary )
                    {
                      HANDLE h_thread = CreateRemoteThread(h_process,NULL,0,(LPTHREAD_START_ROUTINE)p_loadlibrary,s,0,NULL);
                      if ( h_thread )
                         {
                           if ( WaitForSingleObject(h_thread,INFINITE) == WAIT_OBJECT_0 )
                              {
                                DWORD code = STILL_ACTIVE;
                                if ( GetExitCodeThread(h_thread,&code) && code != STILL_ACTIVE )
                                   {
                                     rc = (code != 0);
                                   }
                              }
                           else
                              {
                                can_free = FALSE;
                              }

                           CloseHandle(h_thread);
                         }
                    }
               }

            if ( can_free )
               {
                 VirtualFreeEx(h_process,s,0,MEM_RELEASE);
               }
          }
       
       CloseHandle(h_process);
     }
             
  return rc;
}


static BOOL InjectDLLIntoProcess(int pid,const char *dll_path)
{
  BOOL rc = FALSE;
  
  if ( pid != -1 && pid != GetCurrentProcessId() )
     {
       if ( dll_path && dll_path[0] )
          {
            HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,pid);
            if ( snap != INVALID_HANDLE_VALUE )
               {
                 MODULEENTRY32 i;
                 BOOL b, find = FALSE;

                 ZeroMemory(&i,sizeof(i));
                 i.dwSize = sizeof(i);
                 
                 b = Module32First(snap,&i);
                 while( b )
                 {
                   if ( !lstrcmpi(i.szExePath,dll_path) )
                      {
                        find = TRUE;
                        break;
                      }

                   b = Module32Next(snap,&i);
                 }

                 CloseHandle(snap);

                 if ( !find )
                    {
                      if ( IsFileExist(dll_path) )
                         {
                           rc = InjectDLLIntoProcessInternal(pid,dll_path);
                         }
                    }
               }
          }
     }

  return rc;
}


typedef struct {
const char *list;
const char *dll_path;
BOOL allow_into_older;
int delay;
} INJECTINFO;


static BOOL InjectIntoProcessListInternal(int pid,const char *exe_path,void *parm)
{
  INJECTINFO *i = (INJECTINFO*)parm;

  if ( i && i->list && i->list[0] && i->dll_path && i->dll_path[0] )
     {
       char s[MAX_PATH],*p;
       int n,len;
       BOOL find = FALSE;

       ZeroMemory(s,sizeof(s));
       lstrcpy(s,i->list);
       len = lstrlen(s);
       for ( n = 0; n < len; n++ )
           if ( s[n] == ';' || s[n] == ',' )
              s[n] = 0;
       p = s;
       while ( *p )
       {
         char exe[MAX_PATH];
         int pid;
         
         lstrcpy(exe,p);
         p += lstrlen(p)+1;
         PathRemoveBlanks(exe);
         if ( !lstrcmpi(exe,PathFindFileName(exe_path)) )
            {
              find = TRUE;
              break;
            }
       };

       if ( find )
          {
            if ( pid != -1 && pid != GetCurrentProcessId() )
               {
                 if ( !IsWOW64() || IsPidWow64(pid) )
                    {
                      BOOL allow = TRUE;
                      
                      if ( !i->allow_into_older )
                         {
                           unsigned t_process = GetProcessCreationTimeInSec(pid);
                           unsigned t_my = GetProcessCreationTimeInSec(GetCurrentProcessId());

                           allow = ( t_process && t_my && t_my < t_process );
                         }

                      if ( allow )
                         {
                           if ( i->delay > 0 )
                              {
                                unsigned t_process = GetProcessCreationTimeInSec(pid);
                                __int64 ft = GetSystemTime64();
                                unsigned t_now = GetNormalTimeSec((FILETIME*)&ft);

                                allow = (t_process && t_now && t_now - t_process >= i->delay);
                              }
                           
                           if ( allow )
                              {
                                InjectDLLIntoProcess(pid,i->dll_path);
                              }
                         }
                    }
               }
          }
     }

  return TRUE;
}


static void InjectIntoProcessList(const char *list,const char *dllpath,BOOL allow_into_older,int delay)
{
  if ( list && list[0] && dllpath && dllpath[0] )
     {
       INJECTINFO i;
       
       i.list = list;
       i.dll_path = dllpath;
       i.allow_into_older = allow_into_older;
       i.delay = delay;
       ScanProcesses(InjectIntoProcessListInternal,(void*)&i);
     }
}


void InjectLocalDLLIntoProcessList32(const char *list,const char *dllname,BOOL allow_into_older,int delay)
{
  char s[MAX_PATH];
  InjectIntoProcessList(list,GetLocalPath(dllname,s),allow_into_older,delay);
}

