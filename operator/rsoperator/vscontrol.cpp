
#include "include.h"


static const char *szClassName = "_RSOperatorHostWebCamScreenClass";
static const char *reg_path = REGPATH "\\" OURAPPNAME "\\VSControl";
static const float fps_list1[] = {/*30,25,20,15,12,*/10,8,5,2,1,0.5,0.3,0.2,0.1,0.05};
static const float fps_list2[] = {1,0.5,0.3,0.2,0.1,0.05};



CVSControl::CVSControl()
{
  hwnd = NULL;
  
  ZeroMemory(&client,sizeof(client));
  client.guid = NETGUID_UNKNOWN;

  is_webcam = TRUE;
  is_paused = FALSE;
  is_fullscreen = FALSE;

  SetRectEmpty(&nfs_rect);

  fps_list = NULL;
  fps_list_count = 0;
  fps_idx = 0;

  ZeroMemory(&g_buff,sizeof(g_buff));
}


CVSControl::~CVSControl()
{
  Close();
}


HWND CVSControl::GetWindowHandle()
{
  return hwnd;
}


void CVSControl::FreeDrawBuff()
{
  if ( g_buff.hdc )
     SelectObject(g_buff.hdc,g_buff.oldb);
  if ( g_buff.hdc )
     DeleteDC(g_buff.hdc);
  if ( g_buff.bitmap )
     DeleteObject(g_buff.bitmap);

  g_buff.hdc = NULL;
  g_buff.bitmap = NULL;
  g_buff.oldb = NULL;
  g_buff.w = 0;
  g_buff.h = 0;
}


void CVSControl::Paint(HDC hdc)
{
  if ( !IsIconic(hwnd) )
     {
       RECT r;
       GetClientRect(hwnd,&r);

       if ( !g_buff.hdc )
          {
            HBRUSH brush = CreateSolidBrush(RGB(0,0,0));
            FillRect(hdc,&r,brush);
            DeleteObject(brush);
          }
       else
          {
            int dw = r.right - r.left;
            int dh = r.bottom - r.top;

            SetStretchBltMode(hdc,COLORONCOLOR);
            StretchBlt(hdc,0,0,dw,dh,g_buff.hdc,0,0,g_buff.w,g_buff.h,SRCCOPY);
          }
     }
}


void CVSControl::OnTimer()
{
  if ( !is_paused && !IsIconic(hwnd) )
     {
       CNetCmd cmd(is_webcam?NETCMD_VIDEOCONTROL_REQ:NETCMD_SCREENCONTROL_REQ);
       NetSend(cmd,client.guid);
     }
}


void CVSControl::SendFinalPacket()
{
  if ( is_webcam )
     {
       CNetCmd cmd(NETCMD_VIDEOCONTROLFINISH);
       NetSend(cmd,client.guid);
     }
}


void CVSControl::SwitchFullScreen()
{
  if ( !IsIconic(hwnd) )
     {
       if ( !is_fullscreen )
          {
            is_fullscreen = TRUE;
            GetWindowRect(hwnd,&nfs_rect);
            ShowWindow(hwnd,SW_HIDE);
            SetWindowLong(hwnd,GWL_STYLE,WS_POPUP | WS_CLIPCHILDREN | WS_CLIPSIBLINGS);
            SetWindowPos(hwnd,NULL,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN),SWP_NOREDRAW | SWP_NOSENDCHANGING | SWP_NOZORDER);
            ShowWindow(hwnd,SW_SHOW);
            InvalidateRect(hwnd,NULL,FALSE);
            UpdateWindow(hwnd);
          }
       else
          {
            is_fullscreen = FALSE;
            ShowWindow(hwnd,SW_HIDE);
            SetWindowLong(hwnd,GWL_STYLE,WS_OVERLAPPEDWINDOW | WS_CLIPCHILDREN | WS_CLIPSIBLINGS);
            SetWindowPos(hwnd,NULL,nfs_rect.left,nfs_rect.top,nfs_rect.right-nfs_rect.left,nfs_rect.bottom-nfs_rect.top,SWP_NOREDRAW | SWP_NOSENDCHANGING | SWP_NOZORDER);
            ShowWindow(hwnd,SW_SHOW);
            InvalidateRect(hwnd,NULL,FALSE);
            UpdateWindow(hwnd);
          }
     }
}


void CVSControl::UpdateWindowCaption()
{
  char s[MAX_PATH*4];

  wsprintf(s,"%s\\%s - ",client.machine_loc,client.machine_desc);
  
  lstrcat(s,is_webcam?S_VIDEOCONTROL:S_SCREENCONTROL);
  lstrcat(s," ");
  lstrcat(s,S_RCLICKHELP);

  if ( is_paused )
     {
       lstrcat(s," - ");
       lstrcat(s,S_PAUSED);
     }

  SetWindowText(hwnd,s);
}


