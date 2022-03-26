

static BOOL IsOurSSaverRunning(void)
{
  HANDLE event = OpenEvent(SYNCHRONIZE,FALSE,"_RSEventScreenSaver");
  if ( event )
     {
       CloseHandle(event);
       return TRUE;
     }

  return FALSE;
}


static BOOL IsOurBlockerRunning(void)
{
  HANDLE event = OpenEvent(SYNCHRONIZE,FALSE,"_RSEventBlocker");
  if ( event )
     {
       CloseHandle(event);
       return TRUE;
     }

  return FALSE;
}


static void PrepareShaderFile(char *s,BOOL blocker)
{
  s[0] = 0;
  
  GdiFlush();
  
  RBUFF buff;
  HDC hdc = GetDC(NULL);
  CreateShaderInternal(hdc,&buff);
  ReleaseDC(NULL,hdc);

  if ( blocker )
     {
       RECT r;
       HFONT font,oldfont;

       SetRect(&r,30,30,buff.w-30,buff.h-30);
       font = CreateFont(-20,0,0,0,FW_BOLD,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH,"Verdana");
       oldfont = (HFONT)SelectObject(buff.hdc,font);
       SetBkMode(buff.hdc,TRANSPARENT);
       SetTextColor(buff.hdc,RGB(245,245,245));
       DrawText(buff.hdc,LS(3038),-1,&r,DT_RIGHT | DT_BOTTOM | DT_SINGLELINE);
       SelectObject(buff.hdc,oldfont);
       DeleteObject(font);
     }

  Image *img = CreateImageFromHDC(buff.hdc,buff.w,buff.h);

  if ( img )
     {
       s[0] = 0;
       GetTempPath(MAX_PATH,s);
       PathAppend(s,"rs_shader.jpg");
       SaveImageToFile(img,L"image/jpeg",s);
       delete img;
     }

  RB_Destroy(&buff);
}


static void WaitForBlockerSaverInternal(BOOL blocker,BOOL reversed)
{
  unsigned time = GetTickCount();
  
  do {
   if ( blocker )
      {
        if ( (IsOurBlockerRunning() && !reversed) || (!IsOurBlockerRunning() && reversed) )
           break;
      }
   else
      {
        if ( (IsOurSSaverRunning() && !reversed) || (!IsOurSSaverRunning() && reversed) )
           break;
      }

   if ( GetTickCount()-time > 8000 )
      break;

   Sleep(20);
  } while (1);
}


static void RunBlockerSaverInternal(BOOL blocker)
{
  char s[MAX_PATH];
  
  lstrcpy(s,blocker_file);
  if ( !s[0] )
     PrepareShaderFile(s,blocker);
  else
     ExpandPath(s);

  if ( s[0] )
     {
       char exe[MAX_PATH];
       char cmd[MAX_PATH];

       if ( PathIsDirectory(s) )
          {
            PathAddBackslash(s);
            lstrcat(s,"\\"); //needed
          }

       GetLocalPath("rsblock.exe",exe);
       if ( blocker )
          wsprintf(cmd,"\"%s\" -blocker \"%s\"",exe,s);
       else
          wsprintf(cmd,"\"%s\" -ssaver \"%s\"",exe,s);

       if ( RunProcess(cmd) )
          {
            WaitForBlockerSaverInternal(blocker,0);
          }
     }
}


void RunOurSSaver(void)
{
  if ( !IsOurSSaverRunning() && !IsOurBlockerRunning() )
     {
       RunBlockerSaverInternal(FALSE);
     }
}


void RunOurBlocker(void)
{
  if ( !use_blocker || IsOurBlockerRunning() )
     return;

  if ( IsOurSSaverRunning() )
     {
       HANDLE event = OpenEvent(SYNCHRONIZE | EVENT_MODIFY_STATE,FALSE,"_RSEventScreenSaver");
       if ( event )
          {
            SetEvent(event);
            CloseHandle(event);

            WaitForBlockerSaverInternal(TRUE,0);
          }
       else
          {
            RunBlockerSaverInternal(TRUE);
          }
     }
  else
     {  
       RunBlockerSaverInternal(TRUE);
     }
}


void CloseOurBlocker(void)
{
  if ( IsOurBlockerRunning() )
     {
       HANDLE event = OpenEvent(SYNCHRONIZE | EVENT_MODIFY_STATE,FALSE,"_RSEventBlocker");
       if ( event )
          {
            SetEvent(event);
            CloseHandle(event);

            WaitForBlockerSaverInternal(TRUE,1);
          }
     }
}
