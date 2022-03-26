// CreateFileDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "CreateFileDlg.h"


// CCreateFileDlg dialog

IMPLEMENT_DYNAMIC(CCreateFileDlg, CDialog)

CCreateFileDlg::CCreateFileDlg(CWnd* pParent /*=NULL*/, BOOL bFile/*=TRUE*/)
	: CDialog(CCreateFileDlg::IDD, pParent)
	, m_szNameOperation(_T(""))
	, m_szNameFile(_T(""))
{
	m_bOperationName = bFile;
}

CCreateFileDlg::~CCreateFileDlg()
{
}

void CCreateFileDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_STATIC_NAME, m_szNameOperation);
	DDX_Text(pDX, IDC_ED_NAME, m_szNameFile);
}


BEGIN_MESSAGE_MAP(CCreateFileDlg, CDialog)
	ON_BN_CLICKED(IDOK, &CCreateFileDlg::OnBnClickedOk)
END_MESSAGE_MAP()


// CCreateFileDlg message handlers

void CCreateFileDlg::OnBnClickedOk()
{
	UpdateData(TRUE);
	
	if(m_szNameFile.IsEmpty())
	{
		AfxMessageBox("Не введено имя");
		return; 
	}

	OnOK();
}

BOOL CCreateFileDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	if(!m_bOperationName)
	{
		SetWindowText("Создание нового каталога");
		m_szNameOperation = "Имя нового каталога:";
		UpdateData(FALSE);
	}
	else
	{
		SetWindowText("Создание нового файла");
		m_szNameOperation = "Имя нового файла:";
		UpdateData(FALSE);
	}
	
	//GetDlgItem(IDC_ED_NAME)->SetFocus();

	return TRUE;
	
}
