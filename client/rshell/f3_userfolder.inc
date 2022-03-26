

static BOOL DelOldUserFolders(const char *path,WIN32_FIND_DATA *f,void *parm)
{
  const __int64 one_day = 864000000000LL;
  int n;
  __int64 now = *(__int64*)parm;

  BOOL find = FALSE;

  for ( n = 0; n < clean_user_folder; n++ )
      {
        SYSTEMTIME t;
        char s[MAX_PATH];
        
        FileTimeToSystemTime((FILETIME*)&now,&t);
        wsprintf(s,"%04d_%02d_%02d",t.wYear,t.wMonth,t.wDay);

        if ( !lstrcmpi(PathFindFileName(path),s) )
           {
             find = TRUE;
             break;
           }

        now -= one_day;
      }

   if ( !find )
      {
        CleanDir(path);
        sys_removedirectory(path);
      }

  return TRUE;
}


static void CleanUserFolder(const char *folder)
{
  if ( clean_user_folder > 0 )
     {
       SYSTEMTIME t;
       __int64 time;

       GetLocalTime(&t);
       SystemTimeToFileTime(&t,(FILETIME*)&time);

       ScanDir(folder,SCAN_DIR,DelOldUserFolders,&time);
     }
}


void CreateUserFolder(void)
{
  user_folder[0] = 0;
  
  if ( !user_folder_base[0] )
     return;

  char s[MAX_PATH];
  lstrcpy(s,user_folder_base);

  ExpandPath(s);

  if ( !s[0] )
     return;
  
  PathAddBackslash(s);
  CreateDirectory(s,NULL);

  lstrcat(s,CPathExpander(uf_format));
  PathAddBackslash(s);
  CreateDirectory(s,NULL);

  CleanUserFolder(s);
  
  if ( clean_user_folder > 0 )
     {
       SYSTEMTIME t;
       GetLocalTime(&t);
       char ss[MAX_PATH];
       wsprintf(ss,"%04d_%02d_%02d",t.wYear,t.wMonth,t.wDay);
       lstrcat(s,ss);
       PathAddBackslash(s);
       CreateDirectory(s,NULL);
     }
  
  lstrcpy(user_folder,s);
}
