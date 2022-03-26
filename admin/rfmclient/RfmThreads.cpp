#include "StdAfx.h"
#include "RfmThreads.h"
#include "nrfiledatanet.h"
#include "c_TransportLevel.h"

char		CRfmThreads::g_sz_text1[MAX_PATH] = {0};
char		CRfmThreads::g_sz_text2[MAX_PATH] = {0};
ULONGLONG	CRfmThreads::g_li_max_bound = 0L;
ULONGLONG	CRfmThreads::g_li_cur_pos = 0L;
ULONGLONG	CRfmThreads::g_li_max_bound_copy = 0L;
ULONGLONG	CRfmThreads::g_li_cur_pos_copy = 0L;

// Сообщения окна статуса

extern UINT WM_UPDATE_POS;
extern UINT WM_UPDATE_TEST;
extern UINT WM_UPDATE_POS_MAX;
extern UINT WM_UPDATE_POS_COPY;
extern UINT WM_UPDATE_POS_MAX_COPY;


CRfmThreads::CRfmThreads(void)
{
	m_global_stop = true;
	
	InitializeCriticalSection(&m_cs_data_status);
	m_hThreadStop = ::CreateEvent(NULL, TRUE, FALSE, NULL);
	m_hThreadStart = ::CreateEvent(NULL, TRUE, FALSE, NULL);
	m_hThreadWasStoped = ::CreateEvent(NULL, TRUE, FALSE, NULL);
	m_h_thread = NULL;
	m_dw_id_thread = 0;
	
	// Иницализировать все события в окне старта

	m_proc_dlg.set_event_start_thread(m_hThreadStart);
	m_proc_dlg.set_event_stop_thread(m_hThreadStop);
	m_proc_dlg.set_event_was_stoped_thread(m_hThreadWasStoped);
	m_proc_dlg.set_flag_global_stop(&m_global_stop);

	
}


CRfmThreads::~CRfmThreads(void)
{
	::CloseHandle(m_hThreadStop);
	::CloseHandle(m_hThreadStart);
	::CloseHandle(m_hThreadWasStoped);
	DeleteCriticalSection(&m_cs_data_status);

}

// Установить текстовку на диалоге статуса

void CRfmThreads::SetTextStatusDlg(CString text_1, CString text_2)
{
	EnterCriticalSection(&m_cs_data_status);
	memcpy(g_sz_text1, text_1.GetBuffer(), text_1.GetLength()+1);
	memcpy(g_sz_text2, text_2.GetBuffer(), text_2.GetLength()+1);
	LeaveCriticalSection(&m_cs_data_status);
	if(::IsWindow(m_proc_dlg.m_hWnd))
		m_proc_dlg.PostMessage(WM_UPDATE_TEST, NULL, NULL);
}

// Установить максимальную границу для прогреса

void CRfmThreads::SetMaxBoundProgress(ULONGLONG li_max_bound)
{
	EnterCriticalSection(&m_cs_data_status);
	g_li_max_bound = li_max_bound;
	LeaveCriticalSection(&m_cs_data_status);
	if(::IsWindow(m_proc_dlg.m_hWnd))
		m_proc_dlg.PostMessage(WM_UPDATE_POS_MAX, NULL, NULL);
}

// Обновить показания прогреса

void CRfmThreads::UpdateProgress(ULONGLONG li_cur_pos)
{
	EnterCriticalSection(&m_cs_data_status);
	g_li_cur_pos = li_cur_pos;
	LeaveCriticalSection(&m_cs_data_status);
	if(::IsWindow(m_proc_dlg.m_hWnd))
		m_proc_dlg.PostMessage(WM_UPDATE_POS, NULL, NULL);
}

// Установить максимальную границу для прогреса копирования

void CRfmThreads::SetMaxBoundProgressCopy(ULONGLONG li_max_bound)
{
	EnterCriticalSection(&m_cs_data_status);
	g_li_max_bound_copy = li_max_bound;
	LeaveCriticalSection(&m_cs_data_status);
	if(::IsWindow(m_proc_dlg.m_hWnd))
		m_proc_dlg.PostMessage(WM_UPDATE_POS_MAX_COPY, NULL, NULL);
}

