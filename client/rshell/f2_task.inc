
typedef struct {
int count;
char active[80];
} TTASKS;


static BOOL CALLBACK CalcActive(HWND hwnd,LPARAM lParam)
{
  if ( IsAppWindow(hwnd) )
     {
       TTASKS *list = (TTASKS*)lParam;

       list->count++;

       if ( GetForegroundWindow() == hwnd )
          GetWindowText(hwnd,list->active,sizeof(list->active)-1);
     }

  return TRUE;
}


char* GetActiveTaskString(char *s)
{
  TTASKS t;

  t.count = 0;
  t.active[0] = 0;

  EnumWindows(CalcActive,(unsigned)&t);

  s[0] = 0;
  if ( t.count || t.active[0] )
     {
       if ( t.count > 1 )
          wsprintf(s,"(%d) %s",t.count,t.active);
       else
          lstrcpy(s,t.active);
     }

  return s;
}
