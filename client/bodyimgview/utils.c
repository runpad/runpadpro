
#include <windows.h>
#include <shlwapi.h>



void sys_memzero(void *buff,int size)
{
  ZeroMemory(buff,size);
}


void sys_memset(void *buff,int b,int size)
{
  FillMemory(buff,size,b);
}


void sys_memcpy(void *dest,void *src,int size)
{
  CopyMemory(dest,src,size);
}


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


void *sys_fopen(char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void *sys_fcreate(char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void sys_fclose(void *h)
{
  CloseHandle(h);
}


int sys_fread(void *h,void *buff,int len)
{
  DWORD rc = 0;
  
  ReadFile(h,buff,len,&rc,NULL);
  return rc;
}


int sys_fwrite(void *h,void *buff,int len)
{
  DWORD rc = 0;
  
  WriteFile(h,buff,len,&rc,NULL);
  return rc;
}


int sys_fsize(void *h)
{
  return GetFileSize(h,NULL);
}


void sys_fseek(void *h,int pos)
{
  SetFilePointer(h,pos,NULL,FILE_BEGIN);
}


int sys_clock(void)
{
  return GetTickCount();
}


BOOL FileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


void GetDirFromPath(char *path,char *dir)
{
  if ( dir != path )
     lstrcpy(dir,path);

  PathRemoveFileSpec(dir);
  PathAddBackslash(dir);
}
