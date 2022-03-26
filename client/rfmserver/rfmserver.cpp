// server_rfm.cpp : Точка входа в консольное приложение
//

#include "stdafx.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdio.h>
#include "RfmSocket.h"

// Имя сервиса в таблице сервисов
#define NAME_SERVICE "RunpadProRFMService"
#define DESC_SERVICE "Remote File Manager for Runpad Pro"
// Максимальное время ожидания выполнения команды с сервисов
#define MAX_TIME_WAIT 30000
// Имя сервиса в межпроцессном пространстве
#define NAME_SERVICE_EV_STOP "Global\\event_stop_runpadprorfmserver"

//#pragma warning(disable : 4996)
//#pragma warning(disable : 4800)


SERVICE_STATUS m_ServiceStatus;
SERVICE_STATUS_HANDLE m_ServiceStatusHandle;
BOOL g_bRunning = false;
BOOL g_bInstalled = false;
void WINAPI ServiceMain(DWORD argc, LPTSTR *argv);
void WINAPI ServiceCtrlHandler(DWORD Opcode);
BOOL InstallService();
BOOL DeleteService();
// Запуск сервиса
bool start_service(); 
//остановка службы
bool stop_service(); 

// Событие останова сервиса
HANDLE g_h_event_stop = NULL;




// Экземпляр управления сервером
CRfmSocket g_server_obj;



///////////////////////////////////////////////////////////////
// Параметры для настройки сервера
///////////////////////////////////////////////////////////////


// Имя сервера
#define NAME_SERVER _T("127.0.0.1") 
// Порт сервера
#define PORT_SERVER 13226
bool g_work_server = false;


// Определить статус сервиса для проверки

DWORD get_status_service()
{
	DWORD dwState = 0xFF; 
	
	// open the service control manager
    SC_HANDLE hSCM = OpenSCManager(NULL, NULL, STANDARD_RIGHTS_READ);

	   // open the service
    SC_HANDLE hService = OpenService( hSCM, NAME_SERVICE, SERVICE_QUERY_STATUS );
    
	if( hService ) 
	{
		
		
		// Get the current status
        SERVICE_STATUS ss;
        memset(&ss, 0, sizeof(ss));
        
		BOOL b = QueryServiceStatus( hService, &ss );
        
		if(!b) 
		{
            DWORD dwErr = GetLastError();
                        CloseServiceHandle( hService );
                        CloseServiceHandle( hSCM );
			return dwState;
		}
		else 
		{
            dwState = ss.dwCurrentState;

            // If the service is running, send a control request
            // to get its current status
            if (dwState == SERVICE_RUNNING) 
			{
                b = ::ControlService(hService, SERVICE_CONTROL_INTERROGATE, &ss );
                if( b) 
				{
					dwState = ss.dwCurrentState;
                }
            }
        }

        // close the service handle
        CloseServiceHandle( hService );
    }
	
    // close the service control manager handle
    CloseServiceHandle( hSCM );

	return dwState;
}



// Описание команд сервера 
// сервер принимает в командной строке параметр : start
// в процессе работы сервера, можно дать следующие команды: 
// start - запуск сервера
// stop  - останов сервера

