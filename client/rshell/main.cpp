
#include "include.h"



BOOL FindCmdLineParm(const char *parm)
{
  BOOL rc = FALSE;
  
  for ( int n = 1; n < __argc; n++ )
      {
        if ( !lstrcmpi(__argv[n],parm) )
           {
             rc = TRUE;
             break;
           }
      }

  return rc;
}



void ReadGlobalConfig()
{
  // the same code in service!!!

  machine_type = ReadRegDword(HKLM,REGPATH,"machine_type",MACHINE_TYPE_GAMECLUB);
  ReadRegStr(HKLM,REGPATH,"machine_loc",machine_loc,"");
  if ( !machine_loc[0] )
     ReadRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion","RegisteredOrganization",machine_loc,"");
  if ( !machine_loc[0] )
     lstrcpy(machine_loc,"Organization");
  ReadRegStr(HKLM,REGPATH,"machine_desc",machine_desc,"");
  if ( !machine_desc[0] )
     MyGetComputerName(machine_desc);
  ReadRegStr(HKLM,REGPATH,"server_ip",server_ip_internal,"");
  def_lang = ReadRegDword(HKLM,REGPATH,"def_lang",IsCyrillic()?0:1);
  show_langs_at_startup = ReadRegDword(HKLM,REGPATH,"show_langs_at_startup",0) != 0;
  ReadRegStr(HKLM,REGPATH,"allowed_services_ips",allowed_services_ips,"");
}


void WriteGlobalConfig()
{
  // the same code in service!!!

  WriteRegDword(HKLM,REGPATH,"machine_type",machine_type);
  WriteRegStr(HKLM,REGPATH,"machine_loc",machine_loc);
  WriteRegStr(HKLM,REGPATH,"machine_desc",machine_desc);
  WriteRegStr(HKLM,REGPATH,"server_ip",server_ip_internal);
  WriteRegDword(HKLM,REGPATH,"def_lang",def_lang);
  WriteRegDword(HKLM,REGPATH,"show_langs_at_startup",show_langs_at_startup);
  WriteRegStr(HKLM,REGPATH,"allowed_services_ips",allowed_services_ips);
}


void CheckTempDir(void)
{
  char s[MAX_PATH];
  void *h;
  
  s[0] = 0;
  GetTempPath(sizeof(s),s);

  if ( !s[0] )
     {
       ErrBoxW(WSTR_003);
       return;
     }

  PathAddBackslash(s);
  CreateDirectory(s,NULL);

  lstrcat(s,"__write_test.tst2");

  h = sys_fcreate(s);
  if ( h )
     {
       sys_fclose(h);
       sys_deletefile(s);
     }
  else
     {
       PathRemoveFileSpec(s);

       WCHAR msg[MAX_PATH*2];
       wsprintfW(msg,WSTR_004,CUnicode(s).Text());
       ErrBoxW(msg);
     }
}


void CheckWindowsVersion(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion <= 4 )
          {
            ErrBoxW(WSTR_005);
            ApiDone();
            ApiExit(0);
          }
     }
}


void CheckIfWeRunFromNet(void)
{
  BOOL is_net = (our_currpath[0] == '\\' && our_currpath[1] == '\\');

  if ( !is_net )
     {
       char s[MAX_PATH];
       UINT type;

       lstrcpyn(s,our_currpath,4);

       type = GetDriveType(s);

       if ( type == DRIVE_REMOTE )
          {
            is_net = TRUE;
          }
     }
  
  if ( is_net )
     {
       ErrBoxW(WSTR_006);
       ApiDone();
       ApiExit(0);
     }
}


void SpecialSafeModeCheck(void)
{
  if ( IsRunningInSafeModeWithCmdFromAnotherUser() )
     {
       WinExec("cmd.exe",SW_NORMAL);
       ApiDone();
       ApiExit(0);
     }
}


void CheckAdminAccount()
{
  if ( !IsAdminAccount() )
     {
       ErrBoxW(WSTR_007);
       ApiDone();
       ApiExit(0);
     }
}



typedef struct {
int cbSize;
HICON small_icon;
HICON big_icon;
int machine_type;
TSTRING machine_loc;
TSTRING machine_desc;
TSTRING server_ip;
int def_lang;
BOOL add_langs;
BOOL show_langs_at_startup;
TSTRING allowed_services_ips;
} STARTUPDIALOGINFO;


void StartupMasterDialog(void)
{
  BOOL is_operator = FindCmdLineParm("-operator");
  
  STARTUPDIALOGINFO i;
  
  i.cbSize = sizeof(i);
  i.small_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,16,16,LR_SHARED);
  i.big_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,32,32,LR_SHARED);
  i.machine_type = is_operator ? MACHINE_TYPE_OPERATOR : machine_type;
  lstrcpy(i.machine_loc,machine_loc);
  lstrcpy(i.machine_desc,machine_desc);
  lstrcpy(i.server_ip,/*is_operator ? GetMyIPAsString(s) :*/ server_ip_internal);
  i.def_lang = def_lang;
 #ifdef ADDLANGS
  i.add_langs = TRUE;
 #else
  i.add_langs = FALSE;
 #endif
  i.show_langs_at_startup = show_langs_at_startup;
  lstrcpy(i.allowed_services_ips,allowed_services_ips);

  if ( ShowStartupMasterDialog(&i) )
     {
       machine_type = i.machine_type;
       lstrcpy(machine_loc,i.machine_loc);
       lstrcpy(machine_desc,i.machine_desc);
       lstrcpy(server_ip_internal,i.server_ip);
       def_lang = i.def_lang;
       show_langs_at_startup = i.show_langs_at_startup;
       lstrcpy(allowed_services_ips,i.allowed_services_ips);

       WriteGlobalConfig();
     }
}


