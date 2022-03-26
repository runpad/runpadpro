
#include <windows.h>
#include "hh_api/htmlhelp.h"



__declspec(dllexport) HWND __cdecl HHW_DisplayTopic(HWND parent,
                                                    const char *filename,
                                                    const char *url,
                                                    const char *winname)
{
  char s[MAX_PATH*2];
  
  if ( !filename || !filename[0] )
     return NULL;

  if ( !parent )
     parent = GetDesktopWindow();

  lstrcpy(s,filename);

  if ( url && url[0] )
     {
       lstrcat(s,"::");
       if ( url[0] != '/' )
          lstrcat(s,"/");
       lstrcat(s,url);
     }

  if ( winname && winname[0] )
     {
       lstrcat(s,">");
       lstrcat(s,winname);
     }

  return HtmlHelp(parent,s,HH_DISPLAY_TOPIC,0);
}


__declspec(dllexport) void __cdecl HHW_Close(void)
{
  HtmlHelp(NULL,NULL,HH_CLOSE_ALL,0);
}


BOOL WINAPI _DllMainCRTStartup(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  return TRUE;
}


