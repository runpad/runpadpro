#include <Windows.h>
#include <Shlwapi.h>
#include "resource.h"
#include "lang.h"
#include "rp_shared.h"
#include "filesys.h"



#define HKCU		HKEY_CURRENT_USER
#define HKLM		HKEY_LOCAL_MACHINE
#define REGPATH		"Software\\RunpadProShell"
#define ONE_DAY		864000000000LL
#define MAXWINITEMS	200  // must be like in rshell!!!



#define RECTWIDTH(_rc)       ((_rc).right - (_rc).left)
#define RECTHEIGHT(_rc)      ((_rc).bottom - (_rc).top)


HINSTANCE instance;


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


void *sys_zalloc(int size)
{
  return HeapAlloc(GetProcessHeap(),HEAP_ZERO_MEMORY,size);
}


static void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


static void ReadRegStrP(HKEY h,const char *value,char *data,const char *def)
{
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegQueryValueEx(h,value,NULL,NULL,data,&len) == ERROR_SUCCESS )
     data[len] = 0;
}


static DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def)
{
  HKEY h;
  DWORD data = def;
  DWORD len = 4;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       RegQueryValueEx(h,value,NULL,NULL,(void *)&data,&len);
       RegCloseKey(h);
     }

  return data;
}


static DWORD ReadRegDwordP(HKEY h,const char *value,int def)
{
  DWORD data = def;
  DWORD len = 4;

  RegQueryValueEx(h,value,NULL,NULL,(void *)&data,&len);

  return data;
}


static int WriteRegDword(HKEY root,const char *key,const char *value,DWORD data)
{
  HKEY h;
  int rc = -1;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_DWORD,(void *)&data,4) == ERROR_SUCCESS )
          rc = 0;
       RegCloseKey(h);
     }

  return rc;
}


__declspec(dllexport) int __cdecl ExportWriteRegStr(HKEY root,const char *key,const char *value,const char *data)
{
  HKEY h;
  int rc = -1;

  if ( RegCreateKeyEx(root,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       if ( RegSetValueEx(h,value,0,REG_SZ,data,lstrlen(data)+1) == ERROR_SUCCESS )
          rc = 0;
       RegCloseKey(h);
     }

  return rc;
}


__declspec(dllexport) void __cdecl ExportDeleteRegValue(HKEY root,const char *key,const char *value)
{
  HKEY h;

  if ( RegOpenKeyEx(root,key,0,KEY_WRITE,&h) == ERROR_SUCCESS )
     {
       RegDeleteValue(h,value);
       RegCloseKey(h);
     }
}

/*
BOOL WINAPI _DllMainCRTStartup(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
  if ( fdwReason == DLL_PROCESS_ATTACH )
     {
       instance = hinstDLL;
       //DisableThreadLibraryCalls(instance);
     }

  return TRUE;
}
*/

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason,LPVOID lpvReserved)
{
  if ( fdwReason == DLL_PROCESS_ATTACH )
     {
       instance = hinstDLL;
       //DisableThreadLibraryCalls(instance);
     }

  return TRUE;
}


typedef struct SMessageBox_tag
{
  LPCSTR caption;
  LPCSTR text;
  LPCSTR list;
  int default_item;
  int type;
} SMessageBox;


