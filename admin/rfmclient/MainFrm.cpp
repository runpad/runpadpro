// MainFrm.cpp : implementation of the CMainFrame class
//

#include "stdafx.h"
#include "rfmclient.h"
#include "NRFileData.h"
#include "MainFrm.h"
#include "ConnectDlg.h"
#include "CreateFileDlg.h"
#include <direct.h>
#include "PreviewWnd.h"
#include "RfmThreads.h"

extern UINT WM_LISTFILES_DBSEL;
extern UINT WM_SET_LIST_CURSOR;
extern UINT WM_ENTER_KEY;
extern UINT WM_RENAME_FILE;
UINT WM_UPDATE_PATH_COMMAND = RegisterWindowMessage("Update path command left"); 

#pragma warning(disable : 4996)


#ifdef _DEBUG
#define new DEBUG_NEW
#endif



// CMainFrame

IMPLEMENT_DYNAMIC(CMainFrame, CFrameWnd)

BEGIN_MESSAGE_MAP(CMainFrame, CFrameWnd)
	ON_WM_CREATE()
	ON_WM_SETFOCUS()
	ON_WM_SIZE()
	ON_WM_ACTIVATE()
	ON_BN_CLICKED(IDC_BUTTON1, &CMainFrame::OnBnClickedButton1)
	ON_BN_CLICKED(IDC_BTN_CONNECT, &CMainFrame::OnBnClickedBtnConnect)
	ON_BN_CLICKED(IDC_BTN_DISCONNECT, &CMainFrame::OnBnClickedBtnDisconnect)
	ON_BN_CLICKED(IDC_BTN_CREATEFILE, &CMainFrame::OnBnClickedBtnCreatefile)
	ON_BN_CLICKED(IDC_BTN_CREATEDIR, &CMainFrame::OnBnClickedBtnCreatedir)
	ON_BN_CLICKED(IDC_BTN_DELETEFILE, &CMainFrame::OnBnClickedBtnDeletefile)
	ON_BN_CLICKED(IDC_BTN_COPY, &CMainFrame::OnBnClickedBtnCopy)
	ON_BN_CLICKED(IDC_BTN_MOVE, &CMainFrame::OnBnClickedBtnMove)
	ON_BN_CLICKED(IDC_BTN_PREVIEW, &CMainFrame::OnBnClickedBtnPreview)
	ON_BN_CLICKED(IDC_BTN_EDIT, &CMainFrame::OnBnClickedBtnEdit)
	ON_BN_CLICKED(IDC_BTN_REFRESH, &CMainFrame::OnBnClickedBtnRefresh)
	ON_COMMAND(ID_ACCEL_TAB, &CMainFrame::OnAccelTab)
	ON_REGISTERED_MESSAGE(WM_LISTFILES_DBSEL, &CMainFrame::OnChangeCatalog)
	ON_REGISTERED_MESSAGE(WM_UPDATE_PATH_COMMAND, &CMainFrame::OnUpdateCommandRemoute)
	ON_REGISTERED_MESSAGE(WM_SET_LIST_CURSOR, &CMainFrame::OnSetListCursor)
	ON_REGISTERED_MESSAGE(WM_ENTER_KEY, &CMainFrame::OnCommandLineEnter)
	ON_REGISTERED_MESSAGE(WM_RENAME_FILE, &CMainFrame::OnCommandRenameFile)
	ON_COMMAND(ID_OPEN_LIST_DRIVES_LEFT, &CMainFrame::OnOpenListDrivesLeft)
	ON_COMMAND(ID_OPEN_LIST_DRIVES_RIGHT, &CMainFrame::OnOpenListDrivesRight)
	ON_UPDATE_COMMAND_UI(IDC_BTN_COPY, &CMainFrame::OnUpdateBtnCopy)
	ON_UPDATE_COMMAND_UI(IDC_BTN_CREATEDIR, &CMainFrame::OnUpdateBtnCreatedir)
	ON_UPDATE_COMMAND_UI(IDC_BTN_CREATEFILE, &CMainFrame::OnUpdateBtnCreatefile)
	ON_UPDATE_COMMAND_UI(IDC_BTN_DELETEFILE, &CMainFrame::OnUpdateBtnDeletefile)
	ON_UPDATE_COMMAND_UI(IDC_BTN_DISCONNECT, &CMainFrame::OnUpdateBtnDisconnect)
	ON_UPDATE_COMMAND_UI(IDC_BTN_EDIT, &CMainFrame::OnUpdateBtnEdit)
	ON_UPDATE_COMMAND_UI(IDC_BTN_MOVE, &CMainFrame::OnUpdateBtnMove)
	ON_UPDATE_COMMAND_UI(IDC_BTN_PREVIEW, &CMainFrame::OnUpdateBtnPreview)
	ON_MESSAGE(IDC_DISC_COMBO_RIGHT, &CMainFrame::OnSwichLocalDisc)
	ON_COMMAND(ID_UPDATE_FILES, &CMainFrame::OnUpdateFiles)
	ON_COMMAND(ID_ACCEL_SEL_ALL, &CMainFrame::OnAccelSelAll)
