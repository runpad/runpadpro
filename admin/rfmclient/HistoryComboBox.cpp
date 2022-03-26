// HistoryComboBox.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "HistoryComboBox.h"

UINT WM_ENTER_KEY = ::RegisterWindowMessage("Enter key");


// CHistoryComboBox

IMPLEMENT_DYNAMIC(CHistoryComboBox, CComboBox)

CHistoryComboBox::CHistoryComboBox()
{

}

CHistoryComboBox::~CHistoryComboBox()
{
}


BEGIN_MESSAGE_MAP(CHistoryComboBox, CComboBox)
	ON_WM_KEYDOWN()
	ON_WM_SYSKEYDOWN()
	ON_WM_CHAR()
	ON_WM_SYSCHAR()
END_MESSAGE_MAP()



// CHistoryComboBox message handlers



void CHistoryComboBox::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CComboBox::OnKeyDown(nChar, nRepCnt, nFlags);
}

void CHistoryComboBox::OnSysKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CComboBox::OnSysKeyDown(nChar, nRepCnt, nFlags);
}

void CHistoryComboBox::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CComboBox::OnChar(nChar, nRepCnt, nFlags);
}

void CHistoryComboBox::OnSysChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CComboBox::OnSysChar(nChar, nRepCnt, nFlags);
}

BOOL CHistoryComboBox::PreTranslateMessage(MSG* pMsg)
{
	if(pMsg->message == WM_KEYDOWN && pMsg->wParam == 0xD)
	{
		AddNewLine();
		GetParent()->SendMessage(WM_ENTER_KEY);
	}

	return CComboBox::PreTranslateMessage(pMsg);
}

void CHistoryComboBox::AddNewLine()
{
	CString sz_text;
	GetWindowText(sz_text);
	if(sz_text.IsEmpty())
		return;
	AddString(sz_text);
	if(GetCount() > MAX_HISTORY_LINES)
		DeleteString(0);

}