BOOL CALLBACK MessageBoxDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_SETFONT )
     {
       SetWindowLong(hwnd, GWL_USERDATA, (LONG)wParam);
     }
  if ( message == WM_INITDIALOG )
     {
       SMessageBox *param = (SMessageBox*)lParam;
       LPCSTR li;
       int li_len = 0; // Length of current item(in characters)
       int li_cnt = 0; // Number of items
       HDC hdc;
       HFONT font, old_font;
       RECT r, old_r;
       RECT r2;
       int additional_w;
       RECT wnd_r;
       int dx, dy;
       POINT p = {0,0};
       HWND label = GetDlgItem(hwnd,IDC_LABEL);

       SetProp(hwnd,"_RPMessageBoxProp",(HANDLE)1);

       font = (HFONT)GetWindowLong(hwnd, GWL_USERDATA);
       if (font)
          {
            ClientToScreen(hwnd, &p);

            GetWindowRect(label, &r);
            OffsetRect(&r, -p.x, -p.y);
            old_r = r;

            hdc = GetWindowDC(label);
            old_font = (HFONT)SelectObject(hdc, font);
            DrawText(hdc, param->text, lstrlen(param->text), &r, DT_CALCRECT | DT_EXPANDTABS);
            r2 = r;

            additional_w = 6 + GetSystemMetrics(SM_CXVSCROLL) + 10;//border + button + reserved space

            for ( li = param->list; li[0]; li += li_len+1, li_cnt++ )
                {
                  li_len = lstrlen(li);
                  SendDlgItemMessage(hwnd, IDC_COMBO, LB_ADDSTRING, 0, (LPARAM)li);
                  DrawText(hdc, li, li_len, &r2, DT_CALCRECT | DT_EXPANDTABS);
                  if ( RECTWIDTH(r) < RECTWIDTH(r2)+additional_w )
                    r.right = r.left + RECTWIDTH(r2)+additional_w;
                }


            SelectObject(hdc, old_font);
            ReleaseDC(label, hdc);

            dx = RECTWIDTH(r) - RECTWIDTH(old_r);
            dy = RECTHEIGHT(r) - RECTHEIGHT(old_r);
            
            SetWindowPos(label, 0, 0, 0, RECTWIDTH(r), RECTHEIGHT(r), SWP_NOMOVE | SWP_NOZORDER);
            SetWindowPos(GetDlgItem(hwnd,IDC_COMBO), 0, r.left, r.bottom += 12, RECTWIDTH(r), 104, SWP_NOZORDER);

            GetWindowRect(GetDlgItem(hwnd,IDC_COMBO), &old_r);
            r.bottom += RECTHEIGHT(old_r) + 12;

            GetWindowRect(hwnd, &wnd_r);
            wnd_r.right += dx;
            wnd_r.bottom += dy;
            OffsetRect(&wnd_r, -(dx >> 1), -(dy >> 1));
            SetWindowPos(hwnd, 0, wnd_r.left, wnd_r.top, RECTWIDTH(wnd_r), RECTHEIGHT(wnd_r), SWP_NOZORDER);

            GetClientRect(hwnd, &wnd_r);
            GetWindowRect(GetDlgItem(hwnd,IDOK), &old_r);

            SetWindowPos(GetDlgItem(hwnd,IDOK), 0, (wnd_r.right>>1) - 4 - RECTWIDTH(old_r), r.bottom, 0, 0, SWP_NOSIZE | SWP_NOZORDER);
            SetWindowPos(GetDlgItem(hwnd,IDCANCEL), 0, (wnd_r.right>>1) + 4, r.bottom, 0, 0, SWP_NOSIZE | SWP_NOZORDER);

            SetWindowText(hwnd, param->caption);
            SetDlgItemText(hwnd, IDC_LABEL, param->text);

            if ( param->default_item >= li_cnt )
               param->default_item = li_cnt-1;
            if ( param->default_item < 0 )
               param->default_item = 0;

            SendDlgItemMessage(hwnd, IDC_COMBO, LB_SETCURSEL, param->default_item, 0);

            if ( param->type & ~RPICON_MASK )
               {
                 SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)param->type );
               }
            else
               {
                 switch ( param->type & RPICON_MASK )
                        {
                          case RPICON_SAVE:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(instance, MAKEINTRESOURCE(IDI_SAVE)));
                               break;
                          case RPICON_OPEN:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(instance, MAKEINTRESOURCE(IDI_OPEN)));
                               break;
                          case RPICON_QUESTION:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(NULL, IDI_QUESTION));
                               break;
                          case RPICON_INFO:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(NULL, IDI_INFORMATION));
                               break;
                          case RPICON_ERROR:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(NULL, IDI_ERROR));
                               break;
                          case RPICON_WARNING:
                               SendDlgItemMessage(hwnd, IDC_ICOND, STM_SETIMAGE, IMAGE_ICON, (LPARAM)LoadIcon(NULL, IDI_WARNING));
                               break;
                          default:
                               // No icon selected or unknown icon
                               break;
                        }
               }

            SetDlgItemText(hwnd,IDOK,LS(LS_OKAY));
            SetDlgItemText(hwnd,IDCANCEL,LS(LS_CANCEL));
            
            SetFocus(GetDlgItem(hwnd, IDC_COMBO));
          }
     }
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       RemoveProp(hwnd,"_RPMessageBoxProp");
       EndDialog(hwnd,-1);
     }
  
  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       int c;
       c = SendDlgItemMessage(hwnd,IDC_COMBO,LB_GETCURSEL,0,0);
       RemoveProp(hwnd,"_RPMessageBoxProp");
       EndDialog(hwnd,c);
     }
  
  return FALSE;
}



__declspec(dllexport) int __cdecl RPMessageBox(HWND hwnd, LPCSTR lpText, LPCSTR lpCaption, LPCSTR lpList, UINT uDefaultListItem, UINT uType)
{
  SMessageBox p;
  p.caption = lpCaption;
  p.text = lpText;
  p.list = lpList;
  p.default_item = uDefaultListItem;
  p.type = uType;
  return DialogBoxParam(instance,MAKEINTRESOURCE(IDD_MESSAGEBOX),hwnd,MessageBoxDialog,(LPARAM)&p);
}


__declspec(dllexport) BOOL __cdecl IsDisketteAllowed(void)
{
  return ReadRegDword(HKCU,REGPATH,"allow_use_diskette",1) != 0;
}


__declspec(dllexport) char* __cdecl GetDiskettePath(char *out)
{
  char net_path[MAX_PATH];
  int drives;
  
  out[0] = 0;

  if ( !IsDisketteAllowed() )
     return out;

  ReadRegStr(HKCU,REGPATH,"net_diskette",net_path,"");
  if ( net_path[0] )
     {
       PathAddBackslash(net_path);
       lstrcpy(out,net_path);
       return out;
     }
  
  drives = GetLogicalDrives();
  if ( drives & 1 )
     lstrcpy(out,"A:\\");
  else
  if ( drives & 2 )
     lstrcpy(out,"B:\\");

  return out;
}


__declspec(dllexport) char* __cdecl GetDisketteName(char *s)
{
  lstrcpy(s,S_DISKETTENAME);
  return s;
}


static void GetDrivesInternal(const char *name,DWORD type,char *out,HWND hwnd)
{
  int n,drives,count;
  char *fnames,*p;
  char fletters[32];

  fnames = sys_alloc(MAX_PATH*26);
  ZeroMemory(fnames,MAX_PATH*26);
  p = fnames;
  count = 0;
  
  drives = GetLogicalDrives();
  for ( n = 2; n <= 25; n++ )
      {
        if ( (drives >> n) & 1 )
           {
             char s[8];

             s[0] = 'A'+n;
             s[1] = ':';
             s[2] = '\\';
             s[3] = 0;

             if ( (type == DRIVE_REMOVABLE && IsDriveTrueRemovableI(n)) ||
                  (type != DRIVE_REMOVABLE && GetDriveType(s) == type && !IsDriveTrueRemovableI(n)) )
                {
                  DWORD sn,err,rc;

                  err = SetErrorMode(SEM_FAILCRITICALERRORS);

                  if ( GetVolumeInformation(s,NULL,0,&sn,NULL,NULL,NULL,0) )
                     {
                       char volume[MAX_PATH];
                       
                       volume[0] = 0;
                       GetVolumeInformation(s,volume,sizeof(volume),NULL,NULL,NULL,NULL,0);

                       wsprintf(p,"%s%d (%s)",name,count+1,volume[0]?volume:"noname");
                       p += lstrlen(p)+1;
                       fletters[count] = 'A'+n;
                       count++;
                     }
                  
                  SetErrorMode(err);
                }
           }
      }

  if ( count )
     {
       if ( count == 1 || !hwnd )
          {
            wsprintf(out,"%c:\\",fletters[0]);
          }
       else
          {
            int rc = RPMessageBox(hwnd,S_DISKSELECT2,S_DISKSELECT1,fnames,0,RPICON_SAVE);

            if ( rc >= 0 && rc < count )
               {
                 wsprintf(out,"%c:\\",fletters[rc]);
               }
          }
     }

  sys_free(fnames);
}


