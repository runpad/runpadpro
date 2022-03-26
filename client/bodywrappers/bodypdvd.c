
#include <windows.h>


const WCHAR *text = L"Для запуска безопасного Power DVD просто запускайте стандартный Power DVD";
const WCHAR *caption = L"Безопасный Power DVD";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
