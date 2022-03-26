
#include "include.h"
#include <set>



enum {
RF_INSTALL = 1,
RF_REGULAR = 2,
RF_STARTUPCRITICAL = 4,
};


typedef struct {
int flags;
BOOL *p_state;
void (*func)(BOOL state,void *p1,void *p2,void *p3);
void *p1;
void *p2;
void *p3;
} RESTRICT;

static BOOL sysrestrict_true = TRUE;


static void CtfMonDisable(BOOL state,void *p1,void *p2,void *p3);
static void IEDisable(BOOL state,void *p1,void *p2,void *p3);
static void MPDisable(BOOL state,void *p1,void *p2,void *p3);
static void NotepadDisable(BOOL state,void *p1,void *p2,void *p3);
static void ImgViewDisable(BOOL state,void *p1,void *p2,void *p3);
static void PDFViewDisable(BOOL state,void *p1,void *p2,void *p3);
static void SWFFlashDisable(BOOL state,void *p1,void *p2,void *p3);
static void OfficeDisable(BOOL state,void *p1,void *p2,void *p3);
static void ShellExecuteDisable(BOOL state,void *p1,void *p2,void *p3);
static void CopyHookDisable(BOOL state,void *p1,void *p2,void *p3);
static void SetRegKey(BOOL state,void *p1,void *p2,void *p3);
static void SetRegKeyAutorun(BOOL state,void *p1,void *p2,void *p3);
static void DialogBoxesLite(BOOL state,void *p1,void *p2,void *p3);
static void DialupPropertiesDisable(BOOL state,void *p1,void *p2,void *p3);
static void DisksRestrict(BOOL state,void *p1,void *p2,void *p3);
static void DialogBoxesProcess(BOOL state,void *p1,void *p2,void *p3);
static void WinampProcess(BOOL state,void *p1,void *p2,void *p3);
static void MPlayercProcess(BOOL state,void *p1,void *p2,void *p3);
static void PowerDVDProcess(BOOL state,void *p1,void *p2,void *p3);
static void ConsoleProcess(BOOL state,void *p1,void *p2,void *p3);
static void TorrentProcess(BOOL state,void *p1,void *p2,void *p3);


