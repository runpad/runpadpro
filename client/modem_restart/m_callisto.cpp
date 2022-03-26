
#include <winsock2.h>
#include <windows.h>
#include "m_callisto.h"


BOOL SendCmd(int newsocket,const CHAR *s)
{
  send(newsocket,s,lstrlenA(s),0);
  send(newsocket,"\r\n",2,0);
  return TRUE;
}



BOOL Restart_Callisto(const char *host)
{
  BOOL rc = FALSE;
  
  const unsigned short port = 23;

  const CHAR *login = "qe1dg7bm";
  const CHAR *password = "qa6yo9km";
  const CHAR *command = "system restart";
  
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  int newsocket = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);

  struct sockaddr_in addr;
  ZeroMemory(&addr,sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  *(int*)&addr.sin_addr = inet_addr(host);

  if ( !connect(newsocket,(struct sockaddr*)&addr,sizeof(addr)) )
     {
       int v = 3000;
       setsockopt(newsocket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));
       
       SendCmd(newsocket,login);
       SendCmd(newsocket,password);
       SendCmd(newsocket,command);

       Sleep(3000);

       rc = TRUE;
     }

  //shutdown(newsocket,SD_BOTH);
  closesocket(newsocket);
  WSACleanup();

  return rc;
}



