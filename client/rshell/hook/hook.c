
#define _WIN32_WINNT  0x0501

#include <windows.h>
#include <shlobj.h>
#include <objbase.h>
#include <shlwapi.h>
#include "../messages.h"
#include <stdio.h>


HINSTANCE instance;
HHOOK hook=NULL,hook2=NULL,hook3=NULL,hook4=NULL,hook5=NULL,hook6=NULL,hook7=NULL,hook8=NULL,hook10=NULL,hook11=NULL,hook12=NULL,hook13=NULL;


#ifndef _WIN64

#pragma data_seg("Shared")
int wkey_ignore = 1;
#pragma data_seg()
#pragma comment(linker, "/SECTION:Shared,RWS")

#endif


LRESULT CALLBACK ShellProc(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  hwnd = FindWindow("_RunpadClass",NULL);

  switch ( code )
  {
    case HSHELL_APPCOMMAND:
         switch ( GET_APPCOMMAND_LPARAM(lParam) )
         {
           case APPCOMMAND_BROWSER_BACKWARD:
           case APPCOMMAND_BROWSER_FAVORITES:
           case APPCOMMAND_BROWSER_FORWARD:
           case APPCOMMAND_BROWSER_HOME:
           case APPCOMMAND_BROWSER_REFRESH:
           case APPCOMMAND_BROWSER_SEARCH:
           case APPCOMMAND_BROWSER_STOP:
           case APPCOMMAND_CLOSE:
           case APPCOMMAND_FIND:
           case APPCOMMAND_FORWARD_MAIL:
           case APPCOMMAND_HELP:
           case APPCOMMAND_LAUNCH_APP1:
           case APPCOMMAND_LAUNCH_APP2:
           case APPCOMMAND_LAUNCH_MAIL:
           case APPCOMMAND_NEW:
           case APPCOMMAND_OPEN:
           case APPCOMMAND_PRINT:
           case APPCOMMAND_REPLY_TO_MAIL:
           case APPCOMMAND_SAVE:
           case APPCOMMAND_SEND_MAIL:
           case APPCOMMAND_SPELL_CHECK:
                                           return 1;
         }
         break;
    
    case HSHELL_LANGUAGE:
         PostMessage(hwnd,RS_LANGUAGE,wParam,lParam);
         break;
  };

  return CallNextHookEx(NULL,code,wParam,lParam);
}


#ifndef _WIN64


LRESULT CALLBACK KeyboardProc(int code,WPARAM wParam,LPARAM lParam)
{
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  if ( !(lParam & 0x80000000) /*button down*/ )
     {
       if ( wParam != VK_LWIN && wParam != VK_RWIN )
          wkey_ignore = 1;
       else
          wkey_ignore = 0;
     }
  else
     {
       if ( wParam == VK_LWIN || wParam == VK_RWIN )
          {
            if ( !wkey_ignore )
               {
                 PostMessage(FindWindow("_RunpadClass",NULL),RS_WINKEY,0,0);
               }
          }

       wkey_ignore = 1;
     }
     
  switch ( wParam )
  {
//    case VK_SLEEP:
    case VK_LWIN:
    case VK_RWIN:
    case VK_APPS:
    case VK_BROWSER_BACK:
    case VK_BROWSER_FORWARD:
    case VK_BROWSER_REFRESH:
    case VK_BROWSER_STOP:
    case VK_BROWSER_SEARCH:
    case VK_BROWSER_FAVORITES:
    case VK_BROWSER_HOME:
    case VK_LAUNCH_MAIL:
    case VK_LAUNCH_MEDIA_SELECT:
    case VK_LAUNCH_APP1:
    case VK_LAUNCH_APP2:
                          return 1;
  }
     
  return CallNextHookEx(NULL,code,wParam,lParam);
}


#endif


static BOOL IsChildWnd(HWND hwnd)
{
  int style = GetWindowLong(hwnd,GWL_STYLE);
  return (style & WS_CHILD) != 0;
}


