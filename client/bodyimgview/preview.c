
#include <windows.h>
#include "lang.h"
#include "main.h"
#include "utils.h"
#include "gdip.h"
#include "files.h"
#include "2d_lib.h"
#include "picture.h"
#include "print.h"
#include "scan.h"
#include "convert.h"
#include "../rp_shared/rp_shared.h"



static int keys[256];
static HDC memdc, screenmemdc;
static int x,y,oldx,oldy;
static HBITMAP bitmap = 0,oldbitmap, screen_buf,oldscreen_buf;

static PICTURE pic;
static PICTURE original; // original image
static PICTURE fit;
static PICTURE fit_r;
static PICTURE screen;   // resized to full screen image

static int end_program = FALSE;

#define MODE_BEST_FIT  1
#define MODE_ONE_2_ONE 2

static int mode = MODE_BEST_FIT;
static int rotate = 0;         // global rotate flag: 0 - 0, 1 - 90, 2 - 180, 3 - 270
static int slideshow = FALSE;  // slideshow mode
static int slideshow_cnt;      // timeout for slideshow mode (used also to hide F1_help)
static int F1_help = TRUE;
static const char* forground_text = NULL;
static const char* error_msg;

#define MAX_TASK_QUEUE_LEN 100
#define TSK_EXIT            0
#define TSK_SHOW_CURSOR     -1
#define TSK_HIDE_CURSOR     -2
#define TSK_SHOW_HOURGLASS  1
#define TSK_HIDE_HOURGLASS  2
#define TSK_DRAW            3
#define TSK_REDRAW          4
#define TSK_MODE_BEST_FIT   5
#define TSK_MODE_ONE_2_ONE  6
#define TSK_FIRST_FILE      7
#define TSK_NEXT_FILE       8
#define TSK_NEXT_FILE_R     9
#define TSK_PREV_FILE       10
#define TSK_PREV_FILE_R     11
#define TSK_LAST_FILE       12
#define TSK_SLIDESHOW       13
#define TSK_ROTATE_CW       14
#define TSK_ROTATE_CCW      15
#define TSK_PRINT           16
#define TSK_COPY            17
#define TSK_SCAN            18
#define TSK_FORMAT          19


// initialize tasks queue
#define TASK_INIT      { tasks.pos = 0; tasks.end_pos = 0; }
// add task
#define TASK_ADD(task) { tasks.queue[tasks.end_pos] = task; tasks.end_pos = (tasks.end_pos + 1 == MAX_TASK_QUEUE_LEN ) ? 0 : tasks.end_pos + 1; }
// switch to next task
#define TASK_NEXT      { tasks.pos = (tasks.pos + 1 == MAX_TASK_QUEUE_LEN ) ? 0 : tasks.pos + 1; }
// get task
#define TASK           tasks.queue[tasks.pos]
// is tasks queue not empty ?
#define TASK_EXISTS    tasks.pos != tasks.end_pos

// tasks queue
static struct
{
  int queue[MAX_TASK_QUEUE_LEN];
  int pos;
  int end_pos;
} tasks;

static void OutText(HDC hdc, int x, int y, const char* text)
{
  RECT r;

  r.left = x;
  r.top = y;
  r.right = screen.w;
  r.bottom = screen.h;

  SetTextColor(hdc,0x000000);
  DrawText(hdc,text,-1,&r,DT_LEFT | DT_TOP | DT_EXPANDTABS | DT_TABSTOP | (20<<8));

  r.left -= 2;
  r.top -= 2;

  SetTextColor(hdc,0xFFFFFF);
  DrawText(hdc,text,-1,&r,DT_LEFT | DT_TOP | DT_EXPANDTABS | DT_TABSTOP | (20<<8));
}

