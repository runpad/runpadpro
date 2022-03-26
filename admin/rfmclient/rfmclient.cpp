// ClientRFM.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "rfmclient.h"
#include "MainFrm.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CClientRFMApp

BEGIN_MESSAGE_MAP(CClientRFMApp, CWinApp)
	ON_COMMAND(ID_APP_ABOUT, &CClientRFMApp::OnAppAbout)
END_MESSAGE_MAP()


// CClientRFMApp construction

CClientRFMApp::CClientRFMApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CClientRFMApp object

CClientRFMApp theApp;

extern BOOL CheckAtStartup(HWND parent,BOOL silent);


// CClientRFMApp initialization

BOOL CClientRFMApp::InitInstance()
{
        if ( !CheckAtStartup(NULL,FALSE) )
           return FALSE;

	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	// Initialize OLE libraries
	if (!AfxOleInit())
	{
		AfxMessageBox(IDP_OLE_INIT_FAILED);
		return FALSE;
	}
	AfxEnableControlContainer();
	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));
	// To create the main window, this code creates a new frame window
	// object and then sets it as the application's main window object
	CMainFrame* pFrame = new CMainFrame;
	if (!pFrame)
		return FALSE;
	m_pMainWnd = pFrame;
	// create and load the frame with its resources
	pFrame->LoadFrame(IDR_MAINFRAME,
		WS_OVERLAPPEDWINDOW | FWS_ADDTOTITLE, NULL,
		NULL);


	



	// The one and only window has been initialized, so show and update it
	pFrame->ShowWindow(SW_SHOWMAXIMIZED);
	pFrame->UpdateWindow();
	// call DragAcceptFiles only if there's a suffix
	//  In an SDI app, this should occur after ProcessShellCommand
	return TRUE;
}


// CClientRFMApp message handlers





// App command to run the dialog
void CClientRFMApp::OnAppAbout()
{
	//CAboutDlg aboutDlg;
	//aboutDlg.DoModal();
}


// CClientRFMApp message handlers

