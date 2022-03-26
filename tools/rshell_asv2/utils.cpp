
#include "include.h"




char *sys_copystring(const char *_src,int max)
{
  const char *src = _src ? _src : "";

  char *s = (char*)malloc(lstrlen(src)+1);

  if ( !max )
     lstrcpy(s,src);
  else
     lstrcpyn(s,src,max);

  return s;
}


BOOL IsFileExist(const char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


BOOL SearchParam(const char *s)
{
  for ( int n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],s) )
         return TRUE;

  return FALSE;
}


BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


void Err(const char *s)
{
  MessageBox(NULL,s,NULL,MB_OK | MB_ICONERROR | MB_TOPMOST);
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


BOOL DeleteRegValue(HKEY root,const char *key,const char *value)
{
  BOOL rc = FALSE;

  HKEY h = NULL;
  DWORD err = RegOpenKeyEx(root,key,0,KEY_WRITE,&h);

  if ( err == ERROR_SUCCESS )
     {
       DWORD err = RegDeleteValue(h,value);
       if ( err == ERROR_SUCCESS || err == ERROR_FILE_NOT_FOUND )
          rc = TRUE;
       RegCloseKey(h);
     }
  else
  if ( err == ERROR_FILE_NOT_FOUND )
     {
       rc = TRUE;
     }

  return rc;
}


BOOL ReadTrimmedStringFromIniFile(const char *filename,const char *key,const char *value,char *out)
{
  BOOL rc = FALSE;

  if ( !out )
     return rc;
  
  out[0] = 0;

  if ( !IsStrEmpty(filename) && !IsStrEmpty(key) && !IsStrEmpty(value) )
     {
       const char *random_str = "{42E8F662-0ADC-4434-B7A1-2506201E0BEC}";
       GetPrivateProfileString(key,value,random_str,out,MAX_PATH,filename);

       if ( lstrcmpi(out,random_str) )
          {
            PathRemoveBlanks(out);
            rc = TRUE;
          }
       else
          {
            out[0] = 0;
          }
     }

  return rc;
}


// str,name,value must be not exceeded MAX_PATH!
void StrReplaceI(char *str,const char *name,const char *value)
{
  if ( IsStrEmpty(str) || IsStrEmpty(name) || !value )
     return;

  if ( lstrlen(str) >= MAX_PATH || lstrlen(name) >= MAX_PATH || lstrlen(value) >= MAX_PATH )
     return;

  if ( !lstrcmpi(name,value) )
     return;
     
  if ( !IsStrEmpty(value) && StrStrI(value,name) )
     return;

  do {

   char *p = StrStrI(str,name);
   if ( p )
      {
        char s[MAX_PATH*2+10] = "";

        lstrcpyn(s,str,p-str+1);
        lstrcat(s,value);
        lstrcat(s,p+lstrlen(name));
        lstrcpyn(str,s,MAX_PATH-1);
      }
   else
      break;

  } while (1);
}


void MessageLoop(void)
{
  MSG msg;

  while ( GetMessage(&msg,NULL,0,0) )
  {
    DispatchMessage(&msg);
  }
}


void *sys_fopenr(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void *sys_fcreate(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ|GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
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


int sys_fwrite(void *h,const void *buff,int len)
{
  DWORD rc = 0;
  
  WriteFile(h,buff,len,&rc,NULL);
  return rc;
}


int sys_fsize(void *h)
{
  return GetFileSize(h,NULL);
}
