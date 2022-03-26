


CBackground4Window::CBackground4Window(HWND _wnd,int color,const char *filepath,int quality)
{
  b_finish_creation = FALSE;

  p_bg = NULL;

  msg_wnd = NULL;
  wnd_class_atom = NULL;

  host_wnd = _wnd;
  last_window_vis_state = -1;

  start_play_time = 0;

  if ( host_wnd )
     {
       int width = 0;
       int height = 0;

       if ( !IsIconic(host_wnd) )
          {
            RECT r = {0,0,0,0};
            GetClientRect(host_wnd,&r);
            width = r.right - r.left;
            height = r.bottom - r.top;
          }
       
       p_bg = new CBackground(color,filepath,quality,TRUE,NULL,NULL,width,height,FALSE);

       if ( p_bg->IsMotion() )
          {
            // create our message window
            WNDCLASS wc;
            ZeroMemory(&wc,sizeof(wc));
            wc.lpfnWndProc = WindowProcWrapper;
            wc.hInstance = our_instance;
            wc.lpszClassName = "_CBackground4WindowMessageOnlyWindowClass";
            wnd_class_atom = RegisterClass(&wc);

            msg_wnd = CreateWindowEx(0,(LPCSTR)wnd_class_atom,NULL,0,0,0,0,0,HWND_MESSAGE,NULL,our_instance,NULL);
            InitWindowProcWrapper(msg_wnd);

            SetTimer(msg_wnd,1,200,NULL);

            // play...
            last_window_vis_state = GetWindowVisState(host_wnd);
            if ( last_window_vis_state )
               p_bg->Play();
            start_play_time = GetTickCount();  // before SetCallback()
            p_bg->SetCallback(CallbackBG,this); //after Play()
          }
     }

  b_finish_creation = TRUE;
}


CBackground4Window::~CBackground4Window()
{
  b_finish_creation = FALSE;  // to avoid callbacks in destructor calls (paranoja)

  if ( p_bg )
     delete p_bg;
  p_bg = NULL;

  if ( msg_wnd )
     DestroyWindow(msg_wnd);
  msg_wnd = NULL;

  if ( wnd_class_atom )
     UnregisterClass((LPCSTR)wnd_class_atom,our_instance);
  wnd_class_atom = NULL;

  host_wnd = NULL;
}


BOOL CBackground4Window::IsMotion() const
{
  return p_bg ? p_bg->IsMotion() : FALSE;
}


BOOL CBackground4Window::PaintTo(CRBuff *rbuff)
{
  BOOL rc = FALSE;

  if ( rbuff )
     {
       if ( p_bg )
          {
            if ( p_bg->PaintTo(rbuff->GetHDC(),0,0,rbuff->GetWidth(),rbuff->GetHeight()) )
               {
                 if ( p_bg->IsMotion() )
                    {
                      DoGFX(rbuff);
                    }

                 rc = TRUE;
               }
          }
     }

  return rc;
}


void CBackground4Window::OnResize(int width,int height)
{
  if ( p_bg )
     {
       p_bg->OnResize(width,height);
     }
}


void CBackground4Window::OnWindowStateChanged()
{
  CheckWindowState();
}


LRESULT CBackground4Window::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_TIMER:
                     CheckWindowState();
                     return 0;
    
    case WM_DESTROY:
                     DoneWindowProcWrapper(hwnd);
                     break;

    case WM_CLOSE:
                     return 0;

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}


void CBackground4Window::CheckWindowState()
{
  if ( p_bg && p_bg->IsMotion() )
     {
       if ( host_wnd )
          {
            int new_state = GetWindowVisState(host_wnd);
            if ( new_state != last_window_vis_state )
               {
                 last_window_vis_state = new_state;

                 if ( new_state )
                    {
                      p_bg->Play();
                    }
                 else
                    {
                      p_bg->Pause();
                    }
               }
          }
     }
}


BOOL CBackground4Window::OnCallback()
{
  if ( b_finish_creation && host_wnd && IsWindow(host_wnd) && p_bg )  // paranoja
     {
       if ( !IsIconic(host_wnd) /*&& IsWindowVisible(host_wnd)*/ ) // optimization
          {
            InvalidateRect(host_wnd,NULL,FALSE);
          }
     }

  return TRUE;
}


BOOL __stdcall CBackground4Window::CallbackBG(void *parm)
{
  if ( parm )
     {
       return reinterpret_cast<CBackground4Window*>(parm)->OnCallback();
     }
  else
     {
       return FALSE;
     }
}


void CBackground4Window::DoGFX(CRBuff *rbuff)
{
  if ( rbuff )
     {
       const unsigned gfx_time = 1000;
       unsigned delta_time = GetTickCount() - start_play_time;
       if ( delta_time < gfx_time )
          {
            unsigned char *buff = (unsigned char*)rbuff->GetBuff();
            int width = rbuff->GetWidth();
            int height = rbuff->GetHeight();
 
            if ( buff && width > 0 && height > 0 )
               {
                 unsigned char k_table[256];

                 float k = (float)delta_time/gfx_time;

                 for ( int n = 0; n < 256; n++ )
                     k_table[n] = n * k;

                 for ( int row = 0; row < height; row++ )
                     {
                       unsigned char *dest = buff + row * rbuff->GetRowStride();

                       if ( rbuff->GetBPP() == 24 )
                          ShadeRow24InternalNoCheck(dest,k_table,width);
                       else
                       if ( rbuff->GetBPP() == 32 )
                          ShadeRow32InternalNoCheck(dest,k_table,width);
                     }
               }
          }
     }
}


void CBackground4Window::ShadeRow24InternalNoCheck(unsigned char *buff,const unsigned char *k_table,int count)
{
#ifndef DEBUG
  do {
   *buff++ = k_table[*buff];
   *buff++ = k_table[*buff];
   *buff++ = k_table[*buff];
  } while ( --count );
#else
  __asm {
	pushad
	mov	ecx,count
	mov	esi,buff
	mov	ebx,k_table
L1:
	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	dec	ecx
	jne	L1
	popad
  };
#endif
}


void CBackground4Window::ShadeRow32InternalNoCheck(unsigned char *buff,const unsigned char *k_table,int count)
{
#ifndef DEBUG
  do {
   *buff++ = k_table[*buff];
   *buff++ = k_table[*buff];
   *buff++ = k_table[*buff];
   buff++;
  } while ( --count );
#else
  __asm {
	pushad
	mov	ecx,count
	mov	esi,buff
	mov	ebx,k_table
L1:
	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	movzx	eax,byte ptr [esi]
	mov	al,[eax+ebx]
	mov	[esi],al
	inc	esi

	inc	esi

	dec	ecx
	jne	L1
	popad
  };
#endif
}


int CBackground4Window::GetWindowVisState(HWND hwnd)
{
  return (IsWindowClientRealVisible(hwnd) && CanUseGFX()) ? 1 : 0;
}