void CVSControl::SwitchPause()
{
  is_paused = !is_paused;
  UpdateWindowCaption();
}


void CVSControl::SetFPSTimer()
{
  if ( fps_list && fps_list_count && fps_idx >= 0 && fps_idx < fps_list_count )
     SetTimer(hwnd,1,(int)(1000.0/fps_list[fps_idx]),NULL);
  else
     KillTimer(hwnd,1);
}


void CVSControl::SaveParms()
{
  if ( !IsIconic(hwnd) && !is_fullscreen )
     {
       RECT r;
       GetWindowRect(hwnd,&r);

       int w = r.right - r.left;
       int h = r.bottom - r.top;

       WriteRegDword(HKCU,reg_path,"WindowWidth",w);
       WriteRegDword(HKCU,reg_path,"WindowHeight",h);
     }

  if ( is_webcam )
     WriteRegDword(HKCU,reg_path,"FPSIndexWebCam",fps_idx);
  else
     WriteRegDword(HKCU,reg_path,"FPSIndexScreen",fps_idx);
}


void CVSControl::ProcessMenu()
{
  const int idm_pause = 1000;
  const int idm_fs    = 1001;
  const int idm_speed = 1002;

  HMENU m = CreatePopupMenu();

  for ( int n = 0; n < fps_list_count; n++ )
      {
        char s[32];
        float fps = fps_list[n];
        if ( fps-(int)fps > 0 )
           sprintf(s,"%0.2f FPS",fps);
        else
           sprintf(s,"%d FPS",(int)fps);
        AppendMenu(m,fps_idx==n?MF_CHECKED:0,idm_speed+n,s);
      }
  
  HMENU menu = CreatePopupMenu();

  AppendMenu(menu,is_paused?MF_CHECKED:0,idm_pause,S_PAUSE);
  AppendMenu(menu,is_fullscreen?MF_CHECKED:0,idm_fs,S_FULLSCREEN);
  AppendMenu(menu,MF_SEPARATOR,0,NULL);
  AppendMenu(menu,MF_POPUP,(int)m,S_UPDATESPEED);     

  POINT p;
  GetCursorPos(&p);
  int x = p.x;
  int y = p.y;
  
  SetForegroundWindow(hwnd);
  SetActiveWindow(hwnd);
  int rc = TrackPopupMenu(menu,TPM_LEFTALIGN | TPM_RIGHTBUTTON | TPM_NONOTIFY | TPM_RETURNCMD,x,y,0,hwnd,NULL);
  DestroyMenu(menu);

  if ( rc && rc != -1 )
     {
       if ( rc == idm_pause )
          {
            SwitchPause();
          }
       else
       if ( rc == idm_fs )
          {
            SwitchFullScreen();
          }
       else
          {
            fps_idx = rc - idm_speed;
            SetFPSTimer();
            SaveParms();
          }
     }
}


LRESULT CVSControl::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_DESTROY:
    {
      SendFinalPacket();
      FreeDrawBuff();
      DoneWindowProcWrapper(hwnd);
      UnregisterClass(szClassName,our_instance);
      client.guid = NETGUID_UNKNOWN;
      this->hwnd = NULL;
      return 0;
    }

    case WM_TIMER:
    {
      OnTimer();
      break;
    }
    
    case WM_PAINT:
    {
      PAINTSTRUCT ps;
      HDC hdc = BeginPaint(hwnd,&ps);
      Paint(hdc);
      EndPaint(hwnd,&ps);
      return 0;
    }

    case WM_LBUTTONDBLCLK:
    {
      SwitchFullScreen();
      return 0;
    }

    case WM_RBUTTONUP:
    {
      ProcessMenu();
      return 0;
    }
                           
    case WM_KEYDOWN:
    {
      if ( wParam == VK_ESCAPE )
         DestroyWindow(hwnd);
      else
      if ( wParam == 'F' )
         SwitchFullScreen();
      else
      if ( wParam == VK_SPACE )
         SwitchPause();
      return 0;
    }

    case WM_SIZE:
    {
      SaveParms();
      InvalidateRect(hwnd,NULL,FALSE);
      UpdateWindow(hwnd);
      return 0;
    }

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CVSControl::IncomingScreen(const CNetCmd &cmd,unsigned src_guid)
{
  if ( hwnd && !IsIconic(hwnd) && !is_paused )
     {
       if ( src_guid == client.guid )
          {
            const char *buff = cmd.GetCmdBuffPtr();
            unsigned size = cmd.GetCmdBuffSize();
            
            if ( buff && size )
               {
                 IStream *stream = NULL;
                 
                 if ( CreateStreamOnHGlobal(NULL,TRUE,&stream) == S_OK )
                    {
                      ULARGE_INTEGER u_zero; 
                      u_zero.QuadPart = 0;
                      LARGE_INTEGER i_zero; 
                      i_zero.QuadPart = 0;
                      stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
                      stream->SetSize(u_zero);
                      stream->Write(buff,size,NULL);
                      stream->Seek(i_zero,STREAM_SEEK_SET,NULL);

                      Bitmap *img = new Bitmap(stream,FALSE);

                      if ( img->GetLastStatus() == Ok )
                         {
                           HBITMAP hbitmap = NULL;
                           
                           if ( img->GetHBITMAP(Color(),&hbitmap) == Ok )
                              {
                                if ( hbitmap )
                                   {
                                     FreeDrawBuff();

                                     g_buff.bitmap = hbitmap;
                                     g_buff.hdc = CreateCompatibleDC(NULL);
                                     g_buff.oldb = (HBITMAP)SelectObject(g_buff.hdc,g_buff.bitmap);
                                     g_buff.w = img->GetWidth();
                                     g_buff.h = img->GetHeight();

                                     InvalidateRect(hwnd,NULL,FALSE);
                                     UpdateWindow(hwnd);
                                   }
                              }
                         }

                      delete img;

                      stream->Release();
                    }
               }
          }
     }
}


