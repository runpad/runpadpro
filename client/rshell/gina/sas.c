
#include "include.h"



static BOOL CALLBACK DialogFunc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       int n,def;
       char s[256],*p;
       
       ZeroMemory(s,sizeof(s));
       lstrcpy(s,(const char*)lParam);

       if ( lstrlen(s) == 1 && s[0] == ' ' )
          s[0] = 0;

       for ( n = 0; n < sizeof(s); n++ )
           if ( s[n] == '#' )
              s[n] = 0;

       p = s;
       n = 0;       
       def = 0;
       while ( *p )
       {
         if ( *p == '*' )
            {
              def = n;
              p++;
            }
       
         SendDlgItemMessage(hwnd,IDC_COMBO,CB_ADDSTRING,0,(LPARAM)p);

         p += lstrlen(p) + 1;
         n++;
       }

       if ( n )
          {
            SendDlgItemMessage(hwnd,IDC_COMBO,CB_SETCURSEL,def,0);
            SetFocus(GetDlgItem(hwnd,IDC_COMBO));
          }
       else
          {
            EnableWindow(GetDlgItem(hwnd,IDOK),FALSE);
            SetFocus(GetDlgItem(hwnd,IDCANCEL));
          }
     }
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       EndDialog(hwnd,-1);
     }

  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       int pos = SendDlgItemMessage(hwnd,IDC_COMBO,CB_GETCURSEL,0,0);
       EndDialog(hwnd,pos);
     }
  
  return FALSE;
}



typedef struct {
HWND hwnd;
const char *classname;
} TFINDDESKWND;


static BOOL CALLBACK EnumWndFunc(HWND hwnd,LPARAM lParam)
{
  TFINDDESKWND *i = (TFINDDESKWND*)lParam;
  
  char s[MAX_PATH];
  s[0] = 0;
  GetClassName(hwnd,s,sizeof(s));
  if ( !lstrcmpi(s,i->classname) )
     {
       i->hwnd = hwnd;
       return FALSE;
     }

  return TRUE;
}


HWND FindWindowOnDesktop(HDESK hdesk,const char *classname)
{
  TFINDDESKWND i;

  i.hwnd = NULL;
  i.classname = classname;
  
  EnumDesktopWindows(hdesk,EnumWndFunc,(int)&i);

  return i.hwnd;
}



int OnSASAction(DWORD dwSasType)
{
  if ( dwSasType == WLX_SAS_TYPE_CTRL_ALT_DEL )
     {
       if ( gDispatchTable.WlxGetSourceDesktop )
          {
            WLX_DESKTOP *desktop = NULL;

            if ( gDispatchTable.WlxGetSourceDesktop(ghWlx,&desktop) && desktop )
               {
                 if ( desktop->Flags & WLX_DESKTOP_NAME )
                    {
                      char s_desktop[MAX_PATH];
                      HDESK hdesk;

                      s_desktop[0] = 0;
                      WideCharToMultiByte(CP_ACP,0,desktop->pszDesktopName,-1,s_desktop,MAX_PATH,NULL,NULL);

                      hdesk = OpenDesktop(s_desktop,0,FALSE,DESKTOP_ENUMERATE);
                      if ( hdesk )
                         {
                           HWND w_rshell = FindWindowOnDesktop(hdesk,"_RunpadClass");
                           HWND w_progman = FindWindowOnDesktop(hdesk,"Progman");
                           CloseDesktop(hdesk);

                           if ( !w_rshell && !w_progman )
                              return WLX_SAS_ACTION_NONE;

                           if ( w_rshell )
                              {
                                int atom = 0;
                                if ( SendMessageTimeout(w_rshell,WM_USER+135,0,0,SMTO_BLOCK|SMTO_ABORTIFHUNG,4000,(void*)&atom) )
                                   {
                                     if ( atom )
                                        {
                                          char s[256];

                                          s[0] = 0;
                                          GlobalGetAtomName(atom,s,sizeof(s));
                                          GlobalDeleteAtom(atom);

                                          if ( gDispatchTable.WlxDialogBoxParam )
                                             {
                                               DWORD old_value;
                                               int rc;

                                               if ( gDispatchTable.WlxSetOption )
                                                  gDispatchTable.WlxSetOption(ghWlx,WLX_OPTION_USE_CTRL_ALT_DEL,FALSE,&old_value);

                                               rc = gDispatchTable.WlxDialogBoxParam(ghWlx,instance,(LPWSTR)MAKEINTRESOURCE(IDD_MAIN),NULL,DialogFunc,(int)s);

                                               if ( gDispatchTable.WlxSetOption )
                                                  gDispatchTable.WlxSetOption(ghWlx,WLX_OPTION_USE_CTRL_ALT_DEL,old_value,&old_value);

                                               if ( rc >= 0 && rc < 100 )
                                                  PostMessage(w_rshell,WM_USER+136,rc,0);

                                               return WLX_SAS_ACTION_NONE;
                                             }
                                        }
                                   }
                                else
                                   return WLX_SAS_ACTION_NONE;
                              }
                         }
                    }
               }
          }
     }

  return -1;
}

