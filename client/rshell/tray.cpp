
#include "include.h"


#define MAXICONS        100
#define ICONW		16
#define ICONH		16
#define CLOCKW		48



CTrayIcon::CTrayIcon()
{
  version = 3;  // win2000/xp
  hwnd = NULL;
  id = 0;
  ZeroMemory(&guid,sizeof(guid));
  message = -1;
  icon = NULL;
  hidden = FALSE;
  hide_in_user_mode = FALSE;
  tip[0] = 0;
}

CTrayIcon::~CTrayIcon()
{
  if ( icon )
     DestroyIcon(icon);
  icon = NULL;
}


void CTrayIcon::ReplaceIcon(HICON i)
{
  if ( icon )
     DestroyIcon(icon);
  icon = NULL;

  icon = i ? CopyIcon(i) : NULL;
  if ( icon == NULL )
     icon = CopyIcon(LoadIcon(our_instance,MAKEINTRESOURCE(IDI_EMPTY)));
}


BOOL CTrayIcon::IsHiddenSystemIcon() const
{
  static const GUID ac_guid = { 0x7820AE76, 0x23E3, 0x4229, { 0x82, 0xC1, 0xE4, 0x1C, 0xB6, 0x7D, 0x5B, 0x9C } };
  
  char s[MAX_PATH] = "";
  GetClassName(hwnd,s,sizeof(s));

  return (/*is_vista &&*/ !lstrcmp(s,"SecNotify") /*&& id == 1*/) || IsEqualGUID(guid,ac_guid);
}


BOOL CTrayIcon::IsVisible() const
{
  return !hidden && !hide_in_user_mode;
}


BOOL CTrayIcon::IsHidden() const
{
  return !IsVisible();
}


BOOL CTrayIcon::UseGuid() const
{
  return !IsGUIDEmpty(guid);
}


BOOL CTrayIcon::IsSame(HWND _hwnd,int _id,const GUID& _guid) const
{
  if ( UseGuid() )
     {
       return IsEqualGUID(guid,_guid);
     }
  else
     {
       if ( IsGUIDEmpty(_guid) )
          {
            return hwnd == _hwnd && id == _id;
          }
       else
          {
            return FALSE;
          }
     }
}


//////////////////////////


