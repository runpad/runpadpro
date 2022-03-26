

typedef struct {
const BOOL *p_enabled;
void (*func)(void);
int s_id;
} CADACTION;


static CADACTION cad_actions[] =
{
  {&cad_taskman,    CAD_TaskManager,    3039},
  {&cad_killall,    CAD_KillAllTasks,   3040},
  {&cad_gcinfo,     CAD_GCInfo,         3041},
  {&cad_reboot,     CAD_Reboot,         3042},
  {&cad_shutdown,   CAD_Shutdown,       3043},
  {&cad_monitoroff, CAD_MonitorOffTime, 3044},
  {&cad_logoff,     CAD_LogOff,         3045},
};

static const int num_cad_actions = sizeof(cad_actions)/sizeof(cad_actions[0]);
static int def_cad_action = -1;
static HWND wnd_cad = NULL;



ATOM OnGetCADMenu() //todo: avoid atoms!
{
  if ( !use_cad_catcher )
     return 0;
  
  char s[MAX_PATH*(sizeof(cad_actions)/sizeof(cad_actions[0]))],*p;
  int n,count;

  ZeroMemory(s,sizeof(s));
  p = s;
  count = 0;

  for ( n = 0; n < num_cad_actions; n++ )
      {
        if ( *(cad_actions[n].p_enabled) )
           {
             if ( count )
                *p++ = '#';
             
             if ( count == def_cad_action )
                *p++ = '*';
             
             lstrcpy(p,LS(cad_actions[n].s_id));
             p += lstrlen(p);

             count++;
           }
      }

  if ( !s[0] || lstrlen(s) > 255 )
     lstrcpy(s," ");

  return GlobalAddAtom(s);
}


void OnCADMenuAction(int idx)
{
  int n,count;

  count = 0;

  for ( n = 0; n < num_cad_actions; n++ )
      {
        if ( *(cad_actions[n].p_enabled) )
           {
             if ( idx == count )
                {
                  def_cad_action = idx;
                  cad_actions[n].func();
                  break;
                }

             count++;
           }
      }
}



static BOOL CALLBACK CADDialogFunc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       wnd_cad = hwnd;
       
       int count = 0;
       for ( int n = 0; n < num_cad_actions; n++ )
           {
             if ( *(cad_actions[n].p_enabled) )
                {
                  SendDlgItemMessage(hwnd,IDC_COMBO1,CB_ADDSTRING,0,(LPARAM)LS(cad_actions[n].s_id));
                  count++;
                }
           }

       if ( count > 0 )
          {
            SendDlgItemMessage(hwnd,IDC_COMBO1,CB_SETCURSEL,def_cad_action>=0?def_cad_action:0,0);
            SetFocus(GetDlgItem(hwnd,IDC_COMBO1));
          }
       else
          {
            EnableWindow(GetDlgItem(hwnd,IDOK),FALSE);
            SetFocus(GetDlgItem(hwnd,IDCANCEL));
          }

       SetTimer(hwnd,1,1000*90,NULL);
       SetForegroundWindow(hwnd);
     }
  
  if ( message == WM_CLOSE || 
       (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) ||
       message == WM_TIMER )
     {
       wnd_cad = NULL;
       EndDialog(hwnd,-1);
     }

  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       int pos = SendDlgItemMessage(hwnd,IDC_COMBO1,CB_GETCURSEL,0,0);
       wnd_cad = NULL;
       EndDialog(hwnd,pos);
     }
  
  return FALSE;
}


void ShowCADDialog()
{
  if ( !wnd_cad )
     {
       int rc;

       {
         CForegroundWindowGuard oFGuard;

         rc = DialogBox(our_instance,MAKEINTRESOURCE(IDD_CAD),GetMainWnd(),CADDialogFunc);
       }

       if ( rc >= 0 )
          {
            OnCADMenuAction(rc);
          }
     }
  else
     {
       SetForegroundWindow(wnd_cad);
     }
}
