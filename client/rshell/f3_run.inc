
static WCHAR* GetOurEnvBlockW(void)
{
  WCHAR *rc = NULL;
  HANDLE token = NULL;
  
  if ( OpenProcessToken(GetCurrentProcess(),TOKEN_QUERY,&token) )
     {
       WCHAR *env = NULL;

       if ( CreateEnvironmentBlock((void**)&env,token,TRUE) )
          {
            rc = env;
          }

       CloseHandle(token);
     }

  return rc;
}


static void FreeEnvBlockW(WCHAR *env)
{
  if ( env )
     {
       DestroyEnvironmentBlock(env);
     }
}


static WCHAR* UpdatePathInEnvBlock(const WCHAR *env,const char *addstr)
{
  WCHAR *rc = NULL;

  if ( env && addstr && addstr[0] )
     {
       char delta[1024];

       lstrcpyn(delta,addstr,sizeof(delta)-1);
       DoEnvironmentSubst(delta,sizeof(delta));

       if ( delta[0] )
          {
            WCHAR deltaW[1024];

            if ( delta[lstrlen(delta)-1] != ';' )
               lstrcat(delta,";");

            deltaW[0] = 0;
            MultiByteToWideChar(CP_ACP,0,delta,-1,deltaW,sizeof(deltaW)/sizeof(deltaW[0]));

            if ( deltaW[0] )
               {
                 BOOL path_find=FALSE;
                 const WCHAR *p = env;
                 do {
                   if ( !StrCmpNIW(p,L"PATH=",5) )
                      {
                        if ( path_find )
                           return NULL; //really happens?

                        path_find = TRUE;
                      }
                   
                   p += lstrlenW(p) + 1;
                 } while ( *p );
                 p++;

                 if ( path_find )
                    {
                      int alloc_chars = p - env + lstrlenW(deltaW);
                      
                      {
                        WCHAR *dest = (WCHAR*)sys_alloc(alloc_chars*2);
                        WCHAR *q = dest;
                        const WCHAR *p = env;

                        do {
                         if ( !StrCmpNIW(p,L"PATH=",5) )
                            {
                              lstrcpynW(q,p,6);
                              lstrcatW(q,deltaW);
                              lstrcatW(q,p+5);
                            }
                         else
                            {
                              lstrcpyW(q,p);
                            }
                         q += lstrlenW(q) + 1;
                         p += lstrlenW(p) + 1;

                        } while ( *p );
                        *q++ = *p++;

                        rc = dest;
                      }
                    }
               }
          }
     }

  return rc;
}


