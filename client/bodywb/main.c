
#include <windows.h>
#include <commctrl.h>
#include <shlobj.h>
#include <objbase.h>
#include <shlwapi.h>
#include <stdlib.h>
#include "../rp_shared/rp_shared.h"
#include "tools.h"
#include "download.h"
#include "config.h"
#include "../common/version.h"



HINSTANCE instance;


BOOL IsWin2000(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion == 5 && i.dwMinorVersion == 0 )
          return TRUE;
     }

  return FALSE;
}


BOOL SearchParam(const char *s)
{
  int n;
  
  for ( n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],s) )
         return TRUE;

  return FALSE;
}


BOOL IsSimple(void)
{
  return SearchParam("-simple");
}


BOOL IsNoTopMost(void)
{
  return SearchParam("-notopmost");
}



/////////////////////////////////

struct {
void *handle;
CRITICAL_SECTION section;
} hack_gco;

static void HackGCO(void);
static void UnhackGCO(void);


static HRESULT STDAPICALLTYPE My_CoGetClassObject(IN REFCLSID rclsid, IN DWORD dwClsContext, IN LPVOID pvReserved,
                    IN REFIID riid, OUT LPVOID FAR* ppv)
{
  HRESULT rc;
      
  // {D27CDB6E-AE6D-11CF-96B8-444553540000}
  static const GUID CLSID_FLASH = {0xD27CDB6E, 0xAE6D, 0x11CF, 0x96, 0xB8, 0x44, 0x45, 0x53, 0x54, 0x00, 0x00};
 
  if ( rclsid && !IsEqualIID(rclsid,&CLSID_FLASH) )
     {
       UnhackGCO();
       rc = CoGetClassObject(rclsid,dwClsContext,pvReserved,riid,ppv);
       HackGCO();
     }
  else
     {
       if ( ppv )
          *ppv = NULL;

       rc = E_NOINTERFACE;
     }

  return rc;
}


static void HackGCO(void)
{
  EnterCriticalSection(&hack_gco.section);

  if ( !hack_gco.handle )
     {
       hack_gco.handle = HackAPIFunction("ole32.dll","CoGetClassObject",My_CoGetClassObject);
     }

  LeaveCriticalSection(&hack_gco.section);
}


static void UnhackGCO(void)
{
  EnterCriticalSection(&hack_gco.section);

  if ( hack_gco.handle )
     {
       UnhackAPIFunction(hack_gco.handle);
       hack_gco.handle = NULL;
     }

  LeaveCriticalSection(&hack_gco.section);
}


static void HackGCOInit(void)
{
  InitializeCriticalSection(&hack_gco.section);
  hack_gco.handle = NULL;

  if ( !IsSimple() && g_config.wb_flash_disable )
     {
       HackGCO();
     }
}


static void HackGCODone(void)
{
  UnhackGCO();
  DeleteCriticalSection(&hack_gco.section);
}


/////////////////////////////////

struct {
void *handle;
CRITICAL_SECTION section;
} hack_cmenu;

static void HackBrowserCMenu(void);
static void UnhackBrowserCMenu(void);


static LONG STDAPICALLTYPE My_RegQueryValueExW(
    IN HKEY hKey,
    IN LPCWSTR lpValueName,
    IN LPDWORD lpReserved,
    OUT LPDWORD lpType,
    IN OUT LPBYTE lpData,
    IN OUT LPDWORD lpcbData
    )
{
  LONG rc;

  if ( !lpValueName || lstrcmpiW(lpValueName,L"NoBrowserContextMenu") )
     {
       UnhackBrowserCMenu();
       rc = RegQueryValueExW(hKey,lpValueName,lpReserved,lpType,lpData,lpcbData);
       HackBrowserCMenu();
     }
  else
     {
       rc = ERROR_FILE_NOT_FOUND;
     }

  return rc;
}


static void HackBrowserCMenu(void)
{
  EnterCriticalSection(&hack_cmenu.section);

  if ( !hack_cmenu.handle )
     {
       hack_cmenu.handle = HackAPIFunction("advapi32.dll","RegQueryValueExW",My_RegQueryValueExW);
     }

  LeaveCriticalSection(&hack_cmenu.section);
}


static void UnhackBrowserCMenu(void)
{
  EnterCriticalSection(&hack_cmenu.section);

  if ( hack_cmenu.handle )
     {
       UnhackAPIFunction(hack_cmenu.handle);
       hack_cmenu.handle = NULL;
     }

  LeaveCriticalSection(&hack_cmenu.section);
}


static void HackBrowserCMenuInit(void)
{
  InitializeCriticalSection(&hack_cmenu.section);
  hack_cmenu.handle = NULL;

  if ( !(GetVersion() & 0x80000000) ) //winnt
     {
       HackBrowserCMenu();
     }
}


static void HackBrowserCMenuDone(void)
{
  UnhackBrowserCMenu();
  DeleteCriticalSection(&hack_cmenu.section);
}

/////////////////////////////////


struct {
void *handle;
CRITICAL_SECTION section;
} hack_cpw = {NULL,};

static void HackCPW(void);
static void UnhackCPW(void);


