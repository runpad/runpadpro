
#include "stdafx.h"
#include "pic.h"
#include "main.h"
#include "utils.h"



typedef struct {
unsigned char b,g,r,a;
} BGRA;

typedef struct {
  int w,h;
  void *bits;
  HDC hdc;
} RBUFF;



static void RB_PaintTo(RBUFF *i,HDC dest)
{
  BitBlt(dest,0,0,i->w,i->h,i->hdc,0,0,SRCCOPY);
}


static void RB_PaintFrom(HDC src,RBUFF *i)
{
  BitBlt(i->hdc,0,0,i->w,i->h,src,0,0,SRCCOPY);
}


static void RB_PaintToWindow(RBUFF *i,HWND hwnd)
{
  HDC hdc;

  hdc = GetDC(hwnd);
  RB_PaintTo(i,hdc);
  ReleaseDC(hwnd,hdc);
}


static void RB_PaintBlockToWindow(RBUFF *i,HWND hwnd,int x,int y,int w,int h)
{
  HDC hdc;

  hdc = GetDC(hwnd);
  BitBlt(hdc,x,y,w,h,i->hdc,x,y,SRCCOPY);
  ReleaseDC(hwnd,hdc);
}



static void RB_PaintBlockToHDC(RBUFF *i,HDC hdc,int x,int y,int w,int h)
{
  BitBlt(hdc,x,y,w,h,i->hdc,x,y,SRCCOPY);
}



static void RB_CopyHLine(RBUFF *src,int sx,int sy,int len,RBUFF *dest,int dx,int dy)
{
  int w,h;

  if ( !src->bits || !dest->bits )
     return;

  w = src->w;
  h = src->h;

  if ( len <= 0 )
     return;
  if ( len > w )
     len = w;
  
  if ( dy < 0 || dy >= h )
     return;
  if ( dx >= w || dx+len <= 0 )
     return;
  if ( dx+len > w )
     len = w-dx;
  if ( dx < 0 )
     {
       len += dx;
       sx -= dx;
       dx = 0;
     }

  CopyMemory((BGRA*)dest->bits+dy*w+dx,(BGRA*)src->bits+sy*w+sx,len*4);
}


static void RB_CopyVLine(RBUFF *src,int sx,int sy,int len,RBUFF *dest,int dx,int dy)
{
  int w,h;
  BGRA *psrc,*pdest;

  if ( !src->bits || !dest->bits )
     return;

  w = src->w;
  h = src->h;

  if ( len <= 0 )
     return;
  if ( len > h )
     len = h;
  
  if ( dx < 0 || dx >= w )
     return;
  if ( dy >= h || dy+len <= 0 )
     return;
  if ( dy+len > h )
     len = h-dy;
  if ( dy < 0 )
     {
       len += dy;
       sy -= dy;
       dy = 0;
     }

  psrc = (BGRA*)src->bits+sy*w+sx;
  pdest = (BGRA*)dest->bits+dy*w+dx;
  do {
   *pdest = *psrc;
   pdest += w;
   psrc += w;
  } while (--len);
}


static void RB_CopyBlock(RBUFF *src,int sx,int sy,int w,int h,RBUFF *dest,int dx,int dy)
{
  int n;

  if ( !src->bits || !dest->bits )
     return;

  for ( n = 0; n < h; n++ )
      RB_CopyHLine(src,sx,sy+n,w,dest,dx,dy+n);
}


static void RB_Effect1(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int interlace = 8;
  int n,k,w,h;

  if ( !bsrc->bits || !bdest->bits )
     return;

  w = bsrc->w;
  h = bsrc->h;

  for ( k = 0; k < interlace; k++ )
      {
        for ( n = 0; n < h/interlace; n++ )
            RB_CopyHLine(bdest,0,n*interlace+k,w,bsrc,0,n*interlace+k);
        RB_PaintToWindow(bsrc,hwnd);
        Sleep(5);
      }
}


static void RB_Effect2(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int interlace = 8;
  int n,m,k,w,h;
  HDC hdc;

  if ( !bsrc->bits || !bdest->bits )
     return;

  w = bsrc->w;
  h = bsrc->h;

  for ( k = 0; k < interlace; k++ )
      {
        for ( m = 0; m < h; m++ )
            {
              BGRA *pdest = (BGRA*)bsrc->bits+m*w+k;
              BGRA *psrc = (BGRA*)bdest->bits+m*w+k;
              n = w/interlace;
              do {
               *pdest = *psrc;
               pdest += interlace;
               psrc += interlace;
              } while (--n);
            }

        RB_PaintToWindow(bsrc,hwnd);
        Sleep(5);
      }
}


