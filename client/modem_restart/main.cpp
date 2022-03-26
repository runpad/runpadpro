
#include <windows.h>
#include <commctrl.h>
#include "resource.h"
#include "m_callisto.h"
#include "m_tplink.h"
#include "utils.h"


#define REGPATH  "Software\\DSLRestarter"
#define HKCU HKEY_CURRENT_USER


HINSTANCE instance;


static const struct {
const TCHAR *name;
BOOL (*restart)(const CHAR *s_ip);
} modems[] = 
{
  {TEXT("Callisto"),Restart_Callisto},
  {TEXT("TP-Link"),Restart_TPLink},
};



BOOL CALLBACK MainDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       SetClassLong(hwnd,GCL_HICON,(int)LoadIcon(instance,MAKEINTRESOURCE(IDI_ICON)));

       for ( int n = 0; n < sizeof(modems)/sizeof(modems[0]); n++ )
           {
             SendDlgItemMessage(hwnd,IDC_COMBO,CB_ADDSTRING,0,(LPARAM)modems[n].name);
           }
       
       int def_modem = ReadRegDword(HKCU,REGPATH,"Modem",0);
       SendDlgItemMessage(hwnd,IDC_COMBO,CB_SETCURSEL,def_modem,0);

       CHAR def_ip[MAX_PATH];
       ReadRegStr(HKCU,REGPATH,"IP",def_ip,"");
       if ( !def_ip[0] )
          lstrcpy(def_ip,"192.168.1.1");
       SetDlgItemTextA(hwnd,IDC_EDIT,def_ip);
       
       SetFocus(GetDlgItem(hwnd,IDOK));
     }

  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       CHAR ip[MAX_PATH] = "";
       GetDlgItemTextA(hwnd,IDC_EDIT,ip,MAX_PATH-1);

       if ( !ip[0] )
          {
            MessageBox(hwnd,TEXT("Не указан IP-адрес"),NULL,MB_OK | MB_ICONERROR);
            SetFocus(GetDlgItem(hwnd,IDC_EDIT));
          }
       else
          {
            EnableWindow(GetDlgItem(hwnd,IDC_COMBO),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDC_EDIT),FALSE);
            EnableWindow(GetDlgItem(hwnd,IDOK),FALSE);
            UpdateWindow(hwnd);
            SetCursor(LoadCursor(NULL,IDC_WAIT));

            int modem = SendDlgItemMessage(hwnd,IDC_COMBO,CB_GETCURSEL,0,0);
            BOOL rc = modems[modem].restart(ip);

            SetCursor(LoadCursor(NULL,IDC_ARROW));

            if ( rc )
               {
                 WriteRegDword(HKCU,REGPATH,"Modem",modem);
                 WriteRegStr(HKCU,REGPATH,"IP",ip);
                 
                 MessageBox(hwnd,TEXT("Завершено успешно!"),TEXT("Информация"),MB_OK | MB_ICONINFORMATION);
                 EndDialog(hwnd,1);
               }
            else
               {
                 MessageBox(hwnd,TEXT("Ошибка выполнения"),NULL,MB_OK | MB_ICONERROR);
               }
            
            EnableWindow(GetDlgItem(hwnd,IDC_COMBO),TRUE);
            EnableWindow(GetDlgItem(hwnd,IDC_EDIT),TRUE);
            EnableWindow(GetDlgItem(hwnd,IDOK),TRUE);
            SetFocus(GetDlgItem(hwnd,IDOK));
          }
     }
     
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     EndDialog(hwnd,0);

  return FALSE;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  InitCommonControls();
  instance = GetModuleHandle(NULL);
  DialogBox(instance,MAKEINTRESOURCE(IDD_MAIN),NULL,MainDialog);
  return 1;
}
