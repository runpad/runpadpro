
#ifndef __WIACB_H_
#define __WIACB_H_


// this implementation was moved from rshell.exe because of some conflicts with other threads (probably autorun thread)
// on win7 x64 (crash in RPCRT4.dll)
// but as implemented here it is not supports terminal clients


class CWiaEventCallback;

class CCameraCB
{
          IWiaDevMgr *pWia;
          CWiaEventCallback *pCB;
          IWiaEventCallback *pWiaCB;
          IUnknown *pUnk;

          HANDLE h_fire_event;
          
          DWORD thread_id;
          HANDLE h_thread;

  public:
          CCameraCB();
          ~CCameraCB();

  private:
          static DWORD WINAPI ThreadProcWrapper(void*);
          void ThreadProc();
};




#endif

