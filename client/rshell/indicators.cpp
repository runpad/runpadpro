
#include "include.h"


static int indic_installed = 0;
static HWND last_hwnd = NULL;

static struct { 
unsigned short id; 
unsigned short name; 
} langs[] =
{
  {0x0436,0x6641},{0x041C,0x7153},{0x0401,0x7241},{0x042D,0x7545},
  {0x0423,0x6542},{0x0402,0x6742},{0x0403,0x6143},{0x0404,0x6843},
  {0x0804,0x685A},{0x041A,0x7248},{0x0405,0x7A43},{0x0406,0x6144},
  {0x0413,0x6C4E},{0x0813,0x6C4E},{0x0409,0x6E45},{0x0809,0x6E45},
  {0x0C09,0x6E45},{0x1009,0x6E45},{0x1409,0x6E45},{0x1809,0x6E45},
  {0x0425,0x7445},{0x0429,0x6146},{0x040B,0x6946},{0x040C,0x7246},
  {0x080C,0x7246},{0x0C0C,0x7246},{0x0407,0x6544},{0x0807,0x6544},
  {0x0C07,0x6544},{0x1007,0x6544},{0x1407,0x6544},{0x0408,0x7247},
  {0x040D,0x6548},{0x040E,0x7548},{0x040F,0x7349},{0x0421,0x6142},
  {0x0410,0x7449},{0x0810,0x7449},{0x0411,0x614A},{0x0412,0x6F4B},
  {0x0426,0x764C},{0x0427,0x744C},{0x042F,0x6B4D},{0x0414,0x6F4E},
  {0x0814,0x6F4E},{0x0415,0x6C50},{0x0416,0x7450},{0x0816,0x7450},
  {0x0417,0x6D52},{0x0418,0x6F52},{0x0818,0x6F52},{0x0419,0x7552},
  {0x0819,0x7552},{0x081A,0x7253},{0x0C1A,0x7253},{0x041B,0x6B53},
  {0x0424,0x6C53},{0x042E,0x6253},{0x040A,0x7345},{0x080A,0x7345},
  {0x0C0A,0x7345},{0x041D,0x7653},{0x041E,0x6854},{0x041F,0x7254},
  {0x0422,0x6B55},{0x0420,0x7255},{0x0033,0x6556},{0x0034,0x6858},
  {0x0035,0x755A},{0x002B,0x7453},{0x002E,0x7354},{0x002F,0x6E54},
  {0x043F,0x4B4B},
};


static char *GetLangStr(HWND hwnd,int id)
{
  int n;
  static char s[8];

  if ( !hwnd )
     hwnd = ImmGetDefaultIMEWnd(GetForegroundWindow());  // really needed? IME window in the same thread
  if ( !hwnd )
     hwnd = GetForegroundWindow();
  if ( !id )
     id = (int)GetKeyboardLayout(GetWindowThreadProcessId(hwnd,NULL));
  id &= 0xFFFF;

  last_hwnd = hwnd;

  lstrcpy(s,"??");
  for ( n = 0; n < sizeof(langs)/sizeof(langs[0]); n++ )
      if ( langs[n].id == id )
         {
           s[0] = langs[n].name & 0xFF;
           s[1] = (langs[n].name >> 8) & 0xFF;
           s[2] = 0;
           CharUpperBuff(s,2);
           break;
         }

  return s;
}


