#include "StdAfx.h"
#include "NRFileData.h"
#include <direct.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>



//#pragma warning(disable : 4996)
//#pragma warning(disable : 4800)

// Максимальное количество дисков в системе
#define MAX_COUNT_DRIVES 26



CDisableWOW64FSRedirection::CDisableWOW64FSRedirection()
{
  old_value = NULL;
  
  BOOL (WINAPI *pWow64DisableWow64FsRedirection)(PVOID *OldValue);
  *(void**)&pWow64DisableWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64DisableWow64FsRedirection");

  if ( pWow64DisableWow64FsRedirection )
     {
       pWow64DisableWow64FsRedirection(&old_value);
     }
}


CDisableWOW64FSRedirection::~CDisableWOW64FSRedirection()
{
  BOOL (WINAPI *pWow64RevertWow64FsRedirection)(PVOID OlValue);
  *(void**)&pWow64RevertWow64FsRedirection = (void*)GetProcAddress(GetModuleHandle("kernel32.dll"),"Wow64RevertWow64FsRedirection");

  if ( pWow64RevertWow64FsRedirection )
     {
       pWow64RevertWow64FsRedirection(old_value);
     }
}




CNRFileData::CNRFileData(const char *szMainPath)
{
	m_szCurrentPath = szMainPath;
}

CNRFileData::~CNRFileData(void)
{
}

// Определить список дисков в системе
// discList - массив информации о диске чистит вызывающий

void CNRFileData::GetDiscList(CListDrives& discList)
{
	// Определить битовую маску для логических дисков
	
	DWORD dr = GetLogicalDrives(); 

	for(int x = 0; x < MAX_COUNT_DRIVES; x++)
	{
		std::string str_tmp;
		
		// Получить литеру диска
		
		str_tmp.push_back(((char)(65+x)));
		
		// Для теста (Потом перемотреть)
		if(!str_tmp.compare("A")) continue;	
		

		char targetpath[256];
		str_tmp.push_back(':');
		
		DWORD ret = QueryDosDevice(str_tmp.c_str(), targetpath, sizeof(targetpath)); 


		if(ret || ret == ERROR_INSUFFICIENT_BUFFER)
		{
			PDATA_DISC pDataDisc = new DATA_DISC;
			if(!pDataDisc) throw;
				
			pDataDisc->szLetterDisc.push_back(str_tmp[0]);
			
			// Определить тип диска
			std::string str_path_dr = pDataDisc->szLetterDisc;
			str_path_dr += ":\\";
			pDataDisc->iTypeDisc = GetDriveType(str_path_dr.c_str());

			// Получить метку диска и имя файловой системы
			
			char	drive_label[30];
			char	drive_fat[30];
			DWORD	drive_sn;
			DWORD	drive_name_size = sizeof(drive_label);

			memset(drive_label, 0, 30);
			memset(drive_fat, 0, 30);

			GetVolumeInformation(str_path_dr.c_str(),
								 drive_label,
								 sizeof(drive_label),
								 &drive_sn,
								 &drive_name_size,
								 NULL,
								 drive_fat,
								 sizeof(drive_fat));

			pDataDisc->szLabel += (const char*)drive_label;
			pDataDisc->szFileSys += (const char*)drive_fat;
		
			// Опредеить свободное место на диске в GB
			
			if(pDataDisc->iTypeDisc != DRIVE_CDROM)
			{
				ULARGE_INTEGER i_FreeBytesAvailable, i_TotalNumberOfBytes, i_TotalNumberOfFreeBytes;

				GetDiskFreeSpaceEx(str_path_dr.c_str(), 
									  &i_FreeBytesAvailable, 
									  &i_TotalNumberOfBytes, 
									  &i_TotalNumberOfFreeBytes);
	  			
				pDataDisc->d_free_space = (double)i_FreeBytesAvailable.QuadPart / 1000000000;
			}
			else
			{
				pDataDisc->d_free_space = 0.0;
			}

			discList.push_back(pDataDisc);
		}
	}
}

// Определить полный путь к файлу

std::string CNRFileData::GetFullPath(const char *strCatalog, const char *strFile)
{
	std::string szFullPath = strCatalog;
	
	size_t indx_dots = szFullPath.find("..");
	if(indx_dots != -1)
	{
		szFullPath.replace(indx_dots-2, 4, "");
		for(size_t i=szFullPath.size()-1; i > -1; i--)
		{
			if(szFullPath[i] == '\\')
				break;
			szFullPath.erase(i);
		}
		if(!strlen(strFile))
			szFullPath += strFile;
		else
			szFullPath.erase(szFullPath.size()-1);
	}
	else
	if(strlen(strFile))
	{
		szFullPath += "\\";
		szFullPath += strFile;
	}
	
	return szFullPath;

}


