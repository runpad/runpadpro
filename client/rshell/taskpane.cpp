
#include "include.h"


#define MAXAPPS	            18   //only visible sheets
#define MAXWINS             100  //total windows
#define MAXSHEETWIDTH	    175

static const char *mainclass = "_PanelClass";
static const int groupnames[] = { 3111,3112,3113,3114,3115,3116,3117 };


CTaskPane::CWinApp::CWinApp()
{ 
  hwnd = NULL;
  active = FALSE;
  icon = NULL;
  title[0] = 0; 
  last_update_time = 0;
}


CTaskPane::CWinApp::~CWinApp()
{ 
  if ( icon ) 
     DestroyIcon(icon); 
}


CTaskPane::CWinApp::CWinApp(const CWinApp& other)
{
  hwnd = other.hwnd;
  active = other.active;
  icon = other.icon ? CopyIcon(other.icon) : NULL;
  lstrcpy(title,other.title);
  last_update_time = other.last_update_time;
}


CTaskPane::CWinApp& CTaskPane::CWinApp::operator = (const CWinApp& other)
{
  hwnd = other.hwnd;
  active = other.active;
  if ( icon ) 
     DestroyIcon(icon); 
  icon = other.icon ? CopyIcon(other.icon) : NULL;
  lstrcpy(title,other.title);
  last_update_time = other.last_update_time;
  return *this;
}


void CTaskPane::CWinApp::SetIconFromWindow(HWND w)
{
  if ( icon )
     DestroyIcon(icon);
  icon = NULL;
  
  if ( IsWindow(w) )
     {
       #define ICON_FETCH_TIME 100

       int hung = 0;//IsApplicationHung(w,100);
       
       if ( !icon && !hung )
          if ( !SendMessageTimeout(w,WM_GETICON,ICON_SMALL,0,SMTO_BLOCK|SMTO_ABORTIFHUNG,ICON_FETCH_TIME,(PDWORD_PTR)&icon) )
             icon = NULL;

       if ( !icon && !hung )
          if ( !SendMessageTimeout(w,WM_GETICON,2,0,SMTO_BLOCK|SMTO_ABORTIFHUNG,ICON_FETCH_TIME,(PDWORD_PTR)&icon) )
             icon = NULL;

       if ( !icon )
          icon = (HICON)GetClassLong(w,GCL_HICONSM);
       
       if ( !icon && !hung )
          if ( !SendMessageTimeout(w,WM_GETICON,ICON_BIG,0,SMTO_BLOCK|SMTO_ABORTIFHUNG,ICON_FETCH_TIME,(PDWORD_PTR)&icon) )
             icon = NULL;
       
       if ( !icon )
          icon = (HICON)GetClassLong(w,GCL_HICON);
       
       if ( !icon )
          icon = LoadIcon(NULL,IDI_APPLICATION);
     }
  else
     {
       icon = LoadIcon(NULL,IDI_APPLICATION);
     }

  if ( icon )
     icon = CopyIcon(icon);
}


void CTaskPane::CWinApp::SetTitleFromWindow(HWND w)
{
  title[0] = 0;
  GetWindowText(w,title,sizeof(title));
}


void CTaskPane::CWin::SetGroupIdFromWindow(HWND w)
{
  int rc = -1;
  char s[MAX_PATH];
  
  s[0] = 0;
  GetClassName(w,s,sizeof(s));

  if ( !lstrcmp(s,"TBodyIEForm") )
     rc = 0;
  else
  if ( !lstrcmp(s,"IEFrame") )
     rc = 1;
  else
  if ( !lstrcmp(s,"ExploreWClass") || !lstrcmp(s,"CabinetWClass") )
     rc = 2;
  else
  if ( !lstrcmp(s,"OpusApp") )
     rc = 3;
  else
  if ( !lstrcmp(s,"XLMAIN") )
     rc = 4;
  else
  if ( GetProp(w,"_RPBodyExpl") )
     rc = 5;
  else
  if ( GetProp(w,"_RunpadDownloaderPropInfo") )
     rc = 6;

  group = rc;
}


void CTaskPane::CWin::LoadFromWindow(HWND w)
{
  hwnd = w;
  active = (GetForegroundWindow()==w);
  SetIconFromWindow(w);
  SetTitleFromWindow(w);
  SetGroupIdFromWindow(w);
  last_update_time = GetTickCount() - 10000;
}


void CTaskPane::CApp::SetTitleFromGroupIdAndCount(int id,int count)
{
  if ( id >= 0 && id < sizeof(groupnames)/sizeof(groupnames[0]) )
     {
       wsprintf(title,"[%d] %s",count,LS(groupnames[id]));
     }
  else
     {
       title[0] = 0;
     }
}


