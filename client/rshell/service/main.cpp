
#include "include.h"




BOOL SearchParam(const char *s)
{
  for ( int n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],s) )
         return TRUE;

  return FALSE;
}


BOOL IsSilent()
{
  return SearchParam("-silent");
}


void Message(const char *s)
{
  if ( !IsSilent() )
     {
       #ifndef NDEBUG
       printf("%s\n",s);
       #endif
     }
}



void TryTurnOffRollback()
{
  CRollback rlb;

  int st_drv = -1;
  int st_rlb = -1;

  if ( rlb.GetDriverStatus(st_drv) && rlb.GetRollbackStatus(st_rlb) )
     {
       if ( st_rlb == CRollback::ST_RLB_OFF_OFF || st_rlb == CRollback::ST_RLB_NODRIVER )
          {
            if ( st_drv == CRollback::ST_DRV_ON_ON || st_drv == CRollback::ST_DRV_OFF_ON )
               {
                 rlb.UninstallDriver();
               }
          }
       else
       if ( st_rlb == CRollback::ST_RLB_ON_ON || st_rlb == CRollback::ST_RLB_ON_ON_SAVE )
          {
            rlb.RollbackDeactivate(TRUE);
          }
     }
}


BOOL RemoteUninstallInternal(CServiceManager *sm,BOOL b_restart,BOOL b_force)
{
  BOOL rc = FALSE;

  char our_exe[MAX_PATH] = "";
  GetModuleFileName(GetModuleHandle(NULL),our_exe,sizeof(our_exe));

  if ( StrStrI(PathFindFileName(our_exe),"tmp") )
     {
       // schedule deletion of this .exe and rp_shared.dll
       MoveFileEx(our_exe,NULL,MOVEFILE_DELAY_UNTIL_REBOOT);
       char t[MAX_PATH] = "";
       GetFileNameInLocalAppDir("rp_shared.dll",t);
       MoveFileEx(t,NULL,MOVEFILE_DELAY_UNTIL_REBOOT);

       // get original install path
       char inst_path[MAX_PATH] = "";
       ReadRegStr(HKLM,"SOFTWARE\\RunpadProShell","Install_Dir",inst_path,"");
       if ( !IsStrEmpty(inst_path) )
          {
            // first try to stop and uninstall our service
            if ( sm->HighLevelUninstall() )
               {
                 // then turn off Rollback
                 TryTurnOffRollback(); // todo: maybe better way...

                 // some registry cleanup
                 DeleteRegValue(HKLM,"SOFTWARE\\RunpadProShell","Install_Dir");
                 DeleteRegValue(HKLM,"SOFTWARE\\RunpadProShell","update_finish_flag");

                 // delete all files in original install directory
                 char target_exe[MAX_PATH];
                 lstrcpy(target_exe,inst_path);
                 PathAppend(target_exe,"rshell_svc.exe");
                 
                 unsigned starttime = GetTickCount();
                 do {
                  CleanDir(inst_path);

                  if ( !IsFileExist(target_exe) )
                     break;

                  Sleep(100);

                  if ( GetTickCount() - starttime > 5000 )
                     break;

                 } while (1);

                 if ( IsFileExist(target_exe) )
                    {
                      MoveFileEx(target_exe,NULL,MOVEFILE_DELAY_UNTIL_REBOOT);
                      MoveFileEx(inst_path,NULL,MOVEFILE_DELAY_UNTIL_REBOOT);
                    }
                 else
                    {
                      sys_removedirectory(inst_path);
                    }

                 // reboot if needed
                 if ( b_restart )
                    {
                      DoRebootShutdown(TRUE,b_force);
                    }
                 
                 rc = TRUE;
               }
          }
     }

  return rc;
}



typedef struct {
int cbSize;
HICON small_icon;
HICON big_icon;
int machine_type;
TSTRING machine_loc;
TSTRING machine_desc;
TSTRING server_ip;
} STARTUPDIALOGINFO;


BOOL StartupMasterDialog()
{
  BOOL rc = FALSE;
  
  InitCommonControls();  // before dll loaded

  HINSTANCE lib = LoadLibrary("rshell.dll");

  BOOL (__cdecl *ShowStartupMasterDialog)(void*) = NULL;
  *(void**)&ShowStartupMasterDialog = (void*)GetProcAddress(lib,"ShowStartupMasterDialog");

  if ( ShowStartupMasterDialog )
     {
       rc = TRUE;  // here!
  
       STARTUPDIALOGINFO i;
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.small_icon = (HICON)LoadImage(GetModuleHandle(NULL),MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,16,16,LR_SHARED);
       i.big_icon = (HICON)LoadImage(GetModuleHandle(NULL),MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,32,32,LR_SHARED);

       ReadGlobalConfig(i.machine_type,i.machine_loc,i.machine_desc,i.server_ip);

       if ( ShowStartupMasterDialog(&i) )
          {
            WriteGlobalConfig(i.machine_type,i.machine_loc,i.machine_desc,i.server_ip);
            SaveRollback1();
          }
     }

  if ( lib )
     {
       FreeLibrary(lib);
     }

  return rc;
}


int main()
{
  int rc = 0;
  
  CMyService oService;
  CServiceManager *sm = CServiceManager::Create(&oService);
  
  if ( SearchParam("-install") )
     {
       if ( sm->HighLevelInstall() )
          {
            Message("OK");
            rc = 1;
          }
       else
          {
            Message("failed");
          }
     }
  else
  if ( SearchParam("-uninstall") )
     {
       if ( IsShellInstalled() )
          {
            if ( sm->HighLevelUninstall() )
               {
                 TryTurnOffRollback(); // todo: maybe better way...
                 
                 Message("OK");
                 rc = 1;
               }
            else
               {
                 Message("failed");
               }
          }
     }
  else
  if ( SearchParam("{94F74927-976F-4743-911D-900EA71441D8}") )
     {
       BOOL b_restart = SearchParam("-restart");
       BOOL b_force = SearchParam("-force");
           
       if ( RemoteUninstallInternal(sm,b_restart,b_force) )
          {
            rc = 1;
          }
     }
  else
  if ( SearchParam("-setup") )
     {
       //we're run from installer
       if ( IsAdminAccount() )
          {
            printf("--= Runpad Pro Client Setup =--\n");  // for decoration
            
            if ( StartupMasterDialog() )
               {
                 Message("OK");
                 rc = 1;
               }
            else
               {
                 Message("failed");
               }
          }
       else
          {
            Message("failed");
          }
     }
  else
     {
       rc = sm->HighLevelProcess() ? 1 : 0;
     }

  sm->Release();
  return rc ? 0 : 1;
}
