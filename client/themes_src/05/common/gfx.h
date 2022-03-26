
#ifndef __GFX_H__
#define __GFX_H__


CTempLayersCache::CWrapper* CreateSmoothTextLayer(int _width,int _height,
                   const char *_text,int _format,const char *_font,int _size,int _weight,
                   int _color,BYTE _alpha,int _smooth);
void DrawSmoothText(CLayer &_layer,const RECT &_r,
                   const char *_text,int _format,const char *_font,int _size,int _weight,
                   int _color,BYTE _alpha,int _smooth);
void DrawSmoothTextWithShadow(CLayer &_layer,const RECT &_rtext,const RECT &_rshadow,
                              const char *_text,int _format,
                              const char *_font,int _size,int _weight,int _color,
                              BYTE _alpha_shadow,int _smooth_shadow);
void DrawSmoothTextFitIn(CLayer &_layer,const RECT &_r,
                   const char *_text,int _format,const char *_font,int _start_size,int _weight,
                   int _color,BYTE _alpha,int _smooth);
int GetFontSizeToFitIn(int start_size,const RECT &_r,
                 const char *_text,int _format,const char *_font,int _weight);
void ApplyBitmapProportional(CLayer &_layer,HBITMAP bm,InterpolationMode im=InterpolationModeBilinear);



#endif

