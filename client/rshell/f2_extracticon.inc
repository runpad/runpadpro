

static HICON ExtractSingleIconInternal(IExtractIcon *icon,const char *path,int idx,int size)
{
  HICON hicon1 = NULL;
  HICON hsmall = NULL;

  HRESULT hr = icon->Extract(path,idx,&hicon1,&hsmall,(16 << 16) | size);

  if ( hsmall )
     DestroyIcon(hsmall);

  if ( !hicon1 )
     {
       if ( hr == S_FALSE )
          {
            HICON i = ExtractIcon(our_instance,path,idx);
            i = (i == (HICON)1 ? NULL : i);
            if ( !i )
               i = ExtractIcon(our_instance,path,0);
            i = (i == (HICON)1 ? NULL : i);
            hicon1 = i;
          }
     }

  return hicon1;
}


static BOOL ExtractIconInternal(IExtractIcon *icon, //not NULL
                                const char *s_filepath,   //not NULL
                                const char *s_iconpath,
                                int i_iconidx,
                                int i_size1,
                                int i_size2,
                                HICON *p_i1,     //not NULL
                                HICON *p_i2      //not NULL
                               )
{
  *p_i1 = NULL;
  *p_i2 = NULL;
  
  if ( s_iconpath && s_iconpath[0] )
     {
       if ( lstrlen(s_iconpath) > 2 && s_iconpath[0] == '\\' && s_iconpath[1] == '\\' )
          {
            return TRUE;
          }
       else
          {
            HICON i1 = ExtractSingleIconInternal(icon,s_iconpath,i_iconidx,i_size1);
            HICON i2 = ExtractSingleIconInternal(icon,s_iconpath,i_iconidx,i_size2);

            if ( i1 && i2 )
               {
                 *p_i1 = i1;
                 *p_i2 = i2;
                 return FALSE;
               }
            else
               {
                 if ( i1 )
                    DestroyIcon(i1);
                 if ( i2 )
                    DestroyIcon(i2);
               }
          }
     }

     
  {
    BOOL rc;
    HRESULT type;
    UINT flags;
    char s[MAX_PATH];
    int idx;

    s[0] = 0;
    idx = 0;

    type = icon->GetIconLocation(0/*GIL_ASYNC*/,s,MAX_PATH,&idx,&flags);

    if ( type == E_PENDING )
       {
         rc = TRUE;
       }
    else
    if ( type == S_OK )
       {
         if ( s[0] == '\\' && s[1] == '\\' )
            {
              rc = TRUE;
            }
         else
            {
              if ( !lstrcmp(s,"*") && lstrlen(s_filepath) > 2 && s_filepath[0] == '\\' && s_filepath[1] == '\\' )
                 {
                   rc = TRUE;
                 }
              else
                 {
                   HICON i1 = ExtractSingleIconInternal(icon,s,idx,i_size1);
                   HICON i2 = ExtractSingleIconInternal(icon,s,idx,i_size2);

                   if ( i1 && i2 )
                      {
                        *p_i1 = i1;
                        *p_i2 = i2;
                        rc = FALSE;
                      }
                   else
                      {
                        if ( i1 )
                           DestroyIcon(i1);
                        if ( i2 )
                           DestroyIcon(i2);
                        rc = FALSE;
                      }
                 }
            }
       }
    else
       {
         rc = FALSE;
       }

    return rc;
  }
}



