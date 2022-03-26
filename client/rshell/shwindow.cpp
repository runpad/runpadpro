
#include "include.h"


static const char *mainclass = "_RSSheetWindowClass";
static const int min_width = 400;
static const int min_height = 325;


volatile int CSheetWindow::icons_session = 0;



#define CLEAROBJ(x)   { ZeroMemory(&(x),sizeof(x)); }


BOOL CSheetWindow::IsInvalidIconIdx(int idx)
{
  return idx < 0 || idx >= icons.size();
}


BOOL CSheetWindow::IsWeAreMinimized()
{
  return IsIconic(w_sheet);
}


BOOL CSheetWindow::IsWeAreForeground()
{
  return IsWindowVisible(w_sheet) && !IsIconic(w_sheet) && (GetForegroundWindow() == w_sheet);
}


int CSheetWindow::GetCurrentWindowWidth()
{
  int rc = 0;

  if ( !IsWeAreMinimized() )
     {
       RECT r = {0,0,0,0};
       GetClientRect(w_sheet,&r);
       rc = r.right - r.left;
     }

  return rc;
}


int CSheetWindow::GetCurrentWindowHeight()
{
  int rc = 0;

  if ( !IsWeAreMinimized() )
     {
       RECT r = {0,0,0,0};
       GetClientRect(w_sheet,&r);
       rc = r.bottom - r.top;
     }

  return rc;
}


void CSheetWindow::SaverDropFiles(HDROP h)
{
  if ( m_sheet && !IsWeAreMinimized() )
     {
       POINT p = {0,0};
       DragQueryPoint(h,&p);
       int num = GetIconByPos(p.x,p.y);

       if ( !IsInvalidIconIdx(num) && icons[num]->GetShortcut()->GetSaver()[0] )
          {
            const CShortcut *sh = icons[num]->GetShortcut();

            if ( DragQueryFile(h,-1,NULL,0) == 1 )
               {
                 char src[MAX_PATH];
                 
                 src[0] = 0;
                 DragQueryFile(h,0,src,sizeof(src));
                 if ( src[0] )
                    {
                      ClientToScreen(w_sheet,&p);
                      int rc = TrackSaverPopup(sh->GetSaver(),p.x,p.y);
                      if ( rc != -1 )
                         {
                           Repaint();

                           CRealShortcut oReal(*sh);
                           
                           M_Saver(oReal.GetName(),oReal.GetCWD(),rc,src);
                         }
                    }
               }
            else
               {
                 ErrBox(LS(3077));
               }
          }
     }
}


void CSheetWindow::RightClick(int x,int y,int idx)
{
  if ( IsInvalidIconIdx(idx) )
     {
       SheetsSelectPopup();
     }
  else
     {
       const CShortcut *sh = icons[idx]->GetShortcut();
       
       const int IDM_OPENPROGRAM = 1001;
       const int IDM_SHOWDESC    = 1002;
       const int IDM_SHOWSSHOT   = 1003;
       const int IDM_SAVERBASE   = 1010;
       
       CPopupMenuWithODSeparator *menu = new CPopupMenuWithODSeparator();
       menu->Add(0,IDM_OPENPROGRAM,LS(3078));

       if ( sh->GetSaver()[0] )
          {
            LoadSaver(sh->GetSaver());
            int count = GetSaversCount();

            if ( count )
               {
                 menu->AddSeparator();

                 for ( int n = 0; n < count; n++ )
                     {
                       TSAVER *i = GetSaverAt(n);
                       menu->Add(0,IDM_SAVERBASE+n,i->title);
                     }
               }
          }
       
       menu->AddSeparator();

       BOOL is_desc = sh->GetDescription()[0];
       BOOL is_sshot = sh->GetSShotPath()[0];

       menu->Add(is_desc?0:MF_GRAYED,IDM_SHOWDESC,LS(3079));
       menu->Add(is_sshot?0:MF_GRAYED,IDM_SHOWSSHOT,LS(3080));

       int rc = menu->Popup();
       if ( rc )
          {
            if ( rc == IDM_OPENPROGRAM )
               {
                 ExecShortcut(idx,FALSE);
               }
            else
            if ( rc == IDM_SHOWDESC )
               {
                 ShowShortcutDesc(idx);
               }
            else
            if ( rc == IDM_SHOWSSHOT )
               {
                 ShowShortcutSshot(idx);
               }
            else
               {
                 CRealShortcut oReal(*sh);
                 M_Saver(oReal.GetName(),oReal.GetCWD(),rc-IDM_SAVERBASE,NULL);
               }
          }

       delete menu;
     }
}


