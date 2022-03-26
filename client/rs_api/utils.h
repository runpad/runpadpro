
#ifndef _UTILS_H_
#define _UTILS_H_


HRESULT BOOL2HRESULT(BOOL b);
BOOL IsFileExist(const char *s);
BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data);
BOOL ActiveXRegister(const char *classid,const char *desc,const char *dll,const char *model);
BOOL ActiveXUnregister(const char *classid);


#endif //_UTILS_H_

