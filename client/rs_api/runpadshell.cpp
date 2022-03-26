#include "stdafx.h"
#include "rs_api.h"
#include "runpadshell.h"
#include "impl.h"
#include "utils.h"



HRESULT WINAPI CRunpadShell::UpdateRegistry(BOOL _bReg)
{
	return BOOL2HRESULT( RegisterComponent(_bReg,GetObjectCLSID(),"RunpadShell Interface","Apartment") );
}

STDMETHODIMP CRunpadShell::GetShellState(RSHELLSTATE* pState)
{
	return BOOL2HRESULT( RS_GetShellState(pState) );
}

STDMETHODIMP CRunpadShell::GetShellExecutable(LPSTR lpszExePath, DWORD cbPathLen, DWORD* lpdwPID)
{
	return BOOL2HRESULT( RS_GetShellExecutable(lpszExePath, cbPathLen, lpdwPID) );
}

STDMETHODIMP CRunpadShell::TurnShell(BOOL bNewState)
{
	return BOOL2HRESULT( RS_TurnShell(bNewState) );
}

STDMETHODIMP CRunpadShell::GetShellMode(DWORD* lpdwFlags)
{
	return BOOL2HRESULT( RS_GetShellMode(lpdwFlags) );
}

STDMETHODIMP CRunpadShell::IsShellOwnedWindow(HWND hWnd, BOOL* lpbOwned)
{
	return BOOL2HRESULT( RS_IsShellOwnedWindow(hWnd,lpbOwned) );
}

STDMETHODIMP CRunpadShell::GetFolderPath(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen)
{
	return BOOL2HRESULT( RS_GetFolderPath(dwFolderType, lpszPath, cbPathLen) );
}

STDMETHODIMP CRunpadShell::GetMachineNumber(DWORD* lpdwNum)
{
	return BOOL2HRESULT( RS_GetMachineNumber(lpdwNum) );
}

STDMETHODIMP CRunpadShell::GetCurrentSheet(LPSTR lpszName, DWORD cbNameLen)
{
	return BOOL2HRESULT( RS_GetCurrentSheet(lpszName, cbNameLen) );
}

STDMETHODIMP CRunpadShell::EnableSheets(LPCSTR lpszName, BOOL bEnable)
{
	return BOOL2HRESULT( RS_EnableSheets(lpszName, bEnable) );
}

STDMETHODIMP CRunpadShell::RegisterClient(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_RegisterClient(lpszClientName, lpszClientPath, dwFlags) );
}

STDMETHODIMP CRunpadShell::ShowInfoMessage(LPCSTR lpszText, DWORD dwFlags)
{
	return BOOL2HRESULT( RS_ShowInfoMessage(lpszText, dwFlags) );
}

STDMETHODIMP CRunpadShell::DoSingleAction(RSHELLACTION dwAction)
{
	return BOOL2HRESULT( RS_DoSingleAction(dwAction) );
}
