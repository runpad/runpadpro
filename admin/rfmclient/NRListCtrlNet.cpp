// NRListCtrlNet.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "NRListCtrlNet.h"
#include "mainfrm.h"

UINT WM_ITEM_SELECT = RegisterWindowMessage("List item select");
extern UINT WM_LISTFILES_DBSEL;
extern UINT WM_SET_LIST_CURSOR;
extern UINT WM_RENAME_FILE;

// CNRListCtrlNet

IMPLEMENT_DYNAMIC(CNRListCtrlNet, CNRListCtrl)

CNRListCtrlNet::CNRListCtrlNet(CImageList *pimageListSys) :
	CNRListCtrl(pimageListSys)	
{
		
}

CNRListCtrlNet::~CNRListCtrlNet()
{
}


BEGIN_MESSAGE_MAP(CNRListCtrlNet, CNRListCtrl)
	ON_NOTIFY_REFLECT(NM_DBLCLK, &CNRListCtrlNet::OnNMDblclk)
	ON_WM_KEYDOWN()
	ON_NOTIFY_REFLECT(LVN_KEYDOWN, &CNRListCtrlNet::OnLvnKeydown)
	ON_NOTIFY_REFLECT(LVN_ITEMCHANGED, &CNRListCtrlNet::OnLvnItemchanged)
	ON_WM_SETFOCUS()
	ON_NOTIFY_REFLECT(LVN_ENDLABELEDIT, &CNRListCtrlNet::OnLvnEndlabeledit)
END_MESSAGE_MAP()



// CNRListCtrlNet message handlers



void CNRListCtrlNet::OnNMDblclk(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	
	GetParent()->SendMessage(WM_LISTFILES_DBSEL, (WPARAM)pNMLV->iItem, (LPARAM)0);
		
	*pResult = 0;
}

void CNRListCtrlNet::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CNRListCtrl::OnKeyDown(nChar, nRepCnt, nFlags);
}

void CNRListCtrlNet::OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLVKEYDOWN pLVKeyDow = reinterpret_cast<LPNMLVKEYDOWN>(pNMHDR);
	if(pLVKeyDow->wVKey == VK_RETURN)
	{
		GetParent()->SendMessage(WM_LISTFILES_DBSEL, (WPARAM)m_nCursorItem, (LPARAM)0);
	}
	
	*pResult = 0;
}

void CNRListCtrlNet::OnLvnItemchanged(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	
	m_nCursorItem = pNMLV->iItem;
	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	VERIFY(pFrame);
	pFrame->m_bCursorWindow = false;
	SetFocus();
	*pResult = 0;
	GetParent()->PostMessage(WM_ITEM_SELECT, (WPARAM)m_nCursorItem);
}



void CNRListCtrlNet::OnSetFocus(CWnd* pOldWnd)
{
	CListCtrl::OnSetFocus(pOldWnd);

	CMainFrame *pFrame = (CMainFrame*)GetParentFrame();
	VERIFY(pFrame);
	pFrame->SendMessage(WM_SET_LIST_CURSOR, (WPARAM)false);
}

// Заканчиваем редактировать данные

void CNRListCtrlNet::OnLvnEndlabeledit(NMHDR *pNMHDR, LRESULT *pResult)
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

	GetParent()->SendMessage(WM_RENAME_FILE, (WPARAM)m_sz_old_name.GetBuffer(), (LPARAM)m_sz_new_name.GetBuffer());
	*pResult = 0;
}
