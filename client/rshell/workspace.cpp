
#include "include.h"



#define TIMER_FAST         1
#define TIMER_SLOW         2
#define TIMER_SUPER_FAST   3

static const char *mainclass = "_RunpadClass";


static CWorkSpace* g_workspace = NULL;


void WorkSpaceInit(void)
{
  if ( !g_workspace )
     {
       g_workspace = new CWorkSpace();
     }
}


void WorkSpaceDone(void)
{
  if ( g_workspace )
     {
       delete g_workspace;
       g_workspace = NULL;
     }
}


HWND GetMainWnd(void)
{
  return g_workspace ? g_workspace->GetMainWindow() : NULL;
}


BOOL IsWorkSpaceVisible(void)
{
  return g_workspace && g_workspace->IsVisible();
}


void WorkSpaceShow(void)
{
  if ( g_workspace )
     {
       g_workspace->Show();
     }
}


void WorkSpaceHide(void)
{
  if ( g_workspace )
     {
       g_workspace->Hide();
     }
}


void WorkSpaceOnEndSession(void)
{
  if ( g_workspace )
     {
       g_workspace->OnEndSession();
     }
}


void WorkSpaceOnConfigChange(void)
{
  if ( g_workspace )
     {
       g_workspace->OnConfigChange();
     }
}


void WorkSpaceRepaint(void)
{
  if ( g_workspace )
     {
       g_workspace->Repaint();
     }
}


void WorkSpaceRefresh(void)
{
  if ( g_workspace )
     {
       g_workspace->Refresh();
     }
}


void WorkSpaceOnDeskMouseDown()
{
  if ( g_workspace )
     {
       g_workspace->OnDeskMouseDown();
     }
}


void WorkSpaceOnStatusStringChanged()
{
  if ( g_workspace )
     {
       g_workspace->OnStatusStringChanged();
     }
}


BOOL IsAnyChildWindows(void)
{
  return g_workspace && g_workspace->HasChildWindows();
}


void CloseChildWindowsAsync(void)
{
  if ( g_workspace )
     {
       g_workspace->CloseChildWindowsAsync();
     }
}


void ToggleDesktop(void)
{
  if ( g_workspace )
     {
       g_workspace->ToggleDesktop();
     }
}


void BalloonNotify(int icon,const char *title,const char *text,int delay)
{
  if ( g_workspace )
     {
       g_workspace->BalloonNotify(icon,title,text,delay);
     }
}


void EmulateStartButtonClick(void)
{
  if ( g_workspace )
     {
       g_workspace->EmulateButtonClick();
     }
}


void SwitchMenuButton(void)
{
  if ( g_workspace )
     {
       g_workspace->SwitchMenuButton();
     }
}


CSheet* GetActiveSheet()
{
  return g_workspace ? g_workspace->GetActiveSheet() : NULL;
}


HWND GetActiveSheetWindowHandle()
{
  return g_workspace ? g_workspace->GetActiveSheetWindowHandle() : NULL;
}


void CloseActiveSheet(BOOL do_desk_update)
{
  if ( g_workspace )
     {
       g_workspace->CloseActiveSheet(do_desk_update);
     }
}


void SwitchToSheet(CSheet *new_sheet)
{
  if ( g_workspace )
     {
       g_workspace->SwitchToSheet(new_sheet);
     }
}



