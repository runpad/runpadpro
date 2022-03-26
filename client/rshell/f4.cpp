
// high-level functions

#include "include.h"


#include "f4_fsapp.inc"
#include "f4_hotkey.inc"
#include "f4_mixer.inc"
#include "f4_monitor.inc"
#include "f4_msgloop.inc"
#include "f4_cursor.inc"
#include "f4_fguard.inc"


void DisableDesktopComposition(void)
{
  if ( disable_desktop_composition )
     {
       HINSTANCE lib = LoadLibrary("dwmapi.dll");
       if ( lib )
          {
            typedef HRESULT (WINAPI *TDwmEnableComposition)(BOOL fEnable);
            TDwmEnableComposition pDwmEnableComposition = (TDwmEnableComposition)GetProcAddress(lib,"DwmEnableComposition");

            if ( pDwmEnableComposition )
               pDwmEnableComposition(FALSE);

            FreeLibrary(lib);
          }
     }
}


BOOL IsDesktopCompositionEnabled(void)
{
  BOOL rc = FALSE;
  
  HINSTANCE lib = LoadLibrary("dwmapi.dll");
  if ( lib )
     {
       typedef HRESULT (WINAPI *TDwmIsCompositionEnabled)(BOOL *pfEnable);
       TDwmIsCompositionEnabled pDwmIsCompositionEnabled = (TDwmIsCompositionEnabled)GetProcAddress(lib,"DwmIsCompositionEnabled");

       if ( pDwmIsCompositionEnabled )
          {
            BOOL st = FALSE;
            if ( pDwmIsCompositionEnabled(&st) == S_OK )
               rc = st;
          }

       FreeLibrary(lib);
     }

  return rc;
}


BOOL IsAppWindow(HWND w)
{
  int style;
  HWND owner,parent;

  if ( !w || !IsWindow(w) )
     return 0;

  style = GetWindowLong(w,GWL_STYLE);
  if ( (style & WS_CHILD) || !(style & WS_VISIBLE) )
     return 0;

  if ( GetWindowLong(w,GWL_EXSTYLE) & WS_EX_APPWINDOW )
     return 1;

  if ( GetWindowLong(w,GWL_EXSTYLE) & WS_EX_TOOLWINDOW )
     return 0;
  
  owner = GetWindow(w,GW_OWNER);
  parent = GetParent(w);

  if ( GetWindowLong(w,GWL_USERDATA) == MAGIC_WID )
     return 0;

  if ( GetWindowLong(owner,GWL_USERDATA) == MAGIC_WID )
     return 0;

  if ( GetWindowLong(parent,GWL_USERDATA) == MAGIC_WID )
     return 0;

  {
    char s[MAX_PATH];
    s[0] = 0;
    GetClassName(w,s,sizeof(s));
    if ( !lstrcmpi(s,"Internet Explorer_Hidden") )
       return 0;
  }

  if ( !owner && !parent )
     return 1;
  
  return 0;
}


void UpdateTracking(HWND hwnd)
{
  TRACKMOUSEEVENT event;

  event.cbSize = sizeof(event);
  event.dwFlags = TME_LEAVE;
  event.hwndTrack = hwnd;
  event.dwHoverTime = HOVER_DEFAULT;
  _TrackMouseEvent(&event);
}


void UpdateTrackingWithHover(HWND hwnd)
{
  TRACKMOUSEEVENT event;

  event.cbSize = sizeof(event);
  event.dwFlags = TME_LEAVE | TME_HOVER;
  event.hwndTrack = hwnd;
  event.dwHoverTime = HOVER_DEFAULT;
  _TrackMouseEvent(&event);
}


HWND FindGCWindow(void)
{
  return FindWindow("TfrmMain",NULL/*"GameClass3 Client"*/);
}


HWND GetTopOwner(HWND hwnd)
{
  int n = 0;
  
  do {
   HWND owner = GetWindow(hwnd,GW_OWNER);
   if ( !owner )
      owner = GetParent(hwnd);
   if ( !owner || owner == GetDesktopWindow() )
      return n ? hwnd : NULL;
   hwnd = owner;
   n++;
  } while (1);
}


BOOL IsWindowClientRealVisible(HWND hwnd)
{
  BOOL rc = FALSE;
  
  if ( !IsWindow(hwnd) || !IsWindowVisible(hwnd) || IsIconic(hwnd) )
     return rc;
     
  RECT cr;
  GetClientRect(hwnd,&cr);
  if ( IsRectEmpty(&cr) )
     return rc;
  
  POINT p = {0,0};
  ClientToScreen(hwnd,&p);
  OffsetRect(&cr,p.x,p.y);

  RECT sr;
  sr.left = GetSystemMetrics(SM_XVIRTUALSCREEN);
  sr.top = GetSystemMetrics(SM_YVIRTUALSCREEN);
  sr.right = sr.left + GetSystemMetrics(SM_CXVIRTUALSCREEN);
  sr.bottom = sr.top + GetSystemMetrics(SM_CYVIRTUALSCREEN);

  RECT r;
  IntersectRect(&r,&cr,&sr);
  if ( IsRectEmpty(&r) )
     return rc;

  HWND w = hwnd;
  HWND w_desktop = GetDesktopWindow();

  while ( 1 )
  {
    w = GetNextWindow(w,GW_HWNDPREV);
    if ( w == NULL || w == w_desktop )
       {
         rc = TRUE; //!IsOurDesktopHidden();
         break;
       }

    if ( IsWindowVisible(w) && !IsIconic(w) )
       {
         RECT wr = {0,0,0,0};
         GetWindowRect(w,&wr);

         RECT t;
         IntersectRect(&t,&r,&wr);

         if ( EqualRect(&t,&r) )
            {
              rc = FALSE;
              break;
            }
       }
  };

  return rc;
}


BOOL CanUseGFXThreadSafe()
{
  return /*use_gfx &&*/ 
         !IsRunningInSafeMode() && 
         !IsTerminalSession() && 
         !IsRemoteDesktopRunning() && 
         !monitor_off && 
         !IsOurDesktopHidden();
}


BOOL CanUseGFX()
{
  return CanUseGFXThreadSafe();
}

