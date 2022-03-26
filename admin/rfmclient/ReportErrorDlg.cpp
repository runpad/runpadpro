// ReportErrorDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "ReportErrorDlg.h"
#include "afxdlgs.h"


// CReportErrorDlg dialog

IMPLEMENT_DYNAMIC(CReportErrorDlg, CDialog)

CReportErrorDlg::CReportErrorDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CReportErrorDlg::IDD, pParent)
{

}

CReportErrorDlg::~CReportErrorDlg()
{
	m_arr_list_error.clear();
}

void CReportErrorDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_ERRORS, m_ctrl_report_error);
}


BEGIN_MESSAGE_MAP(CReportErrorDlg, CDialog)
	ON_BN_CLICKED(IDC_BTN_SAVE, &CReportErrorDlg::OnBnClickedBtnSave)
	ON_WM_CLOSE()
END_MESSAGE_MAP()


// CReportErrorDlg message handlers

void CReportErrorDlg::OnBnClickedBtnSave()
{
	CFileDialog f_dlg(false);
	if(f_dlg.DoModal() == IDCANCEL)
		return;
	
	CString sz_full_path = f_dlg.GetPathName();
	
	CStdioFile std_file;
	
	if(!std_file.Open(sz_full_path, CStdioFile::modeCreate | CStdioFile::modeWrite))
		AfxMessageBox("Ошибка создания файла");

	for(int i=0; i < (int)m_arr_list_error.size(); i++)
	{
		std_file.WriteString(m_arr_list_error[i]+"\n");	
	}

	std_file.Close();	
}

BOOL CReportErrorDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_ctrl_report_error.InsertColumn(0, _T("Описание ошибок"), 0, 500);  
		
	// Выгрузить все данные

	for(size_t i = 0; i < m_arr_list_error.size(); i++)
		m_ctrl_report_error.InsertItem((int)i, m_arr_list_error[i]);

	return TRUE;
}


// Добавить новую ошибку

void CReportErrorDlg::add_new_error(CString str_error)
{
	m_arr_list_error.push_back(str_error);
}


void CReportErrorDlg::OnClose()
{
	m_arr_list_error.clear();

	CDialog::OnClose();
}