static HWND IsMSOProtectedDlgWindow(HWND hwnd)
{
  char s[MAX_PATH];
  
  if ( !hwnd || !IsWindow(hwnd) || IsChildWnd(hwnd) || !IsWindowVisible(hwnd) )
     return NULL;

  s[0] = 0;
  GetClassName(hwnd,s,sizeof(s));

  s[10] = 0;
  if ( lstrcmpi(s,"bosa_sdm_M") && lstrcmpi(s,"bosa_sdm_X") )
     return NULL;
  
  return GetProp(hwnd,"_RunpadOpenSaveDialogBox");
}


static void CheckSelectForDisallowedSymbols(HWND hwnd)
{
  char s[MAX_PATH];
  int n,process;
  
  ZeroMemory(s,sizeof(s));
  SendMessage(hwnd,WM_GETTEXT,(WPARAM)sizeof(s),(LPARAM)s);

  process = 0;
  for ( n = 0; n < lstrlen(s); n++ )
      {
        if ( s[n] == '.' && s[n+1] == '.' )
           {
             process = 1;
             break;
           }
      }

  if ( process )
     {
       SendMessage(hwnd,WM_SETTEXT,(WPARAM)0,(LPARAM)"");
       return;
     }
      
  for ( n = lstrlen(s)-1; n >= 0; n-- )
      {
        if ( s[n] == '\\' || s[n] == '/' || s[n] == ':' || s[n] == '%' )
           {
             SendMessage(hwnd,WM_SETTEXT,(WPARAM)0,(LPARAM)&s[n+1]);
             break;
           }
      }
}



LRESULT CALLBACK GetMsgProc(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  MSG *msg;
  char s[MAX_PATH];
  int process;
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  msg = (MSG*)lParam;
  hwnd = msg->hwnd;

  // check for ShellListView clicks, etc.
  process = 0;
  
  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN || msg->message == WM_MOUSEMOVE )
     process = 1;
  else
  if ( msg->message == WM_KEYDOWN || msg->message == WM_KEYUP || 
       msg->message == WM_SYSKEYDOWN || msg->message == WM_SYSKEYUP )
     {
       if ( msg->wParam == VK_DELETE || msg->wParam == VK_BACK || 
            msg->wParam == VK_MENU || msg->wParam == VK_RETURN ||
            msg->wParam == VK_MBUTTON || msg->wParam == VK_XBUTTON1 || msg->wParam == VK_XBUTTON2 ||
            msg->wParam == VK_LWIN || msg->wParam == VK_RWIN || msg->wParam == VK_APPS )
          process = 1;
     }
  
  if ( process )
     {
       s[0] = 0;
       GetClassName(hwnd,s,sizeof(s));

       process = 0;

       if ( !lstrcmp(s,"SysListView32") )
          {
            HWND parent = GetParent(hwnd);
            s[0] = 0;
            GetClassName(parent,s,sizeof(s));
            if ( !lstrcmp(s,"SHELLDLL_DefView") )
               process = 1;
          }
       else        
       if ( !lstrcmp(s,"SysTreeView32") )
          {
            HWND parent = GetParent(hwnd);
            s[0] = 0;
            GetClassName(parent,s,sizeof(s));
            if ( !lstrcmp(s,"SHBrowseForFolder ShellNameSpace Control") )
               process = 1;
          }
               
       if ( process )
          {
            msg->message = WM_NULL;
            return 0;
          }
     }

  // check for MSO dialog click (upper part)
  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN ||
       msg->message == WM_LBUTTONUP || msg->message == WM_LBUTTONDOWN || 
       msg->message == WM_MBUTTONUP || msg->message == WM_MBUTTONDOWN ||
       msg->message == WM_LBUTTONDBLCLK )
     {
       if ( HIWORD(msg->lParam) < 27 )
          {
            if ( IsMSOProtectedDlgWindow(hwnd) )
               {
                 msg->message = WM_NULL;
                 return 0;
               }
          }
     }

  // check for MSO dialog protected symbols
  if ( msg->message == WM_KEYDOWN || msg->message == WM_KEYUP || 
       msg->message == WM_SYSKEYDOWN || msg->message == WM_SYSKEYUP )
     {
       // special check for TAB
       if ( msg->wParam == VK_TAB )
          {
            HWND root = hwnd;
            
            if ( IsChildWnd(hwnd) )
               root = GetAncestor(hwnd,GA_ROOT);
            
            if ( IsMSOProtectedDlgWindow(root) )
               {
                 msg->message = WM_NULL;
                 return 0;
               }
          }

       if ( IsChildWnd(hwnd) )   
          {
            HWND root = GetAncestor(hwnd,GA_ROOT);
            HWND select = IsMSOProtectedDlgWindow(root);
            
            if ( select && hwnd == select )
               CheckSelectForDisallowedSymbols(select);
          }
     }

  return CallNextHookEx(NULL,code,wParam,lParam);
}



