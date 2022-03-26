
#ifndef __PLUGIN_H__
#define __PLUGIN_H__



class CCore;

class CPlugin : public CWindowProc
{
          HWND host_wnd;
          HWND m_wnd;

          TDeskExternalConnection *conn;
          CCore *m_core;

          static int g_numobjects;

  public:
          CPlugin(HWND _host_wnd,TDeskExternalConnection *_conn);
          ~CPlugin();

          void Refresh();
          void Repaint();
          void OnStatusStringChanged();
          void OnActiveSheetChanged();
          void OnPageShaded();
          void OnDisplayChanged();

  protected:
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
          void GetHostSize(int &_w,int &_h);

};



#endif

