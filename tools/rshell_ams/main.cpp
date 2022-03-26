
#include "include.h"



HINSTANCE our_instance = NULL;
char our_currpath[MAX_PATH] = "";
char our_apppath[MAX_PATH] = "";
const char *our_appname = "rshell_ams.exe";

static CConfig *g_config = NULL;
static CWindow *g_window = NULL;
static CTrayIcon *g_icon = NULL;


static void DoneInternal();
static void DoneOnEndSessionInternal();


void G_OnHotKey(int id)
{
  if ( id == 1 )
     { // info
       if ( g_config )
          {
            g_config->ShowInfoMessage();
          }
     }
  else
  if ( id == 2 )
     { // volume down
       CMixer().TuneMaster(-8);
     }
  else
  if ( id == 3 )
     { // volume up
       CMixer().TuneMaster(+8);
     }
}


// we do not call DestroyWindow here!
void G_OnEndSession()
{
  DoneOnEndSessionInternal();
}


void G_OnTimer()
{
  if ( g_config )
     {
       g_config->TryReadData();
     }
}


void G_OnTaskbarCreated()
{
  if ( g_icon )
     {
       g_icon->RecreateIcon();

       //if ( g_config && g_config->HaveGotData() )
       //   {
       //     G_OnTrayMessage(1,WM_LBUTTONUP);
       //   }
     }
}


void G_OnTrayMessage(int wParam,int lParam)
{
  if ( wParam == 1 && lParam == WM_LBUTTONUP || lParam == WM_RBUTTONUP )
     {
       //if ( g_icon && g_config )
       //   {
       //     char text[256] = "";
       //     g_config->GetVarsDesc(text,sizeof(text));
       //     g_icon->DisplayInfoTip(text);
       //   }
     }
}


void G_OnForceUpdate()
{
  if ( g_config )
     {
       g_config->ForceSendInfoToRShell();
     }
}


void AddToAutorun(HKEY root)
{
  WriteRegStr(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","rshell_ams",our_apppath);
}


void RemoveFromAutorun(HKEY root)
{
  DeleteRegValue(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","rshell_ams");
}


void QuitOtherInstanceAsync()
{
  HWND w = FindWindow(CWindow::GetClassName(),NULL);
  if ( w )
     {
       int thread_id = GetWindowThreadProcessId(w,NULL);
       PostThreadMessage(thread_id,WM_QUIT,0,0);
     }
}


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  // some initialization
  our_instance = GetModuleHandle(NULL);
  GetModuleFileName(NULL,our_apppath,sizeof(our_apppath));
  lstrcpy(our_currpath,our_apppath);
  PathRemoveFileSpec(our_currpath);
  PathAddBackslash(our_currpath);
  
  InitCommonControls();

  // some checks
  if ( lstrcmpi(PathFindFileName(our_apppath),our_appname) )
     {
       Err("Файл должен называться rshell_ams.exe");
       return 0;
     }

  if ( GetVersion() & 0x80000000 )
     {
       Err("Win9x/ME не поддерживаются");
       return 0;
     }

  // cmdline processing
  if ( SearchParam("-autorunCU") || SearchParam("/autorunCU") )
     {
       AddToAutorun(HKEY_CURRENT_USER);
     }

  if ( SearchParam("-autorunLM") || SearchParam("/autorunLM") )
     {
       AddToAutorun(HKEY_LOCAL_MACHINE);
     }

  if ( SearchParam("-uninstall") || SearchParam("/uninstall") )
     {
       RemoveFromAutorun(HKEY_LOCAL_MACHINE);
       RemoveFromAutorun(HKEY_CURRENT_USER);
       #ifdef DEBUG
       QuitOtherInstanceAsync();
       #endif
       return 1;
     }

  #ifdef DEBUG
  if ( SearchParam("-exit") || SearchParam("/exit") ||
       SearchParam("-quit") || SearchParam("/quit") ||
       SearchParam("-close") || SearchParam("/close") ||
       SearchParam("-q") || SearchParam("/q") )
     {
       QuitOtherInstanceAsync();
       return 1;
     }
  #endif

  // check if we're loaded
  CreateMutex(NULL,FALSE,"_rshell_ams.exe_Mutex");
  if ( GetLastError() == ERROR_ALREADY_EXISTS )
     {
       return 0;  //silent exit
     }

  CoInitialize(0);

  g_config = new CConfig();
  g_window = new CWindow(WM_USER);
  g_icon = new CTrayIcon(g_window->GetHandle(),WM_USER,"" /*"Информация о сеансе"*/);

  G_OnTimer(); //first time

  MessageLoop();

  DoneInternal();
  return 1;
}


static void DoneInternal()
{
  SAFEDELETE(g_icon);
  SAFEDELETE(g_window);
  SAFEDELETE(g_config);

  CoUninitialize();
}


// we can't call DestroyWindow here!
static void DoneOnEndSessionInternal()
{
  SAFEDELETE(g_icon);
  SAFEDELETE(g_config);

  //CoUninitialize();
  ExitProcess(1); //exit(1);
}