void CSheetWindow::ExecShortcut(int num,BOOL do_effect)
{
  if ( !IsInvalidIconIdx(num) )
     {
       if ( do_effect )
          {
            UberEffect(num);
          }
       
       RunProgram(icons[num]->GetShortcut(),FALSE,m_sheet,TRUE);
     }
}


void CSheetWindow::ShowShortcutDesc(int num)
{
  if ( !IsInvalidIconIdx(num) )
     {
       const char *token = icons[num]->GetShortcut()->GetDescription();

       if ( token && token[0] )
          {
            char s[8192] = "";

            LoadTextFromDescriptionToken(token,s,sizeof(s));

            if ( s[0] )
               MsgBox(s);
          }
     }
}


void CSheetWindow::ShowShortcutSshot(int num)
{
  if ( !IsInvalidIconIdx(num) )
     {
       CRealShortcut rsh(*icons[num]->GetShortcut());

       const char *s = rsh.GetSShotPath();
       if ( !IsStrEmpty(s) )
          {
            Repaint();
            PictureBox(s);
          }
     }
}


void CSheetWindow::DesktopWheel(float delta)
{
  int max;

  if ( IsIconsScrollPresent(&max) )
     {
       RECT r;
       
       icons_scroll = (float)(max * icons_scroll - delta * 16/*pixels*/) / max;
       if ( icons_scroll < 0 )
          icons_scroll = 0;
       if ( icons_scroll > 1 )
          icons_scroll = 1;

       Repaint();
     }
}


void CSheetWindow::DesktopKeyPress(int key)
{
  int numicons = icons.size();

  switch ( key )
  {
    case VK_ESCAPE:
                     PostMessage(w_sheet,WM_CLOSE,0,0);
                     break;
    
    case VK_RETURN:
                     if ( hilited != -1 )
                        {
                          ExecShortcut(hilited,TRUE);
                        }
                     break;

    case VK_HOME:
                     if ( numicons != 0 )
                        {
                          HiliteIcon(GetFirstVisIconIdx());
                          if ( IsIconsScrollPresent(NULL) )
                             {
                               icons_scroll = 0.0;
                               Repaint();
                             }
                        }
                     break;

    case VK_END:
                     if ( numicons != 0 )
                        {
                          HiliteIcon(GetLastVisIconIdx());
                          if ( IsIconsScrollPresent(NULL) )
                             {
                               icons_scroll = 1.0;
                               Repaint();
                             }
                        }
                     break;

    case VK_LEFT:
    case VK_RIGHT:
    case VK_UP:
    case VK_DOWN:
                     if ( hilited == -1 )
                        {
                          if ( numicons != 0 )
                             {
                               int idx = last_hilited;
                               if ( idx < 0 || idx >= numicons )
                                  idx = GetFirstVisIconIdx();
                               HiliteIcon(idx);
                             }
                        }
                     else
                        {
                          if ( numicons != 0 )
                             {
                               int w,h,xoffs,yoffs;
                               GetCellsApprVisCount(&w,&h);

                               if ( icons_winstyle )
                                  {
                                    xoffs = h;
                                    yoffs = 1;
                                  }
                               else
                                  {
                                    xoffs = 1;
                                    yoffs = w;
                                  }

                               int g_idx = -1;
                               int l_idx = -1;
                               GetGroupIdxByNum(hilited,g_idx,l_idx);

                               if ( g_idx != -1 && l_idx != -1 )
                                  {
                                    if ( key == VK_LEFT )
                                       l_idx -= xoffs;
                                    else
                                    if ( key == VK_RIGHT )
                                       l_idx += xoffs;
                                    else
                                    if ( key == VK_UP )
                                       l_idx -= yoffs;
                                    else
                                    if ( key == VK_DOWN )
                                       l_idx += yoffs;

                                    if ( l_idx < 0 )
                                       {
                                         g_idx--;
                                         if ( g_idx < 0 )
                                            {
                                              g_idx = 0;
                                              l_idx = 0;
                                            }
                                         else
                                            {
                                              l_idx = icon_groups[g_idx].count-1;
                                            }
                                       }
                                    else
                                    if ( l_idx >= icon_groups[g_idx].count )
                                       {
                                         g_idx++;
                                         if ( g_idx >= icon_groups.size() )
                                            {
                                              g_idx = icon_groups.size()-1;
                                              l_idx = icon_groups[g_idx].count-1;
                                            }
                                         else
                                            {
                                              l_idx = 0;
                                            }
                                       }


                                    int idx = GetNumByGroupIdx(g_idx,l_idx);
                                    if ( idx != -1 ) //paranoja
                                       {
                                         HiliteIcon(idx);
                                       }
                                  }
                             }
                        }
                     break;

  };
}


