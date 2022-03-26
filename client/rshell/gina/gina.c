
#include "include.h"


// original GINA functions
static tWlxNegotiate                   gWlxNegotiate                     = NULL;
static tWlxInitialize                  gWlxInitialize                    = NULL;
static tWlxDisplaySASNotice            gWlxDisplaySASNotice              = NULL;
static tWlxLoggedOutSAS                gWlxLoggedOutSAS                  = NULL;
static tWlxActivateUserShell           gWlxActivateUserShell             = NULL;
static tWlxLoggedOnSAS                 gWlxLoggedOnSAS                   = NULL;
static tWlxDisplayLockedNotice         gWlxDisplayLockedNotice           = NULL;
static tWlxWkstaLockedSAS              gWlxWkstaLockedSAS                = NULL;
static tWlxIsLockOk                    gWlxIsLockOk                      = NULL;
static tWlxIsLogoffOk                  gWlxIsLogoffOk                    = NULL;
static tWlxLogoff                      gWlxLogoff                        = NULL;
static tWlxShutdown                    gWlxShutdown                      = NULL;
static tWlxScreenSaverNotify           gWlxScreenSaverNotify             = NULL;
static tWlxStartApplication            gWlxStartApplication              = NULL;
static tWlxNetworkProviderLoad         gWlxNetworkProviderLoad           = NULL;
static tWlxDisplayStatusMessage        gWlxDisplayStatusMessage          = NULL;
static tWlxGetStatusMessage            gWlxGetStatusMessage              = NULL;
static tWlxRemoveStatusMessage         gWlxRemoveStatusMessage           = NULL;
static tWlxGetConsoleSwitchCredentials gWlxGetConsoleSwitchCredentials   = NULL; 
static tWlxReconnectNotify             gWlxReconnectNotify               = NULL;
static tWlxDisconnectNotify            gWlxDisconnectNotify              = NULL;


// array used to load functions
#define DEF_GINA_FUNC(name)  { (void**)&g##name, #name },

static const struct {
void **func;
const char *name;
} gina_func_names[] =
{
  DEF_GINA_FUNC(WlxNegotiate)
  DEF_GINA_FUNC(WlxInitialize)
  DEF_GINA_FUNC(WlxDisplaySASNotice)
  DEF_GINA_FUNC(WlxLoggedOutSAS)
  DEF_GINA_FUNC(WlxActivateUserShell)
  DEF_GINA_FUNC(WlxLoggedOnSAS)
  DEF_GINA_FUNC(WlxDisplayLockedNotice)
  DEF_GINA_FUNC(WlxWkstaLockedSAS)
  DEF_GINA_FUNC(WlxIsLockOk)
  DEF_GINA_FUNC(WlxIsLogoffOk)
  DEF_GINA_FUNC(WlxLogoff)
  DEF_GINA_FUNC(WlxShutdown)
  DEF_GINA_FUNC(WlxScreenSaverNotify)
  DEF_GINA_FUNC(WlxStartApplication)
  DEF_GINA_FUNC(WlxNetworkProviderLoad)
  DEF_GINA_FUNC(WlxDisplayStatusMessage)
  DEF_GINA_FUNC(WlxGetStatusMessage)
  DEF_GINA_FUNC(WlxRemoveStatusMessage)
  DEF_GINA_FUNC(WlxGetConsoleSwitchCredentials)
  DEF_GINA_FUNC(WlxReconnectNotify)
  DEF_GINA_FUNC(WlxDisconnectNotify)
};


HINSTANCE instance = NULL;
WLX_DISPATCH_VERSION_1_3 gDispatchTable = {NULL,};
HANDLE ghWlx = NULL;
static DWORD dwWinlogonVer = 0;



BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpvReserved)
{
  if ( fdwReason == DLL_PROCESS_ATTACH )
     {
       instance = hinstDLL;
       DisableThreadLibraryCalls(instance);
     }

  return TRUE;
}



static BOOL LoadOriginalGina(void)
{
  int n;
  HINSTANCE hOldGina = LoadLibrary("msgina.dll");
  
  if ( !hOldGina )
     return FALSE;
  
  for ( n = 0; n < sizeof(gina_func_names)/sizeof(gina_func_names[0]); n++ )
      *gina_func_names[n].func = (void*)GetProcAddress(hOldGina,gina_func_names[n].name);

  return TRUE;
}



BOOL
WINAPI
WlxNegotiate(
    DWORD                   dwWinlogonVersion,
    PDWORD                  pdwDllVersion
    )
{
  dwWinlogonVer = dwWinlogonVersion;
  
  if ( !LoadOriginalGina() )
     return FALSE;

  return gWlxNegotiate ? gWlxNegotiate(dwWinlogonVersion,pdwDllVersion) : FALSE;
}



BOOL
WINAPI
WlxInitialize(
    LPWSTR                  lpWinsta,
    HANDLE                  hWlx,
    PVOID                   pvReserved,
    PVOID                   pWinlogonFunctions,
    PVOID *                 pWlxContext
    )
{
  ghWlx = hWlx;
  CopyMemory(&gDispatchTable,pWinlogonFunctions,
     dwWinlogonVer >= WLX_VERSION_1_3 ? sizeof(gDispatchTable) : sizeof(WLX_DISPATCH_VERSION_1_1) );
  
  return gWlxInitialize ? gWlxInitialize(lpWinsta,hWlx,pvReserved,pWinlogonFunctions,pWlxContext) : FALSE;
}



VOID
WINAPI
WlxDisplaySASNotice(
    PVOID                   pWlxContext
    )
{
  if ( gWlxDisplaySASNotice )
     gWlxDisplaySASNotice(pWlxContext);
}



