
#ifndef __LAYER_H__
#define __LAYER_H__



class CLayer
{
          typedef struct {
           CLayer *self;
           const BYTE *table;
           BYTE c_r;
           BYTE c_g;
           BYTE c_b;
           BYTE alpha;
          } ALPHAFILLROW;
          
  private:        
          int width;
          int height;  // can be negative
          int bpp;
          HBITMAP bitmap;
          HBITMAP old_bitmap;
          HDC hdc;
          void *buff;

          struct {
           BITMAPINFOHEADER bmiHeader;
           RGBQUAD palette[256];
          } bi;

  public:
          CLayer(int _w,int _h,int _bpp,BOOL _clear=TRUE);
          CLayer(const CLayer &_other); //unsupported
          virtual ~CLayer();

          const CLayer& operator = (const CLayer &_other); //unsupported

          BOOL IsNotEmpty() const { return hdc && buff && bitmap && GetWidth()>0 && GetHeight()>0; }
          BOOL IsEmpty() const { return !IsNotEmpty(); }
          BOOL IsValid() const { return IsNotEmpty(); }
          
          int GetWidth() const { return width; }
          int GetRowStride() const { return (width*(bpp/8)+3)&~3; }
          int GetHeight() const { return height < 0 ? -height : height; }
          int GetRealHeight() const { return height; }
          BOOL IsSizeMatch(int w,int h) const { return w == GetWidth() && h == GetHeight(); }
          BOOL IsStrictMatch(int w,int h,int _bpp) const { return w == width && h == height && _bpp == bpp; }
          BOOL IsTopDown() const { return height < 0; }
          BOOL IsDownTop() const { return height > 0; }
          int GetDataSize() const { return GetRowStride()*GetHeight(); }
          int GetBPP() const { return bpp; }
          HDC GetHDC() const { return hdc; }
          HBITMAP GetBitmap() const { return bitmap; }
          void* GetBuff() const { return buff; }
          const BITMAPINFO* GetBitmapInfo() const { return (BITMAPINFO*)&bi; }
          BOOL IsAlpha() const { return GetBPP() == 32; }
          BYTE* GetPointer(int x,int y) const;
          
          void Clear();
          void Fill(int _color=0,BYTE alpha=255);
          void ApplyAlphaLevel(BYTE alpha);

          template <int _pixels>
          inline void Smooth(int factor=1,int from_layer=-1,int to_layer=-1);
          void ApplyBitmap(HBITMAP b,InterpolationMode im=InterpolationModeBilinear);
          void ApplyBitmap(HBITMAP b,int sx,int sy,int sw,int sh,InterpolationMode im=InterpolationModeBilinear);
          void AlphaFill(int color,BYTE alpha,HRGN excl=NULL);
          
          void PaintTo(HDC d_hdc,int d_x,int d_y) const;
          void PaintTo(CLayer &d_layer,int d_x,int d_y) const ;
          void PaintTo(CLayer &d_layer,int d_x,int d_y,BYTE alpha) const;

  private:
          void ClearVars();
          void ApplyBitmapInternal(HBITMAP _b,const RECT *sr,InterpolationMode im);
          
          void AlphaFillRowInternalNoCheck(BYTE *row,int count,const BYTE *table,BYTE c_r,BYTE c_g,BYTE c_b,BYTE alpha);
          void AlphaFillRow(int x,int y,int count,ALPHAFILLROW *i);
          static void AlphaFillRowWrapper(int x,int y,int count,void *parm);
          
};


class CLayer32 : public CLayer
{
  public:
          CLayer32(int _w,int _h,BOOL _clear=TRUE) : CLayer(_w,_h,32,_clear) {}
};

class CLayer24 : public CLayer
{
  public:
          CLayer24(int _w,int _h,BOOL _clear=TRUE) : CLayer(_w,_h,24,_clear) {}
};

class CLayer8 : public CLayer
{
  public:
          CLayer8(int _w,int _h,BOOL _clear=TRUE) : CLayer(_w,_h,8,_clear) {}
};



#include "layer.hpp"


#endif

