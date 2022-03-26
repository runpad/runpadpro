
#ifndef __SERVER_H__
#define __SERVER_H__


#include <vector>

class CDBObj;
class CNetCmd;
class CClient;
class CUpdate;


class CServer
{
          static const unsigned CLIENT_UPDATE_DELTA = 30000;
          
          CNetCmd *p_env;
          CDBObj *p_db;

          CUpdate *p_client_update;
          unsigned last_client_update_time;
          CUpdate *p_client_update_no_shell;
          unsigned last_client_update_no_shell_time;
          
          HANDLE h_stop_event;
          HANDLE h_thread;
          int h_socket;

          typedef std::vector<CClient*> TClients;
          TClients clients;

          unsigned curr_guid;

          CRITICAL_SECTION o_cs;

  public:
          CServer();
          ~CServer();

  protected:
          friend class CClient;

          BOOL CanAddNewClass(const char *new_class,int ip,BOOL is_operator_shell);
          void Push2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid,unsigned dest_guid);
          void GetCopyOfEnv(CNetCmd &env,unsigned guid);
          void GetCopyOfAllEnv(CNetCmd &out);
          void GetClientUpdateList(BOOL is_no_shell,CNetCmd &out);
          void GetClientUpdateFiles(BOOL is_no_shell,const CNetCmd &in,CNetCmd &out);

  private:
          int GetNumActiveUsers();
          int GetNumActiveComputers();
          static DWORD WINAPI AcceptThreadProcWrapper(LPVOID lpParameter);
          DWORD AcceptThreadProc();
          void AddClient(int _socket,int _ip);
          void TerminateAndCleanupClients();
          void DoHeapCompact(unsigned &last_time);
          void DoClientsCleanup(unsigned &last_time);
          void TryRefreshClientUpdateCacheNoGuard(BOOL is_no_shell);

};



#endif
