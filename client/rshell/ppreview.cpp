
#include "include.h"



static const int title_pad = 65;



CPicPreview::CPicPreview(int _max_pic_w)
{
  max_pic_w = _max_pic_w;
}


CPicPreview::~CPicPreview()
{
}


void CPicPreview::GetTitleRect(RECT *r)
{
  int w = back_buff.w;
  int h = back_buff.h;

  r->left = 0;
  r->right = w;
  r->top = 0;
  r->bottom = title_pad;
}


void CPicPreview::GetSheetRect(int num,RECT *r_total,RECT *r_pic,RECT *r_name)
{
  const int global_pad = 15;  //pad between sheets
  const int inner_pad = 8; //inner pad inside rect
  const int name_pad = 25; //pad for name
  int pic_w,pic_h,sw,sh;
  int total_w,total_h;
  int fit_horiz,fit_vert;
  int abs_x,abs_y,offs_x,offs_y,num_rows,num_cols,row,col;
  
  if ( r_total )
     SetRectEmpty(r_total);
  
  if ( r_pic )
     SetRectEmpty(r_pic);
  
  if ( r_name )
     SetRectEmpty(r_name);

  int numpics = g_pics.size();
     
  if ( num < 0 || num >= numpics )
     return;

  //determine w,h
  int bitmap_w = 0, bitmap_h = 0;
  if ( g_pics[0].hbitmap )
     GetBitmapDim(g_pics[0].hbitmap,&bitmap_w,&bitmap_h);

  if ( !bitmap_w || !bitmap_h )
     return;

  sw = back_buff.w - global_pad;
  sh = back_buff.h - title_pad;
  pic_w = max_pic_w;

  do {
   pic_h = pic_w * bitmap_h / bitmap_w;

   total_w = pic_w + 2*inner_pad;
   total_h = pic_h + inner_pad + name_pad;

   fit_horiz = sw / (total_w + global_pad);
   fit_vert = sh / (total_h + global_pad);

   if ( fit_horiz * fit_vert >= numpics )
      break;

   pic_w--;
  } while (1);

  //determine rects
  num_rows = (numpics + fit_horiz - 1) / fit_horiz;
  row = num / fit_horiz;
  offs_y = (sh - (num_rows * (total_h + global_pad) - 0*global_pad)) / 2;
  abs_y = title_pad + offs_y + row * (total_h + global_pad);
  num_cols = (row == num_rows-1) ? ((numpics-1) % fit_horiz)+1 : fit_horiz;
  col = (num % fit_horiz);
  offs_x = (sw - (num_cols * (total_w + global_pad) - global_pad)) / 2;
  abs_x = global_pad/2 + offs_x + col * (total_w + global_pad);

  if ( r_total )
     {
       r_total->left = abs_x;
       r_total->right = r_total->left + total_w;
       r_total->top = abs_y;
       r_total->bottom = r_total->top + total_h;
     }

  if ( r_pic )
     {
       r_pic->left = inner_pad;
       r_pic->right = r_pic->left + pic_w;
       r_pic->top = inner_pad;
       r_pic->bottom = r_pic->top + pic_h;
     }

  if ( r_name )
     {
       r_name->left = 5;
       r_name->right = r_name->left + total_w - 5 - 5;
       r_name->top = inner_pad + pic_h;
       r_name->bottom = r_name->top + name_pad;
     }
}


int CPicPreview::GetSheetNumByPos(int x,int y)
{
  int rc = -1;

  for ( int n = 0; n < g_pics.size(); n++ )
      {
        POINT p;
        p.x = x;
        p.y = y;

        if ( PtInRect(&g_pics[n].r_total,p) )
           {
             rc = n;
             break;
           }
      }

  return rc;
}