CTaskPane::TAppList* CTaskPane::BuildAppsList()
{
  #define G_UNDEFINED 0
  #define G_GROUPED   1
  #define G_SINGLE    2
  
  int groupscount = sizeof(groupnames)/sizeof(groupnames[0]);

  int *flags = (int*)sys_alloc(groupscount*sizeof(*flags));
  for ( int n = 0; n < groupscount; n++ )
      flags[n] = G_UNDEFINED;

  TAppList *apps = new TAppList;

  for ( int n = 0; n < wins.size(); n++ )
      {
        BOOL addsingle = TRUE;
        int group = wins[n].group;
        
        if ( group != -1 )
           {
             int flag = flags[group];
             if ( flag == G_GROUPED )
                {
                  addsingle = FALSE;
                }
             else
             if ( flag == G_UNDEFINED )
                {
                  int find = 0;

                  for ( int m = 0; m < wins.size(); m++ )
                      if ( wins[m].group == group )
                         find++;

                  if ( find < min_grouped_windows || min_grouped_windows <= 1 )
                     {
                       flags[group] = G_SINGLE;
                     }
                  else
                     {
                       flags[group] = G_GROUPED;
                       addsingle = FALSE;

                       if ( apps->size() < MAXAPPS )
                          {
                            (*apps).push_back(CApp());
                            CApp *app = &(*apps).back();
                            
                            BOOL active = FALSE;
                            HICON icon = NULL;

                            for ( int m = 0; m < wins.size(); m++ )
                                if ( wins[m].group == group )
                                   {
                                     icon = icon ? icon : wins[m].icon;
                                     active = wins[m].active ? TRUE : active;
                                   
                                     app->wins.push_back(wins[m]);
                                   }

                            app->hwnd = NULL;
                            app->SetTitleFromGroupIdAndCount(group,find);
                            app->active = active;
                            app->icon = icon ? CopyIcon(icon) : NULL;
                          }
                       else
                          break;
                     }
                }
           }
      
        if ( addsingle )
           {
             if ( apps->size() < MAXAPPS )
                {
                  (*apps).push_back(CApp());
                  CApp *app = &(*apps).back();

                  app->hwnd = wins[n].hwnd;
                  app->active = wins[n].active;
                  app->icon = wins[n].icon ? CopyIcon(wins[n].icon) : NULL;
                  lstrcpy(app->title,wins[n].title);
                }
             else
                break;
           }
      }

  sys_free(flags);

  return apps;
}


void CTaskPane::FreeAppsList(CTaskPane::TAppList *apps)
{
  if ( apps )
     {
       delete apps;
     }
}


BOOL CTaskPane::GetSheetRectByWinNumber(int num,RECT *r)
{
  BOOL rc = FALSE;

  SetRectEmpty(r);

  if ( num >= 0 && num < wins.size() )
     {
       HWND hwnd = wins[num].hwnd;

       TAppList *apps = BuildAppsList();

       for ( int n = 0; n < apps->size(); n++ )
           {
             const CApp *app = &(*apps)[n];
             
             if ( app->wins.size() == 0 )
                {
                  if ( app->hwnd == hwnd )
                     {
                       GetSheetRect(n,r,apps->size());
                       rc = TRUE;
                       break;
                     }
                }
             else
                {
                  BOOL find = FALSE;

                  for ( int m = 0; m < app->wins.size(); m++ )
                      {
                        if ( app->wins[m].hwnd == hwnd )
                           {
                             find = TRUE;
                             break;
                           }
                      }

                  if ( find )
                     {
                       GetSheetRect(n,r,apps->size());
                       rc = TRUE;
                       break;
                     }
                }
           }

       FreeAppsList(apps);
     }

  return rc;
}


void CTaskPane::PanelAdd(HWND w)
{
  if ( !IsAppWindow(w) )
     return;

  for ( int n = 0; n < wins.size(); n++ )
      if ( wins[n].hwnd == w )
         return;
     
  for ( int n = 0; n < wins.size(); n++ )
      wins[n].active = FALSE;

  if ( wins.size() < MAXWINS )
     {
       wins.push_back(CWin());
       wins.back().LoadFromWindow(w);
     }

  PanelUpdate();
}


void CTaskPane::PanelRemove(HWND w)
{
  for ( TWinList::iterator it = wins.begin(); it != wins.end(); ++it )
      {
        if ( it->hwnd == w )
           {
             wins.erase(it);
             PanelUpdate();
             break;
           }
      }
}


void CTaskPane::PanelReplace(HWND w,HWND ghost)
{
  if ( w == ghost )
     return;
  
// commented for Vista fix
//  if ( !IsAppWindow(ghost) )
//     return;

  for ( int n = 0; n < wins.size(); n++ )
      if ( wins[n].hwnd == ghost )
         {
           PanelRemove(w);
           return;
         }

  for ( int n = 0; n < wins.size(); n++ )
      if ( wins[n].hwnd == w )
         {
           wins[n].hwnd = ghost;
           wins[n].SetTitleFromWindow(ghost);
           PanelUpdate();
           break;
         }
}


void CTaskPane::PanelActivate(HWND w)
{
  for ( int n = 0; n < wins.size(); n++ )
      if ( wins[n].hwnd == w )
         wins[n].active = TRUE;
      else
         wins[n].active = FALSE;

  PanelUpdate();
}


void CTaskPane::PanelRedraw(HWND w)
{
  for ( int n = 0; n < wins.size(); n++ )
      {
        if ( wins[n].hwnd == w )
           {
             if ( GetTickCount() - wins[n].last_update_time > 1000 )
                {
                  wins[n].SetIconFromWindow(w);
                  wins[n].last_update_time = GetTickCount();
                }

             wins[n].SetTitleFromWindow(w);
             
             RECT r;
             if ( GetSheetRectByWinNumber(n,&r) )
                {
                  InvalidateRect(w_panel,&r,FALSE);
                  UpdateWindow(w_panel);
                }

             break;
           }
      }
}


