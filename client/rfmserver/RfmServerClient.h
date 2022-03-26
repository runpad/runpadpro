#pragma once

#include "RfmSocket.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// класс	: CRfmServerClient
// описание : Данный класс предоставляет функции для работы с каждым подключенным клиентом
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CRfmServerClient : public CClients
{
public:
	CRfmServerClient(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr, unsigned int id_client, CRfmSocket *p_rfm_socket);
	virtual ~CRfmServerClient(void);
	// Закрыть соединение с текущим клиентом
	void close_client();
	// Определить ID клиента
	unsigned int get_id_client() const { return m_id_client;}
	// Определить сокет клиента
	SOCKET get_client_socket() const {return m_sock_client;}
	// Определить адрес клиента
	sockaddr_in get_client_add() const {return m_addr_client;}
	/// Новые данные на подходе.
	/// Эта функия вызываеться в CServerClientBase классе когда новые данные на подходе.
	/// pInBuffer -  указатель на входной буфер
	/// nBufSize  -  размер входного буфра
	void OnReceive(char* pInBuffer, size_t nBufSize);
	// Начать прослушивать сокет клиента
	bool start_client();
	// Событие отключения клиента
	virtual void OnDisconnect() = 0;
protected:
	// Передача данных в сокет
	// pData - данные подготовленные на передачу
	// nSize - размер данных
	bool Send(char *pData, int nSize);
	// Добавить новые данные для расшифровки пакета
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void AddData(char *pData, int nSize) = 0;
	// Уникальный ID клиента
	unsigned int m_id_client;
	// сокет подключенного клиента
	SOCKET m_sock_client;
private:
	// адрес подключенного клиента
	sockaddr_in m_addr_client; 
	// длина адреса подключенного клиента
	size_t m_i_len_addr;
	// поток прослушки сокета клиента
	HANDLE m_h_thread_client;
	// ID потока прослушки сокета клиента 
	DWORD m_i_id_thread;	
};