void CPicPreview::PrepareBuffer(const WCHAR *title)
{
  CWaitCursor oWait;
  
  RB_Create(&back_buff);

  // prepare shader
  RBUFF shader;
  GdiFlush();
  HDC hdc = GetDC(NULL);
  CreateShaderInternal(hdc,&shader);
  ReleaseDC(NULL,hdc);
  RB_PaintTo(&shader,back_buff.hdc);
  RB_Destroy(&shader);

  //prepare pics
  SetFirst();
  while ( 1 )
  {
    PIC pic;
    ZeroMemory(&pic,sizeof(pic));
    
    if ( !GetNext(pic.hbitmap,pic.name,pic.current) )
       break;

    g_pics.push_back(pic);
  };
  
  //prepare rects
  for ( int n = 0; n < g_pics.size(); n++ )
      {
        PIC *i = &g_pics[n];
        GetSheetRect(n,&i->r_total,&i->r_pic,&i->r_name);
      }

  //draw title
  if ( title && title[0] )
     {
       HFONT font = CreateFontW(-30,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH,L"Verdana");
       HFONT oldfont = (HFONT)SelectObject(back_buff.hdc,font);
       SetBkMode(back_buff.hdc,TRANSPARENT);
       SetTextColor(back_buff.hdc,RGB(255,255,255));
       RECT r;
       GetTitleRect(&r);
       DrawTextWithShadowW(back_buff.hdc,title,&r,DT_CENTER | DT_VCENTER | DT_SINGLELINE,3,3);
       SelectObject(back_buff.hdc,oldfont);
       DeleteObject(font);
     }
  
  //draw entire sheets on buff
  for ( int n = 0; n < g_pics.size(); n++ )
      {
        const PIC *i = &g_pics[n];

        RECT r_total,r_pic,r_name;
        r_total = i->r_total;
        r_pic = i->r_pic;
        r_name = i->r_name;

        const int pic_w = r_pic.right - r_pic.left;
        const int pic_h = r_pic.bottom - r_pic.top;
        const int total_w = r_total.right - r_total.left;
        const int total_h = r_total.bottom - r_total.top;

        if ( total_w > 0 && total_h > 0 && pic_w > 0 && pic_h > 0 )
           {
             RBUFF temp;
             RB_CreateNormal(&temp,total_w,total_h);

             // frame
             {
               RECT r;
               SetRect(&r,0,0,total_w,total_h);
               Draw_Window_Rect(temp.hdc,&r,TRUE,TRUE,TRUE,TRUE,RGB(100,100,100),RGB(30,30,30));
             }

             // pic
             if ( i->hbitmap )
                {
                  HDC hdc = CreateCompatibleDC(NULL);
                  HBITMAP oldb = (HBITMAP)SelectObject(hdc,i->hbitmap);
                  int w = 0, h = 0;
                  GetHDCDim(hdc,&w,&h);
                  SetStretchBltMode(temp.hdc,HALFTONE);
                  SetBrushOrgEx(temp.hdc,0,0,NULL);
                  StretchBlt(temp.hdc,r_pic.left,r_pic.top,pic_w,pic_h,hdc,0,0,w,h,SRCCOPY);
                  SelectObject(hdc,oldb);
                  DeleteDC(hdc);
                }

             // frame around pic
             {
               RECT r;
               HBRUSH brush = CreateSolidBrush(RGB(0,0,0));
               r.left = r_pic.left - 1;
               r.top = r_pic.top - 1;
               r.right = r.left + pic_w + 2;
               r.bottom = r.top + pic_h + 2;
               FrameRect(temp.hdc,&r,brush);
               DeleteObject(brush);
             }

             // name
             if ( i->name && i->name[0] )
                {
                  HFONT font = CreateFontW(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,ANTIALIASED_QUALITY,DEFAULT_PITCH,L"Verdana");
                  HFONT oldfont = (HFONT)SelectObject(temp.hdc,font);
                  SetBkMode(temp.hdc,TRANSPARENT);
                  SetTextColor(temp.hdc,RGB(250,250,250));
                  DrawTextWithShadowW(temp.hdc,i->name,&r_name,DT_CENTER | DT_VCENTER | DT_SINGLELINE,2,3);
                  SelectObject(temp.hdc,oldfont);
                  DeleteObject(font);
                }

             // special effect for current
             if ( i->current )
                {
                  for ( int y = 0; y < total_h; y++ )
                    for ( int x = 0; x < total_w; x++ )
                        {
                          if ( (x+(y%2)) % 2 )
                             SetPixelV(temp.hdc,x,y,RGB(0,0,0));
                        }
                }

             // shadow under sheet
             {
               HBRUSH brush = CreateSolidBrush(RGB(5,5,5));
               RECT r;
               r = r_total;
               OffsetRect(&r,+4,+4);
               FillRect(back_buff.hdc,&r,brush);
               DeleteObject(brush);
             }
             
             // draw to back_buff
             BitBlt(back_buff.hdc,r_total.left,r_total.top,total_w,total_h,temp.hdc,0,0,SRCCOPY);

             RB_Destroy(&temp);
           }
      }
}


void CPicPreview::FreeBuffer()
{
  RB_Destroy(&back_buff);
  g_pics.clear();
}


LRESULT CPicPreview::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_DISPLAYCHANGE:
    case WM_CLOSE:
                       PostQuitMessage(-1);
                       return 0;
    
    case WM_DESTROY:
                       break;
    
    case WM_TIMER:
                       if ( close_time_sec != 0 )
                          {
                            if ( GetTickCount() - last_move_time > close_time_sec*1000 )
                               {
                                 KillTimer(hwnd,wParam);
                                 PostQuitMessage(-1);
                               }
                          }
                       return 0;
    
    case WM_LBUTTONUP:
                       {
                         int n = GetSheetNumByPos(LOWORD(lParam),HIWORD(lParam));
                         if ( n != -1 )
                            {
                              PostQuitMessage(n);
                            }
                       }
                       return 0;

    case WM_KEYDOWN:
                       if ( wParam == VK_ESCAPE )
                          PostQuitMessage(-1);
                       return 0;

    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                       return 0;

    case WM_MOUSEMOVE:
                       last_move_time = GetTickCount();
                       SetCursor(GetSheetNumByPos(LOWORD(lParam),HIWORD(lParam))==-1?cur_arrow:cur_drag);
                       return 0;
    
    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);
                         RB_PaintTo(&back_buff,hdc);
                         EndPaint(hwnd,&ps);
                       }
                       return 0;

    case WM_WINDOWPOSCHANGING:
                   {
                     WINDOWPOS *p = (WINDOWPOS*)lParam;
                     int sw,sh;

                     if ( IsIconic(hwnd) )
                        {
                          sw = GetSystemMetrics(SM_CXSCREEN);
                          sh = GetSystemMetrics(SM_CYSCREEN);

                          p->hwnd = hwnd;
                          p->hwndInsertAfter = HWND_TOPMOST;
                          p->x = 0;
                          p->y = 0;
                          p->cx = sw;
                          p->cy = sh;
                          p->flags = /*SWP_NOACTIVATE |*/ SWP_NOSENDCHANGING | SWP_SHOWWINDOW;

                          ShowWindow(hwnd,SW_RESTORE);
                          return 0;
                        }
                     else
                        break;
                   }
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}


