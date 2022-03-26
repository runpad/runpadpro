
#include "include.h"

// !!!!!!!!!!!!!!!!!!!!!!!!!!
// !!! All functions here can be called from our SERVICE !!!
// !!!!!!!!!!!!!!!!!


void InstallGina(BOOL state,void *p1,void *p2,void *p3)
{
  if ( !IsVistaLonghorn() && !IsWOW64() )
     { // code only for x86:
       const char* RP_GINA = "rpgina.dll";
       const char* MS_GINA = "msgina.dll";
       const char* CTX_GINA = "ctxgina.dll";
       const char* NW_GINA = "nwgina.dll";
       const char* winlogon_key = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";
       
       char old_gina[MAX_PATH];
       ReadRegStr(HKLM,winlogon_key,"GinaDLL",old_gina,"");

       if ( state )
          {
            BOOL can_set = !lstrcmpi(old_gina,"") || !lstrcmpi(old_gina,MS_GINA) || !lstrcmpi(old_gina,CTX_GINA) || !lstrcmpi(old_gina,NW_GINA);

            if ( can_set )
               {
                 char dest[MAX_PATH] = "";
                 GetFileNameInTrueSystem32Dir(RP_GINA,dest);

                 if ( IsFileExist(dest) )
                    {
                      WriteRegStr(HKLM,winlogon_key,"RPSaveGinaDLL",old_gina);
                      WriteRegStr(HKLM,winlogon_key,"GinaDLL",RP_GINA);
                    }
               }
          }
       else
          {
            BOOL can_remove = !lstrcmpi(PathFindFileName(old_gina),RP_GINA);

            if ( can_remove )
               {
                 char saved_gina[MAX_PATH];
                 ReadRegStr(HKLM,winlogon_key,"RPSaveGinaDLL",saved_gina,"");

                 if ( !saved_gina[0] )
                    DeleteRegValue(HKLM,winlogon_key,"GinaDLL");
                 else
                    WriteRegStr(HKLM,winlogon_key,"GinaDLL",saved_gina);
               }

            DeleteRegValue(HKLM,winlogon_key,"RPSaveGinaDLL");
          }
     }
}


void SetAlternateShell(BOOL state,void *p1,void *p2,void *p3)
{
  char s[MAX_PATH] = "";
   
  if ( state )
     {
       GetFileNameInLocalAppDir("rshell.exe",s);
     }
  else
     {
       lstrcpy(s,"cmd.exe");
     }

  WriteRegStr(HKLM,"SYSTEM\\CurrentControlSet\\Control\\SafeBoot","AlternateShell",s);
  //WriteRegStr(HKLM,"SYSTEM\\ControlSet001\\Control\\SafeBoot","AlternateShell",s);
  //WriteRegStr(HKLM,"SYSTEM\\ControlSet002\\Control\\SafeBoot","AlternateShell",s);
}