static HICON CreateLangIcon(HWND hwnd,int id)
{
  ICONINFO i;
  HICON icon;
  HDC hdc;
  HBITMAP mask,color,oldbitmap;
  HFONT font,oldfont;
  HBRUSH brush;
  RECT r;
  unsigned char data_mask[2*16];

  // create mask-bitmap
  ZeroMemory(data_mask,sizeof(data_mask));
  mask = CreateBitmap(16,16,1,1,data_mask);
  
  // create color-bitmap
  hdc = GetDC(NULL);
  color = CreateCompatibleBitmap(hdc,16,16);
  ReleaseDC(NULL,hdc);

  hdc = CreateCompatibleDC(NULL);
  oldbitmap = (HBITMAP)SelectObject(hdc,color);

  // rect
  SetRect(&r,0,0,16,16);
  brush = CreateSolidBrush(RGB(128,0,0));
  FillRect(hdc,&r,brush);
  DeleteObject(brush);
  
  // text
  font = CreateFont(-11,0,0,0,FW_NORMAL,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Tahoma");
  oldfont = (HFONT)SelectObject(hdc,font);
  SetBkMode(hdc,TRANSPARENT);
  SetTextColor(hdc,0xFFFFFF);
  DrawText(hdc,GetLangStr(hwnd,id),-1,&r,DT_CENTER | DT_VCENTER | DT_SINGLELINE);
  SelectObject(hdc,oldfont);
  DeleteObject(font);

  SelectObject(hdc,oldbitmap);
  DeleteDC(hdc);

  // create icon
  i.fIcon = 1;
  i.hbmMask = mask;
  i.hbmColor = color;
  icon = CreateIconIndirect(&i);

  DeleteObject(mask);
  DeleteObject(color);

  return icon;
}


static BOOL UseSystemIndicator(void)
{
  return !is_vista;
}


static BOOL IsSystemIndicatorActive(void)
{
  char s[MAX_PATH];
  HWND w = FindWindow("Indicator",NULL);

  if ( !w )
     return FALSE;

  s[0] = 0;
  GetWindowProcessFileName(w,s);

  if ( !s[0] || lstrcmpi(PathFindExtension(s),".exe") )
     return TRUE; //some cases

  if ( !lstrcmpi(s,"internat.exe") )
     return TRUE;

  return FALSE;
}


static void IndicSwitch(void)
{
  if ( !UseSystemIndicator() )
     {
       NOTIFYICONDATA i;
       
       if ( (tray_indic && indic_installed) || (!tray_indic && !indic_installed) )
          return;

       if ( tray_indic )
          {
            ZeroMemory(&i,sizeof(i));
            i.cbSize = sizeof(i);
            i.hWnd = GetMainWnd();
            i.uID = 1;
            i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
            lstrcpyn(i.szTip,LS(3047),sizeof(i.szTip)-1);
            i.uCallbackMessage = RS_INDICCLICK;
            i.hIcon = CreateLangIcon(NULL,0);
            Shell_NotifyIcon(NIM_ADD,&i);
            DestroyIcon(i.hIcon);
            indic_installed = 1;
          }
       else
          {
            ZeroMemory(&i,sizeof(i));
            i.cbSize = sizeof(i);
            i.hWnd = GetMainWnd();
            i.uID = 1;
            Shell_NotifyIcon(NIM_DELETE,&i);
            indic_installed = 0;
          }
     }
  else
     {
       BOOL active = IsSystemIndicatorActive();

       if ( (tray_indic && active) || (!tray_indic && !active) )
          return;

       if ( tray_indic )
          {
            STARTUPINFO si;
            PROCESS_INFORMATION pi;
            char s[MAX_PATH];

            wsprintf(s,"\"%s%s\"",our_currpath,"internat.exe");

            ZeroMemory(&si,sizeof(si));
            si.cb = sizeof(si);
            CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,our_currpath,&si,&pi);
          }
       else
          {
            HWND w = FindWindow("Indicator",NULL);

            if ( w )
               PostMessage(w,WM_CLOSE,0,0);
          }
     }
}


void IndicUpdate(HWND hwnd,int id)
{
  if ( !UseSystemIndicator() )
     {
       NOTIFYICONDATA i;

       if ( !indic_installed || !tray_indic )
          return;

       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 1;
       i.uFlags = NIF_ICON;
       i.hIcon = CreateLangIcon(hwnd,id);
       Shell_NotifyIcon(NIM_MODIFY,&i);
       DestroyIcon(i.hIcon);
     }
}


