
#include "stdafx.h"
#include <shlwapi.h>
#include "host_pic.h"
#include "main.h"
#include "utils.h"
#include "pic.h"


static char (*gallery)[MAX_PATH] = NULL;
static int numgallery = 0;
static CRBuff *rbuff = NULL;



static void CreateGallery(char *filename)
{
  numgallery = 0;

  char temp[MAX_PATH];
  char dir[MAX_PATH];

  lstrcpy(temp,filename);
  
  if ( PathIsDirectory(temp) )
     {
       PathAddBackslash(temp);
       lstrcpy(dir,temp);
       lstrcat(temp,"*.*");
     }
  else
  if ( FileExist(temp) )
     {
       lstrcpy(dir,temp);
       PathRemoveFileSpec(dir);
       PathAddBackslash(dir);
     }
  else
     return;

  const int maxgallery = 1000;
  gallery = (char(*)[MAX_PATH])sys_alloc(maxgallery*sizeof(*gallery));

  WIN32_FIND_DATA f;
  HANDLE h = FindFirstFile(temp,&f);
  BOOL rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( numgallery == maxgallery )
       break;
    
    if ( !(f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) && !(f.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) )
       {
         lstrcpy(temp,dir);
         lstrcat(temp,f.cFileName);

         lstrcpy(gallery[numgallery],temp);
         numgallery++;
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


static void DestroyGallery(void)
{
  if ( gallery )
     sys_free(gallery);

  gallery = NULL;
  numgallery = 0;
}


static BOOL GoNextPic(HWND hwnd)
{
  BOOL rc = FALSE;

  if ( rbuff && gallery && numgallery )
     {
       CRBuff *temp = new CRBuff(hwnd);
       
       if ( temp->LoadPic(gallery[TrueRandom() % numgallery]) )
          {
            rbuff->Animate(temp,hwnd);
            rc = TRUE;
          }

       delete temp;
     }

  return rc;
}


static LRESULT CALLBACK WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_TIMER:
                           GoNextPic(hwnd);
                           break;
    
    case WM_DISPLAYCHANGE:
                           SetWindowPos(hwnd,NULL,0,0,LOWORD(lParam),HIWORD(lParam),SWP_NOMOVE | SWP_NOSENDCHANGING | SWP_NOREDRAW | SWP_NOZORDER);
                           if ( rbuff )
                              delete rbuff;
                           rbuff = new CRBuff(hwnd);
                           InvalidateRect(hwnd,NULL,FALSE);
                           UpdateWindow(hwnd);
                           GoNextPic(hwnd);
                           break;

    case WM_PAINT:
                           {
                             PAINTSTRUCT ps;
                             HDC hdc = BeginPaint(hwnd,&ps);
                             if ( rbuff )
                                rbuff->Paint(hdc);
                             EndPaint(hwnd,&ps);
                           }
                           return 0;

    case WM_SYSCHAR:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_KEYDOWN:
    case WM_KEYUP:
                           return 0;

    case WM_CLOSE:
                           return 0;

    case WM_SYSCOMMAND:
                           if ( wParam == SC_SCREENSAVE || wParam == SC_MONITORPOWER )
                              {
                                if ( numgallery != 1 || GetGMode() != MODE_BLOCKER )
                                   return 0;
                              }
                           break;

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}



BOOL PIC_ShowHost(char *filename)
{
  const char *szClassName = "_RSHostPicClass";
  WNDCLASS wc;

  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProc;
  wc.hInstance = instance;
  wc.lpszClassName = szClassName;
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,szClassName,"RS Picture Host",WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN),NULL,NULL,instance,NULL);

  rbuff = new CRBuff(hwnd);
  
  ShowWindow(hwnd,SW_SHOWNORMAL);
  ShowCursor(FALSE);
  UpdateWindow(hwnd);
  
  CreateGallery(filename);

  GoNextPic(hwnd);

  if ( numgallery > 1 )
     SetTimer(hwnd,1,5000,NULL);

  MessageLoop();

  DestroyGallery();

  ShowCursor(TRUE);

  if ( rbuff )
     delete rbuff;
  rbuff = NULL;

  DestroyWindow(hwnd);
  UnregisterClass(szClassName,instance);

  return TRUE;
}
