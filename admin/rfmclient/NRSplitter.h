//
//  CNRSplitter


#if !defined(SIMPLE_SPLITTER)
#define SIMPLE_SPLITTER

#define SSP_HORZ		1
#define SSP_VERT		2


class CNRSplitter : public CWnd
{
public:
	CNRSplitter(int nPanes, UINT nOrientation = SSP_HORZ, int nMinSize = 30, int nBarThickness = 3);
	~CNRSplitter();

	BOOL Create(CWnd* pParent, UINT nID = AFX_IDW_PANE_FIRST);
	BOOL CreatePane(int nIndex, CWnd* pPaneWnd, DWORD dwStyle, DWORD dwExStyle, LPCTSTR lpszClassName = NULL);
	
	int GetPaneCount() const							{ return m_nPanes; }
	void SetPane(int nIndex, CWnd* pPaneWnd);
	CWnd* GetPane(int nIndex) const;
	virtual void SetActivePane(int nIndex);
	CWnd* GetActivePane(int* pIndex) const;
	void SetPaneSizes(const int* sizes);
	void GetPaneRect(int nIndex, CRect& rcPane) const;
	void GetBarRect(int nIndex, CRect& rcBar) const;

protected:
	void RecalcLayout();
	void ResizePanes();
	void InvertTracker();
	
	//{{AFX_MSG(CNRSplitter)
	afx_msg void OnPaint();
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg BOOL OnNcCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnWindowPosChanging(WINDOWPOS FAR* lpwndpos);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

protected:
	const int m_nPanes;
	const UINT m_nOrientation;
	const int m_nMinSize, m_nBarThickness;

	int m_nTrackIndex, m_nTracker, m_nTrackerLength, m_nTrackerMouseOffset;
	
	CWnd** m_pane;
	int *m_size, *m_orig;
};


#endif
