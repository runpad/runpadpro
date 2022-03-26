#pragma once

#include "NRFileData.h"
#include <vector>
using namespace std;



// CNRListCtrl

class CNRListCtrl : public CListCtrl
{
	DECLARE_DYNAMIC(CNRListCtrl)

public:
	CNRListCtrl(CImageList *pimageListSys);
	virtual ~CNRListCtrl();
	// Добавить новые данные для отображения
	virtual BOOL SetNewDataFiles(CNRFileData *pNewFileData, bool b_only_files=false);
	int GetCurrentIndx(){return m_nCursorItem;} 
	void SetCurrentIndx(int indx){m_nCursorItem = indx;} 
protected:
	DECLARE_MESSAGE_MAP()
	// Выделенный элемент в списке текущий  
	int m_nCursorItem;
	CString m_sz_old_name,	// Старое имя файла
			m_sz_new_name;  // Новое имя файла
	// Данные для перерисовки ListCtrl 
	CListFiles m_List_files;
public:
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnLvnItemchanged(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMDblclk(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLvnGetdispinfo(NMHDR *pNMHDR, LRESULT *pResult);
	// Индекс поля по которому идет сортировка
	static int  g_nIndxField; 
	// переключение сортировки
	static bool g_bSwitchSort; 
	// Установить курсор
	void SetCursorItem();
	// Определить выделенный элемент 
	int GetSelectItem() const {return /*m_nCursorItem*/0;}
	// Очистить все 
	void ClearAll();
private:
	// Флаг отображения только файлов
	bool m_b_view_only_files;
	// Инициализировать список для отображения файлов на 
	void InitListLocalSystem();
	// Системный ImageList
	CImageList	*m_pimageListSys;
	// Шрифт текта
	CFont m_fontText;
	// Сортировать файлы по заданному массиву
	void SortItemsFile(int nSubItem);
	// Индекс начала файлов после каталогов
	// введено для сортировки данных
	CListFiles::iterator m_iter_begin_files;
	// Зачиска оставшиеся данных
	void ClearOldData();
	afx_msg void OnLvnColumnclick(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
//	afx_msg void OnAccelEnter();
//	afx_msg void OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	afx_msg void OnNMClick(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnSetFocus(CWnd* pOldWnd);
//	afx_msg void OnAccelEnter();
//	afx_msg void OnAccelEnter();
	afx_msg void OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLvnItemchanging(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLvnBeginlabeledit(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg virtual void OnLvnEndlabeledit(NMHDR *pNMHDR, LRESULT *pResult);
};


