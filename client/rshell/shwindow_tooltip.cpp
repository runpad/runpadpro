
#include "include.h"


static const int SSHOT_WIDTH = 320;
static const int SSHOT_HEIGHT = 240;



void CSheetWindow::HideTooltips(void)
{
  SendMessage(tooltip,TTM_POP,0,0);
}


void CSheetWindow::SetTooltips(void)
{
  HideTooltips();

  if ( IsWeAreMinimized() )
     return;
  
  const int old_count = SendMessage(tooltip,TTM_GETTOOLCOUNT,0,0);
  
  for ( int n = 0; n < old_count; n++ )
      {
        TOOLINFO i;
        ZeroMemory(&i,sizeof(i));
        i.cbSize = sizeof(i);

        SendMessage(tooltip,TTM_ENUMTOOLS,0,(int)&i);
        SendMessage(tooltip,TTM_DELTOOL,0,(int)&i);
      }

  for ( int n = 0; n < icons.size(); n++ )
      {
        TOOLINFO i;
        RECT r1,r2,r;

        ZeroMemory(&i,sizeof(i));
        i.cbSize = sizeof(i);
        i.uFlags = TTF_SUBCLASS;
        i.hwnd = w_sheet;
        i.uId = n;
        i.hinst = NULL;
        i.lpszText = LPSTR_TEXTCALLBACK;
        
        GetIconPlacement1(n,&r1);
        MakeAbsolute(n,&r1);
        GetTextPlacement1(&r2);
        MakeAbsolute(n,&r2);
        UnionRect(&i.rect,&r1,&r2);

        GetSheetDrawRect(&r,NULL);
        SetRectEmpty(&r1);
        IntersectRect(&r1,&r,&i.rect);
        if ( !IsRectEmpty(&r1) )
           {
             i.rect = r1;
             SendMessage(tooltip,TTM_ADDTOOL,0,(int)&i);
           }
      }
}



void CSheetWindow::InitTooltipData(void)
{
  ttdata.idx = -1;
  ttdata.text[0] = 0;
  ttdata.p_sshot = NULL;
  SetRectEmpty(&ttdata.client_rect);
  ZeroMemory(&ttdata.back_buff,sizeof(ttdata.back_buff));
}


void CSheetWindow::FreeTooltipData(void)
{
  ttdata.idx = -1;
  ttdata.text[0] = 0;
  if ( ttdata.p_sshot )
     delete ttdata.p_sshot;
  ttdata.p_sshot = NULL;
  SetRectEmpty(&ttdata.client_rect);
  RB_Destroy(&ttdata.back_buff);
}


BOOL CSheetWindow::PreloadTooltipData(int idx,int *_w,int *_h)
{
  const int border = 5;
  const int sw = SSHOT_WIDTH;
  const int sh = SSHOT_HEIGHT;
  const char *p_sshot,*p_desc;
  int w,h;
  HDC hdc;
  HFONT font,oldfont;
  RECT r;
  
  FreeTooltipData();

  if ( IsInvalidIconIdx(idx) )
     return FALSE;

  const CShortcut *shortcut = icons[idx]->GetShortcut();

  ttdata.idx = idx;
  lstrcpy(ttdata.text,shortcut->GetName());
  
  if ( shortcut->GetSaver()[0] )
     {
       lstrcat(ttdata.text,"\n");
       lstrcat(ttdata.text,"(");
       lstrcat(ttdata.text,LS(3082));
       lstrcat(ttdata.text,")");
     }
  
  p_sshot = shortcut->GetSShotPath();
  if ( p_sshot && p_sshot[0] )
     {
       ttdata.p_sshot = new Bitmap(CUnicode(CPathExpander(p_sshot)));
       if ( ttdata.p_sshot->GetLastStatus() != Ok )
          {
            delete ttdata.p_sshot;
            ttdata.p_sshot = NULL;
          }
     }

  p_desc = shortcut->GetDescription();
  if ( p_desc && p_desc[0] )
     {
       char s[4096];

       s[0] = 0;
       LoadTextFromDescriptionToken(p_desc,s,sizeof(s));

       if ( s[0] )
          {
            lstrcat(ttdata.text,"\n\n");
            lstrcat(ttdata.text,s);
          }
     }

  if ( ttdata.p_sshot )
     lstrcat(ttdata.text,"\n\n");


  hdc = CreateCompatibleDC(NULL);
  font = CreateFont(-12,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  oldfont = (HFONT)SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);
  r.left = 0;
  r.top = 0;
  r.right = 500;
  r.bottom = 10;
  DrawText(hdc,ttdata.text,-1,&r,DT_CALCRECT | DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX);
  SelectObject(hdc,oldfont);
  DeleteObject(font);
  DeleteDC(hdc);
  
  w = r.right;
  if ( ttdata.p_sshot && w < sw )
     w = sw;
  h = r.bottom + (ttdata.p_sshot ? sh : 0);

  SetRect(&ttdata.client_rect,border,border,border+w,border+h);

  *_w = w + 2 * border + 2;
  *_h = h + 2 * border + 2;

  if ( !IsBGMotion() && CanUseGFX() )
     {
       RB_CreateNormal(&ttdata.back_buff,*_w,*_h);
     }

  return TRUE;
}


