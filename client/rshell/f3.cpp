
// high-level functions

#include "include.h"


#include "f3_autorun.inc"
#include "f3_blocker.inc"
#include "f3_env.inc"
#include "f3_events.inc"
#include "f3_flash.inc"
#include "f3_killall.inc"
#include "f3_printmon.inc"
#include "f3_run.inc"
#include "f3_scandisallowed.inc"
#include "f3_scandisk.inc"
#include "f3_spy.inc"
#include "f3_userfolder.inc"
#include "f3_vcd.inc"
#include "f3_vmode.inc"
#include "f3_webcam.inc"
#include "f3_cad.inc"
#include "f3_wia.inc"
#include "f3_hwident.inc"
#include "f3_asv2.inc"
#include "f3_hooks64.inc"



void GetDirFromPath(const char *path,char *dir)
{
  if ( dir != path )
     lstrcpy(dir,path);

  PathRemoveFileSpec(dir);
  PathAddBackslash(dir);
}


char* GetLocalPath(const char *local,char *out)
{
  lstrcpy(out,our_currpath);
  lstrcat(out,local);
  return out;
}


CLocalPath::CLocalPath(const char *local)
{
  lstrcpy(s_path,our_currpath);
  PathAddBackslash(s_path);
  if ( local )
     PathAppend(s_path,local);
}


void ClientRestore(void)
{
  if ( !client_restore[0] )
     return;

  if ( GetTickCount()-msgloop_starttime < 45000 )
     return;

  if ( !IsInShutdownState() ) //fix for situation when restoring client during logoff/reboot/shutdown
     {
       char s[MAX_PATH] = "";
       ExpandPath(client_restore,s);
       
       if ( s[0] && !lstrcmpi(PathFindExtension(s),".exe") )
          {
            if ( FindProcess(PathFindFileName(s)) == -1 )
               {
                 CDisableWOW64FSRedirection g;
                 
                 char cwd[MAX_PATH];
                 lstrcpy(cwd,s);
                 PathRemoveFileSpec(cwd);

                 STARTUPINFO si;
                 PROCESS_INFORMATION pi;
                 ZeroMemory(&si,sizeof(si));
                 si.cb = sizeof(si);
                 if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,cwd,&si,&pi) )
                    {
                      CloseHandle(pi.hThread);
                      CloseHandle(pi.hProcess);
                    }
               }
          }
     }
}


void CloseDisallowProcesses(void)
{
  CSessionProcessList pl;

  do {

    char filename[MAX_PATH] = "";
    int pid = -1;
    
    if ( !pl.GetNext(&pid,filename) )
       break;

    const char *file = PathFindFileName(filename);

    if ( pid != GetCurrentProcessId() )
       {
         TCFGLIST1& list = disallow_run;
         
         for ( int n = 0; n < list.size(); n++ )
             {
               if ( list[n].IsActive() )
                  {
                    if ( PathMatchSpec(file,list[n].GetParm()) )
                       {
                         HANDLE ph = OpenProcess(PROCESS_TERMINATE,FALSE,pid);
                         if ( ph )
                            {
                              TerminateProcess(ph,0);
                              CloseHandle(ph);
                            }

                         break;
                       }
                  }
             }
       }

  } while (1);
}


void CleanTempDir(void)
{
  char s[MAX_PATH];
  char some[MAX_PATH];
  
  if ( !clean_temp_dir )
     return;

  s[0] = 0;
  GetTempPath(sizeof(s),s);

  if ( !s[0] )
     return;

  PathAddBackslash(s);

  if ( !lstrcmpi(s,our_currpath) )
     return;

  some[0] = 0;
  GetWindowsDirectory(some,sizeof(some));
  PathAddBackslash(some);
  if ( !lstrcmpi(s,some) )
     return;

  CleanDir(s);
}



void CleanIEDir(void)
{
  if ( clean_ie_dir )
     {
       char s[MAX_PATH];

       s[0] = 0;
       GetSpecialFolder(CSIDL_INTERNET_CACHE,s);

       if ( s[0] )
          CleanDir(s);
     }

  if ( clean_cookies )
     {
       char s[MAX_PATH];

       s[0] = 0;
       GetSpecialFolder(CSIDL_COOKIES,s);

       if ( s[0] )
          CleanDir(s);
     }
}


void CleanRecycleBin(void)
{
  if ( clear_recycle_bin )
     {
       SHEmptyRecycleBin(NULL,NULL,SHERB_NOCONFIRMATION | SHERB_NOPROGRESSUI | SHERB_NOSOUND);
     }
}


void ClearPrintSpooler()
{
  if ( clear_print_spooler )
     {
       SpoolClear();
     }
}


void InstallOurService()
{
  char s[MAX_PATH];
  wsprintf(s,"\"%srshell_svc.exe\" -install -silent",our_currpath);
  RunHiddenProcessAndWait(s,NULL);
}


