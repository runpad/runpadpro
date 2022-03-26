
#include <windows.h>


const WCHAR *text = L"Для запуска безопасного Word просто запускайте стандартный winword.exe";
const WCHAR *caption = L"Безопасный Word";


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  MessageBoxW(NULL,text,caption,MB_OK | MB_ICONINFORMATION);
  ExitProcess(1);
}
