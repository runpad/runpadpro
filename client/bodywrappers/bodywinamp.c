
#include <windows.h>


const WCHAR *text = L"Для запуска безопасного Winamp просто запускайте стандартный Winamp";
const WCHAR *caption = L"Безопасный Winamp";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