// Обновить показания прогреса копирования

void CRfmThreads::UpdateProgressCopy(ULONGLONG li_cur_pos)
{
	EnterCriticalSection(&m_cs_data_status);
	g_li_cur_pos_copy = li_cur_pos;
	LeaveCriticalSection(&m_cs_data_status);
	if(::IsWindow(m_proc_dlg.m_hWnd))
		m_proc_dlg.PostMessage(WM_UPDATE_POS_COPY, NULL, NULL);
}


// Закрыть окно по окончанию операции

void CRfmThreads::CloseStatusWindow()
{
	if(::IsWindow(m_proc_dlg.get_hwnd_process()))
	{
		m_proc_dlg.SendMessage(WM_CLOSE);
		
	}
}

////////////////////////////////////////////////////////////////////////////////////
///////////////////// ПОТОК УДАЛЕНИЯ ФАЙЛОВ ЛОКАЛЬНО ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadDeleteLocalFiles(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	
	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	CNRFileData file_data(_T(""));
	array_path *p_arr_path = p_params->p_arr_path;
	if(!p_arr_path) return 1;


	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество удаляемых файлов
	
	UINT i_total_count = file_data.get_count_files(*p_arr_path);
	
	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Удалить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		// Удаляем файлы	

		file_data.DeleteFiles((*p_arr_path)[i],  p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();
	
	return 0;
}


// Удалить файлы локально
// arr_del_path - массив путей к файлам

void CRfmThreads::delete_local_files(array_path arr_del_path)
{
	pparams_thread params = new params_thread;
	params->p_arr_path = &arr_del_path;
	params->p_rfm_threads = this;	
		
	::ResetEvent(m_hThreadStop);
	
	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadDeleteLocalFiles, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Удаление");
	m_proc_dlg.DoModal();
	delete params;
	
	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();
}


////////////////////////////////////////////////////////////////////////////////////
////////////////////// ПОТОК УДАЛЕНИЯ ФАЙЛОВ НА СЕРВЕРЕ ////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadDeleteFilesServer(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	CNRFileDataNet file_net((c_TransportLevel*)p_params->pConnect);
	array_path_ident *p_arr_path = p_params->p_arr_server_path;
	if(!p_arr_path) return 1;
	CString sz_err;

	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество копируемых файлов
	
	UINT i_total_count = 0;

	for(int i = 0; i < (int)p_arr_path->size(); i++)
	{
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		if((*p_arr_path)[i].b_dir)
			i_total_count += file_net.get_count_file_dir_srv((*p_arr_path)[i].sz_path);
		else
			i_total_count++;
	}

	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Удалить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		// Удаляе файлы на сервере
	
		file_net.delete_files((*p_arr_path)[i].sz_path, (*p_arr_path)[i].b_dir, p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();

	return 0;
}


// Удалить файлы на сервере

void CRfmThreads::delete_server_files(array_path_ident arr_path, CRfmClientSocket *pConnect)
{
	pparams_thread params = new params_thread;
	params->p_arr_server_path = &arr_path;
	params->p_rfm_threads = this;	
	params->pConnect = pConnect;	

	::ResetEvent(m_hThreadStop);
	ResetEvent(((c_TransportLevel*)pConnect)->get_event_stop());

	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadDeleteFilesServer, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Удаление файлов на сервере: ["+((c_TransportLevel*)pConnect)->get_name_server()+"]");
	m_proc_dlg.DoModal();
	delete params;

	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();

	SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
}


////////////////////////////////////////////////////////////////////////////////////
////////// ПОТОК КОПИРОВАНИЯ ФАЙЛОВ НА СЕРВЕР //////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadCopyFilesOnServer(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	
	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	array_path *p_arr_path = p_params->p_arr_path;
	if(!p_arr_path) return 1;
	CNRFileDataNet file_net((c_TransportLevel*)p_params->pConnect);
	CString sz_err_copy;

	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество удаляемых файлов
	
	UINT i_total_count = file_net.get_count_files(*p_arr_path);
	
	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Удалить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			break;
		}
		
		// Копируем файлы	
	
		file_net.copy_file_to_server(p_params->sz_path_server, (*p_arr_path)[i], p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();

	return 0;
}



