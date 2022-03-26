
#ifndef __RUNPADSHELL2_H_
#define __RUNPADSHELL2_H_


class ATL_NO_VTABLE CRunpadShell2 : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CRunpadShell2, &CLSID_RunpadShell2>,
	public IRunpadShell2
{
public:
	static HRESULT WINAPI UpdateRegistry(BOOL _bReg);

	DECLARE_NOT_AGGREGATABLE(CRunpadShell2)
	DECLARE_PROTECT_FINAL_CONSTRUCT()

	BEGIN_COM_MAP(CRunpadShell2)
		COM_INTERFACE_ENTRY(IRunpadShell2)
	END_COM_MAP()

// IRunpadShell2
public:
	STDMETHOD(GetShellState)(RSHELLSTATE* pState);
	STDMETHOD(GetShellExecutable)(LPSTR lpszExePath, DWORD cbPathLen, DWORD* lpdwPID);
	STDMETHOD(TurnShell)(BOOL bNewState);
	STDMETHOD(GetShellMode)(DWORD* lpdwFlags);
	STDMETHOD(IsShellOwnedWindow)(HWND hWnd, BOOL* lpbOwned);
	STDMETHOD(GetFolderPath)(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen);
	STDMETHOD(GetMachineNumber)(DWORD* lpdwNum);
	STDMETHOD(GetCurrentSheet)(LPSTR lpszName, DWORD cbNameLen);
	STDMETHOD(EnableSheets)(LPCSTR lpszName, BOOL bEnable);
	STDMETHOD(RegisterClient)(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags);
	STDMETHOD(ShowInfoMessage)(LPCSTR lpszText, DWORD dwFlags);
	STDMETHOD(DoSingleAction)(RSHELLACTION dwAction);
	STDMETHOD(VipLogin)(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
	STDMETHOD(VipRegister)(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
	STDMETHOD(VipLogout)(BOOL bWait);
};


#endif //__RUNPADSHELL2_H_
