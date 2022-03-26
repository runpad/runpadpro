
#include "include.h"



CTCPClientAsync::CPacket::CPacket(const void *buff,unsigned len)
{
  if ( buff && len )
     {
       m_len = len;
       m_buff = sys_alloc(len);

       if ( m_buff )
          {
            CopyMemory(m_buff,buff,len);
          }
       else
          {
            m_buff = NULL;
            m_len = 0;
          }
     }
  else
     {
       m_buff = NULL;
       m_len = 0;
     }

  m_time = GetTickCount();
}

CTCPClientAsync::CPacket::~CPacket()
{
  Free();
}

void CTCPClientAsync::CPacket::Free()
{
  if ( m_buff )
     {
       sys_free(m_buff);
       m_buff = NULL;
     }

  m_len = 0;
}

void CTCPClientAsync::CPacket::SetBuffLenNoCopy(void *buff,unsigned len)
{
  Free();

  m_buff = buff;
  m_len = len;
}

void CTCPClientAsync::CPacket::GetBuffLenAndClearSelf(void **_buff,unsigned *_len)
{
  assert(_buff);
  assert(_len);
  
  *_buff = m_buff;
  *_len = m_len;

  m_buff = NULL;
  m_len = 0;
}



CTCPClientAsync::CRecvBuff::CRecvBuff()
{
  ClearVars();
}

CTCPClientAsync::CRecvBuff::~CRecvBuff()
{
  Free();
}

void CTCPClientAsync::CRecvBuff::ClearVars()
{
  ZeroMemory(static_buff,sizeof(static_buff));
  dynamic_buff = NULL;
  dynamic_len = 0;
  recv_bytes = 0;
}

void CTCPClientAsync::CRecvBuff::Free()
{
  if ( dynamic_buff )
     sys_free(dynamic_buff);
  ClearVars();
}




CTCPClientAsync::CTCPClientAsync(HKEY root,const char *key,const char *value,
                                 unsigned port,
                                 unsigned _max_packet_size,
                                 unsigned _max_packet_ttl,
                                 unsigned _max_queue_packets,
                                 HANDLE _event_connect,
                                 HANDLE _event_disconnect )
{
  InitializeCriticalSection(&o_cs);

  max_packet_size = _max_packet_size;
  max_packet_ttl = _max_packet_ttl;
  max_queue_packets = _max_queue_packets;

  h_event_connect = _event_connect;
  h_event_disconnect = _event_disconnect;
  
  use_reg = TRUE;
  reg_root = root;
  reg_key = sys_copystring(key);
  reg_value = sys_copystring(value);
  last_reg_read_time = GetTickCount() - 60000;

  tcp_port = port;

  server_name[0] = 0;
  server_ip = 0;

  h_socket = INVALID_SOCKET;
  m_winsock_err = 0;

  SetConnectEvent(FALSE);
  SetDisconnectEvent(FALSE);

  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,NULL);
}


CTCPClientAsync::CTCPClientAsync(const char *server,
                                 unsigned port,
                                 unsigned _max_packet_size,
                                 unsigned _max_packet_ttl,
                                 unsigned _max_queue_packets,
                                 HANDLE _event_connect,
                                 HANDLE _event_disconnect )
{
  InitializeCriticalSection(&o_cs);

  max_packet_size = _max_packet_size;
  max_packet_ttl = _max_packet_ttl;
  max_queue_packets = _max_queue_packets;

  h_event_connect = _event_connect;
  h_event_disconnect = _event_disconnect;
  
  use_reg = FALSE;
  reg_root = NULL;
  reg_key = NULL;
  reg_value = NULL;
  last_reg_read_time = 0;

  tcp_port = port;

  lstrcpyn(server_name,server?server:"",sizeof(server_name));
  server_ip = 0;

  h_socket = INVALID_SOCKET;
  m_winsock_err = 0;

  SetConnectEvent(FALSE);
  SetDisconnectEvent(FALSE);

  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,NULL);
}