END_MESSAGE_MAP()

static UINT indicators[] =
{
	ID_SEPARATOR,           // status line indicator
	ID_INDICATOR_CAPS,
	ID_INDICATOR_NUM,
	ID_INDICATOR_SCRL,
};


// CMainFrame construction/destruction

CMainFrame::CMainFrame() : 
	m_wndSplitter(2, SSP_HORZ, 30, 3),
		m_tabCtrlNet(&m_wndDlgBar),
	m_ctrlListUserFiles(&m_imageListSys)
{
   p_fsguard = new CDisableWOW64FSRedirection();

	VERIFY(m_fontTab.CreateFont(
				   8,
				   0,
				   0,
				   0,
				   FW_NORMAL,
				   FALSE,    
				   FALSE,    
				   0,          
				   ANSI_CHARSET,
				   OUT_DEFAULT_PRECIS,
				   CLIP_DEFAULT_PRECIS,
				   DEFAULT_QUALITY,    
				   DEFAULT_PITCH | FF_SWISS,
				   _T("MS Sans Serif")));               

	m_chCurrentDisc = 'C';

	CNRFileData::GetImageListFiles(m_imageListSys);
	// Фокус на правой панели
	m_bCursorWindow = true;
}

CMainFrame::~CMainFrame()
{
	m_fontTab.DeleteObject();
	m_imageListSys.Detach();

	delete p_fsguard;
}


int CMainFrame::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CFrameWnd::OnCreate(lpCreateStruct) == -1)
		return -1;
	


	// Параметры для окон разделителя
	
	CBrush	bkgLeft(RGB(255, 255, 240)), 
			bkgRight(RGB(255, 248, 240));
	HCURSOR crsArrow = ::LoadCursor(0, IDC_ARROW);
	//CString classLeft =	AfxRegisterWndClass(CS_DBLCLKS, crsArrow, (HBRUSH)bkgLeft, 0);
			
	

	if(!m_wndDlgBar.Create(this, IDR_MAINFRAME, CBRS_ALIGN_TOP, AFX_IDW_DIALOGBAR))
	{
		TRACE0("Ошибка создания дилога для выбора дисков\n");
		return -1;		// fail to create
	}


	
	//CDiscSelectDlg Dlg = this->m_wndDlgBar;

	if (!m_wndToolBar.Create(this, IDR_TOOLBAR_DLG, 
		CBRS_ALIGN_TOP | WS_CHILD, AFX_IDW_DIALOGBAR+1))
	{
		TRACE0("Ошибка создания дилога для выбора дисков\n");
		return -1;		// fail to create
	}

	if (!m_wndReBar.Create(this) || 
		!m_wndReBar.AddBar(&m_wndToolBar, 0, 0, RBBS_GRIPPERALWAYS | RBBS_CHILDEDGE) || 
		!m_wndReBar.AddBar(&m_wndDlgBar, 0, 0, RBBS_BREAK))
	{
		TRACE0("Failed to create rebar\n");
		return -1;      // fail to create
	}

	
	
	if (!m_wndStatusBar.Create(this) ||
		!m_wndStatusBar.SetIndicators(indicators,
		  sizeof(indicators)/sizeof(UINT)))
	{
		TRACE0("Ошичбка создания строки состояния\n");
		return -1;      
	}

	
	if(!m_wndDlgCmdLine.Create(this, IDR_COMMAND_LINE, CBRS_ALIGN_BOTTOM, AFX_IDW_DIALOGBAR+1001))
	{
		TRACE0("Ошибка создания дилога для выбора дисков\n");
		return -1;		// fail to create
	}
	
	// Создать разделитель окна
	
	VERIFY(m_wndSplitter.Create(this));
	VERIFY(m_wndSplitter.CreatePane(0, &m_tabCtrlNet, WS_CHILD | WS_VISIBLE | TCS_TABS | TCS_BOTTOM | TCS_HOTTRACK, WS_EX_CLIENTEDGE, _T("SysTabControl32")));
	VERIFY(m_wndSplitter.CreatePane(1, &m_ctrlListUserFiles, WS_CHILD | WS_VISIBLE | LVS_REPORT | /*LVS_NOSORTHEADER |*/ LVS_EDITLABELS | LVS_OWNERDATA /*| LVS_SHOWSELALWAYS*/, WS_EX_CLIENTEDGE, _T("SysListView32")));


	// Инициализировать список для отображения файлов на локальной машине

	//InitListLocalSystem();
	
	// Обновить всю информацию по локальной стороне

	UpdateLocalSide();

	m_tabCtrlNet.SetFont(&m_fontTab);

	// Установить иконку

	SetIcon(LoadIcon(AfxGetInstanceHandle(), MAKEINTRESOURCE(IDR_MAINFRAME)), FALSE);

	return 0;
}