// Копировать файл на сервер
// arr_copy_path - массив копирования файлов на сервер

void CRfmThreads::copy_files_to_server(CString sz_path_server, array_path arr_copy_path, CRfmClientSocket *pConnect)
{
	pparams_thread params = new params_thread;
	params->sz_path_server = sz_path_server;
	params->p_arr_path = &arr_copy_path;
	params->p_rfm_threads = this;	
	params->pConnect = pConnect;	

	ResetEvent(((c_TransportLevel*)pConnect)->get_event_stop());


	::ResetEvent(m_hThreadStop);

	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadCopyFilesOnServer, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Копирование файлов на сервер: ["+((c_TransportLevel*)pConnect)->get_name_server()+"]");
	m_proc_dlg.DoModal();
	delete params;
	
	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();

	SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
}


////////////////////////////////////////////////////////////////////////////////////
////////////////////// ПОТОК КОПИРОВАНИЯ ФАЙЛОВ С СЕРВЕРА //////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadCopyFilesFromServer(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	
	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	CNRFileDataNet file_net((c_TransportLevel*)p_params->pConnect);
	array_path_ident *p_arr_local_path = p_params->p_arr_local_path;
	if(!p_arr_local_path) return 1;
	array_path_ident *p_arr_server_path = p_params->p_arr_server_path;
	if(!p_arr_server_path) return 1;
	CString sz_err;

	
	
	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество копируемых файлов
	
	UINT i_total_count = 0;

	for(int i = 0; i < (int)p_arr_server_path->size(); i++)
	{
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		if((*p_arr_server_path)[i].b_dir)
			i_total_count += file_net.get_count_file_dir_srv((*p_arr_server_path)[i].sz_path);
		else
			i_total_count++;
	}

	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Удалить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_server_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		// Копируем файлы	
	
		file_net.copy_file_from_server((*p_arr_server_path)[i].sz_path, (*p_arr_local_path)[i].sz_path,
			(*p_arr_server_path)[i].b_dir, p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();

	return 0;
}


// Копировать файлы с сервера

void CRfmThreads::copy_files_from_server(array_path_ident arr_path_local, array_path_ident arr_path_srv, CRfmClientSocket *pConnect)
{
	pparams_thread params = new params_thread;
	params->p_arr_local_path = &arr_path_local;
	params->p_arr_server_path = &arr_path_srv;
	params->p_rfm_threads = this;	
	params->pConnect = pConnect;	

	::ResetEvent(m_hThreadStop);
	ResetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
	
	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadCopyFilesFromServer, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Копирование файлов с сервера: ["+((c_TransportLevel*)pConnect)->get_name_server()+"]");
	m_proc_dlg.DoModal();
	delete params;

	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();

	SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
}


////////////////////////////////////////////////////////////////////////////////////
////////////////////// ПОТОК ПЕРЕМЕЩЕНИЯ ФАЙЛОВ НА СЕРВЕР //////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadMoveFilesOnServer(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	
	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	array_path *p_arr_path = p_params->p_arr_path;
	if(!p_arr_path) return 1;
	CNRFileDataNet file_net((c_TransportLevel*)p_params->pConnect);
	CString sz_err_move;

	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество удаляемых файлов
	
	UINT i_total_count = file_net.get_count_files(*p_arr_path);
	
	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Переместить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		// Перемещаем файлы	
	
		file_net.move_file_to_server(p_params->sz_path_server, (*p_arr_path)[i], p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();

	return 0;
}



// Копировать файл на сервер
// arr_move_path - массив перемещения файлов на сервер

