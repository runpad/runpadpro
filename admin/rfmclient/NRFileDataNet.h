#pragma once

#include "NRFileData.h"
//#include ".\Rfmclientsocket.h"


///////////////////////////////////////////////////////////////////////
// класс		: CNRFileData
// Описание		: Предназначен для работы с файлами, и их данными 
//				  на сервере	
///////////////////////////////////////////////////////////////////////

class CNRFileDataNet : public CNRFileData
{
public:
	CNRFileDataNet(CRfmClientSocket *pConnectObj);
	~CNRFileDataNet(void);
	// Получить данные по найденным файлам
	virtual bool GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread); 
	// Определить список дисков на сервер
	// discList - массив информации о диске чистит вызывающий
	virtual bool GetDiscList(CListDrives& discList, CString& sz_err_descr);
	// Удалить файлы или каталог файлов на сервере
	bool delete_files(CString str_path, bool b_dir, CRfmThreads *p_proc_thread);
	// Установить главный путь
	void SetPathRoot(CString szPathroot){m_szPathroot = szPathroot;}
	// Создать каталог на сервере
	// str_name - название каталога
	bool create_dir(CString str_name, CString& sz_err_descr);
	// Копировать файл на сервер
	// sz_path_server - путь копирования на сервере
	// sz_path_local - путь копирования локальный
	bool copy_file_to_server(CString sz_path_server, CString sz_path_local, CRfmThreads *p_proc_thread);
	// Копировать файл c сервера
	// sz_path_server - путь копирования на сервере
	// sz_path_local - путь копирования локальный
	bool copy_file_from_server(CString sz_path_server, CString sz_path_local, bool b_dir, CRfmThreads *p_rfm_threads);
	// Переместить файл на сервер
	// sz_path_server - путь перемещения на сервере
	// sz_path_local - путь перемещения локальный
	bool move_file_to_server(CString sz_path_server, CString sz_path_local, CRfmThreads *p_proc_thread);
	// Переместить файл c сервера
	// sz_path_server - путь перемещения на сервере
	// sz_path_local - путь перемещения локальный
	bool move_file_from_server(CString sz_path_server, CString sz_path_local, bool b_dir, CRfmThreads *p_proc_thread);
	// Запустить файл на сервере
	// sz_path_server - путь к запускаемому файлу
	bool execute_file_server(CString sz_path_server, CString sz_command_line, CString& sz_err);
	// Установить обьект соединения с сервером
	void SetConnect(CRfmClientSocket *pConnectObj){m_pConnectObj = pConnectObj;}
	// Переименовать файл на сервере
	// sz_old_path - первоначальный путь
	// sz_new_path - новый путь 
	bool rename_file(CString sz_old_path, CString sz_new_path, CString& sz_err); 
	// Определить количество файлов в каталоге на сервере
	// str_path - путь к каталогу на сервере 
	UINT get_count_file_dir_srv(CString str_path);
private:
	// Удалить файл или каталог на сервер
	bool delete_file(CString str_path, CString& sz_err_descr);
	// Копировать каталог рекурсивно
	// sz_path_server - путь на сервере 
	// sz_path_local - локальный путь
	// sz_name_dir - название каталога
	bool copy_dir_to_server(CString sz_path_server, CString sz_path_local, CString sz_name_dir, CRfmThreads *p_proc_thread, bool b_move=false);
	// Копировать один файл на сервер
	// sz_path_server - путь копирования на сервере
	// sz_path_local - путь копирования локальный
	bool copy_one_file_to_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread);
	// Переместить один файл на сервер
	// sz_path_server - путь перемещения на сервере
	// sz_path_local - путь перемещения локальный
	bool move_one_file_to_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread);
	// Копировать один файл с сервера
	// sz_path_server - путь копирования на сервере
	// sz_path_local - путь копирования локальный
	bool copy_one_file_from_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_rfm_threads);
	// Переместить один файл с сервера
	// sz_path_server - путь перемещения на сервере
	// sz_path_local - путь перемещения локальный
	bool move_one_file_from_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread);
	// Код запрашиваемой операции
	int m_codeFunc; 
	// Пришедшие данные с сервера
	char *m_pDataIn;
	// Размер пришедших данных с сервера
	int m_sizeDataIn;
	// Событие окончания операции
	HANDLE m_hEndProccess;
	// Статус выполненной команды
	UINT m_iStatusCommand;
protected:
	// Главный путь для поиска файлов на сервере
	CString m_szPathroot;
	// Обьект соединения с сервером
	CRfmClientSocket *m_pConnectObj;
};

