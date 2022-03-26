#pragma once
#include "afxcmn.h"
#include "afxwin.h"
#include "resource.h"

// CProcessDlg dialog

class CProcessDlg : public CDialog
{
	DECLARE_DYNAMIC(CProcessDlg)

public:
	CProcessDlg(CWnd* pParent = NULL);   // standard constructor
	virtual ~CProcessDlg();
	// Установить максимум основного прогреса
	void SetMaxProcess(ULONGLONG nMax);
	// Обновить прогресс основной
	void UpdateProgress(ULONGLONG nCurrentPos);	
	// Установить максимум прогреса копирования
	void SetMaxProcessCopy(ULONGLONG nMax);
	// Обновить прогресс  копирования
	void UpdateProgressCopy(ULONGLONG nCurrentPos);	
	// Установить текст 1
	void SetText1(CString str);
	// Установить текст 2
	void SetText2(CString str);
	// Установить имя окна процесса
	void SetNameWnd(CString szName){m_strNameWnd = szName;}
	HWND get_hwnd_process() const {return m_hwnd_progress;}
// Dialog Data
	enum { IDD = IDD_PROCESS_DLG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedBreakOperation();
	// Сообщение на обновление текстов
	afx_msg LRESULT OnUpdateText(WPARAM wp, LPARAM lp);
	// Сообщение на обновление процесса основного
	afx_msg LRESULT OnUpdateProgress(WPARAM wp, LPARAM lp);
	// Сообщение на обновление максимальной позиции прогреса основого
	afx_msg  LRESULT OnUpdatePosMax(WPARAM wp, LPARAM lp);
	// Сообщение на обновление процесса копирования
	afx_msg LRESULT OnUpdateProgressCopy(WPARAM wp, LPARAM lp);
	// Сообщение на обновление максимальной позиции прогреса копирования
	afx_msg  LRESULT OnUpdatePosMaxCopy(WPARAM wp, LPARAM lp);
private:
	// Текущая позиция прогреса основоного
	ULONGLONG m_liSizeCurrent;
	// Текущая позиция прогреса копирования
	ULONGLONG m_liSizeCurrentCopy;
	// Граница прогреса основного
	ULONGLONG m_liSizeMax;
	// Граница прогреса копирования
	ULONGLONG m_liSizeMaxCopy;
	// Название операции
	CString m_strNameWnd;
	// Прогресс основной
	CProgressCtrl m_ctrlProgress;
	// Прогресс копирования
	CProgressCtrl m_ctrlProgressCopy;
	// Событие старта потока
	HANDLE m_h_thread_start;
	// Событие останова потока
	HANDLE m_h_thread_stop;
	// Ответ потока на остановку
	HANDLE m_h_thread_was_stoped;
	// Защита данных статуса
	CRITICAL_SECTION m_cs_data_status;
	// Флаг глобального останова
	bool *m_pb_flag_global_stop;
	HWND m_hwnd_progress;
public:
	CStatic m_ctrText1;
	CStatic m_ctrText2;
public:
	virtual BOOL OnInitDialog();
	// Установить событие старта потока
	void set_event_start_thread(HANDLE h_thread_start){m_h_thread_start=h_thread_start;}
	// Установить событие для останова потока
	void set_event_stop_thread(HANDLE h_thread_stop){m_h_thread_stop=h_thread_stop;}
	// Установить событие для для извещения окна статуса об остановке
	void set_event_was_stoped_thread(HANDLE h_thread_was_stoped){m_h_thread_was_stoped=h_thread_was_stoped;}
	// Утановить флаг нлобального останова операции
	void set_flag_global_stop(bool *pb_flag_stop){m_pb_flag_global_stop = pb_flag_stop;}
public:
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
};
