#pragma once

#include <deque>
using namespace std;

#include "RfmThreads.h"

class CRfmThreads;

typedef vector<CString> array_path; 


class CDisableWOW64FSRedirection
{
          void *old_value;
  
  public:
          CDisableWOW64FSRedirection();
          ~CDisableWOW64FSRedirection();
};



///////////////////////////////////////////////////////////////////////
// Описание данных одного файла
///////////////////////////////////////////////////////////////////////

typedef struct __DATA_FILE__
{
	CString		szNameFile;	// Имя файла
	BOOL		bDirectory;	// Является ли файл директорией
	BOOL		bDots;		// Является ли предыдущим каталогом
	ULONGLONG	iSizeFile;	// Разбер файла в байтах
	CTime		timeCreate;	// Дата создания файла
	int			nIconFile;	// Индекс иконки в системном списке 
}DATA_FILE, *PDATA_FILE;

// Обьявления данных о файлах по указанному пути

typedef deque<PDATA_FILE> CListFiles;


///////////////////////////////////////////////////////////////////////
// Описание данных одного найденого диска в системе
///////////////////////////////////////////////////////////////////////

typedef struct __DATA_DISC__
{
	CString		szLetterDisc;	// Литерное  обозначение диска
	UINT		iTypeDisc;		// Тип диска
	CString		szLabel;		// Метка тома;
	CString		szFileSys;		// Имя файловой системы
	int			nIconDisc;		// Иконка для найденного диска
	double		d_free_space;	// Свободное место на диске
}DATA_DISC, *PDATA_DISC;

// Обьявления данных о дисках

typedef deque<PDATA_DISC> CListDrives;

///////////////////////////////////////////////////////////////////////
// класс		: CNRFileData
// Описание		: Предназначен для работы с файлами, и их данными 
//				  на локальном компьютере	
///////////////////////////////////////////////////////////////////////

class CNRFileData
{
public:
	CNRFileData(CString szMainPath);
	virtual ~CNRFileData(void);
	// Получить данные по найденным файлам
	virtual bool GetDataFiles(CListFiles& files_list, CRfmThreads *p_proc_thread); 
	// Определить является ли файл дирректорией
	BOOL IsFileDirectory();
	// Проверить существование пути
	BOOL IsCurrentPathValid();
	// Определить является ли файл предыдущей
	// директорией ([.] or [..])
	BOOL IsFileDots();
	// Является ли файл файлом данных
	BOOL IsFileNormal();
	// Определить список иконок файлов
	void GetImageListFiles();
	// Определить список иконок файлов
	static void GetImageListFiles(CImageList& imageFileList);
	// Определить список дисков в системе
	// discList - массив информации о диске чистит вызывающий
	static void GetDiscList(CListDrives& discList);
	// Определить полный путь к файлу
	static CString GetFullPath(CString strCatalog, CString strFile, bool& b_prev_dir);
	// Удалить файл или каталог
	static BOOL DeleteFiles(CString str_path, CRfmThreads *p_proc_thread);
	// Определить размер каталога или файла
	static ULONGLONG GetFileSizeOrDir(CString str_path, HWND& hWndProcess, HANDLE hEventStop); 
	// Определить количество файлов в списке
	UINT get_count_files(array_path& arr_path_files); 
private:
	// Определить количество файлов в каталоге
	UINT get_count_files_of_dir(CString path_dir); 
	// Определить размер каталога
	static ULONGLONG GetSizeDir(CString str_path, HWND& hWndProcess, HANDLE hEventStop);
	// Удалить каталог рекурсивно
	static BOOL RemoveDir(CString strPath, CRfmThreads *p_proc_thread);
	// определенному пути
	//CListFiles	m_listFiles;
	// Текущий путь к каталогу с которого выведем все файлы
	CString m_szCurrentPath;
};