void CSheetWindow::OnEndSession()
{
  shade_lock = TRUE;
  ShowWindow(w_sheet,SW_HIDE);
}


LRESULT CSheetWindow::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == msg_updateicons )
     {
       LAZYICONLOADUPDATEINFO *p = (LAZYICONLOADUPDATEINFO*)wParam;
       if ( p )
          {
            if ( p->session == icons_session && !IsInvalidIconIdx(p->icon_idx) )
               {
                 icons[p->icon_idx]->UpdateIcons(p->_small,p->_big);
                 if ( !IsWeAreMinimized() )
                    DrawSingleIcon(p->icon_idx,NULL,0,TRUE,0/*ignored*/);
               }
            else
               {
                 SAFEDELETE(p->_big);
                 SAFEDELETE(p->_small);
               }

            sys_free(p);
          }

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
                     Paint(hdc);
                     EndPaint(hwnd,&ps);
                   }
                   return 0;

    case WM_ACTIVATE:
    case WM_ACTIVATEAPP:
                   UpdateBGAnimationState();
                   return 0;

    case WM_CLOSE:
                   if ( !is_inside_sheet_loading )
                      {
                        FreeContent();
                        if ( on_close_proc )
                           on_close_proc(on_close_parm);
                        UpdateDeskShade();
                      }
                   return 0;

    case WM_WINDOWPOSCHANGING:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;

                     if ( !IsIconic(hwnd) )
                        {
                          if ( !(p->flags & SWP_NOSIZE) )
                             {
                               if ( p->cx < min_width )
                                  p->cx = min_width;
                               if ( p->cy < min_height )
                                  p->cy = min_height;

                               p->flags |= SWP_NOCOPYBITS;

                               return 0;
                             }
                        }
                   }
                   break;

    case WM_WINDOWPOSCHANGED:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;

                     if ( !IsIconic(hwnd) )
                        {
                          if ( !(p->flags & SWP_NOSIZE) )
                             {
                               if ( p_background )
                                  p_background->OnResize(GetCurrentWindowWidth(),GetCurrentWindowHeight());

                               Repaint();
                             }
                        }
                   }
                   break;

    case WM_SIZE:
                   {
                     if ( wParam == SIZE_RESTORED || wParam == SIZE_MINIMIZED )
                        {
                          if ( IsWindowVisible(hwnd) )
                             UpdateDeskShade();
                        }

                     UpdateBGAnimationState();
                   }
                   return 0;

    case WM_NOTIFY:
                   if ( ((NMHDR*)lParam)->hwndFrom == tooltip )
                      {
                        BOOL processed = FALSE;
                        int rc = OnTooltipNotify((NMHDR*)lParam,&processed);
                        if ( processed )
                           return rc;
                      }
                   break;

    case WM_DROPFILES:
                   if ( !IsAnyChildWindows() && m_sheet && !IsWeAreMinimized() )
                      SaverDropFiles((HDROP)wParam);
                   DragFinish((HDROP)wParam);
                   return 0;
                   
    case WM_KEYDOWN:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      DesktopKeyPress(wParam);
                   return 0;

    case WM_MOUSEWHEEL:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      DesktopWheel((float)((short)HIWORD(wParam))/120.0);
                   return 0;

    case WM_RBUTTONUP:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      {
                        int idx = -1;
                        
                        if ( GetClickArea(LOWORD(lParam),HIWORD(lParam),&idx) == AREA_ICONS )
                           {
                             RightClick(LOWORD(lParam),HIWORD(lParam),idx);
                           }
                      }
                   return 0;

    case WM_LBUTTONUP:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      {
                        if ( drag_mode != DRAG_NONE )
                           {
                             drag_mode = DRAG_NONE;
                             ReleaseCapture();
                             Repaint();
                           }
                        else
                           {
                             int idx = -1;
                             
                             switch ( GetClickArea(LOWORD(lParam),HIWORD(lParam),&idx) )
                             {
                               case AREA_BUTTONUP:
                                                    DesktopKeyPress(VK_HOME);
                                                    break;
                               case AREA_BUTTONDOWN:
                                                    DesktopKeyPress(VK_END);
                                                    break;
                               case AREA_ENTIRESCROLL:
                                                    icons_scroll = GetNewScrollPosByXY(LOWORD(lParam),HIWORD(lParam));
                                                    Repaint();
                                                    break;
                             };
                           }
                      }
                   return 0;
    
    case WM_LBUTTONDBLCLK:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      {
                        int idx = -1;

                        if ( GetClickArea(LOWORD(lParam),HIWORD(lParam),&idx) == AREA_ICONS )
                           {
                             if ( !IsInvalidIconIdx(idx) )
                                ExecShortcut(idx,TRUE);
                           }
                      }
                   return 0;

    case WM_RBUTTONDOWN:
    case WM_LBUTTONDOWN:
                   if ( !IsAnyChildWindows() && !IsWeAreMinimized() )
                      {
                        int idx = -1;
                        int x = (int)(short)(LOWORD(lParam));
                        int y = (int)(short)(HIWORD(lParam));
                        
                        idx = GetIconByPos(x,y);
                        if ( IsInvalidIconIdx(idx) )
                           Unhilite();
                        else
                           HiliteIcon(idx);

                        if ( message == WM_LBUTTONDOWN && GetClickArea(x,y,NULL) == AREA_SCROLLER )
                           {
                             drag_mode = DRAG_SCROLLER;
                             SetCapture(hwnd);
                           }
                      }
                   return 0;

    case WM_MOUSEMOVE:
                   if ( !IsWeAreMinimized() )
                      {
                        BOOL process_hl = TRUE;
                        
                        if ( drag_mode == DRAG_SCROLLER && (wParam & MK_LBUTTON) )
                           {
                             int x = (int)(short)(LOWORD(lParam));
                             int y = (int)(short)(HIWORD(lParam));

                             icons_scroll = GetNewScrollPosByXY(x,y);

                             InvalidateRect(hwnd,NULL,FALSE);
                             //UpdateWindow(hwnd);

                             process_hl = FALSE;
                           }
                        else
                           {
                             int idx = -1;
                             
                             if ( GetClickArea(LOWORD(lParam),HIWORD(lParam),&idx) == AREA_ICONS )
                                {
                                  //if ( !IsInvalidIconIdx(idx) )
                                  //   ProcessMessages(); //needed when icon highliting drawing
                                }
                           }

                        CWaitCursor::UpdateCurrentCursor();
                           
                        if ( process_hl )
                           ProcessHighliting(TRUE,TRUE);

                        UpdateTrackingWithHover(hwnd);
                      }
                   return 0;

    case WM_MOUSEHOVER:
                   ProcessHighliting(FALSE,TRUE);
                   UpdateTrackingWithHover(hwnd);
                   return 0;

    case WM_MOUSELEAVE:
                   ProcessHighliting(FALSE,TRUE);
                   return 0;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CSheetWindow::UpdateDeskShade()
{
  if ( !shade_lock )
     {
       if ( on_shade_proc )
          {
            on_shade_proc(on_shade_parm);
          }
     }
}


