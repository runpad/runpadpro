

class CCameraCB
{
          HWND hwnd;
          int message;
          HANDLE h_thread;
          HANDLE h_event_stop;

  public:
          CCameraCB(HWND _hwnd,int _message);
          ~CCameraCB();

  private:
          static DWORD WINAPI ThreadProcWrapper(void*);
          void ThreadProc();
};



CCameraCB::CCameraCB(HWND _hwnd,int _message)
{
  hwnd = _hwnd;
  message = _message;

  h_event_stop = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = MyCreateThreadSelectedCPU(ThreadProcWrapper,this);
}


CCameraCB::~CCameraCB()
{
  SetEvent(h_event_stop);
  if ( WaitForSingleObject(h_thread,1000) == WAIT_TIMEOUT )
     {
       TerminateThread(h_thread,0);
     }
  CloseHandle(h_thread);
  h_thread = NULL;

  CloseHandle(h_event_stop);
  h_event_stop = NULL;
}


DWORD WINAPI CCameraCB::ThreadProcWrapper(void *_parm)
{
  if ( _parm )
     {
       ((CCameraCB*)_parm)->ThreadProc();
       return 1;
     }
  else
     {
       return 0;
     }
}


void CCameraCB::ThreadProc()
{
  HANDLE evcb = NULL;

  do {

   if ( WaitForSingleObject(h_event_stop,100) == WAIT_OBJECT_0 )
      break;

   if ( evcb )
      {
        if ( WaitForSingleObject(evcb,0) == WAIT_OBJECT_0 )
           {
             if ( hwnd && IsWindow(hwnd) )
                {
                  PostMessage(hwnd,message,0,0);
                }
           }
      }
   else
      {
        evcb = OpenEvent(SYNCHRONIZE,FALSE,G_EVENT_WIA_DEVICE_CONNECTED);
      }

  } while (1);

  if ( evcb )
     {
       CloseHandle(evcb);
     }
}



static CCameraCB *g_camera_cb = NULL;


void InitCameraCallback()
{
  if ( !g_camera_cb )
     {
       HWND hwnd = GetMainWnd();

       if ( hwnd )
          {
            g_camera_cb = new CCameraCB(hwnd,RS_CAMERACONNECTED);
          }
     }
}


void DoneCameraCallback()
{
  SAFEDELETE(g_camera_cb);
}

