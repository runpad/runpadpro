
#include "include.h"



static TSAVER saver[SAVER_MAX];
static int num_saver = 0;


int GetSaversCount(void)
{
  return num_saver;
}


TSAVER* GetSaverAt(int idx)
{
  if ( idx >= 0 && idx < num_saver )
     return &saver[idx];
  else
     return NULL;
}


static void FreeSingleSaverEntry(TSAVER *i)
{
  int m;

  for ( m = 0; m < i->num_files; m++ )
      {
        if ( i->files[m] )
           sys_free(i->files[m]);
        i->files[m] = NULL;
      }

  i->num_files = 0;
  
  for ( m = 0; m < i->num_parms; m++ )
      {
        if ( i->parms[m] )
           sys_free(i->parms[m]);
        if ( i->def_parms[m] )
           sys_free(i->def_parms[m]);
        i->parms[m] = NULL;
        i->def_parms[m] = NULL;
      }

  i->num_parms = 0;
}


static void PrepareSaverPath(char *str)
{
  PathRemoveBlanks(str);
  PathUnquoteSpaces(str);
  PathRemoveBackslash(str);

  if ( !lstrcmpi(str,".") || !lstrcmpi(str,".\\") )
     str[0] = 0;

  if ( str[0] == '.' && str[1] == '\\' )
     {
       char s[MAX_PATH];
       lstrcpy(s,str+2);
       lstrcpy(str,s);
     }
}



void FreeSaver(void)
{
  int n;
  
  for ( n = 0; n < num_saver; n++ )
      FreeSingleSaverEntry(&saver[n]);

  num_saver = 0;
}


void LoadSaver(const char *token)
{
  FreeSaver();

  num_saver = 0;

  const unsigned max_buff_size = 65536;
  char *buff = (char*)sys_alloc(max_buff_size);
  LoadTextFromDescriptionToken(token,buff,max_buff_size-1);
  char filename[MAX_PATH] = "";
  GetFileNameInTempDir("rs_tmp_file.ini",filename);
  sys_deletefile(filename);
  WriteFullFile(filename,buff,lstrlen(buff));
  sys_free(buff);

  if ( IsFileExist(filename) )
     {
       int n,m;

       for ( n = 0; n < SAVER_MAX; n++ )
           {
             char section[32];
             char s[MAX_PATH];
             TSAVER *i = &saver[num_saver];

             // clear
             ZeroMemory(i,sizeof(*i));

             // read all
             wsprintf(section,"Section%d",n+1);

             GetPrivateProfileString(section,"Direction","",s,sizeof(s),filename);
             if ( !lstrcmpi(s,"In") )
                i->direction = SAVER_IN;
             else
             if ( !lstrcmpi(s,"Out") )
                i->direction = SAVER_OUT;
             else
                i->direction = SAVER_NULL;
             GetPrivateProfileString(section,"Title","",i->title,sizeof(i->title),filename);
             GetPrivateProfileString(section,"Help","",i->help,sizeof(i->help)-1,filename);
             i->quota = GetPrivateProfileInt(section,"Quota",0,filename);
             GetPrivateProfileString(section,"BaseFolder","",i->base_folder,sizeof(i->base_folder),filename);
             GetPrivateProfileString(section,"InSource","",i->in_source,sizeof(i->in_source),filename);
             GetPrivateProfileString(section,"AllowedExts","",i->allowed_exts,sizeof(i->allowed_exts),filename);
             GetPrivateProfileString(section,"AllowedMasks","",i->allowed_masks,sizeof(i->allowed_masks),filename);
             GetPrivateProfileString(section,"SaveAs","",i->save_as,sizeof(i->save_as),filename);
             GetPrivateProfileString(section,"CopyWithFolder","",s,sizeof(s),filename);
             if ( !s[0] || !lstrcmpi(s,"No") || !lstrcmpi(s,"0") || !lstrcmpi(s,"False") )
                i->copy_with_folder = FALSE;
             else
                i->copy_with_folder = TRUE;
                
             i->num_files = 0;
             for ( m = 0; m < SAVER_MAX; m++ )
                 {
                   char name[32];
                   char s[MAX_PATH];
                   
                   wsprintf(name,"File%d",m+1);
                   GetPrivateProfileString(section,name,"",s,sizeof(s),filename);
                   if ( s[0] )
                      {
                        i->files[i->num_files] = (char*)sys_alloc(MAX_PATH);
                        lstrcpy(i->files[i->num_files],s);
                        i->num_files++;
                      }
                 }

             i->num_parms = 0;
             for ( m = 0; m < SAVER_MAX; m++ )
                 {
                   char name[32];
                   char s[MAX_PATH];
                   
                   wsprintf(name,"Parm%d",m+1);
                   GetPrivateProfileString(section,name,"",s,sizeof(s),filename);
                   if ( s[0] )
                      {
                        i->parms[i->num_parms] = (char*)sys_alloc(MAX_PATH);
                        lstrcpy(i->parms[i->num_parms],s);

                        wsprintf(name,"DefParm%d",m+1);
                        GetPrivateProfileString(section,name,"",s,sizeof(s),filename);
                        i->def_parms[i->num_parms] = (char*)sys_alloc(MAX_PATH);
                        lstrcpy(i->def_parms[i->num_parms],s);
                        
                        i->num_parms++;
                      }
                 }

             // prepare
             PrepareSaverPath(i->base_folder);
             PrepareSaverPath(i->in_source);
             PrepareSaverPath(i->save_as);
             for ( m = 0; m < i->num_files; m++ )
                 PrepareSaverPath(i->files[m]);
            
             // check
             if ( (i->direction != SAVER_IN && i->direction != SAVER_OUT) || !i->title[0] )
                FreeSingleSaverEntry(i);
             else
                num_saver++;
           }
     
       sys_deletefile(filename);
     }
}


