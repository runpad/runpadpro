
#include "include.h"



CComModule _Module;

BEGIN_OBJECT_MAP(ObjectMap)
OBJECT_ENTRY(CLSID_MyShellExecuteHook, CMyShellExecuteHook)
OBJECT_ENTRY(CLSID_MyCopyHook,         CMyCopyHook)
OBJECT_ENTRY(CLSID_MyFileSaveDialog,   CMyFileSaveDialog)
OBJECT_ENTRY(CLSID_MyFileOpenDialog,   CMyFileOpenDialog)
END_OBJECT_MAP()



extern "C" 
BOOL WINAPI DllMain(HINSTANCE hInstance, DWORD dwReason, LPVOID lpReserved)
{
  if ( dwReason == DLL_PROCESS_ATTACH )
     {
       _Module.Init(ObjectMap, hInstance);
       //DisableThreadLibraryCalls(hInstance);
     }
  else 
  if ( dwReason == DLL_PROCESS_DETACH )
     {
       _Module.Term();
     }

  return TRUE;
}


STDAPI DllCanUnloadNow(void)
{
  return (_Module.GetLockCount()==0) ? S_OK : S_FALSE;
}

STDAPI DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID* ppv)
{
  return _Module.GetClassObject(rclsid, riid, ppv);
}

STDAPI DllRegisterServer(void)
{
  return _Module.RegisterServer(FALSE);
}

STDAPI DllUnregisterServer(void)
{
  return _Module.UnregisterServer(FALSE);
}