BOOL CMainFrame::PreCreateWindow(CREATESTRUCT& cs)
{
	if( !CFrameWnd::PreCreateWindow(cs) )
		return FALSE;
	// TODO: Modify the Window class or styles here by modifying
	//  the CREATESTRUCT cs

	cs.style = WS_OVERLAPPED | WS_CAPTION | FWS_ADDTOTITLE
		 | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_MAXIMIZE | WS_SYSMENU;

	cs.dwExStyle &= ~WS_EX_CLIENTEDGE;
	cs.lpszClass = AfxRegisterWndClass(0);
	return TRUE;
}


// CMainFrame diagnostics

#ifdef _DEBUG
void CMainFrame::AssertValid() const
{
	CFrameWnd::AssertValid();
}

void CMainFrame::Dump(CDumpContext& dc) const
{
	CFrameWnd::Dump(dc);
}

#endif //_DEBUG


// CMainFrame message handlers

void CMainFrame::OnSetFocus(CWnd* /*pOldWnd*/)
{
	if(m_bCursorWindow)
	{
		if(m_ctrlListUserFiles.m_hWnd)
			m_ctrlListUserFiles.SetFocus();
	}
	else
	{
		if(m_tabCtrlNet.get_list_files()->m_hWnd)
			m_tabCtrlNet.get_list_files()->SetFocus();
	}
}

BOOL CMainFrame::OnCmdMsg(UINT nID, int nCode, void* pExtra, AFX_CMDHANDLERINFO* pHandlerInfo)
{
	// let the view have first crack at the command
	//if (m_wndView.OnCmdMsg(nID, nCode, pExtra, pHandlerInfo))
	//	return TRUE;

	// otherwise, do default handling
	return CFrameWnd::OnCmdMsg(nID, nCode, pExtra, pHandlerInfo);
}



BOOL CMainFrame::OnCreateClient(LPCREATESTRUCT lpcs, CCreateContext* pContext)
{
	return CFrameWnd::OnCreateClient(lpcs, pContext);
}


// Загрузить новые данные в список файлов
// szPathroot - путь к главному каталогу

BOOL CMainFrame::LoadNewDataFile(CString szPathroot)
{
	CNRFileData find_file(szPathroot);
	if(!find_file.IsCurrentPathValid())
		return FALSE;
	
	if(find_file.IsFileNormal())
	{
		// Запустить файл
		return FALSE;
	}
	
	CNRListCtrl *pListCtrl = static_cast<CNRListCtrl*>(m_wndSplitter.GetPane(1));
	
	// Установить данные для перерисовки
	return pListCtrl->SetNewDataFiles(&find_file);
}


// Загрука данными о дисках списка по локальной системе

void CMainFrame::LoadDataDrivesLocal()
{
	// Получить информацию о дисках в системе 	

	CListDrives list_drives;
	CNRFileData::GetDiscList(list_drives);	

	// Вывести фильтрованную инфу

	CWzComboBox *pWzComboBox = m_wndDlgBar.GetLocalCombo();	

	// Проверить старый сбор дисков

	for(CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.begin(); iter != m_arrPathOfDrivesLocal.end(); iter++)
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
			m_arrPathOfDrivesLocal.erase(iter);
			iter = m_arrPathOfDrivesLocal.begin();
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
			szDisc.Format(_T("[-%s-] %s %s " + str_size), (*iter_drives)->szLetterDisc, (*iter_drives)->szLabel, (*iter_drives)->szFileSys); 
		else
			szDisc.Format(_T("[-%s-] CD-ROM " + str_size), (*iter_drives)->szLetterDisc);
		
		// Добавить иконку диска
		
		pWzComboBox->SetImageList(&m_imageListSys);
		char *pData = (char*)szDisc.GetBuffer();
		int indx = pWzComboBox->AddCTString(-1, (*iter_drives)->nIconDisc, szDisc);	
	
	
		// Формировать новый массив путей по дискам
		
		CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find((*iter_drives)->szLetterDisc[0]);
		if(iter == m_arrPathOfDrivesLocal.end())
		{
			PATH_DISC info;
			info.indxDisc = indx;
			info.szPath = (*iter_drives)->szLetterDisc + ":";
			info.indx_cursor_cur = 0;
			info.indx_cursor_prev = 0;
			typedef pair <char, PATH_DISC> Mgr_Pair;
			m_arrPathOfDrivesLocal.insert(Mgr_Pair((*iter_drives)->szLetterDisc[0], info));

		}
		delete (*iter_drives);
	}
	
	list_drives.clear();
}

