
#ifndef ___DRAW_H___
#define ___DRAW_H___



class CSystemIcon
{
          HICON m_handle;
          BOOL b_is_mask_present;
          BOOL b_is_picture;
          int m_width;
          int m_height;

  public:
          CSystemIcon(HICON handle,BOOL is_handle_must_be_owned_by_class);
          CSystemIcon(const char *picfile,int width,int height);
          ~CSystemIcon();

          HICON GetHandle() const { return m_handle; }
          int GetWidth() const { return m_width; }
          int GetHeight() const { return m_height; }
          BOOL IsMaskPresent() const { return b_is_mask_present; }
          BOOL IsPicture() const { return b_is_picture; }
          BOOL IsValid() const { return GetHandle() != NULL && GetWidth() > 0 && GetHeight() > 0; }
          BOOL DrawTo(HDC hdc,int x,int y,int w,int h) const;
          BOOL DrawTo(HDC hdc,int x,int y) const;

  private:
          static BOOL GetIconDim(HICON handle,int& _width,int& _height);
          static HBITMAP Create1FillMonoBitmap(int width,int height,const unsigned *buff32);
          static HBITMAP CreateResizedBitmapInternalNoCheck(HBITMAP sbm,int sw,int sh,int dw,int dh,BOOL draw_border,BOOL is_alpha,HBITMAP& _mask);

};



class CRBuff
{
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
          CRBuff(int _w,int _h,int _bpp,BOOL _clear);
          ~CRBuff();
          CRBuff* CreateCopy();
          void FillRBuffStruct(RBUFF *i);
          BOOL IsNotEmpty() const { return hdc && buff && bitmap && GetWidth()>0 && GetHeight()>0; }
          BOOL IsEmpty() const { return !IsNotEmpty(); }
          int GetWidth() const { return width; }
          int GetRowStride() const { return (width*(bpp/8)+3)&~3; }
          int GetHeight() const { return height < 0 ? -height : height; }
          int GetRealHeight() const { return height; }
          BOOL IsSizeMatch(int w,int h) const { return w == GetWidth() && h == GetHeight(); }
          BOOL IsTopDown() const { return height < 0; }
          BOOL IsDownTop() const { return height > 0; }
          int GetDataSize() const { return GetRowStride()*GetHeight(); }
          int GetBPP() const { return bpp; }
          HDC GetHDC() const { return hdc; }
          HBITMAP GetBitmap() const { return bitmap; }
          void* GetBuff() const { return buff; }
          BITMAPINFO* GetBitmapInfo() const { return (BITMAPINFO*)&bi; }
          BOOL CopyRawDataFrom(const void *_buff,unsigned _size);
          BOOL PaintTo(HDC d_hdc,int d_x,int d_y);
          void Clear(int _color=0);
          HBITMAP ReleaseBitmap();

  private:
          void ClearVars();
};


int GetAniColor(int c1,int c2,int frame,int numframes);
int GetFGColor(int bg);
int Gamma(int color,float k);
void MakeThemeInternal(THEME *theme,int color);
void MakeTheme(int color);
int MakeColorByBrightness(int base_color,int brightness);
const THEME2D* Get2DTheme(void);
void Draw_Theme_Rect(HDC hdc,const RECT *r);
void Draw_Theme_Sheet(HDC hdc,const RECT *r,int state,const char *text,HICON icon,int bold,int highlited,BOOL show_pointer,BOOL centered,int fontsize);
void Draw_Theme_Bitmap(HDC hdc,const RECT *r,const unsigned char *buff);
void Draw_Window_Rect(HDC hdc,RECT *r,int left,int right,int top,int bottom,int _c1,int _c2);
void MapRGB2BGR(void *src,void *dest,int w,int h);
Image* CreateImageFromHDC(HDC hdc,int w,int h);
IStream* SaveScreenToStream();
void RB_Create(RBUFF *i);
void RB_CreateNormal(RBUFF *i,int w,int h);
void RB_CreateGrayscale(RBUFF *i,int w,int h);
void RB_Destroy(RBUFF *i);
void RB_Smooth(RBUFF *i,int value);
void RB_DrawShadow(RBUFF *s,RBUFF *d,int x,int y,int allow_mmx);
void RB_PaintTo(RBUFF *i,HDC dest);
void RB_PaintFrom(HDC src,RBUFF *i);
void RB_Fill(RBUFF *i,int color);
void RB_Frame(RBUFF *i,int color);
void RB_PaintToWindow(RBUFF *i,HWND hwnd);
void RB_HGradient32(RBUFF *buff,int c1,int c2);
void DrawTextWithShadow(HDC hdc,const char *s,RECT *r,int flags,int offset,int smooth);
void DrawTextWithShadowW(HDC hdc,const WCHAR *s,RECT *r,int flags,int offset,int smooth);
void GetHDCDim(HDC hdc,int *w,int *h);
void GetBitmapDim(HBITMAP bitmap,int *w,int *h);
void RB_Animate(RBUFF *bsrc,RBUFF *bdest,HWND hwnd,void(*cb)(int perc,void *parm),void *cb_parm);
void* GetIconRawBitmap24(HICON icon,int w,int h,int bgcolor);
void *GetIconRaw(HICON icon,int *out_size);
void AdjustGammaBGRStride(void *buff,int w,int h,int stride,float desired_gamma);
void DrawIconHLInternal(HDC hdc,RECT *r,int perc);
void MakeTransparent(HDC dest,HDC src,int x_dest,int y_dest,int x_src,int y_src,int w,int h,int alpha);
void DoUberIconEffectInternal(int effect_num,HICON icon,const RECT *r);
void EliminateInvalidRect(RECT *r);


#endif
