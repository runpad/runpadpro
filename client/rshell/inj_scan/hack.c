
#include <windows.h>
#include <shlwapi.h>
#include "hack.h"


#define my_alloc(x) (HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, x))
#define my_free(x)  (HeapFree(GetProcessHeap(), 0, x))


HACK* HackAPIFunction(const char *dll_path,const char *function_name,void *new_func)
{
  HINSTANCE lib;
  void *p;
  
  if ( !new_func )
     return NULL;
     
  lib = GetModuleHandle(PathFindFileName(dll_path));
  if ( !lib )
     lib = LoadLibrary(dll_path);
  p = (void*)GetProcAddress(lib,function_name);

  if ( p )
     {
       HANDLE h = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE,FALSE,GetCurrentProcessId());
       if ( h )
          {
            HACK *hack_handle = NULL;
            DWORD rc = 0;

            hack_handle = (HACK*)my_alloc(sizeof(*hack_handle));
            hack_handle->base_addr = p;
            hack_handle->func_addr = new_func;
            
            if ( ReadProcessMemory(h,p,hack_handle->old_bytes,sizeof(hack_handle->old_bytes),&rc) && rc == sizeof(hack_handle->old_bytes) )
               {
                 unsigned char buff[6] = {0xFF, 0x25, 0,0,0,0};

                 *(void**)(buff+2) = &hack_handle->func_addr;
                 
                 if ( WriteProcessMemory(h,p,buff,sizeof(buff),&rc) && rc == sizeof(buff) )
                    {
                      CloseHandle(h);

                      return hack_handle;
                    }
               }

            my_free(hack_handle);
            hack_handle = NULL;

            CloseHandle(h);
          }
     }

  return NULL;
}


BOOL UnhackAPIFunction(void *hack_handle)
{
  BOOL exit_code = FALSE;
  
  if ( hack_handle )
     {
       HANDLE h = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE,FALSE,GetCurrentProcessId());
       if ( h )
          {
            HACK *p = (HACK*)hack_handle;
            DWORD rc = 0;

            if ( WriteProcessMemory(h,p->base_addr,p->old_bytes,sizeof(p->old_bytes),&rc) && rc == sizeof(p->old_bytes) )
               {
                 my_free(hack_handle);
                 exit_code = TRUE;
               }

            CloseHandle(h);
          }
     }
  
  return exit_code;
}
