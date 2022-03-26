

class CTrayIcon
{
          typedef struct {
            DWORD cbSize;
            HWND hWnd;
            UINT uID;
            UINT uFlags;
            UINT uCallbackMessage;
            HICON hIcon;
            CHAR szTip[128];
            DWORD dwState;
            DWORD dwStateMask;
            CHAR szInfo[256];
            union {
            	UINT uTimeout;
            	UINT uVersion;
            };
            CHAR szInfoTitle[64];
            DWORD dwInfoFlags;
          } NOTIFYICONDATAEX;

          NOTIFYICONDATAEX m_info;

  public:
          CTrayIcon(HWND hwnd,int message,const char *initial_tip);
          ~CTrayIcon();

          void DisplayInfoTip(const char *text);
          void RecreateIcon();

};
