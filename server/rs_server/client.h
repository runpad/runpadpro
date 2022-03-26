
#ifndef __CLIENT_H__
#define __CLIENT_H__


#include <vector>

class CServer;
class CDBObj;

class CClient
{
          static const int MAGIC_ID = 0x13DB0AF7; // our TCP packets id
          static const unsigned max_packet_size = 100000000;
          static const unsigned max_queue_packets = 300;

          class CRecvBuff
          {
            protected:
                     friend class CClient;

                     char static_buff[2*4];
                     char *dynamic_buff;
                     unsigned dynamic_len;
                     unsigned recv_bytes;

            public:
                     CRecvBuff();
                     ~CRecvBuff();

            protected:
                     friend class CClient;

                     void ClearVars();
                     void Free();
          };

          class CPacket2Send
          {
                     unsigned src_guid;
                     CNetCmd *p_cmd;
            public:
                     CPacket2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned _guid);
                     ~CPacket2Send();

                     unsigned GetSrcGuid() const;
                     const CNetCmd* GetCmd() const;
          };

          CServer *p_server;
          CDBObj *p_db;

          int h_socket;
          int m_ip;
          unsigned m_guid;

          CNetCmd *p_env;

          HANDLE h_thread;
          HANDLE h_stop_event;

          CRecvBuff recv_buff;

          typedef std::vector<CPacket2Send*> TPackets;
          TPackets send_queue;

          CRITICAL_SECTION o_cs;

  public:
          CClient(CServer *_server,CDBObj *_db,int _socket,int _ip,unsigned _guid);
          ~CClient();

          BOOL IsActive() const;
          BOOL IsClassKnown() const;
          unsigned GetGUID() const;
          BOOL IsServer() const;
          BOOL IsUser() const;
          BOOL IsComputer() const;
          BOOL IsOperator() const;
          BOOL Push(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid);
          void AsyncTerminate();
          void GetCopyOfEnv(CNetCmd &env) const;

  private:
          static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
          DWORD ThreadProc();
          void TrySend(BOOL *_err);
          void TryRecv(BOOL *_err,unsigned &last_recv_time);
          void ProcessCommand(int cmd_id,const void *data_buff,unsigned data_size,unsigned dest_guid);
          void ProcessServerCommand(int cmd_id,const void *data_buff,unsigned data_size);
          void CleanupSendQueue();
          BOOL Push2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid);
          BOOL Push2Send(const CNetCmd &cmd,unsigned src_guid=NETGUID_SERVER);
          void GetFloatLicsFromFile(const char *filename,CNetCmd& _cmd);

};


#endif

