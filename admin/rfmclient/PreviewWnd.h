#pragma once

#define TF_BINARY	0
#define TF_TEXT		1

#define  MIN_SIZE_TF			4096	

// CPreviewWnd dialog

class CPreviewWnd : public CDialog
{
	DECLARE_DYNAMIC(CPreviewWnd)

public:
	CPreviewWnd(CString szPathFile, CWnd* pParent = NULL);   // standard constructor
	virtual ~CPreviewWnd();

// Dialog Data
	enum { IDD = IDD_PREVIEW_WINDOW };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
private:
	HDC m_memCDC;
	// Длина вичитаного блока
	UINT m_iLenReadBlock;	
	// Подгрузить новые данные
	void LoadNewData(UINT iPos);
	// Буфер для перерисовки
	char m_chDataFirst[MIN_SIZE_TF];
	// Вырисовать данные
	void DrawData(CDC *pDC);
	// Тип загруженного файла
	UINT m_iTypeFile;
	// Путь к просматриваемому файлу
	CString m_szPathFile;
	DECLARE_MESSAGE_MAP()
	virtual BOOL OnInitDialog();
	CFile	m_filePreview;	
	// Определить тип файла
	UINT GetTypeFile();
	afx_msg void OnPaint();
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnSize(UINT nType, int cx, int cy);
};
