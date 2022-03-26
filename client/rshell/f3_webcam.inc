

static CWebCamsMonitor *webcam = NULL;


static BOOL IsWebCamConnected()
{
  return webcam != NULL;
}


static void ConnectWebCam()
{
  if ( !IsWebCamConnected() )
     {
       webcam = new CWebCamsMonitor();
     }
}


void DisconnectWebCam()
{
  SAFEDELETE(webcam);
}


void PollWebCam()
{
  if ( IsWebCamConnected() )
     {
       webcam->Poll();
     }
}


static IStream* GrabWebCamToStreamInternal(BOOL use_gamma)
{
  IStream *out = NULL;

  if ( IsWebCamConnected() )
     {
       BOOL b_changed = FALSE;
       int width=0,height=0,bpp=0,rowstride=0;
       void *buff = webcam->GetShot(use_gamma,0.50,FALSE,b_changed,width,height,bpp,rowstride);
       if ( buff )
          {
            if ( bpp == 24 )
               {
                 Bitmap *pBitmap = new Bitmap(width,height,rowstride,PixelFormat24bppRGB,(BYTE*)buff);
                 out = SaveImageToStream(pBitmap,L"image/jpeg");
                 delete pBitmap;
               }

            sys_free(buff);
          }
     }

  return out;
}


IStream* GrabSingleWebCam()
{ 
  BOOL prev_connect = IsWebCamConnected();

  if ( !prev_connect )
     {
       ConnectWebCam();
       Sleep(1000); // dont want to make this pretty...
     }

  IStream *stream = GrabWebCamToStreamInternal(TRUE);

  if ( !prev_connect )
     DisconnectWebCam();

  return stream;
}


IStream* GrabSeqWebCam()
{ 
  if ( !IsWebCamConnected() )
     ConnectWebCam();

  return GrabWebCamToStreamInternal(FALSE);
}


