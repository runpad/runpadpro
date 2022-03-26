

static struct {
BOOL used;
char list[MAX_PATH];
int count;
} g_licman = {FALSE,"",0};


void OnLicManAck(const CNetCmd &cmd,unsigned src_guid)
{
  if ( g_licman.used )
     {
       const char *s_list = cmd.GetParmAsString(NETPARM_S_PROCESSES);

       if ( s_list && s_list[0] && !lstrcmpi(s_list,g_licman.list) )
          {
            g_licman.count += cmd.GetParmAsInt(NETPARM_I_COPIES);
          }
     }
}


void OnLicManReq(const CNetCmd &cmd,unsigned src_guid)
{
  const char *list = cmd.GetParmAsString(NETPARM_S_PROCESSES);
  
  if ( list && list[0] )
     {
       char s[MAX_PATH],*p;
       int n,len;

       ZeroMemory(s,sizeof(s));
       lstrcpyn(s,list,sizeof(s)-2);

       len = lstrlen(s);
       for ( n = 0; n < len; n++ )
           if ( s[n] == ';' )
              s[n] = 0;

       int count = 0;

       p = s;
       while ( *p )
       {
         if ( FindProcess(p) != -1 )
            {
              count++;
              break;
            }

         p += lstrlen(p) + 1;
       };

       if ( count > 0 ) //optimization
          {
            CNetCmd cmd(NETCMD_LICMAN_ACK);
            cmd.AddStringParm(NETPARM_S_PROCESSES,list);
            cmd.AddIntParm(NETPARM_I_COPIES,count);
            NetSend(cmd,src_guid);
          }
     }
}


typedef struct {
const char *name;
int max_copies;
const char *list;
} LICMAN;


static BOOL CALLBACK LicManDlgProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       LICMAN *i = (LICMAN*)lParam;

       SetWindowText(hwnd,LS(3016));
       SetDlgItemText(hwnd,IDC_LABEL1,LS(3017));
       SetDlgItemText(hwnd,IDC_LABEL2,LS(3018));
       
       char s[MAX_PATH];
       wsprintf(s,LS(3019),i->name,i->max_copies);
       SetDlgItemText(hwnd,IDC_LABEL,s);

       lstrcpyn(g_licman.list,i->list,sizeof(g_licman.list));
       g_licman.count = 0;
       g_licman.used = TRUE;
       
       CNetCmd cmd(NETCMD_LICMAN_REQ);
       cmd.AddStringParm(NETPARM_S_PROCESSES,i->list);
       NetSend(cmd,NETGUID_ALL_USERS_WITHOUTME);

       SetFocus(GetDlgItem(hwnd,IDC_LABEL));
       SetTimer(hwnd,1,7000,NULL);
       SetTimer(hwnd,2,200,NULL);
     }

  if ( message == WM_TIMER && wParam == 2 )
     {
       KillTimer(hwnd,2);
       SetCursor(LoadCursor(NULL,IDC_WAIT));
       SetCapture(hwnd);
     }

  if ( message == WM_TIMER && wParam == 1 )
     {
       g_licman.used = FALSE;
       SetCursor(LoadCursor(NULL,IDC_ARROW));
       ReleaseCapture();
       EndDialog(hwnd,g_licman.count+1);
     }
     
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       g_licman.used = FALSE;
       SetCursor(LoadCursor(NULL,IDC_ARROW));
       ReleaseCapture();
       EndDialog(hwnd,0);
     }

  return FALSE;
}


BOOL ExecuteLicMan(const char *path)
{
  static BOOL in_progress = FALSE;
  BOOL rc = TRUE;

  if ( !in_progress )
     {
       const char *file;
       int n;
       int max_copies;
       char name[MAX_PATH];
       char list[MAX_PATH];

       in_progress = TRUE;
       
       file = PathFindFileName(path);
       max_copies = 0;
       name[0] = 0;
       list[0] = 0;

       TCFGLIST2& lm = lic_manager;

       for ( n = 0; n < lm.size(); n++ )
           {
             if ( lm[n].IsActive() )
                {
                  if ( IsExtensionInList(file,lm[n].GetParm2()) )
                     {
                       char s[MAX_PATH],*p;
                       int m;

                       ZeroMemory(s,sizeof(s));
                       lstrcpy(s,lm[n].GetParm1());

                       for ( m = lstrlen(s)-1; m >= 0; m-- )
                           if ( s[m] == '(' || s[m] == ')' )
                              s[m] = 0;

                       lstrcpy(name,s);
                       PathRemoveBlanks(name);

                       p = s + lstrlen(s) + 1;
                       max_copies = StrToInt(p);
                       if ( max_copies < 1 )
                          max_copies = 1;

                       lstrcpy(list,lm[n].GetParm2());

                       break;
                     }
                }
           }

       if ( max_copies )
          {
            LICMAN i;
            int count;

            i.name = name;
            i.max_copies = max_copies;
            i.list = list;
            
            count = DialogBoxParam(our_instance,MAKEINTRESOURCE(IDD_LICMAN),GetMainWnd(),LicManDlgProc,(int)&i);
            
            if ( count == 0 )
               {
                 rc = FALSE;
               }
            else
            if ( count > max_copies )
               {
                 rc = FALSE;
                 ErrBox(LS(3020));
               }
          }  

       in_progress = FALSE;
     }

  return rc;
}
