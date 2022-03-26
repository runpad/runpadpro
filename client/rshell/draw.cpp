
#include "include.h"


#include "2d_themes.inc"
#include "draw_ubericon.inc"
#include "draw_rbuff.inc"
#include "draw_sysicon.inc"



int GetAniColor(int c1,int c2,int frame,int numframes)
{
  if ( numframes <= 1 )
     return c1;
  
  int r1,g1,b1,r2,g2,b2,r,g,b;

  r1 = GetRValue(c1);
  g1 = GetGValue(c1);
  b1 = GetBValue(c1);
  r2 = GetRValue(c2);
  g2 = GetGValue(c2);
  b2 = GetBValue(c2);
  
  r = r1+(r2-r1)*frame/(numframes-1);
  g = g1+(g2-g1)*frame/(numframes-1);
  b = b1+(b2-b1)*frame/(numframes-1);

  return RGB(r,g,b);
}



int GetFGColor(int bg)
{
  struct { unsigned char r,g,b,a; } c;
  
  *(int *)&c = bg;
  return (((9798*c.r+19235*c.g+3736*c.b)>>15) > 128) ? 0x000000 : 0xFFFFFF;
}


int Gamma(int color,float k)
{
  int r,g,b;

  r = GetRValue(color);
  g = GetGValue(color);
  b = GetBValue(color);

  r = f2i(r*k);
  g = f2i(g*k);
  b = f2i(b*k);

  if ( r > 255 )
     r = 255;
  if ( g > 255 )
     g = 255;
  if ( b > 255 )
     b = 255;

  return RGB(r,g,b);
}


void MakeThemeInternal(THEME *theme,int color)
{
  int n;
  int bg = color;
  int fg = GetFGColor(bg);

  theme->grad1 = Gamma(bg,1.1);
  theme->grad2 = Gamma(bg,0.35);
  theme->skin_color = Gamma(bg,1.1);
  theme->underline = RGB(0,0,0);
  theme->clock = fg;
  theme->title = RGB(0,0,0);
  theme->menutitle = RGB(255,255,255);
  theme->menu = Gamma(color,1.2); 
  theme->menu_admin = theme->menu;//RGB(245,245,240);
  theme->tooltip_back = bg;
  theme->tooltip_text = fg;
  theme->light = theme->grad1;
  theme->dark = RGB(0,0,0);
  theme->activetext = Gamma(bg,1.9);//1.3
  theme->inactivetext = RGB(0,0,0);
  theme->borderline = Gamma(bg,0.2);
}


void MakeTheme(int color)
{
  MakeThemeInternal(&theme,color);
}


//todo: optimize !!!!!!!!!
int MakeColorByBrightness(int base_color,int brightness)
{
  float r,g,b;
  float y,u,v,y_dest;
  int ir,ig,ib;

  r = (float)(GetRValue(base_color)) / 255.0;
  g = (float)(GetGValue(base_color)) / 255.0;
  b = (float)(GetBValue(base_color)) / 255.0;

  y = 0.299*r + 0.587*g + 0.114*b;
  u = (b-y)*0.565;
  v = (r-y)*0.713;

  brightness = f2i(brightness * Get2DTheme()->gamma + Get2DTheme()->brightness);
  if ( brightness < 0 )
     brightness = 0;
  if ( brightness > 255 )
     brightness = 255;

  y_dest = (float)(brightness) / 255.0;

  r = y_dest + 1.403*v;
  g = y_dest - 0.344*u - 0.714*v;
  b = y_dest + 1.770*u;

  ir = f2i(r*255);
  ig = f2i(g*255);
  ib = f2i(b*255);

  if ( ir < 0 )
     ir = 0;
  if ( ir > 255 )
     ir = 255;
  if ( ig < 0 )
     ig = 0;
  if ( ig > 255 )
     ig = 255;
  if ( ib < 0 )
     ib = 0;
  if ( ib > 255 )
     ib = 255;

  return RGB(ir,ig,ib);
}


const THEME2D* Get2DTheme(void)
{
  int count = sizeof(themes2d)/sizeof(themes2d[0]);
  int num = curr_theme2d;
  if ( num < 0 )
     num = 0;
  if ( num >= count )
     num = count-1;
  return &themes2d[num];
}


void Draw_Theme_Rect(HDC hdc,const RECT *r)
{
  int n,m,w,h,x1,y1,x2,y2;

  w = r->right - r->left;
  h = r->bottom - r->top;

  if ( h != Get2DTheme()->panel_height || w <= 0 )
     return;

  y1 = r->top;
  y2 = r->bottom;
  x1 = r->left;
  x2 = r->right;

  for ( n = y1; n < y2; n++ )
      {
        int color = MakeColorByBrightness(theme.skin_color,Get2DTheme()->panel[n-y1]);
        HPEN pen = CreatePen(PS_SOLID,0,color);
        HPEN oldpen = (HPEN)SelectObject(hdc,pen);
        MoveToEx(hdc,x1,n,NULL);
        LineTo(hdc,x2,n);
        SelectObject(hdc,oldpen);
        DeleteObject(pen);
      }
}