CTray::CTray(HWND main_window,HWND panel_window,int _msg_panel_update, int _msg_redraw_single_icon)
{
  w_main = main_window;
  w_panel = panel_window;

  msg_panel_update = _msg_panel_update;
  msg_redraw_single_icon = _msg_redraw_single_icon;

  InitializeCriticalSection(&o_cs);

  id_thread = -1;
  h_thread = NULL;

  cfg_theme2d = Get2DTheme();
  cfg_list_safe = safe_tray_icons;
  cfg_list_hidden = hidden_tray_icons;
  cfg_max_vis = max_vis_tray_icons;
  cfg_is_safe_tray = safe_tray;

  tooltip = CreateWindowEx(WS_EX_TOPMOST,TOOLTIPS_CLASS,NULL,TTS_NOPREFIX | TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,our_instance,NULL);
  SetWindowPos(tooltip,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
  SendMessage(tooltip,TTM_ACTIVATE,TRUE,0);
  
  event_ready = CreateEvent(NULL,FALSE,FALSE,NULL);
  event_finish = CreateEvent(NULL,FALSE,FALSE,NULL);

  p_balloon = NULL;
  p_trayicons = NULL;
  traywnd = NULL;
  notifywnd = NULL;
  clockwnd = NULL;
  
  lasttime[0] = 0;

  h_thread = MyCreateThreadSelectedCPU(ThreadProcWrapper,this,&id_thread);

  WaitForSingleObject(event_ready,INFINITE); // wait until all is created and thread ready
}


CTray::~CTray()
{
  SetEvent(event_finish);
  PostThreadMessage(id_thread,WM_QUIT,0,0);
  if ( WaitForSingleObject(h_thread,500) == WAIT_TIMEOUT )
     TerminateThread(h_thread,0);
  CloseHandle(h_thread);
  h_thread = NULL;

  CloseHandle(event_ready);
  event_ready = NULL;
  CloseHandle(event_finish);
  event_finish = NULL;

  DestroyWindow(tooltip);

  // rest was deleted in thread
  //....

  DeleteCriticalSection(&o_cs);
}


DWORD WINAPI CTray::ThreadProcWrapper(LPVOID lpParameter)
{
  CTray *obj = (CTray*)lpParameter;
  if ( obj )
     return obj->ThreadProc();

  return 0;
}


DWORD CTray::ThreadProc()
{
  CoInitialize(0);     // paranoja
  GdiSetBatchLimit(1);
  
  p_balloon = new CTrayBalloon();
  p_trayicons = new TTrayIcons();

  lasttime[0] = 0;
  
  const char *trayclass = "Shell_TrayWnd";
  const char *notifyclass = "TrayNotifyWnd";
  const char *clockclass = "TrayClockWClass";
  const char *rebarclass = "ReBarWindow32";
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = trayclass;
  RegisterClass(&wc);
  wc.lpszClassName = notifyclass;
  RegisterClass(&wc);  //DefWindowProc will be used for this wnd
  wc.lpszClassName = clockclass;
  RegisterClass(&wc);  //DefWindowProc will be used for this wnd

  traywnd = CreateWindowEx(WS_EX_TOOLWINDOW | WS_EX_TOPMOST/*TOPMOST is needed*/,trayclass,NULL,WS_POPUP,GetSystemMetrics(SM_CXSCREEN)-CLOCKW,GetSystemMetrics(SM_CYSCREEN)-cfg_theme2d->panel_height,0,0,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(traywnd);
  notifywnd = CreateWindowEx(0,notifyclass,NULL,WS_CHILD,0,0,0,0,traywnd,NULL,our_instance,NULL);
  clockwnd = CreateWindowEx(0,clockclass,NULL,WS_CHILD,0,0,0,0,notifywnd,NULL,our_instance,NULL);

  SetTimer(traywnd,1111,1000,NULL);

  SetEvent(event_ready);  // signal to main thread that we are ready

  // message loop
  do {

    MSG msg;
    while ( GetMessage(&msg,NULL,0,0) )
          DispatchMessage(&msg);

    if ( WaitForSingleObject(event_finish,0) == WAIT_OBJECT_0 )  // only exit if our destructor tells us
       break;
  
  } while ( 1 );

  p_balloon->Hide(NULL);

  DestroyWindow(clockwnd);
  clockwnd = NULL;
  DestroyWindow(notifywnd);
  notifywnd = NULL;
  DestroyWindow(traywnd);
  traywnd = NULL;
  UnregisterClass(notifyclass,our_instance);
  UnregisterClass(clockclass,our_instance);
  UnregisterClass(trayclass,our_instance);

  while ( p_trayicons->size() )
  {
    TTrayIcons::iterator it = p_trayicons->begin();
    CTrayIcon *i = *it;
    SAFEDELETE(i);
    p_trayicons->erase(it);
  }

  SAFEDELETE(p_trayicons);
  SAFEDELETE(p_balloon);

  CoUninitialize();
  return 1;
}


LRESULT CTray::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_DESTROY:
                   DoneWindowProcWrapper(hwnd);
                   return 0;
    
    //case WM_IME_NOTIFY:
    //               return 0;
    
    case WM_CLOSE:
                   return 0;

    case WM_TIMER:
                   if ( wParam == 1111 )
                      {
                        OnTimer();
                      }
                   return 0;

    case WM_COPYDATA:
                   return TrayCommand(wParam,lParam);

    case WM_WINDOWPOSCHANGING:
                   if ( IsIconic(hwnd) )
                      {
                        {
                          CCSGuard oGuard(o_cs);

                          WINDOWPOS *p = (WINDOWPOS*)lParam;
                          int sw = GetSystemMetrics(SM_CXSCREEN);
                          int sh = GetSystemMetrics(SM_CYSCREEN);
                          
                          p->hwnd = hwnd;
                          p->hwndInsertAfter = NULL;
                          p->x = sw - CLOCKW;
                          p->y = sh - cfg_theme2d->panel_height;
                          p->cx = 0;
                          p->cy = 0;
                          p->flags = SWP_HIDEWINDOW | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOSENDCHANGING | SWP_NOZORDER;
                        }

                        ShowWindow(hwnd,SW_RESTORE);
                        return 0;
                      }
                   break;

    case WM_DISPLAYCHANGE:
                   {
                     int sw,sh,x,y;
                     
                     {
                       CCSGuard oGuard(o_cs);

                       sw = LOWORD(lParam);
                       sh = HIWORD(lParam);
                       x = sw-CLOCKW;
                       y = sh-cfg_theme2d->panel_height;
                     }

                     SetWindowPos(hwnd,NULL,x,y,0,0,SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOREDRAW | SWP_NOSIZE | SWP_NOSENDCHANGING | SWP_NOZORDER);
                   }
                   break;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                   return 0;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


// called from main thread!
void CTray::OnNotifyMessage(NMHDR *nmhdr)
{
  if ( nmhdr && nmhdr->hwndFrom == tooltip && nmhdr->code == TTN_GETDISPINFO )
     {
       NMTTDISPINFO *i = (NMTTDISPINFO*)nmhdr;

       SendMessage(tooltip,TTM_SETTIPBKCOLOR,theme.tooltip_back,0);
       SendMessage(tooltip,TTM_SETTIPTEXTCOLOR,theme.tooltip_text,0);
       SendMessage(tooltip,TTM_SETMAXTIPWIDTH,0,300);

       CCSGuard oGuard(o_cs);

       int idx = i->hdr.idFrom;
       if ( idx >= 0 && idx < p_trayicons->size() )
          {
            static char text[MAX_PATH];  //must be static
            lstrcpyn(text,(*p_trayicons)[idx]->tip,sizeof(text)-1);
            i->lpszText = text;
          }
       else
       if ( idx == -1 )
          {
            static char s[MAX_PATH];  //must be static
            SYSTEMTIME t;
            GetLocalTime(&t);
            wsprintf(s,"%02d:%02d\n%02d.%02d.%04d\n%s",t.wHour,t.wMinute,t.wDay,t.wMonth,t.wYear,GetDOWString(t.wDayOfWeek));
            i->lpszText = s;
          }
       else
          {
            i->lpszText = "";
          }

       i->szText[0] = 0;
       i->hinst = NULL;
       i->uFlags = 0;
     }
}


// called from main thread!
void CTray::SetTips_NoGuard()
{
  const int old_count = SendMessage(tooltip,TTM_GETTOOLCOUNT,0,0);
  
  for ( int n = 0; n < old_count; n++ )
      {
        TOOLINFO i;
        ZeroMemory(&i,sizeof(i));
        i.cbSize = sizeof(i);

        SendMessage(tooltip,TTM_ENUMTOOLS,0,(int)&i);
        SendMessage(tooltip,TTM_DELTOOL,0,(int)&i);
      }

  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        TOOLINFO i;
        i.cbSize = sizeof(i);
        i.uFlags = TTF_SUBCLASS;
        i.hwnd = w_panel;
        i.uId = n;
        GetIconRect_NoGuard(n,&i.rect);
        i.hinst = NULL;
        i.lpszText = LPSTR_TEXTCALLBACK;

        if ( i.rect.right - i.rect.left > 0 ) // optimization
           {
             SendMessage(tooltip,TTM_ADDTOOL,0,(int)&i);
           }
      }

  //clock
  TOOLINFO i;
  i.cbSize = sizeof(i);
  i.uFlags = TTF_SUBCLASS;
  i.hwnd = w_panel;
  i.uId = -1;
  GetClockRect_NoGuard(&i.rect);
  i.hinst = NULL;
  i.lpszText = LPSTR_TEXTCALLBACK;
  SendMessage(tooltip,TTM_ADDTOOL,0,(int)&i);
}


// called from main thread!
int CTray::GetControlWidth(void)
{
  CCSGuard oGuard(o_cs);
  
  int visible_count = 0;
  for ( int n = 0; n < p_trayicons->size() && visible_count < cfg_max_vis; n++ )
      if ( (*p_trayicons)[n]->IsVisible() )
         {
           visible_count++;
         }
  
  return visible_count * (ICONW+2) + CLOCKW;
}


// called from main thread!
void CTray::GetIconRect_NoGuard(int num,RECT *r)
{
  if ( num < 0 || num >= p_trayicons->size() )
     {
       SetRectEmpty(r);
     }
  else
     {
       int visible_count = 0;
       for ( int n = 0; n < num && visible_count < cfg_max_vis; n++ )
           if ( (*p_trayicons)[n]->IsVisible() )
              {
                visible_count++;
              }

       int width = ((*p_trayicons)[num]->IsVisible() && visible_count < cfg_max_vis) ? ICONW : 0;
       
       RECT r1;
       GetClientRect(w_panel,&r1);

       r->right = r1.right - (visible_count*(ICONW+2)+CLOCKW);
       r->left = r->right - width;
       r->top = cfg_theme2d->transparent_pad + (cfg_theme2d->panel_height-ICONH)/2;
       r->bottom = r->top+ICONH;
     }
}


// called from main thread!
void CTray::GetClockRect_NoGuard(RECT *r)
{
  GetClientRect(w_panel,r);
  r->left = r->right - CLOCKW;
  r->top = cfg_theme2d->transparent_pad;
}


BOOL CTray::IsWindowInList(HWND w,const TCFGLIST1& list)
{
  if ( w )
     {
       char s[MAX_PATH] = "";
       GetWindowProcessFileName(w,s);

       if ( s[0] )
          {
            for ( int n = 0; n < list.size(); n++ )
                {
                  if ( list[n].IsActive() )
                     {
                       if ( !lstrcmpi(s,list[n].GetParm()) )
                          return TRUE;
                     }
                }
          }
     }

  return FALSE;
}


// called from main thread!
void CTray::ClockClick(int message)
{
  if ( message == WM_LBUTTONDBLCLK )
     {
       //todo
     }
}


// called from main thread!
void CTray::OnClick(int message,WPARAM wParam,LPARAM lParam)
{
  CCSGuard oGuard(o_cs);

  POINT p;
  p.x = (int)(short)(LOWORD(lParam));
  p.y = (int)(short)(HIWORD(lParam));

  RECT r;
  GetClockRect_NoGuard(&r);
  if ( PtInRect(&r,p) )
     {
       ClockClick(message);
       return;
     }
  
  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        RECT r;
        GetIconRect_NoGuard(n,&r);
        if ( PtInRect(&r,p) )
           {
             const CTrayIcon *icon = (*p_trayicons)[n];

             BOOL allow = FALSE;

             if ( icon->hwnd == w_main || message == WM_MOUSEMOVE || !cfg_is_safe_tray )
                allow = TRUE;
             else
                allow = IsWindowInList(icon->hwnd,cfg_list_safe);
             
             // special check for USB devices eject
             if ( !allow )
                {
                  char s[MAX_PATH] = "";
                  GetClassName(icon->hwnd,s,sizeof(s));
                  if ( !lstrcmpi(s,"SystemTray_Main") )
                     {
                       if ( icon->message == WM_USER + 202 && icon->id == WM_USER + 202 )
                          {
                            if ( message == WM_LBUTTONDBLCLK || message == WM_RBUTTONUP )
                               {
                                 message = WM_LBUTTONUP;
                               }

                            allow = TRUE;
                          }
                     }
                }
             
             // special check for lang indicator
             if ( !allow )
                {
                  char s[MAX_PATH] = "";
                  GetClassName(icon->hwnd,s,sizeof(s));
                  if ( !lstrcmpi(s,"Indicator") )
                     {
                       if ( message == WM_LBUTTONDOWN || message == WM_LBUTTONUP )
                          {
                            allow = TRUE;
                          }
                     }
                }
             
             if ( allow )
                {
                  if ( icon->message != -1 && icon->hwnd && IsWindow(icon->hwnd) )
                     {
                       if ( message == WM_LBUTTONDOWN || message == WM_RBUTTONDOWN || message == WM_MBUTTONDOWN )
                          {
                            DWORD pid = 0;
                            GetWindowThreadProcessId(icon->hwnd,&pid);
                            AllowSetForegroundWindow(pid);
                          }
                       
                       if ( icon->version < 4 )
                          {
                            PostMessage(icon->hwnd,icon->message,icon->id,message);
                          }
                       else
                          {
                            ClientToScreen(w_panel,&p);
                            PostMessage(icon->hwnd,icon->message,MAKEWPARAM(p.x&0xFFFF,p.y&0xFFFF),MAKELPARAM(message,icon->id&0xFFFF));
                          }
                     }
                }

             break;
           }
      }
}


