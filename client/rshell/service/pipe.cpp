
#include "include.h"


#define MAX_PIPE_BUFF 4096


CPipeObj::CPipeObj()
{
  h_thread = CreateThread(NULL,0,ThreadProc,this,0,NULL);
  //SetThreadPriority(h_thread,THREAD_PRIORITY_IDLE);
}


CPipeObj::~CPipeObj()
{
  SmartThreadFinish(h_thread);
}


DWORD WINAPI CPipeObj::ThreadProc(LPVOID lpParameter)
{
  while ( 1 )
  {
    SECURITY_ATTRIBUTES sa;
    sa.nLength = sizeof(sa);
    sa.lpSecurityDescriptor = AllocateSDWithNoDACL();
    sa.bInheritHandle = FALSE;

    HANDLE h_pipe = CreateNamedPipe("\\\\.\\pipe\\RunpadProShellServicePipe",
                    PIPE_ACCESS_DUPLEX,
                    PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT,
                    PIPE_UNLIMITED_INSTANCES,
                    MAX_PIPE_BUFF,MAX_PIPE_BUFF,
                    NMPWAIT_USE_DEFAULT_WAIT,
                    &sa);

    FreeSD(sa.lpSecurityDescriptor);

    if ( h_pipe != INVALID_HANDLE_VALUE )
       {
         BOOL rc = ConnectNamedPipe(h_pipe,NULL);
         if ( !rc && GetLastError() == ERROR_PIPE_CONNECTED )
            {
              rc = TRUE;
            }

         if ( rc )
            {
              HANDLE h_commthread = CreateThread(NULL,0,CommThreadProc,h_pipe,0,NULL);
              CloseHandle(h_commthread);
            }
         else
            {
              CloseHandle(h_pipe);
              Sleep(30); //paranoja
            }
       }
    else
       {
         break;
       }
  };

  return 1;
}


DWORD WINAPI CPipeObj::CommThreadProc(LPVOID lpParameter)
{
  HANDLE h_pipe = (HANDLE)lpParameter;

  if ( 1/*h_pipe*/ )
     {
       while ( 1 )
       {
         char buff[MAX_PIPE_BUFF];

         ZeroMemory(buff,sizeof(buff));
         DWORD read_bytes = 0;
         if ( !ReadFile(h_pipe,buff,sizeof(buff)-8,&read_bytes,NULL) )
            break;
         
         const char *answer = ProcessPipeMessage(buff) ? "OK" : "Failed";

         DWORD written_bytes = 0;
         if ( !WriteFile(h_pipe,answer,lstrlen(answer)+1,&written_bytes,NULL) || written_bytes != lstrlen(answer)+1 )
            break;
       };

       FlushFileBuffers(h_pipe);
       DisconnectNamedPipe(h_pipe);
       CloseHandle(h_pipe);
     }

  return 1;
}


enum {
CMD_NONE,
CMD_WRITEREGSTR,
CMD_WRITEREGSTR64,
CMD_WRITEREGMULTISTR,
CMD_WRITEREGDWORD,
CMD_DELETEREGVALUE,
CMD_DELETEREGVALUE64,
CMD_DELETEREGKEY,
CMD_CREATETXTFILE,
};


