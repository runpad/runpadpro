
#include "include.h"


static const char *szClassName = "_RSAboutClass";

static unsigned starttime = 0;
static DWORD thread_id;
static HANDLE thread = NULL;

static char s_progress[MAX_PATH];
static char s_lic_name[MAX_PATH];
static int i_lic_machines;
static BOOL g_b_warn;


static void DrawTextOnBitmap(HDC hdc,int w,int h)
{
  HFONT font = CreateFont(-10,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  HFONT oldfont = (HFONT)SelectObject(hdc,font);

  if ( !g_b_warn )
     {
       SetBkMode(hdc,TRANSPARENT);
       SetTextColor(hdc,RGB(31,54,54));
     }
  else
     {
       SetBkMode(hdc,OPAQUE);
       SetBkColor(hdc,RGB(255,0,0));
       SetTextColor(hdc,RGB(255,255,255));
     }

  RECT r;
  SetRect(&r,82,68,350,130);

  if ( s_progress[0] || s_lic_name[0] )
     {
       WCHAR s[MAX_PATH*3] = L"";

       if ( !g_b_warn )
          {
            if ( s_lic_name[0] )
               wsprintfW(s,L"%s\n%s: %d\n\n",CUnicodeRus(s_lic_name).Text(),CUnicode(LS(3000)).Text(),i_lic_machines);
            else
               lstrcpyW(s,L"\n\n\n");
          }

       if ( s_progress[0] )
          lstrcatW(s,CUnicode(s_progress));

       DrawTextW(hdc,s,-1,&r,DT_RIGHT | DT_TOP | DT_WORDBREAK);
     }

  SelectObject(hdc,oldfont);
  DeleteObject(font);
}


static void Paint(HWND hwnd,HDC hdc,HBITMAP bitmap)
{
  if ( bitmap )
     {
       HDC memdc = CreateCompatibleDC(NULL);
       HBITMAP oldbitmap = (HBITMAP)SelectObject(memdc,bitmap);

       int w=0,h=0;
       GetHDCDim(memdc,&w,&h);

       RBUFF buff;
       RB_CreateNormal(&buff,w,h);
       RB_PaintFrom(memdc,&buff);
       DrawTextOnBitmap(buff.hdc,w,h);
       RB_PaintTo(&buff,hdc);
       RB_Destroy(&buff);

       SelectObject(memdc,oldbitmap);
       DeleteDC(memdc);
     }
}


static LRESULT CALLBACK AboutWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_USER:
                       if ( wParam )
                          {
                            lstrcpyn(s_progress,(char*)wParam,sizeof(s_progress));
                            sys_free((char*)wParam);
                            g_b_warn = (BOOL)lParam;
                            InvalidateRect(hwnd,NULL,FALSE);
                            UpdateWindow(hwnd);
                            //GdiFlush();
                          }
                       return 1;
    
    case WM_USER+1:
                       if ( wParam )
                          {
                            lstrcpyn(s_lic_name,(char*)wParam,sizeof(s_lic_name));
                            sys_free((char*)wParam);
                            i_lic_machines = lParam;
                            InvalidateRect(hwnd,NULL,FALSE);
                            UpdateWindow(hwnd);
                            //GdiFlush();
                          }
                       return 1;

    case WM_TIMER:
                       InvalidateRect(hwnd,NULL,FALSE);
                       return 0;
                       
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
    case WM_CLOSE:
                       return 0;

    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);
                         Paint(hwnd,hdc,(HBITMAP)GetProp(hwnd,"hbitmap"));
                         EndPaint(hwnd,&ps);
                       }
                       return 0;
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}



static DWORD WINAPI AboutThreadProc(LPVOID lpParameter)
{
  CoInitialize(0);
  
  GdiSetBatchLimit(1);
  GdiFlush(); //ensure all is redrawed

  BOOL old_ds = FALSE;
  SystemParametersInfo(SPI_GETDROPSHADOW,0,(void*)&old_ds,0);
  SystemParametersInfo(SPI_SETDROPSHADOW,0,(void*)TRUE,0);
  
  s_progress[0] = 0;
  s_lic_name[0] = 0;
  i_lic_machines = 0;
  g_b_warn = FALSE;

  int w = 0, h = 0;
  HBITMAP hbitmap = LoadPicFromResource(IDT_ABOUT);
  if ( hbitmap )
     GetBitmapDim(hbitmap,&w,&h);

  if ( hbitmap && w > 0 && h > 0 )   
     {
       int x = (GetSystemMetrics(SM_CXSCREEN)-w)/2;
       int y = (GetSystemMetrics(SM_CYSCREEN)-h)/2;
       
       WNDCLASS wc;
       ZeroMemory(&wc,sizeof(wc));
       wc.style = is_w2k ? 0 : CS_DROPSHADOW;
       wc.hCursor = LoadCursor(NULL,IDC_WAIT);
       wc.lpfnWndProc = AboutWindowProc;
       wc.hInstance = our_instance;
       wc.lpszClassName = szClassName;
       RegisterClass(&wc);

       HWND hwnd = CreateWindowEx(WS_EX_TOOLWINDOW,szClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,NULL,NULL,our_instance,NULL);
       SetProp(hwnd,"hbitmap",(HANDLE)hbitmap);
       ShowWindow(hwnd,SW_SHOW);
       UpdateWindow(hwnd);

       SetTimer(hwnd,1,1000,NULL);

       MSG msg;
       while ( GetMessage(&msg,NULL,0,0) )
             DispatchMessage(&msg);        

       RemoveProp(hwnd,"hbitmap");
       DestroyWindow(hwnd);
       UnregisterClass(szClassName,our_instance);
     }

  if ( hbitmap )
     DeleteObject(hbitmap);

  SystemParametersInfo(SPI_SETDROPSHADOW,0,(void*)old_ds,0);

  CoUninitialize();
  
  return 1;
}


void ShowAboutBox(void)
{
  thread = MyCreateThreadDontCare(AboutThreadProc,NULL,&thread_id);
  starttime = GetTickCount();

  do {
    HWND w = FindWindow(szClassName,NULL);
    if ( w )
       break;
    Sleep(50);
  } while ( GetTickCount()-starttime < 2000 );
}


void HideAboutBox(void)
{
//  int show_time = is_vista ? 4000 : 3000;
  int show_time = is_vista ? 2000 : 1000;
  
  while ( GetTickCount() - starttime < show_time )
  {
    Sleep(10);
  };
  
  if ( thread )
     {
       PostThreadMessage(thread_id,WM_QUIT,0,0);

       if ( WaitForSingleObject(thread,2000) == WAIT_TIMEOUT )
          TerminateThread(thread,1);
       CloseHandle(thread);
       thread = NULL;
     }

  GdiFlush(); //ensure all is redrawed
}


void AboutBoxUpdateProgress(const char *text,BOOL b_warn)
{
  if ( thread )
     {
       HWND w = FindWindow(szClassName,NULL);
       if ( w )
          {
            char *t = sys_copystring(text);
            SendMessage(w,WM_USER,(unsigned)t,b_warn);
          }
     }
}


void AboutBoxUpdateLicInfo(const char *lic_name,int lic_machines)
{
  if ( thread )
     {
       HWND w = FindWindow(szClassName,NULL);
       if ( w )
          {
            char *t = sys_copystring(lic_name);
            int i = lic_machines;
            SendMessage(w,WM_USER+1,(unsigned)t,i);
          }
     }
}

