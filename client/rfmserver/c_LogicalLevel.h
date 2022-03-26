#pragma once
#include "c_CommandHanlers.h"
#include <map>
using namespace std;


typedef map<unsigned char, c_LogicCommand*> CArrHandlersCmds; 


/////////////////////////////////////////////////////////////////////////////////////
// Класс	: c_LogicalLevel
// Описание	: Данный класс отвечает за выполнение конкретной команды
/////////////////////////////////////////////////////////////////////////////////////

class c_LogicalLevel
{
public:
	c_LogicalLevel(CRfmServerClient *pTransportLevel);
	~c_LogicalLevel(void);
	// Обработать пакет на логическом уровне 
	// pData - данные для логического уровня
	// iSize - размер данных
	bool ProcessData(char *pData, int iSize);
	// добавить новый обработчик команды
	// id_command - ID соманды к которому привязан обработчик
	// pCommand - обьект обработки команды
	void AddNewHandler(unsigned char id_command, c_LogicCommand *pCommand);
	// Удалить команду 
	// id_command - ID соманды к которому привязан обработчик
	void DeleteHandler(unsigned char id_command);
	// Определить обработчик команды по ее ID
	// id_command - ID соманды к которому привязан обработчик
	c_LogicCommand *GetHandlerByID(unsigned char id_command);
	// Дать знать текущей операци что соединение с сервером пропало
	void set_break_operation();
private:
	// Хранилище обработчиков команд
	CArrHandlersCmds m_arrHandlersCmds;
};
