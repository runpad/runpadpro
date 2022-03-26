
#include "include.h"



#define WRITEFILE(arglist)   { wsprintf arglist; if (h) sys_fwrite_txt(h,s); }


static int Handler(DWORD *top_esp,EXCEPTION_POINTERS *p,char *filename)
{
  EXCEPTION_RECORD *info = p->ExceptionRecord;
  CONTEXT *context = p->ContextRecord;

  char s[1024];

  void *h = sys_fcreate(GetErrLogFileName(filename));

  WRITEFILE((s,"Shell version: %s\n\n",RUNPAD_VERSION_STR));

  OSVERSIONINFO ver;
  ZeroMemory(&ver,sizeof(ver));
  ver.dwOSVersionInfoSize = sizeof(ver);
  if ( GetVersionEx(&ver) )
     WRITEFILE((s,"OS: %d.%d (build %d) %s\n\n",ver.dwMajorVersion,ver.dwMinorVersion,ver.dwBuildNumber,ver.szCSDVersion));

  {
    DEVMODE v;
    ZeroMemory(&v,sizeof(v));
    v.dmSize = sizeof(v);
    EnumDisplaySettings(NULL,ENUM_CURRENT_SETTINGS,&v);
    WRITEFILE((s,"VideoMode: %dx%d_%d\n\n",v.dmPelsWidth,v.dmPelsHeight,v.dmBitsPerPel));
  }

  if ( !IsWOW64() )
  {
    char env[MAX_PATH] = "";
    GetEnvironmentVariable("PROCESSOR_ARCHITECTURE",env,sizeof(env));
    WRITEFILE((s,"Processor: %s\n\n",env));
  }
  else
  {
    WRITEFILE((s,"Processor: %s\n\n","x64"));
  }

  WRITEFILE((s,"Exception code: 0x%08X\n",info->ExceptionCode));
  WRITEFILE((s,"Exception addr: 0x%08X\n",info->ExceptionAddress));

  char class_name[MAX_PATH];
  class_name[0] = 0;
  GetClassName(last_processed_message.hwnd,class_name,sizeof(class_name));
  WRITEFILE((s,"Last message: %s 0x%08X (%d,%d)\n",class_name,last_processed_message.message,
                                                last_processed_message.wParam,
                                                last_processed_message.lParam));
  WRITEFILE((s,"\n\n"));


  HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,0);
  if ( snap != INVALID_HANDLE_VALUE )
     {
       MODULEENTRY32 i;
       ZeroMemory(&i,sizeof(i));
       i.dwSize = sizeof(i);
       
       BOOL rc = Module32First(snap,&i);
       while( rc )
       {
         WRITEFILE((s,"Base: 0x%08X, Size: 0x%08X, Name: %s\n",i.modBaseAddr,i.modBaseSize,i.szExePath));
         rc = Module32Next(snap,&i);
       }

       CloseHandle(snap);
     }

  WRITEFILE((s,"\n\n"));

  if ( context )
     {
       SYSTEM_INFO i;
       ZeroMemory(&i,sizeof(i));
       GetSystemInfo(&i);

       if ( i.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL )
          {
            DWORD *gpf_esp = NULL;
            
            WRITEFILE((s,"Registers:\n"));
            
            if ( context->ContextFlags & CONTEXT_INTEGER )
               {
                 WRITEFILE((s,"EAX = 0x%08X\n",context->Eax));
                 WRITEFILE((s,"EBX = 0x%08X\n",context->Ebx));
                 WRITEFILE((s,"ECX = 0x%08X\n",context->Ecx));
                 WRITEFILE((s,"EDX = 0x%08X\n",context->Edx));
                 WRITEFILE((s,"ESI = 0x%08X\n",context->Esi));
                 WRITEFILE((s,"EDI = 0x%08X\n",context->Edi));
               }

            if ( context->ContextFlags & CONTEXT_CONTROL )
               {
                 WRITEFILE((s,"EBP = 0x%08X\n",context->Ebp));
                 WRITEFILE((s,"ESP = 0x%08X\n",context->Esp));
                 gpf_esp = (DWORD*)context->Esp;
               }

            WRITEFILE((s,"\n"));

            if ( gpf_esp && gpf_esp <= top_esp )
               {
                 int n, count;
                 
                 WRITEFILE((s,"Stack dump:\n"));

                 count = top_esp - gpf_esp;
                 for ( n = 0; n < count; n++ )
                     {
                       DWORD *addr = top_esp - 1 - n;
                       DWORD data = *addr;
                       
                       WRITEFILE((s,"%08X: 0x%08X\n",addr,data));
                     }

                 WRITEFILE((s,"\n"));
               }
          }
     }

  if ( h )
     sys_fclose(h);

  return EXCEPTION_EXECUTE_HANDLER;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  static DWORD *top_esp = NULL;   //must be static
  static char filename[MAX_PATH]; //must be static

  __try
  {
    __asm mov top_esp,esp
    
    MainFunction();
  }
  __except ( Handler(top_esp,GetExceptionInformation(),filename) )
  {
    WorkSpaceDone();

    WCHAR ws[MAX_PATH*2];
    WCHAR wfilename[MAX_PATH] = L"";
    MultiByteToWideChar(CP_ACP,0,filename,-1,wfilename,MAX_PATH);
    wsprintfW(ws,WSTR_001,wfilename);
    MessageBoxW(NULL,ws,NULL,MB_OK | MB_ICONERROR | MB_TOPMOST);

    ApiDone();
    ApiExit(-1);
  }

  ApiExit(1);
}
