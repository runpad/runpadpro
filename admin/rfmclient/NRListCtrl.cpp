// NRListCtrl.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "NRListCtrl.h"
#include "mainfrm.h"
#include <algorithm>


UINT WM_LISTFILES_DBSEL	= RegisterWindowMessage("List files select");
UINT WM_SET_LIST_CURSOR	= RegisterWindowMessage("Set list cursor");
UINT WM_RENAME_FILE		= RegisterWindowMessage("Rename file");

using namespace std;

// CNRListCtrl

IMPLEMENT_DYNAMIC(CNRListCtrl, CListCtrl)

CNRListCtrl::CNRListCtrl(CImageList *pimageListSys)
{
	VERIFY(m_fontText.CreateFont(
				   8,
				   0,
				   0,
				   0,
				   FW_BOLD,
				   FALSE,    
				   FALSE,    
				   0,          
				   ANSI_CHARSET,
				   OUT_DEFAULT_PRECIS,
				   CLIP_DEFAULT_PRECIS,
				   DEFAULT_QUALITY,    
				   DEFAULT_PITCH | FF_SWISS,
				   _T("MS Sans Serif")));               
	
	
	m_List_files.clear();
		
	ASSERT(pimageListSys);
	m_pimageListSys = pimageListSys;
	m_nCursorItem = 0;
	m_b_view_only_files = false;
	m_sz_old_name = m_sz_new_name = "";
}

CNRListCtrl::~CNRListCtrl()
{
	m_fontText.DeleteObject();
	
	// Зачистить данные
	ClearOldData();
}


BEGIN_MESSAGE_MAP(CNRListCtrl, CListCtrl)
	ON_WM_SIZE()
	ON_NOTIFY_REFLECT(LVN_ITEMCHANGED, &CNRListCtrl::OnLvnItemchanged)
	ON_NOTIFY_REFLECT(NM_DBLCLK, &CNRListCtrl::OnNMDblclk)
	ON_NOTIFY_REFLECT(LVN_GETDISPINFO, &CNRListCtrl::OnLvnGetdispinfo)
	ON_NOTIFY_REFLECT(LVN_COLUMNCLICK, &CNRListCtrl::OnLvnColumnclick)
	ON_WM_CREATE()
//	ON_COMMAND(ID_ACCEL_ENTER, &CNRListCtrl::OnAccelEnter)
//	ON_NOTIFY_REFLECT(LVN_KEYDOWN, &CNRListCtrl::OnLvnKeydown)
	ON_WM_ACTIVATE()
	ON_WM_SHOWWINDOW()
	ON_NOTIFY_REFLECT(NM_CLICK, &CNRListCtrl::OnNMClick)
	ON_WM_SETFOCUS()
//	ON_COMMAND(ID_ACCEL_ENTER, &CNRListCtrl::OnAccelEnter)
//ON_COMMAND(ID_ACCEL_ENTER, &CNRListCtrl::OnAccelEnter)
ON_NOTIFY_REFLECT(LVN_KEYDOWN, &CNRListCtrl::OnLvnKeydown)
ON_NOTIFY_REFLECT(LVN_ITEMCHANGING, &CNRListCtrl::OnLvnItemchanging)
ON_NOTIFY_REFLECT(LVN_BEGINLABELEDIT, &CNRListCtrl::OnLvnBeginlabeledit)
ON_NOTIFY_REFLECT(LVN_ENDLABELEDIT, &CNRListCtrl::OnLvnEndlabeledit)
END_MESSAGE_MAP()

//ON_NOTIFY(LVN_GETDISPINFO, AFX_IDW_PANE_FIRST+1, &CNRListCtrl::OnLvnGetdispinfo)

// CNRListCtrl message handlers

#define COLUMN_1	60
#define COLUMN_2	20
#define COLUMN_3	20


bool CNRListCtrl::g_bSwitchSort = true;
int  CNRListCtrl::g_nIndxField = 0;


// Очистить все 

void CNRListCtrl::ClearAll()
{
	ClearOldData();
	Invalidate();
}


