
#include <windows.h>


const WCHAR *text = L"Для запуска безопасного Media Player Classic просто запускайте стандартный Media Player Classic";
const WCHAR *caption = L"Безопасный Media Player Classic";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
