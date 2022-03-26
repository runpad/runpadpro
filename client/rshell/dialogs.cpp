
#include "include.h"


typedef struct {
int newdesktop;
char text[257];
HWND hwnd;
} TEXTTHREADINFO;

static int m_delay = 5000;
static TEXTTHREADINFO *m_info = NULL;



static void MDraw(HWND hwnd,HDC hdc)
{
  RECT r;
  HFONT font,oldfont;

  GetClientRect(hwnd,&r);
  FrameRect(hdc,&r,(HBRUSH)GetStockObject(WHITE_BRUSH));

  font = CreateFont(-12,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
  oldfont = (HFONT)SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);
  SetTextColor(hdc,0xFFFFFF);
  r.left += 10;
  r.right -= 10;
  r.top += 10;
  r.bottom -= 10;
  if ( m_info )
     DrawText(hdc,m_info->text,-1,&r,DT_CENTER | DT_VCENTER | DT_WORDBREAK);
  SelectObject(hdc,oldfont);
  DeleteObject(font);
}



static LRESULT CALLBACK MessageWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_USER:
                       KillTimer(hwnd,1);
                       SetTimer(hwnd,1,m_delay,NULL);
                       return 0;
    
    case WM_CLOSE:
                       return 0;

    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                       return 0;
    
    case WM_LBUTTONUP:
    case WM_RBUTTONUP:
    case WM_MBUTTONUP:
                       if ( m_info && m_info->newdesktop )
                          PostQuitMessage(1);
                       return 0;

    case WM_MOUSEMOVE:
                       if ( m_info && !m_info->newdesktop )
                          SetCursor(NULL);
                       return 0;

    case WM_TIMER:
                       if ( wParam == 2 )
                          InvalidateRect(hwnd,NULL,FALSE);
                       else
                       if ( wParam == 1 )
                          PostQuitMessage(1);
                       return 0;

    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);
                         MDraw(hwnd,hdc);
                         EndPaint(hwnd,&ps);
                       }
                       return 0;
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}



static DWORD WINAPI TextThreadProc(LPVOID lpParameter)
{
  const char *szClassName = "_RSMessageClass";
  const char *szDesktopName = "_RSMessageDesktop";
  HDESK desk = NULL, thread_desk = NULL, input_desk = NULL;
  WNDCLASS wc;
  int w,h,x,y;
  MSG msg;

  if ( !m_info )
     return 0;

  GdiSetBatchLimit(1);

  if ( m_info->newdesktop )
     {
       thread_desk = GetThreadDesktop(GetCurrentThreadId());
       input_desk = OpenInputDesktop(0,FALSE,GENERIC_ALL);
       desk = CreateDesktop(szDesktopName,NULL,NULL,0,GENERIC_ALL,NULL);
       SwitchDesktop(desk);
       SetThreadDesktop(desk);
     }

  ZeroMemory(&wc,sizeof(wc));
  wc.hCursor = m_info->newdesktop ? LoadCursor(NULL,IDC_ARROW) : NULL;
  wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
  wc.lpfnWndProc = MessageWindowProc;
  wc.hInstance = our_instance;
  wc.lpszClassName = szClassName;
  RegisterClass(&wc);

  w = 350;
  h = 100;
  x = (GetSystemMetrics(SM_CXSCREEN)-w)/2;
  y = (GetSystemMetrics(SM_CYSCREEN)-h)/2;

  m_info->hwnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,szClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,NULL,NULL,our_instance,NULL);
  SetTimer(m_info->hwnd,1,m_delay,NULL);
  if ( !m_info->newdesktop )
     SetTimer(m_info->hwnd,2,20,NULL);
  
  ShowWindow(m_info->hwnd,m_info->newdesktop?SW_SHOW:SW_SHOWNA);
  UpdateWindow(m_info->hwnd);

  while ( GetMessage(&msg,NULL,0,0) )
        DispatchMessage(&msg);        

  DestroyWindow(m_info->hwnd);
  m_info->hwnd = NULL;
  UnregisterClass(szClassName,our_instance);

  if ( m_info->newdesktop )
     {
       SetThreadDesktop(thread_desk);
       if ( !SwitchDesktop(input_desk) )
          SwitchDesktop(thread_desk);
       CloseDesktop(desk);
       CloseDesktop(input_desk);
     }

  sys_free(m_info);
  m_info = NULL;

  return 1;
}



