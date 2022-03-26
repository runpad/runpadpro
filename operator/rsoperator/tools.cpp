
#include "include.h"



BOOL GetLocalFileInClientShellDir(const char *local,char *out)
{
  BOOL rc = FALSE;

  char s[MAX_PATH];
  ReadRegStr(HKLM,SHELL_REGPATH,"Install_Dir",s,"");

  if ( !IsStrEmpty(s) )
     {
       PathAppend(s,local);
       if ( IsFileExist(s) )
          {
            lstrcpy(out,s);
            rc = TRUE;
          }
     }

  return rc;
}


BOOL RunProcess(const char *cmdline,const char *cwd)
{
  BOOL rc = FALSE;

  char *s = (char*)sys_alloc(lstrlen(cmdline)+MAX_PATH); //paranoja
  lstrcpy(s,cmdline);
  
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,cwd,&si,&pi) )
     {
       CloseHandle(pi.hThread);
       CloseHandle(pi.hProcess);
       rc = TRUE;
     }

  sys_free(s);

  return rc;
}


void ScanDir(const char *path,int type,SCANDIRFUNC func,void *user)
{
  WIN32_FIND_DATA f;
  char s[MAX_PATH]; 
  HANDLE h;
  int rc,dir,file,hidden;

  lstrcpy(s,path);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  h = FindFirstFile(s,&f);
  rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         dir = (f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
         file = !dir;
         hidden = (f.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) || (f.dwFileAttributes & FILE_ATTRIBUTE_SYSTEM);

         if ( !hidden || (type & SCAN_HIDDEN) )
            {
              if ( ((type & SCAN_DIR) && dir) || ((type & SCAN_FILE) && file) )
                 {
                   lstrcpy(s,path);
                   PathAddBackslash(s);
                   lstrcat(s,f.cFileName);
                   if ( !func(s,&f,user) )
                      break;
                 }
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


char* GetLocalPath(const char *local,char *out)
{
  lstrcpy(out,our_currpath);
  PathAppend(out,local);
  return out;
}


ULARGE_INTEGER GetULValue(unsigned v)
{
  ULARGE_INTEGER out;
  out.QuadPart = v;
  return out;
}


LARGE_INTEGER GetILValue(int v)
{
  LARGE_INTEGER out;
  out.QuadPart = v;
  return out;
}

