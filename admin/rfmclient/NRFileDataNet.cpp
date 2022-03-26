#include "StdAfx.h"
#include "NRFileDataNet.h"
#include "c_CommandHanlers.h"
#include "c_TransportLevel.h"
#include "c_LogicalLevel.h"
#include <direct.h>
#include <stack>
using namespace std;

// Максимальный буфер при копированиии файла
#define MAX_BUF_COPY_FILE 4096


//extern UINT WM_UPDATE_POS;
//extern UINT WM_UPDATE_TEST;
//extern UINT WM_UPDATE_POS_MAX;

CNRFileDataNet::CNRFileDataNet(CRfmClientSocket *pConnectObj) :
	CNRFileData(_T(""))	
{
	m_pConnectObj = pConnectObj;
	m_pDataIn = NULL;
	m_sizeDataIn = 0;
	m_codeFunc = -1;
	m_iStatusCommand = 1;
}

CNRFileDataNet::~CNRFileDataNet(void)
{
}


// Определить список дисков на сервер
// discList - массив информации о диске чистит вызывающий

bool CNRFileDataNet::GetDiscList(CListDrives& discList, CString& sz_err_descr)
{
	sz_err_descr = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_get_list_drive_cmd *p_cmd_get_drices = 
		static_cast<c_get_list_drive_cmd*>(p_logic_level->GetHandlerByID(ID_GET_LIST_DRIVES));
	if(!p_cmd_get_drices) return false;
	return p_cmd_get_drices->get_all_drives(discList, sz_err_descr);
}

// Получить данные по найденным файлам

bool CNRFileDataNet::GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread)
{
	CString sz_err_descr;
	sz_err_descr = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_get_list_files_cmd *p_cmd_get_files = 
		static_cast<c_get_list_files_cmd*>(p_logic_level->GetHandlerByID(ID_GET_LIST_FILES));
	if(!p_cmd_get_files) return false;
	p_cmd_get_files->set_rfm_thread(p_proc_thread);
	return p_cmd_get_files->get_list_files(files_list, m_szPathroot, sz_err_descr);
}





// Создать каталог на сервере
// str_name - название каталога

bool CNRFileDataNet::create_dir(CString str_name, CString& sz_err_descr)
{
	CString str_path = m_szPathroot + "\\" + str_name;
	sz_err_descr = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_create_dir_cmd *p_cmd_create_dir = 
		static_cast<c_create_dir_cmd*>(p_logic_level->GetHandlerByID(ID_CREATE_DIR));
	if(!p_cmd_create_dir) return false;
	return p_cmd_create_dir->cmd_create_dir(str_path, sz_err_descr);
}


// Копировать файл на сервер
// sz_path_server - путь копирования на сервере
// sz_path_local - путь копирования локальный

bool CNRFileDataNet::copy_file_to_server(CString sz_path_server, CString sz_path_local, CRfmThreads *p_proc_thread)
{
	WIN32_FIND_DATA findData;
	CString sz_err;		

	HANDLE hFirstFile = ::FindFirstFile(sz_path_local, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
	{
		p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] : Файл не найден " + sz_path_local);
		return false;
	}
	
	// Если путь указан к одному файлу 

	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))	
	{
		::FindClose(hFirstFile);
		
		// Обновить статус 
		
		p_proc_thread->SetTextStatusDlg(sz_path_local, sz_path_server+"\\"+findData.cFileName);
		
		
		if(!m_pConnectObj->is_connected())
		{
			FindClose(hFirstFile);	
			return false;
		}
		

		bool b_ret = copy_one_file_to_server(sz_path_server+"\\"+findData.cFileName, 
									   sz_path_local, sz_err, p_proc_thread);
		if(!b_ret)
		{
			p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " " +
				sz_path_server+"\\"+findData.cFileName);
			FindClose(hFirstFile);	
			return false;
		}
		else
			p_proc_thread->UpdateProgress(1);
	}
	else
	{
		// Если путь указан к каталогу файлов
		FindClose(hFirstFile);	
		return copy_dir_to_server(sz_path_server, sz_path_local, findData.cFileName, p_proc_thread);
	}

	return true;
}

// Копировать один файл на сервер
// sz_path_server - путь копирования на сервере
// sz_path_local - путь копирования локальный

