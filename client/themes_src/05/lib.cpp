
#include "include.h"


HINSTANCE our_instance = NULL;


extern "C" BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpvReserved)
{
  if ( fdwReason == DLL_PROCESS_ATTACH )
     {
       our_instance = hinstDLL;
     }

  return TRUE;
}


#define EXPORT



EXPORT void* __stdcall ThemeCreate(HWND host_wnd,TDeskExternalConnection* conn)
{
  CPlugin *obj = new CPlugin(host_wnd,conn);
  return obj;
}


EXPORT void  __stdcall ThemeDestroy(void *obj)
{
  if ( obj )
     {
       CPlugin *p = reinterpret_cast<CPlugin*>(obj);
       delete p;
     }
}


EXPORT void  __stdcall ThemeRefresh(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->Refresh();
     }
}


EXPORT void  __stdcall ThemeRepaint(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->Repaint();
     }
}


EXPORT void  __stdcall ThemeOnStatusStringChanged(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->OnStatusStringChanged();
     }
}


EXPORT void  __stdcall ThemeOnActiveSheetChanged(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->OnActiveSheetChanged();
     }
}


EXPORT void  __stdcall ThemeOnPageShaded(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->OnPageShaded();
     }
}


EXPORT void  __stdcall ThemeOnDisplayChanged(void *obj)
{
  if ( obj )
     {
       reinterpret_cast<CPlugin*>(obj)->OnDisplayChanged();
     }
}