__declspec(dllexport) BOOL __cdecl IsFlashAllowed(void)
{
  return ReadRegDword(HKCU,REGPATH,"allow_use_flash",1) != 0;
}


__declspec(dllexport) char* __cdecl GetFlashPath(char *out,HWND hwnd)
{
  char net_path[MAX_PATH];
  
  out[0] = 0;

  if ( !IsFlashAllowed() )
     return out;

  ReadRegStr(HKCU,REGPATH,"net_flash",net_path,"");
  if ( net_path[0] )
     {
       PathAddBackslash(net_path);
       lstrcpy(out,net_path);
       return out;
     }

  GetDrivesInternal("Flash",DRIVE_REMOVABLE,out,hwnd);

  return out;
}


__declspec(dllexport) char* __cdecl GetFlashName(char *s)
{
  lstrcpy(s,S_FLASHNAME);
  return s;
}


__declspec(dllexport) BOOL __cdecl IsCDROMAllowed(void)
{
  return ReadRegDword(HKCU,REGPATH,"allow_use_cdrom",1) != 0;
}


__declspec(dllexport) char* __cdecl GetCDROMPath(char *out,HWND hwnd)
{
  char net_cd[MAX_PATH];

  out[0] = 0;

  if ( !IsCDROMAllowed() )
     return out;

  ReadRegStr(HKCU,REGPATH,"net_cdrom",net_cd,"");
  
  if ( net_cd[0] )
     {
       PathAddBackslash(net_cd);
       lstrcpy(out,net_cd);
     }
  else
     {
       GetDrivesInternal("CDROM",DRIVE_CDROM,out,hwnd);
     }

  return out;
}


__declspec(dllexport) char* __cdecl GetCDROMName(char *s)
{
  lstrcpy(s,S_CDROMNAME);
  return s;
}


__declspec(dllexport) BOOL __cdecl IsUserFolderAllowed(void)
{
  char s[MAX_PATH];
  ReadRegStr(HKCU,REGPATH,"user_folder_base",s,"");
  return s[0] != 0;
}


__declspec(dllexport) char* __cdecl GetUserFolderPath(char *out,int days_before)
{
  char s[MAX_PATH];
  char ss[MAX_PATH];
  char format[MAX_PATH];
  
  out[0] = 0;

  ReadRegStr(HKCU,REGPATH,"user_folder_base",s,"");
  
  ss[0] = 0;
  ExpandEnvironmentStrings(s,ss,sizeof(ss));  //not needed
  lstrcpy(s,ss);

  if ( !s[0] )
     return out;

  PathAddBackslash(s);
  CreateDirectory(s,NULL);

  ReadRegStr(HKCU,REGPATH,"uf_format",format,"");
  ss[0] = 0;
  ExpandEnvironmentStrings(format,ss,sizeof(ss));  //not needed
  lstrcat(s,ss);
  PathAddBackslash(s);
  CreateDirectory(s,NULL);

  if ( GetUserFolderRetrospective() > 0 )
     {
       int n;
       SYSTEMTIME t;
       __int64 time;
       char ss[MAX_PATH];
       
       GetLocalTime(&t);
       SystemTimeToFileTime(&t,(FILETIME*)&time);

       for ( n = 0; n < days_before; n++ )
           time -= ONE_DAY;

       FileTimeToSystemTime((FILETIME*)&time,&t);
       
       wsprintf(ss,"%04d_%02d_%02d",t.wYear,t.wMonth,t.wDay);
       lstrcat(s,ss);
       PathAddBackslash(s);
       CreateDirectory(s,NULL);
     }

  lstrcpy(out,s);

  return out;
}

__declspec(dllexport) char* __cdecl GetUserFolderName(char *out,int days_before)
{
  SYSTEMTIME t;
  __int64 time;
  int n;

  out[0] = 0;

  if ( days_before == 0 )
     {
       lstrcpy(out,S_USERFOLDERNAME);
       return out;
     }

  if ( days_before == 1 )
     {
       lstrcpy(out,S_USERFOLDERNAME1);
       return out;
     }

  GetLocalTime(&t);
  SystemTimeToFileTime(&t, (FILETIME*)&time);
  for ( n = 0; n < days_before; n++ )
      time -= ONE_DAY;
  FileTimeToSystemTime((FILETIME*)&time, &t);
  wsprintf(out, S_USERFOLDERNAMEN, t.wDay, t.wMonth, t.wYear);

  return out;
}

__declspec(dllexport) int   __cdecl GetUserFolderRetrospective()
{
  int clean = ReadRegDword(HKCU,REGPATH,"clean_user_folder",4);

  if ( clean < 0 )
     clean = 0;

  return clean;
}