int APIENTRY _tWinMain(HINSTANCE hInstance,
			  HINSTANCE hPrevInstance,
              LPTSTR lpCmdLine,
              int nCmdShow)
{

	std::string str_command = lpCmdLine;
	
	
	SECURITY_DESCRIPTOR SecDesc;
	SECURITY_ATTRIBUTES sa;

	InitializeSecurityDescriptor(&SecDesc, SECURITY_DESCRIPTOR_REVISION);
	SetSecurityDescriptorDacl(&SecDesc, TRUE, NULL, FALSE);

	sa.nLength = sizeof(sa);
	sa.lpSecurityDescriptor = &SecDesc;
	sa.bInheritHandle = FALSE;

	g_h_event_stop = ::CreateEvent(&sa, TRUE, FALSE, NAME_SERVICE_EV_STOP);
	
			
	// Инициализировать состояние сервиса

	DWORD dw_state_srv = get_status_service();	
	if(dw_state_srv == 0xFF)
	{
		g_bRunning = false; 
		g_bInstalled = false;
	}
	else
	{
		g_bInstalled = true;
		if(dw_state_srv == SERVICE_RUNNING)
			g_bRunning = true; 
	}


	// Если командная строка пустая, запускать сервис

	if(!str_command.size())
	{
		SERVICE_TABLE_ENTRY dispatchTable[] =
		{
			{ NAME_SERVICE, ( LPSERVICE_MAIN_FUNCTION) ServiceMain },
			{ NULL, NULL }
		};
		
		// Связь с CSM
		StartServiceCtrlDispatcher(dispatchTable);	
	}
	
	// Прверить команду в командной строке
	
	if(str_command.size())
	{
		if(str_command.find("-install", 0) != -1)
		{
			// Инсталлировать и запустить сервис
		
			DWORD dw_state = get_status_service();
			
			if(dw_state >= SERVICE_STOPPED && dw_state <= SERVICE_PAUSED)
			{
				if(!start_service())
				{
					if(str_command.find("-silent", 0) == -1)  
						MessageBoxA(NULL, "Невозможно запустить сервис!", "rfmserver", NULL);
				}
				else
				{
					g_bRunning = true; 
				}
			}
			else
			{
				if(InstallService())
				{
					// Запустить сервис
				
					if(g_bRunning)
					{
						//printf("Service is work\n");
					}
					else
					{
						if(!start_service())
						{
							if(str_command.find("-silent", 0) == -1)  
								MessageBoxA(NULL, "Невозможно запустить сервис!", "rfmserver", NULL);
						}
						else
						{
							g_bRunning = true; 
						}
					}
					g_bInstalled = true;
				}
				else
				{
					if(str_command.find("-silent", 0) == -1)  
						MessageBoxA(NULL, "Невозможно установить сервис!", "rfmserver", NULL);
				}
			}
		}
		else
		if(str_command.find("-uninstall", 0) != -1)
		{
			// Если сервер запущен, остановить и деинсталлировать
		
			if(!g_bRunning)
			{
				if(g_bInstalled)
				{
					if(!DeleteService())
					{
						if(str_command.find("-silent", 0) == -1 )  
							MessageBoxA(NULL, "Невозможно удалить сервис!", "rfmserver", NULL);
					}
					else
						g_bInstalled = false;
				}
			}
			else
			if(!stop_service())
			{
				if(str_command.find("-silent", 0) == -1)  
						MessageBoxA(NULL, "Невозможно остановить сервис!", "rfmserver", NULL);
			}
			else
			{
				if(!DeleteService())
				{
					if(str_command.find("-silent", 0) == -1)  
						MessageBoxA(NULL, "Невозможно удалить сервис!", "rfmserver", NULL);
					
				}
				else 
				{
					g_bInstalled = false;
				}
			
				g_bRunning = false; 		
			}
		}
		else
		if(str_command.find("-stop", 0) != -1)
		{
			// Остановить сервер
		
			if(!g_bRunning)
			{
				//printf("Service is stopped\n");
			}
			else
			if(!stop_service())
			{
				if(str_command.find("-silent", 0) == -1)  
					MessageBoxA(NULL, "Невозможно остановить сервис!", "rfmserver", NULL);
			}
			else
			{
				g_bRunning = false; 
			}
			
		}
		else
		if(str_command.find("-start", 0) != -1)
		{
			// Запустить север

			if(g_bRunning)
			{
				//printf("Service is work\n");
			}
			else
			if(!start_service())
			{
				if(str_command.find("-silent", 0) == -1)  
					MessageBoxA(NULL, "Невозможно запустить сервис!", "rfmserver", NULL);
			}
			else
			{
				g_bRunning = true; 	
			}
		}
	}

return 0;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//             Блок функций для работы с сервисом ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////

void WINAPI ServiceMain(DWORD argc, LPTSTR *argv)
{
	m_ServiceStatus.dwServiceType             = SERVICE_WIN32;
    m_ServiceStatus.dwCurrentState            = SERVICE_STOPPED;
    m_ServiceStatus.dwControlsAccepted        = 0;
    m_ServiceStatus.dwWin32ExitCode           = NO_ERROR;
    m_ServiceStatus.dwServiceSpecificExitCode = NO_ERROR;
    m_ServiceStatus.dwCheckPoint              = 0;
    m_ServiceStatus.dwWaitHint                = 0;


	// регистрация функции контроля службой 
    m_ServiceStatusHandle = RegisterServiceCtrlHandler( NAME_SERVICE, ServiceCtrlHandler );
   
	 if ( m_ServiceStatusHandle )
     {
         m_ServiceStatus.dwCurrentState = SERVICE_START_PENDING;
         SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );

		 // Запустить сервер

		 if(!g_server_obj.StartServer(NAME_SERVER, PORT_SERVER))
			 return; // НЕУДАЧА! Не удалось запустить сервер 

         m_ServiceStatus.dwControlsAccepted |= ( SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN );
         m_ServiceStatus.dwCurrentState      = SERVICE_RUNNING;
         SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );
	
		 // Ожидаем остановку сервиса
		 
		 while(WaitForSingleObject(g_h_event_stop, 0) != WAIT_OBJECT_0)
		 {
			Sleep(50);
			m_ServiceStatus.dwCurrentState      = SERVICE_RUNNING;
			SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );
		 }

		 m_ServiceStatus.dwCurrentState = SERVICE_STOP_PENDING;
         SetServiceStatus(m_ServiceStatusHandle, &m_ServiceStatus );

		 //Операции по останову 

		 g_server_obj.StopServer();	

         m_ServiceStatus.dwControlsAccepted &= ~( SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN );
         m_ServiceStatus.dwCurrentState      = SERVICE_STOPPED;
         SetServiceStatus(m_ServiceStatusHandle, &m_ServiceStatus);

	 }
}