static void IndicOnGlobalDone()
{
  HWND w = FindWindow("Indicator",NULL);

  if ( w )
     {
       PostMessage(w,WM_CLOSE,0,0);

       unsigned start = GetTickCount();
       while ( IsWindow(w) && GetTickCount() - start < 2000 )
       {
         Sleep(20);
       }
     }
}


void IndicNextLang(void)
{
  if ( !UseSystemIndicator() )
     {
       int thread;
       
       if ( !indic_installed || !tray_indic )
          return;

       if ( !last_hwnd )
          return;

     //  thread = GetWindowThreadProcessId(last_hwnd,NULL);
     //  AttachThreadInput(thread,GetCurrentThreadId(),TRUE);
     //  pAllowSetForegroundWindow(GetCurrentProcessId());
     //  SetForegroundWindow(last_hwnd);
     //  ActivateKeyboardLayout((HKL)HKL_NEXT,0);
     //  PostMessage(last_hwnd,WM_INPUTLANGCHANGEREQUEST,INPUTLANGCHANGE_FORWARD,0x04090409);
     //  AttachThreadInput(thread,GetCurrentThreadId(),FALSE);
     }
}



static int mixer_installed = 0;


static void MixerSwitch(void)
{
  NOTIFYICONDATA i;
  
  if ( (tray_mixer && mixer_installed) || (!tray_mixer && !mixer_installed) )
     return;

  if ( tray_mixer )
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 2;
       i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
       i.uCallbackMessage = RS_MIXERCLICK;
       i.hIcon = (is_volume_mute == 1) ? LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MIXEROFF)) : LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MIXER));
       lstrcpyn(i.szTip,LS(3048),sizeof(i.szTip)-1);
       Shell_NotifyIcon(NIM_ADD,&i);
       mixer_installed = 1;
     }
  else
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 2;
       Shell_NotifyIcon(NIM_DELETE,&i);
       mixer_installed = 0;
     }
}


void MixerUpdate(void)
{
  if ( tray_mixer && mixer_installed )
     {
       NOTIFYICONDATA i;
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 2;
       i.uFlags = NIF_ICON;
       i.hIcon = (is_volume_mute == 1) ? LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MIXEROFF)) : LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MIXER));
       Shell_NotifyIcon(NIM_MODIFY,&i);
     }
}



static void MinimizeAllSwitch(void)
{
  static int installed = 0;
  NOTIFYICONDATA i;
  
  if ( (tray_minimize_all && installed) || (!tray_minimize_all && !installed) )
     return;

  if ( tray_minimize_all )
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 3;
       i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
       i.uCallbackMessage = RS_MINIMIZEALLCLICK;
       i.hIcon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_MINIMIZE));
       lstrcpyn(i.szTip,LS(3049),sizeof(i.szTip)-1);
       Shell_NotifyIcon(NIM_ADD,&i);
       installed = 1;
     }
  else
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 3;
       Shell_NotifyIcon(NIM_DELETE,&i);
       installed = 0;
     }
}



static void MicrophoneSwitch(void)
{
  static int installed = 0;
  NOTIFYICONDATA i;
  
  if ( (tray_microphone && installed) || (!tray_microphone && !installed) )
     return;

  if ( tray_microphone )
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 4;
       i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
       i.uCallbackMessage = RS_MICROPHONECLICK;
       i.hIcon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_REC));
       lstrcpyn(i.szTip,LS(3050),sizeof(i.szTip)-1);
       Shell_NotifyIcon(NIM_ADD,&i);
       installed = 1;
     }
  else
     {
       ZeroMemory(&i,sizeof(i));
       i.cbSize = sizeof(i);
       i.hWnd = GetMainWnd();
       i.uID = 4;
       Shell_NotifyIcon(NIM_DELETE,&i);
       installed = 0;
     }
}


void SwitchOurTrayIcons(void)
{
  IndicSwitch();
  MixerSwitch();
  MinimizeAllSwitch();
  MicrophoneSwitch();
}


void OurTrayIconOnDone()
{
  IndicOnGlobalDone();
}