void CRfmThreads::move_files_to_server(CString sz_path_server, array_path arr_move_path, CRfmClientSocket *pConnect)
{
	pparams_thread params = new params_thread;
	params->sz_path_server = sz_path_server;
	params->p_arr_path = &arr_move_path;
	params->p_rfm_threads = this;	
	params->pConnect = pConnect;	

	::ResetEvent(m_hThreadStop);
	ResetEvent(((c_TransportLevel*)pConnect)->get_event_stop());

	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadMoveFilesOnServer, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Перемещение файлов на сервер: ["+((c_TransportLevel*)pConnect)->get_name_server()+"]");
	m_proc_dlg.DoModal();
	delete params;

	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();

	SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
}

////////////////////////////////////////////////////////////////////////////////////
////////////////////// ПОТОК ПЕРЕМЕЩЕНИЯ ФАЙЛОВ С СЕРВЕРА //////////////////////////
////////////////////////////////////////////////////////////////////////////////////

DWORD WINAPI ThreadMoveFilesFromServer(LPVOID lpData)
{
  CDisableWOW64FSRedirection fsguard; // for x64


	pparams_thread p_params = static_cast<pparams_thread>(lpData);
	if(!p_params) return 1;
	CRfmThreads *p_rfm_threads = p_params->p_rfm_threads;
	if(!p_rfm_threads) return 1;
	CNRFileDataNet file_net((c_TransportLevel*)p_params->pConnect);
	array_path_ident *p_arr_local_path = p_params->p_arr_local_path;
	if(!p_arr_local_path) return 1;
	array_path_ident *p_arr_server_path = p_params->p_arr_server_path;
	if(!p_arr_server_path) return 1;
	CString sz_err;

	// Ожидаем сигнала начала работы
	
	::WaitForSingleObject(p_rfm_threads->get_handle_start(), INFINITE);
	
	// Определить общее количество копируемых файлов
	
	UINT i_total_count = 0;

	for(int i = 0; i < (int)p_arr_server_path->size(); i++)
	{
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		if((*p_arr_server_path)[i].b_dir)
			i_total_count += file_net.get_count_file_dir_srv((*p_arr_server_path)[i].sz_path);
		else
			i_total_count++;
	}

	// Установить максимальную границу прогреса 

	p_rfm_threads->SetMaxBoundProgress(i_total_count);

	// Удалить все файлы по указанным путям

	for(int i = 0; i < (int)p_arr_server_path->size(); i++)
	{
		// Ожидаем прерывания операции сверху
		
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		// Копируем файлы	
	
		file_net.move_file_from_server((*p_arr_server_path)[i].sz_path, (*p_arr_local_path)[i].sz_path,
			(*p_arr_server_path)[i].b_dir, p_rfm_threads);
	}
	
	// Известить окно статуса об останове
	
	::SetEvent(p_rfm_threads->get_handle_was_stoped());
	
	// Закрыть окно статуса
	
	p_rfm_threads->CloseStatusWindow();

	return 0;
}


// Переместить файлы с сервера

void CRfmThreads::move_files_from_server(array_path_ident arr_path_local, array_path_ident arr_path_srv, CRfmClientSocket *pConnect)
{
	pparams_thread params = new params_thread;
	params->p_arr_local_path = &arr_path_local;
	params->p_arr_server_path = &arr_path_srv;
	params->p_rfm_threads = this;	
	params->pConnect = pConnect;	

	::ResetEvent(m_hThreadStop);
	ResetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
	
	// Создать поток удаления файлов
	
	m_h_thread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ThreadMoveFilesFromServer, params, 
		NULL, &m_dw_id_thread); 
	if(!m_h_thread)
	{
		delete params;
		SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
		return;
	}

	// Открыть окно для статуса процесса удаления

	m_proc_dlg.SetNameWnd("Перемещение файлов с сервера: ["+((c_TransportLevel*)pConnect)->get_name_server()+"]");
	m_proc_dlg.DoModal();
	delete params;

	// Восстановить все флажки событий

	ResetEvent(m_hThreadStart);
	ResetEvent(m_hThreadStop);
	ResetEvent(m_hThreadWasStoped);

	// показать ошибки если они имеются

	if(m_report_errors_dlg.get_count_errors())
		m_report_errors_dlg.DoModal();

	SetEvent(((c_TransportLevel*)pConnect)->get_event_stop());
}