bool CNRFileDataNet::copy_one_file_to_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread)
{
	sz_err = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_copy_file_in *p_cmd_copy_file_in = 
		static_cast<c_copy_file_in*>(p_logic_level->GetHandlerByID(ID_COPY_IN));
	p_cmd_copy_file_in->set_rfm_thread(p_proc_thread);
	if(!p_cmd_copy_file_in) return false;
	return p_cmd_copy_file_in->cmd_copy_file(sz_path_server, sz_path_local, sz_err);
}

// Копировать каталог рекурсивно
// sz_path_server - путь на сервере 
// sz_path_local - локальный путь
// sz_name_dir - название каталога

bool CNRFileDataNet::copy_dir_to_server(CString sz_path_server, CString sz_path_local, CString sz_name_dir, CRfmThreads *p_proc_thread, bool b_move/*=false*/)
{
	CString sz_err;
	bool fRet = false;
	if(sz_path_local.IsEmpty()) 
		return fRet;

    size_t tReplaceLen = 1;
    WIN32_FIND_DATA fd;

    // Создать корневой каталог и запомнить новый путь копирования файлов
	
	m_szPathroot = sz_path_server;
	sz_path_server += "\\";
	sz_path_server += sz_name_dir;			
	
	if(!m_pConnectObj->is_connected())
		return false;
	
	
	// Создать каталог на сервере

	if(!create_dir(sz_name_dir, sz_err))
	{
		p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err +
			sz_name_dir);
		
		return false; 
	}

	
	// Формируем строку пути для поиска файлов
    
	std::basic_string< TCHAR > stPath(sz_path_local);
    stPath += _T( "\\*");

    HANDLE hFind = FindFirstFile(stPath.c_str(), &fd);
    
	if( hFind != INVALID_HANDLE_VALUE)
    {
        fRet = TRUE;
        do 
		{
            if(WaitForSingleObject(p_proc_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
			{
				FindClose(hFind);	
				return true;
			}
			
			// Игнорируем вхождения в каталог
            
			if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            
			stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if(fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
				// Посмотреть что лежит в найденом каталоге
				copy_dir_to_server(sz_path_server,  stPath.c_str(), fd.cFileName, p_proc_thread, b_move); 
			}
            else
            {
                // Произвести копию файла на сервер
				if(b_move)
				{
					if(!m_pConnectObj->is_connected())
					{
						FindClose(hFind);	
						return false;
					}
					
					p_proc_thread->SetTextStatusDlg(sz_path_local+"\\"+fd.cFileName, 
						sz_path_server+"\\"+fd.cFileName);
					
					if(!move_one_file_to_server(sz_path_server+"\\"+fd.cFileName, sz_path_local+"\\"+fd.cFileName, sz_err, p_proc_thread))
					{
						p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+
							sz_path_server+"\\"+fd.cFileName +" --> " + sz_path_local+"\\"+fd.cFileName);
					}
					
					p_proc_thread->UpdateProgress(1);
				}
				else
				{
					if(!m_pConnectObj->is_connected()){
						FindClose(hFind);	
						return false;
					}
					

					p_proc_thread->SetTextStatusDlg(sz_path_local+"\\"+fd.cFileName, 
						sz_path_server+"\\"+fd.cFileName);
					
					if(!copy_one_file_to_server(sz_path_server+"\\"+fd.cFileName, sz_path_local+"\\"+fd.cFileName, sz_err, p_proc_thread))
					{
						p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err +" "+
							sz_path_server+"\\"+fd.cFileName +" --> " + sz_path_local+"\\"+fd.cFileName);
					}
					
					p_proc_thread->UpdateProgress(1);
				}
            }

        } 
		while( fRet && FindNextFile( hFind, &fd));
        
		FindClose( hFind);
		
		if(b_move)
		{
			BOOL b_ret = ::RemoveDirectory(sz_path_local);
			if(!b_ret)
				p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] Невозможно удалить каталог" +
							sz_path_local);
		}
    }

	return true;
}

// Копировать файл c сервера
// sz_path_server - путь копирования на сервере
// sz_path_local - путь копирования локальный