void CTray::DrawClock_NoGuard(HDC hdc)
{
  if ( hdc )
     {
       HFONT font = CreateFont(-11,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
       HFONT oldfont = (HFONT)SelectObject(hdc,font);
       SetBkMode(hdc,TRANSPARENT);
       SetTextColor(hdc,cfg_theme2d->is_light ? theme.inactivetext : theme.activetext);
       RECT r;
       GetClockRect_NoGuard(&r);
       SYSTEMTIME t;
       GetLocalTime(&t);
       char s[MAX_PATH];
       wsprintf(s,"%02d:%02d",t.wHour,t.wMinute);
       if ( !cfg_theme2d->is_light )
          DrawTextWithShadow(hdc,s,&r,DT_CENTER | DT_VCENTER | DT_SINGLELINE,0,2);
       else
          DrawText(hdc,s,-1,&r,DT_CENTER | DT_VCENTER | DT_SINGLELINE);
       SelectObject(hdc,oldfont);
       DeleteObject(font);
     }
  else
     {
       RECT r;
       GetClockRect_NoGuard(&r);
       InvalidateRect(w_panel,&r,FALSE);
     }
}


BOOL CTray::IsTimeChanged(void)
{
  SYSTEMTIME t;
  GetLocalTime(&t);
  char s[20];
  wsprintf(s,"%02d:%02d",t.wHour,t.wMinute);
  BOOL rc = (lstrcmp(lasttime,s) != 0);
  lstrcpy(lasttime,s);
  return rc;
}


void CTray::DrawIcons_NoGuard(HDC hdc)
{
  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        RECT r;
        GetIconRect_NoGuard(n,&r);
        if ( r.right - r.left > 0 )
           {
             DrawIconEx(hdc,r.left,r.top,(*p_trayicons)[n]->icon,ICONW,ICONH,0,NULL,DI_NORMAL);
           }
      }
}


