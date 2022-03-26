

class CWindowProc
{
  protected:
            void InitWindowProcWrapper(HWND hwnd);
            void DoneWindowProcWrapper(HWND hwnd);

            static LRESULT CALLBACK WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
            virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam) = 0;
};


class CWindow : public CWindowProc
{
          HWND m_wnd;
          int msg_taskbar;
          int msg_user;

  public:
          CWindow(int _msg_user);
          ~CWindow();

          HWND GetHandle() const { return m_wnd; }
          static const char* GetClassName();

  protected:         
           LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

};