void ShellExecuteDisablePrepare(BOOL state,void *p1,void *p2,void *p3)
{
  if ( state )
     {
       WriteRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellExecuteHooks","{9BE88898-18E7-4528-8886-6358AAC2A61A}","");
       WriteRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellExecuteHooks","{9BE88898-18E7-4528-8886-6358AAC2A61A}","");
     }
  else
     {
       DeleteRegValue(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellExecuteHooks","{9BE88898-18E7-4528-8886-6358AAC2A61A}");
       DeleteRegValue64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellExecuteHooks","{9BE88898-18E7-4528-8886-6358AAC2A61A}");
     }
}


static void ProcessInstallRestricts()
{
  InstallGina(TRUE,NULL,NULL,NULL);
  SetAlternateShell(TRUE,NULL,NULL,NULL);
  ShellExecuteDisablePrepare(TRUE,NULL,NULL,NULL);
}


static void AddOurAppPath_FromSVC()
{
  char currpath[MAX_PATH] = "";
  char exe[MAX_PATH] = "";
  GetModuleFileName(GetModuleHandle(NULL),exe,sizeof(exe));
  PathRemoveFileSpec(exe);
  lstrcpy(currpath,exe);
  PathAppend(exe,"rshell.exe");
  
  WriteRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe",NULL,exe);
  WriteRegStr(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe","Path",currpath);
  WriteRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe",NULL,exe);
  WriteRegStr64(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\rshell.exe","Path",currpath);
}


static void InstallUninstallOurClassesInternal(BOOL b_inst)
{
  char s[MAX_PATH] = "";

  // RS_API
  GetFileNameInTrueSystem32Dir("rs_api.dll",s);
  if ( b_inst )
     ActiveXRegisterFromDLL32(s);
  else
     ActiveXUnregisterFromDLL32(s);

  // VintaSoft twain
  GetFileNameInLocalAppDir("VSTwain.dll",s);
  if ( b_inst )
     ActiveXRegisterFromDLL32(s);
  else
     ActiveXUnregisterFromDLL32(s);

  // CopyHook
  GetFileNameInLocalAppDir("rsexhook.dll",s);
  if ( b_inst )
     ActiveXRegister32("{CE2606AC-0A84-4272-97B0-04FF67BA05B6}","Runpad CopyHook",s,"Apartment",NULL);
  else
     ActiveXUnregister32("{CE2606AC-0A84-4272-97B0-04FF67BA05B6}");

  if ( IsWOW64() )
     {
       GetFileNameInLocalAppDir("rsexhook64.dll",s);
       if ( b_inst )
          ActiveXRegister64("{CE2606AC-0A84-4272-97B0-04FF67BA05B6}","Runpad CopyHook",s,"Apartment",NULL);
       else
          ActiveXUnregister64("{CE2606AC-0A84-4272-97B0-04FF67BA05B6}");
     }

  // ShellExecuteHook
  GetFileNameInLocalAppDir("rsexhook.dll",s);
  if ( b_inst )
     ActiveXRegister32("{9BE88898-18E7-4528-8886-6358AAC2A61A}","Runpad ShellExecuteHook",s,"Apartment",NULL);
  else
     ActiveXUnregister32("{9BE88898-18E7-4528-8886-6358AAC2A61A}");

  if ( IsWOW64() )
     {
       GetFileNameInLocalAppDir("rsexhook64.dll",s);
       if ( b_inst )
          ActiveXRegister64("{9BE88898-18E7-4528-8886-6358AAC2A61A}","Runpad ShellExecuteHook",s,"Apartment",NULL);
       else
          ActiveXUnregister64("{9BE88898-18E7-4528-8886-6358AAC2A61A}");
     }

  //Vista Open/Save dialogs replacement
  if ( IsVistaLonghorn() )
     {
       if ( 1 )
          { // 32-bit processing
            CRegEmptySD g1(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32");
            CRegEmptySD g2(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32");
            
            if ( b_inst )
               {
                 GetFileNameInLocalAppDir("rsexhook.dll",s);
                 WriteRegStr(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32",NULL,s);
                 WriteRegStr(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32",NULL,s);
               }
            else
               {
                 if ( !IsWOW64() )
                    {
                      WriteRegStrExp(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32",NULL,"%SystemRoot%\\System32\\comdlg32.dll");
                      WriteRegStrExp(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32",NULL,"%SystemRoot%\\System32\\comdlg32.dll");
                    }
                 else
                    {
                      WriteRegStrExp(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32",NULL,"%SystemRoot%\\SysWOW64\\comdlg32.dll");
                      WriteRegStrExp(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32",NULL,"%SystemRoot%\\SysWOW64\\comdlg32.dll");
                    }
               }
          }

       if ( IsWOW64() )
          { // 64-bit processing
            CRegEmptySD64 g1(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32");
            CRegEmptySD64 g2(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32");
            
            if ( b_inst )
               {
                 GetFileNameInLocalAppDir("rsexhook64.dll",s);
                 WriteRegStr64(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32",NULL,s);
                 WriteRegStr64(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32",NULL,s);
               }
            else
               {
                 WriteRegStrExp64(HKLM,REG_CLASSES "CLSID\\{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}\\InProcServer32",NULL,"%SystemRoot%\\System32\\comdlg32.dll");
                 WriteRegStrExp64(HKLM,REG_CLASSES "CLSID\\{C0B4E2F3-BA21-4773-8DBA-335EC946EB8B}\\InProcServer32",NULL,"%SystemRoot%\\System32\\comdlg32.dll");
               }
          }
     }

  // BodyOffice2003
  GetFileNameInLocalAppDir("bodyoffice.dll",s);
  if ( b_inst )
     ActiveXRegister32("{AF4A3307-8DDE-4702-9626-38DD2ACBA6A8}","DTExtensibility2 Object for BodyOffice",s,"Apartment",
                       "BodyOffice2003.DTExtensibility2");
  else
     ActiveXUnregister32("{AF4A3307-8DDE-4702-9626-38DD2ACBA6A8}");

  // BodyOffice2000
  GetFileNameInLocalAppDir("bodyoffice2000.dll",s);
  if ( b_inst )
     ActiveXRegister32("{71D42717-EA87-48F1-B263-C5299F4FEF9F}","DTExtensibility2 Object for BodyOffice2000",s,"Apartment",
                       "BodyOffice2000.DTExtensibility2");
  else
     ActiveXUnregister32("{71D42717-EA87-48F1-B263-C5299F4FEF9F}");
}


void InstallOurClasses()
{
  InstallUninstallOurClassesInternal(TRUE);
}


void UninstallOurClasses()
{
  InstallUninstallOurClassesInternal(FALSE);
}


static void InstallOurClasses_FromSVC()
{
  CoInitialize(0);
  InstallOurClasses();
  CoUninitialize();
}


// remove some left from old versions of Runpad/RunpadPro 
void RemoveOldClassEntries()
{
  // VintaSoft twain
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{1169e0cd-9e76-11d7-b1d8-fb63945de96d}");
  DeleteRegKey(HKCU,"Software\\Classes\\TypeLib\\{1169E0C0-9E76-11D7-B1D8-FB63945DE96D}");

  // RS_API
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{D163EEE3-540A-48DA-9009-C194588263B9}");
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{D7346301-B73F-4a94-ABE6-234A0D49521D}");
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{3D4B9FF0-329A-4ed9-A341-B07AE052B7D6}");

  // CopyHook/ShellExecuteHook
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{9BE88898-18E7-4528-8886-6358AAC2A61A}");
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{CE2606AC-0A84-4272-97B0-04FF67BA05B6}");

  // BodyOffice
  DeleteRegKey(HKCU,"Software\\Classes\\BodyOffice.DTExtensibility2");
  DeleteRegKey(HKCU,"Software\\Classes\\CLSID\\{9B2B70C4-2C32-11D5-9F20-900E36B9145B}");
}


void InstallCPUTempDriver()
{
  if ( !IsWOW64() )
     {
       char s[MAX_PATH] = "";
       GetFileNameInLocalAppDir("giveio.sys",s);
       CDriverMgr("giveio").Install(s);
     }
}


void UninstallCPUTempDriver()
{
  if ( !IsWOW64() )
     {
       CDriverMgr("giveio").Uninstall();
     }
}


static void InstallCPUTempDriver_FromSVC()
{
  InstallCPUTempDriver();
}


// for call from service!
void InstallActions_FromSVC()
{
  AddOurAppPath_FromSVC();
  InstallOurClasses_FromSVC();
  InstallCPUTempDriver_FromSVC();
  ProcessInstallRestricts();
}