void CNRListCtrl::OnSize(UINT nType, int cx, int cy)
{
	CListCtrl::OnSize(nType, cx, cy);

	CHeaderCtrl *pHeadCtrl = GetHeaderCtrl();
	if(!pHeadCtrl || !cx) return;

	int nCount = pHeadCtrl->GetItemCount();
	int nWidth = 0;
	
	for(int i = 0; i < nCount; i++)
	{
		switch(i)
		{
			case 0: nWidth = (int)((COLUMN_1 * cx) / 100); break;
			case 1:	nWidth = (int)((COLUMN_2 * cx) / 100); break;
			case 2: nWidth = (int)((COLUMN_3 * cx) / 100); break;
		}
		SetColumnWidth(i, nWidth);
	}

	
}



void CNRListCtrl::OnNMDblclk(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	
	GetParentFrame()->SendMessage(WM_LISTFILES_DBSEL, (WPARAM)pNMLV->iItem, (LPARAM)0);

	*pResult = 0;
}

////////////////////////////////////////////////////////////////////
// Зачиска оставшиеся данных
////////////////////////////////////////////////////////////////////

void CNRListCtrl::ClearOldData()
{
	for(CListFiles::iterator iter = m_List_files.begin(); iter != m_List_files.end(); iter++)
		if((*iter))
			delete (*iter);
	m_List_files.clear();
}


////////////////////////////////////////////////////////////////////
// Добавить новые данные для отображения
////////////////////////////////////////////////////////////////////

BOOL CNRListCtrl::SetNewDataFiles(CNRFileData *pNewFileData, bool b_only_files/*=false*/)
{
	if(!pNewFileData)
		return FALSE;
	
	m_b_view_only_files = b_only_files;

	// Зачистка старых данных

	ClearOldData();
	SetItemCount(0);
	DeleteAllItems();
	
	if(!pNewFileData->GetDataFiles(m_List_files, NULL))
	{
		SetItemCount(0);
		Invalidate();
		return FALSE;
	}

	// Определить индекс начала файловых данных

	for(m_iter_begin_files = m_List_files.begin(); m_iter_begin_files != m_List_files.end(); m_iter_begin_files++)
	{	
		if(!(*m_iter_begin_files)->bDirectory)
			break;
	}

	// Отсортировать
	
	g_nIndxField = 0;
	g_bSwitchSort = true;
	SortItemsFile(g_nIndxField);
	
	
	// Загрузка новых данных
	
	SetItemCount((int)m_List_files.size());

	// Установить курсор на первый итем
	//SetItemState(m_nCursorItem, 0, 0);
	//SetSelectionMark(m_nCursorItem);
	

	
	SetCursorItem();
	SetFocus();
	//SetHotItem(m_nCursorItem);

	
	return TRUE;
}

////////////////////////////////////////////////////////////////////
// Запрос данных на перерисовку
////////////////////////////////////////////////////////////////////

CString str_tmp;

void CNRListCtrl::OnLvnGetdispinfo(NMHDR *pNMHDR, LRESULT *pResult)
{
	NMLVDISPINFO *pDispInfo = reinterpret_cast<NMLVDISPINFO*>(pNMHDR);
	LV_ITEM* pItem = &(pDispInfo)->item;
	*pResult = 0;
	
	if(pItem->iItem >= (int)m_List_files.size())
		return;
	
	// Установить нужный итератор

	CListFiles::iterator iter_drives = m_List_files.begin();
	for(int i = 0; i < pItem->iItem; i++)
		iter_drives++;
	
	// Загрузка текстовки	

	if(pItem->mask & LVIF_TEXT)
	{
		if(pItem->iSubItem == 0) //первая колонка
		{			
			pItem->pszText = (*iter_drives)->szNameFile.GetBuffer();
		}
		else	
			if(pItem->iSubItem == 1) //вторая колонка
			{
				ULONGLONG iSize = (*iter_drives)->iSizeFile;
				if((*iter_drives)->bDirectory)
					str_tmp = "<DIR>";
				else
				if(m_b_view_only_files)
				{
					str_tmp = "---";
				}
				else
				{
					if(iSize > 1024)
					{
						iSize = (ULONGLONG)(iSize / 1024);
						str_tmp.Format(_T("%d KБ"), iSize);
					}
					else
					if(iSize >= 0)
						str_tmp.Format(_T("%d Б"), iSize);
				}
			
				pItem->pszText = str_tmp.GetBuffer();
			}
			else
				if(pItem->iSubItem == 2) // третья колонка
				{
					if(m_b_view_only_files)
					{
						str_tmp = "--.--.--";
					}
					else
					{
						str_tmp.Format(_T("%02d.%02d.%02d"), (*iter_drives)->timeCreate.GetDay(), (*iter_drives)->timeCreate.GetMonth(),
							(*iter_drives)->timeCreate.GetYear() );
					}
					pItem->pszText = str_tmp.GetBuffer();
				}		
	}
	
	// Загрузка картинки	

	if(pItem->mask & LVIF_IMAGE)
	{
		int indx_image = (*iter_drives)->nIconFile; 
				
		if(m_pimageListSys->GetImageCount() == 3)
		{
			if((*iter_drives)->bDirectory)
				indx_image = 1; 
			else
				indx_image = 2; 
		}

		pItem->iImage = indx_image;
	}

}

