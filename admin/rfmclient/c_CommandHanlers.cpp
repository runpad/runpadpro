#include "StdAfx.h"
#include "c_CommandHanlers.h"
#include "c_TransportLevel.h"
#include "nrfiledata.h"

// Максимальное время ожидания ответа с сервера

#define MAX_TIME_WAIT INFINITE
 

//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Получить информацию о дисках на серверной стороне"
//////////////////////////////////////////////////////////////////////////////////////////

c_get_list_drive_cmd::c_get_list_drive_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
	m_i_size_recv_data = 0;
}

c_get_list_drive_cmd::~c_get_list_drive_cmd(void)
{
}


// Дать команду серверу, определить диски
// list_drives - полученный список дисков с сервера

bool c_get_list_drive_cmd::get_all_drives(CListDrives& list_drives, CString& sz_err_descr)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_i_size_recv_data = 0; 

	if(!m_pTransport->is_connected())
	{
		sz_err_descr = "Нет связи с сервером!";
		return false;
	}
	
	
	// Передать указатель на массив с данными

	m_pDrivesList = &list_drives;
	
	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_DRIVES, 0, 0L, 0, NULL, &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err_descr = "Превышено время ожидания ответа с сервера!";
		m_i_size_recv_data = 0; 
		return false;
	}

	sz_err_descr = m_sz_error_descr;
	m_i_size_recv_data = 0; 
	return m_pDrivesList->size() != 0;
}


// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок


void c_get_list_drive_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_i_size_recv_data = 0; 
	::SetEvent(m_h_end_operation);
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_get_list_drive_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
	{
		m_sz_error_descr = "Невозможно получить данные по дискам с сервера, сервер не отвечает!";
		::SetEvent(m_h_end_operation);
		return;
	}
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		PDATA_DISC p_data_drive = new DATA_DISC;
		unsigned short i_tmp_size = 0;

		// Расшифровать полученные данные

		p_data_drive->szLetterDisc = *pdata_pack++;
		memcpy(&p_data_drive->iTypeDisc, pdata_pack, sizeof(unsigned int)); 
		pdata_pack += sizeof(unsigned int);
		memcpy(&i_tmp_size, pdata_pack, sizeof(unsigned short)); 
		pdata_pack += sizeof(unsigned short);
		p_data_drive->szLabel.Append(pdata_pack, i_tmp_size);
		pdata_pack += i_tmp_size;
		memcpy(&i_tmp_size, pdata_pack, sizeof(unsigned short)); 
		pdata_pack += sizeof(unsigned short);
		p_data_drive->szFileSys.Append(pdata_pack, i_tmp_size);
		pdata_pack += i_tmp_size;
		memcpy(&p_data_drive->d_free_space, pdata_pack, sizeof(double)); 
		pdata_pack += sizeof(double);	

		// Добавить в список новый диск
		m_i_size_recv_data += pPacket->i_size_data;
		m_pDrivesList->push_back(p_data_drive);

		// Узнать все ли нам передал сервер и если нет то передать 
		// запрос на следующий диск
		
		if(m_i_size_recv_data < pPacket->ui_total_size)
		{
			char *p_packet = NULL;
			int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_DRIVES, 0, 
				m_i_size_recv_data, 0, NULL, &p_packet);	
			((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
			if(p_packet) delete [] p_packet;
		}
		else
			// Можно забирать данные по полученным дискам
			::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_i_size_recv_data = 0; 			
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_LIST_DRIVES)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_i_size_recv_data = 0; 			
		::SetEvent(m_h_end_operation);
	}
	else
		return;

}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Получить список файлов по указанному пути"
//////////////////////////////////////////////////////////////////////////////////////////

c_get_list_files_cmd::c_get_list_files_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
	m_i_size_recv_data = 0;
}

c_get_list_files_cmd::~c_get_list_files_cmd(void)
{
}

// Дать команду серверу, определить файлы по определенному пути
// list_drives - полученный список файлов
// sz_path - корневой путь

