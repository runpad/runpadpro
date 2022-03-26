
#include <windows.h>



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  HWND w = FindWindow("_RunpadClass",NULL);

  if ( w )
     PostMessage(w,WM_USER+147,0,0);
  
  ExitProcess(1);
}
