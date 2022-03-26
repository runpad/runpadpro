
#ifndef __HOOKS_H__
#define __HOOKS_H__


extern const CLSID CLSID_MyShellExecuteHook;
extern const CLSID CLSID_MyCopyHook;


class CMyShellExecuteHook: 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CMyShellExecuteHook, &CLSID_MyShellExecuteHook>,
	public IShellExecuteHook
{
public:
	DECLARE_NO_REGISTRY()
	DECLARE_NOT_AGGREGATABLE(CMyShellExecuteHook)
	DECLARE_PROTECT_FINAL_CONSTRUCT()

	BEGIN_COM_MAP(CMyShellExecuteHook)
		COM_INTERFACE_ENTRY(IShellExecuteHook)
	END_COM_MAP()

private:
        // IShellExecuteHook
        STDMETHOD(Execute)(LPSHELLEXECUTEINFO pei);
};



class CMyCopyHook: 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CMyCopyHook, &CLSID_MyCopyHook>,
	public ICopyHook
{
public:
	DECLARE_NO_REGISTRY()
	DECLARE_NOT_AGGREGATABLE(CMyCopyHook)
	DECLARE_PROTECT_FINAL_CONSTRUCT()

	BEGIN_COM_MAP(CMyCopyHook)
		COM_INTERFACE_ENTRY(ICopyHook)
	END_COM_MAP()

private:
        // ICopyHook
        STDMETHOD_(UINT,CopyCallback)(HWND hwnd, UINT wFunc, UINT wFlags, LPCSTR pszSrcFile, DWORD dwSrcAttribs,
                                      LPCSTR pszDestFile, DWORD dwDestAttribs);
};





#endif
