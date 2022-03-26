#pragma once

#include ".\Rfmclientsocket.h"
#include "RfmThreads.h"
//#include "NRFileData.h"


// Максимальный буфере передвчи данных при копировании файлов
#define MAX_BUFER_COPY_FILES 2048
#define DEFAULT_ERROR "Внутренняя ошибка!"

/////////////////////////////////////////////////////////////////////////////////////
// Идентификаторы команд серверу
/////////////////////////////////////////////////////////////////////////////////////

#define ID_GET_LIST_DRIVES	0x5  // Получить список дисков в системе
#define ID_GET_LIST_FILES	0x7  // Получить список файлов по текущему выбранному каталогу
#define ID_DELETE_FILE		0xA  // удаление файла/каталога
#define ID_CREATE_DIR		0xC  // Создать дирректорию
#define ID_COPY_IN			0xD  // Копировать файл на сервер
#define ID_COPY_OUT			0xE  // Копировать файл с сервера		 
#define ID_MOVE_IN			0xF  // Переместить файл на сервер	
#define ID_MOVE_OUT			0x10 // Переместить файл с сервера
#define ID_RENAME_FILE		0x11 // Переименовать файл
#define ID_EXEC_FILE		0x12 // Запустить файл
#define ID_ERROR_PACK		0x15 // Ошибочный пакет
#define ID_COUNT_FILES_DIR	0x17 // Определить количество файлов в каталоге


/////////////////////////////////////////////////////////////////////////////////////
// Возможные ошибки прерывания опрации логического уровня
/////////////////////////////////////////////////////////////////////////////////////

#define ERR_TIMEOUT			0x80 // Истекло время ожидание составного пакета
#define ERR_ABORT_PACK	    0x81 // Обрыв текущей операции (может быть спровоцировано пользователем или одной из сторон)
#define ERR_LIST_DRIVES	    0x70 // Ошибка получения списка дисков
#define ERR_LIST_FILES	    0x71 // Ошибка получения списка файлов по текущему пути
#define ERR_DELETE_FILE	    0x72 // Ошибка удаления файла
#define ERR_CREATE_DIR	    0x75 // Ошибка создания дирректории 	 
#define ERR_COPY_FILE	    0x73 // Ошибка копирования файла
#define ERR_RENAME_FILE	    0x77 // Ошибка переименования файла
#define ERR_EXEC_FILE	    0x78 // Ошибка выполнения файла


// Разделитель данных в пакете

#define SPLIT_DATA 0x4


/////////////////////////////////////////////////////////////////////////////////////
// Описание одного пакета  
/////////////////////////////////////////////////////////////////////////////////////
#pragma pack(1)
typedef struct __PACKET_DATA__
{
	unsigned char		c_sign_pack;   // Идентификатор начала пакета (всегда 0x2A)
	unsigned short		i_size_pack;   // Размер текущего пакета
	unsigned char		c_id_packet;   // Идентификатор пакета
	unsigned char		c_code_err;    // Код ошибки (смотреть нужно поле в том случае если id_pack == ID_ERROR_PACK)
	unsigned __int64	ui_total_size; // Общий размер пакета
	unsigned short		i_size_data;   // Размер области данных пакета
}PACKET_DATA, *PPACKET_DATA;


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_LogicCommand
// Описание	: Данный класс является базовым классом для всех классов комманд
/////////////////////////////////////////////////////////////////////////////////////

class c_LogicCommand
{
public:
	c_LogicCommand(CRfmClientSocket *pTransport)
	{
		if(!pTransport) throw;
		m_pTransport = pTransport;
		m_h_end_operation = ::CreateEvent(NULL, TRUE, FALSE, NULL);
		m_p_rfm_thread = NULL;
	}
	~c_LogicCommand(){}
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize) = 0;
	virtual void break_operation() = 0;
	// Установить обьект управления файловыми операциями
	void set_rfm_thread(CRfmThreads *p_rfm_thread){m_p_rfm_thread = p_rfm_thread;}
protected:
	// Обьект транспортного уровня
	CRfmClientSocket *m_pTransport;
	// Событие окончания операции получения ядисков
	HANDLE m_h_end_operation;
	// Описание ошибки получения дисков
	CString m_sz_error_descr;
	// Флаг завершения сетевой функции  
	bool m_flag_finish; 
	// Управление файловыми операциями
	CRfmThreads *m_p_rfm_thread;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_get_list_drive_cmd
// Описание	: Данный класс выполняет команду по определению дисков в системе
/////////////////////////////////////////////////////////////////////////////////////


class c_get_list_drive_cmd : public c_LogicCommand
{
public:
	c_get_list_drive_cmd(CRfmClientSocket *pTransport);
	~c_get_list_drive_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	void break_operation();
	// Дать команду серверу, определить диски
	// list_drives - полученный список дисков с сервера
	bool get_all_drives(CListDrives& list_drives, CString& sz_err_descr);
private:
	// Список полученных в системе дисков
	CListDrives *m_pDrivesList;
	// Размер уже полученных данных по дискам
	int m_i_size_recv_data;
};



/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_get_list_files_cmd
// Описание	: Данный класс выполняет команду по определению списка файлов
/////////////////////////////////////////////////////////////////////////////////////


