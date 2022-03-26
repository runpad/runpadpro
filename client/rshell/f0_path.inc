

CPathExpander::CPathExpander(const char *path,BOOL allow_args)
{
  char currpath[MAX_PATH] = ""; //we do not use 'our_currpath' here, because this code can also be in seperate dll or exe
  GetModuleFileName(GetModuleHandle(NULL),currpath,MAX_PATH);
  PathRemoveFileSpec(currpath);
  PathAddBackslash(currpath);

  
  s_out = NULL;

  if ( !IsStrEmpty(path) )
     {
       if ( !allow_args )
          {
            char *s = sys_copystring(path);

            PathRemoveBlanks(s);
            PathUnquoteSpaces(s);

            if ( s[0] == '$' )
               {
                 char tool[MAX_PATH];

                 lstrcpy(tool,&s[1]);
                 lstrcat(tool,".exe");

                 sys_free(s);
                 s = (char*)sys_alloc(MAX_PATH);
                 
                 wsprintf(s,"%s%s",currpath,tool);
               }
            else
               {
                 unsigned dest_size = lstrlen(s)+MAX_PATH;
                 char *t = (char*)sys_alloc(dest_size);
                 t[0] = 0;
                 ExpandEnvironmentStrings(s,t,dest_size-1);

                 sys_free(s);
                 s = sys_copystring(t,MAX_PATH);
                 sys_free(t);
               }

            s_out = s;
          }
       else
          {
            // todo: make here correct check using CommandLineToArgvW, because such example will not work:
            // %ProgramFiles%\aaa\aaa.exe -parm
            // but with quotes works fine:
            // "%ProgramFiles%\aaa\aaa.exe" -parm
            
            char *s = sys_copystring(path);

            PathRemoveBlanks(s);

            if ( s[0] == '$' )
               {
                 char tool[MAX_PATH] = "";
                 const char *p = s+1;
                 char *q = tool;
                 while ( *p != 0 && *p != ' ' )
                       *q++ = *p++;
                 *q++ = 0;
                 lstrcat(tool,".exe");

                 char *t = (char*)sys_alloc(lstrlen(tool)+MAX_PATH+lstrlen(p));
                 wsprintf(t,"\"%s%s\"%s",currpath,tool,p);

                 sys_free(s);
                 s = sys_copystring(t,MAX_PATH);
                 sys_free(t);
               }
            else
               {
                 unsigned dest_size = MAX_PATH+lstrlen(s);
                 char *t = (char*)sys_alloc(dest_size);
                 t[0] = 0;
                 ExpandEnvironmentStrings(s,t,dest_size-1);

                 sys_free(s);
                 s = sys_copystring(t,MAX_PATH);
                 sys_free(t);
               }

            s_out = s;
          }
     }
}


CPathExpander::~CPathExpander()
{
  if ( s_out )
     sys_free(s_out);
}


char* ExpandPath(const char *in,char *out)
{
  CPathExpander oExp(in);
  lstrcpyn(out,oExp.GetPath(),MAX_PATH);
  return out;
}


char* ExpandPath(char *in_out)
{
  return ExpandPath(in_out,in_out);
}




CString2Filename::CString2Filename(const char *str)
{
  s_out = sys_copystring(str);

  for ( int n = 0; n < lstrlen(s_out); n++ )
      {
        char c = s_out[n];

        if ( c == ' ' && n == 0 )
           c = '_';
        else
        if ( c == '\\' || c == '/' || c == '?' || c == '*' || c == '\'' || c == '%' || c == '\"' || c == ':' || c == '<' || c == '>' || c == '|' )
           c = '_';

        s_out[n] = c;
      }
}


CString2Filename::~CString2Filename()
{
  if ( s_out )
     {
       sys_free(s_out);
       s_out = NULL;
     }
}


BOOL IsNetPathFast(const char *path)
{
  if ( IsStrEmpty(path) )
     return FALSE;

  if ( lstrlen(path) > 2 && path[0] == '\\' && path[1] == '\\' )
     return TRUE;
  else
     return FALSE;
}


