

CBackground::CBackground(int color,const char *filepath,int quality,BOOL mute,
                         CBGBase::TBGCallback cb,void *cb_parm,
                         int initial_width,int initial_height,BOOL autoplay)
{
  p_obj = NULL;

  if ( !p_obj )
     {
       CBGPlugin *t = new CBGPlugin(filepath,quality,mute);
       if ( !t->IsLoaded() )
          delete t;
       else
          p_obj = t;
     }

  if ( !p_obj )
     {
       CBGVideo *t = new CBGVideo(filepath,quality,mute);
       if ( !t->IsLoaded() )
          delete t;
       else
          p_obj = t;
     }

  if ( !p_obj )
     {
       CBGPicture *t = new CBGPicture(filepath,100);
       if ( !t->IsLoaded() )
          delete t;
       else
          p_obj = t;
     }

  if ( !p_obj )
     p_obj = new CBGStaticColor(color);

  if ( initial_width > 0 && initial_height > 0 )
     {
       p_obj->OnResize(initial_width,initial_height);
     }

  if ( cb )
     {
       p_obj->SetCallback(cb,cb_parm);
     }

  if ( autoplay )
     {
       p_obj->Play();
     }
}


CBackground::~CBackground()
{
  SAFEDELETE(p_obj);
}


BOOL CBackground::IsMotion() const
{
  return p_obj ? p_obj->IsMotion() : FALSE;
}


BOOL CBackground::Play()
{
  return p_obj ? p_obj->Play() : FALSE;
}


BOOL CBackground::Pause()
{
  return p_obj ? p_obj->Pause() : FALSE;
}


BOOL CBackground::PaintTo(HDC hdc,int x,int y,int width,int height)
{
  return p_obj ? p_obj->PaintTo(hdc,x,y,width,height) : FALSE;
}


void CBackground::OnResize(int width,int height)
{
  if ( p_obj )
     p_obj->OnResize(width,height);
}


void CBackground::SetCallback(CBGBase::TBGCallback cb,void *cb_parm)
{
  if ( p_obj )
     p_obj->SetCallback(cb,cb_parm);
}


