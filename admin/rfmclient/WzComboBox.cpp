//	CCWzComboBox.cpp : implementation file
/*********************************************************************
*	Author:		Simon Wang
*	Date:		2002-06-21
*	Contact us:	Inte2000@263.net
**********************************************************************/
#include "stdafx.h"
#include "WzComboBox.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CWzComboBox

CWzComboBox::CWzComboBox()
{
	m_crBkGnd = ::GetSysColor(COLOR_WINDOW);
	m_crHiLightBkGnd = ::GetSysColor(COLOR_HIGHLIGHT);
	m_crText = ::GetSysColor(COLOR_WINDOWTEXT);
	m_crHiLightText = ::GetSysColor(COLOR_HIGHLIGHTTEXT);
	m_crHiLightFrame = RGB(0,0,0);

	m_pImgList = NULL;

	///VERIFY(m_ImgList.Create(16, 16, ILC_COLOR32 | ILC_MASK, 2, 1));
}

CWzComboBox::~CWzComboBox()
{
	//if(m_ImgList.GetSafeHandle() != NULL)
	//	m_ImgList.DeleteImageList();
}


BEGIN_MESSAGE_MAP(CWzComboBox, CComboBox)
	//{{AFX_MSG_MAP(CWzComboBox)
	ON_CONTROL_REFLECT(CBN_DROPDOWN, OnDropdown)
	ON_WM_PAINT()
	ON_WM_SYSCOLORCHANGE()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CWzComboBox message handlers
void CWzComboBox::OnDropdown() 
{
	RecalcDropWidth();
}

/***************************Virtual Function***************************************************/
void CWzComboBox::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct) 
{
	ASSERT(lpDrawItemStruct != NULL);
	ASSERT(lpDrawItemStruct->CtlType == ODT_COMBOBOX);	
	if(int(lpDrawItemStruct->itemID) < 0)
		return;

	CDC* pDC   = CDC::FromHandle(lpDrawItemStruct->hDC);

	if (!IsWindowEnabled()) 
	{
		pDC->FillSolidRect(&lpDrawItemStruct->rcItem,RGB(192,192,192));
		pDC->SetBkMode(TRANSPARENT);
		pDC->SetTextColor(::GetSysColor(COLOR_WINDOWTEXT));

		DrawIconString(lpDrawItemStruct, FALSE);
    
    return;
  }

  // Selected
	if ((lpDrawItemStruct->itemState & ODS_SELECTED) && (lpDrawItemStruct->itemAction & (ODA_SELECT | ODA_DRAWENTIRE))) 
	{
		pDC->FillSolidRect(&lpDrawItemStruct->rcItem,m_crBkGnd);
		pDC->SetBkMode(TRANSPARENT);
		pDC->SetTextColor(m_crHiLightText);
    
		DrawIconString(lpDrawItemStruct, TRUE);
    
  }

  // De-Selected
	if (!(lpDrawItemStruct->itemState & ODS_SELECTED) && (lpDrawItemStruct->itemAction & (ODA_SELECT | ODA_DRAWENTIRE))) 
	{
		pDC->FillSolidRect(&lpDrawItemStruct->rcItem,m_crBkGnd);
		pDC->SetBkMode(TRANSPARENT);
		pDC->SetTextColor(m_crText);

		DrawIconString(lpDrawItemStruct, FALSE);
	}

}

void CWzComboBox::DrawIconString(LPDRAWITEMSTRUCT lpDIS, BOOL bselected)
{
	CDC* pDC = CDC::FromHandle(lpDIS->hDC);
	LPITEMDATA pData= (LPITEMDATA)GetItemData(lpDIS->itemID);
	CRect rcText(lpDIS->rcItem);
	rcText.right -= 1;//space for right border

	if (m_pImgList && m_pImgList->GetImageCount() > 0)//has icon attach
	{
		POINT pt;
		CRect rcIcon;

		TRACE(_T("itemState = %d, itemAction = %d\n"),lpDIS->itemState,lpDIS->itemAction);

//@**#---2002-07-21 22:10:05 (Simon)---#**@
//#ifdef _WIN2K_CHINESE_SP2
//		if(lpDIS->itemState == ODS_COMBOBOXEDIT && lpDIS->itemAction == ODA_DRAWENTIRE)//4096
//			rcIcon.left = rcText.left + 2;
//		else if(lpDIS->itemState == (ODS_FOCUS|ODS_COMBOBOXEDIT|ODS_SELECTED) && lpDIS->itemAction == ODA_DRAWENTIRE)//4113
//			rcIcon.left = rcText.left + 2;
//#else //_WIN2K_ENGLISH_SP3
//		if(lpDIS->itemState == 4864 && lpDIS->itemAction == 1)
//			rcIcon.left = rcText.left + 2;
//		else if(lpDIS->itemState == 4881 && lpDIS->itemAction == 1)//4113
//			rcIcon.left = rcText.left + 2;
//#endif

		if((lpDIS->itemState & ODS_COMBOBOXEDIT) && lpDIS->itemAction == ODA_DRAWENTIRE)
			rcIcon.left = rcText.left + 2;
		else
			rcIcon.left = rcText.left + pData->cLevel * 20;//20 = 18+2
		rcIcon.top = rcText.top;
		rcIcon.bottom = rcText.bottom;
		rcIcon.right = rcIcon.left + 18;

		pt.x = rcIcon.left + 2;
		pt.y = rcIcon.top;
		m_pImgList->Draw(pDC,pData->cType,pt,ILD_TRANSPARENT);
		if(bselected)
		{
			rcIcon.InflateRect(0,0,1,0);
			pDC->Draw3dRect(rcIcon,RGB(255,128,128),RGB(0,0,255));
		}
		rcText.left = rcIcon.right+2;
	}

	CString string = _T(""); 
	if (lpDIS->itemID != -1) 
		GetLBText(lpDIS->itemID, string);

	if(bselected)
	{
		pDC->FillSolidRect(&rcText,m_crHiLightBkGnd);
		CPen penFrame(PS_SOLID, 1, m_crHiLightFrame);
		CPen *pOP = pDC->SelectObject(&penFrame);
		pDC->SelectStockObject(NULL_BRUSH);
		pDC->Rectangle(&rcText);
		pDC->SelectObject(pOP);
		penFrame.DeleteObject();
	}

	rcText.DeflateRect(3,1,2,1);
  pDC->DrawText(string, rcText, DT_SINGLELINE |DT_VCENTER ); 
}   