// Обновить список файлов в локальной системе

void CMainFrame::UpdateLocalSide()
{
	CWzComboBox *pWzComboBox = m_wndDlgBar.GetLocalCombo();	
	if(!pWzComboBox)
		return;
	
	CString szPathFind = "";
	
	::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_WAIT)));
		
	// Оределить все диски в системе

	LoadDataDrivesLocal();

	// Вытянуть путь из текущего диска
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	if(iter == m_arrPathOfDrivesLocal.end())
	{
		iter = m_arrPathOfDrivesLocal.begin();
		m_chCurrentDisc = (*iter).first;
		szPathFind = (*iter).second.szPath;
		pWzComboBox->SetCurSel((*iter).second.indxDisc);
	}
	else
	{
		szPathFind = (*iter).second.szPath;
		pWzComboBox->SetCurSel((*iter).second.indxDisc);
	}

	// Ищем все файлы по этому пути
	
	if(!LoadNewDataFile(szPathFind))
	{
		// Пробуем поискать в корне текущего диска
		
		szPathFind = ((CString)m_chCurrentDisc) + ":";
	
		if(!LoadNewDataFile(szPathFind))
		{
			// Переходим на самый первый диск в его текущий путь
			
			iter = m_arrPathOfDrivesLocal.begin();
			m_chCurrentDisc = (*iter).first;
			szPathFind = (*iter).second.szPath;
			pWzComboBox->SetCurSel((*iter).second.indxDisc);

			if(!LoadNewDataFile(szPathFind))
			{
				szPathFind = m_chCurrentDisc + ":";
				if(!LoadNewDataFile(szPathFind))
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
			m_ctrlListUserFiles.SetCurrentIndx((*iter).second.GetPrevIndx());
			LoadNewDataFile(szPathFind);
		}
	}
	
	int indx = m_ctrlListUserFiles.GetCurrentIndx();
	if(indx < 0 || indx >= m_ctrlListUserFiles.GetItemCount()){
		m_ctrlListUserFiles.SetCurrentIndx(0);
		m_ctrlListUserFiles.SetCursorItem();
	}
	
	// Отобразить путь
	if(!szPathFind.IsEmpty())
		m_wndDlgBar.SetPathRight(szPathFind+"\\*.*");
	else
		m_wndDlgBar.SetPathRight("");

	// Обновить данные на командной строке

	if(!szPathFind.IsEmpty())
		m_wndDlgCmdLine.SetPathStatic(szPathFind+"\\");
	
	m_sz_current_path = szPathFind+"\\";
	::SetCursor(::LoadCursor(NULL, MAKEINTRESOURCE(IDC_ARROW)));	
}


// Переключение дисков на локальной машине

LRESULT CMainFrame::OnSwichLocalDisc(WPARAM wp, LPARAM lp)
{
	CWzComboBox *pWzComboBox = m_wndDlgBar.GetLocalCombo();	
	
	for(CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.begin(); iter != m_arrPathOfDrivesLocal.end(); iter++)
	{
		if(pWzComboBox->GetCurSel() == (*iter).second.indxDisc)
		{
			m_chCurrentDisc = (*iter).first;	
			// Обновить курсоры по выбранному диску
			m_ctrlListUserFiles.SetCurrentIndx((*iter).second.indx_cursor_cur);
			break;
		}
	}
	
	UpdateLocalSide();
	
	return TRUE;
}

// Запуск указанного файла

BOOL CMainFrame::ExecuteFile(CString strPath, CString sz_dir, CString sz_params)
{
	HINSTANCE hInst = ShellExecute(m_hWnd, "open", strPath, /*strPath + " " + */sz_params, sz_dir, SW_SHOW);
	if(!hInst) return FALSE;
	return TRUE;
}




void CMainFrame::OnSize(UINT nType, int cx, int cy)
{
	CFrameWnd::OnSize(nType, cx, cy);

	

}

void CMainFrame::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized)
{
	CFrameWnd::OnActivate(nState, pWndOther, bMinimized);

	//UpdateLocalSide();
}

void CMainFrame::OnBnClickedButton1()
{
	
}


//////////////////////////////////////////////////////
// Подкдючится к другому компьютеру
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnConnect()
{
	CConnectDlg	connect_dlg;
	if(connect_dlg.DoModal() == IDCANCEL)
		return;

	// Подключится к серверу и в случае неудачи 
	// выйти с собщением пользователю причины неудачи
	
	
	// Создать окно для нового подключения
	
	m_tabCtrlNet.AddNewConnect(connect_dlg.m_szNetName, connect_dlg.m_iPortNumber);
}

