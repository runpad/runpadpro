
// low-level functions

#include "include.h"

#include "f1_activex.inc"



BOOL IsFileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


void sys_deletefile(const char *s)
{
  DWORD attr = GetFileAttributes(s);

  if ( attr != INVALID_FILE_ATTRIBUTES )
     {
       if ( attr & FILE_ATTRIBUTE_READONLY )
          SetFileAttributes(s,attr & ~FILE_ATTRIBUTE_READONLY);
     }
  
  DeleteFile(s);
}


void sys_removedirectory(const char *s)
{
  DWORD attr = GetFileAttributes(s);

  if ( attr != INVALID_FILE_ATTRIBUTES )
     {
       if ( attr & FILE_ATTRIBUTE_READONLY )
          SetFileAttributes(s,attr & ~FILE_ATTRIBUTE_READONLY);
     }
  
  RemoveDirectory(s);
}


void *sys_fopenr(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void *sys_fopenw(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ|GENERIC_WRITE,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void *sys_fopena(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ|GENERIC_WRITE,FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  if ( h != INVALID_HANDLE_VALUE )
     {
       SetFilePointer(h,0,NULL,FILE_END);
       return h;
     }
  else
     {
       return NULL;
     }
}


void *sys_fcreate(const char *filename,int sharemode)
{
  HANDLE h = CreateFile(filename,GENERIC_READ|GENERIC_WRITE,sharemode,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void sys_fclose(void *h)
{
  CloseHandle(h);
}



int sys_fread(void *h,void *buff,int len)
{
  DWORD rc = 0;
  
  ReadFile(h,buff,len,&rc,NULL);
  return rc;
}



int sys_fwrite(void *h,const void *buff,int len)
{
  DWORD rc = 0;
  
  WriteFile(h,buff,len,&rc,NULL);
  return rc;
}


int sys_fwrite_txt(void *h,const char *buff)
{
  return buff ? sys_fwrite(h, buff, lstrlen(buff)) : 0;
}


int sys_fsize(void *h)
{
  return GetFileSize(h,NULL);
}


void sys_fseek(void *h,int pos)
{
  SetFilePointer(h,pos,NULL,FILE_BEGIN);
}


BOOL WriteFullFile(const char *filename,const void *buff,int size,int sharemode)
{
  BOOL rc = FALSE;
  void *h;

  h = sys_fcreate(filename,sharemode);
  if ( h )
     {
       int total = sys_fwrite(h,buff,size);
       sys_fclose(h);
       rc = (total == size);
     }

  return rc;
}


void* ReadFullFile(const char *filename,int *_size)
{
  void *h,*buff = NULL;
  
  if ( _size )
     *_size = 0;

  h = sys_fopenr(filename);
  if ( h )
     {
       int size = sys_fsize(h);
       //if ( size )   we support zero-len files
          {
            void *t = sys_alloc(size);
            if ( t )
               {
                 if ( sys_fread(h,t,size) == size )
                    {
                      buff = t;
                      if ( _size )
                         *_size = size;
                    }
                 else
                    {
                      sys_free(t);
                    }
               }
          }

       sys_fclose(h);
     }

  return buff;
}


void RegCopyKey(HKEY hkey,const char *in,const char *out)
{
  HKEY h;
  
  SHDeleteKey(hkey,out);

  if ( RegCreateKeyEx(hkey,out,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       SHCopyKey(hkey,in,h,0);
       RegCloseKey(h);
     }
}


BOOL WriteRegStrExp(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_EXPAND_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL WriteRegStrExp64(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE|GetWow64RegFlag64(),NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_EXPAND_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


void ReadRegMultiStr(HKEY root,const char *key,const char *value,char *data,int max,int *_out)
{
  HKEY h;

  data[0] = 0;
  data[1] = 0;

  if ( _out )
     *_out = 2;
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       DWORD len = max-2;
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          {
            int n;
            char *p = data;
            
            data[len] = 0;
            data[len+1] = 0;

            do {
              p += lstrlen(p)+1;
            } while ( *p );
            p++;

            if ( _out )
               *_out = p-data;
          }
       else
          {
            data[0] = 0;
            data[1] = 0;
          }
       RegCloseKey(h);
     }
}


DWORD ReadRegDwordP(HKEY h,const char *value,int def)
{
  DWORD data = def;
  DWORD len = 4;

  RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)&data,&len);

  return data;
}


BOOL WriteRegBinP(HKEY h,const char *value,const char *data,int len)
{
  return RegSetValueEx(h,value,0,REG_BINARY,(const BYTE*)data,len) == ERROR_SUCCESS;
}


void ReadRegBinP(HKEY h,const char *value,char *data,int max,int *out_len)
{
  DWORD len = max;

  *out_len = 0;
  
  if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
     *out_len = len;
}


void RegFlush(void)
{
  RegFlushKey(HKEY_CURRENT_USER);
//  RegFlushKey(HKEY_LOCAL_MACHINE);  todo: check
}


CRegEmptySD::CRegEmptySD(HKEY root,const char *key,BOOL use64)
{
  m_root = root;
  s_key = sys_copystring(key);
  p_old = NULL;
  b_use64 = use64;
  
  HKEY hkey = NULL;
  if ( RegOpenKeyEx(root,key,0,READ_CONTROL|WRITE_DAC|(b_use64?GetWow64RegFlag64():0),&hkey) == ERROR_SUCCESS )
     {
       DWORD size = 0;
       if ( RegGetKeySecurity(hkey,DACL_SECURITY_INFORMATION,NULL,&size) == ERROR_INSUFFICIENT_BUFFER )
          {
            p_old = sys_zalloc(size);
            if ( RegGetKeySecurity(hkey,DACL_SECURITY_INFORMATION,(PSECURITY_DESCRIPTOR)p_old,&size) == ERROR_SUCCESS )
               {
                 SECURITY_DESCRIPTOR *psd = (SECURITY_DESCRIPTOR*)sys_zalloc(SECURITY_DESCRIPTOR_MIN_LENGTH);
                 InitializeSecurityDescriptor(psd,SECURITY_DESCRIPTOR_REVISION);
                 RegSetKeySecurity(hkey,DACL_SECURITY_INFORMATION,psd);
                 sys_free(psd);
               }
            else
               {
                 sys_free(p_old);
                 p_old = NULL;
               }
          }

       RegCloseKey(hkey);
     }
}


CRegEmptySD::~CRegEmptySD()
{
  if ( p_old )
     {
       HKEY hkey = NULL;
       if ( RegOpenKeyEx(m_root,s_key,0,WRITE_DAC|(b_use64?GetWow64RegFlag64():0),&hkey) == ERROR_SUCCESS )
          {
            RegSetKeySecurity(hkey,DACL_SECURITY_INFORMATION,(PSECURITY_DESCRIPTOR)p_old);
            RegCloseKey(hkey);
          }

       sys_free(p_old);
       p_old = NULL;
     }

  SAFESYSFREE(s_key);
}



const char *IntToStr(int n)
{
  static char s[32];
  wsprintf(s,"%d",n);
  return s;
}


void GetSpecialFolder(int folder,char *s)
{
  LPMALLOC pMalloc;
  LPITEMIDLIST pidl;

  s[0] = 0;

  if ( SHGetMalloc(&pMalloc) == NOERROR ) 
     {
       if ( SHGetSpecialFolderLocation(NULL,folder,&pidl) == NOERROR )
          {
            SHGetPathFromIDList(pidl,s);
            pMalloc->Free(pidl);
          }

       pMalloc->Release();
     }
}


void Copy2Clipboard(const char *s)
{
  HGLOBAL mem = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE,lstrlen(s)+1);
  if ( mem )
     {
       void *p = GlobalLock(mem);
       if ( p )
          {
            lstrcpy((LPSTR)p,s);
            GlobalUnlock(mem);
            OpenClipboard(NULL);
            EmptyClipboard();
            SetClipboardData(CF_TEXT,mem);
            CloseClipboard();
          }
       else
          GlobalFree(mem);
     }
}


// str,name,value must be not exceeded MAX_PATH!
void StrReplaceI(char *str,const char *name,const char *value)
{
  if ( IsStrEmpty(str) || IsStrEmpty(name) || !value )
     return;

  if ( lstrlen(str) >= MAX_PATH || lstrlen(name) >= MAX_PATH || lstrlen(value) >= MAX_PATH )
     return;

  if ( !lstrcmpi(name,value) )
     return;
     
  if ( !IsStrEmpty(value) && StrStrI(value,name) )
     return;

  do {

   char *p = StrStrI(str,name);
   if ( p )
      {
        char s[MAX_PATH*2+10] = "";

        lstrcpyn(s,str,p-str+1);
        lstrcat(s,value);
        lstrcat(s,p+lstrlen(name));
        lstrcpyn(str,s,MAX_PATH-1);
      }
   else
      break;

  } while (1);
}


BOOL IsExtensionInList(const char *ext,const char *list)
{
  if ( !ext || !ext[0] )
     return FALSE;

  if ( !list || !list[0] )
     return FALSE;

  char *s_ext = (char*)sys_alloc(lstrlen(ext)+20);
  char *s_list = (char*)sys_alloc(lstrlen(list)+20);
     
  sprintf(s_ext,";%s;",ext);
  sprintf(s_list,";%s;",list); //long maybe

  BOOL rc = (StrStrI(s_list,s_ext) != NULL);

  sys_free(s_list);
  sys_free(s_ext);

  return rc;
}


void Reboot(BOOL force)
{
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  int flags = force ? EWX_FORCE : 0;
  ExitWindowsEx(EWX_REBOOT | flags,0x00040000 | 0x80000000 /*SHTDN_REASON_MAJOR_APPLICATION | SHTDN_REASON_FLAG_PLANNED*/);
}


void Shutdown(BOOL force)
{
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  int flags = force ? EWX_FORCE : 0;
  ExitWindowsEx(EWX_SHUTDOWN | EWX_POWEROFF | flags,0x00040000 | 0x80000000 /*SHTDN_REASON_MAJOR_APPLICATION | SHTDN_REASON_FLAG_PLANNED*/);
}


void LogOff(BOOL force)
{
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  int flags = force ? EWX_FORCE : 0;
  ExitWindowsEx(EWX_LOGOFF | flags,0x00040000 | 0x80000000 /*SHTDN_REASON_MAJOR_APPLICATION | SHTDN_REASON_FLAG_PLANNED*/);
}


void Hibernate(BOOL force)
{
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  if ( !SetSystemPowerState(FALSE,TRUE/*always force!*/) )
     Shutdown(force);
}


void Suspend(BOOL force)
{
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  if ( !SetSystemPowerState(TRUE,TRUE/*always force!*/) )
     Shutdown(force);
}


BOOL IsVistaLonghorn(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion >= 6 )
          return TRUE;
     }

  return FALSE;
}


BOOL IsWindows8OrHigher()
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       double v = (double)i.dwMajorVersion+(double)i.dwMinorVersion*0.1;
       return (v >= 6.2);
     }

  return FALSE;
}


