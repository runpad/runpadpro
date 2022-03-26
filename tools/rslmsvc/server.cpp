
#include "include.h"



CServer::CServer(int _port)
{
  InitializeCriticalSection(&o_cs);

  h_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

  struct sockaddr_in sin;
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(_port);
  bind(h_socket,(SOCKADDR*)&sin,sizeof(sin));

  listen(h_socket,SOMAXCONN/*maybe 0 ?*/);

  h_stop_event = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = CreateThread(NULL,0,AcceptThreadProcWrapper,this,0,NULL);
}


CServer::~CServer()
{
  SetEvent(h_stop_event);
  if ( WaitForSingleObject(h_thread,3000) == WAIT_TIMEOUT )
     TerminateThread(h_thread,0);
  CloseHandle(h_thread);
  CloseHandle(h_stop_event);

  if ( h_socket != INVALID_SOCKET )
     {
       shutdown(h_socket,SD_BOTH);
       closesocket(h_socket);
       h_socket = INVALID_SOCKET;
     }

  DeleteCriticalSection(&o_cs);
}


DWORD WINAPI CServer::AcceptThreadProcWrapper(LPVOID lpParameter)
{
  CServer *obj = (CServer*)lpParameter;
  return obj->AcceptThreadProc();
}


DWORD CServer::AcceptThreadProc()
{
  do {

    timeval tv;
    tv.tv_sec = 0;
    tv.tv_usec = 500*1000; //500 msec

    fd_set rset;
    rset.fd_count = 1;
    rset.fd_array[0] = h_socket;

    int count = select(0,&rset,NULL,NULL,&tv);

    if ( count == SOCKET_ERROR )
       {
         break;
       }

    if ( count == 1 )
       {
         struct sockaddr_in s_in;
         int i_s_in_len = sizeof(s_in);
         SOCKET temp_sock = accept(h_socket,(struct sockaddr*)&s_in,&i_s_in_len);
         if ( temp_sock != INVALID_SOCKET )
            {
              AddClient(temp_sock);
            }
         else
            Sleep(10); //paranoja
       }

    if ( WaitForSingleObject(h_stop_event,0) == WAIT_OBJECT_0 )
       break;

    CleanupLics();

  } while (1);

  shutdown(h_socket,SD_BOTH);

  return 1;
}


void CServer::AddClient(SOCKET _socket)
{
  TCLIENTTHREAD *i = new TCLIENTTHREAD;
  i->server = this;
  i->h_socket = _socket;

  CloseHandle((HANDLE)_beginthreadex(NULL,0,ClientThreadProc,i,0,NULL));
}


// called from another thread!
void CServer::UpdateLic(const std::string& licname,const std::string& licidx,int delta_sec)
{
  CCSGuard g(o_cs);

  if ( !licname.empty() && !licidx.empty() )
     {
       OURTIME newtime = GetNowOurTime() + (OURTIME)delta_sec/86400.0;

       TMap::iterator it = m_map.find(TStringPair(licname,licidx));
       if ( it == m_map.end() )
          {
            m_map.insert(TMap::value_type(TStringPair(licname,licidx),newtime));
          }
       else
          {
            if ( newtime > it->second )
               {
                 it->second = newtime;
               }
          }
     }
}


// called from another thread!
void CServer::GetLicList(const std::string& licname,std::vector<std::string>& _list)
{
  CCSGuard g(o_cs);

  _list.clear();

  if ( !licname.empty() )
     {
       for ( TMap::const_iterator it = m_map.begin(); it != m_map.end(); ++it )
           {
             if ( !lstrcmpi(it->first.first.c_str(),licname.c_str()) )
                {
                  _list.push_back(it->first.second);
                }
           }
     }
}


void CServer::CleanupLics()
{
  CCSGuard g(o_cs);

  OURTIME nowtime = GetNowOurTime();

  do {
  
   BOOL b_deleted = FALSE;
   for ( TMap::iterator it = m_map.begin(); it != m_map.end(); ++it )
       {
         if ( it->second < nowtime )
            {
              m_map.erase(it);
              b_deleted = TRUE;
              break;
            }
       }

   if ( !b_deleted )
      break;

  } while (1);
}


bool CServer::CStringPairLessI::operator () (const TStringPair& f1,const TStringPair& f2) const
{
  std::string s1(f1.first+std::string("|.")+f1.second);
  std::string s2(f2.first+std::string("|.")+f2.second);

  return lstrcmpi(s1.c_str(),s2.c_str()) < 0;
}