LRESULT CALLBACK CWorkSpace::ProxyWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message >= WM_USER && message <= WM_USER+300 )
     return 0;
  
  switch ( message )
  {
    case WM_CLOSE:
                   return 0;

    case WM_WINDOWPOSCHANGING:
                     if ( IsIconic(hwnd) )
                        {
                          WINDOWPOS *p = (WINDOWPOS*)lParam;
                          p->hwnd = hwnd;
                          p->hwndInsertAfter = NULL;
                          p->x = 0;
                          p->y = 0;
                          p->cx = 0;
                          p->cy = 0;
                          p->flags = SWP_HIDEWINDOW | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING | SWP_NOZORDER;

                          ShowWindow(hwnd,SW_RESTORE);
                          return 0;
                        }
                     break;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CWorkSpace::InitProxyWindow(void)
{
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = ProxyWindowProc;
  wc.hInstance = our_instance;
  wc.lpszClassName = "Proxy Desktop";
  RegisterClass(&wc);

  w_proxy = CreateWindowEx(WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,0,0,NULL,NULL,our_instance,NULL);
}


void CWorkSpace::DoneProxyWindow(void)
{
  DestroyWindow(w_proxy);
  UnregisterClass("Proxy Desktop",our_instance);
  w_proxy = NULL;
}


LRESULT CWorkSpace::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_DESTROY:
                   DoneWindowProcWrapper(hwnd);
                   return 0;
    
    case WM_CLOSE:
                   return 0;

    case WM_WINDOWPOSCHANGING:
                   if ( IsIconic(hwnd) )
                      {
                        WINDOWPOS *p = (WINDOWPOS*)lParam;
                        p->hwnd = hwnd;
                        p->hwndInsertAfter = NULL;
                        p->x = 0;
                        p->y = 0;
                        p->cx = 0;
                        p->cy = 0;
                        p->flags = SWP_HIDEWINDOW | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING | SWP_NOZORDER;

                        ShowWindow(hwnd,SW_RESTORE);
                        return 0;
                      }
                   break;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                   return 0;

    case WM_TIMER:
                   OnTimer(wParam);
                   return 0;

    case WM_DISPLAYCHANGE:
                   OnDisplayChange(LOWORD(lParam),HIWORD(lParam));
                   return 0;

    case RS_BALLOONMESSAGE:
                   OnBalloonNotifyMessage(wParam,lParam);
                   return 0;
    
    case WM_HOTKEY:
                   ExecHotKeyEvent(wParam);
                   break;

    case MM_MIXM_CONTROL_CHANGE:
    case MM_MIXM_LINE_CHANGE:
                   CheckVolumes(hwnd);
                   break;
    
    case WM_POWERBROADCAST:
                   if ( wParam == PBT_APMQUERYSUSPEND && disallow_power_keys )
                      return BROADCAST_QUERY_DENY;
                   break;

    case WM_QUERYENDSESSION:
                   return (GetCopyDeleteThreadsCount()?FALSE:TRUE);

    case WM_ENDSESSION:
                   if ( wParam )
                      {
                        GlobalOnEndSession((lParam&ENDSESSION_LOGOFF)?EL_LOGOFF:EL_REBOOT);
                      }
                   return 0;

    case WM_DEVICECHANGE:
                   return OnDeviceChange(hwnd,wParam,lParam);
                   
    default:
                   {
                     BOOL is_processed = FALSE;
                     int rc = ProcessRunpadInternalMessage(hwnd,message,wParam,lParam,&is_processed);
                     if ( is_processed )
                        return rc;
                   }
                   break;
  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}