BOOL CPipeObj::ProcessPipeMessage(const char *zbuff)
{
  BOOL rc = FALSE;
  const char *p = zbuff;

  const char *s_cmd = p; 
  p += lstrlen(p)+1;
  int cmd = CMD_NONE;
  if ( !lstrcmpi(s_cmd,"WriteRegMultiStr") )
     {
       cmd = CMD_WRITEREGMULTISTR;
     }
  else
  if ( !lstrcmpi(s_cmd,"WriteRegStr") )
     {
       cmd = CMD_WRITEREGSTR;
     }
  else
  if ( !lstrcmpi(s_cmd,"WriteRegStr64") )
     {
       cmd = CMD_WRITEREGSTR64;
     }
  else
  if ( !lstrcmpi(s_cmd,"WriteRegDword") )
     {
       cmd = CMD_WRITEREGDWORD;
     }
  else
  if ( !lstrcmpi(s_cmd,"DeleteRegValue") )
     {
       cmd = CMD_DELETEREGVALUE;
     }
  else
  if ( !lstrcmpi(s_cmd,"DeleteRegValue64") )
     {
       cmd = CMD_DELETEREGVALUE64;
     }
  else
  if ( !lstrcmpi(s_cmd,"DeleteRegKey") )
     {
       cmd = CMD_DELETEREGKEY;
     }
  else
  if ( !lstrcmpi(s_cmd,"CreateTextFile") )
     {
       cmd = CMD_CREATETXTFILE;
     }
  else
     {
       return rc;
     }

  if ( cmd == CMD_CREATETXTFILE )
     {
       CDisableWOW64FSRedirection fs_guard;
       
       const char *s_filepath = p;
       p += lstrlen(p)+1;

       if ( IsStrEmpty(s_filepath) )
          {
            return rc;
          }

       char path[MAX_PATH];
       lstrcpyn(path,s_filepath,sizeof(path));
       PathRemoveFileSpec(path);

       if ( IsStrEmpty(path) )
          {
            return rc;
          }

       if ( !IsFileExist(path) )
          {
            SHCreateDirectoryEx(NULL,path,NULL);
          }

       void *h = sys_fcreate(s_filepath);
       if ( h )
          {
            const char *s_data = p;
            
            rc = (sys_fwrite(h,s_data,lstrlen(s_data)) == lstrlen(s_data));

            sys_fclose(h);
          }
     }
  else
     {
       const char *s_root = p; 
       p += lstrlen(p)+1;
       HKEY root = NULL;
       if ( !lstrcmpi(s_root,"HKLM") )
          {
            root = HKEY_LOCAL_MACHINE;
          }
       else
       if ( !lstrcmpi(s_root,"HKU") )
          {
            root = HKEY_USERS;
          }
       else
          {
            return rc;
          }

       const char *s_key = p; 
       p += lstrlen(p)+1;
       if ( !s_key[0] )
          return rc;

       const char *s_value = p; 
       p += lstrlen(p)+1;
       
       const char *s_data = p; 
       //p += lstrlen(p)+1;

       switch ( cmd )
       {
         case CMD_WRITEREGMULTISTR:
                               {
                                 if ( !s_value[0] )
                                    s_value = NULL;

                                 const char *p = s_data;
                                 do {
                                  p += lstrlen(p) + 1;
                                 } while (*p);
                                 p++;
                                 
                                 rc = WriteRegMultiStr(root,s_key,s_value,s_data,p-s_data);
                               }
                               break;
         
         case CMD_WRITEREGSTR:
                               if ( !s_value[0] )
                                  s_value = NULL;
                               rc = WriteRegStr(root,s_key,s_value,s_data);
                               break;

         case CMD_WRITEREGSTR64:
                               if ( !s_value[0] )
                                  s_value = NULL;
                               rc = WriteRegStr64(root,s_key,s_value,s_data);
                               break;

         case CMD_WRITEREGDWORD:
                               if ( !s_value[0] )
                                  s_value = NULL;
                               rc = WriteRegDword(root,s_key,s_value,StrToInt(s_data));
                               break;

         case CMD_DELETEREGVALUE:
                               if ( !s_value[0] )
                                  s_value = NULL;
                               rc = DeleteRegValue(root,s_key,s_value);
                               break;

         case CMD_DELETEREGVALUE64:
                               if ( !s_value[0] )
                                  s_value = NULL;
                               rc = DeleteRegValue64(root,s_key,s_value);
                               break;

         case CMD_DELETEREGKEY:
                               rc = DeleteRegKey(root,s_key);
                               break;
       };
     }

  return rc;
}

