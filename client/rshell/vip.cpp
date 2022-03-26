
#include "include.h"


static struct {
int id;
char login[MAX_PATH];
BOOL got_result;
int err_code;
} vip_res = { 1, "", FALSE, NETERR_VIP_NORESULT };

static int g_login_id = 1;
static HWND g_wnd = NULL;  // login/register dialog window handle
static BOOL b_login_in_progress = FALSE;
static int msg_hwident = WM_NULL;


static void SendBodyVipReqInternal(BOOL new_user,const char *s_login,const char *s_pass)
{
  g_login_id++;
  if ( g_login_id == 0 )
     g_login_id++;
  
  vip_res.id = g_login_id;
  vip_res.login[0] = 0;
  vip_res.got_result = FALSE;
  vip_res.err_code = NETERR_VIP_NORESULT;
  
  CNetCmd cmd(NETCMD_BODYVIP_REQ);
  cmd.AddIntParm(NETPARM_I_ID,vip_res.id);
  cmd.AddBoolParm(NETPARM_B_NEWUSER,new_user);
  cmd.AddStringParm(NETPARM_S_USERNAME,s_login);
  cmd.AddStringParm(NETPARM_S_PASSWORD,s_pass);
  NetSend(cmd);
}


void OnBodyVipAck(const CNetCmd &cmd,unsigned src_guid)
{
  if ( cmd.GetParmAsInt(NETPARM_I_ID,0) == vip_res.id )
     {
       const char *s_login = cmd.GetParmAsString(NETPARM_S_USERNAME,"");
       lstrcpyn(vip_res.login,s_login,sizeof(vip_res.login));
       vip_res.err_code = cmd.GetParmAsInt(NETPARM_I_RESULT,NETERR_VIP_UNKNOWN);
       vip_res.got_result = TRUE;
     }
  else
     {
       if ( cmd.GetParmAsInt(NETPARM_I_ID,0) == 0 )
          {
            vip_res.got_result = TRUE;
            vip_res.err_code = NETERR_VIP_NEWSERVER;
          }
       else
          {
            // ignore this ack
          }
     }
}


static BOOL GetBodyVipResult(char *out)
{
  if ( vip_res.got_result )
     {
       BOOL rc = FALSE;

       if ( vip_res.err_code == NETERR_VIP_WRONGLOGIN )
          {
            lstrcpy(out,LS(3088));
          }
       else
       if ( vip_res.err_code == NETERR_VIP_ALREADYEXIST )
          {
            lstrcpy(out,LS(3089));
          }
       else
       if ( vip_res.err_code == NETERR_VIP_NEWSERVER )
          {
            lstrcpy(out,LS(3226));
          }
       else
       if ( vip_res.err_code == NETERR_VIP_NOERROR )
          {
            if ( !IsStrEmpty(vip_res.login) )
               {
                 lstrcpy(out,vip_basefolder);
                 PathAppend(out,CString2Filename(vip_res.login));
                 PathAddBackslash(out);
                 rc = TRUE;
               }
            else
               {
                 lstrcpy(out,LS(3090));
               }
          }
       else
          {
            lstrcpy(out,LS(3090));
          }
       
       return rc;
     }
  else
     {
       lstrcpy(out,LS(3091));
       return FALSE;
     }
}


static void CheckVipFolderSizeInternal(const char *folder,BOOL use_post_msg)
{
  if ( vip_folder_limit )
     {
       if ( !IsStrEmpty(folder) )
          {
            int kbsize = GetDirectorySize(folder);

            if ( kbsize )
               {
                 int mbsize = kbsize/1024;

                 if ( mbsize > vip_folder_limit )
                    {
                      char s[MAX_PATH*2];
                      wsprintf(s,LS(3219),vip_folder_limit,mbsize);
                      
                      if ( !use_post_msg )
                         {
                           WarnBox(s);
                         }
                      else
                         {
                           PostMessage(GetMainWnd(),RS_MESSAGEBOX,(WPARAM)GlobalAddAtom(s),0);
                         }
                    }
               }
          }
     }
}


static void CloseVIPSessionInternal(BOOL silent)
{
  if ( vip_session[0] )
     {
       {
         CSheetsGuardAutoRefresh oGuard;
         
         vip_session[0] = 0;
         vip_folder[0] = 0;
         SetShellEnvStrings();
       }

       PostMessage(HWND_BROADCAST,RegisterWindowMessage("_RPVIPSessionEnd"),0,0);
       SendDynamicInfoToServer();
       
       if ( !silent )
          {
            MsgBoxTray(LS(3092));
          }
     }
}


BOOL CloseVIPSession(BOOL silent)
{
  if ( !vip_in_menu )
     return FALSE;

  if ( g_wnd || b_login_in_progress )
     return FALSE;
     
  CloseVIPSessionInternal(silent);

  return TRUE;
}