// Компаратор для двух элементов массива

bool UDgreater(PDATA_FILE pData1, PDATA_FILE pData2)
{
	CString str1 = pData1->szNameFile,
			str2 = pData2->szNameFile;
	
	str1.MakeLower();
	str2.MakeLower();

	if(str1 == "[..]")
		return true;
	else
	if(str2 == "[..]")
		return false;
	
	switch(CNRListCtrl::g_nIndxField)
	{
		case 0:
			{
				int min_len = (int)min(strlen(str1), strlen(str2));
				
				for(int i = 0; i < min_len; i++)	
				{
					if((unsigned char)str1[i] > (unsigned char)str2[i])
						return (CNRListCtrl::g_bSwitchSort) ? true : false;
					if((unsigned char)str1[i] < (unsigned char)str2[i])
						return (CNRListCtrl::g_bSwitchSort) ? false : true;
				}
				
				break;
			}
		case 1:
			{
				if(pData1->iSizeFile == pData2->iSizeFile)
					return false;
				else
				if(pData1->iSizeFile > pData2->iSizeFile)
					return ((CNRListCtrl::g_bSwitchSort) ? true : false);
				else
					return ((CNRListCtrl::g_bSwitchSort) ? false : true);
				break;
			}
		case 2:
			{
				if(pData1->timeCreate == pData2->timeCreate)
					return false;
				else
				if(pData1->timeCreate > pData2->timeCreate)
					return (CNRListCtrl::g_bSwitchSort) ? true : false;
				else
					return (CNRListCtrl::g_bSwitchSort) ? false : true;
				break;
			}
	}

	return false;
}


// Сортировать файлы по заданному массиву

void CNRListCtrl::SortItemsFile(int nSubItem)
{
	if(nSubItem >= (int)m_List_files.size())
		return;
	
	
	if(g_bSwitchSort)
		g_bSwitchSort = false;
	else
		g_bSwitchSort = true;

	g_nIndxField = nSubItem;
	
	// Сортировать каталоги

	if(g_nIndxField != 1)
		sort(m_List_files.begin(), m_iter_begin_files, UDgreater);

	// Сортировать файлы

	sort(m_iter_begin_files, m_List_files.end(), UDgreater);
	
	Invalidate();
}

void CNRListCtrl::OnLvnColumnclick(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	
	SortItemsFile(pNMLV->iSubItem);

	*pResult = 0;
}


// Инициализировать список для отображения файлов на 

void CNRListCtrl::InitListLocalSystem()
{
	InsertColumn(0, _T("Имя"), LVCFMT_LEFT, 100); 
	InsertColumn(1, _T("Размер"), LVCFMT_LEFT, 100); 
	InsertColumn(2, _T("Дата"), LVCFMT_LEFT, 100); 
	SetIconSpacing(CSize(20, 20));

	SetImageList(m_pimageListSys, LVSIL_SMALL);

	// Установить шрифт

	SetFont(&m_fontText);
}

int CNRListCtrl::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CListCtrl::OnCreate(lpCreateStruct) == -1)
		return -1;

	InitListLocalSystem();

	return 0;
}


void CNRListCtrl::OnLvnItemchanged(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	m_nCursorItem = pNMLV->iItem;
	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	VERIFY(pFrame);
	pFrame->m_bCursorWindow = true;
	SetFocus();
	*pResult = 0;
}

///////////////////////////////////////////////////////////
// Установить курсор
///////////////////////////////////////////////////////////

