
#include "include.h"



BOOL IsVista(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion > 5 )
          return TRUE;
     }

  return FALSE;
}


BOOL IsOurServiceActive()
{
  HANDLE h = OpenMutex(SYNCHRONIZE,FALSE,"Global\\RunpadProShellServiceMutex");
  if ( h )
     CloseHandle(h);

  return h != NULL;
}


BOOL AASendCmd(const char *buff,int len)
{
  BOOL exit_code = FALSE;

  if ( !IsOurServiceActive() )
     return exit_code;

  unsigned starttime = GetTickCount();

  do {
    char recv_buff[MAX_PATH];

    recv_buff[0] = 0;
    DWORD recv_bytes = 0;
    BOOL rc = CallNamedPipe("\\\\.\\pipe\\RunpadProShellServicePipe",(LPVOID)buff,len,recv_buff,sizeof(recv_buff),&recv_bytes,2000);
    if ( !rc )
       {
         int err = GetLastError();
         if ( err == ERROR_FILE_NOT_FOUND || err == ERROR_PIPE_BUSY )
            {
              Sleep(10);
            }
         else
            {
              break;
            }
       }
    else
       {
         exit_code = !lstrcmpi(recv_buff,"OK");
         break;
       }

  } while ( GetTickCount() - starttime < 3000 );

  return exit_code;
}


BOOL AACreateTextFile(const char *filepath,const char *data)
{
  BOOL rc = FALSE;

  if ( !IsStrEmpty(filepath) )
     {
       if ( !data )
          {
            data = "";
          }

       const char *cmd = "CreateTextFile";
     
       char *buff = (char*)malloc(strlen(cmd)+1+strlen(filepath)+1+strlen(data)+1+1);

       char *t = buff;
       strcpy(t,cmd);
       t += strlen(t)+1;
       strcpy(t,filepath);
       t += strlen(t)+1;
       strcpy(t,data);
       t += strlen(t)+1;
       *t++ = 0; // terminator

       rc = AASendCmd(buff,t-buff);

       free(buff);
     }

  return rc;
}


BOOL StdCreateTextFile(const char *filepath,const char *data)
{
  BOOL rc = FALSE;

  if ( !IsStrEmpty(filepath) )
     {
       if ( !data )
          {
            data = "";
          }

       void *h = sys_fcreate(filepath);
       if ( h )
          {
            rc = (sys_fwrite(h,data,strlen(data)) == strlen(data));
            sys_fclose(h);
          }
     }

  return rc;
}


BOOL CreateTextFile(const char *filepath,const char *data)
{
  BOOL rc = FALSE;

  if ( !IsStrEmpty(filepath) )
     {
       if ( !data )
          {
            data = "";
          }

       rc = StdCreateTextFile(filepath,data);
       if ( !rc )
          {
            rc = AACreateTextFile(filepath,data);
          }
     }

  return rc;
}


BOOL ReadTextFile(const char *filepath,char *data,int max)
{
  BOOL rc = FALSE;
  
  void *h = sys_fopenr(filepath);
  if ( h )
     {
       int read_bytes = sys_fread(h,data,max-1);

       data[read_bytes] = 0;
       rc = TRUE;

       sys_fclose(h);
     }

  return rc;
}


void SpecialVistaProcessing()
{
  if ( IsVista() )
     {
       char user_name[MAX_PATH] = "";
       DWORD s_len = MAX_PATH;
       GetUserName(user_name,&s_len);

       char filepath[MAX_PATH] = "";
       GetSystemWindowsDirectory(filepath,sizeof(filepath));
       if ( IsStrEmpty(filepath) )
          {
            GetWindowsDirectory(filepath,sizeof(filepath));
          }

       if ( !IsStrEmpty(filepath) )
          {
            PathAppend(filepath,"asvshellenabler.ini");

            char t[MAX_PATH] = "";
            if ( !ReadTextFile(filepath,t,sizeof(t)) || strcmpi(t,user_name) )
               {
                 CreateTextFile(filepath,user_name);
               }
          }
     }
}


