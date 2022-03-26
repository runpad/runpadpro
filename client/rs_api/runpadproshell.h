
#ifndef __RUNPADPROSHELL_H_
#define __RUNPADPROSHELL_H_


class ATL_NO_VTABLE CRunpadProShell : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CRunpadProShell, &CLSID_RunpadProShell>,
	public IRunpadProShell
{
public:
	static HRESULT WINAPI UpdateRegistry(BOOL _bReg);

	DECLARE_NOT_AGGREGATABLE(CRunpadProShell)
	DECLARE_PROTECT_FINAL_CONSTRUCT()

	BEGIN_COM_MAP(CRunpadProShell)
		COM_INTERFACE_ENTRY(IRunpadProShell)
	END_COM_MAP()

// IRunpadProShell
public:
	STDMETHOD(GetShellPid)(DWORD* lpdwPID);
	STDMETHOD(GetShellMode)(DWORD* lpdwFlags);
	STDMETHOD(IsShellOwnedWindow)(HWND hWnd, BOOL* lpbOwned);
	STDMETHOD(GetFolderPath)(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen);
	STDMETHOD(GetCurrentSheet)(LPSTR lpszName, DWORD cbNameLen);
	STDMETHOD(EnableSheets)(LPCSTR lpszName, BOOL bEnable);
	STDMETHOD(RegisterClient)(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags);
	STDMETHOD(ShowInfoMessage)(LPCSTR lpszText, DWORD dwFlags);
	STDMETHOD(DoSingleAction)(RSHELLACTION dwAction);
	STDMETHOD(VipLogin)(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
	STDMETHOD(VipRegister)(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait);
	STDMETHOD(VipLogout)(BOOL bWait);
	STDMETHOD(TempOffShell)(LPCSTR lpszPasswordMD5,BOOL bShowReminder);

};


#endif //__RUNPADPROSHELL_H_
