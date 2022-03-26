// NRTabNetCtrl.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "NRFileDataAllNet.h"
#include "mainfrm.h"
#include <map>
#include "NRTabNetCtrl.h"
using namespace std;


extern UINT WM_LISTFILES_DBSEL;
extern UINT WM_DISCONNECT_SERVER;
extern UINT WM_UPDATE_PATH_COMMAND;
extern UINT WM_RENAME_FILE;
extern UINT WM_ITEM_SELECT;

// CNRTabNetCtrl
//m_arrNetWindows[indx]->i_current_pos_cursor

IMPLEMENT_DYNAMIC(CNRTabNetCtrl, CTabCtrl)

CNRTabNetCtrl::CNRTabNetCtrl(CDiscSelectDlg *pSelectDriveDlg) : 
	m_ListCtrlNet(&m_imgList)
{
	m_pSelectDriveDlg = pSelectDriveDlg;
	
	VERIFY(m_imgList.Create(16, 16, ILC_COLOR8, 0, 3));
	m_imgList.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICON_MOVEDIR)));
	m_imgList.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICON_DIR)));
	m_imgList.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICON_FILE)));
	VERIFY(m_img_list.Create(16, 16, ILC_COLOR32 | ILC_MASK, 2, 1));
	m_img_list.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICO_DRIVE_FIXED)));
	m_img_list.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICO_DRIVE_CDROM)));
	m_img_list.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(DRIVE_REMOVABLE)));
	m_img_list.Add(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICO_DRIVE_UNKNOWN)));
	m_i_ids_conn = 1000;
}

CNRTabNetCtrl::~CNRTabNetCtrl()
{
	// Удалить все соединения 
	
	int i = 0;

	for(i = 1; i < (int)m_arrNetWindows.size(); i++)
		DeleteNet(1, FALSE);

	for(i = 0; i < (int)m_imgList.GetImageCount(); i++)
		m_imgList.Remove(0);	
	for(i = 0; i < (int)m_img_list.GetImageCount(); i++)
		m_img_list.Remove(0);	
	
}


BEGIN_MESSAGE_MAP(CNRTabNetCtrl, CTabCtrl)
	ON_WM_SIZE()
	ON_WM_CREATE()
	ON_NOTIFY_REFLECT(TCN_SELCHANGE, &CNRTabNetCtrl::OnTcnSelchange)
	ON_REGISTERED_MESSAGE(WM_LISTFILES_DBSEL, &CNRTabNetCtrl::OnChangeCatalog)
	ON_REGISTERED_MESSAGE(WM_DISCONNECT_SERVER, &CNRTabNetCtrl::OnDisconnectServer)
	ON_REGISTERED_MESSAGE(WM_RENAME_FILE, &CNRTabNetCtrl::OnCommandRenameFile)
	ON_REGISTERED_MESSAGE(WM_ITEM_SELECT, &CNRTabNetCtrl::OnSelecItem)
	ON_MESSAGE(IDC_DISC_COMBO_LEFT, &CNRTabNetCtrl::OnSwichLocalDisc)
	ON_WM_SETFOCUS()
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////
// Подключение к серверу
/////////////////////////////////////////////////////////////////

BOOL CNRTabNetCtrl::ConnectToServer(c_TransportLevel *pRfmSocket, CString szServer, int port)
{
	VERIFY(pRfmSocket);
	
	if(!pRfmSocket->Connect(szServer, port))
	{
		CString err_str = "Невозможно подключиться к серверу [" +szServer+ "]!" + "\n" + "Убедитесь, что на клиентской машине установлена клиентская часть приложения";
		MessageBox(err_str, "ClientRFM", MB_OK | MB_ICONSTOP);
		return FALSE;
	}
	return TRUE; 
}

// Сздать первый таб (все подключения)

void CNRTabNetCtrl::CreateFirstTab()
{
	TCITEM tcItem;
	tcItem.mask = TCIF_TEXT;
	tcItem.pszText = "Все (общие файлы)";
	tcItem.iImage = 0;
	InsertItem(0, &tcItem);

	// Добавить структуру для всех подключений

	PNET_WINDOWS pNetWnd = new NET_WINDOWS;
	ASSERT(pNetWnd);

	m_arrNetWindows.push_back(pNetWnd);	
}


////////////////////////////////////////////////////////////////////
// Добавить новое соединение 
////////////////////////////////////////////////////////////////////

