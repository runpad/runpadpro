
#ifndef __IBUTTON_H__
#define __IBUTTON_H__


#include "hwident.h"


class CiButton : public CHWIdent
{
          HINSTANCE h_lib;

          long  (__stdcall *pTMExtendedStartSession)(short, short, void *);
          short (__stdcall *pTMEndSession)(long);
          short (__stdcall *pTMFirst)(long, void *);
          short (__stdcall *pTMNext)(long, void *);
          short (__stdcall *pTMRom)(long, void *, short *);
          short (__stdcall *pTMSetup)(long);
          short (__stdcall *pTMGetTypeVersion)(short, char *);

          unsigned r_seed;
          
          CRITICAL_SECTION o_cs;
          HANDLE h_thread;
          HANDLE h_event_thread_stop;

          volatile BOOL b_device_detection;
          volatile int i_port_num;
          volatile int i_port_type;

          volatile BOOL b_event;  // for user
          char s_rom[32];         // for user

          unsigned u_last_event_time;  // last time of success event (для защиты от дребезга)
          BOOL b_last_state;           // last state (connected/not_connected) of last access to button

          char drv_state_buffer[15360];  //used internally by driver

  public:
          CiButton();
          ~CiButton();

          EHWIdentDevice GetType() const { return HWID_IBUTTON; }
          BOOL IsDeviceDetection(BOOL &_is_present);
          BOOL IsEvent(char *id,int max);

  private:
          int RandomSeed();
          BOOL CatchSession(long &_session,int port_type=-1,int port_num=-1);
          void CloseSession(long session);
          BOOL IsButtonConnected(long session,char *state_buffer);
          BOOL ReadROM8(long session,char *state_buffer,unsigned char *_rom8);
          BOOL DetectDevice();
          void AddEvent(const unsigned char *rom8);

          static DWORD WINAPI ThreadProcWrapper(LPVOID lpParameter);
          DWORD ThreadProc();
};


#endif
