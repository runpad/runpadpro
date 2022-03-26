
#include "include.h"


static HINSTANCE sett_lib = NULL;

static ULONG_PTR gdiplus_token = 0;
static GdiplusStartupInput gdiplus_input; //here is default constructor present!



void ApiInit(void)
{
  SetErrorMode(SetErrorMode(0) | SEM_FAILCRITICALERRORS);

  is_vista = IsVistaLonghorn();
  is_w2k = IsWin2000();
  our_instance = GetModuleHandle(NULL);
  GetModuleFileName(our_instance,our_currpath,MAX_PATH);
  GetDirFromPath(our_currpath,our_currpath);
  SetCurrentDirectory(our_currpath);
  is_wtsenumproc_bug_present = IsWTSEnumProcBugPresent();

  msgloop_starttime = GetTickCount();   // paranoja here
  cur_wait = LoadCursor(NULL,IDC_WAIT);
  cur_arrow = LoadCursor(NULL,IDC_ARROW);
  cur_drag = LoadCursor(NULL,IDC_HAND);
  SaveDisplayMode();

  RemoveOldClassEntries();
  RemoveAppCompatFlags();
  InitCommonControls();
  CoInitializeEx(NULL,COINIT_APARTMENTTHREADED);
  OleInitialize(NULL);
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);
  GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
  SetProcessShutdownParameters(2,0);
  GdiSetBatchLimit(1);
  SetProcessPrivilege(SE_TCB_NAME);
  SetProcessPrivilege(SE_CHANGE_NOTIFY_NAME);
  SetProcessPrivilege("SeInteractiveLogonRight"/*SE_INTERACTIVE_LOGON_NAME*/);
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  PrepareTerminateProcessFunctionFromHack();
  ChangeProcessTerminateRights(TRUE);
  EnableFFDshowForOurApp();

  sett_lib = LoadLibrary("rshell.dll");

  *(void**)&GetInputTextPos = (void*)GetProcAddress(sett_lib,"GetInputTextPos");
  *(void**)&ShowStartupMasterDialog = (void*)GetProcAddress(sett_lib,"ShowStartupMasterDialog");
  *(void**)&ShowSaverWindow       = (void*)GetProcAddress(sett_lib,"ShowSaverWindow");
  *(void**)&Desk_Create           = (void*)GetProcAddress(sett_lib,"Desk_Create");
  *(void**)&Desk_Destroy          = (void*)GetProcAddress(sett_lib,"Desk_Destroy");
  *(void**)&Desk_IsVisible        = (void*)GetProcAddress(sett_lib,"Desk_IsVisible");
  *(void**)&Desk_Show             = (void*)GetProcAddress(sett_lib,"Desk_Show");
  *(void**)&Desk_Hide             = (void*)GetProcAddress(sett_lib,"Desk_Hide");
  *(void**)&Desk_Repaint          = (void*)GetProcAddress(sett_lib,"Desk_Repaint");
  *(void**)&Desk_Refresh          = (void*)GetProcAddress(sett_lib,"Desk_Refresh");
  *(void**)&Desk_BringToBottom    = (void*)GetProcAddress(sett_lib,"Desk_BringToBottom");
  *(void**)&Desk_Navigate         = (void*)GetProcAddress(sett_lib,"Desk_Navigate");
  *(void**)&Desk_OnDisplayChange  = (void*)GetProcAddress(sett_lib,"Desk_OnDisplayChange");
  *(void**)&Desk_OnEndSession     = (void*)GetProcAddress(sett_lib,"Desk_OnEndSession");
  *(void**)&Desk_OnStatusStringChanged = (void*)GetProcAddress(sett_lib,"Desk_OnStatusStringChanged");
  *(void**)&Desk_OnActiveSheetChanged = (void*)GetProcAddress(sett_lib,"Desk_OnActiveSheetChanged");
  *(void**)&Desk_OnPageShaded = (void*)GetProcAddress(sett_lib,"Desk_OnPageShaded");
  
  if ( !GetInputTextPos         ||
       !ShowStartupMasterDialog || 
       !ShowSaverWindow         ||
       !Desk_Create             ||
       !Desk_Destroy            ||
       !Desk_IsVisible          ||
       !Desk_Show               ||
       !Desk_Hide               ||
       !Desk_Repaint            ||
       !Desk_Refresh            ||
       !Desk_BringToBottom      ||
       !Desk_Navigate           ||
       !Desk_OnDisplayChange    ||
       !Desk_OnEndSession       ||
       !Desk_OnStatusStringChanged ||
       !Desk_OnActiveSheetChanged ||
       !Desk_OnPageShaded
       )
     {
       ErrBoxW(WSTR_002);
       ApiDone();
       ApiExit(0);
     }
}


void ApiDoneWithoutFlush(void)
{
  if ( sett_lib )
     FreeLibrary(sett_lib);

  ChangeProcessTerminateRights(FALSE);
  GdiplusShutdown(gdiplus_token);
  //WSACleanup(); //some problems related with multithreading (but only if no user32.dll in process WSACleanup can deadlocks?)
  //OleUninitialize();
  //CoUninitialize();
}


void ApiDone(void)
{
  ApiDoneWithoutFlush();
  RegFlush();
}


void ApiExit(int code)
{
  exit(code);
}