// called from main thread!
void CTray::OnRedrawSingleIcon(WPARAM wParam,LPARAM lParam)
{
  ICONID *ii = (ICONID*)wParam;
  
  if ( ii )
     {
       CCSGuard oGuard(o_cs);

       for ( int idx = 0; idx < p_trayicons->size(); idx++ )
           {
             if ( (*p_trayicons)[idx]->IsSame(ii->hwnd,ii->id,ii->guid) )
                {
                  RECT r;
                  GetIconRect_NoGuard(idx,&r);
                  if ( r.right - r.left > 0 )
                     {
                       RECT c;
                       GetClientRect(w_panel,&c);
                       c.left = r.left;
                       c.right = r.right;
                       c.top = cfg_theme2d->transparent_pad;
                       HDC hdc = GetDC(w_panel);
                       Draw_Theme_Rect(hdc,&c);
                       DrawIconEx(hdc,r.left,r.top,(*p_trayicons)[idx]->icon,ICONW,ICONH,0,NULL,DI_NORMAL);
                       ReleaseDC(w_panel,hdc);
                     }
                  
                  break;
                }
           }

       sys_free(ii);
     }
}



// called from main thread!
void CTray::OnPaint(HDC hdc)
{
  CCSGuard oGuard(o_cs);

  DrawIcons_NoGuard(hdc);
  DrawClock_NoGuard(hdc);
}