BOOL IsWin2000(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion == 5 && i.dwMinorVersion == 0 )
          return TRUE;
     }

  return FALSE;
}


unsigned GetNormalTimeSec(FILETIME *time)
{
  SYSTEMTIME s;
  unsigned year,month,day,hour,min,sec;
  
  ZeroMemory(&s,sizeof(s));
  FileTimeToSystemTime(time,&s);
  
  year = s.wYear - 1980;
  month = s.wMonth - 1;
  day = s.wDay - 1;
  hour = s.wHour;
  min = s.wMinute;
  sec = s.wSecond;

  return ((((year * 12 + month) * 31 + day) * 24 + hour) * 60 + min) * 60 + sec;
}


__int64 GetLocalTime64(void)
{
  SYSTEMTIME st;
  __int64 rc;

  GetLocalTime(&st);
  SystemTimeToFileTime(&st,(FILETIME*)&rc);

  return rc;
}


__int64 GetSystemTime64(void)
{
  SYSTEMTIME st;
  __int64 rc;

  GetSystemTime(&st);
  SystemTimeToFileTime(&st,(FILETIME*)&rc);

  return rc;
}


unsigned GetLocalTimeMin(void)
{
  const unsigned one_minute = 600000000;
  return GetLocalTime64() / one_minute;
}


