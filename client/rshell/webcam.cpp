
#include "include.h"



class CMediaHelper
{
  public:
          static void MyDeleteMediaType(AM_MEDIA_TYPE* mt);
          static void MyFreeMediaType(AM_MEDIA_TYPE& mt);
};


void CMediaHelper::MyFreeMediaType(AM_MEDIA_TYPE& mt)
{
  if ( mt.pbFormat != NULL )
     {
       CoTaskMemFree((PVOID)mt.pbFormat);
       mt.cbFormat = 0;
       mt.pbFormat = NULL;
     }

  if ( mt.pUnk != NULL )
     {
       // Unecessary because pUnk should not be used, but safest.
       mt.pUnk->Release();
       mt.pUnk = NULL;
     }
}


void CMediaHelper::MyDeleteMediaType(AM_MEDIA_TYPE* mt)
{
  if ( mt )
     {
       MyFreeMediaType(*mt);
       CoTaskMemFree((PVOID)mt);
     }
}


////////////////////


CWebShot::CWebShot(int width,int height,int bpp)
{
  InitializeCriticalSection(&o_cs);

  m_width = width;
  m_height = height;  // can be negative
  m_bpp = bpp;

  p_buff = sys_zalloc(GetDataSize());  // can be zero length

  m_time = 0.0;
  b_changed = FALSE;
}


CWebShot::~CWebShot()
{
  m_width = 0;
  m_height = 0;
  m_bpp = 0;
  
  SAFESYSFREE(p_buff);

  DeleteCriticalSection(&o_cs);
}


// can be called from another thread!
const void* CWebShot::Lock(BOOL& _frame_changed,double& _time)
{
  EnterCriticalSection(&o_cs);

  _frame_changed = b_changed;
  b_changed = FALSE;

  _time = m_time;

  return p_buff;
}


// can be called from another thread!
void CWebShot::Unlock()
{
  LeaveCriticalSection(&o_cs);
}


// can be called from another thread!
BOOL CWebShot::UpdateFrameIfNotLocked(double time,int width,int height,int bpp,const void *data,unsigned datasize)
{
  BOOL rc = FALSE;

  if ( IsFormatTheSame(width,height,bpp) )
     {
       if ( data )
          {
            if ( datasize >= GetDataSize() )
               {
                 if ( GetDataSize() > 0 )
                    {
                      if ( p_buff )
                         {
                           if ( TryEnterCriticalSection(&o_cs) )
                              {
                                m_time = time;
                                b_changed = TRUE;

                                const int row_stride = GetRowStride(GetWidth(),GetBPP());

                                for ( int n = 0; n < GetHeight(); n++ )
                                    {
                                      char *dest = (char*)p_buff + n * row_stride;
                                      const char *src = (const char*)data + n * row_stride;

                                      CopyMemory(dest,src,GetWidth()*(GetBPP()/8));
                                    }

                                rc = TRUE;

                                LeaveCriticalSection(&o_cs);
                              }
                         }
                    }
               }
          }
     }

  return rc;
}


int CWebShot::GetRowStride(int width,int bpp)
{
  return (width * (bpp/8) + 3) & ~3;
}



class CGrabberSampleCB : public ISampleGrabberCB
{
          int i_width;
          int i_height;
          int i_bpp;

          CWebShot *p_shot;
  
  public:
          CGrabberSampleCB(CWebShot *_shot,int _width,int _height,int _bpp) 
            : p_shot(_shot), i_width(_width), i_height(_height), i_bpp(_bpp) {}
          ~CGrabberSampleCB() { p_shot = NULL; i_width = i_height = i_bpp = 0; }
    
          // Fake referance counting.
          STDMETHODIMP_(ULONG) AddRef() { return 1; }
          STDMETHODIMP_(ULONG) Release() { return 2; }

          STDMETHODIMP QueryInterface(REFIID riid, void **ppvObject)
          {
              if (NULL == ppvObject) return E_POINTER;
              if (riid == __uuidof(IUnknown))
              {
                  *ppvObject = static_cast<IUnknown*>(this);
                  return S_OK;
              }
              if (riid == __uuidof(ISampleGrabberCB))
              {
                  *ppvObject = static_cast<ISampleGrabberCB*>(this);
                  return S_OK;
              }
              *ppvObject = NULL;
              return E_NOTIMPL;
          }

