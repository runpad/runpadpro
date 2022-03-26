
#define _WIN32_WINNT  0x0501   //WinXP

#include <windows.h>
#include <commctrl.h>
#include <stdlib.h>



#define MIN(a,b)   ((a)<(b)?(a):(b))


HINSTANCE g_instance = NULL;
int g_idle_timeout = 0;
const WCHAR *g_text = L"";
const WCHAR *g_text_regular = L"Шелл временно отключен до завершения сеанса или перезагрузки";
const WCHAR *g_text_warn = L"Внимание!\nСеанс завершится через %d сек";
WCHAR g_buff[200];
POINT last_mouse_pos = {-1,-1};
unsigned last_move_time = 0;



BOOL IsWarn()
{
  return g_text == g_buff;
}


void GetOurWindowDims(int *_x,int *_y,int *_w,int *_h)
{
  const int w = 300;
  const int h = 45;
  int sw = GetSystemMetrics(SM_CXSCREEN);
  int sh = GetSystemMetrics(SM_CYSCREEN);
  int x = sw - w - 150;
  int y = 10;

  if ( _x )
     *_x = x;
  if ( _y )
     *_y = y;
  if ( _w )
     *_w = w;
  if ( _h )
     *_h = h;
}


void UpdateOurWindowAlpha(HWND hwnd)
{
  if ( GetWindowLong(hwnd,GWL_EXSTYLE) & WS_EX_LAYERED )
     {
       SetLayeredWindowAttributes(hwnd,0,140,LWA_ALPHA);
     }
}



class CBrush
{
          HBRUSH brush;

  public:
          CBrush(int color) { brush = CreateSolidBrush(color); }
          ~CBrush() { DeleteObject(brush); }

          operator HBRUSH () const { return brush; }
};



void Paint(HWND hwnd,HDC hdc)
{
  RECT r;
  GetClientRect(hwnd,&r);

  FillRect(hdc,&r,CBrush(IsWarn()?RGB(255,0,0):RGB(255,255,255)));
  FrameRect(hdc,&r,CBrush(RGB(128,128,128)));

  HFONT font = CreateFont(-12,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  HFONT oldfont = (HFONT)SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);
  SetTextColor(hdc,IsWarn()?RGB(255,255,255):RGB(0,0,0));

  r.left += 5;
  r.top += 5;
  r.right -= 5;
  r.bottom -= 5;
  
  DrawTextW(hdc,g_text,-1,&r,DT_LEFT | DT_TOP | DT_WORDBREAK);

  SelectObject(hdc,oldfont);
  DeleteObject(font);
}




