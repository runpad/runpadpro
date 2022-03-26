
#ifndef __TOOLS_H__
#define __TOOLS_H__



class CUnicode
{
           WCHAR *s_out;

  public:
           CUnicode(const char *s,int locale=0);
           ~CUnicode();

           operator const WCHAR* () const { return s_out ? s_out : L""; }
           const WCHAR* Text() const { return s_out ? s_out : L""; }
};


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


class CWindowProc
{
  protected:
            void InitWindowProcWrapper(HWND hwnd);
            void DoneWindowProcWrapper(HWND hwnd);

            static LRESULT CALLBACK WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
            virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam) = 0;
};


#define MIN(a,b)   ((a)<(b)?(a):(b))
#define MAX(a,b)   ((a)>(b)?(a):(b))
#define ABS(x)     ((x)>0?(x):-(x))
#define FREEANDNULL(x)   { if (x) free(x); x = NULL; }
#define SAFEDELETE(obj)   { if ( obj ) delete obj; obj = NULL; }
#define ASSERT     assert
#define NNS(str)   ((str)?(str):"")


typedef void (*RGNOPFUNC)(int x,int y,int count,void *parm);

BOOL IsStrEmpty(const char *s);
const void* LoadRawResource(HINSTANCE inst,int id,int *_size);
IStream* CreateStreamFromResource(HINSTANCE inst,int res_id);
HBITMAP LoadPicAsHBitmap(const char *filename);
HBITMAP LoadPicFromResource(HINSTANCE inst,int res_id);
char *sys_copystring(const char *_src,int max=0);
void GetBitmapDim(HBITMAP bitmap,int &_w,int &_h);
void ProcessExclRgnOperation(HRGN excl,int width,int height,RGNOPFUNC func,void *parm);
void StrReplaceI(std::string &str,const char *find,const char *value);
void RemoveHTMLTags(const char *src,char *dest,int max);


#endif