void CSheetWindow::UpdateBGAnimationState()
{
  if ( !shade_lock )
     {
       if ( p_background )
          {
            p_background->OnWindowStateChanged();
          }
     }
}


void CSheetWindow::SetWindowNullIcon()
{
  HICON icon;
  
  icon = (HICON)SendMessage(w_sheet, WM_SETICON, ICON_SMALL, 0);
  if ( icon )
     DestroyIcon(icon);

  icon = (HICON)SendMessage(w_sheet, WM_SETICON, ICON_BIG, 0);
  if ( icon )
     DestroyIcon(icon);
}


void CSheetWindow::SetWindowIcon(const char *file)
{
  HICON icon;

  icon = (file && file[0]) ? (HICON)LoadImage(NULL, file, IMAGE_ICON, 16, 16, LR_LOADFROMFILE) : NULL;
  icon = icon ? icon : (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_DEFSHEET),IMAGE_ICON, 16, 16, 0);
  icon = (HICON)SendMessage(w_sheet, WM_SETICON, ICON_SMALL, (LPARAM)icon);
  if ( icon )
     DestroyIcon(icon);

  icon = (file && file[0]) ? (HICON)LoadImage(NULL, file, IMAGE_ICON, 32, 32, LR_LOADFROMFILE) : NULL;
  icon = icon ? icon : (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_DEFSHEET),IMAGE_ICON, 32, 32, 0);
  icon = (HICON)SendMessage(w_sheet, WM_SETICON, ICON_BIG, (LPARAM)icon);
  if ( icon )
     DestroyIcon(icon);
}