static void DoSaverSubst(char *str,char (*parms)[MAX_PATH],int num_parms)
{
  static const struct {
  int id;
  char *name;
  } sys[] = 
  {
    {CSIDL_PERSONAL,"%MYDOCS%"}, //C:\Documents and Settings\username\My Documents
    {CSIDL_COMMON_DOCUMENTS,"%COMMON_DOCUMENTS%"}, //C:\Documents and Settings\All Users\Documents
    {CSIDL_LOCAL_APPDATA,"%LOCAL_APPDATA%"}, //C:\Documents and Settings\username\Local Settings\Application Data
    {CSIDL_APPDATA,"%APPDATA%"},  //C:\Documents and Settings\username\Application Data
    {CSIDL_COMMON_APPDATA,"%COMMON_APPDATA%"}, //C:\Documents and Settings\All Users\Application Data
  };
  
  struct {
   char *name;
   BOOL name_allocated;
   char *value;
   BOOL value_allocated;
  } pairs[SAVER_MAX+20];
  SYSTEMTIME st;
  int n,num_pairs;

  num_pairs = 0;

  //system vars
  for ( n = 0; n < sizeof(sys)/sizeof(sys[0]); n++ )
      {
        pairs[num_pairs].name = sys[n].name;
        pairs[num_pairs].name_allocated = FALSE;
        pairs[num_pairs].value = (char*)sys_alloc(MAX_PATH);
        GetSpecialFolder(sys[n].id,pairs[num_pairs].value);
        pairs[num_pairs].value_allocated = TRUE;
        num_pairs++;
      }

  //date/time
  GetLocalTime(&st);

  pairs[num_pairs].name = "%DATE%";
  pairs[num_pairs].name_allocated = FALSE;
  pairs[num_pairs].value = (char*)sys_alloc(MAX_PATH);
  wsprintf(pairs[num_pairs].value,"%04d_%02d_%02d",st.wYear,st.wMonth,st.wDay);
  pairs[num_pairs].value_allocated = TRUE;
  num_pairs++;

  pairs[num_pairs].name = "%TIME%";
  pairs[num_pairs].name_allocated = FALSE;
  pairs[num_pairs].value = (char*)sys_alloc(MAX_PATH);
  wsprintf(pairs[num_pairs].value,"%02d_%02d",st.wHour,st.wMinute);
  pairs[num_pairs].value_allocated = TRUE;
  num_pairs++;

  //parameters
  for ( n = 0; n < num_parms; n++ )
      {
        pairs[num_pairs].name = (char*)sys_alloc(MAX_PATH);
        wsprintf(pairs[num_pairs].name,"%%PARM%d%%",n+1);
        pairs[num_pairs].name_allocated = TRUE;
        pairs[num_pairs].value = parms[n];
        pairs[num_pairs].value_allocated = FALSE;
        num_pairs++;
      }

  //process expanding
  for ( n = 0; n < num_pairs; n++ )
      {
        StrReplaceI(str,pairs[n].name,pairs[n].value);
      }

  DoEnvironmentSubst(str,MAX_PATH);

  //free
  for ( n = 0; n < num_pairs; n++ )
      {
        if ( pairs[n].name_allocated )
           sys_free(pairs[n].name);
        if ( pairs[n].value_allocated )
           sys_free(pairs[n].value);
      }
}


