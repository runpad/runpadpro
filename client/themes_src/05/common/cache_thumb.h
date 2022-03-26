
#ifndef __CACHE_THUMB_H__
#define __CACHE_THUMB_H__



class CThumbsCache
{
         // warining!!!
         // in this version we do not use automatic cache cleaning up
         static const int max_cache_thumbs = 100;  // not used at this version
         
         CRITICAL_SECTION o_cs;

         HBITMAP m_default_thumb;

         typedef std::pair<char*,HBITMAP> TCacheElem;
         typedef std::vector<TCacheElem> TCache;  // todo: hash_map is better here
         TCache m_cache;

         HANDLE h_thread;
         HANDLE h_event_stop;
         HANDLE h_event_wake;
         HANDLE h_event_thread_processing;

         HWND host_wnd;
         int wnd_message;
         int msg_wParam;

  public:
         CThumbsCache(HINSTANCE _inst,int _def_img_res_id,HWND _wnd,int _message,int _wParam);
         ~CThumbsCache();

         void Clear();
         HBITMAP GetThumb(const char *filename,BOOL &_default);

  private:
         void Clear_NoGuard();
         static DWORD WINAPI ThreadProcWrapper(void *parm);
         void ThreadProc();
         void ProcessLoading();
         //void SmartCleanup_NoGuard();

};



#endif