static void Draw(HDC hdc)
{
  HFONT font,oldfont;
  int xsrc,ysrc,xdest,ydest,w,h;

  if ( bitmap )
     {
       if ( oldx != x || oldy != y )
          {

            oldx = x;
            oldy = y;
               
            if ( pic.w < screen.w )
               {
                 w = pic.w;
                 xsrc = 0;
                 xdest = (screen.w-pic.w)/2;
               }
            else
               {
                 w = screen.w;
                 xsrc = x;
                 xdest = 0;
               }

            if ( pic.h < screen.h )
               {
                 h = pic.h;
                 ysrc = 0;
                 ydest = (screen.h-pic.h)/2;
               }
            else
               {
                 h = screen.h;
                 ysrc = y;
                 ydest = 0;
               }

            BitBlt(hdc,xdest,ydest,w,h,memdc,xsrc,ysrc,SRCCOPY);
          }
     }

  font = CreateFont(-22,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH,"Verdana");
  oldfont = SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);

  if ( error_msg )
     { 
       w = GetTabbedTextExtent(hdc, error_msg, lstrlen(error_msg), 0, NULL);
       h = w>>16;
       w &= 0xFFFF;
       OutText(hdc, (screen.w-w)>>1, (screen.h>>1)-h-5, error_msg);
       w = GetTabbedTextExtent(hdc, GetFileName(), lstrlen(GetFileName()), 0, NULL);
       w &= 0xFFFF;
       OutText(hdc, (screen.w-w)>>1, screen.h>>1, GetFileName());
     }

  if ( slideshow )
     OutText(hdc, 15, 15, S_SLIDE_SHOW);
  else if (F1_help)
     OutText(hdc, 15, 15, S_F1___HELP);
  else if (forground_text)
     OutText(hdc, 15, 15, forground_text);

  SelectObject(hdc,oldfont);
  DeleteObject(font);
}

static void SelectPic()
{
  switch (mode)
  {
  case MODE_ONE_2_ONE:
    pic = original;
    if ( rotate & 0x01 ) // 90 or 270 degrees
       {
         pic.w = original.h;
         pic.h = original.w;
       }
    pic.rotate = rotate;
    break;

  case MODE_BEST_FIT:
    if ( rotate & 0x01 ) // 90 or 270 degrees
       {
         pic = fit_r;
         pic.w = fit_r.h;
         pic.h = fit_r.w;
       }
    else
       {
         pic = fit;
       }
    pic.rotate = rotate;
    break;
  }
}

static void PrepareFit(void)
{
  float waspect, haspect; 

  FreePicture(&fit);

  if ( original.buf )
     {
       if ( (original.w>screen.w) || (original.h>screen.h) )
          {
            waspect = (float)original.w/screen.w;
            haspect = (float)original.h/screen.h;
            if ( waspect>haspect )
               {
                 fit.w = screen.w;
                 fit.h = original.h/waspect;
               }
            else
               {
                 fit.w = original.w/haspect;
                 fit.h = screen.h;
               }
            fit.buf = sys_alloc(fit.w * fit.h * 3);
            if ( fit.buf )
               {
                 fit.own = 1;
                 ResizeImage24(original.buf, original.w, original.h, fit.buf, fit.w, fit.h, 1);
               }
            else
               {
                 error_msg = S_INSUFFICIENT_MEMORY;
               }
          }
       else
          {
            fit.w = original.w;
            fit.h = original.h;
            fit.buf = original.buf;
            fit.own = 0;
          }
     }
}

static void PrepareFit_r(void)
{
  float waspect, haspect; 

  FreePicture(&fit_r);

  if ( original.buf )
     {
       if ( (original.w>screen.h) || (original.h>screen.w) )
          {
            waspect = (float)original.w/screen.h;
            haspect = (float)original.h/screen.w;
            if ( waspect>haspect )
               {
                 fit_r.w = screen.h;
                 fit_r.h = original.h/waspect;
               }
            else
               {
                 fit_r.w = original.w/haspect;
                 fit_r.h = screen.w;
               }
            fit_r.buf = sys_alloc(fit_r.w * fit_r.h * 3);
            if ( fit_r.buf )
               {
                 fit_r.own = 1;
                 ResizeImage24(original.buf, original.w, original.h, fit_r.buf, fit_r.w, fit_r.h, 1);
               }
            else
               {
                 error_msg = S_INSUFFICIENT_MEMORY;
               }
          }
       else
          {
            fit_r.w = original.w;
            fit_r.h = original.h;
            fit_r.buf = original.buf;
            fit_r.own = 0;
          }
     }
}


static int LoadFile(char* filename)
{
  BOOL rc;

  FreePicture(&original);

  if ( !filename || !*filename || !FileExist(filename) )
     {
       FreePicture(&fit);
       FreePicture(&fit_r);
       error_msg = S_NO_IMAGE_FILES_FOUND;
       SelectPic();
       return -1;
     }

  rc = LoadPicFile(filename,&original.w,&original.h,&original.buf);
  if ( rc )
     {
       original.own = 1;
       error_msg = NULL;
       PrepareFit();
       PrepareFit_r();
       if ( error_msg )
          {
            FreePicture(&original);
            FreePicture(&fit);
            FreePicture(&fit_r);
          }
       SelectPic();
       return 0;
     }
  else
     {
       FreePicture(&original);
       FreePicture(&fit);
       FreePicture(&fit_r);
   	   SetFileBad();
       SelectPic();
       error_msg = S_FILE_READ_ERROR;
       //error_msg = S_UNSUPPORTED_FILE_FORMAT;
       return -1;
     }
}