void Draw_Theme_Sheet(HDC hdc,const RECT *r,int state,const char *text,HICON icon,int bold,int highlited,BOOL show_pointer,BOOL centered,int fontsize)
{
  int x1,y1,x2,y2,w,h,n,m,icon_x,icon_w,align;
  int text_color,compact_width;
  char compacted_text[MAX_PATH];
  const unsigned char (*borderl)[MAXTHEMEHEIGHT];
  const unsigned char (*borderr)[MAXTHEMEHEIGHT];
  const unsigned char *center;
  RECT rr;
  HFONT font,oldfont;
  const THEME2D *i = Get2DTheme();
  SIZE size;

  x1 = r->left;
  y1 = r->top;
  x2 = r->right;
  y2 = r->bottom;
  w = x2-x1;
  h = y2-y1;

  if ( h != i->sheet_height || w < i->sheet_border*2 )
     return;

  if ( state < SHEET_ANI_FRAMES/2 )
     state = SHEET_UP;
  else
     state = SHEET_DOWN;

  if ( state == SHEET_DOWN )   
     {
       borderl = i->sheet_borderl_down;
       borderr = i->sheet_borderr_down;
       center = i->sheet_center_down;
     }
  else
     {
       borderl = highlited ? i->sheet_borderl_hl : i->sheet_borderl_up;
       borderr = highlited ? i->sheet_borderr_hl : i->sheet_borderr_up;
       center = highlited ? i->sheet_center_hl : i->sheet_center_up;
     }

  //text_color = GetAniColor(theme.inactivetext,theme.activetext,state,ANIFRAMES);
  text_color = i->is_light ? theme.inactivetext : theme.activetext;

  //draw entire with center bar
  for ( n = y1; n < y2; n++ )
      {
        int color = MakeColorByBrightness(theme.skin_color,center[n-y1]);
        HPEN pen = CreatePen(PS_SOLID,0,color);
        HPEN oldpen = (HPEN)SelectObject(hdc,pen);
        MoveToEx(hdc,x1,n,NULL);
        LineTo(hdc,x2,n);
        SelectObject(hdc,oldpen);
        DeleteObject(pen);
      }

  //borders
  for ( m = 0; m < i->sheet_border; m++ )
      {
        for ( n = y1; n < y2; n++ )
            {
              SetPixelV(hdc,x1+m,n,MakeColorByBrightness(theme.skin_color,borderl[m][n-y1]));
              SetPixelV(hdc,x2+m-i->sheet_border,n,MakeColorByBrightness(theme.skin_color,borderr[m][n-y1]));
            }
      }

  icon_x = i->inner_hpad;
  icon_w = 16;
  
  rr.left = x1+icon_x+(icon?icon_w+2:0);
  rr.top = y1+i->inner_vpad;
  rr.right = x2-i->inner_hpad;
  rr.bottom = y2-i->inner_vpad;
  if ( state >= SHEET_ANI_FRAMES/2 )
     {
       rr.left++;
       rr.right++;
       rr.top++;
       rr.bottom++;
     }
  if ( show_pointer )
     rr.right -= 8;
  font = CreateFont(-fontsize,0,0,0,bold?FW_BOLD:FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  oldfont = (HFONT)SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);
  SetTextColor(hdc,text_color);

  lstrcpyn(compacted_text,text,sizeof(compacted_text)-1);
  compact_width = rr.right-rr.left;
  compact_width = (compact_width < 0 ? 0 : compact_width);
  PathCompactPath(hdc,compacted_text,compact_width);

  if ( compacted_text[0] )
     {
       GetTextExtentPoint32(hdc,compacted_text,lstrlen(compacted_text),&size);
       if ( centered )
          align = (size.cx > rr.right-rr.left || lstrcmp(text,compacted_text)) ? DT_LEFT : DT_CENTER;
       else
          align = DT_LEFT;
      
       if ( !i->is_light )
          DrawTextWithShadow(hdc,compacted_text,&rr,align | DT_VCENTER | DT_SINGLELINE,0,1);
       else
          DrawText(hdc,compacted_text,-1,&rr,align | DT_VCENTER | DT_SINGLELINE);
     }

  SelectObject(hdc,oldfont);
  DeleteObject(font);

  if ( show_pointer )
     {
       int n,x,y,width;
       
       HPEN pen = CreatePen(PS_SOLID,0,text_color);
       HPEN oldpen = (HPEN)SelectObject(hdc,pen);

       x = rr.right+2;
       y = (rr.bottom + rr.top)/2 - 1;
       width = 7;
       
       for ( n = 0; n < 4; n++ )
           {
             MoveToEx(hdc,x,y,NULL);
             LineTo(hdc,x+width,y);

             x++;
             y++;
             width -= 2;
           }

       SelectObject(hdc,oldpen);
       DeleteObject(pen);
     }

  if ( icon )
     {
       x1 = x1+icon_x;
       y1 = (y2-y1+1-16)/2+y1;

       if ( state >= SHEET_ANI_FRAMES/2 )
          {
            x1++;
            y1++;
          }
       DrawIconEx(hdc,x1,y1,icon,16,16,0,NULL,DI_NORMAL);
     }
}