          // called from another thread!!!
          STDMETHODIMP SampleCB(double time, IMediaSample *pSample)
          {
            if ( pSample )
               {
                 long actual_size = pSample->GetActualDataLength();
                 if ( actual_size > 0 )
                    {
                      BYTE *buff = NULL;
                      if ( SUCCEEDED(pSample->GetPointer(&buff)) && buff )
                         {
                           BOOL b_format_ok = TRUE;
                           
                           AM_MEDIA_TYPE *p_mt = NULL;
                           pSample->GetMediaType(&p_mt);

                           if ( p_mt )
                              {
                                b_format_ok = FALSE;

                                if ( p_mt->formattype == FORMAT_VideoInfo && 
                                     p_mt->pbFormat && 
                                     p_mt->cbFormat >= sizeof(VIDEOINFOHEADER) )
                                   {
                                     const VIDEOINFOHEADER *v = (VIDEOINFOHEADER*)p_mt->pbFormat;

                                     int width = v->bmiHeader.biWidth;
                                     int height = v->bmiHeader.biHeight;
                                     int bpp = v->bmiHeader.biBitCount;

                                     if ( width == i_width && height == i_height && bpp == i_bpp )
                                        {
                                          b_format_ok = TRUE;
                                        }
                                   }

                                CMediaHelper::MyDeleteMediaType(p_mt);
                                p_mt = NULL;
                              }
                           
                           if ( b_format_ok )
                              {
                                if ( p_shot )
                                   {
                                     p_shot->UpdateFrameIfNotLocked(time,i_width,i_height,i_bpp,buff,actual_size);
                                   }
                              }
                         }
                    }
               }

            return S_OK;
          }

          STDMETHODIMP BufferCB(double Time, BYTE *pBuffer, long BufferLen)
          {
              return E_NOTIMPL;
          }
};


///////////////////

CSingleWebCam::CSingleWebCam(IBaseFilter *_filt,const WCHAR *_devicepath,const WCHAR *_name)
{
  ws_devicepath = sys_copystringW(_devicepath);
  ws_name = sys_copystringW(_name);

  p_capfilt = _filt;
  if ( p_capfilt )
     p_capfilt->AddRef();

  p_build = NULL;
  p_graph = NULL;
  p_grabberfilt = NULL;
  p_grabber = NULL;
  p_nullfilt = NULL;
  p_shot = NULL;
  p_sample_cb = NULL;
  b_rendered = FALSE;
  last_render_try_time = GetTickCount() - 60000;
  b_dead = FALSE;

  if ( p_capfilt )
     {
       CoCreateInstance(CLSID_CaptureGraphBuilder2, NULL, CLSCTX_INPROC_SERVER, IID_ICaptureGraphBuilder2, (void**)&p_build );
       CoCreateInstance(CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, (void**)&p_graph);
       CoCreateInstance(CLSID_SampleGrabber,NULL,CLSCTX_INPROC_SERVER,IID_IBaseFilter,(void**)&p_grabberfilt);
       if ( p_grabberfilt )
          p_grabberfilt->QueryInterface(IID_ISampleGrabber,(void**)&p_grabber);
       CoCreateInstance(CLSID_NullRenderer,NULL,CLSCTX_INPROC_SERVER,IID_IBaseFilter,(void**)&p_nullfilt);

       if ( AreFiltersCreated() )
          {
            p_build->SetFiltergraph(p_graph);

            AM_MEDIA_TYPE mt;
            ZeroMemory(&mt,sizeof(mt));
            mt.majortype = MEDIATYPE_Video;
            mt.subtype = MEDIASUBTYPE_RGB24;
            mt.formattype = FORMAT_VideoInfo; 
            p_grabber->SetMediaType(&mt);

            p_graph->AddFilter(p_capfilt,L"_CapFilt");  // here error can be returned
            p_graph->AddFilter(p_grabberfilt,L"_GrabberFilt");
            p_graph->AddFilter(p_nullfilt,L"_NullFilt");

            Poll();
          }
     }
}


