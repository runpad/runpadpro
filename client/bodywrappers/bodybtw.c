
#include <windows.h>


const WCHAR *text = L"Работа с Bluetooth/IrDA осуществляется из проводника пользователя";
const WCHAR *caption = L"Работа с Bluetooth/IrDA";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