static int GetAFInfo(int n,HKEY h,char *name,char *path)
{
  char s[32];
  int state;

  wsprintf(s,"state_%d",n+1);
  state = ReadRegDwordP(h,s,0);
  wsprintf(s,"parm1_%d",n+1);
  ReadRegStrP(h,s,name,"");
  wsprintf(s,"parm2_%d",n+1);
  ReadRegStrP(h,s,path,"");

  return state;
}


static void GetAFNamePath(int idx,char *_name,char *_path)
{
  HKEY h;
  int n,localidx=0;

  _name[0] = 0;
  _path[0] = 0;

  if ( RegOpenKeyEx(HKCU,REGPATH "\\addon_folders",0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       for ( n = 0; n < MAXWINITEMS; n++ )
           {
             char name[MAX_PATH];
             char path[MAX_PATH];
             int state;

             state = GetAFInfo(n,h,name,path);

             if ( state && name[0] && path[0] )
                {
                  if ( localidx == idx )
                     {
                       lstrcpy(_name,name);
                       lstrcpy(_path,path);
                       break;
                     }

                  localidx++;
                }
           }
       
       RegCloseKey(h);
     }
}


__declspec(dllexport) int __cdecl GetAdditionalFoldersCount()
{
  HKEY h;
  int n,count=0;

  if ( RegOpenKeyEx(HKCU,REGPATH "\\addon_folders",0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       for ( n = 0; n < MAXWINITEMS; n++ )
           {
             char name[MAX_PATH];
             char path[MAX_PATH];
             int state;

             state = GetAFInfo(n,h,name,path);

             if ( state && name[0] && path[0] )
                count++;
           }
       
       RegCloseKey(h);
     }

  return count;
}


__declspec(dllexport) BOOL __cdecl IsAdditionalFoldersAllowed(void)
{
  return GetAdditionalFoldersCount() != 0;
}


static const char* GetAFAccessPart(const char *name)
{
  const char *rc;
  int n,scope_idx;
  
  if ( !name )
     return NULL;

  rc = name + lstrlen(name);

  if ( !name[0] )
     return rc;

  if ( name[lstrlen(name)-1] != ')' )
     return rc;

  for ( n = lstrlen(name)-1; n >= 0; n-- )
      {
        if ( name[n] == '(' )
           break;
      }

  if ( n < 0 )
     return rc;

  if ( n < 1 )
     return rc;

  scope_idx = n;

  for ( n = scope_idx; n < lstrlen(name); n++ )
      {
        char c = name[n];

        if ( c != '(' && c != ')' && c != 'D' && c != 'd' && c != 'C' && c != 'c' && c != 'W' && c != 'w' )
           return rc;
      }

  if ( name[scope_idx-1] == ' ' )
     scope_idx--;

  if ( scope_idx == 0 )
     return rc;

  return &name[scope_idx];
}


static void RemoveAFAccessFromName(char *name)
{
  const char *acc = GetAFAccessPart(name);

  if ( acc )
     {
       if ( acc[0] )
          {
            *(char*)acc = 0;
          }
     }
}


static void CopyAFAccessFromName(char *name)
{
  const char *acc = GetAFAccessPart(name);

  if ( acc )
     {
       char t[MAX_PATH];

       lstrcpy(t,acc);
       lstrcpy(name,t);
     }
}


__declspec(dllexport) char* __cdecl GetAdditionalFolderName(char *out, int i)
{
  char name[MAX_PATH];
  char path[MAX_PATH];

  GetAFNamePath(i,name,path);
  RemoveAFAccessFromName(name);
  lstrcpy(out,name);

  return out;
}

__declspec(dllexport) char* __cdecl GetAdditionalFolderPath(char *out, int i)
{
  char name[MAX_PATH];
  char path[MAX_PATH];

  GetAFNamePath(i,name,path);
  lstrcpy(out,path);

  return out;
}

__declspec(dllexport) char* __cdecl GetAdditionalFolderAccess(char *out, int i)
{
  char name[MAX_PATH];
  char path[MAX_PATH];

  GetAFNamePath(i,name,path);
  CopyAFAccessFromName(name);
  lstrcpy(out,name);

  return out;
}


__declspec(dllexport) char* __cdecl GetFavoritesPath(char *out)
{
  HWND w;
  
  out[0] = 0;
   
  w = FindWindow("_RunpadClass",NULL);
  if ( w )
     {
       ATOM atom = (ATOM)SendMessage(w,WM_USER+171,0,0);
       if ( atom )
          {
            char name[MAX_PATH];

            name[0] = 0;
            GlobalGetAtomName(atom,name,MAX_PATH);
            GlobalDeleteAtom(atom);

            if ( name[0] )
               {
                 lstrcpy(out,name);
                 PathAddBackslash(out);
               }
          }
     }

  return out;
}


static BOOL RunHiddenProcessAndWaitInternal(const char *cmd,int *exit_code,TWAITPROCESSIDLE cb_func,void *cb_parm)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char *s;
  BOOL rc = FALSE;

  if ( exit_code )
     *exit_code = 0;
  
  s = (char*)sys_alloc(lstrlen(cmd)+1);
  lstrcpy(s,cmd);

  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE;
  if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
     {
       if ( !cb_func )
          {
            WaitForSingleObject(pi.hProcess,INFINITE);
          }
       else
          {
            while ( WaitForSingleObject(pi.hProcess,100) == WAIT_TIMEOUT )
                  {
                    if ( !cb_func(cb_parm) )
                       {
                         exit_code = NULL;
                         break;
                       }
                  }
          }
       
       if ( exit_code )
          {
            if ( GetExitCodeProcess(pi.hProcess,exit_code) )
               rc = TRUE;
          }
       else
          {
            rc = TRUE;
          }

       CloseHandle(pi.hProcess);
       CloseHandle(pi.hThread);
     }

  sys_free(s);
  return rc;
}


__declspec(dllexport) BOOL __cdecl RunHiddenProcessAndWait(const char *cmd,int *exit_code)
{
  return RunHiddenProcessAndWaitInternal(cmd,exit_code,NULL,NULL);
}


__declspec(dllexport) BOOL __cdecl RunHiddenProcessAndWaitIdle(const char *cmd,int *exit_code,TWAITPROCESSIDLE cb_func,void *cb_parm)
{
  return RunHiddenProcessAndWaitInternal(cmd,exit_code,cb_func,cb_parm);
}


__declspec(dllexport) BOOL __cdecl RunProcess(const char *cmd)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char *s;
  BOOL rc = FALSE;

  s = (char*)sys_alloc(lstrlen(cmd)+1);
  lstrcpy(s,cmd);

  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
     {
       rc = TRUE;

       CloseHandle(pi.hProcess);
       CloseHandle(pi.hThread);
     }

  sys_free(s);
  return rc;
}


