
#include "include.h"



void SmartThreadFinish(HANDLE &h)
{
  if ( h )
     {
       if ( WaitForSingleObject(h,0) == WAIT_TIMEOUT )
          {
            TerminateThread(h,0);
          }

       CloseHandle(h);
       h = NULL;
     }
}


char* GetMyMACAsString(char *s)
{
  unsigned char mac[6];
  ULONG len = sizeof(mac);

  if ( SendARP(GetMyIPAsInt(),0,(ULONG*)mac,&len) != NO_ERROR || len != 6 )
     {
       mac[0] = mac[1] = mac[2] = mac[3] = mac[4] = mac[5] = 0xFF;
     }

  wsprintf(s,"%02X:%02X:%02X:%02X:%02X:%02X",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);

  return s;
}


static BOOL TurnShellInternal(BOOL state,HKEY root)
{
  BOOL rc = FALSE;
  
  if ( state )
     {
       char s[MAX_PATH] = "";
       GetModuleFileName(GetModuleHandle(NULL),s,sizeof(s));
       PathRemoveFileSpec(s);
       PathAppend(s,"rshell.exe");

       rc = WriteRegStr64(root,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell",s/*"rshell.exe"*/);
     }
  else
     {
       if ( root == HKLM )
          {
            rc = WriteRegStr64(root,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell","Explorer.exe");
          }
       else
          {
            // fix for remained restricts!
            DeleteRegValue(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableTaskMgr");
            
            rc = DeleteRegValue(root,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","Shell");
          }
     }

  return rc;
}


BOOL TurnShell4User(BOOL state,const char *s_domain,const char *s_user,const char *s_password)
{
  BOOL rc = FALSE;

  if ( s_user && s_user[0] )
     {
       BOOL use_domain = FALSE;
       
       if ( !s_domain || !s_domain[0] )
          {
            s_domain = ".";
          }
       else
          {
            use_domain = TRUE;
          }

       if ( !s_password )
          s_password = "";

       SetProcessPrivilege(SE_TCB_NAME);
       SetProcessPrivilege(SE_CHANGE_NOTIFY_NAME);
       SetProcessPrivilege("SeInteractiveLogonRight"/*SE_INTERACTIVE_LOGON_NAME*/);
       
       HANDLE token = NULL;
       if ( LogonUser(s_user,s_domain,s_password,LOGON32_LOGON_INTERACTIVE,LOGON32_PROVIDER_DEFAULT,&token) )
          {
            char man_profile[MAX_PATH] = "";

            WCHAR w_domain[MAX_PATH];
            WCHAR w_user[MAX_PATH];

            w_domain[0] = 0;
            MultiByteToWideChar(CP_ACP,0,s_domain,-1,w_domain,MAX_PATH);
            w_user[0] = 0;
            MultiByteToWideChar(CP_ACP,0,s_user,-1,w_user,MAX_PATH);

            USER_INFO_4 *ui = NULL;
            //todo: check in domains here!
            if ( NetUserGetInfo(use_domain?w_domain:NULL,w_user,3,(LPBYTE*)&ui) == NERR_Success && ui )
               {
                 if ( ui->usri4_profile && ui->usri4_profile[0] )
                    {
                      WideCharToMultiByte(CP_ACP,0,ui->usri4_profile,-1,man_profile,MAX_PATH,NULL,NULL);
                    }

                 NetApiBufferFree(ui);
               }

            PROFILEINFO pi;
            ZeroMemory(&pi,sizeof(pi));
            pi.dwSize = sizeof(pi);
            pi.dwFlags = PI_NOUI;
            pi.lpUserName = (char*)s_user; //used as dir name ?
            pi.lpProfilePath = man_profile[0] ? man_profile : NULL;
            pi.lpDefaultPath = NULL;
            pi.lpServerName = NULL; //domain?
            pi.lpPolicyPath = NULL;
            pi.hProfile = NULL;
               
            if ( LoadUserProfile(token,&pi) )
               {
                 rc = TurnShellInternal(state,(HKEY)pi.hProfile);
                 UnloadUserProfile(token,pi.hProfile);
               }

            CloseHandle(token);
          }
     }

  return rc;
}


BOOL TurnShell4AllUsers(BOOL state)
{
  return TurnShellInternal(state,HKLM);
}


BOOL TurnAutologonOn(BOOL force,const char *s_domain,const char *s_user,const char *s_password)
{
  BOOL rc = FALSE;
  
  if ( s_user && s_user[0] )
     {
       char cname[MAX_PATH] = "";
       MyGetComputerName(cname);

       if ( !s_domain || !s_domain[0] )
          s_domain = cname;

       if ( !s_password )
          s_password = "";

       const char *key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";

       rc = TRUE;

       rc = !rc ? rc : WriteRegStr64(HKLM,key,"AltDefaultDomainName",s_domain);
       rc = !rc ? rc : WriteRegStr64(HKLM,key,"DefaultDomainName",s_domain);
       rc = !rc ? rc : WriteRegStr64(HKLM,key,"AltDefaultUserName",s_user);
       rc = !rc ? rc : WriteRegStr64(HKLM,key,"DefaultUserName",s_user);

       if ( !IsStrEmpty(s_password) )
          {
            rc = !rc ? rc : WriteRegStr64(HKLM,key,"AltDefaultPassword",s_password);
            rc = !rc ? rc : WriteRegStr64(HKLM,key,"DefaultPassword",s_password);
          }
       else
          {
            rc = !rc ? rc : DeleteRegValue64(HKLM,key,"AltDefaultPassword");
            rc = !rc ? rc : DeleteRegValue64(HKLM,key,"DefaultPassword");
          }

       rc = !rc ? rc : WriteRegStr64(HKLM,key,"AutoAdminLogon","1");
       rc = !rc ? rc : WriteRegStr64(HKLM,key,"ForceAutoLogon",force?"1":"0");
     }

  return rc;
}


// the same code in shell!
BOOL TurnAutologonOff()
{
  const char *key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";

  BOOL rc = TRUE;

  rc = !rc ? rc : DeleteRegValue64(HKLM,key,"AltDefaultPassword");
  rc = !rc ? rc : DeleteRegValue64(HKLM,key,"DefaultPassword");
  rc = !rc ? rc : DeleteRegValue64(HKLM,key,"AutoAdminLogon");
  rc = !rc ? rc : DeleteRegValue64(HKLM,key,"ForceAutoLogon");

  return rc;
}


BOOL DoRebootShutdown(BOOL do_reboot,BOOL force)
{
  BOOL exit_code = TRUE;

  SetProcessPrivilege(SE_SHUTDOWN_NAME);

  const DWORD reason = 0x00040000 | 0x80000000 /*SHTDN_REASON_MAJOR_APPLICATION | SHTDN_REASON_FLAG_PLANNED*/;

  int flags = (do_reboot ? EWX_REBOOT : (EWX_SHUTDOWN | EWX_POWEROFF));
  flags |= (force ? EWX_FORCE : 0);
  if ( !ExitWindowsEx(flags,reason) )
     {
       if ( !InitiateSystemShutdownEx(NULL,NULL,0,force,do_reboot,reason) )
          {
            int rc = GetLastError();
            
            if ( rc != ERROR_SHUTDOWN_IN_PROGRESS )
               {
                 exit_code = FALSE;
                 
                 if ( rc == ERROR_MACHINE_LOCKED && !force )
                    {
                      if ( InitiateSystemShutdownEx(NULL,NULL,0,TRUE,do_reboot,reason) )
                         exit_code = TRUE;
                    }
               }
          }
     }

  return exit_code;
}


BOOL DoSuspendHibernate(BOOL do_suspend,BOOL force)
{
  BOOL rc = FALSE;

  SetProcessPrivilege(SE_SHUTDOWN_NAME);

  if ( !SetSystemPowerState(do_suspend?TRUE:FALSE,TRUE/*always force!*/) )
     {
       rc = DoRebootShutdown(FALSE,force);
     }
  else
     {
       rc = TRUE;
     }

  return rc;
}


BOOL IsServiceRunning(const char *name)
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,STANDARD_RIGHTS_READ);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,name,GENERIC_READ);
       if ( h )
          {
            SERVICE_STATUS ss;
            ZeroMemory(&ss,sizeof(ss));
            if ( QueryServiceStatus(h,&ss) )
               {
                 if ( ss.dwCurrentState == SERVICE_RUNNING )
                    {
                      rc = TRUE;
                    }
               }

            CloseServiceHandle(h);
          }

       CloseServiceHandle(scm);
     }

  return rc;
}


