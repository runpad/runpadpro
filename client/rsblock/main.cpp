
#include "stdafx.h"
#include "initguid.h"
#include <commctrl.h>
#include <shlwapi.h>
#include <stdlib.h>
#include "host_mp.h"
#include "host_flash.h"
#include "host_pic.h"
#include "main.h"
#include "utils.h"


//int _fltused;
HINSTANCE instance = NULL;


//do not change values!
#define E_BLOCKER "_RSEventBlocker"
#define E_SSAVER  "_RSEventScreenSaver"


static HHOOK hook1=NULL, hook2=NULL;
static BOOL keypressed=FALSE;
static POINT last_pos = {-1,-1};
static HANDLE g_event = NULL;
static int g_mode = MODE_NONE;


int GetGMode(void)
{
  return g_mode;
}


static LRESULT CALLBACK KeyboardProc(int code,WPARAM wParam,LPARAM lParam)
{
  if ( code < 0 )
     return CallNextHookEx(hook1,code,wParam,lParam);

  if ( !(lParam & 0x80000000) )
     keypressed = TRUE;

  return 1;
}


static LRESULT CALLBACK MouseProc(int code,WPARAM wParam,LPARAM lParam)
{
  if ( code < 0 )
     return CallNextHookEx(hook2,code,wParam,lParam);

  if ( wParam == WM_LBUTTONUP || wParam == WM_RBUTTONUP )
     {
       keypressed = TRUE;
     }
  else
  if ( wParam == WM_MOUSEMOVE )
     {
       #define ABS(x)  (((x)<0)?(-(x)):(x))
       POINT p = ((MOUSEHOOKSTRUCT*)lParam)->pt;

       if ( ABS(p.x-last_pos.x) > 15 || ABS(p.y-last_pos.y) > 15 )
          keypressed = TRUE;

       #undef ABS
     }

  return 1;
}


static void InitHooks(void)
{
  keypressed = FALSE;
  GetCursorPos(&last_pos);
  if ( !hook1 )
     hook1 = SetWindowsHookEx(WH_KEYBOARD,KeyboardProc,NULL,GetCurrentThreadId());
  if ( !hook2 )
     hook2 = SetWindowsHookEx(WH_MOUSE,MouseProc,NULL,GetCurrentThreadId());
}


static void DoneHooks(void)
{
  if ( hook1 )
     UnhookWindowsHookEx(hook1);
  if ( hook2 )
     UnhookWindowsHookEx(hook2);
  hook1 = NULL;
  hook2 = NULL;
  keypressed = FALSE;
}


static void FreeEvent(void)
{
  if ( g_event )
     CloseHandle(g_event);
  g_event = NULL;
}


static void RecreateEvent(void)
{
  FreeEvent();
  g_event = CreateEvent(NULL,TRUE,FALSE,g_mode==MODE_SSAVER?E_SSAVER:E_BLOCKER);
}


static BOOL Callback(BOOL signaled)
{
  if ( g_mode == MODE_SSAVER )
     {
       if ( signaled )
          {
            g_mode = MODE_BLOCKER;
            RecreateEvent();
          }
       else
          {
            if ( keypressed )
               return FALSE;
          }
     }
  else
     {
       if ( signaled )
          return FALSE;
     }

  return TRUE;
}


void MessageLoop(void)
{
  while ( 1 )
  {
    MSG msg;

    if ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
       {
         if ( !GetMessage(&msg,NULL,0,0) )
            break;

         TranslateMessage(&msg);
         DispatchMessage(&msg);        
       }
    else 
       { 
         DWORD rc = MsgWaitForMultipleObjects(1,&g_event,FALSE,20,QS_ALLINPUT);

         if ( !Callback(rc==WAIT_OBJECT_0) )
            break;
       }
  }
}


