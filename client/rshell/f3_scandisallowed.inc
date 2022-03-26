
BOOL IsFileMaskAllowedInternal(const char *path,const char *list)
{
  BOOL rc = FALSE;
  
  if ( !IsStrEmpty(path) )
     {
       if ( !IsStrEmpty(list) )
          {
            char *s = (char*)sys_zalloc(lstrlen(list)+2); //zero clears
            lstrcpy(s,list);

            int len = lstrlen(s);
            for ( int n = 0; n < len; n++ )
                if ( s[n] == ';' || s[n] == ',' )
                   s[n] = 0;

            const char *fname = PathFindFileName(path);
            if ( *fname )
               {
                 BOOL find = FALSE;

                 const char *p = s;

                 while ( *p )
                 {
                   if ( PathMatchSpec(fname,p) )
                      {
                        find = TRUE;
                        break;
                      }

                   p += lstrlen(p)+1;
                 }

                 rc = find;
               }

            sys_free(s);
          }
     }

  return rc;
}


BOOL IsExtensionAllowedInternal(const char *path,const char *list)
{
  BOOL rc = FALSE;
  
  if ( !IsStrEmpty(path) )
     {
       if ( !IsStrEmpty(list) )
          {
            char *s = (char*)sys_zalloc(lstrlen(list)+2); //zero clears
            lstrcpy(s,list);

            int len = lstrlen(s);
            for ( int n = 0; n < len; n++ )
                if ( s[n] == ';' || s[n] == ',' )
                   s[n] = 0;

            const char *ext = PathFindExtension(path);
            if ( *ext )
               {
                 BOOL find = FALSE;

                 ext++;
                 const char *p = s;

                 while ( *p )
                 {
                   if ( !lstrcmpi(p,ext) )
                      {
                        find = TRUE;
                        break;
                      }

                   p += lstrlen(p)+1;
                 }

                 rc = find;
               }

            sys_free(s);
          }
     }

  return rc;
}



typedef struct {
const char *exts;
BOOL is_masks_allowed;
BOOL find;
} RECURSESCANINFO;

static void ScanForDisallowedFileInDirInternal(const char *dir,RECURSESCANINFO *info);


static BOOL ScanForDisallowedFileInDirProc(const char *path,WIN32_FIND_DATA *f,void *user)
{
  RECURSESCANINFO *info = (RECURSESCANINFO*)user;

  if ( f->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
     {
       ScanForDisallowedFileInDirInternal(path,info);
       if ( info->find )
          return FALSE;
     }
  else
     {
       if ( info->is_masks_allowed )
          {
            if ( !IsFileMaskAllowedInternal(f->cFileName,info->exts) )
               {
                 info->find = TRUE;
                 return FALSE;
               }
          }
       else
          {
            if ( !IsExtensionAllowedInternal(f->cFileName,info->exts) )
               {
                 info->find = TRUE;
                 return FALSE;
               }
          }
     }

  return TRUE;
}


static void ScanForDisallowedFileInDirInternal(const char *dir,RECURSESCANINFO *info)
{
  ScanDir(dir,SCAN_DIR | SCAN_FILE | SCAN_HIDDEN,ScanForDisallowedFileInDirProc,info);
}


BOOL ScanForDisallowedFileInDir(const char *dir,const char *exts,BOOL is_masks_allowed)
{
  if ( !dir || !dir[0] )
     return FALSE;
  
  if ( PathIsDirectory(dir) )
     {
       RECURSESCANINFO info;

       info.exts = exts;
       info.is_masks_allowed = is_masks_allowed;
       info.find = FALSE;
       ScanForDisallowedFileInDirInternal(dir,&info);

       return info.find;
     }
  else
     {
       return is_masks_allowed ? !IsFileMaskAllowedInternal(dir,exts) : !IsExtensionAllowedInternal(dir,exts);
     }
}