CTCPClientAsync::~CTCPClientAsync()
{
  SmartThreadFinish(h_thread);

  SetConnectEvent(FALSE);
  SetDisconnectEvent(FALSE);

  CloseSocket();

  FreeList(send_queue);
  FreeList(recv_queue);
  
  if ( reg_key )
     sys_free(reg_key);
  if ( reg_value )
     sys_free(reg_value);

  DeleteCriticalSection(&o_cs); //must be last
}


void CTCPClientAsync::SetConnectEvent(BOOL state)
{
  if ( h_event_connect )
     {
       if ( state )
          SetEvent(h_event_connect);
       else
          ResetEvent(h_event_connect);
     }
}


void CTCPClientAsync::SetDisconnectEvent(BOOL state)
{
  if ( h_event_disconnect )
     {
       if ( state )
          SetEvent(h_event_disconnect);
       else
          ResetEvent(h_event_disconnect);
     }
}


void CTCPClientAsync::SmartThreadFinish(HANDLE &h)
{
  if ( h )
     {
       if ( WaitForSingleObject(h,0) == WAIT_TIMEOUT )
          {
            TerminateThread(h,0);
          }

       CloseHandle(h);
       h = NULL;
     }
}


DWORD WINAPI CTCPClientAsync::ThreadProcWrapper(LPVOID lpParameter)
{
  CTCPClientAsync *obj = (CTCPClientAsync*)lpParameter;
  return obj->ThreadProc();
}


DWORD CTCPClientAsync::ThreadProc()
{
  do {

    // IP retrieval (if needed)
    int old_ip = server_ip;
    RetrieveServerIP();
    if ( old_ip != server_ip )
       {
         CloseSocket();
         FreeRecvBuff();
         if ( old_ip != 0 )
            EraseAllPackets();
       }

    // connection to server (if needed)
    ConnectSocket();

    // send queued packets
    BOOL send_err = FALSE;
    SendPackets(&send_err);
    if ( send_err )
       {
         CloseSocket();
         FreeRecvBuff();
         EraseAllPackets();
       }

    // async receive packets
    BOOL recv_err = FALSE;
    RecvPackets(&recv_err);
    if ( recv_err )
       {
         CloseSocket();
         FreeRecvBuff();
         EraseAllPackets();
       }

    // delete old and unneed packets
    EraseOldPackets();

    // sleep...
    Sleep(30);

  } while (1);

  return 1;
}


// used in debug purposes only
int CTCPClientAsync::GetLastWinsockErrorNonRepresentative() const
{ // csguard not needed really
  return m_winsock_err;
}


int CTCPClientAsync::GetServerIP() const
{ // csguard not needed really
  return server_ip;
}


BOOL CTCPClientAsync::IsConnected()
{
  return IsSocketReady();
}


BOOL CTCPClientAsync::IsSocketReady()
{
  return h_socket != INVALID_SOCKET;
}


BOOL CTCPClientAsync::IsServerIPRetrieved()
{
  return server_ip != 0;
}


void CTCPClientAsync::RetrieveServerIP()
{
  BOOL need_resolve = FALSE;
  
  if ( use_reg )
     {
       if ( GetTickCount() - last_reg_read_time > 30000 )
          {
            char s[MAX_PATH];
            ReadRegStr(reg_root,reg_key,reg_value,s,"");
            last_reg_read_time = GetTickCount();

            if ( lstrcmpi(s,server_name) )
               {
                 lstrcpy(server_name,s);
                 need_resolve = TRUE;
               }
          }
     }

  if ( need_resolve || server_ip == 0 )
     {
       int ip = server_name[0] ? GetFirstHostAddrByName(server_name) : 0;
       if ( ip == -1 )
          ip = 0;

       server_ip = ip;
     }
}


void CTCPClientAsync::CloseSocket()
{
  if ( IsSocketReady() )
     {
       shutdown(h_socket,SD_BOTH);
       closesocket(h_socket);
       h_socket = INVALID_SOCKET;

       SetConnectEvent(FALSE);
       SetDisconnectEvent(TRUE);
     }
}


