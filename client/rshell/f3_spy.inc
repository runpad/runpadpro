

static HANDLE spy_process = NULL;
static int spy_process_pid = -1;
static unsigned spy_process_start = 0;


void SetSpyProcess(int pid)
{
  if ( spy_process )
     {
       CloseHandle(spy_process);
       spy_process = NULL;
       spy_process_pid = -1;
       spy_process_start = 0;
     }

  if ( pid == -1 )
     return;
     
  spy_process = OpenProcess(SYNCHRONIZE,FALSE,pid);
  spy_process_pid = pid;
  spy_process_start = GetTickCount();
}


int IsProcessSpyed(void)
{
  int rc;
  
  if ( !spy_process )
     return 0;
  
  rc = WaitForSingleObject(spy_process,0);
  if ( rc == WAIT_FAILED || rc == WAIT_OBJECT_0 || 
       (!HasProcessAppWindow(spy_process_pid) && GetTickCount()-spy_process_start>10000) )
     {
       int parent = spy_process_pid;
       int child;
       
       CloseHandle(spy_process);
       spy_process = NULL;
       spy_process_pid = -1;
       spy_process_start = 0;

       child = FindLastProcessChild(parent);
       if ( child != -1 )
          {
            SetSpyProcess(child);
            return IsProcessSpyed();
          }

       return 0;
     }

  return 1;
}

