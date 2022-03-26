
#ifndef __TOOLS_H__
#define __TOOLS_H__


typedef std::wstring widestring;

#define SAFERELEASE(obj)  { if ( obj ) (obj)->Release(); (obj) = NULL; }
#define SAFEDELETE(obj)   { if ( obj ) delete (obj); (obj) = NULL; }
#define ASSERT     assert
#define NNS(str)   ((str)?(str):"")
#define NNSW(str)   ((str)?(str):L"")
#define STRSIZE(_s) (sizeof(_s)/sizeof(_s[0]))
#define IASSIGN(i1,i2) { SAFERELEASE(i1); if ( i2 ) { (i1) = (i2); (i1)->AddRef(); } }
#define IASSIGN2OUT(i1,i2) { (i1) = NULL; IASSIGN(i1,i2); }


BOOL IsStrEmpty(const char *s);
BOOL IsStrEmpty(const WCHAR *s);
BOOL IsStrEmpty(const widestring& s);



#endif