void CWzComboBox::MeasureItem(LPMEASUREITEMSTRUCT lpMeasureItemStruct) 
{
	ASSERT(lpMeasureItemStruct->CtlType == ODT_COMBOBOX);

	lpMeasureItemStruct->itemHeight = 18;//Icon 16X16
}

void CWzComboBox::DeleteItem(LPDELETEITEMSTRUCT lpDeleteItemStruct) 
{
	ASSERT(lpDeleteItemStruct->CtlType == ODT_COMBOBOX);
	LPITEMDATA pData = (LPITEMDATA)GetItemData(lpDeleteItemStruct->itemID);
	delete pData;//release our data 
	CComboBox::DeleteItem(lpDeleteItemStruct);
}

void CWzComboBox::PreSubclassWindow() 
{
	CComboBox::PreSubclassWindow();

  ::SendMessage(m_hWnd, CB_SETITEMHEIGHT, (WPARAM)-1, 16L);//use 16X16 size icon
}

/***************************Owner Function****************************************************/


WORD CWzComboBox::AddCTString(WORD wParentIdx,BYTE cType,LPCTSTR lpszString)
{
	int idx = -1;
	if(wParentIdx == nRootIndex)//if root node,just Add to the end of String List
	{
		idx = CComboBox::AddString(lpszString);//InsertString is not a virtual function
		LPITEMDATA pData = new ITEMDATA;
		ASSERT(pData != NULL);
		pData->cLevel = 0;
		pData->cType = cType;
		pData->wOriginIdx = (WORD)idx;
		pData->wParantOriginIdx = wParentIdx;
		SetItemData(idx, (DWORD_PTR)pData);
	}
	else
	{
		int ParentCurrentIdx = CurrentIdxFromOriginIdx((int)wParentIdx);
		LPITEMDATA pParentData = (LPITEMDATA)GetItemData(ParentCurrentIdx);
		int count = GetChildCount(pParentData->wOriginIdx);//Get All children node,include children's children node
		int pos = wParentIdx + count + 1;
		idx = CComboBox::InsertString(pos,lpszString);//InsertString is not a virtual function
		LPITEMDATA pData = new ITEMDATA;
		ASSERT(pData != NULL);
		pData->cLevel = pParentData->cLevel + 1;
		pData->cType = cType;
		pData->wOriginIdx = (WORD)idx;
		pData->wParantOriginIdx = pParentData->wOriginIdx;
		SetItemData(idx,(DWORD_PTR)pData);
	}

	return (WORD)idx;
}
//delete a item and all children item,return the remain node of Combox
int CWzComboBox::DeleteCTString(int index)
{
	LPITEMDATA pdata = (LPITEMDATA)GetItemData(index);
	BOOL bFind = TRUE;
	//delete all children nodes of this node
	while(bFind)
	{
		bFind = FALSE;//finish mark
		int count = GetCount();//get total items
		for(int i = index + 1; i < count; i++)//search from index+1
		{
			LPITEMDATA p = (LPITEMDATA)GetItemData(i);
			if(p->cLevel > pdata->cLevel)//children nodes' cLevel is higher than parent's node
			{
				bFind = TRUE;//find a children node,maybe more,so...
				CComboBox::DeleteString(i);
				break;
			}
		}
	}
	//delete this node at last
	CComboBox::DeleteString(index);
	return GetCount();
}

