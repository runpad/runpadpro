


void ScanDir(const char *path,int type,SCANFUNC func,void *user)
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



void ScanProcesses(SCANPROCESSESPROC func,void *parm)
{
  if ( func )
     {
       CSessionProcessList pl;

       do {

        char filename[MAX_PATH] = "";
        int pid = -1;
        
        if ( !pl.GetNext(&pid,filename) )
           break;

        if ( !func(pid,filename,parm) )
           break;

       } while (1);
     }
}


int EnumerateRegistryKeys(HKEY root,const char *key,REGENUMKEYFUNC func,void *param)
{
  HKEY h;
  int rc = 0;
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       int idx = 0;

       while ( 1 )
       {
         char key_name[MAX_PATH];
         DWORD namelen = sizeof(key_name);
         FILETIME time;

         if ( RegEnumKeyEx(h,idx,key_name,&namelen,NULL,NULL,NULL,&time) != ERROR_SUCCESS )
            break;

         rc += func(h,key_name,param);

         idx++;
       }

       RegCloseKey(h);
     }

  return rc;
}


int EnumerateRegistryValues(HKEY root,const char *key,REGENUMVALUEFUNC func,void *param)
{
  int rc = 0;
  
  HKEY hkey;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&hkey) == ERROR_SUCCESS )
     {
       int n;

       for ( n = 0; ; n++ )
           {
             char szValueName[MAX_PATH];
             char szData[MAX_PATH];
             DWORD cbValueName = MAX_PATH-1;
             DWORD cbData = MAX_PATH-1;
             DWORD dwDataType;

             ZeroMemory(szValueName,sizeof(szValueName));
             ZeroMemory(szData,sizeof(szData));
             
             if ( RegEnumValue(hkey,n,szValueName,&cbValueName,0,&dwDataType,(LPBYTE)szData,&cbData) != ERROR_SUCCESS )
                break;

             rc += func(szValueName,szData,param);
           }

       RegCloseKey(hkey);
     }

  return rc;
}


int EnumerateRegistryValues64(HKEY root,const char *key,REGENUMVALUEFUNC func,void *param)
{
  int rc = 0;
  
  HKEY hkey;

  if ( RegOpenKeyEx(root,key,0,KEY_READ|GetWow64RegFlag64(),&hkey) == ERROR_SUCCESS )
     {
       int n;

       for ( n = 0; ; n++ )
           {
             char szValueName[MAX_PATH];
             char szData[MAX_PATH];
             DWORD cbValueName = MAX_PATH-1;
             DWORD cbData = MAX_PATH-1;
             DWORD dwDataType;

             ZeroMemory(szValueName,sizeof(szValueName));
             ZeroMemory(szData,sizeof(szData));
             
             if ( RegEnumValue(hkey,n,szValueName,&cbValueName,0,&dwDataType,(LPBYTE)szData,&cbData) != ERROR_SUCCESS )
                break;

             rc += func(szValueName,szData,param);
           }

       RegCloseKey(hkey);
     }

  return rc;
}