class c_get_list_files_cmd : public c_LogicCommand
{
public:
	c_get_list_files_cmd(CRfmClientSocket *pTransport);
	~c_get_list_files_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	void break_operation();
	// Дать команду серверу, определить файлы по определенному пути
	// list_drives - полученный список файлов
	// sz_path - корневой путь
	bool get_list_files(CListFiles& list_files, CString sz_path, CString& sz_err_descr);
private:
	// Список полученных в системе дисков
	CListFiles *m_pFilesList;
	// Размер уже полученных данных по дискам
	int m_i_size_recv_data;
};

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_delete_file_cmd
// Описание	: Данный класс выполняет команду по удалению файла
/////////////////////////////////////////////////////////////////////////////////////


class c_delete_file_cmd : public c_LogicCommand
{
public:
	c_delete_file_cmd(CRfmClientSocket *pTransport);
	~c_delete_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	void break_operation();
	// Команда удаления файла
	// sz_path - путь к удаляемому файлу
	// sz_err_descr - описание последней ошибки
	bool cmd_delete_file(CString sz_path, CString& sz_err_descr);
};

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_create_dir_cmd
// Описание	: Данный класс выполняет команду создания каталога
/////////////////////////////////////////////////////////////////////////////////////


class c_create_dir_cmd : public c_LogicCommand
{
public:
	c_create_dir_cmd(CRfmClientSocket *pTransport);
	~c_create_dir_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	void break_operation();
	// Команда удаления файла
	// sz_path - путь к удаляемому файлу
	// sz_err_descr - описание последней ошибки
	bool cmd_create_dir(CString str_path, CString& sz_err_descr);
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_copy_file_in
// Описание	: Данный класс выполняет команду копирования файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_copy_file_in : public c_LogicCommand
{
public:
	c_copy_file_in(CRfmClientSocket *pTransport);
	~c_copy_file_in(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Копировать файл 
	// sz_path_server - путь файла на сервере
	// sz_path_local - путь файла локальный
	// sz_err - описание ошибки если она возникла
	bool cmd_copy_file(CString sz_path_server, CString sz_path_local, CString& sz_err);
protected:
	// Дескриптор открытого файла на запись
	HANDLE m_h_file_copy;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_copy_file_out
// Описание	: Данный класс выполняет команду копирования файла с сервера
/////////////////////////////////////////////////////////////////////////////////////


class c_copy_file_out : public c_LogicCommand
{
public:
	c_copy_file_out(CRfmClientSocket *pTransport);
	~c_copy_file_out(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Копировать файл 
	// sz_path_server - путь файла на сервере
	// sz_path_local - путь файла локальный
	// sz_err - описание ошибки если она возникла
	bool cmd_copy_file(CString sz_path_server, CString sz_path_local, CString& sz_err);
protected:
	// Дескриптор открытого файла на чтение
	HANDLE m_h_file_copy;
	// Общий размер файла
	ULONGLONG m_liSize;
	// Путь к файлу на случай удаления
	CString m_sz_path_file;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_move_file_in
// Описание	: Данный класс выполняет команду перемещения файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_move_file_in : public c_copy_file_in
{
public:
	c_move_file_in(CRfmClientSocket *pTransport);
	~c_move_file_in(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Переместить файл 
	// sz_path_server - путь файла на сервере
	// sz_path_local - путь файла локальный
	// sz_err - описание ошибки если она возникла
	bool cmd_move_file(CString sz_path_server, CString sz_path_local, CString& sz_err);
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_move_file_out
// Описание	: Данный класс выполняет команду перемещения файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_move_file_out : public c_copy_file_out
{
public:
	c_move_file_out(CRfmClientSocket *pTransport);
	~c_move_file_out(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Переместить файл 
	// sz_path_server - путь файла на сервере
	// sz_path_local - путь файла локальный
	// sz_err - описание ошибки если она возникла
	bool cmd_move_file(CString sz_path_server, CString sz_path_local, CString& sz_err);
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_rename_file_cmd
// Описание	: Данный класс выполняет команду переименования файла
/////////////////////////////////////////////////////////////////////////////////////

class c_rename_file_cmd : public c_LogicCommand
{
public:
	c_rename_file_cmd(CRfmClientSocket *pTransport);
	~c_rename_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Переименовать файл 
	// sz_path_old - предыдущий путь
	// sz_path_new - новый путь
	// sz_err - описание ошибки если она возникла
	bool cmd_move_file(CString sz_path_old, CString sz_path_new, CString& sz_err);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_exec_file_cmd
// Описание	: Данный класс выполняет команду запуска файла
/////////////////////////////////////////////////////////////////////////////////////


class c_exec_file_cmd : public c_LogicCommand
{
public:
	c_exec_file_cmd(CRfmClientSocket *pTransport);
	~c_exec_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Запустить указанный файл
	// sz_path_server - путь к файлу
	bool cmd_exec_file(CString sz_path_server,CString& sz_err);
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_count_files_dir
// Описание	: Определить количество файлов в каталоге
/////////////////////////////////////////////////////////////////////////////////////

class c_count_files_dir : public c_LogicCommand
{
public:
	c_count_files_dir(CRfmClientSocket *pTransport);
	~c_count_files_dir(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Обрыв текущей операции в случае пропадания связи с сервером
	// или потока ошибок
	virtual void break_operation();
	// Определить количесто файлов в указанном каталоге 
	// sz_path_server - путь к каталогу
	UINT cmd_count_files_dir(CString sz_path_server);
private:
	// Полученое количство файлов
	UINT m_i_count_files;
};