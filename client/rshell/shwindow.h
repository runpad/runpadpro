
#ifndef __SHWINDOW_H__
#define __SHWINDOW_H__


#include <vector>

class CSheet;
class CShortcut;
class CBackground4Sheet;
class CRBuff;
class CSystemIcon;


class CSheetWindow : public CWindowProc
{
  public:
           class CIcon
           {
                     CSheetWindow *shwindow;
                     CSystemIcon *icon_small;
                     CSystemIcon *icon_big;
                     RBUFF shadow;
                     const CShortcut *shortcut;
                     BOOL b_neticon;
                     HANDLE h_thread;
                     int i_group_idx; //group number
                     int i_local_idx; //index inside this group
             public:
                     CIcon(CSheetWindow *_shwindow,CSystemIcon* _small,CSystemIcon* _big,const CShortcut *shortcut_ptr,BOOL is_net_icon);
                     ~CIcon();
                     const CSystemIcon* GetSmallIcon() const { return icon_small; }
                     const CSystemIcon* GetBigIcon() const { return icon_big; }
                     const CShortcut* GetShortcut() const { return shortcut; }
                     void StartLazyLoadThread(HWND w_sheet,int self_idx,int session);
                     void UpdateIcons(CSystemIcon* _small,CSystemIcon* _big);
                     RBUFF* GetShadow() { return &shadow; }
                     void SetGroupAndLocalIndexes(int group,int local);
                     void GetGroupAndLocalIndexes(int &_group,int &_local) const;
             private:
                     static DWORD WINAPI LazyIconLoad(void *parm);
           };

  private:
           class COverlay
           {
                     HDC hdc;
                     HBITMAP bitmap,old_bitmap;
                     int w,h;
             public:
                     COverlay(int res_idx);
                     ~COverlay();
                     void Draw(HDC hdc,int x,int y);
                     int GetWidth() const { return w; }
                     int GetHeight() const { return h; }
           };


           typedef enum {
             AREA_NONE = 0,
             AREA_ICONS,
             AREA_BUTTONUP,
             AREA_BUTTONDOWN,
             AREA_SCROLLER,
             AREA_ENTIRESCROLL,
           } CLICKAREA;

           enum {
             DRAG_NONE = 0,
             DRAG_SCROLLER,
           } DRAGMODE;

           typedef struct {
             int idx;
             char text[16384];  //paranoja
             Bitmap *p_sshot;
             RECT client_rect;
             RBUFF back_buff;
           } TTOOLTIPDATA;

           typedef struct {
             int icon_idx;
             CSystemIcon* _big;
             CSystemIcon* _small;
             int session;
           } LAZYICONLOADUPDATEINFO;
           
           CSheet *m_sheet;

           COverlay *overlay_small;
           COverlay *overlay_big;

           int cell_width,cell_height;
           int icon_size1,icon_size2;
           int icon_size1w,icon_size2w;
           LOGFONT icons_font;

           typedef std::vector<CIcon*> TIcons;
           TIcons icons;

           typedef struct {
            int count; //count of icons in this group
            const char *name; // group name (do not free it!)
           } ICONGROUP;

           typedef std::vector<ICONGROUP> TIconGroups;
           TIconGroups icon_groups;

           int msg_updateicons;
           int hilited, last_hilited;
           float icons_scroll;
           int drag_mode;
           int hl_rect_idx;
           int g_movement_percent;  //used in icons highliting

           static volatile int icons_session;

           CBackground4Sheet *p_background;  // our background object

           TTOOLTIPDATA ttdata;
           HWND w_sheet;
           HWND tooltip;

           typedef void (*TOnClose)(void*);
           TOnClose on_close_proc;
           void *on_close_parm;

           typedef void (*TOnShade)(void*);
           TOnShade on_shade_proc;
           void *on_shade_parm;

           BOOL shade_lock;
           BOOL is_inside_sheet_loading;

  public:
           CSheetWindow(TOnClose OnCloseProc,void *OnCloseParm,
                        TOnShade OnShadeProc,void *OnShadeParm);
           ~CSheetWindow();

           CSheet* GetSheet() { return m_sheet; }
           HWND GetWindowHandle() { return w_sheet; }
           void Repaint();
           void OnEndSession();
           BOOL LoadSheet(CSheet *sheet,void(*cb)(int perc,void *parm),void *cb_parm);
           BOOL Close();

  protected:
           friend class CIcon;

           void GetPicIconSize1(int& _w,int& _h) const { _h = icon_size1; _w = icon_size1w; }
           void GetPicIconSize2(int& _w,int& _h) const { _h = icon_size2; _w = icon_size2w; }
           static int GetCurrentSession() { return icons_session; }
           
