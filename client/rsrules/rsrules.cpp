
#include <windows.h>
#include <commctrl.h>
#include <shlobj.h>
#include <objbase.h>
#include <shlwapi.h>
#include <stdlib.h>



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  if ( __argc < 2 )
     return 0;

  const char *mutexname = NULL;
  const char *filename = NULL;
  BOOL is_ls = FALSE;
  
  if ( !lstrcmpi(__argv[1],"-ls") )
     {
       if ( __argc < 3 )
          return 0;

       filename = __argv[2];
       is_ls = TRUE;
       mutexname = "_RSRulesLSMutex";
     }
  else
     {
       filename = __argv[1];
       is_ls = FALSE;
       mutexname = "_RSRulesMutex";
     }

  CreateMutex(NULL,FALSE,mutexname);
  if ( GetLastError() == ERROR_ALREADY_EXISTS )
     return 0;

  HWND hwnd = FindWindow("_RunpadClass",NULL);
  if ( !hwnd )
     return 0;

  InitCommonControls();
  OleInitialize(0);

  HINSTANCE lib = LoadLibrary("rsrules.dll");
  if ( lib )
     {
       void (__cdecl *ShowRules)(HWND,BOOL,const char*);

       *(void**)&ShowRules = (void*)GetProcAddress(lib,"ShowRules");
       if ( ShowRules )
          {
            ShowRules(hwnd,is_ls,filename);
          }

       FreeLibrary(lib);
     }

  OleUninitialize();

  return 1;
}