static void InitVars(void)
{
  oldx = -1;
  oldy = -1;
  x = 0;
  y = 0;
  screen.w = GetSystemMetrics(SM_CXSCREEN);
  screen.h = GetSystemMetrics(SM_CYSCREEN);

  ZeroMemory(keys,sizeof(keys));
}

static int InitScreenBuffer(void)
{
  HDC hdc = GetDC(NULL);

  screen_buf = CreateCompatibleBitmap(hdc, screen.w, screen.h);
  if ( !screen_buf )
     {
       error_msg = S_INSUFFICIENT_MEMORY;
       return -1;
     }
      
  screenmemdc = CreateCompatibleDC(NULL);
  oldscreen_buf = SelectObject(screenmemdc,screen_buf);
  ReleaseDC(NULL,hdc);

  return 0;
}

static void DoneScreenBuffer(void)
{
  if (screen_buf)
     {
       SelectObject(screenmemdc,oldscreen_buf);
       DeleteDC(screenmemdc);
       DeleteObject(screen_buf);
     }
}


static int InitBitmap(void)
{
  HDC hdc;
  BITMAPINFO bmi;
  int n,m,rowstride;
  unsigned char *row;

  int w,h;

  w = pic.w;
  h = pic.h;

  if ( !pic.buf )
     {
       bitmap = 0;
       return -1;
     }

  ZeroMemory(&bmi.bmiHeader,sizeof(BITMAPINFOHEADER));
  bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth = w;
  bmi.bmiHeader.biHeight = h;
  bmi.bmiHeader.biPlanes = 1;
  bmi.bmiHeader.biBitCount = 24;
  bmi.bmiHeader.biCompression = BI_RGB;
  
  hdc = GetDC(NULL);
  bitmap = CreateCompatibleBitmap(hdc, w, h);
  if ( !bitmap )
     {
       error_msg = S_INSUFFICIENT_MEMORY;
       return -1;
     }
  
  rowstride = w*3;
  if ( rowstride % 4 )
     rowstride += 4 - (rowstride % 4);

  row = HeapAlloc(GetProcessHeap(),0,rowstride);

  switch (pic.rotate & 0x03)
  {
  case 0:
    for ( n = 0; n < h; n++ )
        {
          unsigned char *src = (unsigned char *)pic.buf+n*w*3;
          unsigned char *dest = row;

          m = w;
          do {
            unsigned char r,g,b;

            r = *src++;
            g = *src++;
            b = *src++;
            *dest++ = b;
            *dest++ = g;
            *dest++ = r;
          } while (--m);

          SetDIBits(hdc,bitmap,h-1-n,1,row,&bmi,DIB_RGB_COLORS);
        }
    break;

  case 1:
    for ( n = 0; n < h; n++ )
        {
          unsigned char *dest = row;

          m = w;
          do {
            unsigned char *src = (unsigned char *)pic.buf+((m-1)*h + n)*3;
            unsigned char r,g,b;

            r = *src++;
            g = *src++;
            b = *src++;
            *dest++ = b;
            *dest++ = g;
            *dest++ = r;
          } while (--m);

          SetDIBits(hdc,bitmap,h-1-n,1,row,&bmi,DIB_RGB_COLORS);
        }
    break;

  case 2:
    for ( n = 0; n < h; n++ )
        {
          unsigned char *src = (unsigned char *)pic.buf+n*w*3;
          unsigned char *dest = row + w*3;

          m = w;
          do {
            unsigned char r,g,b;

            r = *src++;
            g = *src++;
            b = *src++;
            *--dest = r;
            *--dest = g;
            *--dest = b;
          } while (--m);

          SetDIBits(hdc,bitmap,n,1,row,&bmi,DIB_RGB_COLORS);
        }
    break;

  case 3:
    for ( n = 0; n < h; n++ )
        {
          unsigned char *dest = row;

          m = w;
          do {
            unsigned char *src = (unsigned char *)pic.buf+((w-m)*h + n)*3;
            unsigned char r,g,b;

            r = *src++;
            g = *src++;
            b = *src++;
            *dest++ = b;
            *dest++ = g;
            *dest++ = r;
          } while (--m);

          SetDIBits(hdc,bitmap,n,1,row,&bmi,DIB_RGB_COLORS);
        }
    break;
  }

  HeapFree(GetProcessHeap(),0,row);
      
  memdc = CreateCompatibleDC(NULL);
  oldbitmap = SelectObject(memdc,bitmap);
  ReleaseDC(NULL,hdc);

  return 0;
}

