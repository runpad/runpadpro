
#include "include.h"



#define MAXWINITEMS 200  //must be like in rshell!!!!

#define RP_HIDEKEY   "Software\\RunpadProShell\\hide_tm_programs"
#define RP_KEY       "Software\\RunpadProShell"

#define MAXPIDS     200
#define UPDATETIME  500


#define SCAN_FILE	1
#define SCAN_DIR	2

typedef BOOL (*SCANFUNC)(const char *,const WIN32_FIND_DATA *,void *);


BOOL is_wtsenumproc_bug_present = FALSE;

int pids[MAXPIDS];
char hidden[100][MAX_PATH];
int numhiddens = 0;
BOOL kill_hidden_tasks = FALSE;



static BOOL AddToHiddenList(const char *s)
{
  if ( numhiddens == sizeof(hidden)/sizeof(hidden[0]) )
     return FALSE;

  if ( s && s[0] )
     lstrcpy(hidden[numhiddens++],s);
  return TRUE;
}


void SwitchToWindow(HWND w)
{
  int pid = -1;
  BOOL (WINAPI *pAllowSetForegroundWindow)(DWORD);

  if ( IsIconic(w) )
     ShowWindowAsync(w,SW_RESTORE);
  
  *(void**)&pAllowSetForegroundWindow = (void*)GetProcAddress(GetModuleHandle("user32.dll"),"AllowSetForegroundWindow");
  GetWindowThreadProcessId(w,(DWORD*)&pid);
  if ( pAllowSetForegroundWindow )
     pAllowSetForegroundWindow(pid);
  SetForegroundWindow(w);
}


BOOL IsWOW64()
{
  BOOL rc = FALSE;

  BOOL (WINAPI *pIsWow64Process)(HANDLE hProcess,PBOOL Wow64Process);
  *(void**)&pIsWow64Process = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"IsWow64Process");

  if ( pIsWow64Process )
     {
       BOOL is_wow = FALSE;

       if ( pIsWow64Process(GetCurrentProcess(),&is_wow) )
          {
            rc = is_wow;
          }
     }

  return rc;
}

int GetWow64RegFlag64()
{
  return IsWOW64() ? KEY_WOW64_64KEY : 0;
}



DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}



