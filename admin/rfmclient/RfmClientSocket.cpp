#include "StdAfx.h"
#include ".\Rfmclientsocket.h"

// Максимальный буфер приема данных с сервера

#define MAX_RECV_BUFFER 4096


CRfmClientSocket::CRfmClientSocket(void)
{
	m_listening_sock = INVALID_SOCKET;
	m_i_id_thread = 0;
	m_h_thread = NULL;
	m_b_connected = false;
}

CRfmClientSocket::~CRfmClientSocket(void)
{
	Disconnect();
	m_b_connected = false;
}


// Прослушка сокета клиента

DWORD WINAPI thread_recieve(LPVOID lp_param)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	
	CRfmClientSocket *p_rfm_socket = (CRfmClientSocket*)lp_param;
	if(!p_rfm_socket) return 1;
	char ch_buff_recv[MAX_RECV_BUFFER];
	
	// Цикл, ожидающий данных от клиента

	while(1) 
	{
		// Принять новые данные

		int i_recv = recv(p_rfm_socket->get_client_socket(), ch_buff_recv, MAX_RECV_BUFFER, 0);
		if(i_recv > 0) 
		{
			// Передать данные транспортному уровню

			p_rfm_socket->HandleReceive(ch_buff_recv, i_recv);
		}
		else
		{
			// Связь с сервером пропала !!!
			p_rfm_socket->set_connected(false);
			p_rfm_socket->OnDisconnect();
			break;
		}
	}
	
	return 0;
}



int GetFirstHostAddrByName(const char *name)
{
  int ip = inet_addr(name);

  if ( ip == 0 || ip == -1 )
     {
       struct hostent *h = gethostbyname(name);
       if ( h )
          {
            int *pip = (int*)h->h_addr_list[0];
            if ( pip )
               ip = *pip;
          }
     }

  return ip;
}


bool CRfmClientSocket::Connect(const char* pszServer, int port)
{
	if(!pszServer)
		return false;
	
	int i_error = 0; 
	WSADATA wd = {0};
	struct sockaddr_in sin;
	int i_on = 1;
	struct hostent FAR	*pHostEnt;

	// Инициализировать библиотеку

	i_error = WSAStartup(MAKEWORD(2, 2), &wd);
	if(i_error != 0)
		return false; 

	// Создать сокет

	m_listening_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(m_listening_sock == INVALID_SOCKET)
		return false;

	// Установить одновременное использование сокетами несколькими приложениями 
	
	if(setsockopt(m_listening_sock, SOL_SOCKET, SO_REUSEADDR, (char*)&i_on, sizeof(i_on)) == SOCKET_ERROR)
		return false;

	// Связать сокет с адресом

	sin.sin_family = AF_INET;
	sin.sin_port = htons((short)port);

	if (pszServer[0] >= '0' && pszServer[0] <= '9')
	{
		sin.sin_addr.s_addr=GetFirstHostAddrByName(pszServer);
		if (sin.sin_addr.s_addr==INADDR_NONE)
			return false;
	}
	else
	{
		if((pHostEnt = gethostbyname(pszServer))==NULL) 
			return false;
		else
			memcpy(&sin.sin_addr, pHostEnt->h_addr, pHostEnt->h_length);
	}
	
	// Подключится к серверу

	if(connect(m_listening_sock, (SOCKADDR*)&sin, sizeof(sin)) == SOCKET_ERROR)
		return false;
	
	// Запустить поток приема клиентов

	m_h_thread = ::CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)thread_recieve, (LPVOID)this, NULL, &m_i_id_thread);
	if(!m_h_thread)
		return false;

	m_b_connected = true;

	return true;

}

// Отключится от сервера

bool CRfmClientSocket::Disconnect()
{
		
	if(m_h_thread)
	{
		::TerminateThread(m_h_thread, 0x0);
		::CloseHandle(m_h_thread);
	}
	
	if(m_listening_sock != SOCKET_ERROR)
	{
	        ::shutdown(m_listening_sock, SD_BOTH);
		closesocket(m_listening_sock);
		m_listening_sock = SOCKET_ERROR;
	}
	
	m_h_thread = NULL;
	m_i_id_thread = 0;
	return true;
}


// Передать пакет серверу
// pData - данные на передачу
// nSize - размер данных

bool CRfmClientSocket::Send(char *pData, int nSize)
{
	if(!pData || !nSize)
		return false;
	
	if(send(m_listening_sock, pData, nSize, 0) == INVALID_SOCKET)
		return false;

	
	
	return true;
}




// Возвращает количество вычитаных байт с буфера

void CRfmClientSocket::HandleReceive(char* pInBuffer, size_t nBufSize)
{
	// Передать полученные данные транспртному уровню

	AddData((char*)pInBuffer, (int)nBufSize);
}
