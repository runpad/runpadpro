

static int RunSingleRegEntry(const char *value,const char *data,void *param)
{
  int rc = 0;
  
  if ( !IsStrEmpty(value) && !IsStrEmpty(data) )
     {
       if ( lstrcmpi(value,"ctfmon.exe") && lstrcmpi(value,"internat.exe") )
          {
            if ( !StrStrI(data,"internt.exe") && !StrStrI(data,"internt") && 
                 !StrStrI(data,"usbn.exe") && !StrStrI(data,"sidebar.exe") )
               {
                 ExecTool(data,(BOOL)param);
                 rc++;
               }
          }
     }

  return rc;
}


static void RunFromReg(HKEY root,const char *path)
{
  EnumerateRegistryValues(root,path,RunSingleRegEntry,(void*)TRUE);
}


static void RunFromReg64(HKEY root,const char *path)
{
  EnumerateRegistryValues64(root,path,RunSingleRegEntry,(void*)FALSE);
}


static void DelFromReg(HKEY root,const char *path)
{
  HKEY h;
  DWORD size1,size2;
  char value[MAX_PATH];
  char data[MAX_PATH];

  if ( RegOpenKeyEx(root,path,0,KEY_WRITE|KEY_READ,&h) == ERROR_SUCCESS )
     {
       do {
        value[0] = 0;
        data[0] = 0;
        size1 = sizeof(value)-1;
        size2 = sizeof(data)-1;
        if ( RegEnumValue(h,0,value,&size1,NULL,NULL,(LPBYTE)data,&size2) != ERROR_SUCCESS )
           break;
        if ( RegDeleteValue(h,value) != ERROR_SUCCESS )
           break;
       } while (1);
       RegCloseKey(h);
     }
}


static void DelFromReg64(HKEY root,const char *path)
{
  HKEY h;
  DWORD size1,size2;
  char value[MAX_PATH];
  char data[MAX_PATH];

  if ( RegOpenKeyEx(root,path,0,KEY_WRITE|KEY_READ|GetWow64RegFlag64(),&h) == ERROR_SUCCESS )
     {
       do {
        value[0] = 0;
        data[0] = 0;
        size1 = sizeof(value)-1;
        size2 = sizeof(data)-1;
        if ( RegEnumValue(h,0,value,&size1,NULL,NULL,(LPBYTE)data,&size2) != ERROR_SUCCESS )
           break;
        if ( RegDeleteValue(h,value) != ERROR_SUCCESS )
           break;
       } while (1);
       RegCloseKey(h);
     }
}


static BOOL RunProc(const char *s,WIN32_FIND_DATA *f,void *user)
{
  ShellExecute(NULL,NULL,s,NULL,NULL,SW_SHOWNORMAL);
  return TRUE;
}


static DWORD WINAPI RunThreadProc(LPVOID lpParameter)
{
  CoInitialize(0);

  
  if ( welcome_path[0] )
     {
       char s[MAX_PATH];

       lstrcpy(s,welcome_path);
       
       if ( !PathIsURL(s) )
          {
            ExpandPath(s);
            if ( !IsFileExist(s) )
               s[0] = 0;
          }

       if ( s[0] )
          {
            char cmdline[MAX_PATH];
            wsprintf(cmdline,"$bodywb -simple \"%s\"",s);
            ExecTool(cmdline);
          }
     }
  
  for ( int n = 0; n < autorun_items.size(); n++ )
      {
        CCfgEntry2 *i = &autorun_items[n];

        if ( i->IsActive() )
           {
             ExecTool(i->GetParm2());
           }
      }
  
  if ( !disable_autorun )
     {
       if ( IsWOW64() )
          {
            RunFromReg64(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run");
            RunFromReg64(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
            RunFromReg64(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
            DelFromReg64(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
          }
       
       RunFromReg(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run");
       RunFromReg(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
       RunFromReg(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
       DelFromReg(HKLM,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");

       RunFromReg64(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\Run");
       RunFromReg64(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\Run");
       RunFromReg64(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");
       DelFromReg64(HKCU,"Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce");

       char s[MAX_PATH];
       s[0] = 0;
       GetSpecialFolder(CSIDL_COMMON_STARTUP,s);
       if ( s[0] )
          ScanDir(s,SCAN_FILE,RunProc,NULL);

       s[0] = 0;
       GetSpecialFolder(CSIDL_STARTUP,s);
       if ( s[0] )
          ScanDir(s,SCAN_FILE,RunProc,NULL);
     }


  {
    CShellObjDelayLoad oShellObj;

    MSG msg;
    while ( GetMessage(&msg,NULL,0,0) )
    {
      DispatchMessage(&msg);
    }
  }

  CoUninitialize();

  return 1;
}




static HANDLE h_autorun_thread = NULL;
static DWORD autorun_thread_id = -1;


void InitAutorun(void)
{
  if ( !h_autorun_thread )
     {
       h_autorun_thread = MyCreateThreadSelectedCPU(RunThreadProc,NULL,&autorun_thread_id);
     }
}


void DoneAutorun(void)
{
  if ( h_autorun_thread )
     {
       PostThreadMessage(autorun_thread_id,WM_QUIT,0,0);
       if ( WaitForSingleObject(h_autorun_thread,3000) == WAIT_TIMEOUT )
          {
            TerminateThread(h_autorun_thread,0);
          }

       CloseHandle(h_autorun_thread);
       h_autorun_thread = NULL;
       autorun_thread_id = -1;
     }
}

