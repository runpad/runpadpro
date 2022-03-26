
#include "include.h"


#define ICONSPAD       3
#define BTNSIZE        16
#define SCROLLWH       (BTNSIZE+2)

#define GROUPDIVCLIENTSIZE  22
#define GROUPDIVTOTALSIZE   (GROUPDIVCLIENTSIZE+3)




CSheetWindow::COverlay::COverlay(int res_idx)
{
  hdc = CreateCompatibleDC(NULL);
  bitmap = LoadBitmap(our_instance,MAKEINTRESOURCE(res_idx));
  old_bitmap = (HBITMAP)SelectObject(hdc,bitmap);
  BITMAP b;
  GetObject(bitmap,sizeof(b),&b);
  w = b.bmWidth;
  h = b.bmHeight;
  if ( h < 0 )
     h = -h;
}

CSheetWindow::COverlay::~COverlay()
{
  if ( hdc )
     {
       SelectObject(hdc,old_bitmap);
       DeleteObject(bitmap);
       DeleteDC(hdc);
     }
}

void CSheetWindow::COverlay::Draw(HDC dest_hdc,int x,int y)
{
  BitBlt(dest_hdc,x,y,w,h,hdc,0,0,SRCCOPY);
}


void CSheetWindow::RetrieveIconSystemParms()
{
  int sizew=0,sizeh=0,w=0,h=0;
  
  if ( use_system_icon_spacing )
     {
       SystemParametersInfo(SPI_ICONHORIZONTALSPACING,0,&w,0);
       if ( w < 85 )
          w = 85;
       SystemParametersInfo(SPI_ICONVERTICALSPACING,0,&h,0);
       if ( h < 85 )
          h = 85;
     
       char s[MAX_PATH];
       ReadRegStr(HKCU,"Control Panel\\Desktop\\WindowMetrics","Shell Icon Size",s,"");
       int size = StrToInt(s);
       size = RangeI(size,32,192);
       size = size / 16 * 16;
       sizeh = size;
       sizew = sizeh*4/3;
     }
  else
     {
       w = icon_spacing_w;
       if ( w < 70 )
          w = 70;
       h = icon_spacing_h;
       if ( h < 70 )
          h = 70;

       sizeh = RangeI(icon_size_h,32,192);
       sizew = RangeI(icon_size_w,32,256);
     }

  if ( w > 300 )
     w = 300;
  if ( h > 250 )
     h = 250;
     
  icon_size1 = sizeh;
  icon_size1w = sizew;
  icon_size2 = icon_size1+16;
  icon_size2w = icon_size1w+16;
  cell_width = w;
  cell_height = h;

  SystemParametersInfo(SPI_GETICONTITLELOGFONT,sizeof(icons_font),&icons_font,0);
  icons_font.lfCharSet = DEFAULT_CHARSET;
}


BOOL CSheetWindow::IsOnlyDefaultGroup()
{
  if ( icon_groups.size() == 0 )
     return TRUE;

  if ( icon_groups.size() == 1 && !lstrcmpi(icon_groups[0].name,"") )
     return TRUE;

  if ( icons_winstyle )
     return TRUE; //todo: support this

  return FALSE;
}


void CSheetWindow::GetGroupIdxByNum(int num,int &_group,int &_local)
{
  if ( !IsInvalidIconIdx(num) )
     {
       icons[num]->GetGroupAndLocalIndexes(_group,_local);
     }
}


int CSheetWindow::GetNumByGroupIdx(int group,int local)
{
  int rc = -1;

  if ( group >= 0 && group < icon_groups.size() )
     {
       if ( local >= 0 && local < icon_groups[group].count )
          {
            for ( int n = 0; n < icons.size(); n++ )
                {
                  int g = -1;
                  int l = -1;
                  icons[n]->GetGroupAndLocalIndexes(g,l);

                  if ( g == group && l == local )
                     {
                       rc = n;
                       break;
                     }
                }
          }
     }

  return rc;
}


int CSheetWindow::GetFirstVisIconIdx()
{
  return icons.size() == 0 ? -1 : 0;
}


int CSheetWindow::GetLastVisIconIdx()
{
  int idx = -1;
  
  if ( icons.size() > 0 )
     {
       int g_idx = icon_groups.size()-1;
       int l_idx = icon_groups[g_idx].count-1;
       idx = GetNumByGroupIdx(g_idx,l_idx);
     }

  return idx;
}


int CSheetWindow::GetGroupClientSizeWH(int group,int draw_wh_count)
{
  if ( group < 0 || group >= icon_groups.size() )
     return 0;
  
  int numicons = icon_groups[group].count;
  
  if ( !icons_winstyle )
     {
       return (numicons + draw_wh_count - 1) / draw_wh_count * cell_height;
     }
  else
     {
       return (numicons + draw_wh_count - 1) / draw_wh_count * cell_width;
     }
}


int CSheetWindow::GetGroupTotalSizeWH(int group,int draw_wh_count)
{
  return GetGroupClientSizeWH(group,draw_wh_count) + (IsOnlyDefaultGroup()?0:GROUPDIVTOTALSIZE);
}