void CTray::OnTimer(void)
{
  CCSGuard oGuard(o_cs);

  // dead windows
  BOOL deleted;
  do {
    deleted = FALSE;
    for ( int n = 0; n < p_trayicons->size(); n++ )
        if ( !IsWindow((*p_trayicons)[n]->hwnd) )
           {
             DeleteTrayIcon_NoGuard(n);
             deleted = TRUE;
             break;
           }
  } while ( deleted );

  //clock
  if ( IsTimeChanged() )
     {
       DrawClock_NoGuard(NULL);
     }
}



// called from main thread!
void CTray::OnConfigChange(void)
{
  CCSGuard oGuard(o_cs);

  cfg_theme2d = Get2DTheme();
  cfg_list_safe = safe_tray_icons;
  cfg_list_hidden = hidden_tray_icons;
  cfg_max_vis = max_vis_tray_icons;
  cfg_is_safe_tray = safe_tray;

  //p_balloon->Hide(NULL); //can't call from this thread
  
  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        CTrayIcon *icon = (*p_trayicons)[n];
        icon->hide_in_user_mode = IsWindowInList(icon->hwnd,cfg_list_hidden) || 
                                  icon->IsHiddenSystemIcon();
      }

  SetTips_NoGuard();
}


// called from main thread!
void CTray::OnDisplayChange(int sw,int sh) 
{
  CCSGuard oGuard(o_cs);

  SetTips_NoGuard();
}


// called from main thread!
void CTray::OnUpdate()
{
  CCSGuard oGuard(o_cs);

  SetTips_NoGuard();
}


BOOL CTray::DeleteTrayIcon_NoGuard(int idx)
{
  BOOL rc = FALSE;
  
  if ( idx >= 0 && idx < p_trayicons->size() )
     {
       p_balloon->Hide((*p_trayicons)[idx]);

       int n = 0;
       for ( TTrayIcons::iterator it = p_trayicons->begin(); it != p_trayicons->end(); ++it, ++n )
           {
             if ( n == idx )
                {
                  CTrayIcon *icon = *it;
                  BOOL b_icon_was_hidden = icon->IsHidden();

                  SAFEDELETE(icon);
                  p_trayicons->erase(it);

                  if ( !b_icon_was_hidden )
                     {
                       PostMessage(w_panel,msg_panel_update,0,0);
                     }

                  rc = TRUE;
                  break;
                }
           }
     }

  return rc;
}


BOOL CTray::DeleteTrayIcon(const ICONID *icon)
{
  CCSGuard oGuard(o_cs);

  BOOL rc = FALSE;

  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        if ( (*p_trayicons)[n]->IsSame(icon->hwnd,icon->id,icon->guid) )
           {
             rc = DeleteTrayIcon_NoGuard(n);
             break;
           }
      }

  return rc;
}


BOOL CTray::SetTrayIconVersion(const ICONID *icon,int version)
{
  CCSGuard oGuard(o_cs);

  BOOL rc = FALSE;

  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        if ( (*p_trayicons)[n]->IsSame(icon->hwnd,icon->id,icon->guid) )
           {
             (*p_trayicons)[n]->version = version;
             rc = TRUE;
             break;
           }
      }

  return rc;
}


BOOL CTray::GetTrayIconRect(const ICONID *icon,RECT *_r)
{
  SetRectEmpty(_r);

  CCSGuard oGuard(o_cs);

  BOOL rc = FALSE;

  for ( int n = 0; n < p_trayicons->size(); n++ )
      {
        if ( (*p_trayicons)[n]->IsSame(icon->hwnd,icon->id,icon->guid) )
           {
             GetIconRect_NoGuard(n,_r);
             RECT wr = {0,0,0,0};
             GetWindowRect(w_panel,&wr);
             OffsetRect(_r,wr.left,wr.top);
             rc = TRUE;
             break;
           }
      }

  return rc;
}


BOOL CTray::ModifyTrayIcon(const NOTIFYICONDATAMY *icon)
{
  CCSGuard oGuard(o_cs);

  int idx = -1;
  for ( int n = 0; n < p_trayicons->size(); n++ )
      if ( (*p_trayicons)[n]->IsSame(icon->hWnd,icon->uID,icon->guidItem) )
         {
           idx = n;
           break;
         }

  if ( idx == -1 )
     return FALSE;

  if ( (icon->uFlags & (NIF_ICON|NIF_MESSAGE|NIF_TIP|NIF_STATE|NIF_INFO)) == 0 )
     return TRUE;
  
  CTrayIcon *newicon = (*p_trayicons)[idx];

  BOOL full_update = FALSE;
  BOOL part_update = FALSE;

  if ( icon->uFlags & NIF_ICON )
     {
       newicon->ReplaceIcon(icon->hIcon);
       part_update = TRUE;
     }

  if ( icon->uFlags & NIF_MESSAGE )
     newicon->message = icon->uCallbackMessage;

  if ( icon->uFlags & NIF_TIP )
     lstrcpyn(newicon->tip,icon->szTip,sizeof(newicon->tip)-1);

  if ( icon->uFlags & NIF_STATE )
     {
       if ( icon->dwStateMask & NIS_HIDDEN )
          {
            BOOL old = newicon->hidden;
            newicon->hidden = (icon->dwState & NIS_HIDDEN) ? TRUE : FALSE;
            if ( (old && !newicon->hidden) || (!old && newicon->hidden) )
               full_update = TRUE;
          }
     }

  if ( full_update && newicon->hidden )
     p_balloon->Hide(newicon);

  if ( icon->uFlags & NIF_INFO )
     p_balloon->Show(newicon,icon->szInfo,icon->szInfoTitle,icon->uTimeout,icon->dwInfoFlags);


  if ( full_update )
     {
       PostMessage(w_panel,msg_panel_update,0,0);
     }
  else
  if ( part_update )
     {
       if ( newicon->IsVisible() )
          {
            ICONID *i = (ICONID*)sys_alloc(sizeof(ICONID));

            i->hwnd = newicon->hwnd;
            i->id = newicon->id;
            i->guid = newicon->guid;
            
            PostMessage(w_panel,msg_redraw_single_icon,(WPARAM)i,0);
          }
     }

  return TRUE;
}


