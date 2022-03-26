
#include "include.h"



CListener::CListener(int port)
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  h_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  struct sockaddr_in sin;
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(port);
  bind(h_socket,(SOCKADDR*)&sin,sizeof(sin));
  listen(h_socket,SOMAXCONN);

  h_stop_event = CreateEvent(NULL,TRUE,FALSE,NULL);
  h_thread = CreateThread(NULL,0,AcceptThreadProcWrapper,this,0,NULL);
}


CListener::~CListener()
{
  AsyncTerminateRequest();

  if ( WaitForSingleObject(h_thread,5000) == WAIT_TIMEOUT )
     TerminateThread(h_thread,0);
  CloseHandle(h_thread);

  CloseHandle(h_stop_event);

  shutdown(h_socket,SD_BOTH);
  closesocket(h_socket);
  h_socket = INVALID_SOCKET;

  WSACleanup();
}


void CListener::AsyncTerminateRequest()
{
  SetEvent(h_stop_event);
}


BOOL CListener::IsStopEvent(unsigned timeout)
{
  return WaitForSingleObject(h_stop_event,timeout) == WAIT_OBJECT_0;
}


DWORD WINAPI CListener::AcceptThreadProcWrapper(LPVOID lpParameter)
{
  CListener *obj = (CListener*)lpParameter;
  return obj->AcceptThreadProc();
}


DWORD CListener::AcceptThreadProc()
{
  do {

    BOOL err = TRUE;

    if ( IsDataAvail(h_socket,100,err) )
       {
         struct sockaddr_in s_in;
         int i_s_in_len = sizeof(s_in);
         SOCKET temp_sock = accept(h_socket,(struct sockaddr*)&s_in,&i_s_in_len);
         if ( temp_sock != INVALID_SOCKET )
            {
              if ( IsClientAllowed(s_in.sin_addr.s_addr) )
                 {
                   WorkWithClient(temp_sock);
                 }

              shutdown(temp_sock,SD_BOTH);
              closesocket(temp_sock);
            }
         else
            Sleep(10); //paranoja
       }

    if ( err )
       break;

    if ( IsStopEvent() )
       break;

  } while (1);

  shutdown(h_socket,SD_BOTH);

  return 1;
}


BOOL CListener::IsIPInList(const char *ext,const char *list)
{
  if ( !ext || !ext[0] )
     return FALSE;

  if ( !list || !list[0] )
     return FALSE;

  char *s_ext = (char*)malloc(strlen(ext)+20);
  char *s_list = (char*)malloc(strlen(list)+20);
     
  sprintf(s_ext,";%s;",ext);
  sprintf(s_list,";%s;",list); //long maybe

  BOOL rc = (StrStrI(s_list,s_ext) != NULL);

  free(s_list);
  free(s_ext);

  return rc;
}


BOOL CListener::IsClientAllowed(int client_ip)
{
  if ( client_ip == 0x0100007f )
     return TRUE;

  char s[MAX_PATH];
  ReadRegStr(HKLM,REGPATH,"allowed_services_ips",s,"");

  if ( !s[0] )
     return TRUE;

  char s_ip[MAX_PATH];
  unsigned char v_ip[4];

  *(int*)v_ip = client_ip;

  sprintf(s_ip,"%d.%d.%d.%d",v_ip[0],v_ip[1],v_ip[2],v_ip[3]);

  return IsIPInList(s_ip,s);
}


void CListener::SetSendTimeout(SOCKET h_socket,int timeout_ms)
{
  int v = timeout_ms;
  setsockopt(h_socket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));
}


BOOL CListener::IsDataAvail(SOCKET h_socket,unsigned timeout_ms,BOOL& _err)
{
  BOOL rc = FALSE;
  _err = FALSE;
  
  timeval tv;
  tv.tv_sec = timeout_ms/1000;
  tv.tv_usec = (timeout_ms%1000)*1000;

  fd_set rset;
  rset.fd_count = 1;
  rset.fd_array[0] = h_socket;

  int count = select(0,&rset,NULL,NULL,&tv);

  if ( count == SOCKET_ERROR )
     {
       _err = TRUE;
     }
  else
  if ( count == 1 )
     {
       rc = TRUE;
     }

  return rc;
}