BOOL CTaskPane::PanelGetMinRect(HWND hwnd,RECT *r)
{
  BOOL rc = FALSE;
  
  for ( int n = 0; n < wins.size(); n++ )
      {
        if ( wins[n].hwnd == hwnd )
           {
             if ( GetSheetRectByWinNumber(n,r) )
                {
                  RECT w;
                  GetWindowRect(w_panel,&w);
                  r->left += w.left;
                  r->right += w.left;
                  r->top += w.top;
                  r->bottom += w.top;
                  rc = TRUE;
                }

             break;
           }
      }

  return rc;
}


void CTaskPane::PanelShellActivate(void)
{
  for ( int n = 0; n < wins.size(); n++ )
      wins[n].active = GetForegroundWindow() == wins[n].hwnd;//FALSE;

  PanelUpdate();
}


void CTaskPane::CheckDeadWindows(void)
{
  BOOL changed, need_update = FALSE;

  do {
   changed = FALSE;

   for ( TWinList::iterator it = wins.begin(); it != wins.end(); ++it )
       {
         if ( !IsAppWindow(it->hwnd) )
            {
              wins.erase(it);
              changed = TRUE;
              need_update = TRUE;
              break;
            }
       }

  } while ( changed );
  
  if ( need_update )
     {
       PanelUpdate();
     }
}


BOOL CALLBACK CTaskPane::EnumAppsProc(HWND hwnd,LPARAM lParam)
{
  CTaskPane *obj = (CTaskPane*)lParam;
  
  if ( IsAppWindow(hwnd) && obj->wins.size() < MAXWINS )
     {
       obj->wins.push_back(CWin());
       obj->wins.back().LoadFromWindow(hwnd);
       obj->wins.back().active = FALSE;
     }

  return TRUE;
}


void CTaskPane::EnumApps(void)
{
  EnumWindows(EnumAppsProc,(int)this);
}


void CTaskPane::GetSheetRect(int num,RECT *r,int numapps)
{
  SetRectEmpty(r);
  
  if ( numapps && num >= 0 && num < numapps )
     {
       const THEME2D *i = Get2DTheme();
       
       GetClientRect(w_panel,r);
       int w = (r->right - i->button_pad - i->divider_width - (ql?ql->GetControlWidth():0) - (tray?tray->GetControlWidth():0) - i->divider_width) / numapps - i->sheets_pad;
       if ( w > MAXSHEETWIDTH )
          w = MAXSHEETWIDTH;

       r->left = i->button_pad+i->divider_width+(ql?ql->GetControlWidth():0)+num*(w+i->sheets_pad);
       r->right = r->left+w;
       r->top = i->transparent_pad + (i->panel_height-i->sheet_height)/2;
       r->bottom = r->top + i->sheet_height;
     }
}


void CTaskPane::DrawSheets(HDC hdc)
{
  TAppList *apps = BuildAppsList();
  
  for ( int n = 0; n < apps->size(); n++ )
      {
        CApp *app = &(*apps)[n];
        
        int state = app->active ? SHEET_DOWN : SHEET_UP;

        RECT r;
        GetSheetRect(n,&r,apps->size());

        BOOL highlited = EqualRect(&r,&hl_rect);

        if ( highlited && state != SHEET_UP )
           highlited = FALSE;
                   
        Draw_Theme_Sheet(hdc,&r,state,app->title,app->icon,0,highlited,app->wins.size()?TRUE:FALSE,FALSE,11);
      }

  FreeAppsList(apps);
}


void CTaskPane::DrawButton(HDC hdc)
{
  const THEME2D *i = Get2DTheme();
  
  int state = menu_active ? SHEET_DOWN : SHEET_UP;

  BOOL highlited = EqualRect(&i->button_rect,&hl_rect);
  if ( highlited && state != SHEET_UP )
     highlited = FALSE;

  if ( !i->classic_button )
     {
       const unsigned char *src;

       if ( state == SHEET_DOWN )
          src = i->button_down;
       else
       if ( highlited )   
          src = i->button_hl;
       else
          src = i->button_up;
       
       Draw_Theme_Bitmap(hdc,&i->button_rect,src);
     }
  else
     {
       Draw_Theme_Sheet(hdc,&i->button_rect,state,LS(3083),icon16x16,1,highlited,FALSE,FALSE,11);
     }

  //divider
  RECT r;
  r.left = i->button_pad;
  r.right = r.left + i->divider_width;
  r.top = i->transparent_pad;
  r.bottom = r.top + i->panel_height;
  Draw_Theme_Bitmap(hdc,&r,i->divider);
}


void CTaskPane::DrawQL(HDC hdc)
{
  if ( ql )
     {
       BOOL down = FALSE;
       int highlited = -1;

       for ( int n = 0; n < ql->GetCount(); n++ )
           {
             RECT r;
             ql->GetItemRect(n,&r);

             if ( EqualRect(&r,&hl_rect) )
                {
                  highlited = n;
                  down = (GetAsyncKeyState(VK_LBUTTON) & 0x8000);
                  break;
                }
           }
       
       ql->OnPaint(hdc,highlited,down);
     }
}


void CTaskPane::DrawTray(HDC hdc)
{
  if ( tray )
     tray->OnPaint(hdc);
}


void CTaskPane::UpdateButton(void)
{
  InvalidateRect(w_panel,&Get2DTheme()->button_rect,FALSE);
  UpdateWindow(w_panel);
}