BOOL CTray::AddTrayIcon(const NOTIFYICONDATAMY *icon)
{
  CCSGuard oGuard(o_cs);

  for ( int n = 0; n < p_trayicons->size(); n++ )
      if ( (*p_trayicons)[n]->IsSame(icon->hWnd,icon->uID,icon->guidItem) )
         return FALSE;

  if ( p_trayicons->size() == MAXICONS )
     return FALSE;

  CTrayIcon *newicon = new CTrayIcon();

  newicon->version = icon->uVersion;
  newicon->hwnd = icon->hWnd;
  newicon->id = icon->uID;
  newicon->guid = icon->guidItem; // assume that guidItem already set according to NIF_GUID flag
  newicon->message = -1;
  newicon->icon = NULL;
  newicon->hidden = FALSE;
  newicon->hide_in_user_mode = (IsWindowInList(newicon->hwnd,cfg_list_hidden) || newicon->IsHiddenSystemIcon());
  newicon->tip[0] = 0;

  if ( icon->uFlags & NIF_ICON )
     newicon->icon = icon->hIcon ? CopyIcon(icon->hIcon) : NULL;

  if ( icon->uFlags & NIF_MESSAGE )
     newicon->message = icon->uCallbackMessage;

  if ( icon->uFlags & NIF_TIP )
     lstrcpyn(newicon->tip,icon->szTip,sizeof(newicon->tip)-1);

  if ( icon->uFlags & NIF_STATE )
     {
       if ( icon->dwStateMask & NIS_HIDDEN )
          newicon->hidden = (icon->dwState & NIS_HIDDEN) ? TRUE : FALSE;
     }

  if ( newicon->icon == NULL )
     {
       char s[MAX_PATH] = "";
       GetClassName(newicon->hwnd,s,sizeof(s));
       if ( lstrcmpi(s,"SystemTray_Main") && lstrcmpi(s,"Connections Tray") )
          {
            newicon->icon = CopyIcon(LoadIcon(our_instance,MAKEINTRESOURCE(IDI_EMPTY)));
          }
       else
          {
            SAFEDELETE(newicon);
            return FALSE;  //some mystique fix
          }
     }

  p_trayicons->push_back(newicon);

  if ( icon->uFlags & NIF_INFO )
     p_balloon->Show(newicon,icon->szInfo,icon->szInfoTitle,icon->uTimeout,icon->dwInfoFlags);

  if ( newicon->IsVisible() )
     {
       PostMessage(w_panel,msg_panel_update,0,0);
     }

  return TRUE;
}



// Shell_NotifyIcon()
typedef struct {
int id;  //fixed value
int message;  // add,delete,modify...
NOTIFYICONDATA icon;
} TRAYICONSTRUCT;

typedef struct {
  DWORD cbSize;
  HWND hWnd;
  UINT uID;
  UINT uFlags;
  UINT uCallbackMessage;
  HICON hIcon;
  WCHAR szTip[128];
  DWORD dwState;
  DWORD dwStateMask;
  WCHAR szInfo[256];
  union {
  	UINT uTimeout;
  	UINT uVersion;
  };
  WCHAR szInfoTitle[64];
  DWORD dwInfoFlags;
} NOTIFYICONDATA5;

typedef struct {
  DWORD cbSize;
  HWND hWnd;
  UINT uID;
  UINT uFlags;
  UINT uCallbackMessage;
  HICON hIcon;
  WCHAR szTip[128];
  DWORD dwState;
  DWORD dwStateMask;
  WCHAR szInfo[256];
  union {
  	UINT uTimeout;
  	UINT uVersion;
  };
  WCHAR szInfoTitle[64];
  DWORD dwInfoFlags;
  GUID guidItem;
} NOTIFYICONDATA6;

typedef struct {
  DWORD cbSize;
  HWND hWnd;
  UINT uID;
  UINT uFlags;
  UINT uCallbackMessage;
  HICON hIcon;
  WCHAR  szTip[64];
} NOTIFYICONDATA1W;

typedef struct {
  DWORD cbSize;
  HWND hWnd;
  UINT uID;
  UINT uFlags;
  UINT uCallbackMessage;
  HICON hIcon;
  char  szTip[64];
} NOTIFYICONDATA1A;


