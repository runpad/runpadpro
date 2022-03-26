

static BOOL AdminAccessOffShellLMCU()
{
  BOOL rc1 = TurnShellOffForCurrentUser();
  BOOL rc2 = TurnShellOffForAllUsers();

  return rc1 && rc2;
}


// the same code in service!!!
static BOOL AdminAccessOffAutoLogon()
{
  const char *key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";

  BOOL rc = TRUE;

  rc = !rc ? rc : AdminAccessDeleteRegValue64(HKLM,key,"AltDefaultPassword");
  rc = !rc ? rc : AdminAccessDeleteRegValue64(HKLM,key,"DefaultPassword");
  rc = !rc ? rc : AdminAccessDeleteRegValue64(HKLM,key,"AutoAdminLogon");
  rc = !rc ? rc : AdminAccessDeleteRegValue64(HKLM,key,"ForceAutoLogon");

  return rc;
}


static BOOL KillOurUserTask(int pid,const char *exe_path,void *parm)
{
  const char *short_path = PathFindFileName(exe_path?exe_path:"");
  
  #ifdef DEBUG
  if ( !lstrcmpi(short_path,"far.exe") )
     {
       return TRUE;
     }
  #endif

  if ( !lstrcmpi(short_path,"ClubControlClient.exe") || 
       !lstrcmpi(short_path,"dwm.exe") || 
       !lstrcmpi(short_path,"taskhost.exe") || 
       !lstrcmpi(short_path,"rdpclip.exe") || 
       !lstrcmpi(short_path,"gccl.exe") )  //really?
     {
       return TRUE;
     }
  
  if ( pid != GetCurrentProcessId() )
     {
       char sid1[MAX_PATH] = "";
       GetProcessOwnerStringSid(pid,sid1);

       const char *sid2 = (char*)parm;

       if ( !lstrcmpi(sid1,sid2) )
          {
            //if ( HasProcessAppWindow(pid) )
               {
                 HANDLE ph = OpenProcess(PROCESS_TERMINATE,FALSE,pid);
                 if ( ph )
                    {
                      TerminateProcess(ph,0);
                      CloseHandle(ph);
                    }
               }
          }
     }

  return TRUE;
}


static void KillAllOurUserTasks()
{
  char sid[MAX_PATH] = "";
  GetCurrentUserSid(sid);

  ScanProcesses(KillOurUserTask,sid);

  Sleep(1000); //paranoja
}


static void RunWindowsExplorer()
{
  const char *r_key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";
  const char *r_value = "Shell";

  // save old values
  char old_lm[MAX_PATH];
  char old_cu[MAX_PATH];
  ReadRegStr(HKCU,r_key,r_value,old_cu,"");
  ReadRegStr64(HKLM,r_key,r_value,old_lm,"");

  // set new values
  DeleteRegValue(HKCU,r_key,r_value);
  BOOL modify_lm = FALSE;
  if ( lstrcmpi(old_lm,"explorer.exe") )
     {
       AdminAccessWriteRegStr64(HKLM,r_key,r_value,"Explorer.exe");
       modify_lm = TRUE;
     }

  // exec
  {
    char s[MAX_PATH];
    RunProcess(GetFileNameInWindowsDir("explorer.exe",s));  // we cannot use simple explorer.exe on wow64!
  }

  unsigned start = GetTickCount();
  while ( !FindWindow("Shell_TrayWnd",NULL) && GetTickCount() - start < 4000 )
  {
    Sleep(100);
  }

  // restore registry entries
  if ( !IsStrEmpty(old_cu) )
     {
       WriteRegStr(HKCU,r_key,r_value,old_cu);
     }
  if ( modify_lm )
     {
       if ( !IsStrEmpty(old_lm) )
          AdminAccessWriteRegStr64(HKLM,r_key,r_value,old_lm);
       else
          AdminAccessDeleteRegValue64(HKLM,r_key,r_value); //really happens? :)
     }
}


static void RunOurShellOffIndicator()
{
  char cmd[MAX_PATH];
  wsprintf(cmd,"\"%s%s\" %d",our_currpath,"rsoffindic.exe",fastexit_idle_timeout);
  RunProcess(cmd);
}


void FE_DoFastExit(BOOL silent,BOOL show_reminder)
{
  GlobalDoneWithoutApiDone(EL_OFFSHELL);
  KillAllOurUserTasks();
  RunWindowsExplorer();
  if ( show_reminder )
   RunOurShellOffIndicator();
  ApiDone();
  ApiExit(1);
}


void FE_DoOffShell(BOOL silent)
{
  if ( IsOurShellTurnedOn() )
     {
       AdminAccessOffShellLMCU();
       InternalLogOff(FALSE);
     }
  else
     {
       // we are in DEBUG mode
     }
}


void FE_DoOffAutoLogon(BOOL silent)
{
  BOOL rc = AdminAccessOffAutoLogon();

  if ( !silent )
     {
       if ( rc )
          {
            MsgBoxW(WSTR_024);
          }
       else
          {
            ErrBoxW(WSTR_025);
          }
     }
}



static BOOL CALLBACK FEDialogProcW(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       //SetClassLongW(hwnd,GCL_HICON,(int)LoadIcon(our_instance,MAKEINTRESOURCE(IDI_FASTEXIT)));

       CheckDlgButton(hwnd,IDC_RADIO1,BST_CHECKED);

       SetFocus(GetDlgItem(hwnd,IDC_RADIO1));

       SetTimer(hwnd,1,60000,NULL);

       SetForegroundWindow(hwnd);
     }

  if ( message == WM_TIMER || 
       message == WM_CLOSE || 
       (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       EndDialog(hwnd,0);
     }

  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       int rc = 0;
       
       if ( IsDlgButtonChecked(hwnd,IDC_RADIO1) == BST_CHECKED )
          rc = 1;
       else
       if ( IsDlgButtonChecked(hwnd,IDC_RADIO2) == BST_CHECKED )
          rc = 2;
       else
       if ( IsDlgButtonChecked(hwnd,IDC_RADIO3) == BST_CHECKED )
          rc = 3;
       
       EndDialog(hwnd,rc);
     }

  return FALSE;
}


void FastExitDialog()
{
  int rc = DialogBoxW(our_instance,MAKEINTRESOURCEW(IDD_FASTEXIT),GetMainWnd(),FEDialogProcW);

  if ( rc != 0 )
     {
       if ( rc == 1 )
          {
            FE_DoFastExit(FALSE,TRUE);
          }
       else
       if ( rc == 2 )
          {
            FE_DoOffShell(FALSE);
          }
       else
       if ( rc == 3 )
          {
            FE_DoOffAutoLogon(FALSE);
          }
     }
}


void OnKBFastExit()
{
  if ( fastexit_use_fixed_pwd )
     {
       if ( IsStrEmpty(fastexit_fixed_pwd_md5) )
          {
            ErrBoxW(WSTR_012);
          }
       else
          {
            const char *p = ShowPassword(LS(3033));

            if ( !IsStrEmpty(p) )
               {
                 char s[MAX_PATH];
                 lstrcpyn(s,p,sizeof(s));
                 CharLower(s);

                 BOOL is_ok = !lstrcmpi(fastexit_fixed_pwd_md5,CStr2MD5(s));

                 SecureZeroMemory(s,sizeof(s));

                 if ( is_ok )
                    {
                      FastExitDialog();
                    }
               }
          }
     }
}


