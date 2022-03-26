
#ifndef ___WORKSPACE_H___
#define ___WORKSPACE_H___


#include "taskpane.h"
#include "desk.h"


class CSheet;
class CSheetWindow;

class CWorkSpace : public CWindowProc
{
          HWND w_main, w_proxy;

          CDesk *desk;
          CTaskPane *taskpane;
          CSheetWindow *shwindow;

          int found_childs;
          
          int old_menushowdelay;
          int old_flatmenu;

  public:
          CWorkSpace();
          ~CWorkSpace();

          HWND GetMainWindow();
          BOOL IsVisible();
          void Hide(void);
          void Show(void);
          void OnEndSession(void);
          void OnConfigChange(void);
          void Repaint(void);
          void Refresh(void);
          BOOL HasChildWindows(void);
          void CloseChildWindowsAsync(void);
          void ToggleDesktop(void);
          void BalloonNotify(int icon,const char *title,const char *text,int delay);
          void EmulateButtonClick(void);
          void SwitchMenuButton(void);
          void OnDeskMouseDown();
          void OnStatusStringChanged();
          CSheet* GetActiveSheet();
          HWND GetActiveSheetWindowHandle();
          void CloseActiveSheet(BOOL do_desk_update);
          void SwitchToSheet(CSheet *sh);

  protected:
          virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
          static LRESULT CALLBACK ProxyWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          void InitProxyWindow(void);
          void DoneProxyWindow(void);
          static BOOL CALLBACK CloseAllChildsProc(HWND hwnd,LPARAM lParam);
          static BOOL CALLBACK HideAllChildsProc(HWND hwnd,LPARAM lParam);
          static BOOL CALLBACK ShowAllChildsProc(HWND hwnd,LPARAM lParam);
          static BOOL CALLBACK CalcAllChildsProc(HWND hwnd,LPARAM lParam);
          static BOOL CALLBACK MinimizeAllAppWindows(HWND hwnd,LPARAM lParam);
          void OnDisplayChange(int sw,int sh);
          void CheckDisplayModeChanged(void);
          void OnTimer(int type);
          void InitBalloonNotify();
          void DoneBalloonNotify();
          void HideBalloonNotify(void);
          void OnBalloonNotifyMessage(int wParam,int lParam);

          static void LoadSheetCallback(int perc,void *parm);
          static void OnManualSheetWindowClosed(void *parm);
          static void OnDeskShade(void *parm);
          void OnSheetWindowClosed(BOOL do_desk_update);
          void OnDeskShadeChanged();
          void RepaintTaskPaneOnly(void);
};



void WorkSpaceInit(void);
void WorkSpaceDone(void);
HWND GetMainWnd(void);
BOOL IsWorkSpaceVisible(void);
void WorkSpaceShow(void);
void WorkSpaceHide(void);
void WorkSpaceOnEndSession(void);
void WorkSpaceOnConfigChange(void);
void WorkSpaceRepaint(void);
void WorkSpaceRefresh(void);
void WorkSpaceOnDeskMouseDown();
void WorkSpaceOnStatusStringChanged();
BOOL IsAnyChildWindows(void);
void CloseChildWindowsAsync(void);
void ToggleDesktop(void);
void BalloonNotify(int icon,const char *title,const char *text,int delay);
void EmulateStartButtonClick(void);
void SwitchMenuButton(void);
CSheet* GetActiveSheet();
HWND GetActiveSheetWindowHandle();
void CloseActiveSheet(BOOL do_desk_update);
void SwitchToSheet(CSheet *new_sheet);



#endif