void CTCPClientAsync::ConnectSocket()
{
  if ( !IsSocketReady() && IsServerIPRetrieved() )
     {
       int newsocket = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);

       struct sockaddr_in addr;
       ZeroMemory(&addr,sizeof(addr));
       addr.sin_family = AF_INET;
       addr.sin_port = htons(tcp_port);
       *(int*)&addr.sin_addr = server_ip;

       m_winsock_err = 1; // for debug
       
       if ( connect(newsocket,(struct sockaddr*)&addr,sizeof(addr)) )
          { //error
            m_winsock_err = WSAGetLastError();
            
            closesocket(newsocket);
        
            Sleep(2000);

            server_ip = 0; // this is needed, because IP for host can be changed in dynamic!!!
          }
       else
          {
            int v = 3000;
            setsockopt(newsocket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));
            
            h_socket = newsocket;

            SetDisconnectEvent(FALSE);
            SetConnectEvent(TRUE);
          }
     }
}


void CTCPClientAsync::SendPackets(BOOL *_err)
{
  BOOL rc = TRUE;
  
  if ( IsSocketReady() )
     {
       unsigned sent_packets = 0;
       
       do {

         CPacket *packet = NULL;
         {
           CCSGuard oGuard(o_cs);

           if ( send_queue.size() == 0 )
              break;
           packet = send_queue[0];
         }

         const char* buff = (const char*)packet->GetBuffPtr();
         unsigned len = packet->GetBuffLen();
         int id = MAGIC_ID;

         BOOL err = FALSE;
         err = err ? err : (send(h_socket,(const char*)&id,sizeof(id),0) != sizeof(id));
         err = err ? err : (send(h_socket,(const char*)&len,sizeof(len),0) != sizeof(len));
    
         if ( buff && len )
            {
              const char *p = buff;

              while ( len > 0 )
              {
                static const int MAXPACKET = 17520;
                unsigned sendsize = (len > MAXPACKET ? MAXPACKET : len);
                
                err = err ? err : (send(h_socket,p,sendsize,0) != sendsize);
                p += sendsize;
                len -= sendsize;
              };
            }

         if ( err )
            {
              rc = FALSE;
              break;
            }
         else
            {
              CCSGuard oGuard(o_cs);

              assert(send_queue.size()>0);
              delete packet;
              send_queue.erase(send_queue.begin());
              sent_packets++;
            }

       } while ( sent_packets < 5 );
     }

  if ( _err )
     {
       *_err = !rc;
     }
}