static BOOL IsNetworkIconInternal( const char *s_fullpath,  //full path to object
                                   const char *s_iconpath,  //desired icon path (maybe NULL)
                                   int i_iconidx,     //desired icon idx
                                   int i_size1,       //icon size 1
                                   int i_size2,       //icon size 2
                                   HICON *p_hicon1,   //out pointer
                                   HICON *p_hicon2    //out pointer
                                 )
{
  BOOL exit_code = FALSE;

  if ( p_hicon1 )
     *p_hicon1 = NULL;
  if ( p_hicon2 )
     *p_hicon2 = NULL;
     
  if ( s_fullpath && s_fullpath[0] && (p_hicon1 || p_hicon2) )
     {
       if ( /*(!s_iconpath || !s_iconpath[0]) &&*/ (lstrlen(s_fullpath)>2 && s_fullpath[0]=='\\' && s_fullpath[1]=='\\') )
          {
            exit_code = TRUE;
          }
       else
          {
            LPMALLOC folder_malloc = NULL;
            SHGetMalloc(&folder_malloc);
            if ( folder_malloc )
               {
                 IShellFolder *folder_desktop = NULL;
                 SHGetDesktopFolder(&folder_desktop);
                 if ( folder_desktop )
                    {
                      LPITEMIDLIST id = NULL;
                      WCHAR wsz[MAX_PATH]; 
                      char s[MAX_PATH];

                      lstrcpy(s,s_fullpath);
                      PathRemoveBackslash(s);
                      PathRemoveFileSpec(s);
                      MultiByteToWideChar(CP_ACP,0,s,-1,wsz,MAX_PATH);
                      if ( folder_desktop->ParseDisplayName(NULL,NULL,wsz,NULL,&id,NULL) == S_OK )
                         {
                           IShellFolder *folder_work = NULL;
                           folder_desktop->BindToObject(id,NULL,IID_IShellFolder,(void**)&folder_work);

                           if ( folder_work )
                              {
                                LPITEMIDLIST id = NULL;
                                WCHAR wsz[MAX_PATH]; 
                                char s[MAX_PATH];

                                lstrcpy(s,s_fullpath);
                                PathRemoveBackslash(s);
                                MultiByteToWideChar(CP_ACP,0,PathFindFileName(s),-1,wsz,MAX_PATH);
                                if ( folder_work->ParseDisplayName(NULL,NULL,wsz,NULL,&id,NULL) == S_OK )
                                   {
                                     IExtractIcon *icon = NULL;
                                     if ( folder_work->GetUIObjectOf(NULL,1,(LPCITEMIDLIST*)&id,IID_IExtractIcon,NULL,(void**)&icon) == S_OK )
                                        {
                                          HICON i1=NULL,i2=NULL;
                                                                               
                                          BOOL is_net = ExtractIconInternal(icon,s_fullpath,s_iconpath,i_iconidx,i_size1,i_size2,&i1,&i2);

                                          if ( is_net )
                                             {
                                               if ( i1 )
                                                  DestroyIcon(i1);
                                               if ( i2 )
                                                  DestroyIcon(i2);

                                               exit_code = TRUE;
                                             }
                                          else
                                             {
                                               if ( !i1 || !i2 )
                                                  {
                                                    if ( i1 )
                                                       DestroyIcon(i1);
                                                    if ( i2 )
                                                       DestroyIcon(i2);
                                                  }
                                               else
                                                  {
                                                    if ( p_hicon1 )
                                                       *p_hicon1 = i1;
                                                    else
                                                       DestroyIcon(i1);

                                                    if ( p_hicon2 )
                                                       *p_hicon2 = i2;
                                                    else
                                                       DestroyIcon(i2);
                                                  }
                                             }

                                          icon->Release();
                                        }

                                     folder_malloc->Free(id);
                                   }

                                folder_work->Release();
                              }

                           folder_malloc->Free(id);
                         }

                      folder_desktop->Release();
                    }

                 folder_malloc->Release();
               }
          }
     }

  return exit_code;
}


HICON ExtractSingleIconInOldMethod(const char *s,int size)
{
  SHFILEINFO i;
  int flags = 0;

  if ( size == 32 )
     flags = SHGFI_LARGEICON;
  else
  if ( size > 32 )
     flags = SHGFI_SHELLICONSIZE;
  else
     flags = SHGFI_SMALLICON;

  flags |= SHGFI_ICON;
  
  SHGetFileInfo(s,0,&i,sizeof(i),flags);

  return i.hIcon;
}


