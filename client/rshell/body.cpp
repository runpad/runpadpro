
#include "include.h"


#include "body_copydelete.inc"
#include "body_licman.inc"
#include "body_rules.inc"
#include "body_messages.inc"
#include "body_run.inc"
#include "body_net.inc"
#include "body_config.inc"
#include "body_fastexit.inc"
#include "body_turnshell.inc"



BOOL IsLicenseWithMO()
{
  return StrStrI(lic_feat,"Server") != NULL;
}


BOOL IsLicenseWithShell()
{
  return StrStrI(lic_feat,"NoShell") == NULL;
}


void GlobalOnSheetsStateChanged()
{
  CSheet *sh = GetActiveSheet();
  if ( sh && !sh->IsCurrentlyEnabled() )
     {
       CloseActiveSheet(FALSE);  // здесь возникает ситуация когда одновременно меняется и активность закладок
                                 // и их кол-во, что не всегда может поддерживаться схемой,
                                 // потому просто не обновляем схему, т.к. далее идет
                                 // полный Refresh()
     }

  WorkSpaceRefresh();
}


void GlobalOnTimerFast(void)
{
  WorkSpaceShow();
  UpdateRestricts();
  ClientRestore();
  ProcessMonitorPower();
}


void GlobalOnTimerSlow(void)
{
  TimeSheetsCheck();
  CheckTimeLimitations();
  CheckIdles();
  UpdateStat();
  UpdateStatusTextString();
  InjectFunctions();
  CloseHWWindow();
  PollWebCam();
  CFloatLic::Poll();
}


void GlobalOnTimerSuperFast(void)
{
  NetUpdate();
  ProcessHWIdents();
}


void InjectFunctions(void)
{
  InjectLocalDLLIntoProcessList32(inject_scan,"inj_scan.dll",FALSE,5);
}


const char* ExpandStatusText(const char *s)
{
  static char out[MAX_PATH];
  
  out[0] = 0;
  
  if ( !s || !s[0] )
     return out;

  lstrcpyn(out,s,sizeof(out));

  SYSTEMTIME tim;
  GetLocalTime(&tim);

  char t[MAX_PATH];
  wsprintf(t,"%02d:%02d",tim.wHour,tim.wMinute);
  StrReplaceI(out,"%TIME%",t);
  wsprintf(t,"%02d.%02d.%04d",tim.wDay,tim.wMonth,tim.wYear);
  StrReplaceI(out,"%DATE%",t);
  StrReplaceI(out,"%DOW%",GetDOWString(tim.wDayOfWeek));
  StrReplaceI(out,"%MACHINE%",machine_desc);
  StrReplaceI(out,"%RS_MACHINE%",machine_desc);
  StrReplaceI(out,"%RS_LOC%",machine_loc);
  StrReplaceI(out,"%LOC%",machine_loc);
  StrReplaceI(out,"%VIP%",vip_session);
  StrReplaceI(out,"%RS_VIPSESSION%",vip_session);
  StrReplaceI(out,"%MODE%",""); //bwc

  return out;
}


void UpdateStatusTextString()
{
  static char old[MAX_PATH] = "";

  const char *s = ExpandStatusText(html_status_text1);

  if ( lstrcmp(s,old) )
     {
       lstrcpyn(old,s,sizeof(old));
       WorkSpaceOnStatusStringChanged();
     }
}


// hhmm in H[H][:M[M]] format
static int GetAbsTimeFromHHMMStr(const char *hhmm)
{
  if ( IsStrEmpty(hhmm) )
     return -1;

  char s[20];
  lstrcpyn(s,hhmm,sizeof(s));

  int hh=-1, mm=-1;

  char *semicolon = StrChr(s,':');
  if ( semicolon )
     {
       *semicolon = ' ';
       sscanf(s,"%d %d",&hh,&mm);
     }
  else
     {
       sscanf(s,"%d",&hh);
       mm = 0;
     }

  if ( hh < 0 || hh > 23 )
     return -1;

  if ( mm < 0 || mm > 59 )
     return -1;

  return hh * 60 + mm;
}


