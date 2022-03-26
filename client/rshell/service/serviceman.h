
#ifndef __SERVICEMAN_H__
#define __SERVICEMAN_H__



class CService
{
  public:
          CService() {}
          virtual ~CService() {}

          virtual const char* GetName() const = 0;
          virtual const char* GetDisplayName() const = 0;
          virtual BOOL IsInteractive() const = 0;
          virtual BOOL Start() = 0;
          virtual BOOL Stop() = 0;
          virtual BOOL IsExecuted() const = 0;
};


class CServiceManager
{
           static const int MAX_TIME_WAIT_INSTALL = 5000;
           static const int MAX_TIME_WAIT_UNINSTALL = 2000;
           static const int MAX_TIME_WAIT_START = 10000;
           static const int MAX_TIME_WAIT_STOP = 30000;
           
           static CServiceManager* self;

           CService *m_service;
           SERVICE_STATUS m_ss;
           SERVICE_STATUS_HANDLE m_ssh;
           HANDLE m_stop_event;

  public:
           CServiceManager(CService *obj);
           ~CServiceManager();

  public:
           static CServiceManager* Create(CService *obj);
           void Release();

           BOOL HighLevelInstall();
           BOOL HighLevelUninstall();
           BOOL HighLevelProcess();
           
  protected:
           BOOL GetServiceStatus(DWORD *_state);
           BOOL InstallService();
           BOOL UninstallService();
           BOOL StartService();
           BOOL StopService();
           BOOL StartCtrlDispatcher();

  private:
           static void WINAPI ServiceMainWrapper(DWORD dwArgc,LPTSTR* lpszArgv);
           static CServiceManager* GetSelf();
           void ServiceMain(DWORD dwArgc,LPTSTR* lpszArgv);
           static void WINAPI ServiceCtrlHandlerWrapper(DWORD fdwControl);
           void ServiceCtrlHandler(DWORD fdwControl);
};



#endif

