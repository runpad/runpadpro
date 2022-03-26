// PreviewWnd.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "PreviewWnd.h"


#define  COUNT_SYMB_ONE_LINE	75	

// CPreviewWnd dialog

IMPLEMENT_DYNAMIC(CPreviewWnd, CDialog)

CPreviewWnd::CPreviewWnd(CString szPathFile, CWnd* pParent /*=NULL*/)
	: CDialog(CPreviewWnd::IDD, pParent)
{
	m_szPathFile = szPathFile;
	m_iTypeFile = TF_BINARY;
	memset(m_chDataFirst, 0x0, MIN_SIZE_TF);
	m_iLenReadBlock = 0;
	m_memCDC = ::CreateCompatibleDC(NULL);
}

CPreviewWnd::~CPreviewWnd()
{
	if(m_filePreview.m_hFile != INVALID_HANDLE_VALUE)
		m_filePreview.Close();
	::DeleteDC(m_memCDC);
}

void CPreviewWnd::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CPreviewWnd, CDialog)
	ON_WM_PAINT()
	ON_WM_ERASEBKGND()
	ON_WM_SIZE()
END_MESSAGE_MAP()


// CPreviewWnd message handlers

BOOL CPreviewWnd::OnInitDialog()
{
	CDialog::OnInitDialog();

	SetWindowText(m_szPathFile);

	if(!m_filePreview.Open(m_szPathFile, CFile::modeRead))
	{
		MessageBox("Невозможно открыть файл для просмотра", "ClientRFM", MB_ICONERROR);
		return TRUE;
	}

	// тип файла
	
	//m_iTypeFile = GetTypeFile();

	// Загрузить новые данные

	LoadNewData(0);

	return TRUE;
}

// Определить тип файла

UINT CPreviewWnd::GetTypeFile()
{
	char chData[MIN_SIZE_TF];
	int	 count_find=0;

	UINT uRead = m_filePreview.Read(chData, MIN_SIZE_TF);
	
	for(UINT i=0; i<uRead; i++)
	{
		if((i+1) < uRead && chData[i] == 0xD && chData[i+1] == 0xA)
			count_find++;
			
	}
		
	if(count_find >= 0x4)
		return TF_TEXT;
	
	m_filePreview.SeekToBegin();

	return TF_BINARY;
}

void CPreviewWnd::OnPaint()
{
	CPaintDC dc(this); 
	// Вырисовать данные
	DrawData(&dc);	
}

// Вырисовать данные

void CPreviewWnd::DrawData(CDC *pDC)
{
	ASSERT(pDC);

	RECT rc_wnd, rcCopy;
	::GetClientRect(GetSafeHwnd(), &rc_wnd);
	memcpy(&rcCopy, &rc_wnd, sizeof(RECT));
	HBITMAP h_mem_bmp = ::CreateCompatibleBitmap(pDC->m_hDC, rc_wnd.right-rc_wnd.left, rc_wnd.bottom-rc_wnd.top);
	::SelectObject(m_memCDC, h_mem_bmp);	
	HBRUSH h_brush = ::CreateSolidBrush(RGB(255, 255, 255));
	::FillRect(m_memCDC, &rc_wnd, h_brush);
	::InflateRect(&rc_wnd, -5, -5);
	::DrawText(m_memCDC, m_chDataFirst, m_iLenReadBlock, &rc_wnd, DT_LEFT | DT_TOP);
	::BitBlt(pDC->m_hDC, 0, 0, rcCopy.right, rcCopy.bottom, m_memCDC, 0, 0, SRCCOPY);  	
	::DeleteObject(h_brush);
	::DeleteObject(h_mem_bmp);
}

// Подгрузить новые данные

void CPreviewWnd::LoadNewData(UINT iPos)
{
	m_iLenReadBlock = m_filePreview.Read(m_chDataFirst, MIN_SIZE_TF);
	Invalidate();
}


BOOL CPreviewWnd::OnEraseBkgnd(CDC* pDC)
{
	

	return CDialog::OnEraseBkgnd(pDC);
}

void CPreviewWnd::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);

	Invalidate();
}
