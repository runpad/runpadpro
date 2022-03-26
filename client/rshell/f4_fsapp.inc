
static BOOL CALLBACK CalcFSAPP(HWND hwnd,LPARAM lParam)
{
  if ( GetWindowLong(hwnd,GWL_USERDATA) != MAGIC_WID && IsWindowVisible(hwnd) && !IsIconic(hwnd) )
     {
       RECT r,sr,wr;

       GetWindowRect(hwnd,&wr); 

       sr.left = 0;
       sr.top = 0;
       sr.right = GetSystemMetrics(SM_CXSCREEN);
       sr.bottom = GetSystemMetrics(SM_CYSCREEN);

       IntersectRect(&r,&sr,&wr);

       if ( EqualRect(&r,&sr) )
          (*(int *)lParam)++;
     }

  return TRUE;
}



BOOL IsFullScreenAppFind(void)
{
  int count = 0;
  EnumWindows(CalcFSAPP,(int)&count);
  return count != 0;
}
