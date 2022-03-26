//////////////////////////////////////////////////////////////////////////
// Обьявления команд драйверу GIVEIO
//////////////////////////////////////////////////////////////////////////

#if     !defined(__GPIOCTL_H__)
#define __GPIOCTL_H__

#define GPD_TYPE 40000

#define IOCTL_GPD_READ_PORT_UCHAR \
    CTL_CODE( GPD_TYPE, 0x900, METHOD_BUFFERED, FILE_READ_ACCESS )

#define IOCTL_GPD_READ_PORT_USHORT \
    CTL_CODE( GPD_TYPE, 0x901, METHOD_BUFFERED, FILE_READ_ACCESS )

#define IOCTL_GPD_READ_PORT_ULONG \
    CTL_CODE( GPD_TYPE, 0x902, METHOD_BUFFERED, FILE_READ_ACCESS )

#define IOCTL_GPD_WRITE_PORT_UCHAR \
    CTL_CODE(GPD_TYPE,  0x910, METHOD_BUFFERED, FILE_WRITE_ACCESS)

#define IOCTL_GPD_WRITE_PORT_USHORT \
    CTL_CODE(GPD_TYPE,  0x911, METHOD_BUFFERED, FILE_WRITE_ACCESS)

#define IOCTL_GPD_WRITE_PORT_ULONG \
    CTL_CODE(GPD_TYPE,  0x912, METHOD_BUFFERED, FILE_WRITE_ACCESS)

// Команда на считывание температуры процессора

#define IOCTL_GPD_READ_TEMPERATURE_CPU \
    CTL_CODE( GPD_TYPE, 0x913, METHOD_BUFFERED, FILE_READ_ACCESS )

// Команда на считывание температуры чипсета

#define IOCTL_GPD_READ_TEMPERATURE_MBM \
    CTL_CODE( GPD_TYPE, 0x914, METHOD_BUFFERED, FILE_READ_ACCESS )

typedef struct  _GENPORT_WRITE_INPUT {
    ULONG   PortNumber;     // Порт на запись/считывание
    union   {               // Соответсвенно данные
        ULONG   LongData;
        USHORT  ShortData;
        UCHAR   CharData;
    };
}   GENPORT_WRITE_INPUT;

#endif

