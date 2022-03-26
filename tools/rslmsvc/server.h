
#ifndef __SERVER_H__
#define __SERVER_H__



class CServer
{
          HANDLE h_stop_event;
          HANDLE h_thread;

          SOCKET h_socket;

          CRITICAL_SECTION o_cs;

          typedef std::pair<std::string,std::string> TStringPair;

          class CStringPairLessI
          {
            public:
                    bool operator () (const TStringPair& f1,const TStringPair& f2) const;
          };

          typedef std::map<TStringPair,OURTIME,CStringPairLessI> TMap;
          TMap m_map;

  public:
          CServer(int _port);
          ~CServer();

          void UpdateLic(const std::string& licname,const std::string& licidx,int delta_sec);
          void GetLicList(const std::string& licname,std::vector<std::string>& _list);

  private:
          static DWORD WINAPI AcceptThreadProcWrapper(LPVOID lpParameter);
          DWORD AcceptThreadProc();
          void AddClient(SOCKET _socket);
          void CleanupLics();
};



#endif