BOOL IsRollbackAllowedFromLic(const char *lf,std::string& _comments)
{
  _comments.clear();
  return StrStrI(NNS(lf),"Rollback") != NULL;
}


void ReadGlobalConfig(int& machine_type,TSTRING& machine_loc,TSTRING& machine_desc,TSTRING& server_ip)
{
  // the same code in shell!!!

  machine_type = ReadRegDword(HKLM,REGPATH,"machine_type",MACHINE_TYPE_GAMECLUB);
  ReadRegStr(HKLM,REGPATH,"machine_loc",machine_loc,"");
  if ( !machine_loc[0] )
     ReadRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion","RegisteredOrganization",machine_loc,"");
  if ( !machine_loc[0] )
     lstrcpy(machine_loc,"Organization");
  ReadRegStr(HKLM,REGPATH,"machine_desc",machine_desc,"");
  if ( !machine_desc[0] )
     MyGetComputerName(machine_desc);
  ReadRegStr(HKLM,REGPATH,"server_ip",server_ip,"");
}


void WriteGlobalConfig(const int& machine_type,const TSTRING& machine_loc,const TSTRING& machine_desc,const TSTRING& server_ip)
{
  // the same code in shell!!!

  WriteRegDword(HKLM,REGPATH,"machine_type",machine_type);
  WriteRegStr(HKLM,REGPATH,"machine_loc",machine_loc);
  WriteRegStr(HKLM,REGPATH,"machine_desc",machine_desc);
  WriteRegStr(HKLM,REGPATH,"server_ip",server_ip);
}


