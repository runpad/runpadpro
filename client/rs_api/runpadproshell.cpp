#include "stdafx.h"
#include "rs_api.h"
#include "runpadproshell.h"
#include "impl.h"
#include "utils.h"



HRESULT WINAPI CRunpadProShell::UpdateRegistry(BOOL _bReg)
{
	return BOOL2HRESULT( RegisterComponent(_bReg,GetObjectCLSID(),"RunpadProShell Interface","Apartment") );
}

STDMETHODIMP CRunpadProShell::GetShellPid(DWORD* lpdwPID)
{
	return BOOL2HRESULT( RS_GetShellPid(lpdwPID) );
}

STDMETHODIMP CRunpadProShell::GetShellMode(DWORD* lpdwFlags)
{
	return BOOL2HRESULT( RS_GetShellMode(lpdwFlags) );
}

STDMETHODIMP CRunpadProShell::IsShellOwnedWindow(HWND hWnd, BOOL* lpbOwned)
{
	return BOOL2HRESULT( RS_IsShellOwnedWindow(hWnd,lpbOwned) );
}

STDMETHODIMP CRunpadProShell::GetFolderPath(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen)
{
	return BOOL2HRESULT( RS_GetFolderPath(dwFolderType, lpszPath, cbPathLen) );
}

STDMETHODIMP CRunpadProShell::GetCurrentSheet(LPSTR lpszName, DWORD cbNameLen)
{
	return BOOL2HRESULT( RS_GetCurrentSheet(lpszName, cbNameLen) );
}

STDMETHODIMP CRunpadProShell::EnableSheets(LPCSTR lpszName, BOOL bEnable)
{
	return BOOL2HRESULT( RS_EnableSheets(lpszName, bEnable) );
}

STDMETHODIMP CRunpadProShell::RegisterClient(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_RegisterClient(lpszClientName, lpszClientPath, dwFlags) );
}

STDMETHODIMP CRunpadProShell::ShowInfoMessage(LPCSTR lpszText, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_ShowInfoMessage(lpszText, dwFlags) );
}

STDMETHODIMP CRunpadProShell::DoSingleAction(RSHELLACTION dwAction)
{
	return BOOL2HRESULT( RS_DoSingleAction(dwAction) );
}

STDMETHODIMP CRunpadProShell::VipLogin(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
	return BOOL2HRESULT( RS_VipLogin(lpszLogin, lpszPassword, bWait) );
}

STDMETHODIMP CRunpadProShell::VipRegister(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
	return BOOL2HRESULT( RS_VipRegister(lpszLogin, lpszPassword, bWait) );
}

STDMETHODIMP CRunpadProShell::VipLogout(BOOL bWait)
{
	return BOOL2HRESULT( RS_VipLogout(bWait) );
}

STDMETHODIMP CRunpadProShell::TempOffShell(LPCSTR lpszPasswordMD5,BOOL bShowReminder)
{
	return BOOL2HRESULT( RS_TempOffShell(lpszPasswordMD5,bShowReminder) );
}

