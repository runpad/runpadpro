#include "StdAfx.h"
#include "rfmserverclient.h"
#include "Winbase.h"
#include "NRFileData.h"

// Максимальный размер буфера приема данных

#define MAX_RECV_BUFFER 4096


CRfmServerClient::CRfmServerClient(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr, 
								   unsigned int id_client, CRfmSocket *p_rfm_socket)
	: CClients(sock_client, addr_client, i_len_addr, id_client, p_rfm_socket)
{
	m_sock_client = sock_client;
	m_addr_client = addr_client; 
	m_i_len_addr = i_len_addr;	
	m_id_client = id_client;
	m_h_thread_client = NULL;
	m_i_id_thread = 0;
}


CRfmServerClient::~CRfmServerClient(void)
{
	if(m_h_thread_client)
		TerminateThread(m_h_thread_client, 0x0);
	::CloseHandle(m_h_thread_client);
}

// Прослушка сокета клиента

DWORD WINAPI thread_recieve(LPVOID lp_param)
{
  CDisableWOW64FSRedirection fsguard; // for x64

	CRfmServerClient *p_rfm_socket = (CRfmServerClient*)lp_param;
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

			p_rfm_socket->OnReceive(ch_buff_recv, i_recv);
		}
		else
		{
			p_rfm_socket->OnDisconnect();
			
			// Удалить текущего клиента
	
			shutdown(p_rfm_socket->get_client_socket(), SD_BOTH);

			p_rfm_socket->get_rfm_socket()->set_delete_client(p_rfm_socket->get_id_client());
			
			break;
		}
	}
	
	return 0;
}


// Начать прослушивать сокет клиента

bool CRfmServerClient::start_client()
{
	m_h_thread_client = ::CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)thread_recieve, 
		(LPVOID)this, NULL, &m_i_id_thread);
	if(!m_h_thread_client)
	{
		//CancelIo((HANDLE)m_sock_client); 
		shutdown(m_sock_client,SD_BOTH);
		closesocket(m_sock_client);
		m_sock_client = INVALID_SOCKET;
		return false;
	}
	
	return true;
}



// Закрыть соединение с текущим клиентом

void CRfmServerClient::close_client()
{
	if(m_sock_client == INVALID_SOCKET)
		return;
	
	if(m_h_thread_client){
		TerminateThread(m_h_thread_client, 0x0);
		::CloseHandle(m_h_thread_client);
		//m_h_thread_client = NULL;
	}

	//CancelIo((HANDLE)m_sock_client); 
	shutdown(m_sock_client,SD_BOTH);
	closesocket(m_sock_client);
	m_sock_client = INVALID_SOCKET;

	
	OnDisconnect();
	
	m_h_thread_client = NULL;
}


// Передача данных в сокет
// pData - данные подготовленные на передачу
// nSize - размер данных

bool CRfmServerClient::Send(char *pData, int nSize)
{
	if(!pData || !nSize)
		return false;
	
	if(send(m_sock_client, pData, nSize, 0)  == SOCKET_ERROR)
		return false;
	
	return true;
}


// Обработчик получения данных с сокета
// pInBuffer - поступившие данные
// nBufSize  - размер поступивших данных

void CRfmServerClient::OnReceive(char* pInBuffer, size_t nBufSize)
{
	// Передать данные транспортному уровню

	AddData(pInBuffer, (int)nBufSize);
}