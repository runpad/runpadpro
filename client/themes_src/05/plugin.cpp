
#include "include.h"


static const char *szClassName = "RSPThemeDLLPluginHostClass";

int CPlugin::g_numobjects = 0;  // global ref counter

static ULONG_PTR gdiplus_token = 0;
static GdiplusStartupInput gdiplus_input; //here is default constructor present!



CPlugin::CPlugin(HWND _host_wnd,TDeskExternalConnection *_conn)
{
  host_wnd = _host_wnd;
  m_wnd = NULL;
  conn = _conn;
  m_core = NULL;

  if ( g_numobjects == 0 )
     {
       CoInitialize(0);
       GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
       GdiSetBatchLimit(1);
     }

  g_numobjects++;


  if ( host_wnd )
     {
       WNDCLASS wc;
       ZeroMemory(&wc,sizeof(wc));
       wc.style = CS_DBLCLKS;
       wc.lpfnWndProc = WindowProcWrapper;
       wc.hInstance = our_instance;
       wc.lpszClassName = szClassName;
       RegisterClass(&wc);

       int width=0,height=0;
       GetHostSize(width,height);
       
       m_wnd = CreateWindowEx(0/*WS_EX_NOPARENTNOTIFY*/,szClassName,NULL,WS_CHILD | WS_VISIBLE,0,0,width,height,host_wnd,NULL,our_instance,NULL);
       InitWindowProcWrapper(m_wnd);

       SetTimer(m_wnd,1,120,NULL);

       PostMessage(m_wnd,WM_USER+1,0,0); // postpound creation of the core object
     }
}


CPlugin::~CPlugin()
{
  SAFEDELETE(m_core);
  
  conn = NULL;

  if ( m_wnd )
     {
       DestroyWindow(m_wnd);
       m_wnd = NULL;

       UnregisterClass(szClassName,our_instance);
     }

  host_wnd = NULL;

  g_numobjects--;

  if ( g_numobjects == 0 )
     {
       GdiplusShutdown(gdiplus_token);
       gdiplus_token = 0;
       CoUninitialize();
     }
}


void CPlugin::Refresh()
{
  if ( m_core )
     {
       m_core->Refresh();
     }
  else
     {
       if ( m_wnd )
          InvalidateRect(m_wnd,NULL,FALSE);
     }
}


void CPlugin::Repaint()
{
  if ( m_wnd )
     {
       InvalidateRect(m_wnd,NULL,FALSE);
       UpdateWindow(m_wnd);
     }
}


void CPlugin::OnStatusStringChanged()
{
  if ( m_core )
     m_core->OnStatusStringChanged();
}


void CPlugin::OnActiveSheetChanged()
{
  if ( m_core )
     m_core->Refresh();
}


void CPlugin::OnPageShaded()
{
  if ( m_core )
     m_core->Refresh();
}


void CPlugin::OnDisplayChanged()
{
  int neww=0,newh=0;
  GetHostSize(neww,newh);

  if ( neww > 0 && newh > 0 )
     {
       if ( m_wnd )
          {
            SetWindowPos(m_wnd,NULL,0,0,neww,newh,SWP_NOACTIVATE|SWP_NOCOPYBITS|SWP_NOOWNERZORDER|SWP_NOREDRAW|SWP_NOZORDER);
            //InvalidateRect(m_wnd,NULL,FALSE);
          }
     }
}



LRESULT CPlugin::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_TIMER:
                   if ( wParam == 1 )
                      {
                        if ( m_core )
                           m_core->UpdateInfoTextAnimation();
                      }
                   return 0;
    
    case WM_USER:
                   if ( m_core )
                      m_core->OnUserMessage(message,wParam,lParam);
                   return 0;

    case WM_USER+1:
                   if ( !m_core )
                      m_core = new CCore(conn,m_wnd,WM_USER);
                   return 0;
                   
    case WM_DESTROY:
                   DoneWindowProcWrapper(hwnd);
                   return 0;

    case WM_CLOSE:
                   return 0;
    
    case WM_MOUSEMOVE:
                   {
                     int x = (int)(short)LOWORD(lParam);
                     int y = (int)(short)HIWORD(lParam);

                     if ( m_core )
                        {
                          m_core->OnMouseMove(x,y);
                        }
                     else
                        {
                          //const char *cursor = NULL;
                          //
                          //if ( conn && conn->IsWaitCursor && conn->IsWaitCursor() )
                          //   {
                          //     cursor = IDC_WAIT;
                          //   }
                          //else
                          //   {
                          //     cursor = IDC_ARROW;
                          //   }
                          //
                          //SetCursor(LoadCursor(NULL,cursor));

                          SetCursor(LoadCursor(NULL,IDC_WAIT));
                        }
                   }
                   return 0;

    case WM_LBUTTONUP:
                   {
                     int x = (int)(short)LOWORD(lParam);
                     int y = (int)(short)HIWORD(lParam);

                     if ( m_core )
                        m_core->OnMouseClick(x,y);
                   }
                   return 0;

    case WM_WINDOWPOSCHANGING:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;

                     if ( !IsIconic(hwnd) )  //child?
                        {
                          if ( !(p->flags & SWP_NOSIZE) )
                             {
                               p->flags |= SWP_NOCOPYBITS;
                               return 0;
                             }
                        }
                   }
                   break;

    case WM_WINDOWPOSCHANGED:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;

                     if ( !IsIconic(hwnd) )  //child?
                        {
                          if ( !(p->flags & SWP_NOSIZE) )
                             {
                               if ( m_core )
                                  m_core->Refresh();
                               else
                                  InvalidateRect(hwnd,NULL,FALSE);
                             }
                        }
                   }
                   break;
                   
    case WM_PAINT:
                   {
                     PAINTSTRUCT ps;
                     HDC hdc = BeginPaint(hwnd,&ps);
                   
                     if ( hdc && !IsIconic(hwnd) /*child?*/ )
                        {
                          BOOL painted = FALSE;
                          
                          if ( m_core )
                             painted = m_core->Paint(hdc);

                          if ( !painted )
                             {
                               RECT r = {0,0,0,0};
                               GetClientRect(hwnd,&r);
                               HBRUSH brush = CreateSolidBrush(CCore::GetNullColor());
                               FillRect(hdc,&r,brush);
                               ::DeleteObject(brush);
                             }
                        }
                     
                     EndPaint(hwnd,&ps);
                   }
                   return 0;

  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CPlugin::GetHostSize(int &_w,int &_h)
{
  _w = 0;
  _h = 0;

  if ( host_wnd && !IsIconic(host_wnd) )
     {
       RECT r = {0,0,0,0};
       GetClientRect(host_wnd,&r);

       _w = r.right - r.left;
       _h = r.bottom - r.top;
     }
}

