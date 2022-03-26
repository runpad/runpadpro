
#include "include.h"


static const char *main_wnd_class = "_RSOperatorClass";
static HWND g_wnd = NULL;
static int taskbar_message = WM_NULL;
static int tray_message = WM_NULL;
static int show_message = WM_NULL;
static int alerts_message = WM_NULL;
static const int MAINTRAYID = 0x7D132284; //do not change

CVSControl *vscontrol = NULL;
CAlerts *alerts = NULL;


void ShowTrayIcon();


void OnEndSession()
{
  NetDone();
  ExitProcess(0);
}


BOOL IsWeAddedToAutorun()
{
  char s[MAX_PATH];
  char exe[MAX_PATH];
  
  ReadRegStr(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",OURAPPNAME,s,"");
  if ( IsStrEmpty(s) )
     ReadRegStr(HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",OURAPPNAME,s,"");

  exe[0] = 0;
  GetModuleFileName(our_instance,exe,MAX_PATH);

  return lstrcmpi(exe,s) == 0;
}


void AddToAutorun(HKEY root)
{
  char exe[MAX_PATH];
  exe[0] = 0;
  GetModuleFileName(our_instance,exe,MAX_PATH);
  WriteRegStr(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",OURAPPNAME,exe);
}


void RemoveFromAutorun(HKEY root)
{
  DeleteRegValue(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",OURAPPNAME);
}


BOOL CheckForAlreadyLoaded()
{
  HWND w = FindWindow(main_wnd_class,NULL);
  if ( w )
     {
       PostMessage(w,RegisterWindowMessage("_RSOperatorShowWndMsg"),0,0);
     }

  return w == NULL;
}


void ShowPopupMenu()
{
  HMENU menu = CreatePopupMenu();

  const int IDM_SHOWHIDE = 1001;
  const int IDM_CLOSE = 1002;

  AppendMenu(menu,0,IDM_SHOWHIDE,gui->IsMainWindowVisible()?S_HIDEWINDOW:S_SHOWWINDOW);
  AppendMenu(menu,MF_SEPARATOR,0,NULL);
  AppendMenu(menu,0,IDM_CLOSE,S_CLOSEWINDOW);

  HWND old_fore = GetForegroundWindow();

  SetForegroundWindow(g_wnd);
  SetActiveWindow(g_wnd);

  POINT p;
  GetCursorPos(&p);
  int x = p.x;
  int y = p.y;
 
  int flags = TPM_RIGHTALIGN | TPM_BOTTOMALIGN | TPM_RIGHTBUTTON | TPM_NONOTIFY | TPM_RETURNCMD;

  int rc = TrackPopupMenu(menu,flags,x,y,0,g_wnd,NULL);

  SetForegroundWindow(old_fore);
  
  DestroyMenu(menu);
  
  if ( rc )
     {
       if ( rc == IDM_SHOWHIDE )
          {
            if ( gui->IsMainWindowVisible() )
               gui->HideMainWindow();
            else
               gui->ShowMainWindow();
          }
       else
       if ( rc == IDM_CLOSE )
          {
            PostQuitMessage(1);
          }
     }
}


BOOL CALLBACK EnumThreadWndProc(HWND hwnd,LPARAM lParam)
{
  if ( IsWindow(hwnd) && IsWindowVisible(hwnd) )
     {
       RECT r = {0,0,0,0};
       GetWindowRect(hwnd,&r);

       if ( IsIconic(hwnd) || (r.right - r.left > 0 && r.bottom - r.top > 0) )
          {
            int *p_count = (int*)lParam;
            
            if ( hwnd == gui->GetMainWindowHandle() )
               {
                 *p_count = *p_count + 1;
               }
            else
               {
                 char s[MAX_PATH];
                 s[0] = 0;
                 GetClassName(hwnd,s,sizeof(s));

                 if ( lstrcmp(s,"#32768") && lstrcmp(s,"SysShadow") && lstrcmp(s,"tooltips_class32") )
                    {
                      if ( !vscontrol || vscontrol->GetWindowHandle() != hwnd )
                         {
                           *p_count = *p_count + 2;
                         }
                    }
               }
          }
     }

  return TRUE;
}


BOOL CanShowHideMainWindow()
{
  int count = 0;
  EnumThreadWindows(GetCurrentThreadId(),EnumThreadWndProc,(LPARAM)&count);
  return count <= 1;
}


LRESULT CALLBACK MainWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == taskbar_message )
     {
       ShowTrayIcon();
       return 0;
     }

  if ( message == show_message )
     {
       if ( CanShowHideMainWindow() )
          {
            gui->ShowMainWindow();
          }
       return 0;
     }
  
  if ( message == alerts_message )
     {
       alerts->OnTrayMessage(wParam,lParam);
       return 0;
     }
  
  if ( message == tray_message )
     {
       if ( wParam == MAINTRAYID )
          {
            if ( lParam != WM_MOUSEMOVE )
               {
                 if ( CanShowHideMainWindow() )
                    {
                      if ( lParam == WM_RBUTTONUP )
                         {
                           ShowPopupMenu();
                         }
                      else
                      if ( lParam == WM_LBUTTONUP )
                         {
                           if ( gui->IsMainWindowVisible() )
                              gui->HideMainWindow();
                           else
                              gui->ShowMainWindow();
                         }
                    }
               }
          }

       return 0;
     }
     
  switch ( message )
  {
    case WM_TIMER:
    {
      if ( wParam == 1 )
         {
           NetProcessing();
         }
      else
      if ( wParam == 2 )
         {
           alerts->Blink();
         }
      break;
    }
    
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_CHAR:
    case WM_SYSCHAR:
    {
      return 0;
    }

    case WM_CLOSE:
    {
      return 0;
    }

    case WM_ENDSESSION:
    {
      if ( wParam )
         {
           OnEndSession();
         }
      return 0;
    }

    case WM_WINDOWPOSCHANGING:
    {
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

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CreateWnd()
{
  taskbar_message = RegisterWindowMessage("TaskbarCreated");
  tray_message = RegisterWindowMessage("_RSOperatorTrayNotifyMsg");
  show_message = RegisterWindowMessage("_RSOperatorShowWndMsg");
  alerts_message = RegisterWindowMessage("_RSOperatorAlertsNotifyMsg");

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = MainWindowProc;
  wc.hInstance = our_instance;
  wc.lpszClassName = main_wnd_class;
  wc.hIcon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_ICON));
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(WS_EX_TOOLWINDOW,main_wnd_class,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,0,0,NULL,NULL,our_instance,NULL);
  SetTimer(hwnd,1,66,NULL); //net
  SetTimer(hwnd,2,500,NULL); //alerts
  g_wnd = hwnd;
}


void DestroyWnd()
{
  DestroyWindow(g_wnd);
  UnregisterClass(main_wnd_class,our_instance);
  g_wnd = NULL;
}


void ShowTrayIcon()
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = g_wnd;
  i.uID = MAINTRAYID;
  i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
  i.uCallbackMessage = tray_message;
  i.hIcon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_ICON),IMAGE_ICON,16,16,LR_SHARED);
  GetWindowText(gui->GetMainWindowHandle(),i.szTip,sizeof(i.szTip)-1);
  Shell_NotifyIcon(NIM_ADD,&i);
}