void CSheetWindow::FreeContent(BOOL hide_window)
{
  CloseRulesWindow();
  
  HideTooltips();

  if ( hide_window )
     {
       ShowWindow(w_sheet,SW_HIDE);
       SetWindowText(w_sheet,"");
       SetWindowNullIcon();
     }

  m_sheet = NULL;

  FreeBG();
  FreeIcons();

  InitBaseVars();
}


BOOL CSheetWindow::LoadSheet(CSheet *sheet,void(*cb)(int perc,void *parm),void *cb_parm)
{
  BOOL rc = FALSE;

  if ( is_inside_sheet_loading )
     return rc;
  
  if ( sheet )
     {
       rc = TRUE;
       
       // show window
       shade_lock = TRUE;
       if ( !IsWindowVisible(w_sheet) )
          ShowWindow(w_sheet,(GetWindowLong(w_sheet,GWL_STYLE)&WS_MAXIMIZE)?SW_SHOWMAXIMIZED:SW_SHOW);
       if ( IsIconic(w_sheet) )
          ShowWindow(w_sheet,SW_RESTORE);
       SetForegroundWindow(w_sheet);
       Repaint();
       shade_lock = FALSE;
       UpdateDeskShade();

       if ( sheet != m_sheet )
          {
            // remove something from screen
            CloseRulesWindow();
            HideTooltips();
            Repaint();
            
            // prepare old (currently visible) buffer
            CRBuff *old_buff = NULL;
            if ( CanUseGFX() )
               {
                 CRBuff *buff = p_background ? p_background->GetInternalBuff() : NULL;
                 if ( buff )
                    {
                      old_buff = buff->CreateCopy();
                    }
                 else
                    {
                      int w = GetCurrentWindowWidth();
                      int h = GetCurrentWindowHeight();
                      if ( w > 0 && h > 0 )
                         {
                           old_buff = CBackground4Sheet::CreateRBuffInternalNoCheck(w,h,TRUE);
                         }
                    }
               }

            FreeContent(FALSE);
               
            SetWindowText(w_sheet,LS(3081));
            SetWindowIcon(CPathExpander(sheet->GetIconPath()));

            is_inside_sheet_loading = TRUE;
            ProcessMessages(); //todo: sometimes deadlock can happens here (reason is unknown - only one customer have got them in ?% cases)
                               // make this animation async, i.e. PostMessage(loadsheet)
            is_inside_sheet_loading = FALSE;

            // go next sheet
            m_sheet = sheet;

            {
              CWaitCursor oCursor;

              LoadIcons();
              LoadBG();
          
              if ( old_buff /*&& !IsBGMotion()*/ )
                 {
                   CRBuff *new_buff = p_background ? p_background->GetInternalBuff() : NULL;
                   if ( new_buff )
                      {
                        THEME old_theme = theme;
                        MakeTheme(sheet->GetColor()); //needed here, of course
                        Paint(new_buff->GetHDC());  // paint to itself
                        theme = old_theme;

                        RBUFF b_src, b_dest;

                        old_buff->FillRBuffStruct(&b_src);
                        new_buff->FillRBuffStruct(&b_dest);

                        RB_Animate(&b_src,&b_dest,w_sheet,cb,cb_parm);
                      }
                 }
              
              PrepareForLazyIconsLoading(w_sheet);
            }

            SAFEDELETE(old_buff);
            
            SetWindowText(w_sheet,m_sheet->GetName());

            if ( cb )
               cb(100,cb_parm);

            Repaint();

            ShowRulesWindow(CPathExpander(m_sheet->GetRulesPath()));
          }

       UpdateBGAnimationState();
     }

  return rc;
}


