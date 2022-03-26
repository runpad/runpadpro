
#ifndef __TOOLS_H__
#define __TOOLS_H__


#define MIN(a,b)  (((a)<(b))?(a):(b))
#define MAX(a,b)  (((a)>(b))?(a):(b))

#define NNS(str)   ((str)?(str):"")
#define NNSW(str)   ((str)?(str):L"")

#define FREEANDNULL(x)   { if (x) sys_free(x); x = NULL; }
#define SAFESYSFREE   FREEANDNULL
#define SAFERELEASE(obj)   { if ( obj ) obj->Release(); obj = NULL; }
#define SAFEDELETE(obj)   { if ( obj ) delete obj; obj = NULL; }


typedef double OURTIME;   // in delphi format


class CCSGuard
{
           CRITICAL_SECTION *p_cs;
  public:
           CCSGuard(const CRITICAL_SECTION &cs)
           {
             p_cs = (CRITICAL_SECTION*)&cs;
             EnterCriticalSection(p_cs);
           }

           ~CCSGuard()
           {
             LeaveCriticalSection(p_cs);
           }
};


BOOL IsStrEmpty(const char *s);
BOOL IsStrEmpty(const WCHAR *s);
void *sys_alloc(int size);
void *sys_realloc(void *buff,int newsize);
char *sys_copystring(const char *_src,int max=0);
WCHAR *sys_copystringW(const WCHAR *_src,int max=0);
char *sys_copystring_replace_empty_by_null(const char *_src,int max=0);
void *sys_zalloc(int size);
void sys_free(void *buff);
OURTIME GetNowOurTime();



#endif