static void DoneBitmap(void)
{
  if (bitmap)
     {
       SelectObject(memdc,oldbitmap);
       DeleteDC(memdc);
       DeleteObject(bitmap);
     }
}

static void ReInitBitmap(void)
{
  x = 0;
  y = 0;
  oldx = -1;
  oldy = -1;
  DoneBitmap();
  InitBitmap();
}

void ShowInfo(HWND hwnd)
{
  static char text[1024];
  WIN32_FIND_DATA f;
  HANDLE h;
  SYSTEMTIME t;

  h = FindFirstFile(GetFileName(), &f);
  FindClose(h);
  
  if ( h != INVALID_HANDLE_VALUE )
     {
       FileTimeToSystemTime(&f.ftCreationTime, &t);
       wsprintf(text, "%s:\t %s\n%s:\t %dx%d\n%s:\t %d %s\n%s:\t %d.%02d.%d\n%s:\t %d:%02d", S_FILE_NAME, f.cFileName, S_SIZE,original.w,original.h, S_FILE_SIZE,f.nFileSizeLow,S_BYTES, S_CREATION_DATE,t.wDay,t.wMonth,t.wYear, S_CREATION_TIME,t.wHour,t.wMinute);
     }
  else
     {
       wsprintf(text, "%s:\t %s\n%s:\t %dx%d\n%s:\t %d %s\n%s:\t -\n%s:\t -", S_FILE_NAME, "-", S_SIZE,0,0, S_FILE_SIZE,0,S_BYTES, S_CREATION_DATE, S_CREATION_TIME);
     }

  forground_text = text;
  TASK_ADD(TSK_REDRAW);
}

static LRESULT CALLBACK WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_DISPLAYCHANGE )
     {
       DoneScreenBuffer();
       InitVars();
       PrepareFit();
       PrepareFit_r();
       if ( error_msg )
          {
            FreePicture(&original);
            FreePicture(&fit);
            FreePicture(&fit_r);
          }
       SelectPic();
       ReInitBitmap();
       InitScreenBuffer();
       MoveWindow(hwnd,0,0,screen.w,screen.h,TRUE);
       return 0;
     }
  
  if ( message == WM_PAINT )
     {
       PAINTSTRUCT ps;
       HDC hdc = BeginPaint(hwnd,&ps);
       if ( !IsIconic(hwnd) )
          {
            oldx = -1;
            oldy = -1;
            BitBlt(screenmemdc,0,0,screen.w,screen.h,screenmemdc,0,0,BLACKNESS);
            Draw(screenmemdc);
            BitBlt(hdc,0,0,screen.w,screen.h,screenmemdc,0,0,SRCCOPY);
          }
       EndPaint(hwnd,&ps);
       return 0;
     }

  if ( message == WM_CLOSE )
     return 0;

  if ( message == WM_SYSCHAR || message == WM_SYSKEYUP || message == WM_SYSKEYDOWN )
     return 0;

  if ( message == WM_KEYDOWN )
     keys[wParam & 0xFF] = 1;
     
  if ( message == WM_KEYUP )
     keys[wParam & 0xFF] = 0;

  if ( message == WM_KEYDOWN )
     {
       if ( F1_help )
          {
            F1_help = FALSE;
            TASK_ADD(TSK_REDRAW);
          }

       if ( forground_text )
          {
            forground_text = NULL;
            TASK_ADD(TSK_REDRAW);
          }
       else if (slideshow)
          {
            slideshow = !slideshow;
            TASK_ADD(TSK_REDRAW);
          }
       else
          switch ( wParam & 0xFF )
          {
          case VK_ESCAPE:
            TASK_ADD(TSK_EXIT);
            break;

          case VK_SUBTRACT:
            TASK_ADD(TSK_MODE_BEST_FIT);
            TASK_ADD(TSK_REDRAW);
            break;

          case VK_ADD:
            TASK_ADD(TSK_MODE_ONE_2_ONE);
            TASK_ADD(TSK_REDRAW);
            break;

          case 'R':
            if ( keys[VK_SHIFT] )
               TASK_ADD(TSK_ROTATE_CCW)
            else
               TASK_ADD(TSK_ROTATE_CW);
            TASK_ADD(TSK_REDRAW);
            break;

          case VK_HOME:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_FIRST_FILE);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_END:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_LAST_FILE);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_NEXT:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_NEXT_FILE);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_SPACE:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_NEXT_FILE_R);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_PRIOR:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_PREV_FILE);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_BACK:
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_PREV_FILE_R);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
            break;

          case VK_RETURN:
            if ( !error_msg )
               ShowInfo(hwnd);
            break;

          case VK_F1:
            forground_text = S__HELP;
            TASK_ADD(TSK_REDRAW);
            break;

          case VK_F11:
            slideshow = !slideshow;
            slideshow_cnt = sys_clock();
            TASK_ADD(TSK_REDRAW);
            break;
            
          case 'P':
            if ( keys[VK_CONTROL] && !error_msg)
               {
                 ShowCursor(TRUE);
                 if ( MessageBox(hwnd, S_PRINT_IMAGE_Q, S_CONFIRMATE, MB_OKCANCEL | MB_ICONQUESTION) == IDOK )
                    TASK_ADD(TSK_PRINT);
                 ShowCursor(FALSE);
               }
            break;

          case 'C':
            if ( keys[VK_CONTROL] && !error_msg)
               TASK_ADD(TSK_COPY);
            break;

