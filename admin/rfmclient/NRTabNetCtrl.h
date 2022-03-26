#pragma once

#include "NRListCtrlNet.h"
#include "ProcessDlg.h"
#include "c_TransportLevel.h"
#include "NRFileDataAllNet.h"
#include "DiscSelectDlg.h"
#include <vector>
#include <map>
using namespace std;

// Обновление правосторонней панели
#define WM_UPDATE_LEFT_SIDE WM_USER + 5000;

typedef map<char, PATH_DISC> CArrDrives;

typedef struct __NET_WINDOWS__
{	
	__NET_WINDOWS__() : 
		chCurrentDisc('C'), pSrvConn(NULL), i_current_pos_cursor(0)
	{}
	// Массив текущих путей
	CArrDrives		 arrPath;	
	// Обьект соединения с сервером
	c_TransportLevel *pSrvConn;
	// Текущий выбранный диск
	char			  chCurrentDisc;
	// Позиция курсора для текущего окна
	int				  i_current_pos_cursor;	 
}NET_WINDOWS, *PNET_WINDOWS;

// Открытые соединения

typedef vector<PNET_WINDOWS> CArrTabWindows;



// CNRTabNetCtrl

class CNRTabNetCtrl : public CTabCtrl
{
	DECLARE_DYNAMIC(CNRTabNetCtrl)

public:
	CNRTabNetCtrl(CDiscSelectDlg *pSelectDriveDlg);
	virtual ~CNRTabNetCtrl();
	// Добавить новое соединение 
	void AddNewConnect(CString strNameNet, UINT iPort);
	// Удалить указанное соединение
	void DeleteNet(int indx_net, BOOL bUpdate = TRUE);
	CString get_current_path() const {return m_sz_curent_path.IsEmpty() ? "" : m_sz_curent_path + "\\";}
protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnSize(UINT nType, int cx, int cy);
	// становить курсор
	void OnTabSetCursor();
	// Обработчик перехода по каталогам и запуска файлов
	afx_msg LRESULT OnChangeCatalog(WPARAM wp, LPARAM lp);
	// Обработчик обновления локальной строны
	afx_msg LRESULT OnUpdateLocalSide(WPARAM wp, LPARAM lp);
	// Пропадание связи с сервером
	// wp - индекс подключения 
	afx_msg LRESULT OnDisconnectServer(WPARAM wp, LPARAM lp);
	// Позиция курсора
	//int m_nCursorItem;
	// Переключение дисков на локальной машине
	afx_msg LRESULT OnSwichLocalDisc(WPARAM wp, LPARAM lp);
	// Выбор элемента списка
	afx_msg LRESULT OnSelecItem(WPARAM wp, LPARAM lp);
	// Команда переименования файла
	afx_msg LRESULT OnCommandRenameFile(WPARAM wp, LPARAM lp);
	// Создать каталог на сервере
	void OnCreateDir(CString szName);
	// Копировать файлы на сервер
	void CopyFileToServer(vector<CString> arrPath);
	// Копировать файлы с сервера
	void CopyFileFromServer(CString sz_local_path);
	// Переместить файлы на сервер
	void MoveFileToServer(vector<CString> arrPath);
	// Переместить файлы с сервера
	void MoveFileFromServer(CString sz_local_path);
	HANDLE m_hThreadCopy;
	DWORD m_dwIDThreadCopy;
	// Удаление файло на сервере
	void OnDeleteFiles();
	// Обновить все по активному подкючению
	void UpdateAllOnActive();
	// Выполнить команду на сервере
	BOOL ExecuteFile(CString strPath, CString sz_dir, CString sz_params);
	CNRListCtrl *get_list_files(){return &m_ListCtrlNet;}
private:
	// Указатель на класс выбора дисков
	CDiscSelectDlg *m_pSelectDriveDlg;
	// Палитра иконок
	CImageList m_imgList;
	// Загрузить данные по соответствующему 
	// сетевому окну
	void SetActiveData(int indx);
	// Иконки для таб списка
	CImageList	m_tabImageList;
	// Основное окно для отображения файлов 
	CNRListCtrlNet	m_ListCtrlNet;
	// Массив сетевых функций 
	CArrTabWindows	m_arrNetWindows;
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnTcnSelchange(NMHDR *pNMHDR, LRESULT *pResult);
	// подключение к серверу
	BOOL ConnectToServer(c_TransportLevel *pRfmSocket, CString szServer, int port);
	// Загрука данными о дисках списка по локальной системе
	BOOL LoadDataDrivesLocal(CArrDrives *parrPath, CRfmSocketArr *pArrConnectObj, int indx);
	// Загрузить новые данные в список файлов
	// szPathroot - путь к главному каталогу
	BOOL LoadNewDataFile(CString szPathroot, CRfmSocketArr *pArrConnectObj, int indx);
	// Сздать первый таб (все подключения)
	void CreateFirstTab();
	// Счетчик идентификаторов подключений к серверу
	UINT m_i_ids_conn;
	// Текущий выбранный путь
	CString m_sz_curent_path;
	afx_msg void OnSetFocus(CWnd* pOldWnd);
	CImageList m_img_list;
};


