
#include "include.h"


static const char *balloon_class = "_BalloonClass";


CTrayBalloon::CTrayBalloon()
{
  balloon_hwnd = NULL;
  version = 3;  //win2000/xp
  hwnd = NULL;
  id = 0;
  ZeroMemory(&guid,sizeof(guid));
  message = -1;
  icon = NULL;
  szInfo[0] = 0;
  szInfoTitle[0] = 0;
  close_icon = NULL;
  font1 = NULL;
  font2 = NULL;
  exit_code = -1;
  SetRectEmpty(&r_icon);
  SetRectEmpty(&r_close);
  SetRectEmpty(&r_title);
  SetRectEmpty(&r_text);
  SetRectEmpty(&r_window);
  ZeroMemory(&back_buff,sizeof(back_buff));
}


CTrayBalloon::~CTrayBalloon()
{
  Hide(NULL);
}


BOOL CTrayBalloon::IsShown(const CTrayIcon *newicon) const
{
  if ( !newicon )
     return this->balloon_hwnd != NULL;

  if ( !this->balloon_hwnd )
     return FALSE;

  return newicon->IsSame(this->hwnd,this->id,this->guid);
}


void CTrayBalloon::Hide(const CTrayIcon *newicon)
{
  if ( newicon )
     {
       if ( !IsShown(newicon) )
          return;
     }

  if ( !IsShown(NULL) )
    return;

  this->exit_code = NIN_BALLOONHIDE;
  DestroyWindow(this->balloon_hwnd);
}


void CTrayBalloon::Draw(HWND hwnd,HDC hdc)
{
  RECT r;
  GetClientRect(hwnd,&r);
  int ww = r.right - r.left;
  int wh = r.bottom - r.top;

  RBUFF buff;
  RB_CreateNormal(&buff,ww,wh);
  
  RB_Fill(&buff,theme.tooltip_back);  // assume thread safe :)
  FrameRect(buff.hdc,&r,(HBRUSH)GetStockObject(BLACK_BRUSH));

  if ( this->back_buff.hdc )
     {
       MakeTransparent(buff.hdc,this->back_buff.hdc,0,0,0,0,ww,wh,230);
     }

  if ( this->icon )
     {
       int x = this->r_icon.left;
       int y = this->r_icon.top;
       int w = 32;
       int h = 32;
       DrawIconEx(buff.hdc,x,y,this->icon,w,h,0,NULL,DI_NORMAL);
     }

  if ( this->close_icon )
     {
       int x = this->r_close.left;
       int y = this->r_close.top;
       int w = 16;
       int h = 16;
       DrawIconEx(buff.hdc,x,y,this->close_icon,w,h,0,NULL,DI_NORMAL);
     }

  if ( this->szInfoTitle[0] )
     {
       HFONT oldfont = (HFONT)SelectObject(buff.hdc,this->font1);
       SetBkMode(buff.hdc,TRANSPARENT);
       SetTextColor(buff.hdc,theme.tooltip_text); // assume thread safe :)
       DrawText(buff.hdc,this->szInfoTitle,-1,&this->r_title,DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX | DT_EXPANDTABS);
       SelectObject(buff.hdc,oldfont);
     }
     
  if ( this->szInfo[0] )
     {
       HFONT oldfont = (HFONT)SelectObject(buff.hdc,this->font2);
       SetBkMode(buff.hdc,TRANSPARENT);
       SetTextColor(buff.hdc,theme.tooltip_text);  // assume thread safe :)
       DrawText(buff.hdc,this->szInfo,-1,&this->r_text,DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX | DT_EXPANDTABS);
       SelectObject(buff.hdc,oldfont);
     }

  RB_PaintTo(&buff,hdc);
  RB_Destroy(&buff);
}