static void GetAppPathExt(const char *s_exe,char *out)
{
  if ( s_exe && s_exe[0] )
     {
       char key[MAX_PATH];
       lstrcpy(key,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\");
       lstrcat(key,PathFindFileName(s_exe));
       ReadRegStr64(HKLM,key,"Path",out,"");

       if ( IsStrEmpty(out) )
          {
            ReadRegStr(HKLM,key,"Path",out,"");
          }
     }
  else
     {
       *out = 0;
     }
}


static WCHAR* CreateEnvBlockForUserW(const WCHAR *s_domain,const WCHAR *s_user)
{
  WCHAR *out = NULL;

  void *env = GetEnvironmentStringsW();
  if ( env )
     {
       std::wstring list;

       const WCHAR *p = (WCHAR*)env;

       while ( *p )
       {
         const WCHAR *equ = StrChrW(p,L'=');
         if ( equ )
            {
              char name[MAX_PATH] = "";
              lstrcpyn(name,CANSI(p),MIN(equ-p+1,MAX_PATH));

              std::wstring value;

              if ( !lstrcmpi(name,"USERPROFILE") )
                 {
                   WCHAR new_user_profile[MAX_PATH] = L"";
                   lstrcpyW(new_user_profile,equ+1);
                   if ( !IsStrEmpty(new_user_profile) )
                      {
                        PathRemoveBackslashW(new_user_profile);
                        PathRemoveFileSpecW(new_user_profile);
                        PathAppendW(new_user_profile,s_user);   // todo: not always true, ex. domain users?
                        value = new_user_profile;
                      }
                 }
              else
              if ( !lstrcmpi(name,"USERDOMAIN") )
                 {
                   value = s_domain;  
                 }
              else
              if ( !lstrcmpi(name,"USERNAME") )
                 {
                   value = s_user;  
                 }
              else
              if ( lstrcmpi(name,"APPDATA") && 
                   lstrcmpi(name,"LOCALAPPDATA") && 
                   lstrcmpi(name,"HOMEDRIVE") && 
                   lstrcmpi(name,"HOMEPATH") && 
                   lstrcmpi(name,"__COMPAT_LAYER") )
                 {
                   value = equ+1;
                 }

              if ( !value.empty() )
                 {
                   list += std::wstring((const WCHAR*)CUnicode(name)) + L'=' + value + L'\0';
                 }
            }

         p += lstrlenW(p) + 1;
       }

       if ( !list.empty() )
          {
            list += L'\0'; // final terminator

            int numchars = list.size();

            out = (WCHAR*)sys_alloc(numchars*2);
            CopyMemory(out,list.data(),numchars*2);
          }

       FreeEnvironmentStringsW((LPWSTR)env);
     }

  return out;
}


static int InternalRunAsAnotherUser(const char *s_exe,const char *s_arg,const char *s_cwd,const char *s_domain,const char *s_user,const char *s_password,int showcmd)
{
  int rc = -1;

  SetProcessPrivilege(SE_TCB_NAME);
  SetProcessPrivilege(SE_CHANGE_NOTIFY_NAME);
  SetProcessPrivilege("SeInteractiveLogonRight"/*SE_INTERACTIVE_LOGON_NAME*/);

  char s_path[MAX_PATH];
  WCHAR w_path[MAX_PATH] = {0,};
  WCHAR w_cwd[MAX_PATH] = {0,};
  WCHAR w_domain[MAX_PATH] = {0,};
  WCHAR w_user[MAX_PATH] = {0,};
  WCHAR w_password[MAX_PATH] = {0,};
  PROCESS_INFORMATION pi;
  STARTUPINFOW si;

  wsprintf(s_path,"\"%s\"",s_exe);
  if ( s_arg[0] )
     {
       lstrcat(s_path," ");
       lstrcat(s_path,s_arg);
     }
  
  MultiByteToWideChar(CP_ACP,0,s_path,-1,w_path,MAX_PATH);
  MultiByteToWideChar(CP_ACP,0,s_cwd,-1,w_cwd,MAX_PATH);
  MultiByteToWideChar(CP_ACP,0,s_domain,-1,w_domain,MAX_PATH);
  MultiByteToWideChar(CP_ACP,0,s_user,-1,w_user,MAX_PATH);
  MultiByteToWideChar(CP_ACP,0,s_password,-1,w_password,MAX_PATH);

  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = showcmd;

  ChangeProcessTerminateRights(0);

  WCHAR *new_env = CreateEnvBlockForUserW(w_domain,w_user);
  
  {
    CDisableWOW64FSRedirection fsg;
    
    if ( CreateProcessWithLogonW(w_user,w_domain,w_password,LOGON_WITH_PROFILE,NULL,w_path,
                             CREATE_UNICODE_ENVIRONMENT,new_env,w_cwd,&si,&pi) )
       {
         rc = pi.dwProcessId;

         ProcessGGApp(s_exe,pi.hProcess);
         CloseHandle(pi.hThread);
       }
  }

  SAFESYSFREE(new_env);

  ChangeProcessTerminateRights(1);

  return rc;
}


int IsCommandExtension(const char *ext)
{
  return ( !lstrcmpi(ext,".exe") || !lstrcmpi(ext,".com") || !lstrcmpi(ext,".bat") || !lstrcmpi(ext,".cmd") );
}


int IsLinkExtension(const char *ext)
{
  return ( !lstrcmpi(ext,".lnk") || !lstrcmpi(ext,".pif") );
}


void CreateUrlFile(const char *url,char *out)
{
  char s[MAX_PATH] = "";
  GetTempPath(sizeof(s),s);
  PathAppend(s,"rs_url.url");

  void *h = sys_fcreate(s);
  if ( h )
     {
       sys_fwrite_txt(h,"[InternetShortcut]\r\nURL=");
       sys_fwrite_txt(h,url?url:"");
       sys_fwrite_txt(h,"\r\n");
       sys_fclose(h);
     }

  lstrcpy(out,s);
}


//workaround for one stupid program
static void SpecialWorkaround(char *s_exe,char *s_arg,int *_showcmd)
{
  if ( !lstrcmpi(PathFindExtension(s_exe),".exe") )
     {
       char *name = PathFindFileName(s_exe);

       if ( lstrlen(name) >= 8 )
          {
            if ( (name[0] == 'W' || name[0] == 'w') &&
                 (name[1] == 'P' || name[1] == 'p') &&
                 (name[2] >= '0' && name[2] <= '9') &&
                 (name[3] >= '0' && name[3] <= '9') )
               {
                 char s[MAX_PATH];
                 char temp[MAX_PATH];
                 void *h;

                 s[0] = 0;
                 GetTempPath(sizeof(s),s);
                 PathAddBackslash(s);
                 CreateDirectory(s,NULL);
                 wsprintf(temp,"wpNNN_%02d.bat",GetTickCount()%100);
                 lstrcat(s,temp);

                 h = sys_fcreate(s);
                 if ( h )
                    {
                      char bat[MAX_PATH];
                      char cmd[MAX_PATH];

                      if ( *_showcmd == SW_SHOWMINIMIZED || 
                           *_showcmd == SW_SHOWMINNOACTIVE || 
                           *_showcmd == SW_MINIMIZE || 
                           *_showcmd == SW_HIDE || 
                           *_showcmd == SW_FORCEMINIMIZE )
                         {
                           lstrcpy(cmd,"/MIN ");
                         }
                      else
                      if ( *_showcmd == SW_SHOWMAXIMIZED )
                         {
                           lstrcpy(cmd,"/MAX ");
                         }
                      else
                         lstrcpy(cmd,"");

                      wsprintf(bat,"@echo off\nstart \"WP\" %s\"%s\"%s%s\nexit\n",cmd,s_exe,s_arg[0]?" ":"",s_arg);
                      sys_fwrite(h,bat,lstrlen(bat));
                      sys_fclose(h);

                      lstrcpy(s_exe,s);
                      lstrcpy(s_arg,"");
                      *_showcmd = SW_HIDE;
                    }
               }
          }
     }
}


int RunAsAnotherUser(const CRealShortcut *rsh)
{
  if ( !rsh || !rsh->GetExePath()[0] || PathIsURL(rsh->GetExePath()) )
     return -1;

  char domain[MAX_PATH];
  char user[MAX_PATH];
  char password[MAX_PATH];

  lstrcpy(domain,rsh->GetRunAsDomain());
  lstrcpy(user,rsh->GetRunAsUser());
  lstrcpy(password,rsh->GetRunAsPassword());

  if ( !user[0] /*|| !password[0]*/ )
     return -1;

  if ( !domain[0] )
     {
       char s[MAX_PATH];
       //lstrcpy(domain,GetDomainName(s));
       lstrcpy(domain,MyGetComputerName(s));
     }

  char s_exe[MAX_PATH];
  char s_arg[MAX_PATH];
  char s_cwd[MAX_PATH];

  lstrcpy(s_exe,rsh->GetExePath());
  lstrcpy(s_arg,rsh->GetArg());
  lstrcpy(s_cwd,rsh->GetCWD());
  int showcmd = rsh->GetShowCmd();

  SpecialWorkaround(s_exe,s_arg,&showcmd);

  if ( !IsCommandExtension(PathFindExtension(s_exe)) )
     return -1;

  {
    CDisableWOW64FSRedirection fsg;

    if ( !IsFileExist(s_exe) )
       return -1;
  }

  return InternalRunAsAnotherUser(s_exe,s_arg,s_cwd,domain,user,password,showcmd);
}


static int RunElevatedProcess(const char *s_exe,const char *s_arg,const char *s_cwd,int showcmd)
{
  CDisableWOW64FSRedirection fsg;

  int pid = -1;
  SHELLEXECUTEINFO i;

  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.fMask = SEE_MASK_FLAG_NO_UI | SEE_MASK_NOCLOSEPROCESS;
  i.hwnd = NULL;//GetMainWnd();
  i.lpFile = s_exe;
  i.lpParameters = s_arg;
  i.lpDirectory = s_cwd;
  i.nShow = showcmd;

  if ( ShellExecuteEx(&i) )
     {
       if ( i.hProcess )
          {
            typedef DWORD (WINAPI *TGetProcessId)(HANDLE hProcess);

            TGetProcessId pGetProcessId = (TGetProcessId)GetProcAddress(GetModuleHandle("kernel32.dll"),"GetProcessId");

            if ( pGetProcessId )
               {
                 pid = pGetProcessId(i.hProcess);
                 pid = pid ? pid : -1;
               }

            ProcessGGApp(s_exe,i.hProcess);
          }
     }

  return pid;
}


int RunAsThisUser(const CRealShortcut *rsh)
{
  if ( !rsh || !rsh->GetExePath()[0] )
     return -1;

  char s_exe[MAX_PATH];
  char s_arg[MAX_PATH];
  char s_cwd[MAX_PATH];

  int showcmd = rsh->GetShowCmd();

  BOOL is_url = PathIsURL(rsh->GetExePath());

  if ( !is_url )
     {
       lstrcpy(s_exe,rsh->GetExePath());
       lstrcpy(s_arg,rsh->GetArg());
       lstrcpy(s_cwd,rsh->GetCWD());
       SpecialWorkaround(s_exe,s_arg,&showcmd);
     }
  else
     {
       lstrcpy(s_exe,rsh->GetExePath()); //URL here
       s_arg[0] = 0;
       s_cwd[0] = 0;
     }
  
  if ( is_url || !IsCommandExtension(PathFindExtension(s_exe)) )
     {
       const char *ext = PathFindExtension(s_exe);
       BOOL is_pic_file = (!lstrcmpi(ext,".jpg") || !lstrcmpi(ext,".jpeg") || !lstrcmpi(ext,".bmp") || !lstrcmpi(ext,".png") || !lstrcmpi(ext,".gif") || !lstrcmpi(ext,".tif") || !lstrcmpi(ext,".tiff"));
       
       if ( !is_url && is_pic_file && IsWindows8OrHigher() )
          {
            // todo: special stupid workaround for Windows 10, need make correct code
            
            char s_imgview[MAX_PATH];
            GetFileNameInLocalAppDir("bodyimgview.exe",s_imgview);

            char cmdline[MAX_PATH];
            sprintf(cmdline,"\"%s\" \"%s\"",s_imgview,s_exe);

            STARTUPINFO si;
            PROCESS_INFORMATION pi;
            ZeroMemory(&si,sizeof(si));
            si.cb = sizeof(si);
            if ( CreateProcess(NULL,cmdline,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
               {
                 CloseHandle(pi.hProcess);
                 CloseHandle(pi.hThread);
               }
          }
       else
          {
            if ( (int)ShellExecute(NULL,NULL,s_exe,NULL,s_cwd,showcmd) <= 32 )
               ShellExecute(NULL,"open",s_exe,NULL,s_cwd,showcmd);
          }
     }
  else
     {
       STARTUPINFO si;
       PROCESS_INFORMATION pi;
       char s[MAX_PATH*2];
       BOOL rc;
       char ext_path[MAX_PATH];
       void *new_env = NULL;

       ext_path[0] = 0;
       GetAppPathExt(s_exe,ext_path);
       if ( ext_path[0] )
          {
            WCHAR *env = GetOurEnvBlockW();
            if ( env )
               {
                 new_env = UpdatePathInEnvBlock(env,ext_path);
                 FreeEnvBlockW(env);
               }
          }
       
       wsprintf(s,"\"%s\"",s_exe);
       if ( s_arg[0] )
          {
            lstrcat(s," ");
            lstrcat(s,s_arg);
          }

       ZeroMemory(&si,sizeof(si));
       si.cb = sizeof(si);
       si.dwFlags = STARTF_USESHOWWINDOW;
       si.wShowWindow = showcmd;

       int last_error = 0;
       
       {
         CDisableWOW64FSRedirection fsg;

         if ( new_env )
            rc = CreateProcess(NULL,s,NULL,NULL,FALSE,CREATE_UNICODE_ENVIRONMENT,new_env,s_cwd,&si,&pi);
         else
            rc = CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,s_cwd,&si,&pi);

         last_error = GetLastError();  // here!
       }

       if ( new_env )
          sys_free(new_env);
          
       if ( rc )
          {
            ProcessGGApp(s_exe,pi.hProcess);
            CloseHandle(pi.hThread);
            
            return pi.dwProcessId;
          }
       else
          {
            if ( last_error == 740/*ERROR_ELEVATION_REQUIRED*/ )
               {
                 return RunElevatedProcess(s_exe,s_arg,s_cwd,showcmd);
               }
          }
     }

  return -1;
}
