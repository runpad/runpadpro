
#ifndef ___TASKPANE_H___
#define ___TASKPANE_H___


#include "tray.h"
#include "ql.h"
#include <vector>


class CDesk;

class CTaskPane : public CWindowProc
{
          class CWinApp
          {
            public:
                   HWND hwnd;
                   BOOL active;
                   HICON icon;
                   char title[MAX_PATH];
                   unsigned last_update_time;  //used for icons update only!

            public:
                   CWinApp();
                   ~CWinApp(); 
                   CWinApp(const CWinApp& other);
                   CWinApp& operator = (const CWinApp& other);

            public:
                   void SetIconFromWindow(HWND w);
                   void SetTitleFromWindow(HWND w);
          };
          
          class CWin : public CWinApp
          {
            public:
                   int group; // -1 : no group

            public:
                   inline CWin() : group(-1) {}

                   void LoadFromWindow(HWND w);
                   void SetGroupIdFromWindow(HWND w);
          };

          typedef std::vector<CWin> TWinList;

          class CApp : public CWinApp
          {
            public:
                   TWinList wins;

            public:
                   void SetTitleFromGroupIdAndCount(int id,int count);
          };

          typedef std::vector<CApp> TAppList;

          TWinList wins;

          HWND w_main, w_panel;

          CTray *tray;
          CQuickLaunch *ql;
          CDesk *desk;
          
          int msg_panel_update, msg_redraw_single_icon;
          int msg_shellhook;
          HICON icon16x16;
          BOOL menu_active;
          unsigned last_menu_active;
          RECT hl_rect;
          HWND tooltip;
          HWND ghost_window;
          BOOL is_xp_theme_active;

  public:
          CTaskPane(HWND main_window);
          ~CTaskPane();

          void SetDeskObj(CDesk *obj);
          
          BOOL IsVisible(void);
          void Hide(void);
          void Show(void);
          void Repaint(void);
          void Refresh(void);
          void OnConfigChange(void);
          void OnDisplayChange(int sw,int sh);
          void OnTimer(void);
          void OnEndSession(void);
          void EmulateButtonClick(void);
          void SwitchMenuButton(void);
          void OnDeskMouseDown();

  protected:
          virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
          TAppList* BuildAppsList();
          void FreeAppsList(TAppList *apps);
          BOOL GetSheetRectByWinNumber(int num,RECT *r);
          void PanelAdd(HWND w);
          void PanelRemove(HWND w);
          void PanelReplace(HWND w,HWND ghost);
          void PanelActivate(HWND w);
          void PanelRedraw(HWND w);
          BOOL PanelGetMinRect(HWND hwnd,RECT *r);
          void PanelShellActivate(void);
          void CheckDeadWindows(void);
          static BOOL CALLBACK EnumAppsProc(HWND hwnd,LPARAM lParam);
          void EnumApps(void);
          void GetSheetRect(int num,RECT *r,int numapps);
          void DrawSheets(HDC hdc);
          void DrawButton(HDC hdc);
          void DrawQL(HDC hdc);
          void DrawTray(HDC hdc);
          void UpdateButton(void);
          void SetTooltips(void);
          void DisplayTip(NMTTDISPINFO *i);
          void OnNotifyMessage(NMHDR *i);
          void PanelUpdate(void);
          void MinimizeOrMaximizeWindow(HWND hwnd,int active);
          void SheetClick(int x,int y);
          void SheetRClick(int x,int y);
          BOOL SheetTest(int x,int y);
          void ButtonClick(int x,int y);
          void OnPaint(HDC hdc);
          void ProcessHighliting(BOOL do_update);
          void SetPanelVisRegion(void);
          void RepositionPanel(void);
          void MinimizedWindowsTrayHide(void);
          void MinimizedWindowsTrayShow(void);
          void SetWorkArea(void);
          void ClearWorkArea(void);

};


#endif

