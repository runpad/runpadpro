#include "StdAfx.h"
#include "c_CommandHanlers.h"
#include "c_TransportLevel.h"

//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Получить информацию о дисках на серверной стороне"
//////////////////////////////////////////////////////////////////////////////////////////

c_get_list_drive_cmd::c_get_list_drive_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
	m_indx_drive_data = 0;
	m_i_total_size = 0;
}

c_get_list_drive_cmd::~c_get_list_drive_cmd(void)
{
	
	
	// Очистить предыдущие данные
	
	ClearAllData();
}



// Сгенеривать передаваемые данные по одному диску
// pDataDrive  - информация по одному диску
// p_data_ret  - возвращаемые данные после генерации 
// b_only_size - если true возвратися размер и область данных пакета, false - только размер 

int c_get_list_drive_cmd::make_data_drive(PDATA_DISC pDataDrive, char **pp_data_ret, bool b_only_size/*=false*/)
{
	if(!pDataDrive) return 0;
	
	unsigned short i_tmp = 0;
	char *p_data_ret = NULL;

	// Определить общую длину пакета
	
	int total_size = 1 + sizeof(unsigned int) + sizeof(unsigned short) + (int)pDataDrive->szLabel.size() +
						 sizeof(unsigned short) + (int)pDataDrive->szFileSys.size() + sizeof(double);

	if(b_only_size)
	{
		p_data_ret = NULL;
		return total_size;
	}

	*pp_data_ret = p_data_ret = new char[total_size];
	*p_data_ret++ = pDataDrive->szLetterDisc[0];
	memcpy(p_data_ret, &pDataDrive->iTypeDisc, sizeof(unsigned int));
	p_data_ret += sizeof(unsigned int);
	i_tmp = (int)pDataDrive->szLabel.size();
	memcpy(p_data_ret, &i_tmp, sizeof(unsigned short));
	p_data_ret += sizeof(unsigned short);
	memcpy(p_data_ret, pDataDrive->szLabel.c_str(), i_tmp);
	p_data_ret += i_tmp;
	i_tmp = (int)pDataDrive->szFileSys.size();
	memcpy(p_data_ret, &i_tmp, sizeof(unsigned short));
	p_data_ret += sizeof(unsigned short);
	memcpy(p_data_ret, pDataDrive->szFileSys.c_str(), i_tmp);
	p_data_ret += pDataDrive->szFileSys.size();
	memcpy(p_data_ret, &pDataDrive->d_free_space, sizeof(double));	
	return total_size;
}

// Подсчитать общую длину данных по дискам

unsigned int c_get_list_drive_cmd::get_total_size_data()
{
	unsigned int i_total_size = 0; 
	
	for(int i = 0; i < (int)m_drivesList.size(); i++)
		i_total_size += make_data_drive(m_drivesList[i], NULL, true);
	
	return i_total_size;
}

// Очистить массив полученных дисков

void c_get_list_drive_cmd::ClearAllData()
{
	for(int i = 0; i < (int)m_drivesList.size(); i++)
	{
		if(m_drivesList[i])
			delete m_drivesList[i];
	}

	m_drivesList.clear();
}

// Розрыв текущей операции

