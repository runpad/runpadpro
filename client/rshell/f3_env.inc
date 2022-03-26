

class CEnvVars
{
          typedef std::vector<char*> TNames;
          TNames names;

  public:
          CEnvVars();
          ~CEnvVars();
          
          void SetVar(const char *name,const char *value);
          void DeleteVar(const char *name);
          void DeleteAll();
};


static CEnvVars g_envvars;


CEnvVars::CEnvVars()
{
}

CEnvVars::~CEnvVars()
{
  // we do not clear vars here!
  
  for ( int n = 0; n < names.size(); n++ )
      {
        if ( names[n] )
           {
             sys_free(names[n]);
             names[n] = NULL;
           }
      }

  names.clear();
}

void CEnvVars::SetVar(const char *name,const char *value)
{
  if ( name && name[0] )
     {
       if ( value && value[0] )
          {
            WriteRegStr(HKCU,"Environment",name,value);
            SetEnvironmentVariable(name,value);

            BOOL find = FALSE;
            for ( int n = 0; n < names.size(); n++ )
                {
                  if ( !lstrcmpi(names[n],name) )
                     {
                       find = TRUE;
                       break;
                     }
                }

            if ( !find )
               {
                 names.push_back(sys_copystring(name));
               }
          }
       else
          {
            DeleteVar(name);
          }
     }
}

void CEnvVars::DeleteVar(const char *name)
{
  if ( name && name[0] )
     {
       for ( TNames::iterator it = names.begin(); it != names.end(); ++it )
           {
             if ( !lstrcmpi(*it,name) )
                {
                  DeleteRegValue(HKCU,"Environment",name);
                  SetEnvironmentVariable(name,NULL);

                  sys_free(*it);
                  names.erase(it);
                  break;
                }
           }
     }
}

void CEnvVars::DeleteAll()
{
  do {

   TNames::iterator it = names.begin();
   if ( it == names.end() )
      break;

   char *s = sys_copystring(*it);
   DeleteVar(s);
   sys_free(s);

  } while ( 1 );
}



void SetSingleEnvVar(const char *name,const char *value,BOOL is_path)
{
  if ( is_path )
     {
       char *path = sys_copystring(value);
       PathRemoveBackslash(path);
       g_envvars.SetVar(name,path);
       sys_free(path);
     }
  else
     {
       g_envvars.SetVar(name,value);
     }
}


void DeleteSingleEnvVar(const char *name)
{
  g_envvars.DeleteVar(name);
}


void DeleteAllEnvVars()
{
  g_envvars.DeleteAll();
}


static void WriteShellUserFolderPath(const char *name,const char *path)
{
  const char *key = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders";
  char s[MAX_PATH];
         
  if ( !PathUnExpandEnvStrings(path,s,sizeof(s)) )
     lstrcpy(s,path);

  PathRemoveBackslash(s);
  WriteRegStrExp(HKCU,key,name,s);
}


