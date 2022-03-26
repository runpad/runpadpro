
#include "include.h"


#include "palette.inc"


CBuff7::CBuff7(BOOL grayscale, int sw, int sh)
{
  m_hdc = NULL;
  m_bitmap = NULL;
  m_oldbitmap = NULL;
  m_bits = NULL;
  m_grayscale = grayscale;
  m_w = sw;
  m_h = sh;

  if ( m_w && m_h )
     {
       struct {
        BITMAPINFOHEADER bmiHeader;
        RGBQUAD bmiColors[256];
       } bi;
       
       CopyMemory(bi.bmiColors,grayscale?pal_gray:pal_color,sizeof(bi.bmiColors));

       ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
       bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
       bi.bmiHeader.biWidth = m_w;
       bi.bmiHeader.biHeight = -m_h;
       bi.bmiHeader.biPlanes = 1;
       bi.bmiHeader.biBitCount = 8;
       bi.bmiHeader.biClrUsed = 127;
       bi.bmiHeader.biClrImportant = 127;
       m_bitmap = CreateDIBSection(NULL,(BITMAPINFO*)&bi,DIB_RGB_COLORS,(void**)&m_bits,NULL,0);

       if ( m_bits )
          {
            ZeroMemory(m_bits,m_w*m_h*1);
          }

       m_hdc = CreateCompatibleDC(NULL);
       m_oldbitmap = (HBITMAP)SelectObject(m_hdc,m_bitmap);

       if ( !m_bitmap || !m_hdc )
          {
            Free();
          }
     }
}


CBuff7::~CBuff7()
{
  Free();
}


void CBuff7::Free()
{
  if ( m_hdc )
     SelectObject(m_hdc,m_oldbitmap);
  if ( m_hdc )
     DeleteDC(m_hdc);
  if ( m_bitmap )
     DeleteObject(m_bitmap);

  m_hdc = NULL;
  m_bitmap = NULL;
  m_oldbitmap = NULL;
  m_w = 0;
  m_h = 0;
  m_bits = NULL;
}


void CBuff7::Capture()
{
  if ( IsAllocated() && IsScreenMatch() )
     {
       HDC hdc = GetDC(NULL);
       BitBlt(m_hdc,0,0,m_w,m_h,hdc,0,0,SRCCOPY);   // multimonitors are not supported!
       ReleaseDC(NULL,hdc);
       GdiFlush();
     }
}


BOOL CBuff7::IsScreenMatch() const
{
  return IsAllocated() && GetSystemMetrics(SM_CXSCREEN) == GetWidth() && GetSystemMetrics(SM_CYSCREEN) == GetHeight();
}


BOOL CBuff7::IsScreenMatch(BOOL grayscale,int sw,int sh) const
{
  return IsAllocated() && IsBoolEqu(IsGrayscale(),grayscale) && sw == GetWidth() && sh == GetHeight();
}
