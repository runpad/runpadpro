#pragma once

#include <map>
using namespace std; 

class CRfmSocket;

////////////////////////////////////////////////////////////////////////
// класс	: CClients
// описание	: Базовый класс для классов управления пдключенными
//			  клиентами				
////////////////////////////////////////////////////////////////////////


class CClients	
{
public:
	CClients(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr, unsigned int id_client, CRfmSocket *p_rfm_socket)
	{
		m_p_rfm_socket = p_rfm_socket;
	};
	virtual ~CClients(void){}
	CRfmSocket *get_rfm_socket() {return m_p_rfm_socket;}
protected:	
	// Указатель на класс управлениям сокетами
	CRfmSocket *m_p_rfm_socket;
};
	
typedef map<unsigned int, CClients*> c_arr_clients;

////////////////////////////////////////////////////////////////////////
// класс	: CRfmSocket
// описание	: Предоставляет функции для работы с сокетами на серверной 
//			  стороне 	
////////////////////////////////////////////////////////////////////////

class CRfmSocket
{
public:
	CRfmSocket(void);
	~CRfmSocket(void);
	// Старт сервера 
	// p_name_server - имя сервера
	// i_port - порт сервера
	bool StartServer(const char* p_name_server, unsigned short i_port);
	// Останов сервера 
	bool StopServer();
	// Определить сокет прослушивания сервера
	SOCKET get_socket_listen() const {return m_listening_sock;}
	// Определить событие отключения клиентов
	HANDLE get_event_disconnect() const { return m_h_disconnect_client;}
	// Определить идентификатор удаляемого клиента
	unsigned int get_id_delete_client() const { return m_i_id_delete_cl; }
	// Добавить нового клиента 
	// sock_client - сокет соединения с клиентом
	// addr_client - адрес клиента
	// i_len_addr - длина адреса
	void add_new_client(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr);
	// Удалить клиента 
	// p_clietnt - указатель на обьект соединения
	void delete_client(int i_id_client);
	// Удалить всех клиентов
	void delete_clients_all();
	// Установить событие удаления клиента
	void set_delete_client(unsigned int id_delete)
	{
		m_i_id_delete_cl = id_delete;	 
		::SetEvent(m_h_disconnect_client);
	}
	// Проверить, является ли подключен клиент
	bool check_same_client(sockaddr_in addr_client, size_t i_len_addr);
private:
	// Сокет сервера для прослушивания
	SOCKET m_listening_sock;
	// Разграничение доступа к базе подключенных клиентов
	CRITICAL_SECTION m_cs_clients;
	// Хранилище подключенных клиентов
	c_arr_clients m_arr_clients;
	// Идентификатор потока
	DWORD m_i_id_thread;
	// Дескриптор потока подключения клиентов
	HANDLE m_h_thread;
	// Дескриптор потока обслуживания
	HANDLE m_h_thread_mtc;
	// Идентификатор потока обслуживания
	DWORD m_i_id_thread_mtc;
	// Уникальный идентификатор клиента
	// инкрементируется каждый раз при добавлении клиента
	unsigned int m_i_id_guid;
	// Собитие отключения клиента от сервера
	HANDLE m_h_disconnect_client;
	// ID удаляемого клиента
	unsigned int m_i_id_delete_cl; 
};
