

void ActiveXRegister32(const char *classid,const char *desc,const char *dll,const char *model,const char *progid)
{
  char s[MAX_PATH];

  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  WriteRegStr(HKLM,s,NULL,desc);
  lstrcat(s,"\\InprocServer32");
  WriteRegStr(HKLM,s,NULL,dll);
  WriteRegStr(HKLM,s,"ThreadingModel",model);

  if ( progid && progid[0] )
     {
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       WriteRegStr(HKLM,s,NULL,desc);
       lstrcat(s,"\\Clsid");
       WriteRegStr(HKLM,s,NULL,classid);

       lstrcpy(s,REG_CLASSES "CLSID\\");
       lstrcat(s,classid);
       lstrcat(s,"\\ProgID");
       WriteRegStr(HKLM,s,NULL,progid);
     }
}


void ActiveXUnregister32(const char *classid)
{
  char s[MAX_PATH];
  char progid[MAX_PATH];

  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\ProgID");
  ReadRegStr(HKLM,s,NULL,progid,"");
  
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\ProgID");
  DeleteRegKeyNoRec(HKLM,s);
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\InprocServer32");
  DeleteRegKeyNoRec(HKLM,s);
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  DeleteRegKeyNoRec(HKLM,s);

  if ( progid[0] )
     {
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       lstrcat(s,"\\Clsid");
       DeleteRegKeyNoRec(HKLM,s);
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       DeleteRegKeyNoRec(HKLM,s);
     }
}


void ActiveXRegister64(const char *classid,const char *desc,const char *dll,const char *model,const char *progid)
{
  char s[MAX_PATH];

  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  WriteRegStr64(HKLM,s,NULL,desc);
  lstrcat(s,"\\InprocServer32");
  WriteRegStr64(HKLM,s,NULL,dll);
  WriteRegStr64(HKLM,s,"ThreadingModel",model);

  if ( progid && progid[0] )
     {
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       WriteRegStr64(HKLM,s,NULL,desc);
       lstrcat(s,"\\Clsid");
       WriteRegStr64(HKLM,s,NULL,classid);

       lstrcpy(s,REG_CLASSES "CLSID\\");
       lstrcat(s,classid);
       lstrcat(s,"\\ProgID");
       WriteRegStr64(HKLM,s,NULL,progid);
     }
}


void ActiveXUnregister64(const char *classid)
{
  char s[MAX_PATH];
  char progid[MAX_PATH];

  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\ProgID");
  ReadRegStr64(HKLM,s,NULL,progid,"");
  
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\ProgID");
  DeleteRegKeyNoRec64(HKLM,s);
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  lstrcat(s,"\\InprocServer32");
  DeleteRegKeyNoRec64(HKLM,s);
  lstrcpy(s,REG_CLASSES "CLSID\\");
  lstrcat(s,classid);
  DeleteRegKeyNoRec64(HKLM,s);

  if ( progid[0] )
     {
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       lstrcat(s,"\\Clsid");
       DeleteRegKeyNoRec64(HKLM,s);
       lstrcpy(s,REG_CLASSES);
       lstrcat(s,progid);
       DeleteRegKeyNoRec64(HKLM,s);
     }
}


void ActiveXRegisterFromDLL32(const char *dll)
{
  UINT old_err = SetErrorMode(SEM_FAILCRITICALERRORS|SEM_NOGPFAULTERRORBOX|SEM_NOOPENFILEERRORBOX);
  HINSTANCE lib = LoadLibrary(dll);
  SetErrorMode(old_err);

  if ( lib )
     {
       typedef HRESULT (__stdcall *TDllRegisterServer)(void);
       
       TDllRegisterServer pDllRegisterServer = (TDllRegisterServer)GetProcAddress(lib,"DllRegisterServer");
       if ( pDllRegisterServer )
          pDllRegisterServer();

       FreeLibrary(lib);
     }
}


void ActiveXUnregisterFromDLL32(const char *dll)
{
  UINT old_err = SetErrorMode(SEM_FAILCRITICALERRORS|SEM_NOGPFAULTERRORBOX|SEM_NOOPENFILEERRORBOX);
  HINSTANCE lib = LoadLibrary(dll);
  SetErrorMode(old_err);

  if ( lib )
     {
       typedef HRESULT (__stdcall *TDllUnregisterServer)(void);
       
       TDllUnregisterServer pDllUnregisterServer = (TDllUnregisterServer)GetProcAddress(lib,"DllUnregisterServer");
       if ( pDllUnregisterServer )
          pDllUnregisterServer();

       FreeLibrary(lib);
     }
}