static void CollectFromReg(HKEY root,const char *path)
{
  HKEY h;
  int n,size1,size2;
  char value[MAX_PATH];
  char data[MAX_PATH];

  if ( RegOpenKeyEx(root,path,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       n = 0;
       do {
        size1 = sizeof(value);
        size2 = sizeof(data);

        ZeroMemory(value,sizeof(value));
        ZeroMemory(data,sizeof(data));
        
        if ( RegEnumValue(h,n,value,(LPDWORD)&size1,NULL,NULL,(LPBYTE)data,(LPDWORD)&size2) != ERROR_SUCCESS )
           break;

        if ( !AddToHiddenList(PathFindFileName(data)) )
           break;
        
        n++;
       } while (1);

       RegCloseKey(h);
     }
}


static void CollectFromReg64(HKEY root,const char *path)
{
  HKEY h;
  int n,size1,size2;
  char value[MAX_PATH];
  char data[MAX_PATH];

  if ( RegOpenKeyEx(root,path,0,KEY_READ|GetWow64RegFlag64(),&h) == ERROR_SUCCESS )
     {
       n = 0;
       do {
        size1 = sizeof(value);
        size2 = sizeof(data);

        ZeroMemory(value,sizeof(value));
        ZeroMemory(data,sizeof(data));
        
        if ( RegEnumValue(h,n,value,(LPDWORD)&size1,NULL,NULL,(LPBYTE)data,(LPDWORD)&size2) != ERROR_SUCCESS )
           break;

        if ( !AddToHiddenList(PathFindFileName(data)) )
           break;
        
        n++;
       } while (1);

       RegCloseKey(h);
     }
}


static void GetSpecialFolder(int folder,char *s)
{
  if ( s )
     {
       s[0] = 0;

       LPMALLOC pMalloc = NULL;
       if ( SHGetMalloc(&pMalloc) == NOERROR ) 
          {
            LPITEMIDLIST pidl = NULL;
            if ( SHGetSpecialFolderLocation(NULL,folder,&pidl) == NOERROR )
               {
                 SHGetPathFromIDList(pidl,s);
                 pMalloc->Free(pidl);
               }

            pMalloc->Release();
          }
     }
}


static void ScanDir(const char *path,int type,SCANFUNC func,void *user)
{
  WIN32_FIND_DATA f;
  char s[MAX_PATH]; 
  HANDLE h;
  int rc,dir;

  lstrcpy(s,path);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  h = FindFirstFile(s,&f);
  rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( !(f.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) && !(f.dwFileAttributes & FILE_ATTRIBUTE_SYSTEM) )
       if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
          {
            dir = (f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);

            if ( ((type & SCAN_DIR) && dir) || ((type & SCAN_FILE) && !dir) )
               {
                 lstrcpy(s,path);
                 PathAddBackslash(s);
                 lstrcat(s,f.cFileName);
                 if ( !func(s,&f,user) )
                    break;
               }
          }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


static IShellLink *psl = NULL; 
static IPersistFile *ppf = NULL; 


static void LnkPrepare(void)
{
  psl = NULL;
  ppf = NULL;

  CoCreateInstance(CLSID_ShellLink,NULL,CLSCTX_INPROC_SERVER,IID_IShellLink,(void **)&psl);
  if ( psl )
     psl->QueryInterface(IID_IPersistFile,(void **)&ppf); 
}



static void LnkFinish(void)
{
  if ( ppf )
     ppf->Release(); 
  if ( psl )
     psl->Release(); 

  psl = NULL;
  ppf = NULL;
}



static void GetLnkInfo(const char *filename,char *path)
{
  WCHAR wsz[MAX_PATH]; 
  WIN32_FIND_DATA wfd; 

  lstrcpy(path,filename);

  if ( psl && ppf )
     {
       MultiByteToWideChar(CP_ACP,0,filename,-1,wsz,MAX_PATH);
       if ( ppf->Load(wsz,STGM_READ) == S_OK ) 
          psl->GetPath(path,MAX_PATH,&wfd,0);
     }

  if ( !path[0] )
     lstrcpy(path,filename);
}



static BOOL RunProc(const char *s,const WIN32_FIND_DATA *f,void *user)
{
  char path[MAX_PATH] = "";
  
  GetLnkInfo(s,path);

  return AddToHiddenList(PathFindFileName(path));
}


static void CollectFromConfig(void)
{
  for ( int n = 0; n < MAXWINITEMS; n++ )
      {
        char s[32];
        wsprintf(s,"state_%d",n+1);
        int state = ReadRegDword(HKEY_CURRENT_USER,RP_HIDEKEY,s,0);
        if ( state )
           {
             char name[MAX_PATH];
             wsprintf(s,"parm1_%d",n+1);
             ReadRegStr(HKEY_CURRENT_USER,RP_HIDEKEY,s,name,"");
             if ( name[0] )
                {
                  AddToHiddenList(name);
                }
           }
      }
}


static void LoadHiddens(void)
{
  char s[MAX_PATH];

  numhiddens = 0;

  if ( IsWOW64() )
     {
       CollectFromReg64(HKEY_LOCAL_MACHINE,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
       CollectFromReg64(HKEY_LOCAL_MACHINE,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
     }
  CollectFromReg(HKEY_LOCAL_MACHINE,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
  CollectFromReg(HKEY_LOCAL_MACHINE,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
  CollectFromReg(HKEY_CURRENT_USER,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
  CollectFromReg(HKEY_CURRENT_USER,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");

  LnkPrepare();
  
  if ( !(GetVersion() & 0x80000000) )
     {
       GetSpecialFolder(CSIDL_COMMON_STARTUP,s);
       if ( s[0] )
          ScanDir(s,SCAN_FILE,RunProc,NULL);
     }

  GetSpecialFolder(CSIDL_STARTUP,s);
  if ( s[0] )
     ScanDir(s,SCAN_FILE,RunProc,NULL);

  LnkFinish();

  CollectFromConfig();

  // special win98 fixes:
  AddToHiddenList("kernel32.dll");
  AddToHiddenList("msgsrv32.exe");
  AddToHiddenList("mprexe.exe");
  AddToHiddenList("mdm.exe");
  AddToHiddenList("mmtask.tsk");
  AddToHiddenList("spool32.exe");
  AddToHiddenList("systray.exe");

  // NT fixes:
  AddToHiddenList("csrss.exe");
  AddToHiddenList("winlogon.exe");
  AddToHiddenList("smss.exe");
  AddToHiddenList("services.exe");
  AddToHiddenList("lsass.exe");
  AddToHiddenList("svchost.exe");
  AddToHiddenList("spoolsv.exe");

  // Vista fixes:
  AddToHiddenList("rundll32.exe");
  AddToHiddenList("taskeng.exe");

  // Win7 fixes:
  AddToHiddenList("dwm.exe");
  AddToHiddenList("taskhost.exe");

  //Lineage GameGuard fix
  //AddToHiddenList("L2.exe");

  //our exes
  AddToHiddenList("rsblock.exe");
  AddToHiddenList("bodytm.exe");
  AddToHiddenList("internat.exe");
  AddToHiddenList("rsrules.exe");
  AddToHiddenList("rfmserver.exe");
  AddToHiddenList("rsrdserver.exe");
  AddToHiddenList("rshell_svc.exe");
  AddToHiddenList("rshell.exe");
  AddToHiddenList("rshell_asv2.exe");
  AddToHiddenList("rshell_ams.exe");
  AddToHiddenList("rsoffindic.exe");
}


#define MAGIC	0x49474541	// magic DWORD


int IsAppWindow(HWND w)
{
  int style;
  HWND owner,parent;

  if ( !w || !IsWindow(w) )
     return 0;

  style = GetWindowLong(w,GWL_STYLE);
  if ( (style & WS_CHILD) || !(style & WS_VISIBLE) )
     return 0;

  if ( GetWindowLong(w,GWL_EXSTYLE) & WS_EX_APPWINDOW )
     return 1;

  if ( GetWindowLong(w,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
     return 0;
  
  owner = GetWindow(w,GW_OWNER);
  parent = GetParent(w);

  if ( GetWindowLong(w,GWL_USERDATA) == MAGIC )
     return 0;

  if ( GetWindowLong(owner,GWL_USERDATA) == MAGIC )
     return 0;

  if ( GetWindowLong(parent,GWL_USERDATA) == MAGIC )
     return 0;

  if ( !owner && !parent )
     return 1;
  
  return 0;
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



void UpdateProcesses(HWND hwnd)
{
  int count = SendMessage(hwnd,LB_GETCOUNT,0,0);
  int sel_pid = SendMessage(hwnd,LB_GETCURSEL,0,0);
  if ( sel_pid != -1 )
     sel_pid = pids[sel_pid];

  for ( int n = count-1; n >= 0; n-- )
      {
        HANDLE ph = OpenProcess(SYNCHRONIZE,FALSE,pids[n]);
        if ( ph )
           {
             int rc = WaitForSingleObject(ph,0);
             CloseHandle(ph);
             if ( rc == WAIT_TIMEOUT )
                {
                  if ( GetProcessAppWindow(pids[n]) )  //allow only processes with windows
                     continue;
                }
           }

        SendMessage(hwnd,LB_DELETESTRING,n,0);
        for ( int m = n; m < count-1; m++ )
            pids[m] = pids[m+1];
        count--;
      }

  {
    CSessionProcessList pl;

    int id = -1;
    char exefile[MAX_PATH] = "";
    
    while ( pl.GetNext(&id,exefile) )
    {
      const char *file = PathFindFileName(exefile);

      if ( count == MAXPIDS )
         break;

      if ( id == GetCurrentProcessId() )
         goto next;

      for ( int n = 0; n < numhiddens; n++ )
          if ( !StrCmpNI(file,hidden[n],lstrlen(file)) )
             goto next;
         
      HANDLE ph = OpenProcess(SYNCHRONIZE,FALSE,id);
      if ( ph )
         {
           int rc = WaitForSingleObject(ph,0);
           CloseHandle(ph);

           if ( rc == WAIT_TIMEOUT )
              {
                int n;
                
                for ( n = 0; n < count; n++ )
                    if ( pids[n] == id )
                       break;

                if ( n == count )
                   {
                     char s[MAX_PATH*2];
                     char t[MAX_PATH];
                     HWND w = GetProcessAppWindow(id);

                     t[0] = 0;
                     if ( w )
                        GetWindowText(w,t,sizeof(t));
                     
                     if ( t[0] )
                        wsprintf(s,"%s (%s)",file,t);
                     else
                        lstrcpy(s,file);
                     
                     if ( w ) //allow only processes with windows
                        {
                          SendMessage(hwnd,LB_ADDSTRING,0,(int)s);
                          pids[count++] = id;
                        }
                   }
              }
         }

     next:;
    }
  }

  {
    int n;
    
    for ( n = 0; n < count; n++ )
        if ( pids[n] == sel_pid )
           break;

    if ( n == count )
       n = -1;
           
    if ( SendMessage(hwnd,LB_GETCURSEL,0,0) != n )
       SendMessage(hwnd,LB_SETCURSEL,n,0);
  }
}



BOOL CALLBACK MainDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       SetClassLong(hwnd,GCL_HICON,(int)LoadIcon(GetModuleHandle(NULL),MAKEINTRESOURCE(IDI_ICON)));
       SetDlgItemText(hwnd,IDC_END,LS(1002));
       SetDlgItemText(hwnd,IDC_SWITCH,LS(1003));
       SetWindowText(hwnd,LS(1001));
       UpdateProcesses(GetDlgItem(hwnd,IDC_LIST));
       SetFocus(GetDlgItem(hwnd,IDC_END));
       SetTimer(hwnd,1,UPDATETIME,NULL);
       SetForegroundWindow(hwnd);
     }
  
  if ( message == WM_TIMER && wParam == 1 )
     UpdateProcesses(GetDlgItem(hwnd,IDC_LIST));
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     EndDialog(hwnd,0);

  if ( message == WM_COMMAND && LOWORD(wParam) == IDC_END )
     {
       int n = SendMessage(GetDlgItem(hwnd,IDC_LIST),LB_GETCURSEL,0,0);
       if ( n != -1 )
          {
            int sel_pid = pids[n];
            
            if ( !MyTerminateProcess(sel_pid) )
               {
                 MessageBox(hwnd,LS(1000),LS(LS_ERROR),MB_OK | MB_ICONERROR);
               }
            else
               {
                 HANDLE ph = OpenProcess(SYNCHRONIZE,FALSE,sel_pid);
                 if ( ph )
                    {
                      EnableWindow(GetDlgItem(hwnd,IDC_END),FALSE);
                      EnableWindow(GetDlgItem(hwnd,IDC_SWITCH),FALSE);
                      EnableWindow(GetDlgItem(hwnd,IDC_LIST),FALSE);
                      UpdateWindow(hwnd);

                      WaitForSingleObject(ph,3000);

                      EnableWindow(GetDlgItem(hwnd,IDC_END),TRUE);
                      EnableWindow(GetDlgItem(hwnd,IDC_SWITCH),TRUE);
                      EnableWindow(GetDlgItem(hwnd,IDC_LIST),TRUE);

                      CloseHandle(ph);

                      UpdateProcesses(GetDlgItem(hwnd,IDC_LIST));
                    }
               }
          }
     }
     
  if ( message == WM_COMMAND && LOWORD(wParam) == IDC_SWITCH )
     {
       int n = SendMessage(GetDlgItem(hwnd,IDC_LIST),LB_GETCURSEL,0,0);
       if ( n != -1 )
          {
            int sel_pid = pids[n];
            HWND w = GetProcessAppWindow(sel_pid);

            if ( w )
               {
                 SwitchToWindow(w);
               }
          }
     }
     
  return FALSE;
}



void KillAllTasks(void)
{
  //ChangeProcessTerminateRights(0);
  
  {
    CSessionProcessList pl;

    int id = -1;
    char exefile[MAX_PATH] = "";
    
    while ( pl.GetNext(&id,exefile) )
    {
      const char *file = PathFindFileName(exefile);

      if ( id == GetCurrentProcessId() )
         goto next;

      for ( int n = 0; n < numhiddens; n++ )
          if ( !StrCmpNI(file,hidden[n],lstrlen(file)) )
             goto next;
         
      if ( GetProcessAppWindow(id) || !lstrcmpi(file,"L2.exe") /*Lineage2*/ || !lstrcmpi(file,"war3.exe") /*Warcraft3*/ )
         MyTerminateProcess(id);
      else
      if ( kill_hidden_tasks )
         StdTerminateProcess(id);  //some problems related with MyTerminateProcess() here

     next:;
    }
  }

  //ChangeProcessTerminateRights(1);
}




int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  is_wtsenumproc_bug_present = IsWTSEnumProcBugPresent();
  
  BOOL kill_all = (StrStr(GetCommandLine()," /kill_all_tasks") != NULL);

  if ( kill_all )
     {
       CreateMutex(NULL,FALSE,"_RSTMMutex");
       if ( GetLastError() == ERROR_ALREADY_EXISTS )
          return 0;
     }
  
  kill_hidden_tasks = (ReadRegDword(HKEY_CURRENT_USER,RP_KEY,"kill_hidden_tasks",0) != 0);

  InitCommonControls();

  if ( !kill_all )
     {
       if ( !CheckRPVersion(RUNPAD_VERSION_DIG) )
          return 0;
     }

  HWND w;
  if ( !kill_all && (w = FindWindow("#32770",LS(1001))) )
     {
       SwitchToWindow(w);
       return 0;
     }

  CoInitialize(0);
  LoadHiddens();

  if ( !kill_all )
     DialogBox(GetModuleHandle(NULL),MAKEINTRESOURCE(IDD_MAIN),NULL,MainDialog);
  else
     KillAllTasks();

  CoUninitialize();
  return 1;
}

