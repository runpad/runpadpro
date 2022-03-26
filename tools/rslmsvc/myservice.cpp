
#include "include.h"



CMyService::CMyService(int _port)
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  m_port = _port;
  p_obj = NULL;
}


CMyService::~CMyService()
{
  Stop();

  //WSACleanup(); //some problems related with multithreading (but only if no user32.dll in process WSACleanup can deadlocks?)
}


BOOL CMyService::IsExecuted() const
{
  return p_obj != NULL;
}


BOOL CMyService::Start()
{
  if ( !IsExecuted() )
     {
       p_obj = new CServer(m_port);
     }

  return TRUE;
}


BOOL CMyService::Stop()
{
  if ( IsExecuted() )
     {
       delete p_obj;
       p_obj = NULL;
     }

  return TRUE;
}

