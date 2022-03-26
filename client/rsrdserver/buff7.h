
#ifndef __BUFF7_H__
#define __BUFF7_H__


class CBuff7
{
      HBITMAP m_bitmap;
      HBITMAP m_oldbitmap;
      HDC m_hdc;
      int m_w, m_h;
      unsigned char *m_bits;
      BOOL m_grayscale;
    
  public:
      CBuff7(BOOL grayscale, int w, int h);
      ~CBuff7();

      BOOL IsAllocated() const { return m_hdc && m_bitmap && m_bits && m_w && m_h; }
      BOOL IsScreenMatch() const;
      BOOL IsScreenMatch(BOOL grayscale,int sw,int sh) const;

      BOOL IsGrayscale() const { return m_grayscale; }
      int GetWidth() const { return m_w; }
      int GetHeight() const { return m_h; }
      unsigned char* GetBits() { return m_bits; }
      HDC GetHDC() { return m_hdc; }

      void Capture();

  private:
      void Free();
};


#endif