static BOOL CheckDesktop(void)
{
  BOOL rc = TRUE;

  if ( !(GetVersion() & 0x80000000) )
     {
       char *szDesktopName = "_RSBlockDesktop";
       STARTUPINFO i;
       
       GetStartupInfo(&i);

       if ( !i.lpDesktop || lstrcmpi(i.lpDesktop,szDesktopName) )
          {
            HDESK input_desk = OpenInputDesktop(0,FALSE,MAXIMUM_ALLOWED);
            HDESK desk = CreateDesktop(szDesktopName,NULL,NULL,0,MAXIMUM_ALLOWED,NULL);

            if ( desk )
               {
                 HDESK thread_desk = GetThreadDesktop(GetCurrentThreadId());
                 if ( SwitchDesktop(desk) )
                    {
                      if ( SetThreadDesktop(desk) )
                         {
                           STARTUPINFO si;
                           PROCESS_INFORMATION pi;
                           char s[MAX_PATH];
                           ZeroMemory(&si,sizeof(si));
                           si.cb = sizeof(si);
                           si.lpDesktop = szDesktopName;
                           lstrcpyn(s,GetCommandLine(),sizeof(s)-1);
                           if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
                              {
                                while ( 1 )
                                {
                                  MSG msg;

                                  if ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
                                     {
                                       if ( GetMessage(&msg,NULL,0,0) )
                                          {
                                            TranslateMessage(&msg);
                                            DispatchMessage(&msg);        
                                          }
                                       //else
                                       //   break;
                                     }
                                  else 
                                     { 
                                       DWORD rc = MsgWaitForMultipleObjects(1,&pi.hProcess,FALSE,100,QS_ALLINPUT);

                                       if ( rc == WAIT_OBJECT_0 )
                                          break;
                                     }
                                }

                                CloseHandle(pi.hProcess);
                                CloseHandle(pi.hThread);
                                rc = FALSE;
                              }
                           
                           SetThreadDesktop(thread_desk);
                         }

                      if ( !SwitchDesktop(input_desk) )
                         SwitchDesktop(thread_desk);
                    }

                 CloseDesktop(desk);
               }

            if ( input_desk )
               CloseDesktop(input_desk);
          }
     }

  return rc;
}


static BOOL CheckCmdLine(int *_mode,char *_file)
{
  BOOL rc = FALSE;
  *_mode = MODE_NONE;
  _file[0] = 0;
  
  if ( __argc == 3 )
     {
       if ( !lstrcmpi(__argv[1],"-blocker") )
          {
            *_mode = MODE_BLOCKER;
            lstrcpy(_file,__argv[2]);
            rc = TRUE;
          }
       else
       if ( !lstrcmpi(__argv[1],"-ssaver") )
          {
            *_mode = MODE_SSAVER;
            lstrcpy(_file,__argv[2]);
            rc = TRUE;
          }
     }

  return rc;
}


static BOOL CheckLoaded(void)
{
  HANDLE event;
  
  event = OpenEvent(SYNCHRONIZE,FALSE,E_SSAVER);
  if ( event )
     {
       CloseHandle(event);
       return FALSE;
     }

  event = OpenEvent(SYNCHRONIZE,FALSE,E_BLOCKER);
  if ( event )
     {
       CloseHandle(event);
       return FALSE;
     }

  return TRUE;
}


static void HideProcess98(void)
{
  if ( GetVersion() & 0x80000000 )
     {
       typedef int (WINAPI *TRegisterServiceProcess)(int p1,int p2);
       TRegisterServiceProcess RegisterServiceProcess = (TRegisterServiceProcess)GetProcAddress(GetModuleHandle("kernel32.dll"),"RegisterServiceProcess");
       if ( RegisterServiceProcess )
          RegisterServiceProcess(0,1);
     }
}



CComModule _Module;
BEGIN_OBJECT_MAP(ObjectMap)
END_OBJECT_MAP()


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine, int nShowCmd)
{
  instance = hInstance;
  
  CreateMutex(NULL,FALSE,"_RunpadShellMutex");
  if ( GetLastError() != ERROR_ALREADY_EXISTS )
     return 0;
  
  char filename[MAX_PATH];

  if ( !CheckCmdLine(&g_mode,filename) )
     return 0;

  if ( !CheckLoaded() )
     return 0;

  if ( !CheckDesktop() )
     return 0;

  HideProcess98();
     
  RecreateEvent();
     
  InitCommonControls();
  GdiSetBatchLimit(1);
  
  CoInitialize(0);
  _Module.Init( ObjectMap, hInstance, &LIBID_ATLLib );

  InitHooks();

  if ( !MP_ShowHost(filename) )
     if ( !SWF_ShowHost(filename) )
        PIC_ShowHost(filename); //must be last, always returns TRUE

  DoneHooks();
  
  _Module.Term();
  CoUninitialize();

  FreeEvent();

  return 1;
}
