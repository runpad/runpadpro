#include "StdAfx.h"
#include "NRFileDataAllNet.h"

CNRFileDataAllNet::CNRFileDataAllNet(CRfmSocketArr *p_arr_all_connect) : 
	CNRFileDataNet(NULL)
{
	m_p_arr_all_connect = p_arr_all_connect;
}

CNRFileDataAllNet::~CNRFileDataAllNet(void)
{
}

// Отобрать одинаковые диски

void CNRFileDataAllNet::SelectSameDisc(CListDrives& discList, CListDrives& discList_new)
{
	if(!discList.size())
	{
		discList.assign(discList_new.begin(), discList_new.end());
		
		// Стереть индивидуальную информацию
		
		for(size_t i=0; i < discList.size(); i++)
		{
			discList[i]->szLabel = "----";
			discList[i]->szFileSys = "----";
		}

		discList_new.clear();
		return;
	}

	// Отфильтровать лишние диски

	for(size_t i=0; i < discList.size(); i++)
	{
		bool b_find = false; 
		for(size_t j=0; j<discList_new.size(); j++)
		{
			if(discList_new[j]->szLetterDisc == discList[i]->szLetterDisc &&
			   discList_new[j]->iTypeDisc == discList[i]->iTypeDisc)
			{
				b_find = true; 
				break;
			}
		}	
	
		if(!b_find)
		{
			delete discList[i];
			discList.erase(discList.begin()+i);
			i--;
		}
	}

	// Очистить полученный список

	for(size_t i=0; i < discList_new.size(); i++)
	{
		delete discList_new[i];
		discList_new.erase(discList_new.begin()+i);
	}
}


// Отобрать одинаковые диски

void CNRFileDataAllNet::SelectSameFile(CListFiles& files_list, CListFiles& file_list_new)
{
	if(!files_list.size())
	{
		files_list.assign(file_list_new.begin(), file_list_new.end());
		
		// Стереть индивидуальную информацию
		
		for(size_t i=0; i < files_list.size(); i++)
		{
			files_list[i]->timeCreate = 0;
			files_list[i]->iSizeFile = 0;
		}
		
		file_list_new.clear();
		return;
	}

	// Отфильтровать лишние файлы

	for(size_t i=0; i < files_list.size(); i++)
	{
		bool b_find = false; 
		for(size_t j=0; j < file_list_new.size(); j++)
		{
			if(files_list[i]->szNameFile == file_list_new[j]->szNameFile &&
			   files_list[i]->bDirectory == file_list_new[j]->bDirectory)
			{
				b_find = true; 
				break;
			}
		}	
	
		if(!b_find)
		{
			delete files_list[i];
			files_list.erase(files_list.begin()+i);
			i--;
		}
	}

	// Очистить полученный список

	for(size_t i=0; i < file_list_new.size(); i++)
	{
		delete file_list_new[0];
		file_list_new.erase(file_list_new.begin());
	}
	file_list_new.clear();
}



// Получить данные по найденным файлам по всем подключение
// с выбором только идентичных файлов

bool CNRFileDataAllNet::GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread) 
{
	CListFiles file_list_new;
	
	if(!m_p_arr_all_connect && m_p_arr_all_connect->size())
		return false;
	
	// сканируем диски по всем подключениям
	
	for(int i=1; i < (int)m_p_arr_all_connect->size(); i++)
	{
		m_pConnectObj = (*m_p_arr_all_connect)[i];
		if(!m_pConnectObj->is_connected())
			continue;
		if(!CNRFileDataNet::GetDataFiles(file_list_new, NULL))
		{
			files_list.clear();
			file_list_new.clear();
			return false;
		}
		
		// Отобрать одинаковые файлы и каталоги
		SelectSameFile(files_list, file_list_new);
	}
	
	return true;
}

// Определить общий список дисков на серверах
// discList - массив информации о диске чистит вызывающий

bool CNRFileDataAllNet::GetDiscList(CListDrives& discList, CString& sz_err_descr)
{
	CListDrives disc_list_new;
	
	if(!m_p_arr_all_connect && m_p_arr_all_connect->size())
		return false;
	
	// сканируем диски по всем подключениям
	
	for(int i=1; i < (int)m_p_arr_all_connect->size(); i++)
	{
		m_pConnectObj = (*m_p_arr_all_connect)[i];
		CNRFileDataNet::GetDiscList(disc_list_new, sz_err_descr);
		// Отобрать одинаковые диски
		SelectSameDisc(discList, disc_list_new);
	}

	return true;
}