void CNRTabNetCtrl::AddNewConnect(CString strNameNet, UINT iPort)
{
	CString str;
	
	// Создать соединение с сервером

	c_TransportLevel *pNewSocket = new c_TransportLevel(GetSafeHwnd(), m_i_ids_conn);
	VERIFY(pNewSocket);
	pNewSocket->set_name_server(strNameNet);

	if(!ConnectToServer(pNewSocket, strNameNet, iPort))
	{
		pNewSocket->Disconnect();
		delete pNewSocket;
		return; 
	}
	
	PNET_WINDOWS pNetWnd = new NET_WINDOWS;
	ASSERT(pNetWnd);
	pNetWnd->pSrvConn = pNewSocket;
	
	// Добавить вкладку

	//str.Format("%s:%d", strNameNet, iPort);
	TCITEM tcItem;
	tcItem.mask = TCIF_TEXT | TCIF_IMAGE;
	tcItem.pszText = strNameNet.GetBuffer();
	tcItem.iImage = 0;
	InsertItem(GetItemCount(), &tcItem);
 			
	// Добавить подключение в список

	//m_ctrlListAllConnect.AddString(str);
	
	
	// Заполнить структуру первоначальными данными
		
	m_arrNetWindows.push_back(pNetWnd);	

	// Установить активный таб
	
	SetCurSel(GetItemCount()-1);

	// Установить активные данные
	
	SetActiveData(GetItemCount()-1);

	// Активизировать окна

	//m_ctrlListAllConnect.ShowWindow(SW_HIDE);
	//m_ListCtrlNet.ShowWindow(SW_SHOW);

	m_i_ids_conn++;

	Invalidate();
}

//////////////////////////////////////////////////////////////////////////////////
// Удалить указанное соединение
//////////////////////////////////////////////////////////////////////////////////


void CNRTabNetCtrl::DeleteNet(int indx_net, BOOL bUpdate /*= TRUE*/)
{
	if(indx_net >= (int)m_arrNetWindows.size() || indx_net == -1 || (bUpdate && !indx_net))
		return;
	
	if(indx_net == 1)
		int d = 0;
	
	// Удалить cписок путей

	m_arrNetWindows[indx_net]->arrPath.clear();

	// Отключится от сервера  
	
	if(m_arrNetWindows[indx_net]->pSrvConn != NULL)
	{
		bool bts = m_arrNetWindows[indx_net]->pSrvConn->Disconnect();
		delete m_arrNetWindows[indx_net]->pSrvConn;
		m_arrNetWindows[indx_net]->pSrvConn = NULL;
	}
	

	// Удалить структуру данных

	delete m_arrNetWindows[indx_net];

	m_arrNetWindows.erase(m_arrNetWindows.begin() + indx_net);
	
	if(!bUpdate) return; 

	// Удалить вкладку

	DeleteItem(indx_net);

	// Удалить запись в списке подключений

	if(GetItemCount()<2)
	{
		// Очистить все диски которые остались
		
		CWzComboBox *pWzComboBox = m_pSelectDriveDlg->GetNetCombo();	
		VERIFY(pWzComboBox);
		while(pWzComboBox->GetCount())
			pWzComboBox->DeleteCTString(0);

		// Старый список файлов

		m_ListCtrlNet.ClearAll();
		m_ListCtrlNet.SetItemCount(0);

		m_pSelectDriveDlg->SetPathLeft("");

		m_sz_curent_path = "";
		
		SetCurSel(0);

		return; // Уходим если все подключения снесены 
	}

	SetCurSel( ((GetItemCount() > 0) ? GetItemCount()-1 : 0) );

	// Загрузить последний таб

	SetActiveData( ((GetItemCount() > 0) ? GetItemCount()-1 : 0) );	

	
		

	Invalidate();

}


// Загрука данными о дисках списка по локальной системе