__declspec(dllexport) BOOL __cdecl RunProcessWithShowWindow(const char *cmd,int cmd_show)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char *s;
  BOOL rc = FALSE;

  s = (char*)sys_alloc(lstrlen(cmd)+1);
  lstrcpy(s,cmd);

  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = cmd_show;

  if ( CreateProcess(NULL,s,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi) )
     {
       rc = TRUE;

       CloseHandle(pi.hProcess);
       CloseHandle(pi.hThread);
     }

  sys_free(s);
  return rc;
}


__declspec(dllexport) void __cdecl AddURL2Stat(const char *url)
{
  char s[256];
  DWORD len = sizeof(s)-1;

  if ( !url || !url[0] )
     return;

  s[0] = 0;
  if ( UrlGetPart(url,s,&len,URL_PART_HOSTNAME,0) == S_OK && s[0] )
     {
       char *p = s;
       
       if ( lstrlen(s) > 4 && !StrCmpNI(s,"www.",4) )
          p = &s[4];

       if ( p[0] )
          {
            ATOM atom = GlobalAddAtom(p);

            if ( atom )
               {
                 HWND w = FindWindow("_RunpadClass",NULL);

                 if ( w )
                    PostMessage(w,WM_USER+157,(int)atom,0);
               }
          }
     }
}



__declspec(dllexport) BOOL __cdecl IsVIPFolderAllowed(void)
{
  return ReadRegDword(HKCU,REGPATH,"vip_in_menu",1) != 0;
}


__declspec(dllexport) char* __cdecl GetVIPFolderPath(char *out)
{
  HWND w;
  
  out[0] = 0;
   
  w = FindWindow("_RunpadClass",NULL);
  if ( w )
     {
       ATOM atom = (ATOM)SendMessage(w,WM_USER+161,0,0);
       if ( atom )
          {
            char name[MAX_PATH];

            name[0] = 0;
            GlobalGetAtomName(atom,name,MAX_PATH);
            GlobalDeleteAtom(atom);

            if ( name[0] )
               {
                 lstrcpy(out,name);
                 PathAddBackslash(out);
               }
          }
     }

  return out;
}


__declspec(dllexport) char* __cdecl GetVIPFolderName(char *s)
{
  HWND w;
  
  lstrcpy(s,S_VIPFOLDERNAME);
   
  w = FindWindow("_RunpadClass",NULL);
  if ( w )
     {
       ATOM atom = (ATOM)SendMessage(w,WM_USER+160,0,0);
       if ( atom )
          {
            char name[MAX_PATH];

            name[0] = 0;
            GlobalGetAtomName(atom,name,MAX_PATH);
            GlobalDeleteAtom(atom);

            if ( name[0] )
               {
                 wsprintf(s,S_VIPNAME,name);
               }
          }
     }

  return s;
}

/******************************************************************************
** Open With... section
******************************************************************************/

__declspec(dllexport) int   __cdecl GetOpenWithCount()
{
  return 2;
}


__declspec(dllexport) char* __cdecl GetOpenWithName(int idx,char *name)
{
  if ( idx == 0 )
     lstrcpy(name, S_NOTEPAD);
  else
  if ( idx == 1 )
     lstrcpy(name, S_MEDIAPLAYER);
  else
     lstrcpy(name,"");

  return name;
}


__declspec(dllexport) void  __cdecl OpenWith(int idx,const char *filename)
{
  if ( idx == 0 || idx == 1 )
     {
       if ( filename && filename[0] )
          {
            HWND w = FindWindow("_RunpadClass",NULL);
            if ( w )
               {
                 ATOM atom = GlobalAddAtom(filename);
                 if ( atom )
                    {
                      HWND f = FindWindow("Shell_TrayWnd",NULL);
                      if ( f )
                         {
                           DWORD id = GetWindowThreadProcessId(f,NULL);
                           AttachThreadInput(id,GetCurrentThreadId(),TRUE);
                           SetForegroundWindow(f);
                           AttachThreadInput(id,GetCurrentThreadId(),FALSE);
                         }
                      
                      if ( idx == 0 )
                         PostMessage(w,WM_USER+162,(int)atom,0);
                      else
                      if ( idx == 1 )
                         PostMessage(w,WM_USER+169,(int)atom,0);
                    }
               }
          }
     }
}


static BOOL IsExtensionInList(const char *path,const char *allowed_ext)
{
  char s[MAX_PATH],*ext,*p;
  int n;

  ZeroMemory(s,sizeof(s));
  lstrcpy(s,allowed_ext);

  for ( n = 0; n < sizeof(s); n++ )
      if ( s[n] == ';' || s[n] == ',' )
         s[n] = 0;

  ext = PathFindExtension(path);
  if ( *ext )
     {
       int find = 0;

       ext++;
       p = s;

       while ( *p )
       {
         if ( !lstrcmpi(p,ext) )
            {
              find = 1;
              break;
            }

         p += lstrlen(p)+1;
       }

       return find;
     }

  return 0;
}


