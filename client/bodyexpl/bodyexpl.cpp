
#include <windows.h>
#include <shlwapi.h>
#include <gdiplus.h>
#include <stdlib.h>

using namespace Gdiplus;

#define EXPORT  extern "C" __declspec(dllexport)


static ULONG_PTR gdiplus_token = 0;
static GdiplusStartupInput gdiplus_input; //here is default constructor present!


class CUnicode
{
           WCHAR *s_out;

  public:
           CUnicode(const char *s,int locale=0);
           ~CUnicode();

           operator const WCHAR* () const { return s_out ? s_out : L""; }
           const WCHAR* Text() const { return s_out ? s_out : L""; }
};


CUnicode::CUnicode(const char *s,int locale)
{
  if ( s )
     {
       s_out = (WCHAR*)malloc((lstrlen(s)+1)*sizeof(WCHAR));
       s_out[0] = 0;

       if ( locale != 0 )
          {
            //todo: critical sections here...
            int old = GetThreadLocale();
            SetThreadLocale(locale);
            MultiByteToWideChar(CP_THREAD_ACP,0,s,-1,s_out,lstrlen(s)+1);
            SetThreadLocale(old);
          }
       else
          {
            MultiByteToWideChar(CP_ACP,0,s,-1,s_out,lstrlen(s)+1);
          }
     }
  else
     {
       s_out = NULL;
     }
}


CUnicode::~CUnicode()
{
  if ( s_out )
     {
       free(s_out);
     }
}


static Bitmap* LoadFromFile(const char *filename)
{
  BOOL rc = FALSE;
  
  Bitmap *img = new Bitmap(CUnicode(filename));

  if ( img->GetLastStatus() == Ok )
     {
       int w = img->GetWidth();
       int h = img->GetHeight();

       if ( w > 0 && h > 0 )
          {
            rc = TRUE;
          }
     }

  if ( !rc )
     {
       if ( img )
          delete img;
       img = NULL;
     }

  return img;
}


static BOOL IsOurFile(const char *s,const WCHAR **_fmt=NULL)
{
  BOOL rc = FALSE;

  if ( _fmt )
     *_fmt = L"";
  
  if ( s && s[0] )
     {
       static const struct {
        const char *ext;
        const WCHAR *fmt;
       } types[] =
       {
         {".jpg",  L"image/jpeg"},
         {".jpe",  L"image/jpeg"},
         {".jpeg", L"image/jpeg"},
         {".bmp",  L"image/bmp"},
         {".png",  L"image/png"},
         {".tif",  L"image/tiff"},
         {".tiff", L"image/tiff"},
         {".gif",  L"image/gif"},
       };
       
       const char *ext = PathFindExtension(s);

       for ( int n = 0; n < sizeof(types)/sizeof(types[0]); n++ )
           {
             if ( !lstrcmpi(ext,types[n].ext) )
                {
                  if ( _fmt )
                     *_fmt = types[n].fmt;
                  
                  rc = TRUE;
                  break;
                }
           }
     }

  return rc;
}


static BOOL GetEncoderClsid(const WCHAR* format, CLSID* pClsid)
{
  UINT num = 0;          // number of image encoders
  UINT size = 0;         // size of the image encoder array in bytes

  ImageCodecInfo* pImageCodecInfo = NULL;

  GetImageEncodersSize(&num, &size);
  if ( size == 0 )
     return FALSE;

  pImageCodecInfo = (ImageCodecInfo*)malloc(size);

  GetImageEncoders(num, size, pImageCodecInfo);

  for ( UINT j = 0; j < num; ++j )
      {
        if ( lstrcmpiW(pImageCodecInfo[j].MimeType, format) == 0 )
           {
             *pClsid = pImageCodecInfo[j].Clsid;
             free(pImageCodecInfo);
             return TRUE;
           }    
      }

  free(pImageCodecInfo);
  return FALSE;
}


static BOOL SaveToFile(Image *img,const char *filename)
{
  const WCHAR *format = L"";
  
  if ( !IsOurFile(filename,&format) )
     return FALSE;
  
  CLSID clsid;
  if ( !GetEncoderClsid(format,&clsid) )
     return FALSE;

  return img->Save(CUnicode(filename),&clsid) == Ok;
}


EXPORT void __cdecl GDIP_Init()
{
  GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
}


EXPORT void __cdecl GDIP_Done()
{
  GdiplusShutdown(gdiplus_token);
}


EXPORT BOOL __cdecl GDIP_IsSupportedFormat(const char *s)
{
  return IsOurFile(s);
}


EXPORT BOOL __cdecl GDIP_ConvertFile(const char *file_in,const char *file_out)
{
  BOOL rc = FALSE;
  
  if ( IsOurFile(file_out) )
     {
       Bitmap *b = LoadFromFile(file_in);
       if ( b )
          {
            if ( SaveToFile(b,file_out) )
               {
                 rc = TRUE;
               }

            delete b;
          }
     }

  return rc;
}


EXPORT BOOL __cdecl GDIP_RotateImage(BOOL ccw,const char *file_in,const char *file_out)
{
  BOOL rc = FALSE;
  
  if ( IsOurFile(file_out) )
     {
       Bitmap *b = LoadFromFile(file_in);
       if ( b )
          {
            b->RotateFlip(ccw?Rotate270FlipNone:Rotate90FlipNone);
            
            if ( SaveToFile(b,file_out) )
               {
                 rc = TRUE;
               }

            delete b;
          }
     }

  return rc;
}


EXPORT BOOL __cdecl GDIP_ReduceImage(int neww,int newh,const char *file_in,const char *file_out)
{
  BOOL rc = FALSE;
  
  if ( neww > 0 && newh > 0 )
     {
       if ( IsOurFile(file_out) )
          {
            Bitmap *b = LoadFromFile(file_in);
            if ( b )
               {
                 int oldw = b->GetWidth();
                 int oldh = b->GetHeight();

                 if ( (oldw > oldh && neww < newh) || (oldw < oldh && neww > newh) )
                    {
                      int t = neww;
                      neww = newh;
                      newh = t;
                    }

                 if ( oldw > neww && oldh > newh )
                    {
                      int w = neww;
                      int h = w * oldh / oldw;

                      Bitmap *pBitmap = new Bitmap(w,h,PixelFormat24bppRGB);
                      Graphics *pGraphics = new Graphics(pBitmap);

                      pGraphics->SetCompositingQuality(CompositingQualityHighQuality);
                      pGraphics->SetInterpolationMode(InterpolationModeHighQualityBicubic);
                      pGraphics->SetCompositingMode(CompositingModeSourceCopy);
                      pGraphics->DrawImage(b,0,0,w,h);
                      pGraphics->Flush(FlushIntentionSync);

                      delete pGraphics;
                      delete b;
                      b = pBitmap;
                    }
               
                 if ( SaveToFile(b,file_out) )
                    {
                      rc = TRUE;
                    }

                 delete b;
               }
          }
     }

  return rc;
}



