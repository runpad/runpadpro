
#include "include.h"



CEvents::CEvents()
{
  InitializeCriticalSection(&o_cs);

  last_time_ldown = last_time_rdown = last_time_mdown = GetTickCount() - 10000;
}


CEvents::~CEvents()
{
  DeleteCriticalSection(&o_cs);
}


void CEvents::OnInputEvent(int message,int wParam,int lParam,unsigned time)
{
  CCSGuard g(o_cs);

  time = 0; // must be cleared!
  
  if ( message == WM_LBUTTONDBLCLK && GetTickCount()-last_time_ldown > GetDoubleClickTime() )
     {
       SendInputEvent(WM_LBUTTONDOWN,wParam,lParam,time);
       SendInputEvent(WM_LBUTTONUP,wParam,lParam,time);
     }

  if ( message == WM_LBUTTONDOWN )
     {
       last_time_ldown = GetTickCount();
     }

  SendInputEvent(message,wParam,lParam,time);
}


void CEvents::SendInputEvent(int message,int wParam,int lParam,unsigned time)
{
  BOOL e_mouse = FALSE;
  BOOL e_keyboard = FALSE;
  
  if ( message == WM_MOUSEMOVE || 
       message == WM_LBUTTONDOWN || 
       message == WM_LBUTTONUP || 
       message == WM_LBUTTONDBLCLK || 
       message == WM_RBUTTONDOWN || 
       message == WM_RBUTTONUP || 
       message == WM_RBUTTONDBLCLK || 
       message == WM_MBUTTONDOWN || 
       message == WM_MBUTTONUP || 
       message == WM_MBUTTONDBLCLK || 
       message == WM_MOUSEWHEEL )
     {
       e_mouse = TRUE;
     }

  if ( message == WM_KEYUP || 
       message == WM_KEYDOWN || 
       message == WM_SYSKEYUP || 
       message == WM_SYSKEYDOWN )
     {
       e_keyboard = TRUE;
     }

  if ( e_mouse || e_keyboard )
     {
       if ( e_mouse )
          {
            INPUT i;

            i.type = INPUT_MOUSE;

            int sw = GetSystemMetrics(SM_CXSCREEN);
            int x = (int)(short)(LOWORD(lParam));
            if ( x < 0 )
               x = 0;
            if ( x > sw-1 )
               x = sw-1;
            x = x * 65535 / (sw-1);
            i.mi.dx = x;

            int sh = GetSystemMetrics(SM_CYSCREEN);
            int y = (int)(short)(HIWORD(lParam));
            if ( y < 0 )
               y = 0;
            if ( y > sh-1 )
               y = sh-1;
            y = y * 65535 / (sh-1);
            i.mi.dy = y;

            if ( message == WM_MOUSEWHEEL )
               {
                 i.mi.mouseData = GET_WHEEL_DELTA_WPARAM(wParam);
               }
            else
               {
                 i.mi.mouseData = 0;
               }

            i.mi.dwFlags = 0;
            i.mi.dwFlags |= MOUSEEVENTF_ABSOLUTE;

            switch ( message )
            {
              case WM_MOUSEMOVE:     i.mi.dwFlags |= MOUSEEVENTF_MOVE;       break;
              case WM_LBUTTONDOWN:   i.mi.dwFlags |= MOUSEEVENTF_LEFTDOWN;   break;
              case WM_LBUTTONUP:     i.mi.dwFlags |= MOUSEEVENTF_LEFTUP;     break;
              case WM_LBUTTONDBLCLK: i.mi.dwFlags |= MOUSEEVENTF_LEFTDOWN;   break;
              case WM_RBUTTONDOWN:   i.mi.dwFlags |= MOUSEEVENTF_RIGHTDOWN;  break;
              case WM_RBUTTONUP:     i.mi.dwFlags |= MOUSEEVENTF_RIGHTUP;    break;
              case WM_RBUTTONDBLCLK: i.mi.dwFlags |= MOUSEEVENTF_RIGHTDOWN;  break;
              case WM_MBUTTONDOWN:   i.mi.dwFlags |= MOUSEEVENTF_MIDDLEDOWN; break;
              case WM_MBUTTONUP:     i.mi.dwFlags |= MOUSEEVENTF_MIDDLEUP;   break;
              case WM_MBUTTONDBLCLK: i.mi.dwFlags |= MOUSEEVENTF_MIDDLEDOWN; break;
              case WM_MOUSEWHEEL:    i.mi.dwFlags |= MOUSEEVENTF_WHEEL;      break;
            };
            
            i.mi.time = time;
            i.mi.dwExtraInfo = 0;

            SendInput(1,&i,sizeof(i));
          }
       else
       if ( e_keyboard )
          {
            INPUT i;

            i.type = INPUT_KEYBOARD;
            i.ki.wVk = wParam;
            i.ki.wScan = ((lParam >> 16) & 0xFF);
            i.ki.dwFlags = 0;
            i.ki.dwFlags |= KEYEVENTF_SCANCODE; //ignore VK
            if ( message == WM_KEYUP || message == WM_SYSKEYUP )
               i.ki.dwFlags |= KEYEVENTF_KEYUP;
            if ( lParam & 0x01000000 )
               i.ki.dwFlags |= KEYEVENTF_EXTENDEDKEY;
            i.ki.time = time;
            i.ki.dwExtraInfo = 0;

            SendInput(1,&i,sizeof(i));
          }
     }
}


