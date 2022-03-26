
#include <windows.h>
#include <shlwapi.h>
#include <gdiplus.h>
#include "utils.h"


using namespace Gdiplus;

static ULONG_PTR gdiplus_token = 0;
static GdiplusStartupInput gdiplus_input; //here is default constructor present!



extern "C" void GDIP_Init()
{
  GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
}


extern "C" void GDIP_Done()
{
  GdiplusShutdown(gdiplus_token);
}


static const char *masks[] = { "*.bmp", "*.jpg", "*.jpeg", "*.jpe", "*.png", "*.gif", "*.tif", "*.tiff" };
static const int nummasks = sizeof(masks)/sizeof(masks[0]);
static int curpicmask = 0;


extern "C" void SetFirstMask()
{
  curpicmask = 0;
}


extern "C" const char* GetNextMask()
{
  if ( curpicmask<nummasks )
    return masks[curpicmask++];
  else
    return NULL;
}


static void MapBGR2RGB(const void *src,void *dest,int w,int h)
{
  if ( w && h )
     {
       const unsigned char *src24 = (const unsigned char *)src;
       unsigned char *dest24 = (unsigned char *)dest;
       int count = w*h;
       do {
        unsigned char r = *src24++;
        unsigned char g = *src24++;
        unsigned char b = *src24++;
        *dest24++ = b;
        *dest24++ = g;
        *dest24++ = r;
       } while(--count);
     }
}


extern "C" BOOL LoadPicFile(const char *filename,int *_width,int *_height,void **_buff)
{
  BOOL rc = FALSE;

  if ( _width )
     *_width = 0;
  if ( _height )
     *_height = 0;
  if ( _buff )
     *_buff = NULL;
  
  WCHAR wsz[MAX_PATH] = L"";
  MultiByteToWideChar(CP_ACP,0,filename?filename:"",-1,wsz,MAX_PATH);

  Bitmap *pBitmap = new Bitmap(wsz);

  if ( pBitmap->GetLastStatus() == Ok )
     {
       int pic_w = pBitmap->GetWidth();
       int pic_h = pBitmap->GetHeight();

       if ( pic_w > 0 && pic_h > 0 )
          {
            BitmapData bd;
            bd.Width = pic_w;
            bd.Height = pic_h;
            bd.Stride = pic_w*3+0;
            bd.PixelFormat = PixelFormat24bppRGB;
            bd.Scan0 = sys_alloc(bd.Stride*bd.Height);
            bd.Reserved = 0;
            
            if ( pBitmap->LockBits(&Rect(0,0,pic_w,pic_h),ImageLockModeRead|ImageLockModeUserInputBuf,PixelFormat24bppRGB,&bd) == Ok )
               {
                 pBitmap->UnlockBits(&bd);

                 MapBGR2RGB(bd.Scan0,bd.Scan0,pic_w,pic_h);

                 if ( _width )
                    *_width = pic_w;
                 if ( _height )
                    *_height = pic_h;
                 if ( _buff )
                    *_buff = bd.Scan0;
                 bd.Scan0 = NULL; //paranoja
                 rc = TRUE;
               }
            else
               {
                 sys_free(bd.Scan0);
                 bd.Scan0 = NULL; //paranoja
               }
          }
     }

  delete pBitmap;

  return rc;
}



static const struct {
const char *ext;
const WCHAR *mime;
} mimes[] = 
{
  { ".bmp"   , L"image/bmp"  },
  { ".jpg"   , L"image/jpeg" },
  { ".jpe"   , L"image/jpeg" },
  { ".jpeg"  , L"image/jpeg" },
  { ".png"   , L"image/png"  },
  { ".gif"   , L"image/gif"  },
  { ".tif"   , L"image/tiff" },
  { ".tiff"  , L"image/tiff" },
};


static const WCHAR *GetMime(const char *filename)
{
  if ( !filename )
     return NULL;

  const char *ext = PathFindExtension(filename);
  
  for ( int n = 0; n < sizeof(mimes)/sizeof(mimes[0]); n++ )
      {
        if ( !lstrcmpi(mimes[n].ext,ext) )
           {
             return mimes[n].mime;
           }
      }

  return NULL;
}


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


typedef struct {
unsigned char b,g,r;
} BGR;

typedef struct {
unsigned char r,g,b;
} RGB;


static HBITMAP CreateBitmapFromRGB(int w,int h,const void *buff)
{
  if ( !w || !h || !buff )
     return NULL;

  const RGB *src = (const RGB*)buff;
  BGR *dest = NULL;

  BITMAPINFO bi;
  ZeroMemory(&bi.bmiHeader,sizeof(bi.bmiHeader));
  bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
  bi.bmiHeader.biWidth = w;
  bi.bmiHeader.biHeight = -h;
  bi.bmiHeader.biPlanes = 1;
  bi.bmiHeader.biBitCount = 24;
  HBITMAP bitmap = CreateDIBSection(NULL,&bi,DIB_RGB_COLORS,(void**)&dest,NULL,0);

  if ( bitmap )
     {
       int count = w*h;
       do {
        dest->b = src->b;
        dest->g = src->g;
        dest->r = src->r;
        dest++;
        src++;
       } while (--count);
     }

  return bitmap;
}


extern "C" BOOL SavePicFile(const char *filename,int width,int height,const void *buff)
{
  if ( !filename || !width || !height || !buff )
     return FALSE;

  const WCHAR *s_mime = GetMime(filename);

  if ( !s_mime )
     return FALSE;

  CLSID clsid;
  if ( !GetEncoderClsid(s_mime,&clsid) )
     return FALSE;

  HBITMAP hbitmap = CreateBitmapFromRGB(width,height,buff);
  if ( !hbitmap )
     return FALSE;

  Bitmap *img = new Bitmap(hbitmap,NULL);

  WCHAR wsz[MAX_PATH] = L"";
  MultiByteToWideChar(CP_ACP,0,filename?filename:"",-1,wsz,MAX_PATH);

  BOOL rc = (img->Save(wsz,&clsid) == Ok);

  delete img;

  DeleteObject(hbitmap);

  return rc;
}



extern "C" void FreePicFile(void *buff)
{
  if ( buff )
     {
       sys_free(buff);
     }
}


