


class CMediaSampleCB : public ISampleGrabberCB
{
          CBGVideo *p_obj;
          int i_width;
          int i_height;
          int i_bpp;
  
  public:
          CMediaSampleCB(CBGVideo *_obj,int _width,int _height,int _bpp) 
            : p_obj(_obj), i_width(_width), i_height(_height), i_bpp(_bpp) {}
          ~CMediaSampleCB() { p_obj = NULL; }
    
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
            if ( pSample && p_obj )
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

                                CBGVideo::MyDeleteMediaType(p_mt);
                                p_mt = NULL;
                              }
                           
                           if ( b_format_ok )
                              {
                                p_obj->OnSampleCB_AnotherThread(buff,actual_size);
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




CBGVideo::CBGVideo(const char *filepath,int quality,BOOL mute)
{
  InitializeCriticalSection(&o_cs);

  b_data_processed = TRUE;  // we are ready to next frame
  obuff = NULL;
  rbuff = NULL;

  m_wnd = NULL;
  wnd_class_atom = NULL;
  msg_newframe = RegisterWindowMessage("_MsgCBGVideo_newframe");
  msg_poll = RegisterWindowMessage("_MsgCBGVideo_poll");
  last_repeat_time = GetTickCount() - 10000;

  pGraphBuilder = NULL;
  pGrabberBaseFilter = NULL;
  pSampleGrabber = NULL;
  pSampleCB = NULL;

  i_quality = quality;

  user_cb = NULL;
  user_cb_parm = NULL;


  if ( !IsStrEmpty(filepath) )
     {
       const char *ext = PathFindExtension(filepath);
       if ( !lstrcmpi(ext,".avi") ||
            !lstrcmpi(ext,".asf") ||
            !lstrcmpi(ext,".mpeg") ||
            !lstrcmpi(ext,".mpe") ||
            !lstrcmpi(ext,".mpg") ||
            !lstrcmpi(ext,".wmv") )
          {
            LoadVideoInternal(filepath,!mute);  //obuff also be allocated here
          }
     }

  if ( IsLoaded() )
     {
       // create our message-window
       WNDCLASS wc;
       ZeroMemory(&wc,sizeof(wc));
       wc.lpfnWndProc = WindowProcWrapper;
       wc.hInstance = our_instance;
       wc.lpszClassName = "_CBGVideoMessageOnlyWindowClass";
       wnd_class_atom = RegisterClass(&wc);

       m_wnd = CreateWindowEx(0,(LPCSTR)wnd_class_atom,NULL,0,0,0,0,0,HWND_MESSAGE,NULL,our_instance,NULL);
       SetProp(m_wnd,"this",(HANDLE)this);
     }
}


CBGVideo::~CBGVideo()
{
  Stop();  // must be called first

  if ( m_wnd )
     DestroyWindow(m_wnd);
  m_wnd = NULL;

  if ( wnd_class_atom )
     UnregisterClass((LPCSTR)wnd_class_atom,our_instance);
  wnd_class_atom = NULL;

  FreeVideoInternal(); // obuff must be deleted here

  if ( rbuff )
     delete rbuff;
  rbuff = NULL;

  user_cb = NULL;
  user_cb_parm = NULL;

  DeleteCriticalSection(&o_cs);
}


BOOL CBGVideo::IsLoaded() const
{
  return pGraphBuilder && pGrabberBaseFilter && pSampleGrabber && pSampleCB && obuff;
}


BOOL CBGVideo::IsMotion() const
{
  return TRUE;
}


BOOL CBGVideo::Play()
{
  BOOL rc = FALSE;
  
  if ( IsLoaded() )
     {
       IMediaControl *pMediaControl = NULL;
       pGraphBuilder->QueryInterface(IID_IMediaControl,(void**)&pMediaControl);
       if ( pMediaControl )
          {
            FILTER_STATE fs;
            if ( SUCCEEDED(pMediaControl->GetState(0,(OAFilterState*)&fs)) )
               {
                 if ( fs == State_Paused )
                    {
                      if ( SUCCEEDED(pMediaControl->Run()) )
                         {
                           rc = TRUE;
                         }
                    }
                 else
                 if ( fs == State_Stopped )
                    {
                      IMediaEventEx *pMediaEventEx = NULL;
                      pGraphBuilder->QueryInterface(IID_IMediaEventEx,(void**)&pMediaEventEx);
                      if ( pMediaEventEx )
                         {
                           // remove old callbacks (paranoja)
                           pMediaEventEx->SetNotifyWindow(NULL,WM_NULL,NULL);
                           pSampleGrabber->SetCallback(NULL,0);

                           // set new callbacks
                           pMediaEventEx->SetNotifyWindow((OAHWND)m_wnd,msg_poll,NULL);
                           pSampleGrabber->SetCallback(pSampleCB,0);

                           pSampleGrabber->SetOneShot(FALSE);
                           pSampleGrabber->SetBufferSamples(FALSE);

                           if ( FAILED(pMediaControl->Run()) )
                              {
                                pMediaEventEx->SetNotifyWindow(NULL,WM_NULL,NULL);
                                pSampleGrabber->SetCallback(NULL,0);
                              }
                           else
                              {
                                rc = TRUE;
                              }

                           pMediaEventEx->Release();
                         }
                    }
                 else
                 if ( fs == State_Running )
                    {
                      rc = TRUE;
                    }
               }
          
            pMediaControl->Release();
          }
     }

  return rc;
}


BOOL CBGVideo::Pause()
{
  BOOL rc = FALSE;

  if ( IsLoaded() )
     {
       IMediaControl *pMediaControl = NULL;
       pGraphBuilder->QueryInterface(IID_IMediaControl,(void**)&pMediaControl);
       if ( pMediaControl )
          {
            FILTER_STATE fs;
            if ( SUCCEEDED(pMediaControl->GetState(0,(OAFilterState*)&fs)) )
               {
                 if ( fs == State_Running )
                    {
                      if ( SUCCEEDED(pMediaControl->Pause()) )
                         {
                           rc = TRUE;
                         }
                    }
                 else
                    {
                      rc = TRUE;
                    }
               }
          
            pMediaControl->Release();
          }
     }

  return rc;
}


BOOL CBGVideo::Stop()
{
  BOOL rc = FALSE;

  if ( IsLoaded() )
     {
       IMediaControl *pMediaControl = NULL;
       pGraphBuilder->QueryInterface(IID_IMediaControl,(void**)&pMediaControl);
       if ( pMediaControl )
          {
            pMediaControl->Stop();
            
            unsigned starttime = GetTickCount();
            do {
              FILTER_STATE fs;
              if ( FAILED(pMediaControl->GetState(5,(OAFilterState*)&fs)) )
                 break;
              if ( fs == State_Stopped )
                 break;
            } while ( GetTickCount()-starttime < 100 );

            IMediaEventEx *pMediaEventEx = NULL;
            pGraphBuilder->QueryInterface(IID_IMediaEventEx,(void**)&pMediaEventEx);
            if ( pMediaEventEx )
               {
                 pMediaEventEx->SetNotifyWindow(NULL,WM_NULL,NULL);
                 pMediaEventEx->Release();
               }

            pSampleGrabber->SetCallback(NULL,0);

            {
              CCSGuard oGuard(o_cs);  //ensure that no callbacks are in this time
            }

            rc = TRUE;  // do not check errors here
            
            pMediaControl->Release();
          }
     }

  return rc;
}


BOOL CBGVideo::PaintTo(HDC hdc,int x,int y,int width,int height)
{
  BOOL rc = FALSE;

  if ( hdc )
     {
       if ( rbuff )
          {
            if ( rbuff->GetWidth() == width && rbuff->GetHeight() == height )
               {
                 rc = rbuff->PaintTo(hdc,x,y);
               }
          }
     }

  return rc;
}


void CBGVideo::OnResize(int width,int height)
{
  if ( IsLoaded() )
     {
       if ( width > 0 && height > 0 )
          {
            ReallocResizedBuff(width,height);
            {
              CCSGuard oGuard(o_cs);
              FillResizedBuff_NoGuard();
            }
          }
     }
}


void CBGVideo::SetCallback(TBGCallback cb,void *cb_parm)
{
  if ( IsLoaded() )
     {
       user_cb = cb;
       user_cb_parm = cb_parm;
     }
}


// called from another thread!!!!!
void CBGVideo::OnSampleCB_AnotherThread(const void *data,unsigned size)
{
  if ( data && size > 0 )
     {
       if ( TryEnterCriticalSection(&o_cs) )
          {
            if ( b_data_processed )
               {
                 if ( obuff )
                    {
                      if ( obuff->CopyRawDataFrom(data,size) )
                         {
                           b_data_processed = FALSE;

                           if ( IsWindow(m_wnd) )  //paranoja
                              {
                                PostMessage(m_wnd,msg_newframe,0,0);
                              }
                         }
                    }
               }

            LeaveCriticalSection(&o_cs);
          }
     }
}


void CBGVideo::ReallocResizedBuff(int width,int height)
{
  if ( width > 0 && height > 0 )
     {
       if ( obuff ) // optimization
          {
            if ( !rbuff || rbuff->GetWidth() != width || rbuff->GetHeight() != height )
               {
                 if ( rbuff )
                    delete rbuff;
                 rbuff = NULL;
                 rbuff = new CRBuff(width,height,24,FALSE);
               }
          }
     }
}


BOOL CBGVideo::FillResizedBuff_NoGuard()
{
  BOOL rc = FALSE;

  if ( obuff && rbuff )
     {
       int sw = obuff->GetWidth();
       int sh = obuff->GetHeight();
       int dw = rbuff->GetWidth();
       int dh = rbuff->GetHeight();

       if ( sw > 0 && sh > 0 && dw > 0 && dh > 0 )
          {
            int aw,ah;

            if ( sh >= dh * sw / dw )  
               { 
                 ah = dh * sw / dw;
                 aw = sw;
               }
            else
               { 
                 aw = dw * sh / dh;
                 ah = sh;
               }

            if ( aw > 0 && aw <= sw && ah > 0 && ah <= sh ) //paranoja
               {
                 // actual resizing
                 BOOL low_quality = (i_quality <= 50);

                 int sx = (sw-aw)/2;
                 int sy = (sh-ah)/2;
                 int dx = 0;
                 int dy = 0;

                 if ( low_quality && obuff->GetBuff() && rbuff->GetBuff() )
                    {
                      Stretch24InternalNoCheck(rbuff,dx,dy,dw,dh,obuff,sx,sy,aw,ah);
                      rc = TRUE;
                    }
                 else
                    {
                      if ( obuff->GetBuff() )
                         {
                           Graphics *gr = new Graphics(rbuff->GetHDC());

                           gr->SetCompositingMode(CompositingModeSourceCopy);
                           gr->SetCompositingQuality(CompositingQualityHighSpeed);
                           gr->SetInterpolationMode(low_quality?InterpolationModeLowQuality:InterpolationModeBilinear);

                           Bitmap *b = new Bitmap(obuff->GetBitmapInfo(),obuff->GetBuff());

                           rc = (gr->DrawImage(b,Rect(dx,dy,dw,dh),sx,sy,aw,ah,UnitPixel,NULL,NULL,NULL) == Ok);
                           gr->Flush(FlushIntentionSync);

                           delete b;
                           delete gr;
                         }
                    }
               }
          }
     }

  return rc;
}


LRESULT CALLBACK CBGVideo::WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  CBGVideo *obj = (CBGVideo*)GetProp(hwnd,"this");

  if ( obj )
     {
       return obj->WindowProc(hwnd,message,wParam,lParam);
     }
  else
     {
       return DefWindowProc(hwnd,message,wParam,lParam);
     }
}


