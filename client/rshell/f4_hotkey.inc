

static void EV_Taskmgr(void)
{
//  ExecTool("$bodytm");
  ShowCADDialog();
}


static void EV_Menu(void)
{
  if ( winkey_enable && !IsAnyChildWindows() && IsWorkSpaceVisible() && !IsFullScreenAppFind() )
     {
       SwitchMenuButton();
     }
}


static void EV_Minimize(void)
{
  if ( !IsAnyChildWindows() && IsWorkSpaceVisible() )
     {
       ToggleDesktop();
     }
}


static void EV_Explorer(void)
{
  if ( mycomp_in_menu && !IsAnyChildWindows() && IsWorkSpaceVisible() )
     {
       M_Mycomp();
     }
}


static void EV_FastExit(void)
{
  if ( !IsAnyChildWindows() )
     {
       OnKBFastExit();
     }
}


// key-events
enum {
EV_TASKMGR = 0,
EV_TASKMGR2,
EV_TASKMGR3,
EV_MENU,
EV_MINIMIZE1,
EV_MINIMIZE2,
EV_EXPLORER,
EV_FASTEXIT,
};

static struct {
int id;
unsigned last_event_time;
void(*func)(void);
int delay;
} events[] =
{
  {EV_TASKMGR,0,EV_Taskmgr,1000},
  {EV_TASKMGR2,0,EV_Taskmgr,1000},
  {EV_TASKMGR3,0,EV_Taskmgr,1000},
  {EV_MENU,0,EV_Menu,200},
  {EV_MINIMIZE1,0,EV_Minimize,100},
  {EV_MINIMIZE2,0,EV_Minimize,100},
  {EV_EXPLORER,0,EV_Explorer,100},
  {EV_FASTEXIT,0,EV_FastExit,300},
};


void ExecHotKeyEvent(int id)
{
  int n;

  for ( n = 0; n < sizeof(events)/sizeof(events[0]); n++ )
      if ( events[n].id == id )
         {
           if ( GetTickCount() - events[n].last_event_time > events[n].delay )
              {
                events[n].last_event_time = GetTickCount();
                events[n].func();
              }

           break;
         }
}


void OnWinKeyPressed(void)
{
  ExecHotKeyEvent(EV_MENU);
}


void SetGeneralHotKeys(HWND w)
{
  if ( safe_taskmgr )
     RegisterHotKey(w,EV_TASKMGR,MOD_CONTROL|MOD_ALT,VK_NEXT);
  else
     UnregisterHotKey(w,EV_TASKMGR);

  if ( safe_taskmgr2 )
     RegisterHotKey(w,EV_TASKMGR2,MOD_CONTROL|MOD_ALT,VK_END);
  else
     UnregisterHotKey(w,EV_TASKMGR2);

  if ( safe_taskmgr3 )
     RegisterHotKey(w,EV_TASKMGR3,MOD_CONTROL|MOD_ALT,VK_INSERT);
  else
     UnregisterHotKey(w,EV_TASKMGR3);

  if ( fastexit_use_keyboard )
     RegisterHotKey(w,EV_FASTEXIT,MOD_CONTROL|MOD_ALT,'P');
  else
     UnregisterHotKey(w,EV_FASTEXIT);

//  RegisterHotKey(w,EV_MENU,MOD_WIN,VK_LWIN);
  RegisterHotKey(w,EV_MINIMIZE1,MOD_WIN,'D');
  RegisterHotKey(w,EV_MINIMIZE2,MOD_WIN,'M');
  RegisterHotKey(w,EV_EXPLORER,MOD_WIN,'E');
}
