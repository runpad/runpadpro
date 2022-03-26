


static void SetHook64Internal(BOOL state,const char *hook_name,const char *event_name)
{
  BOOL exists = FALSE;
  HANDLE h = OpenEvent(SYNCHRONIZE,FALSE,event_name);
  if ( h )
     {
       exists = TRUE;
       CloseHandle(h);
     }
  
  if ( state )
     { 
       // setup hook
       if ( !exists )
          {
            CDisableWOW64FSRedirection g;

            char s[MAX_PATH];
            GetFileNameInLocalAppDir("rshelper64.dll",s);
            //GetShortPathName(s,s,sizeof(s));

            char exe[MAX_PATH];
            GetFileNameInTrueSystem64Dir("rundll32.exe",exe);
            //GetShortPathName(exe,exe,sizeof(exe));

            char cmdline[MAX_PATH];
            sprintf(cmdline,"\"%s\" \"%s\",%s %s %s",exe,s,"SetHook64",hook_name,event_name);

            if ( RunProcess(cmdline) )
               {
                 unsigned starttime = GetTickCount();
                 while ( 1 )
                 {
                   if ( GetTickCount() - starttime > 2000 )
                      break;

                   HANDLE h = OpenEvent(SYNCHRONIZE,FALSE,event_name);
                   if ( h )
                      {
                        CloseHandle(h);
                        break;
                      }

                   Sleep(10);
                 };
               }
          }
     }
  else
     {
       // remove hook
       if ( exists )
          {
            HANDLE h = OpenEvent(SYNCHRONIZE|EVENT_MODIFY_STATE,FALSE,event_name);
            if ( h )
               {
                 SetEvent(h);
                 CloseHandle(h);
          
                 unsigned starttime = GetTickCount();
                 while ( 1 )
                 {
                   if ( GetTickCount() - starttime > 2000 )
                      break;

                   HANDLE h = OpenEvent(SYNCHRONIZE,FALSE,event_name);
                   if ( h )
                      {
                        CloseHandle(h);
                      }
                   else
                      {
                        break;
                      }

                   Sleep(10);
                 };
               }
          }
     }
}



void SetGlobalHook64(BOOL state)
{
  if ( IsWOW64() )
     {
       const char *hook_name = "GlobalHook";
       const char *event_name = "_RPS64_Event_Hook_Global";

       SetHook64Internal(state,hook_name,event_name);
     }
}



void SetDialogsHook64(BOOL state)
{
  if ( IsWOW64() )
     {
       const char *hook_name = "DialogsHook";
       const char *event_name = "_RPS64_Event_Hook_Dialogs";

       SetHook64Internal(state,hook_name,event_name);
     }
}



