
#include <windows.h>
#include <shlwapi.h>
#include <commctrl.h>
#include <commdlg.h>
#include <shlobj.h>
#include <objbase.h>
#include <stdlib.h>
#include "lang.h"
#include "vstwain.tlh"

//#import "VSTwain.dll"

#include "../rp_shared/rp_shared.h"


using namespace VSTWAINLib;
                                          
static CLSID const CLSID_VintaSoftTwain = {0x1169E0CD,0x9E76,0x11D7,{0xB1,0xD8,0xFB,0x63,0x94,0x5D,0xE9,0x6D}};
static IID const IID_IVintaSoftTwain = {0x1169E0CC,0x9E76,0x11D7,{0xB1,0xD8,0xFB,0x63,0x94,0x5D,0xE9,0x6D}};
static IID const DIID__IVintaSoftTwainEvents = {0x1169E0CE,0x9E76,0x11D7,{0xB1,0xD8,0xFB,0x63,0x94,0x5D,0xE9,0x6D}};



HINSTANCE instance;


void Err(HWND parent,const char *s)
{
  if ( parent )
     SetForegroundWindow(parent);
  MessageBox(parent,s,S_ERROR,MB_OK | MB_ICONERROR);
}


static void GetSpecialFolder(int folder,char *s)
{
  LPMALLOC pMalloc;
  LPITEMIDLIST pidl;

  s[0] = 0;

  if ( SHGetMalloc(&pMalloc) == NOERROR ) 
     {
       if ( SHGetSpecialFolderLocation(NULL,folder,&pidl) == NOERROR )
          {
            SHGetPathFromIDList(pidl,s);
            pMalloc->Free(pidl);
          }

       pMalloc->Release();
     }
}


static char *GetSaveFile(HWND parent,const char *filter,const char *name,const char *defext)
{
  static char out[MAX_PATH];
  char dir[MAX_PATH];
  OPENFILENAME p;

  dir[0] = 0;
  GetSpecialFolder(CSIDL_DESKTOP,dir);
  
  lstrcpy(out,name);
  ZeroMemory(&p,sizeof(p));
  p.lStructSize = sizeof(p);
  p.hwndOwner = parent;
  p.lpstrFilter = filter;
  p.nFilterIndex = 1;
  p.lpstrDefExt = defext;
  p.lpstrInitialDir = dir[0]?dir:NULL;
  p.lpstrFile = out;
  p.nMaxFile = MAX_PATH;
  p.Flags = OFN_HIDEREADONLY | OFN_LONGNAMES | OFN_OVERWRITEPROMPT | OFN_PATHMUSTEXIST;
  
  return GetSaveFileName(&p) ? out : NULL;
}


