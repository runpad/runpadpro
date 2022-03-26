#pragma once


// CConnectDlg dialog

class CConnectDlg : public CDialog
{
	DECLARE_DYNAMIC(CConnectDlg)

public:
	CConnectDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CConnectDlg();

// Dialog Data
	enum { IDD = IDD_DLG_CONNECT };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CString m_szNetName;
	UINT m_iPortNumber;
	afx_msg void OnBnClickedOk();
private:
	static CString g_sz_last_name_host;
};
