
#include "stdafx.h"
#include "initguid.h"
#include <commctrl.h>
#include <shlwapi.h>
#include <stdlib.h>
#include "wmp.h"
#include "wmpids.h"
#include "../rp_shared/rp_shared.h"
#include "../common/version.h"

int error = 0;


class CWMPHost
        : public CWindowImpl<CWMPHost, CWindow, CWinTraits<WS_OVERLAPPEDWINDOW | /*WS_VISIBLE |*/ WS_CLIPCHILDREN | WS_CLIPSIBLINGS, WS_EX_APPWINDOW> >
	, public IDispEventImpl<1,CWMPHost>
{
public:
    DECLARE_WND_CLASS_EX(NULL, 0, 0)

    BEGIN_MSG_MAP(CWMPHost)
        MESSAGE_HANDLER(WM_CREATE, OnCreate)
        MESSAGE_HANDLER(WM_DESTROY, OnDestroy)
        MESSAGE_HANDLER(WM_SIZE, OnSize)
        MESSAGE_HANDLER(WM_ERASEBKGND, OnErase)
        MESSAGE_HANDLER(WM_SYSCOMMAND, OnSysCmd)
    END_MSG_MAP()

    void OnFinalMessage(HWND /*hWnd*/);
    LRESULT OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnErase(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& bHandled);
    LRESULT OnSize(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& /* lResult */);
    LRESULT OnSysCmd(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);

    BEGIN_SINK_MAP(CWMPHost)
        SINK_ENTRY(1, 5101, OnPlayStateChange)
    END_SINK_MAP()

    void __stdcall OnPlayStateChange(long NewState);

    CAxWindow                   m_wndView;
    CComPtr<IWMPPlayer>         m_spWMPPlayer;
};


void __stdcall CWMPHost::OnPlayStateChange(long NewState)
{
    if (NewState == 3)
        m_spWMPPlayer->put_fullScreen(VARIANT_TRUE);
}


void CWMPHost::OnFinalMessage(HWND /*hWnd*/)
{
    ::PostQuitMessage(0);
}

LRESULT CWMPHost::OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
    CComPtr<IAxWinHostWindow>           spHost;
    HRESULT                             hr;
    RECT                                rcClient;

	AtlAxWinInit();

    // create window
    GetClientRect(&rcClient);
    m_wndView.Create(m_hWnd, rcClient, NULL, WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN, WS_EX_CLIENTEDGE);
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
    ::MessageBox(NULL,"Windows Media Player 9+ needed","Error",MB_ICONERROR | MB_OK);
    ::PostQuitMessage(0);
    ::error = 1;
    return 0;
}

LRESULT CWMPHost::OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled)
{
    // Stop listening events
    Unadvise(m_spWMPPlayer);
    
    // close the OCX
    if (m_spWMPPlayer)
    {
        m_spWMPPlayer->close();
        m_spWMPPlayer.Release();
    }

    bHandled = FALSE;
    return 0;
}

LRESULT CWMPHost::OnErase(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& bHandled)
{
    return 1;
}

LRESULT CWMPHost::OnSize(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& /* lResult */)
{
    RECT rcClient;
    GetClientRect(&rcClient);
    m_wndView.MoveWindow(rcClient.left, rcClient.top, rcClient.right, rcClient.bottom);
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



CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
END_OBJECT_MAP()



int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nShowCmd)
{
        char filename[MAX_PATH];

	::InitCommonControls();

        if ( !CheckRPVersion(RUNPAD_VERSION_DIG) )
           return 0;

        EnableFFDshowForOurApp();

   	
	filename[0] = 0;
	if ( __argc >= 2 )
	   {
	     if ( !lstrcmpi(__argv[1],"/dvd") )
	        {
	          if ( __argc == 3 )
	             {
	               char drive = __argv[2][0];
	               wsprintf(filename,"wmpdvd://%c",drive);
	             }
	        }
	     else
	        {
	          if ( __argc == 2 )
	             {
	               lstrcpy(filename,__argv[1]);
	               PathUnquoteSpaces(filename);
	             }
	        }
	   }
	
	if ( !filename[0] )
	   {
             MessageBoxW(NULL,L"Для просмотра медиа просто откройте нужный файл в проводнике пользователя",L"Информация",MB_OK | MB_ICONINFORMATION);
             return 0;
  	   }	

	WCHAR wstr[MAX_PATH];
	MultiByteToWideChar(CP_ACP,0,filename,-1,wstr,MAX_PATH);
	
	CoInitialize(0);
	_Module.Init( ObjectMap, hInstance, &LIBID_ATLLib );

	RECT rcPos = { CW_USEDEFAULT, 0, 0, 0 };
	CWMPHost frame;
        frame.GetWndClassInfo().m_wc.hIcon = LoadIcon(hInstance,MAKEINTRESOURCE(101));
	frame.Create(NULL, rcPos, _T("Media Player"), 0, 0, (UINT)0);
	if ( !error )
	{
		frame.m_spWMPPlayer->put_enableContextMenu(VARIANT_FALSE);
	 	frame.ShowWindow(SW_SHOWNORMAL);
	 	frame.UpdateWindow();

	 	frame.m_spWMPPlayer->put_URL(wstr);

	 	MSG msg;
	 	while (GetMessage(&msg, 0, 0, 0))
	 	{
	 		TranslateMessage(&msg);
	 		DispatchMessage(&msg);
	 	}
	}

	_Module.Term();
	CoUninitialize();
	return 0;
}
