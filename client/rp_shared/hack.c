
#include <windows.h>
#include <shlwapi.h>
#include <sddl.h>
#include <Aclapi.h>
#include "rp_shared.h"
#include "lang.h"



static void DoCreateProcessMessage(void)
{
  HWND w = FindWindow("_RunpadClass",NULL);

  if ( w )
     {
       ATOM atom = GlobalAddAtom(S_RUNPROTECT);
       if ( atom )
          PostMessage(w,WM_USER+165,(int)atom,0);
     }
}



#define my_alloc(x) (HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, x))
#define my_free(x)  (HeapFree(GetProcessHeap(), 0, x))


static BOOL WINAPI MyCreateProcessA(
  LPCSTR lpApplicationName,
  LPSTR lpCommandLine,
  LPSECURITY_ATTRIBUTES lpProcessAttributes,
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  BOOL bInheritHandles,
  DWORD dwCreationFlags,
  LPVOID lpEnvironment,
  LPCSTR lpCurrentDirectory,
  LPSTARTUPINFO lpStartupInfo,
  LPPROCESS_INFORMATION lpProcessInformation
)
{
  if ( lpProcessInformation )
     {
       lpProcessInformation->hProcess = NULL;
       lpProcessInformation->hThread = NULL;
       lpProcessInformation->dwProcessId = 0;
       lpProcessInformation->dwThreadId = 0;
     }

  DoCreateProcessMessage();   

  SetLastError(ERROR_FILE_NOT_FOUND);
  return FALSE;
}


static BOOL WINAPI MyCreateProcessW(
  LPCWSTR lpApplicationName,
  LPWSTR lpCommandLine,
  LPSECURITY_ATTRIBUTES lpProcessAttributes,
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  BOOL bInheritHandles,
  DWORD dwCreationFlags,
  LPVOID lpEnvironment,
  LPCWSTR lpCurrentDirectory,
  LPSTARTUPINFO lpStartupInfo,
  LPPROCESS_INFORMATION lpProcessInformation
)
{
  if ( lpProcessInformation )
     {
       lpProcessInformation->hProcess = NULL;
       lpProcessInformation->hThread = NULL;
       lpProcessInformation->dwProcessId = 0;
       lpProcessInformation->dwThreadId = 0;
     }

  DoCreateProcessMessage();   

  SetLastError(ERROR_FILE_NOT_FOUND);
  return FALSE;
}


static BOOL WINAPI MyCreateProcessASilent(
  LPCSTR lpApplicationName,
  LPSTR lpCommandLine,
  LPSECURITY_ATTRIBUTES lpProcessAttributes,
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  BOOL bInheritHandles,
  DWORD dwCreationFlags,
  LPVOID lpEnvironment,
  LPCSTR lpCurrentDirectory,
  LPSTARTUPINFO lpStartupInfo,
  LPPROCESS_INFORMATION lpProcessInformation
)
{
  if ( lpProcessInformation )
     {
       lpProcessInformation->hProcess = NULL;
       lpProcessInformation->hThread = NULL;
       lpProcessInformation->dwProcessId = 0;
       lpProcessInformation->dwThreadId = 0;
     }

  SetLastError(ERROR_FILE_NOT_FOUND);
  return FALSE;
}


static BOOL WINAPI MyCreateProcessWSilent(
  LPCWSTR lpApplicationName,
  LPWSTR lpCommandLine,
  LPSECURITY_ATTRIBUTES lpProcessAttributes,
  LPSECURITY_ATTRIBUTES lpThreadAttributes,
  BOOL bInheritHandles,
  DWORD dwCreationFlags,
  LPVOID lpEnvironment,
  LPCWSTR lpCurrentDirectory,
  LPSTARTUPINFO lpStartupInfo,
  LPPROCESS_INFORMATION lpProcessInformation
)
{
  if ( lpProcessInformation )
     {
       lpProcessInformation->hProcess = NULL;
       lpProcessInformation->hThread = NULL;
       lpProcessInformation->dwProcessId = 0;
       lpProcessInformation->dwThreadId = 0;
     }

  SetLastError(ERROR_FILE_NOT_FOUND);
  return FALSE;
}


typedef struct {
void *base_addr;
void *func_addr;
char old_bytes[6];
char pad[2];
} HACK;


