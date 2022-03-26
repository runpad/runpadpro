// ConnectDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "ConnectDlg.h"


CString CConnectDlg::g_sz_last_name_host = _T("localhost");

// CConnectDlg dialog

IMPLEMENT_DYNAMIC(CConnectDlg, CDialog)

CConnectDlg::CConnectDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CConnectDlg::IDD, pParent)
	, m_szNetName(g_sz_last_name_host)
	, m_iPortNumber(DEFAULT_PORT_SERVER)
{

}

CConnectDlg::~CConnectDlg()
{
}

void CConnectDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_ED_NET_NAME, m_szNetName);
}


BEGIN_MESSAGE_MAP(CConnectDlg, CDialog)
	ON_BN_CLICKED(IDOK, &CConnectDlg::OnBnClickedOk)
END_MESSAGE_MAP()


// CConnectDlg message handlers

void CConnectDlg::OnBnClickedOk()
{
	UpdateData(TRUE);
	g_sz_last_name_host = m_szNetName;
	OnOK();
}