void CNRListCtrl::SetCursorItem()
{
	//SetFocus();
	
	//if(m_nCursorItem >= GetItemCount())
	//	m_nCursorItem = 0;
	
	
	SetItemState(m_nCursorItem, LVIS_FOCUSED | LVIS_SELECTED, 0x000F);
}

//void CNRListCtrl::OnAccelEnter()
//{
//}

//void CNRListCtrl::OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult)
//{
//	
//	
//	
//	*pResult = 0;
//}

void CNRListCtrl::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized)
{
	CListCtrl::OnActivate(nState, pWndOther, bMinimized);

	// TODO: Add your message handler code here
}


void CNRListCtrl::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CListCtrl::OnShowWindow(bShow, nStatus);

	//SetCursorItem();
}

void CNRListCtrl::OnNMClick(NMHDR *pNMHDR, LRESULT *pResult)
{
	// TODO: Add your control notification handler code here
	*pResult = 0;
}



void CNRListCtrl::OnSetFocus(CWnd* pOldWnd)
{
	CListCtrl::OnSetFocus(pOldWnd);

	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	VERIFY(pFrame);
	pFrame->SendMessage(WM_SET_LIST_CURSOR, (WPARAM)true);
	
}

//void CNRListCtrl::OnAccelEnter()
//{
//	
//}

//void CNRListCtrl::OnAccelEnter()
//{
//	// TODO: Add your command handler code here
//}

void CNRListCtrl::OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLVKEYDOWN pLVKeyDow = reinterpret_cast<LPNMLVKEYDOWN>(pNMHDR);
	if(pLVKeyDow->wVKey == VK_RETURN)
	{
		GetParentFrame()->SendMessage(WM_LISTFILES_DBSEL, (WPARAM)m_nCursorItem, (LPARAM)0);
	}

	*pResult = 0;
}

void CNRListCtrl::OnLvnItemchanging(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

// Начинаем редактировать имя файла	

void CNRListCtrl::OnLvnBeginlabeledit(NMHDR *pNMHDR, LRESULT *pResult)
{
	NMLVDISPINFO *pDispInfo = reinterpret_cast<NMLVDISPINFO*>(pNMHDR);
	
	if(pDispInfo->item.iItem >= (int)m_List_files.size() || pDispInfo->item.iItem < 0){
		*pResult = 0;
		return;
	}
	
	CString sz_name_dir = m_List_files[pDispInfo->item.iItem]->szNameFile;
	if(sz_name_dir.IsEmpty() || sz_name_dir == "[..]" || sz_name_dir == "[.]"){
		*pResult = 0;
		return;
	}
	
	// Если имя файла

	m_sz_old_name = sz_name_dir;

	if(!m_List_files[pDispInfo->item.iItem]->bDirectory){
		*pResult = 0;
		return;
	}
	

	sz_name_dir.Delete(0);
	sz_name_dir.Delete(sz_name_dir.GetLength()-1);
	
	// Если имя каталога

	m_sz_old_name = sz_name_dir;

	CEdit *pEdit = GetEditControl();
	pEdit->SetWindowText(sz_name_dir);
	
	*pResult = 0;
}

// Заканчиваем редактировать имя файла	

void CNRListCtrl::OnLvnEndlabeledit(NMHDR *pNMHDR, LRESULT *pResult)
{
	NMLVDISPINFO *pDispInfo = reinterpret_cast<NMLVDISPINFO*>(pNMHDR);
	
	if(pDispInfo->item.iItem >= (int)m_List_files.size() || pDispInfo->item.iItem < 0){
		*pResult = 0;
		return;
	}
	
	CString sz_name_dir = m_List_files[pDispInfo->item.iItem]->szNameFile;
	if(sz_name_dir.IsEmpty() || sz_name_dir == "[..]" || sz_name_dir == "[.]"){
		*pResult = 0;
		return;
	}
	
	CEdit *pEdit = GetEditControl();
	pEdit->GetWindowText(m_sz_new_name);

	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	VERIFY(pFrame);
	pFrame->SendMessage(WM_RENAME_FILE, (WPARAM)m_sz_old_name.GetBuffer(), (LPARAM)m_sz_new_name.GetBuffer());
	*pResult = 0;
}
