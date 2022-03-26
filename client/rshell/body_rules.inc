
static HANDLE rules_process = NULL;
static int rules_threadid = -1;


void CloseRulesWindow(void)
{
  if ( !rules_process )
     return;

  PostThreadMessage(rules_threadid,WM_QUIT,0,0);

  WaitForSingleObject(rules_process,3000);
  CloseHandle(rules_process);
  rules_process = NULL;
}


void ShowRulesWindow(const char *s)
{
  STARTUPINFO si;
  PROCESS_INFORMATION pi;
  char cmd[MAX_PATH];
  unsigned time;

  CloseRulesWindow();
  
  if ( !s || !s[0] || !IsFileExist(s) )
     return;

  wsprintf(cmd,"\"%s%s\" \"%s\"",our_currpath,"rsrules.exe",s);

  ZeroMemory(&si,sizeof(si));
  si.cb = sizeof(si);
  if ( !CreateProcess(NULL,cmd,NULL,NULL,FALSE,0,NULL,our_currpath,&si,&pi) )
     return;

  CloseHandle(pi.hThread);

  rules_process = pi.hProcess;
  rules_threadid = pi.dwThreadId;

  time = GetTickCount();
  
  while( 1 )
  {
    if ( FindWindow("TRulesForm",NULL) )
       break;

    if ( GetTickCount() - time > 5000 )
       break;

    Sleep(20);
  };
}