BOOL CNRTabNetCtrl::LoadDataDrivesLocal(CArrDrives *parrPath, CRfmSocketArr *pArrConnectObj, int indx)
{

	CNRFileDataAllNet	*pnr_net_file = NULL;
	CNRFileDataNet		one_file((*pArrConnectObj)[indx]);
	CNRFileDataAllNet	all_net_file(pArrConnectObj);
	if(!indx)
		pnr_net_file = &all_net_file;
	else
		pnr_net_file = (CNRFileDataAllNet*)&one_file;
	
	
	
	// Получить информацию о дисках в системе 	

	CListDrives list_drives;
	CString sz_err;

	if(!pnr_net_file->GetDiscList(list_drives, sz_err))
	{
		AfxMessageBox(sz_err);
		return FALSE;
	}

	// Вывести фильтрованную инфу
	
	CWzComboBox *pWzComboBox = m_pSelectDriveDlg->GetNetCombo();	
	VERIFY(pWzComboBox);

	// Проверить старый сбор дисков

	for(CArrDrives::iterator iter = parrPath->begin(); iter != parrPath->end(); iter++)
	{
		bool bFind = false;

		
		for(CListDrives::iterator iter_drives = list_drives.begin(); iter_drives != list_drives.end(); iter_drives++)
		{
			if((*iter).first == (*iter_drives)->szLetterDisc[0])
			{
				bFind = true;
				break;
			}
		}
		
		// Удалить путь если он не найден
		
		if(!bFind)
		{
			parrPath->erase(iter);
			iter = parrPath->begin();
		}
		
	}

	
	// Очистить все старые диски

	while(pWzComboBox->GetCount())
		pWzComboBox->DeleteCTString(0);
	
	
	
	// Загрузить новые диски
	
	for(CListDrives::iterator iter_drives = list_drives.begin(); iter_drives != list_drives.end(); iter_drives++)
	{
		CString szDisc = _T("");
		
		CString str_size;
		str_size.Format("[%.2f GB]", (*iter_drives)->d_free_space);

		if((*iter_drives)->iTypeDisc != DRIVE_CDROM)
		{
			PDATA_DISC data_disc = *iter_drives;
						
			CString s1 = (*iter_drives)->szLabel;
			CString s2 = (*iter_drives)->szFileSys;
			
			szDisc.Format(_T("[-%s-] %s %s " + str_size), (*iter_drives)->szLetterDisc, (*iter_drives)->szLabel, (*iter_drives)->szFileSys); 
		}
		else
			szDisc.Format(_T("[-%s-] CD-ROM " + str_size), (*iter_drives)->szLetterDisc);
		
	
		// Добавить иконку диска

		int indx_im = 3;

		
		if((*iter_drives)->iTypeDisc == DRIVE_FIXED)
			indx_im = 0;
		else
		if((*iter_drives)->iTypeDisc == DRIVE_CDROM)
			indx_im = 1;
		else
		if((*iter_drives)->iTypeDisc == DRIVE_REMOVABLE)
			indx_im = 2;
		else
			indx_im = 3;

		pWzComboBox->SetImageList(&m_img_list);
		int indx = pWzComboBox->AddCTString(-1, indx_im, szDisc);

//		int nTypeIcon = pWzComboBox->AddIcon(hIcon);;
//		char *pData = (char*)szDisc.GetBuffer();
		
		
		// Формировать новый массив путей по дискам
		
		CArrDrives::iterator iter = parrPath->find((*iter_drives)->szLetterDisc[0]);
		if(iter == parrPath->end())
		{
			PATH_DISC info;
			info.indxDisc = indx;
			info.szPath = (*iter_drives)->szLetterDisc + ":";
			info.indx_cursor_cur = 0;
			info.indx_cursor_prev = 0;
			typedef pair <char, PATH_DISC> Mgr_Pair;
			parrPath->insert(Mgr_Pair((*iter_drives)->szLetterDisc[0], info));

		}
		delete (*iter_drives);
		
	}
	
	list_drives.clear();


	return TRUE;
}


// Загрузить новые данные в список файлов
// szPathroot - путь к главному каталогу

BOOL CNRTabNetCtrl::LoadNewDataFile(CString szPathroot, CRfmSocketArr *pArrConnectObj, int indx)
{
	
	CNRFileDataAllNet *pnr_net_file = NULL;
	CNRFileDataNet		one_file((*pArrConnectObj)[indx]);
	CNRFileDataAllNet	all_net_file(pArrConnectObj);
	if(!indx)
		pnr_net_file = &all_net_file;
	else
		pnr_net_file = (CNRFileDataAllNet*)&one_file;
	
	
	//CListFiles files;
	//CNRFileDataNet net_file(pConnectObj);
	pnr_net_file->SetPathRoot(szPathroot);
	

	return m_ListCtrlNet.SetNewDataFiles((CNRFileData*)pnr_net_file, (indx==0) ? true : false );


}


// Обновить все по активному подкючению

