#include "StdAfx.h"
#include "RfmSocket.h"
#include "c_TransportLevel.h"
#include <shlwapi.h>
#include "global.h"

#define MAX_TIME_WAIT 10000 // Максимальное время, через кот орое осуществляется передача события  на транспортный уровень



CRfmSocket::CRfmSocket(void)
{
	m_listening_sock = INVALID_SOCKET;
	::InitializeCriticalSection(&m_cs_clients);
	m_i_id_guid = 1000;
	m_h_thread_mtc = NULL;
	m_i_id_thread_mtc = 0;
	m_h_disconnect_client = ::CreateEvent(NULL, FALSE, FALSE, NULL);
	m_i_id_delete_cl = 0;

	// Инициализировать библиотеку
	WSADATA wd = {0};
	if(WSAStartup(MAKEWORD(2, 2), &wd) != 0)
		throw; 
}

CRfmSocket::~CRfmSocket(void)
{
	//StopServer();
	::DeleteCriticalSection(&m_cs_clients);
	::CloseHandle(m_h_disconnect_client);
	WSACleanup();
}


void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def)
{
  HKEY h;
  DWORD len = MAX_PATH;

  lstrcpy(data,def);
  
  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       if ( RegQueryValueEx(h,value,NULL,NULL,(LPBYTE)data,&len) == ERROR_SUCCESS )
          data[len] = 0;
       RegCloseKey(h);
     }
}


BOOL IsIPInList(const char *ext,const char *list)
{
  if ( !ext || !ext[0] )
     return FALSE;

  if ( !list || !list[0] )
     return FALSE;

  char *s_ext = (char*)malloc(strlen(ext)+20);
  char *s_list = (char*)malloc(strlen(list)+20);
     
  sprintf(s_ext,";%s;",ext);
  sprintf(s_list,";%s;",list); //long maybe

  BOOL rc = (StrStrI(s_list,s_ext) != NULL);

  free(s_list);
  free(s_ext);

  return rc;
}


BOOL IsClientAllowed(int client_ip)
{
  if ( client_ip == 0x0100007f )
     return TRUE;

  char s[MAX_PATH];
  ReadRegStr(HKEY_LOCAL_MACHINE,REGPATH,"allowed_services_ips",s,"");

  if ( !s[0] )
     return TRUE;

  char s_ip[MAX_PATH];
  unsigned char v_ip[4];

  *(int*)v_ip = client_ip;

  sprintf(s_ip,"%d.%d.%d.%d",v_ip[0],v_ip[1],v_ip[2],v_ip[3]);

  return IsIPInList(s_ip,s);
}




// Функция работающая в потоке и ожидающая новых 
// подключений клиентов

DWORD WINAPI thread_accepting(LPVOID lp_param)
{
	CRfmSocket *p_rfm_socket = (CRfmSocket*)lp_param;
	if(!p_rfm_socket) return 1;
	
	SOCKET temp_sock; 
	struct sockaddr_in s_in;
	
	// Цикл, ожидающий подключения 

	while(1) 
	{
		// Принять новое подключение если оно имеется
    	        int i_s_in_len = sizeof(struct sockaddr_in);

		temp_sock = accept(p_rfm_socket->get_socket_listen(), (struct sockaddr*)&s_in, &i_s_in_len);
		if(temp_sock != INVALID_SOCKET) 
		{
			if(p_rfm_socket->check_same_client(s_in, i_s_in_len) ||
			   !IsClientAllowed(s_in.sin_addr.s_addr))
			{
			        shutdown(temp_sock,SD_BOTH);
				closesocket(temp_sock);
			}
			else
			{
				// Добавить нового клиента
				
				p_rfm_socket->add_new_client(temp_sock, s_in, i_s_in_len);
			}
		}
		else
		    Sleep(100); //break;
	}
	
	return 0;
}

// Функция работающая в потоке. Выполняет дополнительное
// обслуживание

DWORD WINAPI thread_maintenance(LPVOID lp_param)
{
	CRfmSocket *p_rfm_socket = (CRfmSocket*)lp_param;
	if(!p_rfm_socket) return 1;
	
	while(1)
	{
		// Ожидать сообщения... 
		
		DWORD i_res =  ::WaitForSingleObject(p_rfm_socket->get_event_disconnect(), MAX_TIME_WAIT);
		if(i_res != WAIT_TIMEOUT)
		{
			p_rfm_socket->delete_client(p_rfm_socket->get_id_delete_client());

			Sleep(20);
		}
		
	}

	return 0;
}


// Старт сервера 
// p_name_server - имя сервера
// i_port - порт сервера

