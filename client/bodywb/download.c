
#include <windows.h>
#include <wininet.h>
#include <objbase.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <commctrl.h>
#include <stdio.h>
#include <string.h>
#include "resource.h"
#include "../rp_shared/rp_shared.h"
#include "tools.h"
#include "utf8.h"
#include "main.h"
#include "config.h"



typedef struct {
char *url;
char *referer;
HWND g_hwnd;
volatile int thread_stop;
int old_perc;
float old_bps;
char old_s1[64];
char old_s2[64];
int message_begin; // in async usage only
int message_end; // in async usage only
DWORD parent_thread; // in async usage only
} GINFO;


void UpdateField(GINFO *info,int id,char *value)
{
  SetDlgItemText(info->g_hwnd,id,value);
}



void UpdateProgress(GINFO *info,int perc)
{
  char s[128];
  
  if ( info->old_perc != perc )
     {
       info->old_perc = perc;
       SendMessage( GetDlgItem(info->g_hwnd,IDC_PROGRESS), PBM_SETPOS, perc, 0);
       if ( perc )
          {
            wsprintf(s,"%d%% %s",perc,LS(1551));
            SetWindowText(info->g_hwnd,s);
          }
     }
}


void Err(GINFO *info,const char *s)
{
  if ( info->g_hwnd )
     SendMessage( GetDlgItem(info->g_hwnd,IDC_ANIMATE), ACM_STOP, 0, 0 );
  MessageBox(info->g_hwnd,s,LS(LS_ERR),MB_ICONERROR | MB_OK);
}


void Msg(GINFO *info,const char *s)
{
  if ( info->g_hwnd )
     SendMessage( GetDlgItem(info->g_hwnd,IDC_ANIMATE), ACM_STOP, 0, 0 );
  MessageBox(info->g_hwnd,s,LS(LS_INFO),MB_ICONINFORMATION | MB_OK);
}



void PrintSize(unsigned size,char *s)
{
  if ( size < 1000 )
     sprintf(s,"%lu bytes",size);
  else
  if ( size < 1000*1024 )
     sprintf(s,"%0.0f KB",(float)size/1024.0);
  else
  {
     float mb = (float)size/(1024.0*1024.0);
     if ( mb < 10 )
        sprintf(s,"%0.2f MB",mb);
     else
     if ( mb < 100 )
        sprintf(s,"%0.1f MB",mb);
     else
        sprintf(s,"%0.2f GB",mb/1000.0);
  }
}



BOOL CALLBACK QuestionDialogProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       SetWindowText(hwnd,LS(LS_QUESTION));
       SetDlgItemText(hwnd,IDC_LABEL1,LS(1566));
       SetDlgItemText(hwnd,IDC_OPEN,LS(1567));
       SetDlgItemText(hwnd,IDC_SAVE,LS(1568));
       SetDlgItemText(hwnd,IDCANCEL,LS(LS_CANCEL));
       SetDlgItemText(hwnd,IDC_FILE,(char*)lParam);
       SetFocus(GetDlgItem(hwnd,IDCANCEL));
     }

  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     EndDialog(hwnd,0);

  if ( message == WM_COMMAND && LOWORD(wParam) == IDC_OPEN )
     EndDialog(hwnd,2);

  if ( message == WM_COMMAND && LOWORD(wParam) == IDC_SAVE )
     EndDialog(hwnd,1);

  return FALSE;
}


int FileQuestion(HWND parent,char *file)
{
  return DialogBoxParam(instance,MAKEINTRESOURCE(IDD_DIALOGQ),parent,QuestionDialogProc,(int)file);
}



int IsExtensionAllowed(char *path,char *allowed_ext)
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


