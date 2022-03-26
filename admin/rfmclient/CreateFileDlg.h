#pragma once


// CCreateFileDlg dialog

class CCreateFileDlg : public CDialog
{
	DECLARE_DYNAMIC(CCreateFileDlg)

public:
	CCreateFileDlg(CWnd* pParent = NULL, BOOL bFile=TRUE);   // standard constructor
	virtual ~CCreateFileDlg();

// Dialog Data
	enum { IDD = IDD_DLG_NEW_FILI };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CString m_szNameOperation;
	CString m_szNameFile;
	afx_msg void OnBnClickedOk();
private:
	BOOL m_bOperationName;
	virtual BOOL OnInitDialog();
};
