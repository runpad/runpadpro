
#include "include.h"


// {9BE88898-18E7-4528-8886-6358AAC2A61A}
DEFINE_GUID(CLSID_MyShellExecuteHook, 0x9BE88898, 0x18E7, 0x4528, 0x88,0x86,0x63,0x58,0xAA,0xC2,0xA6,0x1A );

// {CE2606AC-0A84-4272-97B0-04FF67BA05B6}
DEFINE_GUID(CLSID_MyCopyHook, 0xCE2606AC, 0x0A84, 0x4272, 0x97,0xB0,0x04,0xFF,0x67,0xBA,0x05,0xB6 );


///////////////////////


STDMETHODIMP CMyShellExecuteHook::Execute(LPSHELLEXECUTEINFO pei)
{
  HRESULT rc = S_FALSE;

  if ( pei )
     {
       HWND w = FindWindow("_RunpadClass",NULL);
       if ( w )
          {
            DWORD pid = -1;
            GetWindowThreadProcessId(w,&pid);
            if ( pid != GetCurrentProcessId() )
               {
                 ATOM a1 = pei->lpFile ? GlobalAddAtom(pei->lpFile) : 0;
                 ATOM a2 = pei->lpDirectory ? GlobalAddAtom(pei->lpDirectory) : 0;

                 if ( SendMessage(w,WM_USER+129,(WPARAM)a1,(LPARAM)a2) == 0 )
                    {
                      pei->hInstApp = (HINSTANCE)33;
                      pei->hProcess = NULL;
                      rc = S_OK;
                    }
               }
          }
     }

  return rc;
}


///////////////////////


STDMETHODIMP_(UINT) CMyCopyHook::CopyCallback(HWND hwnd, UINT wFunc, UINT wFlags, 
                                              LPCSTR pszSrcFile, DWORD dwSrcAttribs,
                                              LPCSTR pszDestFile, DWORD dwDestAttribs)
{
  UINT rc = IDYES;

  HWND w = FindWindow("_RunpadClass",NULL);
  if ( w )
     {
       DWORD pid = -1;
       GetWindowThreadProcessId(w,&pid);
       if ( pid != GetCurrentProcessId() )
          {
            if ( hwnd )
               {
                 char s[MAX_PATH] = "";
                 GetClassName(hwnd,s,sizeof(s));
                 if ( !lstrcmp(s,"TBodyExplForm") /*|| !lstrcmp(s,"TShellListView")*/ || !lstrcmp(s,"TBodyRecycleForm") )
                    return rc;
                 HWND w2 = GetAncestor(hwnd,GA_ROOTOWNER);
                 if ( w2 )
                    {
                      char s[MAX_PATH] = "";
                      GetClassName(w2,s,sizeof(s));
                      if ( !lstrcmp(s,"TBodyExplForm") /*|| !lstrcmp(s,"TShellListView")*/ || !lstrcmp(s,"TBodyRecycleForm") )
                         return rc;
                    }
               }

            ATOM atom = pszSrcFile ? GlobalAddAtom(pszSrcFile) : 0;

            if ( SendMessage(w,WM_USER+130,(WPARAM)wFunc,(LPARAM)atom) == 0 )
               {
                 rc = IDCANCEL;
               }
          }
     }

  return rc;
}












