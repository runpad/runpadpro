// CmdLineDlg.cpp : implementation file
//

#include "stdafx.h"
#include "rfmclient.h"
#include "CmdLineDlg.h"


extern UINT WM_ENTER_KEY;



// CCmdLineDlg dialog

IMPLEMENT_DYNAMIC(CCmdLineDlg, CDialogBar)

CCmdLineDlg::CCmdLineDlg(CWnd* pParent /*=NULL*/)
{
	VERIFY(m_fontDrives.CreateFont(
				   12,
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
}

CCmdLineDlg::~CCmdLineDlg()
{
	m_fontDrives.DeleteObject();
}

void CCmdLineDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogBar::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STAT_PATH, m_ctrl_cmd_line);
	DDX_Control(pDX, IDC_CMB_CMD_LINE, m_ctrl_combo_cmd_line);
}



BEGIN_MESSAGE_MAP(CCmdLineDlg, CDialogBar)
	ON_WM_CREATE()
	ON_WM_SIZE()
	ON_CBN_SELENDOK(IDC_CMB_CMD_LINE, &CCmdLineDlg::OnCbnSelendokCmbCmdLine)
	ON_CBN_EDITCHANGE(IDC_CMB_CMD_LINE, &CCmdLineDlg::OnCbnEditchangeCmbCmdLine)
	ON_CBN_EDITUPDATE(IDC_CMB_CMD_LINE, &CCmdLineDlg::OnCbnEditupdateCmbCmdLine)
	ON_REGISTERED_MESSAGE(WM_ENTER_KEY, &CCmdLineDlg::OnComboEnterKey)
END_MESSAGE_MAP()



// CCmdLineDlg message handlers

void CCmdLineDlg::OnEnChangeEdCommandLine()
{
	
}

int CCmdLineDlg::OnCreate(LPCREATESTRUCT lpCreateStruct)
{
	if (CDialogBar::OnCreate(lpCreateStruct) == -1)
		return -1;

	return 0;
}

void CCmdLineDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialogBar::OnSize(nType, cx, cy);

	if(!m_ctrl_cmd_line.m_hWnd || !m_ctrl_combo_cmd_line.m_hWnd || !cx)
		return;
	
	int i_len_path = (int)cx/3;

	WINDOWPLACEMENT plc1, plc2;
	m_ctrl_cmd_line.GetWindowPlacement(&plc1);
	m_ctrl_combo_cmd_line.GetWindowPlacement(&plc2);
	
	m_ctrl_cmd_line.SetWindowPos(NULL, 0, plc1.rcNormalPosition.top, i_len_path, plc1.rcNormalPosition.bottom - plc1.rcNormalPosition.top, NULL);
	m_ctrl_combo_cmd_line.SetWindowPos(NULL, i_len_path+4, plc2.rcNormalPosition.top, (i_len_path*2)-6, 
									  plc2.rcNormalPosition.bottom - plc2.rcNormalPosition.top, NULL);
}

BOOL CCmdLineDlg::Create(CWnd* pParentWnd, UINT nIDTemplate, UINT nStyle, UINT nID)
{
	if(!CDialogBar::Create(pParentWnd, nIDTemplate, nStyle, nID))
		return FALSE;
	
	UpdateData(FALSE);

	m_ctrl_cmd_line.SetFont(&m_fontDrives);
	m_ctrl_combo_cmd_line.SetFont(&m_fontDrives);

	return TRUE;
}


// Установить путь

void CCmdLineDlg::SetPathStatic(CString sz_path)
{
	if(m_ctrl_cmd_line.m_hWnd)
		m_ctrl_cmd_line.SetWindowText(sz_path);
}


// Определить путь

CString CCmdLineDlg::GetPathStatic()
{
	CString sz_path;
	m_ctrl_cmd_line.GetWindowText(sz_path);
	return sz_path;
}

// Установить имя файла

void CCmdLineDlg::SetFileName(CString sz_f_name)
{
	m_ctrl_combo_cmd_line.SetWindowText(sz_f_name);
}

// Определить имя файла

CString CCmdLineDlg::GetFileName()
{
	CString sz_f_name;
	m_ctrl_combo_cmd_line.GetWindowText(sz_f_name);
	return sz_f_name;
}
void CCmdLineDlg::OnCbnSelendokCmbCmdLine()
{
	// TODO: Add your control notification handler code here
}

void CCmdLineDlg::OnCbnEditchangeCmbCmdLine()
{
	// TODO: Add your control notification handler code here
}

void CCmdLineDlg::OnCbnEditupdateCmbCmdLine()
{
	// TODO: Add your control notification handler code here
}

LRESULT CCmdLineDlg::OnComboEnterKey(WPARAM wp, LPARAM lp)
{
	GetParentFrame()->SendMessage(WM_ENTER_KEY);
	return TRUE; 
}
