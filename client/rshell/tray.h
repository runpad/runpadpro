
#ifndef ___TRAY_H___
#define ___TRAY_H___


#include <vector>


class CTrayIcon
{
  public:
          int version;
          HWND hwnd;
          int id;
          GUID guid;
          int message;
          HICON icon;
          BOOL hidden;
          BOOL hide_in_user_mode;
          char tip[256];

  public:
          CTrayIcon();
          ~CTrayIcon();

          BOOL IsSame(HWND _hwnd,int _id,const GUID& _guid) const;
          void ReplaceIcon(HICON i);
          BOOL IsHiddenSystemIcon() const;
          BOOL IsVisible() const;
          BOOL IsHidden() const;

  private:
          BOOL UseGuid() const;
};



class CTrayBalloon : public CWindowProc
{
           HWND balloon_hwnd;
           int version;
           HWND hwnd;
           int id;
           GUID guid;
           int message;
           HICON icon;
           char szInfo[256];
           char szInfoTitle[64];
           HICON close_icon;
           HFONT font1;
           HFONT font2;
           int exit_code;
           RECT r_icon;
           RECT r_close;
           RECT r_title;
           RECT r_text;
           RECT r_window;
           RBUFF back_buff;

  public:
           CTrayBalloon();
           ~CTrayBalloon();

           BOOL IsShown(const CTrayIcon *newicon) const;
           void Hide(const CTrayIcon *newicon);
           void Show(const CTrayIcon *newicon,const char *szInfo,const char *szInfoTitle,DWORD uTimeout,DWORD dwInfoFlags);

  protected:         
           LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
           void Draw(HWND hwnd,HDC hdc);

};



class CTray : public CWindowProc
{
          typedef struct {
            HWND hWnd;
            UINT uID;
            UINT uFlags;
            UINT uCallbackMessage;
            HICON hIcon;
            char szTip[256];
            DWORD dwState;
            DWORD dwStateMask;
            char szInfo[256];
            char szInfoTitle[64];
            DWORD uTimeout;
            DWORD uVersion;
            DWORD dwInfoFlags;
            GUID guidItem;
          } NOTIFYICONDATAMY;

          typedef struct {
            HWND hwnd;
            int id;
            GUID guid;
          } ICONID;
     

          HWND w_main, w_panel;
          int msg_panel_update, msg_redraw_single_icon;

          CRITICAL_SECTION o_cs;
          HANDLE h_thread;
          DWORD id_thread;

          const THEME2D *cfg_theme2d; // copy from global variables
          TCFGLIST1 cfg_list_safe;    // copy from global variables
          TCFGLIST1 cfg_list_hidden;  // copy from global variables
          int cfg_max_vis;            // copy from global variables
          BOOL cfg_is_safe_tray;      // copy from global variables

          HWND tooltip;

          HANDLE event_ready;
          HANDLE event_finish;
          
          CTrayBalloon *p_balloon;    // created in thread
          
          typedef std::vector<CTrayIcon*> TTrayIcons;
          TTrayIcons *p_trayicons;    // created in thread
          
          HWND traywnd, notifywnd, clockwnd;   // created in thread

          char lasttime[32];

  public:
          CTray(HWND main_window,HWND panel_window,int _msg_panel_update, int _msg_redraw_single_icon);
          ~CTray();

          int GetControlWidth();
          void OnClick(int message,WPARAM wParam,LPARAM lParam);
          void OnPaint(HDC hdc);
          void OnConfigChange();
          void OnDisplayChange(int sw,int sh);
          void OnNotifyMessage(NMHDR *i);
          void OnUpdate();
          void OnRedrawSingleIcon(WPARAM wParam,LPARAM lParam);

  protected:
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
          static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
          DWORD ThreadProc();
          
          void SetTips_NoGuard();
          void GetIconRect_NoGuard(int num,RECT *r);
          void GetClockRect_NoGuard(RECT *r);
          BOOL IsWindowInList(HWND w,const TCFGLIST1& list);
          void ClockClick(int message);
          void DrawClock_NoGuard(HDC hdc);
          BOOL IsTimeChanged(void);
          void DrawIcons_NoGuard(HDC hdc);
          void OnTimer();
          BOOL DeleteTrayIcon_NoGuard(int idx);
          BOOL DeleteTrayIcon(const ICONID *icon);
          BOOL SetTrayIconVersion(const ICONID *icon,int version);
          BOOL GetTrayIconRect(const ICONID *icon,RECT *_r);
          BOOL ModifyTrayIcon(const NOTIFYICONDATAMY *icon);
          BOOL AddTrayIcon(const NOTIFYICONDATAMY *icon);
          LRESULT TrayCommandNotify(WPARAM wParam,void *lpData,int cbData);
          LRESULT TrayCommandAppBar(WPARAM wParam,void *lpData,int cbData);
          LRESULT TrayCommandLoadInProc(WPARAM wParam,void *lpData,int cbData);
          LRESULT TrayCommandIconGetRect(WPARAM wParam,void *lpData,int cbData);
          LRESULT TrayCommand(WPARAM wParam,LPARAM lParam);

};



#endif
