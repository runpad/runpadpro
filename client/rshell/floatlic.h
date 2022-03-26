
#ifndef __FLOATLIC_H__
#define __FLOATLIC_H__

#include <string>
#include <vector>


class CFloatLicSingle
{
          std::string m_envname;
          std::string m_envvalue;
          std::string m_licname;
          int m_licidx;
          int m_pid;
          std::string m_exelist;
          BOOL b_is_steam;
          std::string m_server;
          unsigned m_last_poll_time;
          OURTIME m_starttime;
          unsigned m_exedelayload;

  protected:
          friend class CFloatLic;
          
          CFloatLicSingle(const char *envname,const char *envvalue,const char *licname,int licidx,const char *exes,BOOL steam,const char *server,unsigned exedelayload);
          ~CFloatLicSingle();

          BOOL IsLicNameEqu(const char *licname) const;
          int GetLicIdx() const { return m_licidx; }
          BOOL IsSteam() const { return b_is_steam; }

          BOOL Poll(BOOL &_is_dead);
          void SendServerBusyRequest(unsigned timeout_sec) const;

  public:
          void SetPid(int pid) { m_pid = pid; }
          void SetEnvForThisProcess() const;
          void ClearEnvForThisProcess() const;

  private:
          BOOL IsDead() const;
};


class CFloatLic
{
          static CFloatLic g_floatlicman;  // our singletone
          
          int m_uid;
          std::vector<CFloatLicSingle*> m_list;
          BOOL b_executed;

          // these vars are used only in Execute():
          std::string m_licname;
          std::string m_server;
          std::string m_exelist;
          BOOL b_is_steam;
          unsigned m_keeptime;
          unsigned m_exedelayload;
          BOOL b_do_not_promt;
          typedef std::pair<BOOL,std::string> TSingleLicInfo;
          std::vector<TSingleLicInfo> m_lics;
          BOOL b_lics_recvd;
          HWND m_wnd;

          typedef struct {
           CFloatLic *obj;
           const std::vector<int> *list;
           int def_idx;
           int timeout_sec;
          } TLICSELINFO;

  public:
          CFloatLic();
          ~CFloatLic();

          static void Poll();
          static void Add(CFloatLicSingle *i);
          static CFloatLicSingle* Execute(const char *serverpath,const char *envname);
          static void OnServerAck(const CNetCmd& cmd);
          static void OnClientReq(const CNetCmd& cmd,unsigned src_guid);
          static void OnClientAck(const CNetCmd& cmd);
          static void ShutdownSteamAndSteamLicsWait();

  private:
          static CFloatLic& GetObj() { return g_floatlicman; }
          
          void _Poll();
          void _Add(CFloatLicSingle *i);
          CFloatLicSingle* _Execute(const char *serverpath,const char *envname);
          void _OnServerAck(const CNetCmd& cmd);
          void _OnClientReq(const CNetCmd& cmd,unsigned src_guid);
          void _OnClientAck(const CNetCmd& cmd);
          void _ShutdownSteamAndSteamLicsWait();

  private:
          static BOOL CALLBACK DlgProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          BOOL DlgProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          static BOOL CALLBACK DlgSelProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          BOOL DlgSelProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
};




#endif