// Определить все файлы в указанном каталоге
// Загружает текущий массив m_listFiles

// Получить данные по найденным файлам

bool CNRFileData::GetDataFiles(CListFiles& files_list) 
{
	WIN32_FIND_DATA findData;

	std::string path_serch = m_szCurrentPath;
	path_serch += "\\*.*";

	HANDLE hFirstFile = ::FindFirstFile(path_serch.c_str(), &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	

	// Искать все файлы апо указанному пути

	PDATA_FILE pDataFileDots = NULL;

	do
	{
		// Если попадаем на точки предыдущей дирректории
		
		if((0 == lstrcmp(findData.cFileName, TEXT("."))) || (0 == lstrcmp(findData.cFileName, TEXT(".."))))
		{
			if((0 == lstrcmp(findData.cFileName, TEXT(".."))))	
			{
				pDataFileDots = new DATA_FILE;
				if(!pDataFileDots) throw;
				pDataFileDots->bDirectory = (findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0 ? true : false;
				char ch_name[255];
				sprintf(ch_name, "[%s]", findData.cFileName);
				pDataFileDots->szNameFile = ch_name;
				pDataFileDots->iSizeFile = 0;
				pDataFileDots->timeCreate =  findData.ftCreationTime;
				pDataFileDots->bDots = true;
			}
			continue;
		}
	
		PDATA_FILE pDataFile = new DATA_FILE;
		if(!pDataFile) throw;
		
		pDataFile->bDirectory = (findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0 ? true : false;
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
		pDataFile->bDots = false;
		
		

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

bool CNRFileData::IsFileDirectory()
{
	WIN32_FIND_DATA findData;
		
	std::string path_serch = m_szCurrentPath;
	path_serch += "*.*";

	HANDLE hFirstFile = ::FindFirstFile(path_serch.c_str(), &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	
	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)){
		::FindClose(hFirstFile);
		return false; 
	}

	::FindClose(hFirstFile);
	return true;
}

// Удалить указанный файл или пустой каталог

bool CNRFileData::del_specif_file()
{
	SetFileAttributes(m_szCurrentPath, FILE_ATTRIBUTE_NORMAL);
	
	if(IsFileDirectory())
		return (bool)::RemoveDirectory(m_szCurrentPath);
	else
		return (bool)::DeleteFile(m_szCurrentPath);

	return false;
}


// Создать каталог

bool CNRFileData::CreateDir(const char *str_path)
{
	if(mkdir(str_path) == ENOENT)
		return false;
	
	return true;
}

// Определить количество файлов в каталоге

UINT CNRFileData::get_count_files_of_dir(std::string path_dir)
{
	UINT iCommonSize = 0;
	
	if(path_dir.empty()) return 0;

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
    return iCommonSize;
}


/*
// Определить список иконок файлов

void CNRFileData::GetImageListFiles(HIMAGELIST& imageFileList)
{
	SHFILEINFO shfi;
	memset(&shfi,0,sizeof(shfi));
	imageFileList = (HIMAGELIST)SHGetFileInfo(_T("C:\\"),
	FILE_ATTRIBUTE_NORMAL,
	&shfi,
	sizeof(shfi), SHGFI_SMALLICON | SHGFI_ICON | SHGFI_SYSICONINDEX);
}








// Определить является ли файл предыдущей
// директорией ([.] or [..])

bool CNRFileData::IsFileDots()
{
	WIN32_FIND_DATA findData;
		
	std::string path_serch = m_szCurrentPath;
	path_serch += "*.*";

	HANDLE hFirstFile = ::FindFirstFile(path_serch.c_str(), &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	
	if((0 == lstrcmp(findData.cFileName, TEXT("."))) || (0 == lstrcmp(findData.cFileName, TEXT("..")))){
		::FindClose(hFirstFile);
		return true; 
	}

	::FindClose(hFirstFile);

	return false;
	
}

// Является ли файл файлом данных

bool CNRFileData::IsFileNormal()
{
	WIN32_FIND_DATA findData;
		
	std::string path_serch = m_szCurrentPath;
	path_serch += "*.*";

	HANDLE hFirstFile = ::FindFirstFile(path_serch.c_str(), &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	
	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_NORMAL)){
		::FindClose(hFirstFile);
		return false; 
	}

	::FindClose(hFirstFile);
	return true;
}

// Проверить существование пути

bool CNRFileData::IsCurrentPathValid()
{
	WIN32_FIND_DATA findData;
		
	std::string path_serch = m_szCurrentPath;
	path_serch += "*.*";

	HANDLE hFirstFile = ::FindFirstFile(path_serch.c_str(), &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return false;
	
	::FindClose(hFirstFile);
	
	return true;
}

// Удалить каталог рекурсивно

bool CNRFileData::RemoveDir(const char *strPath, HANDLE hThreadStop, CRfmServerClient *pConnCli)
{
	char ch_tmp[MAX_PATH];
	bool fRet = FALSE;
	if(!strlen(strPath)) return fRet;
	CRfmProtocol::Packet OutPacket;

    size_t tReplaceLen = 1;
    WIN32_FIND_DATA fd = {};

    // Формируем строку пути для поиска файлов
    std::basic_string< TCHAR > stPath(strPath);
    stPath += _T( "\\*");

    HANDLE hFind = FindFirstFile( stPath.c_str(), &fd);
    if( hFind != INVALID_HANDLE_VALUE)
    {
        fRet = TRUE;
        do {
            // Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
                fRet = RemoveDir(stPath.c_str(), hThreadStop, pConnCli); // Удаляем все потроха найденного каталога
            else
            {
                // Отправить пакет статуса на сервер
				
				//HANDLE hSizeFile = ::CreateFile(stPath.c_str(), GENERIC_READ, 0, NULL, OPEN_EXISTING,
				//		FILE_ATTRIBUTE_NORMAL, NULL);
				//if(hSizeFile != INVALID_HANDLE_VALUE)
				//{
					
					//ULONGLONG uLen = (ULONGLONG)::GetFileSize(hSizeFile, &dwHight);
					//uLen |= (dwHight >> 4);			
					pConnCli->m_uCommonLength ++;

					if((GetTickCount() - pConnCli->m_iOldCountTime) > 500)
					{
						DWORD dwLow = (DWORD)pConnCli->m_uCommonLength; 
						DWORD dwHight = 0; 

						// Отправить статус удаления клиенту
						
						std::string szPack;
						szPack.push_back(ID_STATUS_PROCESS);
						szPack.push_back(0x4);
						szPack += stPath;
						szPack.push_back(0x4);
						char *pData = itoa(dwLow, ch_tmp, 10);
						szPack += pData;
						szPack.push_back(0x4);
						pData = itoa(dwHight, ch_tmp, 10);
						szPack += pData;
						szPack.push_back(0x4);

						OutPacket.Status = CRfmProtocol::TS_OK;
						OutPacket.nFunctionCode = CRfmProtocol::TC_SVR_DELETE_FILE;
						pConnCli->SetPacketBuffer(OutPacket, szPack.c_str(), (int)szPack.size());
						bool ret = pConnCli->Send(OutPacket);
						pConnCli->m_iOldCountTime = GetTickCount();
					}
				//	::CloseHandle(hSizeFile);
				//}
			
				
				// Просто удаляем найденный файл
                
				if( fd.dwFileAttributes & FILE_ATTRIBUTE_READONLY)
                    SetFileAttributes( stPath.c_str(), FILE_ATTRIBUTE_NORMAL);
                
				if(!DeleteFile(stPath.c_str()))
				{
					// Фиксить ошибку
				}
			}

        } while( fRet && FindNextFile( hFind, &fd));
        FindClose( hFind);

        // Заключительный момент - удалить пустой каталог...
        if(fRet) fRet = RemoveDirectory(strPath);
    }
    return fRet;
}


// Удалить файл или каталог

bool CNRFileData::DeleteFiles(const char *str_path, HANDLE hThreadStop, CRfmServerClient *pConnCli)
{
	WIN32_FIND_DATA findData;
	char ch_tmp[MAX_PATH];
	CRfmProtocol::Packet OutPacket; 


	HANDLE hFirstFile = ::FindFirstFile(str_path, &findData);
	if(hFirstFile == INVALID_HANDLE_VALUE)
		return FALSE;
	
	// Если путь указан к файлу 

	if(!(findData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))	
	{
		::FindClose(hFirstFile);
		
		// Отправить статус на сервер
		if((GetTickCount() - pConnCli->m_iOldCountTime) > 500)
		{
			DWORD dwLow = (DWORD)pConnCli->m_uCommonLength; 
			DWORD dwHight = 0; 

			// Отправить статус удаления клиенту
			
			std::string szPack;
			szPack.push_back(ID_STATUS_PROCESS);
			szPack.push_back(0x4);
			szPack += str_path;
			szPack.push_back(0x4);
			char *pData = itoa(dwLow, ch_tmp, 10);
			szPack += pData;
			szPack.push_back(0x4);
			pData = itoa(dwHight, ch_tmp, 10);
			szPack += pData;
			szPack.push_back(0x4);

			OutPacket.Status = CRfmProtocol::TS_OK;
			OutPacket.nFunctionCode = CRfmProtocol::TC_SVR_DELETE_FILE;
			pConnCli->SetPacketBuffer(OutPacket, szPack.c_str(), (int)szPack.size());
			bool ret = pConnCli->Send(OutPacket);
			pConnCli->m_iOldCountTime = GetTickCount();
		}
		
		return ::DeleteFile(str_path);
	}

	// Удалить все вложенные каталоги и файлы

	if(!RemoveDir(str_path, hThreadStop, pConnCli)){
		::FindClose(hFirstFile);
		return FALSE;
	}

	::FindClose(hFirstFile);
	
	return true;
}




// Определить размер каталога или файла

ULONGLONG CNRFileData::GetFileSizeOrDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli)
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
		::CloseHandle(hSizeFile);
		return iCommonSize;
	}

	// Удалить все вложенные каталоги и файлы

	iCommonSize = GetSizeDir(str_path, hEventStop, pConnCli);

	::FindClose(hFirstFile);

	return iCommonSize; 
}



// Определить количество файлов в каталоге

DWORD CNRFileData::GetCountFilesDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli)
{
	DWORD iCommonCount = 0;
	char ch_tmp[MAX_PATH];
	CRfmProtocol::Packet OutPacket; 

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
				return TRUE;   
			 
			 // Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
				iCommonCount += GetCountFilesDir(stPath.c_str(), hEventStop, pConnCli); // Удаляем все потроха найденного каталога
				
				if((GetTickCount() - pConnCli->m_iOldCountTime) > 1000)
				{
					pConnCli->m_iOldCountTime = GetTickCount();
					
					std::string szPack;
					szPack.push_back(ID_STATUS_CALC_COUNT);
					szPack.push_back(0x4);
					char *pData = _i64toa(iCommonCount, ch_tmp, 10);
					szPack += pData;
					szPack.push_back(0x4);
					
					OutPacket.nFunctionCode = CRfmProtocol::TC_SVR_DELETE_FILE;
					pConnCli->SetPacketBuffer(OutPacket, szPack.c_str(), (int)szPack.size());
					pConnCli->Send(OutPacket);
					
				}
			}
            else
            {
                iCommonCount ++;
	        }

        } while(FindNextFile( hFind, &fd));
        FindClose( hFind);
    }
    return iCommonCount;
}


// Определить размер каталога

ULONGLONG CNRFileData::GetSizeDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli)
{
	ULONGLONG iCommonSize = 0;
	char ch_tmp[MAX_PATH];
	CRfmProtocol::Packet OutPacket; 

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
				return TRUE;   
			 
			 // Игнорируем вхождения в каталог
            if( !(_tcscmp( fd.cFileName, _T( ".")) && _tcscmp( fd.cFileName, _T( ".."))) )
                continue;

            // Формруем полный путь к файлу/каталогу
            stPath.replace( stPath.end() - tReplaceLen, stPath.end(), fd.cFileName);
            tReplaceLen = _tcslen( fd.cFileName); // Прикапываем для следующего replace

            if( fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			{
				iCommonSize += GetSizeDir(stPath.c_str(), hEventStop, pConnCli); // Удаляем все потроха найденного каталога
				
				if((GetTickCount() - pConnCli->m_iOldCountTime) > 1000)
				{
					pConnCli->m_iOldCountTime = GetTickCount();
					
					std::string szPack;
					szPack.push_back(ID_STATUS_CALC_SIZE);
					szPack.push_back(0x4);
					char *pData = _i64toa(iCommonSize, ch_tmp, 10);
					szPack += pData;
					szPack.push_back(0x4);
					
					OutPacket.nFunctionCode = CRfmProtocol::TC_SVR_DELETE_FILE;
					pConnCli->SetPacketBuffer(OutPacket, szPack.c_str(), (int)szPack.size());
					pConnCli->Send(OutPacket);
					
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

*/