void CTaskPane::SetTooltips(void)
{
  SendMessage(tooltip,TTM_POP,0,0);
  
  for ( int n = 0; n < MAXAPPS; n++ )
      {
        TOOLINFO i;

        ZeroMemory(&i,sizeof(i));
        i.cbSize = sizeof(i);
        i.hwnd = w_panel;
        i.uId = n;
        
        SendMessage(tooltip,TTM_DELTOOL,0,(int)&i);
      }

  TAppList *apps = BuildAppsList();
  
  for ( int n = 0; n < apps->size(); n++ )
      {
        TOOLINFO i;

        ZeroMemory(&i,sizeof(i));
        i.cbSize = sizeof(i);
        i.uFlags = TTF_SUBCLASS;
        i.hwnd = w_panel;
        i.uId = n;
        i.hinst = NULL;
        i.lpszText = LPSTR_TEXTCALLBACK;
        GetSheetRect(n,&i.rect,apps->size());
        
        SendMessage(tooltip,TTM_ADDTOOL,0,(int)&i);
      }

  FreeAppsList(apps);
}


void CTaskPane::DisplayTip(NMTTDISPINFO *i)
{
  static char s[MAX_PATH]; // must be static!
 
  TAppList *apps = BuildAppsList();

  int idx = i->hdr.idFrom;
  if ( idx >= 0 && idx < apps->size() )
     lstrcpyn(s,(*apps)[idx].title,sizeof(s)-1);
  else
     s[0] = 0;

  FreeAppsList(apps);

  SendMessage(tooltip,TTM_SETMAXTIPWIDTH,0,600);
  SendMessage(tooltip,TTM_SETTIPBKCOLOR,theme.tooltip_back,0);
  SendMessage(tooltip,TTM_SETTIPTEXTCOLOR,theme.tooltip_text,0);
  
  i->lpszText = s;
  i->szText[0] = 0;
  i->hinst = NULL;
  i->uFlags = 0;
}


void CTaskPane::OnNotifyMessage(NMHDR *i)
{
  if ( i && i->hwndFrom == tooltip && i->code == TTN_GETDISPINFO )
     DisplayTip((NMTTDISPINFO*)i);

  if ( tray )
     tray->OnNotifyMessage(i);
  if ( ql )
     ql->OnNotifyMessage(i);
}


void CTaskPane::PanelUpdate(void)
{
  SetTooltips();
  ProcessHighliting(FALSE);
  InvalidateRect(w_panel,NULL,FALSE);
  UpdateWindow(w_panel);
}


void CTaskPane::Repaint(void)
{
  PanelUpdate();
}


void CTaskPane::Refresh(void)
{
  PanelUpdate();
}


void CTaskPane::MinimizeOrMaximizeWindow(HWND hwnd,int active)
{
  if ( IsWindow(hwnd) )
     {
       int hung = IsApplicationHung(hwnd,100);
       BOOL (WINAPI *MyShowWindow)(HWND,int) = hung ? ShowWindowAsync : ShowWindow;

       if ( !active || IsIconic(hwnd) )
          {
            //if ( pSwitchToThisWindow )
            //   pSwitchToThisWindow(hwnd,1);
            //else
               {
                 if ( IsIconic(hwnd) )
                    MyShowWindow(hwnd,SW_RESTORE);
                 SetForegroundWindow(hwnd);
               }
          }
       else
          {
            MyShowWindow(hwnd,SW_MINIMIZE);
          }
     }
}


void CTaskPane::SheetClick(int x,int y)
{
  TAppList *apps = BuildAppsList();
  
  for ( int n = 0; n < apps->size(); n++ )
      {
        RECT r;
        GetSheetRect(n,&r,apps->size());

        if ( x >= r.left && x < r.right && y >= r.top && y < r.bottom )
           {
             CApp *app = &(*apps)[n];
             
             if ( app->wins.size() == 0 )
                {
                  MinimizeOrMaximizeWindow(app->hwnd,app->active);
                }
             else
                {
                  const int base = 1000;

                  CPopupMenu *menu = new CPopupMenu();
                  for ( int m = 0; m < app->wins.size(); m++ )
                      {
                        char s[100];
                        lstrcpyn(s,app->wins[m].title,sizeof(s)-1);
                        if ( !s[0] )
                           lstrcpy(s," ");
                        menu->Add(0,base+m,s);
                      }

                  RECT wr;
                  GetWindowRect(w_panel,&wr);
                  wr.left += r.left;
                  wr.top += r.top;
                  
                  int rc = menu->Popup(TRUE,wr.left,wr.top);

                  if ( rc )
                     {
                       rc -= base;
                       if ( rc >= 0 && rc < app->wins.size() )
                          {
                            CWin *win = &app->wins[rc];
                            MinimizeOrMaximizeWindow(win->hwnd,win->active);
                          }
                     }

                  delete menu;
                }
             
             break;
           }
      }

  FreeAppsList(apps);
}