CSingleWebCam::~CSingleWebCam()
{
  // stop the graph
  if ( p_graph )
     {
       IMediaControl *pMediaControl = NULL;
       p_graph->QueryInterface(IID_IMediaControl,(void**)&pMediaControl);
       if ( pMediaControl )
          {
            pMediaControl->Stop();

            unsigned starttime = GetTickCount();
            while ( GetTickCount() - starttime < 3000 )
            {
              FILTER_STATE fs;
              HRESULT hr = pMediaControl->GetState(5,(OAFilterState*)&fs);

              if ( hr == E_FAIL )
                 break;
              else
              if ( hr == S_OK )
                 {
                   if ( fs == State_Stopped )
                      break;
                 }
            };
            
            pMediaControl->Release();
          }
     }

  // remove callback
  if ( p_grabber )
     {
       p_grabber->SetCallback(NULL,0);
     }

  // destroy rest objects
  SAFEDELETE(p_sample_cb);
  SAFEDELETE(p_shot);
  SAFERELEASE(p_nullfilt);
  SAFERELEASE(p_grabber);
  SAFERELEASE(p_grabberfilt);
  SAFERELEASE(p_graph);
  SAFERELEASE(p_build);
  SAFERELEASE(p_capfilt);
  SAFESYSFREE(ws_name);
  SAFESYSFREE(ws_devicepath);
}


BOOL CSingleWebCam::AreFiltersCreated() const
{
  return p_capfilt && p_build && p_graph && p_grabberfilt && p_grabber && p_nullfilt;
}


void CSingleWebCam::Poll()
{
  if ( !IsDead() )
     {
       if ( AreFiltersCreated() )
          {
            if ( b_rendered )
               {
                 //if ( p_shot && p_sample_cb )
                    {
                      IMediaEvent *pMediaEvent = NULL;
                      p_graph->QueryInterface(IID_IMediaEvent,(void**)&pMediaEvent);
                      if ( pMediaEvent )
                         {
                           do {

                             long ec;
                             LONG_PTR parm1,parm2;
                             if ( FAILED(pMediaEvent->GetEvent(&ec,&parm1,&parm2,0)) )
                                break;

                             if ( ec == EC_DEVICE_LOST )
                                {
                                  if ( parm2 == 0 )
                                     {
                                       b_dead = TRUE;
                                     }
                                  else
                                  if ( parm2 == 1 )
                                     {
                                     }
                                }

                             pMediaEvent->FreeEventParams(ec,parm1,parm2);

                           } while (1);
                         
                           pMediaEvent->Release();
                         }
                    }
               }
            else
               {
                 if ( GetTickCount() - last_render_try_time > 5000 )
                    {
                      if ( p_build->RenderStream(&PIN_CATEGORY_CAPTURE,&MEDIATYPE_Video,p_capfilt,p_grabberfilt,p_nullfilt) == S_OK )
                         {
                           b_rendered = TRUE;

                           // try to get real media type
                           AM_MEDIA_TYPE mt;
                           ZeroMemory(&mt,sizeof(mt));
                           if ( SUCCEEDED(p_grabber->GetConnectedMediaType(&mt)) )
                              {
                                if ( mt.formattype == FORMAT_VideoInfo && 
                                     mt.pbFormat && 
                                     mt.cbFormat >= sizeof(VIDEOINFOHEADER) )
                                   {
                                     const VIDEOINFOHEADER *v = (VIDEOINFOHEADER*)mt.pbFormat;

                                     int width = v->bmiHeader.biWidth;
                                     int height = v->bmiHeader.biHeight;  // negative values are supported
                                     int bpp = v->bmiHeader.biBitCount;

                                     if ( bpp == 24 || bpp == 32 )
                                        {
                                          p_shot = new CWebShot(width,height,bpp);
                                          p_sample_cb = new CGrabberSampleCB(p_shot,width,height,bpp);

                                          p_grabber->SetCallback(p_sample_cb,0);

                                          // run the graph
                                          IMediaControl *pMediaControl = NULL;
                                          p_graph->QueryInterface(IID_IMediaControl,(void**)&pMediaControl);
                                          if ( pMediaControl )
                                             {
                                               pMediaControl->Run();
                                               pMediaControl->Release();
                                             }
                                        }
                                   }

                                CMediaHelper::MyFreeMediaType(mt);
                              }
                         }
                      else
                         {
                           // device can be used by another app...
                         }

                      last_render_try_time = GetTickCount();
                    }
               }
          }
     }
}