CWorkSpace::CWorkSpace()
{
  w_main = NULL;
  w_proxy = NULL;
  desk = NULL;
  taskpane = NULL;
  shwindow = NULL;

  SystemParametersInfo(SPI_GETMENUSHOWDELAY,0,(void*)&old_menushowdelay,0);
  SystemParametersInfo(SPI_SETMENUSHOWDELAY,400,NULL,0);
  SystemParametersInfo(SPI_GETFLATMENU,0,(void*)&old_flatmenu,0);
  SystemParametersInfo(SPI_SETFLATMENU,0,(void*)TRUE,0);

  MakeTheme(def_sheet_color);
  
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = mainclass;
  RegisterClass(&wc);

  w_main = CreateWindowEx(WS_EX_TOOLWINDOW,mainclass,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,0,0,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(w_main);
  SetWindowLong(w_main,GWL_USERDATA,MAGIC_WID);
  InitProxyWindow();

  taskpane = new CTaskPane(w_main);
  desk = new CDesk(w_main);

  taskpane->SetDeskObj(desk);
  
  SetTimer(w_main,TIMER_SUPER_FAST,130,NULL);
  SetTimer(w_main,TIMER_FAST,250,NULL);
  SetTimer(w_main,TIMER_SLOW,1000,NULL);
  SetGeneralHotKeys(w_main);

  PrepareVolumeMixer(w_main);
  CheckVolumes(w_main);
  
  SendMessage(GetDesktopWindow(),WM_USER,0,0);

  SetForegroundWindow(w_main);

  InitBalloonNotify();

  shwindow = new CSheetWindow(OnManualSheetWindowClosed,this,OnDeskShade,this);
  
  GdiFlush(); //ensure all is redrawed

  PostMessage(HWND_BROADCAST,RegisterWindowMessage("TaskbarCreated"),0,0);
}


CWorkSpace::~CWorkSpace()
{
  SAFEDELETE(shwindow);
  DoneBalloonNotify();
  FinishVolumeMixer();
  if ( taskpane )
     taskpane->SetDeskObj(NULL);
  SAFEDELETE(desk);
  SAFEDELETE(taskpane);
  DoneProxyWindow();
  DestroyWindow(w_main);
  w_main = NULL;
  UnregisterClass(mainclass,our_instance);

  SystemParametersInfo(SPI_SETMENUSHOWDELAY,old_menushowdelay,NULL,0);
  SystemParametersInfo(SPI_SETFLATMENU,0,(void*)old_flatmenu,0);

  GdiFlush();
}


// we can't call DestroyWindow here!!!
void CWorkSpace::OnEndSession(void)
{
  FinishVolumeMixer();
  KillTimer(w_main,TIMER_SUPER_FAST);
  KillTimer(w_main,TIMER_FAST);
  KillTimer(w_main,TIMER_SLOW);
  if ( shwindow )
     shwindow->OnEndSession();
  if ( desk )
     desk->OnEndSession();
  if ( taskpane )
     taskpane->OnEndSession();
}


BOOL CALLBACK CWorkSpace::CloseAllChildsProc(HWND hwnd,LPARAM lParam)
{
  CWorkSpace *obj = (CWorkSpace *)lParam;
  HWND w_main = obj->w_main;
  
  if ( GetParent(hwnd) == w_main || GetWindow(hwnd,GW_OWNER) == w_main ||
       IsShaderWindow(GetParent(hwnd)) || IsShaderWindow(GetWindow(hwnd,GW_OWNER)) )
     if ( hwnd != ImmGetDefaultIMEWnd(w_main) )
        if ( IsWindowVisible(hwnd) )
           PostMessage(hwnd,WM_CLOSE,0,0);

  return TRUE;
}


BOOL CALLBACK CWorkSpace::HideAllChildsProc(HWND hwnd,LPARAM lParam)
{
  CWorkSpace *obj = (CWorkSpace *)lParam;
  HWND w_main = obj->w_main;
  
  if ( GetParent(hwnd) == w_main || GetWindow(hwnd,GW_OWNER) == w_main ||
       IsShaderWindow(GetParent(hwnd)) || IsShaderWindow(GetWindow(hwnd,GW_OWNER)) )
     if ( hwnd != ImmGetDefaultIMEWnd(w_main) )
        if ( IsWindowVisible(hwnd) )
           ShowWindow(hwnd,SW_HIDE);

  return TRUE;
}


BOOL CALLBACK CWorkSpace::ShowAllChildsProc(HWND hwnd,LPARAM lParam)
{
  CWorkSpace *obj = (CWorkSpace *)lParam;
  HWND w_main = obj->w_main;
  
  if ( GetParent(hwnd) == w_main || GetWindow(hwnd,GW_OWNER) == w_main ||
       IsShaderWindow(GetParent(hwnd)) || IsShaderWindow(GetWindow(hwnd,GW_OWNER)) )
     if ( hwnd != ImmGetDefaultIMEWnd(w_main) )
       if ( !IsWindowVisible(hwnd) )
           ShowWindow(hwnd,SW_SHOW);

  return TRUE;
}


BOOL CALLBACK CWorkSpace::CalcAllChildsProc(HWND hwnd,LPARAM lParam)
{
  CWorkSpace *obj = (CWorkSpace *)lParam;
  HWND w_main = obj->w_main;
  
  if ( GetParent(hwnd) == w_main || GetWindow(hwnd,GW_OWNER) == w_main )
     if ( hwnd != ImmGetDefaultIMEWnd(w_main) )
        if ( IsWindowVisible(hwnd) )
           {
             obj->found_childs++;
           }

  return TRUE;
}


BOOL CWorkSpace::IsVisible()
{
  return desk && desk->IsVisible() && taskpane && taskpane->IsVisible();
}


// unused???
void CWorkSpace::Hide(void)
{
  if ( IsVisible() )
     {
       EnumWindows(HideAllChildsProc,(int)this);
       if ( desk )
          desk->Hide();
       if ( taskpane )
          taskpane->Hide();
     }
}


void CWorkSpace::Show(void)
{
  if ( !IsVisible() )
     {
       if ( taskpane )
          taskpane->Show();
       if ( desk )
          desk->Show();
       EnumWindows(ShowAllChildsProc,(int)this);
     }
}


BOOL CWorkSpace::HasChildWindows(void)
{
  found_childs = 0;
  EnumWindows(CalcAllChildsProc,(int)this);
  return found_childs != 0;
}


void CWorkSpace::CloseChildWindowsAsync(void)
{
  EndMenu();
  EnumWindows(CloseAllChildsProc,(int)this);
}


BOOL CALLBACK CWorkSpace::MinimizeAllAppWindows(HWND hwnd,LPARAM lParam)
{
  if ( IsAppWindow(hwnd) && !IsIconic(hwnd) )
     {
       ShowWindowAsync(hwnd,SW_MINIMIZE);
     }

  return TRUE;
}


void CWorkSpace::ToggleDesktop(void)
{
  EnumWindows(MinimizeAllAppWindows,0);
  SetForegroundWindow(w_main);  //!!!!!!!!!!!!!!!!! to ddraw games needed? todo
}


void CWorkSpace::OnDisplayChange(int sw,int sh)
{
  if ( taskpane )
     taskpane->OnDisplayChange(sw,sh);
  if ( desk )
     desk->OnDisplayChange(sw,sh);
  //shwindow->OnDisplayChange(sw,sh); not needed
}


void CWorkSpace::CheckDisplayModeChanged(void)
{
  HWND deskw = desk ? desk->GetWindow() : NULL;
  if ( deskw && IsWindow(deskw) )
     {
       RECT r;
       GetWindowRect(deskw,&r);
       int ww = r.right - r.left;
       int wh = r.bottom - r.top;
       int sw = GetSystemMetrics(SM_CXSCREEN);
       int sh = GetSystemMetrics(SM_CYSCREEN);

       if ( sw != ww || sh != wh )
          {
            OnDisplayChange(sw,sh);
          }
     }
}


void CWorkSpace::OnTimer(int type)
{
  if ( type == TIMER_FAST )
     {
       CheckDisplayModeChanged();
       if ( desk )
          desk->OnTimer();
       if ( taskpane )
          taskpane->OnTimer();
       ::GlobalOnTimerFast();
     }
  else
  if ( type == TIMER_SLOW )
     {
       CheckVolumes(w_main);
       ::GlobalOnTimerSlow();
     }
  else
  if ( type == TIMER_SUPER_FAST )
     {
       ::GlobalOnTimerSuperFast();
     }
}


#define BALLOON_ID 0x7D43A502

typedef struct {
  DWORD cbSize;
  HWND hWnd;
  UINT uID;
  UINT uFlags;
  UINT uCallbackMessage;
  HICON hIcon;
  CHAR szTip[128];
  DWORD dwState;
  DWORD dwStateMask;
  CHAR szInfo[256];
  union {
  	UINT uTimeout;
  	UINT uVersion;
  };
  CHAR szInfoTitle[64];
  DWORD dwInfoFlags;
} NOTIFYICONDATAEX;


void CWorkSpace::InitBalloonNotify()
{
  NOTIFYICONDATAEX i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = w_main;
  i.uID = BALLOON_ID;
  i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_STATE;
  i.uCallbackMessage = RS_BALLOONMESSAGE;
  i.hIcon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_ICON));
  i.dwStateMask = NIS_HIDDEN;
  i.dwState = NIS_HIDDEN;

  Shell_NotifyIcon(NIM_ADD,(NOTIFYICONDATA*)&i);
}


