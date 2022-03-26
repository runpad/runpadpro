
#include "include.h"



CServiceMgr::CServiceMgr(const char *name)
{
  s_name = sys_copystring(name);
}


CServiceMgr::~CServiceMgr()
{
  if ( s_name )
     sys_free(s_name);
}


BOOL CServiceMgr::GetServiceStatus(DWORD *_state)
{
  BOOL rc = FALSE;

  if ( _state )
     *_state = -1;
  
  SC_HANDLE scm = OpenSCManager(NULL,NULL,STANDARD_RIGHTS_READ);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,GetName(),GENERIC_READ);
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


BOOL CServiceMgr::InstallService(const char *display_name,
                                     const char *path,
                                     DWORD dwServiceType,
                                     DWORD dwStartType,
                                     DWORD dwErrorControl,
                                     unsigned max_time_wait )
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = CreateService(scm,
                                   GetName(),
                                   display_name ? display_name : GetName(),
                                   SERVICE_ALL_ACCESS,
                                   dwServiceType,
                                   dwStartType,
                                   dwErrorControl,
                                   path,
                                   NULL, NULL, NULL, NULL, NULL );
       if ( h )
          {
            unsigned counter = 0;
            while ( !GetServiceStatus(NULL) && counter < max_time_wait )
            {
              Sleep(10);
              counter += 10;
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


BOOL CServiceMgr::UninstallService(unsigned max_time_wait)
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,GetName(),DELETE);
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
                 unsigned counter = 0;
                 while ( GetServiceStatus(NULL) && counter < max_time_wait )
                 {
                   Sleep(10);
                   counter += 10;
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


BOOL CServiceMgr::StartService(unsigned max_time_wait)
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,GetName(),SERVICE_START);
       if ( h )
          {
            if ( ::StartService(h,0,NULL) )
               {
                 unsigned counter = 0;
                 do {
                   DWORD state = -1;
                   if ( GetServiceStatus(&state) && state == SERVICE_RUNNING )
                      {
                        rc = TRUE;
                        break;
                      }

                   if ( counter >= max_time_wait )
                      break;
                      
                   Sleep(50);
                   counter += 50;
                 } while ( 1 );
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


BOOL CServiceMgr::StopService(unsigned max_time_wait)
{
  BOOL rc = FALSE;

  SC_HANDLE scm = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);
  if ( scm )
     {
       SC_HANDLE h = OpenService(scm,GetName(),SERVICE_STOP);
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
                      unsigned counter = 0;
                      do {
                        DWORD state = -1;
                        if ( GetServiceStatus(&state) && state == SERVICE_STOPPED )
                           {
                             rc = TRUE;
                             break;
                           }

                        if ( counter >= max_time_wait )
                           break;
                        
                        Sleep(50);
                        counter += 50;
                      } while ( 1 );
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


BOOL CServiceMgr::HighLevelInstall( const char *display_name,
                                        const char *path,
                                        DWORD dwServiceType,
                                        DWORD dwStartType,
                                        DWORD dwErrorControl,
                                        unsigned max_time_wait_install,
                                        unsigned max_time_wait_start )
{
  BOOL rc = FALSE;

  if ( InstallService(display_name,path,dwServiceType,dwStartType,dwErrorControl,max_time_wait_install) )
     {
       if ( StartService(max_time_wait_start) )
          {
            rc = TRUE;
          }
       else
          {
            //UninstallService(max_time_wait_install);
          }
     }

  return rc;
}


BOOL CServiceMgr::HighLevelUninstall( unsigned max_time_wait_stop,
                                          unsigned max_time_wait_uninstall )
{
  BOOL rc = FALSE;

  if ( StopService(max_time_wait_stop) )
     {
       if ( UninstallService(max_time_wait_uninstall) )
          {
            rc = TRUE;
          }
       else
          {
            //StartService();
          }
     }

  return rc;
}


BOOL CDriverMgr::Install(const char *path)
{
  return HighLevelInstall( GetName(), path, SERVICE_KERNEL_DRIVER );
}


BOOL CDriverMgr::Uninstall()
{
  return HighLevelUninstall();
}


