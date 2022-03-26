
#ifndef __NET_H__
#define __NET_H__


class CNetClient;
class CUpdate;
class CConfigurator;


class CNetObj
{
         HANDLE h_ev_connect;
         CNetClient *p_net;
         CUpdate *p_upd;

         HANDLE h_thread;
         HANDLE h_ev_finish;
         
         int machine_type;
         TSTRING machine_loc;
         TSTRING machine_desc;
         OURTIME time_to_resend_classname;

         CConfigurator *p_cfg;

  public:
         CNetObj();
         ~CNetObj();

  private:       
         static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
         DWORD ThreadProc();
         BOOL NetSend(const CNetCmd& cmd,unsigned dest_guid=NETGUID_SERVER);
         BOOL NetGet(CNetCmd& cmd,unsigned *_src_guid=NULL);
         BOOL NetFlush(unsigned timeout);
         BOOL NetIsConnected();
         BOOL IsConnectEvent();
         void PollServer(unsigned &last_poll_time,BOOL &old_rfm,BOOL &old_rd);
         void SendStaticInfoToServer();
         void OnNetCmdReceived(const CNetCmd &cmd,unsigned src_guid);
         void OnCfgReceived();
         void SetRollbackParmsInternal(int disks,const TCFGLIST1& exlist);

  protected:
         friend class CUpdate;
         
         void SendDynamicInfoToServer();

};


#endif