bool CRfmSocket::StartServer(const char* p_name_server, unsigned short i_port)
{
	int i_error = 0; 
	struct sockaddr_in sin;
	int i_on = 1;

	// Создать сокет

	m_listening_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(m_listening_sock == INVALID_SOCKET)
		return false;

	// Установить одновременное использование сокетами несколькими приложениями 
	
	//if(setsockopt(m_listening_sock, SOL_SOCKET, SO_REUSEADDR, (char*)&i_on, sizeof(i_on)) == SOCKET_ERROR)
	//	return false;

	// Связать сокет с адресом

	sin.sin_family = AF_INET;
	sin.sin_addr.s_addr = INADDR_ANY;
	sin.sin_port = htons((short)i_port);

	if(bind(m_listening_sock, (SOCKADDR*)&sin, sizeof(sin)) == SOCKET_ERROR)
		return false;

	// Начать прослушку сокета

	if(listen(m_listening_sock, 0) == SOCKET_ERROR)
		return false;

	// Запустить поток приема клиентов

	m_h_thread = ::CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)thread_accepting, (LPVOID)this, NULL, &m_i_id_thread);
	if(!m_h_thread)
		return false;

	// Запустить поток обслуживания

	m_h_thread_mtc = ::CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)thread_maintenance, (LPVOID)this, NULL, &m_i_id_thread_mtc);
	if(!m_h_thread_mtc)
		return false;

	return true;
}

//////////////////////////////////////////////////////////
//void write_log(const char *p_str)
//{
//	if(!p_str) return;
//	
//	FILE *p_file = fopen("C:\\log_srv_222.txt", "a");
//	if(!p_file) return;
//	fprintf(p_file, "%s", p_str);
//	fclose(p_file);
//}
//////////////////////////////////////////////////////////


// Останов сервера 

bool CRfmSocket::StopServer()
{		
	// Удалить все соединения с клиентами
	delete_clients_all();
	
	::TerminateThread(m_h_thread, 0x0);
	::CloseHandle(m_h_thread);
	m_h_thread = NULL;

	::TerminateThread(m_h_thread_mtc, 0x0);
	::CloseHandle(m_h_thread_mtc);
	m_h_thread_mtc = NULL;

	//CancelIo((HANDLE)m_listening_sock); 
	::shutdown(m_listening_sock, SD_BOTH);
	::closesocket(m_listening_sock);

	m_listening_sock = INVALID_SOCKET;
	m_h_thread = NULL;
	m_h_thread_mtc = NULL;

	return true;
}

// sock_client - сокет соединения с клиентом
// addr_client - адрес клиента
// i_len_addr - длина адреса

void CRfmSocket::add_new_client(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr)
{
	::EnterCriticalSection(&m_cs_clients);
	
	// Создать обьект соединения с клиентом

	c_TransportLevel *p_new_client = new c_TransportLevel(sock_client, addr_client, i_len_addr, m_i_id_guid, this);
	if(!p_new_client) throw;
	
	if(p_new_client->start_client())
	{
		// добавить клиента

		typedef pair <unsigned int, c_TransportLevel*> Mgr_Pair;
		m_arr_clients.insert(Mgr_Pair(m_i_id_guid, p_new_client)); 
		
		m_i_id_guid++;
	}
	else
		delete p_new_client;

	::LeaveCriticalSection(&m_cs_clients);	
}

// Проверить, является ли подключен клиент
// addr_client - адрес клиента
// i_len_addr - длина адреса

bool CRfmSocket::check_same_client(sockaddr_in addr_client, size_t i_len_addr)
{
	::EnterCriticalSection(&m_cs_clients);
	
	for(c_arr_clients::iterator iter = m_arr_clients.begin(); iter != m_arr_clients.end(); iter++)
	{
		c_TransportLevel *pClient = static_cast<c_TransportLevel*>((*iter).second);
		sockaddr_in addr_in = pClient->get_client_add();
		if(addr_in.sin_addr.S_un.S_addr == addr_client.sin_addr.S_un.S_addr){
			::LeaveCriticalSection(&m_cs_clients);	
			return true;
		}
	}

	::LeaveCriticalSection(&m_cs_clients);	
	return false;
}


// Удалить клиента 
// p_clietnt - указатель на обьект соединения

void CRfmSocket::delete_client(int i_id_client)
{
	::EnterCriticalSection(&m_cs_clients);
	
	c_arr_clients::iterator iter = m_arr_clients.find(i_id_client);
	if(iter == m_arr_clients.end())
	{
		::LeaveCriticalSection(&m_cs_clients);
		return;
	}

	// Удалить соединение с клиентом

	((c_TransportLevel*)(*iter).second)->close_client();

	delete (*iter).second;

	m_arr_clients.erase(iter);

	::LeaveCriticalSection(&m_cs_clients);
}







// Удалить всех клиентов

void CRfmSocket::delete_clients_all()
{
	//write_log("1\n");
	
	::EnterCriticalSection(&m_cs_clients);
	
	//write_log("2\n");

	for(c_arr_clients::iterator iter = m_arr_clients.begin();
		iter != m_arr_clients.end(); iter++)
	{
		if((*iter).second)
		{
	//		write_log("3\n");

			((c_TransportLevel*)(*iter).second)->close_client();
	
	//		write_log("4\n");

			delete (*iter).second;

	//		write_log("5\n");
		}
	}
	
	//write_log("6\n");

	m_arr_clients.clear();

	//write_log("7\n");

	::LeaveCriticalSection(&m_cs_clients);

	//write_log("8\n");
}
