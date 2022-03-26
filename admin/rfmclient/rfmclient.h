// ClientRFM.h : main header file for the ClientRFM application
//
#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"       // main symbols


// CClientRFMApp:
// See ClientRFM.cpp for the implementation of this class
//

class CClientRFMApp : public CWinApp
{
public:
	CClientRFMApp();


// Overrides
public:
	virtual BOOL InitInstance();

// Implementation

public:
	afx_msg void OnAppAbout();
	DECLARE_MESSAGE_MAP()
};

extern CClientRFMApp theApp;