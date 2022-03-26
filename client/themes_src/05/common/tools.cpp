
#include "common.h"



BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


const void* LoadRawResource(HINSTANCE inst,int id,int *_size)
{
  HRSRC res = FindResource(inst,MAKEINTRESOURCE(id),RT_RCDATA);
  if ( res )
     {
       HGLOBAL g = LoadResource(inst,res);
       if ( g )
          {
            if ( _size )
               *_size = SizeofResource(inst,res);
   
            return LockResource(g);
          }
     }

  if ( _size )
     *_size = 0;

  return NULL;
}


IStream* CreateStreamFromResource(HINSTANCE inst,int res_id)
{
  IStream *stream = NULL;

  int size = 0;
  const void *buff = LoadRawResource(inst,res_id,&size);

  if ( buff && size > 0 )
     {
       if ( CreateStreamOnHGlobal(NULL,TRUE,&stream) == S_OK )
          {
            ULARGE_INTEGER u_zero; u_zero.QuadPart = 0;
            LARGE_INTEGER i_zero; i_zero.QuadPart = 0;
            stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
            stream->SetSize(u_zero);
            stream->Write(buff,size,NULL);
            stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
          }
     }

  return stream;
}


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


HBITMAP LoadPicFromResource(HINSTANCE inst,int res_id)
{
  HBITMAP hbitmap = NULL;
  
  IStream *stream = CreateStreamFromResource(inst,res_id);
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


char *sys_copystring(const char *_src,int max)
{
  const char *src = _src ? _src : "";

  char *s = (char*)malloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


void GetBitmapDim(HBITMAP bitmap,int &_w,int &_h)
{
  BITMAP binfo;

  ZeroMemory(&binfo,sizeof(binfo));
  
  GetObject(bitmap,sizeof(binfo),&binfo);
  int iw = binfo.bmWidth;
  int ih = binfo.bmHeight;
  if ( ih < 0 )
     ih = -ih;

  _w = iw;
  _h = ih;
}


void ProcessExclRgnOperation(HRGN excl,int width,int height,RGNOPFUNC func,void *parm)
{
  if ( width > 0 && height > 0 && func )
     {
       RGNDATA *rdata = NULL;
       
       if ( excl )
          {
            DWORD alloc_size = GetRegionData(excl,0,NULL);
            if ( alloc_size > 0 )
               {
                 rdata = (RGNDATA*)malloc(alloc_size);
                 if ( rdata )
                    {
                      if ( GetRegionData(excl,alloc_size,rdata) != alloc_size )
                         {
                           free(rdata);
                           rdata = NULL;
                         }
                    }
               }
          }

       int excl_count = rdata ? rdata->rdh.nCount : 0;   
       RECT *excl_ar = rdata ? (RECT*)rdata->Buffer : NULL;

       if ( excl_count == 0 )
          excl_ar = NULL;
       if ( excl_ar == NULL )
          excl_count = 0;

       // make intersections
       for ( int n = 0; n < excl_count; n++ )
           {
             const RECT r_bound = {0,0,width,height};
             RECT r = {0,0,0,0};
             IntersectRect(&r,&excl_ar[n],&r_bound);
             CopyRect(&excl_ar[n],&r);
           }

       // outer loop by Y
       for ( int m = 0; m < height; m++ )
           {
             int start_x = 0;

             for ( int n = 0; n < excl_count; n++ )
                 {
                   RECT &r = excl_ar[n];
                   if ( !IsRectEmpty(&r) )
                      {
                        if ( m >= r.top && m < r.bottom )
                           {
                             int count = r.left - start_x;
                             if ( count > 0 )
                                func(start_x,m,count,parm);

                             start_x = r.right;
                           }
                      }
                 }

             int count = width - start_x;
             if ( count > 0 )
                func(start_x,m,count,parm);
           }

       FREEANDNULL(rdata);
     }
}



static const char *prop_name = "this_class_pointer";


void CWindowProc::InitWindowProcWrapper(HWND hwnd)
{
  SetProp(hwnd,prop_name,(HANDLE)this);
}


void CWindowProc::DoneWindowProcWrapper(HWND hwnd)
{
  RemoveProp(hwnd,prop_name);
}


LRESULT CALLBACK CWindowProc::WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  CWindowProc *obj = (CWindowProc*)GetProp(hwnd,prop_name);

  if ( obj )
     {
       return obj->WindowProc(hwnd,message,wParam,lParam);
     }
  else
     {
       return DefWindowProc(hwnd,message,wParam,lParam);
     }
}


void StrReplaceI(std::string &str,const char *find,const char *value)
{
  if ( str.empty() || IsStrEmpty(find) )
     return;

  if ( !value )
     value = "";

  if ( !lstrcmpi(find,value) )
     return;

  if ( !IsStrEmpty(value) && StrStrI(value,find) )
     return;

  do {
    const char *begin = str.c_str();
    const char *c = StrStrI(begin,find);
    if ( !c )
       break;

    str.replace(c-begin,lstrlen(find),value);

  } while (1);
}


void RemoveHTMLTags(const char *src,char *dest,int max)
{
  if ( dest && max > 0 )
     {
       dest[0] = 0;

       if ( !IsStrEmpty(src) )
          {
            std::string str(src);

            // replace known tags
            StrReplaceI(str,"\r","");
            StrReplaceI(str,"\n"," ");
            StrReplaceI(str,"<br>","\n");
            StrReplaceI(str,"<div>","\n\n");
            StrReplaceI(str,"</div>","\n\n");
            StrReplaceI(str,"<p>","\n");
            StrReplaceI(str,"</p>","\n");
            StrReplaceI(str,"\n ","\n");
            StrReplaceI(str,"  "," ");

            // remove other tags
            do {

             size_t pos1 = str.find('<');
             if ( pos1 == std::string::npos )
                break;

             size_t pos2 = str.find('>',pos1);
             if ( pos2 == std::string::npos )
                break;

             str.replace(pos1,pos2-pos1+1,"");
             
            } while (1);
            
            // replace rest HTML-specs
            StrReplaceI(str,"&lt;","<");
            StrReplaceI(str,"&gt;",">");
            StrReplaceI(str,"&amp;","&");
            StrReplaceI(str,"&nbsp;"," ");
            StrReplaceI(str,"&copy;","(c)");

            // copy to dest
            lstrcpyn(dest,str.c_str(),max);
          }
     }
}