void CNRTabNetCtrl::UpdateAllOnActive()
{
	CString szPathFind = "";
	
	// Вытянуть активное подключение
	
	int nActive = GetCurSel();
	if(nActive < 0) return;

	::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_WAIT)));
	
	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActive];
	if(!pNetWnd){
		::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));
		return;
	}

	
	CWzComboBox *pWzComboBox = m_pSelectDriveDlg->GetNetCombo();	
	if(!pWzComboBox){
		::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));
		return;
	}
	
	// Массив всех подключений

	CRfmSocketArr arr_connect;
	for(size_t i=0; i < m_arrNetWindows.size(); i++)
	{
		if(i==0 && m_arrNetWindows.size() > 1)
			m_arrNetWindows[0]->pSrvConn = m_arrNetWindows[i+1]->pSrvConn;
		arr_connect.push_back(m_arrNetWindows[i]->pSrvConn);
	}
	

	// Обновить диски
	
	if(!LoadDataDrivesLocal(&pNetWnd->arrPath, &arr_connect, nActive))
	{
		DeleteNet(nActive+1);
		::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));
		return;
	}
	
	// Вытянуть путь из текущего диска

	CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
	if(iter == pNetWnd->arrPath.end())
	{
		if(pNetWnd->arrPath.size())
		{
			iter = pNetWnd->arrPath.begin();
			pNetWnd->chCurrentDisc = (*iter).first;
			szPathFind = (*iter).second.szPath;
			pWzComboBox->SetCurSel((*iter).second.indxDisc);
		}
	}
	else
	{
		szPathFind = (*iter).second.szPath;
		int t = (*iter).second.indxDisc;  
		pWzComboBox->SetCurSel((*iter).second.indxDisc);
	}
	
	// Запросить файлы с сервера
	
	if(!LoadNewDataFile(szPathFind, &arr_connect, nActive))
	{
		// Пробуем поискать в корне текущего диска
		
		szPathFind = ((CString)pNetWnd->chCurrentDisc) + ":";
	
		if(!LoadNewDataFile(szPathFind, &arr_connect, nActive))
		{
			// Переходим на самый первый диск в его текущий путь
			
			iter = pNetWnd->arrPath.begin();
			pNetWnd->chCurrentDisc = (*iter).first;
			szPathFind = (*iter).second.szPath;
			pWzComboBox->SetCurSel((*iter).second.indxDisc);

			if(!LoadNewDataFile(szPathFind, &arr_connect, nActive))
			{
				szPathFind = pNetWnd->chCurrentDisc + ":";
				if(!LoadNewDataFile(szPathFind, &arr_connect, nActive))
				{
					::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));
					return;
				}
			}
			else
			{
				(*iter).second.szPath = szPathFind;
			}
		
		}
		else
		{
			(*iter).second.szPath = szPathFind;
			m_ListCtrlNet.SetCurrentIndx((*iter).second.GetPrevIndx());
			LoadNewDataFile(szPathFind, &arr_connect, nActive);
		}
	}
	
	int indx = m_ListCtrlNet.GetCurrentIndx();
	if(indx < 0 || indx >= m_ListCtrlNet.GetItemCount())
		m_ListCtrlNet.SetCurrentIndx(0);
	
	
	// Отобразить путь
	
	m_pSelectDriveDlg->SetPathLeft(szPathFind+"\\*.*");

	m_sz_curent_path = szPathFind;

	m_ListCtrlNet.SetCursorItem();	

	CMainFrame *pFrame = (CMainFrame*) GetParentFrame();
	VERIFY(pFrame);
	pFrame->PostMessage(WM_UPDATE_PATH_COMMAND);
	
	::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));	
}

void CNRTabNetCtrl::OnSize(UINT nType, int cx, int cy)
{
	if(!m_ListCtrlNet.m_hWnd)
		return;
	
	CRect rcItem;
	GetItemRect(0, rcItem);
	//if(GetCurSel())
		m_ListCtrlNet.SetWindowPos(NULL, -1, -2, cx, cy-rcItem.Height()-2, NULL);
	//else
		//m_ctrlListAllConnect.SetWindowPos(NULL, -1, -2, cx, cy-rcItem.Height()-2, NULL);

	CTabCtrl::OnSize(nType, cx, cy);
}

int CNRTabNetCtrl::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if(CTabCtrl::OnCreate(lpCreateStruct) == -1)
		return -1;

	// Создать необходимое окно отображения 
	// сетевых файлов
		
	CRect rcWnd = CRect(0, 0, 200, 200);
	m_ListCtrlNet.CreateEx(WS_EX_CLIENTEDGE, WS_CHILD | WS_VISIBLE | LVS_REPORT | LVS_EDITLABELS | LVS_OWNERDATA,
		rcWnd, this, AFX_IDW_DIALOGBAR+1001);
	
	
	
	// Список картинок для таба

	if (!m_tabImageList.Create(16, 16, ILC_COLOR8, 0, 2))
	{
	  ASSERT(false);
	}
	HICON hIcon = LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDI_ICO_CONNECT));
	m_tabImageList.Add(hIcon);
		

	SetImageList(&m_tabImageList);

	// Создать первый таб

	CreateFirstTab();

	// Просканировать коммандную строку клиента

	if(theApp.m_lpCmdLine[0] == '\0') return 0;
	char ch_one_command[MAX_PATH];
	int n_start = 0;
	bool b_run_command = false;

	for(int i=0; i < strlen(theApp.m_lpCmdLine)+1; i++)
	{
		if(theApp.m_lpCmdLine[i] == ' ' || theApp.m_lpCmdLine[i] == '\0')
		{
			memcpy(ch_one_command, theApp.m_lpCmdLine+n_start, i-n_start);
			ch_one_command[i-n_start] = '\0';	
			n_start	= i+1;
			b_run_command = true;
			AddNewConnect((CString)ch_one_command, DEFAULT_PORT_SERVER);
		}
	}
	if(!b_run_command)
		AddNewConnect((CString)ch_one_command, DEFAULT_PORT_SERVER);

	return 0;
}

void CNRTabNetCtrl::OnTcnSelchange(NMHDR *pNMHDR, LRESULT *pResult)
{
	// Установить активные данные
	
	SetActiveData(GetCurSel());
	
	*pResult = 0;
}


// Загрузить данные по соответствующему 
// сетевому окну