void CTaskPane::SheetRClick(int x,int y)
{
  TAppList *apps = BuildAppsList();
  
  for ( int n = 0; n < apps->size(); n++ )
      {
        RECT r;
        GetSheetRect(n,&r,apps->size());

        if ( x >= r.left && x < r.right && y >= r.top && y < r.bottom )
           {
             CApp *app = &(*apps)[n];
             
             if ( app->wins.size() == 0 )
                {
                  HMENU menu = GetSystemMenu(app->hwnd,FALSE);
                  if ( menu )
                     {
                       CPopupMenu *m = new CPopupMenu(menu);
                       int rc = m->Popup(TRUE);
                       delete m;

                       if ( rc )
                          {
                            POINT p={-1,-1};
                            GetCursorPos(&p);
                            if ( rc == SC_CLOSE || rc == SC_MAXIMIZE || rc == SC_MINIMIZE || rc == SC_RESTORE )
                               PostMessage(app->hwnd,WM_SYSCOMMAND,rc,MAKELONG(p.x,p.y));
                            else
                               ErrBox(LS(3084));
                          }
                     }
                }
             else
                {
                  const int base = 1000;

                  CPopupMenu *menu = new CPopupMenu();

                  menu->Add(0,base+0,LS(3085));
                  menu->Add(0,base+1,LS(3086));
                  menu->Add(0,base+2,LS(3087));
                  
                  int rc = menu->Popup(TRUE);
                  if ( rc )
                     {
                       rc -= base;
                       for ( int m = 0; m < app->wins.size(); m++ )
                           {
                             HWND hwnd = app->wins[m].hwnd;
                             if ( IsWindow(hwnd) )
                                {
                                  if ( rc == 0 )
                                     {
                                       if ( !IsIconic(hwnd) )
                                          ShowWindowAsync(hwnd,SW_MINIMIZE);
                                     }
                                  else
                                  if ( rc == 1 )
                                     {
                                       if ( IsIconic(hwnd) )
                                          ShowWindowAsync(hwnd,SW_RESTORE);
                                     }
                                  else
                                  if ( rc == 2 )
                                     {
                                       PostMessage(hwnd,WM_CLOSE,0,0);
                                     }
                                }
                           }
                     }

                  delete menu;
                }

             ProcessHighliting(TRUE); //needed
             break;
           }
      }

  FreeAppsList(apps);
}


BOOL CTaskPane::SheetTest(int x,int y)
{
  BOOL rc = FALSE;
 
  TAppList *apps = BuildAppsList();
  
  for ( int n = 0; n < apps->size(); n++ )
      {
        RECT r;
        GetSheetRect(n,&r,apps->size());
        if ( x >= r.left && x < r.right && y >= r.top && y < r.bottom )
           {
             rc = TRUE;
             break;
           }
      }

  FreeAppsList(apps);

  return rc;
}


void CTaskPane::ButtonClick(int x,int y)
{
  POINT p;

  p.x = x;
  p.y = y;

  if ( !PtInRect(&Get2DTheme()->button_rect,p) || menu_active || IsAnyChildWindows() )
     return;

  if ( GetTickCount() - last_menu_active/*GetMenuLastPopdownTime()*/ > 50 )
     {
       menu_active = TRUE;
       UpdateButton();
       CMainMenu(&g_content,::GetActiveSheet(),ql).Show();
       menu_active = FALSE;
       ProcessHighliting(TRUE); //needed
       UpdateButton();
       last_menu_active = GetTickCount();
     }
}


void CTaskPane::EmulateButtonClick(void)
{
  ButtonClick(Get2DTheme()->button_rect.left,Get2DTheme()->button_rect.top);
}


void CTaskPane::SwitchMenuButton(void)
{
  if ( menu_active )
     {
       EndMenu();
     }
  else
     {
       EmulateButtonClick();
     }
}


void CTaskPane::OnPaint(HDC hdc)
{
  if ( !IsIconic(w_panel) )  //paranoja
     {
       RECT r = {0,0,0,0};
       GetClientRect(w_panel,&r);
       int w = r.right - r.left;
       int h = r.bottom - r.top;

       if ( w > 0 && h > 0 )
          {
            RBUFF rbuff;
            RB_CreateNormal(&rbuff,w,h);
            
            RECT r2;
            r2 = r;
            r2.top = Get2DTheme()->transparent_pad;
            Draw_Theme_Rect(rbuff.hdc,&r2);

            DrawSheets(rbuff.hdc);
            DrawButton(rbuff.hdc);
            DrawQL(rbuff.hdc);
            DrawTray(rbuff.hdc);
            
            BitBlt(hdc,0,0,w,h,rbuff.hdc,0,0,SRCCOPY);

            RB_Destroy(&rbuff);
          }
     }
}


