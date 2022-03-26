
#ifndef __SOCKET_H__
#define __SOCKET_H__

#include <windows.h>
#include <vector>


class CSocket
{
       SOCKET m_socket;
       CRITICAL_SECTION m_section;
       HANDLE m_thread;
       int m_parent_thread_id;
       BOOL m_connected;

  public:
       CSocket();
       virtual ~CSocket();

       void SyncBegin();
       void SyncEnd();

       virtual BOOL Connect(char *server,unsigned port);
       virtual void Disconnect();
       virtual void WorkWithServer() = 0;

       BOOL IsConnected() { return m_connected; }

  protected:
       void PostMessageToParentThread(const char *msg);
       void PostDisconnectMessage();

       BOOL RecvData(void *buff, int max_len);
       BOOL RecvData(int *i);
       BOOL RecvData(unsigned *u);
       BOOL SendData(void *buff, int len);
       BOOL SendData(int i);
       BOOL SendData(unsigned u);

  private:
       int GetFirstHostAddrByName(char *name);
       static DWORD WINAPI ThreadProc(LPVOID lpParameter);
};


class CEventsSocket: public CSocket
{
      typedef struct {
       int message;
       int wParam;
       int lParam;
       unsigned time;
      } TEVENT;

      HANDLE m_event;
      std::vector<TEVENT> m_events;

  public:
      CEventsSocket();
      ~CEventsSocket();

      virtual void WorkWithServer();

      void AddEvent(int message,int wParam,int lParam,unsigned time);
};


class CBuff7;

class CScreenSocket: public CSocket
{
      CBuff7 *m_screen;
      CBuff7 *m_rlebuff;
      int m_picture_type;
      float m_fps;

  public:
      CScreenSocket();
      ~CScreenSocket();

      virtual void Disconnect();
      virtual void WorkWithServer();

      void UpdateFPS(float fps);
      void UpdatePictureType(int type);
      HDC Lock(int *w,int *h);
      void Unlock();

  private:
      void ReallocateBuffIfNeeded(CBuff7* &buff,BOOL grayscale,int w,int h);
      void FreeBuffers();
};



#endif