void CNRTabNetCtrl::SetActiveData(int indx)
{
	CWzComboBox *pWzComboBox = m_pSelectDriveDlg->GetNetCombo();	
	VERIFY(pWzComboBox);
	
	// Очистить все старые диски
	
	while(pWzComboBox->GetCount())
		pWzComboBox->DeleteCTString(0);
	
	SetCurSel(indx);
	
	// Установить курсор в новое окно
	if(m_ListCtrlNet.GetItemCount() <= m_arrNetWindows[indx]->i_current_pos_cursor || 
	   m_arrNetWindows[indx]->i_current_pos_cursor < 0)
		m_arrNetWindows[indx]->i_current_pos_cursor = 0;
	m_ListCtrlNet.SetCurrentIndx(m_arrNetWindows[indx]->i_current_pos_cursor);

	// Запросить все данные с сервера

	UpdateAllOnActive();	
}

//////////////////////////////////////////////////////////////
// Установить курсор
//////////////////////////////////////////////////////////////

void CNRTabNetCtrl::OnTabSetCursor()
{
	m_ListCtrlNet.SetFocus();
	m_ListCtrlNet.SetCursorItem();
}


// Переключение дисков на локальной машине

LRESULT CNRTabNetCtrl::OnSwichLocalDisc(WPARAM wp, LPARAM lp)
{
	if(GetCurSel() < 0)
		return FALSE;
	
	CWzComboBox *pWzComboBox = m_pSelectDriveDlg->GetNetCombo();	
	VERIFY(pWzComboBox);
	
	PNET_WINDOWS pCurrentWnd = m_arrNetWindows[GetCurSel()];	
	VERIFY(pCurrentWnd);

	for(CArrDrives::iterator iter = pCurrentWnd->arrPath.begin(); iter != pCurrentWnd->arrPath.end(); iter++)
	{
		if(pWzComboBox->GetCurSel() == (*iter).second.indxDisc)
		{
			pCurrentWnd->chCurrentDisc = (*iter).first;	
			// Обновить курсоры по выбранному диску
			m_ListCtrlNet.SetCurrentIndx((*iter).second.indx_cursor_cur);
			break;
		}
	}

	UpdateAllOnActive();

	return TRUE;
}


// Обработчик перехода по каталогам и запуска файлов

LRESULT CNRTabNetCtrl::OnChangeCatalog(WPARAM wp, LPARAM lp)
{
	int nIndx = (int)wp;	
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0 || nIndx < 0) 
	{
		return FALSE;
	}
	//nActiveConn--;

	CMainFrame *pFrame = (CMainFrame*) GetParentFrame();
	VERIFY(pFrame);


	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
	if(!pNetWnd){ 
		return FALSE;
	}
		
	CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
	if(iter == pNetWnd->arrPath.end()){
		return FALSE;
	}

	CString szCurPath = (*iter).second.szPath;
	
	CString szText = m_ListCtrlNet.GetItemText(nIndx, 0);
	CString dir = m_ListCtrlNet.GetItemText(nIndx, 1);
	if(dir != "<DIR>")
	{
		int res = MessageBox("Запустить файл на удаленной машине?", "ClientRFM", MB_YESNO | MB_ICONQUESTION);
		if(res == IDNO) return FALSE;

		// Дать команду запуска файла на сервере

		if(nActiveConn == 0)
		{
			for(size_t i=1; i < m_arrNetWindows.size(); i++)
			{
				CString sz_err;
				CNRFileDataNet file_net(m_arrNetWindows[i]->pSrvConn);
				file_net.execute_file_server(szCurPath + "\\" + szText, "", sz_err);
				//	AfxMessageBox(sz_err);
				//else
				//	MessageBox("Файл успешно запущен");
			}
		}
		else
		{
			CString sz_err;
			CNRFileDataNet file_net(pNetWnd->pSrvConn);
			file_net.execute_file_server(szCurPath += "\\" + szText, "", sz_err);
			//	AfxMessageBox(sz_err);
			//else
			//	MessageBox("Файл успешно запущен");
		}
		
		return FALSE;
	}
	
	// Удалить лишние скобки

	szText.Delete(0);
	szText.Delete(szText.GetLength()-1);

	// Заменить путь по текущему диску

	PATH_DISC info_new;
	
	szCurPath += "\\";
	szCurPath += szText;
	bool b_prev = false;
	(*iter).second.szPath = CNRFileDataNet::GetFullPath(szCurPath, "", b_prev);
	
	if(b_prev)
		m_ListCtrlNet.SetCurrentIndx((*iter).second.GetPrevIndx());
	else
	{
		(*iter).second.SetPrevIndx(m_ListCtrlNet.GetCurrentIndx());
		m_ListCtrlNet.SetCurrentIndx(0);
	}

	// Обновить удаленную сторону
	UpdateAllOnActive();

	return TRUE;
}

// Создать каталог на сервере

