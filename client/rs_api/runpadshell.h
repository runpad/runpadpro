
#ifndef __RUNPADSHELL_H_
#define __RUNPADSHELL_H_


class ATL_NO_VTABLE CRunpadShell : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CRunpadShell, &CLSID_RunpadShell>,
	public IRunpadShell
{
public:
	static HRESULT WINAPI UpdateRegistry(BOOL _bReg);

	DECLARE_NOT_AGGREGATABLE(CRunpadShell)
	DECLARE_PROTECT_FINAL_CONSTRUCT()

	BEGIN_COM_MAP(CRunpadShell)
		COM_INTERFACE_ENTRY(IRunpadShell)
	END_COM_MAP()

// IRunpadShell
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
};


#endif //__RUNPADSHELL_H_
