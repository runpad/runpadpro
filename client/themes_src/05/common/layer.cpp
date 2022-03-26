
#include "common.h"




CLayer::CLayer(int _w,int _h,int _bpp,BOOL _clear)
{
  ClearVars();

  width = _w;
  height = _h;  // can be negative
  bpp = _bpp;

  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = width;
  bi.bmiHeader.biHeight = height;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = bpp;

  for ( int n = 0; n < 256; n++ )
      {
        bi.palette[n].rgbBlue = bi.palette[n].rgbGreen = bi.palette[n].rgbRed = n;
        bi.palette[n].rgbReserved = 0;
      }
  
  buff = NULL;
  bitmap = CreateDIBSection(NULL,(BITMAPINFO*)&bi,DIB_RGB_COLORS,(void**)&buff,NULL,0);

  hdc = CreateCompatibleDC(NULL);
  old_bitmap = (HBITMAP)SelectObject(hdc,bitmap);

  if ( _clear )
     {
       Clear();
     }
}


CLayer::CLayer(const CLayer &_other)
{
  ASSERT(FALSE);
}


const CLayer& CLayer::operator = (const CLayer &_other)
{
  ASSERT(FALSE);
  return *this;
}


CLayer::~CLayer()
{
  if ( hdc )
     SelectObject(hdc,old_bitmap);
  if ( hdc )
     DeleteDC(hdc);
  if ( bitmap )
     DeleteObject(bitmap);

  ClearVars();
}


void CLayer::ClearVars()
{
  hdc = NULL;
  bitmap = NULL;
  old_bitmap = NULL;
  buff = NULL;
  width = 0;
  height = 0;
  bpp = 0;
}


BYTE* CLayer::GetPointer(int x,int y) const
{
  if ( !IsValid() )
     return NULL;

  if ( x < 0 || x >= GetWidth() || y < 0 || y >= GetHeight() )
     return NULL;

  int yoffs = IsTopDown() ? y : (GetHeight()-1-y);
  
  return (BYTE*)GetBuff() + yoffs * GetRowStride() + x * (GetBPP()/8);
}


void CLayer::Clear()
{
  Fill(RGB(0,0,0),255);
}


void CLayer::Fill(int color,BYTE alpha)
{
  if ( IsValid() )
     {
       int r = GetRValue(color);
       int g = GetGValue(color);
       int b = GetBValue(color);
       
       r = r * alpha / 255;
       g = g * alpha / 255;
       b = b * alpha / 255;

       if ( GetBPP() == 8 )
          {
            int c = (r+g+b)/3;

            for ( int m = 0; m < GetHeight(); m++ )
                {
                  BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                  
                  for ( int n = 0; n < GetWidth(); n++ )
                      {
                        *row++ = c;
                      }
                }
          }
       else
       if ( GetBPP() == 24 )
          {
            for ( int m = 0; m < GetHeight(); m++ )
                {
                  BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                  
                  for ( int n = 0; n < GetWidth(); n++ )
                      {
                        *row++ = b;
                        *row++ = g;
                        *row++ = r;
                      }
                }
          }
       else
       if ( GetBPP() == 32 )
          {
            for ( int m = 0; m < GetHeight(); m++ )
                {
                  BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                  
                  for ( int n = 0; n < GetWidth(); n++ )
                      {
                        *row++ = b;
                        *row++ = g;
                        *row++ = r;
                        *row++ = alpha;
                      }
                }
          }
     }
}


void CLayer::ApplyAlphaLevel(BYTE alpha)
{
  if ( IsValid() )
     {
       BYTE table[256];

       for ( int n = 0; n < 256; n++ )
           {
             table[n] = n * alpha / 255;
           }

       if ( GetBPP() == 8 )
          {
            if ( alpha != 255 )
               {
                 for ( int m = 0; m < GetHeight(); m++ )
                     {
                       BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                       
                       for ( int n = 0; n < GetWidth(); n++ )
                           {
                             *row = table[*row]; row++;
                           }
                     }
               }
          }
       else
       if ( GetBPP() == 24 )
          {
            if ( alpha != 255 )
               {
                 for ( int m = 0; m < GetHeight(); m++ )
                     {
                       BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                       
                       for ( int n = 0; n < GetWidth(); n++ )
                           {
                             *row = table[*row]; row++;
                             *row = table[*row]; row++;
                             *row = table[*row]; row++;
                           }
                     }
               }
          }
       else
       if ( GetBPP() == 32 )
          {
            for ( int m = 0; m < GetHeight(); m++ )
                {
                  BYTE *row = (BYTE*)GetBuff() + m * GetRowStride();
                  
                  for ( int n = 0; n < GetWidth(); n++ )
                      {
                        *row = table[*row]; row++;
                        *row = table[*row]; row++;
                        *row = table[*row]; row++;
                        *row = alpha; row++;
                      }
                }
          }
     }
}