LRESULT CALLBACK MsgFilterProc(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd,root;
  MSG *msg;
  char s[MAX_PATH];
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  switch ( code )
  {
    case MSGF_DIALOGBOX:
                        msg = (MSG*)lParam;
                        hwnd = msg->hwnd;
                        s[0] = 0;
                        GetClassName(hwnd,s,sizeof(s));

                        if ( lstrcmpi(s,"Edit") )
                           break;

                        if ( GetDlgCtrlID(hwnd) != edt1 )
                           {
                             HWND parent = GetParent(hwnd);
                             s[0] = 0;
                             GetClassName(parent,s,sizeof(s));
                             if ( lstrcmpi(s,"ComboBox") )
                                break;

                             parent = GetParent(parent);
                             s[0] = 0;
                             GetClassName(parent,s,sizeof(s));
                             if ( lstrcmpi(s,"ComboBoxEx32") && lstrcmpi(s,"#32770") )
                                break;

                             if ( GetDlgCtrlID(hwnd) != cmb13 )
                                break;
                           }

                        root = GetAncestor(hwnd,GA_ROOT);
                        if ( !root )
                           break;

                        if ( !IsWindowVisible(root) || !GetProp(root,"_RunpadOpenSaveDialogBox") )
                           break;

                        s[0] = 0;
                        GetClassName(root,s,sizeof(s));
                        if ( lstrcmpi(s,"#32770") )
                           break;

                        if ( !FindWindowEx(root,NULL,"SHELLDLL_DefView",NULL) )
                           break;

                        CheckSelectForDisallowedSymbols(hwnd);
                        break;
  };

  return CallNextHookEx(NULL,code,wParam,lParam);
}


static HWND GetTopOwner(HWND hwnd)
{
  int n = 0;
  
  do {
   HWND owner = GetWindow(hwnd,GW_OWNER);
   if ( !owner )
      owner = GetParent(hwnd);
   if ( !owner || owner == GetDesktopWindow() )
      return hwnd;//n ? hwnd : NULL;
   hwnd = owner;
   n++;
  } while (1);
}


#ifndef _WIN64


