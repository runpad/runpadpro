
#ifndef __PIPE_H__
#define __PIPE_H__


class CPipeObj
{
          HANDLE h_thread;

  public:
          CPipeObj();
          ~CPipeObj();

  private:
          static DWORD WINAPI ThreadProc(LPVOID lpParameter);
          static DWORD WINAPI CommThreadProc(LPVOID lpParameter);
          static BOOL ProcessPipeMessage(const char *buff);
};



#endif