/*          case 'S':
            if ( keys[VK_CONTROL] && !error_msg)
               {
                 TASK_ADD(TSK_SCAN);
                 TASK_ADD(TSK_EXIT);
               }
            break;*/

          case 'F':
            if ( keys[VK_CONTROL] && !error_msg)
               {
                 TASK_ADD(TSK_FORMAT);
               }
            break;
          }
     }

  return DefWindowProc(hwnd,message,wParam,lParam);
}



static void UpdateInput(void)
{
  int allowx = (pic.w > screen.w);
  int allowy = (pic.h > screen.h);

  if ( F1_help )
     {
       if ( sys_clock()-slideshow_cnt > 5000 )
          { 
            F1_help = FALSE;
            TASK_ADD(TSK_REDRAW);
          }   
     }
  if ( slideshow )
     {
       if ( sys_clock()-slideshow_cnt > 5000 )
          {
            slideshow_cnt = sys_clock();
            TASK_ADD(TSK_SHOW_HOURGLASS);
            TASK_ADD(TSK_NEXT_FILE_R);
            TASK_ADD(TSK_REDRAW);
            TASK_ADD(TSK_HIDE_HOURGLASS);
          }
     }

  if ( keys[VK_LEFT] && allowx )
     {
       x -= 25;
       if ( x < 0 )
          x = 0;
       TASK_ADD(TSK_DRAW);
     }

  if ( keys[VK_RIGHT] && allowx )
     {
       x += 25;
       if ( x > pic.w-screen.w )
         x = pic.w-screen.w;
       TASK_ADD(TSK_DRAW);
     }

  if ( keys[VK_UP] && allowy )
     {
       y -= 25;
       if ( y < 0 )
          y = 0;
       TASK_ADD(TSK_DRAW);
     }

  if ( keys[VK_DOWN] && allowy )
     {
       y += 25;
       if ( y > pic.h-screen.h )
          y = pic.h-screen.h;
       TASK_ADD(TSK_DRAW);
     }
}


