
#include "include.h"


HINSTANCE our_instance = NULL;
char our_currpath[MAX_PATH];

CGUI *gui = NULL;

static ULONG_PTR gdiplus_token = 0;
static GdiplusStartupInput gdiplus_input; //here is default constructor present!



void StartupMaster()
{
  STARTUPDIALOGINFO i;
  
  i.small_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,16,16,LR_SHARED);
  i.big_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_SETTINGS),IMAGE_ICON,32,32,LR_SHARED);

  ReadRegStr(HKLM,REGPATH,"sql_server",i.sql_server,"");
  if ( IsStrEmpty(i.sql_server) )
     MyGetComputerName(i.sql_server);
  i.dbtype_rp = ReadRegDword(HKLM,REGPATH,"sql_type_rp",SQL_TYPE_MSSQL);
  ReadRegStr(HKLM,REGPATH,"server_ip",i.runpad_server,"");
  if ( IsStrEmpty(i.runpad_server) )
     MyGetComputerName(i.runpad_server);
  i.autorun = IsWeAddedToAutorun();

  if ( gui->StartupDialog(&i) )
     {
       WriteRegStr(HKLM,REGPATH,"sql_server",i.sql_server);
       WriteRegDword(HKLM,REGPATH,"sql_type_rp",i.dbtype_rp);
       WriteRegStr(HKLM,REGPATH,"server_ip",i.runpad_server);
       if ( i.autorun )
          {
            AddToAutorun(HKLM);
            RemoveFromAutorun(HKCU);
          }
       else
          {
            RemoveFromAutorun(HKLM);
            RemoveFromAutorun(HKCU);
          }
     }
}


void ApiInit()
{
  our_instance = GetModuleHandle(NULL);
  GetModuleFileName(our_instance,our_currpath,MAX_PATH);
  PathRemoveFileSpec(our_currpath);
  PathAddBackslash(our_currpath);

  InitCommonControls();
  CoInitializeEx(NULL,COINIT_APARTMENTTHREADED);

  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  GdiplusStartup(&gdiplus_token,&gdiplus_input,NULL);
  GdiSetBatchLimit(1);
}


void ApiDone()
{
  GdiplusShutdown(gdiplus_token);
  //WSACleanup();
  CoUninitialize();
}


BOOL CreateGUIObj()
{
  gui = new CGUI();

  if ( !gui->IsLibraryLoaded() )
     {
       delete gui;
       gui = NULL;

       return FALSE;
     }

  return TRUE;
}


void DestroyGUIObj()
{
  if ( gui )
     {
       delete gui;
       gui = NULL;
     }
}


BOOL SearchParam(const char *s)
{
  for ( int n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],s) )
         return TRUE;

  return FALSE;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  ApiInit();

  if ( CreateGUIObj() )
     {
       if ( SearchParam("-setup") )
          {
            if ( IsAdminAccount() )
               {
                 StartupMaster();
               }
            else
               {
                 gui->ErrBox(S_ADMINRIGHTS);
               }
          }
       else
          {
            if ( CheckForAlreadyLoaded() )
               {
                 MainProcessing();
               }
          }

       DestroyGUIObj();
     }

  ApiDone();
  return 1;
}

