#include "StdAfx.h"
#include "NRFileData.h"

#pragma warning(disable : 4996)


// some bugs related to WTL?
CDisableWOW64FSRedirection::CDisableWOW64FSRedirection()
{
/*  old_value = NULL;
  
  BOOL (WINAPI *pWow64DisableWow64FsRedirection)(PVOID *OldValue);
  *(void**)&pWow64DisableWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64DisableWow64FsRedirection");

  if ( pWow64DisableWow64FsRedirection )
     {
       pWow64DisableWow64FsRedirection(&old_value);
     }*/
}


CDisableWOW64FSRedirection::~CDisableWOW64FSRedirection()
{
/*  BOOL (WINAPI *pWow64RevertWow64FsRedirection)(PVOID OlValue);
  *(void**)&pWow64RevertWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64RevertWow64FsRedirection");

  if ( pWow64RevertWow64FsRedirection )
     {
       pWow64RevertWow64FsRedirection(old_value);
     }*/
}


extern UINT WM_UPDATE_TEST;
extern UINT WM_UPDATE_POS;

CNRFileData::CNRFileData(CString szMainPath)
{
	m_szCurrentPath = szMainPath;
}




CNRFileData::~CNRFileData(void)
{
	// Зачистка предыдущего результата

	//for(int i = 0; i < (int)m_listFiles.size(); i++)
	//	if(m_listFiles[i])
	//		delete m_listFiles[i];
	//m_listFiles.clear();
}

// Определить список дисков в системе
// discList - массив информации о диске чистит вызывающий

void CNRFileData::GetDiscList(CListDrives& discList)
{
	CString str_tmp;
	
	// Определить битовую маску для логических дисков
	
	DWORD dr = GetLogicalDrives(); 

	for(int x = 0; x < 26; x++)
	{
		// Получить литеру диска
		
		str_tmp = CString((char)(65+x)); 	
		
		// Для теста (Потом перемотреть)
		if(str_tmp == "A") continue;	
		

		char targetpath[256];
		DWORD ret = QueryDosDevice(str_tmp + _T(":"), targetpath, sizeof(targetpath)); 
		
		if(ret || ret == ERROR_INSUFFICIENT_BUFFER)
		{
			PDATA_DISC pDataDisc = new DATA_DISC;
			VERIFY(pDataDisc);
				
			pDataDisc->szLetterDisc = str_tmp;
			
			// Определить тип диска

			pDataDisc->iTypeDisc = GetDriveType(pDataDisc->szLetterDisc + _T(":\\"));

			// Получить метку диска и имя файловой системы
			
			char	drive_label[30];
			char	drive_fat[30];
			DWORD	drive_sn;
			DWORD	drive_name_size = sizeof(drive_label);

			memset(drive_label, 0, 30);
			memset(drive_fat, 0, 30);

			GetVolumeInformation(pDataDisc->szLetterDisc + _T(":\\"),
								 drive_label,
								 sizeof(drive_label),
								 &drive_sn,
								 &drive_name_size,
								 NULL,
								 drive_fat,
								 sizeof(drive_fat));

			pDataDisc->szLabel = CString(drive_label);
			pDataDisc->szFileSys = CString(drive_fat);
		
			// Определить иконку диска

			SHFILEINFO shfi;
			memset(&shfi,0,sizeof(shfi));
			HIMAGELIST hImageList = (HIMAGELIST)SHGetFileInfo(pDataDisc->szLetterDisc + _T(":\\"),
			FILE_ATTRIBUTE_NORMAL,
			&shfi,
			sizeof(shfi), SHGFI_SMALLICON | SHGFI_ICON | SHGFI_SYSICONINDEX);
			pDataDisc->nIconDisc = shfi.iIcon;	
		
			// Опредеить свободное место на диске в GB
			
			if(pDataDisc->iTypeDisc != DRIVE_CDROM)
			{
				ULARGE_INTEGER i_FreeBytesAvailable, i_TotalNumberOfBytes, i_TotalNumberOfFreeBytes;

				GetDiskFreeSpaceEx(pDataDisc->szLetterDisc + _T(":\\"), 
									  &i_FreeBytesAvailable, 
									  &i_TotalNumberOfBytes, 
									  &i_TotalNumberOfFreeBytes);
	  			
				pDataDisc->d_free_space = (double)i_FreeBytesAvailable.QuadPart / 1000000000;
			}
			else
			{
				pDataDisc->d_free_space = 0.0;
			}
			// Добавить данные

			discList.push_back(pDataDisc);
		}
	}

}