LRESULT CALLBACK WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_TIMER:
                       if ( wParam == 1 )
                          {
                            LASTINPUTINFO i;
                            ZeroMemory(&i,sizeof(i));
                            i.cbSize = sizeof(i);
                            if ( GetLastInputInfo(&i) )
                               {
                                 unsigned last_input_time = i.dwTime;

                                 POINT p;
                                 if ( GetCursorPos(&p) )
                                    {
                                      if ( p.x != last_mouse_pos.x || p.y != last_mouse_pos.y )
                                         {
                                           last_mouse_pos = p;
                                           last_move_time = GetTickCount();
                                         }
                                    }

                                 unsigned delta1 = GetTickCount() - last_input_time;
                                 unsigned delta2 = GetTickCount() - last_move_time;

                                 unsigned delta = MIN(delta1,delta2);

                                 if ( g_idle_timeout > 0 )
                                    {
                                      unsigned idle_sec = delta / 1000;
                                      unsigned idle_max = g_idle_timeout * 60;

                                      if ( idle_sec >= idle_max )
                                         {
                                           ExitWindowsEx(EWX_LOGOFF/*|EWX_FORCE*/,0);
                                           PostQuitMessage(1);
                                         }
                                      else
                                      if ( idle_max - idle_sec < 30 )
                                         {
                                           wsprintfW(g_buff,g_text_warn,idle_max-idle_sec);
                                           g_text = g_buff;

                                           ShowWindow(hwnd,SW_HIDE);
                                           SetWindowLong(hwnd,GWL_EXSTYLE,GetWindowLong(hwnd,GWL_EXSTYLE)&~(WS_EX_LAYERED|WS_EX_TRANSPARENT));
                                           ShowWindow(hwnd,SW_SHOWNA);
                                           
                                           InvalidateRect(hwnd,NULL,FALSE);
                                         }
                                      else
                                         {
                                           if ( g_text != g_text_regular )
                                              {
                                                g_text = g_text_regular;
                                       
                                                ShowWindow(hwnd,SW_HIDE);
                                                SetWindowLong(hwnd,GWL_EXSTYLE,GetWindowLong(hwnd,GWL_EXSTYLE)|(WS_EX_LAYERED|WS_EX_TRANSPARENT));
                                                UpdateOurWindowAlpha(hwnd);
                                                ShowWindow(hwnd,SW_SHOWNA);
                                                
                                                InvalidateRect(hwnd,NULL,FALSE);
                                              }
                                         }
                                    }
                               }
                          }
                       else
                       if ( wParam == 2 )
                          {
                            if ( !IsWindowVisible(hwnd) )
                               {
                                 ShowWindow(hwnd,SW_SHOWNA);
                               }
                          }
                       return 0;

    case WM_WINDOWPOSCHANGING:
                       if ( IsIconic(hwnd) )
                          {
                            WINDOWPOS *p = (WINDOWPOS*)lParam;

                            int x,y,w,h;
                            GetOurWindowDims(&x,&y,&w,&h);
                            
                            p->hwnd = hwnd;
                            p->hwndInsertAfter = HWND_TOPMOST;
                            p->x = x;
                            p->y = y;
                            p->cx = w;
                            p->cy = h;
                            p->flags = SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_SHOWWINDOW;

                            ShowWindow(hwnd,SW_RESTORE);
                            return 0;
                          }
                       break;

    case WM_MOUSEACTIVATE:
                       return MA_NOACTIVATE;

    case WM_ENDSESSION:
                       return 0;

    case WM_DISPLAYCHANGE:
                       {
                         int x,y;
                         GetOurWindowDims(&x,&y,NULL,NULL);
                         SetWindowPos(hwnd,HWND_TOPMOST,x,y,0,0,SWP_NOACTIVATE|SWP_NOSENDCHANGING|SWP_NOSIZE);
                       }
                       return 0;
                       
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                       return 0;

    case WM_CLOSE:
                       return 0;

    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);
                         Paint(hwnd,hdc);
                         EndPaint(hwnd,&ps);
                       }
                       return 0;
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}



int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nShowCmd)
{
  CreateMutex(NULL,FALSE,"_rsoffindic_Mutex");
  if ( GetLastError() == ERROR_ALREADY_EXISTS )
     return 0;

  if ( __argc == 1 )
     return 0;

  g_instance = GetModuleHandle(NULL);
  g_idle_timeout = __argc >= 2 ? atoi(__argv[1]) : 0;

  InitCommonControls();
  GdiSetBatchLimit(1);

  g_text = g_text_regular;

  GetCursorPos(&last_mouse_pos);
  last_move_time = GetTickCount();

  const char *szClassName = "_rsoffindic_wnd_class";

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = 0;
  wc.hCursor = LoadCursor(NULL,IDC_ARROW);
  wc.lpfnWndProc = WindowProc;
  wc.hInstance = g_instance;
  wc.lpszClassName = szClassName;
  RegisterClass(&wc);

  int x,y,w,h;
  GetOurWindowDims(&x,&y,&w,&h);
  
  int ex_style = WS_EX_TOOLWINDOW|WS_EX_LAYERED|WS_EX_TOPMOST|WS_EX_TRANSPARENT;
  HWND hwnd = CreateWindowEx(ex_style,szClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,NULL,NULL,g_instance,NULL);
  UpdateOurWindowAlpha(hwnd);
  ShowWindow(hwnd,SW_SHOWNA);
  UpdateWindow(hwnd);

  SetTimer(hwnd,1,1000,NULL);
  SetTimer(hwnd,2,100,NULL);

  MSG msg;
  while ( GetMessage(&msg,NULL,0,0) )
        DispatchMessage(&msg);        

  DestroyWindow(hwnd);
  UnregisterClass(szClassName,g_instance);

  return 1;
}
