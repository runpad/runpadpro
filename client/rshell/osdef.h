
#ifndef ___OSDEF_H___
#define ___OSDEF_H___


#define SPI_GETDROPSHADOW                   0x1024
#define SPI_SETDROPSHADOW                   0x1025
#define CS_DROPSHADOW       0x00020000

#define SM_REMOTECONTROL        0x2001
#define SM_SHUTTINGDOWN         0x2000

#define SPI_GETFLATMENU                     0x1022
#define SPI_SETFLATMENU                     0x1023

#define NIN_BALLOONSHOW      (WM_USER + 2)
#define NIN_BALLOONHIDE      (WM_USER + 3)
#define NIN_BALLOONTIMEOUT   (WM_USER + 4)
#define NIN_BALLOONUSERCLICK (WM_USER + 5)

#define NIIF_NONE       0x00000000
#define NIIF_INFO       0x00000001
#define NIIF_WARNING    0x00000002
#define NIIF_ERROR      0x00000003
#define NIIF_ICON_MASK  0x0000000F

#define NIF_GUID        0x00000020


#define HSHELL_WINDOWREPLACED       13
#define HSHELL_WINDOWREPLACING      14

#define APPCOMMAND_MICROPHONE_VOLUME_MUTE 24
#define APPCOMMAND_MICROPHONE_VOLUME_DOWN 25
#define APPCOMMAND_MICROPHONE_VOLUME_UP   26
#define APPCOMMAND_HELP                   27
#define APPCOMMAND_FIND                   28
#define APPCOMMAND_NEW                    29
#define APPCOMMAND_OPEN                   30
#define APPCOMMAND_CLOSE                  31
#define APPCOMMAND_SAVE                   32
#define APPCOMMAND_PRINT                  33
#define APPCOMMAND_UNDO                   34
#define APPCOMMAND_REDO                   35
#define APPCOMMAND_COPY                   36
#define APPCOMMAND_CUT                    37
#define APPCOMMAND_PASTE                  38
#define APPCOMMAND_REPLY_TO_MAIL          39
#define APPCOMMAND_FORWARD_MAIL           40
#define APPCOMMAND_SEND_MAIL              41
#define APPCOMMAND_SPELL_CHECK            42
#define APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE    43
#define APPCOMMAND_MIC_ON_OFF_TOGGLE      44
#define APPCOMMAND_CORRECTION_LIST        45
#define APPCOMMAND_MEDIA_PLAY             46
#define APPCOMMAND_MEDIA_PAUSE            47
#define APPCOMMAND_MEDIA_RECORD           48
#define APPCOMMAND_MEDIA_FAST_FORWARD     49
#define APPCOMMAND_MEDIA_REWIND           50
#define APPCOMMAND_MEDIA_CHANNEL_UP       51
#define APPCOMMAND_MEDIA_CHANNEL_DOWN     52


#ifndef NT_SUCCESS
#define NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
#endif



#endif
