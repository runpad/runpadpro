#include "stdafx.h"
#include "rs_api.h"
#include "runpadshell2.h"
#include "impl.h"
#include "utils.h"



HRESULT WINAPI CRunpadShell2::UpdateRegistry(BOOL _bReg)
{
	return BOOL2HRESULT( RegisterComponent(_bReg,GetObjectCLSID(),"RunpadShell2 Interface","Apartment") );
}

STDMETHODIMP CRunpadShell2::GetShellState(RSHELLSTATE* pState)
{
	return BOOL2HRESULT( RS_GetShellState(pState) );
}

STDMETHODIMP CRunpadShell2::GetShellExecutable(LPSTR lpszExePath, DWORD cbPathLen, DWORD* lpdwPID)
{
	return BOOL2HRESULT( RS_GetShellExecutable(lpszExePath, cbPathLen, lpdwPID) );
}

STDMETHODIMP CRunpadShell2::TurnShell(BOOL bNewState)
{
	return BOOL2HRESULT( RS_TurnShell(bNewState) );
}

STDMETHODIMP CRunpadShell2::GetShellMode(DWORD* lpdwFlags)
{
	return BOOL2HRESULT( RS_GetShellMode(lpdwFlags) );
}

STDMETHODIMP CRunpadShell2::IsShellOwnedWindow(HWND hWnd, BOOL* lpbOwned)
{
	return BOOL2HRESULT( RS_IsShellOwnedWindow(hWnd,lpbOwned) );
}

STDMETHODIMP CRunpadShell2::GetFolderPath(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen)
{
	return BOOL2HRESULT( RS_GetFolderPath(dwFolderType, lpszPath, cbPathLen) );
}

STDMETHODIMP CRunpadShell2::GetMachineNumber(DWORD* lpdwNum)
{
	return BOOL2HRESULT( RS_GetMachineNumber(lpdwNum) );
}

STDMETHODIMP CRunpadShell2::GetCurrentSheet(LPSTR lpszName, DWORD cbNameLen)
{
	return BOOL2HRESULT( RS_GetCurrentSheet(lpszName, cbNameLen) );
}

STDMETHODIMP CRunpadShell2::EnableSheets(LPCSTR lpszName, BOOL bEnable)
{
	return BOOL2HRESULT( RS_EnableSheets(lpszName, bEnable) );
}

STDMETHODIMP CRunpadShell2::RegisterClient(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_RegisterClient(lpszClientName, lpszClientPath, dwFlags) );
}

STDMETHODIMP CRunpadShell2::ShowInfoMessage(LPCSTR lpszText, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_ShowInfoMessage(lpszText, dwFlags) );
}

STDMETHODIMP CRunpadShell2::DoSingleAction(RSHELLACTION dwAction)
{
	return BOOL2HRESULT( RS_DoSingleAction(dwAction) );
}

STDMETHODIMP CRunpadShell2::VipLogin(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
	return BOOL2HRESULT( RS_VipLogin(lpszLogin, lpszPassword, bWait) );
}

STDMETHODIMP CRunpadShell2::VipRegister(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
	return BOOL2HRESULT( RS_VipRegister(lpszLogin, lpszPassword, bWait) );
}

STDMETHODIMP CRunpadShell2::VipLogout(BOOL bWait)
{
	return BOOL2HRESULT( RS_VipLogout(bWait) );
}
