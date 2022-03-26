
#ifndef __EXECUTOR_H__
#define __EXECUTOR_H__



class CExecutor
{
          std::vector<HANDLE> m_processes;
          DWORD m_last_sid;
          DWORD (WINAPI *pWTSGetActiveConsoleSessionId)();

  public:
          CExecutor();
          ~CExecutor();

          BOOL Prepare(DWORD& _session,BOOL& _session_changed);
          static BOOL Exec(DWORD session,const void *inbuff,unsigned insize,void *outbuff,unsigned maxsize,unsigned& _outsize,unsigned timeout);

  private:        
          static BOOL CallPipe(const char* pipe_name,const void *inbuff,unsigned insize,void *outbuff,unsigned maxsize,unsigned& _outsize,unsigned timeout_wait,unsigned timeout_call);
          static HANDLE GetSessionToken(DWORD sid);
          static int FindProcess(int session,const char *path,BOOL is_short);
          static char* GetExePathByPid(int pid,char *_path);
          static char* PathRemoveUNCPrefix(char *inout);

};



#endif
