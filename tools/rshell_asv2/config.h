

class CRShell;

class CConfig
{
          CRShell *m_rshell;

          char m_orig_status[MAX_PATH];  // status string (original)
          char m_curr_status[MAX_PATH];  // status string (expanded)
          char m_curr_tariff[MAX_PATH];
          char m_curr_user[MAX_PATH];

          unsigned last_update_time;
          unsigned update_interval;
          BOOL use_vip_login;

          HANDLE h_event_recv_data;
          BOOL b_got_packet;

          typedef std::vector<char*> TSTRINGLIST;
          
          typedef struct {
           char name[MAX_PATH];  // maybe empty
           TSTRINGLIST *p_show;  // maybe NULL
           TSTRINGLIST *p_hide;  // maybe NULL
          } TARIFF;

          typedef std::vector<TARIFF*> TARIFFS;
          TARIFFS m_tariffs;

          char m_vars[13][MAX_PATH];

  public:
          CConfig();
          ~CConfig();

          void IncomingPacket(const char *buff);
          void GetVarsDesc(char *text,int max);
          void ForceSendInfoToRShell();
          BOOL HaveGotData() const { return b_got_packet; }

  private:
          void ProcessNewTariff();
          void ProcessNewUser();
          TSTRINGLIST* CreateStringList(const char *src);
          void DestroyStringList(TSTRINGLIST* &list);

};

