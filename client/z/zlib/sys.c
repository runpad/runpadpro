
#include <windows.h>
#include "sys.h"



//#ifdef Z_DLL
//int WINAPI _DllMainCRTStartup(void *hInst,int reason,void *lpReserved)
//{
//  return 1;
//}
//#endif



void *z_sys_alloc(unsigned size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void z_sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}