static BOOL IsCurrentTimeIsInTimeIntervals(const char *limits)
{
  if ( IsStrEmpty(limits) )
     return FALSE;

  SYSTEMTIME st;
  GetLocalTime(&st);

  int now = st.wHour * 60 + st.wMinute;

  char s[MAX_PATH+1];
  ZeroMemory(s,sizeof(s)); // needed
  lstrcpy(s,limits);

  for ( int n = lstrlen(s)-1; n >= 0; n-- )
      {
        if ( s[n] == ',' || s[n] == ';' )
           {
             s[n] = 0;
           }
      }

  BOOL intersect = FALSE;

  const char *p = s;
  while ( *p )
  {
    // here p in H[H][:M[M]]-H[H][:M[M]] format
    const char *minus = StrChr(p,'-');
    if ( minus )
       {
         char s1[10];
         char s2[10];
         ZeroMemory(s1,sizeof(s1));
         ZeroMemory(s2,sizeof(s2));

         lstrcpyn(s1,p,MIN(minus-p+1,sizeof(s1)));
         lstrcpyn(s2,minus+1,MIN((p+lstrlen(p))-minus,sizeof(s2)));

         int t1 = GetAbsTimeFromHHMMStr(s1);
         int t2 = GetAbsTimeFromHHMMStr(s2);

         if ( t1 != -1 && t2 != -1 )
            {
              if ( t1 > t2 )
                 {
                   if ( (now >= t1 && now < 24*60) || (now >= 0 && now <= t2) )
                      {
                        intersect = TRUE;
                        break;
                      }
                 }
              else
                 {
                   if ( now >= t1 && now <= t2 )
                      {
                        intersect = TRUE;
                        break;
                      }
                 }
            }
       }

    p += lstrlen(p) + 1;
  };

  return intersect;
}


void CheckTimeLimitations()
{
  if ( use_time_limitation )
     {
       static BOOL b_shutdown_timer_started = FALSE;
       static unsigned shutdown_timer_starttime = 0;

       if ( !b_shutdown_timer_started )
          {
            if ( !IsCurrentTimeIsInTimeIntervals(time_limitation_intervals) )
               {
                 if ( !IsInShutdownState() )
                    {
                      b_shutdown_timer_started = TRUE;
                      shutdown_timer_starttime = GetTickCount();

                      WarnBox(LS(3238));
                    }
               }
          }
       else
          {
            if ( GetTickCount() - shutdown_timer_starttime > 60*1000 )
               {
                 b_shutdown_timer_started = FALSE; // paranoja

                 KillAllTasks();  // prevent from shutdown cancelation

                 if ( time_limitation_action == 0 )
                    {
                      InternalLogOff(FALSE);
                    }
                 else
                    {
                      DoShutdownAction(FALSE);
                    }
               }
          }
     }
}


void CheckIdles(void)
{
  LASTINPUTINFO i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);

  if ( GetLastInputInfo(&i) )
     {
       int delta = (GetTickCount() - i.dwTime) / 1000;

       // special check for GetLastInputInfo() bug after LogOff with Autologon turned on
       // and for Sleep/Hybernate
       static BOOL is_first_call = TRUE;
       static unsigned last_entry_time = 0;
       static BOOL is_bug_present = FALSE;
       static int bug_secs = 0;
       if ( is_first_call )
          {
            is_first_call = FALSE;

            last_entry_time = GetTickCount();
            
            if ( delta > 50 )
               {
                 is_bug_present = TRUE;
                 bug_secs = delta;
               }
          }

       if ( GetTickCount() - last_entry_time > 15000 )
          {
            if ( delta >= 15 )
               {
                 // probably Sleep/Hybernate was before
                 is_bug_present = TRUE;
                 bug_secs = delta;
               }
          }
       last_entry_time = GetTickCount();

       if ( is_bug_present )
          {
            if ( delta < bug_secs )
               {
                 is_bug_present = FALSE;
               }
          }
       if ( !is_bug_present )
          {
            // now we can process idles:
            if ( turn_off_idle != 0 )
               {
                 if ( delta > turn_off_idle * 60 )
                    {
                      if ( !monitor_off && !GetCopyDeleteThreadsCount() )
                         {
                           if ( !IsAppWindow(GetForegroundWindow()) && !IsFullScreenAppFind() )
                              {
                                if ( use_logoff_in_turn_off_idle )
                                   {
                                     InternalLogOff(FALSE);
                                   }
                                else
                                   {
                                     DoShutdownAction(FALSE);
                                   }
                              }
                         }
                    }
               }

            if ( close_sheet_idle != 0 && GetActiveSheet() != NULL )
               {
                 if ( delta > close_sheet_idle * 60 )
                    {
                      if ( !monitor_off && !IsFullScreenAppFind() )
                         {
                           CloseActiveSheet(TRUE);
                           CloseChildWindowsAsync();
                         }
                    }
               }

            if ( ssaver_idle != 0 )
               {
                 if ( delta > ssaver_idle * 60 )
                    {
                      if ( !monitor_off && !IsFullScreenAppFind() )
                         {
                           RunOurSSaver();
                         }
                    }
               }
          }
     }
}


