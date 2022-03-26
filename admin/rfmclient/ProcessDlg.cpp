// ProcessDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "ProcessDlg.h"
#include "RfmThreads.h"


UINT WM_UPDATE_POS = RegisterWindowMessage("Update pos");
UINT WM_UPDATE_TEST = RegisterWindowMessage("Update text");
UINT WM_UPDATE_POS_MAX = RegisterWindowMessage("Update pos max");
UINT WM_UPDATE_POS_COPY = RegisterWindowMessage("Update pos copy");
UINT WM_UPDATE_POS_MAX_COPY = RegisterWindowMessage("Update pos max copy");


// CProcessDlg dialog

IMPLEMENT_DYNAMIC(CProcessDlg, CDialog)

CProcessDlg::CProcessDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CProcessDlg::IDD, pParent)
{
	m_strNameWnd = "";
	m_liSizeMax = 0;
	m_liSizeCurrent = 0;
	InitializeCriticalSection(&m_cs_data_status);
	m_pb_flag_global_stop = NULL;	
}

CProcessDlg::~CProcessDlg()
{
	DeleteCriticalSection(&m_cs_data_status);
}

void CProcessDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_PROGRESS_OPER, m_ctrlProgress);
	DDX_Control(pDX, IDC_STATIC_STR1, m_ctrText1);
	DDX_Control(pDX, IDC_STATIC_STR2, m_ctrText2);
	DDX_Control(pDX, IDC_PROGRESS_COPY, m_ctrlProgressCopy);
}


BEGIN_MESSAGE_MAP(CProcessDlg, CDialog)
	ON_BN_CLICKED(IDCANCEL, &CProcessDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDOK, &CProcessDlg::OnBnClickedOk)
	ON_BN_CLICKED(IDC_BTN_OPERATION_BREAK, &CProcessDlg::OnBnClickedBreakOperation)
	ON_REGISTERED_MESSAGE(WM_UPDATE_POS, &CProcessDlg::OnUpdateProgress)
	ON_REGISTERED_MESSAGE(WM_UPDATE_TEST, &CProcessDlg::OnUpdateText)
	ON_REGISTERED_MESSAGE(WM_UPDATE_POS_MAX, &CProcessDlg::OnUpdatePosMax)
	ON_REGISTERED_MESSAGE(WM_UPDATE_POS_COPY, &CProcessDlg::OnUpdateProgressCopy)
	ON_REGISTERED_MESSAGE(WM_UPDATE_POS_MAX_COPY, &CProcessDlg::OnUpdatePosMaxCopy)
	ON_WM_KEYDOWN()
END_MESSAGE_MAP()


// Установить максимум

void CProcessDlg::SetMaxProcess(ULONGLONG  nMax)
{
	m_liSizeMax = nMax;
	m_liSizeCurrent = 0;
}




// Обновить прогресс

void CProcessDlg::UpdateProgress(ULONGLONG nCurrentPos)
{
	if(m_liSizeMax == 0L)
		return;
	
	int nPosNew = (int)((nCurrentPos * 100) / m_liSizeMax);

	
	m_ctrlProgress.SetPos(nPosNew);

}

// Установить максимум прогреса копирования

void CProcessDlg::SetMaxProcessCopy(ULONGLONG nMax)
{
	m_liSizeMaxCopy = nMax;
	m_liSizeCurrentCopy = 0;
}

// Обновить прогресс  копирования

void CProcessDlg::UpdateProgressCopy(ULONGLONG nCurrentPos)
{
	if(m_liSizeMaxCopy == 0L)
		return;
	
	int nPosNew = (int)((nCurrentPos * 100) / m_liSizeMaxCopy);

	
	m_ctrlProgressCopy.SetPos(nPosNew);
}



// Установить текст 1

void CProcessDlg::SetText1(CString str)
{
	m_ctrText1.SetWindowTextA(str);
}

// Установить текст 2

