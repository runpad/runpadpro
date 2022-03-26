
static HANDLE gg_handle = NULL;  //GameGuard app handle (LineAgeII, warcraft, etc.)


BOOL MyTerminateProcess(int pid)
{
  HANDLE ph;
  BOOL rc = FALSE;

  ph = OpenProcess(PROCESS_TERMINATE,FALSE,pid);
  if ( ph )
     {
       rc = TerminateProcess(ph,0);
       CloseHandle(ph);
     }

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


static void *my_ntterminateprocess = NULL;

__declspec(noinline) static int WINAPI MyNtTerminateProcess( HANDLE hProcess, UINT uExitCode )
{
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop
  __asm nop

  return -1;
}


static BOOL ProtectFunctionFromHack(const char *lib,const char *name,int num_bytes,void *emulator_func,void **pemulator_var)
{
  BOOL exit_code = FALSE;

  HANDLE h = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE,FALSE,GetCurrentProcessId());
  if ( h )
     {
       char *orig_ptr = (char*)GetProcAddress(GetModuleHandle(lib),name);

       if ( orig_ptr )
          {
            DWORD rc;
            int size = num_bytes+6;
            void *buff = sys_alloc(size);
            
            rc = 0;
            if ( ReadProcessMemory(h,orig_ptr,buff,num_bytes,&rc) && rc == num_bytes )
               {
                 char *p = (char*)buff + num_bytes;
                 *p++ = 0xFF;
                 *p++ = 0x25;
                 *(void**)p = pemulator_var;
                 
                 rc = 0;
                 if ( WriteProcessMemory(h,emulator_func,buff,size,&rc) && rc == size )
                    {
                      *pemulator_var = (char*)orig_ptr + num_bytes;
                      exit_code = TRUE;
                    }
               }

            sys_free(buff);
          }

       CloseHandle(h);
     }

  return exit_code;
}


void PrepareTerminateProcessFunctionFromHack(void)
{
  if ( !IsWOW64() )  // simply dont want to mess with this shit...
     {
       OSVERSIONINFO i;
       
       ZeroMemory(&i,sizeof(i));
       i.dwOSVersionInfoSize = sizeof(i);
       if ( GetVersionEx(&i) )
          {
            int num_bytes = 0;
            
            if ( i.dwMajorVersion == 5 && i.dwMinorVersion == 0 )
               {
                 //win2000
                 num_bytes = 9;
               }
            if ( i.dwMajorVersion == 5 && i.dwMinorVersion != 0 )
               {
                 //winXP/2003
                 num_bytes = 10;
               }
            if ( i.dwMajorVersion == 6 )
               {
                 //vista
                 num_bytes = 10;
               }

            if ( num_bytes )
               {
                 ProtectFunctionFromHack("ntdll.dll","NtTerminateProcess",num_bytes,&MyNtTerminateProcess,&my_ntterminateprocess);
               }
          }
     }
}


void TerminateGameGuardApp(HANDLE hProcess)
{
  if ( hProcess )
     {
       MyNtTerminateProcess(hProcess,0);
     }
}


void KillGGIfPresent(BOOL wait)
{
  if ( gg_handle )
     {
       ChangeProcessTerminateRights(0);
       TerminateGameGuardApp(gg_handle);
       CloseHandle(gg_handle);
       gg_handle = NULL;
       ChangeProcessTerminateRights(1);

       if ( wait )
          {
            unsigned start = GetTickCount();

            if ( !GetModuleHandle("npggNT.des") )
               return;
            
            do {
             if ( !GetModuleHandle("npggNT.des") )
                break;

             if ( GetTickCount() - start > 3000 )
                break;

             Sleep(50);

            } while (1);

            Sleep(1000);
          }
     }
}


BOOL IsGGApp(const char *s_exe)
{
  return !lstrcmpi(PathFindFileName(s_exe),"L2.exe");
}


void ProcessGGApp(const char *s_exe,HANDLE hProcess)
{
  if ( !IsGGApp(s_exe) )
     {
       CloseHandle(hProcess);
     }
  else
     {
       if ( gg_handle )
          CloseHandle(gg_handle);
       gg_handle = hProcess;
     }
}



void KillAllTasks(void)
{
  static unsigned last_call_time = 0;

  KillGGIfPresent(FALSE);

  if ( GetTickCount() - last_call_time > 3000 )
     {
       STARTUPINFO si;
       PROCESS_INFORMATION pi;
       char s[MAX_PATH];

       wsprintf(s,"\"%s%s\" /kill_all_tasks",our_currpath,"bodytm.exe");

       ZeroMemory(&si,sizeof(si));
       si.cb = sizeof(si);
       if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
          {
            WaitForSingleObject(pi.hProcess,5000);

            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
          }

       last_call_time = GetTickCount();
     }
}