void ChecksAtStartup(void)
{
  if ( FindCmdLineParm("-install") )
     {
       //silent install mode, we're run from installer
       if ( IsAdminAccount() )
          {
            // !!! these functions is also called from InstallActions_FromSVC()
            // so changes here must be mirrored in function !!!
            AddOurAppPath();
            InstallOurClasses();
            InstallCPUTempDriver();
            InstallOurService();
            ProcessRestricts(RREASON_INSTALL);
          }
     }
  else
  if ( FindCmdLineParm("-uninstall") )
     {
       //silent uninstall mode, we're run from installer
       if ( IsAdminAccount() )
          {
            ProcessRestricts(RREASON_UNINSTALL);
            UninstallOurService();
            UninstallCPUTempDriver();
            UninstallOurClasses();
            ClearSettingsCacheForAllUsers();
            RemoveOurAppPath();
          }
     }
  else
  if ( FindCmdLineParm("-turnon") )
     {
       TurnShellOnDialogW();
     }
  else
     {
       CreateMutex(NULL,FALSE,"_RunpadShellMutex");
       if ( GetLastError() != ERROR_ALREADY_EXISTS )
          {
            if ( IsExplorerLoaded() )
               {
                 CheckWindowsVersion();
                 CheckIfWeRunFromNet();
                 CheckAdminAccount();
                 StartupMasterDialog();
               }
            else
               {
                 SpecialSafeModeCheck();
                 CheckTempDir();

                 return;
               }
          }
     }

  ApiDone();
  ApiExit(1);
}



void GlobalDoneWithoutApiDone(int event_id)
{
  CloseOurBlocker();
  CloseActiveSheet(FALSE);
  TurnOnMonitor();
  SetInputDisableState(FALSE);
  
  DisconnectWebCam();
  //CloseChildWindowsAsync();
  AddEventString2SQLBase(event_id);
  FinishFlashDrives4Stat();
  DoneCameraCallback();
  DoneAutorun();
  OurTrayIconOnDone();
  DonePrinterThread();
  WorkSpaceDone();
  ProcessRestricts(event_id == EL_OFFSHELL ? RREASON_OFFSHELL : RREASON_SHUTDOWN);
  DoneHWIdents();
  NetFlush(200);
  NetDone();
  ClearShellEnvStrings();
}


void GlobalOnEndSession(int event_id)
{
  DoneAutorun();  // this can takes a lot of time on Vista immediately after restart!

  if ( is_vista && !IsInShutdownState() )
     return;
  
  ProcessRestricts(RREASON_SHUTDOWN);
  AddEventString2SQLBase(event_id);
  FinishFlashDrives4Stat();
  NetFlush(200);
  NetDone();
  ClearShellEnvStrings();
  
  DisconnectWebCam();
  DoneCameraCallback();
  DoneHWIdents();
  //DonePrinterThread();
  SetInputDisableState(FALSE);
  WorkSpaceOnEndSession();
  //ApiDoneWithoutFlush();

  #ifdef DEBUG
  Beep(1000,50);
  #endif

  ExitProcess(1); //ApiExit(1);
}


void MainFunction(void)
{
  ApiInit();
  ReadGlobalConfig();
  ChecksAtStartup();

  ProcessLangAtStartup();

  ShowAboutBox();
  Wait4DesktopSwitch();

  NetInit();
  ReadConfig();
  WriteConfig4BodyTools();
  SwitchCurrentThreadToCPU0IfNeeded();
  PollServer(); //optimization
  InitHWIdents();

  WaitForOurServiceReady();

  ProcessRestricts(RREASON_STARTUP);
  
  WaitForFileServerReady();

  AboutBoxUpdateProgress(LS(3051));
  ASV2_ExecToolIfPresent();
  CreateUserFolder();
  SetShellEnvStrings();
  SetIEStartupSettings();
  CleanTempDir();
  CleanIEDir();
  CleanRecycleBin();
  ClearPrintSpooler();
  ScheduleScanDisk();
  ProcessStatAtStartup();
  CollectFlashDrivesInfo4Stat();
  ASV2_WaitForData();
  AboutBoxUpdateProgress("");

  HideAboutBox();
  DisableDesktopComposition();
  AutoRestoreDisplayModeAtStartup();
  MouseRestoreAtStartup();

  WorkSpaceInit();
  CheckRunProtectionAtStartup();
  InitPrinterThread();
  SwitchOurTrayIcons();
  InitAutorun();
  InitCameraCallback();
  ShowLAAtStartup();

  CheckMonitorPowerAtStartup();
  SendDynamicInfoToServer();
  AddEventString2SQLBase(EL_STARTSHELL);
  ShellReadyEvent();
  ASV2_ForceUpdate();

  OpenDefaultSheetAsync();

  MessageLoopNeverReturns();
}