BOOL CListener::SendData(SOCKET h_socket,const void *buff, int len)
{
  BOOL err = FALSE;

  const char *p = (const char*)buff;

  while ( len > 0 )
  {
    static const int MAXPACKET = 17520;
    unsigned sendsize = (len > MAXPACKET ? MAXPACKET : len);
    
    err = err ? err : (send(h_socket,p,sendsize,0) != sendsize);
    p += sendsize;
    len -= sendsize;
  };

  return !err;
}


BOOL CListener::SendData(SOCKET h_socket,int i)
{
  return SendData(h_socket,(const void*)&i,sizeof(i));
}


BOOL CListener::SendData(SOCKET h_socket,unsigned u)
{
  return SendData(h_socket,(const void*)&u,sizeof(u));
}


BOOL CListener::RecvData(SOCKET h_socket,void *buff, int max_len)
{
  if ( max_len <= 0 )
     return FALSE;
  
  char *dest = (char*)buff;

  do {
    int rc = recv(h_socket, dest, max_len, 0);
    if ( rc <= 0 )
       return FALSE;

    dest += rc;
    max_len -= rc;

  } while ( max_len );

  return TRUE;
}


BOOL CListener::RecvData(SOCKET h_socket,unsigned *u)
{
  return RecvData(h_socket, (void*)u, sizeof(*u) );
}


BOOL CListener::RecvData(SOCKET h_socket,int *i)
{
  return RecvData(h_socket, (void*)i, sizeof(*i) );
}


///////////////////////////////////



void CListenerScreen::WorkWithClient(SOCKET h_socket)
{
  CExecutor exec;
  
  SetSendTimeout(h_socket,7000);

  const unsigned buffsize = 2560*2048;  // is enought for large screens?
  void *buff = malloc(buffsize);

  while ( 1 )
  {
    if ( IsStopEvent() )
       break;

    BOOL err = TRUE;
    if ( IsDataAvail(h_socket,50,err) )
       {
         unsigned cmd;   
         if ( !RecvData(h_socket, &cmd ) )
            break;

         if ( cmd == CMD_SCREENREQ_RLE7B_GRAY || cmd == CMD_SCREENREQ_RLE7B_COLOR )
            {
              BOOL must_exit = TRUE;

              for ( int n = 0; n < 50; n++ )
                  {
                    DWORD session = -1;
                    BOOL session_changed = FALSE;
                    if ( exec.Prepare(session,session_changed) )
                       {
                         struct {
                          unsigned cmd;
                          BOOL session_changed;
                         } p = {cmd,session_changed};
                         
                         unsigned packetsize = 0;
                         if ( exec.Exec(session,&p,sizeof(p),buff,buffsize,packetsize,3000) )
                            {
                              if ( SendData(h_socket,buff,packetsize) )
                                 {
                                   must_exit = FALSE;
                                 }

                              break;
                            }
                       }

                    if ( IsStopEvent() )
                       {
                         break;
                       }

                    Sleep(100);
                  }

              if ( must_exit )
                 break;
            }
         else
            break;
       }
    else
    if ( err )
       break;
  }

  free(buff);
}


///////////////////////////////////



void CListenerEvents::WorkWithClient(SOCKET h_socket)
{
  CExecutor exec;
  
  while ( 1 )
  {
    if ( IsStopEvent() )
       break;

    BOOL err = TRUE;
    if ( IsDataAvail(h_socket,50,err) )
       {
         unsigned cmd;
         if ( !RecvData(h_socket, &cmd ) )
            break;

         if ( cmd == CMD_INPUTEVENT )
            {
              int count;
              if ( !RecvData(h_socket,&count) || count <= 0 || count > 10000 )
                 break;
              
              BOOL err = FALSE;
              for ( int n = 0; n < count; n++ )
                  {
                    struct {
                     unsigned cmd;
                     int message,wParam,lParam;
                     unsigned time;
                    } p = {cmd,};

                    if ( !RecvData(h_socket,&p.message) || 
                         !RecvData(h_socket,&p.wParam) || 
                         !RecvData(h_socket,&p.lParam) || 
                         !RecvData(h_socket,&p.time) )
                       {
                         err = TRUE;
                         break;
                       }

                    DWORD session = -1;
                    BOOL session_changed = FALSE;
                    if ( exec.Prepare(session,session_changed) )
                       {
                         int rc = -1;
                         unsigned rc_size = 0;
                         exec.Exec(session,&p,sizeof(p),&rc,sizeof(rc),rc_size,2000);
                       }
                  }

              if ( err )
                 break;
            }
         else
            break;
       }
    else
    if ( err )
       break;
  }
}