static BOOL WINAPI My_CreateProcessW(
    IN LPCWSTR lpApplicationName,
    IN LPWSTR lpCommandLine,
    IN LPSECURITY_ATTRIBUTES lpProcessAttributes,
    IN LPSECURITY_ATTRIBUTES lpThreadAttributes,
    IN BOOL bInheritHandles,
    IN DWORD dwCreationFlags,
    IN LPVOID lpEnvironment,
    IN LPCWSTR lpCurrentDirectory,
    IN LPSTARTUPINFOW lpStartupInfo,
    OUT LPPROCESS_INFORMATION lpProcessInformation
    )
{
  BOOL rc = FALSE;
 
  const WCHAR *app = lpApplicationName ? lpApplicationName : L"";
  const WCHAR *cmdline = lpCommandLine ? lpCommandLine : L"";

  const WCHAR *allowed[] = {L"\\bodymp.exe",
                            L"\\bodywb.exe",
                            L"\\bodymail.exe",
                            L"\\verclsid.exe",
                            L"\\fpdisp6.exe",  // FinePrint6
                            L"\\drwtsn32.exe"};

  int n;
  BOOL find = FALSE;

  for ( n = 0; n < sizeof(allowed)/sizeof(allowed[0]); n++ )
      if ( StrStrIW(app,allowed[n]) || StrStrIW(cmdline,allowed[n]) )
         {
           find = TRUE;
           break;
         }
  
  if ( find )
     {
       DWORD err;
       
       UnhackCPW();
       rc = CreateProcessW(lpApplicationName,lpCommandLine,lpProcessAttributes,
                           lpThreadAttributes,bInheritHandles,dwCreationFlags,
                           lpEnvironment,lpCurrentDirectory,lpStartupInfo,lpProcessInformation);
       err = GetLastError();
       HackCPW();
       SetLastError(err);
     }
  else
     {
       if ( lpProcessInformation )
          {
            lpProcessInformation->hProcess = NULL;
            lpProcessInformation->hThread = NULL;
            lpProcessInformation->dwProcessId = 0;
            lpProcessInformation->dwThreadId = 0;
          }

       SetLastError(ERROR_FILE_NOT_FOUND);
       rc = FALSE;
     }

  return rc;
}


static void HackCPW(void)
{
  EnterCriticalSection(&hack_cpw.section);

  if ( !hack_cpw.handle )
     {
       hack_cpw.handle = HackAPIFunction("kernel32.dll","CreateProcessW",My_CreateProcessW);
     }

  LeaveCriticalSection(&hack_cpw.section);
}


static void UnhackCPW(void)
{
  EnterCriticalSection(&hack_cpw.section);

  if ( hack_cpw.handle )
     {
       UnhackAPIFunction(hack_cpw.handle);
       hack_cpw.handle = NULL;
     }

  LeaveCriticalSection(&hack_cpw.section);
}


static void HackCPWInit(void)
{
  InitializeCriticalSection(&hack_cpw.section);
  hack_cpw.handle = NULL;

  HackCPW();
}


static void HackCPWDone(void)
{
  UnhackCPW();
  DeleteCriticalSection(&hack_cpw.section);
}


/////////////////////////////////




char *GetURL(void)
{
  int n;
  static char out[1024];
  char **argv = __argv;
  int argc = __argc;
  out[0] = 0;

  if ( !argc || !argv )
     return "";

  // search for url
  for ( n = 1; n < argc; n++ )
      if ( argv[n][0] != '-' && argv[n][0] != '/' )
         {
           lstrcpyn(out,argv[n],sizeof(out)-1);
           return out;
         }
  
  // look for 'nohome'
  for ( n = 1; n < argc; n++ )
      if ( !lstrcmpi(argv[n],"-nohome") )
         return "";

  // get homepage
  //ReadRegStr(HKEY_CURRENT_USER,"Software\\Microsoft\\Internet Explorer\\Main","Start Page",out,"");
  lstrcpy(out,g_config.ie_home_page);

  if ( !out[0] )
     lstrcpy(out,"about:blank");

  return out;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  char s[MAX_PATH];
  HANDLE lib;

  instance = GetModuleHandle(NULL);

  ReadConfig();

  InitCommonControls();

  if ( !CheckRPVersion(RUNPAD_VERSION_DIG) )
     return 0;

  OleInitialize(0);

  s[0] = 0;
  GetModuleFileName(NULL,s,sizeof(s));

  WriteRegDword(HKEY_CURRENT_USER,"Software\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BROWSER_EMULATION",PathFindFileName(s),9999); // force IE8/9 mode instead of IE7
  
  PathRemoveExtension(s);
  lstrcat(s,".dll");
  
  lib = LoadLibrary(s);
  if ( lib )
     {
       void (__cdecl *ShowBrowser)(const char*,BOOL,BOOL,void*,void*);

       ShowBrowser = (void*)GetProcAddress(lib,"ShowBrowser");

       if ( ShowBrowser )
          {
            BOOL do_hack = g_config.protect_run_in_ie && !IsWin2000() /*we dont want to workaround w2k WinExec()*/;
            void *h1 = do_hack ? HackCreateProcessA(FALSE) : NULL;
            if ( do_hack )
               HackCPWInit();
            HackGCOInit();
            //HackBrowserCMenuInit();
            
            ShowBrowser(GetURL(),IsSimple(),IsNoTopMost(),DownloadFileAsync,&g_config);

            //HackBrowserCMenuDone();
            HackGCODone();
            if ( do_hack )
               HackCPWDone();
            UnhackCreateProcess(h1);
          }

       FreeLibrary(lib);
     }
  else
     {
       MessageBox(NULL,"dll not found","Error",MB_OK | MB_ICONERROR);
     }

  OleUninitialize();

  return 1;
}