void CNRTabNetCtrl::OnCreateDir(CString szName)
{
	CString sz_err;
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return;
	//nActiveConn--;

	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
	if(!pNetWnd) return;	
	
	
	if(nActiveConn == 0)
	{
		for(size_t i=1; i < m_arrNetWindows.size(); i++)
		{
			CNRFileDataNet file_net(m_arrNetWindows[i]->pSrvConn);
			CArrDrives::iterator iter = pNetWnd->arrPath.find(m_arrNetWindows[0]->chCurrentDisc);
			if(iter == pNetWnd->arrPath.end())
			{
				AfxMessageBox("Невозможно создать каталог!");
				return;
			}
			
			file_net.SetPathRoot((*iter).second.szPath);
			if(!file_net.create_dir(szName, sz_err))
			{
				AfxMessageBox(sz_err);
			}
		}
	}
	else
	{
		CNRFileDataNet file_net(pNetWnd->pSrvConn);
		CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
		if(iter == pNetWnd->arrPath.end())
		{
			AfxMessageBox("Невозможно создать каталог!");
			return;
		}
		
		file_net.SetPathRoot((*iter).second.szPath);
		if(!file_net.create_dir(szName, sz_err))
		{
			AfxMessageBox(sz_err);
		}
	}

	UpdateAllOnActive();
}

// Копировать файлы на сервер

void CNRTabNetCtrl::CopyFileToServer(vector<CString> arrPath)
{
	CString sz_err;
	CRfmThreads rfm_thread;
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return;
	//nActiveConn--;



	if(!nActiveConn)
	{
		for(size_t i=1; i < m_arrNetWindows.size(); i++)	
		{
			CArrDrives::iterator iter = m_arrNetWindows[0]->arrPath.find(m_arrNetWindows[0]->chCurrentDisc);
			if(iter == m_arrNetWindows[0]->arrPath.end())
			{
				AfxMessageBox("Невозможно скопировать файл!");
				return;
			}
		
			CString  sz_path_server = (*iter).second.szPath;
		
			// Запусить поток копирования файлов на один сервер	
			
			rfm_thread.copy_files_to_server(sz_path_server, arrPath, (CRfmClientSocket*)m_arrNetWindows[i]->pSrvConn);
		
			if(!rfm_thread.get_flag_global_stop() || !m_arrNetWindows[i]->pSrvConn->is_connected())
				break;
		}
	}
	else
	{
		PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
		if(!pNetWnd) 
		{
			return;	
		}
		
		CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
		if(iter == pNetWnd->arrPath.end())
		{
			AfxMessageBox("Невозможно скопировать файл!");
			return;
		}
		
		CString  sz_path_server = (*iter).second.szPath;
		
		// Запусить поток копирования файлов на сервер	
		
		rfm_thread.copy_files_to_server(sz_path_server, arrPath, (CRfmClientSocket*)pNetWnd->pSrvConn);
	}

	UpdateAllOnActive();

	// Переустановить курсор

	CMainFrame *pFrame = (CMainFrame*) GetParentFrame();
	VERIFY(pFrame);
	pFrame->PostMessage(WM_COMMAND, ID_ACCEL_TAB, 0);

}

// Копировать файлы с сервера

void CNRTabNetCtrl::CopyFileFromServer(CString sz_local_path)
{
	
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0)
	{
		return;
	}
	//nActiveConn--;
	array_path_ident arr_path_ident, arr_path_ident_local;
	path_ident st_path_ident, st_path_ident_local;
	CRfmThreads rfm_thread;
	
	PNET_WINDOWS pNrtWnd = m_arrNetWindows[nActiveConn];
	if(!pNrtWnd)
	{
		return;
	}
	
	CString sz_err;
	
	// Определить текущий путь
		
	CArrDrives::iterator iter = pNrtWnd->arrPath.find(pNrtWnd->chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	szCurrentPath += "\\";
		
	// Выбрать необходимые пути копирования файлов
	
	POSITION nStartPos = m_ListCtrlNet.GetFirstSelectedItemPosition();

	while(nStartPos)
	{
		szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
					
		int nItem = m_ListCtrlNet.GetNextSelectedItem(nStartPos);
		
		CString szText = m_ListCtrlNet.GetItemText(nItem, 0);
		CString dir = m_ListCtrlNet.GetItemText(nItem, 1);
		if(dir != "<DIR>")
		{
			szCurrentPath += szText;		
			st_path_ident_local.sz_path = sz_local_path + "\\" + szText;
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = st_path_ident_local.b_dir = false;
			arr_path_ident.push_back(st_path_ident);
			arr_path_ident_local.push_back(st_path_ident_local);
		}
		else
		{
			if(szText == "[.]" || szText == "[..]")
				continue;

			szText.Delete(0);
			szText.Delete(szText.GetLength()-1);
			szCurrentPath += szText;		
			st_path_ident_local.sz_path = sz_local_path + "\\" + szText;
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = st_path_ident_local.b_dir = true;
			arr_path_ident.push_back(st_path_ident);
			arr_path_ident_local.push_back(st_path_ident_local);
		}		 
	}
	
	// Запустить поток копирования файлов с сервера

	rfm_thread.copy_files_from_server(arr_path_ident_local, arr_path_ident, pNrtWnd->pSrvConn);
	
}