static void ReadShellUserFolderPath(const char *name,char *path)
{
  ReadRegStr(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders",name,path,"");
}


static void DeleteShellUserFolderPath(const char *name)
{
  DeleteRegValue(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\User Shell Folders",name);
}


static char* GetDefaultShellUserFolderPath(int id,char *path)
{
  path[0] = 0;
  SHGetFolderPath(NULL,id,NULL,SHGFP_TYPE_DEFAULT,path);
  PathRemoveBackslash(path);
  return path;
}


static void NotifyAboutShellUserFolderChange(int id)
{
  LPITEMIDLIST pidl = NULL;

  SHGetSpecialFolderLocation(NULL,id,&pidl);

  if ( pidl )
     {
       LPMALLOC pMalloc = NULL;

       SHChangeNotify(SHCNE_UPDATEITEM,SHCNF_IDLIST,pidl,NULL);

       SHGetMalloc(&pMalloc);
       if ( pMalloc ) 
          {
            pMalloc->Free(pidl);
            pMalloc->Release();
          }
     }
}


static void FlushShellCache(void)
{
  typedef void (WINAPI *TSHFlushSFCache)(void);
  TSHFlushSFCache pSHFlushSFCache = (TSHFlushSFCache)GetProcAddress(GetModuleHandle("shell32.dll"),"SHFlushSFCache");
  if ( pSHFlushSFCache )
     pSHFlushSFCache();
}


static void RedirectSingleFolder(int state,const char *name,const char *foldername,int id,BOOL use_personal_path)
{
  char s[MAX_PATH];
  char qname[MAX_PATH];

  wsprintf(qname,"~%s",name);

  if ( state )
     {
       // save old path
       ReadShellUserFolderPath(qname,s);
       if ( !s[0] )
          {
            ReadShellUserFolderPath(name,s);
            if ( !s[0] )
               GetDefaultShellUserFolderPath(id,s);
            if ( !s[0] )
               return;
            WriteShellUserFolderPath(qname,s);
          }

       // write new path
       lstrcpy(s,vip_folder);
       PathAddBackslash(s);
       CreateDirectory(s,NULL);
       lstrcat(s,"My Settings");
       PathAddBackslash(s);
       CreateDirectory(s,NULL);
       lstrcat(s,foldername);
       PathAddBackslash(s);
       CreateDirectory(s,NULL);
       PathRemoveBackslash(s);
       WriteShellUserFolderPath(name,s);
     }
  else
     {
       ReadShellUserFolderPath(qname,s);
       DeleteShellUserFolderPath(qname);

       if ( use_personal_path && personal_path[0] )
          {
            char t[MAX_PATH] = "";
            
            if ( !lstrcmpi(personal_path,"$default") )
               GetDefaultShellUserFolderPath(id,t);
            else
            if ( !lstrcmpi(personal_path,"$user_folder") )
               lstrcpy(t,user_folder);
            else
               lstrcpy(t,personal_path);

            ExpandPath(t);
            PathRemoveBackslash(t);
            
            if ( t[0] && PathIsDirectory(t) )
               lstrcpy(s,t);
          }

       if ( s[0] )
          WriteShellUserFolderPath(name,s);
     }
}


static void RedirectSysFoldersInternal(int state)
{
  if ( state && !vip_folder[0] )
     state = 0;

  RedirectSingleFolder(state && redirect_personal,"Personal","My documents",CSIDL_PERSONAL,TRUE);
  RedirectSingleFolder(state && redirect_personal,"My Pictures","My Pictures",CSIDL_MYPICTURES,TRUE);
  RedirectSingleFolder(state && redirect_appdata,"AppData","Application Data",CSIDL_APPDATA,FALSE);
  RedirectSingleFolder(state && redirect_localappdata,"Local AppData","Local Application Data",CSIDL_LOCAL_APPDATA,FALSE);
  
  FlushShellCache();
  NotifyAboutShellUserFolderChange(CSIDL_PERSONAL);
  NotifyAboutShellUserFolderChange(CSIDL_MYPICTURES);
  NotifyAboutShellUserFolderChange(CSIDL_APPDATA);
  NotifyAboutShellUserFolderChange(CSIDL_LOCAL_APPDATA);
  FlushShellCache();
}


static void RedirectSysFolders(int state)
{
  RedirectSysFoldersInternal(!state);
  RedirectSysFoldersInternal(state);
}


void SetShellEnvStrings(void)
{
  SetSingleEnvVar("RS_FOLDER",our_currpath,TRUE);
  SetSingleEnvVar("RS_MACHINE",machine_desc);
  SetSingleEnvVar("RS_LOC",machine_loc);
  SetSingleEnvVar("RS_VIPSESSION",vip_session);
  SetSingleEnvVar("RS_VIPFOLDER",vip_folder,TRUE);
  SetSingleEnvVar("RS_USERFOLDER",user_folder,TRUE);
//  SendMessageTimeout( (HWND)-1, WM_WININICHANGE, 0, (LPARAM)"Environment", SMTO_ABORTIFHUNG, 1000, NULL );

  RedirectSysFolders(vip_session[0] && redirect_sys_folders);
}


void ClearShellEnvStrings(void)
{
  DeleteAllEnvVars();

// lockdown in GlobalDone
//  SendMessageTimeout( (HWND)-1, WM_WININICHANGE, 0, (LPARAM)"Environment", SMTO_ABORTIFHUNG, 1000, NULL );

  RedirectSysFolders(FALSE);
}