static unsigned CalculateHashFunction( unsigned char *k, unsigned length, unsigned initval )
{
	unsigned a,b,c,len;

	len = length;
	a = b = 0x9e3779b9;
	c = initval;

	while( len >= 12 )
	{
		a += (k[0] + ((unsigned)k[1]<<8) + ((unsigned)k[2]<<16)  + ((unsigned)k[3]<<24));
		b += (k[4] + ((unsigned)k[5]<<8) + ((unsigned)k[6]<<16)  + ((unsigned)k[7]<<24));
		c += (k[8] + ((unsigned)k[9]<<8) + ((unsigned)k[10]<<16) + ((unsigned)k[11]<<24));

		a -= b; a -= c; a ^= (c>>13);
		b -= c; b -= a; b ^= (a<<8);
		c -= a; c -= b; c ^= (b>>13);
		a -= b; a -= c; a ^= (c>>12);
		b -= c; b -= a; b ^= (a<<16);
		c -= a; c -= b; c ^= (b>>5);
		a -= b; a -= c; a ^= (c>>3);
		b -= c; b -= a; b ^= (a<<10);
		c -= a; c -= b; c ^= (b>>15);

		k += 12; 
		len -= 12;
	}

	c += length;

	switch( len )
	{
	case 11: c += ((unsigned)k[10]<<24);
	case 10: c += ((unsigned)k[9]<<16);
	case 9 : c += ((unsigned)k[8]<<8);
	case 8 : b += ((unsigned)k[7]<<24);
	case 7 : b += ((unsigned)k[6]<<16);
	case 6 : b += ((unsigned)k[5]<<8);
	case 5 : b += k[4];
	case 4 : a += ((unsigned)k[3]<<24);
	case 3 : a += ((unsigned)k[2]<<16);
	case 2 : a += ((unsigned)k[1]<<8);
	case 1 : a += k[0];
	}

	a -= b; a -= c; a ^= (c>>13);
	b -= c; b -= a; b ^= (a<<8);
	c -= a; c -= b; c ^= (b>>13);
	a -= b; a -= c; a ^= (c>>12);
	b -= c; b -= a; b ^= (a<<16);
	c -= a; c -= b; c ^= (b>>5);
	a -= b; a -= c; a ^= (c>>3);
	b -= c; b -= a; b ^= (a<<10);
	c -= a; c -= b; c ^= (b>>15);

	return c;
}


