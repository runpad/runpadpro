
#include <windows.h>
#include <commdlg.h>
#include "2d_lib.h"
#include "utils.h"
#include "lang.h"
#include "fp.h"
#include "../rp_shared/rp_shared.h"


static PRINTDLG p;

static int PrintBegin(HWND hwnd)
{
  DOCINFO di;
  HDC hdc = p.hDC;

  ZeroMemory(&di,sizeof(di));
  di.cbSize = sizeof(di);
  di.lpszDocName = "Image";
  if ( StartDoc(hdc,&di) <= 0 )
     {
       MessageBox(hwnd,S_PRINT_ERROR,NULL,MB_OK);
       return -1;
     }

  if ( StartPage(hdc) <= 0 )
     {
       EndDoc(hdc);
       MessageBox(hwnd,S_PRINT_ERROR,NULL,MB_OK);
       return -1;
     }

  return 0;
}



static void PrintEnd(HWND hwnd)
{
  HDC hdc = p.hDC;

  EndPage(hdc);
  EndDoc(hdc);
}


static int width,height,xdpi,ydpi;
static int left,top,right,bottom;


void PrintPic(HWND hwnd,void *buff,int w,int h)
{
  BITMAPINFO bmi;
  HDC hdc = p.hDC;
  unsigned char *obuf;
  int ow, oh;
  int w4b; // size of row (width) in bytes, aligned to 4 byte
  int i,j;
  float wscale, hscale;

  if ( (w > h) != (width > height) )
     {
       // Rotate image
       ow = h;
       oh = w;

       w4b = ow*3;
       if ( w4b % 4 )
          w4b += 4 - (w4b % 4);

       obuf = sys_alloc(w4b*oh);
       
       if ( !obuf )
          {
            MessageBox(hwnd,S_INSUFFICIENT_MEMORY,S_PRINT_ERROR,MB_OK);
            return;
          }
       
       for (j = 0; j<h; j++)
           {
             unsigned char *scanline = (unsigned char*)buff + (h-j-1)*w*3;
             for (i = 0; i<w; i++)
                 {
                   sys_memcpy(obuf + w4b*i + j*3, scanline, 3);
                   scanline += 3;
                 }
           }
     }
  else
     {
       ow = w;
       oh = h;

       w4b = ow*3;
       if ( w4b % 4 )
          w4b += 4 - (w4b % 4);

       obuf = sys_alloc(w4b*oh);
       
       if ( !obuf )
          {
            MessageBox(hwnd,S_INSUFFICIENT_MEMORY,S_PRINT_ERROR,MB_OK);
            return;
          }
       
       for (j = 0; j<h; j++)
           {
             unsigned char *scanline = (unsigned char*)buff + j*w*3;
             unsigned char *dst = obuf + j*w4b;
             sys_memcpy(dst, scanline, w*3);
             if (w*3 < w4b)
                {
                  ZeroMemory(dst+w*3, w4b-w*3);
                }
           }
     }

  wscale = (float)width/ow;
  hscale = (float)height/oh;
  
  if (wscale > hscale)
     {
       int old_width = width;
       width = ow*hscale;
       left += (old_width - width)>>1;
     }
  else
     {
       int old_height = height;
       height = oh*wscale;
       top += (old_height - height)>>1;
     }

  ZeroMemory(&bmi,sizeof(bmi));
  bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth = ow;
  bmi.bmiHeader.biHeight = -oh;
  bmi.bmiHeader.biPlanes = 1;
  bmi.bmiHeader.biBitCount = 24;
  bmi.bmiHeader.biCompression = BI_RGB;

  if ( StretchDIBits(hdc,left,top,width,height,0,0,ow,oh,obuf,&bmi,DIB_RGB_COLORS,SRCCOPY) != oh )
     MessageBox(hwnd,S_PRINT_ERROR,NULL,MB_OK);

  sys_free(obuf);
}

void Print(HWND hwnd,void *buff,int w,int h)
{
  HDC hdc;
  p.lStructSize = sizeof(p);
  p.hwndOwner = NULL;//hwnd;
  p.hDevMode = NULL;
  p.hDevNames = NULL; 
  p.Flags = PD_RETURNDEFAULT | PD_RETURNDC ;

  if ( PrintDlg(&p) )
     {
       if (!PrintBegin(hwnd))
          {
            int margin_left = 15;
            int margin_right = 15;
            int margin_top = 15;
            int margin_bottom = 15;
            hdc = p.hDC;
            width = GetDeviceCaps(hdc,HORZRES);
            height = GetDeviceCaps(hdc,VERTRES);
            xdpi = GetDeviceCaps(hdc,LOGPIXELSX);
            ydpi = GetDeviceCaps(hdc,LOGPIXELSY);
            left = margin_left*xdpi*10/254;
            right = margin_right*xdpi*10/254;
            top = margin_top*ydpi*10/254;
            bottom = margin_bottom*ydpi*10/254;
            width -= left+right;
            height -= top+bottom;
            
            if ( width > 0  &&  height > 0 )
               PrintPic(hwnd, buff, w, h);
          }
       PrintEnd(hwnd);
     }
  else
     {
       MessageBox(hwnd,S_PRINT_RESTRICT,NULL,MB_OK);
     }

  if (p.hDevMode) 
     GlobalFree(p.hDevMode);
  if (p.hDevNames) 
     GlobalFree(p.hDevNames);
  if (p.hDC)
     DeleteDC(p.hDC);
}


static void FillToDIBCBFormat(void *_dest,void *_src,int w,int h)
{
  BITMAPINFOHEADER *header;
  int n,aw;

  header = (BITMAPINFOHEADER*)_dest;
  ZeroMemory(header,sizeof(*header));
  header->biSize = sizeof(*header);
  header->biWidth = w;
  header->biHeight = -h;
  header->biPlanes = 1;
  header->biBitCount = 24;

  aw = w * 3;
  if ( aw & 3 )
     aw += 4 - (aw & 3);

  for ( n = 0; n < h; n++ )
      {
        unsigned char *src = (unsigned char *)_src+n*w*3;
        unsigned char *dest = (unsigned char *)_dest + sizeof(*header) + n*aw;

        int m = w;
        do {
          unsigned char r,g,b;

          r = *src++;
          g = *src++;
          b = *src++;
          *dest++ = b;
          *dest++ = g;
          *dest++ = r;
        } while (--m);
      }
}


void CopyToClipboard(HWND hwnd,void *buff,int w,int h)
{
  int aw;
  HGLOBAL mem;
  
  if ( !buff || !w || !h )
     return;

  aw = w * 3;
  if ( aw & 3 )
     aw += 4 - (aw & 3);

  mem = GlobalAlloc(GMEM_MOVEABLE | GMEM_DDESHARE,sizeof(BITMAPINFOHEADER)+aw*h);
  if ( mem )
     {
       void *p = GlobalLock(mem);
       if ( p )
          {
            FillToDIBCBFormat(p,buff,w,h);
            GlobalUnlock(mem);
            if ( OpenClipboard(hwnd) )
               {
                 EmptyClipboard();
                 SetClipboardData(CF_DIB,mem);
                 CloseClipboard();
               }
            else
               GlobalFree(mem);
          }
       else
          GlobalFree(mem);
     }
}