void CProcessDlg::SetText2(CString str)
{
	m_ctrText2.SetWindowTextA(str);
}

BOOL CProcessDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_hwnd_progress = this->m_hWnd;

	m_liSizeMaxCopy = 0;
	m_liSizeCurrentCopy = 0;
	m_liSizeMax = 0;
	m_liSizeCurrent = 0;
	
	SetText1("");
	SetText2("");
	
	SetWindowText(m_strNameWnd);

	m_ctrlProgress.SetRange(0, 100);
	
	// Сигнал старта потока

	::SetEvent(m_h_thread_start);

	return TRUE;  
}

// Сообщение обновления максимальной границы

LRESULT CProcessDlg::OnUpdatePosMax(WPARAM wp, LPARAM lp)
{
	EnterCriticalSection(&m_cs_data_status);
	ULONGLONG max_pos = CRfmThreads::g_li_max_bound;
	LeaveCriticalSection(&m_cs_data_status);
	SetMaxProcess(max_pos);
	return TRUE;
}

// Сообщение на обновление процесса

LRESULT CProcessDlg::OnUpdateProgress(WPARAM wp, LPARAM lp)
{
	EnterCriticalSection(&m_cs_data_status);
	m_liSizeCurrent += CRfmThreads::g_li_cur_pos;
	LeaveCriticalSection(&m_cs_data_status);
	UpdateProgress(m_liSizeCurrent);
	
	return TRUE;
}

// Сообщение на обновление тексов для операций

LRESULT CProcessDlg::OnUpdateText(WPARAM wp, LPARAM lp)
{
	EnterCriticalSection(&m_cs_data_status);
	SetText1((const char*)CRfmThreads::g_sz_text1);
	SetText2((const char*)CRfmThreads::g_sz_text2);
	LeaveCriticalSection(&m_cs_data_status);
	return TRUE;
}

// Сообщение на обновление процесса копирования
LRESULT CProcessDlg::OnUpdateProgressCopy(WPARAM wp, LPARAM lp)
{
	EnterCriticalSection(&m_cs_data_status);
	m_liSizeCurrentCopy += CRfmThreads::g_li_cur_pos_copy;
	LeaveCriticalSection(&m_cs_data_status);
	UpdateProgressCopy(m_liSizeCurrentCopy);
	
	return TRUE;
}

// Сообщение на обновление максимальной позиции прогреса копирования

LRESULT CProcessDlg::OnUpdatePosMaxCopy(WPARAM wp, LPARAM lp)
{
	EnterCriticalSection(&m_cs_data_status);
	ULONGLONG max_pos = CRfmThreads::g_li_max_bound_copy;
	LeaveCriticalSection(&m_cs_data_status);
	SetMaxProcessCopy(max_pos);
	return TRUE;
}


void CProcessDlg::OnBnClickedCancel()
{
	// Дать сигнал на остановку текущей операции

	::SetEvent(m_h_thread_stop);

	// Подождать завершения

	::WaitForSingleObject(m_h_thread_was_stoped, INFINITE);
	
	OnCancel();
}

void CProcessDlg::OnBnClickedOk(){}


void CProcessDlg::OnBnClickedBreakOperation()
{
	// Установить флаг глобального прерывания операции
	
	if(m_pb_flag_global_stop)
		*m_pb_flag_global_stop = false;
	
	// Сгенерировать сообщение останова

	OnBnClickedCancel();
}
void CProcessDlg::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	

	CDialog::OnKeyDown(nChar, nRepCnt, nFlags);
}

BOOL CProcessDlg::PreTranslateMessage(MSG* pMsg)
{
	if(pMsg->message == WM_KEYDOWN)
	{
		if(pMsg->wParam == 0x1B)
		{
			// Глобальное прерывание операции по клавише <ESC>
			
			if(m_pb_flag_global_stop)
				*m_pb_flag_global_stop = false;
		}
	}

	return CDialog::PreTranslateMessage(pMsg);
}