void TextMessageBox(const char *text,int newdesktop,int delay_in_sec)
{
  int t;
  
  if ( !text || !text[0] || lstrlen(text) > 255 )
     return;

  t = delay_in_sec;
  if ( t < 2 )
     t = 2;
  if ( t > 300 )
     t = 300;
  t *= 1000;
  m_delay = t;

  if ( m_info )
     {
       if ( m_info->hwnd )
          {
            PostMessage(m_info->hwnd,WM_USER,0,0);
          }
     }
  else
     {
       DWORD thread_id;
       HANDLE thread;

       m_info = (TEXTTHREADINFO*)sys_alloc(sizeof(*m_info));
       m_info->newdesktop = newdesktop;
       lstrcpy(m_info->text,text);
       m_info->hwnd = NULL;

       thread = MyCreateThreadSelectedCPU(TextThreadProc,NULL,&thread_id);
       CloseHandle(thread);
     }
}



static LRESULT CALLBACK PictureWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  Bitmap *pBitmap = (Bitmap*)GetProp(hwnd,"Bitmap");
  HWND shader = (HWND)GetProp(hwnd,"Shader");
  const char *classname = (const char*)GetProp(hwnd,"ClassName");
  
  switch ( message )
  {
    case WM_KEYDOWN:
    case WM_LBUTTONUP:
    case WM_RBUTTONUP:
    case WM_MBUTTONUP:
    case WM_TIMER:
                       DestroyWindow(hwnd);
                       return 0;

    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
                       return 0;

    case WM_PAINT:
                       {
                         PAINTSTRUCT ps;
                         HDC hdc = BeginPaint(hwnd,&ps);

                         Graphics *pGraphics = new Graphics(hdc);
                         pGraphics->SetCompositingQuality(CompositingQualityHighSpeed);
                         pGraphics->SetInterpolationMode(InterpolationModeBilinear);
                         pGraphics->SetCompositingMode(CompositingModeSourceCopy);

                         RECT r;
                         GetClientRect(hwnd,&r);
                         int w = r.right - r.left;
                         int h = r.bottom - r.top;
                         
                         if ( pBitmap )
                            pGraphics->DrawImage(pBitmap,0,0,w,h);

                         pGraphics->Flush(FlushIntentionSync);

                         delete pGraphics;
                         
                         EndPaint(hwnd,&ps);
                       }
                       return 0;

    case WM_DESTROY:
                       {
                         RemoveProp(hwnd,"Bitmap");
                         RemoveProp(hwnd,"Shader");
                         RemoveProp(hwnd,"ClassName");
                         
                         if ( classname )
                            UnregisterClass(classname,our_instance);

                         if ( pBitmap )
                            delete pBitmap;
                         
                         ReleaseCapture();
                         PostMessage(GetMainWnd(),RS_DESTROYSHADER,(unsigned)shader,0);
                       }
                       return 0;
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}



void PictureBox(const char *filename)
{
  CWaitCursor oWait;

  Bitmap *pBitmap = new Bitmap(CUnicode(filename));

  if ( pBitmap->GetLastStatus() == Ok )
     {
       WNDCLASS wc;
       ZeroMemory(&wc,sizeof(wc));
       wc.hCursor = LoadCursor(NULL,IDC_ARROW);
       wc.lpfnWndProc = PictureWindowProc;
       wc.hInstance = our_instance;
       wc.lpszClassName = "_PictureClass";
       RegisterClass(&wc);

       int w = 512;
       int h = 384;
       int sw = GetSystemMetrics(SM_CXSCREEN);
       int sh = GetSystemMetrics(SM_CYSCREEN);
       int x = (sw-w)/2;
       int y = (sh-h)/2;

       HWND shader = CreateShader();
       HWND hwnd = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,wc.lpszClassName,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,x,y,w,h,shader,NULL,our_instance,NULL);

       SetProp(hwnd,"Bitmap",(HANDLE)pBitmap);
       SetProp(hwnd,"Shader",(HANDLE)shader);
       SetProp(hwnd,"ClassName",(HANDLE)wc.lpszClassName);
       
       SetTimer(hwnd,1,10000,NULL);
       ShowWindow(hwnd,SW_SHOW);
       UpdateWindow(hwnd);
       SetForegroundWindow(hwnd);
       SetCapture(hwnd);
     }
  else
     {
       delete pBitmap;
     }
}



typedef struct {
 const char *title;
 const char *text;
 int attr;
 int max;
 const char *data;
} TSTRINGPARAM;

static char out[1024];


