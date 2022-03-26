
#include "include.h"



unsigned CPopupMenu::last_popdown_time = 0;


int PopupMenuAndDestroy(HMENU menu,BOOL is_down_top,int x,int y)
{
  int rc = 0;
  
  if ( menu )
     {
       CPopupMenu *m = new CPopupMenu(menu);

       rc = m->Popup(is_down_top,x,y);

       delete m;

       DestroyMenu(menu);
     }

  return rc;
}


unsigned GetMenuLastPopdownTime()
{
  return CPopupMenu::GetLastPopdownTime();
}



CPopupMenu::CPopupMenu(HMENU src_menu)
{
  if ( !src_menu )
     {
       menu = CreatePopupMenu();
       need_destroy_menu = TRUE;
     }
  else
     {
       menu = src_menu;
       need_destroy_menu = FALSE;
     }
}


CPopupMenu::~CPopupMenu()
{
  if ( need_destroy_menu )
     {
       DestroyMenu(menu);
     }
}


BOOL CPopupMenu::MeasureMenuItem(MEASUREITEMSTRUCT *i)
{
  return FALSE;
}


BOOL CPopupMenu::DrawMenuItem(DRAWITEMSTRUCT *i)
{
  return FALSE;
}


void CPopupMenu::Add(int flags,int id,const char *value)
{
  AppendMenu(menu,flags,id,value);
}


void CPopupMenu::AddSeparator()
{
  AppendMenu(menu,MF_SEPARATOR,0,NULL);
}


unsigned CPopupMenu::GetLastPopdownTime()
{
  return last_popdown_time;
}


HBRUSH CPopupMenu::GetMenuBrush(HMENU menu)
{
  MENUINFO i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.fMask = MIM_BACKGROUND;

  GetMenuInfo(menu,&i);

  return i.hbrBack;
}


void CPopupMenu::SetMenuBrush(HMENU menu,HBRUSH brush)
{
  MENUINFO i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.fMask = MIM_BACKGROUND | MIM_APPLYTOSUBMENUS;
  i.hbrBack = brush;

  SetMenuInfo(menu,&i);
}


int CPopupMenu::Popup(BOOL is_down_top,int x,int y)
{
  if ( x == -1 && y == -1 )
     {
       POINT p = {0,0};
       GetCursorPos(&p);
       x = p.x;
       y = p.y;
     }
  
  BOOL menu_fade=FALSE, menu_anim=FALSE;

  SystemParametersInfo(SPI_GETMENUFADE,0,(void*)&menu_fade,0);
  SystemParametersInfo(SPI_GETMENUANIMATION,0,(void*)&menu_anim,0);
  if ( !CanUseGFX() )
     {
       SystemParametersInfo(SPI_SETMENUFADE,0,(void*)FALSE,0);
       SystemParametersInfo(SPI_SETMENUANIMATION,0,(void*)FALSE,0);
     }
  else
     {
       SystemParametersInfo(SPI_SETMENUFADE,0,(void*)FALSE,0);
       SystemParametersInfo(SPI_SETMENUANIMATION,0,(void*)TRUE,0);
       SystemParametersInfo(SPI_SETMENUFADE,0,(void*)TRUE,0);
     }

  HBRUSH menu_brush = CreateSolidBrush(theme.menu);
  HBRUSH old_brush = GetMenuBrush(menu);
  SetMenuBrush(menu,menu_brush);

  static const char *mainclass = "_RSMenuWindowClass";
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = mainclass;
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,0,0,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(hwnd);

  CForegroundWindowGuard *pForeGuard = new CForegroundWindowGuard();

  SetForegroundWindow(hwnd);
  SetActiveWindow(hwnd);

  int flags = TPM_LEFTALIGN | TPM_RIGHTBUTTON | TPM_NONOTIFY | TPM_RETURNCMD;
  flags |= (is_down_top ? TPM_BOTTOMALIGN : TPM_TOPALIGN);
  int rc = TrackPopupMenu(menu,flags,x,y,0,hwnd,NULL);

  delete pForeGuard;
  
  DestroyWindow(hwnd);
  UnregisterClass(mainclass,our_instance);

  SetMenuBrush(menu,old_brush);
  DeleteObject(menu_brush);

  SystemParametersInfo(SPI_SETMENUFADE,0,(void *)FALSE,0);
  SystemParametersInfo(SPI_SETMENUANIMATION,0,(void *)FALSE,0);
  SystemParametersInfo(SPI_SETMENUANIMATION,0,(void *)menu_anim,0);
  SystemParametersInfo(SPI_SETMENUFADE,0,(void *)menu_fade,0);

  last_popdown_time = GetTickCount();

  return rc;
}


LRESULT CPopupMenu::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
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

    case WM_MEASUREITEM:
                   if ( wParam == 0 && lParam )
                      {
                        if ( MeasureMenuItem((MEASUREITEMSTRUCT *)lParam) )
                           return TRUE;
                      }
                   break;
                   
    case WM_DRAWITEM:
                   if ( wParam == 0 && lParam )
                      {
                        if ( DrawMenuItem((DRAWITEMSTRUCT *)lParam) )
                           return TRUE;
                      }
                   break;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                   return 0;
  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}



void CPopupMenuWithODSeparator::AddSeparator()
{
  Add(MF_SEPARATOR | MF_OWNERDRAW,0,(const char*)-1);
}


BOOL CPopupMenuWithODSeparator::MeasureMenuItem(MEASUREITEMSTRUCT *i)
{
  BOOL rc = FALSE;

  int id = (int)i->itemData;
  if ( id == -1 )
     {
       i->itemWidth = 1;
       i->itemHeight = 7;

       rc = TRUE;
     }

  return rc;
}


BOOL CPopupMenuWithODSeparator::DrawMenuItem(DRAWITEMSTRUCT *i)
{
  BOOL rc = FALSE;

  int id = (int)i->itemData;
  HDC hdc = i->hDC;
  RECT r = i->rcItem;

  int w = r.right - r.left;
  int h = r.bottom - r.top;

  if ( id == -1 )
     {
       int bg_color = theme.menu;
       int fg_color = GetFGColor(bg_color);

       RBUFF buff;
       RB_CreateNormal(&buff,w,h);
       RB_Fill(&buff,bg_color);

       RECT lr;
       lr.left = 0;
       lr.right = w;
       lr.top = h/2;
       lr.bottom = lr.top+1;
       
       HBRUSH brush = CreateSolidBrush(fg_color);
       FillRect(buff.hdc,&lr,brush);
       DeleteObject(brush);

       BitBlt(hdc,r.left,r.top,w,h,buff.hdc,0,0,SRCCOPY);
       RB_Destroy(&buff);

       rc = TRUE;
     }

  return rc;
}

