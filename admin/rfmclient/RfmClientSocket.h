#pragma once
#include "NRFileData.h"


////////////////////////////////////////////////////////////
// Класс содержащий функции для обмена данными с сервером //
////////////////////////////////////////////////////////////

class CRfmClientSocket
{
public:
	CRfmClientSocket(void);
	virtual ~CRfmClientSocket(void);
	// Подключится к серверу 
	// pszServer - адрес сервера
	// port - порт соединения с сервером
	bool Connect(const char* pszServer, int port);
	// Отключится от сервера
	bool Disconnect();
	// Новые данные получены полностью.
	// Эта функция вызываеться в CClientSocket классе когда новые данные получены.
	// pInBuffer -  указатель на входной буфер
	// nBufSize  -  размер входного буфра
	void HandleReceive(char* pInBuffer, size_t nBufSize);
	// Определить сокет соединения с сервером
	SOCKET get_client_socket() const {return m_listening_sock;}
	// Событие потери связи с сервером 
	virtual void OnDisconnect() = 0;
	// Определить подключены в данный моент к серверу
	bool is_connected() const { return m_b_connected;}
	// Установить флаг подключения к серверу
	void set_connected(bool b_connected){m_b_connected = b_connected;}
protected:
	// Передать пакет серверу
	// pData - данные на передачу
	// nSize - размер данных
	bool Send(char *pData, int nSize);
	// Добавить новые данные для расшифровки пакета
	// pData - поступившие из сокета данные
	// nSize - размер данных
	virtual void AddData(char *pData, int nSize) = 0;
	// Флаг подключения к серверу
	bool m_b_connected;
private:
	// Сокет соединения с сервером
	SOCKET m_listening_sock;
	// ID потока ожидания данных с сервера
	DWORD m_i_id_thread;
	// Дескриптор потока ожидания данных с сервера
	HANDLE m_h_thread;

};