bool CNRFileDataNet::copy_file_from_server(CString sz_path_server, CString sz_path_local, bool b_dir, CRfmThreads *p_rfm_threads)
{
	CListFiles		files_list;
	CString			sz_err;

	if(!b_dir)
	{
		p_rfm_threads->SetTextStatusDlg(sz_path_server, sz_path_local);
		
		if(!m_pConnectObj->is_connected())
			return false;

		bool b_ret = copy_one_file_from_server(sz_path_server, sz_path_local, sz_err, p_rfm_threads);
		
		if(!b_ret)
		{
			p_rfm_threads->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							sz_path_server + "-->" + sz_path_local);
		}
		else
			// Скопировать файл с сервера
			p_rfm_threads->UpdateProgress(1);
		
		return b_ret;
	}
	
	// Создать каталог на локальной машине
	mkdir(sz_path_local);
	
	m_szPathroot = sz_path_server;
	GetDataFiles(files_list, p_rfm_threads);	

	while(files_list.size())
	{
		if(WaitForSingleObject(p_rfm_threads->get_handle_stop(), 0) == WAIT_OBJECT_0 || !m_pConnectObj->is_connected())
			break;
		
		if(files_list[0]->bDots)
		{
			files_list.erase(files_list.begin());
			continue;
		}

		if(files_list[0]->bDirectory)
		{
			// Создать каталог
			files_list[0]->szNameFile.Delete(0);
			files_list[0]->szNameFile.Delete(files_list[0]->szNameFile.GetLength()-1);
			mkdir(sz_path_local +"\\"+ files_list[0]->szNameFile);	
			// копировать каталог файлов 
			bool b_ret = copy_file_from_server(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile, b_dir, p_rfm_threads);
			
			m_szPathroot = sz_path_server;

			if(!b_ret)
				p_rfm_threads->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							m_szPathroot + "\\" + files_list[0]->szNameFile + "-->" + sz_path_local +"\\"+ files_list[0]->szNameFile);
		}
		else
		{
			p_rfm_threads->SetTextStatusDlg(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile);
			// Копировать отдельный файл
			bool b_ret = copy_one_file_from_server(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile, sz_err, p_rfm_threads);
			
			if(!b_ret)
				p_rfm_threads->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							m_szPathroot + "\\" + files_list[0]->szNameFile + "-->" + sz_path_local +"\\"+ files_list[0]->szNameFile);
			
			p_rfm_threads->UpdateProgress(1);
		}
		
		files_list.erase(files_list.begin());
	}
	
	return true;
}

// Копировать один файл с сервера
// sz_path_server - путь копирования на сервере
// sz_path_local - путь копирования локальный

bool CNRFileDataNet::copy_one_file_from_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_rfm_threads)
{
	sz_err = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_copy_file_out *p_cmd_file_out = 
		static_cast<c_copy_file_out*>(p_logic_level->GetHandlerByID(ID_COPY_OUT));
	if(!p_cmd_file_out) return false;
	p_cmd_file_out->set_rfm_thread(p_rfm_threads);
	return p_cmd_file_out->cmd_copy_file(sz_path_server, sz_path_local, sz_err);
}

// Переместить файл на сервер
// sz_path_server - путь перемещения на сервере
// sz_path_local - путь перемещения локальный

bool CNRFileDataNet::move_file_to_server(CString sz_path_server, CString sz_path_local, CRfmThreads *p_proc_thread)
{
	WIN32_FIND_DATA findData;
	CString sz_err;

	HANDLE hFirstFile = ::FindFirstFile(sz_path_local, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
	{
		sz_err = "Файл не найден!";
		return FALSE;
	}
	
	// Если путь указан к одному файлу 

	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))	
	{
		::FindClose(hFirstFile);
		
		p_proc_thread->SetTextStatusDlg(sz_path_local, sz_path_server+"\\"+findData.cFileName);
		
		
		bool b_ret = move_one_file_to_server(sz_path_server+"\\"+findData.cFileName, 
									   sz_path_local, sz_err, p_proc_thread);
		
		if(!b_ret)
		{		
			p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							sz_path_server+"\\"+findData.cFileName + " --> " + sz_path_local);
		}
		else
			p_proc_thread->UpdateProgress(1);
		
		FindClose(hFirstFile);	

		return b_ret;
	}
	
	// Если путь указан к каталогу файлов

	copy_dir_to_server(sz_path_server, sz_path_local, findData.cFileName, p_proc_thread, true);
	
	FindClose(hFirstFile);	

	return true;
}


