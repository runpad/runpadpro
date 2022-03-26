#pragma once
#include "afxwin.h"
#include "WzComboBox.h"

#define IDC_DISC_COMBO_RIGHT WM_USER + 1000
#define IDC_DISC_COMBO_LEFT WM_USER + 1001



// CDiscSelectDlg dialog

class CDiscSelectDlg : public CDialogBar
{
	DECLARE_DYNAMIC(CDiscSelectDlg)

public:
	CDiscSelectDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDiscSelectDlg();

// Dialog Data
	enum { IDD = IDR_MAINFRAME };

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnSize(UINT nType, int cx, int cy);
public:
	// Отобразить левого окна;
	void SetPathLeft(CString strPath);
	// Отобразить правого окна;
	void SetPathRight(CString strPath);
public:
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	CWzComboBox *GetLocalCombo(){return &m_ctrlDiscComboRight;}
	CWzComboBox *GetNetCombo(){return &m_ctrlDiscComboLeft;}
private:
	CStatic		m_ctrlPathLeft,
				m_ctrlPathRight;
	CFont m_fontDrives;
	CWzComboBox m_ctrlDiscComboRight;
	CWzComboBox m_ctrlDiscComboLeft;
	afx_msg void OnCbnSelchangeComboRight();
	afx_msg void OnCbnSelchangeComboLeft();
};
