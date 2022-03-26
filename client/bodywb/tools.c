
#include <windows.h>


void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,data,&len) == ERROR_SUCCESS )
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
       RegQueryValueEx(h,value,NULL,NULL,(void *)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


int WriteRegDword(HKEY root, const char *key, const char *value, int data)
{
  HKEY h;
  int rc = -1;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_DWORD,(LPBYTE)&data,sizeof(data)) == ERROR_SUCCESS )
          rc = 0;
       RegCloseKey(h);
     }

  return rc;
}