static RESTRICT restricts[] = 
{
  // !!! these RF_INSTALL restricts are also set from SERVICE in InstallActions_FromSVC() !!!
  {RF_INSTALL,&sysrestrict_true,InstallGina,NULL,NULL,NULL},
  {RF_INSTALL,&sysrestrict_true,SetAlternateShell,NULL,NULL,NULL},
  {RF_INSTALL,&sysrestrict_true,ShellExecuteDisablePrepare,NULL,NULL,NULL},
  ///////
  {RF_REGULAR,&sysrestrict_true,CtfMonDisable,NULL,NULL,NULL},
  {RF_STARTUPCRITICAL,&sysrestrict00,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableTaskMgr"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict01,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableChangePassword"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict02,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableLockWorkstation"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict03,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoLogoff"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict04,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoClose"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict05,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableRegistryTools"},
  {RF_REGULAR/*RF_STARTUPCRITICAL*/,&sysrestrict06,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\System","DisableSwitchUserOption"},
  {RF_REGULAR,&sysrestrict07,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoControlPanel"},
  {RF_REGULAR,&sysrestrict08,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoFileMenu"},
  {RF_REGULAR,&sysrestrict09,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Network","NoFileSharingControl"},
  {RF_REGULAR,&sysrestrict10,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Network","NoEntireNetwork"},
  {RF_REGULAR,&sysrestrict11,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Network","NoWorkgroupContents"},
  {RF_REGULAR,&sysrestrict12,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Network","NoNetSetup"},
  {RF_REGULAR,&sysrestrict13,SetRegKey,HKCU,"Software\\Policies\\Microsoft\\Internet Explorer\\Restrictions","NoBrowserOptions"},
  {RF_REGULAR,&sysrestrict14,SetRegKey,HKCU,"Software\\Policies\\Microsoft\\Internet Explorer\\Restrictions","NoBrowserContextMenu"},
  {RF_REGULAR,&sysrestrict15,SetRegKey,HKCU,"Software\\Policies\\Microsoft\\Internet Explorer\\Restrictions","NoFavorites"},
  {RF_REGULAR,&sysrestrict16,SetRegKey,HKCU,"Software\\Policies\\Microsoft\\Internet Explorer\\Restrictions","NoHelpMenu"},
  {RF_REGULAR,&sysrestrict17,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoBandCustomize"},
  {RF_REGULAR,&sysrestrict18,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoToolbarCustomize"},
  {RF_REGULAR,&sysrestrict19,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoRun"},
  {RF_REGULAR,&sysrestrict20,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoFileUrl"},
  {RF_REGULAR,&sysrestrict21,SetRegKeyAutorun,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoDriveTypeAutorun"},
  {RF_REGULAR,&sysrestrict22,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoViewContextMenu"},
  //{RF_REGULAR,&sysrestrict??,SetRegKey,HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoNetHood"},
  {RF_REGULAR,&sysrestrict23,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoDeletePrinter"},
  {RF_REGULAR,&sysrestrict24,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoAddPrinter"},
  {RF_REGULAR,&sysrestrict25,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoNetCrawling"},
  {RF_REGULAR,&sysrestrict26,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoNetConnectDisconnect"},
  {RF_REGULAR,&sysrestrict27,SetRegKey,HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoWindowsUpdate"},
  {RF_REGULAR,&sysrestrict28,DialogBoxesLite,NULL,NULL,NULL},
  {RF_REGULAR,&sysrestrict29,DialupPropertiesDisable,NULL,NULL,NULL},
  {RF_REGULAR,&sysrestrict_true,DisksRestrict,NULL,NULL,NULL},
  {RF_REGULAR,&restrict_shellexechook,ShellExecuteDisable,NULL,NULL,NULL},
  {RF_REGULAR,&restrict_copyhook,CopyHookDisable,NULL,NULL,NULL},
  {RF_REGULAR,&restrict_file_dialogs,DialogBoxesProcess,NULL,NULL,NULL},
  {RF_REGULAR,&safe_winamp,WinampProcess,NULL,NULL,NULL},
  {RF_REGULAR,&safe_mplayerc,MPlayercProcess,NULL,NULL,NULL},
  {RF_REGULAR,&safe_powerdvd,PowerDVDProcess,NULL,NULL,NULL},
  {RF_REGULAR,&safe_torrent,TorrentProcess,NULL,NULL,NULL},
  {RF_REGULAR,&safe_console,ConsoleProcess,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_ie,IEDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_mp,MPDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_office,OfficeDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_notepad,NotepadDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_imgview,ImgViewDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_pdf,PDFViewDisable,NULL,NULL,NULL},
  {RF_REGULAR,&use_bodytool_swf,SWFFlashDisable,NULL,NULL,NULL},
};



static void CtfMonDisable(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       char s[MAX_PATH];
       
       // save state
       ReadRegStr(HKCU,REGPATH,"ctfmon.exe",s,"*");
       if ( s[0] == '*' )
          {
            ReadRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","ctfmon.exe",s,"");
            WriteRegStr(HKCU,REGPATH,"ctfmon.exe",s);
          }
       int val = ReadRegDword(HKCU,REGPATH,"Disable Thread Input Manager",-2);
       if ( val == -2 )
          {
            val = ReadRegDword(HKCU,"SOFTWARE\\Microsoft\\CTF","Disable Thread Input Manager",-1);
            WriteRegDword(HKCU,REGPATH,"Disable Thread Input Manager",val);
          }

       // set new state
       DeleteRegValue(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","ctfmon.exe");
       WriteRegDword(HKCU,"SOFTWARE\\Microsoft\\CTF","Disable Thread Input Manager",1);
     }
  else
     {
       char s[MAX_PATH];

       // restore state
       ReadRegStr(HKCU,REGPATH,"ctfmon.exe",s,"*");
       if ( s[0] != '*' )
          {
            if ( s[0] )
               WriteRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","ctfmon.exe",s);
            else
               DeleteRegValue(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","ctfmon.exe");
          }
       int val = ReadRegDword(HKCU,REGPATH,"Disable Thread Input Manager",-2);
       if ( val != -2 )
          {
            if ( val != -1 )
               WriteRegDword(HKCU,"SOFTWARE\\Microsoft\\CTF","Disable Thread Input Manager",val);
            else
               DeleteRegValue(HKCU,"SOFTWARE\\Microsoft\\CTF","Disable Thread Input Manager");
          }

       // cleanup
       DeleteRegValue(HKCU,REGPATH,"ctfmon.exe");
       DeleteRegValue(HKCU,REGPATH,"Disable Thread Input Manager");
     }
}


static void IEDisable(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       char s[MAX_PATH] = "";
       GetLocalPath("bodywb.exe",s);
       WriteRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\IEXPLORE.EXE",NULL,s);
       lstrcpy(s,our_currpath);
       PathRemoveBackslash(s);
       lstrcat(s,";");
       WriteRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\IEXPLORE.EXE","Path",s);
     }
  else
     {
       DeleteRegKey(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\IEXPLORE.EXE");
     }
  
  const char *subname = "BodyIE";
  const char *path = "$bodywb";
  RegUnregExtensions(state,subname,path,1,"Internet File",safe_ie_exts);
  RegUnregProtocols(state,subname,path,safe_ie_protos);
}


static void MPDisable(BOOL state,void *p1,void *p2,void *p3)
{
  const char *subname = "BodyMediaPlayer";
  const char *path = alternate_mp[0] ? alternate_mp : "$bodymp";
  int icon_idx = alternate_mp[0] ? 0 : 1;

  char exts[MAX_PATH*2];

  lstrcpy(exts,safe_mp_exts);

  // add special winamp extensions
  if ( 1 )
     {
       int n, count = 0;
       char **winamp_exts = ConvertList2Ar(safe_mp_exts_winamp,&count,FALSE);

       for ( n = 0; n < count; n++ )
           {
             if ( lstrlen(winamp_exts[n]) > 0 )
                {
                  char s[MAX_PATH];
                  char t[MAX_PATH];
                  BOOL iswinamp;

                  lstrcpy(t,".");
                  lstrcat(t,winamp_exts[n]);
                  ZeroMemory(s,sizeof(s));
                  ReadRegStr(HKCR,t,NULL,s,"");
                  s[6] = 0;
                  iswinamp = !lstrcmpi(s,"Winamp");

                  if ( !iswinamp )
                     {
                       if ( lstrlen(exts) > 0 && exts[lstrlen(exts)-1] != ';' && exts[lstrlen(exts)-1] != ',' )
                          lstrcat(exts,";");
                       lstrcat(exts,winamp_exts[n]);
                     }
                }
           }

       FreeListAr(winamp_exts,count);
     }

  RegUnregExtensions(state,subname,path,icon_idx,"Media File",exts);
  RegUnregProtocols(state,subname,path,safe_mp_protos);
}


static void NotepadDisable(BOOL state,void *p1,void *p2,void *p3)
{
  RegUnregExtensions(state,"BodyNotepad","$bodynotepad",1,"Text Document",safe_notepad_exts);
}


static void ImgViewDisable(BOOL state,void *p1,void *p2,void *p3)
{
  const char *exts = "bmp;png;jpg;jpeg;jpe;gif;tif;tiff";
  RegUnregExtensions(state,"BodyImgView","$bodyimgview",1,"Picture File",exts);
}


static void PDFViewDisable(BOOL state,void *p1,void *p2,void *p3)
{
  const char *exts = "pdf";
  RegUnregExtensions(state,"BodyAcro","$bodyacro",1,"PDF Document",exts);
}


static void SWFFlashDisable(BOOL state,void *p1,void *p2,void *p3)
{
  const char *exts = "swf";
  RegUnregExtensions(state,"BodyFlash","$bodyflash",1,"Flash Movie",exts);
}


static void RegisterOfficeAddin(const char *key,BOOL state)
{
  if ( state )
     {
       WriteRegStr(HKCU,key,"FriendlyName","BodyOffice AddIn");
       WriteRegDword(HKCU,key,"LoadBehavior",3);
     }
  else
     {
       DeleteRegKey(HKCU,key);
     }
}


static BOOL IsOldOfficeInstalled(void)
{
  char s[MAX_PATH];

  ReadRegStr(HKCR,"Word.Application\\CurVer",NULL,s,"");

  if ( !lstrcmpi(s,"Word.Application.9") )
     return TRUE;
  else
     return FALSE;
}


static void OfficeDisable(BOOL state,void *p1,void *p2,void *p3)
{
  #define OLD_OFFICE_PROGID "BodyOffice.DTExtensibility2"
  #define OFFICE2003_PROGID "BodyOffice2003.DTExtensibility2"
  #define OFFICE2000_PROGID "BodyOffice2000.DTExtensibility2"
  #define WORD_ADDINSPATH  "Software\\Microsoft\\Office\\Word\\Addins\\"
  #define EXCEL_ADDINSPATH "Software\\Microsoft\\Office\\Excel\\Addins\\"

  RegisterOfficeAddin(WORD_ADDINSPATH OLD_OFFICE_PROGID,FALSE);  // remove from old versions
  RegisterOfficeAddin(EXCEL_ADDINSPATH OLD_OFFICE_PROGID,FALSE); // remove from old versions

  RegisterOfficeAddin(WORD_ADDINSPATH OFFICE2000_PROGID,FALSE);
  RegisterOfficeAddin(EXCEL_ADDINSPATH OFFICE2000_PROGID,FALSE);
  RegisterOfficeAddin(WORD_ADDINSPATH OFFICE2003_PROGID,FALSE);
  RegisterOfficeAddin(EXCEL_ADDINSPATH OFFICE2003_PROGID,FALSE);
  
  if ( state )
     {
       if ( IsOldOfficeInstalled() )
          {
            RegisterOfficeAddin(WORD_ADDINSPATH OFFICE2000_PROGID,TRUE);
            RegisterOfficeAddin(EXCEL_ADDINSPATH OFFICE2000_PROGID,TRUE);
          }
       else
          {
            RegisterOfficeAddin(WORD_ADDINSPATH OFFICE2003_PROGID,TRUE);
            RegisterOfficeAddin(EXCEL_ADDINSPATH OFFICE2003_PROGID,TRUE);
          }
     }

  #undef OLD_OFFICE_PROGID
  #undef OFFICE2003_PROGID
  #undef OFFICE2000_PROGID
  #undef WORD_ADDINSPATH
  #undef EXCEL_ADDINSPATH
}


static void ShellExecuteDisable(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       AdminAccessWriteRegDword(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","EnableShellExecuteHooks",1);
     }
  else
     {
       AdminAccessDeleteRegValue(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","EnableShellExecuteHooks");
     }
}


static void CopyHookDisable(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       WriteRegStr(HKCU,REG_CLASSES "Directory\\Shellex\\CopyHookHandlers\\RunpadCopyHook",NULL,"{CE2606AC-0A84-4272-97B0-04FF67BA05B6}");
       AdminAccessWriteRegDword(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","AllowFileCLSIDJunctions",1);
     }
  else
     {
       AdminAccessDeleteRegValue(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","AllowFileCLSIDJunctions");
       DeleteRegKey(HKCU,REG_CLASSES "Directory\\Shellex\\CopyHookHandlers\\RunpadCopyHook");
     }
}


static void SetRegKey(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     AdminAccessWriteRegDword((HKEY)p1,(char*)p2,(char*)p3,1);
  else
     AdminAccessDeleteRegValue((HKEY)p1,(char*)p2,(char*)p3);
}


static void SetRegKeyAutorun(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     AdminAccessWriteRegDword((HKEY)p1,(char*)p2,(char*)p3,0x03FFFFFF);
  else
     AdminAccessDeleteRegValue((HKEY)p1,(char*)p2,(char*)p3);
}


static void DialogBoxesLite(BOOL state,void *p1,void *p2,void *p3)
{
  AdminAccessDeleteRegKey(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Comdlg32");
  
  if ( state )
     {
       //AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Comdlg32","NoFileMRU",1);  //CorelDraw uncompatible!
       AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Comdlg32","NoBackButton",1);
       //if ( !user_folder[0] )
          AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Comdlg32","NoPlacesBar",1);
       //else
       //   AdminAccessWriteRegStr(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Comdlg32\\PlacesBar","Place0",user_folder);
       AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","DisableThumbnails",1);
     }
  else
     {
       AdminAccessDeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","DisableThumbnails");
     }
}


static void DialupPropertiesDisable(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       AdminAccessWriteRegDword(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_EnableAdminProhibits",1);
       AdminAccessWriteRegDword(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_RasMyProperties",0);
       AdminAccessWriteRegDword(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_RasAllUserProperties",0);
     }
  else
     {
       AdminAccessDeleteRegValue(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_EnableAdminProhibits");
       AdminAccessDeleteRegValue(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_RasMyProperties");
       AdminAccessDeleteRegValue(HKCU,"Software\\Policies\\Microsoft\\Windows\\Network Connections","NC_RasAllUserProperties");
     }
}


static void DisksRestrict(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoViewOnDrive",disks_disabled);
       AdminAccessWriteRegDword(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoDrives",disks_hidden);
     }
  else
     {
       AdminAccessDeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoViewOnDrive");
       AdminAccessDeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer","NoDrives");
     }
}


static void DialogBoxesProcess(BOOL state,void *p1,void *p2,void *p3)
{
  SetDialogsHook(state);
  SetDialogsHook64(state);
}


static void WinampProcess(BOOL state,void *p1,void *p2,void *p3)
{
  SetWinampHook(state);
}


static void MPlayercProcess(BOOL state,void *p1,void *p2,void *p3)
{
  SetMPlayercHook(state);
}


static void PowerDVDProcess(BOOL state,void *p1,void *p2,void *p3)
{
  SetPowerDVDHook(state);
}


static void TorrentProcess(BOOL state,void *p1,void *p2,void *p3)
{
  SetTorrentHook(state);
}


static void ConsoleProcess(BOOL state,void *p1,void *p2,void *p3)
{
#ifndef DEBUG
  SetConsoleHook(state);
#endif
}


static std::set<HWND> g_opensavedlgs;


static BOOL IsRunpadWrapperWindow(HWND hwnd)
{
  return (g_opensavedlgs.find(hwnd) != g_opensavedlgs.end()) || GetProp(hwnd,"_RunpadOpenSaveDialogBox") || GetProp(hwnd,"_RPMessageBoxProp");
}


static void SafeWinamp(void)
{
  char s_class[MAX_PATH];
  char s_win[MAX_PATH];
  HWND hwnd,owner;
  
  if ( !safe_winamp )
     return;

  hwnd = FindWindow("Winamp MB",NULL);
  if ( hwnd && IsWindowVisible(hwnd) )
     SendMessage(FindWindow("Winamp v1.x",NULL),WM_COMMAND,40298,40298);
//  hwnd = FindWindow("Winamp EQ",NULL);
//  if ( hwnd && IsWindowVisible(hwnd) )
//     SendMessage(FindWindow("Winamp v1.x",NULL),WM_COMMAND,40036,40036);
  hwnd = FindWindow("BaseWindow_RootWnd","Media Library");
  if ( hwnd && IsWindowVisible(hwnd) )
     //SendMessage(FindWindow("Winamp v1.x",NULL),WM_COMMAND,40380,40380);
     ShowWindow(hwnd,SW_HIDE);
  hwnd = FindWindow("Winamp Gen",NULL);
  if ( hwnd && IsWindowVisible(hwnd) )
     //SendMessage(FindWindow("Winamp v1.x",NULL),WM_COMMAND,40380,40380);
     ShowWindow(hwnd,SW_HIDE);

  hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  s_class[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));

  if ( lstrcmpi(s_class,"#32770") )
     return;

  owner = GetTopOwner(hwnd);
  if ( !owner )
     return;
  
  s_class[0] = 0;
  GetClassName(owner,s_class,sizeof(s_class));

  if ( !lstrcmpi(s_class,"Winamp v1.x") )
     {
       s_win[0] = 0;
       GetWindowText(hwnd,s_win,sizeof(s_win));

       if ( lstrcmpi(s_win,"Jump to file") )
          {
            if ( !IsRunpadWrapperWindow(hwnd) )
               {
                 if ( GetWindowLong(hwnd,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
                    ShowWindowAsync(hwnd,SW_HIDE);
                 PostMessage(hwnd,WM_CLOSE,0,0);
               }
          }
     }
}



static void SafeMplayerc(void)
{
  char s_class[MAX_PATH];
  char s_win[MAX_PATH];
  HWND hwnd,owner;
  
  if ( !safe_mplayerc )
     return;

  hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  s_class[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));

  if ( !lstrcmpi(s_class,"MediaPlayerClassicW") || 
       !lstrcmpi(s_class,"MediaPlayerClassicA") || 
       !lstrcmpi(s_class,"MediaPlayerClassic") )
     {
       HMENU menu = GetMenu(hwnd);
       if ( menu )
          {
            int n,count = GetMenuItemCount(menu);
            BOOL changed = FALSE;

            for ( n = 0; n < count; n++ )
                {
                  int rc, mask = MF_DISABLED | MF_GRAYED;
                  
                  rc = EnableMenuItem(menu,n,MF_BYPOSITION | mask);

                  if ( rc != -1 && rc != mask )
                     changed = TRUE;
                }

            if ( changed )
               DrawMenuBar(hwnd);
          }
     }

  if ( lstrcmpi(s_class,"#32770") )
     return;

  owner = GetTopOwner(hwnd);
  if ( !owner )
     return;
  
  s_class[0] = 0;
  GetClassName(owner,s_class,sizeof(s_class));

  if ( !lstrcmpi(s_class,"MediaPlayerClassicW") || 
       !lstrcmpi(s_class,"MediaPlayerClassicA") || 
       !lstrcmpi(s_class,"MediaPlayerClassic") )
     {
       if ( !IsRunpadWrapperWindow(hwnd) )
          {
            if ( GetWindowLong(hwnd,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
               ShowWindowAsync(hwnd,SW_HIDE);
            PostMessage(hwnd,WM_CLOSE,0,0);
          }
     }
}


static void SafePowerDVD(void)
{
  char s_class[MAX_PATH];
  char s_win[MAX_PATH];
  HWND hwnd,owner;
  
  if ( !safe_powerdvd )
     return;

  hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  s_class[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));

  if ( lstrcmpi(s_class,"#32770") )
     return;

  owner = GetTopOwner(hwnd);
  if ( !owner )
     return;
  
  s_class[0] = 0;
  GetClassName(owner,s_class,sizeof(s_class));

  if ( !lstrcmpi(s_class,"Class of CyberLink Universal Player") || 
       !lstrcmpi(s_class,"CyberLink Video Window Class") )
     {
       if ( !IsRunpadWrapperWindow(hwnd) )
          {
            if ( GetWindowLong(hwnd,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
               ShowWindowAsync(hwnd,SW_HIDE);
            PostMessage(hwnd,WM_CLOSE,0,0);
          }
     }
}


static void CloseSingleWindow(HWND hwnd)
{
  char s_class[MAX_PATH];
  char s_win[MAX_PATH];
  int n,is_class,is_win;
  int processed;
  DWORD pid = -1;

  if ( !hwnd || !IsWindow(hwnd) )
     return;
  
  if ( !IsWindowVisible(hwnd) )
     return;

  if ( GetWindowLong(hwnd,GWL_USERDATA) == MAGIC_WID )
     return;

  if ( GetWindowLong(GetParent(hwnd),GWL_USERDATA) == MAGIC_WID )
     return;

  if ( GetWindowLong(GetWindow(hwnd,GW_OWNER),GWL_USERDATA) == MAGIC_WID )
     return;

  GetWindowThreadProcessId(hwnd,&pid);
  if ( pid == GetCurrentProcessId() )
     return;
     
  s_class[0] = 0;
  s_win[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));
  GetWindowText(hwnd,s_win,sizeof(s_win));
  processed = 0;

  for ( n = 0; n < disable_windows.size(); n++ )
      {
        CCfgEntry2 *w = &disable_windows[n];
        if ( w->GetState() )
           {
             is_class = w->GetParm1()[0];
             is_win = w->GetParm2()[0];

             if ( !is_class && !is_win )
                continue;
             
             if ( is_class && !PathMatchSpec(s_class,w->GetParm1()) )
                continue;

             if ( is_win && !PathMatchSpec(s_win,w->GetParm2()) )
                continue;

             if ( GetWindowLong(hwnd,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
                ShowWindowAsync(hwnd,SW_HIDE);
             PostMessage(hwnd,WM_CLOSE,0,0);

             processed = 1;
             break;
           }
      }

  if ( !processed )
     {
       if ( close_ie_when_nosheet && !IsInternetSheetPresentAndEnabled() )
          {
            if ( !lstrcmpi(s_class,"IEFrame") || 
                 !lstrcmpi(s_class,"OpWindow") || 
                 !lstrcmpi(s_class,"MozillaUIWindowClass") || 
                 !lstrcmpi(s_class,"MozillaWindowClass") || 
                 !lstrcmpi(s_class,"TBodyIEForm") || 
                 !lstrcmpi(s_class,"TBodyMailForm") ||
                 !lstrcmpi(s_class,"OperaWindowClass") ||
                 !lstrcmpi(s_class,"Chrome_XPFrame") /*Chrome 1.x*/ ||
                 PathMatchSpec(s_class,"Chrome_WidgetWin_?") /*Chrome 2.x*/ ||
                 !lstrcmpi(s_class,"Chrome_WindowImpl_0") /*Chrome 4.x*/ ||
                 !lstrcmpi(s_class,"{1C03B488-D53B-4a81-97F8-754559640193}") /*Safari*/
                 )
               {
                 if ( !GetProp(hwnd,"_NoClose") )
                    {
                      #if 0
                      char filename[MAX_PATH] = "";
                      GetWindowProcessFileName(hwnd,filename);
                      if ( lstrcmpi(PathFindFileName(filename),"OperaPortable.exe") )
                      #endif
                         {
                           PostMessage(hwnd,WM_CLOSE,0,0);
                         }
                    }
               }
          }
     }
}



static BOOL CALLBACK CloseCallbackProc(HWND hwnd,LPARAM lParam)
{
  CloseSingleWindow(hwnd);
  return TRUE;
}



static void CloseWindows(void)
{
  if ( !close_not_active_windows )
     {
       CloseSingleWindow(GetForegroundWindow());
     }
  else
     {
       EnumWindows(CloseCallbackProc,0);
     }
}


static void BrowseToFolderInDialog(const char *folder,HWND hwnd,HWND select,int mso,int corel)
{
  if ( !mso )
     {
       // standard dialog
       char t[MAX_PATH];
       char s[MAX_PATH];
       int idok = SendMessage(hwnd,DM_GETDEFID,0,0) & 0xFFFF;

       if ( !idok )
          idok = IDOK;

       t[0] = 0;
       SendMessage(select,WM_GETTEXT,sizeof(t),(int)t);

       if ( idok )
          {
            SendMessage(select,WM_SETTEXT,0,(int)folder);

            if ( corel )
               SendMessage(GetParent(select),WM_COMMAND,MAKELONG(GetDlgCtrlID(select),EN_CHANGE),(int)select);
            
            SendMessage(hwnd,WM_COMMAND,MAKELONG(idok,BN_CLICKED),(int)GetDlgItem(hwnd,idok));

            if ( corel )
               Sleep(400);

            if ( 1/*vista*/ )
               Sleep(50);

            SendMessage(select,WM_SETTEXT,0,(int)t);
            SendMessage(select,EM_SETSEL,0,-1);
            //SendMessage(control,EM_SETSEL,-1,0);

            if ( corel )
               SendMessage(GetParent(select),WM_COMMAND,MAKELONG(GetDlgCtrlID(select),EN_CHANGE),(int)select);
          }
       else
          {
            lstrcpy(s,folder);
            PathAddBackslash(s);
            lstrcat(s,t);

            SendMessage(select,WM_SETTEXT,0,(int)s);
            SendMessage(select,EM_SETSEL,0,-1);
            SendMessage(select,EM_SETSEL,-1,0);
          }
     }
  else
     {
       // MS office dialog

       char t[MAX_PATH];

       t[0] = 0;
       SendMessage(select,WM_GETTEXT,sizeof(t),(int)t);

       SendMessage(select,WM_SETTEXT,0,(int)folder);
       SendMessage(select,WM_KEYDOWN,VK_RETURN,0x001C0001);
       Sleep(1);
       SendMessage(select,WM_KEYUP,VK_RETURN,0xC01C0001);
       Sleep(400); // todo: find better way
       SendMessage(select,WM_SETTEXT,0,(int)t);
       SendMessage(select,EM_SETSEL,0,-1);
     }
}



static void DialogBoxReqProcessing(HWND hwnd,HWND select,BOOL mso,BOOL icq,BOOL corel)
{
  int rc;
  BOOL is_user_folder;
  char dest_path[MAX_PATH];
  char user_folder[MAX_PATH];
  char s[MAX_PATH*2];
  char sel_name[MAX_PATH];

  if ( !IsWindow(hwnd) )
     return;
  
  ShowWindow(hwnd,SW_HIDE);

  dest_path[0] = 0;
  sel_name[0] = 0;
  
  rc = RPOpenSaveDialog(hwnd,LS(3067),LS(3068),dest_path,sel_name);
  
  if ( rc == RPOPENSAVE_CANCEL )
     {
       PostMessage(hwnd,WM_CLOSE,0,0);
       return;
     }

  is_user_folder = (rc == RPOPENSAVE_USERFOLDER);

  if ( !dest_path[0] )
     {
       PostMessage(hwnd,WM_CLOSE,0,0);
       return;
     }

  if ( !IsWindow(hwnd) )
     return;

  if ( is_user_folder )
     lstrcpy(user_folder,dest_path);
  else
     GetUserFolderPath(user_folder,0);

  if ( !icq )
     {
       if ( user_folder[0] )
          BrowseToFolderInDialog(user_folder,hwnd,select,mso,corel);

       if ( !is_user_folder )
          {
            if ( 1/*vista*/ )
               Sleep(400);
           
            BrowseToFolderInDialog(dest_path,hwnd,select,mso,corel);
          }
     }
  else
     {
       BrowseToFolderInDialog(dest_path,hwnd,select,mso,corel);
     }

  s[0] = 0;
  GetWindowText(hwnd,s,MAX_PATH);
  lstrcat(s," - ");
  lstrcat(s,sel_name);
  SetWindowText(hwnd,s);

  ShowWindow(hwnd,SW_SHOW);
}


typedef struct {
HWND hwnd;
HWND select;
BOOL mso;
BOOL icq;
BOOL corel;
} DIALOGBOXTHREADINFO;



static DWORD WINAPI DialogBoxThread(LPVOID lpParameter)
{
  DIALOGBOXTHREADINFO *info = (DIALOGBOXTHREADINFO*)lpParameter;

  if ( info )
     DialogBoxReqProcessing(info->hwnd,info->select,info->mso,info->icq,info->corel);

  sys_free(info);
  return 1;
}


static BOOL CALLBACK FindMSOSelect(HWND hwnd,LPARAM lParam)
{
  if ( IsWindowVisible(hwnd) )
     {
       char t[MAX_PATH];

       t[0] = 0;
       GetClassName(hwnd,t,sizeof(t));
       t[8] = 0;

       if ( !lstrcmpi(t,"RichEdit") )
          {
            *(HWND*)lParam = hwnd;
            return FALSE;
          }
     }

  return TRUE;
}


static BOOL DeleteToolbarButton(HWND tool,int cmdid)
{
  BOOL rc = FALSE;
  
  if ( tool )
     {
       int idx = -1;
       
       if ( SendMessageTimeout(tool,TB_COMMANDTOINDEX,cmdid,0,SMTO_ABORTIFHUNG|SMTO_BLOCK,2000,(PDWORD_PTR)&idx) )
          {
            if ( idx != -1 )
               {
                 BOOL res = FALSE;
                 if ( SendMessageTimeout(tool,TB_DELETEBUTTON,idx,0,SMTO_ABORTIFHUNG|SMTO_BLOCK,2000,(PDWORD_PTR)&res) )
                    {
                      rc = res;
                    }
               }
          }
     }

  return rc;
}


static void ProcessOpenSaveDlgToolbarInternal(HWND tool)
{
  if ( tool )
     {
       BOOL need_hide = TRUE;
       
       if ( allow_newfolder_opensave )
          {
            int id = GetDlgCtrlID(tool);
            if ( id == 0x440 || id == 0x1 )
               {
                 BOOL rc1 = DeleteToolbarButton(tool,0xA001);
                 BOOL rc2 = DeleteToolbarButton(tool,0xA009);
                 BOOL rc3 = DeleteToolbarButton(tool,0xA00B);
                 
                 if ( rc1 || rc2 || rc3 )
                    {
                      need_hide = FALSE;
                    }
               }
          }
       
       if ( need_hide )
          {
            EnableWindow(tool,FALSE);
            ShowWindow(tool,SW_HIDE);
          }
     }
}

typedef struct {
const char *classname;
HWND result;
} ENUMCHWSTR;


BOOL CALLBACK FindChildWindowRecCB(HWND hwnd,LPARAM lParam)
{
  ENUMCHWSTR *pi = (ENUMCHWSTR*)lParam;
  
  char s[MAX_PATH] = "";
  GetClassName(hwnd,s,sizeof(s));

  if ( !lstrcmpi(pi->classname,s) )
     {
       pi->result = hwnd;
     }
  else
     {
       EnumChildWindows(hwnd,FindChildWindowRecCB,lParam);
     }

  return pi->result ? FALSE : TRUE;
}


HWND FindChildWindowRec(HWND parent,const char *classname)
{
  ENUMCHWSTR i;

  i.classname = classname;
  i.result = NULL;

  EnumChildWindows(parent,FindChildWindowRecCB,(LPARAM)&i);

  return i.result;
}


static void CheckDialogBoxes(void)
{
  HWND hwnd,select;
  char s_process[MAX_PATH];
  char s_class[MAX_PATH];
  char s_win[MAX_PATH];
  char s[MAX_PATH];
  char t[MAX_PATH];
  int mso_window = 0;
  int icq_window = 0;
  int corel_window = 0;
  BOOL do_catch;
  
  if ( !restrict_file_dialogs )
     return;

  hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  if ( GetWindowLong(hwnd,GWL_USERDATA) == MAGIC_WID )
     return;

  if ( GetWindowLong(GetParent(hwnd),GWL_USERDATA) == MAGIC_WID )
     return;

  if ( GetWindowLong(GetWindow(hwnd,GW_OWNER),GWL_USERDATA) == MAGIC_WID )
     return;

  if ( IsRunpadWrapperWindow(hwnd) )
     return;

  s_class[0] = 0;
  s_win[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));
  GetWindowText(hwnd,s_win,sizeof(s_win));

  lstrcpy(t,s_class);
  t[10] = 0;
  if ( !lstrcmpi(t,"bosa_sdm_M") || !lstrcmpi(t,"bosa_sdm_X") )
     {
       // MS Office dialog
       HWND tool1,tool2,snake,lv;

       select = GetDlgItem(hwnd,0x36);
       t[0] = 0;
       GetClassName(select,t,sizeof(t));
       t[8] = 0;
       if ( !select || !IsWindowVisible(select) || lstrcmpi(t,"RichEdit") )
          {
            select = NULL;
            EnumChildWindows(hwnd,FindMSOSelect,(int)&select);
          }
       if ( !select )
          return;

       tool1 = FindWindowEx(hwnd,NULL,"MsoCommandBar",NULL);
       tool2 = FindWindowEx(hwnd,tool1,"MsoCommandBar",NULL);

       snake = FindWindowEx(hwnd,NULL,"Snake List",NULL);
       if ( !snake )
          snake = hwnd;

       if ( (lv = FindWindowEx(snake,NULL,"SHELLDLL_DefView",NULL)) )
          lv = FindWindowEx(lv,NULL,"SysListView32",NULL);
       else
          lv = FindWindowEx(snake,NULL,"OpenListView",NULL);

       if ( !lv )
          return;

       SetWindowLong(lv,GWL_STYLE,GetWindowLong(lv,GWL_STYLE) & ~LVS_EDITLABELS);
       DragAcceptFiles(lv,FALSE);

       if ( tool1 )
          {
            EnableWindow(tool1,FALSE);
            //ShowWindow(tool1,SW_HIDE);
          }
   
       if ( tool2 )
          {
            EnableWindow(tool2,FALSE);
            //ShowWindow(tool2,SW_HIDE);
          }

       mso_window = 1;
     }
  else
  if ( !lstrcmpi(s_class,"#32770") )
     {
       // standard dialog
       HWND tool1,tool2,cmb,lv,stc;

       tool1 = FindWindowEx(hwnd,NULL,"ToolbarWindow32",NULL);
       tool2 = FindWindowEx(hwnd,tool1,"ToolbarWindow32",NULL);

       select = GetDlgItem(hwnd,edt1);
       if ( !select || !IsWindowVisible(select) )
          select = NULL;
       if ( !select )
          {
            select = GetDlgItem(hwnd,cmb13);
            if ( !select || !IsWindowVisible(select) )
               select = NULL;
          }
       if ( !select )
          {
            select = GetDlgItem(hwnd,0xB5);
            if ( !select || !IsWindowVisible(select) )
               select = NULL;
            else
               icq_window = 1;
          }
       if ( !select )
          {
            HWND t = FindWindowEx(hwnd,NULL,"#32770",NULL);
            if ( t )
               {
                 select = GetDlgItem(t,0x81C);
                 if ( !select || !IsWindowVisible(select) )
                    select = NULL;
                 else
                    {
                      select = FindWindowEx(select,NULL,"Edit",NULL);
                      if ( !select || !IsWindowVisible(select) )
                         select = NULL;
                      else
                         corel_window = 1;
                    }
               }
            else
               {
                 HWND t = FindWindowEx(hwnd,NULL,"DUIViewWndClassName",NULL);
                 if ( t )
                    {
                      select = FindChildWindowRec(t,"Edit");  // OpenOffice
                    }
               }
          }
       if ( !select )
          return;

       lv = FindChildWindowRec(hwnd,"SHELLDLL_DefView");
       
       if ( !lv )
          return;
       else
          {
            lv = FindWindowEx(lv,NULL,"SysListView32",NULL);
            if ( lv )
               {
                 SetWindowLong(lv,GWL_STYLE,GetWindowLong(lv,GWL_STYLE) & ~LVS_EDITLABELS);
                 DragAcceptFiles(lv,FALSE);
               }
          }

       ProcessOpenSaveDlgToolbarInternal(tool1);
       ProcessOpenSaveDlgToolbarInternal(tool2);
       
       cmb = GetDlgItem(hwnd,cmb2);
       if ( cmb )
          {
            EnableWindow(cmb,FALSE);
            ShowWindow(cmb,SW_HIDE);
          }

       stc = GetDlgItem(hwnd,stc4);
       if ( stc )
          {
            ShowWindow(stc,SW_HIDE);
          }

       tool1 = FindWindowEx(hwnd,NULL,"#32770",NULL);
       if ( tool1 && !corel_window )
          EnableWindow(tool1,FALSE);   

       mso_window = 0;
     }
  else
     return;

  if ( !SetProp(hwnd,"_RunpadOpenSaveDialogBox",(HANDLE)select) && GetLastError() == ERROR_ACCESS_DENIED )
     {
       g_opensavedlgs.insert(hwnd);
     }

  lstrcpy(s,"< ");
  lstrcat(s,s_win);
  lstrcat(s," >");
  SetWindowText(hwnd,s);

  do_catch = TRUE;
  
  s_process[0] = 0;
  GetWindowProcessFileName(hwnd,s_process);
  if ( !IsStrEmpty(s_process) )
     {
       int n,count = 0;
       char **ar = ConvertList2Ar(apps_opensave_prohibited,&count,FALSE);

       for ( n = 0; n < count; n++ )
           {
             if ( !lstrcmpi(PathFindFileName(ar[n]),PathFindFileName(s_process)) )
                {
                  do_catch = FALSE;
                  break;
                }
           }

       FreeListAr(ar,count);
     }

  if ( do_catch )
     {
       HANDLE h;
       DWORD id;
       DIALOGBOXTHREADINFO *pInfo = (DIALOGBOXTHREADINFO*)sys_alloc(sizeof(*pInfo));
       pInfo->hwnd = hwnd;
       pInfo->select = select;
       pInfo->mso = mso_window;
       pInfo->icq = icq_window;
       pInfo->corel = corel_window;

       h = MyCreateThreadSelectedCPU(DialogBoxThread,(void*)pInfo,&id);
       CloseHandle(h);
     }
  else
     {
       PostMessage(hwnd,WM_CLOSE,0,0);
     }
}


static BOOL IsMainTorrentWindow(HWND hwnd,BOOL can_set)
{
  BOOL rc = FALSE;

  if ( hwnd && IsWindow(hwnd) )
     {
       if ( GetProp(hwnd,"IsTorrentWnd") )
          {
            rc = TRUE;
          }
       else
          {
            if ( can_set )
               {
                 char s_class[MAX_PATH];
                 s_class[0] = 0;
                 GetClassName(hwnd,s_class,sizeof(s_class));

                 if ( StrStrI(s_class,"Torrent482") || StrStrI(s_class,"BT482") )
                    {
                      char s_win[MAX_PATH];
                      s_win[0] = 0;
                      GetWindowText(hwnd,s_win,sizeof(s_win));

                      if ( StrStrI(s_win,"Torrent") ) //needed?
                         {
                           SetProp(hwnd,"IsTorrentWnd",(HANDLE)1);
                           rc = TRUE;
                         }
                    }
               }
          }
     }

  return rc;
}


static void SafeTorrent(void)
{
  if ( !safe_torrent )
     return;

  HWND hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  IsMainTorrentWindow(hwnd,TRUE); //mark window if needed

  char s_class[MAX_PATH];
  s_class[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));
  if ( !lstrcmpi(s_class,"#32770") )
     {
       HWND owner = GetWindow(hwnd,GW_OWNER);
       if ( owner && IsMainTorrentWindow(owner,TRUE/*FALSE*/) )
          {
            char s_win[MAX_PATH];
            s_win[0] = 0;
            GetWindowText(hwnd,s_win,sizeof(s_win));

            if ( StrStrI(s_win,"Preferences") || StrStrI(s_win,"Настройки") || StrStrI(s_win,"Уподобання") || StrStrI(s_win,"Налаштування") ||
                 StrStrI(s_win,"Torrent Properties") || StrStrI(s_win,"Свойства торрента") || StrStrI(s_win,"Властивості торента") ||
                 StrStrI(s_win,"RSS Downloader") || StrStrI(s_win,"RSS загрузчик") || StrStrI(s_win,"Диспетчер RSS-рассылок") || StrStrI(s_win,"Завантажувач RSS") ||
                 StrStrI(s_win,"Add RSS Feed") || StrStrI(s_win,"Добавить RSS-рассылку") || StrStrI(s_win,"Додати RSS стрічку") || 
                 StrStrI(s_win,"Enter logfile") || StrStrI(s_win,"Ведение файла журнала") || StrStrI(s_win,"Введіть файл журналу") ||
                 !lstrcmpi(s_win,"Create New Torrent") || !lstrcmpi(s_win,"Создать новый торрент") || !lstrcmpi(s_win,"Створити новий Torrent") ||
                                                          !lstrcmpi(s_win,"Новый торрент")
                )
               {
                 PostMessage(hwnd,WM_CLOSE,0,0);
               }
            else
            if ( StrStrI(s_win,"Add New Torrent") || 
                 StrStrI(s_win,"Добавление нового торрента") || StrStrI(s_win,"Добавить новый торрент") ||
                 StrStrI(s_win,"Додати новий торент")
               )
               {
                 if ( !GetProp(hwnd,"IsAddTorrentWnd") )
                    {
                      HWND w_combo = GetDlgItem(hwnd,0x4B1);
                      HWND w_edit = w_combo?FindWindowEx(w_combo,NULL,"Edit",NULL):NULL;
                      HWND w_select = GetDlgItem(hwnd,0x4B3);
                      HWND w_adv = GetDlgItem(hwnd,0x4B5);
                      HWND w_ok = GetDlgItem(hwnd,0x14);

                      if ( w_combo && w_edit && w_select && w_adv && w_ok )
                         {
                           SetProp(hwnd,"IsAddTorrentWnd",(HANDLE)1);
                           
                           ShowWindow(hwnd,SW_HIDE);

                           EnableWindow(w_combo,FALSE);
                           EnableWindow(w_select,FALSE);
                           EnableWindow(w_adv,FALSE);

                           char dest_path[MAX_PATH];
                           char sel_name[MAX_PATH];
                           
                           int rc = RPOpenSaveDialog(hwnd,LS(3211),LS(3210),dest_path,sel_name);

                           if ( IsWindow(hwnd) )
                              {
                                if ( rc == RPOPENSAVE_CANCEL || IsStrEmpty(dest_path) )
                                   {
                                     PostMessage(hwnd,WM_CLOSE,0,0);
                                   }
                                else
                                   {
                                     char s[MAX_PATH];
                                     s[0] = 0;
                                     SendMessage(w_edit,WM_GETTEXT,sizeof(s),(int)s);
                                     if ( IsStrEmpty(s) )
                                        lstrcpy(s,"New Folder");

                                     char ss[MAX_PATH];
                                     PathRemoveBackslash(s);
                                     lstrcpy(ss,PathFindFileName(s));
                                     
                                     // Multithread warning!
                                     const char *folder_name = GetStringParentHwnd(hwnd,LS(3212),LS(3213),0,200,ss);

                                     if ( IsWindow(hwnd) )
                                        {
                                          if ( IsStrEmpty(folder_name) )
                                             {
                                               PostMessage(hwnd,WM_CLOSE,0,0);
                                             }
                                          else
                                             {
                                               char s[MAX_PATH];

                                               lstrcpyn(s,folder_name,sizeof(s)-1);

                                               for ( int n = 0; n < lstrlen(s); n++ )
                                                   if ( s[n] == ':' || s[n] == '%' || s[n] == '?' || s[n] == '*' || s[n] == '.' )
                                                      s[n] = '_';
                                               if ( s[0] == ' ' )
                                                  s[0] = '_';

                                               char path[MAX_PATH];

                                               lstrcpy(path,dest_path);
                                               PathAppend(path,s);
                                               PathRemoveBackslash(path);
                                               
                                               SendMessage(w_edit,WM_SETTEXT,0,(int)path);

                                               ShowWindow(hwnd,SW_SHOW);
                                               SetForegroundWindow(hwnd);
                                               SetFocus(w_ok);
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }
}


static void SafeGarena(void)
{
  if ( !safe_garena )
     return;

  HWND hwnd = GetForegroundWindow();

  if ( !hwnd )
     return;

  if ( !IsWindowVisible(hwnd) )
     return;

  char s_class[MAX_PATH];
  s_class[0] = 0;
  GetClassName(hwnd,s_class,sizeof(s_class));
  if ( !lstrcmpi(s_class,"FrameDialog") )
     {
       char s_exe[MAX_PATH] = "";
       GetWindowProcessFileName(hwnd,s_exe);
       if ( !lstrcmpi(PathFindFileName(s_exe),"garena.exe") )
          {
            HWND w = GetDlgItem(hwnd,0x4E5);
            if ( w )
               {
                 s_class[0] = 0;
                 GetClassName(w,s_class,sizeof(s_class));
                 if ( !lstrcmpi(s_class,"Static") )
                    {
                      char s_text[MAX_PATH] = "";
                      GetWindowText(w,s_text,sizeof(s_text));

                      if ( !lstrcmpi(s_text,"System Setting") || !lstrcmpi(s_text,"System Settings") || !lstrcmpi(s_text,"Игровые настройки") )
                         {
                           PostMessage(hwnd,WM_CLOSE,0,0);
                         }
                    }
               }
          }
     }
  else
  if ( !lstrcmp(s_class,"SkinDialog") )
     {
       char s_exe[MAX_PATH] = "";
       GetWindowProcessFileName(hwnd,s_exe);
       if ( !lstrcmpi(PathFindFileName(s_exe),"garena_room.exe") )
          {
            HWND wd = FindWindowEx(hwnd,NULL,"#32770",NULL);
            if ( wd )
               {
                 HWND e1 = GetDlgItem(wd,0x498);
                 HWND e2 = GetDlgItem(wd,0x49C);
                 HWND e3 = GetDlgItem(wd,0x4A0);

                 if ( e1 && e2 && e3 )
                    {
                      char s_class1[MAX_PATH] = "";
                      char s_class2[MAX_PATH] = "";
                      char s_class3[MAX_PATH] = "";

                      GetClassName(e1,s_class1,sizeof(s_class1));
                      GetClassName(e2,s_class2,sizeof(s_class2));
                      GetClassName(e3,s_class3,sizeof(s_class3));

                      if ( !lstrcmpi(s_class1,"Edit") && !lstrcmpi(s_class2,"Edit") && !lstrcmpi(s_class3,"Edit") )
                         {
                           PostMessage(hwnd,WM_CLOSE,0,0);
                         }
                    }
               }
          }
     }
}


void ProcessRestricts(int reason)
{
  AboutBoxUpdateProgress(LS(3069));

  int flags = 0;
  BOOL state = FALSE;
  
  switch ( reason )
  {
    case RREASON_INSTALL:    
                             flags = RF_INSTALL;
                             state = TRUE;
                             break;
    case RREASON_UNINSTALL:
                             flags = RF_INSTALL;
                             state = FALSE;
                             break;
    case RREASON_STARTUP:
                             flags = RF_REGULAR | RF_STARTUPCRITICAL;
                             state = TRUE;
                             break;
    case RREASON_SHUTDOWN:
                             flags = IsOurShellTurnedOn() ? RF_REGULAR : (RF_REGULAR | RF_STARTUPCRITICAL);
                             state = FALSE;
                             break;
    case RREASON_OFFSHELL:
                             flags = RF_REGULAR | RF_STARTUPCRITICAL;
                             state = FALSE;
                             break;
  };

  for ( int n = 0; n < sizeof(restricts)/sizeof(restricts[0]); n++ )
      {
        RESTRICT *r = &restricts[n];
     
        if ( r->flags & flags )
           {
             if ( state )
                r->func(*(r->p_state),r->p1,r->p2,r->p3);
             else
                r->func(FALSE,r->p1,r->p2,r->p3);
           }
      }

  AboutBoxUpdateProgress("");
}


void UpdateRestricts(void)
{
  CloseDisallowProcesses();
  CloseWindows();
  CheckDialogBoxes();
  SafeWinamp();
  SafeMplayerc();
  SafePowerDVD();
  SafeTorrent();
  SafeGarena();
}
