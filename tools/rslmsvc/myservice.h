
#ifndef __MYSERVICE_H__
#define __MYSERVICE_H__



class CServer;


class CMyService : public CService
{
          int m_port;
          CServer *p_obj;

  public:
          CMyService(int _port);
          ~CMyService();
          
          BOOL Start();
          BOOL Stop();
          BOOL IsExecuted() const;
};



#endif