//todo: optimize!!!
void Draw_Theme_Bitmap(HDC hdc,const RECT *r,const unsigned char *buff)
{
  int w = r->right - r->left;
  int h = r->bottom - r->top;
  int n,m;

  for ( m = 0; m < h; m++ )
      {
        const unsigned char *src = buff + m*w;
        
        for ( n = 0; n < w; n++ )
            SetPixelV(hdc,r->left+n,r->top+m,MakeColorByBrightness(theme.skin_color,src[n]));
      }
}


void Draw_Window_Rect(HDC hdc,RECT *r,int left,int right,int top,int bottom,int _c1,int _c2)
{
  unsigned char c1[4];
  unsigned char c2[4];
  unsigned char c[4];
  int y1,y2,x1,x2,n,m,w,h;
  HPEN pen,oldpen;
  HDC hdc2=NULL;
  HBITMAP bitmap=NULL,oldb=NULL;
  unsigned char *bits = NULL;

  *(int *)c1 = _c1;
  *(int *)c2 = _c2;

  y1 = r->top;
  y2 = r->bottom;
  x1 = r->left;
  x2 = r->right;
  w = x2-x1;
  h = y2-y1;

  for ( n = y1; n < y2; n++ )
      {
        for ( m = 0; m < 3; m++ )
            c[m] = (n-y1)*((int)c2[m]-(int)c1[m])/(y2-y1-1)+c1[m];
        c[3] = 0;

        pen = CreatePen(PS_SOLID,0,*(int *)c);
        oldpen = (HPEN)SelectObject(hdc,pen);
        MoveToEx(hdc,x1,n,NULL);
        LineTo(hdc,x2,n);
        SelectObject(hdc,oldpen);
        DeleteObject(pen);
      }

  *(int *)c = theme.underline;
  c[3] = 0;
  pen = CreatePen(PS_SOLID,0,*(int *)c);
  oldpen = (HPEN)SelectObject(hdc,pen);

  if ( left )
     {
       MoveToEx(hdc,x1,y1,NULL);
       LineTo(hdc,x1,y2);
     }

  if ( right )
     {
       MoveToEx(hdc,x2-1,y1,NULL);
       LineTo(hdc,x2-1,y2);
     }

  if ( top )
     {
       MoveToEx(hdc,x1,y1,NULL);
       LineTo(hdc,x2,y1);
     }

  if ( bottom )
     {
       MoveToEx(hdc,x1,y2-1,NULL);
       LineTo(hdc,x2,y2-1);
     }

  SelectObject(hdc,oldpen);
  DeleteObject(pen);
}


typedef struct {
unsigned char r,g,b;
} RGB;


void MapRGB2BGR(void *src,void *dest,int w,int h)
{
  unsigned char *src24,*dest24,r,g,b;
  int n;

  if ( !w || !h )
     return;

  n = w*h;
  src24 = (unsigned char *)src;
  dest24 = (unsigned char *)dest;
  do {
   r = *src24++;
   g = *src24++;
   b = *src24++;
   *dest24++ = b;
   *dest24++ = g;
   *dest24++ = r;
  } while(--n);
}


Image* CreateImageFromHDC(HDC hdc,int w,int h)
{
  Bitmap *pBitmap = new Bitmap(w,h,PixelFormat24bppRGB);

  Graphics *pGraphics = new Graphics(pBitmap);
  pGraphics->Clear(Color());
  HDC hdc_dest = pGraphics->GetHDC();
  BitBlt(hdc_dest,0,0,w,h,hdc,0,0,SRCCOPY);
  pGraphics->ReleaseHDC(hdc_dest);
  pGraphics->Flush(FlushIntentionSync);
  delete pGraphics;

  return pBitmap;
}