void CTCPClientAsync::RecvPackets(BOOL *_err)
{
  BOOL rc = TRUE;
  
  if ( IsSocketReady() )
     {
       unsigned recv_packets = 0;
       
       do {

        timeval tv;
        tv.tv_sec = 0;
        tv.tv_usec = 0;
        
        fd_set rset;
        rset.fd_count = 1;
        rset.fd_array[0] = h_socket;
        
        int count = select(0,&rset,NULL,NULL,&tv);
        if ( count == SOCKET_ERROR )
           {
             rc = FALSE;
             break;
           }

        if ( count == 0 )
           break;

        CRecvBuff &rb = recv_buff;
        
        if ( rb.recv_bytes < sizeof(rb.static_buff) )
           {
             // we on static buffer (id,len retrieval)
             
             char *dest_buff = rb.static_buff + rb.recv_bytes;
             unsigned dest_size = sizeof(rb.static_buff) - rb.recv_bytes;
             
             int recv_bytes = recv(h_socket,dest_buff,dest_size,0);
             if ( recv_bytes <= 0 )
                {
                  rc = FALSE;
                  break;
                }

             rb.recv_bytes += recv_bytes;

             if ( rb.recv_bytes >= sizeof(int) )
                {
                  int id = ((int*)rb.static_buff)[0];
                  if ( id != MAGIC_ID )
                     {
                       rc = FALSE;
                       break;
                     }
                }

             if ( rb.recv_bytes == sizeof(rb.static_buff) )
                {
                  unsigned len = ((unsigned*)rb.static_buff)[1];

                  if ( len == 0 )
                     {
                       CCSGuard oGuard(o_cs);
                       
                       if ( recv_queue.size() < max_queue_packets )
                          {
                            CPacket *packet = new CPacket(NULL,0);
                            recv_queue.push_back(packet);
                          }

                       rb.Free();
                       recv_packets++;
                     }
                  else
                     {
                       if ( len > max_packet_size )
                          {
                            rc = FALSE;
                            break;
                          }
                       
                       assert(!rb.dynamic_buff);
                       rb.dynamic_len = len;
                       rb.dynamic_buff = (char*)sys_alloc(len);

                       if ( !rb.dynamic_buff )
                          {
                            rc = FALSE;
                            break;
                          }
                     }
                }
             else
             if ( rb.recv_bytes > sizeof(rb.static_buff) )
                {
                  assert(FALSE);
                }
           }
        else
           {
             // we on dynamic buffer (data retrieval)
             assert(rb.dynamic_buff);
             assert(rb.dynamic_len);
             assert(rb.recv_bytes < sizeof(rb.static_buff) + rb.dynamic_len);

             char *dest_buff = rb.dynamic_buff + rb.recv_bytes - sizeof(rb.static_buff);
             unsigned dest_size = sizeof(rb.static_buff) + rb.dynamic_len - rb.recv_bytes;

             int recv_bytes = recv(h_socket,dest_buff,dest_size,0);
             if ( recv_bytes <= 0 )
                {
                  rc = FALSE;
                  break;
                }

             rb.recv_bytes += recv_bytes;

             if ( rb.recv_bytes == sizeof(rb.static_buff) + rb.dynamic_len )
                {
                  CCSGuard oGuard(o_cs);
                  
                  if ( recv_queue.size() < max_queue_packets )
                     {
                       CPacket *packet = new CPacket(NULL,0);
                       packet->SetBuffLenNoCopy(rb.dynamic_buff,rb.dynamic_len);
                       rb.ClearVars(); //dont free it!
                       recv_queue.push_back(packet);
                     }
                  else
                     {
                       rb.Free();
                     }

                  recv_packets++;
                }
             else
             if ( rb.recv_bytes > sizeof(rb.static_buff) + rb.dynamic_len )
                {
                  assert(FALSE);
                }
           }

       } while ( recv_packets < 5 );

       if ( !rc )
          {
            recv_buff.Free();
          }
     }

  if ( _err )
     {
       *_err = !rc;
     }
}


void CTCPClientAsync::EraseAllPackets()
{
  EraseOldPackets(TRUE);
}


void CTCPClientAsync::EraseOldPackets(BOOL erase_all)
{
  EraseOldList(send_queue,erase_all);
  EraseOldList(recv_queue,erase_all);
}


void CTCPClientAsync::EraseOldList(TPackets &list,BOOL erase_all)
{
  CCSGuard oGuard(o_cs);

  unsigned now = GetTickCount();

  do {
  
    BOOL deleted = FALSE;
    for ( TPackets::iterator it = list.begin(); it != list.end(); ++it )
        {
          if ( erase_all || (now - (*it)->GetCreationTime() > max_packet_ttl) )
             {
               delete *it;
               list.erase(it);

               deleted = TRUE;
               break;
             }
        }

    if ( !deleted )
       break;

  } while ( 1 );
}


void CTCPClientAsync::FreeList(TPackets &list)
{
  //CCSGuard oGuard(o_cs);

  int count = list.size();

  for ( int n = 0; n < count; n++ )
      {
        TPackets::iterator it = list.begin();
        delete *it;
        list.erase(it);
      }
}


void CTCPClientAsync::FreeRecvBuff()
{
  recv_buff.Free();
}


BOOL CTCPClientAsync::Push(const void *buff,unsigned len)
{
  CCSGuard oGuard(o_cs);

  if ( len > max_packet_size )
     return FALSE;

  if ( send_queue.size() >= max_queue_packets )
     return FALSE;

  CPacket *p = new CPacket(buff,len);
  send_queue.push_back(p);

  return TRUE;
}