//////////////////////

CWebCams::CWebCams()
{
  p_devenum = NULL;
  CoCreateInstance(CLSID_SystemDeviceEnum, NULL, CLSCTX_INPROC_SERVER, IID_ICreateDevEnum, reinterpret_cast<void**>(&p_devenum));
  last_add_try_time = GetTickCount() - 60000;

  Poll();
}


CWebCams::~CWebCams()
{
  for ( TCams::iterator it = m_cams.begin(); it != m_cams.end(); ++it )
      {
        SAFEDELETE(*it);
      }
  m_cams.clear();

  SAFERELEASE(p_devenum);
}


void CWebCams::Poll()
{
  // poll existing cams
  for ( TCams::const_iterator it = m_cams.begin(); it != m_cams.end(); ++it )
      {
        (*it)->Poll();
      }

  // delete deads
  BOOL b_deleted;
  do {
   b_deleted = FALSE;
   for ( TCams::iterator it = m_cams.begin(); it != m_cams.end(); ++it )
       {
         CSingleWebCam *j = *it;

         if ( j->IsDead() )
            {
              delete j;
              *it = NULL;
              m_cams.erase(it);
              b_deleted = TRUE;
              break;
            }
       }
  } while ( b_deleted );

  // add new devices
  if ( GetTickCount() - last_add_try_time > 10000 )
     {
       AddNewDevicesInternal();
       last_add_try_time = GetTickCount();
     }
}


void CWebCams::AddNewDevicesInternal()
{
  if ( p_devenum )
     {
       IEnumMoniker *pEnum = NULL;
       p_devenum->CreateClassEnumerator(CLSID_VideoInputDeviceCategory,&pEnum,0);

       if ( pEnum )
          {
            do {

             IMoniker *pMoniker = NULL;
             if ( pEnum->Next(1,&pMoniker,NULL) != S_OK )
                break;

             if ( pMoniker )
                {
                  IPropertyBag *pPropBag = NULL;
                  pMoniker->BindToStorage(NULL,NULL,IID_IPropertyBag,(void**)(&pPropBag));

                  if ( pPropBag )
                     {
                       WCHAR *ws_path = ReadStrFromPropBag(pPropBag,L"DevicePath");
                       WCHAR *ws_name = ReadStrFromPropBag(pPropBag,L"FriendlyName");

                       if ( !IsStrEmpty(ws_path) )
                          {
                            // check if this device unique
                            BOOL find = FALSE;
                            for ( TCams::const_iterator it = m_cams.begin(); it != m_cams.end(); ++it )
                                {
                                  if ( !StrCmpW((*it)->GetDevicePath(),ws_path) )
                                     {
                                       find = TRUE;
                                       break;
                                     }
                                }

                            if ( !find )
                               {
                                 IBaseFilter *pCap = NULL;
                                 pMoniker->BindToObject(NULL,NULL,IID_IBaseFilter,(void**)&pCap);

                                 if ( pCap )
                                    {
                                      // check if this is a VFW deprecated device filter
                                      IAMVfwCaptureDialogs *t = NULL;
                                      pCap->QueryInterface(IID_IAMVfwCaptureDialogs,(void**)&t);
                                      BOOL is_vfw = (t != NULL);
                                      SAFERELEASE(t);

                                      if ( !is_vfw )
                                         {
                                           CSingleWebCam *wc = new CSingleWebCam(pCap,ws_path,NNSW(ws_name));
                                           m_cams.push_back(wc);
                                         }

                                      pCap->Release();
                                    }
                               }
                          }

                       SAFESYSFREE(ws_path);
                       SAFESYSFREE(ws_name);

                       pPropBag->Release();
                     }

                  pMoniker->Release();
                }
             else
                break;

            } while (1);

            pEnum->Release();
          }
     }
}


WCHAR* CWebCams::ReadStrFromPropBag(IPropertyBag *pPropBag,const WCHAR *prop)
{
  WCHAR *out = NULL;

  if ( pPropBag )
     {
       VARIANT v;
       ZeroMemory(&v,sizeof(v)); //needed
       VariantInit(&v);

       if ( pPropBag->Read(prop,&v,NULL) == S_OK )
          {
            if ( v.vt == VT_BSTR )
               {
                 out = sys_copystringW(v.bstrVal);
               }
          }

       VariantClear(&v);
     }

  return out;
}