static BOOL BeginVIPSessionInternal(const char *login,const char *folder,BOOL silent)
{
  BOOL rc = FALSE;

  if ( login && login[0] && folder && folder[0] )
     {
       if ( vip_session[0] )
          CloseVIPSessionInternal(silent);

       {
         CSheetsGuardAutoRefresh oGuard;

         lstrcpy(vip_session,login);
         lstrcpy(vip_folder,folder);
         PathAddBackslash(vip_folder);
         CreateDirectory(vip_folder,NULL);
         SetShellEnvStrings();
       }

       PostMessage(HWND_BROADCAST,RegisterWindowMessage("_RPVIPSessionBegin"),0,0);
       SendDynamicInfoToServer();

       if ( !silent )
          {
            MsgBoxTray(LS(3093));
          }

       rc = TRUE;
     }

  return rc;
}


BOOL LoginVIPSession(BOOL new_user,const char *s_login,const char *s_pass,BOOL silent)
{
  BOOL rc = FALSE;

  if ( !vip_in_menu )
     return rc;

  if ( g_wnd || b_login_in_progress )
     return rc;
  
  if ( new_user && IsStrEmpty(s_login) )
     return rc;

  if ( !vip_basefolder[0] )
     {
       if ( !silent )
          WarnBoxTray(LS(3102));
       return rc;
     }
  
  if ( s_pass && s_pass[0] )
     {
       CWaitCursor oCursor;

       SendBodyVipReqInternal(new_user,s_login,s_pass);
       
       b_login_in_progress = TRUE;

       char out_err[MAX_PATH] = "";
       
       unsigned time = GetTickCount();
       while ( GetTickCount()-time < 4000 )
       {
         ProcessMessages();
         Sleep(50);
         
         if ( GetBodyVipResult(out_err) )
            {
              BeginVIPSessionInternal(vip_res.login,out_err,silent);

              if ( !silent )
                 CheckVipFolderSizeInternal(out_err,FALSE);

              rc = TRUE;
              break;
            }
       };

       b_login_in_progress = FALSE;

       if ( !rc )
          {
            if ( !silent )
               ErrBoxTray(out_err);
          }
     }

  return rc;
}


BOOL LoginVIPSessionForce(const char *s_login,BOOL silent)
{
  BOOL rc = FALSE;

  if ( !vip_in_menu )
     return rc;

  if ( g_wnd || b_login_in_progress )
     return rc;
  
  if ( IsStrEmpty(s_login) )
     return rc;

  if ( !vip_basefolder[0] )
     {
       if ( !silent )
          WarnBoxTray(LS(3102));
       return rc;
     }
  
  {
    CWaitCursor oCursor;

    char path[MAX_PATH];

    lstrcpy(path,vip_basefolder);
    PathAppend(path,CString2Filename(s_login));
    PathAddBackslash(path);
           
    BeginVIPSessionInternal(s_login,path,silent);

    //if ( !silent )
       CheckVipFolderSizeInternal(path,TRUE);

    rc = TRUE;
  }

  return rc;
}


typedef struct {
char login[MAX_PATH];
char folder[MAX_PATH];
} VIPINFO;