typedef struct {
const char *exts;
BOOL find;
} LAWINFO;

static void ScanForLawProtectedInternal(const char *dir,LAWINFO *info);


static BOOL FindProc(const char *path,WIN32_FIND_DATA *f,void *user)
{
  LAWINFO *info = (LAWINFO*)user;

  if ( f->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
     {
       ScanForLawProtectedInternal(path,info);
       if ( info->find )
          return FALSE;
     }
  else
     {
       if ( IsExtensionInList(f->cFileName,info->exts) )
          {
            info->find = TRUE;
            return FALSE;
          }
     }

  return TRUE;
}


static void ScanForLawProtectedInternal(const char *dir,LAWINFO *info)
{
  ScanDir(dir,SCAN_DIR | SCAN_FILE | SCAN_HIDDEN,FindProc,info);
}


__declspec(dllexport) BOOL __cdecl ScanForLawProtected(const char *dir)
{
  char exts[MAX_PATH];

  if ( !dir || !dir[0] )
     return FALSE;
  
  ReadRegStr(HKCU,REGPATH,"law_protected_files",exts,"");
  
  if ( PathIsDirectory(dir) )
     {
       LAWINFO info;

       info.exts = exts;
       info.find = FALSE;
       ScanForLawProtectedInternal(dir,&info);

       return info.find;
     }
  else
     {
       return IsExtensionInList(dir,exts);
     }
}


static void* LoadRawResource(int id,int *_size)
{
  HRSRC res = FindResource(instance,MAKEINTRESOURCE(id),RT_RCDATA);
  if ( res )
     {
       HGLOBAL g = LoadResource(instance,res);
       if ( g )
          {
            *_size = SizeofResource(instance,res);
            return LockResource(g);
          }
     }

  *_size = 0;
  return NULL;
}


static BOOL WriteFullFile(const char *filename,void *buff,int size)
{
  BOOL rc = FALSE;
  void *h;

  h = sys_fcreate(filename);
  if ( h )
     {
       int total = sys_fwrite(h,buff,size);
       sys_fclose(h);
       rc = (total == size);
     }

  return rc;
}


static BOOL WriteResourceToFile(const char *filename,int id)
{
  int size = 0;
  void *buff = LoadRawResource(id,&size);
  return buff ? WriteFullFile(filename,buff,size) : FALSE;
}


__declspec(dllexport) BOOL __cdecl CreateNewEmptyDOC(const char *filename)
{
  return WriteResourceToFile(filename,ID_NEWDOC);
}

__declspec(dllexport) BOOL __cdecl CreateNewEmptyXLS(const char *filename)
{
  return WriteResourceToFile(filename,ID_NEWXLS);
}

__declspec(dllexport) BOOL __cdecl CreateNewEmptyTXT(const char *filename)
{
  return WriteResourceToFile(filename,ID_NEWTXT);
}


// warning!! registry modif. can be disabled by setting DisableRegistryTools !!!
__declspec(dllexport) BOOL __cdecl ImportRegistryFile(const char *filename)
{
  BOOL rc = FALSE;
  OSVERSIONINFO v;
  
  v.dwOSVersionInfoSize = sizeof(v);
  if ( GetVersionEx(&v) )
     {
       char cmd[MAX_PATH];
       int exit_code;
       BOOL use_exit_code = TRUE;

       if ( v.dwMajorVersion == 4 || (v.dwMajorVersion == 5 && v.dwMinorVersion == 0) )  //Win98/ME/2000
          {
            wsprintf(cmd,"regedit.exe -s \"%s\"",filename);
            use_exit_code = FALSE;
          }
       else
          {
            wsprintf(cmd,"reg.exe IMPORT \"%s\"",filename);
          }

       exit_code = -1;
       if ( RunHiddenProcessAndWait(cmd,&exit_code) )
          {
            if ( use_exit_code )
               rc = (exit_code == 0);
            else
               rc = TRUE;
          }
     }

  return rc;
}



__declspec(dllexport) int __cdecl RPOpenSaveDialog(HWND hwnd,const char *s_text,const char *s_caption,char *out,char *out_name)
{
  int rc = RPOPENSAVE_CANCEL;
  char s[2048],*p;
  char buff[MAX_PATH];
  int last_save_to;
  int iflash=-1,idiskette=-1,icdrom=-1,ivipfolder=-1,iuserfolder=-1,iexfolder=-1;
  int count, idx;

  out[0] = 0;

  if ( out_name )
     out_name[0] = 0;
  
  ZeroMemory(s,sizeof(s));
  p = s;
  count = 0;

  if ( IsFlashAllowed() )
     {
       lstrcpy(p,GetFlashName(buff));
       p += lstrlen(p) + 1;
       iflash = count;
       count++;
     }

  if ( IsDisketteAllowed() )
     {
       lstrcpy(p,GetDisketteName(buff));
       p += lstrlen(p) + 1;
       idiskette = count;
       count++;
     }

  if ( IsCDROMAllowed() )
     {
       lstrcpy(p,GetCDROMName(buff));
       p += lstrlen(p) + 1;
       icdrom = count;
       count++;
     }

  if ( IsVIPFolderAllowed() )
     {
       lstrcpy(p,GetVIPFolderName(buff));
       p += lstrlen(p) + 1;
       ivipfolder = count;
       count++;
     }

  if ( IsUserFolderAllowed() )
     {
       lstrcpy(p,GetUserFolderName(buff,0));
       p += lstrlen(p) + 1;
       iuserfolder = count;
       count++;
     }

  if ( IsAdditionalFoldersAllowed() )
     {
       if ( ReadRegDword(HKCU,REGPATH,"allow_save_to_addon_folders",0) )
          {
            int n,total = GetAdditionalFoldersCount();

            iexfolder = count;

            for ( n = 0; n < total; n++ )
                {
                  char t[MAX_PATH];
                  t[0] = 0;
                  GetAdditionalFolderName(t,n);
                  lstrcpy(p,t);
                  p += lstrlen(p) + 1;
                  count++;
                }
          }
     }

  if ( !count )
     {
       MessageBox(hwnd,S_SAVERESTRICT,S_RESTRICT,MB_OK | MB_ICONWARNING);
       return rc;
     }

  last_save_to = ReadRegDword(HKCU,REGPATH,"RPLastSaveTo",0);
  idx = RPMessageBox(hwnd,s_text,s_caption,s,last_save_to,RPICON_SAVE);
  
  if ( idx == -1 )
     {
       return rc;
     }

  WriteRegDword(HKCU,REGPATH,"RPLastSaveTo",idx);

  if ( idx == iflash )
     {
       GetFlashPath(out,hwnd);
       rc = RPOPENSAVE_FLASH;
       if ( out_name )
          GetFlashName(out_name);
     }
  else
  if ( idx == idiskette )
     {
       GetDiskettePath(out);
       rc = RPOPENSAVE_DISKETTE;
       if ( out_name )
          GetDisketteName(out_name);
     }
  else
  if ( idx == icdrom )
     {
       GetCDROMPath(out,hwnd);
       rc = RPOPENSAVE_CDROM;
       if ( out_name )
          GetCDROMName(out_name);
     }
  else
  if ( idx == ivipfolder )
     {
       GetVIPFolderPath(out);
       rc = RPOPENSAVE_VIPFOLDER;
       if ( out_name )
          GetVIPFolderName(out_name);
     }
  else
  if ( idx == iuserfolder )
     {
       GetUserFolderPath(out,0);
       rc = RPOPENSAVE_USERFOLDER;
       if ( out_name )
          GetUserFolderName(out_name,0);
     }
  else
     {
       GetAdditionalFolderPath(out,idx-iexfolder);
       rc = RPOPENSAVE_EXFOLDER;
       if ( out_name )
          GetAdditionalFolderName(out_name,idx-iexfolder);
     }

  if ( !out[0] )
     {
       if ( rc != RPOPENSAVE_VIPFOLDER )
          {
            MessageBox(hwnd,S_RESEMPTY,LS(LS_INFORMATION),MB_OK | MB_ICONWARNING);
          }
       else
          {
            MessageBox(hwnd,S_RESVIPEMPTY,LS(LS_INFORMATION),MB_OK | MB_ICONINFORMATION);
          }
     }

  return rc;
}


__declspec(dllexport) BOOL __cdecl IsRunningUnderVistaLonghorn(void)
{
  OSVERSIONINFO i;

  ZeroMemory(&i,sizeof(i));
  i.dwOSVersionInfoSize = sizeof(i);
  if ( GetVersionEx(&i) )
     {
       if ( i.dwMajorVersion > 5 )
          return TRUE;
     }

  return FALSE;
}


__declspec(dllexport) const char* __cdecl GetSaveFileDialog(HWND parent,const char *filter,const char *name)
{
  static char out[MAX_PATH];
  OPENFILENAME p;
  
  lstrcpy(out,name);
  ZeroMemory(&p,sizeof(p));
  p.lStructSize = sizeof(p);
  p.hwndOwner = parent;
  p.lpstrFilter = filter;
  p.nFilterIndex = 1;
  p.lpstrFile = out;
  p.nMaxFile = MAX_PATH;
  p.Flags = OFN_HIDEREADONLY | OFN_LONGNAMES | OFN_OVERWRITEPROMPT | OFN_PATHMUSTEXIST;
  
  return GetSaveFileName(&p) ? out : NULL;
}


__declspec(dllexport) BOOL __cdecl IsUrlCannotBeDownloadedWithOurDM(const char *url)
{
  BOOL rc = FALSE;

  if ( ReadRegDword(HKCU,REGPATH,"use_std_downloader",0) )
     return TRUE;
  
  if ( url && url[0] )
     {
       char s[MAX_PATH];
       DWORD len;

       s[0] = 0;
       len = MAX_PATH;
       UrlGetPart(url,s,&len,URL_PART_SCHEME,0);

       if ( !lstrcmpi(s,"http") || !lstrcmpi(s,"https") || !lstrcmpi(s,"http:") || !lstrcmpi(s,"https:") )
          {
            char host[MAX_PATH];
            char sites[MAX_PATH],*p;
            int n,size;
            DWORD len;
            
            host[0] = 0;
            len = MAX_PATH;
            UrlGetPart(url,host,&len,URL_PART_HOSTNAME,0);

            ZeroMemory(sites,sizeof(sites));
            ReadRegStr(HKCU,REGPATH,"std_downloader_sites",sites,"");

            size = lstrlen(sites);
            for ( n = 0; n < size; n++ )
                if ( sites[n] == ';' || sites[n] == ',' )
                   sites[n] = 0;
            p = sites;
            while ( *p )
            {
              char s[MAX_PATH];

              lstrcpy(s,p);
              PathRemoveBlanks(s);

              if ( PathMatchSpec(host,s) )
                 {
                   rc = TRUE;
                   break;
                 }

              p += lstrlen(p)+1;
            };
          }
     }

  return rc;
}


int GetCurrLang(void)
{
  return ReadRegDword(HKCU,REGPATH,"curr_lang",0);
}


__declspec(dllexport) BOOL __cdecl CheckRPVersion(int version)
{
  char s[MAX_PATH];
  
  HWND r_w = FindWindow("_RunpadClass",NULL);
  if ( r_w )
     {
       int ver = SendMessage(r_w,WM_USER+100,0,0);

       if ( ver >= version && ver < 10000 )
          return TRUE;
     }

  wsprintf(s,"Runpad Shell Pro v%d.%02d+ required",version/100,version%100);
  MessageBox(NULL,s,"Error",MB_OK | MB_ICONERROR);

  return FALSE;
}


static void SetProcessPrivilege(const char *name)
{   
  HANDLE token;
  
  if ( OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,&token) )
     {
       TOKEN_PRIVILEGES tkp; 
       LookupPrivilegeValue(NULL,name,&tkp.Privileges[0].Luid); 
       tkp.PrivilegeCount = 1;
       tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED; 
       AdjustTokenPrivileges(token,FALSE,&tkp,0,(PTOKEN_PRIVILEGES)NULL,0);
       CloseHandle(token);
     }
}