void CTaskPane::ProcessHighliting(BOOL do_update)
{
  POINT p = {-1,-1};
  GetCursorPos(&p);
  BOOL cover = (WindowFromPoint(p) == w_panel);

  RECT r,fr;
  GetWindowRect(w_panel,&r);
  p.x -= r.left;
  p.y -= r.top;
 
  BOOL find = FALSE;
  
  if ( cover )
     {
       TAppList *apps = BuildAppsList();

       for ( int n = 0; n < apps->size(); n++ )
           {
             RECT r;
             GetSheetRect(n,&r,apps->size());

             if ( PtInRect(&r,p) )
                {
                  CopyRect(&fr,&r);
                  find = TRUE;
                  break;
                }
           }

       FreeAppsList(apps);
     }

  if ( PtInRect(&Get2DTheme()->button_rect,p) && cover )
     {
       CopyRect(&fr,&Get2DTheme()->button_rect);
       find = TRUE;
     }

  if ( cover )
     {
       if ( ql )
          {
            for ( int n = 0; n < ql->GetCount(); n++ )
                {
                  RECT r;
                  ql->GetItemRect(n,&r);

                  if ( PtInRect(&r,p) )
                     {
                       CopyRect(&fr,&r);
                       find = TRUE;
                       break;
                     }
                }
          }
     }

  if ( find )
     {
       if ( EqualRect(&fr,&hl_rect) )
          return;

       InvalidateRect(w_panel,&fr,FALSE);
       if ( !IsRectEmpty(&hl_rect) )
          InvalidateRect(w_panel,&hl_rect,FALSE);
       CopyRect(&hl_rect,&fr);

       if ( do_update )
          UpdateWindow(w_panel);
       return;
     }

  if ( !IsRectEmpty(&hl_rect) )
     {
       InvalidateRect(w_panel,&hl_rect,FALSE);
       SetRectEmpty(&hl_rect);
       if ( do_update )
          UpdateWindow(w_panel);
     }
}


void CTaskPane::SetPanelVisRegion(void)
{
  const THEME2D *i = Get2DTheme();
  
  if ( i->transparent_pad == 0 && i->regions_count == 0 )
     {
       SetWindowRgn(w_panel,NULL,FALSE);
     }
  else
     {
       HRGN rgn,t;
       RECT r = {0,0,0,0};
       int w,h,n;

       GetClientRect(w_panel,&r);

       w = r.right - r.left;
       h = r.bottom - r.top;

       rgn = CreateRectRgn(0,0,0,0);

       t = CreateRectRgn(0,i->transparent_pad,w,h);
       CombineRgn(rgn,rgn,t,RGN_OR);
       DeleteObject(t);

       for ( n = 0; n < i->regions_count; n++ )
           {
             int x = i->regions[n].x + i->button_rect.left;
             int y = i->regions[n].y + i->button_rect.top;
             int width = i->regions[n].width;
             
             t = CreateRectRgn(x,y,x+width,y+1);
             CombineRgn(rgn,rgn,t,RGN_OR);
             DeleteObject(t);
           }

       SetWindowRgn(w_panel,rgn,FALSE);
     }
}


void CTaskPane::RepositionPanel(void)
{
  int sw = GetSystemMetrics(SM_CXSCREEN);
  int sh = GetSystemMetrics(SM_CYSCREEN);
  int h = Get2DTheme()->transparent_pad + Get2DTheme()->panel_height;

  SetWindowPos(w_panel,NULL,0,sh-h,sw,h,SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_NOREDRAW);
}


void CTaskPane::OnConfigChange(void)
{
  RepositionPanel();
  SetWorkArea();
  SetPanelVisRegion();
  if ( tray )
     tray->OnConfigChange();
  if ( ql )
     ql->OnConfigChange();
  PanelUpdate();
}


void CTaskPane::OnDisplayChange(int sw,int sh)
{
  RepositionPanel();
  SetWorkArea();
  SetPanelVisRegion();
  if ( tray )
     tray->OnDisplayChange(sw,sh);
  if ( ql )
     ql->OnDisplayChange(sw,sh);
  PanelUpdate();
}


void CTaskPane::OnTimer(void)
{
  CheckDeadWindows();
}


void CTaskPane::Hide(void)
{
  if ( IsVisible() )
     {
       ShowWindow(w_panel,SW_HIDE);
       ClearWorkArea();
       MinimizedWindowsTrayShow();
     }
}


void CTaskPane::Show(void)
{
  if ( !IsVisible() )
     {
       MinimizedWindowsTrayHide();
       SetWorkArea();
       SetWindowPos(w_panel,HWND_NOTOPMOST,0,0,0,0,SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSENDCHANGING | SWP_NOSIZE | SWP_SHOWWINDOW);
     }
}


BOOL CTaskPane::IsVisible(void)
{
  return IsWindowVisible(w_panel);
}


