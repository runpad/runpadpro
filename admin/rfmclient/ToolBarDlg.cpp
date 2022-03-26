// ToolBarDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "ToolBarDlg.h"



// CToolBarDlg dialog

IMPLEMENT_DYNAMIC(CToolBarDlg, CDialogBar)

CToolBarDlg::CToolBarDlg(CWnd* pParent /*=NULL*/)
	//: CDialog(CToolBarDlg::IDD, pParent)
{

}

CToolBarDlg::~CToolBarDlg()
{
}

void CToolBarDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogBar::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BTN_CONNECT, m_btnConnect);
	DDX_Control(pDX, IDC_BTN_DISCONNECT, m_btnDisConnect);
	DDX_Control(pDX, IDC_BTN_CREATEFILE, m_btnCreateFile);
	DDX_Control(pDX, IDC_BTN_CREATEDIR, m_btnCreateDir);
	DDX_Control(pDX, IDC_BTN_DELETEFILE, m_btnDeleteFile);
	DDX_Control(pDX, IDC_BTN_COPY, m_btnCopy);
	DDX_Control(pDX, IDC_BTN_MOVE, m_btnMove);
	DDX_Control(pDX, IDC_BTN_PREVIEW, m_btnPreview);
	DDX_Control(pDX, IDC_BTN_EDIT, m_btnEdit);
	DDX_Control(pDX, IDC_BTN_REFRESH, m_btnRefresh);
}


BEGIN_MESSAGE_MAP(CToolBarDlg, CDialogBar)
	ON_WM_CREATE()
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()



int CToolBarDlg::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CDialogBar::OnCreate(lpCreateStruct) == -1)
		return -1;

	


	return 0;
}

void CToolBarDlg::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CDialogBar::OnShowWindow(bShow, nStatus);

	
	
}

BOOL CToolBarDlg::Create(CWnd* pParentWnd, UINT nIDTemplate, UINT nStyle, UINT nID)
{
	if(!CDialogBar::Create(pParentWnd, nIDTemplate, nStyle, nID))
		return FALSE;

	UpdateData(FALSE);


	m_btnConnect.SetFlat(true);
	m_btnConnect.SetToolTipText(_T("Подключится к другому компьютеру"));
	m_btnConnect.SetShade(SHS_METAL);
	m_btnConnect.SetIcon(IDI_CONNECT, BS_LEFT);


	m_btnDisConnect.SetFlat(true);
	m_btnDisConnect.SetToolTipText(_T("Отключится от тукущего компьютера"));
	m_btnDisConnect.SetShade(SHS_METAL);
	m_btnDisConnect.SetIcon(IDI_DISCONNECT, BS_LEFT);

	m_btnCreateFile.SetFlat(true);
	m_btnCreateFile.SetToolTipText(_T("Создать новый файл"));
	m_btnCreateFile.SetShade(SHS_METAL);
	m_btnCreateFile.SetIcon(IDI_CREATEFILE, BS_LEFT);
	
	m_btnCreateDir.SetFlat(true);
	m_btnCreateDir.SetToolTipText(_T("Создать новый каталог"));
	m_btnCreateDir.SetShade(SHS_METAL);
	m_btnCreateDir.SetIcon(IDI_CREATEDIR, BS_LEFT);
	
	m_btnDeleteFile.SetFlat(true);
	m_btnDeleteFile.SetToolTipText(_T("Удалить файл или каталог"));
	m_btnDeleteFile.SetShade(SHS_METAL);
	m_btnDeleteFile.SetIcon(IDI_DELETEFILESDIR, BS_RIGHT);
	
	m_btnCopy.SetFlat(true);
	m_btnCopy.SetToolTipText(_T("Копировать файл(ы)"));
	m_btnCopy.SetShade(SHS_METAL);
	m_btnCopy.SetIcon(IDI_COPY, BS_LEFT);
	
	m_btnMove.SetFlat(true);
	m_btnMove.SetToolTipText(_T("Переместить файл(ы)"));
	m_btnMove.SetShade(SHS_METAL);
	m_btnMove.SetIcon(IDI_MOVE, BS_LEFT);
	
	m_btnPreview.SetFlat(true);
	m_btnPreview.SetToolTipText(_T("Просмотреть файл"));
	m_btnPreview.SetShade(SHS_METAL);
	m_btnPreview.SetIcon(IDI_PREVIEW, BS_LEFT);
	
	m_btnEdit.SetFlat(true);
	m_btnEdit.SetToolTipText(_T("Править файл"));
	m_btnEdit.SetShade(SHS_METAL);
	m_btnEdit.SetIcon(IDI_EDIT, BS_LEFT);

	m_btnRefresh.SetFlat(true);
	m_btnRefresh.SetToolTipText(_T("Обновить"));
	m_btnRefresh.SetShade(SHS_METAL);
	m_btnRefresh.SetIcon(IDI_REFRESH, BS_LEFT);
	
	return TRUE;
}


