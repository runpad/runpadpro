
#include "include.h"



BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


BOOL IsStrEmpty(const WCHAR *s)
{
  return !s || !s[0];
}



void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void *sys_realloc(void *buff,int newsize)
{
  return HeapReAlloc(GetProcessHeap(),0,buff,newsize);
}


char *sys_copystring(const char *_src,int max)
{
  const char *src = _src ? _src : "";

  char *s = (char*)sys_alloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


WCHAR *sys_copystringW(const WCHAR *_src,int max)
{
  const WCHAR *src = _src ? _src : L"";

  WCHAR *s = (WCHAR*)sys_alloc((lstrlenW(src)+1)*sizeof(WCHAR));

  if ( !max )
     lstrcpyW(s,src);
  else
     lstrcpynW(s,src,max);

  return s;
}


char *sys_copystring_replace_empty_by_null(const char *_src,int max)
{
  const char *src = _src;

  if ( src && !src[0] )
     src = NULL;

  if ( src == NULL )
     return NULL;

  char *s = (char*)sys_alloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


void *sys_zalloc(int size)
{
  return HeapAlloc(GetProcessHeap(),HEAP_ZERO_MEMORY,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


OURTIME SystemTimeToOurTime(const SYSTEMTIME *st)
{
  double rc = 0.0;
  
  if ( st )
     {
       int i_year = st->wYear;
       int i_month = st->wMonth;
       int i_day = st->wDay;
       int i_hour = st->wHour;
       int i_min = st->wMinute;
       int i_sec = st->wSecond;
       int i_ms = st->wMilliseconds;

       const int n_year = 1899;
       const int n_month = 12;
       const int n_day = 30;
       const int n_hour = 0;
       const int n_min = 0;
       const int n_sec = 0;
       const int n_ms = 0;

       const SYSTEMTIME i_st = {i_year,i_month,0,i_day,i_hour,i_min,i_sec,i_ms};
       const SYSTEMTIME n_st = {n_year,n_month,0,n_day,n_hour,n_min,n_sec,n_ms};

       __int64 i_ft = 0, n_ft = 0;

       SystemTimeToFileTime(&i_st,(FILETIME*)&i_ft);
       SystemTimeToFileTime(&n_st,(FILETIME*)&n_ft);

       __int64 delta = i_ft - n_ft;

       rc = (double)delta/864000000000.0;
     }

  return rc;
}


OURTIME GetNowOurTime()
{
  SYSTEMTIME st;
  GetLocalTime(&st);

  return SystemTimeToOurTime(&st);
}


