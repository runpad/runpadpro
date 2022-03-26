


CSystemIcon::CSystemIcon(HICON handle,BOOL is_handle_must_be_owned_by_class)
{
  m_handle = is_handle_must_be_owned_by_class ? handle : ::CopyIcon(handle);
  b_is_mask_present = TRUE;
  b_is_picture = FALSE;

  m_width = 0;
  m_height = 0;
  GetIconDim(m_handle,m_width,m_height);
}


CSystemIcon::CSystemIcon(const char *picfile,int dw,int dh)
{
  m_handle = NULL;
  b_is_mask_present = FALSE;
  b_is_picture = TRUE;
  m_width = 0;
  m_height = 0;
  
  if ( dw > 0 && dh > 0 )
     {
       HBITMAP hbm = LoadPicAsHBitmap(picfile);

       if ( hbm )
          {
            BITMAP bi;
            if ( ::GetObject((HGDIOBJ)hbm,sizeof(bi),&bi) > 0 )
               {
                 int sw = bi.bmWidth;
                 int sh = bi.bmHeight;
                 BOOL is_alpha = ((bi.bmBitsPixel==32) && IsPNGPictureFile(picfile));

                 if ( sw > 0 && sh > 0 )
                    {
                      HBITMAP hmask = NULL;
                      HBITMAP hcolor = CreateResizedBitmapInternalNoCheck(hbm,sw,sh,dw,dh,!is_alpha,is_alpha,hmask);
                      if ( hcolor && hmask )
                         {
                           ICONINFO ii;
                           ii.fIcon = TRUE;
                           ii.hbmMask = hmask;
                           ii.hbmColor = hcolor;
                           HICON icon = ::CreateIconIndirect(&ii);
                           if ( icon )
                              {
                                m_handle = icon;
                                b_is_mask_present = is_alpha;
                                b_is_picture = TRUE;
                                m_width = dw;
                                m_height = dh;
                              }
                         }

                      if ( hmask )
                         ::DeleteObject(hmask);
                      if ( hcolor )
                         ::DeleteObject(hcolor);
                    }
               }

            ::DeleteObject(hbm);
          }
     }
}


CSystemIcon::~CSystemIcon()
{
  if ( m_handle )
     {
       ::DestroyIcon(m_handle);
     }
}


BOOL CSystemIcon::GetIconDim(HICON handle,int& _width,int& _height)
{
  BOOL rc = FALSE;

  ICONINFO i;
  if ( ::GetIconInfo(handle,&i) )
     {
       if ( i.hbmColor )
          {
            BITMAP bi;
            if ( ::GetObject((HGDIOBJ)i.hbmColor,sizeof(bi),&bi) > 0 )
               {
                 _width = bi.bmWidth;
                 _height = bi.bmHeight;

                 rc = TRUE;
               }
          }

       if ( i.hbmMask )
          ::DeleteObject(i.hbmMask);
       if ( i.hbmColor )
          ::DeleteObject(i.hbmColor);
     }

  return rc;
}


HBITMAP CSystemIcon::Create1FillMonoBitmap(int width,int height,const unsigned *buff32)
{
  HBITMAP hbm = NULL;
  
  if ( width > 0 && height > 0 )
     {
       int rowstride = ((width+15)&~15)/8;
       void *buff = sys_alloc(rowstride*height);
       if ( buff )
          {
            FillMemory(buff,rowstride*height,0x00); // fill with ~'1' all

            if ( buff32 )
               {
                 for ( int m = 0; m < height; m++ )
                     {
                       const unsigned *src = &buff32[(height-1-m)*width];
                       unsigned char *dest = (unsigned char*)buff+m*rowstride;
                       
                       for ( int n = 0; n < width; n++ )
                           {
                             if ( !((*src++) & 0xFF000000) )
                                {
                                  dest[n>>3] |= (1 << (7-(n&7)));
                                }
                           }
                     }
               }

            hbm = ::CreateBitmap(width,height,1,1,buff);

            sys_free(buff);
          }
     }

  return hbm;
}


HBITMAP CSystemIcon::CreateResizedBitmapInternalNoCheck(HBITMAP sbm,int sw,int sh,int dw,int dh,BOOL draw_border,BOOL is_alpha,HBITMAP& _mask)
{
  _mask = NULL;
  HBITMAP rc = NULL;
  
  CRBuff *rbuff = new CRBuff(dw,dh,is_alpha?32:24,TRUE);

  if ( !rbuff->IsEmpty() )
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
            // resize
            int sx = (sw-aw)/2;
            int sy = (sh-ah)/2;
            int dx = 0;
            int dy = 0;

            if ( !is_alpha )
               {
                 Graphics *gr = new Graphics(rbuff->GetHDC());

                 gr->SetCompositingMode(CompositingModeSourceCopy);
                 gr->SetCompositingQuality(CompositingQualityHighSpeed);
                 gr->SetInterpolationMode(InterpolationModeBilinear);

                 Bitmap *b = new Bitmap(sbm,(HPALETTE)NULL);

                 gr->DrawImage(b,Rect(dx,dy,dw,dh),sx,sy,aw,ah,UnitPixel,NULL,NULL,NULL);

                 if ( draw_border )
                    {
                      Pen pen1(Color(140,140,140),1);
                      Pen pen2(Color(70,70,70),1);

                      gr->DrawLine(&pen1,0,dh-1,0,0);
                      gr->DrawLine(&pen1,0,0,dw,0);
                      gr->DrawLine(&pen2,dw-1,0,dw-1,dh);
                      gr->DrawLine(&pen2,dw-1,dh-1,0,dh-1);
                    }
                 
                 gr->Flush(FlushIntentionSync);

                 delete b;
                 delete gr;

                 _mask = Create1FillMonoBitmap(dw,dh,NULL);
               }
            else
               {
                 HDC s_hdc = CreateCompatibleDC(NULL);
                 HBITMAP old_bitmap = (HBITMAP)SelectObject(s_hdc,sbm);

                 BLENDFUNCTION bf;

                 bf.BlendOp = AC_SRC_OVER;
                 bf.BlendFlags = 0;
                 bf.SourceConstantAlpha = 255;
                 bf.AlphaFormat = AC_SRC_ALPHA;

                 SetStretchBltMode(rbuff->GetHDC(),HALFTONE);
                 SetBrushOrgEx(rbuff->GetHDC(),0,0,NULL);
                 AlphaBlend(rbuff->GetHDC(),dx,dy,dw,dh,s_hdc,sx,sy,aw,ah,bf);

                 SelectObject(s_hdc,old_bitmap);
                 DeleteDC(s_hdc);

                 _mask = Create1FillMonoBitmap(dw,dh,(const unsigned*)rbuff->GetBuff());
               }

            rc = rbuff->ReleaseBitmap();
          }
     }

  delete rbuff;

  return rc;
}


BOOL CSystemIcon::DrawTo(HDC hdc,int x,int y,int w,int h) const
{
  return ::DrawIconEx(hdc,x,y,m_handle,w,h,0,NULL,IsMaskPresent()?DI_NORMAL:DI_IMAGE);
}


BOOL CSystemIcon::DrawTo(HDC hdc,int x,int y) const
{
  return ::DrawIconEx(hdc,x,y,m_handle,m_width,m_height,0,NULL,IsMaskPresent()?DI_NORMAL:DI_IMAGE);
}