void UninstallOurService()
{
  char s[MAX_PATH];
  wsprintf(s,"\"%srshell_svc.exe\" -uninstall -silent",our_currpath);
  RunHiddenProcessAndWait(s,NULL);
}


BOOL IsRunningInSafeModeWithCmdFromAnotherUser(void)
{
  return IsRunningInSafeMode() && !IsExplorerLoaded() && !IsOurShellTurnedOn();
}


BOOL IsRemoteDesktopRunning(void)
{
  BOOL rc = FALSE;

  HANDLE m = OpenMutex(READ_CONTROL,FALSE,RSRD_MUTEX);
  if ( m )
     {
       rc = TRUE;
       CloseHandle(m);
     }

  if ( !rc )
     {
       rc = GetSystemMetrics(SM_REMOTECONTROL) != 0;
     }

  return rc;
}


BOOL IsGCInstalled(void)
{
  char s[MAX_PATH];

  if ( FindGCWindow() )
     return TRUE;

  ReadRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","gccl",s,"");

  if ( lstrcmpi(PathFindFileName(s),"gccl.exe") )
     {
       ReadRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","gccl",s,"");
       if ( lstrcmpi(PathFindFileName(s),"gccl.exe") )
          return FALSE;
     }

  if ( PathFindFileName(s) == s )
     {
       s[0] = 0;
       GetWindowsDirectory(s,sizeof(s));
       PathAppend(s,"gccl.exe");
     }

  return IsFileExist(s);
}


BOOL IsBodyExplorerLoaded(void)
{
  return FindWindow("TBodyExplForm",NULL) != NULL;
}


void ExecTool(const char *s,BOOL force32)
{
  CCmdLineExpander cmd(s);

  if ( !IsStrEmpty(cmd) )
     {
       char *t = sys_copystring(cmd.GetPath());
       if ( t[0] == '\"' )
          {
            PathRemoveArgs(t);
            PathUnquoteSpaces(t);
          }
       const char *ext = PathFindExtension(t);
       BOOL is_script = (!lstrcmpi(ext,".bat") || !lstrcmpi(ext,".cmd"));
       BOOL is_reg = !lstrcmpi(ext,".reg");
       sys_free(t);
       
       if ( is_script )
          {
            RunProcessWithShowWindow(cmd,SW_SHOWMINNOACTIVE);
          }
       else
       if ( is_reg )
          {
            if ( IsFileExist(cmd) )
               {
                 ImportRegistryFileGuarantee(cmd);  //todo: restore critical reg section after

                 if ( IsWOW64() )
                    {
                      CDisableWOW64FSRedirection g;
                      ImportRegistryFileGuarantee(cmd);  // run x64 reg.exe
                    }
               }
          }
       else
          {
            if ( force32 )
               {
                 RunProcess(cmd);
               }
            else
               {
                 CDisableWOW64FSRedirection g;
                 RunProcess(cmd);
               }
          }
     }
}


