
#include "include.h"



static const char *class_name = "_rshell_asv2_WndClass";


const char* CWindow::GetClassName()
{
  return class_name;
}


CWindow::CWindow(int _msg_user)
{
  msg_taskbar = RegisterWindowMessage("TaskbarCreated");
  msg_user = _msg_user;
  
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = class_name;
  RegisterClass(&wc);

  m_wnd = CreateWindowEx(WS_EX_TOOLWINDOW,class_name,NULL,WS_POPUP,0,0,0,0,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(m_wnd);

  SetTimer(m_wnd,1,500,NULL);
  SetTimer(m_wnd,2,10000,NULL);
}


CWindow::~CWindow()
{
  DestroyWindow(m_wnd);
  UnregisterClass(class_name,our_instance);
}


LRESULT CWindow::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == msg_taskbar )
     {
       G_OnTaskbarCreated();
       return 0;
     }

  if ( message == msg_user )
     {
       G_OnTrayMessage(wParam,lParam);
       return 0;
     }
     
  switch ( message )
  {
    case WM_USER+102:
                   G_OnForceUpdate();
                   return 0;
    
    case WM_DESTROY:
                   DoneWindowProcWrapper(hwnd);
                   return 0;
    
    case WM_CLOSE:
                   return 0;

    case WM_TIMER:
                   if ( wParam == 1 )
                      G_OnTimer();
                   else
                   if ( wParam == 2 )
                      G_OnTimerVista();
                   return 0;

    case WM_ENDSESSION:
                   if ( wParam )
                      {
                        G_OnEndSession();
                      }
                   return 0;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                   return 0;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}




static const char *prop_name = "this_class_pointer";


void CWindowProc::InitWindowProcWrapper(HWND hwnd)
{
  SetProp(hwnd,prop_name,(HANDLE)this);
}


void CWindowProc::DoneWindowProcWrapper(HWND hwnd)
{
  RemoveProp(hwnd,prop_name);
}


LRESULT CALLBACK CWindowProc::WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  CWindowProc *obj = (CWindowProc*)GetProp(hwnd,prop_name);

  if ( obj )
     {
       return obj->WindowProc(hwnd,message,wParam,lParam);
     }
  else
     {
       return DefWindowProc(hwnd,message,wParam,lParam);
     }
}