IStream* SaveScreenToStream()
{
  IStream *stream = NULL;
  
  HDC hdc = GetDC(NULL);
  Image *img = CreateImageFromHDC(hdc,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
  ReleaseDC(NULL,hdc);
  
  if ( img )
     {
       stream = SaveImageToStream(img,L"image/jpeg");
       delete img;
     }

  return stream;
}


void RB_Create(RBUFF *i)
{
  RB_CreateNormal(i,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
}


void RB_CreateNormal(RBUFF *i,int w,int h)
{
  BITMAPINFO bi;

  i->grayscale = 0;
  i->w = w;
  i->h = h;
  i->bits = NULL;
  
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = i->w;
  bi.bmiHeader.biHeight = -i->h;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 32;
  i->bitmap = CreateDIBSection(NULL,&bi,DIB_RGB_COLORS,(void**)&i->bits,NULL,0);

  i->hdc = CreateCompatibleDC(NULL);
  i->old_bitmap = (HBITMAP)SelectObject(i->hdc,i->bitmap);
}


void RB_CreateGrayscale(RBUFF *i,int w,int h)
{
  int n;
  
  struct {
   BITMAPINFOHEADER bmiHeader;
   BGRA pal[256];
  } bi;

  i->grayscale = 1;
  i->w = w;
  i->h = h;
  i->bits = NULL;
  
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = i->w;
  bi.bmiHeader.biHeight = -i->h;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 8;

  for ( n = 0; n < 256; n++ )
      {
        bi.pal[n].b = n;
        bi.pal[n].g = n;
        bi.pal[n].r = n;
        bi.pal[n].a = 0;
      }
  
  i->bitmap = CreateDIBSection(NULL,(BITMAPINFO*)&bi,DIB_RGB_COLORS,(void**)&i->bits,NULL,0);
  i->hdc = CreateCompatibleDC(NULL);
  i->old_bitmap = (HBITMAP)SelectObject(i->hdc,i->bitmap);
}


void RB_Destroy(RBUFF *i)
{
  if ( i )
     {
       if ( i->hdc )
          SelectObject(i->hdc,i->old_bitmap);
       if ( i->hdc )
          DeleteDC(i->hdc);
       if ( i->bitmap )
          DeleteObject(i->bitmap);
       i->hdc = NULL;
       i->bitmap = NULL;
       i->bits = NULL;
       i->w = 0;
       i->h = 0;
     }
}


void RB_Smooth(RBUFF *i,int value)
{
  int k,n,m,w,h,aw,in,out,c;
  unsigned char *buffs[2],*src,*dest;

  if ( !i || !i->grayscale || !i->bits )
     return;

  w = i->w;
  h = i->h;
  aw = w;
  if ( aw & 3 )
     aw += 4 - (aw&3);

  buffs[0] = (unsigned char*)i->bits;
  buffs[1] = (unsigned char*)sys_alloc(aw*h);
  CopyMemory(buffs[1],buffs[0],aw*h);

  in = 0;
  out = 1;

  for ( k = 0; k < value; k++ )
      {
        for ( m = 1; m < h-1; m++ )
            {
              src = buffs[in]+m*aw+1;
              dest = buffs[out]+m*aw+1;

              for ( n = 1; n < w-1; n++ )
                  {
                    c = 0;
                    c += *(src-aw-1) * 3;
                    c += *(src-aw) * 4;
                    c += *(src-aw+1) * 3;
                    c += *(src-1) * 4;
                    c += *(src) * 4;
                    c += *(src+1) * 4;
                    c += *(src+aw-1) * 3;
                    c += *(src+aw) * 4;
                    c += *(src+aw+1) * 3;
                    c >>= 5;
                    
                    *dest++ = c;
                    src++;
                  }
            }

        in = (~in)&1;
        out = (~out)&1;
      }

  if ( out == 0 )
     CopyMemory(buffs[0],buffs[1],aw*h);

  sys_free(buffs[1]);
}


BOOL CanUseMMX()
{
  int use_mmx = 0;
  
  __asm {
	pushad
	mov	eax,1
	cpuid
	shr	edx,23
	and	edx,1
	mov	use_mmx,edx
	popad
  }

  return use_mmx != 0;
}


void RB_DrawShadow(RBUFF *s,RBUFF *d,int x,int y,int allow_mmx)
{
  BOOL use_mmx;
  int asw,sw,sh,dw,dh,n,m,xcount,ycount,xoffs,yoffs;
  unsigned char *src;
  unsigned char *dest;
  RECT clip;

  if ( !s || !s->bits || !d || !d->bits )
     return;

  if ( !allow_mmx )
     use_mmx = FALSE;
  else
     use_mmx = CanUseMMX();

  sw = s->w;
  sh = s->h;
  asw = sw;
  if ( asw&3 )
     asw += 4 - (asw&3);

  dw = d->w;
  dh = d->h;

  SetRectEmpty(&clip);
  if ( GetClipBox(d->hdc,&clip) == ERROR || IsRectEmpty(&clip) )
     SetRect(&clip,0,0,dw,dh);
  if ( clip.left < 0 )
     clip.left = 0;
  if ( clip.top < 0 )
     clip.top = 0;
  if ( clip.right > dw )
     clip.right = dw;
  if ( clip.bottom > dh )
     clip.bottom = dh;

  if ( clip.left >= clip.right || clip.top >= clip.bottom )
     return;

  if ( x >= clip.right || y >= clip.bottom || x+sw <= clip.left || y+sh <= clip.top )
     return;
  
  xcount = sw;
  ycount = sh;
  xoffs = 0;
  yoffs = 0;

  if ( x+xcount > clip.right )
     xcount = clip.right-x;
  if ( y+ycount > clip.bottom )
     ycount = clip.bottom-y;
  if ( x < clip.left )
     {
       xoffs = clip.left-x;
       xcount -= xoffs;
       x = clip.left;
     }
  if ( y < clip.top )
     {
       yoffs = clip.top-y;
       ycount -= yoffs;
       y = clip.top;
     }

  if ( xcount <= 0 || ycount <= 0 )  //paranoja
     return;

  for ( m = 0; m < ycount; m++ )
      {
        src = (unsigned char*)s->bits + (m+yoffs)*asw + xoffs;
        dest = (unsigned char*)d->bits + ((y+m)*dw+x)*4;
        
        if ( !use_mmx )
           {
             for ( n = 0; n < xcount; n++ )
                 {
                   int t,k;
                   int shadow = *src++;
                   if ( shadow )
                      {
                        for ( k = 0; k < 3; k++ )
                            {
                              t = dest[k];
                              t -= shadow;
                              if ( t < 0 )
                                 t = 0;
                              dest[k] = t;
                            }
                      }
                   dest += 4;
                 }
           }
        else
           {
             if ( (xcount/2) <= 0 )
                break;
             
             __asm {
			pushad
			mov	ecx,xcount
			shr	ecx,1
			mov	esi,src
			mov	edi,dest
		L1:
		        xor	eax,eax
			mov	al,[esi]
			inc	esi
			mov	ah,[esi]
			inc	esi
			or	eax,eax
			je	L2
			mov	bl,ah
			mov	ah,al
			shl	eax,8
			mov	al,ah
			shl	eax,8
			mov	al,ah
			mov	bh,bl
			shl	ebx,8
			mov	bl,bh
			shl	ebx,8
			mov	bl,bh
			movd	mm0,eax
			movd	mm1,ebx
			punpckldq mm0,mm1
			movq	mm1,[edi]
			psubusb mm1,mm0
			movq	[edi],mm1
		L2:
			add	edi,8
			dec	ecx
			jne	L1
			popad
			emms
             }
           }
      }
}


void RB_PaintTo(RBUFF *i,HDC dest)
{
  BitBlt(dest,0,0,i->w,i->h,i->hdc,0,0,SRCCOPY);
}


void RB_PaintFrom(HDC src,RBUFF *i)
{
  BitBlt(i->hdc,0,0,i->w,i->h,src,0,0,SRCCOPY);
}


void RB_Fill(RBUFF *i,int color)
{
  RECT lr = {0,0,i->w,i->h};
  HBRUSH brush = CreateSolidBrush(color);
  FillRect(i->hdc,&lr,brush);
  DeleteObject(brush);
}


void RB_Frame(RBUFF *i,int color)
{
  RECT lr = {0,0,i->w,i->h};
  HBRUSH brush = CreateSolidBrush(color);
  FrameRect(i->hdc,&lr,brush);
  DeleteObject(brush);
}


void RB_PaintToWindow(RBUFF *i,HWND hwnd)
{
  HDC hdc;

  hdc = GetDC(hwnd);
  RB_PaintTo(i,hdc);
  ReleaseDC(hwnd,hdc);
}


static int SwapBGRA(int c)
{
  int r = GetRValue(c);
  int g = GetGValue(c);
  int b = GetBValue(c);
  int a = c & 0xFF000000;

  return RGB(b,g,r) | a;
}


void RB_HGradient32(RBUFF *buff,int c1,int c2)
{
  if ( buff && buff->bits )
     {
       if ( buff->w == 1 )
          {
            RB_Fill(buff,c1);
          }
       else
          {
            // swap RGB in colors
            c1 = SwapBGRA(c1);
            c2 = SwapBGRA(c2);
            
            // fill scan0
            int *pat = (int*)buff->bits;
            for ( int i = 0; i < buff->w; i++ )
                {
                  pat[i] = GetAniColor(c1,c2,i,buff->w) | 0xFF000000;  //assume alpha is 1.0
                }

            // copy other lines
            for ( int j = 1; j < buff->h; j++ )
                {
                  CopyMemory((int*)buff->bits+j*buff->w,pat,buff->w*4);
                }
          }
     }
}


void DrawTextWithShadowW(HDC hdc,const WCHAR *s,RECT *r,int flags,int offset,int smooth)
{
  int text_color = GetTextColor(hdc);
  int shadow_color = 0xFFFFFF;
  int back_color = 0x000000;
  int w = r->right - r->left;
  int h = r->bottom - r->top;
  RBUFF gray,buff;
  RECT gr;
  HBRUSH brush;
  HFONT oldfont,font;

  if ( w <= 0 || h <= 0 )
     return;

  font = (HFONT)GetCurrentObject(hdc,OBJ_FONT);

  RB_CreateGrayscale(&gray,w,h);

  gr.left = 0;
  gr.top = 0;
  gr.right = w;
  gr.bottom = h;
  
  brush = CreateSolidBrush(back_color);
  FillRect(gray.hdc,&gr,brush);
  DeleteObject(brush);

  oldfont = (HFONT)SelectObject(gray.hdc,font);
  SetBkMode(gray.hdc,TRANSPARENT);
  SetTextColor(gray.hdc,shadow_color);

  gr.left += offset;
  gr.top += offset;
  
  DrawTextW(gray.hdc,s,-1,&gr,flags);
  SelectObject(gray.hdc,oldfont);

  RB_Smooth(&gray,smooth);

  RB_CreateNormal(&buff,w,h);
  BitBlt(buff.hdc,0,0,w,h,hdc,r->left,r->top,SRCCOPY);
  RB_DrawShadow(&gray,&buff,0,0,0);

  gr.left = 0;
  gr.top = 0;
  gr.right = w;
  gr.bottom = h;

  oldfont = (HFONT)SelectObject(buff.hdc,font);
  SetBkMode(buff.hdc,TRANSPARENT);
  SetTextColor(buff.hdc,text_color);
  DrawTextW(buff.hdc,s,-1,&gr,flags);
  SelectObject(buff.hdc,oldfont);

  BitBlt(hdc,r->left,r->top,w,h,buff.hdc,0,0,SRCCOPY);

  RB_Destroy(&buff);
  RB_Destroy(&gray);
}


void DrawTextWithShadow(HDC hdc,const char *s,RECT *r,int flags,int offset,int smooth)
{
  DrawTextWithShadowW(hdc,CUnicode(s),r,flags,offset,smooth);
}


void GetHDCDim(HDC hdc,int *w,int *h)
{
  HBITMAP bitmap;

  *w = 0;
  *h = 0;
  
  bitmap = (HBITMAP)GetCurrentObject(hdc,OBJ_BITMAP);
  if ( bitmap )
     {
       int tw,th;
       BITMAP binfo;

       ZeroMemory(&binfo,sizeof(binfo));
     
       GetObject(bitmap,sizeof(binfo),&binfo);

       tw = binfo.bmWidth;
       th = binfo.bmHeight;

       if ( th < 0 )
          th = -th;

       *w = tw;
       *h = th;
     }
}


void GetBitmapDim(HBITMAP bitmap,int *w,int *h)
{
  BITMAP binfo;

  ZeroMemory(&binfo,sizeof(binfo));
  
  GetObject(bitmap,sizeof(binfo),&binfo);
  int iw = binfo.bmWidth;
  int ih = binfo.bmHeight;
  if ( ih < 0 )
     ih = -ih;

  *w = iw;
  *h = ih;
}


static void MMXAlphaBlendRow(unsigned char *dest,
                             const unsigned char *p1,
                             const unsigned char *p2,
                             int count,
                             int step,
                             int numsteps)
{
  unsigned short k[4];

  k[0] = k[1] = k[2] = k[3] = step * 128 / numsteps;

  __asm {
          pushad
          mov edi,dest
          mov esi,p2
          mov ebx,p1
          mov ecx,count
          pxor mm7,mm7         // mm7 = 0 0 0 0
          movq mm6,k           // mm6 = k k k k   (k = 0..128)
        _L1:
          movd mm0,[esi]
          punpcklbw mm0,mm7    // mm0 = A1 R1 G1 B1
          movd mm1,[ebx]
          punpcklbw mm1,mm7    // mm1 = A2 R2 G2 B2
          psubw mm0,mm1        // mm0 = A1-A2 R1-R2 G1-G2 B1-B2
          pmullw mm0,mm6
          psraw mm0,7          // mm0 = k*(A1-A2) k*(R1-R2) k*(G1-G2) k*(B1-B2)  (-255..+255)
          paddw mm0,mm1        // mm0 = A R G B   (0..255)
          packuswb mm0,mm7
          movd [edi],mm0
          add esi,4
          add ebx,4
          add edi,4
          dec ecx
          jne _L1
          popad
          emms
  }
}


static void RB_EffectBlend(RBUFF *bsrc,RBUFF *bdest,HWND hwnd,void(*cb)(int perc,void *parm),void *cb_parm)
{
  int w = bsrc->w;
  int h = bsrc->h;

  RBUFF temp;
  RB_CreateNormal(&temp,w,h);

  BOOL use_mmx = CanUseMMX();

  unsigned starttime = GetTickCount();
  unsigned endtime = starttime + 180;

  while ( 1 )
  {
    const int steps = 100; //percent
    int k = (GetTickCount() - starttime) * steps / (endtime - starttime);

    if ( k > steps )
       k = steps;
    
    unsigned char u_table[256];
    unsigned char v_table[256];

    if ( !use_mmx )
       {
         for ( int n = 0; n < 256; n++ )
             {
               u_table[n] = k * n / steps;
               v_table[n] = (steps-k) * n / steps;
             }
       }
    
    for ( int m = 0; m < h; m++ )
        {
          const unsigned char *p1 = (const unsigned char *)((BGRA*)bsrc->bits+m*w);
          const unsigned char *p2 = (const unsigned char *)((BGRA*)bdest->bits+m*w);
          unsigned char *dest = (unsigned char *)((BGRA*)temp.bits+m*w);

          if ( !use_mmx )
             {
               int count = w;
               do {
                *dest++ = v_table[*p1++] + u_table[*p2++];
                *dest++ = v_table[*p1++] + u_table[*p2++];
                *dest++ = v_table[*p1++] + u_table[*p2++];
                p1++;
                p2++;
                dest++;
               } while (--count);
             }
          else
             {
               MMXAlphaBlendRow(dest,p1,p2,w,k,steps);
             }
        }

    RB_PaintToWindow(&temp,hwnd);
    if ( cb ) cb(k*100/steps,cb_parm);
    Sleep(5);

    if ( k >= steps )
       break;
  }

  RB_Destroy(&temp);
}


void RB_Animate(RBUFF *bsrc,RBUFF *bdest,HWND hwnd,void(*cb)(int perc,void *parm),void *cb_parm)
{
  if ( bsrc && bsrc->bits && 
       bdest && bdest->bits && 
       bsrc->w == bdest->w && 
       bsrc->h == bdest->h && 
       bsrc->w > 0 && bsrc->h > 0 &&
       hwnd )
     {
       RB_EffectBlend(bsrc,bdest,hwnd,cb,cb_parm);
     }
}


void* GetIconRawBitmap24(HICON icon,int w,int h,int bgcolor)
{
  RBUFF i;
  RECT gr;
  HBRUSH brush;
  int n;
  unsigned char *src,*dest;
  void *buff;

  RB_CreateNormal(&i,w,h);

  gr.left = 0;
  gr.top = 0;
  gr.right = w;
  gr.bottom = h;
  brush = CreateSolidBrush(bgcolor);
  FillRect(i.hdc,&gr,brush);
  DeleteObject(brush);

  DrawIconEx(i.hdc,0,0,icon,w,h,0,NULL,DI_NORMAL);

  buff = sys_alloc(w*h*3);
  dest = (unsigned char *)buff;
  src = (unsigned char *)i.bits;

  for ( n = 0; n < w*h; n++ )
      {
        *dest++ = *src++;
        *dest++ = *src++;
        *dest++ = *src++;
        src++;
      }

  RB_Destroy(&i);

  return buff;
}


typedef struct {
LONG bmWidth;
LONG bmHeight;
LONG bmWidthBytes;
WORD bmPlanes;
WORD bmBitsPixel;
} MYBITMAP;


static void* GetRawBitmap(HBITMAP bitmap,int force32,int *out_size)
{
  BITMAP bi;

  *out_size = 0;

  if ( GetObject(bitmap,sizeof(bi),&bi) )
     {
       if ( !force32 )
          {
            int size = bi.bmWidthBytes*bi.bmHeight;
            char *buff = (char*)sys_alloc(sizeof(MYBITMAP)+size);

            MYBITMAP *header = (MYBITMAP*)buff;
            header->bmWidth = bi.bmWidth;
            header->bmHeight = bi.bmHeight;
            header->bmWidthBytes = bi.bmWidthBytes;
            header->bmPlanes = bi.bmPlanes;
            header->bmBitsPixel = bi.bmBitsPixel;
            
            GetBitmapBits(bitmap,size,buff+sizeof(MYBITMAP));

            *out_size = sizeof(MYBITMAP)+size;
            return buff;
          }
       else
          {
            HDC hdc;
            char *buff;
            int size;
            BITMAPINFO dib;
            MYBITMAP *header;

            bi.bmWidthBytes = bi.bmWidth*4;
            bi.bmBitsPixel = 32;

            ZeroMemory(&dib,sizeof(dib));
            dib.bmiHeader.biSize = sizeof(dib.bmiHeader);
            dib.bmiHeader.biWidth = bi.bmWidth;
            dib.bmiHeader.biHeight = -bi.bmHeight;
            dib.bmiHeader.biPlanes = bi.bmPlanes;
            dib.bmiHeader.biBitCount = bi.bmBitsPixel;

            size = bi.bmWidthBytes*bi.bmHeight;
            buff = (char*)sys_alloc(sizeof(MYBITMAP)+size);
            
            header = (MYBITMAP*)buff;
            header->bmWidth = bi.bmWidth;
            header->bmHeight = bi.bmHeight;
            header->bmWidthBytes = bi.bmWidthBytes;
            header->bmPlanes = bi.bmPlanes;
            header->bmBitsPixel = bi.bmBitsPixel;

            hdc = GetDC(NULL);
            GetDIBits(hdc,bitmap,0,bi.bmHeight,buff+sizeof(MYBITMAP),&dib,DIB_RGB_COLORS);
            ReleaseDC(NULL,hdc);

            *out_size = sizeof(MYBITMAP)+size;
            return buff;
          }
     }

  return NULL;
}



void *GetIconRaw(HICON icon,int *out_size)
{
  ICONINFO i;
  char *buff = NULL;

  *out_size = 0;

  if ( GetIconInfo(icon,&i) )
     {
       int color_size,mask_size;

       void *color = GetRawBitmap(i.hbmColor,TRUE,&color_size);
       void *mask = GetRawBitmap(i.hbmMask,FALSE,&mask_size);

       if ( color && mask )
          {
            buff = (char*)sys_alloc(color_size+mask_size);
            CopyMemory(buff,color,color_size);
            CopyMemory(buff+color_size,mask,mask_size);
            *out_size = color_size+mask_size;
          }

       if ( color )
          sys_free(color);
       if ( mask )
          sys_free(mask);
       
       DeleteObject(i.hbmColor);
       DeleteObject(i.hbmMask);
     }

  return buff;
}


void AdjustGammaBGRStride(void *buff,int w,int h,int stride,float desired_gamma)
{
  if ( !buff || !w || !h || !stride || desired_gamma < 0.10 || desired_gamma > 0.90 )
     return;
  
  //calculate average gamma
  float average_gamma;
  {   
    double gamma = 0.0;

    for ( int j = 0; j < h; j++ )
    {
      const unsigned char *p = (const unsigned char *)buff+j*stride;
    
      int count = w;
      
      while ( count-- )
      {
        float b = *p++;
        float g = *p++;
        float r = *p++;
        
        b /= 255.0;
        g /= 255.0;
        r /= 255.0;

        float y = 0.299 * r + 0.587 * g + 0.114 * b;

        gamma += y;
      }
    }

    gamma /= (double)(w*h);
    average_gamma = gamma;
  }

  if ( average_gamma < 0.10 || average_gamma > 0.90 )
     return;

  float k = desired_gamma / average_gamma;

  //adjust gamma
  {
    for ( int j = 0; j < h; j++ )
    {
      unsigned char *p = (unsigned char *)buff+j*stride;
    
      int count = w;
      
      while ( count-- )
      {
        float y,u,v;
        int ir,ig,ib;

        float b = p[0];
        float g = p[1];
        float r = p[2];
        
        r /= 255.0;
        g /= 255.0;
        b /= 255.0;

        y = 0.299 * r + 0.587 * g + 0.114 * b;
        u = 0.492 * ( b - y );
        v = 0.877 * ( r - y );

        y *= k;

        r = y + 1.140 * v;
        g = y - 0.395 * u - 0.581 * v;
        b = y + 2.032 * u;

        ir = f2i(r * 255.0);
        ig = f2i(g * 255.0);
        ib = f2i(b * 255.0);

        if ( ir < 0 )
           ir = 0;
        if ( ir > 255 )
           ir = 255;
        if ( ig < 0 )
           ig = 0;
        if ( ig > 255 )
           ig = 255;
        if ( ib < 0 )
           ib = 0;
        if ( ib > 255 )
           ib = 255;

        p[0] = ib;
        p[1] = ig;
        p[2] = ir;

        p += 3;
      }
    }
  }
}



void DrawIconHLInternal(HDC hdc,RECT *r,int perc)
{
  HBRUSH brush;
  RBUFF buff;
  RECT lr;
  int w,h,alpha,alpha1,alpha2;

  w = r->right - r->left;
  h = r->bottom - r->top;

  if ( w > 0 && h > 0 )
     {
       lr.left = 0;
       lr.top = 0;
       lr.right = w;
       lr.bottom = h;

       RB_CreateNormal(&buff,w,h);

       brush = CreateSolidBrush(theme.grad1);
       FillRect(buff.hdc,&lr,brush);
       DeleteObject(brush);

       brush = CreateSolidBrush(theme.grad2);
       FrameRect(buff.hdc,&lr,brush);
       DeleteObject(brush);

       alpha1 = 255;
       alpha2 = 200;
       alpha = (alpha2 - alpha1) * perc / 100 + alpha1;
       MakeTransparent(hdc,buff.hdc,r->left,r->top,0,0,w,h,alpha);

       RB_Destroy(&buff);
     }
}



void MakeTransparent(HDC dest,HDC src,int x_dest,int y_dest,int x_src,int y_src,int w,int h,int alpha)
{
  BLENDFUNCTION blend;
  
  if ( !dest || !src || alpha == 255 )
     return;

  blend.BlendOp = AC_SRC_OVER;
  blend.BlendFlags = 0;
  blend.SourceConstantAlpha = 255-alpha;
  blend.AlphaFormat = 0;
  
  AlphaBlend(dest,x_dest,y_dest,w,h,src,x_src,y_src,w,h,blend);
}


void EliminateInvalidRect(RECT *r)
{
  if ( r )
     {
       if ( r->right < r->left || r->bottom < r->top )
          {
            SetRectEmpty(r);
          }
     }
}


