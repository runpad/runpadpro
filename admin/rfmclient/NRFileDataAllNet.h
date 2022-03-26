#pragma once
#include "nrfiledatanet.h"

///////////////////////////////////////////////////////////////////////
// класс		: CNRFileDataAllNe
// Описание		: Предназначен для работы с файлами, и их данными 
//				  на сервере. Данный класс проводит операции с файлами по 
//				  всем текущим подключениям
///////////////////////////////////////////////////////////////////////

typedef vector<CRfmClientSocket*> CRfmSocketArr; 

class CNRFileDataAllNet : public CNRFileDataNet
{
public:
	CNRFileDataAllNet(CRfmSocketArr *p_arr_all_connect);
	~CNRFileDataAllNet(void);
	// Получить данные по найденным файлам по всем подключение
	// с выбором только идентичных файлов
	bool GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread); 
	// Определить общий список дисков на серверах
	// discList - массив информации о диске чистит вызывающий
	bool GetDiscList(CListDrives& discList, CString& sz_err_descr);
private:
	// Мвссив обьектов подключения к серверам
	CRfmSocketArr *m_p_arr_all_connect;
	// Отобрать одинаковые диски
	void SelectSameFile(CListFiles& files_list, CListFiles& file_list_new);
	// Отобрать одинаковые диски
	void SelectSameDisc(CListDrives& discList, CListDrives& discList_new);
};
