
#include "include.h"



CNet::CNet()
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  recv_socket = CreateRecvSocket(PORT);
}


CNet::~CNet()
{
  closesocket(recv_socket);
  //WSACleanup();
}


int CNet::CreateRecvSocket(unsigned port)
{
  struct sockaddr_in address;
  BOOL v;
  u_long v2;
  int newsocket;
  int data;

  newsocket = socket(PF_INET,SOCK_DGRAM,IPPROTO_UDP);
  v2 = 1;
  ioctlsocket(newsocket,FIONBIO,&v2);
  v = 1;
  setsockopt(newsocket,SOL_SOCKET,SO_REUSEADDR,(char *)&v,sizeof(v));
  data = 64512;
  setsockopt(newsocket,SOL_SOCKET,SO_RCVBUF,(char *)&data,sizeof(data));

  ZeroMemory(&address,sizeof(address));
  address.sin_family = AF_INET;
  address.sin_addr.s_addr = htonl(INADDR_LOOPBACK); //INADDR_ANY
  address.sin_port = htons(port);
  bind(newsocket,(struct sockaddr *)&address,sizeof(address));

  return newsocket;
}


int CNet::RecvPacket(int newsocket,void *buff,int maxlen,int *from_ip)
{
  struct sockaddr_in addr;
  int len = sizeof(addr);
  int rc;

  rc = recvfrom(newsocket,(char *)buff,maxlen,0,(struct sockaddr *)&addr,&len);
  if ( rc <= 0 )
     return rc;

  if ( from_ip )
     *from_ip = *(int *)&addr.sin_addr;

  return rc;
}


BOOL CNet::Get(void *buff,int maxlen,int *_recv_bytes)
{
  if ( _recv_bytes )
     *_recv_bytes = 0;
  
  int from_ip = 0;
  int rc = RecvPacket(recv_socket,buff,maxlen,&from_ip);

  if ( rc <= 0 )
     return FALSE;

  if ( from_ip != 0x0100007F && !IsMyIP(from_ip) )  // for security reasons!
     return FALSE;

  if ( _recv_bytes )
     *_recv_bytes = rc;

  return TRUE;
}


BOOL CNet::IsMyIP(int ip)
{
  char host[MAX_PATH];
  struct hostent *h;
  int n,*pip;
  
  host[0] = 0;
  gethostname(host,sizeof(host));
  h = gethostbyname(host);
  if ( !h )
     return FALSE;

  n = 0;
  while ( (pip = (int*)h->h_addr_list[n]) )
  {
    if ( *pip == ip )
       return TRUE;
    n++;
  }

  return FALSE;
}
