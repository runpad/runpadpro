
#include "stdafx.h"
#include "initguid.h"
#include <shlwapi.h>
#include "wmp.h"
#include "wmpids.h"
#include "host_mp.h"
#include "main.h"
#include "utils.h"
#include "../rp_shared/rp_shared.h"


namespace HOST_MP {


class CWMPHost
        : public CWindowImpl<CWMPHost, CWindow, CWinTraits<WS_POPUP | WS_CLIPCHILDREN | WS_CLIPSIBLINGS, WS_EX_TOOLWINDOW | WS_EX_TOPMOST> >
	, public IDispEventImpl<1,CWMPHost>
{
public:
    DECLARE_WND_CLASS_EX(NULL, 0, 0)

    BEGIN_MSG_MAP(CWMPHost)
        MESSAGE_HANDLER(WM_DISPLAYCHANGE, OnDisplayChange)
        MESSAGE_HANDLER(WM_CLOSE, OnClose)
        MESSAGE_HANDLER(WM_CREATE, OnCreate)
        MESSAGE_HANDLER(WM_DESTROY, OnDestroy)
        MESSAGE_HANDLER(WM_ERASEBKGND, OnErase)
        MESSAGE_HANDLER(WM_SYSCOMMAND, OnSysCmd)
    END_MSG_MAP()

    LRESULT OnDisplayChange(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnClose(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnErase(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& bHandled);
    LRESULT OnSysCmd(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);

    BEGIN_SINK_MAP(CWMPHost)
        SINK_ENTRY(1, 5101, OnPlayStateChange)
    END_SINK_MAP()

    void __stdcall OnPlayStateChange(long NewState);

    CAxWindow                   m_wndView;
    CComPtr<IWMPPlayer>         m_spWMPPlayer;

    int error;
    WCHAR filename[MAX_PATH];
};


void __stdcall CWMPHost::OnPlayStateChange(long NewState)
{
    if (NewState == 3)
        m_spWMPPlayer->put_fullScreen(VARIANT_TRUE);
}


LRESULT CWMPHost::OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
    CComPtr<IAxWinHostWindow>           spHost;
    HRESULT                             hr;
    RECT                                rcClient;

    error = 0;
    
    AtlAxWinInit();

    // create window
    GetClientRect(&rcClient);
    m_wndView.Create(m_hWnd, rcClient, NULL, WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN, 0/*WS_EX_CLIENTEDGE*/);
    if (NULL == m_wndView.m_hWnd)
        goto FAILURE;
    
    // load OCX in window
    hr = m_wndView.QueryHost(&spHost);
    if (FAILED(hr))
        goto FAILURE;

    hr = spHost->CreateControl(CComBSTR(_T("{6BF52A52-394A-11d3-B153-00C04F79FAA6}")), m_wndView, 0);
    if (FAILED(hr))
        goto FAILURE;

    hr = m_wndView.QueryControl(&m_spWMPPlayer);
    if (FAILED(hr))
        goto FAILURE;

    // Start listening events
    Advise(m_spWMPPlayer);

    return 0;

FAILURE:
    error = 1;
    return 0;
}

LRESULT CWMPHost::OnClose(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
  bHandled = TRUE;
  return 0;
}


LRESULT CWMPHost::OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
    // Stop listening events
    if ( m_spWMPPlayer )
       Unadvise(m_spWMPPlayer);
    
    // close the OCX
    if (m_spWMPPlayer)
    {
        m_spWMPPlayer->close();
        m_spWMPPlayer.Release();
        m_spWMPPlayer = NULL;
    }

    m_wndView.DestroyWindow();

    bHandled = FALSE;
    return 0;
}

LRESULT CWMPHost::OnErase(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& bHandled)
{
    return 1;
}

LRESULT CWMPHost::OnDisplayChange(UINT /* uMsg */, WPARAM /* wParam */, LPARAM lParam , BOOL& /* lResult */)
{
    m_spWMPPlayer->close();

    MoveWindow(0, 0, LOWORD(lParam), HIWORD(lParam));
    m_wndView.MoveWindow(0, 0, LOWORD(lParam), HIWORD(lParam));

    m_spWMPPlayer->put_URL(filename);
    
    return 0;
}

LRESULT CWMPHost::OnSysCmd(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
  if ( wParam == SC_SCREENSAVE || wParam == SC_MONITORPOWER )
     {
       bHandled = TRUE;
       return 0;
     }
  else
     {
       bHandled = FALSE;
       return 1;
     }
}

};//namespace

using namespace HOST_MP;


static BOOL ValidateFileName(char *filename)
{
  if ( !PathIsDirectory(filename) && FileExist(filename) )
     {
       char *ext = PathFindExtension(filename);

       if ( !lstrcmpi(ext,".avi") ||
            !lstrcmpi(ext,".wmv") ||
            !lstrcmpi(ext,".mpg") ||
            !lstrcmpi(ext,".mpe") ||
            !lstrcmpi(ext,".mpeg") )
          {
            return TRUE;
          }
     }

  return FALSE;
}


BOOL MP_ShowHost(char *filename)
{
  BOOL rc = FALSE;

  if ( !ValidateFileName(filename) )
     return rc;

  EnableFFDshowForOurApp();

  CWMPHost frame;

  MultiByteToWideChar(CP_ACP,0,filename,-1,frame.filename,MAX_PATH);
  
  RECT rcPos;
  SetRect(&rcPos,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
  
  frame.Create(NULL, rcPos, _T("RS MP Screen"), 0, 0, (UINT)0);
  if ( !frame.error )
     {
  	frame.m_spWMPPlayer->put_enableContextMenu(VARIANT_FALSE);
	IWMPSettings *i = NULL;
  	frame.m_spWMPPlayer->get_settings(&i);
  	if ( i )
           i->put_playCount(0x7FFFFFFF);
 	frame.m_spWMPPlayer->put_uiMode(L"none");
   	frame.ShowWindow(SW_SHOWNORMAL);
   	ShowCursor(FALSE);
   	frame.UpdateWindow();
   	frame.m_spWMPPlayer->put_URL(frame.filename);
   	MessageLoop();
   	ShowCursor(TRUE);
   	rc = TRUE;
     }
  frame.DestroyWindow();

  return rc;
}
