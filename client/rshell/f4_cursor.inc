

unsigned CWaitCursor::ref_count = 0;


CWaitCursor::CWaitCursor()
{
  ::SetCursor(cur_wait);
  ref_count++;
}


CWaitCursor::~CWaitCursor()
{
  ref_count--;

  if ( ref_count == 0 )
     {
       ::SetCursor(cur_arrow);
     }
}


unsigned CWaitCursor::GetRefCount()
{
  return CWaitCursor::ref_count;
}


void CWaitCursor::UpdateCurrentCursor()
{
  ::SetCursor( CWaitCursor::GetRefCount() ? cur_wait : cur_arrow );
}


BOOL CWaitCursor::IsWaitCursor()
{
  return CWaitCursor::ref_count > 0;
}


