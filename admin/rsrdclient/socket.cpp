
#include <winsock2.h>
#include <windows.h>
#include "socket.h"


CSocket::CSocket()
{
  m_socket = INVALID_SOCKET;
  m_parent_thread_id = GetCurrentThreadId();
  m_thread = NULL;
  m_connected = FALSE;
  InitializeCriticalSection(&m_section);
}


CSocket::~CSocket()
{
  DeleteCriticalSection(&m_section);
}


void CSocket::SyncBegin()
{ 
  EnterCriticalSection(&m_section);
}


void CSocket::SyncEnd()
{
  LeaveCriticalSection(&m_section);
}


BOOL CSocket::Connect(char *server,unsigned port)
{
  BOOL rc = FALSE;
  struct sockaddr_in addr;

  m_socket = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);

  ZeroMemory(&addr,sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  *(int *)&addr.sin_addr = GetFirstHostAddrByName(server);

  if ( !connect(m_socket,(struct sockaddr*)&addr,sizeof(addr)) )
     {
       int v = 3000;
       setsockopt(m_socket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));

       DWORD id;
       m_thread = CreateThread(NULL,0,ThreadProc,(void*)this,0,&id);
       m_connected = TRUE;
       rc = TRUE;
     }
  else
     {
       closesocket(m_socket);
       m_socket = INVALID_SOCKET;
       m_connected = FALSE;
     }

  return rc;
}


void CSocket::Disconnect()
{
  if ( m_thread )
     {
       TerminateThread(m_thread,0);
       CloseHandle(m_thread);
       m_thread = NULL;
     }

  if ( m_socket != INVALID_SOCKET )
     {
       shutdown(m_socket,SD_BOTH);
       closesocket(m_socket);
       m_socket = INVALID_SOCKET;
     }

  m_connected = FALSE;
}


int CSocket::GetFirstHostAddrByName(char *name)
{
  int ip = inet_addr(name);

  if ( ip == 0 || ip == -1 )
     {
       struct hostent *h = gethostbyname(name);
       if ( h )
          {
            int *pip = (int*)h->h_addr_list[0];
            if ( pip )
               ip = *pip;
          }
     }

  return ip;
}


DWORD WINAPI CSocket::ThreadProc(LPVOID lpParameter)
{
  CSocket *obj = (CSocket*)lpParameter;
  obj->WorkWithServer();
  return 1;
}


BOOL CSocket::RecvData(void *buff, int max_len)
{
  char *dest;
  
  if ( max_len <= 0 )
     return FALSE;
  
  dest = (char*)buff;

  do {
    int rc = recv(m_socket, dest, max_len, 0);
    if ( rc <= 0 )
       return FALSE;

    dest += rc;
    max_len -= rc;

  } while ( max_len );

  return TRUE;
}


BOOL CSocket::RecvData(int *i)
{
  return RecvData((void*)i,sizeof(*i));
}


BOOL CSocket::RecvData(unsigned *u)
{
  return RecvData((void*)u,sizeof(*u));
}


BOOL CSocket::SendData(void *buff, int len)
{
  return send(m_socket,(char*)buff,len,0) == len;
}


BOOL CSocket::SendData(int i)
{
  return SendData((void*)&i,sizeof(i));
}


BOOL CSocket::SendData(unsigned u)
{
  return SendData((void*)&u,sizeof(u));
}


void CSocket::PostMessageToParentThread(const char *msg)
{
  ::PostThreadMessage(m_parent_thread_id,RegisterWindowMessage(msg),0,0);
}


void CSocket::PostDisconnectMessage()
{
  PostMessageToParentThread("_RSRDDisconnected");
}
