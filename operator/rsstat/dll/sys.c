
static void ReadRegStr(HKEY root,char *key,char *value,char *data,char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(BYTE*)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


static void ReadRegStrP(HKEY h,char *value,char *data,char *def)
{
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegQueryValueEx(h,value,NULL,NULL,(BYTE*)data,&len) == ERROR_SUCCESS )
     data[len] = 0;
}


static DWORD ReadRegDword(HKEY root,char *key,char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(BYTE*)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


static DWORD ReadRegDwordP(HKEY h,char *value,int def)
{
  DWORD data = def;
  DWORD len = 4;

  RegQueryValueEx(h,value,NULL,NULL,(BYTE*)&data,&len);

  return data;
}


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


void *sys_fcreate(char *filename)
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
  DWORD rc;
  
  ReadFile(h,buff,len,&rc,NULL);
  return rc;
}



int sys_fwrite(void *h,void *buff,int len)
{
  DWORD rc;
  
  WriteFile(h,buff,len,&rc,NULL);
  return rc;
}