void EnableSheetsFromAPI(const char *name,BOOL b_enable)
{
  CSheetsGuardAutoRefresh oGuard;
  
  if ( b_enable )
     {
       RemoveSheetFromDisableList(name);
     }
  else
     {
       AddSheetToDisableList(name);
     }
}


void SetSheetActiveByIdx(int idx, BOOL active)
{
  int real_idx = 0;

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         {
           if ( real_idx == idx )
              {
                CSheet *sheet = &g_content[n];
                
                if ( active )
                   {
                     SwitchToSheet(sheet);
                   }
                else
                   {
                     if ( GetActiveSheet() == sheet )
                        {
                          CloseActiveSheet(TRUE);
                        }
                   }

                break;
              }
           
           real_idx++;
         }
}


void SetSheetActiveByName(const char *desname)
{
  if ( !IsStrEmpty(desname) )
     {
       CSheet *sh = g_content.FindSheetByName(desname);
       if ( sh && sh->IsCurrentlyEnabled() )
          {
            SwitchToSheet(sh);
          }
     }
}


void SheetsSelectPopup()
{
  const int IDM_RESTORE = 1000;
  const int IDM_BASE = 1010;

  CPopupMenuWithODSeparator *menu = new CPopupMenuWithODSeparator();

  SYSTEMTIME st;
  GetLocalTime(&st);

  for ( int n = 0; n < g_content.GetCount(); n++ )
      if ( g_content[n].IsCurrentlyEnabled(&st) )
         {
           BOOL is_active = (GetActiveSheet() == &g_content[n]);
           menu->Add(is_active?MF_CHECKED:0,IDM_BASE+n,g_content[n].GetName());
         }
  
  menu->AddSeparator();
  menu->Add(0,IDM_RESTORE,LS(3001));     

  int rc = menu->Popup();

  delete menu;

  if ( rc )
     {
       if ( rc == IDM_RESTORE )
          {
            RestoreDisplayMode();
          }
       else
          {
            int idx = rc - IDM_BASE;
            if ( idx >= 0 && idx < g_content.GetCount() )
               {
                 if ( g_content[idx].IsCurrentlyEnabled() )
                    {
                      SwitchToSheet(&g_content[idx]);
                    }
               }
          }
     }
}


void TimeSheetsCheck(void)
{
  static SYSTEMTIME old_time = {0,};

  if ( old_time.wYear == 0 )
     {
       GetLocalTime(&old_time);
     }
  else
     {
       SYSTEMTIME t;
       GetLocalTime(&t);

       if ( t.wHour != old_time.wHour )
          {
            CreateUserFolder();
            SetShellEnvStrings();
            ScheduleScanDisk();
            CSheetsGuardAutoRefresh oGuard(&old_time);  //update sheets if needed
          }

       old_time = t;
     }
}


BOOL CanExecuteBodyToolWithSQLIntegrationOn(BOOL silent,BOOL check_protect_flag)
{
  if ( check_protect_flag && !protect_bodytools_when_nosql )
     return TRUE;

  if ( !sql_base_ready )
     {
       if ( !silent )
          ErrBoxTray(LS(3002));

       return FALSE;
     }

  return TRUE;
}


void DoShutdownAction(BOOL force)
{
  if ( shutdown_action == SHA_SHUTDOWN )
     Shutdown(force);
  else
  if ( shutdown_action == SHA_HIBERNATE )
     Hibernate(force);
  else
  if ( shutdown_action == SHA_SUSPEND )
     Suspend(force);
}


