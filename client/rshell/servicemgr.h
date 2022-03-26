
#ifndef __SERVICEMGR_H__
#define __SERVICEMGR_H__



class CServiceMgr
{
  public:
          static const unsigned MAX_T_INSTALL = 3000;
          static const unsigned MAX_T_START = 10000;
          static const unsigned MAX_T_STOP = 30000;

  private:        
          char *s_name;

  public:
          CServiceMgr(const char *name);
          ~CServiceMgr();

          const char* GetName() const { return s_name ? s_name : ""; }
          BOOL GetServiceStatus(DWORD *_state);

          BOOL InstallService(const char *display_name,
                              const char *path,
                              DWORD dwServiceType,
                              DWORD dwStartType = SERVICE_AUTO_START,
                              DWORD dwErrorControl = SERVICE_ERROR_NORMAL,
                              unsigned max_time_wait = MAX_T_INSTALL );
          BOOL UninstallService(unsigned max_time_wait = MAX_T_INSTALL);
          BOOL StartService(unsigned max_time_wait = MAX_T_START);
          BOOL StopService(unsigned max_time_wait = MAX_T_STOP);

          BOOL HighLevelInstall( const char *display_name,
                                 const char *path,
                                 DWORD dwServiceType,
                                 DWORD dwStartType = SERVICE_AUTO_START,
                                 DWORD dwErrorControl = SERVICE_ERROR_NORMAL,
                                 unsigned max_time_wait_install = MAX_T_INSTALL,
                                 unsigned max_time_wait_start = MAX_T_START );
          BOOL HighLevelUninstall( unsigned max_time_wait_stop = MAX_T_STOP,
                                   unsigned max_time_wait_uninstall = MAX_T_INSTALL );

};


class CDriverMgr : public CServiceMgr
{
  public:
          CDriverMgr(const char *name) : CServiceMgr(name) {}

          BOOL Install(const char *path);
          BOOL Uninstall();
};



#endif
