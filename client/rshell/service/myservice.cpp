
#include "include.h"



CMyService::CMyService()
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  h_mutex = NULL;
  p_pipe = NULL;
  p_net = NULL;
  p_cam = NULL;
}


CMyService::~CMyService()
{
  Stop();

  //WSACleanup(); //some problems related with multithreading (but only if no user32.dll in process WSACleanup can deadlocks?)
}


BOOL CMyService::IsExecuted() const
{
  return h_mutex != NULL;
}


BOOL CMyService::Start()
{
  if ( !IsExecuted() )
     {
       p_pipe = new CPipeObj();
       p_net = new CNetObj();
       p_cam = new CCameraCB();

       SECURITY_ATTRIBUTES sa;
       sa.nLength = sizeof(sa);
       sa.lpSecurityDescriptor = AllocateSDWithNoDACL();
       sa.bInheritHandle = FALSE;
       h_mutex = CreateMutex(&sa,FALSE,"Global\\RunpadProShellServiceMutex");
       FreeSD(sa.lpSecurityDescriptor);
     }

  return TRUE;
}


BOOL CMyService::Stop()
{
  if ( IsExecuted() )
     {
       CloseHandle(h_mutex);
       h_mutex = NULL;
       
       delete p_pipe;
       p_pipe = NULL;

       delete p_net;
       p_net = NULL;

       delete p_cam;
       p_cam = NULL;
     }

  return TRUE;
}