LRESULT CTray::TrayCommandNotify(WPARAM wParam,void *lpData,int cbData)
{
  const TRAYICONSTRUCT *tray = (TRAYICONSTRUCT*)lpData;

  if ( !tray || cbData < 4 )
     return 0;

  if ( tray->id != 0x34753423 )
     return 0;

  if ( cbData < 8 )
     return 0;

  switch ( tray->message )
  {
    case NIM_ADD:
    case NIM_MODIFY:
    case NIM_DELETE:
    case NIM_SETFOCUS:
    case NIM_SETVERSION:
              break;

    default:
              return 0;
  }

  if ( tray->message == NIM_SETFOCUS )
     {
       SetForegroundWindow(traywnd);
       return 1;
     }

  if ( cbData < 12 )
     return 0;

  const NOTIFYICONDATA1A *icon = (NOTIFYICONDATA1A*)&tray->icon;
  const NOTIFYICONDATA5 *icon5 = (NOTIFYICONDATA5*)&tray->icon;
  const NOTIFYICONDATA6 *icon6 = (NOTIFYICONDATA6*)&tray->icon;

  if ( icon->cbSize < sizeof(NOTIFYICONDATA1A) )
     return 0;

  const BOOL v5 = (icon->cbSize >= sizeof(NOTIFYICONDATA5));
  const BOOL v6 = (icon->cbSize >= sizeof(NOTIFYICONDATA6));
  const int flags = icon->uFlags;

  ICONID iid;
  iid.hwnd = icon->hWnd;
  iid.id = icon->uID;
  iid.guid = (v6 && (flags&NIF_GUID)) ? icon6->guidItem : GetEmptyGUID();

  if ( tray->message == NIM_DELETE )
     {
       return DeleteTrayIcon(&iid) ? 1 : 0;
     }

  if ( tray->message == NIM_SETVERSION )
     {
       return v5 ? (SetTrayIconVersion(&iid,icon5->uVersion) ? 1 : 0) : 0;
     }

  
  NOTIFYICONDATAMY newicon;
  ZeroMemory(&newicon,sizeof(newicon));
  
  newicon.uVersion = 3; // win2000/xp
  newicon.hWnd = iid.hwnd;
  newicon.uID = iid.id;
  newicon.guidItem = iid.guid;
  newicon.uFlags = flags;
  newicon.uCallbackMessage = (flags & NIF_MESSAGE) ? icon->uCallbackMessage : -1;
  newicon.hIcon = (flags & NIF_ICON) ? icon->hIcon : NULL;

  if ( flags & NIF_TIP )
     {
       if ( icon->cbSize == sizeof(NOTIFYICONDATA1W) )
          {
            WCHAR t[64];
            lstrcpynW(t,(WCHAR*)icon->szTip,64);
            WideCharToMultiByte(CP_ACP,0,t,-1,newicon.szTip,sizeof(newicon.szTip)-1,NULL,NULL);
          }
       else
       if ( v5 )
          {
            WCHAR t[128];
            lstrcpynW(t,(WCHAR*)icon->szTip,128);
            WideCharToMultiByte(CP_ACP,0,t,-1,newicon.szTip,sizeof(newicon.szTip)-1,NULL,NULL);
          }
       else
          {
            lstrcpyn(newicon.szTip,icon->szTip,64);
          }
     }

  if ( (flags & NIF_STATE) && v5 )
     {
       newicon.dwState = icon5->dwState;
       newicon.dwStateMask = icon5->dwStateMask;
     }

  if ( (flags & NIF_INFO) && v5 )
     {
       WideCharToMultiByte(CP_ACP,0,icon5->szInfo,-1,newicon.szInfo,sizeof(newicon.szInfo)-1,NULL,NULL);

       if ( newicon.szInfo[0] )
          {
            WideCharToMultiByte(CP_ACP,0,icon5->szInfoTitle,-1,newicon.szInfoTitle,sizeof(newicon.szInfoTitle)-1,NULL,NULL);
            newicon.uTimeout = icon5->uTimeout;
            newicon.dwInfoFlags = icon5->dwInfoFlags;
          }
     }

  if ( tray->message == NIM_ADD )
     {
       return AddTrayIcon(&newicon) ? 1 : 0;
     }

  if ( tray->message == NIM_MODIFY )
     {
       return ModifyTrayIcon(&newicon) ? 1 : 0;
     }

  return 0;  // never happens
}


// SHAppBarMessage()

typedef struct {
    DWORD dwMessage;
    HANDLE hSharedABD;
    DWORD dwProcId;
} TRAYAPPBARDATA2;

typedef struct {
    DWORD dwMessage;
    LPVOID pUnknown1;
    HANDLE hSharedABD;
    DWORD dwUnknown2;
    DWORD dwProcId;
//    LPVOID pUnknown3;
} TRAYAPPBARDATA3;