void c_get_list_drive_cmd::break_operation()
{
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_get_list_drive_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	const char *err_msg;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	
	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == 0)
		{
			// Очистить предыдущие данные
	
			ClearAllData();
			m_indx_drive_data = 0;
			m_i_total_size = 0;
						
			// Дать запрос на определения дисков в системе
			
			CNRFileData::GetDiscList(m_drivesList);
		
			if(!m_drivesList.size())
			{
				err_msg = "В системе не найдены логические диски!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_DRIVES, ERR_LIST_DRIVES, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
			
			// Подсчитать длину и отправить клиенту 
			// информацию по первому диску  

			m_i_total_size = get_total_size_data();
			// Сгенерировать пакет по первому диску
			i_size = make_data_drive(m_drivesList[m_indx_drive_data], &p_data_ret, false);
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_DRIVES, 0, 
				(unsigned __int64)m_i_total_size,
				(unsigned short)i_size, p_data_ret, &p_data_packet);
			if(p_data_ret) delete [] p_data_ret;
			// Передать пакет клиенту
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			m_indx_drive_data++;
		}
		else
		{
			// Передать следующий пакет

			if(m_indx_drive_data >=  (int)m_drivesList.size() ||
			   m_i_total_size <= (int)pPacket->ui_total_size)
			{
				ClearAllData();
				m_indx_drive_data = 0;
				m_i_total_size = 0;
				return;
			}
			
			// Сгенерировать пакет по первому диску
			char *p_data_ret = NULL, *p_data_packet=NULL;
			int i_size = make_data_drive(m_drivesList[m_indx_drive_data], &p_data_ret, false);
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_DRIVES, 0, 
				(unsigned __int64)m_i_total_size,
				(unsigned short)i_size, p_data_ret, &p_data_packet);
			if(p_data_ret) delete [] p_data_ret;
			// Передать пакет клиенту
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			m_indx_drive_data++;
		
			// Данные переданы полностью, можно чистить временные даные 
		
			if(m_indx_drive_data >=  (int)m_drivesList.size())
			{
				ClearAllData();
				m_indx_drive_data = 0;
				m_i_total_size = 0;
				return;
			}
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		ClearAllData();
		m_indx_drive_data = 0;
		m_i_total_size = 0;
		return;
	}
	else
		return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Получить список файлов по указанному пути"
//////////////////////////////////////////////////////////////////////////////////////////

c_get_list_files_cmd::c_get_list_files_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
	m_i_total_size = 0;
	m_indx_file_data = 0;
}

c_get_list_files_cmd::~c_get_list_files_cmd(void)
{
	// Зачистка данных 
	
	ClearAllData();
}

// Очистить массив полученных файлов

void c_get_list_files_cmd::ClearAllData()
{
	for(int i=0; i < (int)m_listFiles.size(); i++)
		if(m_listFiles[i]) delete m_listFiles[i];
	m_listFiles.clear();
}

// Подсчитать общую длину данных по файлам

unsigned int c_get_list_files_cmd::get_total_size_data()
{
	unsigned int i_total_size = 0;
	for(int i=0; i < (int)m_listFiles.size(); i++)
		i_total_size += make_data_files(m_listFiles[i], NULL, true);
	return i_total_size;
}




// Сгенеривать передаваемые данные по одному файлу
// pDataFile   - информация по одному файлу
// p_data_ret  - возвращаемые данные после генерации 
// b_only_size - если true возвратися размер и область данных пакета, false - только размер 


int c_get_list_files_cmd::make_data_files(PDATA_FILE pDataFile, char **pp_data_ret, bool b_only_size/*=false*/)
{
	if(!pDataFile) return 0;
	
	unsigned short i_tmp = 0;
	char *p_data_ret = NULL;

	// Определить общую длину пакета
	
	int total_size = sizeof(unsigned short) + (int)pDataFile->szNameFile.size() + sizeof(char) * 2 +
					 sizeof(unsigned __int64) + sizeof(FILETIME);	

	if(b_only_size)
	{
		p_data_ret = NULL;
		return total_size;
	}

	*pp_data_ret = p_data_ret = new char[total_size];
	i_tmp = (int)pDataFile->szNameFile.size();
	memcpy(p_data_ret, &i_tmp, sizeof(unsigned short));
	p_data_ret += sizeof(unsigned short);
	memcpy(p_data_ret, pDataFile->szNameFile.c_str(), i_tmp);
	p_data_ret += i_tmp;
	*p_data_ret++ = (char)pDataFile->bDirectory;
	*p_data_ret++ = (char)pDataFile->bDots;
	memcpy(p_data_ret, &pDataFile->iSizeFile, sizeof(unsigned __int64));
	p_data_ret += sizeof(unsigned __int64);
	memcpy(p_data_ret, &pDataFile->timeCreate, sizeof(FILETIME));
	p_data_ret += sizeof(FILETIME);
	return total_size;
}

// Розрыв текущей операции

