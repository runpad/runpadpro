


CShellObjDelayLoad::CShellObjDelayLoad()
{
  ZeroMemory(shellobj,sizeof(shellobj));
  num_shellobj = 0;

  
  if ( !is_vista )
     {
       const char *key = "Software\\Microsoft\\Windows\\CurrentVersion\\ShellServiceObjectDelayLoad";
       EnumerateRegistryValues(HKLM,key,EnumSOFunc,this);
     }
  else
     {
       // in Vista we must iterate KEYS also in HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellServiceObject
       // but in this hive SysTray not present, but required. Also some objects are duplicated with SysTray sub-part
       // so we load only some objects inplicity:
       const char* ids[] =
       {
         //  "{68ddbb56-9d1d-4fd9-89c5-c0da2a625392}",   //UnexpectedShutdownReason  (stobject.dll)
         //  "{6FDEDD65-AC51-43CA-B2D0-9EB5D1155D03}",   //MediaCenterSSO Class
         //  "{7007ACCF-3202-11D1-AAD2-00805FC1270E}",    //Network Connections Tray
//?         "{7849596a-48ea-486e-8937-a2a3009f31a9}",    //PostBootReminder
         //  "{A1607060-5D4C-467a-B711-2B59A6F25957}",   //AltTab
         //  "{AAA288BA-9A4C-45B0-95D7-94D524869DB5}",   //WPDShServiceObj Class  (Portable devices)
         //  "{C51F0A6B-2A63-4cf4-8938-24404EAEF422}",   //cscui.dll  (Cleint Side Caching - offline files)
         //  "{DA67B8AD-E81B-4c70-9B91-B417B5E33527}",  //Search Shell
         //  "{F20487CC-FC04-4B1E-863F-D9801796130B}",  //SyncCenterShell (internal) (synccenter.dll) - uses tray icon
//?         "{fbeb8a05-beee-4442-804e-409d6c4515e9}",  // ShellFolder for CDBurning
         //  "{FD6905CE-952F-41F1-9A6F-135D9C6622CC}",  //WscNotify   windows security center
         //  "{3BF043EF-A974-49B3-8322-B853CF1E5EC5}",  //Sound volume control service 
         //"{E6FB5E20-DE35-11CF-9C87-00AA005127ED}",     //WebCheck
         "{35CEC8A3-2BE6-11D2-8773-92E220524153}", //SysTray (must be last! ???)
       };

       for ( int n = 0; n < sizeof(ids)/sizeof(ids[0]); n++ )
           {
             AddShellObj(ids[n]);
           }
     }
}


CShellObjDelayLoad::~CShellObjDelayLoad()
{
  for ( int n = num_shellobj-1; n >= 0; n-- )
      {
        FreeShellObj(shellobj[n]);
        shellobj[n] = NULL;
      }

  num_shellobj = 0;
}


int CShellObjDelayLoad::EnumSOFunc(const char *name,const char *data,void *param)
{
  if ( !IsStrEmpty(data) )
     {
       if ( param )
          {
            CShellObjDelayLoad *obj = (CShellObjDelayLoad*)param;
            
            obj->AddShellObj(data);
          }
     }

  return 1;
}


void CShellObjDelayLoad::AddShellObj(const char *name)
{
  if ( !IsStrEmpty(name) )
     {
       if ( num_shellobj < MAXSHELLOBJ )
          {
            WCHAR wszCLSID[MAX_PATH];
            CLSID clsid;
            IOleCommandTarget *obj = NULL;

            wszCLSID[0] = 0;
            MultiByteToWideChar(CP_ACP,0,name,-1,wszCLSID,MAX_PATH);
            CLSIDFromString(wszCLSID,&clsid);

            CoCreateInstance(clsid,NULL,CLSCTX_INPROC_SERVER | CLSCTX_INPROC_HANDLER,IID_IOleCommandTarget,(void **)&obj);

            if ( obj )
               {
                 try
                 {
                   obj->Exec(&CGID_ShellServiceObject,2,0,NULL,NULL);
                 }
                 catch ( ... )
                 {
                 }

                 shellobj[num_shellobj] = obj;
                 num_shellobj++;
               }
          }
     }
}


void CShellObjDelayLoad::FreeShellObj(IOleCommandTarget *obj)
{
  if ( obj )
     {
       try
       {
         obj->Exec(&CGID_ShellServiceObject,3,0,NULL,NULL);
       }
       catch ( ... )
       {
       }

       obj->Release();
     }
}