__declspec(dllexport)  void* __cdecl HackAPIFunction(const char *dll_name,const char *function_name,void *new_func)
{
  HINSTANCE lib;
  void *p;
  
  if ( !new_func )
     return NULL;
     
  lib = GetModuleHandle(dll_name);
  if ( !lib )
     lib = LoadLibrary(dll_name);
  p = (void*)GetProcAddress(lib,function_name);

  if ( p )
     {
       HANDLE h = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE,FALSE,GetCurrentProcessId());
       if ( h )
          {
            HACK *hack_handle = NULL;
            DWORD rc = 0;

            hack_handle = my_alloc(sizeof(*hack_handle));
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


__declspec(dllexport)  BOOL __cdecl UnhackAPIFunction(void *hack_handle)
{
  BOOL exit_code = FALSE;
  
  if ( hack_handle )
     {
       HANDLE h = OpenProcess(PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE,FALSE,GetCurrentProcessId());
       if ( h )
          {
            HACK *p = hack_handle;
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


__declspec(dllexport) void* __cdecl HackCreateProcessA(BOOL silent)
{
  return HackAPIFunction("kernel32.dll","CreateProcessA",silent?MyCreateProcessASilent:MyCreateProcessA);
}

__declspec(dllexport) void* __cdecl HackCreateProcessW(BOOL silent)
{
  return HackAPIFunction("kernel32.dll","CreateProcessW",silent?MyCreateProcessWSilent:MyCreateProcessW);
}

__declspec(dllexport) void __cdecl UnhackCreateProcess(void *h)
{
  UnhackAPIFunction(h);
}


__declspec(dllexport) void __cdecl ChangeProcessTerminateRights(BOOL state)
{
  HANDLE h;
  BOOL (WINAPI *pConvertStringSecurityDescriptorToSecurityDescriptor)(
      IN  LPCSTR StringSecurityDescriptor,
      IN  DWORD StringSDRevision,
      OUT PSECURITY_DESCRIPTOR  *SecurityDescriptor,
      OUT PULONG  SecurityDescriptorSize OPTIONAL ) = NULL;
  BOOL (WINAPI *pConvertSecurityDescriptorToStringSecurityDescriptor)(
      IN  PSECURITY_DESCRIPTOR  SecurityDescriptor,
      IN  DWORD RequestedStringSDRevision,
      IN  SECURITY_INFORMATION SecurityInformation,
      OUT LPSTR  *StringSecurityDescriptor OPTIONAL,
      OUT PULONG StringSecurityDescriptorLen OPTIONAL ) = NULL;
  
  pConvertStringSecurityDescriptorToSecurityDescriptor = (void*)GetProcAddress(GetModuleHandle("advapi32.dll"),"ConvertStringSecurityDescriptorToSecurityDescriptorA");
  pConvertSecurityDescriptorToStringSecurityDescriptor = (void*)GetProcAddress(GetModuleHandle("advapi32.dll"),"ConvertSecurityDescriptorToStringSecurityDescriptorA");

  if ( !pConvertStringSecurityDescriptorToSecurityDescriptor || !pConvertSecurityDescriptorToStringSecurityDescriptor )
     return;

  h = OpenProcess(STANDARD_RIGHTS_ALL,FALSE,GetCurrentProcessId());
  if ( h )
     {
       ACL *dacl = NULL;
       SECURITY_DESCRIPTOR *desc = NULL;

       if ( GetSecurityInfo(h,SE_KERNEL_OBJECT,DACL_SECURITY_INFORMATION,NULL,NULL,&dacl,NULL,&desc) == ERROR_SUCCESS )
          {
            char *s = NULL;
            if ( pConvertSecurityDescriptorToStringSecurityDescriptor(desc,SDDL_REVISION_1,DACL_SECURITY_INFORMATION,&s,NULL) )
               {
                 if ( s )
                    {
                      SECURITY_DESCRIPTOR *new_desc = NULL;
                      char *p = my_alloc(lstrlen(s)+1),*t;

                      const char *sub1 = IsRunningUnderVistaLonghorn() ? "0x1fffff" : "0x1f0fff";
                      const char *sub2 = IsRunningUnderVistaLonghorn() ? "0x1ffffe" : "0x1f0ffe";
                      const char *s_find = state ? sub1 : sub2;
                      const char *s_replace = state ? sub2 : sub1;

                      lstrcpy(p,s);

                      while ( t = StrStrI(p,s_find) )
                      {
                        CopyMemory(t,s_replace,lstrlen(s_replace));
                      }

                      if ( pConvertStringSecurityDescriptorToSecurityDescriptor(p,SDDL_REVISION_1,&new_desc,NULL) )
                         {
                           ACL *dacl = NULL;
                           BOOL present = FALSE,def = FALSE;

                           GetSecurityDescriptorDacl(new_desc,&present,&dacl,&def);
                           
                           if ( dacl )
                           {
                             if ( SetSecurityInfo(h,SE_KERNEL_OBJECT,DACL_SECURITY_INFORMATION,NULL,NULL,dacl,NULL) == ERROR_SUCCESS )
                                {
                                  //ok
                                }
                           }

                           if ( new_desc )
                              LocalFree(new_desc);
                         }

                      my_free(p);
                      
                      LocalFree(s);
                    }
               }

            if ( desc )
               LocalFree(desc);
          }

       CloseHandle(h);
     }
}
