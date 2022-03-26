

static LRESULT CALLBACK UberZoomWndProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_CLOSE:
                   return 0;

    case WM_KEYUP:
    case WM_KEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSKEYDOWN:
                   return 0;
  }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


static void UberZoomInternalNoCheck(HICON icon,const RECT *r,int trail)
{
  Bitmap *pBitmap = new Bitmap(icon);
  
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = CS_HREDRAW | CS_VREDRAW;
  wc.lpfnWndProc = UberZoomWndProc;
  wc.hInstance = our_instance;
  wc.lpszClassName = "E_UberZoomWnd";
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_LAYERED | WS_EX_TRANSPARENT | WS_EX_TOOLWINDOW, wc.lpszClassName, NULL, WS_POPUP | WS_CLIPSIBLINGS, 0, 0, 0, 0, NULL, NULL, our_instance, NULL);
  ShowWindow(hwnd,SW_SHOWNA);

  int minw = r->right - r->left;
  int minh = r->bottom - r->top;
  int maxw = 280;
  int maxh = 280;
  if ( maxw < minw+50 )
     maxw = minw+50;
  if ( maxh < minh+50 )
     maxh = minh+50;

  BITMAPINFO bi;
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = maxw;
  bi.bmiHeader.biHeight = maxh;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 32;
  HBITMAP hbitmap = CreateDIBSection(NULL,&bi,DIB_RGB_COLORS,NULL,NULL,0);

  HDC hdc = CreateCompatibleDC(NULL);
  HBITMAP old_bitmap = (HBITMAP)SelectObject(hdc,hbitmap);

  Graphics *pGraphics = new Graphics(hdc);
  pGraphics->SetCompositingQuality(CompositingQualityHighSpeed);
  pGraphics->SetInterpolationMode(InterpolationModeBilinear);

  unsigned starttime = GetTickCount();
  unsigned endtime = starttime + 200;

  do {

   float k = (float)(GetTickCount()-starttime)/(endtime-starttime);

   if ( k > 1.0 )
      break;
   
   float maxalpha = 0.60;
   float alpha = maxalpha * (1-k);

   int ialpha = (int)(alpha*255);
   if ( ialpha <= 0 )
      break; //paranoja
   if ( ialpha > 254 )
      ialpha = 254; //!

   int currw = k*(maxw-minw)+minw;
   if ( currw < minw )
      currw = minw;
   if ( currw > maxw )
      currw = maxw;

   int currh = k*(maxh-minh)+minh;
   if ( currh < minh )
      currh = minh;
   if ( currh > maxh )
      currh = maxh;

   for ( int n = 0; n < trail; n++ )
       {
         int w = n * (minw - currw) / trail + currw;
         int h = n * (minh - currh) / trail + currh;
         int x = (maxw - w) / 2;
         int y = (maxh - h) / 2;

         pGraphics->SetCompositingMode(n==0?CompositingModeSourceCopy:CompositingModeSourceOver);
         pGraphics->DrawImage(pBitmap,x,y,w,h);
       }

   pGraphics->Flush(FlushIntentionSync);

   BLENDFUNCTION blend;
   blend.BlendOp = AC_SRC_OVER;
   blend.BlendFlags = 0;
   blend.SourceConstantAlpha = ialpha;
   blend.AlphaFormat = AC_SRC_ALPHA;

   int midx = (r->left + r->right) / 2;
   int midy = (r->top + r->bottom) / 2;
   POINT xy = { midx-currw/2, midy-currh/2 };
   SIZE wh = { currw, currh };
   POINT orig = { (maxw-currw)/2, (maxh-currh)/2 };
   
   UpdateLayeredWindow(hwnd,NULL,&xy,&wh,hdc,&orig,RGB(0,0,0),&blend,ULW_ALPHA);

   Sleep(1);

  } while ( 1 );

  delete pGraphics;

  SelectObject(hdc,old_bitmap);
  DeleteDC(hdc);
  DeleteObject(hbitmap);

  ShowWindow(hwnd,SW_HIDE);
  DestroyWindow(hwnd);
  UnregisterClass(wc.lpszClassName,our_instance);

  delete pBitmap;
}


typedef struct {
HICON icon;
RECT r;
int trail;
} UBERZOOM;


static DWORD WINAPI UberZoomThread(void *parm)
{
  UBERZOOM *uz = (UBERZOOM*)parm;
  if ( uz )
     {
       HICON icon = uz->icon;
       const RECT *r = &uz->r;
       int trail = uz->trail;

       if ( icon && r && !IsRectEmpty(r) )
          {
            UberZoomInternalNoCheck(icon,r,trail);
          }

       if ( icon )
          DestroyIcon(icon);
     
       sys_free(uz);
     }

  return 1;
}


static void UberZoomInternal(HICON icon,const RECT *r,int trail)
{
  SYSTEM_INFO si;
  GetSystemInfo(&si);

  if ( si.dwNumberOfProcessors > 1 )
     {
       UBERZOOM *i = (UBERZOOM*)sys_alloc(sizeof(UBERZOOM));

       i->icon = CopyIcon(icon);
       i->r = *r;
       i->trail = trail;

       HANDLE hthread = MyCreateThreadDontCare(UberZoomThread,i);
       CloseHandle(hthread);
     }
  else
     {
       UberZoomInternalNoCheck(icon,r,trail);
     }
}


static void E_None(HICON icon,const RECT *r)
{
}

static void E_UberZoom1(HICON icon,const RECT *r)
{
  UberZoomInternal(icon,r,5);
}

static void E_UberZoom2(HICON icon,const RECT *r)
{
  UberZoomInternal(icon,r,1);
}


static const struct {
void (*func)(HICON,const RECT*);
} effects[] = 
{
  E_None,
  E_UberZoom1,
  E_UberZoom2,
};


void DoUberIconEffectInternal(int effect_num,HICON icon,const RECT *r)
{
  if ( icon && r && !IsRectEmpty(r) )
     {
       if ( effect_num >= 0 && effect_num < sizeof(effects)/sizeof(effects[0]) )
          {
            effects[effect_num].func(icon,r);
          }
     }
}

