

CBackground4Sheet::CBackground4Sheet(HWND _wnd,CSheet *_sheet)
{
  p_bg = NULL;
  rbuff = NULL;

  if ( _wnd && _sheet )
     {
       int width = 0;
       int height = 0;

       if ( !IsIconic(_wnd) )
          {
            RECT r = {0,0,0,0};
            GetClientRect(_wnd,&r);
            width = r.right - r.left;
            height = r.bottom - r.top;
          }

       if ( width > 0 && height > 0 )
          {
            rbuff = CreateRBuffInternalNoCheck(width,height,TRUE);
          }

       int quality = (high_quality_bg_video ? 100 : 0);
       p_bg = new CBackground4Window(_wnd,_sheet->GetBGColor(),CPathExpander(_sheet->GetBGPath()),quality);
     }
}


CBackground4Sheet::~CBackground4Sheet()
{
  SAFEDELETE(p_bg);
  SAFEDELETE(rbuff);
}


CRBuff* CBackground4Sheet::CreateRBuffInternalNoCheck(int width,int height,BOOL b_clear)
{
  return (new CRBuff(width,-height,32,b_clear));
}


BOOL CBackground4Sheet::IsMotion() const
{
  return p_bg ? p_bg->IsMotion() : FALSE;
}


BOOL CBackground4Sheet::PaintToInternalBuff()
{
  BOOL rc = FALSE;

  if ( rbuff && p_bg )
     {
       rc = p_bg->PaintTo(rbuff);
     }

  return rc;
}


CRBuff* CBackground4Sheet::GetInternalBuff() const
{
  return rbuff;
}


void CBackground4Sheet::OnResize(int width,int height)
{
  if ( width > 0 && height > 0 )
     {
       if ( p_bg )  //optimization
          {
            if ( !rbuff || !rbuff->IsSizeMatch(width,height) )
               {
                 SAFEDELETE(rbuff);
                 rbuff = CreateRBuffInternalNoCheck(width,height,FALSE);
               }

            p_bg->OnResize(width,height);
          }
     }
}


void CBackground4Sheet::OnWindowStateChanged()
{
  if ( p_bg )
     {
       p_bg->OnWindowStateChanged();
     }
}


