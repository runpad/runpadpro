
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


BOOL CServiceManager::GetServiceStatus(DWORD *_state)
{
  BOOL rc = FALSE;

  if ( _state )
     *_state = -1;
  
  SC_HANDLE scm = OpenSCManager(NULL,NULL,STANDARD_RIGHTS_READ);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,m_service->GetName(),GENERIC_READ);
       if ( h )
          {
            SERVICE_STATUS ss;
            ZeroMemory(&ss,sizeof(ss));
            if ( QueryServiceStatus(h,&ss) )
               {
                 if ( ss.dwCurrentState == SERVICE_RUNNING )
                    {
                      SERVICE_STATUS ss;
                      ZeroMemory(&ss,sizeof(ss));
                      if ( ControlService(h,SERVICE_CONTROL_INTERROGATE,&ss) )
                         {
                           if ( _state )
                              *_state = ss.dwCurrentState;
                         }
                      else
                         {
                           if ( _state )
                              *_state = SERVICE_RUNNING;
                         }
                    }
                 else
                    {
                      if ( _state )
                         *_state = ss.dwCurrentState;
                    }

                 rc = TRUE;
               }

            CloseServiceHandle(h);
          }

       CloseServiceHandle(scm);
     }

  return rc;
}



BOOL CServiceManager::InstallService()
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       char exe[MAX_PATH] = "";
       HINSTANCE instance = GetModuleHandle(NULL);
       GetModuleFileName(instance,exe,sizeof(exe));
       
       SC_HANDLE h = CreateService(scm,
                                   m_service->GetName(),
                                   m_service->GetDisplayName(),
                                   SERVICE_ALL_ACCESS,
                                   SERVICE_WIN32_OWN_PROCESS | (m_service->IsInteractive() ? SERVICE_INTERACTIVE_PROCESS : 0),
                                   SERVICE_AUTO_START,
                                   SERVICE_ERROR_NORMAL,
                                   exe,
                                   NULL, NULL, NULL, NULL, NULL );
       if ( h )
          {
            int counter = 0;
            while ( !GetServiceStatus(NULL) && counter < MAX_TIME_WAIT_INSTALL )
            {
              Sleep(1000);
              counter += 1000;
            };

            rc = GetServiceStatus(NULL);

            CloseServiceHandle(h);
          }
       else
          {
            if ( GetLastError() == ERROR_SERVICE_EXISTS )
               {
                 rc = TRUE;
               }
          }

       CloseServiceHandle(scm);
     }

  return rc;
}


BOOL CServiceManager::UninstallService()
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,m_service->GetName(),DELETE);
       if ( h )
          {
            if ( DeleteService(h) )
               {
                 rc = TRUE;
               }
            else
               {
                 if ( GetLastError() == ERROR_SERVICE_MARKED_FOR_DELETE )
                    {
                      rc = TRUE;
                    }
               }

            CloseServiceHandle(h);

            if ( rc )
               {
                 int counter = 0;
                 while ( GetServiceStatus(NULL) && counter < MAX_TIME_WAIT_UNINSTALL )
                 {
                   Sleep(1000);
                   counter += 1000;
                 };

                 rc = !GetServiceStatus(NULL);
               }
          }
       else
          {
            if ( GetLastError() == ERROR_SERVICE_DOES_NOT_EXIST )
               {
                 rc = TRUE;
               }
          }

       CloseServiceHandle(scm);
     }

  return rc;
}


BOOL CServiceManager::StartService()
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,m_service->GetName(),SERVICE_START);
       if ( h )
          {
            if ( ::StartService(h,0,NULL) )
               {
                 int counter = 0;
                 while ( counter < MAX_TIME_WAIT_START )
                 {
                   DWORD state = -1;
                   
                   if ( GetServiceStatus(&state) && state == SERVICE_RUNNING )
                      {
                        rc = TRUE;
                        break;
                      }
                   
                   Sleep(1000);
                   counter += 1000;
                 };
               }
            else
               {
                 if ( GetLastError() == ERROR_SERVICE_ALREADY_RUNNING )
                    {
                      rc = TRUE;
                    }
               }

            CloseServiceHandle(h);
          }

       CloseServiceHandle(scm);
     }

  return rc;
}


BOOL CServiceManager::StopService()
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,m_service->GetName(),SERVICE_STOP);
       if ( h )
          {
            DWORD state = -1;
            
            if ( GetServiceStatus(&state) && state == SERVICE_STOPPED )
               {
                 rc = TRUE;
               }
            else
               {
                 SERVICE_STATUS ss;
                 ZeroMemory(&ss,sizeof(ss));
                 if ( ControlService(h,SERVICE_CONTROL_STOP,&ss) )
                    {
                      int counter = 0;
                      while ( counter < MAX_TIME_WAIT_STOP )
                      {
                        DWORD state = -1;
                        
                        if ( GetServiceStatus(&state) && state == SERVICE_STOPPED )
                           {
                             rc = TRUE;
                             break;
                           }
                        
                        Sleep(1000);
                        counter += 1000;
                      };
                    }
               }

            CloseServiceHandle(h);
          }
       else
          {
            if ( GetLastError() == ERROR_SERVICE_DOES_NOT_EXIST )
               {
                 rc = TRUE;
               }
          }

       CloseServiceHandle(scm);
     }

  return rc;
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
  
  m_ss.dwServiceType = SERVICE_WIN32_OWN_PROCESS | (m_service->IsInteractive() ? SERVICE_INTERACTIVE_PROCESS : 0);
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


BOOL CServiceManager::HighLevelInstall()
{
  BOOL rc = FALSE;

  if ( InstallService() )
     {
       if ( StartService() )
          {
            rc = TRUE;
          }
       else
          {
            UninstallService();
          }
     }

  return rc;
}


BOOL CServiceManager::HighLevelUninstall()
{
  BOOL rc = FALSE;

  if ( StopService() )
     {
       if ( UninstallService() )
          {
            rc = TRUE;
          }
       else
          {
            StartService();
          }
     }

  return rc;
}


BOOL CServiceManager::HighLevelProcess()
{
  BOOL rc = FALSE;
  
  DWORD state = -1;
  if ( GetServiceStatus(&state) && state == SERVICE_RUNNING )
     {
       rc = TRUE;
     }
  else
     {
       if ( StartCtrlDispatcher() )
          {
            rc = TRUE;
          }
     }

  return rc;
}

