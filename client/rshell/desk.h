
#ifndef ___DESK_H___
#define ___DESK_H___


class CDesk
{
          HWND w_main, w_desk;

  public:
          CDesk(HWND main_window);
          ~CDesk();

          HWND GetWindow();
          BOOL IsVisible(void);
          void Hide(void);
          void Show(void);
          void Repaint(void);
          void Refresh(void);
          void BringToBottom(void);
          void OnConfigChange(void);
          void OnDisplayChange(int sw,int sh);
          void OnTimer(void);
          void OnEndSession(void);
          void OnStatusStringChanged();
          void OnActiveSheetChanged();
          void OnPageShaded();

};



#endif

