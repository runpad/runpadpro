
#include "stdafx.h"
#include "initguid.h"
#include <commctrl.h>
#include <oleauto.h>
#include <shlwapi.h>
#include <stdlib.h>
#include "../rp_shared/rp_shared.h"
#include "../common/version.h"

#include "flash.tlh"


static int error = 0;


class CWMPHost
        : public CWindowImpl<CWMPHost, CWindow, CWinTraits<WS_OVERLAPPEDWINDOW | /*WS_VISIBLE |*/ WS_CLIPCHILDREN | WS_CLIPSIBLINGS, 0/*WS_EX_APPWINDOW*/> >
	, public IDispEventImpl<1,CWMPHost>
{
public:
    DECLARE_WND_CLASS_EX(NULL, 0, 0)

    BEGIN_MSG_MAP(CWMPHost)
        MESSAGE_HANDLER(WM_CREATE, OnCreate)
        MESSAGE_HANDLER(WM_DESTROY, OnDestroy)
        MESSAGE_HANDLER(WM_SIZE, OnSize)
        MESSAGE_HANDLER(WM_ERASEBKGND, OnErase)
    END_MSG_MAP()

    void OnFinalMessage(HWND /*hWnd*/);
    LRESULT OnDestroy(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnCreate(UINT uMsg, WPARAM wParam, LPARAM lParam, BOOL& bHandled);
    LRESULT OnErase(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& bHandled);
    LRESULT OnSize(UINT /* uMsg */, WPARAM /* wParam */, LPARAM /* lParam */, BOOL& /* lResult */);

    BEGIN_SINK_MAP(CWMPHost)
    END_SINK_MAP()

    CAxWindow m_wndView;
    CComPtr<ShockwaveFlashObjects::IShockwaveFlash> m_spWMPPlayer;
};


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
    m_wndView.Create(m_hWnd, rcClient, NULL, WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN, 0/*WS_EX_CLIENTEDGE*/);
    if (NULL == m_wndView.m_hWnd)
        goto FAILURE;
    
    // load OCX in window
    hr = m_wndView.QueryHost(&spHost);
    if (FAILED(hr))
        goto FAILURE;

    hr = spHost->CreateControl(CComBSTR(_T("{D27CDB6E-AE6D-11CF-96B8-444553540000}")), m_wndView, 0);
    if (FAILED(hr))
        goto FAILURE;

    hr = m_wndView.QueryControl(&m_spWMPPlayer);
    if (FAILED(hr))
        goto FAILURE;

    // Start listening events
    Advise(m_spWMPPlayer);

    return 0;

FAILURE:
    ::MessageBox(NULL,"Macromedia Flash Player needed!","Error",MB_ICONERROR | MB_OK);
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
        m_spWMPPlayer.Release();
        m_spWMPPlayer = NULL;
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



CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
END_OBJECT_MAP()


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nShowCmd)
{
	::InitCommonControls();

        if ( !CheckRPVersion(RUNPAD_VERSION_DIG) )
           return 0;
	
	if ( __argc != 2 )
	   {
             MessageBoxW(NULL,L"Для просмотра SWF-Flash роликов просто откройте нужный файл в проводнике пользователя",L"Информация",MB_OK | MB_ICONINFORMATION);
   	     return 0;
  	   }	
	
	CoInitialize(0);
	_Module.Init( ObjectMap, hInstance, &LIBID_ATLLib );

	{
        	RECT rcPos = { CW_USEDEFAULT, 0, 0, 0 };
        	CWMPHost frame;
                frame.GetWndClassInfo().m_wc.hIcon = LoadIcon(hInstance,MAKEINTRESOURCE(101));

        	char *filename = __argv[1];
        	char title[MAX_PATH];
        	wsprintf(title,"Flash - %s",PathFindFileName(filename));
        	
        	frame.Create(NULL, rcPos, title, 0, 0, (UINT)0);

        	if ( !error )
        	{
        		frame.m_spWMPPlayer->PutMenu(VARIANT_FALSE);

        	 	frame.ShowWindow(SW_SHOWNORMAL);

                     	WCHAR wstr[MAX_PATH];
                     	wstr[0] = 0;
                     	MultiByteToWideChar(CP_ACP,0,filename,-1,wstr,MAX_PATH);
        	 	BSTR bstr = SysAllocString(wstr);
        	 	frame.m_spWMPPlayer->LoadMovie(0,bstr);
        	 	SysFreeString(bstr);

        		frame.m_spWMPPlayer->PutMenu(VARIANT_FALSE);

              	 	SetFocus(frame.m_wndView.m_hWnd);
              	 	
              	 	MSG msg;
              	 	while (GetMessage(&msg, 0, 0, 0))
              	 	{
              	 		TranslateMessage(&msg);
              	 		DispatchMessage(&msg);
              	 	}
        	}
	}

	_Module.Term();
	CoUninitialize();
	return 0;
}