void WINAPI ServiceCtrlHandler(DWORD Opcode)
{
	switch ( Opcode )
     {
        case SERVICE_CONTROL_INTERROGATE:
            break;

        case SERVICE_CONTROL_PAUSE:
		case SERVICE_CONTROL_SHUTDOWN:
        case SERVICE_CONTROL_STOP:
			m_ServiceStatus.dwCurrentState = SERVICE_STOP_PENDING;
            SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );
			g_bRunning = false;
			SetEvent(g_h_event_stop);
			//g_nrserviceCom.StopReaddata(); 	
            //LowLog( "Получено от системы сообщение останова" );
			return;
        case SERVICE_CONTROL_CONTINUE:
            g_bRunning = true;
			ResetEvent(g_h_event_stop);
			//m_ServiceStatus.dwCurrentState = SERVICE_RUNNING;
            //SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );
		default:
			break;
    }

    SetServiceStatus( m_ServiceStatusHandle, &m_ServiceStatus );
}

BOOL InstallService()
{
	char strDir[1024];
	HANDLE schSCManager,schService;

        GetModuleFileName(GetModuleHandle(NULL),strDir,sizeof(strDir));

	schSCManager = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);

	if (schSCManager == NULL) 
		return false;
	LPCTSTR lpszBinaryPathName=strDir;

	schService = CreateService((SC_HANDLE)schSCManager, NAME_SERVICE, 
     DESC_SERVICE,
	 SERVICE_ALL_ACCESS,
	 SERVICE_WIN32_OWN_PROCESS | SERVICE_INTERACTIVE_PROCESS,
	 SERVICE_AUTO_START,
	 SERVICE_ERROR_NORMAL,
	 lpszBinaryPathName,
	 NULL,
	 NULL,
	 NULL,
	 NULL,
	 NULL);

	if (schService == NULL)
		return false; 

	// Ожидать установки сервиса

	DWORD dw_counter = 0;
	while(get_status_service() == 0xFF && dw_counter < MAX_TIME_WAIT)
	{
		Sleep(1000);
		dw_counter += 1000;
	}
	
	CloseServiceHandle((SC_HANDLE)schService);
		return true;
}

BOOL DeleteService()
{
	HANDLE schSCManager;
	SC_HANDLE hService;
	schSCManager = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);

	if (schSCManager == NULL)
		return false;
	hService=OpenService((SC_HANDLE)schSCManager, NAME_SERVICE, SERVICE_ALL_ACCESS);
	if (hService == NULL)
		return false;
	if(DeleteService(hService)==0)
		return false;
	if(CloseServiceHandle(hService)==0)
		return false;
	return true;
}

// Запуск сервиса

bool start_service() 
{
	if(g_bRunning)
		return true;

	bool b_ret_start = false;
	ResetEvent(g_h_event_stop);	

	// open the service control manager
    
	SC_HANDLE hSCM = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );
     // open the service
    SC_HANDLE hService = OpenService( hSCM, NAME_SERVICE, SERVICE_ALL_ACCESS );
    
    // start the service
    BOOL b;
	
	//if(get_status_service() == SERVICE_STOPPED)
	//{
		//continue
	//	SERVICE_STATUS ss;
	//	b = ControlService( hService, SERVICE_CONTROL_CONTINUE, &ss );	
	//}
	//else
		//start
		b = StartService( hService, 0, NULL );
		
	b_ret_start = b; 
	if(b_ret_start)
	{
		// Ожидать старта сервиса
		
		DWORD dw_counter = 0;
		while(get_status_service() != SERVICE_RUNNING && dw_counter < MAX_TIME_WAIT)
		{
			Sleep(1000);
			dw_counter += 1000;
		}
	}


    // close the service handle
    CloseServiceHandle( hService );

    // close the service control manager handle
    CloseServiceHandle( hSCM );

	return b_ret_start;
	
}

//остановка службы

bool stop_service() 
{
	SetEvent(g_h_event_stop);

	// Ожидать останова сервиса
		
	DWORD dw_counter = 0;
	while(get_status_service() != SERVICE_STOPPED && dw_counter < MAX_TIME_WAIT)
	{
		Sleep(1000);
		dw_counter += 1000;
	}

		
	/*	
	bool b_ret_stop = false;
	
	// open the service control manager
    SC_HANDLE hSCM = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );
    // open the service
    SC_HANDLE hService = OpenService( hSCM, NAME_SERVICE, SERVICE_ALL_ACCESS );
    
    SERVICE_STATUS ssQuery;
	QueryServiceStatus( hService, &ssQuery );
	// stop the service
    
	
	
	if( ssQuery.dwCurrentState == SERVICE_RUNNING || ssQuery.dwCurrentState == SERVICE_CONTROL_CONTINUE )
	{
		SERVICE_STATUS ss;
		BOOL b = ControlService( hService, SERVICE_CONTROL_STOP, &ss );
		b_ret_stop = b;
	}
	else
		b_ret_stop = true;

	if(b_ret_stop)
	{
		// Ожидать останова сервиса
		
		DWORD dw_counter = 0;
		while(get_status_service() != SERVICE_STOPPED && dw_counter < MAX_TIME_WAIT)
		{
			Sleep(1000);
			dw_counter += 1000;
		}
	}

    // close the service handle
    CloseServiceHandle( hService );

    // close the service control manager handle
    CloseServiceHandle( hSCM );
*/	
	return true;
}

