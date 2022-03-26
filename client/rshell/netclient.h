
#ifndef __NETCLIENT_H__
#define __NETCLIENT_H__

#include <vector>
#include "netcmd.h"


class CTCPClientAsync
{
          class CPacket
          {
                     void *m_buff;
                     unsigned m_len;
                     unsigned m_time;
            public:
                     CPacket(const void *buff,unsigned len);
                     ~CPacket();

                     BOOL IsEmpty() const { return !m_buff || !m_len; }
                     const void* GetBuffPtr() const { return m_buff; }
                     unsigned GetBuffLen() const { return m_len; }

            protected:
                     friend class CTCPClientAsync;
            
                     unsigned GetCreationTime() const { return m_time; }
                     void SetBuffLenNoCopy(void *buff,unsigned len);
                     void GetBuffLenAndClearSelf(void **_buff,unsigned *_len);
            private:
                     void Free();
          };

          class CRecvBuff
          {
            protected:
                     friend class CTCPClientAsync;

                     char static_buff[2*4];
                     char *dynamic_buff;
                     unsigned dynamic_len;
                     unsigned recv_bytes;

            public:
                     CRecvBuff();
                     ~CRecvBuff();

            protected:
                     friend class CTCPClientAsync;

                     void ClearVars();
                     void Free();
          };

          static const int MAGIC_ID = 0x13DB0AF7; // our TCP packets id

          unsigned max_packet_size;
          unsigned max_packet_ttl;
          unsigned max_queue_packets;
          
          BOOL use_reg;
          HKEY reg_root;
          char *reg_key;
          char *reg_value;
          unsigned last_reg_read_time;

          char server_name[MAX_PATH];
          int server_ip;

          unsigned tcp_port;

          int m_winsock_err;

          volatile int h_socket;
          HANDLE h_thread;

          CRITICAL_SECTION o_cs;

          typedef std::vector<CPacket*> TPackets;
          TPackets send_queue;
          TPackets recv_queue;

          CRecvBuff recv_buff;

          HANDLE h_event_connect;
          HANDLE h_event_disconnect;

  public:
          CTCPClientAsync(HKEY root,const char *key,const char *value,
                          unsigned port,
                          unsigned _max_packet_size,
                          unsigned _max_packet_ttl,
                          unsigned _max_queue_packets,
                          HANDLE _event_connect,
                          HANDLE _event_disconnect );
          CTCPClientAsync(const char *server,
                          unsigned port,
                          unsigned _max_packet_size,
                          unsigned _max_packet_ttl,
                          unsigned _max_queue_packets,
                          HANDLE _event_connect,
                          HANDLE _event_disconnect );
          ~CTCPClientAsync();

          int GetLastWinsockErrorNonRepresentative() const;
          int GetServerIP() const;

  protected:

          BOOL IsConnected();
          BOOL Push(const void *buff,unsigned len);
          BOOL Pop(void **_buff,unsigned *_len);
          BOOL Flush(unsigned timeout);

  private:
          void SmartThreadFinish(HANDLE &h);
          static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
          DWORD ThreadProc();
          void RetrieveServerIP();
          void CloseSocket();
          void ConnectSocket();
          BOOL IsSocketReady();
          BOOL IsServerIPRetrieved();
          void SendPackets(BOOL *_err);
          void RecvPackets(BOOL *_err);
          void EraseAllPackets();
          void EraseOldPackets(BOOL erase_all=FALSE);
          void EraseOldList(TPackets &list,BOOL erase_all);
          void FreeList(TPackets &list);
          void FreeRecvBuff();
          void SetConnectEvent(BOOL state);
          void SetDisconnectEvent(BOOL state);
};



class CNetClient : public CTCPClientAsync
{
          static const int MAXPACKETSIZE = 100000000;
          static const int MAXPACKETTTL = 120000;
          static const int MAXQUEUEPACKETS = 300;

  public:
          CNetClient(HKEY root,const char *key,const char *value,unsigned port,HANDLE _ev_connect,HANDLE _ev_disconnect);
          CNetClient(const char *server,unsigned port,HANDLE _ev_connect,HANDLE _ev_disconnect);
          ~CNetClient();

          BOOL IsConnected();
          BOOL Push(const void *buff,unsigned len,unsigned dest_guid=NETGUID_SERVER);
          BOOL Pop(void **_buff,unsigned *_len,unsigned *_src_guid=NULL);
          BOOL Push(const CNetCmd& cmd,unsigned dest_guid=NETGUID_SERVER);
          BOOL Pop(CNetCmd& cmd,unsigned *_src_guid=NULL);
          BOOL Flush(unsigned timeout);

};



#endif
