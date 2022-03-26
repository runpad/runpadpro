#pragma once


// Максимальное количество строк которое хранится в истории
#define MAX_HISTORY_LINES 20

// CHistoryComboBox

class CHistoryComboBox : public CComboBox
{
	DECLARE_DYNAMIC(CHistoryComboBox)

public:
	CHistoryComboBox();
	virtual ~CHistoryComboBox();

protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
public:
	afx_msg void OnSysKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
public:
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
public:
	afx_msg void OnSysChar(UINT nChar, UINT nRepCnt, UINT nFlags);
public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
private:
	void AddNewLine();
};

