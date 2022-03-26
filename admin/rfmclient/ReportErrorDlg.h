#pragma once
#include "afxcmn.h"
#include <vector>
using namespace std;

typedef vector<CString> c_error_list;


// CReportErrorDlg dialog

class CReportErrorDlg : public CDialog
{
	DECLARE_DYNAMIC(CReportErrorDlg)

public:
	CReportErrorDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CReportErrorDlg();

// Dialog Data
	enum { IDD = IDD_DLG_REPORT_ERROR };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedBtnSave();
	CListCtrl m_ctrl_report_error;
	// Добавить новую ошибку
	void add_new_error(CString str_error);
	// Узнать количество ошибок на текущий момент
	size_t get_count_errors(){return m_arr_list_error.size();}
private:
	// Список ошибок на текущий момент
	c_error_list m_arr_list_error; 
	virtual BOOL OnInitDialog();
	afx_msg void OnClose();
};