void CLayer::ApplyBitmapInternal(HBITMAP _b,const RECT *sr,InterpolationMode im)
{
  if ( IsValid() && _b )
     {
       Bitmap *b = new Bitmap(_b,(HPALETTE)NULL);
       
       Graphics *gr = new Graphics(GetHDC());
       gr->SetCompositingMode(CompositingModeSourceCopy);
       gr->SetCompositingQuality(CompositingQualityDefault);
       gr->SetInterpolationMode(im);
       gr->SetPixelOffsetMode(PixelOffsetModeHalf);

       if ( !sr )
          gr->DrawImage(b,0,0,GetWidth(),GetHeight());
       else
          gr->DrawImage(b,Rect(0,0,GetWidth(),GetHeight()),sr->left,sr->top,sr->right-sr->left,sr->bottom-sr->top,UnitPixel,NULL,NULL,NULL);

       gr->Flush(FlushIntentionSync);
       delete gr;

       delete b;

       if ( IsAlpha() ) // optimization
          {
            ApplyAlphaLevel(255);
          }
     }
}


void CLayer::ApplyBitmap(HBITMAP _b,InterpolationMode im)
{
  ApplyBitmapInternal(_b,NULL,im);
}


void CLayer::ApplyBitmap(HBITMAP _b,int sx,int sy,int sw,int sh,InterpolationMode im)
{
  RECT r = {sx,sy,sx+sw,sy+sh};

  ApplyBitmapInternal(_b,&r,im);
}


void CLayer::AlphaFillRowInternalNoCheck(BYTE *row,int count,
                                  const BYTE *table,BYTE c_r,BYTE c_g,BYTE c_b,BYTE alpha)
{
  if ( GetBPP() == 8 )
     {
       ASSERT(FALSE); // unsupported
     }
  else
  if ( GetBPP() == 24 )
     {
       for ( int n = 0; n < count; n++ )
           {
             *row++ = table[*row] + c_b;
             *row++ = table[*row] + c_g;
             *row++ = table[*row] + c_r;
           }
     }
  else
  if ( GetBPP() == 32 )
     {
       for ( int n = 0; n < count; n++ )
           {
             *row++ = table[*row] + c_b;
             *row++ = table[*row] + c_g;
             *row++ = table[*row] + c_r;
             *row++ = table[*row] + alpha;
           }
     }
}


void CLayer::AlphaFillRow(int x,int y,int count,ALPHAFILLROW *i)
{
  ASSERT( IsValid() );
  ASSERT( i );
  ASSERT( y >= 0 && y < GetHeight() );
  ASSERT( count >= 0 );
  ASSERT( x >= 0 );
  ASSERT( x + count <= GetWidth() );

  if ( count > 0 )
     {
       BYTE *row = GetPointer(x,y);
       ASSERT( row );

       AlphaFillRowInternalNoCheck(row,count,i->table,i->c_r,i->c_g,i->c_b,i->alpha);
     }
}


void CLayer::AlphaFillRowWrapper(int x,int y,int count,void *parm)
{
  ALPHAFILLROW *i = (ALPHAFILLROW*)parm;

  if ( i && i->self )
     {
       i->self->AlphaFillRow(x,y,count,i);
     }
}


void CLayer::AlphaFill(int color,BYTE alpha,HRGN excl)
{
  if ( IsValid() )
     {
       BYTE c_r = (int)GetRValue(color) * alpha / 255;
       BYTE c_g = (int)GetGValue(color) * alpha / 255;
       BYTE c_b = (int)GetBValue(color) * alpha / 255;

       BYTE table[256];
       for ( int n = 0; n < 256; n++ )
           table[n] = n * (255-alpha) / 255;

       ALPHAFILLROW i;

       i.self = this;
       i.table = table;
       i.c_r = c_r;
       i.c_g = c_g;
       i.c_b = c_b;
       i.alpha = alpha;
       
       ::ProcessExclRgnOperation(excl,GetWidth(),GetHeight(),AlphaFillRowWrapper,&i);
     }
}


void CLayer::PaintTo(HDC d_hdc,int d_x,int d_y) const
{
  if ( IsValid() && d_hdc )
     {
       if ( GetHDC() != d_hdc )
          {
            BitBlt(d_hdc,d_x,d_y,GetWidth(),GetHeight(),GetHDC(),0,0,SRCCOPY);
          }
     }
}


void CLayer::PaintTo(CLayer &d_layer,int d_x,int d_y) const
{
  if ( IsValid() && d_layer.IsValid() && this != &d_layer )
     {
       if ( !IsAlpha() && !d_layer.IsAlpha() )
          {
            BitBlt(d_layer.GetHDC(),d_x,d_y,GetWidth(),GetHeight(),GetHDC(),0,0,SRCCOPY);
          }
       else
          {
            BLENDFUNCTION bf;

            bf.BlendOp = AC_SRC_OVER;
            bf.BlendFlags = 0;
            bf.SourceConstantAlpha = 255;
            bf.AlphaFormat = IsAlpha() ? AC_SRC_ALPHA : 0;

            AlphaBlend(d_layer.GetHDC(),d_x,d_y,GetWidth(),GetHeight(),GetHDC(),0,0,GetWidth(),GetHeight(),bf);
          }
     }
}


void CLayer::PaintTo(CLayer &d_layer,int d_x,int d_y,BYTE alpha) const
{
  if ( IsValid() && d_layer.IsValid() && this != &d_layer )
     {
       BLENDFUNCTION bf;

       bf.BlendOp = AC_SRC_OVER;
       bf.BlendFlags = 0;
       bf.SourceConstantAlpha = alpha; // fixed alpha
       bf.AlphaFormat = IsAlpha() ? AC_SRC_ALPHA : 0;

       AlphaBlend(d_layer.GetHDC(),d_x,d_y,GetWidth(),GetHeight(),GetHDC(),0,0,GetWidth(),GetHeight(),bf);
     }
}


