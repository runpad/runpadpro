
#ifndef __MYDLG_H__
#define __MYDLG_H__


#define CLSID_MyFileSaveDialog CLSID_FileSaveDialog
#define CLSID_MyFileOpenDialog CLSID_FileOpenDialog


template <class __ReqIntf,const CLSID& __ReqClsid>
class CMyFileDialog:
                     public CComObjectRootEx<CComSingleThreadModel>,
                     public CComCoClass<CMyFileDialog<__ReqIntf,__ReqClsid>, &__ReqClsid>,
                     public IFileDialog2,
                     public IFileSaveDialog,
                     public IFileOpenDialog,
                     public IFileDialogCustomize,
                     public IOleWindow
{
  public:
          DECLARE_NO_REGISTRY()
          DECLARE_NOT_AGGREGATABLE(CMyFileDialog)
          DECLARE_PROTECT_FINAL_CONSTRUCT()
          
          BEGIN_COM_MAP(CMyFileDialog)
           COM_INTERFACE_ENTRY2(IModalWindow,IFileDialog2)
           COM_INTERFACE_ENTRY2(IFileDialog,IFileDialog2)
           COM_INTERFACE_ENTRY(IFileDialog2)
           COM_INTERFACE_ENTRY(IFileDialogCustomize)
           COM_INTERFACE_ENTRY(IOleWindow)
           COM_INTERFACE_ENTRY(__ReqIntf)
          END_COM_MAP()
  
  private:
          static const HRESULT HR_CANCEL_NAV = (HRESULT)(0x800704C7);
          
          typedef LPITEMIDLIST (WINAPI *TILCreateFromPath)(LPCWSTR pszPath);
          typedef void (WINAPI *TILFree)(LPITEMIDLIST pidl);
          typedef HRESULT (WINAPI *TSHCreateItemFromIDList)(LPCITEMIDLIST pidl, REFIID riid, void **ppv);
          typedef HRESULT (WINAPI *TSHCreateShellItemArrayFromIDLists)(UINT cidl, LPCITEMIDLIST* rgpidl, IShellItemArray **ppsiItemArray);

          typedef struct {
            DWORD id;
            int state;
          } TDlgSubItem;

          typedef TDlgSubItem* PDlgSubItem;
          typedef std::vector<TDlgSubItem> TDlgSubItems;

          typedef struct {
            DWORD id;
            int state;
            widestring data;
            bool b_checked;
            DWORD id_selected;
            bool b_selected;
            TDlgSubItems subitems;
          } TDlgItem;

          typedef TDlgItem* PDlgItem;
          typedef std::vector<TDlgItem> TDlgItems;

          TILCreateFromPath pILCreateFromPath;
          TILFree pILFree;
          TSHCreateItemFromIDList pSHCreateItemFromIDList;
          TSHCreateShellItemArrayFromIDLists pSHCreateShellItemArrayFromIDLists;

          HWND m_wnd;               // used only in Show()
          widestring m_filename;
          widestring m_defext;
          int m_typeindex;          // 1-based
          widestring m_title;
          IShellItem* m_deffolder;
          int m_options;            // FOS_ constants
          widestring m_filter;
          IShellItem* m_outresult;
          IShellItemArray* m_outresults;

          TDlgItems m_items;
          
          typedef ATL::CInterfaceArray<IFileDialogEvents> TEvents;
          TEvents m_events;


  public:
          CMyFileDialog();
          ~CMyFileDialog();

  private:
          bool IsSaveDlg() const { return __uuidof(__ReqIntf) == __uuidof(IFileSaveDialog); }

          PDlgItem FindItem(DWORD id);
          int FindSubItemI(DWORD id_item,DWORD id_sub);
          PDlgSubItem FindSubItemP(DWORD id_item,DWORD id_sub);
          PDlgItem AddItem(DWORD id,const widestring& data=widestring(),bool b_checked=false);
          PDlgSubItem AddSubItem(DWORD id_item,DWORD id_sub);
          bool DeleteItem(int idx);
          bool DeleteSubItem(DWORD id_item,DWORD id_sub);

          void ConvertFlagsFromFOS2OFN(int fos,DWORD& Flags,DWORD& FlagsEx);
          void SetResultsFromPath(const WCHAR* pf,bool is_multi);
          LPITEMIDLIST CreateFilePIDLGuarantee(const widestring& filename);
          HRESULT ShowFilesInternal(HWND hwndParent);
          HRESULT ShowFoldersInternal(HWND hwndParent);

  private:
          //IModalWindow
          STDMETHOD(Show)(HWND hwndOwner);

          //IFileDialog
          STDMETHOD(SetFileTypes)(UINT cFileTypes,const COMDLG_FILTERSPEC *rgFilterSpec);
          STDMETHOD(SetFileTypeIndex)(UINT iFileType);
          STDMETHOD(GetFileTypeIndex)(UINT *piFileType);
          STDMETHOD(Advise)(IFileDialogEvents *pfde,DWORD *pdwCookie);
          STDMETHOD(Unadvise)(DWORD dwCookie);
          STDMETHOD(SetOptions)(FILEOPENDIALOGOPTIONS fos);
          STDMETHOD(GetOptions)(FILEOPENDIALOGOPTIONS *pfos);
          STDMETHOD(SetDefaultFolder)(IShellItem *psi);
          STDMETHOD(SetFolder)(IShellItem *psi);
          STDMETHOD(GetFolder)(IShellItem **ppsi);
          STDMETHOD(GetCurrentSelection)(IShellItem **ppsi);
          STDMETHOD(SetFileName)(LPCWSTR pszName);
          STDMETHOD(GetFileName)(LPWSTR *pszName);
          STDMETHOD(SetTitle)(LPCWSTR pszTitle);
          STDMETHOD(SetOkButtonLabel)(LPCWSTR pszText);
          STDMETHOD(SetFileNameLabel)(LPCWSTR pszLabel);
          STDMETHOD(GetResult)(IShellItem **ppsi);
          STDMETHOD(AddPlace)(IShellItem *psi,FDAP fdap);
          STDMETHOD(SetDefaultExtension)(LPCWSTR pszDefaultExtension);
          STDMETHOD(Close)(HRESULT hr);
          STDMETHOD(SetClientGuid)(REFGUID guid);
          STDMETHOD(ClearClientData)(void);
          STDMETHOD(SetFilter)(IShellItemFilter *pFilter);

          //IFileDialog2
          STDMETHOD(SetCancelButtonLabel)(LPCWSTR pszLabel);
          STDMETHOD(SetNavigationRoot)(IShellItem *psi);

          //IFileSaveDialog
          STDMETHOD(SetSaveAsItem)(IShellItem *psi);
          STDMETHOD(SetProperties)(IPropertyStore *pStore);
          STDMETHOD(SetCollectedProperties)(IPropertyDescriptionList *pList,BOOL fAppendDefault);
          STDMETHOD(GetProperties)(IPropertyStore **ppStore);
          STDMETHOD(ApplyProperties)(IShellItem *psi,IPropertyStore *pStore,HWND hwnd,IFileOperationProgressSink *pSink);

          //IFileOpenDialog
          STDMETHOD(GetResults)(IShellItemArray **ppenum);
          STDMETHOD(GetSelectedItems)(IShellItemArray **ppsai);

          //IFileDialogCustomize
          STDMETHOD(EnableOpenDropDown)(DWORD dwIDCtl);
          STDMETHOD(AddMenu)(DWORD dwIDCtl,LPCWSTR pszLabel);
          STDMETHOD(AddPushButton)(DWORD dwIDCtl,LPCWSTR pszLabel);
          STDMETHOD(AddComboBox)(DWORD dwIDCtl);
          STDMETHOD(AddRadioButtonList)(DWORD dwIDCtl);
          STDMETHOD(AddCheckButton)(DWORD dwIDCtl,LPCWSTR pszLabel,BOOL bChecked);
          STDMETHOD(AddEditBox)(DWORD dwIDCtl,LPCWSTR pszText);
          STDMETHOD(AddSeparator)(DWORD dwIDCtl);
          STDMETHOD(AddText)(DWORD dwIDCtl,LPCWSTR pszText);
          STDMETHOD(SetControlLabel)(DWORD dwIDCtl,LPCWSTR pszLabel);
          STDMETHOD(GetControlState)(DWORD dwIDCtl,CDCONTROLSTATEF *pdwState);
          STDMETHOD(SetControlState)(DWORD dwIDCtl,CDCONTROLSTATEF dwState);
          STDMETHOD(GetEditBoxText)(DWORD dwIDCtl,WCHAR **ppszText);
          STDMETHOD(SetEditBoxText)(DWORD dwIDCtl,LPCWSTR pszText);
          STDMETHOD(GetCheckButtonState)(DWORD dwIDCtl,BOOL *pbChecked);
          STDMETHOD(SetCheckButtonState)(DWORD dwIDCtl,BOOL bChecked);
          STDMETHOD(AddControlItem)(DWORD dwIDCtl,DWORD dwIDItem,LPCWSTR pszLabel);
          STDMETHOD(RemoveControlItem)(DWORD dwIDCtl,DWORD dwIDItem);
          STDMETHOD(RemoveAllControlItems)(DWORD dwIDCtl);
          STDMETHOD(GetControlItemState)(DWORD dwIDCtl,DWORD dwIDItem,CDCONTROLSTATEF *pdwState);
          STDMETHOD(SetControlItemState)(DWORD dwIDCtl,DWORD dwIDItem,CDCONTROLSTATEF dwState);
          STDMETHOD(GetSelectedControlItem)(DWORD dwIDCtl,DWORD *pdwIDItem);
          STDMETHOD(SetSelectedControlItem)(DWORD dwIDCtl,DWORD dwIDItem);
          STDMETHOD(StartVisualGroup)(DWORD dwIDCtl,LPCWSTR pszLabel);
          STDMETHOD(EndVisualGroup)(void);
          STDMETHOD(MakeProminent)(DWORD dwIDCtl);
          STDMETHOD(SetControlItemText)(DWORD dwIDCtl,DWORD dwIDItem,LPCWSTR pszLabel);

          //IOleWindow
          STDMETHOD(GetWindow)(HWND *phwnd);
          STDMETHOD(ContextSensitiveHelp)(BOOL fEnterMode);
};


typedef CMyFileDialog<IFileSaveDialog,CLSID_FileSaveDialog> CMyFileSaveDialog;
typedef CMyFileDialog<IFileOpenDialog,CLSID_FileOpenDialog> CMyFileOpenDialog;


#include "mydlg.hpp"


#endif
