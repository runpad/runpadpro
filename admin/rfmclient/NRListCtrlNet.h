#pragma once

#include "NRListCtrl.h"

// CNRListCtrlNet

class CNRListCtrlNet : public CNRListCtrl
{
	DECLARE_DYNAMIC(CNRListCtrlNet)

public:
	CNRListCtrlNet(CImageList *pimageListSys);
	virtual ~CNRListCtrlNet();

protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnNMDblclk(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnLvnKeydown(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLvnItemchanged(NMHDR *pNMHDR, LRESULT *pResult);
private:
	// »конки дл€ серверной стороны 
	CImageList m_imgList;
//	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnSetFocus(CWnd* pOldWnd);
	afx_msg void OnLvnEndlabeledit(NMHDR *pNMHDR, LRESULT *pResult);
};