void CWorkSpace::DoneBalloonNotify()
{
  NOTIFYICONDATA i;
  
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = w_main;
  i.uID = BALLOON_ID;

  Shell_NotifyIcon(NIM_DELETE,&i);
}


void CWorkSpace::BalloonNotify(int icon,const char *title,const char *text,int delay)
{
  NOTIFYICONDATAEX i;

  if ( !title || !text )
     return;
  
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = w_main;
  i.uID = BALLOON_ID;
  i.uFlags = NIF_STATE | NIF_INFO;
  i.dwStateMask = NIS_HIDDEN;
  i.dwState = 0;
  i.uTimeout = delay*1000;
  i.dwInfoFlags = icon;
  lstrcpyn(i.szInfo,text,sizeof(i.szInfo));
  lstrcpyn(i.szInfoTitle,title,sizeof(i.szInfoTitle));

  Shell_NotifyIcon(NIM_MODIFY,(NOTIFYICONDATA*)&i);
}


void CWorkSpace::HideBalloonNotify(void)
{
  NOTIFYICONDATAEX i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = w_main;
  i.uID = BALLOON_ID;
  i.uFlags = NIF_STATE;
  i.dwStateMask = NIS_HIDDEN;
  i.dwState = NIS_HIDDEN;

  Shell_NotifyIcon(NIM_MODIFY,(NOTIFYICONDATA*)&i);
}


