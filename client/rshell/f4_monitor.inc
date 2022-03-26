
static unsigned monitor_off_interval;
static unsigned monitor_off_start_time;


void ProcessMonitorPower(void)
{
  if ( monitor_off )
     {
       if ( monitor_off_interval != 0 && GetTickCount() - monitor_off_start_time > monitor_off_interval )
          {
            TurnOnMonitor();
            SendDynamicInfoToServer();
          }
       else
          {
            PostMessage(GetMainWnd(),WM_SYSCOMMAND,SC_MONITORPOWER,2);
          }
     }
}


void TurnOffMonitor(int input_off,int interval)
{
  monitor_off = TRUE;
  monitor_off_start_time = GetTickCount();
  monitor_off_interval = interval;
  SetInputDisableState(input_off);
  ProcessMonitorPower();
  WriteRegDword(HKCU,REGPATH,"monitor_off_after_startup",1);
  //DisableTransparentWindows();
}


void TurnOnMonitor(void)
{
  monitor_off = FALSE;
  PostMessage(GetMainWnd(),WM_SYSCOMMAND,SC_MONITORPOWER,-1);
  SetInputDisableState(0);
  DeleteRegValue(HKCU,REGPATH,"monitor_off_after_startup");
  //EnableTransparentWindows();
}

