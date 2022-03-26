


static BOOL CALLBACK TSHODialogProcW(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       CheckDlgButton(hwnd,IsCurrentUserIsInDomain()?IDC_RADIO1:IDC_RADIO2,BST_CHECKED);
       SetFocus(GetDlgItem(hwnd,IDC_RADIO2));
       SetForegroundWindow(hwnd);
     }

  if ( message == WM_CLOSE || 
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
       
       EndDialog(hwnd,rc);
     }

  return FALSE;
}


void TurnShellOnDialogW()
{
  if ( machine_type == MACHINE_TYPE_OPERATOR || machine_type == MACHINE_TYPE_HOME )
     {
       const char *rsop_name = "RSOperator";
       const char *rsop_exe = "rsoperator.exe";
       
       char s[MAX_PATH] = "";
       ReadRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",rsop_name,s,"");
       if ( IsStrEmpty(s) )
          ReadRegStr(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",rsop_name,s,"");

       BOOL added_to_autorun = !lstrcmpi(PathFindFileName(s),rsop_exe);

       if ( !added_to_autorun )
          {
            MsgBoxW(WSTR_031);
            return;
          }
     }

  if ( ConfirmYESNODefNOW(WSTR_032) )
     {
       int rc = DialogBoxW(our_instance,MAKEINTRESOURCEW(IDD_TURNSHELLON),GetMainWnd(),TSHODialogProcW);

       if ( rc != 0 )
          {
            HKEY root = ((rc==1) ? HKLM : HKCU);
            
            if ( !TurnShellOnFor(root) )
               {
                 ErrBoxW(WSTR_033);
               }
            else
               {
                 if ( ConfirmW(WSTR_034) )
                    {
                      LogOff(FALSE);
                    }
               }
          }
     }
}