//////////////////////////////////////////////////////
// Отключится от компьютера
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnDisconnect()
{
	m_tabCtrlNet.DeleteNet(m_tabCtrlNet.GetCurSel());

	if(m_tabCtrlNet.GetItemCount() < 2)
		if(!m_bCursorWindow)
			PostMessage(WM_COMMAND, ID_ACCEL_TAB, 0);
}

//////////////////////////////////////////////////////
// Создать файл
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnCreatefile()
{
	CCreateFileDlg	dlg_file(this, TRUE);
	if(dlg_file.DoModal() == IDCANCEL)
		return;

	// Определить текущий путь

	if(m_bCursorWindow)
	{
		CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
		CString szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
		szCurrentPath += dlg_file.m_szNameFile;

		HANDLE hNewFile = ::CreateFile(szCurrentPath, GENERIC_READ | GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE,
			NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
	
		if(hNewFile == INVALID_HANDLE_VALUE )
		{
			AfxMessageBox("Невозможно создать указанный файл!");
			return;
		}

		::CloseHandle(hNewFile);
	
		// Запустить блокнот для редактирования

		HINSTANCE h_inst = ShellExecute(m_hWnd, "open", "notepad.exe", szCurrentPath, (*iter).second.szPath, SW_SHOW); 
		
		if(!h_inst) ::CloseHandle(h_inst);	

		UpdateLocalSide();
	}
	else
	{
		// Передать запрос серверу
	}

}

//////////////////////////////////////////////////////
// Создать каталог
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnCreatedir()
{
	CCreateFileDlg	dlg_file(this, FALSE);
	if(dlg_file.DoModal() == IDCANCEL)
		return;

	// Определить текущий путь

	if(m_bCursorWindow)
	{
		CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
		CString szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
		szCurrentPath += dlg_file.m_szNameFile;

		if(mkdir(szCurrentPath) == -1)
		{
			AfxMessageBox("Невозможно создать указанный каталог!");
			return;
		}
		
		m_tabCtrlNet.UpdateAllOnActive();
		UpdateLocalSide();
	}
	else
	{
		// Передать запрос серверу
	
		m_tabCtrlNet.OnCreateDir(dlg_file.m_szNameFile);
		UpdateLocalSide();
		m_tabCtrlNet.UpdateAllOnActive();
	}
}





//////////////////////////////////////////////////////
// Удалить  файл\каталог
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnDeletefile()
{
	if(m_bCursorWindow)
	{
		CRfmThreads thread_del;
		
		CProcessDlg dlgProcess;
		DWORD dwIDThreadDelete = 0;
		array_path arrPath;
		
		// Определить текущий путь
			
		CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
		CString szCurrentPath = (*iter).second.szPath;
		szCurrentPath += "\\";
	
		// Выбрать необходимые пути удаления файлов
		
		POSITION nStartPos = m_ctrlListUserFiles.GetFirstSelectedItemPosition();
	
		while(nStartPos)
		{
			szCurrentPath = (*iter).second.szPath;
			szCurrentPath += "\\";
						
			int nItem = m_ctrlListUserFiles.GetNextSelectedItem(nStartPos);
			
			CString szText = m_ctrlListUserFiles.GetItemText(nItem, 0);
			CString dir = m_ctrlListUserFiles.GetItemText(nItem, 1);
			if(dir != "<DIR>")
			{
				szCurrentPath += szText;		
				arrPath.push_back(szCurrentPath);
			}
			else
			{
				if(szText == "[.]" || szText == "[..]")
					continue;

				szText.Delete(0);
				szText.Delete(szText.GetLength()-1);
				szCurrentPath += szText;		
				arrPath.push_back(szCurrentPath);
			}		 
		}
	
		if(!arrPath.size())
		{
			AfxMessageBox("Ничего не выбрано!");
			return;
		}
		else
		{
			if(MessageBox("Удалить выбранные файлы?", "ClientRFM", MB_YESNO | MB_ICONQUESTION) != IDYES)
				return;
		}
	
		// Запустить поток удаления файлов

		thread_del.delete_local_files(arrPath);
		
		m_ctrlListUserFiles.SetCurrentIndx(0);
				
		// Обновить локальную сторону
	
		m_tabCtrlNet.UpdateAllOnActive();
		UpdateLocalSide();
	}
	else
	{
		// Передать запрос удаления на сервер
	
		m_tabCtrlNet.OnDeleteFiles();
		UpdateLocalSide();
		m_tabCtrlNet.UpdateAllOnActive();
	}
}

//////////////////////////////////////////////////////
// Копировать файл(ы)
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnCopy()
{
	if(MessageBox("Копировать выбранные файлы?\nВ процессе копирования одинаковые файлы будут перезаписаны.", "ClientRFM", MB_YESNO | MB_ICONQUESTION) != IDYES)
		return;
	
	
	vector<CString> arrPath;	
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;

	if(m_bCursorWindow)
	{
		// Определить текущий путь
				
		szCurrentPath += "\\";
		
		// Определить список копируемых каталогов и файлов 
		
		POSITION nStartPos = m_ctrlListUserFiles.GetFirstSelectedItemPosition();
		
		while(nStartPos)
		{
			szCurrentPath = (*iter).second.szPath;
			szCurrentPath += "\\";
						
			int nItem = m_ctrlListUserFiles.GetNextSelectedItem(nStartPos);
			
			CString szText = m_ctrlListUserFiles.GetItemText(nItem, 0);
			CString dir = m_ctrlListUserFiles.GetItemText(nItem, 1);
			if(dir != "<DIR>")
			{
				szCurrentPath += szText;		
				arrPath.push_back(szCurrentPath);
			}
			else
			{
				if(szText == "[.]" || szText == "[..]")
					continue;

				szText.Delete(0);
				szText.Delete(szText.GetLength()-1);
				szCurrentPath += szText;		
				
				arrPath.push_back(szCurrentPath);
			
			}		 
		}

		// Передать файл на сервер

		m_tabCtrlNet.CopyFileToServer(arrPath);
	}
	else
	{
		// Копировать файл с сервера
	
		m_tabCtrlNet.CopyFileFromServer(szCurrentPath);
	
		m_tabCtrlNet.UpdateAllOnActive();
		UpdateLocalSide();

		PostMessage(WM_COMMAND, ID_ACCEL_TAB, 0);
	}
}

//////////////////////////////////////////////////////
// Переместить файл(ы)
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnMove()
{
	if(MessageBox("Переместить выбранные файлы?\nВ процессе перемещения одинаковые файлы будут перезаписаны.", "ClientRFM", MB_YESNO | MB_ICONQUESTION) != IDYES)
		return;
	
	vector<CString> arrPath;	
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;

	if(m_bCursorWindow)
	{
		// Определить текущий путь
				
		szCurrentPath += "\\";
		
		// Определить список перемещаемых каталогов и файлов 
		
		POSITION nStartPos = m_ctrlListUserFiles.GetFirstSelectedItemPosition();
		
		while(nStartPos)
		{
			szCurrentPath = (*iter).second.szPath;
			szCurrentPath += "\\";
						
			int nItem = m_ctrlListUserFiles.GetNextSelectedItem(nStartPos);
			
			CString szText = m_ctrlListUserFiles.GetItemText(nItem, 0);
			CString dir = m_ctrlListUserFiles.GetItemText(nItem, 1);
			if(dir != "<DIR>")
			{
				szCurrentPath += szText;		
				arrPath.push_back(szCurrentPath);
			}
			else
			{
				if(szText == "[.]" || szText == "[..]")
					continue;

				szText.Delete(0);
				szText.Delete(szText.GetLength()-1);
				szCurrentPath += szText;		
				
				arrPath.push_back(szCurrentPath);
			
			}		 
		}

		// Переместить файл на сервер

		m_tabCtrlNet.MoveFileToServer(arrPath);
	
		m_tabCtrlNet.UpdateAllOnActive();
		UpdateLocalSide();	
	}
	else
	{
		// Переместить файл с сервера
	
		m_tabCtrlNet.MoveFileFromServer(szCurrentPath);
	
		UpdateLocalSide();
		m_tabCtrlNet.UpdateAllOnActive();
		
		//PostMessage(WM_COMMAND, ID_ACCEL_TAB, 0);
	}	

	
	
}

//////////////////////////////////////////////////////
// Просмотр файла
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnPreview()
{
        OnBnClickedBtnEdit();


/*	if(!m_bCursorWindow)
		return;
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	szCurrentPath += "\\";
	int nIndx = m_ctrlListUserFiles.GetCurrentIndx();
	if(nIndx < 0) return;
	CString szText = m_ctrlListUserFiles.GetItemText(nIndx, 0);
	CString dir = m_ctrlListUserFiles.GetItemText(nIndx, 1);
	if(dir == "<DIR>")
	{
		AfxMessageBox("Не выбран файл!");
		return;
	}
	szCurrentPath += szText;
	
	// Открыть окно просмотра файла

	CPreviewWnd preview_wnd(szCurrentPath, this);
	preview_wnd.DoModal();
*/

}

//////////////////////////////////////////////////////
// Правка файла
//////////////////////////////////////////////////////

void CMainFrame::OnBnClickedBtnEdit()
{
	if(!m_bCursorWindow)
		return;
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	szCurrentPath += "\\";
	int nIndx = m_ctrlListUserFiles.GetCurrentIndx();
	if(nIndx < 0) return;
	CString szText = m_ctrlListUserFiles.GetItemText(nIndx, 0);
	CString dir = m_ctrlListUserFiles.GetItemText(nIndx, 1);
	if(dir == "<DIR>")
	{
		AfxMessageBox("Не выбран файл!");
		return;
	}
	szCurrentPath += szText;
	
	// Открыть в блокноте

	ShellExecute(m_hWnd, "open", "notepad.exe", szCurrentPath, (*iter).second.szPath, SW_SHOW); 

	m_tabCtrlNet.UpdateAllOnActive();
	UpdateLocalSide();
}

void CMainFrame::ActivateFrame(int nCmdShow)
{
	CFrameWnd::ActivateFrame(nCmdShow);
}


// Переключение курсора на окнах
// Сопровождается нажатием клавиши <TAB>

void CMainFrame::OnAccelTab()
{
	if(m_bCursorWindow && m_tabCtrlNet.GetItemCount() > 1)
	{
		
		m_tabCtrlNet.OnTabSetCursor();
		m_wndDlgCmdLine.SetPathStatic(m_tabCtrlNet.get_current_path());
		m_bCursorWindow = false;
	}
	else
	{
		m_ctrlListUserFiles.SetFocus();
		m_ctrlListUserFiles.SetCursorItem();
		m_wndDlgCmdLine.SetPathStatic(m_sz_current_path);
		m_bCursorWindow = true;
	}

	// Обновить данные на командной строке

	//m_wndDlgCmdLine.SetPathStatic(szPathFind+"\\");
	//m_wndDlgCmdLine.SetFileName("");
}

// Перейти в другой каталог
// или выйти в предыдущий

LRESULT CMainFrame::OnChangeCatalog(WPARAM wp, LPARAM lp)
{
	int nIndx = (int)wp;	

	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	if(iter == m_arrPathOfDrivesLocal.end())
		return FALSE;

	CString szCurPath = (*iter).second.szPath;
	
	CString szText = m_ctrlListUserFiles.GetItemText(nIndx, 0);
	CString dir = m_ctrlListUserFiles.GetItemText(nIndx, 1);
	if(dir != "<DIR>")
	{
		// Пререадресовать файла функции запуска файла
		ExecuteFile(szCurPath + "\\" +szText, szCurPath, "");
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
	(*iter).second.szPath = CNRFileData::GetFullPath(szCurPath, "", b_prev);
	
	if(b_prev)
		m_ctrlListUserFiles.SetCurrentIndx((*iter).second.GetPrevIndx());
	else
	{
		(*iter).second.SetPrevIndx(m_ctrlListUserFiles.GetCurrentIndx());
		m_ctrlListUserFiles.SetCurrentIndx(0);
	}
	
	// Обновить список файлов
	UpdateLocalSide();

	return TRUE;
}

// Открыть список дисков для удаленной стороны 

void CMainFrame::OnOpenListDrivesLeft()
{
	CWzComboBox *pCombo = m_wndDlgBar.GetNetCombo();
	VERIFY(pCombo);
	pCombo->SetFocus();
	pCombo->SendMessage(CB_SHOWDROPDOWN, /*wParam*/(WPARAM)true, (LPARAM)/*pCombo->m_hWnd*/NULL);

}

// Открыть список дисков для локальной стороны 

void CMainFrame::OnOpenListDrivesRight()
{
	CWzComboBox *pCombo = m_wndDlgBar.GetLocalCombo();
	VERIFY(pCombo);
	pCombo->SetFocus();
	pCombo->SendMessage(CB_SHOWDROPDOWN, /*wParam*/(WPARAM)true, (LPARAM)/*pCombo->m_hWnd*/NULL);
}

void CMainFrame::OnUpdateBtnCopy(CCmdUI *pCmdUI)
{
	if((!m_bCursorWindow && !m_tabCtrlNet.GetCurSel()) ||
	   (m_bCursorWindow && m_tabCtrlNet.GetItemCount()==1))
		pCmdUI->Enable(false);
	else
		pCmdUI->Enable(true);

}

void CMainFrame::OnUpdateBtnCreatedir(CCmdUI *pCmdUI)
{
	if((!m_bCursorWindow && m_tabCtrlNet.GetItemCount()==1))
		pCmdUI->Enable(false);
	else
		pCmdUI->Enable(true);

}

void CMainFrame::OnUpdateBtnCreatefile(CCmdUI *pCmdUI)
{
	pCmdUI->Enable(m_bCursorWindow);
}

void CMainFrame::OnUpdateBtnDeletefile(CCmdUI *pCmdUI)
{
	if((!m_bCursorWindow && m_tabCtrlNet.GetItemCount()==1))
		pCmdUI->Enable(false);
	else
		pCmdUI->Enable(true);

}

void CMainFrame::OnUpdateBtnDisconnect(CCmdUI *pCmdUI)
{
	if(m_tabCtrlNet.GetItemCount()==1 || !m_tabCtrlNet.GetCurSel())
		pCmdUI->Enable(false);
	else
		pCmdUI->Enable(true);
}

void CMainFrame::OnUpdateBtnEdit(CCmdUI *pCmdUI)
{
	pCmdUI->Enable(m_bCursorWindow);	
}

void CMainFrame::OnUpdateBtnMove(CCmdUI *pCmdUI)
{
	if((!m_bCursorWindow && !m_tabCtrlNet.GetCurSel()) ||
	   (m_bCursorWindow && m_tabCtrlNet.GetItemCount()==1))
		pCmdUI->Enable(false);
	else
		pCmdUI->Enable(true);

}

void CMainFrame::OnUpdateBtnPreview(CCmdUI *pCmdUI)
{
	pCmdUI->Enable(m_bCursorWindow);
}

LRESULT CMainFrame::OnUpdateCommandRemoute(WPARAM wp, LPARAM lp)
{
	m_wndDlgCmdLine.SetPathStatic(m_tabCtrlNet.get_current_path());
	return TRUE;
}

LRESULT CMainFrame::OnSetListCursor(WPARAM wp, LPARAM lp)
{
	bool *pb_cur = (bool*)&wp;
	m_bCursorWindow = *pb_cur;
	if(m_bCursorWindow)
		m_wndDlgCmdLine.SetPathStatic(m_sz_current_path);
	else
		m_wndDlgCmdLine.SetPathStatic(m_tabCtrlNet.get_current_path());
	return TRUE;
}



void CMainFrame::OnUpdateFiles()
{
	
}

void CMainFrame::OnEnterCommand()
{
	
}

void CMainFrame::OnUpdateEnterCommand(CCmdUI *pCmdUI)
{
	
}

LRESULT CMainFrame::OnCommandLineEnter(WPARAM wp, LPARAM lp)
{
	CString sz_commang, sz_file_name;
	CString sz_file = m_wndDlgCmdLine.GetFileName();	
	CFileFind find_file;
	if(sz_file.IsEmpty())
	{
		AfxMessageBox("Команда отсутствует!");
		return FALSE;
	}

	// Имя файла

	int i_end_file =  sz_file.Find(' '); 
	if(i_end_file == -1)
		sz_file_name = sz_file;
	else
	{
		sz_file_name = sz_file.Mid(0, i_end_file);
		sz_commang = sz_file.Mid(i_end_file+1, sz_file.GetLength()-i_end_file);
	}

	CString sz_full_path = m_wndDlgCmdLine.GetPathStatic() + sz_file_name;
	
	if(!m_bCursorWindow)
		m_tabCtrlNet.ExecuteFile(sz_full_path, m_wndDlgCmdLine.GetPathStatic(), sz_commang);



	if(!find_file.FindFile(sz_full_path))
	{
		AfxMessageBox("Файл не найден!");
		m_wndDlgCmdLine.SetFileName("");	
		return FALSE;
	}
	
	ExecuteFile(sz_full_path, m_wndDlgCmdLine.GetPathStatic(), sz_commang);
	m_wndDlgCmdLine.SetFileName("");	
	return TRUE;
}

void CMainFrame::OnBnClickedBtnRefresh()
{
	if(m_bCursorWindow)
	{
		m_tabCtrlNet.UpdateAllOnActive();
		UpdateLocalSide();
	}
	else
	{
		UpdateLocalSide();
		m_tabCtrlNet.UpdateAllOnActive();
	}
}

// Команда переименования файла локально

LRESULT CMainFrame::OnCommandRenameFile(WPARAM wp, LPARAM lp)
{
	CFile file;
	
	CArrPathDrives::iterator iter = m_arrPathOfDrivesLocal.find(m_chCurrentDisc);
	CString szCurrentPath = (*iter).second.szPath;
	CString sz_old_path = szCurrentPath + "\\" + (CString)(const char*)wp;
	CString sz_new_path = szCurrentPath + "\\" + (CString)(const char*)lp;
	
	try
	{
		file.Rename(sz_old_path, sz_new_path);
	}
	catch(...)
	{
		AfxMessageBox("Невозможно переименовать файл!");
		return FALSE;
	}

	UpdateLocalSide();

	return TRUE;
}
void CMainFrame::OnAccelSelAll()
{
	CNRListCtrl *p_nr_list_ctrl = m_bCursorWindow ? &m_ctrlListUserFiles : m_tabCtrlNet.get_list_files();	 
	if(!p_nr_list_ctrl) return;

	if(p_nr_list_ctrl->GetItemText(0, 0) != _T("[..]"))
		p_nr_list_ctrl->SetItemState(0, LVIS_SELECTED, LVIS_SELECTED);
	for(int i = 1; i < p_nr_list_ctrl->GetItemCount(); i++)
		p_nr_list_ctrl->SetItemState(i, LVIS_SELECTED, LVIS_SELECTED);
}
