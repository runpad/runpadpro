

static void WriteProgid(const char *subname,const char *path,int icon_idx,const char *desc)
{
  char key[MAX_PATH];
  char s_exe[MAX_PATH];
  char s1[MAX_PATH];
  char s2[MAX_PATH];

  wsprintf(key,REG_CLASSES "RunpadPro.%s",subname);
  WriteRegStr(HKCU,key,NULL,desc);

  if ( path[0] == '$' )
     {
       wsprintf(s_exe,"%s%s.exe",our_currpath,&path[1]);
     }
  else
     {
       lstrcpy(s_exe,path);
       PathUnquoteSpaces(s_exe);
     }

  wsprintf(s1,"%s\\DefaultIcon",key);
  wsprintf(s2,"\"%s\",%d",s_exe,icon_idx);
  WriteRegStr(HKCU,s1,NULL,s2);

  wsprintf(s1,"%s\\shell\\open\\command",key);
  wsprintf(s2,"\"%s\" \"%%1\"",s_exe);
  WriteRegStr(HKCU,s1,NULL,s2);
}


static void DeleteProgid(const char *subname)
{
  char key[MAX_PATH];

  wsprintf(key,REG_CLASSES "RunpadPro.%s",subname);

  DeleteRegKey(HKCU,key);
}


