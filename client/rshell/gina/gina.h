

extern HINSTANCE instance;
extern WLX_DISPATCH_VERSION_1_3 gDispatchTable;
extern HANDLE ghWlx;


// gina functions prototypes

typedef
BOOL
(WINAPI
*tWlxNegotiate)(
    DWORD                   dwWinlogonVersion,
    PDWORD                  pdwDllVersion
    );

typedef
BOOL
(WINAPI
*tWlxInitialize)(
    LPWSTR                  lpWinsta,
    HANDLE                  hWlx,
    PVOID                   pvReserved,
    PVOID                   pWinlogonFunctions,
    PVOID *                 pWlxContext
    );

typedef
VOID
(WINAPI
*tWlxDisplaySASNotice)(
    PVOID                   pWlxContext
    );

typedef
int
(WINAPI
*tWlxLoggedOutSAS)(
    PVOID                   pWlxContext,
    DWORD                   dwSasType,
    PLUID                   pAuthenticationId,
    PSID                    pLogonSid,
    PDWORD                  pdwOptions,
    PHANDLE                 phToken,
    PWLX_MPR_NOTIFY_INFO    pNprNotifyInfo,
    PVOID *                 pProfile
    );

typedef
BOOL
(WINAPI
*tWlxActivateUserShell)(
    PVOID                   pWlxContext,
    PWSTR                   pszDesktopName,
    PWSTR                   pszMprLogonScript,
    PVOID                   pEnvironment
    );

typedef
int
(WINAPI
*tWlxLoggedOnSAS)(
    PVOID                   pWlxContext,
    DWORD                   dwSasType,
    PVOID                   pReserved
    );

typedef
VOID
(WINAPI
*tWlxDisplayLockedNotice)(
    PVOID                   pWlxContext
    );

typedef
int
(WINAPI
*tWlxWkstaLockedSAS)(
    PVOID                   pWlxContext,
    DWORD                   dwSasType
    );

typedef
BOOL
(WINAPI
*tWlxIsLockOk)(
    PVOID                   pWlxContext
    );

typedef
BOOL
(WINAPI
*tWlxIsLogoffOk)(
    PVOID                   pWlxContext
    );

typedef
VOID
(WINAPI
*tWlxLogoff)(
    PVOID                   pWlxContext
    );

typedef
VOID
(WINAPI
*tWlxShutdown)(
    PVOID                   pWlxContext,
    DWORD                   ShutdownType
    );

typedef
BOOL
(WINAPI
*tWlxScreenSaverNotify)(
    PVOID                   pWlxContext,
    BOOL *                  pSecure);

typedef
BOOL
(WINAPI
*tWlxStartApplication)(
    PVOID                   pWlxContext,
    PWSTR                   pszDesktopName,
    PVOID                   pEnvironment,
    PWSTR                   pszCmdLine
    );

typedef
BOOL
(WINAPI
*tWlxNetworkProviderLoad)(
    PVOID                   pWlxContext,
    PWLX_MPR_NOTIFY_INFO    pNprNotifyInfo
    );

typedef
BOOL
(WINAPI
*tWlxDisplayStatusMessage)(
    PVOID                   pWlxContext,
    HDESK                   hDesktop,
    DWORD                   dwOptions,
    PWSTR                   pTitle,
    PWSTR                   pMessage
    );

typedef
BOOL
(WINAPI
*tWlxGetStatusMessage)(
    PVOID                   pWlxContext,
    DWORD *                 pdwOptions,
    PWSTR                   pMessage,
    DWORD                   dwBufferSize
    );

typedef
BOOL
(WINAPI
*tWlxRemoveStatusMessage)(
    PVOID                   pWlxContext
    );

typedef
BOOL
(WINAPI
*tWlxGetConsoleSwitchCredentials )(
    PVOID                   pWlxContext,
    PVOID                   pCredInfo
    );

typedef
VOID
(WINAPI
*tWlxReconnectNotify )(
    PVOID                   pWlxContext
    );

typedef
VOID
(WINAPI
*tWlxDisconnectNotify )(
    PVOID                   pWlxContext
    );
