
#ifndef __ICONSCACHE_H__
#define __ICONSCACHE_H__


class CIconsCache
{
  public:
          static void Get(const char *path1,const char *path2,int idx,int size1,int size2,HICON& _i1,HICON& _i2,BOOL *_is_net=NULL);

  private:
          static HICON GetSingleFromCache(const char *path1,const char *path2,int idx,int size);
          static void StoreSingleToCache(const char *path1,const char *path2,int idx,int size,HICON hicon);
          static unsigned GetHash(const char *path1,const char *path2,int idx,int size);
          static char* GetCacheDir(char *out,BOOL need_create);
          static char* GetIconFullPathName(const char *path1,const char *path2,int idx,int size,char *out,BOOL need_create_dir);
          static void* DecodeHIcon(HICON hicon,unsigned& _size);
          static HICON EncodeHIcon(const void *buff,unsigned size);

};


#endif