LRESULT CALLBACK GetMsgProcWinamp(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  MSG *msg;
  char s[MAX_PATH];
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  msg = (MSG*)lParam;
  hwnd = msg->hwnd;

  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN )
     {
       hwnd = GetTopOwner(hwnd);

       if ( hwnd )
          {
            s[0] = 0;
            GetClassName(hwnd,s,sizeof(s));

            if ( !lstrcmp(s,"Winamp v1.x") )
               {
                 msg->message = WM_NULL;
                 return 0;
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}


LRESULT CALLBACK GetMsgProcMplayerc(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  MSG *msg;
  char s[MAX_PATH];
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  msg = (MSG*)lParam;
  hwnd = msg->hwnd;

  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN )
     {
       hwnd = GetTopOwner(hwnd);

       if ( hwnd )
          {
            s[0] = 0;
            GetClassName(hwnd,s,sizeof(s));

            if ( !lstrcmp(s,"MediaPlayerClassicW") || !lstrcmp(s,"MediaPlayerClassicA") || !lstrcmp(s,"MediaPlayerClassic") )
               {
                 msg->message = WM_NULL;
                 return 0;
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}


LRESULT CALLBACK GetMsgProcPowerDVD(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  MSG *msg;
  char s[MAX_PATH];
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  msg = (MSG*)lParam;
  hwnd = msg->hwnd;

  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN )
     {
       hwnd = GetTopOwner(hwnd);

       if ( hwnd )
          {
            s[0] = 0;
            GetClassName(hwnd,s,sizeof(s));

            if ( !lstrcmp(s,"Class of CyberLink Universal Player") || 
                 !lstrcmp(s,"CyberLink Video Window Class") )
               {
                 msg->message = WM_NULL;
                 return 0;
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}


LRESULT CALLBACK GetMsgProcTorrent(int code,WPARAM wParam,LPARAM lParam)
{
  HWND hwnd;
  MSG *msg;
  
  if ( code < 0 )
     return CallNextHookEx(NULL,code,wParam,lParam);

  msg = (MSG*)lParam;
  hwnd = msg->hwnd;

  if ( msg->message == WM_RBUTTONUP || msg->message == WM_RBUTTONDOWN || msg->message == WM_LBUTTONDBLCLK )
     {
       if ( GetWindowLong(hwnd,GWL_STYLE) & WS_CHILD )
          {
            hwnd = GetAncestor(hwnd,GA_ROOT);

            if ( hwnd )
               {
                 if ( GetProp(hwnd,"IsTorrentWnd") )
                    {
                      msg->message = WM_NULL;
                      return 0;
                    }
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}





static LRESULT CALLBACK MouseLLProc( int code, WPARAM wParam, LPARAM lParam )
{
  if ( code == HC_ACTION )
     {
       MSLLHOOKSTRUCT *info = (MSLLHOOKSTRUCT*)lParam;
       if ( !(info->flags & LLMHF_INJECTED) )
          return 1;
     }

  return CallNextHookEx(NULL,code,wParam,lParam);
}


static LRESULT CALLBACK KeyboardLLProc( int code, WPARAM wParam, LPARAM lParam )
{
  if ( code == HC_ACTION )
     {
       KBDLLHOOKSTRUCT *info = (KBDLLHOOKSTRUCT *)lParam;
       if ( !(info->flags & LLKHF_INJECTED) )
          return 1;
     }

  return CallNextHookEx(NULL,code,wParam,lParam);
}



__declspec(dllexport) void __cdecl InitGlobalHook(HWND hwnd)
{
  BOOL (WINAPI *pSetTaskmanWindow)(HWND) = (void*)GetProcAddress(GetModuleHandle("user32.dll"),"SetTaskmanWindow");

  if ( !hook )
     hook = SetWindowsHookEx(WH_SHELL,ShellProc,instance,0);
// commented due to conflict with FaceIt:
//  if ( !hook2 )
//     hook2 = SetWindowsHookEx(WH_KEYBOARD,KeyboardProc,instance,0);

  if ( pSetTaskmanWindow )
     {
       pSetTaskmanWindow(NULL);
       pSetTaskmanWindow(hwnd);
     }
  
  RegisterShellHookWindow(hwnd);
}



__declspec(dllexport) void __cdecl DoneGlobalHook(HWND hwnd)
{
  BOOL (WINAPI *pSetTaskmanWindow)(HWND) = (void*)GetProcAddress(GetModuleHandle("user32.dll"),"SetTaskmanWindow");

  DeregisterShellHookWindow(hwnd);

  if ( pSetTaskmanWindow )
     pSetTaskmanWindow(NULL);

  if ( hook2 )
     UnhookWindowsHookEx(hook2);

  if ( hook )
     UnhookWindowsHookEx(hook);

  hook2 = NULL;
  hook = NULL;
}


#endif


#ifndef _WIN64
__declspec(dllexport) void __cdecl SetDialogsHook(BOOL state)
#else
void SetDialogsHook(BOOL state)
#endif
{
  if ( state )
     {
       if ( !hook3 )
          hook3 = SetWindowsHookEx(WH_SYSMSGFILTER,MsgFilterProc,instance,0);
       if ( !hook4 )
          hook4 = SetWindowsHookEx(WH_GETMESSAGE,GetMsgProc,instance,0);
     }
  else
     {
       if ( hook3 )
          UnhookWindowsHookEx(hook3);
       if ( hook4 )
          UnhookWindowsHookEx(hook4);
       hook3 = NULL;
       hook4 = NULL;
     }
}


#ifndef _WIN64


__declspec(dllexport) void __cdecl SetWinampHook(BOOL state)
{
  if ( state )
     {
       if ( !hook5 )
          hook5 = SetWindowsHookEx(WH_GETMESSAGE,GetMsgProcWinamp,instance,0);
     }
  else
     {
       if ( hook5 )
          UnhookWindowsHookEx(hook5);
       hook5 = NULL;
     }
}


__declspec(dllexport) void __cdecl SetMPlayercHook(BOOL state)
{
  if ( state )
     {
       if ( !hook8 )
          hook8 = SetWindowsHookEx(WH_GETMESSAGE,GetMsgProcMplayerc,instance,0);
     }
  else
     {
       if ( hook8 )
          UnhookWindowsHookEx(hook8);
       hook8 = NULL;
     }
}


__declspec(dllexport) void __cdecl SetPowerDVDHook(BOOL state)
{
  if ( state )
     {
       if ( !hook12 )
          hook12 = SetWindowsHookEx(WH_GETMESSAGE,GetMsgProcPowerDVD,instance,0);
     }
  else
     {
       if ( hook12 )
          UnhookWindowsHookEx(hook12);
       hook12 = NULL;
     }
}


__declspec(dllexport) void __cdecl SetTorrentHook(BOOL state)
{
  if ( state )
     {
       if ( !hook13 )
          hook13 = SetWindowsHookEx(WH_GETMESSAGE,GetMsgProcTorrent,instance,0);
     }
  else
     {
       if ( hook13 )
          UnhookWindowsHookEx(hook13);
       hook13 = NULL;
     }
}


__declspec(dllexport) void __cdecl SetInputDisableState(BOOL state)
{
// commented due to conflict with FaceIt:
//  if ( state )
//     {
//       if ( !hook6 )
//          hook6 = SetWindowsHookEx(WH_MOUSE_LL,MouseLLProc,instance,0);
//       if ( !hook7 )
//          hook7 = SetWindowsHookEx(WH_KEYBOARD_LL,KeyboardLLProc,instance,0);
//     }
//  else
//     {
//       if ( hook6 )
//          UnhookWindowsHookEx(hook6);
//       if ( hook7 )
//          UnhookWindowsHookEx(hook7);
//       hook6 = NULL;
//       hook7 = NULL;
//     }
}


LRESULT CALLBACK ProcConsoleKeyboard(int code,WPARAM wParam,LPARAM lParam)
{
  if ( code >= 0 )
     {
       HWND w = GetForegroundWindow();

       if ( w && IsWindowVisible(w) )
          {
            char s[MAX_PATH];

            s[0] = 0;
            GetClassName(w,s,sizeof(s));

            if ( !lstrcmp(s,"ConsoleWindowClass") )
               {
                 s[0] = 0;
                 GetWindowText(w,s,sizeof(s));
                 
                 if ( lstrcmp(s,"HLTV") )  //Half-Life TV
                    return 1;
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}


LRESULT CALLBACK ProcConsoleMouse(int code,WPARAM wParam,LPARAM lParam)
{
  if ( code >= 0 )
     {
       if ( wParam == WM_LBUTTONDOWN || wParam == WM_RBUTTONUP || wParam == WM_RBUTTONDOWN ||
            wParam == WM_MBUTTONUP || wParam == WM_MBUTTONDOWN )
          {
            MOUSEHOOKSTRUCT *i = (MOUSEHOOKSTRUCT*)lParam;
            
            if ( i )
               {
                 HWND w = i->hwnd;
                 
                 if ( w )
                    {
                      char s[MAX_PATH];

                      s[0] = 0;
                      GetClassName(w,s,sizeof(s));

                      if ( !lstrcmp(s,"ConsoleWindowClass") )
                         {
                           s[0] = 0;
                           GetWindowText(w,s,sizeof(s));
                           
                           if ( lstrcmp(s,"HLTV") )  //Half-Life TV
                              return 1;
                         }
                    }
               }
          }
     }
  
  return CallNextHookEx(NULL,code,wParam,lParam);
}


__declspec(dllexport) void __cdecl SetConsoleHook(BOOL state)
{
// commented due to conflict with FaceIt:
//  if ( GetVersion() & 0x80000000 ) //win9x
//     return;
//  
//  if ( state )
//     {
//       if ( !hook10 )
//          hook10 = SetWindowsHookEx(WH_KEYBOARD,ProcConsoleKeyboard,instance,0);
//       if ( !hook11 )
//          hook11 = SetWindowsHookEx(WH_MOUSE,ProcConsoleMouse,instance,0);
//     }
//  else
//     {
//       if ( hook10 )
//          UnhookWindowsHookEx(hook10);
//       hook10 = NULL;
//       if ( hook11 )
//          UnhookWindowsHookEx(hook11);
//       hook11 = NULL;
//     }
}

#endif


#ifdef _WIN64

void SetGlobalHook(BOOL state)
{
  if ( state )
     {
       if ( !hook )
          hook = SetWindowsHookEx(WH_SHELL,ShellProc,instance,0);
     }
  else
     {
       if ( hook )
          UnhookWindowsHookEx(hook);
       hook = NULL;
     }
}


LRESULT CALLBACK OurWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
    case WM_CLOSE:
                       return 0;

    case WM_ENDSESSION:
                   if ( wParam )
                      {
                        ExitProcess(0);
                      }
                   return 0;
  
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}



void SetHook64Internal(HWND hwndOwner,int nCmdShow,void(*phook)(BOOL),const char *event_name)
{
  WNDCLASS wc;
  HWND hwnd;
  HANDLE h_event;
  
  // init process
  SetProcessShutdownParameters(1,SHUTDOWN_NORETRY);

  // create wnd
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = OurWindowProc;
  wc.hInstance = instance;
  wc.lpszClassName = "_SetHook64InternalWndClass";
  RegisterClass(&wc);
  hwnd = CreateWindowEx(WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,0,0,NULL,NULL,instance,NULL);

  // setup hook
  phook(TRUE);

  // create event
  h_event = CreateEvent(NULL,TRUE,FALSE,event_name);

  // message loop
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
         DWORD rc = MsgWaitForMultipleObjects(1,&h_event,FALSE,20,QS_ALLINPUT);

         if ( rc == WAIT_OBJECT_0 )
            break;
       }
  }

  // shutdown
  phook(FALSE);
  CloseHandle(h_event);
  DestroyWindow(hwnd);
  UnregisterClass(wc.lpszClassName,instance);
}



// main export function for rundll32
__declspec(dllexport) void CALLBACK SetHook64(HWND hwnd, HINSTANCE hinst, LPSTR lpszCmdLine, int nCmdShow)
{
  if ( lpszCmdLine && lpszCmdLine[0] )
     {
       char hook_name[MAX_PATH] = "";
       char event_name[MAX_PATH] = "";
       
       sscanf(lpszCmdLine,"%s %s",hook_name,event_name);

       if ( hook_name[0] && event_name[0] )
          {
            void (*phook)(BOOL) = NULL;

            if ( !lstrcmp(hook_name,"GlobalHook") )
               {
                 phook = SetGlobalHook;
               }
            else
            if ( !lstrcmp(hook_name,"DialogsHook") )
               {
                 phook = SetDialogsHook;
               }

            if ( phook )
               {
                 SetHook64Internal(hwnd,nCmdShow,phook,event_name);
               }
          }
     }
}



#endif //WIN64


BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpvReserved)
{
  if ( fdwReason == DLL_PROCESS_ATTACH )
     {
       instance = hinstDLL;
       DisableThreadLibraryCalls(instance);
     }

  return TRUE;
}

