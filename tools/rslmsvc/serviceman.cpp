
#include "include.h"



CServiceManager* CServiceManager::self = NULL;


CServiceManager* CServiceManager::Create(CService *obj)
{
  if ( !self )
     {
       self = new CServiceManager(obj);
       return self;
     }

  return NULL;
}


void CServiceManager::Release()
{
  self = NULL;
  delete this;
}


CServiceManager* CServiceManager::GetSelf()
{
  return self;
}


CServiceManager::CServiceManager(CService *obj)
{
  m_service = obj;

  ZeroMemory(&m_ss,sizeof(m_ss));
  m_ssh = NULL;
  m_stop_event = NULL;
}


CServiceManager::~CServiceManager()
{
  if ( m_stop_event )
     {
       CloseHandle(m_stop_event);
     }
}


BOOL CServiceManager::StartCtrlDispatcher()
{
  BOOL rc = FALSE;
  
  const SERVICE_TABLE_ENTRY dispatchTable[] =
  {
    { "", ServiceMainWrapper },
    { NULL, NULL }
  };

  if ( StartServiceCtrlDispatcher(dispatchTable) )
     {
       rc = TRUE;
     }
  else
     {
       if ( GetLastError() == ERROR_SERVICE_ALREADY_RUNNING )
          {
            rc = TRUE;
          }
     }

  return rc;
}


void WINAPI CServiceManager::ServiceMainWrapper(DWORD dwArgc,LPTSTR* lpszArgv)
{
  GetSelf()->ServiceMain(dwArgc,lpszArgv);
}


void CServiceManager::ServiceMain(DWORD dwArgc,LPTSTR* lpszArgv)
{
  m_stop_event = CreateEvent(NULL,FALSE,FALSE,NULL);
  
  m_ss.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
  m_ss.dwCurrentState = SERVICE_STOPPED;
  m_ss.dwControlsAccepted = 0;
  m_ss.dwWin32ExitCode = NO_ERROR;
  m_ss.dwServiceSpecificExitCode = NO_ERROR;
  m_ss.dwCheckPoint = 0;
  m_ss.dwWaitHint = 0;

  m_ssh = RegisterServiceCtrlHandler("",ServiceCtrlHandlerWrapper);
  if ( m_ssh )
     {
       m_ss.dwCurrentState = SERVICE_START_PENDING;
       m_ss.dwControlsAccepted = 0;
       m_ss.dwWaitHint = MAX_TIME_WAIT_START;
       SetServiceStatus(m_ssh,&m_ss);

       if ( m_service->Start() )
          {
            m_ss.dwCurrentState = SERVICE_RUNNING;
            m_ss.dwControlsAccepted = SERVICE_ACCEPT_SHUTDOWN | SERVICE_ACCEPT_STOP;
            m_ss.dwWaitHint = 0;
            SetServiceStatus(m_ssh,&m_ss);

            while ( 1 )
            {
              if ( !m_service->IsExecuted() )
                 {
                   m_ss.dwCurrentState = SERVICE_STOP_PENDING;
                   m_ss.dwWaitHint = MAX_TIME_WAIT_STOP;
                   SetServiceStatus(m_ssh,&m_ss);
                   break;
                 }

              if ( WaitForSingleObject(m_stop_event,0) == WAIT_OBJECT_0 )
                 break;
              
              //m_ss.dwCurrentState = SERVICE_RUNNING;
              SetServiceStatus(m_ssh,&m_ss);

              Sleep(100);
            };

            m_service->Stop();

            m_ss.dwCurrentState = SERVICE_STOPPED;
            m_ss.dwControlsAccepted = 0;
            m_ss.dwWaitHint = 0;
            SetServiceStatus(m_ssh,&m_ss);
          }
       else
          {
            m_ss.dwCurrentState = SERVICE_STOPPED;
            m_ss.dwControlsAccepted = 0;
            SetServiceStatus(m_ssh,&m_ss);
          }
     }

  CloseHandle(m_stop_event);
  m_stop_event = NULL;
}


void WINAPI CServiceManager::ServiceCtrlHandlerWrapper(DWORD fdwControl)
{
  GetSelf()->ServiceCtrlHandler(fdwControl);
}


void CServiceManager::ServiceCtrlHandler(DWORD fdwControl)
{
  switch ( fdwControl )
  {
    case SERVICE_CONTROL_INTERROGATE:
                                      break;

    case SERVICE_CONTROL_SHUTDOWN:
    case SERVICE_CONTROL_STOP:
                                      m_ss.dwCurrentState = SERVICE_STOP_PENDING;
                                      m_ss.dwWaitHint = MAX_TIME_WAIT_STOP;
                                      SetEvent(m_stop_event);
                                      break;
  };

  SetServiceStatus(m_ssh,&m_ss);
}


BOOL CServiceManager::HighLevelProcess()
{
  return StartCtrlDispatcher();
}