///////////////////////

CWebCamsMonitor::CWebCamsMonitor()
{
  m_obj.Poll();
}


CWebCamsMonitor::~CWebCamsMonitor()
{
}


void CWebCamsMonitor::Poll()
{
  m_obj.Poll();
}


void* CWebCamsMonitor::GetShot(BOOL use_gamma,float gamma,BOOL downtop,BOOL& _changed,int& _width,int& _height,int& _bpp,int& _rowstride)
{
  void *out_buff = NULL;
  
  const CWebCams::TCams& cams = m_obj.GetCamsList();

  // calculate num active webcams and max dimensions
  int count = 0;
  int max_width = 0;
  int max_height = 0;  //always positive
  for ( CWebCams::TCams::const_iterator it = cams.begin(); it != cams.end(); ++it )
      {
        const CSingleWebCam *c = *it;
        const CWebShot *sh = c->GetShot();
        if ( sh )
           {
             int w = sh->GetWidth();
             int h = sh->GetHeight();

             if ( w > 0 && h > 0 )
                {
                  if ( w > max_width )
                     max_width = w;
                  if ( h > max_height )
                     max_height = h;

                  count++;

                  if ( count == 4 )  // we do not support more than 4 webcams
                     break;
                }
           }
      }

  if ( count > 0 )
     {
       int g_width = (count == 1 ? max_width : max_width*2);
       int g_height = (count == 1 ? max_height : max_height*2);  // always positive
       int g_bpp = 24; // only BGR24 is accepted
       int g_rowstride = ((g_width*(g_bpp/8)+3)&~3);
       BOOL g_changed = FALSE;

       out_buff = sys_zalloc(g_rowstride*g_height); // zero clears
       if ( out_buff )
          {
            // copy images to global buff
            int idx = 0;
            for ( CWebCams::TCams::const_iterator it = cams.begin(); it != cams.end(); ++it )
                {
                  const CSingleWebCam *c = *it;
                  CWebShot *sh = c->GetShot();
                  if ( sh )
                     {
                       int w = sh->GetWidth();
                       int h = sh->GetHeight();

                       if ( w > 0 && h > 0 )
                          {
                            if ( sh->GetBPP() == g_bpp ) // paranoja
                               {
                                 BOOL b_changed;
                                 double timestamp;
                                 const void* shot_buff = sh->Lock(b_changed,timestamp);
                                 if ( shot_buff )
                                    {
                                      int d_x = (idx%2)*(g_width/2);
                                      int d_y = (idx/2)*(g_height/2);

                                      CopySingleImage24InternalNoCheck(out_buff,g_rowstride,g_width,g_height,d_x,d_y,downtop,shot_buff,sh->GetRowStride(),w,h,sh->IsDownTop());

                                      if ( b_changed )
                                         g_changed = TRUE;
                                    }
                                 sh->Unlock(); // we must call Unlock anywhere!
                               }

                            idx++;
                            if ( idx == count )
                               break;
                          }
                     }
                }

            if ( use_gamma )
               {
                 AdjustGammaBGRStride(out_buff,g_width,g_height,g_rowstride,gamma);
               }

            _changed = g_changed;
            _width = g_width;
            _height = g_height;
            _bpp = g_bpp;
            _rowstride = g_rowstride;
          }
     }

  return out_buff;
}


void CWebCamsMonitor::CopySingleImage24InternalNoCheck(
         void *d_buff,int d_rowstride,int d_width,int d_height,int d_x,int d_y,BOOL d_downtop,
         const void *s_buff,int s_rowstride,int s_width,int s_height,BOOL s_downtop)
{
  const int bpp = 24;
  
  for ( int y = 0; y < s_height; y++ )
      {
        char *d_row = (char*)d_buff + (d_downtop?(d_height-1-(d_y+y)):(d_y+y))*d_rowstride + d_x*(bpp/8);
        const char *s_row = (char*)s_buff + (s_downtop?(s_height-1-y):(y))*s_rowstride;
        int numbytes = s_width*(bpp/8);

        CopyMemory(d_row,s_row,numbytes);
      }
}


