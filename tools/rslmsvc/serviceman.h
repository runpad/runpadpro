
#ifndef __SERVICEMAN_H__
#define __SERVICEMAN_H__



class CService
{
  public:
          virtual ~CService() {}

          virtual BOOL Start() = 0;
          virtual BOOL Stop() = 0;
          virtual BOOL IsExecuted() const = 0;
};


class CServiceManager
{
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

           BOOL HighLevelProcess();

  protected:
           BOOL StartCtrlDispatcher();

  private:
           static void WINAPI ServiceMainWrapper(DWORD dwArgc,LPTSTR* lpszArgv);
           static CServiceManager* GetSelf();
           void ServiceMain(DWORD dwArgc,LPTSTR* lpszArgv);
           static void WINAPI ServiceCtrlHandlerWrapper(DWORD fdwControl);
           void ServiceCtrlHandler(DWORD fdwControl);
};



#endif