LRESULT CBGVideo::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == msg_newframe )
     {
       if ( this && IsWindow(hwnd) && IsLoaded() )  // paranoja
          {
            OnNewFrameInternal();
          }

       return 0;
     }
  
  if ( message == msg_poll )
     {
       if ( this && IsWindow(hwnd) && IsLoaded() )  // paranoja
          {
            OnPollInternal();
          }

       return 0;
     }
  
  switch ( message )
  {
    case WM_DESTROY:
                     RemoveProp(hwnd,"this");
                     break;

    case WM_CLOSE:
                     return 0;

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CBGVideo::OnNewFrameInternal()
{
  BOOL rc = FALSE;
  
  {
    CCSGuard oGuard(o_cs);

    if ( !b_data_processed )
       {
         rc = FillResizedBuff_NoGuard();
         b_data_processed = TRUE;
       }
  }

  if ( rc )
     {
       if ( user_cb )
          {
            if ( !user_cb(user_cb_parm) )
               {
                 Pause();
               }
          }
     }
}


void CBGVideo::OnPollInternal()
{
  if ( IsLoaded() )
     {
       IMediaEvent *pMediaEvent = NULL;
       pGraphBuilder->QueryInterface(IID_IMediaEvent,(void**)&pMediaEvent);
       if ( pMediaEvent )
          {
            do {

              long ec;
              LONG_PTR parm1,parm2;
              if ( FAILED(pMediaEvent->GetEvent(&ec,&parm1,&parm2,0)) )
                 break;

              pMediaEvent->FreeEventParams(ec,parm1,parm2);

              if ( ec == EC_COMPLETE )
                 {
                   if ( GetTickCount() - last_repeat_time > 200 ) // to avoid error streams
                      {
                        IMediaSeeking *pMediaSeeking = NULL;
                        pGraphBuilder->QueryInterface(IID_IMediaSeeking,(void**)&pMediaSeeking);
                        if ( pMediaSeeking )
                           {
                             LONGLONG pos = 0;
                             pMediaSeeking->SetPositions(&pos,AM_SEEKING_AbsolutePositioning,NULL,AM_SEEKING_NoPositioning);
                             pMediaSeeking->Release();
                           }

                        last_repeat_time = GetTickCount();
                      }
                 }
              else
              if ( ec == EC_ERRORABORT )
                 {
                 }
              else
              if ( ec == EC_USERABORT )
                 {
                 }

            } while (1);
          
            pMediaEvent->Release();
          }
     }
}


void CBGVideo::LoadVideoInternal(const char *filename,BOOL use_sound)
{
  BOOL rc = FALSE;
  
  pGraphBuilder = NULL;
  pGrabberBaseFilter = NULL;
  pSampleGrabber = NULL;
  pSampleCB = NULL;
  obuff = NULL;

  EnableFFDshowForOurApp();
  
  CoCreateInstance(CLSID_FilterGraph,NULL,CLSCTX_INPROC_SERVER,IID_IGraphBuilder,(void**)&pGraphBuilder);
  if ( pGraphBuilder )
     {
       HRESULT hr = pGraphBuilder->RenderFile(CUnicode(filename),NULL);
       if ( SUCCEEDED(hr) && hr != VFW_S_VIDEO_NOT_RENDERED )
          {
            CoCreateInstance(CLSID_SampleGrabber,NULL,CLSCTX_INPROC_SERVER,IID_IBaseFilter,(void**)&pGrabberBaseFilter);
            if ( pGrabberBaseFilter )
               {
                 pGrabberBaseFilter->QueryInterface(IID_ISampleGrabber,(void**)&pSampleGrabber);
                 if ( pSampleGrabber )
                    {
                      if ( SUCCEEDED(pGraphBuilder->AddFilter(pGrabberBaseFilter,L"_MyGrabber")) )
                         {
                           AM_MEDIA_TYPE mt;
                           ZeroMemory(&mt,sizeof(mt));
                           mt.majortype = MEDIATYPE_Video;
                           mt.subtype = MEDIASUBTYPE_RGB24; //MEDIASUBTYPE_YUY2
                           mt.formattype = FORMAT_VideoInfo; 
                           if ( SUCCEEDED(pSampleGrabber->SetMediaType(&mt)) )
                              {
                                if ( PrepareGraph(pGraphBuilder,pGrabberBaseFilter,!use_sound) )
                                   {
                                     AM_MEDIA_TYPE mt;
                                     ZeroMemory(&mt,sizeof(mt));
                                     if ( SUCCEEDED(pSampleGrabber->GetConnectedMediaType(&mt)) )
                                        {
                                          if ( mt.formattype == FORMAT_VideoInfo && 
                                               mt.pbFormat && 
                                               mt.cbFormat >= sizeof(VIDEOINFOHEADER) )
                                             {
                                               const VIDEOINFOHEADER *v = (VIDEOINFOHEADER*)mt.pbFormat;

                                               int width = v->bmiHeader.biWidth;
                                               int height = v->bmiHeader.biHeight;
                                               int bpp = v->bmiHeader.biBitCount;

                                               if ( width > 0 && height != 0 && bpp == 24 )
                                                  {
                                                    pSampleCB = new CMediaSampleCB(this,width,height,bpp);
                                                    obuff = new CRBuff(width,height,bpp,TRUE);
                                                    rc = TRUE;
                                                  }
                                             }

                                          MyFreeMediaType(mt);
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }

  if ( !rc )
     {
       SAFEDELETE(obuff);
       SAFEDELETE(pSampleCB);
       SAFERELEASE(pSampleGrabber);
       SAFERELEASE(pGrabberBaseFilter);
       SAFERELEASE(pGraphBuilder);
     }
}


void CBGVideo::FreeVideoInternal()
{
  SAFERELEASE(pSampleGrabber);
  SAFERELEASE(pGrabberBaseFilter);
  SAFERELEASE(pGraphBuilder);
  SAFEDELETE(pSampleCB); //it is safe with this free order!
  {
    CCSGuard oGuard(o_cs);  //paranoja
    SAFEDELETE(obuff); //it is safe with this free order!
  }
}


// returns only first pin in _input, _output
BOOL CBGVideo::GetFilterPins(IBaseFilter *filter,int *_num_inputs,int *_num_outputs,IPin **_input,IPin **_output)
{
  BOOL rc = FALSE;

  if ( _num_inputs )
     *_num_inputs = 0;
  if ( _num_outputs )
     *_num_outputs = 0;
  if ( _input )
     *_input = NULL;
  if ( _output )
     *_output = NULL;

  if ( filter )
     {
       IEnumPins *ep = NULL;
       filter->EnumPins(&ep);
       if ( ep )
          {
            rc = TRUE;

            int num_inputs = 0;
            int num_outputs = 0;
            
            do {
             IPin *pin = NULL;
             ep->Next(1,&pin,NULL);
             if ( !pin )
                break;

             PIN_DIRECTION dir;
             pin->QueryDirection(&dir);
             if ( dir == PINDIR_INPUT )
                {
                  num_inputs++;
                  if ( _input && (*_input) == NULL )
                     *_input = pin;
                  else
                     pin->Release();
                }
             else
                {
                  num_outputs++;
                  if ( _output && (*_output) == NULL )
                     *_output = pin;
                  else
                     pin->Release();
                }

            } while (1);

            if ( _num_inputs )
               *_num_inputs = num_inputs;
            if ( _num_outputs )
               *_num_outputs = num_outputs;

            ep->Release();
          }
     }

  return rc;
}


// returns only first find renderer
// pass MEDIATYPE_Audio, MEDIATYPE_Video
IBaseFilter* CBGVideo::FindRenderer(IFilterGraph *pGraph,const GUID &media_type)
{
  IBaseFilter *rc = NULL;

  if ( pGraph )
     {
       IEnumFilters *ef = NULL;
       pGraph->EnumFilters(&ef);

       if ( ef )
          {
            do {
              IBaseFilter *filter = NULL;
              ef->Next(1,&filter,NULL);
              if ( !filter )
                 break;

              int numinputs = 0;
              int numoutputs = 0;
              IPin *input = NULL;
              GetFilterPins(filter,&numinputs,&numoutputs,&input,NULL);

              if ( numinputs == 1 && numoutputs == 0 )
                 {
                   if ( input )
                      {
                        AM_MEDIA_TYPE mt;
                        ZeroMemory(&mt,sizeof(mt));
                        if ( SUCCEEDED(input->ConnectionMediaType(&mt)) )
                           {
                             if ( IsEqualGUID(mt.majortype,media_type) )
                                {
                                  rc = filter;
                                  filter = NULL;
                                }
                           }
                      }
                 }
              
              SAFERELEASE(input);
              SAFERELEASE(filter);

              if ( rc )
                 break;

            } while (1);

            ef->Release();
          }
     }

  return rc;
}


IBaseFilter* CBGVideo::GetPinConnectedFilter(IPin *pin)
{
  IBaseFilter* rc = NULL;

  if ( pin )
     {
       IPin *pin2 = NULL;
       pin->ConnectedTo(&pin2);

       if ( pin2 )
          {
            PIN_INFO pi;
            if ( SUCCEEDED(pin2->QueryPinInfo(&pi)) )
               rc = pi.pFilter;
            pin2->Release();
          }
     }

  return rc;
}


IPin* CBGVideo::GetPinConnectedPin(IPin *pin)
{
  IPin* rc = NULL;

  if ( pin )
     {
       IPin *pin2 = NULL;
       pin->ConnectedTo(&pin2);
       rc = pin2;
     }

  return rc;
}


void CBGVideo::RemoveRendererChain(IFilterGraph *pGraph,IBaseFilter *renderer)
{
  if ( pGraph && renderer )
     {
       IBaseFilter *curr = renderer;
       curr->AddRef();

       do {
         int numinputs = 0;
         int numoutputs = 0;
         IPin *input = NULL;
         GetFilterPins(curr,&numinputs,&numoutputs,&input,NULL);

         if ( numinputs != 1 || numoutputs > 1 || !input )
            {
              SAFERELEASE(input);
              SAFERELEASE(curr);
              break;
            }

         IBaseFilter *left = GetPinConnectedFilter(input);
         SAFERELEASE(input);

         pGraph->RemoveFilter(curr);  //we do not check for errors here
         curr->Release();
         
         curr = left;

       } while ( curr );
     }
}


BOOL CBGVideo::RemoveAudio(IFilterGraph *pGraph)
{
  BOOL rc = FALSE;

  if ( pGraph )
     {
       IBaseFilter *audio = FindRenderer(pGraph,MEDIATYPE_Audio);
       if ( audio )
          {
            RemoveRendererChain(pGraph,audio);
            SAFERELEASE(audio);
          }

       audio = FindRenderer(pGraph,MEDIATYPE_Audio);
       if ( audio )
          {
            SAFERELEASE(audio);
          }
       else
          {
            rc = TRUE;
          }
     }

  return rc;
}


BOOL CBGVideo::AddOurFilterWithNullRenderer(IFilterGraph *pGraph,IPin *left_pin,IBaseFilter *pOurFilter)
{
  BOOL rc = FALSE;

  if ( pGraph && left_pin && pOurFilter )
     {
       // create and add NULL-Renderer
       IBaseFilter *pNull = NULL;
       CoCreateInstance(CLSID_NullRenderer,NULL,CLSCTX_INPROC_SERVER,IID_IBaseFilter,(void**)&pNull);
       if ( pNull )
          {
            if ( SUCCEEDED(pGraph->AddFilter(pNull,L"_MyNullRenderer")) )
               {
                 // connect left_pin with our filter
                 IPin *my_input = NULL;
                 IPin *my_output = NULL;
                 GetFilterPins(pOurFilter,NULL,NULL,&my_input,&my_output);
                 if ( my_input && my_output )
                    {
                      if ( SUCCEEDED(pGraph->ConnectDirect(left_pin,my_input,NULL)) )
                         {
                           // connect our filter with NULL-renderer
                           IPin *null_input = NULL;
                           GetFilterPins(pNull,NULL,NULL,&null_input,NULL);
                           if ( null_input )
                              {
                                if ( SUCCEEDED(pGraph->ConnectDirect(my_output,null_input,NULL)) )
                                   {
                                     rc = TRUE;
                                   }

                                SAFERELEASE(null_input);
                              }
                         }
                    }

                 SAFERELEASE(my_input);
                 SAFERELEASE(my_output);
               }

            pNull->Release();
          }
     }

  return rc;
}


BOOL CBGVideo::ReplaceVideo(IFilterGraph *pGraph,IBaseFilter *pOurFilter)
{
  BOOL rc = FALSE;

  if ( pGraph && pOurFilter )
     {
       // find default video renderer
       IBaseFilter *video = FindRenderer(pGraph,MEDIATYPE_Video);
       if ( video )
          {
            IPin *input = NULL;
            GetFilterPins(video,NULL,NULL,&input,NULL);
            IPin *left_pin = input ? GetPinConnectedPin(input) : NULL;
            SAFERELEASE(input);

            if ( left_pin )
               {
                 pGraph->RemoveFilter(video);
                 video->Release();

                 video = FindRenderer(pGraph,MEDIATYPE_Video);
                 if ( !video )
                    {
                      if ( AddOurFilterWithNullRenderer(pGraph,left_pin,pOurFilter) )
                         {
                           rc = TRUE;
                         }
                    }
                 else
                    {
                      video->Release();
                    }

                 left_pin->Release();
               }
            else
               {
                 video->Release();
               }
          }
     }

  return rc;
}


BOOL CBGVideo::PrepareGraph(IFilterGraph *pGraph,IBaseFilter *pOurFilter,BOOL b_remove_audio)
{
  BOOL rc = FALSE;

  if ( pGraph && pOurFilter )
     {
       if ( !b_remove_audio || RemoveAudio(pGraph) )
          {
            if ( ReplaceVideo(pGraph,pOurFilter) )
               {
                 rc = TRUE;
               }
          }
     }

  return rc;
}


void CBGVideo::MyFreeMediaType(AM_MEDIA_TYPE& mt)
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


void CBGVideo::MyDeleteMediaType(AM_MEDIA_TYPE* mt)
{
  if ( mt )
     {
       MyFreeMediaType(*mt);
       CoTaskMemFree((PVOID)mt);
     }
}



// enable modify of ebp register
#pragma warning (disable:4731)

void CBGVideo::StretchRow24(char *dest,int d_width,const char *src,int s_width)
{
#ifndef DEBUG
  int k = s_width * 65536 / d_width;
  int offs = 0;
  int count = d_width;
  do {
    const char *s = &src[(offs >> 16) * 3];

    *dest++ = *s++;
    *dest++ = *s++;
    *dest++ = *s++;

    offs += k;
  } while (--count);
#else
__asm {
	pushad
	mov	eax,s_width
	shl	eax,16
	xor	edx,edx
	div	d_width
	mov	edx,eax       // edx = k
	mov	ebx,src     // ebx = src
	mov	edi,dest    // edi = dest
	mov	ecx,d_width // ecx = width
	mov	ebp,0   // ebp = offs (must be last)
L1:
	mov	eax,ebp
	shr	eax,16
	lea	esi,[eax+eax*2]
	mov	al,[esi+ebx+0]
	mov	[edi],al
	inc	edi
	mov	al,[esi+ebx+1]
	mov	[edi],al
	inc	edi
	mov	al,[esi+ebx+2]
	mov	[edi],al
	inc	edi
	add	ebp,edx
	dec	ecx
	jne	L1
	popad
};
#endif
}


void CBGVideo::Stretch24InternalNoCheck(CRBuff *db,int d_x,int d_y,int d_width,int d_height,
                                        const CRBuff *sb,int s_x,int s_y,int s_width,int s_height)
{
  for ( int row = 0; row < d_height; row++ )
      {
        int real_dest_y = (db->IsDownTop() ? (db->GetHeight()-1 - (row + d_y)) : (row + d_y) );
        char *dest = (char*)db->GetBuff() + real_dest_y * db->GetRowStride() + d_x*3;

        int y_offs = row * s_height / d_height;
        int real_src_y = (sb->IsDownTop() ? (sb->GetHeight()-1 - (y_offs + s_y)) : (y_offs + s_y) );
        const char *src = (char*)sb->GetBuff() + real_src_y * sb->GetRowStride() + s_x*3;

        StretchRow24(dest,d_width,src,s_width);
      }
}