BOOL DoScanImage(HWND hwnd,char *outfile,BOOL show_ui)
{
  BOOL rc = FALSE;

  outfile[0] = 0;
  
  IVintaSoftTwain *wia = NULL;
  CoCreateInstance(CLSID_VintaSoftTwain,NULL,CLSCTX_INPROC_SERVER,IID_IVintaSoftTwain,(void **)&wia);
  if ( wia )
     {
       wia->appProductName = "Runpad Shell Scan";
       
       if ( wia->StartDevice() )
          {
            wia->Register("Сергей Шамшин","support@runpad-shell.com","51CBEC753C5C3C6931B0EF16AAF6D30B7468B715E7088E4CEDB43F71EA4E82DF519936D95FE774A4A5829D803D4B42E334CF15BB45D9E25EDB2294E82C6D9B94846E7E9A6161C3829307A83A0E575B28A9C1921D132C1E5BDF12D758A03A69DEAA2CADFD7E0B754E29A4F3A5E93EA813CC7D066F33845E58F79A288232C4B37D3F5AFFE92DCB8249E0433D76473C191B0AC4DFA97D0534F6CA741D48D935E0EF");
            
            if ( wia->sourcesCount > 0 )
               {
                 wia->modalUI = true;

                 if ( wia->SelectSource() )
                    {
                      if ( show_ui )
                         {
                           wia->disableAfterAcquire = false;
                           wia->showUI = true;
                         }
                      else
                         {
                           wia->disableAfterAcquire = true;
                           wia->showUI = false;
                         }

                      wia->maxImages = 1;

                      if ( wia->OpenDataSource() )
                         {
                           wia->unitOfMeasure = Inches;
                           wia->pixelType = RGB;
                           wia->resolution = 300;
                           wia->brightness = wia->brightnessMaxValue;
                           wia->contrast = 0;
                           wia->xferCount = 1;

                           BOOL result = wia->AcquireModal();
                           int last_error = wia->errorCode;

                           //wia->CloseDataSource();  some bugs with this here - not needed
                           
                           if ( result )
                              {
                                while (1)
                                {
                                  if ( hwnd )
                                     SetForegroundWindow(hwnd);
                                  char *s = GetSaveFile(hwnd,"JPEG (*.jpg)\0*.jpg\0BMP (*.bmp)\0*.bmp\0TIFF (*.tif)\0*.tif\0\0","scan_000",".jpg");
                                  if ( s && s[0] )
                                     {
                                       SetCursor(LoadCursor(NULL,IDC_WAIT));
                                       BOOL save_res = wia->SaveImage(0,s);
                                       SetCursor(LoadCursor(NULL,IDC_ARROW));
                                       
                                       if ( save_res )
                                          {
                                            lstrcpy(outfile,s);
                                            rc = TRUE;
                                            break;
                                          }
                                       else
                                          {
                                            Err(hwnd,S_ERR_SAVE);
                                          }
                                     }
                                  else
                                     break;
                                };
                              }
                           else
                              {
                                //if ( last_error != 0 )
                                //   {
                                //     Err(hwnd,S_ERR_SCAN);
                                //   }
                              }
                         }
                      else
                         {
                           Err(hwnd,S_ERR_DATASOURCE);
                         }
                    }
               }
            else
               {
                 Err(hwnd,S_ERR_NOSCANNER);
               }

            wia->StopDevice();
          }
       else
          {
            Err(hwnd,S_ERR_DEVICE);
          }

       wia->Release();
     }
  else
     {
       Err(hwnd,S_ERR_ACTIVEX);
     }

  return rc;
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
  wc.hIcon = LoadIcon(instance,MAKEINTRESOURCE(101));
  RegisterClass(&wc);

  hwnd = CreateWindowEx(0,szDummyClass,NULL,WS_POPUP,0,0,0,0,NULL,NULL,instance,NULL);

  return hwnd;
}



int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  instance = GetModuleHandle(NULL);

  InitCommonControls();
  CoInitialize(0);

  if ( !(GetVersion() & 0x80000000) )
     {
       HWND r_w = FindWindow("_RunpadClass",NULL);
       if ( r_w )
          {
            if ( SendMessage(r_w,WM_USER+187,0,0) )
               {
                 char out[MAX_PATH] = "";
                 BOOL show_ui = !(__argc == 2 && !lstrcmpi(__argv[1],"-noui"));
                 
                 HWND w = CreateDummyWindow();
                 SetForegroundWindow(w);
                 
                 if ( DoScanImage(w,out,show_ui) )
                    {
                      PostMessage(r_w,WM_USER+175,0,0);
                      
                      SetForegroundWindow(w);
                      if ( MessageBox(w,S_SCAN_VIEW,S_QUESTION,MB_YESNO | MB_ICONQUESTION) == IDYES )
                         ShellExecute(NULL,NULL,out,NULL,NULL,SW_SHOWNORMAL);
                    }

                 if ( IsWindow(w) )
                    DestroyWindow(w);
               }
          }
       else
          {
            Err(NULL,S_RUNPADNEEDED);
          }
     }
  else
     {
       Err(NULL,S_WIN9X);
     }

  CoUninitialize();
  return 1;
}