BOOL IsShellInstalled()
{
  char s[MAX_PATH] = "";
  GetFileNameInLocalAppDir("rshell.exe",s);

  return IsFileExist(s);
}


void ScanDir(const char *path,int type,SCANFUNC func,void *user)
{
  WIN32_FIND_DATA f;
  char s[MAX_PATH]; 
  HANDLE h;
  int rc,dir,file,hidden;

  lstrcpy(s,path);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  h = FindFirstFile(s,&f);
  rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         dir = (f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
         file = !dir;
         hidden = (f.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) || (f.dwFileAttributes & FILE_ATTRIBUTE_SYSTEM);

         if ( !hidden || (type & SCAN_HIDDEN) )
            {
              if ( ((type & SCAN_DIR) && dir) || ((type & SCAN_FILE) && file) )
                 {
                   lstrcpy(s,path);
                   PathAddBackslash(s);
                   lstrcat(s,f.cFileName);
                   if ( !func(s,&f,user) )
                      break;
                 }
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}



static BOOL DelProc(const char *path,WIN32_FIND_DATA *f,void *user)
{
  if ( f->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
     {
       CleanDir(path);
       sys_removedirectory(path);
     }
  else
     {
       sys_deletefile(path);
     }

  return TRUE;
}



void CleanDir(const char *dir)
{
  ScanDir(dir,SCAN_DIR | SCAN_FILE | SCAN_HIDDEN,DelProc,NULL);
}


BOOL SaveRollback1()
{
  BOOL rc = FALSE;
  
  CRollback rlb;

  int st_rlb = -1;
  if ( rlb.GetRollbackStatus(st_rlb) )
     {
       if ( st_rlb == CRollback::ST_RLB_ON_ON )
          {
            rc = rlb.RollbackSaveAll();
          }
     }

  return rc;
}



