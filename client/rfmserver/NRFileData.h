#pragma once
#include "commctrl.h"
#include "shellapi.h"
#include "RfmServerClient.h"
#include <deque>
using namespace std;

///////////////////////////////////////////////////////////////////////
// Описание данных одного файла
///////////////////////////////////////////////////////////////////////


class CDisableWOW64FSRedirection
{
          void *old_value;
  
  public:
          CDisableWOW64FSRedirection();
          ~CDisableWOW64FSRedirection();
};


typedef struct __DATA_FILE__
{
	std::string			szNameFile;				// Имя файла
	bool				bDirectory;				// Является ли файл директорией
	bool				bDots;					// Является ли предыдущим каталогом
	unsigned __int64	iSizeFile;				// Разбер файла в байтах
	FILETIME			timeCreate;				// Дата создания файла
}DATA_FILE, *PDATA_FILE;

// Обьявления данных о файлах по указанному пути

typedef deque<PDATA_FILE> CListFiles;


///////////////////////////////////////////////////////////////////////
// Описание данных одного найденого диска в системе
///////////////////////////////////////////////////////////////////////

typedef struct __DATA_DISC__
{
	std::string		szLetterDisc;			// Литерное  обозначение диска
	unsigned int	iTypeDisc;				// Тип диска
	std::string		szLabel;				// Метка тома;
	std::string 	szFileSys;				// Имя файловой системы
	double			d_free_space;			// Свободное место на диске
}DATA_DISC, *PDATA_DISC;

// Обьявления данных о дисках

typedef deque<PDATA_DISC> CListDrives;

///////////////////////////////////////////////////////////////////////
// класс		: CNRFileData
// Описание		: Предназначен для работы с файлами, и их данными
///////////////////////////////////////////////////////////////////////

class CNRFileData
{
public:
	CNRFileData(const char *szMainPath);
	~CNRFileData(void);
	// Получить данные по найденным файлам
	bool GetDataFiles(CListFiles& files_list); 
	// Определить полный путь к файлу
	static std::string GetFullPath(const char *strCatalog, const char *strFile);
	// Определить является ли файл дирректорией
	bool IsFileDirectory();
	// Удалить указанный файл или пустой каталог
	bool del_specif_file();
	// Создать каталог
	static bool CreateDir(const char *str_path);
	// Определить список дисков в системе
	// discList - массив информации о диске чистит вызывающий
	static void GetDiscList(CListDrives& discList);
	// Определить количество файлов в каталоге
	static UINT get_count_files_of_dir(std::string path_dir);
	// Проверить существование пути
	//bool IsCurrentPathValid();
	// Определить является ли файл предыдущей
	// директорией ([.] or [..])
	//bool IsFileDots();
	// Является ли файл файлом данных
	//bool IsFileNormal();
	// Определить список иконок файлов
	//void GetImageListFiles();
	// Определить список иконок файлов
	//static void GetImageListFiles(HIMAGELIST& imageFileList);
	// Удалить файл или каталог
	//static bool DeleteFiles(const char *str_path, HANDLE hThreadStop, CRfmServerClient *pConnCli);
	// Определить размер каталога или файла
	//static ULONGLONG GetFileSizeOrDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli);
	// Определить количество файлов в каталоге
	//static DWORD GetCountFilesDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli);
private:
	// Определить размер каталога
	//static ULONGLONG GetSizeDir(const char *str_path, HANDLE hEventStop, CRfmServerClient *pConnCli);
	// Удалить каталог рекурсивно
	//static bool RemoveDir(const char *strPath, HANDLE hThreadStop, CRfmServerClient *pConnCli);
	// определенному пути
	//CListFiles	m_listFiles;
	// Текущий путь к каталогу с которого выведем все файлы
	const char *m_szCurrentPath;
};
