
#include <windows.h>
#include <shlwapi.h>
#include <commctrl.h>
#include <shlobj.h>
#include <objbase.h>
#include "gdip.h"
#include "utils.h"
#include "preview.h"
#include "2d_lib.h"
#include "files.h"
#include "lang.h"
#include "scan.h"
#include "../rp_shared/rp_shared.h"
#include "../common/version.h"



int _fltused;
HINSTANCE instance;
char currpath[MAX_PATH];


static char path[MAX_PATH];
static char *filename = NULL;

void SeparatePathAndFile()
{
  char buf[MAX_PATH];
  char *s_filename;

  char *s = GetCommandLine();

  // Skip program path and name
  if ( *s == '\"' )
     {
       s++;
       while ( *s && *s != '\"' )
             s++;
       if ( *s == '\"' )
          s++;
       if ( *s )
          s++;
     }
  else
     {
       while ( *s && *s != ' ' )
             s++;
       if ( *s == ' ' )
          s++;
     }

  while ( *s && *s == ' ' )
        s++;

  // Remove quotes if present
  if ( *s == '\"' )
     s++;
  lstrcpy(buf,s);
  for ( s = buf; *s ; s++ )
  	   if ( *s == '\"' )
  	      {
   		      *s = 0;
   		      break;
  	      }
 
  if ( !GetFullPathName(buf, MAX_PATH, path, &filename) )
     {
       *path = '\0';
       filename = NULL;
     }

  // Replace '\' character between path and filename
  if ( filename && filename != path)
     {
       *(filename - 1) = '\0';
     }
}


static const char *szDummyClass = "_DummyParentWnd";


static LRESULT CALLBACK DummyWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_DESTROY )
     {
       UnregisterClass(szDummyClass,instance);
       return 0;
     }

  return DefWindowProc(hwnd,message,wParam,lParam);
}


static HWND CreateDummyWindow(void)
{
  WNDCLASS wc;
  HWND hwnd;

  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = DummyWindowProc;
  wc.hInstance = instance;
  wc.lpszClassName = szDummyClass;
  wc.hIcon = LoadIcon(instance,MAKEINTRESOURCE(103));
  RegisterClass(&wc);

  hwnd = CreateWindowEx(0,szDummyClass,NULL,WS_POPUP,0,0,0,0,NULL,NULL,instance,NULL);

  return hwnd;
}

/*
static void AddShellLogMessage(void)
{
  HWND w = FindWindow("_RunpadClass",NULL);
  if ( w )
     PostMessage(w,WM_USER+175,0,0);
}
*/

int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  InitCommonControls();
  CoInitialize(0);
  
  if ( !CheckRPVersion(RUNPAD_VERSION_DIG) )
     return 0;

  instance = GetModuleHandle(NULL);

  GetModuleFileName(instance,currpath,MAX_PATH);
  GetDirFromPath(currpath,currpath);
  
  SeparatePathAndFile();
  if (!filename)
     {
       MessageBoxW(NULL,L"Для просмотра картинок просто откройте файл картинки в проводнике пользователя",L"Информация",MB_OK | MB_ICONINFORMATION);
       return 0;
     }

  GDIP_Init();
  GdiSetBatchLimit(1);

  if ( !lstrcmpi(filename,"-scan") )
     {
       char s[MAX_PATH];
       lstrcpy(s,currpath);
       PathAppend(s,"bodyscan.exe");
       RunProcess(s);
       
       /*HWND r_w = FindWindow("_RunpadClass",NULL);
       if ( r_w )
          {
            if ( SendMessage(r_w,WM_USER+187,0,0) )
               {
                 char out[MAX_PATH];
                 HWND w = CreateDummyWindow();
                 SetForegroundWindow(w);

                 if ( DoScanImage(w,out) )
                    {
                      AddShellLogMessage();
                      
                      if ( MessageBox(w,S_SCAN_VIEW,LS(LS_QUESTION),MB_YESNO | MB_ICONQUESTION) == IDYES )
                         ShellExecute(NULL,NULL,out,NULL,NULL,SW_SHOWNORMAL);
                    }

                 if ( IsWindow(w) )
                    DestroyWindow(w);
               }
          }*/
     }
  else
     {
       Preview(NULL,path,filename);
     }

  GDIP_Done();
  return 1;
}
