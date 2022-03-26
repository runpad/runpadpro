

static const char *prop_name = "this_class_pointer";


void CWindowProc::InitWindowProcWrapper(HWND hwnd)
{
  SetProp(hwnd,prop_name,(HANDLE)this);
}


void CWindowProc::DoneWindowProcWrapper(HWND hwnd)
{
  RemoveProp(hwnd,prop_name);
}


LRESULT CALLBACK CWindowProc::WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  CWindowProc *obj = (CWindowProc*)GetProp(hwnd,prop_name);

  if ( obj )
     {
       return obj->WindowProc(hwnd,message,wParam,lParam);
     }
  else
     {
       return DefWindowProc(hwnd,message,wParam,lParam);
     }
}