  private:
           BOOL IsInvalidIconIdx(int idx);
           BOOL IsWeAreMinimized();
           BOOL IsWeAreForeground();
           void SaverDropFiles(HDROP h);
           void RightClick(int x,int y,int idx);
           void ExecShortcut(int num,BOOL do_effect);
           void ShowShortcutDesc(int num);
           void ShowShortcutSshot(int num);
           void DesktopWheel(float delta);
           void DesktopKeyPress(int key);
           LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
           void UpdateDeskShade();
           void UpdateBGAnimationState();
           void SetWindowNullIcon();
           void SetWindowIcon(const char *file);
           void FreeContent(BOOL hide_window=TRUE);
           void InitBaseVars();
           int GetCurrentWindowWidth();
           int GetCurrentWindowHeight();
           
           int GetIconSize1() const { return icon_size1; }
           int GetIconSize2() const { return icon_size2; }
           float GetIconsScrollPos() const { return icons_scroll; }
           void RetrieveIconSystemParms();
           BOOL IsOnlyDefaultGroup();
           void GetGroupIdxByNum(int num,int &_group,int &_local);
           int GetNumByGroupIdx(int group,int local);
           int GetFirstVisIconIdx();
           int GetLastVisIconIdx();
           int GetGroupClientSizeWH(int group,int draw_wh_count);
           int GetGroupTotalSizeWH(int group,int draw_wh_count);
           int GetAllGroupsBeforeThisTotalSizeWH(int before_group,int draw_wh_count);
           int GetAllGroupsTotalSizeWH(int draw_wh_count);
           void GetCellsApprVisCount(int *_w,int *_h);
           BOOL GetSheetDrawRect(RECT *r,int *_delta);
           CLICKAREA GetClickArea(int x,int y,int *_idx);
           int Interpolate(int v1,int v2,int perc);
           void InterpolateRect(RECT *out,RECT *r1,RECT *r2,int perc);
           BOOL IsIconsScrollPresent(int *_delta);
           void GetCellXY(int n,int *_x,int *_y);
           void GetCellRect(int n,RECT *r);
           void MakeAbsolute(int n,RECT *r);
           void GetIconPlacement1(int n,RECT *r);
           void GetIconPlacement2(int n,RECT *r);
           void GetCellRectExt(int n,RECT *r);
           void GetTextPlacement1(RECT *r);
           void GetShadowPlacement1(RECT *r);
           void GetTextPlacement2(RECT *r);
           void GetShadowPlacement2(RECT *r);
           int GetIconByPos(int x,int y);
           void DrawSingleIcon(int n,HDC hdc,int hl,BOOL fulldraw,int perc);
           void DrawSingleText(int n,HDC hdc,CRBuff *i,RBUFF *shadow,int perc);
           void DrawHighlightUnderIcon(HDC hdc,int perc);
           void DrawGroupDividerInternal(HDC hdc,const RECT *rect,const char *name);
           void DrawIcons(HDC hdc,CRBuff *i);
           void HiliteIcon(int num);
           void Unhilite(void);
           void ProcessHighliting(BOOL from_wm_mousemove,BOOL do_update);
           HICON CreateHilitedIcon(HICON in);
           void CreateShadowInternal(RBUFF *shadow,const char *name,int perc);
           void GetGroupDividerRect(int group,RECT *_r);
           BOOL GetEntireScrollRect(RECT *r);
           void GetButtonScrollUpRect(RECT *r);
           void GetButtonScrollDownRect(RECT *r);
           void GetButtonScrollerRect(RECT *r);
           float GetNewScrollPosByXY(int x,int y);
           void DrawButton(RBUFF *buff,int x,int y,char *data,int color,int alpha);
           void DrawSheetBorder(HDC hdc);
           void Paint(HDC hdc);
           void UberEffect(int idx);

           CIcon* LoadShortcut(const CShortcut *sh);
           void LoadIcons();
           void PrepareForLazyIconsLoading(HWND w);
           void FreeIcons();
           void LoadBG();
           void FreeBG();
           BOOL IsBGMotion() const;

           void HideTooltips();
           void SetTooltips(void);
           void InitTooltipData(void);
           void FreeTooltipData(void);
           BOOL PreloadTooltipData(int idx,int *_w,int *_h);
           int DrawTooltip(NMTTCUSTOMDRAW *i);
           int OnTooltipNotify(NMHDR* hdr,BOOL *b_processed);
};



#endif