int FileExist(char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


void Check4InvalidChars(char *file)
{
  int n;

  for ( n = 0; n < lstrlen(file); n++ )
      if ( StrChr("\"*/:;<=>?\\^`{|}~#@",file[n]) )
         file[n] = '_';
      else
      if ( file[n] == '+' )
         file[n] = ' ';

  PathRemoveBlanks(file);
}


static BOOL CALLBACK CalcAll(HWND hwnd,LPARAM lParam)
{
  if ( GetProp(hwnd,"_RunpadDownloaderPropInfo") )
     (*(int *)lParam)++;

  return TRUE;
}


BOOL CheckWindowsCount(void)
{
  BOOL rc = TRUE;
  unsigned max = g_config.max_download_windows;

  if ( max != 0 )
     {
       int count  = 0;

       EnumWindows(CalcAll,(unsigned)&count);

       if ( count > max )
          rc = FALSE;
     }

  return rc;
}


void NotifyAboutFlashDriveChange(char *s)
{
  if ( s && s[0] )
     {
       if ( lstrlen(s) > 2 && s[1] == ':' && s[0] != 'a' && s[0] != 'b' && s[0] != 'A' && s[0] != 'B' )
          {
            char drive[8];

            drive[0] = s[0];
            drive[1] = ':';
            drive[2] = '\\';
            drive[3] = 0;

            if ( GetDriveType(drive) == DRIVE_REMOVABLE || IsDriveTrueRemovableS(drive) )
               {
                 HWND w = FindWindow("_RunpadClass",NULL);
                 if ( w )
                    {
                      int n = (int)CharUpper((LPSTR)((unsigned char*)s)[0]) - 'A';
                      PostMessage(w,g_config.msg_flash_notify,n,0);
                    }
               }
          }
     }
}


#define CACHE 8192


DWORD ThreadProcInternal(GINFO *info)
{
  char cache[CACHE];
  char s[INTERNET_MAX_URL_LENGTH];
  char temp_path[MAX_PATH];
  char dest_path[MAX_PATH];
  unsigned char target_file[MAX_PATH];
  DWORD len,seek,nn;
  unsigned char file[MAX_PATH];
  int use_ftp,use_http,n,rc,drives;
  HINTERNET hinet=NULL,hurl=NULL;
  DWORD total_bytes,read_bytes,read_count,time,last_update_time1,last_update_time2;
  HANDLE hfile;
  //MSGBOXPARAMS mb;
  char target_ext[64];
  int autorun = 0;
  unsigned hash = 0;
  BOOL can_seek = FALSE;
  char *headers;
  int dont_show_download_speed;
  int download_delay,kbps_limit;
  const char *from_lang_prefix;
  char dest_name[MAX_PATH];

  info->old_perc = -1;
  info->old_bps = -1000;
  info->old_s1[0] = 0;
  info->old_s2[0] = 0;

  s[0] = 0;
  len = sizeof(s);
  UrlGetPart(info->url,s,&len,URL_PART_SCHEME,0);

  use_ftp = !lstrcmpi(s,"ftp") || !lstrcmpi(s,"ftp:");
  use_http = !lstrcmpi(s,"http") || !lstrcmpi(s,"http:") || !lstrcmpi(s,"https") || !lstrcmpi(s,"https:");

//  if ( !use_ftp && !use_http )
//     {
//       Err(info,"Unsupported protocol");
//       return 1;
//     }

  s[0] = 0;
  len = sizeof(s);
  UrlGetPart(info->url,s,&len,URL_PART_HOSTNAME,0);
  UpdateField(info,IDC_SERVER,s);

  if ( !CheckWindowsCount() )
     {
       Err(info,LS(1552));
       return 1;
     }

  hinet = InternetOpen("Runpad Shell Downloader",INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0);
  if ( !hinet )
     {
       Err(info,"Cannot open internet handle");
       return 1;
     }

  SendMessage( GetDlgItem(info->g_hwnd,IDC_ANIMATE), ACM_PLAY, -1, MAKELONG(0,-1) );
     
  // process referer
  headers = NULL;
  if ( info->referer && info->referer[0] )
     {
       if ( lstrcmpi(info->referer,"about:blank") )
          {
            if ( use_http )  // really?
               {
                 if ( lstrlen(info->referer) < sizeof(s) - 16 )
                    {
                      wsprintf(s,"Referer: %s\r\n",info->referer);
                      headers = s;
                    }
               }
          }
     }
  
  hurl = InternetOpenUrl(hinet,info->url,headers,headers?-1:0,INTERNET_FLAG_NO_UI /*| INTERNET_FLAG_RELOAD*/,0);
  if ( !hurl )
     {
       InternetCloseHandle(hinet);
       wsprintf(s,LS(1553),info->url);
       Err(info,s);
       return 1;
     }

  hash = CalculateHashFunction(info->url,lstrlen(info->url),hash);

  target_file[0] = 0;
  target_ext[0] = 0;
  total_bytes = -1;
  if ( use_http )
     {
       DWORD rc = sizeof(total_bytes);
       if ( !HttpQueryInfo(hurl,HTTP_QUERY_CONTENT_LENGTH | HTTP_QUERY_FLAG_NUMBER,&total_bytes,&rc,NULL) )
          total_bytes = -1;

       s[0] = 0;
       rc = sizeof(s);
       if ( HttpQueryInfo(hurl,HTTP_QUERY_LAST_MODIFIED,s,&rc,NULL) )
          {
            if ( s[0] )
               {
                 hash = CalculateHashFunction(s,lstrlen(s),hash);
                 can_seek = TRUE;
               }
          }

       s[0] = 0;
       rc = sizeof(s);
       if ( HttpQueryInfo(hurl,HTTP_QUERY_CONTENT_TYPE,s,&rc,NULL) )
          {
            if ( s[0] && lstrcmpi(s,"text/plain") )
               {
                 char t[300];
                 lstrcpy(t,s);
                 wsprintf(s,"MIME\\Database\\Content Type\\%s",t);
                 ReadRegStr(HKEY_CLASSES_ROOT,s,"Extension",target_ext,"");
               }
          }

       s[0] = 0;
       rc = sizeof(s);
       if ( HttpQueryInfo(hurl,HTTP_QUERY_CONTENT_DISPOSITION,s,&rc,NULL) )
          {
            if ( s[0] )
               {
                 char *p = NULL;
                 p = StrStr(s,"filename=");
                 if ( p )
                    {
                      p += lstrlen("filename=");
                    }
                 else
                    {
                      p = StrStr(s,"filename*=");
                      if ( p )
                         {
                           p += lstrlen("filename*=");
                         }
                    }

                 if ( p )
                    {
                      char temp_in[INTERNET_MAX_URL_LENGTH];
                      char temp_out[INTERNET_MAX_URL_LENGTH];

                      char *dest = temp_in;
                      ZeroMemory(temp_in,sizeof(temp_in));

                      if ( *p == '\'' )
                         {
                           p++;
                           while ( *p && *p != '\'' )
                                 *dest++ = *p++;
                         }
                      else
                      if ( *p == '\"' )
                         {
                           p++;
                           while ( *p && *p != '\"' )
                                 *dest++ = *p++;
                         }
                      else
                         {
                           while ( *p && *p != ';' )
                                 *dest++ = *p++;
                         }
                    
                      if ( UTF8Decode64(temp_in,temp_out,sizeof(temp_out)) )
                         lstrcpyn(target_file,temp_out,sizeof(target_file));
                      else
                      if ( UTF8DecodeStupid(temp_in,temp_out,sizeof(temp_out)) )
                         lstrcpyn(target_file,temp_out,sizeof(target_file));
                      else
                      if ( UTF8DecodeRaw(temp_in,temp_out,sizeof(temp_out)) )
                         lstrcpyn(target_file,temp_out,sizeof(target_file));
                      else
                         lstrcpyn(target_file,temp_in,sizeof(target_file));
                    }
               }
          }
     }
  if ( total_bytes == 0 )
     total_bytes = -1;

  if ( total_bytes != -1 )
     {
       unsigned max = g_config.max_download_size;

       if ( max != 0 )
          {
            if ( total_bytes > max*1024*1024 )
               {
                 InternetCloseHandle(hurl);
                 InternetCloseHandle(hinet);
                 wsprintf(s,LS(1554),max);
                 Err(info,s);
                 return 1;
               }
          }
     }

  if ( !target_file[0] )
     {
       char t[INTERNET_MAX_URL_LENGTH];
       char tt[MAX_PATH];
       
       lstrcpy(t,PathFindFileName(info->url));
       UrlUnescapeInPlace(t,0);

       if ( t[0] == '?' )
          {
            char temp[MAX_PATH];
            int n;

            temp[0] = 0;
            for ( n = lstrlen(t)-1; n >= 0; n-- )
                if ( t[n] == '=' )
                   {
                     lstrcpyn(temp,&t[n+1],sizeof(temp)-1);
                     break;
                   }

            lstrcpy(t,temp);
          }
       else
          {
            int n;
            for ( n = 0; n < lstrlen(t); n++ )
                if ( t[n] == '?' || t[n] == '#' )
                   {
                     t[n] = 0;
                     break;
                   }
          }

       if ( lstrlen(t) > MAX_PATH-1 )
          t[MAX_PATH-1] = 0;

       if ( UTF8DecodeRaw(t,tt,sizeof(tt)) )
          lstrcpy(t,tt);

       Check4InvalidChars(t);

       if ( target_ext[0] )
          {
            *PathFindExtension(t) = 0;
            lstrcat(t,target_ext);
          }

       lstrcpyn(file,t,sizeof(file)-1);
     }
  else
     lstrcpy(file,target_file);

  UrlUnescapeInPlace(file,0);
  Check4InvalidChars(file);

  if ( !file[0] )
     lstrcpy(file,"unknown");
   
  UpdateField(info,IDC_FILE,file);

  hash = CalculateHashFunction(file,lstrlen(file),hash);
  hash = CalculateHashFunction((unsigned char*)&total_bytes,sizeof(total_bytes),hash);

  // check if file type is allowed
  if ( g_config.use_allowed_download_types )
     {
       char allowed_ext[MAX_PATH];

       lstrcpy(allowed_ext,g_config.allowed_download_types);

       if ( !IsExtensionAllowed(file,allowed_ext) )
          {
            InternetCloseHandle(hurl);
            InternetCloseHandle(hinet);
            Err(info,LS(1555));
            return 1;
          }
     }

  {
    char allowed_ext[MAX_PATH];
    lstrcpy(allowed_ext,g_config.download_autorun);
    autorun = IsExtensionAllowed(file,allowed_ext);
  }
  
  dest_path[0] = 0;
  dest_name[0] = 0;

  if ( !autorun )
     {
       if ( g_config.allow_run_downloaded )
          {
            int rc = FileQuestion(info->g_hwnd,file);

            if ( rc == 0 )
               {
                 InternetCloseHandle(hurl);
                 InternetCloseHandle(hinet);
                 return 1;
               }

            autorun = (rc == 2);
          }
     }

  if ( !autorun )
     {
       do {
         char s[MAX_PATH];
         wsprintf(s,LS(1556),file);

         if ( RPOpenSaveDialog(info->g_hwnd,s,LS(LS_QUESTION),dest_path,dest_name) == RPOPENSAVE_CANCEL )
            {
              InternetCloseHandle(hurl);
              InternetCloseHandle(hinet);
              return 1;
            }

         if ( dest_path[0] )
            break;

       } while ( 1 );
     }

  if ( dest_path[0] )
     PathAddBackslash(dest_path);
  lstrcat(dest_path,file);

  if ( dest_name[0] )
     PathAddBackslash(dest_name);
  lstrcat(dest_name,file);
  UpdateField(info,IDC_DEST,dest_name);

  temp_path[0] = 0;
  GetTempPath(sizeof(temp_path),temp_path);
  PathAddBackslash(temp_path);
  CreateDirectory(temp_path,NULL);

  wsprintf(s,"%s__%08X_%s",temp_path,hash,file);
  lstrcpy(temp_path,s);

  hfile = NULL;
  seek = 0;

  if ( FileExist(temp_path) )
     {
       HANDLE h = CreateFile(temp_path,GENERIC_WRITE,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
       if ( h == INVALID_HANDLE_VALUE )
          {
            InternetCloseHandle(hurl);
            InternetCloseHandle(hinet);
            Err(info,LS(1557));
            return 1;
          }

       if ( can_seek && MessageBox(info->g_hwnd,
                                   LS(1558),
                                   LS(LS_QUESTION),
                                   MB_YESNO | MB_ICONQUESTION) == IDYES )
          {
            seek = GetFileSize(h,NULL);
            if ( seek != 0 )
               {
                 if ( InternetSetFilePointer(hurl,seek,NULL,FILE_BEGIN,0) != seek )
                    {
                      InternetSetFilePointer(hurl,0,NULL,FILE_BEGIN,0);
                      seek = 0;
                      CloseHandle(h);
                      DeleteFile(temp_path);
                    }
                 else
                    {
                      hfile = h;
                      SetFilePointer(hfile,0,NULL,FILE_END);
                    }
               }
            else
               hfile = h;
          }
       else
          {
            CloseHandle(h);
            DeleteFile(temp_path);
          }
     }
  
  if ( !hfile )
     hfile = CreateFile(temp_path,GENERIC_WRITE,FILE_SHARE_READ,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);

  if ( hfile == INVALID_HANDLE_VALUE )
     {
       InternetCloseHandle(hurl);
       InternetCloseHandle(hinet);
       wsprintf(s,LS(1559),temp_path);
       Err(info,s);
       return 1;
     }

  dont_show_download_speed = g_config.dont_show_download_speed;

  kbps_limit = g_config.download_speed_limit;
  if ( kbps_limit )
     {
       if ( kbps_limit < 0 )
          kbps_limit = -kbps_limit;
       
       kbps_limit /= 2;  //от балды коррекция
       if ( kbps_limit == 0 )
          kbps_limit++;
     }
  
  from_lang_prefix = LS(1560);
  download_delay = -1;
  nn = seek;
  read_bytes = 0;
  read_count = 0;
  time = GetTickCount();
  last_update_time1 = time;
  last_update_time2 = time;
  do {
   DWORD bytes,written_bytes,rc;

   if ( info->thread_stop )
      break;
   
   rc = InternetReadFile(hurl,cache,CACHE,&bytes);
   if ( !rc )
      {
        InternetCloseHandle(hurl);
        InternetCloseHandle(hinet);
        CloseHandle(hfile);
        //DeleteFile(temp_path);
        Err(info,LS(1561));
        return 1;
      }

   if ( !bytes || GetTickCount() - last_update_time1 > 100 )
      {
        char s1[32],s2[32];

        PrintSize(nn,s1);
        
        if ( total_bytes != -1 )
           {
             PrintSize(total_bytes,s2);
             wsprintf(s,"%s %s %s",s1,from_lang_prefix,s2);
           }
        else
           wsprintf(s,"%s",s1);

        if ( lstrcmp(info->old_s1,s) )
           {
             lstrcpy(info->old_s1,s);
             UpdateField(info,IDC_BYTES,s);
           }

        last_update_time1 = GetTickCount();
      }

   if ( total_bytes != -1 )
      UpdateProgress( info, (unsigned __int64)nn * 100 / total_bytes );

   if ( !bytes )
      break;

   if ( read_bytes > 1024 && GetTickCount() - last_update_time2 > 300 )
      {
        float delta = (float)(GetTickCount() - time) / 1000.0;
        float bps = (float)read_bytes / delta;
        float kbps;
        if ( info->old_bps < 0 )
           info->old_bps = bps;

        info->old_bps = info->old_bps * 0.3 + bps * 0.7;
        kbps = info->old_bps/1024.0;

        if ( kbps < 100 )
           sprintf(s,"%0.1f KB/sec",kbps);
        else
           sprintf(s,"%0.0f KB/sec",kbps);

        if ( lstrcmp(info->old_s2,s) )
           {
             lstrcpy(info->old_s2,s);
             if ( !dont_show_download_speed && kbps_limit == 0 )
                UpdateField(info,IDC_RATE,s);
           }

        if ( kbps_limit != 0 )
           {
             if ( kbps > kbps_limit )
                {
                  float new_delta = (float)read_bytes / (kbps_limit * 1024);

                  if ( new_delta > delta )
                     {
                       float delay_ms = (float)(new_delta - delta) * 1000 / read_count;

                       download_delay = delay_ms;
                     }
                }
           }
        
        last_update_time2 = GetTickCount();
      }

   rc = WriteFile(hfile,cache,bytes,&written_bytes,NULL);
   if ( !rc || bytes != written_bytes )
      {
        InternetCloseHandle(hurl);
        InternetCloseHandle(hinet);
        CloseHandle(hfile);
        //DeleteFile(temp_path);
        wsprintf(s,LS(1562),temp_path);
        Err(info,s);
        return 1;
      }

   if ( download_delay >= 0 )
      Sleep(download_delay);

   nn += bytes;
   read_bytes += bytes;
   read_count++;
  } while (1);

  CloseHandle(hfile);
  InternetCloseHandle(hurl);
  InternetCloseHandle(hinet);

  if ( info->thread_stop )
     {
       DeleteFile(temp_path);
       return 1;
     }
  
  SendMessage( GetDlgItem(info->g_hwnd,IDC_ANIMATE), ACM_STOP, 0, 0 );
  EnableWindow(GetDlgItem(info->g_hwnd,IDCANCEL),FALSE);

  if ( !autorun )
     {
       if ( FileExist(dest_path) )
          {
            char s[MAX_PATH];
            wsprintf(s,LS(1563),dest_path);
            
            if ( MessageBox(info->g_hwnd,s,LS(LS_QUESTION),MB_YESNO | MB_ICONQUESTION) == IDNO )
               {
                 DeleteFile(temp_path);
                 return 1;
               }
          }
      
      retry:;
       if ( !CopyFile(temp_path,dest_path,FALSE) )
          {
            wsprintf(s,LS(1564),dest_path);
            if ( MessageBox(info->g_hwnd,s,LS(LS_ERR),MB_RETRYCANCEL | MB_ICONERROR) == IDCANCEL )
               {
                 DeleteFile(temp_path);
                 return 1;
               }
            else
               goto retry;
          }

       DeleteFile(temp_path);

       NotifyAboutFlashDriveChange(dest_path);

       wsprintf(s,LS(1565),file);
       Msg(info,s);
     }
  else
     {
       // we do not use ShellExecute here, because CreateProcess can be blocked

       HWND w = FindWindow("_RunpadClass",NULL);

       if ( w )
          {
            ATOM atom = GlobalAddAtom(temp_path);
       
            if ( atom )
               PostMessage(w,g_config.msg_runprogram,(int)atom,0);
          }
     }

  return 1;
}


int g_endthreadmessage;



DWORD WINAPI ThreadProc(void *_info)
{
  GINFO *info = _info;
  DWORD rc = ThreadProcInternal(info);
  PostMessage(info->g_hwnd,g_endthreadmessage,0,0);
  return rc;
}



void StartThread(GINFO *info)
{
  DWORD id;
  HANDLE h;

  info->thread_stop = 0;
  h = CreateThread(NULL,0,ThreadProc,info,0,&id);
  SetThreadPriority(h,THREAD_PRIORITY_IDLE);
  CloseHandle(h);
}



void StopThread(GINFO *info)
{
  info->thread_stop = 1;
}



BOOL CALLBACK MainDialog(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  const char *szPropName = "_RunpadDownloaderPropInfo";
  
  if ( message == WM_INITDIALOG )
     {
       GINFO *info = (GINFO*)lParam;
       
       SetProp(hwnd,szPropName,(HANDLE)info);
       info->g_hwnd = hwnd;
       SetClassLong(hwnd,GCL_HICON,(int)LoadIcon(instance,MAKEINTRESOURCE(IDI_ICON)));

       SetWindowText(hwnd,LS(1569));
       SetDlgItemText(hwnd,IDC_LABEL1,LS(1570));
       SetDlgItemText(hwnd,IDC_LABEL2,LS(1571));
       SetDlgItemText(hwnd,IDC_LABEL3,LS(1572));
       SetDlgItemText(hwnd,IDC_LABEL4,LS(1573));
       SetDlgItemText(hwnd,IDC_LABEL5,LS(1574));
       SetDlgItemText(hwnd,IDCANCEL,LS(LS_CANCEL));
       
       SendMessage( GetDlgItem(hwnd,IDC_ANIMATE), ACM_OPEN, 0, IDA_MOVIE );
       SendMessage( GetDlgItem(hwnd,IDC_PROGRESS), PBM_SETRANGE, 0, MAKELPARAM (0,100));
       SendMessage( GetDlgItem(hwnd,IDC_PROGRESS), PBM_SETPOS, 0, 0);
       SetFocus(GetDlgItem(hwnd,IDCANCEL));
       StartThread(info);
       return FALSE;
     }

  if ( message == g_endthreadmessage )
     {
       SendMessage( GetDlgItem(hwnd,IDC_ANIMATE), ACM_OPEN, 0, 0 );
       RemoveProp(hwnd,szPropName);
       EndDialog(hwnd,0);
       return TRUE;
     }
     
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       GINFO *info;

       EnableWindow(GetDlgItem(hwnd,IDCANCEL),FALSE);
       
       info = GetProp(hwnd,szPropName);
       if ( info )
          StopThread(info);

       return TRUE;
     }

  return FALSE;
}


#define myalloc(x) (HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, x))
#define myfree(x)  (HeapFree(GetProcessHeap(), 0, x))


DWORD WINAPI ThreadProcAsync(void *_info)
{
  GINFO *info = (GINFO*)_info;

  PostThreadMessage(info->parent_thread,info->message_begin,0,0);

  InitCommonControls();
  DialogBoxParam(instance,MAKEINTRESOURCE(IDD_DIALOG),NULL,MainDialog,(int)info);

  PostThreadMessage(info->parent_thread,info->message_end,0,0);

  myfree(info->url);
  myfree(info->referer);
  myfree(info);

  return 1;
}


void __cdecl DownloadFileAsync(const char *s,const char *referer,int msg_begin,int msg_end)
{
  GINFO *info;
  DWORD id;
  HANDLE h;
  
  if ( !s || !*s )
     return;

  g_endthreadmessage = RegisterWindowMessage("_RunpadDownloaderEndThreadMsg");
  
  info = myalloc(sizeof(GINFO));
  ZeroMemory(info,sizeof(GINFO));
  info->url = myalloc(lstrlen(s)+1);
  lstrcpy(info->url,s);

  if ( !referer )
     referer = "";
  info->referer = myalloc(lstrlen(referer)+1);
  lstrcpy(info->referer,referer);

  info->parent_thread = GetCurrentThreadId();
  info->message_begin = msg_begin;
  info->message_end = msg_end;

  h = CreateThread(NULL,0,ThreadProcAsync,info,0,&id);

  if ( h )
     {
       CloseHandle(h);
     }
  else
     {
       myfree(info->url);
       myfree(info->referer);
       myfree(info);
     }
}

