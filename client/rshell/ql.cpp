
#include "include.h"



CQLItem::CQLItem()
{
  name[0] = 0;
  exe[0] = 0;
  arg[0] = 0;
  icon_big = NULL;
  icon_small = NULL;
}


CQLItem::CQLItem(const CQLItem &other)
{
  lstrcpy(name,other.name);
  lstrcpy(exe,other.exe);
  lstrcpy(arg,other.arg);
  icon_big = other.icon_big ? CopyIcon(other.icon_big) : NULL;
  icon_small = other.icon_small ? CopyIcon(other.icon_small) : NULL;
}


CQLItem::~CQLItem()
{
  Free();
}


CQLItem& CQLItem::operator = (const CQLItem &other)
{
  Free();

  lstrcpy(name,other.name);
  lstrcpy(exe,other.exe);
  lstrcpy(arg,other.arg);
  icon_big = other.icon_big ? CopyIcon(other.icon_big) : NULL;
  icon_small = other.icon_small ? CopyIcon(other.icon_small) : NULL;

  return *this;
}


void CQLItem::Load(const char *s_exe,const char *s_arg,const char *s_name)
{
  Free();

  SHFILEINFO i;
  ZeroMemory(&i,sizeof(i));
  SHGetFileInfo(s_exe,0,&i,sizeof(i),SHGFI_ICON | SHGFI_SMALLICON);
  icon_small = i.hIcon ? i.hIcon : CopyIcon(LoadIcon(NULL,IDI_APPLICATION));
  ZeroMemory(&i,sizeof(i));
  SHGetFileInfo(s_exe,0,&i,sizeof(i),SHGFI_ICON | SHGFI_LARGEICON);
  icon_big = i.hIcon ? i.hIcon : CopyIcon(LoadIcon(NULL,IDI_APPLICATION));

  lstrcpy(name,s_name);
  lstrcpy(exe,s_exe);
  lstrcpy(arg,s_arg);
}


void CQLItem::Free()
{
  if ( icon_big )
     DestroyIcon(icon_big);
  if ( icon_small )
     DestroyIcon(icon_small);

  icon_big = NULL;
  icon_small = NULL;
  name[0] = 0;
  exe[0] = 0;
  arg[0] = 0;
}


void CQLItem::Execute()
{
  CShortcut sh(name,exe,arg);
  RunProgram(&sh,FALSE,NULL,FALSE);
}


