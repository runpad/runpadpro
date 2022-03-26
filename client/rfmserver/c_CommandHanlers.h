#pragma once

#include "NRFileData.h"

// Максимальный буфере передвчи данных при копировании файлов
#define MAX_BUFER_COPY_FILES 2048

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
	c_LogicCommand(CRfmServerClient *pTransport)
	{
		if(!pTransport) throw;
		m_pTransport = pTransport;
	}
	~c_LogicCommand(){}
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize) = 0;
	virtual void break_operation() = 0;
protected:
	// Обьект транспортного уровня
	CRfmServerClient *m_pTransport;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_get_list_drive_cmd
// Описание	: Данный класс выполняет команду по определению дисков в системе
/////////////////////////////////////////////////////////////////////////////////////


class c_get_list_drive_cmd : public c_LogicCommand
{
public:
	c_get_list_drive_cmd(CRfmServerClient *pTransport);
	~c_get_list_drive_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
private:
	// Общая длина области данных по дискам
	unsigned int m_i_total_size;
	// Очистить массив полученных дисков
	void ClearAllData();
	// Индекс данных диска которые необходимо передать следующим пкетом
	int m_indx_drive_data;
	// Подсчитать общую длину данных по дискам
	unsigned int get_total_size_data();
	// Сгенеривать передаваемые данные по одному диску
	// pDataDrive  - информация по одному диску
	// p_data_ret  - возвращаемые данные после генерации 
	// b_only_size - если true возвратися размер и область данных пакета, false - только размер 
	int make_data_drive(PDATA_DISC pDataDrive, char **pp_data_ret, bool b_only_size/*=false*/);
	// Список полученных в системе дисков
	CListDrives m_drivesList;
};



/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_get_list_files_cmd
// Описание	: Данный класс выполняет команду по определению списка файлов
/////////////////////////////////////////////////////////////////////////////////////


class c_get_list_files_cmd : public c_LogicCommand
{
public:
	c_get_list_files_cmd(CRfmServerClient *pTransport);
	~c_get_list_files_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
private:
	// Общая длина области данных по файлам
	unsigned int m_i_total_size;
	// Очистить массив полученных файлов
	void ClearAllData();
	// Индекс данных диска которые необходимо передать следующим пкетом
	int m_indx_file_data;
	// Подсчитать общую длину данных по файлам
	unsigned int get_total_size_data();
	// Сгенеривать передаваемые данные по одному файлу
	// pDataFile   - информация по одному файлу
	// p_data_ret  - возвращаемые данные после генерации 
	// b_only_size - если true возвратися размер и область данных пакета, false - только размер 
	int make_data_files(PDATA_FILE pDataFile, char **pp_data_ret, bool b_only_size/*=false*/);
	// Педыдущий список файлов
	CListFiles m_listFiles;
};

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_delete_file_cmd
// Описание	: Данный класс выполняет команду по удалению файла
/////////////////////////////////////////////////////////////////////////////////////


class c_delete_file_cmd : public c_LogicCommand
{
public:
	c_delete_file_cmd(CRfmServerClient *pTransport);
	~c_delete_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_create_dir_cmd
// Описание	: Данный класс выполняет команду создания каталога
/////////////////////////////////////////////////////////////////////////////////////


class c_create_dir_cmd : public c_LogicCommand
{
public:
	c_create_dir_cmd(CRfmServerClient *pTransport);
	~c_create_dir_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_copy_file_in
// Описание	: Данный класс выполняет команду копирования файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_copy_file_in : public c_LogicCommand
{
public:
	c_copy_file_in(CRfmServerClient *pTransport);
	~c_copy_file_in(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	virtual void break_operation();
protected:
	// Дескриптор открытого файла на запись
	HANDLE h_file_copy;
	// Путь к копируемому файлу
	std::string m_sz_path_file;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_copy_file_out
// Описание	: Данный класс выполняет команду копирования файла с сервера
/////////////////////////////////////////////////////////////////////////////////////


class c_copy_file_out : public c_LogicCommand
{
public:
	c_copy_file_out(CRfmServerClient *pTransport);
	~c_copy_file_out(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
protected:
	// Дескриптор открытого файла на чтение
	HANDLE h_file_copy;
	// Общий размер файла
	ULONGLONG m_liSize;
	// Текущая позиция чтения в файле
	ULONGLONG m_cur_pos_file;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_move_file_in
// Описание	: Данный класс выполняет команду перемещения файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_move_file_in : public c_copy_file_in
{
public:
	c_move_file_in(CRfmServerClient *pTransport);
	~c_move_file_in(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_move_file_out
// Описание	: Данный класс выполняет команду перемещения файла на сервер
/////////////////////////////////////////////////////////////////////////////////////


class c_move_file_out : public c_copy_file_out
{
public:
	c_move_file_out(CRfmServerClient *pTransport);
	~c_move_file_out(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
private:
	// путь к перемещаемому файлу
	std::string m_sz_path_move;
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_rename_file_cmd
// Описание	: Данный класс выполняет команду переименования файла
/////////////////////////////////////////////////////////////////////////////////////

class c_rename_file_cmd : public c_LogicCommand
{
public:
	c_rename_file_cmd(CRfmServerClient *pTransport);
	~c_rename_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_exec_file_cmd
// Описание	: Данный класс выполняет команду запуска файла
/////////////////////////////////////////////////////////////////////////////////////


class c_exec_file_cmd : public c_LogicCommand
{
public:
	c_exec_file_cmd(CRfmServerClient *pTransport);
	~c_exec_file_cmd(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_count_files_dir
// Описание	: Определить количество файлов в каталоге
/////////////////////////////////////////////////////////////////////////////////////

class c_count_files_dir : public c_LogicCommand
{
public:
	c_count_files_dir(CRfmServerClient *pTransport);
	~c_count_files_dir(void);
	// Добавить данные для выполнения команды
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void ProcessCommand(char *pData, int nSize);
	// Розрыв текущей операции
	void break_operation();
};