void EndTaskRequest(HWND hwnd)
{
  typedef BOOL (WINAPI *TEndTask)(IN HWND hWnd,IN BOOL fShutDown,IN BOOL fForce);

  TEndTask pEndTask = (TEndTask)GetProcAddress(GetModuleHandle("user32.dll"),"EndTask");

  if ( pEndTask )
     pEndTask(hwnd,FALSE,FALSE);
}


BOOL IsRunningInSafeMode(void)
{
  return GetSystemMetrics(SM_CLEANBOOT) != 0;
}


void ShellReadyEvent(void)
{
  HANDLE event = CreateEvent(NULL,FALSE,FALSE,"ShellReadyEvent");
  if ( event )
     SetEvent(event);
}


unsigned GetProcessCreationTimeInSec(int pid)
{
  unsigned rc = 0;

  if ( pid != -1 )
     {
       HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION,FALSE,pid);
       if ( h )
          {
            FILETIME t1,t2,t3,t4;
            
            if ( GetProcessTimes(h,&t1,&t2,&t3,&t4) )
               {
                 rc = GetNormalTimeSec(&t1);
               }

            CloseHandle(h);
          }
     }

  return rc;
}


BOOL IsInShutdownState()
{
  return GetSystemMetrics(SM_SHUTTINGDOWN) != 0;
}


