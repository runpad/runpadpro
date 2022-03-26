// DiscSelectDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "DiscSelectDlg.h"
#include "mainfrm.h"




// CDiscSelectDlg dialog

IMPLEMENT_DYNAMIC(CDiscSelectDlg, CDialogBar)

CDiscSelectDlg::CDiscSelectDlg(CWnd* pParent /*=NULL*/)
//	: CDialog(CDiscSelectDlg::IDD, pParent)
{
	VERIFY(m_fontDrives.CreateFont(
				   12,
				   0,
				   0,
				   0,
				   FW_NORMAL,
				   FALSE,    
				   FALSE,    
				   0,          
				   ANSI_CHARSET,
				   OUT_DEFAULT_PRECIS,
				   CLIP_DEFAULT_PRECIS,
				   DEFAULT_QUALITY,    
				   DEFAULT_PITCH | FF_SWISS,
				   _T("MS Sans Serif")));       
}

CDiscSelectDlg::~CDiscSelectDlg()
{
	m_fontDrives.DeleteObject();
}


BEGIN_MESSAGE_MAP(CDiscSelectDlg, CDialogBar)
	ON_WM_SIZE()
	ON_WM_CREATE()
	ON_CBN_SELENDOK(IDC_DISC_COMBO_RIGHT, &CDiscSelectDlg::OnCbnSelchangeComboRight)
	ON_CBN_SELENDOK(IDC_DISC_COMBO_LEFT, &CDiscSelectDlg::OnCbnSelchangeComboLeft)
END_MESSAGE_MAP()


// CDiscSelectDlg message handlers

void CDiscSelectDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialogBar::OnSize(nType, cx, cy);
	
	if(!m_ctrlDiscComboRight.m_hWnd)
		return;

	m_ctrlDiscComboRight.SetWindowPos(NULL, (int)cx/2, 2, 73, 200, NULL);	
	
	m_ctrlPathRight.SetWindowPos(NULL, (int)(cx/2) + 76, 5, cx - ((int)(cx/2)), 70, NULL);	

	m_ctrlPathLeft.SetWindowPos(NULL, 78, 5, (int)(cx/2) - 78,  70, NULL);	
}



int CDiscSelectDlg::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CDialogBar::OnCreate(lpCreateStruct) == -1)
		return -1;

	// Создание списков для дисков
	
	CRect rcLeft = CRect(2, 2, 75, 200), rcRight = CRect(179, 2, 252, 200);
	
	if(!m_ctrlDiscComboRight.Create(CBS_HASSTRINGS | CBS_DROPDOWNLIST | CBS_OWNERDRAWFIXED | WS_VSCROLL | WS_TABSTOP | WS_VISIBLE,
		rcRight, this, IDC_DISC_COMBO_RIGHT))
	{
		return 1;
	}

	if(!m_ctrlDiscComboLeft.Create(CBS_HASSTRINGS | CBS_DROPDOWNLIST | CBS_OWNERDRAWFIXED | WS_VSCROLL | WS_TABSTOP | WS_VISIBLE,
		rcLeft, this, IDC_DISC_COMBO_LEFT))
	{
		return 1;
	}

	m_ctrlDiscComboRight.SetFont(&m_fontDrives);
	m_ctrlDiscComboLeft.SetFont(&m_fontDrives);
	
	// Создание элементов для вывода пути

	CRect rcLeftStatic  = CRect(78, 5, 178, 70), 
		  rcRightStatic = CRect(182, 5, 282, 61);

	
	if(!m_ctrlPathLeft.Create("Static", WS_VISIBLE, rcLeftStatic, this))
	{
		return 1;
	}
	
	if(!m_ctrlPathRight.Create("Static", WS_VISIBLE, rcRightStatic, this))
	{
		return 1;
	}
	
	m_ctrlPathLeft.SetFont(&m_fontDrives);
	m_ctrlPathRight.SetFont(&m_fontDrives);	
	m_ctrlPathLeft.SetWindowText("");
	m_ctrlPathRight.SetWindowText("");
	return 0;
}

// Переключение дисков на правом списке 

void CDiscSelectDlg::OnCbnSelchangeComboRight()
{
	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	if(!pFrame) return;
	pFrame->PostMessage(IDC_DISC_COMBO_RIGHT); 
	
	//pFrame->OnSwichLocalDisc();
}

// Переключение дисков на левом списке 

void CDiscSelectDlg::OnCbnSelchangeComboLeft()
{
	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	if(!pFrame) return;
	pFrame->m_tabCtrlNet.PostMessage(IDC_DISC_COMBO_LEFT); 
	//pFrame->m_tabCtrlNet.OnSwichLocalDisc();	
}


// Отобразить левого окна;

void CDiscSelectDlg::SetPathLeft(CString strPath)
{
	m_ctrlPathLeft.SetWindowText(strPath);
}

// Отобразить правого окна;

void CDiscSelectDlg::SetPathRight(CString strPath)
{
	m_ctrlPathRight.SetWindowText(strPath);
}