// Переместить файлы на сервер

void CNRTabNetCtrl::MoveFileToServer(vector<CString> arrPath)
{
	CString sz_err;
	CRfmThreads rfm_thread;
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return;
	//nActiveConn--;


	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
	if(!pNetWnd){
		return;	
	}
	
	CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
	if(iter == pNetWnd->arrPath.end())
	{
		AfxMessageBox("Невозможно переместить файл!");
		return;
	}
	
	CString  sz_path_server = (*iter).second.szPath;
	
	// Запусить поток перемещения файлов на сервер	
	
	rfm_thread.move_files_to_server(sz_path_server, arrPath, (CRfmClientSocket*)pNetWnd->pSrvConn);

	UpdateAllOnActive();

	//CMainFrame *pFrame = (CMainFrame*) GetParentFrame();
	//VERIFY(pFrame);
	//pFrame->PostMessage(WM_COMMAND, ID_ACCEL_TAB, 0);
}

// Переместить файлы с сервера

void CNRTabNetCtrl::MoveFileFromServer(CString sz_local_path)
{
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return;
	//nActiveConn--;
	array_path_ident arr_path_ident, arr_path_ident_local;
	path_ident st_path_ident, st_path_ident_local;
	CRfmThreads rfm_thread;
	

	PNET_WINDOWS pNrtWnd = m_arrNetWindows[nActiveConn];
	if(!pNrtWnd){
		return;
	}
	
	CString sz_err;
	
	// Определить текущий путь
		
	CArrDrives::iterator iter = pNrtWnd->arrPath.find(pNrtWnd->chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	szCurrentPath += "\\";
		
	// Выбрать необходимые пути копирования файлов
	
	POSITION nStartPos = m_ListCtrlNet.GetFirstSelectedItemPosition();

	while(nStartPos)
	{
		szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
					
		int nItem = m_ListCtrlNet.GetNextSelectedItem(nStartPos);
		
		CString szText = m_ListCtrlNet.GetItemText(nItem, 0);
		CString dir = m_ListCtrlNet.GetItemText(nItem, 1);
		if(dir != "<DIR>")
		{
			szCurrentPath += szText;		
			st_path_ident_local.sz_path = sz_local_path + "\\" + szText;
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = st_path_ident_local.b_dir = false;
			arr_path_ident.push_back(st_path_ident);
			arr_path_ident_local.push_back(st_path_ident_local);
		}
		else
		{
			if(szText == "[.]" || szText == "[..]")
				continue;

			szText.Delete(0);
			szText.Delete(szText.GetLength()-1);
			szCurrentPath += szText;		
			st_path_ident_local.sz_path = sz_local_path + "\\" + szText;
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = st_path_ident_local.b_dir = true;
			arr_path_ident.push_back(st_path_ident);
			arr_path_ident_local.push_back(st_path_ident_local);
		}		 
	}
	
	// Запустить поток копирования файлов с сервера

	rfm_thread.move_files_from_server(arr_path_ident_local, arr_path_ident, pNrtWnd->pSrvConn);
	


	UpdateAllOnActive();
}


// Удаление файлов на сервере

void CNRTabNetCtrl::OnDeleteFiles()
{
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return;
	//nActiveConn--;
	
	array_path_ident arr_path_ident;
	path_ident st_path_ident;
	CRfmThreads rfm_thread;

	

	PNET_WINDOWS pNrtWnd = m_arrNetWindows[nActiveConn];
	if(!pNrtWnd) return;
	
	CString sz_err;
	
	// Определить текущий путь
		
	CArrDrives::iterator iter = pNrtWnd->arrPath.find(pNrtWnd->chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	szCurrentPath += "\\";
	
	if(MessageBox("Удалить выбранные файлы?", "ClientRFM", MB_YESNO | MB_ICONQUESTION) != IDYES)
		return;

	// Выбрать необходимые пути удаления файлов
	
	POSITION nStartPos = m_ListCtrlNet.GetFirstSelectedItemPosition();


	while(nStartPos)
	{
		szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
					
		int nItem = m_ListCtrlNet.GetNextSelectedItem(nStartPos);
		
		CString szText = m_ListCtrlNet.GetItemText(nItem, 0);
		CString dir = m_ListCtrlNet.GetItemText(nItem, 1);
		if(dir != "<DIR>")
		{
			szCurrentPath += szText;		
			
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = false;
			arr_path_ident.push_back(st_path_ident);
			
		}
		else
		{
			if(szText == "[.]" || szText == "[..]")
				continue;

			szText.Delete(0);
			szText.Delete(szText.GetLength()-1);
			szCurrentPath += szText;		
			
			st_path_ident.sz_path = szCurrentPath;
			st_path_ident.b_dir = true;
			arr_path_ident.push_back(st_path_ident);
		}		 
	}

	// Запустить поток удаления файлов на сервере
	
	if(!nActiveConn)
	{
		for(size_t i=1; i < m_arrNetWindows.size(); i++)	
		{
			rfm_thread.delete_server_files(arr_path_ident, m_arrNetWindows[i]->pSrvConn);
		}
	}
	else
		rfm_thread.delete_server_files(arr_path_ident, pNrtWnd->pSrvConn);
	
	m_ListCtrlNet.SetCurrentIndx(0);

	
	UpdateAllOnActive();
}


// Пропадание связи с сервером
// wp - индекс подключения 

LRESULT CNRTabNetCtrl::OnDisconnectServer(WPARAM wp, LPARAM lp)
{
	UINT i_id_conn = (UINT)wp; 
	
	int ddd = m_arrNetWindows.size();

	// Ожидаем окончание текущей операции если она идет
	
	
	//AfxMessageBox("==###==");

	// Определить индекс соответствующего таба

	for(size_t i=1; i < m_arrNetWindows.size(); i++)
	{
		if(m_arrNetWindows[i]->pSrvConn)
		{
			if(i_id_conn == m_arrNetWindows[i]->pSrvConn->get_id_connected())
			{
				DeleteNet((int)i);
				return TRUE;
			}
		}
	}

	return TRUE;
}


// Команда переименования файла локально

LRESULT CNRTabNetCtrl::OnCommandRenameFile(WPARAM wp, LPARAM lp)
{
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return TRUE;
	
	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
	if(!pNetWnd) return FALSE;
		
	CArrDrives::iterator iter = pNetWnd->arrPath.find(pNetWnd->chCurrentDisc);
	if(iter == pNetWnd->arrPath.end())
		return FALSE;

	CString szCurPath = (*iter).second.szPath;
	CString sz_err;
	CReportErrorDlg report_errors_dlg;
	
	if(nActiveConn == 0)
	{
		for(size_t i=1; i < m_arrNetWindows.size(); i++)
		{
			CString sz_old_path = szCurPath + "\\" + (CString)(const char*)wp;
			CString sz_new_path = szCurPath + "\\" + (CString)(const char*)lp;
			CNRFileDataNet file_net(pNetWnd->pSrvConn);
			bool b_res = file_net.rename_file(sz_old_path, sz_new_path, sz_err);
			if(!b_res)
			{
				// Добавляем возникшую ошибку и идем дальше 
				
				CString str_err_full = "[" + pNetWnd->pSrvConn->get_name_server() + "] " + 
										sz_err + " " + sz_old_path;
				report_errors_dlg.add_new_error(str_err_full);	
			}
		
			// Показать ошибки переименования файла по серверам
			
			if(report_errors_dlg.get_count_errors())
				report_errors_dlg.DoModal();
		}
		UpdateAllOnActive();
	}
	else
	{
		CString sz_old_path = szCurPath + "\\" + (CString)(const char*)wp;
		CString sz_new_path = szCurPath + "\\" + (CString)(const char*)lp;
		CNRFileDataNet file_net(pNetWnd->pSrvConn);
		bool b_res = file_net.rename_file(sz_old_path, sz_new_path, sz_err);
		if(!b_res)
			AfxMessageBox("Не удается переименовать указанный файл!");
		else
			UpdateAllOnActive();
	}
		
	return FALSE;
}
void CNRTabNetCtrl::OnSetFocus(CWnd* pOldWnd)
{
	CTabCtrl::OnSetFocus(pOldWnd);

	m_ListCtrlNet.SetFocus();
}


BOOL CNRTabNetCtrl::ExecuteFile(CString strPath, CString sz_dir, CString sz_params)
{
	CString sz_err;
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return FALSE;
	
	PNET_WINDOWS pNetWnd = m_arrNetWindows[nActiveConn];
	if(!pNetWnd) return FALSE;	
	
	
	if(nActiveConn == 0)
	{
		for(size_t i=1; i < m_arrNetWindows.size(); i++)
		{
			CNRFileDataNet file_net(m_arrNetWindows[i]->pSrvConn);
			file_net.execute_file_server(strPath, sz_params, sz_err);
		}
	}
	else
	{
		CNRFileDataNet file_net(pNetWnd->pSrvConn);
		file_net.execute_file_server(strPath, sz_params, sz_err);
	}

	UpdateAllOnActive();
	
	return TRUE;
}


LRESULT CNRTabNetCtrl::OnSelecItem(WPARAM wp, LPARAM lp)
{
	int nActiveConn = GetCurSel();
	if(nActiveConn < 0) return TRUE;
	
	m_arrNetWindows[nActiveConn]->i_current_pos_cursor = (int)wp;

	return TRUE; 
}