void SetIEStartupSettings(void)
{
  WriteRegStr(HKCU,"Software\\Microsoft\\Internet Explorer\\Main","Start Page",ie_home_page);
  WriteRegStr(HKCU,"Software\\Microsoft\\Ftp","Use Web Based FTP","yes"); // ftp folders view fix

  if ( ie_use_sett )
     {
       char s_proxy[MAX_PATH];

       lstrcpy(s_proxy,ie_sett_proxy);
       if ( s_proxy[0] && ie_sett_port[0] )
          {
            lstrcat(s_proxy,":");
            lstrcat(s_proxy,ie_sett_port);
          }

       WriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings","ProxyEnable",s_proxy[0]?1:0);
       if ( s_proxy[0] )
          WriteRegStr(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings","ProxyServer",s_proxy);
       else
          DeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings","ProxyServer");

       if ( ie_sett_autoconfig[0] )
          WriteRegStr(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings","AutoConfigURL",ie_sett_autoconfig);
       else
          DeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings","AutoConfigURL");
     }
}


BOOL CheckUrlSite(const char *s)
{
  char host[MAX_PATH] = "";
  DWORD len = sizeof(host);
  TCFGLIST1& list = disallow_sites ? allowed_sites : disallowed_sites;
  int n;
  BOOL find;
  
  UrlGetPart(s,host,&len,URL_PART_HOSTNAME,0/*URL_PARTFLAG_KEEPSCHEME*/);
  if ( !host[0] )
     return FALSE;

  find = FALSE;
  for ( n = 0; n < list.size(); n++ )
      {
        if ( list[n].IsActive() )
           {
             if ( PathMatchSpec(host,list[n].GetParm()) )
                {
                  find = TRUE;
                  break;
                }
           }
      }

  return (disallow_sites ? find : !find);
}


BOOL IsThisURLMustBeRedirected(const char *_url)
{
  BOOL rc = FALSE;

  if ( !IsStrEmpty(_url) )
     {
       char *url = sys_copystring(_url);

       for ( int n = 0; n < lstrlen(url); n++ )
        if ( url[n] == '#' )
           {
             url[n] = 0;
             break;
           }
        else
        if ( url[n] == '?' )
          url[n] = '^';

       const TCFGLIST1& list = redirected_urls;

       for ( int n = 0; n < list.size(); n++ )
           {
             if ( list[n].IsActive() )
                {
                  char mask[MAX_PATH];
                  lstrcpyn(mask,list[n].GetParm(),MAX_PATH);

                  StrReplaceI(mask,"?","^");
                  
                  BOOL find = PathMatchSpec(url,mask);
                  if ( !find )
                     {
                       lstrcat(mask,"/");
                       find = PathMatchSpec(url,mask);
                     }

                  if ( find )
                     {
                       rc = TRUE;
                       break;
                     }
                }
           }

       sys_free(url);
     }

  return rc;
}


void InsertIntoCfgList1(TCFGLIST1& list,const char *value)
{
  for ( int n = 0; n < list.size(); n++ )
      {
        if ( !lstrcmpi(list[n].GetParm(),value) )
           {
             list[n].Load(TRUE,value);
             return;
           }
      }

  list.push_back(CCfgEntry1());
  list.back().Load(TRUE,value);
}


char** ConvertList2Ar(const char *list,int *_count,BOOL add_dot)
{
  char s[MAX_PATH],*p,**buff;
  int n,len,count;
  
  ZeroMemory(s,sizeof(s));
  lstrcpy(s,list);

  len = lstrlen(s);
  for ( n = 0; n < len; n++ )
      if ( s[n] == ';' )
         s[n] = 0;

  count = 0;
  p = s;
  while ( *p )
  {
    count++;
    p += lstrlen(p)+1;
  }

  if ( _count )
     *_count = count;

  if ( !count )
     return NULL;

  buff = (char**)sys_alloc(count*sizeof(char*));
  p = s;
  for ( n = 0; n < count; n++ )
      {
        buff[n] = (char*)sys_alloc(MAX_PATH);
        lstrcpy(buff[n],add_dot?".":"");
        lstrcat(buff[n],p);
        p += lstrlen(p)+1;
      }

  return buff;
}


void FreeListAr(char **buff,int count)
{
  int n;
  
  if ( !buff || !count )
     return;

  for ( n = 0; n < count; n++ )
      sys_free(buff[n]);

  sys_free(buff);
}


BOOL IsProtoInList(const char *list,const char *url)
{
  BOOL rc = FALSE;
  int n,count = 0;
  char **ar = ConvertList2Ar(list,&count,FALSE);

  for ( n = 0; n < count; n++ )
      {
        char s[MAX_PATH];

        lstrcpy(s,ar[n]);
        lstrcat(s,":");

        if ( !StrCmpNI(url,s,lstrlen(s)) )
           {
             rc = TRUE;
             break;
           }
      }

  FreeListAr(ar,count);

  return rc;
}


BOOL IsOurShellTurnedOnForCurrentUser()
{
  char s[MAX_PATH];
  ReadRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell",s,"");
  return !lstrcmpi(PathFindFileName(s),"rshell.exe");
}


BOOL TurnShellOffForCurrentUser()
{
  BOOL rc = TRUE;
  
  if ( IsOurShellTurnedOnForCurrentUser() )
     {
       const char *r_key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";
       const char *r_value = "Shell";

       rc = DeleteRegValue(HKCU,r_key,r_value);
     }

  return rc;
}


BOOL IsOurShellTurnedOnForAllUsers()
{
  char s[MAX_PATH];
  ReadRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell",s,"");
  return !lstrcmpi(PathFindFileName(s),"rshell.exe");
}


BOOL TurnShellOffForAllUsers()
{
  BOOL rc = TRUE;
  
  if ( IsOurShellTurnedOnForAllUsers() )
     {
       const char *r_key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";
       const char *r_value = "Shell";

       rc = AdminAccessWriteRegStr64(HKLM,r_key,r_value,"Explorer.exe");
     }

  return rc;
}


BOOL IsOurShellTurnedOn()
{
  return IsOurShellTurnedOnForCurrentUser() || IsOurShellTurnedOnForAllUsers();
}


// used only by shell.exe process!!!
BOOL TurnShellOnFor(HKEY root)
{
  char s[MAX_PATH] = "";
  GetModuleFileName(NULL,s,sizeof(s));
  
  return WriteRegStr64(root,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell",s);
}


void AddToAllowedFirewallProgramsList(const char *exe,const char *name)
{
  CDisableWOW64FSRedirection g;

  if ( exe && exe[0] && name && name[0] )
     {
       BOOL del_exe = FALSE;

       if ( !IsFileExist(exe) )
          {
            sys_fclose(sys_fcreate(exe));
            del_exe = TRUE;
          }
       
       char s[MAX_PATH];
       wsprintf(s,"netsh.exe firewall add allowedprogram \"%s\" %s ENABLE ALL",exe,name);

       STARTUPINFO si;
       PROCESS_INFORMATION pi;
       ZeroMemory(&si,sizeof(si));
       si.cb = sizeof(si);
       si.dwFlags = STARTF_USESHOWWINDOW;
       si.wShowWindow = SW_HIDE;
       if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
          {
            WaitForSingleObject(pi.hProcess,5000);
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
          }

       if ( del_exe )
          sys_deletefile(exe);
     }
}


// the same code in AddOurAppPath_FromSVC() !!!
void AddOurAppPath()
{
  char exe[MAX_PATH];
  GetLocalPath("rshell.exe",exe);
  
  WriteRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe",NULL,exe);
  WriteRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe","Path",our_currpath);
  WriteRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe",NULL,exe);
  WriteRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe","Path",our_currpath);
}


void RemoveOurAppPath()
{
  DeleteRegKeyNoRec(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe");
  DeleteRegKeyNoRec64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe");
}


void CloseHWWindow(void)
{
  HWND w = GetForegroundWindow();

  if ( w && IsWindowVisible(w) )
     {
       char s_class[MAX_PATH] = "";
       GetClassName(w,s_class,sizeof(s_class));

       if ( !lstrcmp(s_class,"#32770") ) 
          {
            char s_win[MAX_PATH] = "";
            GetWindowText(w,s_win,sizeof(s_win));

            if ( !lstrcmpi(s_win,"Изменение параметров системы") ) //todo:english
               {
                 HWND w_yes = GetDlgItem(w,IDYES);
                 HWND w_no = GetDlgItem(w,IDNO);
                 HWND w_ok = GetDlgItem(w,IDOK);
                 HWND w_cancel = GetDlgItem(w,IDCANCEL);
               
                 if ( w_yes && w_no && !w_ok && !w_cancel )
                    {
                      DWORD rc;
                      SendMessageTimeout(w,WM_COMMAND,MAKELONG(IDNO,BN_CLICKED),(LPARAM)w_no,SMTO_BLOCK|SMTO_ABORTIFHUNG,1000,(PDWORD_PTR)&rc);
                    }
               }
            else
            if ( !lstrcmpi(s_win,"Ограничения") || !lstrcmpi(s_win,"Restrictions") )
               {
                 HWND w_ok = GetDlgItem(w,IDOK);
                 HWND w_cancel = GetDlgItem(w,IDCANCEL);
               
                 if ( !w_ok && w_cancel )
                    {
                      HWND w2 = FindWindowEx(w,NULL,"Static","Операция отменена вследствие действующих для компьютера ограничений. Обратитесь к администратору сети.");

                      if ( !w2 )
                         w2 = FindWindowEx(w,NULL,"Static","This operation has been cancelled due to restrictions in effect on this computer. Please contact your system administrator.");

                      if ( w2 )
                         {
                           PostMessage(w,WM_CLOSE,0,0);
                           BalloonNotify(NIIF_WARNING,LS(LS_INFO),LS(3229),10);
                         }
                    }
               }
          }
     }
}


const char *GetDOWString(int dow)
{
  static const int days[7] = {3104,3105,3106,3107,3108,3109,3110};

  if ( dow < 0 || dow > 6 )
     return "";

  return LS(days[dow]);
}


TStringList* CreateStringListFromMultiLineStringIgnoreEmptys(const char *_src,const char *undecorate_str,char terminator)
{
  TStringList *list = new TStringList;

  if ( !IsStrEmpty(_src) )
     {
       int len = lstrlen(_src);
       int i_begin = 0;
       for ( int n = 0; n <= len; n++ )
           {
             char c = _src[n];
             if ( c == 0 || c == terminator )
                {
                  char *t = (char*)sys_alloc(n-i_begin+1);
                  lstrcpyn(t,_src+i_begin,n-i_begin+1);
                  if ( !IsStrEmpty(undecorate_str) )
                     StrTrim(t,undecorate_str);
                  if ( IsStrEmpty(t) )
                     sys_free(t);
                  else
                     list->push_back(t);

                  i_begin = n+1;
                }
           }
     }

  return list;
}


void FreeStringList(TStringList *list)
{
  if ( list )
     {
       for ( TStringList::iterator it = list->begin(); it != list->end(); ++it )
           {
             SAFESYSFREE(*it);
           }

       list->clear();
       delete list;
     }
}