//Get All children node,include children's children node
int CWzComboBox::GetChildCount(WORD wParentIdx)
{
	LPITEMDATA pdata = (LPITEMDATA)GetItemData(wParentIdx);
	int nTotalCount = GetCount();
	int wChildCount = 0;
	for(int i = wParentIdx+1; i < nTotalCount; i++)
	{
		LPITEMDATA p = (LPITEMDATA)GetItemData(i);
		if(p->cLevel > pdata->cLevel)//children nodes' cLevel is higher than parent's node
			wChildCount++;
		else
			break;
	}

	return wChildCount;
}

//get node is current index by search original index
int CWzComboBox::CurrentIdxFromOriginIdx(int wOriginIdx)
{
	int nRtn = -1;
	int count = GetCount();
	for(int i = 0; i < count; i++)
	{
		LPITEMDATA pData = (LPITEMDATA)GetItemData(i);
		if(wOriginIdx == (int)pData->wOriginIdx)
		{
			nRtn = i;
			break;
		}
	}

	return nRtn;
}

void CWzComboBox::RecalcDropWidth()
{
	int nNumEntries = GetCount();
	int nWidth = 0;
	CString str;

//@**#---2002-06-26 16:58:48 (Simon)---#**@
//	CClientDC dc(this);
//	int nSave = dc.SaveDC();
//	dc.SelectObject(GetFont());

	CDC *pDC = GetDC();
	int nScrollWidth = ::GetSystemMetrics(SM_CXVSCROLL);
	for (int i = 0; i < nNumEntries; i++)
	{
		GetLBText(i, str);
		LPITEMDATA pData = (LPITEMDATA)GetItemData(i);
		int nLength = 20 + pData->cLevel * 8 + pDC->GetTextExtent(str).cx + nScrollWidth + 30;
//@**#---2002-06-26 17:06:08 (orbit)---#**@
//		SIZE size;
//		::GetTextExtentPoint32(pDC->GetSafeHdc(),str,str.GetLength(),&size);
//		int nLength = 20 + pData->cLevel * 8 + size.cx + nScrollWidth;
		nWidth = max(nWidth, nLength);
	}

	// Add margin space to the calculations
	nWidth += pDC->GetTextExtent("0").cx;

//	dc.RestoreDC(nSave);
	ReleaseDC(pDC);

	SetDroppedWidth(nWidth);
}

void CWzComboBox::DrawCombo(DWORD dwStyle, COLORREF clrTopLeft, COLORREF clrBottomRight)
{
	CRect rcItem;
	GetClientRect(&rcItem);
	CDC* pDC = GetDC();
	
	// Cover up dark 3D shadow.
	pDC->Draw3dRect(rcItem, clrTopLeft, clrBottomRight);
	rcItem.DeflateRect(1,1);
	
	if (!IsWindowEnabled()) 
	{
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),::GetSysColor(COLOR_BTNHIGHLIGHT));
	}
	
	else 
	{
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),::GetSysColor(COLOR_BTNFACE));
	}

	// Cover up dark 3D shadow on drop arrow.
	rcItem.DeflateRect(1,1);
	rcItem.left = rcItem.right-::GetSystemMetrics(SM_CXHTHUMB);//Offset();
	pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),::GetSysColor(COLOR_BTNFACE));
	
	// Cover up normal 3D shadow on drop arrow.
	rcItem.DeflateRect(1,1);
	pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),::GetSysColor(COLOR_BTNFACE));
	
	if (!IsWindowEnabled()) 
	{
		return;
	}

	switch (dwStyle)
	{
	case FC_DRAWNORMAL:
		rcItem.top -= 1;
		rcItem.bottom += 1;
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),::GetSysColor(COLOR_BTNHIGHLIGHT));
		rcItem.left -= 1;
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),::GetSysColor(COLOR_BTNHIGHLIGHT));
		break;

	case FC_DRAWRAISED:
		rcItem.top -= 1;
		rcItem.bottom += 1;
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),::GetSysColor(COLOR_BTNSHADOW));
		break;

	case FC_DRAWPRESSD:
		rcItem.top -= 1;
		rcItem.bottom += 1;
		rcItem.OffsetRect(1,1);
		pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNSHADOW),::GetSysColor(COLOR_BTNHIGHLIGHT));
		break;
	}

	ReleaseDC(pDC);
}
  
void CWzComboBox::OnPaint() 
{
	Default();
	DrawCombo(FC_DRAWRAISED, ::GetSysColor(COLOR_BTNSHADOW),::GetSysColor(COLOR_BTNHIGHLIGHT));
}

void CWzComboBox::OnSysColorChange() 
{
	CComboBox::OnSysColorChange();

	m_crBkGnd = ::GetSysColor(COLOR_WINDOW);
	m_crHiLightBkGnd = ::GetSysColor(COLOR_HIGHLIGHT);
	m_crText = ::GetSysColor(COLOR_WINDOWTEXT);
	m_crHiLightText = ::GetSysColor(COLOR_HIGHLIGHTTEXT);
}