int CSheetWindow::GetAllGroupsBeforeThisTotalSizeWH(int before_group,int draw_wh_count)
{
  int size = 0;
  
  for ( int n = 0; n < before_group; n++ )
      {
        size += GetGroupTotalSizeWH(n,draw_wh_count);
      }

  return size;
}


int CSheetWindow::GetAllGroupsTotalSizeWH(int draw_wh_count)
{
  return GetAllGroupsBeforeThisTotalSizeWH(icon_groups.size(),draw_wh_count);
}


void CSheetWindow::GetCellsApprVisCount(int *_w,int *_h)
{
  RECT r;
  int w,h;
  
  GetSheetDrawRect(&r,NULL);
  
  *_w = (r.right - r.left) / cell_width;
  *_h = (r.bottom - r.top) / cell_height;
}


// returns TRUE if scroll present and delta-scroll-count
BOOL CSheetWindow::GetSheetDrawRect(RECT *r,int *_delta)
{
  BOOL rc = FALSE;
  RECT wr;
  int w,h,vis_w,vis_h;

  if ( _delta )
     *_delta = 0;
  
  GetClientRect(w_sheet,&wr);
  
  w = wr.right - wr.left;
  h = wr.bottom - wr.top;

  if ( w == 0 || h == 0 )
     {
       SetRectEmpty(r);
       return rc;
     }
  
  r->left = ICONSPAD;
  r->top = ICONSPAD;
  r->right = w-ICONSPAD;
  r->bottom = h-ICONSPAD;

  vis_w = r->right - r->left;
  vis_h = r->bottom - r->top;
  w = vis_w / cell_width;
  h = vis_h / cell_height;
  
  if ( !icons_winstyle )
     {
       int max = GetAllGroupsTotalSizeWH(w);
       if ( max > vis_h )
          {
            r->right -= SCROLLWH + ICONSPAD;
            vis_w = r->right - r->left;
            w = vis_w / cell_width;
            max = GetAllGroupsTotalSizeWH(w);
            if ( _delta )
               *_delta = max-vis_h;
            rc = TRUE;
          }
     }
  else
     {
       int max = GetAllGroupsTotalSizeWH(h);
       if ( max > vis_w )
          {
            r->bottom -= SCROLLWH + ICONSPAD;
            vis_h = r->bottom - r->top;
            h = vis_h / cell_height;
            max = GetAllGroupsTotalSizeWH(h);
            if ( _delta )
               *_delta = max-vis_w;
            rc = TRUE;
          }
     }
  
  return rc;
}


CSheetWindow::CLICKAREA CSheetWindow::GetClickArea(int x,int y,int *_idx)
{
  RECT r;
  POINT p;

  if ( _idx )
     *_idx = -1;

  p.x = x;
  p.y = y;

  GetSheetDrawRect(&r,NULL);
  if ( PtInRect(&r,p) )
     {
       if ( _idx )
          *_idx = GetIconByPos(x,y);
       
       return AREA_ICONS;
     }

  GetButtonScrollUpRect(&r);
  if ( PtInRect(&r,p) )
     return AREA_BUTTONUP;

  GetButtonScrollDownRect(&r);
  if ( PtInRect(&r,p) )
     return AREA_BUTTONDOWN;

  GetButtonScrollerRect(&r);
  if ( PtInRect(&r,p) )
     return AREA_SCROLLER;

  GetEntireScrollRect(&r);
  if ( PtInRect(&r,p) )
     return AREA_ENTIRESCROLL;

  return AREA_NONE;
}


int CSheetWindow::Interpolate(int v1,int v2,int perc)
{
  if ( perc < 0 )
     perc = 0;
  if ( perc > 100 )
     perc = 100;

  return (v2-v1) * perc / 100 + v1;
}


void CSheetWindow::InterpolateRect(RECT *out,RECT *r1,RECT *r2,int perc)
{
  out->left = Interpolate(r1->left,r2->left,perc);
  out->top = Interpolate(r1->top,r2->top,perc);
  out->right = Interpolate(r1->right,r2->right,perc);
  out->bottom = Interpolate(r1->bottom,r2->bottom,perc);
}


BOOL CSheetWindow::IsIconsScrollPresent(int *_delta)
{
  RECT r;
  return GetSheetDrawRect(&r,_delta);
}


void CSheetWindow::GetCellXY(int n,int *_x,int *_y)
{
  RECT r;
  int x,y,delta;

  BOOL scroll_needed = GetSheetDrawRect(&r,&delta);
  int delta_scrolled = scroll_needed ? f2i(delta*icons_scroll) : 0;
  
  int w = (r.right - r.left) / cell_width;
  int h = (r.bottom - r.top) / cell_height;

  int group_idx = -1;
  int local_idx = -1;
  GetGroupIdxByNum(n,group_idx,local_idx);

  if ( w == 0 || h == 0 || group_idx == -1 || local_idx == -1 )
     {
       *_x = 0;
       *_y = 0;
       return;
     }

  if ( !icons_winstyle )
     {
       x = (local_idx % w)*cell_width;
       y = (local_idx / w)*cell_height;

       y += GetAllGroupsBeforeThisTotalSizeWH(group_idx,w) + (IsOnlyDefaultGroup()?0:GROUPDIVTOTALSIZE);
       y -= delta_scrolled;
     }
  else
     {
       x = (local_idx / h)*cell_width;
       y = (local_idx % h)*cell_height;

       x += GetAllGroupsBeforeThisTotalSizeWH(group_idx,h) + (IsOnlyDefaultGroup()?0:GROUPDIVTOTALSIZE);
       x -= delta_scrolled;
     }

  x += r.left;
  y += r.top;

  *_x = x;
  *_y = y;
}