BOOL CTCPClientAsync::Pop(void **_buff,unsigned *_len)
{
  CCSGuard oGuard(o_cs);

  assert(_buff);
  assert(_len);

  *_buff = NULL;
  *_len = 0;

  TPackets::iterator it = recv_queue.begin();
  if ( it == recv_queue.end() )
     return FALSE;

  (*it)->GetBuffLenAndClearSelf(_buff,_len);
  delete *it;
  recv_queue.erase(it);

  return TRUE;
}


BOOL CTCPClientAsync::Flush(unsigned timeout)
{
  if ( timeout == 0 )
     {
       CCSGuard oGuard(o_cs);
       
       return send_queue.size() == 0;
     }

  unsigned endtime = GetTickCount() + timeout;

  do {

    {
      CCSGuard oGuard(o_cs);

      if ( send_queue.size() == 0 )
         return TRUE;
    }

    Sleep(10);

  } while ( GetTickCount() < endtime );

  return FALSE;
}




CNetClient::CNetClient(HKEY root,const char *key,const char *value,unsigned port,HANDLE _ev_connect,HANDLE _ev_disconnect)
      : CTCPClientAsync(root,key,value,port,MAXPACKETSIZE,MAXPACKETTTL,MAXQUEUEPACKETS,_ev_connect,_ev_disconnect)
{
}


CNetClient::CNetClient(const char *server,unsigned port,HANDLE _ev_connect,HANDLE _ev_disconnect)
      : CTCPClientAsync(server,port,MAXPACKETSIZE,MAXPACKETTTL,MAXQUEUEPACKETS,_ev_connect,_ev_disconnect)
{
}


CNetClient::~CNetClient()
{
}


BOOL CNetClient::IsConnected()
{
  return CTCPClientAsync::IsConnected();
}


BOOL CNetClient::Push(const void *buff,unsigned len,unsigned dest_guid)
{
  void *temp = sys_alloc(sizeof(unsigned)+len);
  if ( !temp )
     return FALSE;

  *(unsigned*)temp = dest_guid;
  if ( buff )
     CopyMemory((char*)temp+sizeof(unsigned),buff,len);

  BOOL rc = CTCPClientAsync::Push(temp,sizeof(unsigned)+len);

  sys_free(temp);

  return rc;
}


BOOL CNetClient::Pop(void **_buff,unsigned *_len,unsigned *_src_guid)
{
  assert(_buff);
  assert(_len);

  if ( _src_guid )
     *_src_guid = NETGUID_INVALID;

  *_buff = NULL;
  *_len = 0;
  
  void *temp = NULL;
  unsigned tlen = 0;

  if ( !CTCPClientAsync::Pop(&temp,&tlen) )
     return FALSE;

  if ( tlen < sizeof(unsigned) )
     {
       if ( temp )
          sys_free(temp);
       return TRUE; //!!!
     }

  unsigned len = tlen - sizeof(unsigned);
  void *buff = len ? sys_alloc(len) : NULL;

  if ( !buff && len )
     len = 0;

  if ( buff )
     CopyMemory(buff,(char*)temp+sizeof(unsigned),len);

  if ( _src_guid )
     *_src_guid = *(unsigned*)temp;

  *_buff = buff;
  *_len = len;

  sys_free(temp);

  return TRUE;
}


BOOL CNetClient::Push(const CNetCmd& cmd,unsigned dest_guid)
{
  return Push(cmd.GetBuffPtr(),cmd.GetBuffSize(),dest_guid);
}


BOOL CNetClient::Pop(CNetCmd& cmd,unsigned *_src_guid)
{
  void *buff = NULL;
  unsigned len = 0;
  unsigned src_guid = NETGUID_INVALID;

  if ( !Pop(&buff,&len,&src_guid) )
     return FALSE;

  cmd.Clear();
  cmd.AddBuff(buff,len);

  if ( buff )
     sys_free(buff);

  if ( _src_guid )
     *_src_guid = src_guid;

  return TRUE;
}


BOOL CNetClient::Flush(unsigned timeout)
{
  return CTCPClientAsync::Flush(timeout);
}