LRESULT CTrayBalloon::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_CLOSE:
                       return 0;

    case WM_MOUSEACTIVATE:
                       return MA_NOACTIVATE;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                       return 0;
                       
    case WM_LBUTTONUP:
    case WM_RBUTTONUP:
    case WM_MBUTTONUP:
                       this->exit_code = NIN_BALLOONHIDE;//NIN_BALLOONUSERCLICK;
                       DestroyWindow(hwnd);
                       return 0;

    case WM_TIMER:
                       this->exit_code = NIN_BALLOONTIMEOUT;
                       DestroyWindow(hwnd);
                       return 0;

    case WM_DISPLAYCHANGE:
                       this->exit_code = NIN_BALLOONHIDE;
                       DestroyWindow(hwnd);
                       return 0;

    case WM_DESTROY:
                       DoneWindowProcWrapper(hwnd);
                       UnregisterClass(balloon_class,our_instance);
                       if ( this->icon )
                          DestroyIcon(this->icon);
                       this->icon = NULL;
                       if ( this->font1 )
                          DeleteObject(this->font1);
                       this->font1 = NULL;
                       if ( this->font2 )
                          DeleteObject(this->font2);
                       this->font2 = NULL;
                       RB_Destroy(&this->back_buff);

                       this->balloon_hwnd = NULL;

                       if ( this->hwnd && IsWindow(this->hwnd) && this->message != -1 && this->exit_code != -1 )
                          {
                            if ( this->version < 4 )
                               {
                                 PostMessage(this->hwnd,this->message,this->id,this->exit_code);
                               }
                            else
                               {
                                 PostMessage(this->hwnd,this->message,0,MAKELPARAM((this->exit_code&0xFFFF),(this->id&0xFFFF)));
                               }
                          }
                       return 0;

    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);
                         Draw(hwnd,hdc);
                         EndPaint(hwnd,&ps);
                       }
                       return 0;

    case WM_PRINTCLIENT:
                       Draw(hwnd,(HDC)wParam);
                       return 0;

    case WM_WINDOWPOSCHANGING:
                     if ( IsIconic(hwnd) )
                        {
                          WINDOWPOS *p = (WINDOWPOS*)lParam;
                          
                          p->hwnd = hwnd;
                          p->hwndInsertAfter = HWND_TOPMOST;
                          p->x = this->r_window.left;
                          p->y = this->r_window.top;
                          p->cx = this->r_window.right - this->r_window.left;
                          p->cy = this->r_window.bottom - this->r_window.top;
                          p->flags = SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_SHOWWINDOW;

                          ShowWindow(hwnd,SW_RESTORE);
                          return 0;
                        }
                     break;
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CTrayBalloon::Show(const CTrayIcon *newicon,const char *szInfo,const char *szInfoTitle,DWORD uTimeout,DWORD dwInfoFlags)
{
  int w,h,x,y;

  if ( IsStrEmpty(szInfo) )
     {
       Hide(newicon);
       return;
     }

  if ( !newicon )
     return;

  if ( newicon->IsHidden() )
     {
       Hide(newicon);
       return;
     }

  if ( IsShown(newicon) )
     Hide(newicon);

  if ( IsShown(NULL) )
     return;

  if ( IsFullScreenAppFind() )  //ddraw games
     return;

  if ( uTimeout < 10000 )
     uTimeout = 10000;
  if ( uTimeout > 30000 )
     uTimeout = 30000;

  HICON icon = NULL;
  switch ( (dwInfoFlags & NIIF_ICON_MASK) )
  {
    case NIIF_ERROR:
                     icon = LoadIcon(NULL,IDI_ERROR);
                     break;
    case NIIF_INFO:
                     icon = LoadIcon(NULL,IDI_INFORMATION);
                     break;
    case NIIF_NONE:
                     icon = NULL;
                     break;
    case NIIF_WARNING:
                     icon = LoadIcon(NULL,IDI_WARNING);
                     break;
    default:
                     icon = newicon->icon;
                     break;
  };

  if ( !szInfoTitle[0] )
     icon = NULL;

  this->version = newicon->version;
  this->hwnd = newicon->hwnd;
  this->id = newicon->id;
  this->guid = newicon->guid;
  this->message = newicon->message;
  this->icon = icon ? CopyIcon(icon) : NULL;
  lstrcpy(this->szInfo,szInfo);
  lstrcpy(this->szInfoTitle,szInfoTitle);
  this->close_icon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_X));
  this->font1 = CreateFont(-10,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  this->font2 = CreateFont(-10,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = CanUseGFXThreadSafe() ? (is_w2k ? 0 : CS_DROPSHADOW) : 0;
  wc.hCursor = LoadCursor(NULL,IDC_ARROW);
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = balloon_class;
  RegisterClass(&wc);

  {
    const int border = 10;
    int icon_w,icon_h,text_width,text1_height,text2_height,close_w,close_h;
    int left,right,top,bottom;

    icon_w = this->icon ? 32+border : 0;
    icon_h = this->icon ? 32 : 0;
    close_w = 16;
    close_h = 16;
    text_width = 240;
    text1_height = 0;

    if ( this->szInfoTitle[0] )
       {
         RECT r;
         HDC hdc = CreateCompatibleDC(NULL);
         HFONT oldfont = (HFONT)SelectObject(hdc,this->font1);
         r.left = 0;
         r.top = 0;
         r.right = text_width;
         r.bottom = 10;
         DrawText(hdc,this->szInfoTitle,-1,&r,DT_CALCRECT | DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX | DT_EXPANDTABS);
         SelectObject(hdc,oldfont);
         DeleteDC(hdc);

         if ( r.right > text_width )
            text_width = r.right;
         text1_height = r.bottom + border;
       }

    text2_height = 0;

    if ( this->szInfo[0] )
       {
         RECT r;
         HDC hdc = CreateCompatibleDC(NULL);
         HFONT oldfont = (HFONT)SelectObject(hdc,this->font2);
         r.left = 0;
         r.top = 0;
         r.right = text_width;
         r.bottom = 10;
         DrawText(hdc,this->szInfo,-1,&r,DT_CALCRECT | DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX | DT_EXPANDTABS);
         SelectObject(hdc,oldfont);
         DeleteDC(hdc);

         if ( r.right > text_width )
            text_width = r.right;
         text2_height = r.bottom;
       }

    w = border + icon_w + text_width + border + close_w + border;
    h = border + MAX( MAX( icon_h, text1_height+text2_height ), close_h ) + border;
    RECT area = {0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN)};
    SystemParametersInfo(SPI_GETWORKAREA,0,&area,0);
    x = area.right-w-5;
    y = area.bottom-h-5;
    SetRect(&this->r_window,x,y,x+w,y+h);

    left = border;
    top = border;
    right = left + icon_w;
    bottom = top + icon_h;
    SetRect(&this->r_icon,left,top,right,bottom);

    left = this->r_icon.right;
    top = border;
    right = left + text_width;
    bottom = top + text1_height;
    SetRect(&this->r_title,left,top,right,bottom);

    left = this->r_title.left;
    top = this->r_title.bottom;
    right = left + text_width;
    bottom = top + text2_height;
    SetRect(&this->r_text,left,top,right,bottom);

    left = this->r_text.right + border;
    top = border;
    right = left + close_w;
    bottom = top + close_h;
    SetRect(&this->r_close,left,top,right,bottom);
  }

  if ( CanUseGFXThreadSafe() )
     {
       RB_CreateNormal(&this->back_buff,w,h);
       HDC hdc = GetDC(NULL);
       BitBlt(this->back_buff.hdc,0,0,w,h,hdc,x,y,SRCCOPY);
       ReleaseDC(NULL,hdc);
     }

  this->balloon_hwnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,balloon_class,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(this->balloon_hwnd);
  SetTimer(this->balloon_hwnd,1,uTimeout,NULL);

  this->exit_code = NIN_BALLOONHIDE;

  if ( CanUseGFXThreadSafe() )
     {
       AnimateWindow(this->balloon_hwnd,200,AW_BLEND | AW_SLIDE);
     }
  else
     {
       ShowWindow(this->balloon_hwnd,SW_SHOWNA);
       UpdateWindow(this->balloon_hwnd);
     }
  
  if ( this->hwnd && IsWindow(this->hwnd) && this->message != -1 )
     {
       if ( this->version < 4 )
          {
            PostMessage(this->hwnd,this->message,this->id,NIN_BALLOONSHOW);
          }
       else
          {
            PostMessage(this->hwnd,this->message,0,MAKELPARAM(NIN_BALLOONSHOW,(this->id&0xFFFF)));
          }
     }
}