void M_Offersbook(void)
{
  ExecTool("$bodybook");
}


void M_Restore(void)
{
  RestoreDisplayMode();
}


void M_Reboot(void) 
{
  WorkSpaceRepaint();
  if ( ShaderConfirm(LS(3003)) )
     {
       WorkSpaceRepaint();
       Reboot(FALSE);
     }
}


void M_Shutdown(void) 
{
  WorkSpaceRepaint();
  if ( ShaderConfirm(LS(3004)) )
     {
       WorkSpaceRepaint();
       DoShutdownAction(FALSE);
     }
}


void M_Monitoroff(void)
{
  int n,rc;
  HICON icon;
  char list[300],*p;

  ZeroMemory(list,sizeof(list));
  p = list;
  for ( n = 1; n <= 20; n++ )
      {
        lstrcpy(p,IntToStr(n));
        p += lstrlen(p)+1;
      }
  
  icon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MONITOROFF));
  rc = RPMessageBox(GetMainWnd(),LS(3005),LS(3006),list,0,(UINT)icon);

  if ( rc != -1 )
     {
       char s[MAX_PATH];
       
       rc++;
       wsprintf(s,LS(3007),rc);
       if ( Confirm(s) )
          {
            TurnOffMonitor(1,rc*60*1000);
            SendDynamicInfoToServer();
          }
     }
}


void InternalLogOff(BOOL force)
{
  KillGGIfPresent(TRUE);
  LogOff(force);
}


void M_Logoff(void) 
{
  char s[300];
  char user[MAX_PATH];

  MyGetUserName(user);
  wsprintf(s,LS(3008),user);
  
  WorkSpaceRepaint();
  if ( ShaderConfirm(s) )
     {
       WorkSpaceRepaint();
       InternalLogOff(FALSE);
     }
}


void M_Mycomp(void)
{
  char s[MAX_PATH];

  if ( ExecutionMustBeProtectedBecauseClientNotLoaded() )
     {
       MsgBox(LS(3009));
       return;
     }

  if ( protect_run_from_api )
     {
       MsgBox(LS(3029));
       return;
     }

  ExecTool("$bodyexpl");
}


void M_Calladmin(void)
{
  char msg[MAX_PATH];
  wsprintf(msg,STR_001,machine_loc,machine_desc);
  SendMessageToOperator(msg,FALSE);
  MsgBox(LS(3010));
}


void M_Showgcinfo(void)
{
  HWND w = FindGCWindow();

  if ( w )
     {
       PostMessage(w,WM_USER+10,0,0);
     }
  else
     {
       MsgBox(LS(3011));
     }
}


void CAD_TaskManager(void)
{
  ExecTool("$bodytm");
}


void CAD_KillAllTasks(void)
{
  //CloseChildWindowsAsync();
  KillAllTasks();
}


void CAD_GCInfo(void)
{
  M_Showgcinfo();
}


void CAD_Reboot(void)
{
  Reboot(FALSE);
}


void CAD_Shutdown(void)
{
  DoShutdownAction(FALSE);
}


void CAD_LogOff(void)
{
  InternalLogOff(FALSE);
}


void CAD_MonitorOffTime(void)
{
  M_Monitoroff();
}


void DisplayFolder(const char *_path)
{
  char s[MAX_PATH];
  wsprintf(s,"\"%srsbrowser.exe\" \"%s\"",our_currpath,_path);
  RunProcess(s);
}


void NetRun(const CNetCmd &cmd)
{
  const char *s = cmd.GetParmAsString(NETPARM_S_CMDLINE);
  if ( s && s[0] )
     {
       CCmdLineExpander obj(s);
       const char *cmdline = (const char *)obj;
       if ( cmdline && cmdline[0] )
          {
            CDisableWOW64FSRedirection fsg;
            RunProcess(cmdline);
          }
     }
  else
     {
       const char *s = cmd.GetParmAsString(NETPARM_S_FILENAME);
       if ( s && s[0] )
          {
            ExecTool(s);
          }
     }
}


void OnBlockAction(void)
{
  protect_run_from_api = 1;
  RunOurBlocker();
  SendDynamicInfoToServer();
}


void OnUnblockAction(void)
{
  protect_run_from_api = 0;
  CloseOurBlocker();
  SendDynamicInfoToServer();
}


