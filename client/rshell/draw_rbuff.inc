


CRBuff::CRBuff(int _w,int _h,int _bpp,BOOL _clear)
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


CRBuff::~CRBuff()
{
  if ( hdc )
     SelectObject(hdc,old_bitmap);
  if ( hdc )
     DeleteDC(hdc);
  if ( bitmap )
     DeleteObject(bitmap);

  ClearVars();
}


void CRBuff::ClearVars()
{
  hdc = NULL;
  bitmap = NULL;
  old_bitmap = NULL;
  buff = NULL;
  width = 0;
  height = 0;
  bpp = 0;
}


void CRBuff::Clear(int _color)
{
  if ( hdc )
     {
       HBRUSH brush = CreateSolidBrush(_color);
       RECT r;
       SetRect(&r,0,0,GetWidth(),GetHeight());
       FillRect(hdc,&r,brush);
       DeleteObject(brush);
     }
}


BOOL CRBuff::CopyRawDataFrom(const void *_buff,unsigned _size)
{
  BOOL rc = FALSE;
  
  if ( buff && _buff )
     {
       if ( _size >= GetDataSize() )
          {
            //CopyMemory(buff,_buff,GetDataSize());

            // we must copy all except padding bytes, because this memory can be not accessible
            // if stored in video memory (only for DShow)

            for ( int n = 0; n < GetHeight(); n++ )
                {
                  char *dest = (char*)GetBuff() + n * GetRowStride();
                  const char *src = (const char*)_buff + n * GetRowStride();

                  if ( dest != src )
                     CopyMemory(dest,src,GetWidth()*(GetBPP()/8));
                }
            
            rc = TRUE;
          }
     }

  return rc;
}


BOOL CRBuff::PaintTo(HDC d_hdc,int d_x,int d_y)
{
  BOOL rc = FALSE;
  
  if ( hdc && d_hdc )
     {
       if ( hdc == d_hdc )
          {
            rc = TRUE;
          }
       else
          {
            rc = BitBlt(d_hdc,d_x,d_y,GetWidth(),GetHeight(),hdc,0,0,SRCCOPY);
          }
     }

  return rc;
}


CRBuff* CRBuff::CreateCopy()
{
  CRBuff *d = new CRBuff(width,height,bpp,TRUE);

  PaintTo(d->GetHDC(),0,0);

  return d;
}


// for BWC only
void CRBuff::FillRBuffStruct(RBUFF *i)
{
  if ( i )
     {
       i->grayscale = (GetBPP()==8);
       i->w = GetWidth();
       i->h = GetHeight();
       i->bits = GetBuff();
       i->bitmap = GetBitmap();
       i->old_bitmap = NULL;
       i->hdc = GetHDC();
     }
}


HBITMAP CRBuff::ReleaseBitmap()
{
  HBITMAP rc = bitmap;

  if ( hdc )
     SelectObject(hdc,old_bitmap);
  if ( hdc )
     DeleteDC(hdc);

  ClearVars();

  return rc;
}



