
#include "include.h"



class CWiaEventCallback: public IWiaEventCallback
{
      LONG  m_cRef;
      HANDLE event_notify;

  public:
    
    CWiaEventCallback(HANDLE _event) : m_cRef(1), event_notify(_event)
    {
    }
    ~CWiaEventCallback()
    {
    }

    ULONG STDMETHODCALLTYPE AddRef()
    {
        return InterlockedIncrement(&m_cRef);
    }    

    ULONG STDMETHODCALLTYPE Release()
    {
        LONG cRef = InterlockedDecrement(&m_cRef);
        if (0 == cRef)
        {
            delete this;
        }
        return cRef;
    }
    
    HRESULT STDMETHODCALLTYPE QueryInterface( REFIID riid, void **ppvObject )
    {
        //
        // Validate arguments
        //
        if (NULL == ppvObject)
        {
            return E_INVALIDARG;
        }

        //
        // Return the appropriate interface
        //
        if (IsEqualIID( riid, IID_IUnknown ))
        {
            *ppvObject = static_cast<IUnknown*>(this);
        }
        else if (IsEqualIID( riid, IID_IWiaEventCallback ))
        {
            *ppvObject = static_cast<IWiaEventCallback*>(this);
        }
        else
        {
            *ppvObject = NULL;
            return E_NOINTERFACE;
        }

        //
        // Increment the reference count before returning the interface.
        //
        reinterpret_cast<IUnknown*>(*ppvObject)->AddRef();
        return S_OK;
    }

    HRESULT STDMETHODCALLTYPE ImageEventCallback( 
        /* [in] */ const GUID *pEventGUID,
        /* [in] */ BSTR bstrEventDescription,
        /* [in] */ BSTR bstrDeviceID,
        /* [in] */ BSTR bstrDeviceDescription,
        /* [in] */ DWORD dwDeviceType,
        /* [in] */ BSTR bstrFullItemName,
        /* [out][in] */ ULONG *pulEventType,
        /* [in] */ ULONG ulReserved)
    {
      if ( IsEqualIID( *pEventGUID, WIA_EVENT_DEVICE_CONNECTED ) )
         {
           if ( GET_STIDEVICE_TYPE(dwDeviceType) == StiDeviceTypeDigitalCamera )
              {
                if ( event_notify )
                   {
                     SetEvent(event_notify);
                   }
              }
         }

      return S_OK;
    }
};



CCameraCB::CCameraCB()
{
  pWia = NULL;
  pCB = NULL;
  pWiaCB = NULL;
  pUnk = NULL;

  SECURITY_ATTRIBUTES sa;
  sa.nLength = sizeof(sa);
  sa.lpSecurityDescriptor = AllocateSDWithNoDACL();
  sa.bInheritHandle = FALSE;
  h_fire_event = CreateEvent(&sa,FALSE,FALSE,G_EVENT_WIA_DEVICE_CONNECTED);
  FreeSD(sa.lpSecurityDescriptor);

  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,&thread_id);
}


CCameraCB::~CCameraCB()
{
  PostThreadMessage(thread_id,WM_QUIT,0,0);
  if ( WaitForSingleObject(h_thread,1000) == WAIT_TIMEOUT )
     {
       TerminateThread(h_thread,0);
     }
  CloseHandle(h_thread);
  h_thread = NULL;

  CloseHandle(h_fire_event);
  h_fire_event = NULL;
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
  CoInitialize(0);

  pWia = NULL;
  pCB = NULL;
  pWiaCB = NULL;
  pUnk = NULL;

  BOOL rc = FALSE;

  // this call can be very slow on Vista at startup (~50 sec!!!)
  CoCreateInstance(CLSID_WiaDevMgr,NULL,CLSCTX_LOCAL_SERVER,IID_IWiaDevMgr,(void**)&pWia);
  if ( pWia )
     {
       pCB = new CWiaEventCallback(h_fire_event);
       pCB->QueryInterface(IID_IWiaEventCallback,(void**)&pWiaCB);

       if ( pWiaCB )
          {
            if ( pWia->RegisterEventCallbackInterface(0,NULL,&WIA_EVENT_DEVICE_CONNECTED,pWiaCB,&pUnk) == S_OK )
               {
                 rc = TRUE;
               }
          }
     }

  if ( rc )
     {
       MSG msg;

       while ( GetMessage(&msg,NULL,0,0) )
       {
         DispatchMessage(&msg);
       }
     }

  SAFERELEASE(pUnk);
  SAFERELEASE(pWiaCB);
  SAFERELEASE(pCB);
  SAFERELEASE(pWia);
  
  CoUninitialize();
}


