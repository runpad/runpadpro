
#include "include.h"



HINSTANCE our_instance = NULL;
char our_currpath[MAX_PATH] = "";
char our_apppath[MAX_PATH] = "";
const char *our_appname = "rshell_asv2.exe";

static CConfig *g_config = NULL;
static CNet *g_net = NULL;
static CWindow *g_window = NULL;
static CTrayIcon *g_icon = NULL;


static void DoneInternal();
static void DoneOnEndSessionInternal();



// we do not call DestroyWindow here!
void G_OnEndSession()
{
  DoneOnEndSessionInternal();
}


void G_OnTimer()
{
  if ( g_net )
     {
       int packets = 0;
       
       while ( packets < 5 )
       {
         char buff[4000];
         ZeroMemory(buff,sizeof(buff));

         int rb = 0;
         
         if ( !g_net->Get(buff,sizeof(buff)-1,&rb) )
            break;

         if ( rb > 0 )
            {
              for ( int n = 0; n < rb; n++ )
                  if ( buff[n] == 0 )
                     buff[n] = ' ';

              if ( g_config )
                 {
                   g_config->IncomingPacket(buff);
                 }
            }
         else
            break;

         packets++;
       }
     }
}


void G_OnTimerVista()
{
  SpecialVistaProcessing();
}


void G_OnTaskbarCreated()
{
  if ( g_icon )
     {
       g_icon->RecreateIcon();

       if ( g_config && g_config->HaveGotData() )
          {
            G_OnTrayMessage(1,WM_LBUTTONUP);
          }
     }
}


void G_OnTrayMessage(int wParam,int lParam)
{
  if ( wParam == 1 && lParam == WM_LBUTTONUP || lParam == WM_RBUTTONUP )
     {
       if ( g_icon && g_config )
          {
            char text[256] = "";
            g_config->GetVarsDesc(text,sizeof(text));
            g_icon->DisplayInfoTip(text);
          }
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
  WriteRegStr(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","rshell_asv2",our_apppath);
}


void RemoveFromAutorun(HKEY root)
{
  DeleteRegValue(root,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run","rshell_asv2");
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
       Err("Файл должен называться rshell_asv2.exe");
       return 0;
     }

  if ( FindWindow("TAsv2InfoRorms",NULL) )
     {
       Err("Необходимо закрыть программу InfoASV2.exe");
       return 0;
     }

  if ( FindWindow("tAMSShellFormDesktop",NULL) || FindWindow("tAMSShellFormDesktop2",NULL) )
     {
       Err("Программа не будет работать из-под AstaShell");
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
  CreateMutex(NULL,FALSE,"_rshell_asv2.exe_Mutex");
  if ( GetLastError() == ERROR_ALREADY_EXISTS )
     {
       return 0;  //silent exit
     }

  CoInitialize(0);

  g_config = new CConfig();
  g_net = new CNet();
  g_window = new CWindow(WM_USER);
#ifndef ADDLANGS
  g_icon = new CTrayIcon(g_window->GetHandle(),WM_USER,"Информация о сеансе");
#else
  g_icon = new CTrayIcon(g_window->GetHandle(),WM_USER,"Information about session");
#endif

  CreateMutex(NULL,FALSE,"AstaShellMutex");  // needed for asta2
  SpecialVistaProcessing(); // needed for asta2

  MessageLoop();

  DoneInternal();
  return 1;
}


static void DoneInternal()
{
  SAFEDELETE(g_icon);
  SAFEDELETE(g_window);
  SAFEDELETE(g_net);
  SAFEDELETE(g_config);

  CoUninitialize();
}


// we can't call DestroyWindow here!
static void DoneOnEndSessionInternal()
{
  SAFEDELETE(g_icon);
  SAFEDELETE(g_net);
  SAFEDELETE(g_config);

  //CoUninitialize();
  ExitProcess(1); //exit(1);
}
