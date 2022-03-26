

HANDLE MyCreateThread(LPTHREAD_START_ROUTINE func,void *parm,DWORD *_id,int priority,int cpu_mask)
{
  DWORD id;
  HANDLE thread;
  
  if ( _id )
     *_id = -1;
  
  thread = CreateThread(NULL,0,func,parm,CREATE_SUSPENDED,&id);

  if ( thread )
     {
       if ( _id )
          *_id = id;
       
       SetThreadPriority(thread,priority);

       if ( cpu_mask != -1 && cpu_mask != 0 )
          {
            SetThreadAffinityMask(thread,cpu_mask);
          }

       ResumeThread(thread);
     }

  return thread;
}


HANDLE MyCreateThreadDontCare(LPTHREAD_START_ROUTINE func,void *parm,DWORD *_id)
{
  return MyCreateThread(func,parm,_id,THREAD_PRIORITY_NORMAL,-1);
}


HANDLE MyCreateThreadSelectedCPU(LPTHREAD_START_ROUTINE func,void *parm,DWORD *_id,int priority)
{
  return MyCreateThread(func,parm,_id,priority,only_one_cpu?0x1:-1);
}


void SwitchCurrentThreadToCPU0IfNeeded(void)
{
  if ( only_one_cpu )
     {
       HANDLE h_thread = OpenThread(THREAD_SET_INFORMATION | THREAD_QUERY_INFORMATION,FALSE,GetCurrentThreadId());
       SetThreadAffinityMask(h_thread,0x1);
       CloseHandle(h_thread);
       Sleep(1); //reschedule thread
     }
}