static BOOL CALLBACK StringDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       HWND w;
       TSTRINGPARAM *p = (TSTRINGPARAM*)lParam;
       int icon = ( p->attr & ES_PASSWORD ) ? IDI_PASSWORD : IDI_STRING;
       
       SendDlgItemMessage(hwnd,IDC_SPICON,STM_SETIMAGE,IMAGE_ICON,(LPARAM)LoadIcon(our_instance,MAKEINTRESOURCE(icon)));
       SetWindowText(hwnd,p->title);
       SetDlgItemText(hwnd,IDC_LABEL,p->text);
       w = GetDlgItem(hwnd,IDC_EDIT);
       //SetWindowLong(w,GWL_STYLE,GetWindowLong(w,GWL_STYLE) | p->attr);
       //if ( p->attr & ES_PASSWORD )
       //   SendMessage(w,EM_SETPASSWORDCHAR,'*',0);
       SendMessage(w,EM_LIMITTEXT,p->max,0);
       SetWindowText(w,p->data);
       SetFocus(w);
       SendMessage(w,EM_SETSEL,0,-1);
       if ( p->attr & ES_PASSWORD )
          ActivateKeyboardLayout((HKL)0x409,0);
       SetForegroundWindow(hwnd);
     }
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     EndDialog(hwnd,0);
  
  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       GetDlgItemText(hwnd,IDC_EDIT,out,sizeof(out));
       EndDialog(hwnd,1);
     }

  return FALSE;
}


const char *GetString(const char *_title,const char *_text,int _attr,int _max,const char *_data)
{
  CForegroundWindowGuard oFGuard;
  
  TSTRINGPARAM p;
  int id = (_attr & ES_PASSWORD) ? IDD_STRINGP : IDD_STRING;
  
  p.title  = _title;
  p.text   = _text;
  p.attr   = _attr;
  p.max    = _max;
  p.data   = _data;

  return DialogBoxParam(our_instance,MAKEINTRESOURCE(id),GetMainWnd(),StringDialog,(int)&p) == 1 ? out : NULL;
}


const char *GetStringParentHwnd(HWND parent,const char *_title,const char *_text,int _attr,int _max,const char *_data)
{
  CForegroundWindowGuard oFGuard;

  TSTRINGPARAM p;
  int id = (_attr & ES_PASSWORD) ? IDD_STRINGP : IDD_STRING;
  
  p.title  = _title;
  p.text   = _text;
  p.attr   = _attr;
  p.max    = _max;
  p.data   = _data;

  return DialogBoxParam(our_instance,MAKEINTRESOURCE(id),parent,StringDialog,(int)&p) == 1 ? out : NULL;
}



void MsgBox(const char *text)
{
  CForegroundWindowGuard oFGuard;

  MessageBox(GetMainWnd(),text,LS(LS_INFO),MB_OK | MB_ICONINFORMATION | MB_TOPMOST);
}


void MsgBoxW(const WCHAR *text)
{
  CForegroundWindowGuard oFGuard;

  MessageBoxW(GetMainWnd(),text,CUnicodeRus(LS(LS_INFO)),MB_OK | MB_ICONINFORMATION | MB_TOPMOST);
}


void MsgBoxTray(const char *text,int delay)
{
  BalloonNotify(NIIF_INFO,LS(LS_INFO),text,delay);
}


void WarnBox(const char *text)
{
  CForegroundWindowGuard oFGuard;

  MessageBox(GetMainWnd(),text,LS(LS_INFO),MB_OK | MB_ICONWARNING | MB_TOPMOST);
}


void WarnBoxTray(const char *text,int delay)
{
  BalloonNotify(NIIF_WARNING,LS(LS_INFO),text,delay);
}


void ErrBox(const char *text)
{
  CForegroundWindowGuard oFGuard;

  MessageBox(GetMainWnd(),text,LS(LS_ERROR),MB_OK | MB_ICONERROR | MB_TOPMOST);
}


void ErrBoxW(const WCHAR *text)
{
  CForegroundWindowGuard oFGuard;

  MessageBoxW(GetMainWnd(),text,NULL,MB_OK | MB_ICONERROR | MB_TOPMOST);
}


void ErrBoxTray(const char *text,int delay)
{
  BalloonNotify(NIIF_ERROR,LS(LS_ERROR),text,delay);
}


int Confirm(const char *text)
{
  CForegroundWindowGuard oFGuard;

  return (MessageBox(GetMainWnd(),text,LS(LS_QUESTION),MB_OKCANCEL | MB_ICONQUESTION | MB_TOPMOST) == IDOK);
}


int ConfirmW(const WCHAR *text)
{
  CForegroundWindowGuard oFGuard;

  return (MessageBoxW(GetMainWnd(),text,CUnicodeRus(LS(LS_QUESTION)),MB_OKCANCEL | MB_ICONQUESTION | MB_TOPMOST) == IDOK);
}


int ShaderConfirm(const char *text)
{
  CForegroundWindowGuard oFGuard;

  HWND shader = CreateShader();
  int rc = MessageBox(shader,text,LS(LS_QUESTION),MB_OKCANCEL | MB_ICONQUESTION /*| MB_TOPMOST*/);
  DestroyShader(shader);
  return (rc == IDOK);
}


int ConfirmYESNO(const char *text)
{
  CForegroundWindowGuard oFGuard;

  return (MessageBox(GetMainWnd(),text,LS(LS_QUESTION),MB_YESNO | MB_ICONQUESTION | MB_TOPMOST) == IDYES);
}


