
#include "stdafx.h"
#include <shlwapi.h>
#include <gdiplus.h>
#include "pic.h"
#include "main.h"
#include "utils.h"

using namespace Gdiplus;



CRBuff::~CRBuff()
{
  if ( hdc )
     SelectObject(hdc,old_bitmap);
  if ( hdc )
     DeleteDC(hdc);
  if ( bitmap )
     DeleteObject(bitmap);
}


CRBuff::CRBuff(HWND hwnd)
{
  RECT r;
  SetRectEmpty(&r);
  GetClientRect(hwnd,&r);
  if ( IsRectEmpty(&r) )
     GetWindowRect(hwnd,&r);
  if ( IsRectEmpty(&r) )
     SetRect(&r,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
     
  w = r.right - r.left;
  h = r.bottom - r.top;
  bits = NULL;
  
  BITMAPINFO bi;
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = w;
  bi.bmiHeader.biHeight = -h;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 32;
  bitmap = CreateDIBSection(NULL,&bi,DIB_RGB_COLORS,(void**)&bits,NULL,0);

  hdc = CreateCompatibleDC(NULL);
  old_bitmap = (HBITMAP)SelectObject(hdc,bitmap);

  Fill(RGB(0,0,0));
}


void CRBuff::Fill(int color)
{
  if ( !IsEmpty() )
     {
       RECT r;
       SetRect(&r,0,0,w,h);
       HBRUSH brush = CreateSolidBrush(color);
       FillRect(hdc,&r,brush);
       DeleteObject(brush);
     }
}


BOOL CRBuff::LoadPic(const char *filename)
{
  BOOL rc = FALSE;

  if ( !IsEmpty() )
     {
       ULONG_PTR gdiplus_token = 0;
       GdiplusStartupInput gdiplus_input; //here is default constructor present!
       GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
       
       WCHAR wsz[MAX_PATH] = L"";
       MultiByteToWideChar(CP_ACP,0,filename?filename:"",-1,wsz,MAX_PATH);
       
       Bitmap *pBitmap = new Bitmap(wsz);

       if ( pBitmap->GetLastStatus() == Ok )
          {
            int pic_w = pBitmap->GetWidth();
            int pic_h = pBitmap->GetHeight();

            if ( pic_w > 0 && pic_h > 0 )
               {
                 int fit_w = pic_w;
                 int fit_h = pic_h;
                 
                 if ( pic_w > w || pic_h > h )
                    {
                      if ( h >= pic_h * w / pic_w )
                         {
                           fit_h = pic_h * w / pic_w;
                           fit_w = w;
                         }
                      else
                         {
                           fit_w = pic_w * h / pic_h;
                           fit_h = h;
                         }
                    }

                 Fill(RGB(0,0,0));

                 Graphics *pGraphics = new Graphics(hdc);

                 pGraphics->SetCompositingQuality(CompositingQualityHighSpeed);
                 pGraphics->SetInterpolationMode(InterpolationModeBilinear);
                 pGraphics->SetCompositingMode(CompositingModeSourceCopy);

                 rc = (pGraphics->DrawImage(pBitmap,(w-fit_w)/2,(h-fit_h)/2,fit_w,fit_h) == Ok);
                 pGraphics->Flush(FlushIntentionSync);

                 delete pGraphics;
               }
          }

       delete pBitmap;

       GdiplusShutdown(gdiplus_token);
     }

  return rc;
}


void CRBuff::Paint(HDC dest)
{
  if ( !IsEmpty() )
     {
       BitBlt(dest,0,0,w,h,hdc,0,0,SRCCOPY);
     }
}
