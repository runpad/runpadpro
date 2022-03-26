#pragma once
#include "c_LogicalLevel.h"

#define SIGN_BEGIN_PACK		0x2A	// Признак начала пакета
#define COUNT_TRY_SEND		0xA		// Количество раз передачи пакета, после которого происходит
									// отключение клиента	
#define MAX_SIZE_CICLE_BUFER 102400 // Максимальный размер приемного кольцевого буфера
#define MAX_SIZE_PACK 30720			// Максимальный размер вычитаных данных

/////////////////////////////////////////////////////////////////////////////////////
// Возможные ошибки транспортного уровня  
/////////////////////////////////////////////////////////////////////////////////////

#define ERR_SIGN_PACK		0x50 // Не найден признак пакета
#define ERR_ID_PACK			0x51 // Не правильный тип пакета
#define ERR_SIZE_PACK	    0x52 // Не правильный размер пакета
#define ERR_SRC_PACK	    0x53 // Не правильная контрольная сумма пакета

/////////////////////////////////////////////////////////////////////////////////////
// Описание очереди из одного пакета (по запросу передать пакет повторно)  
/////////////////////////////////////////////////////////////////////////////////////

typedef struct __ORDER_DATA__
{
	unsigned short iSize;			   // Размер предыщего пакета
	char		   *pData;			   // Данные предыдущего пакета	
}ORDER_DATA;

/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_TransportLevel
// Описание	: Данный класс отвечает за передачу пакета на транспортном уровне.  
/////////////////////////////////////////////////////////////////////////////////////

class c_TransportLevel : public CRfmServerClient
{
public:
	c_TransportLevel(SOCKET sock_client, sockaddr_in addr_client, size_t i_len_addr, unsigned int id_client, CRfmSocket *p_rfm_socket);
	~c_TransportLevel(void);
	// Отправить пакет с логического уровня
	// pData - данные которые необходимо передать клиенту
	// nSize - размер данных
	void SendData(char *pData, int nSize);
	// Генерация пакета на передачу в сеть
	int c_TransportLevel::make_packet(unsigned char c_id_packet, unsigned char	c_code_err, 
									  unsigned __int64 ui_total_size, unsigned short	i_size_data, 
									  char *pData, char **pp_packet);
	// Событие отключения клиента от сервера
	void OnDisconnect();
private:
	// Добавить новые данные для расшифровки пакета
	// pData - поступившие из сокета данные
	// nSize - размер данных
	void AddData(char *pData, int nSize);
	// Расшифровка полного пакета
	// pData - полный принятый пакет
	// nSize - размер пакета
	void ParsePacket(char *pData, int nSize);
	// Определить является ли ошибка транспортного уровня
	// c_code_err - код ошибки
	bool IsTransportError(unsigned char c_code_err);
	// Определить является ли правильным идентификатор пакета
	// c_id_packet - полученный идентификатор пакета
	bool IsValidIDpacket(unsigned char c_id_packet);
	// Проверить контрольную сумму пакета
	// pData - данные пакета
	// nSize - размер данных
	bool CheckSRCpacket(char *pData, int nSize);
	// Вычислить контрольную сумму пакета
	// pData - данные пакета
	// nSize - размер данных
	unsigned short CalcSRCpacket(char *pData, int nSize);
	// Обработать ошибку транспортного уровня
	// повторно передать пакет
	void ProcessError();
	// Отослать уведомление другой стороне о принятом ошибочном пакете
	// c_code_error - код ошибки транспортного уровня
	void SendErrorMsg(unsigned char c_code_error);
	// Сохраненный предыдущий пакет на случай повторной передачи
	ORDER_DATA m_prevPack;
	// Счетчик передач одного и того же пакета клиенту
	short	   m_iCountSend;
	// Счетчик принятых ошибочных пакетов из сети
	short	   m_iCountErrPack;	
	// Обьект логического уровня протокола
	c_LogicalLevel m_LogicLevel;
	// Кольцевой приемный буфер
	unsigned char *m_pch_cicle_bufer;
	// Указатель чтения приемного буфера
	int m_i_point_read;
	// Указатель записи приемного буфера
	int m_i_point_write;
	// Количество байт требуемое для полного пакета
	int m_i_need_count;
};