static BOOL CALLBACK VipDlgProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  static struct {
   int label_color;
   int bg_color;
   HBRUSH brush;
   HFONT font;
   BOOL can_close;
   int ticks;
   VIPINFO *i;
  } i = {0,0,NULL,NULL,TRUE,0,NULL};
  
  if ( message == WM_INITDIALOG )
     {
       g_wnd = hwnd;
       msg_hwident = RegisterWindowMessage("_MsgHWIdent4VipLogin");
       
       i.label_color = 0xFF0000;
       i.bg_color = GetSysColor(COLOR_BTNFACE);
       i.brush = CreateSolidBrush(i.bg_color);
       i.font = CreateFont(-10,0,0,0,FW_NORMAL,0,TRUE,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"MS Shell Dlg");
       i.can_close = TRUE;
       i.ticks = 0;
       i.i = (VIPINFO*)lParam;

       SetWindowText(hwnd,LS(3094));
       SetDlgItemText(hwnd,IDC_LABEL1,LS(3095));
       SetDlgItemText(hwnd,IDC_LABEL2,LS(3096));
       SetDlgItemText(hwnd,IDC_LABEL3,LS(3097));
       SetDlgItemText(hwnd,IDC_LABEL4,LS(3098));
       SetDlgItemText(hwnd,IDC_LABEL5,LS(3227));
       SetDlgItemText(hwnd,IDOK,LS(3099));
       SetDlgItemText(hwnd,IDCANCEL,LS(LS_CANCEL));

       SendMessage(GetDlgItem(hwnd,IDC_EDIT1),EM_LIMITTEXT,250,0);
       SendMessage(GetDlgItem(hwnd,IDC_EDIT2),EM_LIMITTEXT,250,0);
       SendMessage(GetDlgItem(hwnd,IDC_EDIT3),EM_LIMITTEXT,250,0);
       SendMessage(GetDlgItem(hwnd,IDC_LABEL4),WM_SETFONT,(int)i.font,FALSE);
       SetFocus(GetDlgItem(hwnd,IDC_EDIT1));
     }

  if ( message == WM_DESTROY )
     {
       //SendMessage(GetDlgItem(hwnd,IDC_LABEL4),WM_SETFONT,(int)0,FALSE);
       if ( i.brush )
          DeleteObject(i.brush);
       i.brush = NULL;
       if ( i.font )
          DeleteObject(i.font);
       i.font = NULL;
       i.i = NULL;

       g_wnd = NULL;
     }

  if ( message == msg_hwident && msg_hwident != WM_NULL )
     {
       char *device_str = (char*)lParam;
       if ( !IsStrEmpty(device_str) )
          {
            if ( IsWindowVisible(GetDlgItem(hwnd,IDC_EDIT3)) )
               { //registration
                 SetDlgItemText(hwnd,IDC_EDIT2,device_str);
                 EnableWindow(GetDlgItem(hwnd,IDC_EDIT2),FALSE);
                 SetDlgItemText(hwnd,IDC_EDIT3,device_str);
                 EnableWindow(GetDlgItem(hwnd,IDC_EDIT3),FALSE);
                 SetDlgItemText(hwnd,IDC_LABEL5,LS(3228));
                 EnableWindow(GetDlgItem(hwnd,IDC_LABEL5),TRUE);
                 SetFocus(GetDlgItem(hwnd,IDC_EDIT1));
               }
            else
               { //login
                 EndDialog(hwnd,0);
                 g_wnd = NULL; //needed here!
                 PostMessage(GetMainWnd(),RS_LOGINVIPSESSION_NOFORCE,0,(LPARAM)GlobalAddAtom(device_str));
               }
          }

       if ( device_str )
          sys_free(device_str);
     }
     
  if ( message == WM_CTLCOLORSTATIC )
     {
       HWND control = (HWND)lParam;

       if ( control == GetDlgItem(hwnd,IDC_LABEL4) )
          {
            if ( IsWindowEnabled(control) && IsWindowVisible(control) )
               {
                 HDC hdc = (HDC)wParam;

                 SetTextColor(hdc,i.label_color);
                 SetBkColor(hdc,i.bg_color);
                 //SetBkMode(hdc,TRANSPARENT);
                 
                 return (BOOL)i.brush;
               }
          }
     }

  if ( message == WM_MOUSEMOVE || 
       message == WM_LBUTTONDOWN || message == WM_LBUTTONUP || message == WM_LBUTTONDBLCLK ||
       message == WM_MBUTTONDOWN || message == WM_MBUTTONUP || message == WM_MBUTTONDBLCLK ||
       message == WM_RBUTTONDOWN || message == WM_RBUTTONUP || message == WM_RBUTTONDBLCLK )
     {
       if ( !i.can_close )
          {
            SetCursor(LoadCursor(NULL,IDC_WAIT));
          }
       else
          {
            POINT p;

            p.x = LOWORD(lParam);
            p.y = HIWORD(lParam);

            if ( ChildWindowFromPointEx(hwnd,p,CWP_SKIPINVISIBLE | CWP_SKIPDISABLED) == GetDlgItem(hwnd,IDC_LABEL4) )
               {
                 SetCursor(LoadCursor(NULL,IDC_HAND));

                 if ( message == WM_LBUTTONUP )
                    {
                      ShowWindow(GetDlgItem(hwnd,IDC_LABEL4),SW_HIDE);
                      ShowWindow(GetDlgItem(hwnd,IDC_LABEL3),SW_SHOW);
                      ShowWindow(GetDlgItem(hwnd,IDC_EDIT3),SW_SHOW);
                    }
               }
          }
     }

  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       char s_login[MAX_PATH] = "";
       char s_pass[MAX_PATH] = "";
       char s_pass2[MAX_PATH] = "";
       
       GetDlgItemText(hwnd,IDC_EDIT1,s_login,sizeof(s_login));
       GetDlgItemText(hwnd,IDC_EDIT2,s_pass,sizeof(s_pass));
       GetDlgItemText(hwnd,IDC_EDIT3,s_pass2,sizeof(s_pass2));

       if ( !s_login[0] || !s_pass[0] || (!s_pass2[0] && IsWindowVisible(GetDlgItem(hwnd,IDC_EDIT3))) )
          {
            MessageBox(hwnd,LS(3100),LS(LS_ERROR),MB_OK | MB_ICONERROR);
          }
       else
       if ( IsWindowVisible(GetDlgItem(hwnd,IDC_EDIT3)) && lstrcmp(s_pass,s_pass2) )
          {
            MessageBox(hwnd,LS(3101),LS(LS_ERROR),MB_OK | MB_ICONERROR);
          }
       else
       if ( !vip_basefolder[0] )
          {
            MessageBox(hwnd,LS(3102),LS(LS_ERROR),MB_OK | MB_ICONERROR);
          }
       else
          {
            EnableWindow(GetDlgItem(hwnd,IDC_EDIT1),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDC_EDIT2),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDC_EDIT3),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDC_LABEL4),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDOK),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDCANCEL),FALSE);
            UpdateWindow(hwnd);
            SetCursor(LoadCursor(NULL,IDC_WAIT));

            BOOL new_user = IsWindowVisible(GetDlgItem(hwnd,IDC_LABEL4))?FALSE:TRUE;
            
            SendBodyVipReqInternal(new_user,s_login,s_pass);
            b_login_in_progress = TRUE;

            i.can_close = FALSE;
            i.ticks = 0;
            SetTimer(hwnd,1,250,NULL);
          }
     }

  if ( message == WM_TIMER && wParam == 1 && !i.can_close )
     {
       const int maxtime = 16; // 4 sec
       
       ++i.ticks;

       char out_err[MAX_PATH] = "";
       BOOL rc = GetBodyVipResult(out_err);
       
       if ( i.ticks == maxtime || rc )
          {
            KillTimer(hwnd,1);
            i.can_close = TRUE;
            b_login_in_progress = FALSE;
          }

       if ( rc )
          {
            lstrcpy(i.i->login,vip_res.login);
            lstrcpy(i.i->folder,out_err);
            SetCursor(LoadCursor(NULL,IDC_ARROW));
            EndDialog(hwnd,1);
          }
       else
          {
            if ( i.ticks == maxtime )
               {
                 SetCursor(LoadCursor(NULL,IDC_ARROW));
                 MessageBox(hwnd,out_err,LS(LS_ERROR),MB_OK | MB_ICONERROR);

                 EnableWindow(GetDlgItem(hwnd,IDC_EDIT1),TRUE);
                 EnableWindow(GetDlgItem(hwnd,IDC_EDIT2),TRUE);
                 EnableWindow(GetDlgItem(hwnd,IDC_EDIT3),TRUE);
                 EnableWindow(GetDlgItem(hwnd,IDC_LABEL4),TRUE);
                 EnableWindow(GetDlgItem(hwnd,IDOK),TRUE);
                 EnableWindow(GetDlgItem(hwnd,IDCANCEL),TRUE);
               }
          }
     }
     
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       if ( i.can_close )
          {
            EndDialog(hwnd,0);
          }
     }

  return FALSE;
}


