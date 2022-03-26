

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


int FindProcess(const char *name)
{
  int rc = -1;

  if ( !IsStrEmpty(name) )
     {
       CSessionProcessList pl;

       do {

         char filename[MAX_PATH] = "";
         int pid = -1;
         
         if ( !pl.GetNext(&pid,filename) )
            break;

         if ( !lstrcmpi(PathFindFileName(filename),PathFindFileName(name)) )
            {
              rc = pid;
              break;
            }

       } while (1);
     }
  
  return rc;
}



void GetProcessNameByPID(DWORD _pid,char *s)
{
  if ( s )
     {
       s[0] = 0;

       CSessionProcessList pl;

       do {

         char filename[MAX_PATH] = "";
         int pid = -1;
         
         if ( !pl.GetNext(&pid,filename) )
            break;

         if ( pid == _pid )
            {
              lstrcpy(s,PathFindFileName(filename));
              break;
            }

       } while (1);
     }
}


void GetWindowProcessFileName(HWND w,char *out)
{
  if ( out )
     {
       out[0] = 0;

       if ( w && IsWindow(w) )
          {
            DWORD pid = (DWORD)-1;
            GetWindowThreadProcessId(w,&pid);
            if ( pid != (DWORD)-1 )
               {
                 char s[MAX_PATH] = "";
                 GetProcessNameByPID(pid,s);

                 if ( !IsStrEmpty(s) )
                    {
                      lstrcpy(out,s);
                    }
               }
          }
     }
}


typedef struct {
int pid;
HWND hwnd;
} FINDINFO;


static BOOL CALLBACK EnumFunc(HWND hwnd,LPARAM lParam)
{
  FINDINFO *info = (FINDINFO*)lParam;

  if ( IsAppWindow(hwnd) )
     {
       DWORD pid = -1;
       GetWindowThreadProcessId(hwnd,&pid);
       
       if ( pid == info->pid )
          {
            info->hwnd = hwnd;
            return FALSE;
          }
     }

  return TRUE;
}



HWND GetProcessAppWindow(int pid)
{
  FINDINFO info;
  
  if ( pid == -1 )
     return NULL;

  info.pid = pid;
  info.hwnd = NULL;
  EnumWindows(EnumFunc,(int)&info);

  return info.hwnd;
}


typedef enum _SYSTEM_INFORMATION_CLASS {
    SystemBasicInformation = 0,
    SystemPerformanceInformation = 2,
    SystemTimeOfDayInformation = 3,
    SystemProcessInformation = 5,
    SystemProcessorPerformanceInformation = 8,
    SystemInterruptInformation = 23,
    SystemExceptionInformation = 33,
    SystemRegistryQuotaInformation = 37,
    SystemLookasideInformation = 45
} SYSTEM_INFORMATION_CLASS;

typedef struct _SYSTEM_PROCESS_INFORMATION {
    ULONG NextEntryOffset;
    BYTE Reserved1[52];
    PVOID Reserved2[3];
    HANDLE UniqueProcessId;
    PVOID ParentProcessId;
    ULONG HandleCount;
    BYTE Reserved4[4];
    PVOID Reserved5[11];
    SIZE_T PeakPagefileUsage;
    SIZE_T PrivatePageCount;
    LARGE_INTEGER Reserved6[6];
} SYSTEM_PROCESS_INFORMATION, *PSYSTEM_PROCESS_INFORMATION;

typedef LONG NTSTATUS;


// works fine even if desired process running as another user and we are have limited rights!
static int FindProcessInternal(int des_pid,BOOL is_parent_pid)
{
  int exit_code = -1;
  
  NTSTATUS (WINAPI *pNtQuerySystemInformation)(
    IN SYSTEM_INFORMATION_CLASS SystemInformationClass,
    OUT PVOID SystemInformation,
    IN ULONG SystemInformationLength,
    OUT PULONG ReturnLength OPTIONAL
  );

  if ( des_pid == -1 || des_pid == 0 )
     return exit_code;

  *(void**)&pNtQuerySystemInformation = (void*)GetProcAddress(GetModuleHandle("ntdll.dll"),"NtQuerySystemInformation");

  if ( pNtQuerySystemInformation  )
     {
       SYSTEM_PROCESS_INFORMATION dummy;
       ZeroMemory(&dummy,sizeof(dummy));

       char *buff = (char*)&dummy;

       ULONG size = 0;
       NTSTATUS rc = pNtQuerySystemInformation(SystemProcessInformation,buff,sizeof(dummy),&size);

       if ( rc == 0xC0000004/*STATUS_INFO_LENGTH_MISMATCH*/ )
          {
            size += sizeof(dummy)*64;
            buff = (char*)sys_alloc(size);
            ZeroMemory(buff,size);

            rc = pNtQuerySystemInformation(SystemProcessInformation,buff,size,NULL);
          }
       
       if ( NT_SUCCESS(rc) )
          {
            unsigned offset = 0;
            
            do {

              const SYSTEM_PROCESS_INFORMATION *p = (SYSTEM_PROCESS_INFORMATION*)(buff+offset);
            
              if ( is_parent_pid )
                 {
                   if ( (int)p->ParentProcessId == des_pid )  //maybe process times check needed!
                      {
                        exit_code = (int)p->UniqueProcessId;
                        //break;
                      }
                 }
              else
                 {
                   if ( (int)p->UniqueProcessId == des_pid )
                      {
                        exit_code = des_pid;
                        break;
                      }
                 }

              if ( p->NextEntryOffset == 0 )
                 break;

              offset += p->NextEntryOffset;

            } while (1);
          }

       if ( buff != (char*)&dummy )
          {
            sys_free(buff);
          }
     }

  return exit_code ? exit_code : -1;
}


// todo: check for child of child here (how?)
int FindLastProcessChild(int pid_parent)
{
  return FindProcessInternal(pid_parent,TRUE);
}


BOOL IsProcessExists(int pid)
{
  return FindProcessInternal(pid,FALSE) == pid;
}


BOOL HasProcessAppWindow(int pid)
{
  char s[MAX_PATH];
  
  if ( pid == -1 )
     return FALSE;

  if ( GetProcessAppWindow(pid) )
     return TRUE;

  s[0] = 0;
  GetProcessNameByPID(pid,s);

  // stupid games
  if ( !lstrcmpi(s,"L2.exe") /*Lineage2*/ || !lstrcmpi(s,"war3.exe") /*Warcraft3*/ )
     return TRUE;

  return FALSE;
}


char* GetExePathByPid(int pid,char *_path)
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
            //PathRemoveUNCPrefix(_path);
            CloseHandle(h);
          }
     }

  return _path;
}