void CWorkSpace::OnBalloonNotifyMessage(int wParam,int lParam)
{
  if ( lParam == NIN_BALLOONUSERCLICK || lParam == NIN_BALLOONTIMEOUT || lParam == NIN_BALLOONHIDE || lParam == WM_LBUTTONUP )
     {
       HideBalloonNotify();
     }
}


void CWorkSpace::OnConfigChange(void)
{
  SetGeneralHotKeys(w_main);
  if ( taskpane )
     taskpane->OnConfigChange();
  if ( desk )
     desk->OnConfigChange();
  //shwindow->OnConfigChange();  not implemented!
}


void CWorkSpace::Repaint(void)
{
  if ( taskpane )
     taskpane->Repaint();
  if ( desk )
     desk->Repaint();
  if ( shwindow )
     shwindow->Repaint();
}


void CWorkSpace::RepaintTaskPaneOnly(void)
{
  if ( taskpane )
     taskpane->Repaint();
}


void CWorkSpace::Refresh(void)
{
  if ( taskpane )
     taskpane->Refresh();
  if ( desk )
     desk->Refresh();
  //shwindow->Refresh();  not implemented!
}


void CWorkSpace::EmulateButtonClick(void)
{
  if ( taskpane )
     taskpane->EmulateButtonClick();
}


void CWorkSpace::SwitchMenuButton(void)
{
  if ( taskpane )
     taskpane->SwitchMenuButton();
}


HWND CWorkSpace::GetMainWindow()
{
  return w_main;
}


CSheet* CWorkSpace::GetActiveSheet()
{
  return shwindow ? shwindow->GetSheet() : NULL;
}


HWND CWorkSpace::GetActiveSheetWindowHandle()
{
  return shwindow ? shwindow->GetWindowHandle() : NULL;
}


void CWorkSpace::CloseActiveSheet(BOOL do_desk_update)
{
  if ( shwindow )
     {
       if ( shwindow->Close() )
          {
            OnSheetWindowClosed(do_desk_update);
          }
     }
}


typedef struct {
CWorkSpace *obj;
int old_color;
int new_color;
} TCOLORANI;


void CWorkSpace::LoadSheetCallback(int perc,void *parm)
{
  TCOLORANI *ani = (TCOLORANI*)parm;

  int color = GetAniColor(ani->old_color,ani->new_color,perc,101);
  MakeTheme(color);

  ani->obj->RepaintTaskPaneOnly();
}


void CWorkSpace::SwitchToSheet(CSheet *new_sheet)
{
  if ( shwindow )
     {
       CSheet *old_sheet = shwindow->GetSheet();

       TCOLORANI ani;
       ani.obj = this;
       ani.old_color = old_sheet ? old_sheet->GetColor() : def_sheet_color;
       ani.new_color = new_sheet ? new_sheet->GetColor() : def_sheet_color;
       
       BOOL rc = shwindow->LoadSheet(new_sheet,LoadSheetCallback,(void*)&ani);

       if ( rc && old_sheet != new_sheet )
          {
            if ( desk )
               desk->OnActiveSheetChanged();
          }
     }
}


void CWorkSpace::OnManualSheetWindowClosed(void *parm)
{
  if ( parm )
     {
       CWorkSpace *obj = (CWorkSpace*)parm;
       obj->OnSheetWindowClosed(TRUE);
     }
}


void CWorkSpace::OnDeskShade(void *parm)
{
  if ( parm )
     {
       CWorkSpace *obj = (CWorkSpace*)parm;
       obj->OnDeskShadeChanged();
     }
}


void CWorkSpace::OnSheetWindowClosed(BOOL do_desk_update)
{
  MakeTheme(def_sheet_color);
  RepaintTaskPaneOnly();
  if ( do_desk_update )
     {
       if ( desk )
          desk->OnActiveSheetChanged();
     }
}


void CWorkSpace::OnDeskShadeChanged()
{
  if ( desk )
     desk->OnPageShaded();
}


void CWorkSpace::OnDeskMouseDown()
{
  if ( taskpane )
     taskpane->OnDeskMouseDown();
}


void CWorkSpace::OnStatusStringChanged()
{
  if ( desk )
     desk->OnStatusStringChanged();
}