void CheckRunProtectionAtStartup(void)
{
  protect_run_from_api = protect_run_at_startup;
  if ( protect_run_from_api )
     {
       RunOurBlocker();
     }
}


void CheckMonitorPowerAtStartup(void)
{
  if ( ReadRegDword(HKCU,REGPATH,"monitor_off_after_startup",0) )
     TurnOffMonitor(disable_input_when_monitor_off,0);
  else
     TurnOnMonitor();
}


void WaitForFileServerReady(void)
{
  if ( wait_server_path[0] )
     {
       AboutBoxUpdateProgress(LS(3012));

       char s[MAX_PATH];
       unsigned start_time,end_time,timeout;
       HWND hwnd = NULL;

       lstrcpy(s,wait_server_path);
       PathRemoveBackslash(s);

       timeout = wait_server_timeout;
       if ( timeout < 1 )
          timeout = 1;
       if ( timeout > 300 )
          timeout = 300;
       start_time = GetTickCount();
       end_time = start_time + timeout*1000;

       do {
         if ( IsFileExist(CPathExpander(s)) )
            break;

         Sleep(500);

       } while ( GetTickCount() < end_time );

       AboutBoxUpdateProgress("");
     }
}


void WaitForOurServiceReady(void)
{
#ifndef DEBUG
  AboutBoxUpdateProgress(LS(3013));
  
  unsigned timeout = (is_vista ? 70 : 40);
  unsigned start_time = GetTickCount();
  unsigned end_time = start_time + timeout*1000;

  do {
    if ( IsOurServiceActive() )
       break;

    Sleep(500);

  } while ( GetTickCount() < end_time );

  AboutBoxUpdateProgress("");
#endif
}


void AutoRestoreDisplayModeAtStartup(void)
{
  if ( restore_dm_at_startup )
     {
       RestoreDisplayMode();
     }
}


