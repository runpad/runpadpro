


#define FREEANDNULL(x)   { if (x) free(x); x = NULL; }
#define SAFERELEASE(obj)   { if ( obj ) obj->Release(); obj = NULL; }
#define SAFEDELETE(obj)   { if ( obj ) delete obj; obj = NULL; }



char *sys_copystring(const char *_src,int max=0);
BOOL IsFileExist(const char *s);
BOOL SearchParam(const char *s);
BOOL IsStrEmpty(const char *s);
void Err(const char *s);
BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data);
BOOL DeleteRegValue(HKEY root,const char *key,const char *value);
BOOL ReadTrimmedStringFromIniFile(const char *filename,const char *key,const char *value,char *out);
void StrReplaceI(char *str,const char *name,const char *value);
void MessageLoop(void);

