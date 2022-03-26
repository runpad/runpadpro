#pragma once

//////////////////////////////////////////////////////////////////////////////////////////////////////
// Класс		: CRfmThreads
// Описание		: Предназначен для выполнения файловых операций в потоке с последующим отображения 
//				  статуса операции. 	
//////////////////////////////////////////////////////////////////////////////////////////////////////

#include "ProcessDlg.h"
#include "ReportErrorDlg.h"
#include ".\Rfmclientsocket.h"
#include <vector>
using namespace std;

class CRfmClientSocket;

typedef vector<CString> array_path; 

typedef struct __path_ident__
{
	CString sz_path;
	bool	b_dir;	
}path_ident;

typedef vector<path_ident> array_path_ident; 

//////////////////////////////////////////////////
// Структура параметров для рабочего потока
//////////////////////////////////////////////////

class CRfmThreads;

typedef struct __params_thread__
{
	CString				sz_path_server;			// путь копирования\перемещения на сервер	
	array_path			*p_arr_path;			// Массив путей к файлам
	CRfmThreads			*p_rfm_threads;			// Указатель на класс управления потоками
	CRfmClientSocket	*pConnect;				// Указатель на обьект соединения с сервером
	array_path_ident	*p_arr_local_path;		// Массив путей копирования локально
	array_path_ident	*p_arr_server_path;		// Массив путей копирования на сервере
}params_thread, *pparams_thread;

class CRfmThreads
{
public:
	CRfmThreads(void);
	~CRfmThreads(void);
	// Удалить файлы локально
	// arr_del_path - массив путей к файлам
	void delete_local_files(array_path arr_del_path);
	// Удалить файлы на сервере
	void delete_server_files(array_path_ident arr_path, CRfmClientSocket *pConnect); 
	// Копировать файлы на сервер
	void copy_files_to_server(CString sz_path_server, array_path arr_copy_path, CRfmClientSocket *pConnect); 
	// Копировать файлы с сервера
	void copy_files_from_server(array_path_ident arr_path_local, array_path_ident arr_path_srv, CRfmClientSocket *pConnect); 
	// Копировать файл на сервер
	// arr_move_path - массив перемещения файлов на сервер
	void move_files_to_server(CString sz_path_server, array_path arr_move_path, CRfmClientSocket *pConnect);
	// Переместить файлы с сервера
	void move_files_from_server(array_path_ident arr_path_local, array_path_ident arr_path_srv, CRfmClientSocket *pConnect);
	// Определить событие старта потока
	HANDLE get_handle_start(){return m_hThreadStart;}
	// Определить событие останова потока
	HANDLE get_handle_stop(){return m_hThreadStop;}
	// Определить событие ответа потока на останов
	HANDLE get_handle_was_stoped(){return m_hThreadWasStoped;}
	// Установить текстовку на диалоге статуса
	void SetTextStatusDlg(CString text_1, CString text_2);
	// Установить максимальную границу для основного прогреса
	void SetMaxBoundProgress(ULONGLONG li_max_bound);
	// Обновить показания основного прогреса
	void UpdateProgress(ULONGLONG li_cur_pos);
	// Установить максимальную границу для прогреса копирования
	void SetMaxBoundProgressCopy(ULONGLONG li_max_bound);
	// Обновить показания прогреса копирования
	void UpdateProgressCopy(ULONGLONG li_cur_pos);
	// Закрыть окно по окончанию операции
	void CloseStatusWindow();
	// Добавить описание возникшей ошибки
	void add_new_error(CString str_error)
	{
		m_report_errors_dlg.add_new_error(str_error);
	}
	// Определить флаг глобального останова
	bool get_flag_global_stop() const {return m_global_stop;}
	// Установить флаг глобального останова
	void set_flag_global_stop(bool b_flag_stop){m_global_stop = b_flag_stop;}
private:
	// Окно для отображения процесса
	CProcessDlg m_proc_dlg;
	// Дескриптор события старта потока
	HANDLE m_hThreadStart;
	// Дескриптор события останова потока
	HANDLE m_hThreadStop;
	// Дескриптор события ответа потока на останов
	HANDLE m_hThreadWasStoped;
	// Дескриптор потока
	HANDLE m_h_thread;
	// Идентификатор потока
	DWORD m_dw_id_thread;
	// Защита данных статуса
	CRITICAL_SECTION m_cs_data_status;
	// Окно отображающее отчет об ошибках
	CReportErrorDlg m_report_errors_dlg;
	// Глобальный останов операции
	bool m_global_stop;
public:	
	// Глобальные данны для окна отображения статуса
	// Эти данные вычитывает окно статуса при получении события обновления
	static char			g_sz_text1[MAX_PATH];	// первая строка на окне статуса
	static char			g_sz_text2[MAX_PATH];	// вторая строка на окне статуса
	static ULONGLONG	g_li_max_bound;			// максимальная граница основного прогреса
	static ULONGLONG	g_li_cur_pos;			// текущая позиция основного прогреса 
	static ULONGLONG	g_li_max_bound_copy;	// максимальная граница прогреса копирования
	static ULONGLONG	g_li_cur_pos_copy;		// текущая позиция прогреса копирования
};

