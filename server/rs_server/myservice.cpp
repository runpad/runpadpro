
#include "include.h"



CMyService::CMyService()
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  b_started = FALSE;
  p_obj = NULL;
}


CMyService::~CMyService()
{
  Stop();

  //WSACleanup(); //some problems related with multithreading (but only if no user32.dll in process WSACleanup can deadlocks?)
}


BOOL CMyService::IsExecuted() const
{
  return b_started;
}


BOOL CMyService::Start()
{
  if ( !IsExecuted() )
     {
       p_obj = new CServer();
       b_started = TRUE;
     }

  return TRUE;
}


BOOL CMyService::Stop()
{
  if ( IsExecuted() )
     {
       b_started = FALSE;
       delete p_obj;
       p_obj = NULL;
     }

  return TRUE;
}

