
#ifndef __VSCONTROL_H__
#define __VSCONTROL_H__



class CVSControl : public CWindowProc
{
          HWND hwnd;

          TENVENTRY client;
          BOOL is_webcam;
          BOOL is_paused;
          BOOL is_fullscreen;
          RECT nfs_rect;
          const float *fps_list;
          int fps_list_count;
          int fps_idx;

          struct {
           int w,h;
           HDC hdc;
           HBITMAP bitmap,oldb;
          } g_buff;

  public:
          CVSControl();
          ~CVSControl();

          void Open(HWND parent,BOOL webcam,const TENVENTRY *_client);
          void Close();
          void IncomingScreen(const CNetCmd &cmd,unsigned src_guid);

          HWND GetWindowHandle();

  private:
          void FreeDrawBuff();
          void Paint(HDC hdc);
          void OnTimer();
          void SendFinalPacket();
          void SwitchFullScreen();
          void UpdateWindowCaption();
          void SwitchPause();
          void SetFPSTimer();
          void SaveParms();
          void ProcessMenu();

  protected:
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

};


#endif