BOOL IsTerminalSession()
{
  return GetSystemMetrics(SM_REMOTESESSION) != 0;
}


static TOKEN_USER* GetProcessUserToken(HANDLE hprocess)
{
  TOKEN_USER *pUser = NULL;

  HANDLE hUser = NULL;
  if ( OpenProcessToken(hprocess,TOKEN_QUERY,&hUser) )
     {
       DWORD dwSize = 64;
       pUser = (TOKEN_USER*)sys_alloc(dwSize);
       
       DWORD dwNewSize = 0;
       BOOL rc = GetTokenInformation(hUser,TokenUser,pUser,dwSize,&dwNewSize);
       if ( !rc && GetLastError() == ERROR_INSUFFICIENT_BUFFER )
          {
            sys_free(pUser);
            pUser = (TOKEN_USER*)sys_alloc(dwNewSize);
            rc = GetTokenInformation(hUser,TokenUser,pUser,dwNewSize,&dwNewSize);
          }

       if ( !rc )
          {
            sys_free(pUser);
            pUser = NULL;
          }

       CloseHandle(hUser);
     }

  return pUser;
}


static char* GetProcessOwnerStringSid(HANDLE hprocess,char *out)
{
  out[0] = 0;
  
  TOKEN_USER *pUser = GetProcessUserToken(hprocess);
  if ( pUser )
     {
       char *s = NULL;
       
       if ( ConvertSidToStringSid(pUser->User.Sid,&s) )
          {
            lstrcpyn(out,s,MAX_PATH);
            LocalFree((HLOCAL)s);
          }

       sys_free(pUser);
     }

  return out;
}


char* GetProcessOwnerStringSid(int pid,char *out)
{
  out[0] = 0;

  HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION,FALSE,pid);
  if ( h )
     {
       GetProcessOwnerStringSid(h,out);
       CloseHandle(h);
     }

  return out;
}


char* GetCurrentUserSid(char *_sid)
{
  return GetProcessOwnerStringSid(GetCurrentProcess(),_sid);
}


BOOL IsOurServiceActive()
{
  HANDLE h = OpenMutex(SYNCHRONIZE,FALSE,"Global\\RunpadProShellServiceMutex");
  if ( h )
     CloseHandle(h);

  return h != NULL;
}