// Переместить один файл на сервер
// sz_path_server - путь перемещения на сервере
// sz_path_local - путь перемещения локальный

bool CNRFileDataNet::move_one_file_to_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread)
{
	sz_err = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_move_file_in *p_cmd_file_in = 
		static_cast<c_move_file_in*>(p_logic_level->GetHandlerByID(ID_MOVE_IN));
	if(!p_cmd_file_in) return false;
	p_cmd_file_in->set_rfm_thread(p_proc_thread);
	return p_cmd_file_in->cmd_move_file(sz_path_server, sz_path_local, sz_err);
}

// Переместить один файл с сервера
// sz_path_server - путь перемещения на сервере
// sz_path_local - путь перемещения локальный

bool CNRFileDataNet::move_one_file_from_server(CString sz_path_server, CString sz_path_local, CString& sz_err, CRfmThreads *p_proc_thread)
{
	sz_err = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_move_file_out *p_cmd_move_out = 
		static_cast<c_move_file_out*>(p_logic_level->GetHandlerByID(ID_MOVE_OUT));
	if(!p_cmd_move_out) return false;
	p_cmd_move_out->set_rfm_thread(p_proc_thread);
	return p_cmd_move_out->cmd_move_file(sz_path_server, sz_path_local, sz_err);
}


// Переместить файл c сервера
// sz_path_server - путь перемещения на сервере
// sz_path_local - путь перемещения локальный

bool CNRFileDataNet::move_file_from_server(CString sz_path_server, CString sz_path_local, bool b_dir, CRfmThreads *p_proc_thread)
{
	CListFiles		files_list;
	CString			sz_err;

	if(!b_dir)
	{
		p_proc_thread->SetTextStatusDlg(sz_path_server, sz_path_local);
		
		bool b_ret = move_one_file_from_server(sz_path_server, sz_path_local, sz_err, p_proc_thread);

		if(!b_ret)
		{
			p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							sz_path_server + " --> " + sz_path_local);
		}
		else
			p_proc_thread->UpdateProgress(1);
		
		// Переместить файл с сервера
		return b_ret;
	}
	
	// Создать каталог на локальной машине
	mkdir(sz_path_local);
	
	m_szPathroot = sz_path_server;
	GetDataFiles(files_list, p_proc_thread);	

	while(files_list.size())
	{
		if(WaitForSingleObject(p_proc_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		if(files_list[0]->bDots)
		{
			files_list.erase(files_list.begin());
			continue;
		}

		if(files_list[0]->bDirectory)
		{
			// Создать каталог
			files_list[0]->szNameFile.Delete(0);
			files_list[0]->szNameFile.Delete(files_list[0]->szNameFile.GetLength()-1);
			mkdir(sz_path_local +"\\"+ files_list[0]->szNameFile);	
			// копировать каталог файлов 
			move_file_from_server(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile, b_dir, p_proc_thread);
			m_szPathroot = sz_path_server;
		}
		else
		{
			// Копировать отдельный файл
			bool b_ret = move_one_file_from_server(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile, sz_err, p_proc_thread);
			
			if(!b_ret)
				p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + sz_err + " "+ 
							m_szPathroot + "\\" + files_list[0]->szNameFile + " --> " + sz_path_local +"\\"+ files_list[0]->szNameFile);

			p_proc_thread->UpdateProgress(1);
			p_proc_thread->SetTextStatusDlg(m_szPathroot + "\\" + files_list[0]->szNameFile, 
				sz_path_local +"\\"+ files_list[0]->szNameFile);
		}
		
		files_list.erase(files_list.begin());
	}

	// Удалить каталог
	delete_file(m_szPathroot, sz_err);
	
	return true;
}



// Удалить файл или пустой каталог на сервере
// str_path - путь к удаляемому файлу

bool CNRFileDataNet::delete_file(CString str_path, CString& sz_err_descr)
{
	sz_err_descr = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_delete_file_cmd *p_cmd_delete_file = 
		static_cast<c_delete_file_cmd*>(p_logic_level->GetHandlerByID(ID_DELETE_FILE));
	if(!p_cmd_delete_file) return false;
	return p_cmd_delete_file->cmd_delete_file(str_path, sz_err_descr);
}