LRESULT CTaskPane::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == msg_panel_update )
     {
       if ( tray )
          tray->OnUpdate();
       PanelUpdate();
       return 0;
     }
  
  if ( message == msg_redraw_single_icon )
     {
       if ( tray )
          tray->OnRedrawSingleIcon(wParam,lParam);
       return 0;
     }
  
  if ( message == msg_shellhook )
     {
       switch ( wParam )
       {
         case HSHELL_TASKMAN:
                                     break;
         
         case HSHELL_GETMINRECT:
                                     break;

         case HSHELL_WINDOWACTIVATED:
         case HSHELL_RUDEAPPACTIVATED:
                                     PanelActivate((HWND)lParam);
                                     break;

         case HSHELL_WINDOWREPLACING:
                                     ghost_window = (HWND)lParam;
                                     break;

         case HSHELL_WINDOWREPLACED:
                                     PanelReplace((HWND)lParam,ghost_window);
                                     ghost_window = NULL;
                                     break;
         
         case HSHELL_WINDOWCREATED:
                                     PanelAdd((HWND)lParam);
                                     break;

         case HSHELL_WINDOWDESTROYED:
                                     PanelRemove((HWND)lParam);
                                     break;

         case HSHELL_REDRAW:
                                     PanelRedraw((HWND)lParam);
                                     break;

         case HSHELL_ENDTASK:
                                     EndTaskRequest((HWND)lParam);
                                     break;

         case HSHELL_APPCOMMAND:
                                     switch ( GET_APPCOMMAND_LPARAM(lParam) )
                                     {
                                       case APPCOMMAND_BROWSER_BACKWARD:
                                       case APPCOMMAND_BROWSER_FAVORITES:
                                       case APPCOMMAND_BROWSER_FORWARD:
                                       case APPCOMMAND_BROWSER_HOME:
                                       case APPCOMMAND_BROWSER_REFRESH:
                                       case APPCOMMAND_BROWSER_SEARCH:
                                       case APPCOMMAND_BROWSER_STOP:
                                       case APPCOMMAND_CLOSE:
                                       case APPCOMMAND_FIND:
                                       case APPCOMMAND_FORWARD_MAIL:
                                       case APPCOMMAND_HELP:
                                       case APPCOMMAND_LAUNCH_APP1:
                                       case APPCOMMAND_LAUNCH_APP2:
                                       case APPCOMMAND_LAUNCH_MAIL:
                                       case APPCOMMAND_NEW:
                                       case APPCOMMAND_OPEN:
                                       case APPCOMMAND_PRINT:
                                       case APPCOMMAND_REPLY_TO_MAIL:
                                       case APPCOMMAND_SAVE:
                                       case APPCOMMAND_SEND_MAIL:
                                       case APPCOMMAND_SPELL_CHECK:
                                                                       return 1;
                                     };
                                     break;
       };

       return 0;
     }
  
  switch ( message )
  {
    case WM_DESTROY:
                   DoneWindowProcWrapper(hwnd);
                   return 0;
    
    case WM_PAINT:
                   {
                     PAINTSTRUCT ps;
                     HDC hdc = BeginPaint(hwnd,&ps);
                     OnPaint(hdc);
                     EndPaint(hwnd,&ps);
                   }
                   return 0;

    case WM_CLOSE:
                   return 0;

    case WM_WINDOWPOSCHANGING:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;
                     int sw,sh;

                     if ( IsIconic(hwnd) )
                        {
                          int h = Get2DTheme()->transparent_pad + Get2DTheme()->panel_height;
                          
                          sw = GetSystemMetrics(SM_CXSCREEN);
                          sh = GetSystemMetrics(SM_CYSCREEN);

                          p->hwnd = hwnd;
                          p->hwndInsertAfter = NULL;
                          p->x = 0;
                          p->y = sh-h;
                          p->cx = sw;
                          p->cy = h;
                          p->flags = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_SHOWWINDOW;

                          ShowWindow(hwnd,SW_RESTORE);
                          return 0;
                        }
                     else
                        break;
                   }

    case WM_SYSCHAR:
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
                   return 0;

    case WM_DISPLAYCHANGE:
                   return 0;

    case WM_ACTIVATE:
                   if ( LOWORD(wParam) == WA_INACTIVE )
                      {
                        HWND other = (HWND)lParam;
                        if ( other )
                           {
                             if ( GetWindowThreadProcessId(other,NULL) == GetCurrentThreadId() )
                                {
                                  if ( desk )
                                     {
                                       desk->BringToBottom();
                                       return 0;
                                     }
                                }
                           }
                      }
                   break;
    
    case WM_MOUSEACTIVATE:
                   return MA_NOACTIVATE;

    case WM_LBUTTONDOWN:
    case WM_RBUTTONDOWN:
    case WM_MBUTTONDOWN:
                   if ( !SheetTest(LOWORD(lParam),HIWORD(lParam)) )
                      PanelShellActivate();

    case WM_LBUTTONUP:
    case WM_LBUTTONDBLCLK:
    case WM_RBUTTONUP:
    case WM_RBUTTONDBLCLK:
    case WM_MBUTTONUP:
    case WM_MBUTTONDBLCLK:
    case WM_MOUSEMOVE:
                   if ( tray )
                      tray->OnClick(message,wParam,lParam);
                   if ( ql )
                      ql->OnClick(message,wParam,lParam);
                   if ( message == WM_LBUTTONDOWN )
                      ButtonClick(LOWORD(lParam),HIWORD(lParam));
                   if ( message == WM_LBUTTONUP )
                      SheetClick(LOWORD(lParam),HIWORD(lParam));
                   if ( message == WM_RBUTTONUP )
                      SheetRClick(LOWORD(lParam),HIWORD(lParam));
                   if ( message == WM_MOUSEMOVE )
                      {
                        CWaitCursor::UpdateCurrentCursor();
                        ProcessHighliting(TRUE);
                        UpdateTrackingWithHover(hwnd);
                      }
                   return 0;

    case WM_MOUSEHOVER:
                   ProcessHighliting(TRUE);
                   UpdateTrackingWithHover(hwnd);
                   return 0;

    case WM_MOUSELEAVE:
                   ProcessHighliting(TRUE);
                   return 0;

    case WM_NOTIFY:
                   OnNotifyMessage((NMHDR *)lParam);
                   break;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CTaskPane::MinimizedWindowsTrayHide(void)
{
  MINIMIZEDMETRICS mm;

  ZeroMemory(&mm,sizeof(mm));
  mm.cbSize = sizeof(mm);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS,sizeof(MINIMIZEDMETRICS),&mm,0);
  if ( !(mm.iArrange & ARW_HIDE) )
     {
       mm.iArrange |= ARW_HIDE;
       SystemParametersInfo(SPI_SETMINIMIZEDMETRICS,sizeof(MINIMIZEDMETRICS),&mm,0);
     }
}