__declspec(dllexport) void __cdecl SysReboot(BOOL force)
{
  int flags = force ? EWX_FORCE : 0;
  SetProcessPrivilege(SE_SHUTDOWN_NAME);
  ExitWindowsEx(EWX_REBOOT | flags,0x00040000 | 0x80000000 /*SHTDN_REASON_MAJOR_APPLICATION | SHTDN_REASON_FLAG_PLANNED*/);
}


BOOL IsStrEmpty(const char *s)
{
  return !s || !s[0];
}


static BOOL SearchStringInQuotedList(const char *base,const char *sub,char quote)
{
  BOOL rc = FALSE;

  if ( !IsStrEmpty(base) && !IsStrEmpty(sub) && quote != 0 )
     {
       const char *p;
       int n;
       int len = lstrlen(base);
       char *s = (char*)sys_zalloc(len+10);
       lstrcpy(s,base);

       for ( n = 0; n < len; n++ )
           {
             if ( s[n] == quote )
                s[n] = 0;
           }

       p = s;
       while ( *p )
       {
         if ( !lstrcmpi(p,sub) )
            {
              rc = TRUE;
              break;
            }

         p += lstrlen(p)+1;
       };

       sys_free(s);
     }

  return rc;
}


static BOOL EnableFFDshowForAppInternal(HKEY root,const char *key,const char *filepath)
{
  BOOL rc = FALSE;
  HKEY h = NULL;
  
  char filename[MAX_PATH] = "";
  lstrcpy(filename,PathFindFileName(filepath));

  if ( RegOpenKeyEx(root,key,0,KEY_READ|KEY_WRITE,&h) == ERROR_SUCCESS )
     {
       DWORD size = 0;
       if ( RegQueryValueEx(h,"whitelist",NULL,NULL,NULL,&size) == ERROR_SUCCESS )
          {
            char *s = (char*)sys_zalloc(size+MAX_PATH);

            if ( RegQueryValueEx(h,"whitelist",NULL,NULL,(BYTE*)s,&size) == ERROR_SUCCESS )
               {
                 if ( SearchStringInQuotedList(s,filename,';') )
                    {
                      rc = TRUE;
                    }
                 else
                    {
                      if ( !IsStrEmpty(s) && s[lstrlen(s)-1] != ';' )
                         lstrcat(s,";");
                      lstrcat(s,filename);
                      lstrcat(s,";");
                         
                      if ( RegSetValueEx(h,"whitelist",0,REG_SZ,(const BYTE*)s,lstrlen(s)+1) == ERROR_SUCCESS )
                         {
                           rc = TRUE;
                         }
                    }
               }

            sys_free(s);
          }

       RegCloseKey(h);
     }

  return rc;
}


