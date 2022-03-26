

class CRBuff 
{
  int w,h;
  void *bits;
  HBITMAP bitmap,old_bitmap;
  HDC hdc;

 public:
         CRBuff(HWND hwnd);
         ~CRBuff();

         BOOL LoadPic(const char *filename);
         void Animate(CRBuff *dest,HWND hwnd);
         void Paint(HDC hdc);

 private:        
         void Fill(int color);
         BOOL IsEmpty() { return !hdc || !bitmap || !bits || !w || !h; }
};