void CSheetWindow::GetCellRect(int n,RECT *r)
{
  GetCellXY(n,(int*)&r->left,(int*)&r->top);

  r->right = r->left + cell_width;
  r->bottom = r->top + cell_height;
}


void CSheetWindow::MakeAbsolute(int n,RECT *r)
{
  int x,y;

  GetCellXY(n,&x,&y);
  r->left += x;
  r->right += x;
  r->top += y;
  r->bottom += y;
}


void CSheetWindow::GetIconPlacement1(int n,RECT *r)
{
  int w = GetIconSize1();
  int h = GetIconSize1();
  
  if ( !IsInvalidIconIdx(n) )
     {
       const CSystemIcon *i = icons[n]->GetSmallIcon();
       if ( i && i->IsValid() )
          {
            if ( i->IsPicture() )
               {
                 w = i->GetWidth();
                 h = i->GetHeight();
               }
          }
     }
  
  r->left = (cell_width-w)/2;
  r->top = 1;
  r->right = r->left+w;
  r->bottom = r->top+h;
}


void CSheetWindow::GetIconPlacement2(int n,RECT *r)
{
  int w = GetIconSize2();
  int h = GetIconSize2();
  
  if ( !IsInvalidIconIdx(n) )
     {
       const CSystemIcon *i = icons[n]->GetBigIcon();
       if ( i && i->IsValid() )
          {
            if ( i->IsPicture() )
               {
                 w = i->GetWidth();
                 h = i->GetHeight();
               }
          }
     }

  r->left = (cell_width-w)/2;
  r->top = 1 - (GetIconSize2() - GetIconSize1()) / 2;
  r->right = r->left+w;
  r->bottom = r->top+h;
}


void CSheetWindow::GetCellRectExt(int n,RECT *r)
{
  int delta = (GetIconSize2() - GetIconSize1()) / 2 + 1/*pad*/;
  GetCellRect(n,r);
  r->top -= delta;
  r->bottom += delta;
  r->left -= delta;     // always true?
  r->right += delta;    // always true?
}


void CSheetWindow::GetTextPlacement1(RECT *r)
{
  if ( dont_show_icon_names )
     {
       SetRectEmpty(r);
     }
  else
     {
       r->left = 2;
       r->top = 1+GetIconSize1()+2;
       r->right = cell_width-2;
       r->bottom = cell_height-1;

       EliminateInvalidRect(r);
     }
}


void CSheetWindow::GetShadowPlacement1(RECT *r)
{
  if ( dont_show_icon_names )
     {
       SetRectEmpty(r);
     }
  else
     {
       r->left = 0;
       r->top = 1+GetIconSize1();
       r->right = cell_width;
       r->bottom = cell_height;

       EliminateInvalidRect(r);
     }
}


void CSheetWindow::GetTextPlacement2(RECT *r)
{
  if ( dont_show_icon_names )
     {
       SetRectEmpty(r);
     }
  else
     {
       int delta = (GetIconSize2() - GetIconSize1()) / 2;
       
       r->left = 2;
       r->top = 1+GetIconSize1()+2+delta;
       r->right = cell_width-2;
       r->bottom = cell_height-1+delta;

       EliminateInvalidRect(r);
     }
}


void CSheetWindow::GetShadowPlacement2(RECT *r)
{
  if ( dont_show_icon_names )
     {
       SetRectEmpty(r);
     }
  else
     {
       int delta = (GetIconSize2() - GetIconSize1()) / 2;
       
       r->left = 0;
       r->top = 1+GetIconSize1()+delta;
       r->right = cell_width;
       r->bottom = cell_height+delta;

       EliminateInvalidRect(r);
     }
}


int CSheetWindow::GetIconByPos(int x,int y)
{
  POINT p;
  RECT r;

  p.x = x;
  p.y = y;
  GetSheetDrawRect(&r,NULL);

  if ( PtInRect(&r,p) )
     {
       for ( int n = 0; n < icons.size(); n++ )
           {
             RECT r,r1,r2;
             
             GetIconPlacement1(n,&r1);
             MakeAbsolute(n,&r1);
             GetTextPlacement1(&r2);
             MakeAbsolute(n,&r2);

             if ( !do_icon_highlight )
                {
                  if ( PtInRect(&r1,p) )
                     return n;
                  if ( PtInRect(&r2,p) )
                     return n;
                }
             else
                {
                  UnionRect(&r,&r1,&r2);
                  if ( PtInRect(&r,p) )
                     return n;
                }
           }
     }

  return -1;
}


