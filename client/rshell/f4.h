
#ifndef ___F4_H___
#define ___F4_H___


class CWaitCursor
{
          static unsigned ref_count;

  public:
          CWaitCursor();
          ~CWaitCursor();

          static void UpdateCurrentCursor();
          static BOOL IsWaitCursor();

  private:
          static unsigned GetRefCount();
};


class CForegroundWindowGuard
{
          HWND old_fg;
  public:
          CForegroundWindowGuard();
          ~CForegroundWindowGuard();
};


void DisableDesktopComposition(void);
BOOL IsDesktopCompositionEnabled(void);
BOOL IsAppWindow(HWND w);
void UpdateTracking(HWND hwnd);
void UpdateTrackingWithHover(HWND hwnd);
HWND FindGCWindow(void);
HWND GetTopOwner(HWND hwnd);
BOOL IsFullScreenAppFind(void);
void SetGeneralHotKeys(HWND w);
void CheckVolumes(HWND w_main);
void PrepareVolumeMixer(HWND w);
void FinishVolumeMixer(void);
void ProcessMonitorPower(void);
void TurnOffMonitor(int input_off,int interval);
void TurnOnMonitor(void);
void MessageLoopNeverReturns(void);
void ProcessMessages(void);
void OnWinKeyPressed(void);
void ExecHotKeyEvent(int id);
BOOL IsWindowClientRealVisible(HWND hwnd);
BOOL CanUseGFX();
BOOL CanUseGFXThreadSafe();


#endif


