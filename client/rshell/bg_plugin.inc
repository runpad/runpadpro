


CBGPlugin::CBGPlugin(const char *dllpath,int quality,BOOL mute)
{
  ClearVars();

  if ( !IsStrEmpty(dllpath) )
     {
       const char *ext = PathFindExtension(dllpath);
       if ( !lstrcmpi(ext,".vp") || !lstrcmpi(ext,".dll") )
          {
            UINT old_err = SetErrorMode(SEM_FAILCRITICALERRORS|SEM_NOGPFAULTERRORBOX|SEM_NOOPENFILEERRORBOX);

            try
            {
              hlib = LoadLibrary(dllpath);
            }
            catch ( ... )
            {
            }

            SetErrorMode(old_err);

            if ( hlib )
               {
                 *(void**)&pCreateObject   = (void*)GetProcAddress(hlib,"VP_CreateObject");
                 *(void**)&pDestroyObject  = (void*)GetProcAddress(hlib,"VP_DestroyObject");
                 *(void**)&pIsMotion       = (void*)GetProcAddress(hlib,"VP_IsMotion");
                 *(void**)&pPlay           = (void*)GetProcAddress(hlib,"VP_Play");
                 *(void**)&pPause          = (void*)GetProcAddress(hlib,"VP_Pause");
                 *(void**)&pPaintTo        = (void*)GetProcAddress(hlib,"VP_PaintTo");
                 *(void**)&pOnResize       = (void*)GetProcAddress(hlib,"VP_OnResize");
                 *(void**)&pSetCallback    = (void*)GetProcAddress(hlib,"VP_SetCallback");

                 if ( pCreateObject && pDestroyObject && pIsMotion && pPlay && pPause && pPaintTo && pOnResize && pSetCallback )
                    {
                      try
                      {
                        p_obj = pCreateObject(quality,mute);
                      }
                      catch ( ... )
                      {
                      }
                    }
               }
          }
     }
}


CBGPlugin::~CBGPlugin()
{
  if ( p_obj )
     {
       try
       {
         pDestroyObject(p_obj);
       }
       catch ( ... )
       {
       }

       p_obj = NULL;
     }

  if ( hlib )
     {
       try
       {
         FreeLibrary(hlib);
       }
       catch ( ... )
       {
       }

       hlib = NULL;
     }

  ClearVars();
}


void CBGPlugin::ClearVars()
{
  hlib = NULL;

  pCreateObject = NULL;
  pDestroyObject = NULL;
  pIsMotion = NULL;
  pPlay = NULL;
  pPause = NULL;
  pPaintTo = NULL;
  pOnResize = NULL;
  pSetCallback = NULL;

  p_obj = NULL;
}


BOOL CBGPlugin::IsLoaded() const
{
  return p_obj != NULL;
}


BOOL CBGPlugin::IsMotion() const
{
  BOOL rc = FALSE;
  
  if ( IsLoaded() )
     {
       try
       {
         rc = pIsMotion(p_obj);
       }
       catch ( ... )
       {
       }
     }

  return rc;
}


BOOL CBGPlugin::Play()
{
  BOOL rc = FALSE;
  
  if ( IsLoaded() )
     {
       try
       {
         rc = pPlay(p_obj);
       }
       catch ( ... )
       {
       }
     }

  return rc;
}


BOOL CBGPlugin::Pause()
{
  BOOL rc = FALSE;
  
  if ( IsLoaded() )
     {
       try
       {
         rc = pPause(p_obj);
       }
       catch ( ... )
       {
       }
     }

  return rc;
}


BOOL CBGPlugin::PaintTo(HDC hdc,int x,int y,int width,int height)
{
  BOOL rc = FALSE;
  
  if ( IsLoaded() )
     {
       try
       {
         rc = pPaintTo(p_obj,hdc,x,y,width,height);
       }
       catch ( ... )
       {
       }
     }

  return rc;
}


void CBGPlugin::OnResize(int width,int height)
{
  if ( IsLoaded() )
     {
       try
       {
         pOnResize(p_obj,width,height);
       }
       catch ( ... )
       {
       }
     }
}


void CBGPlugin::SetCallback(TBGCallback cb,void *cb_parm)
{
  if ( IsLoaded() )
     {
       try
       {
         pSetCallback(p_obj,cb,cb_parm);
       }
       catch ( ... )
       {
       }
     }
}