void CSheetWindow::DrawSingleIcon(int n,HDC hdc,int hl,BOOL fulldraw,int perc)
{
  if ( IsInvalidIconIdx(n) )
     return;
  
  if ( fulldraw )
     {
       RECT r;
       GetIconPlacement2(n,&r);
       MakeAbsolute(n,&r);
       InvalidateRect(w_sheet,&r,FALSE);
     }
  else
     {
       const CSystemIcon* icon1 = icons[n]->GetSmallIcon();
       const CSystemIcon* icon2 = icons[n]->GetBigIcon();
       
       if ( !icon1 || !icon1->IsValid() || !icon2 || !icon2->IsValid() )
          return;

       RECT r,r1,r2;
       const CSystemIcon* i_icon = perc > 0 ? icon2 : icon1;
       HICON h_icon = i_icon->GetHandle();

       if ( hl == n )
          h_icon = CreateHilitedIcon(h_icon);
       
       GetIconPlacement1(n,&r1);
       GetIconPlacement2(n,&r2);
       InterpolateRect(&r,&r1,&r2,perc);
       MakeAbsolute(n,&r);
       DrawIconEx(hdc,r.left,r.top,h_icon,r.right-r.left,r.bottom-r.top,0,NULL,i_icon->IsMaskPresent()?DI_NORMAL:DI_IMAGE);
       if ( icons[n]->GetShortcut()->GetSaver()[0] )
          {
            int h_icon_size = Interpolate(GetIconSize1(),GetIconSize2(),perc);
            COverlay *overlay = (h_icon_size == 32 ? overlay_small : overlay_big);
            overlay->Draw(hdc,r.left,r.bottom-overlay->GetHeight());
          }

       if ( hl == n )
          DestroyIcon(h_icon);
     }
}


void CSheetWindow::DrawSingleText(int n,HDC hdc,CRBuff *i,RBUFF *shadow,int perc)
{
  RECT r,r1,r2;

  if ( IsInvalidIconIdx(n) )
     return;
  
  const char *name = icons[n]->GetShortcut()->GetName();
  
  if ( !name || !name[0] )
     return;
  
  if ( !shadow || !shadow->hdc || !i || !i->GetHDC() )
     return;

  SetBkMode(hdc,TRANSPARENT);
  SetTextColor(hdc,0xFFFFFF);

  GetShadowPlacement1(&r1);
  GetShadowPlacement2(&r2);
  InterpolateRect(&r,&r1,&r2,perc);
  MakeAbsolute(n,&r);

  if ( !IsRectEmpty(&r) )
     {
       RBUFF tb;
       i->FillRBuffStruct(&tb);
       RB_DrawShadow(shadow,&tb,r.left,r.top,1);

       GetTextPlacement1(&r1);
       GetTextPlacement2(&r2);
       InterpolateRect(&r,&r1,&r2,perc);
       MakeAbsolute(n,&r);
       DrawText(hdc,name,-1,&r,DT_CENTER | DT_WORDBREAK | DT_EDITCONTROL);
     }
}


void CSheetWindow::DrawHighlightUnderIcon(HDC hdc,int perc)
{
  if ( !IsInvalidIconIdx(hl_rect_idx) )
     {
       RECT r;
       GetCellRectExt(hl_rect_idx,&r);
       DrawIconHLInternal(hdc,&r,perc);
     }
}


