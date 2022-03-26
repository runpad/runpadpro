
static void GetMyDesktopName(char *name)
{
  HDESK my_desk;

  name[0] = 0;
  
  my_desk = GetThreadDesktop(GetCurrentThreadId());
  if ( my_desk )
     {
       DWORD rc = 0;
       if ( !GetUserObjectInformation(my_desk,UOI_NAME,name,MAX_PATH,&rc) )
          name[0] = 0;
     }
}


static void GetInputDesktopName(char *name)
{
  HDESK desk;

  name[0] = 0;
  
  desk = OpenInputDesktop(0,FALSE,GENERIC_READ);
  if ( desk )
     {
       DWORD rc = 0;
       if ( !GetUserObjectInformation(desk,UOI_NAME,name,MAX_PATH,&rc) )
          name[0] = 0;

       CloseDesktop(desk);
     }
}


BOOL IsOurDesktopHidden(void)
{
  char my_desk[MAX_PATH];
  char input_desk[MAX_PATH];

  GetMyDesktopName(my_desk);
  if ( !my_desk[0] )
     return FALSE;

  GetInputDesktopName(input_desk);
  return lstrcmp(input_desk,my_desk) != 0;
}


void Wait4DesktopSwitch(void)
{
  char my_desk[MAX_PATH];

  HANDLE event = CreateEvent(NULL,FALSE,FALSE,"ShellDesktopSwitchEvent");
  if ( event )
     SetEvent(event);

  GetMyDesktopName(my_desk);
  if ( my_desk[0] )
     {
       const unsigned waittime = 5000;
       unsigned t = GetTickCount();
       
       do {
         char input_desk[MAX_PATH];
         
         GetInputDesktopName(input_desk);
         if ( !lstrcmp(input_desk,my_desk) )
            break;

         if ( GetTickCount() - t > waittime )
            break;

         Sleep(100);

       } while (1);
     }
}