int CPicPreview::ShowModal(HWND parent,const WCHAR *title,int maxtime)
{
  int exit_code = -1;
  
  PrepareBuffer(title);

  if ( g_pics.size() > 0 )
     {
       last_move_time = GetTickCount();
       close_time_sec = maxtime;

       WNDCLASS wc;
       ZeroMemory(&wc,sizeof(wc));
       wc.lpfnWndProc = WindowProcWrapper;
       wc.hInstance = our_instance;
       wc.lpszClassName = "_RSPicsPreviewWindowClass3";
       RegisterClass(&wc);

       HWND wnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,back_buff.w,back_buff.h,parent,NULL,our_instance,NULL);
       InitWindowProcWrapper(wnd);
       SetTimer(wnd,1,1000,NULL);

       HWND tooltip = CreateWindowExW(WS_EX_TOPMOST,TOOLTIPS_CLASSW,NULL,TTS_NOPREFIX | TTS_ALWAYSTIP,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,our_instance,NULL);
       SetWindowPos(tooltip,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE | SWP_NOSIZE | SWP_NOACTIVATE);
       SendMessageW(tooltip,TTM_ACTIVATE,TRUE,0);

       for ( int n = 0; n < g_pics.size(); n++ )
           {
             TOOLINFOW i;
             ZeroMemory(&i,sizeof(i));
             i.cbSize = sizeof(i);
             i.uFlags = TTF_SUBCLASS;
             i.hwnd = wnd;
             i.uId = n;
             i.hinst = NULL;
             i.lpszText = g_pics[n].name?(LPWSTR)g_pics[n].name:L"";
             i.rect = g_pics[n].r_total;
             SendMessageW(tooltip,TTM_ADDTOOLW,0,(int)&i);
           }

       ShowWindow(wnd,SW_SHOW);
       UpdateWindow(wnd);
       SetCapture(wnd);

       MSG msg;
       while ( GetMessage(&msg,NULL,0,0) )
             DispatchMessage(&msg);

       exit_code = msg.wParam;
       if ( exit_code < 0 || exit_code >= g_pics.size() )
          exit_code = -1;

       ReleaseCapture();
       DestroyWindow(tooltip);
       DoneWindowProcWrapper(wnd);
       DestroyWindow(wnd);
       UnregisterClass(wc.lpszClassName,our_instance);
     }

  FreeBuffer();

  return exit_code;
}



//////////////////////////////////////

static const int flag_width = 220;


CFlagsPreview::CFlagsPreview() : CPicPreview(flag_width)
{
 #ifdef ADDLANGS
  static const int flags[] = {IDT_FLAG_0,IDT_FLAG_1,IDT_FLAG_2,IDT_FLAG_3,IDT_FLAG_4,IDT_FLAG_5,IDT_FLAG_6,IDT_FLAG_7};
  static const WCHAR* names[] = {WSTR_008,WSTR_009,WSTR_010,WSTR_038,WSTR_039,WSTR_040,WSTR_041,WSTR_042};
 #else
  static const int flags[] = {IDT_FLAG_0,IDT_FLAG_1,IDT_FLAG_2};
  static const WCHAR* names[] = {WSTR_008,WSTR_009,WSTR_010};
 #endif
  const int count = sizeof(flags)/sizeof(flags[0]);

  for ( int n = 0; n < count; n++ )
      {
        g_bitmaps.push_back(LoadPicFromResource(flags[n]));
        g_names.push_back(names[n]);
      }
  
  g_idx = 0;
}


CFlagsPreview::~CFlagsPreview()
{
  for ( int n = 0; n < g_bitmaps.size(); n++ )
      {
        HBITMAP b = g_bitmaps[n];
        if ( b )
           DeleteObject(b);
        g_bitmaps[n] = NULL;
      }
  g_bitmaps.clear();

  g_names.clear();

  g_idx = 0;
}


void CFlagsPreview::SetFirst()
{
  g_idx = 0;
}


BOOL CFlagsPreview::GetNext(HBITMAP &_bitmap,const WCHAR* &_name,BOOL &_selected)
{
  if ( g_idx < 0 || g_idx >= g_bitmaps.size() )
     return FALSE;
  
  _bitmap = g_bitmaps[g_idx];
  _name = g_names[g_idx];
  _selected = FALSE;
  g_idx++;
  return TRUE;
}

