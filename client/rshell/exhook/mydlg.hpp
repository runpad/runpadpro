


template <class __ReqIntf,const CLSID& __ReqClsid>
CMyFileDialog<__ReqIntf,__ReqClsid>::CMyFileDialog()
{
  HINSTANCE lib = GetModuleHandle("shell32.dll");
  if ( !lib )
     {
       lib = LoadLibrary("shell32.dll");
     }

  pILCreateFromPath = TILCreateFromPath(GetProcAddress(lib,"ILCreateFromPathW"));
  pILFree = TILFree(GetProcAddress(lib,"ILFree"));
  pSHCreateItemFromIDList = TSHCreateItemFromIDList(GetProcAddress(lib,"SHCreateItemFromIDList"));
  pSHCreateShellItemArrayFromIDLists = TSHCreateShellItemArrayFromIDLists(GetProcAddress(lib,"SHCreateShellItemArrayFromIDLists"));

  m_wnd = NULL;
  m_typeindex = 1;
  m_deffolder = NULL;
  m_options = IsSaveDlg() ? (FOS_OVERWRITEPROMPT | FOS_PATHMUSTEXIST | FOS_NOREADONLYRETURN) : (FOS_PATHMUSTEXIST | FOS_FILEMUSTEXIST);
  m_filter.assign(L"*.*\0*.*\0\0",9);
  m_outresult = NULL;
  m_outresults = NULL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
CMyFileDialog<__ReqIntf,__ReqClsid>::~CMyFileDialog()
{
  m_events.RemoveAll();
  m_items.clear();

  SAFERELEASE(m_outresult);
  SAFERELEASE(m_outresults);
  SAFERELEASE(m_deffolder);
}


template <class __ReqIntf,const CLSID& __ReqClsid>
typename CMyFileDialog<__ReqIntf,__ReqClsid>::PDlgItem CMyFileDialog<__ReqIntf,__ReqClsid>::FindItem(DWORD id)
{
  PDlgItem rc = NULL;

  for ( TDlgItems::iterator it = m_items.begin(); it != m_items.end(); ++it )
      {
        if ( it->id == id )
           {
             rc = &(*it);
             break;
           }
      }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
int CMyFileDialog<__ReqIntf,__ReqClsid>::FindSubItemI(DWORD id_item,DWORD id_sub)
{
  int rc = -1;

  PDlgItem i = FindItem(id_item);
  if ( i )
     {
       int idx = 0;
       
       for ( TDlgSubItems::iterator it = i->subitems.begin(); it != i->subitems.end(); ++it )
           {
             if ( it->id == id_sub )
                {
                  rc = idx;
                  break;
                }

             ++idx;
           }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
typename CMyFileDialog<__ReqIntf,__ReqClsid>::PDlgSubItem CMyFileDialog<__ReqIntf,__ReqClsid>::FindSubItemP(DWORD id_item,DWORD id_sub)
{
  PDlgSubItem rc = NULL;

  PDlgItem i = FindItem(id_item);
  if ( i )
     {
       for ( TDlgSubItems::iterator it = i->subitems.begin(); it != i->subitems.end(); ++it )
           {
             if ( it->id == id_sub )
                {
                  rc = &(*it);
                  break;
                }
           }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
typename CMyFileDialog<__ReqIntf,__ReqClsid>::PDlgItem CMyFileDialog<__ReqIntf,__ReqClsid>::AddItem(DWORD id,const widestring& data,bool b_checked)
{
  PDlgItem rc = NULL;

  if ( !FindItem(id) )
     {
       TDlgItem i;

       i.id = id;
       i.state = CDCS_ENABLEDVISIBLE;
       i.data = data;
       i.b_checked = b_checked;
       i.id_selected = 0;
       i.b_selected = false;

       m_items.push_back(i);
       rc = &m_items.back();
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
typename CMyFileDialog<__ReqIntf,__ReqClsid>::PDlgSubItem CMyFileDialog<__ReqIntf,__ReqClsid>::AddSubItem(DWORD id_item,DWORD id_sub)
{
  PDlgSubItem rc = NULL;

  PDlgItem i = FindItem(id_item);
  if ( i )
     {
       if ( !FindSubItemP(id_item,id_sub) )
          {
            TDlgSubItem s;

            s.id = id_sub;
            s.state = CDCS_ENABLEDVISIBLE;

            i->subitems.push_back(s);
            rc = &i->subitems.back();
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
bool CMyFileDialog<__ReqIntf,__ReqClsid>::DeleteItem(int idx)
{
  bool rc = false;

  if ( idx >= 0 && idx < m_items.size() )
     {
       m_items.erase(m_items.begin()+idx);
       rc = true;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
bool CMyFileDialog<__ReqIntf,__ReqClsid>::DeleteSubItem(DWORD id_item,DWORD id_sub)
{
  bool rc = false;

  PDlgItem i = FindItem(id_item);
  if ( i )
     {
       int idx = FindSubItemI(id_item,id_sub);
       if ( idx != -1 )
          {
            const TDlgSubItem& si = i->subitems[idx];

            if ( i->b_selected && i->id_selected == si.id )
               {
                 i->b_selected = false;
                 i->id_selected = 0;
               }
            
            i->subitems.erase(i->subitems.begin()+idx);
            rc = true;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
void CMyFileDialog<__ReqIntf,__ReqClsid>::ConvertFlagsFromFOS2OFN(int fos,DWORD& Flags,DWORD& FlagsEx)
{
  Flags = OFN_ENABLESIZING | OFN_EXPLORER | OFN_HIDEREADONLY | OFN_LONGNAMES /*| OFN_NONETWORKBUTTON*/;
  FlagsEx = FindWindow("_RunpadClass",NULL) ? OFN_EX_NOPLACESBAR : 0;

  if ( fos&FOS_OVERWRITEPROMPT )
     Flags |= OFN_OVERWRITEPROMPT;
  if ( fos&FOS_NOVALIDATE )
     Flags |= OFN_SHAREAWARE;
  if ( fos&FOS_SHAREAWARE )
     Flags |= OFN_SHAREAWARE;
  if ( fos&FOS_ALLOWMULTISELECT )
     Flags |= OFN_ALLOWMULTISELECT;
  if ( fos&FOS_PATHMUSTEXIST )
     Flags |= OFN_PATHMUSTEXIST;
  if ( fos&FOS_FILEMUSTEXIST )
     Flags |= OFN_FILEMUSTEXIST;
  if ( fos&FOS_CREATEPROMPT )
     Flags |= OFN_CREATEPROMPT;
  if ( fos&FOS_NOREADONLYRETURN )
     Flags |= OFN_NOREADONLYRETURN;
  if ( fos&FOS_NOTESTFILECREATE )
     Flags |= OFN_NOTESTFILECREATE;
  if ( fos&FOS_NODEREFERENCELINKS )
     Flags |= OFN_NODEREFERENCELINKS;
  if ( fos&FOS_DONTADDTORECENT )
     Flags |= OFN_DONTADDTORECENT;
  if ( fos&FOS_FORCESHOWHIDDEN )
     Flags |= OFN_FORCESHOWHIDDEN;

  if ( fos&FOS_HIDEPINNEDPLACES )
     FlagsEx |= OFN_EX_NOPLACESBAR;
  if ( fos&FOS_HIDEMRUPLACES )
     FlagsEx |= OFN_EX_NOPLACESBAR;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
void CMyFileDialog<__ReqIntf,__ReqClsid>::SetResultsFromPath(const WCHAR* pf,bool is_multi)
{
  SAFERELEASE(m_outresult);
  SAFERELEASE(m_outresults);

  if ( pSHCreateItemFromIDList && pSHCreateShellItemArrayFromIDLists )
     {
       if ( !IsStrEmpty(pf) )
          {
            widestring s(pf);

            if ( !is_multi || pf[lstrlenW(pf)+1] == '\0' )
               {
                 // single path
                 LPITEMIDLIST pidl = CreateFilePIDLGuarantee(s);
                 if ( pidl )
                    {
                      pSHCreateItemFromIDList(pidl,IID_IShellItem,(void**)&m_outresult);
                      pSHCreateShellItemArrayFromIDLists(1,(LPCITEMIDLIST*)&pidl,&m_outresults);
                      pILFree(pidl);
                    }
               }
            else
               {
                 // multiselect
                 widestring dir(s);
                 if ( dir[dir.length()-1] != '\\' )
                    {
                      dir += L"\\";
                    }

                 std::vector<LPITEMIDLIST> v;
                 const WCHAR *p = pf + lstrlenW(pf)+1;
                 while ( *p )
                 {
                   LPITEMIDLIST pidl = CreateFilePIDLGuarantee(dir+widestring(p));
                   if ( pidl )
                      {
                        v.push_back(pidl);
                      }

                   p += lstrlenW(p)+1;
                 };

                 if ( v.size() > 0 )
                    {
                      LPITEMIDLIST *ar = new LPITEMIDLIST[v.size()];

                      for ( int n = 0; n < v.size(); n++ )
                          {
                            ar[n] = v[n];
                          }

                      pSHCreateShellItemArrayFromIDLists(v.size(),(LPCITEMIDLIST*)ar,&m_outresults);
                      if ( v.size() == 1 )
                         {
                           pSHCreateItemFromIDList(ar[0],IID_IShellItem,(void**)&m_outresult);
                         }

                      for ( int n = 0; n < v.size(); n++ )
                          {
                            pILFree(v[n]);
                            v[n] = NULL;
                          }
                      v.clear();

                      delete [] ar;
                    }
               }
          }
     }
}


template <class __ReqIntf,const CLSID& __ReqClsid>
LPITEMIDLIST CMyFileDialog<__ReqIntf,__ReqClsid>::CreateFilePIDLGuarantee(const widestring& filename)
{
  LPITEMIDLIST rc = NULL;

  if ( !IsStrEmpty(filename) )
     {
       bool b_delete = false;

       if ( GetFileAttributesW(filename.c_str()) == INVALID_FILE_ATTRIBUTES )
          {
            HANDLE h = CreateFileW(filename.c_str(),GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
            CloseHandle(h);
            b_delete = true;
          }

       rc = pILCreateFromPath(filename.c_str());

       if ( b_delete )
          {
            DeleteFileW(filename.c_str());
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
HRESULT CMyFileDialog<__ReqIntf,__ReqClsid>::ShowFilesInternal(HWND hwndParent)
{
  SAFERELEASE(m_outresult);
  SAFERELEASE(m_outresults);

  widestring c_filter(m_filter);
  if ( IsStrEmpty(c_filter) )
     {
       c_filter.assign(L"\0\0\0",3);
     }

  const int i_filemax = 65536;
  WCHAR *p_file = new WCHAR[i_filemax];
  lstrcpyW(p_file,m_filename.c_str());

  widestring c_title(m_title);
  widestring c_defext(m_defext);

  WCHAR *p_dir = NULL;
  if ( m_deffolder )
     {
       m_deffolder->GetDisplayName(SIGDN_FILESYSPATH,&p_dir);
     }

  OPENFILENAMEW i;
  ZeroMemory(&i,sizeof(i));

  i.lStructSize = sizeof(i);
  i.hwndOwner = hwndParent;
  i.lpstrFilter = c_filter.data(); // .c_str()
  i.nFilterIndex = m_typeindex;
  i.lpstrFile = p_file;
  i.nMaxFile = i_filemax;
  i.lpstrInitialDir = p_dir;
  i.lpstrTitle = IsStrEmpty(c_title)?NULL:c_title.c_str();
  i.lpstrDefExt = IsStrEmpty(c_defext)?NULL:c_defext.c_str();
  ConvertFlagsFromFOS2OFN(m_options,i.Flags,i.FlagsEx);
  if ( IsSaveDlg() )
     {
       i.Flags &= ~OFN_ALLOWMULTISELECT; // not allow multiselect on SaveDlg
     }

  BOOL rc = IsSaveDlg() ? GetSaveFileNameW(&i) : GetOpenFileNameW(&i);

  if ( rc )
     {
       m_typeindex = i.nFilterIndex;
       SetResultsFromPath(p_file,(i.Flags&OFN_ALLOWMULTISELECT)!=0);
     }

  if ( p_dir )
     {
       CoTaskMemFree(p_dir);
     }

  delete [] p_file;

  return ( m_outresult || m_outresults ) ? S_OK : HR_CANCEL_NAV;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
HRESULT CMyFileDialog<__ReqIntf,__ReqClsid>::ShowFoldersInternal(HWND hwndParent)
{
  SAFERELEASE(m_outresult);
  SAFERELEASE(m_outresults);

  widestring c_title(m_title);

  WCHAR t[MAX_PATH] = L"";

  BROWSEINFOW i;
  ZeroMemory(&i,sizeof(i));

  i.hwndOwner = hwndParent;
  i.pidlRoot = NULL;
  i.pszDisplayName = t;
  i.lpszTitle = IsStrEmpty(c_title)?NULL:c_title.c_str();
  i.ulFlags = 0;

  LPITEMIDLIST pidl = SHBrowseForFolderW(&i);
  if ( pidl )
     {
       if ( pSHCreateItemFromIDList && pSHCreateShellItemArrayFromIDLists )
          {
            pSHCreateItemFromIDList(pidl,IID_IShellItem,(void**)&m_outresult);
            pSHCreateShellItemArrayFromIDLists(1,(LPCITEMIDLIST*)&pidl,&m_outresults);
          }

       // free pidl
       IMalloc *malloc = NULL;
       SHGetMalloc(&malloc);
       if ( malloc )
          {
            malloc->Free(pidl);
            SAFERELEASE(malloc);
          }
     }

  return m_outresult ? S_OK : HR_CANCEL_NAV;
}



//IModalWindow
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::Show(HWND hwndOwner)
{
  m_wnd = hwndOwner;

  SAFERELEASE(m_outresult);
  SAFERELEASE(m_outresults);

  HRESULT rc = (m_options&FOS_PICKFOLDERS) ? ShowFoldersInternal(hwndOwner) : ShowFilesInternal(hwndOwner);

  if ( rc == S_OK )
     {
       if ( !m_events.IsEmpty() )
          {
            IFileDialog *host = NULL;
            QueryInterface(IID_IFileDialog,(void**)&host);
            ASSERT(host);

            for ( int n = 0; n < m_events.GetCount(); n++ )
                {
                  if ( m_events[n]->OnFileOk(host) == S_FALSE )
                     {
                       rc = HR_CANCEL_NAV;
                       SAFERELEASE(m_outresult);
                       SAFERELEASE(m_outresults);
                       break;
                     }
                }

            SAFERELEASE(host);
          }
     }

  m_wnd = NULL;

  // here original implementation clears all m_items[n].data.  We do not.
  //...

  return rc;
}



//IFileDialog
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFileTypes(UINT cFileTypes,const COMDLG_FILTERSPEC *rgFilterSpec)
{
  HRESULT rc = S_OK; //E_FAIL
  
  if ( cFileTypes > 0 && rgFilterSpec )
     {
       widestring s;

       for ( UINT n = 0; n < cFileTypes; n++ )
           {
             const COMDLG_FILTERSPEC& i = rgFilterSpec[n];
             s += NNSW(i.pszName);
             s += (wchar_t)'\0';
             s += NNSW(i.pszSpec);
             s += (wchar_t)'\0';
           }

       s += (wchar_t)'\0'; // terminator
       m_filter = s;

       if ( m_typeindex == 0 || m_typeindex > int(cFileTypes) )
          {
            m_typeindex = 1;
          }

       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFileTypeIndex(UINT iFileType)
{
  m_typeindex = iFileType;
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetFileTypeIndex(UINT *piFileType)
{
  HRESULT rc = E_POINTER;

  if ( piFileType )
     {
       *piFileType = m_typeindex;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::Advise(IFileDialogEvents *pfde,DWORD *pdwCookie)
{
  HRESULT rc = E_POINTER;

  if ( pfde )
     {
       DWORD idx = m_events.Add(CComQIPtr<IFileDialogEvents>(pfde));

       if ( pdwCookie )
          {
            *pdwCookie = idx;
          }
       
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::Unadvise(DWORD dwCookie)
{
  HRESULT rc = E_FAIL;

  int idx = dwCookie;
  if ( idx >= 0 && idx < m_events.GetCount() )
     {
       m_events.RemoveAt(dwCookie);
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetOptions(FILEOPENDIALOGOPTIONS fos)
{
  m_options = fos;
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetOptions(FILEOPENDIALOGOPTIONS *pfos)
{
  HRESULT rc = E_POINTER;

  if ( pfos )
     {
       *pfos = m_options;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetDefaultFolder(IShellItem *psi)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFolder(IShellItem *psi)
{
  IASSIGN(m_deffolder,psi);
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetFolder(IShellItem **ppsi)
{
  HRESULT rc = E_POINTER;

  if ( ppsi )
     {
       IASSIGN2OUT(*ppsi,m_deffolder);  // not always true, see help on GetFolder()!
       rc = m_deffolder ? S_OK : E_FAIL;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetCurrentSelection(IShellItem **ppsi)
{
  HRESULT rc = E_POINTER;

  if ( ppsi )
     {
       IASSIGN2OUT(*ppsi,NULL);
       rc = E_FAIL;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFileName(LPCWSTR pszName)
{
  m_filename = NNSW(pszName);
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetFileName(LPWSTR *pszName)
{
  HRESULT rc = E_POINTER;

  if ( pszName )
     {
       WCHAR *p = (WCHAR*)CoTaskMemAlloc(sizeof(WCHAR));
       if ( !p )
          {
            *pszName = NULL;
            rc = E_FAIL;
          }
       else
          {
            *p = 0;
            *pszName = p;
            rc = S_OK;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetTitle(LPCWSTR pszTitle)
{
  m_title = NNSW(pszTitle);
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetOkButtonLabel(LPCWSTR pszText)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFileNameLabel(LPCWSTR pszLabel)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetResult(IShellItem **ppsi)
{
  HRESULT rc = E_POINTER;

  if ( ppsi )
     {
       IASSIGN2OUT(*ppsi,m_outresult);
       rc = m_outresult ? S_OK : E_FAIL;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddPlace(IShellItem *psi,FDAP fdap)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetDefaultExtension(LPCWSTR pszDefaultExtension)
{
  m_defext = NNSW(pszDefaultExtension);
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::Close(HRESULT hr)
{
  return E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetClientGuid(REFGUID guid)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::ClearClientData(void)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetFilter(IShellItemFilter *pFilter)
{
  return S_OK;
}



//IFileDialog2
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetCancelButtonLabel(LPCWSTR pszLabel)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetNavigationRoot(IShellItem *psi)
{
  return S_OK;
}



//IFileSaveDialog
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetSaveAsItem(IShellItem *psi)
{
  HRESULT rc = E_FAIL;

  if ( psi )
     {
       WCHAR *p = NULL;
       psi->GetDisplayName(SIGDN_FILESYSPATH,&p);
       if ( p )
          {
            if ( GetFileAttributesW(p) != INVALID_FILE_ATTRIBUTES )
               {
                 widestring s(p);
                 if ( !IsStrEmpty(s) )
                    {
                      int delim = -1;
                      for ( int n = s.length()-1; n >= 0; n-- )
                          {
                            if ( s[n] == '\\' || s[n] == ':' )
                               {
                                 delim = n;
                                 break;
                               }
                          }

                      widestring filename;
                      filename = s.substr(delim+1);
                      widestring filepath;
                      filepath = s.substr(0,delim+1);

                      m_filename = filename;

                      if ( !IsStrEmpty(filepath) )
                         {
                           LPITEMIDLIST pidl = pILCreateFromPath(filepath.c_str());
                           if ( pidl )
                              {
                                IShellItem *shi = NULL;
                                pSHCreateItemFromIDList(pidl,IID_IShellItem,(void**)&shi);
                                if ( shi )
                                   {
                                     IASSIGN(m_deffolder,shi);
                                     shi->Release();
                                   }

                                pILFree(pidl);
                              }
                         }
                    }
               }

            CoTaskMemFree(p);
          }

       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetProperties(IPropertyStore *pStore)
{
  return E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetCollectedProperties(IPropertyDescriptionList *pList,BOOL fAppendDefault)
{
  return E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetProperties(IPropertyStore **ppStore)
{
  HRESULT rc = E_POINTER;

  if ( ppStore )
     {
       IASSIGN2OUT(*ppStore,NULL);
       rc = E_FAIL;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::ApplyProperties(IShellItem *psi,IPropertyStore *pStore,HWND hwnd,IFileOperationProgressSink *pSink)
{
  return E_FAIL;
}



//IFileOpenDialog
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetResults(IShellItemArray **ppenum)
{
  HRESULT rc = E_POINTER;

  if ( ppenum )
     {
       IASSIGN2OUT(*ppenum,m_outresults);
       rc = m_outresults ? S_OK : E_FAIL;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetSelectedItems(IShellItemArray **ppsai)
{
  HRESULT rc = E_POINTER;

  if ( ppsai )
     {
       IASSIGN2OUT(*ppsai,NULL);
       rc = E_FAIL;
     }

  return rc;
}



//IFileDialogCustomize
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::EnableOpenDropDown(DWORD dwIDCtl)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddMenu(DWORD dwIDCtl,LPCWSTR pszLabel)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddPushButton(DWORD dwIDCtl,LPCWSTR pszLabel)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddComboBox(DWORD dwIDCtl)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddRadioButtonList(DWORD dwIDCtl)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddCheckButton(DWORD dwIDCtl,LPCWSTR pszLabel,BOOL bChecked)
{
  return AddItem(dwIDCtl,widestring(),bChecked?true:false) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddEditBox(DWORD dwIDCtl,LPCWSTR pszText)
{
  return AddItem(dwIDCtl,widestring(NNSW(pszText))) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddSeparator(DWORD dwIDCtl)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddText(DWORD dwIDCtl,LPCWSTR pszText)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetControlLabel(DWORD dwIDCtl,LPCWSTR pszLabel)
{
  return FindItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetControlState(DWORD dwIDCtl,CDCONTROLSTATEF *pdwState)
{
  HRESULT rc = E_POINTER;

  if ( pdwState )
     {
       const PDlgItem i = FindItem(dwIDCtl);
       if ( i )
          {
            *pdwState = (CDCONTROLSTATEF)i->state;
            rc = S_OK;
          }
       else
          {
            *pdwState = (CDCONTROLSTATEF)0;
            rc = E_FAIL;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetControlState(DWORD dwIDCtl,CDCONTROLSTATEF dwState)
{
  HRESULT rc = E_FAIL;

  PDlgItem i = FindItem(dwIDCtl);
  if ( i )
     {
       i->state = (int)dwState;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetEditBoxText(DWORD dwIDCtl,WCHAR **ppszText)
{
  HRESULT rc = E_POINTER;

  if ( ppszText )
     {
       const PDlgItem i = FindItem(dwIDCtl);
       if ( i )
          {
            WCHAR *p = (WCHAR*)CoTaskMemAlloc((i->data.length()+1)*sizeof(WCHAR));
            if ( p )
               {
                 lstrcpyW(p,i->data.c_str());
                 *ppszText = p;
                 rc = S_OK;
               }
            else
               {
                 *ppszText = NULL;
                 rc = E_FAIL;
               }
          }
       else
          {
            *ppszText = NULL;
            rc = E_FAIL;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetEditBoxText(DWORD dwIDCtl,LPCWSTR pszText)
{
  HRESULT rc = E_FAIL;

  PDlgItem i = FindItem(dwIDCtl);
  if ( i )
     {
       i->data = NNSW(pszText);
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetCheckButtonState(DWORD dwIDCtl,BOOL *pbChecked)
{
  HRESULT rc = E_POINTER;

  if ( pbChecked )
     {
       const PDlgItem i = FindItem(dwIDCtl);
       if ( i )
          {
            *pbChecked = i->b_checked ? TRUE : FALSE;
            rc = S_OK;
          }
       else
          {
            *pbChecked = FALSE;
            rc = E_FAIL;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetCheckButtonState(DWORD dwIDCtl,BOOL bChecked)
{
  HRESULT rc = E_FAIL;

  PDlgItem i = FindItem(dwIDCtl);
  if ( i )
     {
       i->b_checked = bChecked ? true : false;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::AddControlItem(DWORD dwIDCtl,DWORD dwIDItem,LPCWSTR pszLabel)
{
  return AddSubItem(dwIDCtl,dwIDItem) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::RemoveControlItem(DWORD dwIDCtl,DWORD dwIDItem)
{
  return DeleteSubItem(dwIDCtl,dwIDItem) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::RemoveAllControlItems(DWORD dwIDCtl)
{
  HRESULT rc = E_FAIL;

  PDlgItem i = FindItem(dwIDCtl);
  if ( i )
     {
       i->subitems.clear();
       i->b_selected = false;
       i->id_selected = 0;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetControlItemState(DWORD dwIDCtl,DWORD dwIDItem,CDCONTROLSTATEF *pdwState)
{
  HRESULT rc = E_POINTER;

  if ( pdwState )
     {
       const PDlgSubItem i = FindSubItemP(dwIDCtl,dwIDItem);
       if ( i )
          {
            *pdwState = (CDCONTROLSTATEF)i->state;
            rc = S_OK;
          }
       else
          {
            *pdwState = (CDCONTROLSTATEF)0;
            rc = E_FAIL;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetControlItemState(DWORD dwIDCtl,DWORD dwIDItem,CDCONTROLSTATEF dwState)
{
  HRESULT rc = E_FAIL;

  PDlgSubItem i = FindSubItemP(dwIDCtl,dwIDItem);
  if ( i )
     {
       i->state = (int)dwState;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetSelectedControlItem(DWORD dwIDCtl,DWORD *pdwIDItem)
{
  HRESULT rc = E_POINTER;

  if ( pdwIDItem )
     {
       const PDlgItem i = FindItem(dwIDCtl);
       if ( i && i->b_selected )
          {
            *pdwIDItem = i->id_selected;
            rc = S_OK;
          }
       else
          {
            rc = E_FAIL;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetSelectedControlItem(DWORD dwIDCtl,DWORD dwIDItem)
{
  HRESULT rc = E_FAIL;

  PDlgItem i = FindItem(dwIDCtl);
  if ( i )
     {
       int sub_idx = FindSubItemI(dwIDCtl,dwIDItem);
       if ( sub_idx != -1 )
          {
            i->b_selected = true;
            i->id_selected = dwIDItem;
            rc = S_OK;
          }
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::StartVisualGroup(DWORD dwIDCtl,LPCWSTR pszLabel)
{
  return AddItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::EndVisualGroup(void)
{
  return S_OK;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::MakeProminent(DWORD dwIDCtl)
{
  return FindItem(dwIDCtl) ? S_OK : E_FAIL;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::SetControlItemText(DWORD dwIDCtl,DWORD dwIDItem,LPCWSTR pszLabel)
{
  return FindSubItemP(dwIDCtl,dwIDItem) ? S_OK : E_FAIL;
}



//IOleWindow
template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::GetWindow(HWND *phwnd)
{
  HRESULT rc = E_POINTER;

  if ( phwnd )
     {
       *phwnd = m_wnd;
       rc = S_OK;
     }

  return rc;
}


template <class __ReqIntf,const CLSID& __ReqClsid>
STDMETHODIMP CMyFileDialog<__ReqIntf,__ReqClsid>::ContextSensitiveHelp(BOOL fEnterMode)
{
  return S_OK;
}




