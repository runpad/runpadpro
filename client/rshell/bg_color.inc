


CBGStaticColor::CBGStaticColor(int color)
{
  i_color = color;
}


CBGStaticColor::~CBGStaticColor()
{
}


BOOL CBGStaticColor::IsMotion() const
{
  return FALSE;
}


BOOL CBGStaticColor::Play()
{
  return TRUE;
}


BOOL CBGStaticColor::Pause()
{
  return TRUE;
}


BOOL CBGStaticColor::PaintTo(HDC hdc,int x,int y,int width,int height)
{
  BOOL rc = FALSE;

  if ( hdc )
     {
       RECT r;
       SetRect(&r,x,y,x+width,y+height);
       HBRUSH brush = CreateSolidBrush(i_color);
       FillRect(hdc,&r,brush);
       DeleteObject(brush);
       rc = TRUE;
     }

  return rc;
}


void CBGStaticColor::OnResize(int width,int height)
{
}


void CBGStaticColor::SetCallback(TBGCallback cb,void *cb_parm)
{
}


