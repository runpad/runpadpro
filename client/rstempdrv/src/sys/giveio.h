/////////////////////////////////////////////////////////////////////////
// Файл		: giveio.h
// Описание : Драйвер определения температуры процессора и чипсета
// OS		: Windows NT 
/////////////////////////////////////////////////////////////////////////

#include <ntddk.h>
#include "gpioctl.h"        // IOCTL интерфейс

#if     !defined(__GIVEIO_H__)
#define __GIVEIO_H__

// NT device name
#define GPD_DEVICE_NAME L"\\Device\\giveio"

// Имя устройства файловой системы.   При открытии драйвера функцией CreateFile
// используте имя устройства "\\.\GiveIO" или в C\C++ конвертации: "\\\\.\\GiveIO".

#define DOS_DEVICE_NAME L"\\DosDevices\\giveio"

#define PORTIO_TAG 'TROP'

// Структура локальных данных драйвера указывющих на каждый обьект устройства

typedef struct _LOCAL_DEVICE_INFO {
    PVOID               PortBase;			// Базовый адрес порта
    ULONG               PortCount;			// Количество используемых I/O адресов.
    ULONG               PortMemoryType;		// HalTranslateBusAddress MemoryType
    PDEVICE_OBJECT      DeviceObject;		// GiveIO обьект устройства
    PDEVICE_OBJECT      NextLowerDriver;    // Верхушка стэка
    BOOLEAN             Started;
    BOOLEAN             Removed;
    BOOLEAN             PortWasMapped;		
    BOOLEAN             Filler[1]; 			
    IO_REMOVE_LOCK      RemoveLock;
} LOCAL_DEVICE_INFO, *PLOCAL_DEVICE_INFO;


#if DBG
#define DebugPrint(_x_) \
               DbgPrint ("GiveIO:"); \
               DbgPrint _x_;

#define TRAP() DbgBreakPoint()

#else
#define DebugPrint(_x_)
#define TRAP()
#endif


NTSYSAPI
NTSTATUS
NTAPI
    Ke386QueryIoAccessMap(ULONG dwFlag,PVOID pIopm);


NTSYSAPI
NTSTATUS 
NTAPI
    Ke386SetIoAccessMap(ULONG dwFlag,PVOID pIopm);

NTSYSAPI
NTSTATUS 
NTAPI
    Ke386IoSetAccessProcess(PEPROCESS pProcess, ULONG dwFlag);

/********************* Прототипы функций ***********************************/
//

NTSTATUS    
DriverEntry(       
    IN  PDRIVER_OBJECT DriverObject,
    IN  PUNICODE_STRING RegistryPath 
    );

NTSTATUS
CreateCloseDispatch(
         IN  PDRIVER_OBJECT DriverObject,
         IN  PIRP pIrp);

NTSTATUS
ADriverUnload(
         IN  PDRIVER_OBJECT DriverObject);

#endif


