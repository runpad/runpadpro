
#include "include.h"



void CIconsCache::Get(const char *path1,const char *path2,int idx,int size1,int size2,HICON& _i1,HICON& _i2,BOOL *_is_net)
{
  HICON i1 = GetSingleFromCache(path1,path2,idx,size1);
  HICON i2 = GetSingleFromCache(path1,path2,idx,size2);

  if ( i1 && i2 )
     {
       _i1 = i1;
       _i2 = i2;

       if ( _is_net )
          {
            *_is_net = FALSE;
          }
     }
  else
     {
       if ( i1 )
          {
            DestroyIcon(i1);
            i1 = NULL;
          }

       if ( i2 )
          {
            DestroyIcon(i2);
            i2 = NULL;
          }

       BOOL is_net = FALSE;
       BOOL is_default = FALSE;
       LoadFileIconsGuarant(path1,path2,idx,size1,size2,&i1,&i2,&is_net,is_default);

       if ( !is_default )
          {
            StoreSingleToCache(path1,path2,idx,size1,i1);
            StoreSingleToCache(path1,path2,idx,size2,i2);
          }

       _i1 = i1;
       _i2 = i2;

       if ( _is_net )
          {
            *_is_net = is_net;
          }
     }
}


HICON CIconsCache::GetSingleFromCache(const char *path1,const char *path2,int idx,int size)
{
  HICON hicon = NULL;
  
  char filename[MAX_PATH] = "";
  GetIconFullPathName(path1,path2,idx,size,filename,FALSE);

  int fsize = 0;
  void *fbuff = ReadFullFile(filename,&fsize);

  if ( fbuff && fsize )
     {
       hicon = EncodeHIcon(fbuff,fsize);
     }

  SAFESYSFREE(fbuff);

  return hicon;
}


void CIconsCache::StoreSingleToCache(const char *path1,const char *path2,int idx,int size,HICON hicon)
{
  if ( hicon )
     {
       unsigned fsize = 0;
       void *fbuff = DecodeHIcon(hicon,fsize);

       if ( fbuff && fsize )
          {
            char filename[MAX_PATH] = "";
            GetIconFullPathName(path1,path2,idx,size,filename,TRUE);
            WriteFullFile(filename,fbuff,fsize,0/*no sharing!*/);
          }

       SAFESYSFREE(fbuff);
     }
}


unsigned CIconsCache::GetHash(const char *path1,const char *path2,int idx,int size)
{
  char s[MAX_PATH*2];
  sprintf(s,"%s,%s,%d,%d",NNS(path1),NNS(path2),idx,size);
  CharLowerBuff(s,lstrlen(s));
  return CalculateHashBobJankins((const unsigned char*)s,lstrlen(s),12345);
}


char* CIconsCache::GetCacheDir(char *out,BOOL need_create)
{
  if ( out )
     {
       GetConfigCacheDir4AllUsers(out);
       PathAppend(out,"icons");
       PathAddBackslash(out);

       if ( need_create )
          {
            SHCreateDirectoryEx(NULL,out,NULL);
          }
     }

  return out;
}


char* CIconsCache::GetIconFullPathName(const char *path1,const char *path2,int idx,int size,char *out,BOOL need_create_dir)
{
  if ( out )
     {
       GetCacheDir(out,need_create_dir);

       unsigned hash = GetHash(path1,path2,idx,size);
       char filename[MAX_PATH];
       sprintf(filename,"%08X",hash);

       PathAppend(out,filename);
     }

  return out;
}


