
#include <windows.h>
#include <shlwapi.h>
#include <shlobj.h>
#include <objbase.h>
#include "utils.h"


#define HKLM	HKEY_LOCAL_MACHINE
#define CLASSES "Software\\Classes\\"


HRESULT BOOL2HRESULT(BOOL b)
{
  return b ? S_OK : E_FAIL;
}


BOOL IsFileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_SZ,(const BYTE*)data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}


BOOL ActiveXRegister(const char *classid,const char *desc,const char *dll,const char *model)
{
  BOOL rc = TRUE;
  
  char s[MAX_PATH];
  lstrcpy(s,CLASSES "CLSID\\");
  lstrcat(s,classid);
  rc = WriteRegStr(HKLM,s,NULL,desc) ? rc : FALSE;
  lstrcat(s,"\\InprocServer32");
  rc = WriteRegStr(HKLM,s,NULL,dll) ? rc : FALSE;
  rc = WriteRegStr(HKLM,s,"ThreadingModel",model) ? rc : FALSE;

  return rc;
}


BOOL ActiveXUnregister(const char *classid)
{
  char s[MAX_PATH];
  lstrcpy(s,CLASSES "CLSID\\");
  lstrcat(s,classid);
  DWORD rc = SHDeleteKey(HKLM,s);
  return (rc == ERROR_SUCCESS || rc == ERROR_FILE_NOT_FOUND);
}
