
#include <windows.h>
#include <shlobj.h>
#include <objbase.h>
#include <stdio.h>
#include "../include/rs_api.h"
#include "../include/rs_api_i.c"


void main()
{
  HRESULT hr;
  IRunpadProShell *sh = NULL;

  CoInitialize(0);
  
  hr = CoCreateInstance( &CLSID_RunpadProShell, NULL, CLSCTX_INPROC_SERVER, &IID_IRunpadProShell, (void**)&sh);

  if( SUCCEEDED(hr) )
  {
    sh->lpVtbl->DoSingleAction(sh,RSA_MINIMIZEALLWINDOWS);
    
    sh->lpVtbl->Release(sh);
  }
  else
  {
    printf("Error: Runpad Pro Shell not installed\n");
  }

  CoUninitialize();
}