// this function never returns NULL icons
void LoadFileIconsGuarant( const char *s_fullpath,  //full path to object
                           const char *s_iconpath,  //desired icon path (maybe NULL)
                           int i_iconidx,     //desired icon idx
                           int i_size1,       //icon size 1
                           int i_size2,       //icon size 2
                           HICON *p_hicon1,   //out pointer
                           HICON *p_hicon2,   //out pointer
                           BOOL *p_is_net,     //is network icon?
                           BOOL &_is_default_loaded
                         )
{
  _is_default_loaded = FALSE;
  if ( p_is_net )
     *p_is_net = FALSE;
  if ( p_hicon1 )
     *p_hicon1 = NULL;
  if ( p_hicon2 )
     *p_hicon2 = NULL;

  if ( p_hicon1 || p_hicon2 )
     {
       HICON i1=NULL,i2=NULL;
       BOOL is_net = IsNetworkIconInternal(s_fullpath,s_iconpath,i_iconidx,i_size1,i_size2,&i1,&i2);

       if ( is_net || !i1 || !i2 )
          {
            _is_default_loaded = TRUE;
            
            BOOL is_folder = FALSE;
            char s[MAX_PATH];
            
            //load default icons
            if ( i1 )
               DestroyIcon(i1);
            i1 = NULL;
            if ( i2 )
               DestroyIcon(i2);
            i2 = NULL;

            if ( s_fullpath && s_fullpath[0] )
               {
                 if ( lstrlen(s_fullpath) > 2 && s_fullpath[0] == '\\' && s_fullpath[1] == '\\' )
                    {
                      if ( s_fullpath[lstrlen(s_fullpath)-1] == '\\' )
                         {
                           is_folder = TRUE;
                         }
                      else
                         {
                           is_folder = !(PathFindExtension(PathFindFileName(s_fullpath))[0]);
                         }
                    }
                 else
                    {
                      if ( IsFileExist(s_fullpath) )
                         {
                           is_folder = PathIsDirectory(s_fullpath);
                         }
                      else
                         {
                           if ( s_fullpath[lstrlen(s_fullpath)-1] == '\\' )
                              {
                                is_folder = TRUE;
                              }
                           else
                              {
                                is_folder = !(PathFindExtension(PathFindFileName(s_fullpath))[0]);
                              }
                         }
                    }
               }

            s[0] = 0;
            GetTempPath(sizeof(s),s);
            if ( !is_folder )
               {
                 PathAppend(s,"rs_tmp_deficon");
                 sys_fclose(sys_fcreate(s));
               }
            else
               {
                 PathRemoveBackslash(s);
               }

            i1 = NULL;
            i2 = NULL;
            IsNetworkIconInternal(s,NULL,0,i_size1,i_size2,&i1,&i2);

            if ( !i1 || !i2 )
               {
                 if ( i1 )
                    DestroyIcon(i1);
                 if ( i2 )
                    DestroyIcon(i2);

                 //retrieve in old method
                 i1 = ExtractSingleIconInOldMethod(s,i_size1);
                 if ( !i1 )
                    i1 = CopyIcon(LoadIcon(NULL,IDI_APPLICATION));

                 i2 = ExtractSingleIconInOldMethod(s,i_size2);
                 if ( !i2 )
                    i2 = CopyIcon(LoadIcon(NULL,IDI_APPLICATION));
               }
          }

       //success
       if ( p_is_net )
          *p_is_net = is_net;

       if ( p_hicon1 )
          *p_hicon1 = i1;
       else
          DestroyIcon(i1);

       if ( p_hicon2 )
          *p_hicon2 = i2;
       else
          DestroyIcon(i2);
     }
}


// this function never returns NULL icons
void LoadUrlIconsGuarant(int i_size1,int i_size2,HICON *p_hicon1,HICON *p_hicon2)
{
  char s[MAX_PATH] = "";
  CreateUrlFile("http://localhost",s);

  BOOL defload;
  LoadFileIconsGuarant(s,NULL,0,i_size1,i_size2,p_hicon1,p_hicon2,NULL,defload);
}

