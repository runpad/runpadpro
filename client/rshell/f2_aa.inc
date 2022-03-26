


static BOOL AASendCmd(const char *buff,int len)
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


static char* AAPrepareBuff4RegCmd(int cmd,HKEY root,const char *s_key,const char *s_value,const DWORD_PTR data,int *_len)
{
  int data_len = *_len; //used only in multistr
  if ( data_len < 0 )
     data_len = 0;
  
  *_len = 0;

  const char *s_root = NULL;
  if ( root == HKEY_LOCAL_MACHINE )
     s_root = "HKLM";
  else
  if ( root == HKEY_USERS )
     s_root = "HKU";
  else
     return NULL;

  if ( !s_key )
     s_key = "";
  
  if ( !s_value )
     s_value = "";
  
  const char *s_data = (const char *)data;
  if ( !s_data )
     s_data = "";

  DWORD i_data = (DWORD)data;
  
  char *buff = (char*)sys_zalloc(MAX_PATH*4+data_len); //zero clears
  char *p = buff;

  if ( cmd == CMD_WRITEREGMULTISTR )
     {
       lstrcpy(p,"WriteRegMultiStr"); p += lstrlen(p)+1;
       lstrcpy(p,s_root);        p += lstrlen(p)+1;
       lstrcpy(p,s_key);         p += lstrlen(p)+1;
       lstrcpy(p,s_value);       p += lstrlen(p)+1;
       if ( data_len >= 2 )
          {
            CopyMemory(p,s_data,data_len); p += data_len;
          }
       else
          {
            *p++ = 0;
            *p++ = 0;
          }
       p++; //terminator
     }
  else
  if ( cmd == CMD_WRITEREGSTR )
     {
       lstrcpy(p,"WriteRegStr"); p += lstrlen(p)+1;
       lstrcpy(p,s_root);        p += lstrlen(p)+1;
       lstrcpy(p,s_key);         p += lstrlen(p)+1;
       lstrcpy(p,s_value);       p += lstrlen(p)+1;
       lstrcpy(p,s_data);        p += lstrlen(p)+1;
       p++; //terminator
     }
  else
  if ( cmd == CMD_WRITEREGSTR64 )
     {
       lstrcpy(p,"WriteRegStr64"); p += lstrlen(p)+1;
       lstrcpy(p,s_root);        p += lstrlen(p)+1;
       lstrcpy(p,s_key);         p += lstrlen(p)+1;
       lstrcpy(p,s_value);       p += lstrlen(p)+1;
       lstrcpy(p,s_data);        p += lstrlen(p)+1;
       p++; //terminator
     }
  else
  if ( cmd == CMD_WRITEREGDWORD )
     {
       lstrcpy(p,"WriteRegDword");  p += lstrlen(p)+1;
       lstrcpy(p,s_root);           p += lstrlen(p)+1;
       lstrcpy(p,s_key);            p += lstrlen(p)+1;
       lstrcpy(p,s_value);          p += lstrlen(p)+1;
       lstrcpy(p,IntToStr(i_data)); p += lstrlen(p)+1;
       p++; //terminator
     }
  else
  if ( cmd == CMD_DELETEREGVALUE )
     {
       lstrcpy(p,"DeleteRegValue");  p += lstrlen(p)+1;
       lstrcpy(p,s_root);            p += lstrlen(p)+1;
       lstrcpy(p,s_key);             p += lstrlen(p)+1;
       lstrcpy(p,s_value);           p += lstrlen(p)+1;
       p++; //terminator
     }
  else
  if ( cmd == CMD_DELETEREGVALUE64 )
     {
       lstrcpy(p,"DeleteRegValue64");  p += lstrlen(p)+1;
       lstrcpy(p,s_root);            p += lstrlen(p)+1;
       lstrcpy(p,s_key);             p += lstrlen(p)+1;
       lstrcpy(p,s_value);           p += lstrlen(p)+1;
       p++; //terminator
     }
  else
  if ( cmd == CMD_DELETEREGKEY )
     {
       lstrcpy(p,"DeleteRegKey");  p += lstrlen(p)+1;
       lstrcpy(p,s_root);          p += lstrlen(p)+1;
       lstrcpy(p,s_key);           p += lstrlen(p)+1;
       p++; //terminator
     }
  else
     {
       sys_free(buff);
       return NULL;
     }

  int len = p-buff;
  *_len = len;
  char *out = (char*)sys_alloc(len);
  CopyMemory(out,buff,len);

  sys_free(buff);

  return out;
}