CQuickLaunch::CQuickLaunch(HWND main_window,HWND panel_window)
{
  w_main = main_window;
  w_panel = panel_window;
  
  tooltip = CreateWindowEx(WS_EX_TOPMOST,TOOLTIPS_CLASS,NULL,TTS_NOPREFIX | TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,our_instance,NULL);
  SetWindowPos(tooltip,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
  SendMessage(tooltip,TTM_ACTIVATE,TRUE,0);

  LoadItems();
  SetTooltips();
}


CQuickLaunch::~CQuickLaunch()
{
  DestroyWindow(tooltip);
}


int CQuickLaunch::GetCount() const
{
  return qlitems.size();
}


CQLItem* CQuickLaunch::GetItemAt(int num)
{
  if ( num >= 0 && num < GetCount() )
     {
       return &qlitems[num];
     }
  else
     {
       return NULL;
     }
}


const CQLItem* CQuickLaunch::GetItemAt(int num) const
{
  if ( num >= 0 && num < GetCount() )
     {
       return &qlitems[num];
     }
  else
     {
       return NULL;
     }
}


void CQuickLaunch::GetItemDim(int *_w,int *_h)
{
  const int pad = 3;
  *_w = 16+2*pad;
  *_h = 16+2*pad;
}


void CQuickLaunch::GetItemRect(int num,RECT *r)
{
  if ( num < 0 || num >= GetCount() )
     {
       SetRectEmpty(r);
     }
  else
     {
       const THEME2D *i = Get2DTheme();
       int w,h;
       
       GetItemDim(&w,&h);
       r->left = i->button_pad+i->divider_width+num*w;
       r->right = r->left+w;
       r->top = i->transparent_pad + (i->panel_height-h)/2;
       r->bottom = r->top + h;
     }
}


void CQuickLaunch::SetTooltips(void)
{
  if ( w_panel )
     {
       const int old_count = SendMessage(tooltip,TTM_GETTOOLCOUNT,0,0);
       
       for ( int n = 0; n < old_count; n++ )
           {
             TOOLINFO i;

             ZeroMemory(&i,sizeof(i));
             i.cbSize = sizeof(i);
             i.hwnd = w_panel;
             i.uId = n;
             
             SendMessage(tooltip,TTM_DELTOOL,0,(int)&i);
           }
       
       for ( int n = 0; n < GetCount(); n++ )
           {
             TOOLINFO i;

             ZeroMemory(&i,sizeof(i));
             i.cbSize = sizeof(i);
             i.uFlags = TTF_SUBCLASS;
             i.hwnd = w_panel;
             i.uId = n;
             i.hinst = NULL;
             i.lpszText = LPSTR_TEXTCALLBACK;
             GetItemRect(n,&i.rect);
             
             SendMessage(tooltip,TTM_ADDTOOL,0,(int)&i);
           }
     }
}


void CQuickLaunch::OnNotifyMessage(NMHDR *i)
{
  if ( i && i->hwndFrom == tooltip && i->code == TTN_GETDISPINFO )
     DisplayTip((NMTTDISPINFO*)i);
}


void CQuickLaunch::DisplayTip(NMTTDISPINFO *i)
{
  SendMessage(tooltip,TTM_SETTIPBKCOLOR,theme.tooltip_back,0);
  SendMessage(tooltip,TTM_SETTIPTEXTCOLOR,theme.tooltip_text,0);
  SendMessage(tooltip,TTM_SETMAXTIPWIDTH,0,300);

  int idx = i->hdr.idFrom;

  if ( idx >= 0 && idx < GetCount() )
     {
       static char s[MAX_PATH];  //must be static!
       lstrcpyn(s,qlitems[idx].name,sizeof(s)-1);
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


int CQuickLaunch::GetControlWidth(void)
{
  if ( GetCount() == 0 )
     {
       return 0;
     }
  else
     {
       int w,h;
       GetItemDim(&w,&h);
       return w * GetCount() + Get2DTheme()->divider_width;
     }
}


void CQuickLaunch::OnPaint(HDC hdc,int hl,BOOL down)
{
  if ( GetCount() )
     {
       for ( int n = 0; n < GetCount(); n++ )
           {
             RECT r;
             int x,y,w,h;

             GetItemRect(n,&r);

             w = r.right - r.left;
             h = r.bottom - r.top;
             x = r.left + (w - 16)/2;
             y = r.top + (h - 16)/2;

             if ( hl == n )
                {
                  DrawIconHLInternal(hdc,&r,100);

                  if ( down )
                     {
                       x++;
                       y++;
                     }
                }

             DrawIconEx(hdc,x,y,qlitems[n].icon_small,16,16,0,NULL,DI_NORMAL);
           }

       //divider
       {
         const THEME2D *i = Get2DTheme();
         RECT r;
         int w,h;
         
         GetItemDim(&w,&h);
         r.left = i->button_pad + i->divider_width + GetCount() * w;
         r.right = r.left + i->divider_width;
         r.top = i->transparent_pad;
         r.bottom = r.top + i->panel_height;
         Draw_Theme_Bitmap(hdc,&r,i->divider);
       }
     }
}


void CQuickLaunch::OnClick(int message,int wParam,int lParam)
{
  if ( message == WM_LBUTTONDOWN || message == WM_LBUTTONUP )
     {
       int n;
       POINT p;

       p.x = LOWORD(lParam);
       p.y = HIWORD(lParam);

       for ( n = 0; n < GetCount(); n++ )
           {
             RECT r;
             
             GetItemRect(n,&r);
             
             if ( PtInRect(&r,p) )
                {
                  InvalidateRect(w_panel,&r,FALSE);
                  if ( message == WM_LBUTTONUP )
                     {
                       if ( !IsAnyChildWindows() )
                          ExecItem(n);
                     }
                  break;
                }
           }
     }
}


void CQuickLaunch::LoadItems(void)
{
  qlitems.clear();

  TCFGLIST2 &list = user_tools;
  
  for ( int n = 0; n < list.size(); n++ )
      {
        if ( list[n].IsActive() )
           {
             CPathExpander cmd(list[n].GetParm2());
             qlitems.push_back(CQLItem());
             qlitems.back().Load(cmd.GetPath(),"",list[n].GetParm1());
           }
      }
}


void CQuickLaunch::ExecItem(int num)
{
  if ( num >= 0 && num < GetCount() )
     {
       qlitems[num].Execute();
     }
}


void CQuickLaunch::OnConfigChange()
{
  LoadItems();
  SetTooltips();
}


void CQuickLaunch::OnDisplayChange(int sw,int sh)
{
  SetTooltips();
}


void ExecQLItem(void *obj)
{
  CQLItem *ql = (CQLItem*)obj;
  if ( ql )
     ql->Execute();
}
