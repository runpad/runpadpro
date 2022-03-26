
#include <windows.h>
#include "utils.h"


void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)&data,&len);
       RegCloseKey(h);
     }

  return data;
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


BOOL WriteRegDword(HKEY root,const char *key,const char *value,DWORD data)
{
  HKEY h;
  BOOL rc = FALSE;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_DWORD,(const BYTE *)&data,4) == ERROR_SUCCESS )
          rc = TRUE;
       RegCloseKey(h);
     }

  return rc;
}
