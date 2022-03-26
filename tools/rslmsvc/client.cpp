
#include "include.h"




static std::string GetAnswerHeaders(int i_status,const char *s_status,const char *ctype)
{
  std::string rc;

  char s[MAX_PATH];
  sprintf(s,"HTTP/1.1 %d %s\r\n",i_status,s_status);
  rc += s;

  rc += "Server: Runpad Pro LicMgr\r\n";

  static const char* const dow[7] = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
  static const char* const month[12] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
  SYSTEMTIME st;
  GetSystemTime(&st);
  sprintf(s,"%s, %d %s %d %02d:%02d:%02d GMT",dow[st.wDayOfWeek],st.wDay,month[st.wMonth-1],st.wYear,st.wHour,st.wMinute,st.wSecond);
  rc += "Date: "; rc += s; rc += "\r\n";
  rc += "Last-Modified: "; rc += s; rc += "\r\n";

  rc += "Expires: Thu, 19 Nov 1981 08:52:00 GMT\r\n";
  rc += "Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0\r\n";
  rc += "Pragma: no-cache\r\n";

  rc += "Connection: close\r\n";

  rc += "Content-Type: "; rc += ctype; rc += "\r\n";

  rc += "\r\n";

  return rc;
}


static std::string GetParmValue(const std::vector<std::string>& env,const char *name)
{
  std::string rc;

  if ( !IsStrEmpty(name) )
     {
       std::string search(name);
       search += '=';

       for ( int n = 0; n < env.size(); n++ )
           {
             if ( !_strnicmp(env[n].c_str(),search.c_str(),search.size()) )
                {
                  rc = env[n].substr(search.size());
                  break;
                }
           }
     }

  return rc;
}


static BOOL SendString(SOCKET h_socket,const std::string& s)
{
  BOOL rc = TRUE;
  
  const char *buff = s.data();
  int len = s.size();

  while ( len > 0 )
  {
    int bsent = send(h_socket,buff,len,0);
    if ( bsent == SOCKET_ERROR )
       {
         rc = FALSE;
         break;
       }

    buff += bsent;
    len -= bsent;
  }

  return rc;
}


static void ProcessAction(SOCKET h_socket,CServer *server,const std::vector<std::string>& env)
{
  std::string act = GetParmValue(env,"action");

  if ( !lstrcmp(act.c_str(),"update") )
     {
       std::string licname = GetParmValue(env,"licname");
       std::string licidx = GetParmValue(env,"licidx");
       int delta = StrToInt(GetParmValue(env,"delta").c_str());

       server->UpdateLic(licname,licidx,delta);

       SendString(h_socket,GetAnswerHeaders(200,"OK","text/html"));
     }
  else
  if ( !lstrcmp(act.c_str(),"getlist") )
     {
       std::string licname = GetParmValue(env,"licname");

       std::vector<std::string> l;
       server->GetLicList(licname,l);
       
       std::string s = GetAnswerHeaders(200,"OK","text/xml");

       s += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
       s += "<response>\n";

       for ( int n = 0; n < l.size(); n++ )
           {
             s += "<lic>";
             s += l[n];
             s += "</lic>\n";
           }
       
       s += "</response>\n";

       SendString(h_socket,s);
     }
  else
     {
       SendString(h_socket,GetAnswerHeaders(404,"Not Found","text/html"));
     }
}


static void ProcessParms(SOCKET h_socket,CServer *server,const char *parms)
{
  std::vector<std::string> env;
  
  std::string t = parms;

  t += "&&";

  for ( int n = 0; n < t.size(); n++ )
      {
        if ( t[n] == '&' )
           {
             t[n] = '\0';
           }
      }

  const char *p = t.data();
  while ( *p )
  {
    env.push_back(std::string(p));
    p += lstrlen(p) + 1;
  };

  ProcessAction(h_socket,server,env);
}


static void WorkWithSocket(SOCKET h_socket,CServer *server)
{
  // recv client request
  BOOL err = FALSE;
  std::string req;
  
  do {

   char buff[1];
   int rc = recv(h_socket,buff,1,0);
   if ( rc == SOCKET_ERROR || rc == 0 )
      {
        err = TRUE;
        break;
      }

   req += buff[0];

   if ( req.length() > 4 && req[req.length()-4] == '\r' && req[req.length()-3] == '\n' && req[req.length()-2] == '\r' && req[req.length()-1] == '\n' )
      {
        break;
      }

  } while (1);

  if ( !err )
     {
       const char *s = req.c_str();

       const char *e = StrStrI(s,"HTTP/1.1\r\n");
       if ( e )
          {
            if ( !StrCmpNI(s,"GET",3) )
               {
                 int numchars = e-s-3+1;
                 char *q = (char*)sys_alloc(numchars);
                 lstrcpyn(q,s+3,numchars);
                 StrTrim(q," \t");

                 if ( !StrCmpN(q,"/licman?",8) )
                    {
                      const char *parms = q+8;
                      ProcessParms(h_socket,server,parms);
                    }

                 sys_free(q);
               }
          }
     }
}


unsigned __stdcall ClientThreadProc(LPVOID lpParameter)
{
  TCLIENTTHREAD *i = (TCLIENTTHREAD*)lpParameter;

  if ( i )
     {
       CServer *server = i->server;
       SOCKET h_socket = i->h_socket;

       int v = 5000;
       setsockopt(h_socket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));

       WorkWithSocket(h_socket,server);

       shutdown(h_socket,SD_BOTH);
       closesocket(h_socket);

       delete i;
     }

  return 1;
}