void c_get_list_files_cmd::break_operation()
{
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_get_list_files_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;
	const char *err_msg;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == 0)
		{
			// Зачистить предыдущие данные если они остались
			
			ClearAllData();
			m_indx_file_data = 0;
			m_i_total_size = 0;
						
			// Определить путь вывода файлов
			
			if(!pPacket->i_size_data || !pdata_pack)
			{
				err_msg = "Неверно заданый путь!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, ERR_LIST_FILES, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
			
			// Дать запрос на определения списка файлов
			
			CNRFileData file_data((const char*)pdata_pack);
			if(!file_data.GetDataFiles(m_listFiles))
			{
				err_msg = "Неверно заданый путь!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, ERR_LIST_FILES, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}

			// Подсчитать длину и отправить клиенту 
			// информацию по первому диску  

			m_i_total_size = get_total_size_data();
			// Сгенерировать пакет по первому диску
			i_size = make_data_files(m_listFiles[m_indx_file_data], &p_data_ret, false);
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, 0, 
				(unsigned __int64)m_i_total_size,
				(unsigned short)i_size, p_data_ret, &p_data_packet);
			if(p_data_ret) delete [] p_data_ret;
			// Передать пакет клиенту
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			m_indx_file_data++;
		}
		else
		{
			// Передать следующий пакет

			if(m_indx_file_data >=  (int)m_listFiles.size() ||
			   m_i_total_size < (int)pPacket->ui_total_size)
			{
				ClearAllData();
				m_indx_file_data = 0;
				m_i_total_size = 0;
				return;
			}
			
			// Сгенерировать пакет по первому диску
			char *p_data_ret = NULL, *p_data_packet=NULL;
			int i_size = make_data_files(m_listFiles[m_indx_file_data], &p_data_ret, false);
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_GET_LIST_FILES, 0, 
				(unsigned __int64)m_i_total_size,
				(unsigned short)i_size, p_data_ret, &p_data_packet);
			if(p_data_ret) delete [] p_data_ret;
			// Передать пакет клиенту
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			m_indx_file_data++;
		
			// Данные переданы полностью, можно чистить временные даные 
		
			if(m_indx_file_data >=  (int)m_listFiles.size())
			{
				ClearAllData();
				m_indx_file_data = 0;
				m_i_total_size = 0;
				return;
			}
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		ClearAllData();
		m_indx_file_data = 0;
		m_i_total_size = 0;
		return;
	}
	else
		return;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Удалить файл на сервере"
//////////////////////////////////////////////////////////////////////////////////////////

c_delete_file_cmd::c_delete_file_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_delete_file_cmd::~c_delete_file_cmd(void)
{
}