static void RegisterExtensions(const char *list,const char *subname)
{
  int n,count;
  char **exts;

  char progid[MAX_PATH];
  char progid_back[MAX_PATH];
  char key_progid[MAX_PATH];
  char key_progid_back[MAX_PATH];

  wsprintf(progid,"RunpadPro.%s",subname);
  wsprintf(progid_back,"RunpadPro.%s.back",subname);
  wsprintf(key_progid,REG_CLASSES "%s",progid);
  wsprintf(key_progid_back,REG_CLASSES "%s",progid_back);

  count = 0;
  exts = ConvertList2Ar(list,&count,TRUE);
  
  // save extensions
  for ( n = 0; n < count; n++ )
      {
        if ( lstrlen(exts[n]) > 1 )
           {
             char t[MAX_PATH];
             char s[MAX_PATH];

             wsprintf(t,REG_CLASSES "%s",exts[n]);
             ReadRegStr(HKCU,t,NULL,s,"");
             if ( lstrcmpi(s,progid) )
                {
                  wsprintf(t,"%s",exts[n]);
                  WriteRegStr(HKCU,key_progid_back,t,s);
                }

             wsprintf(t,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s",exts[n]);
             ReadRegStr(HKCU,t,"Progid",s,"");
             if ( lstrcmpi(s,progid) )
                {
                  wsprintf(t,"id_%s",exts[n]);
                  WriteRegStr(HKCU,key_progid_back,t,s);
                }

             wsprintf(t,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s\\UserChoice",exts[n]);
             ReadRegStr(HKCU,t,"Progid",s,"");
             if ( lstrcmpi(s,progid) )
                {
                  wsprintf(t,"uc_%s",exts[n]);
                  WriteRegStr(HKCU,key_progid_back,t,s);
                }

             wsprintf(t,"Software\\Microsoft\\Windows\\Roaming\\OpenWith\\FileExts\\%s\\UserChoice",exts[n]);
             ReadRegStr(HKCU,t,"Progid",s,"");
             if ( lstrcmpi(s,progid) )
                {
                  wsprintf(t,"uc2_%s",exts[n]);
                  WriteRegStr(HKCU,key_progid_back,t,s);
                }
           }
      }

  // set new extensions
  for ( n = 0; n < count; n++ )
      {
        if ( lstrlen(exts[n]) > 1 )
           {
             char t[MAX_PATH];
             char s[MAX_PATH];

             wsprintf(t,REG_CLASSES "%s",exts[n]);
             WriteRegStr(HKCU,t,NULL,progid);
             wsprintf(t,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s",exts[n]);
             WriteRegStr(HKCU,t,"Progid",progid);

             wsprintf(t,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s\\UserChoice",exts[n]);
             ReadRegStr(HKCU,t,"Progid",s,"");
             if ( !IsStrEmpty(s) )
                {
                  AdminAccessWriteRegStr(HKCU,t,"Progid",progid); //win7
                }

             wsprintf(t,"Software\\Microsoft\\Windows\\Roaming\\OpenWith\\FileExts\\%s\\UserChoice",exts[n]);
             ReadRegStr(HKCU,t,"Progid",s,"");
             if ( !IsStrEmpty(s) )
                {
                  AdminAccessWriteRegStr(HKCU,t,"Progid",progid); //win8
                }
           }
      }

  FreeListAr(exts,count);
}


static int UnregisterSingleExt(const char *value,const char *data,void *param)
{
  char *progid = (char*)param;

  if ( !StrCmpNI(value,".",1) )
     {
       char key[MAX_PATH];
       char ext[MAX_PATH];

       lstrcpy(ext,value);
       if ( lstrlen(ext) > 1 )
          {
            wsprintf(key,REG_CLASSES "%s",ext);
            if ( data[0] )
               {
                 WriteRegStr(HKCU,key,NULL,data);
               }
            else
               {
                 DeleteRegKey(HKCU,key);
               }
          }
     }
  else
  if ( !StrCmpNI(value,"id_",3) )
     {
       char key[MAX_PATH];
       char ext[MAX_PATH];

       lstrcpy(ext,&value[3]);
       if ( lstrlen(ext) > 1 )
          {
            wsprintf(key,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s",ext);
            if ( data[0] )
               {
                 WriteRegStr(HKCU,key,"Progid",data);
               }
            else
               {
                 DeleteRegValue(HKCU,key,"Progid");
               }
          }
     }
  else
  if ( !StrCmpNI(value,"uc_",3) )
     {
       char key[MAX_PATH];
       char ext[MAX_PATH];

       lstrcpy(ext,&value[3]);
       if ( lstrlen(ext) > 1 )
          {
            wsprintf(key,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FileExts\\%s\\UserChoice",ext);
            if ( data[0] )
               {
                 AdminAccessWriteRegStr(HKCU,key,"Progid",data);  //win7
               }
            else
               {
                 AdminAccessDeleteRegValue(HKCU,key,"Progid");   // win7
               }
          }
     }
  else
  if ( !StrCmpNI(value,"uc2_",4) )
     {
       char key[MAX_PATH];
       char ext[MAX_PATH];

       lstrcpy(ext,&value[4]);
       if ( lstrlen(ext) > 1 )
          {
            wsprintf(key,"Software\\Microsoft\\Windows\\Roaming\\OpenWith\\FileExts\\%s\\UserChoice",ext);
            if ( data[0] )
               {
                 AdminAccessWriteRegStr(HKCU,key,"Progid",data);  //win8
               }
            else
               {
                 AdminAccessDeleteRegValue(HKCU,key,"Progid");  //win8
               }
          }
     }

  return 0; //unused
}


static void UnregisterExtensions(const char *subname)
{
  char progid[MAX_PATH];
  char progid_back[MAX_PATH];
  char key_progid[MAX_PATH];
  char key_progid_back[MAX_PATH];

  wsprintf(progid,"RunpadPro.%s",subname);
  wsprintf(progid_back,"RunpadPro.%s.back",subname);
  wsprintf(key_progid,REG_CLASSES "%s",progid);
  wsprintf(key_progid_back,REG_CLASSES "%s",progid_back);

  EnumerateRegistryValues(HKCU,key_progid_back,UnregisterSingleExt,(void*)progid);
  DeleteRegKey(HKCU,key_progid_back);
}


void RegUnregExtensions(BOOL state,const char *subname,const char *path,int icon_idx,const char *desc,const char *list)
{
  UnregisterExtensions(subname);
  DeleteProgid(subname);

  if ( state )
     {
       WriteProgid(subname,path,icon_idx,desc);
       RegisterExtensions(list,subname);
     }
}


static void RegisterProtocols(const char *subname,const char *path,const char *list)
{
  int n,count;
  char **protos;
  char cmdline[MAX_PATH];

  if ( path[0] == '$' )
     {
       wsprintf(cmdline,"\"%s%s.exe\" \"%%1\"",our_currpath,&path[1]);
     }
  else
     {
       char s[MAX_PATH];
       lstrcpy(s,path);
       PathUnquoteSpaces(s);
       wsprintf(cmdline,"\"%s\" \"%%1\"",s);
     }

  count = 0;
  protos = ConvertList2Ar(list,&count,FALSE);

  // save protos
  for ( n = 0; n < count; n++ )
      {
        if ( lstrlen(protos[n]) > 0 )
           {
             char key[MAX_PATH];
             char s[MAX_PATH];

             wsprintf(key,"%s%s%s",REG_CLASSES,protos[n],"\\shell\\open\\command");
             ReadRegStr(HKCU,key,NULL,s,"");

             if ( lstrcmpi(s,cmdline) )
                {
                  char from[MAX_PATH];
                  char to[MAX_PATH];

                  wsprintf(from,"%s%s",REG_CLASSES,protos[n]);
                  wsprintf(to,"%sRunpadPro.%s.back2\\%s",REG_CLASSES,subname,protos[n]);
                  
                  RegCopyKey(HKCU,from,to);
                }
           }
      }

  // set new protos
  for ( n = 0; n < count; n++ )
      {
        if ( lstrlen(protos[n]) > 0 )
           {
             char key[MAX_PATH];
             char t[MAX_PATH];

             wsprintf(key,"%s%s",REG_CLASSES,protos[n]);
             DeleteRegKey(HKCU,key);

             lstrcpy(t,key);
             WriteRegDword(HKCU,t,"EditFlags",2);
             WriteRegStr(HKCU,t,"URL Protocol","");
             WriteRegStr(HKCU,t,"Source Filter","");

             lstrcpy(t,key);
             lstrcat(t,"\\shell\\open\\command");
             WriteRegStr(HKCU,t,NULL,cmdline);

             lstrcpy(t,key);
             lstrcat(t,"\\shell\\open\\ddeexec");
             WriteRegStr(HKCU,t,NULL,"");

             wsprintf(key,"Software\\Microsoft\\Windows\\Shell\\Associations\\UrlAssociations\\%s\\UserChoice",protos[n]);
             AdminAccessDeleteRegValue(HKCU,key,"Progid"); //win7

             wsprintf(key,"Software\\Microsoft\\Windows\\Roaming\\OpenWith\\UrlAssociations\\%s\\UserChoice",protos[n]);
             AdminAccessDeleteRegValue(HKCU,key,"Progid"); //win8
           }
      }

  FreeListAr(protos,count);
}


static int UnregisterSingleProto(HKEY h,const char *name,void *param)
{
  char *key = (char*)param;

  char s[MAX_PATH];
  char t[MAX_PATH];

  wsprintf(t,"%s\\%s\\shell\\open\\command",key,name);
  ReadRegStr(HKCU,t,NULL,s,"");

  if ( s[0] )
     {
       char from[MAX_PATH];
       char to[MAX_PATH];

       wsprintf(from,"%s\\%s",key,name);
       wsprintf(to,"%s%s",REG_CLASSES,name);
       RegCopyKey(HKCU,from,to);
     }
  else
     {
       wsprintf(t,"%s%s",REG_CLASSES,name);
       DeleteRegKey(HKCU,t);
     }

  return 0; //unused
}


static void UnregisterProtocols(const char *subname)
{
  char key[MAX_PATH];

  wsprintf(key,"%sRunpadPro.%s.back2",REG_CLASSES,subname);
  EnumerateRegistryKeys(HKCU,key,UnregisterSingleProto,(void*)key);
  DeleteRegKey(HKCU,key);
}


void RegUnregProtocols(BOOL state,const char *subname,const char *path,const char *list)
{
  UnregisterProtocols(subname);

  if ( state )
     {
       RegisterProtocols(subname,path,list);
     }
}


BOOL IsFileAssociationSetInRegistry(const char *filepath)
{
  BOOL rc = FALSE;
  
  if ( !IsStrEmpty(filepath) )
     {
       const char *ext = PathFindExtension(filepath);
       if ( !IsStrEmpty(ext) )
          {
            char progid[MAX_PATH] = "";
            ReadRegStr(HKEY_CLASSES_ROOT,ext,NULL,progid,"");
            if ( !IsStrEmpty(progid) )
               {
                 char key[MAX_PATH];
                 sprintf(key,"%s\\shell\\open\\command",progid);
                 char cmdline[MAX_PATH] = "";
                 ReadRegStr(HKEY_CLASSES_ROOT,key,NULL,cmdline,"");
                 if ( !IsStrEmpty(cmdline) )
                    {
                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}

