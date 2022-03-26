
#ifndef __PROCESS_H__
#define __PROCESS_H__


class CSessionProcessList
{
          struct {
           HANDLE handle;
           BOOL first;
          } snap;
          
          struct {
           DWORD our_sid;   // our session id
           WTS_PROCESS_INFO *list;
           DWORD count;
           DWORD curr;  // current index in list
          } wts;

  public:
          CSessionProcessList();
          ~CSessionProcessList();

          BOOL GetNext(int *_pid,char *_filename=NULL);
};



BOOL StdTerminateProcess(int pid);
BOOL MyTerminateProcess(int pid);



#endif
