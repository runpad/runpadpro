

HBITMAP LoadPicAsHBitmap(const char *filename)
{
  HBITMAP hbitmap = NULL;
  
  Bitmap *img = new Bitmap(CUnicode(filename));

  if ( img->GetLastStatus() == Ok )
     {
       img->GetHBITMAP(Color(),&hbitmap);
     }

  delete img;

  return hbitmap;
}



HBITMAP LoadPicFromResource(int res_id)
{
  HBITMAP hbitmap = NULL;
  
  IStream *stream = CreateStreamFromResource(res_id);
  if ( stream )
     {
       Bitmap *pBitmap = new Bitmap(stream);

       if ( pBitmap->GetLastStatus() == Ok )
          {
            pBitmap->GetHBITMAP(Color(),&hbitmap);
          }

       delete pBitmap;

       stream->Release();
     }

  return hbitmap;
}


/*
BOOL LoadPicAsRGB(const char *filename,int *_w,int *_h,void **_buff)
{
  BOOL rc = FALSE;
  
  if ( _w )
     *_w = 0;
  if ( _h )
     *_h = 0;
  if ( _buff )
     *_buff = NULL;

  if ( !IsStrEmpty(filename) )
     {
       Bitmap *img = new Bitmap(CUnicode(filename));

       if ( img->GetLastStatus() == Ok )
          {
            int w = img->GetWidth();
            int h = img->GetHeight();

            if ( w > 0 && h > 0 )
               {
                 BitmapData bd;
                 bd.Width = w;
                 bd.Height = h;
                 bd.Stride = w*3+0;
                 bd.PixelFormat = PixelFormat24bppRGB;
                 bd.Scan0 = sys_alloc(bd.Stride*bd.Height);
                 bd.Reserved = 0;
                 
                 if ( img->LockBits(&Rect(0,0,w,h),ImageLockModeRead|ImageLockModeUserInputBuf,PixelFormat24bppRGB,&bd) == Ok )
                    {
                      img->UnlockBits(&bd);

                      MapRGB2BGR(bd.Scan0,bd.Scan0,w,h);

                      if ( _w )
                         *_w = w;
                      if ( _h )
                         *_h = h;
                      if ( _buff )
                         *_buff = bd.Scan0;

                      bd.Scan0 = NULL;
                      rc = TRUE;
                    }
                 else
                    {
                      sys_free(bd.Scan0);
                      bd.Scan0 = NULL;
                    }
               }
          }

       delete img;
     }

  return rc;
}
*/

static BOOL GetEncoderClsid(const WCHAR* format, CLSID* pClsid)
{
  UINT num = 0;          // number of image encoders
  UINT size = 0;         // size of the image encoder array in bytes

  ImageCodecInfo* pImageCodecInfo = NULL;

  GetImageEncodersSize(&num, &size);
  if ( size == 0 )
     return FALSE;

  pImageCodecInfo = (ImageCodecInfo*)sys_alloc(size);

  GetImageEncoders(num, size, pImageCodecInfo);

  for ( UINT j = 0; j < num; ++j )
      {
        if ( lstrcmpiW(pImageCodecInfo[j].MimeType, format) == 0 )
           {
             *pClsid = pImageCodecInfo[j].Clsid;
             sys_free(pImageCodecInfo);
             return TRUE;
           }    
      }

  sys_free(pImageCodecInfo);
  return FALSE;
}


IStream* SaveImageToStream(Image *img,const WCHAR *format)
{
  if ( !img )
     return NULL;
  
  CLSID clsid;
  if ( !GetEncoderClsid(format,&clsid) )
     return NULL;

  IStream *stream = NULL;

  if ( CreateStreamOnHGlobal(NULL,TRUE,&stream) == S_OK )
     {
       ULARGE_INTEGER u_zero; u_zero.QuadPart = 0;
       LARGE_INTEGER i_zero; i_zero.QuadPart = 0;

       stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
       stream->SetSize(u_zero);
       
       if ( img->Save(stream,&clsid) == Ok )
          {
            stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
            return stream;
          }
       else
          {
            stream->Release();
          }
     }

  return NULL;
}


BOOL SaveImageToFile(Image *img,const WCHAR *format,const char *filename)
{
  if ( !img )
     return FALSE;
  
  CLSID clsid;
  if ( !GetEncoderClsid(format,&clsid) )
     return FALSE;

  return img->Save(CUnicode(filename),&clsid) == Ok;
}


BOOL IsPictureFile(const char *filename)
{
  BOOL rc = FALSE;
  
  if ( !IsStrEmpty(filename) )
     {
       const char *ext = PathFindExtension(filename);
       if ( !lstrcmpi(ext,".bmp") ||
            !lstrcmpi(ext,".jpg") ||
            !lstrcmpi(ext,".jpeg") ||
            !lstrcmpi(ext,".jpe") ||
            !lstrcmpi(ext,".png") ||
            !lstrcmpi(ext,".tif") ||
            !lstrcmpi(ext,".tiff") ||
            !lstrcmpi(ext,".gif") )
          {
            rc = TRUE;
          }
     }

  return rc;
}


BOOL IsPNGPictureFile(const char *filename)
{
  BOOL rc = FALSE;
  
  if ( !IsStrEmpty(filename) )
     {
       const char *ext = PathFindExtension(filename);
       if ( !lstrcmpi(ext,".png") )
          {
            rc = TRUE;
          }
     }

  return rc;
}