void HideTrayIcon()
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = g_wnd;
  i.uID = MAINTRAYID;
  Shell_NotifyIcon(NIM_DELETE,&i);
}


void ModifyTrayTip(const char *new_title)
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = g_wnd;
  i.uID = MAINTRAYID;
  i.uFlags = NIF_TIP;
  lstrcpyn(i.szTip,new_title?new_title:"",sizeof(i.szTip)-1);
  Shell_NotifyIcon(NIM_MODIFY,&i);
}


void ProcessMessages(void)
{
  MSG msg;

  while ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
        {
          if ( GetMessage(&msg,NULL,0,0) )
             {
               TranslateMessage(&msg);
               DispatchMessage(&msg);
             }
          else
             {
               PostQuitMessage(1);
               break;
             }
        }
}


void MessageLoop()
{
  MSG msg;

  while ( GetMessage(&msg,NULL,0,0) )
  {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
}


void __cdecl C_OnTitleChanged(const char *new_title)
{
  ModifyTrayTip(new_title);
}


void __cdecl C_GetServerName(char *out)
{
  ReadRegStr(HKEY_LOCAL_MACHINE,REGPATH,"server_ip",out,"");
}


BOOL __cdecl C_IsServerConnected()
{
  return NetIsConnected();
}


int __cdecl C_GetEnvListCount()
{
  return GetEnvListCount();
}


void __cdecl C_GetEnvListAt(int idx,TENVENTRY *out)
{
  GetEnvListAt(idx,out);
}


void __cdecl C_WakeupOnLAN(const char *ip,const char *mac)
{
  WakeupOnLAN(ip,mac);
}


BOOL __cdecl C_IsOurIP(const char *s_ip)
{
  return IsMyIP(s_ip);
}


void __cdecl C_ExecFunction(int id,const TENVENTRY *list,int count)
{
  ExecFunction(id,list,count);
}


static const TGUICONNECTION gui_conn = 
{
  C_OnTitleChanged,
  C_GetServerName,
  C_IsServerConnected,
  C_GetEnvListCount,
  C_GetEnvListAt,
  C_WakeupOnLAN,
  C_IsOurIP,
  C_ExecFunction,
};


void MainProcessing()
{
  NetInit();
  CreateWnd();
  vscontrol = new CVSControl();
  alerts = new CAlerts(g_wnd,alerts_message);
  gui->CreateMainWindow(&gui_conn);
  ShowTrayIcon();
  if ( !IsWeAddedToAutorun() )
     gui->ShowMainWindow();
  MessageLoop();
  HideTrayIcon();
  gui->DestroyMainWindow();
  delete alerts;
  alerts = NULL;
  delete vscontrol;
  vscontrol = NULL;
  DestroyWnd();
  NetFlush(300);
  NetDone();
}