bool c_get_list_files_cmd::get_list_files(CListFiles& list_files, CString sz_path, CString& sz_err_descr)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_i_size_recv_data = 0; 
	m_flag_finish = false;

	if(!m_pTransport->is_connected())
	{
		sz_err_descr = "Нет связи с сервером!";
		return false;
	}
	
	// Передать указатель на массив с данными

	m_pFilesList = &list_files;
	
	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, 0, 0L, sz_path.GetLength()+1, 
		sz_path.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err_descr = "Превышено время ожидания ответа с сервера!";
		m_i_size_recv_data = 0; 
		return false;
	}
	
	sz_err_descr = m_sz_error_descr;
	m_i_size_recv_data = 0; 
	
	return m_flag_finish;
}



// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_get_list_files_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_i_size_recv_data = 0; 
	m_flag_finish = false;
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_get_list_files_cmd::ProcessCommand(char *pData, int nSize)
{
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	
	// Ожидать прерывание операции юзером
		
	if(m_p_rfm_thread)
	{
		if(WaitForSingleObject(m_p_rfm_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			// Отослать на сервер пакет разрыва операции 
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Очичстить все накопленое ранее
			
			for(size_t i = 0; i < m_pFilesList->size(); i++)
			{
				if((*m_pFilesList)[i])
					delete (*m_pFilesList)[i];
			}
			m_pFilesList->clear();

			// Установить событие выхода
		
			m_flag_finish = false; 
			::SetEvent(m_h_end_operation);	
			return;
		}
	}

	if(!pData || !nSize)
	{
		m_sz_error_descr = "Невозможно получить данные по файлам с сервера!";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		PDATA_FILE p_data_file = new DATA_FILE;
		unsigned short i_tmp_size = 0;

		// Расшифровать полученные данные

		memcpy(&i_tmp_size, pdata_pack, sizeof(unsigned short)); 
		pdata_pack += sizeof(unsigned short);
		p_data_file->szNameFile.Append(pdata_pack, i_tmp_size);
		pdata_pack += i_tmp_size;
		p_data_file->bDirectory = (BOOL)*pdata_pack++; 
		p_data_file->bDots = (BOOL)*pdata_pack++; 
		memcpy(&p_data_file->iSizeFile, pdata_pack, sizeof(ULONGLONG));
		pdata_pack += sizeof(ULONGLONG);
		FILETIME file_time;
		memcpy(&file_time, pdata_pack, sizeof(FILETIME));
		p_data_file->timeCreate = (CTime)file_time;
		
		// Добавить в список новый диск
		m_i_size_recv_data += pPacket->i_size_data;
		m_pFilesList->push_back(p_data_file);

		// Узнать все ли нам передал сервер и если нет то передать 
		// запрос на следующий диск
		
		if(m_i_size_recv_data < pPacket->ui_total_size)
		{
			char *p_packet = NULL;
			int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, 0, 
				m_i_size_recv_data, 0, NULL, &p_packet);	
			((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
			if(p_packet) delete [] p_packet;
		}
		else
		{
			m_flag_finish = true; 
			// Можно забирать данные по полученным файлам
			::SetEvent(m_h_end_operation);
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_i_size_recv_data = 0; 
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_LIST_FILES)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_i_size_recv_data = 0; 
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Удалить файл на сервере"
//////////////////////////////////////////////////////////////////////////////////////////

c_delete_file_cmd::c_delete_file_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_delete_file_cmd::~c_delete_file_cmd(void)
{
}

// Команда удаления файла
// sz_path - путь к удаляемому файлу
// sz_err_descr - описание последней ошибки

bool c_delete_file_cmd::cmd_delete_file(CString sz_path, CString& sz_err_descr)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;

	if(!m_pTransport->is_connected())
	{
		sz_err_descr = "Нет связи с сервером!";
		return false;
	}

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_DELETE_FILE, 0, 0L, sz_path.GetLength()+1, 
		sz_path.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err_descr = "Превышено время ожидания ответа с сервера!";
		return false;
	}
	
	sz_err_descr = m_sz_error_descr;
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_delete_file_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_delete_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
	{
		m_sz_error_descr = DEFAULT_ERROR;
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		m_sz_error_descr.Empty();
		m_flag_finish = true; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_DELETE_FILE)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Создать каталог на сервере"
//////////////////////////////////////////////////////////////////////////////////////////

c_create_dir_cmd::c_create_dir_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_create_dir_cmd::~c_create_dir_cmd(void)
{
}


// Команда удаления файла
// sz_path - путь к удаляемому файлу
// sz_err_descr - описание последней ошибки

bool c_create_dir_cmd::cmd_create_dir(CString str_path, CString& sz_err_descr)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;

	if(!m_pTransport->is_connected())
	{
		sz_err_descr = "Нет связи с сервером!";
		return false;
	}

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_CREATE_DIR, 0, 0L, str_path.GetLength()+1, 
		str_path.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err_descr = "Превышено время ожидания ответа с сервера!";
		return false;
	}
	
	sz_err_descr = m_sz_error_descr;
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_create_dir_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_create_dir_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
	{
		m_sz_error_descr = DEFAULT_ERROR;
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		m_sz_error_descr.Empty();
		m_flag_finish = true; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_CREATE_DIR)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}


//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Копировать файл на сервер"
//////////////////////////////////////////////////////////////////////////////////////////

c_copy_file_in::c_copy_file_in(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
	m_h_file_copy = NULL;
}

c_copy_file_in::~c_copy_file_in(void)
{
}


// Копировать файл 
// sz_path_server - путь файла на сервере
// sz_path_local - путь файла локальный
// sz_err - описание ошибки если она возникла

bool c_copy_file_in::cmd_copy_file(CString sz_path_server, CString sz_path_local, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE && m_h_file_copy != NULL){ 
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = INVALID_HANDLE_VALUE;
	}

	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	// Открыть файл для копирования

	m_h_file_copy = ::CreateFile(sz_path_local, GENERIC_READ, 0, NULL, 
					OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(m_h_file_copy == INVALID_HANDLE_VALUE)
	{
		sz_err = "Невозможно открыть файл на копирование!";
		return false;
	}
	
	// Установить показания прогресса
	
	DWORD dw_hight = 0;
	ULONGLONG li_max_bound = ::GetFileSize(m_h_file_copy, &dw_hight);
	li_max_bound |= (dw_hight << sizeof(unsigned int));
	m_p_rfm_thread->SetMaxBoundProgressCopy(li_max_bound);
	
	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, 0, 0L, sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err = "Превышено время ожидания ответа с сервера!";
		if(m_h_file_copy != INVALID_HANDLE_VALUE) ::CloseHandle(m_h_file_copy);
		return false;
	}
	
	sz_err = m_sz_error_descr;
	
	return m_flag_finish;
}


// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_copy_file_in::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE){
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
	}
	::SetEvent(m_h_end_operation);
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_copy_file_in::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		DWORD read_data=0;
		char ch_tmp_buf[MAX_BUFER_COPY_FILES];

		// Узнать размер файла

		DWORD dwHight = 0;	
		ULONGLONG iSizeFile = (ULONGLONG)::GetFileSize(m_h_file_copy, &dwHight);
		iSizeFile |= ((ULONGLONG)dwHight << 32); 

		// Если файл с нулевой длиной

		if(!iSizeFile)
		{
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, 0, 
			1, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
		}

		// Узнать не пора ли закрыватся

		if(pPacket->ui_total_size >= iSizeFile)
		{
			
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_flag_finish = true; 
			::SetEvent(m_h_end_operation);
			return;
		}

		// Ожидать прерывание операции юзером
		
		if(WaitForSingleObject(m_p_rfm_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			// Отослать на сервер пакет разрыва операции 
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Установить событие выхода
		
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_flag_finish = true; 
			::SetEvent(m_h_end_operation);	
			return;
		}


		if(!::ReadFile(m_h_file_copy, ch_tmp_buf, MAX_BUFER_COPY_FILES, &read_data, NULL))
		{
			DWORD dw_err = ::GetLastError();
			
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_sz_error_descr = "Ошибка чтения файла!";
			m_flag_finish = false; 
			::SetEvent(m_h_end_operation);
			return;
		}
	
		// Передать данные серверу

		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, 0, 
		iSizeFile, (unsigned short)read_data, ch_tmp_buf, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;			
	
		// Обновить показания прогреса
		
		m_p_rfm_thread->UpdateProgressCopy(i_size);
	}
	else
	if(pPacket->c_code_err == ERR_COPY_FILE)
	{
		CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Копировать файл с сервера"
//////////////////////////////////////////////////////////////////////////////////////////

c_copy_file_out::c_copy_file_out(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
	m_h_file_copy = NULL;
	m_liSize = 0;
	m_sz_path_file = "";
}

c_copy_file_out::~c_copy_file_out(void)
{
}




// Копировать файл 
// sz_path_server - путь файла на сервере
// sz_path_local - путь файла локальный
// sz_err - описание ошибки если она возникла

bool c_copy_file_out::cmd_copy_file(CString sz_path_server, CString sz_path_local, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE){
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
	}

	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	SetFileAttributes(sz_path_local, FILE_ATTRIBUTE_NORMAL);
	
	// Открыть файл для копирования

	m_h_file_copy = ::CreateFile(sz_path_local, GENERIC_WRITE, 0, NULL, 
					CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if(m_h_file_copy == INVALID_HANDLE_VALUE)
	{
		sz_err = "Невозможно открыть файл на копирование!";
		return false;
	}
	
	m_sz_path_file = sz_path_local;

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, 0, 
		(sz_path_server.GetLength()+1 + ID_COPY_OUT), // Специальный идентификатор начала передачи файла 
		sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err = "Превышено время ожидания ответа с сервера!";
		if(m_h_file_copy != INVALID_HANDLE_VALUE)::CloseHandle(m_h_file_copy);
		return false;
	}
	
	sz_err = m_sz_error_descr;
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_copy_file_out::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE){
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
	}
	::DeleteFile(m_sz_path_file);
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_copy_file_out::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	char *p_packet = NULL;
	int size_pack = 0;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		if(m_liSize != pPacket->ui_total_size)
		{
			m_liSize = pPacket->ui_total_size;
			
			// подтверждение на то что файл на сервере уже открыт
			// запросить первую порцию данных с сервера
				
			size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, 0, 
				0, 0, NULL, &p_packet);	
			((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
			if(p_packet) delete [] p_packet;

			// Установить границы прогреса

			m_p_rfm_thread->SetMaxBoundProgressCopy(m_liSize);

			return; 
		}
		
		// Дописываем текущий файл
			
		DWORD dw_was_write = 0;
		if(!::WriteFile(m_h_file_copy, pdata_pack, pPacket->i_size_data, &dw_was_write, NULL))
		{
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			::CloseHandle(m_h_file_copy);
			::DeleteFile(m_sz_path_file);
			m_h_file_copy = NULL;
			m_sz_path_file.Empty();
			m_liSize = 0;
			m_flag_finish = false; 
			::SetEvent(m_h_end_operation);
			return;
		}
		
		// Обновить прогрес

		m_p_rfm_thread->UpdateProgressCopy(pPacket->i_size_data);

		// Ожидать прерывание операции юзером
		
		if(WaitForSingleObject(m_p_rfm_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			// Отослать на сервер пакет разрыва операции 
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Установить событие выхода
		
			::CloseHandle(m_h_file_copy);
			::DeleteFile(m_sz_path_file);
			m_h_file_copy = NULL;
			m_flag_finish = true; 
			m_liSize = 0;
			::SetEvent(m_h_end_operation);	
			return;
		}
		
		
		// Передать текущую длину файла клиенту
			
		DWORD dwHight = 0;	
		ULONGLONG iCurSize = (ULONGLONG)::GetFileSize(m_h_file_copy, &dwHight);
		iCurSize |= ((ULONGLONG)dwHight << 32); 
					
		// Узнать не пора ли нам закрыватся

		if(iCurSize == m_liSize)
		{
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_sz_path_file.Empty();
			m_liSize = 0;
			m_flag_finish = true; 
			::SetEvent(m_h_end_operation);

		}
		else
		{
			// Сообщить серверу что файл дописан удачно
		
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, 0, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
		}
	}
	else
	if(pPacket->c_code_err == ERR_COPY_FILE)
	{
		::CloseHandle(m_h_file_copy);
		::DeleteFile(m_sz_path_file);
		m_h_file_copy = NULL;
		m_sz_path_file.Empty();
		m_liSize = 0;
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		::CloseHandle(m_h_file_copy);
		::DeleteFile(m_sz_path_file);
		m_h_file_copy = NULL;
		m_sz_path_file.Empty();
		m_liSize = 0;
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переместить файл на сервер"
//////////////////////////////////////////////////////////////////////////////////////////

c_move_file_in::c_move_file_in(CRfmClientSocket *pTransport) :
	c_copy_file_in(pTransport)
{
}

c_move_file_in::~c_move_file_in(void)
{
}

// Переместить файл 
// sz_path_server - путь файла на сервере
// sz_path_local - путь файла локальный
// sz_err - описание ошибки если она возникла

bool c_move_file_in::cmd_move_file(CString sz_path_server, CString sz_path_local, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE)
	{
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = INVALID_HANDLE_VALUE;
	}
	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	SetFileAttributes(sz_path_local, FILE_ATTRIBUTE_NORMAL);

	// Открыть файл для перемещения

	m_h_file_copy = ::CreateFile(sz_path_local, GENERIC_READ, 0, NULL, 
					OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if(m_h_file_copy == INVALID_HANDLE_VALUE)
	{
		sz_err = "Невозможно открыть файл на копирование!";
		return false;
	}
	
	// Установить показания прогресса
	
	DWORD dw_hight = 0;
	ULONGLONG li_max_bound = ::GetFileSize(m_h_file_copy, &dw_hight);
	li_max_bound |= ((ULONGLONG)dw_hight << (sizeof(unsigned int)*8));
	m_p_rfm_thread->SetMaxBoundProgressCopy(li_max_bound);	

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, 0, 0L, sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных
	

	::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
		
	sz_err = m_sz_error_descr;
	
	BOOL bts; 
	if(m_flag_finish)
		bts = ::DeleteFile(sz_path_local);
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_move_file_in::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE){
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = INVALID_HANDLE_VALUE;
	}
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_move_file_in::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	

	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		DWORD read_data=0;
		char ch_tmp_buf[MAX_BUFER_COPY_FILES];

		if(WaitForSingleObject(m_p_rfm_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			// Отослать на сервер пакет разрыва операции 
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Установить событие выхода
		
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_flag_finish = false; 
			m_h_file_copy = INVALID_HANDLE_VALUE;
			::SetEvent(m_h_end_operation);	
			return;
		}


		// Узнать размер файла

		DWORD dwHight = 0;	
		ULONGLONG iSizeFile = (ULONGLONG)::GetFileSize(m_h_file_copy, &dwHight);
		iSizeFile |= ((ULONGLONG)dwHight << 32); 

		// Узнать не пора ли закрыватся

		if(pPacket->ui_total_size >= iSizeFile)
		{
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_flag_finish = true; 
			m_h_file_copy = INVALID_HANDLE_VALUE;
			::SetEvent(m_h_end_operation);
			return;
		}


		if(!::ReadFile(m_h_file_copy, ch_tmp_buf, MAX_BUFER_COPY_FILES, &read_data, NULL))
		{
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_sz_error_descr = "Ошибка чтения файла!";
			m_flag_finish = false; 
			::SetEvent(m_h_end_operation);
			return;
		}
	
		// Передать данные серверу

		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, 0, 
		iSizeFile, (unsigned short)read_data, ch_tmp_buf, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;		

		m_p_rfm_thread->UpdateProgressCopy(read_data);
	
	}
	else
	if(pPacket->c_code_err == ERR_COPY_FILE)
	{
		CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		m_h_file_copy = INVALID_HANDLE_VALUE;
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		CloseHandle(m_h_file_copy);
		m_h_file_copy = NULL;
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		m_h_file_copy = INVALID_HANDLE_VALUE;
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}


//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переместить файл с сервера"
//////////////////////////////////////////////////////////////////////////////////////////

c_move_file_out::c_move_file_out(CRfmClientSocket *pTransport) :
	c_copy_file_out(pTransport)
{
}

c_move_file_out::~c_move_file_out(void)
{
}

// Переместить файл 
// sz_path_server - путь файла на сервере
// sz_path_local - путь файла локальный
// sz_err - описание ошибки если она возникла

bool c_move_file_out::cmd_move_file(CString sz_path_server, CString sz_path_local, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE)
	{
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = INVALID_HANDLE_VALUE;
	}

	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	SetFileAttributes(sz_path_local, FILE_ATTRIBUTE_NORMAL);

	// Открыть файл для копирования

	m_h_file_copy = ::CreateFile(sz_path_local, GENERIC_WRITE, 0, NULL, 
					CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if(m_h_file_copy == INVALID_HANDLE_VALUE)
	{
		sz_err = "Невозможно открыть файл на копирование!";
		return false;
	}
	
	m_sz_path_file = sz_path_local;

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, 0, 
		(sz_path_server.GetLength()+1 + ID_MOVE_OUT), // Специальный идентификатор начала передачи файла 
		sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err = "Превышено время ожидания ответа с сервера!";
		if(m_h_file_copy != INVALID_HANDLE_VALUE){
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = INVALID_HANDLE_VALUE;
		}
		return false;
	}
	
	sz_err = m_sz_error_descr;
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_move_file_out::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	if(m_h_file_copy != INVALID_HANDLE_VALUE)
	{
		::CloseHandle(m_h_file_copy);
		m_h_file_copy = INVALID_HANDLE_VALUE;
	}
	::SetEvent(m_h_end_operation);
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_move_file_out::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	char *p_packet = NULL;
	int size_pack = 0;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		if(m_liSize != pPacket->ui_total_size)
		{
			m_liSize = pPacket->ui_total_size;
			
			// подтверждение на то что файл на сервере уже открыт
			// запросить первую порцию данных с сервера
				
			size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, 0, 
				0, 0, NULL, &p_packet);	
			((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
			if(p_packet) delete [] p_packet;

			// Установить границы прогреса

			m_p_rfm_thread->SetMaxBoundProgressCopy(m_liSize);	

			return; 
		}
		
		// Дописываем текущий файл
			
		DWORD dw_was_write = 0;
		if(!::WriteFile(m_h_file_copy, pdata_pack, pPacket->i_size_data, &dw_was_write, NULL))
		{
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			::CloseHandle(m_h_file_copy);
			::DeleteFile(m_sz_path_file);
			m_h_file_copy = NULL;
			m_sz_path_file.Empty();
			m_liSize = 0;
			m_flag_finish = false; 
			::SetEvent(m_h_end_operation);
			return;
		}
		
		// Ожидать прерывание операции юзером
		
		if(WaitForSingleObject(m_p_rfm_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
		{
			// Отослать на сервер пакет разрыва операции 
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, ERR_ABORT_PACK, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Установить событие выхода
		
			::CloseHandle(m_h_file_copy);
			::DeleteFile(m_sz_path_file);
			m_h_file_copy = NULL;
			m_flag_finish = true; 
			::SetEvent(m_h_end_operation);	
			return;
		}


		// Передать текущую длину файла серверу
			
		DWORD dwHight = 0;	
		ULONGLONG iCurSize = (ULONGLONG)::GetFileSize(m_h_file_copy, &dwHight);
		iCurSize |= ((ULONGLONG)dwHight << 32); 
					
		// Узнать не пора ли нам закрыватся

		if(iCurSize == m_liSize)
		{
			::CloseHandle(m_h_file_copy);
			m_h_file_copy = NULL;
			m_sz_path_file.Empty();
			m_liSize = 0;
			m_flag_finish = true; 
			::SetEvent(m_h_end_operation);
		}
		else
		{
			// Сообщить серверу что файл дописан удачно
		
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, 0, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
		}
	
		m_p_rfm_thread->UpdateProgressCopy(dw_was_write);
	}
	else
	if(pPacket->c_code_err == ERR_COPY_FILE)
	{
		::CloseHandle(m_h_file_copy);
		::DeleteFile(m_sz_path_file);
		m_h_file_copy = NULL;
		m_sz_path_file.Empty();
		m_liSize = 0;
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		::CloseHandle(m_h_file_copy);
		::DeleteFile(m_sz_path_file);
		m_h_file_copy = NULL;
		m_sz_path_file.Empty();
		m_liSize = 0;
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		
	}
	else
		return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переименовать файл"
//////////////////////////////////////////////////////////////////////////////////////////

c_rename_file_cmd::c_rename_file_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_rename_file_cmd::~c_rename_file_cmd(void)
{
}

// Переименовать файл 
// sz_path_old - предыдущий путь
// sz_path_new - новый путь
// sz_err - описание ошибки если она возникла

bool c_rename_file_cmd::cmd_move_file(CString sz_path_old, CString sz_path_new, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;

	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	CString sz_data_path = sz_path_old + '\04' + sz_path_new;	

	// Передать команду серверу 

	char *p_packet = NULL;
	
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_RENAME_FILE, 0, 0L, sz_data_path.GetLength()+1, 
		sz_data_path.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err = "Превышено время ожидания ответа с сервера!";
		return false;
	}
	
	sz_err = m_sz_error_descr;
	
	return m_flag_finish;
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_rename_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
	{
		m_sz_error_descr = DEFAULT_ERROR;
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		m_sz_error_descr.Empty();
		m_flag_finish = true; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_RENAME_FILE)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_rename_file_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	::SetEvent(m_h_end_operation);
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Запустить файл"
//////////////////////////////////////////////////////////////////////////////////////////

c_exec_file_cmd::c_exec_file_cmd(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_exec_file_cmd::~c_exec_file_cmd(void)
{
}

// Запустить указанный файл
// sz_path_server - путь к файлу

bool c_exec_file_cmd::cmd_exec_file(CString sz_path_server, CString& sz_err)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;

	if(!m_pTransport->is_connected())
	{
		sz_err = "Нет связи с сервером!";
		return false;
	}

	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_EXEC_FILE, 0, 0L, sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		sz_err = "Превышено время ожидания ответа с сервера!";
		return false;
	}
	
	sz_err = m_sz_error_descr;
	
	return m_flag_finish;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок



void c_exec_file_cmd::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_exec_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
	{
		m_sz_error_descr = DEFAULT_ERROR;
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	
	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA);

	if(pPacket->c_code_err == 0)
	{
		m_sz_error_descr.Empty();
		m_flag_finish = true; 
		::SetEvent(m_h_end_operation);
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT)
	{
		m_sz_error_descr = "Превышено время ожидания данных с сервера";
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
		return;
	}
	else
	if(pPacket->c_code_err == ERR_EXEC_FILE)
	{
		m_sz_error_descr.Append(pdata_pack, pPacket->i_size_data);
		m_flag_finish = false; 
		::SetEvent(m_h_end_operation);
	}
	else
		return;
}

//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Определить количество файлов в каталоге"
//////////////////////////////////////////////////////////////////////////////////////////

c_count_files_dir::c_count_files_dir(CRfmClientSocket *pTransport) :
	c_LogicCommand(pTransport)
{
	m_i_count_files = 0;
}

c_count_files_dir::~c_count_files_dir(void)
{
}



// Определить количесто файлов в указанном каталоге 
// sz_path_server - путь к каталогу

UINT c_count_files_dir::cmd_count_files_dir(CString sz_path_server)
{
	::ResetEvent(m_h_end_operation);
	m_sz_error_descr.Empty();
	m_flag_finish = false;
	m_i_count_files = 0;

	if(!m_pTransport->is_connected())
		return false;
	
	// Передать команду серверу 

	char *p_packet = NULL;
	int size_pack = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COUNT_FILES_DIR, 0, 0L, 
		sz_path_server.GetLength()+1, 
		sz_path_server.GetBuffer(), &p_packet);	
	((c_TransportLevel*)m_pTransport)->SendData(p_packet, size_pack);
	if(p_packet) delete [] p_packet;
	// Ожидать события получения данных

	DWORD i_ret = ::WaitForSingleObject(m_h_end_operation, MAX_TIME_WAIT);
	if(i_ret == WAIT_TIMEOUT)
	{
		//sz_err_descr = "Превышено время ожидания ответа с сервера!";
		return false;
	}
	
	return m_i_count_files;
}

// Обрыв текущей операции в случае пропадания связи с сервером
// или потока ошибок

void c_count_files_dir::break_operation()
{
	m_sz_error_descr = "Нет связи с сервером!";
	m_flag_finish = false;
	::SetEvent(m_h_end_operation);
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_count_files_dir::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 
	if(pPacket->c_code_err != 0)
		return;
	
	// Закончить операцию
	
	m_i_count_files = (UINT)pPacket->ui_total_size;
	::SetEvent(m_h_end_operation);	
}



