void* CIconsCache::DecodeHIcon(HICON hicon,unsigned& _size)
{
  void *buff = NULL;
  _size = 0;

  if ( hicon )
     {
       ICONINFO i;
       ZeroMemory(&i,sizeof(i));
       if ( GetIconInfo(hicon,&i) )
          {
            if ( i.hbmColor && i.hbmMask )
               {
                 BITMAP ic;
                 ZeroMemory(&ic,sizeof(ic));
                 BOOL resc = (GetObject((HGDIOBJ)i.hbmColor,sizeof(ic),&ic) > 0);

                 BITMAP im;
                 ZeroMemory(&im,sizeof(im));
                 BOOL resm = (GetObject((HGDIOBJ)i.hbmMask,sizeof(im),&im) > 0);

                 if ( resc && resm )
                    {
                      if ( ic.bmBitsPixel == 32 && im.bmBitsPixel == 1 )
                         {
                           if ( ic.bmWidth == ic.bmHeight && im.bmWidth == im.bmHeight && ic.bmWidth == im.bmWidth && ic.bmWidth > 0 && ic.bmWidthBytes > 0 && im.bmWidthBytes > 0 )
                              {
                                int dim = ic.bmWidth;
                                int crowstride = ic.bmWidthBytes;
                                int mrowstride = im.bmWidthBytes;
                                int cimagesize = dim * crowstride;
                                int mimagesize = dim * mrowstride;
                                int totalbuffsize = sizeof(int) + sizeof(int) + cimagesize + sizeof(int) + mimagesize;

                                buff = sys_alloc(totalbuffsize);
                                if ( buff )
                                   {
                                     char *dest = (char*)buff;

                                     *(int*)dest = dim; dest += sizeof(int);
                                     *(int*)dest = cimagesize; dest += sizeof(int);
                                     BOOL resc = (GetBitmapBits(i.hbmColor,cimagesize,dest) == cimagesize);
                                     dest += cimagesize;
                                     *(int*)dest = mimagesize; dest += sizeof(int);
                                     BOOL resm = (GetBitmapBits(i.hbmMask,mimagesize,dest) == mimagesize);
                                     dest += mimagesize;

                                     if ( resc && resm )
                                        {
                                          _size = totalbuffsize;
                                        }
                                     else
                                        {
                                          sys_free(buff);
                                          buff = NULL;
                                        }
                                   }
                              }
                         }
                    }
               }

            if ( i.hbmColor )
               DeleteObject(i.hbmColor);
            if ( i.hbmMask )
               DeleteObject(i.hbmMask);
          }
     }

  return buff;
}


HICON CIconsCache::EncodeHIcon(const void *buff,unsigned size)
{
  HICON hicon = NULL;

  if ( buff && size > sizeof(int)*3 )
     {
       const char *src = (const char*)buff;

       unsigned dim = *(unsigned*)src; src += sizeof(int); size -= sizeof(int);
       if ( dim == 16 || dim == 24 || dim == 32 || dim == 48 || dim == 64 || dim == 128 )
          {
            unsigned cimagesize = *(unsigned*)src; src += sizeof(int); size -= sizeof(int);
            if ( size > cimagesize )
               {
                 const void *cimagebuff = (const void*)src; src += cimagesize; size -= cimagesize;
                 if ( size >= sizeof(int) )
                    {
                      unsigned mimagesize = *(unsigned*)src; src += sizeof(int); size -= sizeof(int);
                      if ( size >= mimagesize )
                         {
                           const void *mimagebuff = (const void*)src; src += mimagesize; size -= mimagesize;

                           if ( cimagesize > 0 && mimagesize > 0 )
                              {
                                unsigned crowstride = cimagesize / dim;
                                unsigned mrowstride = mimagesize / dim;

                                if ( crowstride*dim == cimagesize && mrowstride*dim == mimagesize )
                                   {
                                     BITMAP ic = {0,dim,dim,crowstride,1,32,(LPVOID)cimagebuff};
                                     HBITMAP hbmc = CreateBitmapIndirect(&ic);
                                     BITMAP im = {0,dim,dim,mrowstride,1,1,(LPVOID)mimagebuff};
                                     HBITMAP hbmm = CreateBitmapIndirect(&im);

                                     if ( hbmc && hbmm )
                                        {
                                          ICONINFO i = {TRUE,0,0,hbmm,hbmc};
                                          hicon = CreateIconIndirect(&i);
                                        }

                                     if ( hbmc )
                                        DeleteObject(hbmc);
                                     if ( hbmm )
                                        DeleteObject(hbmm);
                                   }
                              }
                         }
                    }
               }
          }
     }

  return hicon;
}