void c_delete_file_cmd::break_operation()
{
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_delete_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err != 0)
		return;

	// Вытянуть путь удаляемого файла

	if(!pPacket->i_size_data || !pdata_pack)
	{
		err_msg = "Неверно заданый путь!";
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_DELETE_FILE, ERR_DELETE_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Удалить указанный файл

	CNRFileData file_del((const char*)pdata_pack);
	if(!file_del.del_specif_file())
	{
		err_msg = "Невозможно удалить указанный файл!";		
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_DELETE_FILE, ERR_DELETE_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Отправить клиенту подтверждение об удалении
	
	i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_DELETE_FILE, 0, 
	0, 0, NULL, &p_data_packet);
	((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
	if(p_data_packet) delete [] p_data_packet;
	return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Создать каталог на сервере"
//////////////////////////////////////////////////////////////////////////////////////////

c_create_dir_cmd::c_create_dir_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_create_dir_cmd::~c_create_dir_cmd(void)
{
}

void c_create_dir_cmd::break_operation()
{
}

// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_create_dir_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err != 0)
		return;

	// Вытянуть путь к создаваемому каталогу

	if(!pPacket->i_size_data || !pdata_pack)
	{
		err_msg = "Неверно заданый путь!";
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_CREATE_DIR, ERR_CREATE_DIR, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Создать каталог по указанному пути

	if(!CNRFileData::CreateDir((const char*)pdata_pack))
	{
		err_msg = "Невозможно содать каталог!";		
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_CREATE_DIR, ERR_CREATE_DIR, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Отправить клиенту подтверждение о создании каталога
	
	i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_CREATE_DIR, 0, 
	0, 0, NULL, &p_data_packet);
	((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
	if(p_data_packet) delete [] p_data_packet;
	return;
}






//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Копировать файл на сервер"
//////////////////////////////////////////////////////////////////////////////////////////

c_copy_file_in::c_copy_file_in(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
	h_file_copy = NULL;
	m_sz_path_file.clear();
}

c_copy_file_in::~c_copy_file_in(void)
{
}


void c_copy_file_in::break_operation()
{
	if(h_file_copy != INVALID_HANDLE_VALUE) ::CloseHandle(h_file_copy);
	h_file_copy = NULL;
	m_sz_path_file.clear();
}




// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_copy_file_in::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == 0)
		{
			// Вытянуть путь к создаваемому файлу

			if(!pPacket->i_size_data || !pdata_pack)
			{
				err_msg = "Неверно заданый путь!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			SetFileAttributes((const char*)pdata_pack, FILE_ATTRIBUTE_NORMAL);
			
			// Создать указанный файл
		
			h_file_copy = ::CreateFile((const char*)pdata_pack, GENERIC_WRITE, 0, NULL, 
				CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
			if(h_file_copy == INVALID_HANDLE_VALUE)
			{
				err_msg = "Невозможно создать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			// Сохранить путь у файлу на случай его удаления 

			m_sz_path_file = (const char*)pdata_pack;
						
			// Сообщить клиенту что файл создан и сервер ожидает данных файла
		
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, 0, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			
			return;
		}
		else
		{
			// Определить размер файла
			
			DWORD dwHight = 0;	
			ULONGLONG iCurSize = (ULONGLONG)::GetFileSize(h_file_copy, &dwHight);
			iCurSize |= ((ULONGLONG)dwHight << 32); 
			
			if(pPacket->ui_total_size < (iCurSize + pPacket->i_size_data))
			{
				err_msg = "Невозможно скопировать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				::DeleteFile(m_sz_path_file.c_str());
				h_file_copy = NULL;
				m_sz_path_file.clear();
				return;
			}
			
			// Файл нулевой длины

			if(!pPacket->i_size_data && pPacket->ui_total_size==1)
			{
				m_sz_path_file.clear();
				::CloseHandle(h_file_copy);
				return;
			}

			// Дописываем текущий файл
			
			DWORD dw_was_write = 0;
			if(!::WriteFile(h_file_copy, pdata_pack, pPacket->i_size_data, &dw_was_write, NULL))
			{
				err_msg = "Невозможно скопировать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				::DeleteFile(m_sz_path_file.c_str());
				h_file_copy = NULL;
				m_sz_path_file.clear();
				return;
			}
		
			// Передать текущую длину файла клиенту
			
			dwHight = 0;	
			iCurSize = (ULONGLONG)::GetFileSize(h_file_copy, &dwHight);
			iCurSize |= ((ULONGLONG)dwHight << 32); 
						
			// Сообщить клиенту что файл дописан удачно
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_IN, 0, 
			iCurSize, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
		
			// Узнать не пора ли нам закрыватся

			if(pPacket->ui_total_size == iCurSize)
			{
				::CloseHandle(h_file_copy);
				h_file_copy = NULL;
				m_sz_path_file.clear();
			}
		
			// Ожидаем следующих файлов!!!
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		::CloseHandle(h_file_copy);
		::DeleteFile(m_sz_path_file.c_str());
		h_file_copy = NULL;
		m_sz_path_file.clear();
		return;
	}
	else
		return;

}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Копировать файл с сервера"
//////////////////////////////////////////////////////////////////////////////////////////

c_copy_file_out::c_copy_file_out(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
	h_file_copy = NULL;
	m_liSize = 0;
	m_cur_pos_file = 0;
}

c_copy_file_out::~c_copy_file_out(void)
{
}

void c_copy_file_out::break_operation()
{
	if(h_file_copy != INVALID_HANDLE_VALUE) ::CloseHandle(h_file_copy);
	h_file_copy = NULL;
	m_cur_pos_file = 0;
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_copy_file_out::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	char err_msg[MAX_PATH*2];	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == (pPacket->i_size_data + ID_COPY_OUT))
		{
			// Вытянуть путь к создаваемому файлу

			if(!pPacket->i_size_data || !pdata_pack)
			{
				sprintf(err_msg, "Невозможно прочитать файл:");
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			// Открыть указанный файл
		
			h_file_copy = ::CreateFile((const char*)pdata_pack, GENERIC_READ, 0, NULL, 
				OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
			if(h_file_copy == INVALID_HANDLE_VALUE)
			{
				sprintf(err_msg, "Невозможно прочитать файл: %s", pdata_pack);
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg)+1, (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			
			
			// Определить длину файла
			
			DWORD dw_hight;
			m_liSize = ::GetFileSize(h_file_copy, &dw_hight);
			m_liSize |= ((ULONGLONG)dw_hight << 32);

			// Сообщить клиенту что файл открыт и можно начинать перефдачу
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, 0, 
			m_liSize, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			return;
		}
		else
		{
			char ch_tmp_buf[MAX_BUFER_COPY_FILES];	

			// Читаль следующую порцию данных
			
			DWORD read_data=0;
			if(!::ReadFile(h_file_copy, ch_tmp_buf, MAX_BUFER_COPY_FILES, &read_data, NULL))
			{
				sprintf(err_msg, "Невозможно скопировать файл: %s", pdata_pack);
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				m_liSize = 0;
				m_cur_pos_file = 0;
				h_file_copy = NULL;
				return;
			}
			
			m_cur_pos_file += read_data;			
			
			// Передать данные клиенту

			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COPY_OUT, 0, 
			m_liSize, (unsigned short)read_data, ch_tmp_buf, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Проверить не пора ли нам завершать копирование
		
			if(m_liSize == m_cur_pos_file)
			{
				::CloseHandle(h_file_copy);
				h_file_copy = NULL;
				m_liSize = 0;
				m_cur_pos_file = 0;
				// Удалить файл
				return;
			}
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		::CloseHandle(h_file_copy);
		h_file_copy = NULL;
		m_liSize = 0;
		m_cur_pos_file = 0;
		return;
	}
	else
		return;
}



//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переместить файл на сервер"
//////////////////////////////////////////////////////////////////////////////////////////

c_move_file_in::c_move_file_in(CRfmServerClient *pTransport) :
	c_copy_file_in(pTransport)
{
}

c_move_file_in::~c_move_file_in(void)
{
}

void c_move_file_in::break_operation()
{
	if(h_file_copy != INVALID_HANDLE_VALUE) ::CloseHandle(h_file_copy);
	h_file_copy = NULL;
	m_sz_path_file.clear();
}




// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_move_file_in::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == 0)
		{
			// Вытянуть путь к создаваемому файлу

			if(!pPacket->i_size_data || !pdata_pack)
			{
				err_msg = "Неверно заданый путь!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			SetFileAttributes((const char*)pdata_pack, FILE_ATTRIBUTE_NORMAL);
			
			// Создать указанный файл
		
			h_file_copy = ::CreateFile((const char*)pdata_pack, GENERIC_WRITE, 0, NULL, 
				CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
			if(h_file_copy == INVALID_HANDLE_VALUE)
			{
				err_msg = "Невозможно создать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			// Сохранить путь у файлу на случай его удаления 

			m_sz_path_file = (const char*)pdata_pack;
			
			// Сообщить клиенту что файл создан и сервер ожидает данных файла
		
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, 0, 
			0, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			return;
		}
		else
		{
			// Определить размер файла
			
			DWORD dwHight = 0;	
			ULONGLONG iCurSize = (ULONGLONG)::GetFileSize(h_file_copy, &dwHight);
			iCurSize |= ((ULONGLONG)dwHight << 32); 
			
			if(pPacket->ui_total_size < (iCurSize + pPacket->i_size_data))
			{
				err_msg = "Невозможно переместить файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				::DeleteFile(m_sz_path_file.c_str());
				h_file_copy = NULL;
				m_sz_path_file.clear();
				return;
			}
			
			// Дописываем текущий файл
			
			DWORD dw_was_write = 0;
			if(!::WriteFile(h_file_copy, pdata_pack, pPacket->i_size_data, &dw_was_write, NULL))
			{
				err_msg = "Невозможно переместить файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				::DeleteFile(m_sz_path_file.c_str());
				h_file_copy = NULL;
				m_sz_path_file.clear();
				return;
			}
		
			// Передать текущую длину файла клиенту
			
			dwHight = 0;	
			iCurSize = (ULONGLONG)::GetFileSize(h_file_copy, &dwHight);
			iCurSize |= ((ULONGLONG)dwHight << 32); 
						
			// Сообщить клиенту что файл дописан удачно
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_IN, 0, 
			iCurSize, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
		
			// Узнать не пора ли нам закрыватся

			if(pPacket->ui_total_size == iCurSize)
			{
				::CloseHandle(h_file_copy);
				h_file_copy = NULL;
				m_sz_path_file.clear();
				return;
			}
			
			// Ожидаем следующих файлов!!!
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		::CloseHandle(h_file_copy);
		::DeleteFile(m_sz_path_file.c_str());
		h_file_copy = NULL;
		m_sz_path_file.clear();
		return;
	}
	else
		return;
}


//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переместить файл с сервера"
//////////////////////////////////////////////////////////////////////////////////////////

c_move_file_out::c_move_file_out(CRfmServerClient *pTransport) :
	c_copy_file_out(pTransport)
{
}

c_move_file_out::~c_move_file_out(void)
{
}

void c_move_file_out::break_operation()
{
	if(h_file_copy != INVALID_HANDLE_VALUE) ::CloseHandle(h_file_copy);
	h_file_copy = NULL;
	m_cur_pos_file = 0;
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_move_file_out::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 

	if(pPacket->c_code_err == 0)
	{
		if(pPacket->ui_total_size == (pPacket->i_size_data + ID_MOVE_OUT))
		{
			// Вытянуть путь к создаваемому файлу

			if(!pPacket->i_size_data || !pdata_pack)
			{
				err_msg = "Неверно заданый путь!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			SetFileAttributes((const char*)pdata_pack, FILE_ATTRIBUTE_NORMAL);
			
			// Открыть указанный файл
		
			h_file_copy = ::CreateFile((const char*)pdata_pack, GENERIC_READ, 0, NULL, 
				OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
			if(h_file_copy == INVALID_HANDLE_VALUE)
			{
				err_msg = "Невозможно прочитать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg)+1, (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				return;
			}
		
			m_sz_path_move = pdata_pack;
			
			// Определить длину файла
			
			DWORD dw_hight;
			m_liSize = ::GetFileSize(h_file_copy, &dw_hight);
			m_liSize |= ((ULONGLONG)dw_hight << 32);

			// Сообщить клиенту что файл открыт и можно начинать перефдачу
			
			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, 0, 
			m_liSize, 0, NULL, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;
			return;
		}
		else
		{
			char ch_tmp_buf[MAX_BUFER_COPY_FILES];	

			// Читаль следующую порцию данных
			
			DWORD read_data=0;
			if(!::ReadFile(h_file_copy, ch_tmp_buf, MAX_BUFER_COPY_FILES, &read_data, NULL))
			{
				err_msg = "Невозможно скопировать файл!";
				i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, ERR_COPY_FILE, 
				0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
				((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
				if(p_data_packet) delete [] p_data_packet;
				::CloseHandle(h_file_copy);
				m_liSize = 0;
				m_cur_pos_file = 0;
				h_file_copy = NULL;
				m_sz_path_move.clear(); 
				return;
			}
			
			m_cur_pos_file += read_data;			
			
			// Передать данные клиенту

			i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_MOVE_OUT, 0, 
			m_liSize, (unsigned short)read_data, ch_tmp_buf, &p_data_packet);
			((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
			if(p_data_packet) delete [] p_data_packet;			
		
			// Проверить не пора ли нам завершать копирование
		
			if(m_liSize == m_cur_pos_file)
			{
				::CloseHandle(h_file_copy);
				h_file_copy = NULL;
				m_liSize = 0;
				m_cur_pos_file = 0;
				::DeleteFile(m_sz_path_move.c_str());
				m_sz_path_move.clear(); 
				return;
			}
		}
	}
	else
	if(pPacket->c_code_err == ERR_TIMEOUT || pPacket->c_code_err == ERR_ABORT_PACK)
	{
		::CloseHandle(h_file_copy);
		h_file_copy = NULL;
		m_liSize = 0;
		m_cur_pos_file = 0;
		m_sz_path_move.clear(); 
		return;
	}
	else
		return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Переименовать файл"
//////////////////////////////////////////////////////////////////////////////////////////

c_rename_file_cmd::c_rename_file_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_rename_file_cmd::~c_rename_file_cmd(void)
{
}

void c_rename_file_cmd::break_operation()
{
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_rename_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
	
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 
	if(pPacket->c_code_err != 0)
		return;

	// Определить пути файлов переименования

	if(!pPacket->i_size_data || !pdata_pack)
	{
		err_msg = "Ошибка переименования файла!";
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_RENAME_FILE, ERR_RENAME_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	char *pszToken = strtok(pdata_pack, "\04");
	// Старый путь
	const char *old_path = (const char*)pszToken;
	// Новый путь
	const char *new_path = NULL;
	if(pszToken)
		new_path = strtok(NULL, "\04");

	if(!old_path || !new_path)
	{
		err_msg = "Не определены пути переименования!";
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_RENAME_FILE, ERR_RENAME_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Переименовать указанный файл

	if(::rename(old_path, new_path))
	{
		err_msg = "Ошибка переименования файла!";		
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_RENAME_FILE, ERR_RENAME_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Отправить клиенту подтверждение о переименовании файла
	
	i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_RENAME_FILE, 0, 
	0, 0, NULL, &p_data_packet);
	((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
	if(p_data_packet) delete [] p_data_packet;
	return;
}




//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Запустить файл"
//////////////////////////////////////////////////////////////////////////////////////////

c_exec_file_cmd::c_exec_file_cmd(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_exec_file_cmd::~c_exec_file_cmd(void)
{
}

void c_exec_file_cmd::break_operation()
{
}


// Добавить данные для выполнения команды
// pData - поступившие из сокета данные
// nSize - размер данных

void c_exec_file_cmd::ProcessCommand(char *pData, int nSize)
{
	if(!pData || !nSize)
		return;
		
	const char *err_msg;	
	int i_size=0;
	char *p_data_ret = NULL, *p_data_packet=NULL;

	PPACKET_DATA pPacket = (PPACKET_DATA)pData; 
	char *pdata_pack = pData + sizeof(PACKET_DATA); 
	if(pPacket->c_code_err != 0)
		return;

	// Определить путь к файлу запуска

	if(!pPacket->i_size_data || !pdata_pack)
	{
		err_msg = "Невозможно выполнить указанный файл!";
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_EXEC_FILE, ERR_EXEC_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	char sz_dir[MAX_PATH];
	memcpy(sz_dir, pdata_pack, pPacket->i_size_data);
	for(int i = pPacket->i_size_data; i > -1; i-- )
	{
		if(sz_dir[i] == '\\')
		{
			sz_dir[i] = '\0';	
			break;
		}
	}
	
	// Выполнить указанный файл
	
	HINSTANCE hInst = ::ShellExecute(NULL, "open", (const char*)pdata_pack, 
		(const char*)pdata_pack, (const char*)sz_dir, SW_SHOW);
	
	
	if(!hInst)
	{
		err_msg = "Невозможно выполнить указанный файл!";		
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_EXEC_FILE, ERR_EXEC_FILE, 
		0, (unsigned short)strlen(err_msg), (char*)err_msg, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}

	// Отправить клиенту подтверждение о выполнении указанного файла
	
	i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_EXEC_FILE, 0, 
	0, 0, NULL, &p_data_packet);
	((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
	if(p_data_packet) delete [] p_data_packet;
	return;
}


//////////////////////////////////////////////////////////////////////////////////////////
// Класс обработки команды "Определить количество файлов в каталоге"
//////////////////////////////////////////////////////////////////////////////////////////

c_count_files_dir::c_count_files_dir(CRfmServerClient *pTransport) :
	c_LogicCommand(pTransport)
{
}

c_count_files_dir::~c_count_files_dir(void)
{
}


void c_count_files_dir::break_operation()
{
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

	// Определить путь к каталогу

	if(!pPacket->i_size_data || !pdata_pack)
	{
		i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COUNT_FILES_DIR, 0, 
		1, 0, NULL, &p_data_packet);
		((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
		if(p_data_packet) delete [] p_data_packet;
		return;
	}
	
	// Подсчитать файлы в каталоге

	UINT i_count_file = CNRFileData::get_count_files_of_dir((const char*)pdata_pack);
	if(!i_count_file) i_count_file=1; 

	// Отправить количество клиенту

	i_size = ((c_TransportLevel*)m_pTransport)->make_packet(ID_COUNT_FILES_DIR, 0, 
	(ULONGLONG)i_count_file, 0, NULL, &p_data_packet);
	((c_TransportLevel*)m_pTransport)->SendData(p_data_packet, i_size);
	if(p_data_packet) delete [] p_data_packet;
}


