char* GetFileNameInTempDir(const char *local,char *out)
{
  out[0] = 0;
  GetTempPath(MAX_PATH,out);
  PathAddBackslash(out);
  CreateDirectory(out,NULL);
  lstrcat(out,local);
  return out;
}


char* GetTrueSystem32Dir(char *out)
{
  char sys_dir[MAX_PATH] = "";
  
  UINT (WINAPI *pGetSystemWow64Directory)(OUT LPSTR lpBuffer,IN UINT uSize);
  *(void**)&pGetSystemWow64Directory = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"GetSystemWow64DirectoryA");
  if ( pGetSystemWow64Directory )
     {
       pGetSystemWow64Directory(sys_dir,sizeof(sys_dir));
     }

  if ( !sys_dir[0] )
     {
       GetSystemDirectory(sys_dir,sizeof(sys_dir));
     }
  
  lstrcpy(out,sys_dir);
  return out;
}


char* GetTrueSystem64Dir(char *out)
{
  out[0] = 0;

  if ( IsWOW64() )
     {
       GetSystemWindowsDirectory(out,MAX_PATH);
       
       if ( IsStrEmpty(out) )
          GetWindowsDirectory(out,MAX_PATH);

       PathAppend(out,"System32");
     }

  return out;
}


char* GetFileNameInWindowsDir(const char *local,char *out)
{
  char sys_dir[MAX_PATH] = "";

  GetSystemWindowsDirectory(sys_dir,MAX_PATH);
  if ( IsStrEmpty(out) )
     GetWindowsDirectory(sys_dir,MAX_PATH);

  lstrcpy(out,sys_dir);
  PathAppend(out,local);
  return out;
}


char* GetFileNameInTrueSystem32Dir(const char *local,char *out)
{
  char sys_dir[MAX_PATH] = "";
  GetTrueSystem32Dir(sys_dir);
  lstrcpy(out,sys_dir);
  PathAppend(out,local);
  return out;
}


char* GetFileNameInTrueSystem64Dir(const char *local,char *out)
{
  char sys_dir[MAX_PATH] = "";
  GetTrueSystem64Dir(sys_dir);
  lstrcpy(out,sys_dir);
  if ( !IsStrEmpty(out) )
     PathAppend(out,local);
  return out;
}


char* GetFileNameInLocalAppDir(const char *local,char *out)
{
  char s[MAX_PATH] = "";
  GetModuleFileName(GetModuleHandle(NULL),s,sizeof(s));  // we do not use currdir[], because can be called from another app
  PathRemoveFileSpec(s);
  PathAppend(s,local);
  lstrcpy(out,s);
  return out;
}


BOOL IsCyrillic()
{
  return GetACP() == 1251;
}


BOOL IsPidWow64(int pid)
{
  BOOL rc = FALSE;

  BOOL (WINAPI *pIsWow64Process)(HANDLE hProcess,PBOOL Wow64Process);
  *(void**)&pIsWow64Process = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"IsWow64Process");

  if ( pIsWow64Process )
     {
       HANDLE h = OpenProcess(PROCESS_QUERY_INFORMATION,FALSE,pid);
       if ( h )
          {
            BOOL is_wow = FALSE;

            if ( pIsWow64Process(h,&is_wow) )
               {
                 rc = is_wow;
               }

            CloseHandle(h);
          }
     }

  return rc;
}


CDisableWOW64FSRedirection::CDisableWOW64FSRedirection()
{
  old_value = NULL;
  
  BOOL (WINAPI *pWow64DisableWow64FsRedirection)(PVOID *OldValue);
  *(void**)&pWow64DisableWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64DisableWow64FsRedirection");

  if ( pWow64DisableWow64FsRedirection )
     {
       pWow64DisableWow64FsRedirection(&old_value);
     }
}


CDisableWOW64FSRedirection::~CDisableWOW64FSRedirection()
{
  BOOL (WINAPI *pWow64RevertWow64FsRedirection)(PVOID OlValue);
  *(void**)&pWow64RevertWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64RevertWow64FsRedirection");

  if ( pWow64RevertWow64FsRedirection )
     {
       pWow64RevertWow64FsRedirection(old_value);
     }
}