// Определить список иконок файлов
static char* GetSysDrivePathWithBackslash(void)
{
  static char s[MAX_PATH];
  char drive;

  s[0] = 0;
  GetEnvironmentVariable("SystemDrive",s,sizeof(s));
  if ( !s[0] )
     GetWindowsDirectory(s,sizeof(s));
  CharUpper(s);

  if ( lstrlen(s) >= 2 && s[1] == ':' )
     drive = s[0];
  else
     drive = 'C';

  if ( drive < 'C' || drive > 'Z' )
     drive = 'C';

  wsprintf(s,"%c:\\",drive);
  return s;
}



void CNRFileData::GetImageListFiles(CImageList& imageFileList)
{
	SHFILEINFO shfi;
	memset(&shfi,0,sizeof(shfi));
	HIMAGELIST hImageList = (HIMAGELIST)SHGetFileInfo(GetSysDrivePathWithBackslash(),
	FILE_ATTRIBUTE_NORMAL,
	&shfi,
	sizeof(shfi), SHGFI_SMALLICON | SHGFI_ICON | SHGFI_SYSICONINDEX);
	imageFileList.Attach(hImageList);
	::DestroyIcon(shfi.hIcon);
}


// Определить полный путь к файлу

CString CNRFileData::GetFullPath(CString strCatalog, CString strFile, bool& b_prev_dir)
{
	CString szFullPath = strCatalog;
	if(szFullPath.Find("..") != -1)
	{
		szFullPath.Replace("\\..", "");
		for(int i=szFullPath.GetLength()-1; i > -1; i--)
		{
			if(szFullPath[i] == '\\')
				break;
			szFullPath.Delete(i);
		}
		if(!strFile.IsEmpty())
			szFullPath += strFile;
		else
			szFullPath.Delete(szFullPath.GetLength()-1);
	
		b_prev_dir = true;
	}
	else
	if(!strFile.IsEmpty())
	{
		szFullPath += "\\";
		szFullPath += strFile;
		b_prev_dir = false;
	}
	return szFullPath;
}


// Определить все файлы в указанном каталоге
// Загружает текущий массив m_listFiles

// Получить данные по найденным файлам


