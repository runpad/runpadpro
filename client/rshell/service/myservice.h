
#ifndef __MYSERVICE_H__
#define __MYSERVICE_H__

#include "serviceman.h"

class CPipeObj;
class CNetObj;
class CCameraCB;


class CMyService : public CService
{
          HANDLE h_mutex;
          CPipeObj *p_pipe;
          CNetObj *p_net;
          CCameraCB *p_cam;

  public:
          CMyService();
          ~CMyService();
          
          const char* GetName() const { return "RunpadProShellService"; }
          const char* GetDisplayName() const { return "Runpad Pro Shell Service"; }
          BOOL IsInteractive() const { return FALSE; }
          BOOL Start();
          BOOL Stop();
          BOOL IsExecuted() const;
};



#endif