static void RB_Effect3(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int interlace = 8;
  int n,m,k,w,h;

  if ( !bsrc->bits || !bdest->bits )
     return;

  w = bsrc->w;
  h = bsrc->h;

  for ( k = 0; k < interlace; k++ )
      {
        for ( n = 0; n < h/interlace; n++ )
            RB_CopyHLine(bdest,0,n*interlace+k,w,bsrc,0,n*interlace+k);
        for ( m = 0; m < h; m++ )
            {
              BGRA *pdest = (BGRA*)bsrc->bits+m*w+k;
              BGRA *psrc = (BGRA*)bdest->bits+m*w+k;
              n = w/interlace;
              do {
               *pdest = *psrc;
               pdest += interlace;
               psrc += interlace;
              } while (--n);
            }

        RB_PaintToWindow(bsrc,hwnd);
        Sleep(5);
      }
}

/*
static void RB_Effect4(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int size = 8;
  int n,w,h,pos,len,x,y;
  int *table;
  HDC hdc;

  if ( !bsrc->bits || !bdest->bits )
     return;

  seed = GetTickCount();

  w = bsrc->w/size;
  h = bsrc->h/size;
  len = w*h;

  table = (int*)sys_alloc(len*4);

  for ( n = 0; n < len; n++ )
      table[n] = n;

  for ( n = 0; n < len; n++ )
      {
        int idx1 = PseudoRandom() % len;
        int idx2 = PseudoRandom() % len;
        if ( idx1 != idx2 )
           {
             int t = table[idx1];
             table[idx1] = table[idx2];
             table[idx2] = t;
           }
      }

  hdc = GetDC(hwnd);
  for ( n = 0; n < len; n++ )
      {
        pos = table[n];
        x = pos % w;
        y = pos / w;

        RB_PaintBlockToHDC(bdest,hdc,x*size,y*size,size,size);
        if ( (n % (len/20)) == 0 )
           Sleep(5);
      }
  ReleaseDC(hwnd,hdc);

  sys_free(table);
}
*/

/*
static void RB_Effect5(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int delta = 8;
  const int hh = 8;
  int n,m,w,h,x,y;
  HDC hdc;

  if ( !bsrc->bits || !bdest->bits )
     return;

  w = bsrc->w/delta;
  h = bsrc->h;

  hdc = GetDC(hwnd);
  for ( n = 0; n < w; n++ )
      {
        for ( m = 0; m < (h/hh)/2; m++ )
            {
              x = n*delta;
              y = (m*2+0)*hh;
              RB_PaintBlockToHDC(bdest,hdc,x,y,delta,hh);
              x = (w-1-n)*delta;
              y = (m*2+1)*hh;
              RB_PaintBlockToHDC(bdest,hdc,x,y,delta,hh);
            }
        if ( n % (w/30) == 0 )
           Sleep(5);
      }
  ReleaseDC(hwnd,hdc);
}
*/

/*
static void RB_Effect6(RBUFF *bsrc,RBUFF *bdest,HWND hwnd)
{
  const int delta = 8;
  const int hh = 8;
  int n,m,w,h,x,y;
  HDC hdc;

  if ( !bsrc->bits || !bdest->bits )
     return;

  w = bsrc->w;
  h = bsrc->h/delta;

  hdc = GetDC(hwnd);
  for ( n = 0; n < h; n++ )
      {
        for ( m = 0; m < (w/hh)/2; m++ )
            {
              y = n*delta;
              x = (m*2+0)*hh;
              RB_PaintBlockToHDC(bdest,hdc,x,y,hh,delta);
              y = (h-1-n)*delta;
              x = (m*2+1)*hh;
              RB_PaintBlockToHDC(bdest,hdc,x,y,hh,delta);
            }
        if ( n % (h/30) == 0 )
           Sleep(5);
      }
  ReleaseDC(hwnd,hdc);
}
*/


typedef void (*RB_EFFECT)(RBUFF*,RBUFF*,HWND);

static RB_EFFECT rb_effects[] =
{
  RB_Effect1,
  RB_Effect2,
  RB_Effect3,
//  RB_Effect4,
//  RB_Effect5,
//  RB_Effect6,
};


void CRBuff::Animate(CRBuff *dest,HWND hwnd)
{
  if ( dest && !dest->IsEmpty() && !IsEmpty() )
     {
       if ( w == dest->w && h == dest->h )
          {
            int count = sizeof(rb_effects)/sizeof(rb_effects[0]);
            int idx = TrueRandom() % count;

            RBUFF bsrc,bdest;

            bsrc.w = w;
            bsrc.h = h;
            bsrc.bits = bits;
            bsrc.hdc = hdc;

            bdest.w = dest->w;
            bdest.h = dest->h;
            bdest.bits = dest->bits;
            bdest.hdc = dest->hdc;

            rb_effects[idx](&bsrc,&bdest,hwnd);
          }
     }
}