void CSheetWindow::InitBaseVars()
{
  hilited = -1;
  last_hilited = -1;
  icons_scroll = 0.0;
  drag_mode = DRAG_NONE;
  hl_rect_idx = -1;
  g_movement_percent = 100;
}


BOOL CSheetWindow::Close()
{
  BOOL rc = FALSE;
  
  if ( !is_inside_sheet_loading )
     {
       FreeContent();
       UpdateDeskShade();
       rc = TRUE;
     }

  return rc;
}


CSheetWindow::CSheetWindow(TOnClose OnCloseProc,void *OnCloseParm,
                           TOnShade OnShadeProc,void *OnShadeParm)
{
  on_close_proc = OnCloseProc;
  on_close_parm = OnCloseParm;
  on_shade_proc = OnShadeProc;
  on_shade_parm = OnShadeParm;
  shade_lock = TRUE;
  is_inside_sheet_loading = FALSE;
  
  m_sheet = NULL;

  overlay_small = new COverlay(IDB_OVERLAYS);
  overlay_big = new COverlay(IDB_OVERLAYB);
  
  RetrieveIconSystemParms();

  msg_updateicons = RegisterWindowMessage("_SheetsWindowUpdateIcon");

  InitBaseVars();

  p_background = NULL;

  InitTooltipData();

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = CS_DBLCLKS;
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = mainclass;
  RegisterClass(&wc);

  int sw = GetSystemMetrics(SM_CXSCREEN);
  int sh = GetSystemMetrics(SM_CYSCREEN);

  int w,h;
  
  if ( sw == 1024 && sh == 768 )
     {
       w = 768;
       h = 602;
     }
  else
  if ( sw == 1280 && sh == 1024 )
     {
       w = 960;
       h = 746;
     }
  else
     {
       h = sh*3/4+26;
       w = sh;
       if ( w > sw*8/10 )
          w = sw*8/10;
       if ( w < min_width )
          w = min_width;
       if ( h < min_height )
          h = min_height;
     }

  int x = (sw-w)/2;
  int y = (sh-h)/2;

  w_sheet = CreateWindowEx(WS_EX_ACCEPTFILES,mainclass,"",WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_OVERLAPPEDWINDOW | (sheet_init_maximize?WS_MAXIMIZE:0),x,y,w,h,NULL,NULL,our_instance,NULL);
  InitWindowProcWrapper(w_sheet);

  SetWindowNullIcon();

  tooltip = CreateWindowEx(0,TOOLTIPS_CLASS,NULL,TTS_NOPREFIX | TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,our_instance,NULL);
  SetWindowPos(tooltip,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
  SendMessage(tooltip,CCM_SETVERSION,5,0);
  SendMessage(tooltip,TTM_SETDELAYTIME,TTDT_INITIAL,MAKELONG(500, 0));
  SendMessage(tooltip,TTM_SETDELAYTIME,TTDT_AUTOPOP,MAKELONG(15000, 0));
  SendMessage(tooltip,TTM_ACTIVATE,TRUE,0);

  UpdateTrackingWithHover(w_sheet);
}



CSheetWindow::~CSheetWindow()
{
  shade_lock = TRUE;

  FreeContent();
  
  HideTooltips();
  SendMessage(tooltip,TTM_ACTIVATE,FALSE,0);
  DestroyWindow(tooltip);
  tooltip = NULL;
  FreeTooltipData();

  DestroyWindow(w_sheet);
  w_sheet = NULL;
  UnregisterClass(mainclass,our_instance);
  
  delete overlay_big;
  delete overlay_small;
}

