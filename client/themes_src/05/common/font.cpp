
#include "common.h"



CFont::CFont(HDC _hdc,const char *name,int size,int weight,int quality,
             BOOL italic,BOOL underline,BOOL strikeout,DWORD charset)
{
  hdc = _hdc;
  font = CreateFont(size,0,0,0,weight,italic,underline,strikeout,charset,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,quality,DEFAULT_PITCH,name);
  old_font = (HFONT)SelectObject(hdc,font);

  old_bkmode = ::GetBkMode(hdc);
  old_bkcolor = ::GetBkColor(hdc);
  old_textcolor = ::GetTextColor(hdc);
}


CFont::~CFont()
{
  ::SetTextColor(hdc,old_textcolor);
  ::SetBkColor(hdc,old_bkcolor);
  ::SetBkMode(hdc,old_bkmode);
  
  SelectObject(hdc,old_font);

  if ( font )
     DeleteObject(font);

  hdc = NULL;
  old_font = NULL;
  font = NULL;
}


void CFont::SetBkMode(int mode)
{
  ::SetBkMode(hdc,mode);
}


void CFont::SetBkColor(int color)
{
  ::SetBkColor(hdc,color);
}


void CFont::SetTextColor(int color)
{
  ::SetTextColor(hdc,color);
}


int CFont::DrawText(const char *text,RECT &r,UINT format)
{
  if ( !text || !text[0] )
     return 0;

  return ::DrawText(hdc,text,-1,&r,format);
}