static void ShowVipDialogInternal(void)
{
  VIPINFO i;
  ZeroMemory(&i,sizeof(i));

  if ( DialogBoxParam(our_instance,MAKEINTRESOURCE(IDD_VIPDIALOG),GetMainWnd(),VipDlgProc,(int)&i) )
     {
       CWaitCursor oCursor;
       BeginVIPSessionInternal(i.login,i.folder,FALSE);
       CheckVipFolderSizeInternal(i.folder,FALSE);
     }
}


void M_Vipsession(void)
{
  if ( !vip_in_menu )
     return; //paranoja
  
  if ( !g_wnd && !b_login_in_progress )
     {
       if ( vip_session[0] )
          {
            char s[MAX_PATH];
            wsprintf(s,LS(3103),vip_session);
            if ( Confirm(s) )
               {
                 if ( vip_session[0] )  //maybe changed before
                    {
                      CloseActiveSheet(TRUE);
                      CloseVIPSession(FALSE);
                    }
               }
          }
       else
          {
            ShowVipDialogInternal();
          }
     }
}


void VipOnHWIdent(CHWIdent::EHWIdentDevice device,const char *device_id)
{
  if ( !IsStrEmpty(device_id) )
     {
       if ( vip_in_menu )
          {
            if ( !b_login_in_progress )
               {
                 if ( !g_wnd )
                    {
                      if ( IsStrEmpty(vip_session) )
                         {
                           LoginVIPSession(FALSE,"",device_id,FALSE);
                         }
                      else
                         {
                           CloseActiveSheet(TRUE);
                           CloseVIPSession(FALSE);
                         }
                    }
                 else
                    {
                      PostMessage(g_wnd,msg_hwident,(WPARAM)device,(LPARAM)sys_copystring(device_id));
                    }
               }
          }
     }
}


