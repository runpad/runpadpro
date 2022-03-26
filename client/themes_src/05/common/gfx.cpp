
#include "common.h"




CTempLayersCache::CWrapper* CreateSmoothTextLayer(int _width,int _height,
                   const char *_text,int _format,const char *_font,int _size,int _weight,
                   int _color,BYTE _alpha,int _smooth)
{
  const int w = _width;
  const int h = _height;

  CTempLayersCache::CWrapper *out_wrp = CTempLayersCache::GetLayer(w,h,32);
  if ( out_wrp )
     {
       CLayer32 *out = static_cast<CLayer32*>(out_wrp->GetLayer());

       if ( out && out->IsValid() )
          {
            if ( w > 0 && h > 0 && !IsStrEmpty(_text) )
               {
                 CTempLayersCache::CWrapper *wrp = CTempLayersCache::GetLayer(w,h,24);
                 if ( wrp )
                    {
                      CLayer24 *t = static_cast<CLayer24*>(wrp->GetLayer());
                      if ( t && t->IsValid() )
                         {
                           t->Fill(RGB(0,0,0));

                           {
                             CFont f(t->GetHDC(),_font,_size,_weight,CLEARTYPE_QUALITY);
                             f.SetBkMode(OPAQUE);
                             f.SetBkColor(RGB(0,0,0));
                             f.SetTextColor(RGB(_alpha,_alpha,_alpha));
                             RECT r = {0,0,w,h};
                             f.DrawText(_text,r,_format);
                           }

                           if ( _smooth == 1 )
                              t->Smooth<5>(_smooth,0,0);
                           else
                           if ( _smooth > 1 )
                              t->Smooth<9>(_smooth,0,0);

                           int c_r = GetRValue(_color);
                           int c_g = GetGValue(_color);
                           int c_b = GetBValue(_color);

                           int c255 = 0xFF000000 | (c_r << 16) | (c_g << 8) | c_b;
                           
                           for ( int m = 0; m < h; m++ )
                               {
                                 const BYTE *src24 = t->GetPointer(0,m);
                                 BYTE *dest32 = out->GetPointer(0,m);

                                 for ( int n = 0; n < w; n++ )
                                     {
                                       BYTE alpha = *src24;
                                       src24 += 3;

                                       if ( alpha == 0 )
                                          {
                                            *(int*)dest32 = 0;
                                            dest32 += 4;
                                          }
                                       else
                                       if ( alpha == 255 )
                                          {
                                            *(int*)dest32 = c255;
                                            dest32 += 4;
                                          }
                                       else
                                          {
                                            *dest32++ = c_b * alpha / 255;
                                            *dest32++ = c_g * alpha / 255;
                                            *dest32++ = c_r * alpha / 255;
                                            *dest32++ = alpha;
                                          }
                                     }
                               }
                         }
                      else
                         {
                           out->Fill(RGB(0,0,0),0);
                         }
                    
                      delete wrp;
                    }
               }
            else
               {
                 out->Fill(RGB(0,0,0),0);
               }
          }
     }

  return out_wrp;
}


void DrawSmoothText(CLayer &_layer,const RECT &_r,
                   const char *_text,int _format,const char *_font,int _size,int _weight,
                   int _color,BYTE _alpha,int _smooth)
{
  if ( _layer.IsValid() )
     {
       const int w = _r.right - _r.left;
       const int h = _r.bottom - _r.top;

       if ( w > 0 && h > 0 )
          {
            if ( !IsStrEmpty(_text) )
               {
                 CTempLayersCache::CWrapper *wrp = CreateSmoothTextLayer(w,h,_text,_format,_font,_size,_weight,_color,_alpha,_smooth);
                 if ( wrp )
                    {
                      const CLayer32 *t = static_cast<CLayer32*>(wrp->GetLayer());
                      if ( t && t->IsValid() )
                         {
                           ASSERT(t->IsAlpha());
                           t->PaintTo(_layer,_r.left,_r.top);
                         }

                      delete wrp;
                    }
               }
          }
     }
}


void DrawSmoothTextWithShadow(CLayer &_layer,const RECT &_rtext,const RECT &_rshadow,
                              const char *_text,int _format,
                              const char *_font,int _size,int _weight,int _color,
                              BYTE _alpha_shadow,int _smooth_shadow)
{
  DrawSmoothText(_layer,_rshadow,_text,_format,_font,_size,_weight,RGB(0,0,0),_alpha_shadow,_smooth_shadow);
  DrawSmoothText(_layer,_rtext,_text,_format,_font,_size,_weight,_color,255,1);
}


void DrawSmoothTextFitIn(CLayer &_layer,const RECT &_r,
                   const char *_text,int _format,const char *_font,int _start_size,int _weight,
                   int _color,BYTE _alpha,int _smooth)
{
  int fsize = GetFontSizeToFitIn(_start_size,_r,_text,_format,_font,_weight);

  if ( fsize != 0 )
     {
       DrawSmoothText(_layer,_r,_text,_format,_font,fsize,_weight,_color,_alpha,_smooth);
     }
}


int GetFontSizeToFitIn(int start_size,const RECT &_r,
                 const char *_text,int _format,const char *_font,int _weight)
{
  if ( start_size == 0 )
     return start_size;
     
  if ( IsStrEmpty(_text) )
     return start_size;
  
  HDC hdc = CreateCompatibleDC(NULL);

  const int bound_width = _r.right - _r.left;
  const int bound_height = _r.bottom - _r.top;

  int size = start_size;

  while ( size != 0 )
  {
    CFont f(hdc,_font,size,_weight);

    RECT r = {0,0,bound_width,bound_height};

    f.DrawText(_text,r,_format|DT_CALCRECT);

    int new_width = r.right - r.left;
    int new_height = r.bottom - r.top;

    if ( new_width <= bound_width && new_height <= bound_height )
       break;

    size -= size/ABS(size);
  }

  DeleteDC(hdc);

  return size;
}


void ApplyBitmapProportional(CLayer &_layer,HBITMAP bm,InterpolationMode im)
{
  if ( bm && _layer.IsValid() )
     {
       int sw=0,sh=0;
       GetBitmapDim(bm,sw,sh);
       if ( sw > 0 && sh > 0 )
          {
            int dw = _layer.GetWidth();
            int dh = _layer.GetHeight();

            ASSERT(dw > 0);
            ASSERT(dh > 0);

            int aw,ah;

            if ( sh >= dh * sw / dw )  
               { 
                 ah = dh * sw / dw;
                 aw = sw;
               }
            else
               { 
                 aw = dw * sh / dh;
                 ah = sh;
               }

            if ( aw > 0 && aw <= sw && ah > 0 && ah <= sh ) //paranoja
               {
                 int sx = (sw-aw)/2;
                 int sy = (sh-ah)/2;
       
                 _layer.ApplyBitmap(bm,sx,sy,aw,ah,im);
               }
          }
     }
}





