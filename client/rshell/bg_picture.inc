

CBGPicture::CBGPicture(const char *filepath,int quality)
{
  rbuff = NULL;
  hbitmap = NULL;
  i_quality = quality;

  
  if ( !IsStrEmpty(filepath) )
     {
       char filename[MAX_PATH] = "";
       
       if ( PathIsDirectory(filepath) )
          {
            filename[0] = 0;
            GetRandomPictureFileFromGallery(filepath,filename);
          }
       else
          {
            lstrcpy(filename,filepath);
          }

       if ( !IsStrEmpty(filename) )
          {
            const char *ext = PathFindExtension(filename);
            if ( !lstrcmpi(ext,".bmp") ||
                 !lstrcmpi(ext,".jpg") ||
                 !lstrcmpi(ext,".jpeg") ||
                 !lstrcmpi(ext,".jpe") ||
                 !lstrcmpi(ext,".png") ||
                 !lstrcmpi(ext,".tif") ||
                 !lstrcmpi(ext,".tiff") ||
                 !lstrcmpi(ext,".gif") )
               {
                 hbitmap = LoadPicAsHBitmap(filename);
               }
          }
     }
}


CBGPicture::~CBGPicture()
{
  if ( rbuff )
     delete rbuff;
  rbuff = NULL;

  if ( hbitmap )
     DeleteObject(hbitmap);
  hbitmap = NULL;
}


BOOL CBGPicture::IsLoaded() const
{
  return hbitmap != NULL;
}


BOOL CBGPicture::IsMotion() const
{
  return FALSE;
}


BOOL CBGPicture::Play()
{
  return TRUE;
}


BOOL CBGPicture::Pause()
{
  return TRUE;
}


BOOL CBGPicture::PaintTo(HDC hdc,int x,int y,int width,int height)
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


void CBGPicture::OnResize(int width,int height)
{
  if ( width > 0 && height > 0 )
     {
       if ( hbitmap )
          {
            if ( !rbuff || rbuff->GetWidth() != width || rbuff->GetHeight() != height )
               {
                 // realloc buffer
                 if ( rbuff )
                    delete rbuff;
                 rbuff = NULL;
                 rbuff = new CRBuff(width,height,24,FALSE);

                 // copy resized image to it
                 {
                   int sw = 0, sh = 0;
                   GetBitmapDim(hbitmap,&sw,&sh);

                   if ( sw > 0 && sh > 0 )
                      {
                        int dw = width;
                        int dh = height;

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
                             // resize
                             Graphics *gr = new Graphics(rbuff->GetHDC());

                             gr->SetCompositingMode(CompositingModeSourceCopy);
                             gr->SetCompositingQuality(CompositingQualityHighSpeed);
                             gr->SetInterpolationMode(i_quality>50?InterpolationModeBilinear:InterpolationModeLowQuality);

                             Bitmap *b = new Bitmap(hbitmap,(HPALETTE)NULL);

                             int sx = (sw-aw)/2;
                             int sy = (sh-ah)/2;
                             int dx = 0;
                             int dy = 0;
                             
                             gr->DrawImage(b,Rect(dx,dy,dw,dh),sx,sy,aw,ah,UnitPixel,NULL,NULL,NULL);
                             gr->Flush(FlushIntentionSync);

                             delete b;
                             delete gr;
                           }
                      }
                 }
               }
          }
     }
}


void CBGPicture::SetCallback(TBGCallback cb,void *cb_parm)
{
}