void CTaskPane::MinimizedWindowsTrayShow(void)
{
  MINIMIZEDMETRICS mm;

  ZeroMemory(&mm,sizeof(mm));
  mm.cbSize = sizeof(mm);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS,sizeof(MINIMIZEDMETRICS),&mm,0);
  if ( mm.iArrange & ARW_HIDE )
     {
       mm.iArrange &= ~ARW_HIDE;
       SystemParametersInfo(SPI_SETMINIMIZEDMETRICS,sizeof(MINIMIZEDMETRICS),&mm,0);
     }
}


void CTaskPane::SetWorkArea(void)
{
  RECT r,q;

  r.left = 0;
  r.right = GetSystemMetrics(SM_CXSCREEN);
  r.top = 0;
  r.bottom = GetSystemMetrics(SM_CYSCREEN)-Get2DTheme()->panel_height;

  if ( !is_xp_theme_active )
   r.bottom -= GetSystemMetrics(SM_CYSIZEFRAME);
  
  SystemParametersInfo(SPI_GETWORKAREA,0,&q,0);
  if ( !EqualRect(&r,&q) )
     SystemParametersInfo(SPI_SETWORKAREA,0,&r,SPIF_SENDCHANGE);
}


void CTaskPane::ClearWorkArea(void)
{
  RECT r,q;

  r.left = 0;
  r.right = GetSystemMetrics(SM_CXSCREEN);
  r.top = 0;
  r.bottom = GetSystemMetrics(SM_CYSCREEN);
  
  SystemParametersInfo(SPI_GETWORKAREA,0,&q,0);
  if ( !EqualRect(&r,&q) )
     SystemParametersInfo(SPI_SETWORKAREA,0,&r,SPIF_SENDCHANGE);
}


CTaskPane::CTaskPane(HWND main_window)
{
  {
    is_xp_theme_active = FALSE;

    HINSTANCE lib = LoadLibrary("uxtheme.dll");
    if ( lib )
       {
         BOOL (WINAPI *pIsThemeActive)() = NULL;
         *(void**)&pIsThemeActive = (void*)GetProcAddress(lib,"IsThemeActive");
         if ( pIsThemeActive )
            is_xp_theme_active = pIsThemeActive();

         FreeLibrary(lib);
       }
  }
  
  w_main = main_window;
  w_panel = NULL;

  tray = NULL;
  ql = NULL;
  desk = NULL;

  msg_panel_update = RegisterWindowMessage("_MsgTaskPane_PanelUpdate");
  msg_redraw_single_icon = RegisterWindowMessage("_MsgTaskPane_RedrawSingleIcon");
  ghost_window = NULL;
  msg_shellhook = RegisterWindowMessage("SHELLHOOK");
  icon16x16 = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_ICON),IMAGE_ICON,16,16,LR_SHARED);
  menu_active = FALSE;
  last_menu_active = 0;
  SetRectEmpty(&hl_rect);
  tooltip = NULL;

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = CS_DBLCLKS;
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = mainclass;
  RegisterClass(&wc);
  
  int w = GetSystemMetrics(SM_CXSCREEN);
  int h = Get2DTheme()->transparent_pad + Get2DTheme()->panel_height;
  int x = 0;
  int y = GetSystemMetrics(SM_CYSCREEN)-h;

  w_panel = CreateWindowEx(WS_EX_TOOLWINDOW,mainclass,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(w_panel);
  SetWindowLong(w_panel,GWL_USERDATA,MAGIC_WID);

  tooltip = CreateWindowEx(0,TOOLTIPS_CLASS,NULL,TTS_NOPREFIX | TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,our_instance,NULL);
  SetWindowPos(tooltip,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
  SendMessage(tooltip,TTM_ACTIVATE,TRUE,0);

  tray = new CTray(w_main,w_panel,msg_panel_update,msg_redraw_single_icon);
  ql = new CQuickLaunch(w_main,w_panel);

  SetPanelVisRegion();
  SetWindowPos(w_panel,HWND_NOTOPMOST,0,0,0,0,SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSENDCHANGING | SWP_NOSIZE | SWP_SHOWWINDOW);
  MinimizedWindowsTrayHide();
  SetWorkArea();
  EnumApps();
  PanelUpdate();
  UpdateTrackingWithHover(w_panel);
  InitGlobalHook(w_panel);
  SetGlobalHook64(TRUE);
}


CTaskPane::~CTaskPane()
{
  ShowWindow(w_panel,SW_HIDE);

  SetGlobalHook64(FALSE);
  DoneGlobalHook(w_panel);
  ClearWorkArea();
  MinimizedWindowsTrayShow();

  SAFEDELETE(ql);
  SAFEDELETE(tray);
  
  DestroyWindow(tooltip);
  DestroyWindow(w_panel);
  UnregisterClass(mainclass,our_instance);
  w_panel = NULL;
}


void CTaskPane::SetDeskObj(CDesk *obj)
{
  desk = obj;
}


void CTaskPane::OnEndSession()
{
  ShowWindow(w_panel,SW_HIDE);
  SetGlobalHook64(FALSE);
  DoneGlobalHook(w_panel);
  ClearWorkArea();
}


void CTaskPane::OnDeskMouseDown()
{
  PanelShellActivate();
}