//!works only when icons_winstyle==FALSE
void CSheetWindow::DrawGroupDividerInternal(HDC hdc,const RECT *rect,const char *name)
{
  int w = rect->right - rect->left;
  int h = rect->bottom - rect->top;

  if ( w > 0 && h > 0 )
     {
       RBUFF buff;
       RB_CreateNormal(&buff,w,h);
       //RB_Fill(&buff,theme.grad1);
       RECT r;
       SetRect(&r,0,0,w,h);
       Draw_Window_Rect(buff.hdc,&r,FALSE,FALSE,TRUE,TRUE,theme.grad1,theme.grad2);
       MakeTransparent(hdc,buff.hdc,rect->left,rect->top,0,0,w,h,80);
       RB_Destroy(&buff);

       if ( !IsStrEmpty(name) )
          {
            static const int hpad = 8;
            char s[MAX_PATH];

            lstrcpyn(s,name,sizeof(s)-1);
            CharUpperBuff(s,lstrlen(s));
            
            HFONT font = CreateFont(-14,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
            HFONT oldfont = (HFONT)SelectObject(hdc,font);
            SetBkMode(hdc,TRANSPARENT);
            SetTextColor(hdc,theme.activetext);

            RECT fr;
            SetRect(&fr,0,0,1,1);
            DrawText(hdc,s,-1,&fr,DT_CALCRECT | DT_LEFT | DT_VCENTER | DT_SINGLELINE);
            int font_width = fr.right-fr.left;
            if ( font_width > w-2*hpad )
               font_width = w-2*hpad;

            RECT r;
            CopyRect(&r,rect);
            //r.left += hpad;
            r.left += (w-font_width)/2;
            r.right = r.left + font_width;

            DrawTextWithShadow(hdc,s,&r,DT_LEFT | DT_VCENTER | DT_SINGLELINE,1,2);

            SelectObject(hdc,oldfont);
            DeleteObject(font);
          }
     }
}


void CSheetWindow::DrawIcons(HDC hdc,CRBuff *i)
{
  int n,hl_idx;
  HFONT font,oldfont;
  RECT r;
  HRGN rgn;
  BOOL is_scroller;

  if ( hl_rect_idx != -1 && i && hdc )
     hl_idx = hl_rect_idx;
  else
     hl_idx = -1;

  if ( hl_idx != -1 && IsInvalidIconIdx(hl_idx) )
     hl_idx = -1;
     
  // draw non-hilited items
  is_scroller = GetSheetDrawRect(&r,NULL);
  rgn = CreateRectRgnIndirect(&r);
  SelectClipRgn(hdc,rgn);

  {
    // group dividers
    if ( !IsOnlyDefaultGroup() )
       {
         for ( int n = 0; n < icon_groups.size(); n++ )
             {
               RECT gr;
               GetGroupDividerRect(n,&gr);

               RECT tr;
               SetRectEmpty(&tr);
               IntersectRect(&tr,&gr,&r);

               if ( !IsRectEmpty(&tr) )  //optimization
                  {
                    DrawGroupDividerInternal(hdc,&gr,icon_groups[n].name);
                  }
             }
       }
  }

  font = CreateFontIndirect(&icons_font);
  oldfont = (HFONT)SelectObject(hdc,font);
  for ( n = 0; n < icons.size(); n++ )
      {
        if ( n != hl_idx )
           {
             DrawSingleText(n,hdc,i,icons[n]->GetShadow(),0);
             DrawSingleIcon(n,hdc,hilited,FALSE,0);
           }
      }
  SelectObject(hdc,oldfont);
  DeleteObject(font);

  // draw hilited item
  if ( hl_idx != -1 )
     {
       if ( !is_scroller )
          {
            SelectClipRgn(hdc,NULL);
            DeleteObject(rgn);

            GetClientRect(w_sheet,&r);
            rgn = CreateRectRgnIndirect(&r);
            SelectClipRgn(hdc,rgn);
          }

       DrawHighlightUnderIcon(hdc,g_movement_percent);
       
       LOGFONT lf = icons_font;
       lf.lfWeight = Interpolate(lf.lfWeight,FW_BOLD,g_movement_percent);
       font = CreateFontIndirect(&lf);
       oldfont = (HFONT)SelectObject(hdc,font);

       // todo: optimize allocation of RBUFF
       RBUFF shadow;
       ZeroMemory(&shadow,sizeof(shadow));
       CreateShadowInternal(&shadow,icons[hl_idx]->GetShortcut()->GetName(),g_movement_percent);
       DrawSingleText(hl_idx,hdc,i,&shadow,g_movement_percent);
       DrawSingleIcon(hl_idx,hdc,hilited,FALSE,g_movement_percent);
       RB_Destroy(&shadow);

       SelectObject(hdc,oldfont);
       DeleteObject(font);
     }

  SelectClipRgn(hdc,NULL);
  DeleteObject(rgn);
}


void CSheetWindow::HiliteIcon(int num)
{
  if ( !IsInvalidIconIdx(num) )
     {
       if ( hilited != -1 )
          DrawSingleIcon(hilited,NULL,0,TRUE,0/*ignored*/);
       DrawSingleIcon(num,NULL,0,TRUE,0/*ignored*/);
       hilited = num;
     }
}


void CSheetWindow::Unhilite(void)
{
  if ( hilited != -1 )
     {
       DrawSingleIcon(hilited,NULL,0,TRUE,0/*ignored*/);
       last_hilited = hilited;
     }

  hilited = -1;
}


void CSheetWindow::ProcessHighliting(BOOL from_wm_mousemove,BOOL do_update)
{
  if ( IsWeAreMinimized() )
     return;
  
  if ( do_icon_highlight && CanUseGFX() && !IsAnyChildWindows() && IsWeAreForeground() && drag_mode != DRAG_SCROLLER )
     {
       RECT r;
       POINT p={-1,-1},sp;
       BOOL cover,find=FALSE;
       int idx = -1;
       
       GetCursorPos(&p);
       cover = (WindowFromPoint(p) == w_sheet);
       sp.x = 0;
       sp.y = 0;
       ClientToScreen(w_sheet,&sp);
       p.x -= sp.x;
       p.y -= sp.y;

       GetSheetDrawRect(&r,NULL);
       if ( !PtInRect(&r,p) )
          cover = FALSE;

       if ( cover )
          {
            int n;
            
            for ( n = 0; n < icons.size(); n++ )
                {
                  GetCellRect(n,&r);

                  if ( PtInRect(&r,p) )
                     {
                       find = TRUE;
                       idx = n;
                       break;
                     }
                }
          }
       
       if ( find )
          {
            if ( hl_rect_idx == idx )
               return;

            if ( !IsInvalidIconIdx(hl_rect_idx) )
               {
                 RECT r;
                 GetCellRectExt(hl_rect_idx,&r);
                 InvalidateRect(w_sheet,&r,FALSE);
               }
            
            hl_rect_idx = idx;
            GetCellRectExt(hl_rect_idx,&r);

            if ( from_wm_mousemove )
               {
                 HideTooltips();

                 if ( !IsBGMotion() )
                    {
                      unsigned starttime = GetTickCount();
                      unsigned endtime = starttime + 100;
                      BOOL finish = FALSE;

                      do {
                        g_movement_percent = (GetTickCount()-starttime)*100/(endtime-starttime);

                        if ( g_movement_percent >= 100 )
                           {
                             g_movement_percent = 100;
                             finish = TRUE;
                           }
                        
                        InvalidateRect(w_sheet,&r,FALSE);
                        UpdateWindow(w_sheet);
                        Sleep(1);
                      } while ( !finish );
                    }
                 else
                    {
                      g_movement_percent = 100;
                      InvalidateRect(w_sheet,&r,FALSE);
                    }
               }
            else
               {
                 InvalidateRect(w_sheet,&r,FALSE);
               }

            if ( do_update )
               UpdateWindow(w_sheet);
            return;
          }
     }

  if ( !IsInvalidIconIdx(hl_rect_idx) )
     {
       RECT r;
       GetCellRectExt(hl_rect_idx,&r);
       InvalidateRect(w_sheet,&r,FALSE);

       hl_rect_idx = -1;

       if ( do_update )
          UpdateWindow(w_sheet);
     }
}


HICON CSheetWindow::CreateHilitedIcon(HICON in)
{
  ICONINFO i;
  HDC hdc1,hdc2;
  HBITMAP oldb1,oldb2,bitmap;
  BITMAPINFO bi;
  BITMAP b;
  void *bits = NULL;
  DWORD *pix;
  int w,h,n,t;
  HICON icon;
  unsigned char color[4];

  if ( !in )
     return NULL;

  GetIconInfo(in,&i);
  if ( !i.hbmColor )
     return CopyIcon(in);
  
  GetObject(i.hbmColor,sizeof(b),&b);
  w = b.bmWidth;
  h = b.bmHeight;

  hdc2 = CreateCompatibleDC(NULL);
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = w;
  bi.bmiHeader.biHeight = h;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 32;
  bitmap = CreateDIBSection(hdc2,&bi,DIB_RGB_COLORS,&bits,NULL,0);
  oldb2 = (HBITMAP)SelectObject(hdc2,bitmap);

  hdc1 = CreateCompatibleDC(NULL);
  oldb1 = (HBITMAP)SelectObject(hdc1,i.hbmColor);

  FillMemory(bits,w*h*4,0xFF); // ensure alpha is 1.0
  BitBlt(hdc2,0,0,w,h,hdc1,0,0,SRCCOPY);

  SelectObject(hdc1,oldb1);
  DeleteDC(hdc1);

  SelectObject(hdc2,oldb2);
  DeleteDC(hdc2);

  n = w*h;
  pix = (DWORD*)bits;
  do {
   *(int*)color = *pix;
   t = color[0];
   t -= 32;
   if ( t < 0 )
      t = 0;
   color[0] = t;
   color[1] >>= 1;
   color[2] >>= 1;
   *pix++ = *(int*)color;
  } while ( --n );

  DeleteObject(i.hbmColor);
  i.hbmColor = bitmap;
  icon = CreateIconIndirect(&i);
  DeleteObject(i.hbmMask);

  DeleteObject(bitmap);

  return icon?icon:CopyIcon(in);
}


void CSheetWindow::CreateShadowInternal(RBUFF *shadow,const char *name,int perc)
{
  LOGFONT lf;
  HFONT font,oldfont;
  HDC hdc;
  RECT r,r1,r2;
  int w,h;

  GetShadowPlacement1(&r1);
  GetShadowPlacement2(&r2);
  InterpolateRect(&r,&r1,&r2,perc);

  w = r.right-r.left;
  h = r.bottom-r.top;

  if ( w > 0 && h > 0 )
     {
       RB_CreateGrayscale(shadow,w,h);
       hdc = shadow->hdc;
       SetRect(&r2,0,0,w,h);
       FillRect(hdc,&r2,(HBRUSH)GetStockObject(BLACK_BRUSH));

       GetTextPlacement1(&r1);
       GetTextPlacement2(&r2);
       InterpolateRect(&r2,&r1,&r2,perc);

       r2.left -= r.left;
       r2.right -= r.left;
       r2.top -= r.top;
       r2.bottom -= r.top;
       r2.left += 1;
       r2.right += 1;
       r2.top += 1;
       r2.bottom += 1;

       SetTextColor(hdc,0xFFFFFF);
       SetBkMode(hdc,TRANSPARENT);
       lf = icons_font;
       lf.lfWeight = Interpolate(lf.lfWeight,FW_BOLD,perc);
       font = CreateFontIndirect(&lf);
       oldfont = (HFONT)SelectObject(hdc,font);
       if ( name && name[0] )
          DrawText(hdc,name,-1,&r2,DT_CENTER | DT_WORDBREAK | DT_EDITCONTROL);
       SelectObject(hdc,oldfont);
       DeleteObject(font);

       RB_Smooth(shadow,4);
     }
}


void CSheetWindow::GetGroupDividerRect(int group,RECT *_r)
{
  SetRectEmpty(_r);

  RECT r;
  int delta;
  BOOL scroll_needed = GetSheetDrawRect(&r,&delta);
  int delta_scrolled = scroll_needed ? f2i(delta*icons_scroll) : 0;
  
  int w = (r.right - r.left) / cell_width;
  int h = (r.bottom - r.top) / cell_height;

  int offset = GetAllGroupsBeforeThisTotalSizeWH(group,icons_winstyle?h:w);
  offset -= delta_scrolled;

  if ( icons_winstyle )
     {
       _r->left = r.left + offset;
       _r->right = _r->left + GROUPDIVCLIENTSIZE;
       _r->top = r.top;
       _r->bottom = r.bottom;
     }
  else
     {
       _r->left = r.left;
       _r->right = r.right;
       _r->top = r.top + offset;
       _r->bottom = _r->top + GROUPDIVCLIENTSIZE;
     }
}


BOOL CSheetWindow::GetEntireScrollRect(RECT *r)
{
  BOOL rc = FALSE;
  RECT cr;
  
  SetRectEmpty(r);
  
  if ( GetSheetDrawRect(&cr,NULL) )
     {
       if ( !icons_winstyle )
          {
            cr.left = cr.right + ICONSPAD;
            cr.right = cr.left + SCROLLWH;
          }
       else
          {
            cr.top = cr.bottom + ICONSPAD;
            cr.bottom = cr.top + SCROLLWH;
          }

       *r = cr;
       rc = TRUE;
     }

  return rc;
}


void CSheetWindow::GetButtonScrollUpRect(RECT *r)
{
  RECT sr;
  
  SetRectEmpty(r);

  if ( GetEntireScrollRect(&sr) )
     {
       int delta;

       if ( !icons_winstyle )
          delta = (sr.right-sr.left-BTNSIZE)/2;
       else
          delta = (sr.bottom-sr.top-BTNSIZE)/2;

       r->left = sr.left + delta;
       r->top = sr.top + delta;
       r->right = r->left + BTNSIZE;
       r->bottom = r->top + BTNSIZE;
     }
}


void CSheetWindow::GetButtonScrollDownRect(RECT *r)
{
  RECT sr;
  
  SetRectEmpty(r);

  if ( GetEntireScrollRect(&sr) )
     {
       int delta;

       if ( !icons_winstyle )
          delta = (sr.right-sr.left-BTNSIZE)/2;
       else
          delta = (sr.bottom-sr.top-BTNSIZE)/2;

       r->right = sr.right - delta;
       r->bottom = sr.bottom - delta;
       r->left = r->right - BTNSIZE;
       r->top = r->bottom - BTNSIZE;
     }
}


void CSheetWindow::GetButtonScrollerRect(RECT *r)
{
  RECT r1,r2;
  
  SetRectEmpty(r);

  GetButtonScrollUpRect(&r1);
  GetButtonScrollDownRect(&r2);

  if ( !IsRectEmpty(&r1) && !IsRectEmpty(&r2) )
     {
       CFPU_RC_Near oFPU;
       
       if ( !icons_winstyle )
          {
            r->top = f2i((r2.top - r1.bottom - BTNSIZE) * GetIconsScrollPos() + r1.bottom);
            r->left = r1.left;
          }
       else
          {
            r->left = f2i((r2.left - r1.right - BTNSIZE) * GetIconsScrollPos() + r1.right);
            r->top = r1.top;
          }

       r->right = r->left + BTNSIZE;
       r->bottom = r->top + BTNSIZE;
     }
}


float CSheetWindow::GetNewScrollPosByXY(int x,int y)
{
  float rc = GetIconsScrollPos();
  RECT r;
  
  if ( GetEntireScrollRect(&r) )
     {
       RECT r1,r2;
       int min,max,value;

       GetButtonScrollUpRect(&r1);
       GetButtonScrollDownRect(&r2);

       if ( !icons_winstyle )
          {
            min = r1.bottom;
            max = r2.top - BTNSIZE;
            value = y;
          }
       else
          {
            min = r1.right;
            max = r2.left - BTNSIZE;
            value = x;
          }

       if ( value < min )
          value = min;
       if ( value > max )
          value = max;

       rc = (float)(value - min) / (float)(max - min);
     }

  return rc;
}


#include "shwindow_draw.inc"


void CSheetWindow::DrawButton(RBUFF *buff,int x,int y,char *data,int color,int alpha)
{
  int n,m,r,g,b;

  r = GetRValue(color);
  g = GetGValue(color);
  b = GetBValue(color);
  r = r * alpha / 255;
  g = g * alpha / 255;
  b = b * alpha / 255;
  color = RGB(b,g,r);
  color |= (alpha << 24);

  for ( m = 0; m < BTNSIZE; m++ )
      {
        int *dest = (int*)buff->bits + (m+y)*buff->w + x;
        char *src = (char*)data + m * BTNSIZE;
        
        for ( n = 0; n < BTNSIZE; n++ )
            {
              if ( *src++ )
                 *dest = color;
              dest++;
            }
      }
}


void CSheetWindow::DrawSheetBorder(HDC hdc)
{
  RECT sr;

  if ( GetEntireScrollRect(&sr) )
     {
       const int alpha_buttons = 210;
       const int alpha_back = 120;
       RBUFF buff;
       RECT ir;
       int x,y,n,c,*dest,R,G,B;
       int w = sr.right - sr.left;
       int h = sr.bottom - sr.top;
       
       RB_CreateNormal(&buff,w,h);

       n = w*h;
       R = GetRValue(theme.underline) * alpha_back / 255;
       G = GetGValue(theme.underline) * alpha_back / 255;
       B = GetBValue(theme.underline) * alpha_back / 255;
       c = (RGB(B,G,R)) | (alpha_back << 24);
       dest = (int*)buff.bits;
       do {
        *dest++ = c;
       } while ( --n );
       
       GetButtonScrollUpRect(&ir);
       OffsetRect(&ir,-sr.left,-sr.top);
       DrawButton(&buff,ir.left,ir.top,icons_winstyle?(char*)button_left:(char*)button_up,theme.tooltip_back,alpha_buttons);
       GetButtonScrollDownRect(&ir);
       OffsetRect(&ir,-sr.left,-sr.top);
       DrawButton(&buff,ir.left,ir.top,icons_winstyle?(char*)button_right:(char*)button_down,theme.tooltip_back,alpha_buttons);
       GetButtonScrollerRect(&ir);
       OffsetRect(&ir,-sr.left,-sr.top);
       DrawButton(&buff,ir.left,ir.top,(char*)button_scroller,theme.tooltip_back,alpha_buttons);

       x = sr.left;
       y = sr.top;
       if ( 1 )
          {
            BLENDFUNCTION blend;
            //MakeTransparent(hdc,buff.hdc,brect.left,brect.top,0,0,buff.w,buff.h,190);
            blend.BlendOp = AC_SRC_OVER;
            blend.BlendFlags = 0;
            blend.SourceConstantAlpha = 255;
            blend.AlphaFormat = AC_SRC_ALPHA;
            AlphaBlend(hdc,x,y,buff.w,buff.h,buff.hdc,0,0,buff.w,buff.h,blend);
          }
     
       RB_Destroy(&buff);
     }
}


void CSheetWindow::Paint(HDC hdc)
{
  if ( !IsWeAreMinimized() )
     {
       RECT cr;
       GetClientRect(w_sheet,&cr);

       int cw = cr.right - cr.left;
       int ch = cr.bottom - cr.top;

       if ( m_sheet && p_background )
          {
            BOOL rc = FALSE;

            CRBuff *back_buff = p_background->GetInternalBuff();
            
            if ( back_buff && back_buff->IsSizeMatch(cw,ch) )
               {
                 if ( p_background->PaintToInternalBuff() )
                    {
                      DrawSheetBorder(back_buff->GetHDC());
                      DrawIcons(back_buff->GetHDC(),back_buff);

                      if ( back_buff->PaintTo(hdc,0,0) )
                         {
                           rc = TRUE;
                         }
                    }
               }

            if ( !rc )
               { //fatal error here!:
                 FillRect(hdc,&cr,(HBRUSH)GetStockObject(WHITE_BRUSH));
               }
          }
       else
          {
            FillRect(hdc,&cr,(HBRUSH)GetStockObject(BLACK_BRUSH));
          }
     }
}


void CSheetWindow::Repaint()
{
  if ( !IsWeAreMinimized() )
     {
       ProcessHighliting(FALSE,FALSE);
       SetTooltips();
       InvalidateRect(w_sheet,NULL,FALSE);
       UpdateWindow(w_sheet);
     }
}


void CSheetWindow::UberEffect(int idx)
{
  if ( !IsInvalidIconIdx(idx) )
     {
       if ( CanUseGFX() )
          {
            RECT r;
            HICON icon = NULL;
            
            if ( do_icon_highlight && hl_rect_idx == idx )
               {
                 GetIconPlacement2(idx,&r);
                 icon = icons[idx]->GetBigIcon() ? icons[idx]->GetBigIcon()->GetHandle() : NULL;
               }
            else
               {
                 GetIconPlacement1(idx,&r);
                 icon = icons[idx]->GetSmallIcon() ? icons[idx]->GetSmallIcon()->GetHandle() : NULL;
               }

            MakeAbsolute(idx,&r);

            RECT dr;
            GetSheetDrawRect(&dr,NULL);

            RECT tr;
            IntersectRect(&tr,&r,&dr);

            if ( !IsRectEmpty(&tr) )
               {
                 POINT p = {0,0};
                 ClientToScreen(w_sheet,&p);

                 OffsetRect(&r,p.x,p.y);

                 if ( icon )
                    {
                      DoUberIconEffectInternal(ubericon_effect,icon,&r);
                    }
               }
          }
     }
}

