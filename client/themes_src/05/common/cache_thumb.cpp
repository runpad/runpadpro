
#include "common.h"



CThumbsCache::CThumbsCache(HINSTANCE _inst,int _def_img_res_id,HWND _wnd,int _message,int _wParam)
{
  InitializeCriticalSection(&o_cs);
  
  m_default_thumb = ::LoadPicFromResource(_inst,_def_img_res_id);
  ASSERT(m_default_thumb);

  host_wnd = _wnd;

  if ( _wnd )
     { // use this assert only if cache cleaning is used
       ASSERT( GetCurrentThreadId() == GetWindowThreadProcessId(_wnd,NULL) );
     }

  wnd_message = _message;
  msg_wParam = _wParam;

  h_event_stop = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_event_wake = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_event_thread_processing = CreateEvent(NULL,TRUE/*manual_reset*/,FALSE,NULL);

  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,CREATE_SUSPENDED,NULL);
  SetThreadPriority(h_thread,THREAD_PRIORITY_NORMAL); //THREAD_PRIORITY_BELOW_NORMAL
//  SetThreadAffinityMask(h_thread,0x1); //paranoja for some AMD2 bug
  ResumeThread(h_thread);
}


CThumbsCache::~CThumbsCache()
{
  SetEvent(h_event_stop); // must be first!
  SetEvent(h_event_wake);
  if ( WaitForSingleObject(h_thread,500) == WAIT_TIMEOUT )
     {
       TerminateThread(h_thread,0);
     }
  CloseHandle(h_thread);
  h_thread = NULL;

  CloseHandle(h_event_stop);
  h_event_stop = NULL;
  CloseHandle(h_event_wake);
  h_event_wake = NULL; 
  CloseHandle(h_event_thread_processing);
  h_event_thread_processing = NULL; 
  
  if ( m_default_thumb )
     {
       ::DeleteObject(m_default_thumb);
       m_default_thumb = NULL;
     }
  
  Clear_NoGuard();

  DeleteCriticalSection(&o_cs);
}


void CThumbsCache::Clear_NoGuard()
{
  for ( int n = 0; n < m_cache.size(); n++ )
      {
        FREEANDNULL(m_cache[n].first);

        if ( m_cache[n].second != NULL && m_cache[n].second != m_default_thumb )
           ::DeleteObject(m_cache[n].second);
        m_cache[n].second = NULL;
      }

  m_cache.clear();
}


void CThumbsCache::Clear()
{
  CCSGuard g(o_cs);
  
  Clear_NoGuard();
}


DWORD WINAPI CThumbsCache::ThreadProcWrapper(void *parm)
{
  if ( parm )
     {
       reinterpret_cast<CThumbsCache*>(parm)->ThreadProc();
       return 1;
     }

  return 0;
}


void CThumbsCache::ThreadProc()
{
  do {

   WaitForSingleObject(h_event_wake,INFINITE);

   if ( WaitForSingleObject(h_event_stop,0) == WAIT_OBJECT_0 )
      break;

   ProcessLoading();

  } while (1);
}


void CThumbsCache::ProcessLoading()
{
  SetEvent(h_event_thread_processing);
  
  do {
  
    // find first image to load
    char filename[MAX_PATH] = "";
    {
      CCSGuard g(o_cs);

      for ( int n = 0; n < m_cache.size(); n++ )
          {
            if ( m_cache[n].second == NULL )
               {
                 lstrcpyn(filename,m_cache[n].first,sizeof(filename));
                 break;
               }
          }
    }

    if ( IsStrEmpty(filename) )
       break;

    // load it
    HBITMAP b = LoadPicAsHBitmap(filename);  // maybe take a lot of time...
    if ( !b )
       b = m_default_thumb;

    if ( b == NULL )
       break; // prevent deadlock, only if m_default_thumb is NULL

    // update it in cache
    BOOL updated = FALSE;
    {
      CCSGuard g(o_cs);

      for ( int n = 0; n < m_cache.size(); n++ )
          {
            if ( !lstrcmpi(m_cache[n].first,filename) )
               {
                 if ( m_cache[n].second == NULL )
                    {
                      m_cache[n].second = b;
                      updated = TRUE;

                      if ( b != m_default_thumb ) // optimization
                         {
                           if ( host_wnd && IsWindow(host_wnd) )
                              PostMessage(host_wnd,wnd_message,msg_wParam,(int)sys_copystring(filename));
                         }
                    }

                 break;
               }
          }
    }

    if ( !updated )
       {
         if ( b != m_default_thumb )
            ::DeleteObject(b);
       }

    Sleep(1);

  } while (1);

  ResetEvent(h_event_thread_processing);
}


HBITMAP CThumbsCache::GetThumb(const char *_filename,BOOL &_default)
{
  // check if empty
  if ( IsStrEmpty(_filename) )
     {
       _default = TRUE;
       return m_default_thumb;
     }

  // special check
  if ( m_default_thumb == NULL )
     {
       _default = TRUE;
       return m_default_thumb;
     }
     
  // find it in cache
  HBITMAP b = NULL;
  {
    CCSGuard g(o_cs);

    BOOL find = FALSE;
    for ( int n = 0; n < m_cache.size(); n++ )
        {
          if ( !lstrcmpi(m_cache[n].first,_filename) )
             {
               find = TRUE;
               b = m_cache[n].second;
               break;
             }
        }

    if ( !find )
       {
         // we do not use clear cache mechanism!
         
         //MSG msg;
         //
         //BOOL b_thread_working = (WaitForSingleObject(h_event_thread_processing,0) == WAIT_OBJECT_0);
         //BOOL b_queue_msgs = (host_wnd && PeekMessage(&msg,host_wnd,wnd_message,wnd_message,PM_NOREMOVE));
         //
         //if ( !b_thread_working && !b_queue_msgs )
         //   {
         //     SmartCleanup_NoGuard();
         //   }
         
         m_cache.push_back(TCacheElem(sys_copystring(_filename),NULL));
         SetEvent(h_event_wake);
       }
  }

  _default = (!b || b == m_default_thumb);
  return b ? b : m_default_thumb;
}


//void CThumbsCache::SmartCleanup_NoGuard()
//{
//  int cnt = 0;
//
//  for ( int n = 0; n < m_cache.size(); n++ )
//      {
//        if ( m_cache[n].second != NULL && m_cache[n].second != m_default_thumb )
//           {
//             cnt++;
//           }
//      }
//
//  if ( cnt > max_cache_thumbs )
//     {
//       const int del_count = cnt - max_cache_thumbs;
//
//       for ( int n = 0; n < del_count; n++ )
//           {
//             for ( TCache::iterator it = m_cache.begin(); it != m_cache.end(); ++it )
//                 {
//                   if ( (*it).second != NULL && (*it).second != m_default_thumb )
//                      {
//                        FREEANDNULL((*it).first);
//                        ::DeleteObject((*it).second);
//                        (*it).second = NULL;
//                        m_cache.erase(it);
//                        break;
//                      }
//                 }
//           }
//     }
//}