static BOOL AARegCmd(int cmd,HKEY root,const char *key,const char *value,const DWORD_PTR data,int len=-1)
{
  BOOL rc = FALSE;
  
  char s_key[MAX_PATH];
  
  if ( root == HKEY_CURRENT_USER )
     {
       char sid[MAX_PATH] = "";
       GetCurrentUserSid(sid);

       if ( !sid[0] )
          return rc;

       wsprintf(s_key,"%s\\%s",sid,key?key:"");
       root = HKEY_USERS;
     }
  else
     {
       lstrcpy(s_key,key);
     }

  char *buff = AAPrepareBuff4RegCmd(cmd,root,s_key,value,data,&len);

  if ( buff )
     {
       rc = AASendCmd(buff,len);
       sys_free(buff);
     }

  return rc;
}


static BOOL AAWriteRegStr(HKEY root,const char *key,const char *value,const char *data)
{
  return AARegCmd(CMD_WRITEREGSTR,root,key,value,(DWORD_PTR)data);
}


static BOOL AAWriteRegStr64(HKEY root,const char *key,const char *value,const char *data)
{
  return AARegCmd(CMD_WRITEREGSTR64,root,key,value,(DWORD_PTR)data);
}


static BOOL AAWriteRegMultiStr(HKEY root,const char *key,const char *value,const char *data,int len)
{
  return AARegCmd(CMD_WRITEREGMULTISTR,root,key,value,(DWORD_PTR)data,len);
}


static BOOL AAWriteRegDword(HKEY root,const char *key,const char *value,DWORD data)
{
  return AARegCmd(CMD_WRITEREGDWORD,root,key,value,(DWORD_PTR)data);
}


static BOOL AADeleteRegValue(HKEY root,const char *key,const char *value)
{
  return AARegCmd(CMD_DELETEREGVALUE,root,key,value,(DWORD_PTR)0);
}


static BOOL AADeleteRegValue64(HKEY root,const char *key,const char *value)
{
  return AARegCmd(CMD_DELETEREGVALUE64,root,key,value,(DWORD_PTR)0);
}


static BOOL AADeleteRegKey(HKEY root,const char *key)
{
  return AARegCmd(CMD_DELETEREGKEY,root,key,NULL,(DWORD_PTR)0);
}


BOOL AdminAccessWriteRegStr(HKEY root,const char *key,const char *value,const char *data)
{
  BOOL rc = WriteRegStr(root,key,value,data);
  if ( !rc )
     rc = AAWriteRegStr(root,key,value,data);
  return rc;
}


BOOL AdminAccessWriteRegStr64(HKEY root,const char *key,const char *value,const char *data)
{
  BOOL rc = WriteRegStr64(root,key,value,data);
  if ( !rc )
     rc = AAWriteRegStr64(root,key,value,data);
  return rc;
}


BOOL AdminAccessWriteRegMultiStr(HKEY root,const char *key,const char *value,const char *data,int len)
{
  BOOL rc = WriteRegMultiStr(root,key,value,data,len);
  if ( !rc )
     rc = AAWriteRegMultiStr(root,key,value,data,len);
  return rc;
}


BOOL AdminAccessWriteRegDword(HKEY root,const char *key,const char *value,DWORD data)
{
  BOOL rc = WriteRegDword(root,key,value,data);
  if ( !rc )
     rc = AAWriteRegDword(root,key,value,data);
  return rc;
}


BOOL AdminAccessDeleteRegValue(HKEY root,const char *key,const char *value)
{
  BOOL rc = DeleteRegValue(root,key,value);
  if ( !rc )
     rc = AADeleteRegValue(root,key,value);
  return rc;
}


BOOL AdminAccessDeleteRegValue64(HKEY root,const char *key,const char *value)
{
  BOOL rc = DeleteRegValue64(root,key,value);
  if ( !rc )
     rc = AADeleteRegValue64(root,key,value);
  return rc;
}


BOOL AdminAccessDeleteRegKey(HKEY root,const char *key)
{
  BOOL rc = DeleteRegKey(root,key);
  if ( !rc )
     rc = AADeleteRegKey(root,key);
  return rc;
}