// Удалить файлы или каталог файлов на сервере
// str_path - путь удаления файла
// sz_err_descr - описание ошибки если она есть
// b_dir - true если каталог

bool CNRFileDataNet::delete_files(CString str_path, bool b_dir, CRfmThreads *p_proc_thread)
{
	CListFiles		files_list;
	CString			sz_err_descr;

	if(!b_dir)
	{
		p_proc_thread->UpdateProgress(1);
		p_proc_thread->SetTextStatusDlg(str_path, _T(""));
		
		bool b_ret = delete_file(str_path, sz_err_descr);
		if(!b_ret)
			p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + 
										  sz_err_descr + " "+ str_path);
		
		return b_ret;	
	}
	
	if(delete_file(str_path, sz_err_descr)) 
		return true;

	m_szPathroot = str_path;
	GetDataFiles(files_list, p_proc_thread);	
	
	while(files_list.size())
	{
		if(WaitForSingleObject(p_proc_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
			break;
		
		if(files_list[0]->bDots)
		{
			files_list.erase(files_list.begin());
			continue;
		}

		// Удаляем все что в каталоге
		
		CString str_debug = m_szPathroot + "\\" + files_list[0]->szNameFile;	

		if(!delete_file(m_szPathroot + "\\" + files_list[0]->szNameFile, sz_err_descr))
		{
			// Удалить каталог файлов
			
			if(files_list[0]->bDirectory)
			{
				files_list[0]->szNameFile.Delete(0);
				files_list[0]->szNameFile.Delete(files_list[0]->szNameFile.GetLength()-1);
				delete_files(m_szPathroot + "\\" + files_list[0]->szNameFile, true, p_proc_thread);
				m_szPathroot = str_path;
			}
			else
			{
				p_proc_thread->add_new_error("["+((c_TransportLevel*)m_pConnectObj)->get_name_server()+"] " + 
										  sz_err_descr + " "+ str_path);
			}
		}
		else
		{
			p_proc_thread->UpdateProgress(1);
			p_proc_thread->SetTextStatusDlg(str_path, _T(""));
		}
		
		files_list.erase(files_list.begin());
	}
	
	// Удалить пустой каталог
	
	delete_file(m_szPathroot, sz_err_descr);
	
	return true;
}

// Запустить файл на сервере
// sz_path_server - путь к запускаемому файлу

bool CNRFileDataNet::execute_file_server(CString sz_path_server, CString sz_command_line, CString& sz_err)
{
	sz_err = DEFAULT_ERROR;
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_exec_file_cmd *p_cmd_exec_file = 
		static_cast<c_exec_file_cmd*>(p_logic_level->GetHandlerByID(ID_EXEC_FILE));
	if(!p_cmd_exec_file) return false;
	return p_cmd_exec_file->cmd_exec_file(sz_path_server, sz_err);
}

// Определить количество файлов в каталоге на сервере
// str_path - путь к каталогу на сервере 

UINT CNRFileDataNet::get_count_file_dir_srv(CString str_path)
{
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_count_files_dir *p_cmd_count_files = 
		static_cast<c_count_files_dir*>(p_logic_level->GetHandlerByID(ID_COUNT_FILES_DIR));
	if(!p_cmd_count_files) return false;
	return p_cmd_count_files->cmd_count_files_dir(str_path);
}

// Переименовать файл на сервере
// sz_old_path - первоначальный путь
// sz_new_path - новый путь 

bool CNRFileDataNet::rename_file(CString sz_old_path, CString sz_new_path, CString& sz_err)
{
	if(!m_pConnectObj) return false;
	c_LogicalLevel *p_logic_level = ((c_TransportLevel*)m_pConnectObj)->get_logic_level();
	if(!p_logic_level) return false;
	c_rename_file_cmd *p_cmd_rename_file = 
		static_cast<c_rename_file_cmd*>(p_logic_level->GetHandlerByID(ID_RENAME_FILE));
	if(!p_cmd_rename_file) return false;
	return p_cmd_rename_file->cmd_move_file(sz_old_path, sz_new_path, sz_err);
}