LRESULT CTray::TrayCommandAppBar(WPARAM wParam,void *lpData,int cbData)
{
  if ( !lpData || cbData < sizeof(APPBARDATA) )
     return 0;

  const APPBARDATA *abd = (APPBARDATA*)lpData;

  if ( abd->cbSize < sizeof(APPBARDATA) )
     return 0;

  DWORD dwMessage = -1;
  HANDLE hSharedABD = NULL;
  DWORD dwProcId = 0;
  
  int add_size = cbData - (int)abd->cbSize;
  if ( add_size >= sizeof(TRAYAPPBARDATA3) )
     {
       const TRAYAPPBARDATA3 *tray = (TRAYAPPBARDATA3*)((char*)abd + abd->cbSize);
       dwMessage = tray->dwMessage;
       hSharedABD = tray->hSharedABD;
       dwProcId = tray->dwProcId;
     }
  else
  if ( add_size >= sizeof(TRAYAPPBARDATA2) )
     {
       const TRAYAPPBARDATA2 *tray = (TRAYAPPBARDATA2*)((char*)abd + abd->cbSize);
       dwMessage = tray->dwMessage;
       hSharedABD = tray->hSharedABD;
       dwProcId = tray->dwProcId;
     }
  else
     {
       return 0;
     }

  switch ( dwMessage )
  {
    case ABM_GETSTATE:
    case ABM_GETTASKBARPOS:
    //case ABM_QUERYPOS:
                         break;
    default:
                         return 0;
  }

  if ( dwMessage == ABM_GETSTATE )
     {
       return ABS_ALWAYSONTOP;  // maybe 0 better?
     }

  if ( dwMessage == ABM_GETTASKBARPOS )
     {
       if ( !hSharedABD )
          return 0;

       const char *dllname = is_vista ? "shlwapi.dll" : "shell32.dll";
       void* (WINAPI *pSHLockShared)(HANDLE hData, DWORD dwSourceProcessId);
       BOOL (WINAPI *pSHUnlockShared)(void *pvData);
       *(void**)&pSHLockShared = (void*)GetProcAddress(GetModuleHandle(dllname),"SHLockShared");
       *(void**)&pSHUnlockShared = (void*)GetProcAddress(GetModuleHandle(dllname),"SHUnlockShared");

       if ( !pSHLockShared || !pSHUnlockShared )
          return 0;

       APPBARDATA *abd = (APPBARDATA*)pSHLockShared(hSharedABD,dwProcId);
       if ( !abd )
          return 0;

       abd->uEdge = ABE_BOTTOM;
       {
         CCSGuard oGuard(o_cs);
         
         RECT *r = &abd->rc;
         GetWindowRect(w_panel,r);
         r->top = r->bottom - cfg_theme2d->panel_height;
       }

       pSHUnlockShared(abd);

       return 1;
     }

  return 0;
}


// SHLoadInProc()

LRESULT CTray::TrayCommandLoadInProc(WPARAM wParam,void *lpData,int cbData)
{
  return E_FAIL;
}


// Shell_NotifyIconGetRect 

typedef struct {
int cbSize;
DWORD dwUnknown1;
HWND hwnd;
int id;
GUID guid;
} ICONID2;

typedef struct {
int id;  //fixed value
int message;  // 1 or 2
ICONID2 iid;
} TRAYICONRECTSTRUCT;

LRESULT CTray::TrayCommandIconGetRect(WPARAM wParam,void *lpData,int cbData)
{
  const TRAYICONRECTSTRUCT *tray = (TRAYICONRECTSTRUCT*)lpData;

  if ( !tray || cbData < sizeof(TRAYICONRECTSTRUCT) )
     return 0;

  if ( tray->id != 0x34753423 )
     return 0;

  if ( tray->message != 1 && tray->message != 2 )
     return 0;

  ICONID iid;
  iid.hwnd = tray->iid.hwnd;
  iid.id = tray->iid.id;
  iid.guid = tray->iid.guid;

  RECT r = {0,0,0,0};
  
  if ( !GetTrayIconRect(&iid,&r) )
     return 0;

  WORD x = r.left;
  WORD y = r.top;
  WORD w = (r.right-r.left);
  WORD h = (r.bottom-r.top);

  return tray->message == 1 ? MAKELONG(x,y) : MAKELONG(w,h);
}



LRESULT CTray::TrayCommand(WPARAM wParam,LPARAM lParam)
{
  LRESULT rc = 0;
  const COPYDATASTRUCT *data = (COPYDATASTRUCT *)lParam;

  if ( !data || !data->lpData || data->cbData < 4 )
     return rc;

//  __try
  {
    switch ( data->dwData )
    {
      case 0: //TCDM_APPBAR
           rc = TrayCommandAppBar(wParam,data->lpData,data->cbData);
           break;

      case 1: //TCDM_NOTIFY
           rc = TrayCommandNotify(wParam,data->lpData,data->cbData);
           break;

      case 2: //TCDM_LOADINPROC
           rc = TrayCommandLoadInProc(wParam,data->lpData,data->cbData);
           break;

      case 3: //TCDM_NOTIFYICONGETRECT
           rc = TrayCommandIconGetRect(wParam,data->lpData,data->cbData);
           break;
    }
  }
//  __except ( EXCEPTION_EXECUTE_HANDLER )
//  {
//    rc = 0;
//  }

  return rc;
}