void CVSControl::Open(HWND parent,BOOL webcam,const TENVENTRY *_client)
{
  if ( hwnd )
     {
       if ( _client->guid == client.guid && ((webcam && is_webcam) || (!webcam && !is_webcam)) )
          {
            if ( IsIconic(hwnd) )
               ShowWindow(hwnd,SW_RESTORE);
            SetForegroundWindow(hwnd);
            return;
          }
       else
          {
            Close();
          }
     }
  
  int w = ReadRegDword(HKCU,reg_path,"WindowWidth",512);
  if ( w < 100 )
     w = 100;
  int h = ReadRegDword(HKCU,reg_path,"WindowHeight",400);
  if ( h < 100 )
     h = 100;
  int sw = GetSystemMetrics(SM_CXSCREEN);
  int sh = GetSystemMetrics(SM_CYSCREEN);
  int x = (sw-w)/2;
  int y = (sh-h)/2;

  CopyMemory(&client,_client,sizeof(TENVENTRY));
  
  is_webcam = webcam;
  is_fullscreen = FALSE;
  is_paused = FALSE;
  fps_list = webcam?fps_list1:fps_list2;
  fps_list_count = webcam?(sizeof(fps_list1)/sizeof(fps_list1[0])):(sizeof(fps_list2)/sizeof(fps_list2[0]));
  if ( webcam )
     fps_idx = ReadRegDword(HKCU,reg_path,"FPSIndexWebCam",1);
  else
     fps_idx = ReadRegDword(HKCU,reg_path,"FPSIndexScreen",0);
  if ( fps_idx < 0 )
      fps_idx = 0;
  if ( fps_idx >= fps_list_count )
     fps_idx = fps_list_count-1;

  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.style = CS_DBLCLKS;
  wc.hCursor = LoadCursor(NULL,IDC_ARROW);
  wc.hIcon = NULL;
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = our_instance;
  wc.lpszClassName = szClassName;
  RegisterClass(&wc);

  hwnd = CreateWindowEx(0,szClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_OVERLAPPEDWINDOW,x,y,w,h,parent,NULL,our_instance,NULL);
  InitWindowProcWrapper(hwnd);

  int i_icon = webcam ? IDI_WEBCAM : IDI_DESKTOP;
  HICON icon_small = (HICON)LoadImage(our_instance, MAKEINTRESOURCE(i_icon), IMAGE_ICON, 16, 16, LR_SHARED);
  HICON icon_big = (HICON)LoadImage(our_instance, MAKEINTRESOURCE(i_icon), IMAGE_ICON, 32, 32, LR_SHARED);
  SendMessage(hwnd, WM_SETICON, ICON_SMALL, (LPARAM)icon_small);
  SendMessage(hwnd, WM_SETICON, ICON_BIG, (LPARAM)icon_big);
  
  UpdateWindowCaption();
  ShowWindow(hwnd,SW_SHOWNORMAL);
  UpdateWindow(hwnd);
  SetForegroundWindow(hwnd);

  SaveParms();

  if ( !webcam )
     SwitchFullScreen();

  OnTimer();
  SetFPSTimer();
}


void CVSControl::Close(void)
{
  if ( hwnd )
     {
       DestroyWindow(hwnd);
     }

  //all other action in WM_DESTROY
}