int ConfirmYESNODefNOW(const WCHAR *text)
{
  CForegroundWindowGuard oFGuard;

  return (MessageBoxW(GetMainWnd(),text,CUnicodeRus(LS(LS_QUESTION)),MB_YESNO | MB_DEFBUTTON2 | MB_ICONQUESTION | MB_TOPMOST) == IDYES);
}


int RetryCancel(const char *text)
{
  CForegroundWindowGuard oFGuard;

  return (MessageBox(GetMainWnd(),text,LS(LS_ERROR),MB_RETRYCANCEL | MB_ICONERROR | MB_TOPMOST) == IDRETRY);
}



static const char *szShaderClass = "_RPShaderClass";
static const char *szShaderProp = "_RPShaderProp";


static LRESULT CALLBACK ShaderWindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  PAINTSTRUCT ps;
  HDC hdc;
  RBUFF *buff;
  
  switch ( message )
  {
    case WM_USER:
                       if ( wParam == 1 && lParam == 1 )
                          SetForegroundWindow(hwnd);
                       break;
    
    case WM_KEYDOWN:
    case WM_KEYUP:
    case WM_SYSKEYDOWN:
    case WM_SYSKEYUP:
    case WM_SYSCHAR:
    case WM_CLOSE:
                       return 0;

    case WM_PAINT:
                       hdc = BeginPaint(hwnd,&ps);
                       buff = (RBUFF*)GetProp(hwnd,szShaderProp);
                       if ( buff )
                          RB_PaintTo(buff,hdc);
                       EndPaint(hwnd,&ps);
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
                          p->flags = SWP_NOACTIVATE | SWP_NOSENDCHANGING | SWP_SHOWWINDOW;

                          ShowWindow(hwnd,SW_RESTORE);
                          PostMessage(hwnd,WM_USER,1,1);
                          return 0;
                        }
                     else
                        break;
                   }
  }
  
  return DefWindowProc(hwnd,message,wParam,lParam);
}


BOOL IsShaderWindow(HWND w)
{
  return (IsWindow(w) && GetProp(w,szShaderProp));
}


void CreateShaderInternal(HDC hdc,RBUFF *buff)
{
  CWaitCursor oWait;
  
  const int shade_color = 0x000000;
  const int alpha = 128;

  RB_Create(buff);
  RB_Fill(buff,shade_color);
  RB_PaintFrom(hdc,buff);

  RBUFF temp;
  RB_Create(&temp);
  RB_Fill(&temp,shade_color);
  MakeTransparent(buff->hdc,temp.hdc,0,0,0,0,buff->w,buff->h,alpha);
  RB_Destroy(&temp);
}


HWND CreateShader(void)
{
  HDC hdc;
  HWND w,parent = GetMainWnd();
  RBUFF *buff;
  WNDCLASS wc;

  if ( !CanUseGFX() )
     return parent;
  
  hdc = GetDC(NULL);
  if ( !hdc )
     return parent;
  buff = (RBUFF*)sys_alloc(sizeof(*buff));
  CreateShaderInternal(hdc,buff);
  ReleaseDC(NULL,hdc);

  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = ShaderWindowProc;
  wc.hInstance = our_instance;
  wc.lpszClassName = szShaderClass;
  wc.hCursor = LoadCursor(NULL,IDC_ARROW);
  RegisterClass(&wc);

  w = CreateWindowEx(WS_EX_TOPMOST | WS_EX_TOOLWINDOW,szShaderClass,NULL,WS_CLIPCHILDREN | WS_CLIPSIBLINGS | WS_POPUP,0,0,buff->w,buff->h,parent,NULL,our_instance,NULL);
  SetProp(w,szShaderProp,(HANDLE)buff);
  ShowWindow(w,SW_SHOW);
  //UpdateWindow(w);

  return w;
}


void DestroyShader(HWND w)
{
  RBUFF *buff;
  
  if ( !w || w == GetMainWnd() || !IsShaderWindow(w) )
     return;

  buff = (RBUFF*)RemoveProp(w,szShaderProp);
  DestroyWindow(w);
  UnregisterClass(szShaderClass,our_instance);
  
  if ( buff )
     {
       RB_Destroy(buff);
       sys_free(buff);
     }
}


const char* ShowPassword(const char *title)
{
  return GetString(LS(3037),title,ES_PASSWORD,31,"");
}


const char* ShowPasswordParentHwnd(HWND parent,const char *title)
{
  return GetStringParentHwnd(parent,LS(3037),title,ES_PASSWORD,31,"");
}


int GetLangDialog(int max_time_sec)
{
  CFlagsPreview *p = new CFlagsPreview();
  int idx = p->ShowModal(GetMainWnd(),NULL,max_time_sec);
  delete p;

  return idx;
}
