#pragma once

#include "xShadeButton.h"

// CToolBarDlg dialog

class CToolBarDlg : public CDialogBar
{
	DECLARE_DYNAMIC(CToolBarDlg)

public:
	CToolBarDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CToolBarDlg();

// Dialog Data
	enum { IDD = IDR_TOOLBAR_DLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	CxShadeButton	m_btnConnect;
	CxShadeButton	m_btnDisConnect;
	CxShadeButton	m_btnCreateFile;
	CxShadeButton	m_btnCreateDir;
	CxShadeButton	m_btnDeleteFile;
	CxShadeButton	m_btnCopy;
	CxShadeButton	m_btnMove;
	CxShadeButton	m_btnPreview;
	CxShadeButton	m_btnEdit;
	CxShadeButton	m_btnRefresh;
public:
	virtual BOOL Create(CWnd* pParentWnd, UINT nIDTemplate, UINT nStyle, UINT nID);
};
