
#ifndef __FONT_H__
#define __FONT_H__



class CFont
{
          HFONT font;
          HFONT old_font;
          HDC hdc;

          int old_bkmode;
          int old_bkcolor;
          int old_textcolor;

  public:
          CFont(HDC _hdc,const char *name,int size,int weight=FW_NORMAL,int quality=DEFAULT_QUALITY,
                BOOL italic=FALSE,BOOL underline=FALSE,BOOL strikeout=FALSE,
                DWORD charset=DEFAULT_CHARSET);
          ~CFont();

          void SetBkMode(int mode);
          void SetBkColor(int color);
          void SetTextColor(int color);

          int DrawText(const char *text,RECT &r,UINT format);
};



#endif