bool CNRFileData::GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread)
{
	WIN32_FIND_DATA findData;
	bool b_prev = false;

	CString path_serch = m_szCurrentPath + _T("\\*.*");
	HANDLE hFirstFile = ::FindFirstFile(path_serch, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	



	// Искать все файлы апо указанному пути

	PDATA_FILE pDataFileDots = NULL;

	do
	{
		// изять с файла иконку

		SHFILEINFO shfi;
		memset(&shfi,0,sizeof(shfi));
		SHGetFileInfo(GetFullPath(m_szCurrentPath, findData.cFileName, b_prev),
		FILE_ATTRIBUTE_NORMAL,
		&shfi,
		sizeof(shfi), SHGFI_SMALLICON | SHGFI_ICON | SHGFI_SYSICONINDEX);
		::DestroyIcon(shfi.hIcon);
	
		// Если попадаем на точки предыдущей дирректории
		
		if((0 == lstrcmp(findData.cFileName, TEXT("."))) || (0 == lstrcmp(findData.cFileName, TEXT(".."))))
		{
			if((0 == lstrcmp(findData.cFileName, TEXT(".."))))	
			{
				pDataFileDots = new DATA_FILE;
				VERIFY(pDataFileDots);
				pDataFileDots->bDirectory = (findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
				char ch_name[255];
				sprintf(ch_name, "[%s]", findData.cFileName);
				pDataFileDots->szNameFile = ch_name;
				pDataFileDots->iSizeFile = 0;
				pDataFileDots->timeCreate =  findData.ftCreationTime;
				pDataFileDots->nIconFile = shfi.iIcon;
			}
			continue;
		}
	
		PDATA_FILE pDataFile = new DATA_FILE;
		VERIFY(pDataFile);
		
		pDataFile->bDirectory = (findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
		if(!pDataFile->bDirectory)
			pDataFile->szNameFile = findData.cFileName;
		else
		{
			char ch_name[255];
			sprintf(ch_name, "[%s]", findData.cFileName);
			pDataFile->szNameFile = ch_name;
		}
		
		union{unsigned int dwSize[2]; ULONGLONG ullData;} Size;
		Size.dwSize[0] = findData.nFileSizeLow;
		Size.dwSize[1] = findData.nFileSizeHigh;
		pDataFile->iSizeFile = Size.ullData;
		pDataFile->timeCreate = findData.ftCreationTime;
		pDataFile->nIconFile = shfi.iIcon;
		
		

		// добавить данные (каталоги вставлять вперед)
		if(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			files_list.push_front(pDataFile);
		else
			files_list.push_back(pDataFile);
	
	}
	while(::FindNextFile(hFirstFile, &findData));

	// если мы во вложенном каталоге
	
	if(pDataFileDots)
		files_list.push_front(pDataFileDots);
	
	::FindClose(hFirstFile);
	
	return true;
}

// Определить является ли файл дирректорией

BOOL CNRFileData::IsFileDirectory()
{
	CFileFind file_find;
	if(!file_find.FindFile(m_szCurrentPath + _T("*.*")))
		return FALSE;
	file_find.FindNextFile();
	return file_find.IsDirectory();
}

// Определить является ли файл предыдущей
// директорией ([.] or [..])

BOOL CNRFileData::IsFileDots()
{
	CFileFind file_find;
	if(!file_find.FindFile(m_szCurrentPath + _T("*.*")))
		return FALSE;
	file_find.FindNextFile();
	return file_find.IsDots();
}

// Является ли файл файлом данных

BOOL CNRFileData::IsFileNormal()
{
	CFileFind file_find;
	if(!file_find.FindFile(m_szCurrentPath + _T("*.*")))
		return FALSE;
	file_find.FindNextFile();
	return file_find.IsNormal();
}

// Проверить существование пути

BOOL CNRFileData::IsCurrentPathValid()
{
	CFileFind file_find;
	if(!file_find.FindFile(m_szCurrentPath + _T("*.*")))
		return FALSE;
	return TRUE;
}

// Удалить каталог рекурсивно

BOOL CNRFileData::RemoveDir(CString strPath, CRfmThreads *p_proc_thread)
{
	BOOL fRet = FALSE;
	if(strPath.IsEmpty()) return fRet;

    size_t tReplaceLen = 1;
    WIN32_FIND_DATA fd = {};

    // Формируем строку пути для поиска файлов
    std::basic_string< TCHAR > stPath(strPath);
    stPath += _T( "\\*");

    HANDLE hFind = FindFirstFile( stPath.c_str(), &fd);
    if( hFind != INVALID_HANDLE_VALUE)
    {
        fRet = TRUE;
        do 
		{	
			if(WaitForSingleObject(p_proc_thread->get_handle_stop(), 0) == WAIT_OBJECT_0)
			{
				::FindClose(hFind);
				return TRUE;
			}

			// Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
                fRet = RemoveDir( stPath.c_str(), p_proc_thread); // Удаляем все потроха найденного каталога
            else
            {
                // Обновление текстовки
				p_proc_thread->SetTextStatusDlg(stPath.c_str(), _T(""));
				p_proc_thread->UpdateProgress(1);
								
				
				// Просто удаляем найденный файл
                SetFileAttributes( stPath.c_str(), FILE_ATTRIBUTE_NORMAL);
                fRet = DeleteFile(stPath.c_str());
				if(!fRet)
					p_proc_thread->add_new_error("Ошибка удаления файла: " + (CString)stPath.c_str());
            }

        } while( fRet && FindNextFile( hFind, &fd));
        FindClose( hFind);

        // Заключительный момент - удалить пустой каталог...
        if(fRet) 
			fRet = RemoveDirectory(strPath);
		if(!fRet)
			p_proc_thread->add_new_error("Ошибка удаления каталога: " + strPath);
    }
    return fRet;
}


// Удалить файл или каталог

BOOL CNRFileData::DeleteFiles(CString str_path, CRfmThreads *p_proc_thread)
{
	WIN32_FIND_DATA findData;
		
	HANDLE hFirstFile = ::FindFirstFile(str_path, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return FALSE;
	
	// Если путь указан к файлу 

	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))	
	{
		::FindClose(hFirstFile);
		
		// Обновление текстовки
		p_proc_thread->SetTextStatusDlg(str_path, _T(""));
		p_proc_thread->UpdateProgress(1);
		SetFileAttributes(str_path, FILE_ATTRIBUTE_NORMAL);
		BOOL b_ret = ::DeleteFile(str_path);
		if(!b_ret)
			p_proc_thread->add_new_error("Ошибка удаления файла: " + str_path);
		return b_ret;
	}

	// Удалить все вложенные каталоги и файлы

	if(!RemoveDir(str_path, p_proc_thread)){
		::FindClose(hFirstFile);
		return FALSE;
	}

	::FindClose(hFirstFile);
	
	return TRUE;
}

// Определить размер каталога или файла

ULONGLONG CNRFileData::GetFileSizeOrDir(CString str_path, HWND& hWndProcess, HANDLE hEventStop)
{
	ULONGLONG iCommonSize = 0;

	WIN32_FIND_DATA findData;
		
	HANDLE hFirstFile = ::FindFirstFile(str_path, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return FALSE;
	
	// Если путь указан к файлу 

	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))	
	{
		// Определить размер одного файла	
	
		HANDLE hSizeFile = ::CreateFile(str_path, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		DWORD dwH = 0;
		iCommonSize = GetFileSize(hSizeFile, &dwH);
		iCommonSize |= (iCommonSize >> 4);
		::FindClose(hSizeFile);
		return iCommonSize;
	}

	// Удалить все вложенные каталоги и файлы

	iCommonSize = GetSizeDir(str_path, hWndProcess, hEventStop);

	::FindClose(hFirstFile);

	return iCommonSize; 
}





// Определить размер каталога

ULONGLONG CNRFileData::GetSizeDir(CString str_path, HWND& hWndProcess, HANDLE hEventStop)
{
	
	ULONGLONG iCommonSize = 0;
	
	if(str_path.IsEmpty()) return 0;

    size_t tReplaceLen = 1;
    WIN32_FIND_DATA fd = {};

    // Формируем строку пути для поиска файлов
    std::basic_string< TCHAR > stPath(str_path);
    stPath += _T( "\\*");

    HANDLE hFind = FindFirstFile( stPath.c_str(), &fd);
    if( hFind != INVALID_HANDLE_VALUE)
    {
         do 
		 {
			 if(WaitForSingleObject(hEventStop, 0) == WAIT_OBJECT_0)
			 {
				 FindClose(hFind);
				 return TRUE;   
			 }
			 
			 // Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
                iCommonSize += GetSizeDir(stPath.c_str(), hWndProcess, hEventStop); // Удаляем все потроха найденного каталога
				if(hWndProcess)
				{
					CString str;
					str.Format("%d [байт]", iCommonSize);

					WORD wItem1 = GlobalAddAtom("Вычисление размеров файлов...");
					WORD wItem2 = GlobalAddAtom(str.GetBuffer());
					if(!::PostMessage(hWndProcess, WM_UPDATE_TEST, wItem1, wItem2))
					{
						GlobalDeleteAtom(wItem1);
						GlobalDeleteAtom(wItem2);
					}
				}
			}
            else
            {
                // Определить размер одного файла	
	
				HANDLE hSizeFile = ::CreateFile(str_path + "\\" + fd.cFileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
				if(hSizeFile != INVALID_HANDLE_VALUE)
				{
					DWORD dwH = 0;
					ULONGLONG iSize = GetFileSize(hSizeFile, &dwH);
					iSize |= (dwH >> 4);
					::CloseHandle(hSizeFile);
					iCommonSize += iSize;
				}
            }

        } while(FindNextFile( hFind, &fd));
        FindClose( hFind);
    }
    return iCommonSize;
}

// Определить количество файлов в списке

UINT CNRFileData::get_count_files(array_path& arr_path_files)
{
	UINT i_count_file = 0;
	
	WIN32_FIND_DATA fd = {};

	for(int i=0; i < (int)arr_path_files.size(); i++)
	{
		HANDLE hFind = FindFirstFile(arr_path_files[i] + "\\*.*", &fd);
		if( hFind == INVALID_HANDLE_VALUE)
		{
			i_count_file++;
			FindClose( hFind);
			continue;
		}
		
		// Определить количество файлов в каталоге
	
		i_count_file += get_count_files_of_dir(arr_path_files[i]);	

		FindClose( hFind);
	}

	return i_count_file; 
}

// Определить количество файлов в каталоге

UINT CNRFileData::get_count_files_of_dir(CString path_dir)
{
	UINT iCommonSize = 0;
	
	if(path_dir.IsEmpty()) return 0;

    size_t tReplaceLen = 1;
    WIN32_FIND_DATA fd = {};

    // Формируем строку пути для поиска файлов
    std::basic_string< TCHAR > stPath(path_dir);
    stPath += _T( "\\*");

    HANDLE hFind = FindFirstFile( stPath.c_str(), &fd);
    if( hFind != INVALID_HANDLE_VALUE)
    {
         do 
		 {
			// Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
                iCommonSize += get_count_files_of_dir(stPath.c_str()); // Удаляем все потроха найденного каталога
			}
            else
            {
                iCommonSize ++;
            }

        } 
		while(FindNextFile( hFind, &fd));
        FindClose( hFind);
    }
    
	FindClose(hFind);
	
	return iCommonSize;
}




