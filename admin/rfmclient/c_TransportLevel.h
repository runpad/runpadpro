#pragma once
#include ".\Rfmclientsocket.h"
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

class c_TransportLevel : public CRfmClientSocket
{
public:
	c_TransportLevel(HWND hwnd_tab, int i_indx_tab);
	~c_TransportLevel(void);
	// Отправить пакет с логического уровня
	// pData - данные которые необходимо передать клиенту
	// nSize - размер данных
	void SendData(char *pData, int nSize);
	// Генерация пакета на передачу в сеть
	int c_TransportLevel::make_packet(unsigned char c_id_packet, unsigned char	c_code_err, 
									  unsigned __int64 ui_total_size, unsigned short	i_size_data, 
									  char *pData, char **pp_packet);
	// Получить указатель на логический уровень протокола
	c_LogicalLevel *get_logic_level(){return &m_LogicLevel;}
	// Проверить соединение с сервером
	void OnCheckConnect();
	// Установить имя сервера
	void set_name_server(CString sz_name_srv);
	// Определить имя сервера
	CString get_name_server(){return m_sz_name_server;}
	// Событие пропадания связи с сервером
	void OnDisconnect();
	// Определить идентификатор соединения
	UINT get_id_connected() const {return m_i_indx_tab;}
	// Определить событие останова текущей операции
	HANDLE get_event_stop() const { return m_h_stop_current_process;}
private:
	// Событие останова текущей операции по инициативе
	// разрыва связи с сервером
	mutable HANDLE m_h_stop_current_process;
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
	// Время получения пакета
	DWORD m_i_tm_recv_pack;
	// Время отправки пакета
	DWORD m_i_tm_send_pack;
	// флаг передачи пакета
	bool m_b_send_packet;
	// Название сервера
	CString m_sz_name_server;
	// Окно, отображающее текущее соединение
	HWND m_hwnd_tab;
	// Идентификатор окна, отображающего текущее соединение
	int m_i_indx_tab;
};
