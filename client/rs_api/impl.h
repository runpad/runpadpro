
#ifndef _IMPL_H_
#define _IMPL_H_


BOOL RegisterComponent(BOOL bReg,const CLSID &clsid,const char *desc,const char *model);

BOOL RS_GetShellState(RSHELLSTATE* pState);
BOOL RS_GetShellExecutable(LPSTR lpszExePath, DWORD cbPathLen, DWORD* lpdwPID);
BOOL RS_GetShellPid(DWORD* lpdwPID);
BOOL RS_TurnShell(BOOL bNewState);
BOOL RS_GetShellMode(DWORD* lpdwFlags);
BOOL RS_IsShellOwnedWindow(HWND hWnd, BOOL* lpbOwned);
BOOL RS_GetFolderPath(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen);
BOOL RS_GetMachineNumber(DWORD* lpdwNum);
BOOL RS_GetCurrentSheet(LPSTR lpszName, DWORD cbNameLen);
BOOL RS_EnableSheets(LPCSTR lpszName, BOOL bEnable);
BOOL RS_RegisterClient(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags);
BOOL RS_ShowInfoMessage(LPCSTR lpszText, DWORD dwFlags);
BOOL RS_DoSingleAction(RSHELLACTION dwAction);
BOOL RS_VipLogin(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
BOOL RS_VipRegister(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
BOOL RS_VipLogout(BOOL bWait);
BOOL RS_TempOffShell(LPCSTR lpszPasswordMD5,BOOL bShowReminder);



#endif //_IMPL_H_