int
WINAPI
WlxLoggedOutSAS(
    PVOID                   pWlxContext,
    DWORD                   dwSasType,
    PLUID                   pAuthenticationId,
    PSID                    pLogonSid,
    PDWORD                  pdwOptions,
    PHANDLE                 phToken,
    PWLX_MPR_NOTIFY_INFO    pNprNotifyInfo,
    PVOID *                 pProfile
    )
{
  return gWlxLoggedOutSAS ? gWlxLoggedOutSAS(pWlxContext,dwSasType,pAuthenticationId,pLogonSid,pdwOptions,phToken,pNprNotifyInfo,pProfile) : 0;
}



BOOL
WINAPI
WlxActivateUserShell(
    PVOID                   pWlxContext,
    PWSTR                   pszDesktopName,
    PWSTR                   pszMprLogonScript,
    PVOID                   pEnvironment
    )
{
  return gWlxActivateUserShell ? gWlxActivateUserShell(pWlxContext,pszDesktopName,pszMprLogonScript,pEnvironment) : FALSE;
}



int
WINAPI
WlxLoggedOnSAS(
    PVOID                   pWlxContext,
    DWORD                   dwSasType,
    PVOID                   pReserved
    )
{
  int rc = OnSASAction(dwSasType);
  if ( rc != -1 )
     return rc;

  return gWlxLoggedOnSAS ? gWlxLoggedOnSAS(pWlxContext,dwSasType,pReserved) : WLX_SAS_ACTION_NONE;
}



VOID
WINAPI
WlxDisplayLockedNotice(
    PVOID                   pWlxContext
    )
{
  if ( gWlxDisplayLockedNotice )
     gWlxDisplayLockedNotice(pWlxContext);
}



int
WINAPI
WlxWkstaLockedSAS(
    PVOID                   pWlxContext,
    DWORD                   dwSasType
    )
{
  return gWlxWkstaLockedSAS ? gWlxWkstaLockedSAS(pWlxContext,dwSasType) : WLX_SAS_ACTION_NONE;
}



BOOL
WINAPI
WlxIsLockOk(
    PVOID                   pWlxContext
    )
{
  return gWlxIsLockOk ? gWlxIsLockOk(pWlxContext) : FALSE;
}



BOOL
WINAPI
WlxIsLogoffOk(
    PVOID                   pWlxContext
    )
{
  return gWlxIsLogoffOk ? gWlxIsLogoffOk(pWlxContext) : FALSE;
}



VOID
WINAPI
WlxLogoff(
    PVOID                   pWlxContext
    )
{
  if ( gWlxLogoff )
     gWlxLogoff(pWlxContext);
}



VOID
WINAPI
WlxShutdown(
    PVOID                   pWlxContext,
    DWORD                   ShutdownType
    )
{
  if ( gWlxShutdown )
     gWlxShutdown(pWlxContext,ShutdownType);
}



BOOL
WINAPI
WlxScreenSaverNotify(
    PVOID                   pWlxContext,
    BOOL *                  pSecure)
{
  return gWlxScreenSaverNotify ? gWlxScreenSaverNotify(pWlxContext,pSecure) : FALSE;
}


// we do not export it!!!
// remember to add in exp.def if want to export
/*
BOOL
WINAPI
WlxStartApplication(
    PVOID                   pWlxContext,
    PWSTR                   pszDesktopName,
    PVOID                   pEnvironment,
    PWSTR                   pszCmdLine
    )
{
  return gWlxStartApplication ? gWlxStartApplication(pWlxContext,pszDesktopName,pEnvironment,pszCmdLine) : FALSE;
}
*/


BOOL
WINAPI
WlxNetworkProviderLoad(
    PVOID                   pWlxContext,
    PWLX_MPR_NOTIFY_INFO    pNprNotifyInfo
    )
{
  return gWlxNetworkProviderLoad ? gWlxNetworkProviderLoad(pWlxContext,pNprNotifyInfo) : FALSE;
}



BOOL
WINAPI
WlxDisplayStatusMessage(
    PVOID                   pWlxContext,
    HDESK                   hDesktop,
    DWORD                   dwOptions,
    PWSTR                   pTitle,
    PWSTR                   pMessage
    )
{
  return gWlxDisplayStatusMessage ? gWlxDisplayStatusMessage(pWlxContext,hDesktop,dwOptions,pTitle,pMessage) : FALSE;
}



BOOL
WINAPI
WlxGetStatusMessage(
    PVOID                   pWlxContext,
    DWORD *                 pdwOptions,
    PWSTR                   pMessage,
    DWORD                   dwBufferSize
    )
{
  return gWlxGetStatusMessage ? gWlxGetStatusMessage(pWlxContext,pdwOptions,pMessage,dwBufferSize) : FALSE;
}



BOOL
WINAPI
WlxRemoveStatusMessage(
    PVOID                   pWlxContext
    )
{
  return gWlxRemoveStatusMessage ? gWlxRemoveStatusMessage(pWlxContext) : FALSE;
}



BOOL
WINAPI
WlxGetConsoleSwitchCredentials (
    PVOID                   pWlxContext,
    PVOID                   pCredInfo
    )
{
  return gWlxGetConsoleSwitchCredentials ? gWlxGetConsoleSwitchCredentials(pWlxContext,pCredInfo) : FALSE;
}



VOID
WINAPI
WlxReconnectNotify (
    PVOID                   pWlxContext
    )
{
  if ( gWlxReconnectNotify )
     gWlxReconnectNotify(pWlxContext);
}



VOID
WINAPI
WlxDisconnectNotify (
    PVOID                   pWlxContext
    )
{
  if ( gWlxDisconnectNotify )
     gWlxDisconnectNotify(pWlxContext);
}