void MouseRestoreAtStartup(void)
{
  if ( allow_mouse_adj )
     {
       int old_values[3] = {0,0,0};

       int sens = adj_mouse_speed * 19 / 10 + 1;
       SystemParametersInfo(SPI_SETMOUSESPEED,0,(void*)sens,SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);

       SystemParametersInfo(SPI_GETMOUSE,0,old_values,0);
       old_values[2] = adj_mouse_acc;
       SystemParametersInfo(SPI_SETMOUSE,0,old_values,SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
     }
}


int OnDeviceChange(HWND hwnd,int wParam,int lParam)
{
  if ( wParam == DBT_DEVICEARRIVAL || wParam == DBT_DEVICEREMOVECOMPLETE )
     {
       DEV_BROADCAST_HDR *i = (DEV_BROADCAST_HDR*)lParam;

       if ( i && i->dbch_devicetype == DBT_DEVTYP_VOLUME )
          {
            DEV_BROADCAST_VOLUME *i = (DEV_BROADCAST_VOLUME*)lParam;
            int n;

            for ( n = 2; n < 26; n++ )
                {
                  if ( (i->dbcv_unitmask >> n) & 1 )
                     {
                       char s[8];
                       int drive_type;

                       s[0] = n+'A';
                       s[1] = ':';
                       s[2] = '\\';
                       s[3] = 0;

                       drive_type = GetDriveType(s);

                       if ( wParam == DBT_DEVICEARRIVAL && 
                            i->dbcv_flags == DBTF_MEDIA && 
                            drive_type == DRIVE_CDROM )
                          {
                            PostMessage(hwnd,RS_MEDIAINSERTED,n,0);
                          }
                       else
                       if ( wParam == DBT_DEVICEARRIVAL &&
                            i->dbcv_flags == 0 && 
                            (drive_type == DRIVE_REMOVABLE || IsDriveTrueRemovableI(n)) )
                          {
                            PostMessage(hwnd,RS_FLASHINSERTED4STAT,n,0);
                            PostMessage(hwnd,RS_FLASHDISK,n,0);
                          }
                       else
                       if ( wParam == DBT_DEVICEREMOVECOMPLETE &&
                            i->dbcv_flags == 0 /*&& 
                            drive_type == DRIVE_REMOVABLE*/ )
                          {
                            PostMessage(hwnd,RS_FLASHREMOVED4STAT,n,0);
                          }
                     }
                }
          }
     }

  return TRUE;
}



void ProcessLangAtStartup()
{
  curr_lang = def_lang;
 #ifdef ADDLANGS
  if ( curr_lang < 0 || curr_lang > 7 )
 #else
  if ( curr_lang < 0 || curr_lang > 2 )
 #endif
     curr_lang = 0;

  if ( show_langs_at_startup )
     {
       Wait4DesktopSwitch();
       int idx = GetLangDialog(45);
       if ( idx != -1 )
          {
            curr_lang = idx;
          }
     }
}


void ShowLA(void)
{
  if ( !IsStrEmpty(la_startup_path) )
     {
       char cmd[MAX_PATH];
       
       wsprintf(cmd,"\"%srsrules.exe\" -ls \"%s\"",our_currpath,CPathExpander(la_startup_path).GetPath());

       STARTUPINFO si;
       PROCESS_INFORMATION pi;

       ZeroMemory(&si,sizeof(si));
       si.cb = sizeof(si);

       if ( CreateProcess(NULL,cmd,NULL,NULL,FALSE,0,NULL,our_currpath,&si,&pi) )
          {
            CloseHandle(pi.hThread);
            CloseHandle(pi.hProcess);

            unsigned time = GetTickCount();
            
            while( 1 )
            {
              HWND w = FindWindow("TRulesLSForm",NULL);
              
              if ( w /*&& (GetWindowLong(w,GWL_STYLE)&WS_VISIBLE)*/ ) //lockdown
                 break;

              if ( GetTickCount() - time > 5000 )
                 break;

              Sleep(20);
            };
          }
     }
}


void ShowLAAtStartup(void)
{
  if ( show_la_at_startup )
     {
       ShowLA();
     }
}


void ProcessHWIdents()
{
  CHWIdent::EHWIdentDevice device = CHWIdent::HWID_NONE;
  char id[MAX_PATH] = "";
  
  if ( GetHWIdentsEvent(&device,id,sizeof(id)-1) )
     {
       PlaySound(MAKEINTRESOURCE(IDW_HWIDENT),our_instance,SND_ASYNC|SND_NODEFAULT|SND_NOWAIT|SND_RESOURCE);
       VipOnHWIdent(device,id);
     }
}


// needed for some LineAgeII servers
#include "explorer_exe.inc"
void ExecExplorerUmulator4LA2()
{
  char s[MAX_PATH] = "";
  GetTempPath(MAX_PATH,s);

  if ( !IsStrEmpty(s) )
     {
       PathAppend(s,"explorer.exe");

       if ( WriteFullFile(s,explorer_exe,sizeof(explorer_exe)) )
          {
            RunProcess(s);
          }
     }
}


void S_GetShellVersion(CNetCmd &cmd)
{
  cmd.AddStringParm(NETPARM_S_VERSION,RUNPAD_VERSION_STR);
}


void S_GetGPUTemp(CNetCmd &cmd)
{
  char s[MAX_PATH];
  s[0] = 0;
  GetGPUTemperatureHTMLString(s);
  cmd.AddStringParm(NETPARM_S_GPUTEMP,s);
}


void S_GetCfgInfo(CNetCmd &cmd)
{
  char s[MAX_PATH*2] = "";

  if ( g_cfg_recv_type == 0 )     
     lstrcpy(s,STR_011);
  else
  if ( g_cfg_recv_type == 1 )     
     lstrcpy(s,STR_012);
  else
  if ( g_cfg_recv_type == 2 )
     lstrcpy(s,STR_013);
  else
     lstrcpy(s,"???");

  if ( !IsStrEmpty(g_cfg_recv_msg) )   
     {
       lstrcat(s," (");
       lstrcat(s,g_cfg_recv_msg); // MAX_PATH max
       lstrcat(s,")");
     }
  
  cmd.AddStringParm(NETPARM_S_USERSETTINGS,s);
}


void PrepareSomeInfo(CNetCmd &cmd)
{
  S_GetShellVersion(cmd);
  S_GetCfgInfo(cmd);
  S_GetGPUTemp(cmd);
}


void OpenDefaultSheetAsync()
{
  PostMessage(GetMainWnd(),RS_OPENDEFAULTSHEET,0,0);
}




