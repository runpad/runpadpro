
#include <windows.h>


const WCHAR *text = L"Для запуска безопасного Excel просто запускайте стандартный excel.exe";
const WCHAR *caption = L"Безопасный Excel";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