static BOOL IsPathAbsolute(const char *s)
{
  if ( !s )
     return FALSE;

  if ( !s[0] )
     return FALSE;

  if ( lstrlen(s) > 2 && s[0] == '\\' && s[1] == '\\' )
     return TRUE;

  if ( lstrlen(s) >= 2 && s[1] == ':' )
     return TRUE;

  return FALSE;
}


static void ReplaceInvalidFileChars(char *file)
{
  int n;

  for ( n = 0; n < lstrlen(file); n++ )
      if ( StrChr("\"*/:<>?\\|",file[n]) )
         file[n] = '_';
}


static void ReplaceSlashesByZero(char *s)
{
  int n,len = lstrlen(s);

  for ( n = 0; n < len; n++ )
      if ( s[n] == '\\' )
         s[n] = 0;
}


static void AddExtraZero(char *s)
{
  s[lstrlen(s)+1] = 0;
}


static BOOL IsStringConsistsOnlyOfChar(const char *s,char c)
{
  int len,n,find;
  
  if ( IsStrEmpty(s) )
     return FALSE;
  
  len = lstrlen(s);
  find = 0;
  for ( n = 0; n < len; n++ )
      if ( s[n] == c )
         find++;

  return find == len;
}


void M_Saver(const char *icon_name,const char *icon_cwd,int saver_idx,const char *src_for_in_direction)
{
  TSAVER *i = GetSaverAt(saver_idx);
  if ( i )
     {
       char parm_values[SAVER_MAX][MAX_PATH];
       char base_folder[MAX_PATH];
       int n;

       // display help
       if ( !IsStrEmpty(i->help) )
          MsgBox(i->help);

       // parameters
       for ( n = 0; n < SAVER_MAX; n++ )
           parm_values[n][0] = 0;

       for ( n = 0; n < i->num_parms; n++ )
           {
             char title[MAX_PATH];
             char def[MAX_PATH];
             const char *s;

             lstrcpy(title,i->parms[n]);
             DoSaverSubst(title,parm_values,n);
             lstrcpy(def,i->def_parms[n]);
             DoSaverSubst(def,parm_values,n);
             
             s = GetString(LS(3070),title,0,100,def);
             if ( !s )
                return;

             lstrcpy(parm_values[n],s);
             ReplaceInvalidFileChars(parm_values[n]);

             if ( IsStringConsistsOnlyOfChar(parm_values[n],' ') || 
                  IsStringConsistsOnlyOfChar(parm_values[n],'.') )
                {
                  lstrcpy(parm_values[n],"_");
                }
           }

       // base_folder
       lstrcpy(base_folder,i->base_folder);
       DoSaverSubst(base_folder,parm_values,i->num_parms);
       if ( !IsPathAbsolute(base_folder) )
          {
            char temp[MAX_PATH];
            lstrcpy(temp,icon_cwd);
            PathAddBackslash(temp);
            lstrcat(temp,base_folder);
            lstrcpy(base_folder,temp);
          }
          
       if ( i->direction == SAVER_OUT )
          { //out
            int n,actual_files;
            char files[SAVER_MAX][MAX_PATH];
            char saveas_folder[MAX_PATH];

            //save as dir
            lstrcpy(saveas_folder,i->save_as);
            if ( !saveas_folder[0] )
               wsprintf(saveas_folder,"%s_%%DATE%%",icon_name);
            DoSaverSubst(saveas_folder,parm_values,i->num_parms);
            ReplaceInvalidFileChars(saveas_folder);
            if ( IsStrEmpty(saveas_folder) )
               lstrcpy(saveas_folder,"_folder_");

            //collect files
            actual_files = 0;
            for ( n = 0; n < i->num_files; n++ )
                {
                  char s[MAX_PATH];

                  lstrcpy(s,i->files[n]);
                  DoSaverSubst(s,parm_values,i->num_parms);

                  if ( s[0] )
                     lstrcpy(files[actual_files++],s);
                }

            //check
            if ( actual_files == 0 )
               {
                 ErrBox(LS(3071));
                 return;
               }

            //copy files
            {
              BOOL rc = FALSE;
              char s_to[MAX_PATH];
              int n;

              //prepare dest dir
              s_to[0] = 0;
              GetTempPath(MAX_PATH,s_to);
              PathAppend(s_to,saveas_folder);
              PathRemoveBackslash(s_to);
              CreateDirectory(s_to,NULL);
              CleanDir(s_to);

              // copy each src into the dest and create subdirs in it
              for ( n = 0; n < actual_files; n++ )
                  {
                    SHFILEOPSTRUCT fop;
                    char s_from[MAX_PATH],*p;
                    char dir_to_create[MAX_PATH];
                    char subdirs[MAX_PATH];

                    lstrcpy(dir_to_create,s_to);
                    
                    lstrcpy(subdirs,files[n]);
                    PathRemoveBackslash(subdirs);
                    PathRemoveFileSpec(subdirs);
                    PathRemoveBackslash(subdirs);
                    AddExtraZero(subdirs);
                    ReplaceSlashesByZero(subdirs);
                    p = subdirs;
                    while (*p)
                    {
                      PathAppend(dir_to_create,p);
                      CreateDirectory(dir_to_create,NULL);
                      p += lstrlen(p)+1;
                    }

                    PathAddBackslash(dir_to_create);
                    
                    lstrcpy(s_from,base_folder);
                    PathAppend(s_from,files[n]);
                    PathRemoveBackslash(s_from);

                    ZeroMemory(&fop,sizeof(fop));
                    fop.hwnd = NULL;
                    fop.wFunc = FO_COPY;
                    fop.pFrom = s_from;
                    AddExtraZero(s_from);
                    fop.pTo = dir_to_create;
                    AddExtraZero(dir_to_create);
                    fop.fFlags = FOF_NOCONFIRMATION | FOF_NOCONFIRMMKDIR | FOF_NOERRORUI | FOF_SILENT;

                    {
                      CWaitCursor oCursor;
                      rc = !SHFileOperation(&fop);
                    }

                    if ( !rc )
                       break;
                  }

              if ( rc )
                 {
                   if ( !IsBodyExplorerLoaded() )
                      ExecTool("$bodyexpl");
                   ShowSaverWindow(GetMainWnd(),i->direction,i->title,s_to);
                 }
              else
                 {
                   ErrBox(LS(3072));
                 }
            
              CleanDir(s_to);
              sys_removedirectory(s_to);
            }
          }
       else
          { //in
            char src[MAX_PATH];

            if ( IsStrEmpty(i->in_source) )
               {
                 if ( IsStrEmpty(src_for_in_direction) )
                    {
                      if ( !IsBodyExplorerLoaded() )
                         ExecTool("$bodyexpl");
                      src[0] = 0;
                      if ( !ShowSaverWindow(GetMainWnd(),i->direction,i->title,src) || IsStrEmpty(src) )
                         return;
                    }
                 else
                    lstrcpy(src,src_for_in_direction);
               }
            else
               {
                 lstrcpy(src,i->in_source);
                 DoSaverSubst(src,parm_values,i->num_parms);
               }

            if ( !IsFileExist(src) )
               {
                 ErrBox(LS(3073));
                 return;
               }

            if ( i->quota )
               {
                 int size;

                 {
                   CWaitCursor oCursor;
                   size = GetDirectorySize(src);
                 }
                 
                 if ( size > (i->quota << 10) )
                    {
                      ErrBox(LS(3074));
                      return;
                    }
               }

            if ( !IsStrEmpty(i->allowed_exts) ) // for BWC only
               {
                 BOOL rc; 
                 
                 {
                   CWaitCursor oCursor;
                   rc = ScanForDisallowedFileInDir(src,i->allowed_exts,FALSE);
                 }

                 if ( rc )
                    {
                      ErrBox(LS(3075));
                      return;
                    }
               }

            if ( !IsStrEmpty(i->allowed_masks) )
               {
                 BOOL rc; 
                 
                 {
                   CWaitCursor oCursor;
                   rc = ScanForDisallowedFileInDir(src,i->allowed_masks,TRUE);
                 }

                 if ( rc )
                    {
                      ErrBox(LS(3075));
                      return;
                    }
               }

            //copy
            {
              BOOL rc;
              SHFILEOPSTRUCT p;
              char s_from[MAX_PATH];
              char s_to[MAX_PATH];

              ZeroMemory(s_from,sizeof(s_from));
              lstrcpy(s_from,src);
              PathRemoveBackslash(s_from);
              if ( PathIsDirectory(s_from) && !i->copy_with_folder )
                 {
                   PathAddBackslash(s_from);
                   lstrcat(s_from,"*.*");
                 }
              ZeroMemory(s_to,sizeof(s_to));
              lstrcpy(s_to,base_folder);
              PathAddBackslash(s_to);

              SHCreateDirectoryEx(NULL,s_to,NULL);

              ZeroMemory(&p,sizeof(p));
              p.hwnd = NULL;
              p.wFunc = FO_COPY;
              p.pFrom = s_from;
              AddExtraZero(s_from);
              p.pTo = s_to;
              AddExtraZero(s_to);
              p.fFlags = FOF_NOCONFIRMATION | FOF_NOCONFIRMMKDIR | FOF_NOERRORUI | FOF_SILENT;

              {
                CWaitCursor oCursor;
                rc = !SHFileOperation(&p);
              }

              if ( rc )
                 MsgBox(LS(3076));
              else
                 ErrBox(LS(3072));
            }
          }
     }
}


int TrackSaverPopup(const char *saver_token,int x,int y)
{
  int rc = -1;

  if ( saver_token && saver_token[0] )
     {
       int n,count;
       
       LoadSaver(saver_token);
       count = GetSaversCount();

       if ( count )
          {
            BOOL find = FALSE;

            for ( n = 0; n < count; n++ )
                {
                  if ( GetSaverAt(n)->direction == SAVER_IN )
                     {
                       find = TRUE;
                       break;
                     }
                }

            if ( find )
               {
                 const int IDM_SAVERBASE = 1000;
                 HMENU menu = CreatePopupMenu();

                 for ( n = 0; n < count; n++ )
                     {
                       TSAVER *i = GetSaverAt(n);
                       if ( i->direction == SAVER_IN )
                          AppendMenu(menu,0,IDM_SAVERBASE+n,i->title);
                     }

                 rc = PopupMenuAndDestroy(menu,FALSE,x,y);
                 rc = (rc ? rc - IDM_SAVERBASE : -1);
               }
          }
     }

  return rc;
}