// old version
//__declspec(dllexport) void __cdecl EnableFFDshowForOurApp(void)
//{
//  char filepath[MAX_PATH] = "";
//  GetModuleFileName(GetModuleHandle(NULL),filepath,sizeof(filepath));
//
//  if ( EnableFFDshowForAppInternal(HKEY_CURRENT_USER,"Software\\GNU\\ffdshow_audio",filepath) )
//     {
//       if ( !EnableFFDshowForAppInternal(HKEY_CURRENT_USER,"Software\\GNU\\ffdshow",filepath) )
//          EnableFFDshowForAppInternal(HKEY_CURRENT_USER,"Software\\GNU\\ffdshow_video",filepath);
//     }
//}


__declspec(dllexport) void __cdecl EnableFFDshowForOurApp(void)
{
  WriteRegDword(HKCU,"Software\\GNU\\ffdshow","isCompMgr",0);
  WriteRegDword(HKCU,"Software\\GNU\\ffdshow","isWhitelist",0);
  WriteRegDword(HKCU,"Software\\GNU\\ffdshow_audio","isWhitelist",0);
}


__declspec(dllexport) BOOL __cdecl IsWTSEnumProcBugPresent(void)
{
  BOOL rc = FALSE;
  
  if ( IsRunningUnderVistaLonghorn() )
     {
       DWORD h = 0;
       
       unsigned size = GetFileVersionInfoSize("wtsapi32.dll",&h);

       if ( size > 0 )
          {
            void *info = sys_alloc(size);
            
            if ( GetFileVersionInfo("wtsapi32.dll",h,size,info) )
               {
                 const char *i = NULL;
                 UINT i_len = 0;
                 
                 if ( VerQueryValue(info,"\\StringFileInfo\\040904b0\\ProductVersion",(void**)&i,&i_len) )
                    {
                      if ( i && i_len > 0 && i_len < 50 )
                         {
                           char s[MAX_PATH];

                           ZeroMemory(s,sizeof(s));
                           CopyMemory(s,i,i_len);

                           if ( lstrcmp(s,"6.0.6000.16386") <= 0 )
                              {
                                rc = TRUE;
                              }
                         }
                    }
               }

            sys_free(info);
          }
     }

  return rc;
}


