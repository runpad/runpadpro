
#include <windows.h>
#include <commctrl.h>
#include "resource.h"



BOOL CALLBACK MainDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  static HWND last = NULL;
  
  if ( message == WM_INITDIALOG )
     {
       SetTimer(hwnd,1,200,NULL);
       SetForegroundWindow(hwnd);
     }
  
  if ( message == WM_TIMER && wParam == 1 )
     {
       char s[200];
       HWND w = GetForegroundWindow();
       if ( w != hwnd && w != last )
          {
            last = w;
            s[0] = 0;
            GetClassName(w,s,sizeof(s));
            SetDlgItemText(hwnd,IDC_EDIT,s);
            SendDlgItemMessage(hwnd,IDC_EDIT,EM_SETSEL,0,-1);
          }
     }
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     EndDialog(hwnd,0);

  return FALSE;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  InitCommonControls();
  DialogBox(GetModuleHandle(NULL),MAKEINTRESOURCE(IDD_MAIN),NULL,MainDialog);
  ExitProcess(1);
}