int CSheetWindow::DrawTooltip(NMTTCUSTOMDRAW *i)
{
  HWND hwnd;
  HDC hdc;
  int idx;
  int rc = CDRF_DODEFAULT;
  RECT r;
  HBRUSH brush;
  HFONT font,oldfont;
  RBUFF buff;

  hwnd = i->nmcd.hdr.hwndFrom;
  hdc = i->nmcd.hdc;
  idx = i->nmcd.hdr.idFrom;

  if ( !hwnd || !hdc )
     return rc;

  if ( IsInvalidIconIdx(idx) )
     return rc;

  if ( idx != ttdata.idx || !ttdata.text[0] )
     return rc;

  if ( IsRectEmpty(&ttdata.client_rect) )
     return rc;

  GetClientRect(hwnd,&r);

  if ( IsRectEmpty(&r) )
     return rc;

  if ( r.right < ttdata.client_rect.right - ttdata.client_rect.left ||
       r.bottom < ttdata.client_rect.bottom - ttdata.client_rect.top )
     return rc;

  RB_CreateNormal(&buff,r.right,r.bottom);
  
  RB_Fill(&buff,theme.tooltip_back);

  if ( ttdata.back_buff.hdc )
     {
       MakeTransparent(buff.hdc,ttdata.back_buff.hdc,0,0,0,0,buff.w,buff.h,210);
     }

  font = CreateFont(-12,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  oldfont = (HFONT)SelectObject(buff.hdc,font);
  SetBkMode(buff.hdc,TRANSPARENT);
  SetTextColor(buff.hdc,theme.tooltip_text);
  DrawText(buff.hdc,ttdata.text,-1,&ttdata.client_rect,DT_LEFT | DT_TOP | DT_WORDBREAK | DT_NOPREFIX);
  SelectObject(buff.hdc,oldfont);
  DeleteObject(font);

  if ( ttdata.p_sshot )
     {
       int w = SSHOT_WIDTH;
       int h = SSHOT_HEIGHT;

       Graphics *pGraphics = new Graphics(buff.hdc);
       pGraphics->SetCompositingQuality(CompositingQualityHighSpeed);
       pGraphics->SetInterpolationMode(InterpolationModeBilinear);
       pGraphics->SetCompositingMode(CompositingModeSourceCopy);
       pGraphics->DrawImage(ttdata.p_sshot,ttdata.client_rect.left,ttdata.client_rect.bottom-h,w,h);
       pGraphics->Flush(FlushIntentionSync);
       delete pGraphics;
     }

  RB_PaintTo(&buff,hdc);
  RB_Destroy(&buff);

  return CDRF_SKIPDEFAULT;
}


int CSheetWindow::OnTooltipNotify(NMHDR* hdr,BOOL *b_processed)
{
  *b_processed = TRUE;
  
  int code = hdr->code;
  int number = hdr->idFrom;

  if ( code == TTN_SHOW )
     {
       int w,h;
       
       if ( PreloadTooltipData(number,&w,&h) )
          {
            RECT r;
            int sw = GetSystemMetrics(SM_XVIRTUALSCREEN) + GetSystemMetrics(SM_CXVIRTUALSCREEN);
            int sh = GetSystemMetrics(SM_YVIRTUALSCREEN) + GetSystemMetrics(SM_CYVIRTUALSCREEN);
            int x,y;
            POINT p = {-1,-1};

            GetWindowRect(tooltip,&r);
            x = r.left;
            y = r.top;
            x += 5;
            y += 1;

            if ( x + w > sw )
               x -= x + w - sw;
            if ( y + h > sh )
               y -= y + h - sh;

            r.left = x;
            r.top = y;
            r.right = r.left + w;
            r.bottom = r.top + h;

            GetCursorPos(&p);
            if ( PtInRect(&r,p) )
               x -= r.right - p.x + 5;

            if ( ttdata.back_buff.hdc )
               {
                 HDC hdc = GetDC(NULL);
                 BitBlt(ttdata.back_buff.hdc,0,0,w,h,hdc,x,y,SRCCOPY);
                 ReleaseDC(NULL,hdc);
               }
            
            SetWindowPos(tooltip,NULL,x,y,w,h,SWP_NOACTIVATE | SWP_NOZORDER);
            return TRUE;
          }

       *b_processed = FALSE;
       return 0;
     }

  if ( code == TTN_POP )
     {
       FreeTooltipData();
       *b_processed = FALSE;
       return 0;
     }

  if ( code == NM_CUSTOMDRAW )
     {
       return DrawTooltip((NMTTCUSTOMDRAW*)hdr);
     }

  if ( code == TTN_GETDISPINFO )
     {
       NMTTDISPINFO* i = (NMTTDISPINFO*)hdr;

       i->lpszText = (IsAnyChildWindows() || !IsWeAreForeground()) ? NULL : "???";
       i->szText[0] = 0;
       i->hinst = NULL;

       return 0;
     }

  *b_processed = FALSE;
  return 0;
}

