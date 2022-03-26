
static CHWIdent* hwidents[] =
{
  NULL, // iButton
};


void InitHWIdents()
{
  hwidents[0] = allow_hwident_ibutton ? new CiButton() : NULL;
  
}


void DoneHWIdents()
{
  for ( int n = 0; n < sizeof(hwidents)/sizeof(hwidents[0]); n++ )
      {
        if ( hwidents[n] )
           delete hwidents[n];
        hwidents[n] = NULL;
      }
}


// we return only first one event
// return FALSE if no events
BOOL GetHWIdentsEvent(CHWIdent::EHWIdentDevice *_device,char *id,int max_id_chars)
{
  BOOL rc = FALSE;

  if ( _device )
     *_device = CHWIdent::HWID_NONE;

  if ( id )
     id[0] = 0;
  
  for ( int n = 0; n < sizeof(hwidents)/sizeof(hwidents[0]); n++ )
      {
        if ( hwidents[n] )
           {
             if ( hwidents[n]->IsEvent(id,max_id_chars) )
                {
                  if ( _device )
                     *_device = hwidents[n]->GetType();

                  rc = TRUE;
                  break;
                }
           }
      }

  return rc;
}

