
#ifndef __LISTENER_H__
#define __LISTENER_H__


class CListener
{
          SOCKET h_socket;
          HANDLE h_thread;
          HANDLE h_stop_event;

  public:
          CListener(int port);
          virtual ~CListener();

          void AsyncTerminateRequest();

  private:
          static DWORD WINAPI AcceptThreadProcWrapper(LPVOID lpParameter);
          DWORD AcceptThreadProc();

          static BOOL IsIPInList(const char *ext,const char *list);
          static BOOL IsClientAllowed(int client_ip);

  protected:
          virtual void WorkWithClient(SOCKET h_socket) = 0;

          BOOL IsStopEvent(unsigned timeout=0);

          static void SetSendTimeout(SOCKET h_socket,int timeout_ms);
          static BOOL IsDataAvail(SOCKET h_socket,unsigned timeout_ms,BOOL& _err);
          static BOOL SendData(SOCKET h_socket,const void *buff, int len);
          static BOOL SendData(SOCKET h_socket,int i);
          static BOOL SendData(SOCKET h_socket,unsigned u);
          static BOOL RecvData(SOCKET h_socket,void *buff, int max_len);
          static BOOL RecvData(SOCKET h_socket,unsigned *u);
          static BOOL RecvData(SOCKET h_socket,int *i);

};


class CListenerScreen : public CListener
{
  public:
          CListenerScreen() : CListener(PORT_SCREEN) {}

  protected:
          void WorkWithClient(SOCKET h_socket);
};


class CListenerEvents : public CListener
{
  public:
          CListenerEvents() : CListener(PORT_EVENTS) {}

  protected:
          void WorkWithClient(SOCKET h_socket);
};



#endif