void ProcessTask(HWND hwnd)
{
  HDC hdc;
  RECT rect;
  HCURSOR cursor;

  switch (TASK)
  {
  case TSK_EXIT:
    end_program = TRUE;
    break;

  case TSK_SHOW_CURSOR:
    ShowCursor(TRUE);
    break;

  case TSK_HIDE_CURSOR:
    ShowCursor(FALSE);
    break;

  case TSK_SHOW_HOURGLASS:
    cursor = LoadCursor(NULL, IDC_WAIT);
    SetCursor(cursor);
    ShowCursor(TRUE);
    break;

  case TSK_HIDE_HOURGLASS:
    ShowCursor(FALSE);
    cursor = LoadCursor(NULL, IDC_ARROW);
    SetCursor(cursor);
    break;

  case TSK_DRAW:
    hdc = GetDC(hwnd);
    Draw(hdc);
    ReleaseDC(hwnd,hdc);
    break;

  case TSK_REDRAW:
    rect.left = 0;
    rect.top = 0;
    rect.bottom = screen.h;
    rect.right = screen.w;
    InvalidateRect(hwnd, &rect, 0);
    break;

  case TSK_MODE_ONE_2_ONE:
    mode = MODE_ONE_2_ONE;
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_MODE_BEST_FIT:
    mode = MODE_BEST_FIT;
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_ROTATE_CW:
    rotate++;
    if ( rotate>3 )
       rotate -= 4;
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_ROTATE_CCW:
    rotate--;
    if ( rotate<0 )
       rotate += 4;
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_FIRST_FILE:
    SetFileRotate(rotate);
    FirstFile();
    rotate = GetFileRotate();
    LoadFile(GetFileName());
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_LAST_FILE:
    SetFileRotate(rotate);
    LastFile();
    rotate = GetFileRotate();
    LoadFile(GetFileName());
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_NEXT_FILE:
    SetFileRotate(rotate);
    if ( NextFile() )
       {
         rotate = GetFileRotate();
         LoadFile(GetFileName());
         SelectPic();
         ReInitBitmap();
       }
    break;

  case TSK_PREV_FILE:
    SetFileRotate(rotate);
    if ( PrevFile() )
       {
         rotate = GetFileRotate();
         LoadFile(GetFileName());
         SelectPic();
         ReInitBitmap();
       }
    break;

  case TSK_NEXT_FILE_R:
    SetFileRotate(rotate);
    if (!NextFile())
      FirstFile();
    rotate = GetFileRotate();
    LoadFile(GetFileName());
    SelectPic();
    ReInitBitmap();
    break;

  case TSK_PREV_FILE_R:
    SetFileRotate(rotate);
    if (!PrevFile())
      LastFile();
    rotate = GetFileRotate();
    LoadFile(GetFileName());
    SelectPic();
    ReInitBitmap();
    break;
    
  case TSK_PRINT:
    Print (hwnd, original.buf,original.w, original.h);
    break;

  case TSK_COPY:
    CopyToClipboard (hwnd, original.buf,original.w, original.h);
    break;

  case TSK_SCAN:
    ExecuteSelfScan();
    break;
 
  case TSK_FORMAT:
    ShowCursor(TRUE);
    ConvertFormat(hwnd,GetFileName(),rotate);
    ShowCursor(FALSE);
    break;
 
  }
  TASK_NEXT;
}


int Preview(HWND parent, char *path, char *filename)
{
  char *szClassName = "_BodyImgViewClass";
  HWND hwnd;
  HDC hdc;
  WNDCLASS wc;
  HANDLE event;
  MSG msg;

  // initialize tasks queue
  TASK_INIT;
  InitPicture(&original);
  InitPicture(&fit);
  InitPicture(&fit_r);

  InitVars();
  InitFiles(path, filename);
  InitScreenBuffer();

  
  ZeroMemory(&wc,sizeof(wc));
  wc.hIcon = LoadIcon(instance,MAKEINTRESOURCE(101));
  wc.hCursor = LoadCursor(NULL,IDC_ARROW);
  wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
  wc.lpfnWndProc = WindowProc;
  wc.hInstance = instance;
  wc.lpszClassName = szClassName;
  RegisterClass(&wc);

  hwnd = CreateWindowEx(0,szClassName,S_WIN_TITLE,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,screen.w,screen.h,parent,NULL,instance,NULL);
  ShowWindow(hwnd,SW_SHOWNORMAL);
  SetForegroundWindow(hwnd);


  if (filename)
     {
       if ( !FileExist(GetFileName()) )
          error_msg = S_FILE_NOT_FOUND;
       else
          LoadFile(GetFileName());
     }

  InitBitmap();


  ShowCursor(FALSE);
  UpdateWindow(hwnd);
  event = CreateEvent(NULL,FALSE,FALSE,NULL);

  RunFilesThread();

  slideshow_cnt = sys_clock();
  while (1)
  {
    if ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
       {
       	 GetMessage(&msg,NULL,0,0);
       	 DispatchMessage(&msg);        
       }
    else 
       { 
         UpdateInput();

         while (TASK_EXISTS)
           ProcessTask(hwnd);

         if ( end_program )
            break;

         MsgWaitForMultipleObjects(1,&event,FALSE,5,QS_ALLINPUT);
       }
  }

  CloseHandle(event);
  ShowCursor(TRUE);
  DestroyWindow(hwnd);
  UnregisterClass(szClassName,instance);
  DoneScreenBuffer();
  DoneBitmap();
  DoneFiles();

  return 0;
}

