
#ifndef __BACKGROUND_H__
#define __BACKGROUND_H__


class CRBuff;
class CBackground;
class CBackground4Window;
interface ISampleGrabber;


class CBackground4Sheet
{
          CBackground4Window *p_bg;
          CRBuff *rbuff;

  public:
          CBackground4Sheet(HWND _wnd,CSheet *_sheet);
          ~CBackground4Sheet();

          BOOL IsMotion() const;
          BOOL PaintToInternalBuff();
          CRBuff* GetInternalBuff() const;
          void OnResize(int width,int height);
          void OnWindowStateChanged();

  protected:
          friend class CSheetWindow;
          static CRBuff* CreateRBuffInternalNoCheck(int width,int height,BOOL b_clear);

};


class CBackground4Window : public CWindowProc
{
          BOOL b_finish_creation;  // to avoid callbacks calls during creation of this object

          CBackground *p_bg;

          HWND msg_wnd;
          ATOM wnd_class_atom;

          HWND host_wnd;
          int last_window_vis_state;  // -1 - intermediate

          unsigned start_play_time;

  public:
          CBackground4Window(HWND _wnd,int color,const char *filepath,int quality=0);
          ~CBackground4Window();

          BOOL IsMotion() const;
          BOOL PaintTo(CRBuff *rbuff);
          void OnResize(int width,int height);
          void OnWindowStateChanged();
          
  protected:
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);

  private:
          void CheckWindowState();
          BOOL OnCallback();
          static BOOL __stdcall CallbackBG(void *parm);
          void DoGFX(CRBuff *rbuff);
          void ShadeRow24InternalNoCheck(unsigned char *buff,const unsigned char *k_table,int count);
          void ShadeRow32InternalNoCheck(unsigned char *buff,const unsigned char *k_table,int count);
          static int GetWindowVisState(HWND hwnd);
};


class CBGBase
{
  public:
          typedef BOOL (__stdcall *TBGCallback)(void *parm);

  public:
          virtual ~CBGBase() {}

          virtual BOOL IsMotion() const = 0;
          virtual BOOL Play() = 0;
          virtual BOOL Pause() = 0;
          virtual BOOL PaintTo(HDC hdc,int x,int y,int width,int height) = 0;
          virtual void OnResize(int width,int height) = 0;
          virtual void SetCallback(TBGCallback cb,void *cb_parm) = 0;
};


class CBackground
{
          CBGBase *p_obj;

  public:
          CBackground(int color,const char *filepath,int quality=0,BOOL mute=TRUE,
                      CBGBase::TBGCallback cb=NULL,void *cb_parm=NULL,
                      int initial_width=0,int initial_height=0,BOOL autoplay=FALSE);
          ~CBackground();

          BOOL IsMotion() const;
          BOOL Play();
          BOOL Pause();
          BOOL PaintTo(HDC hdc,int x,int y,int width,int height);
          void OnResize(int width,int height);
          void SetCallback(CBGBase::TBGCallback cb,void *cb_parm);
};


class CBGStaticColor : public CBGBase
{
          int i_color;

  public:
          CBGStaticColor(int color);
          ~CBGStaticColor();

          BOOL IsMotion() const;
          BOOL Play();
          BOOL Pause();
          BOOL PaintTo(HDC hdc,int x,int y,int width,int height);
          void OnResize(int width,int height);
          void SetCallback(TBGCallback cb,void *cb_parm);
};


class CBGPicture : public CBGBase
{
          CRBuff *rbuff;
          HBITMAP hbitmap;
          int i_quality;

  public:
          CBGPicture(const char *filepath,int quality);
          ~CBGPicture();

          BOOL IsLoaded() const;

          BOOL IsMotion() const;
          BOOL Play();
          BOOL Pause();
          BOOL PaintTo(HDC hdc,int x,int y,int width,int height);
          void OnResize(int width,int height);
          void SetCallback(TBGCallback cb,void *cb_parm);
};


class CMediaSampleCB;

class CBGVideo : public CBGBase
{
          CRITICAL_SECTION o_cs;  // needed for b_data_processed, obuff

          volatile BOOL b_data_processed;  // are data being processed after last callback ?
          CRBuff *obuff;  //original
          CRBuff *rbuff;  //resized

          HWND m_wnd;  // our internal message-window
          ATOM wnd_class_atom;
          int msg_newframe;
          int msg_poll;
          unsigned last_repeat_time;  // last time we have call Seek(0) on the stream

          IGraphBuilder *pGraphBuilder;
          IBaseFilter *pGrabberBaseFilter;
          ISampleGrabber *pSampleGrabber;
          CMediaSampleCB *pSampleCB;

          int i_quality;

          TBGCallback user_cb;
          void *user_cb_parm;

  public:
          CBGVideo(const char *filepath,int quality,BOOL mute);
          ~CBGVideo();

          BOOL IsLoaded() const;

          BOOL IsMotion() const;
          BOOL Play();
          BOOL Pause();
          BOOL PaintTo(HDC hdc,int x,int y,int width,int height);
          void OnResize(int width,int height);
          void SetCallback(TBGCallback cb,void *cb_parm);

  protected:
          friend class CMediaSampleCB;

          void OnSampleCB_AnotherThread(const void *data,unsigned size);
          static void MyFreeMediaType(AM_MEDIA_TYPE& mt);
          static void MyDeleteMediaType(AM_MEDIA_TYPE* mt);

  private:
          void ReallocResizedBuff(int width,int height);
          BOOL FillResizedBuff_NoGuard();

          static LRESULT CALLBACK WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
          void OnNewFrameInternal();
          void OnPollInternal();

          BOOL Stop();
          void LoadVideoInternal(const char *filename,BOOL use_sound);
          void FreeVideoInternal();

          BOOL GetFilterPins(IBaseFilter *filter,int *_num_inputs,int *_num_outputs,IPin **_input,IPin **_output);
          IBaseFilter* FindRenderer(IFilterGraph *pGraph,const GUID &media_type);
          IBaseFilter* GetPinConnectedFilter(IPin *pin);
          IPin* GetPinConnectedPin(IPin *pin);
          void RemoveRendererChain(IFilterGraph *pGraph,IBaseFilter *renderer);
          BOOL RemoveAudio(IFilterGraph *pGraph);
          BOOL AddOurFilterWithNullRenderer(IFilterGraph *pGraph,IPin *left_pin,IBaseFilter *pOurFilter);
          BOOL ReplaceVideo(IFilterGraph *pGraph,IBaseFilter *pOurFilter);
          BOOL PrepareGraph(IFilterGraph *pGraph,IBaseFilter *pOurFilter,BOOL b_remove_audio);

          void StretchRow24(char *dest,int d_width,const char *src,int s_width);
          void Stretch24InternalNoCheck(CRBuff *db,int d_x,int d_y,int d_width,int d_height,
                                                  const CRBuff *sb,int s_x,int s_y,int s_width,int s_height);

};


class CBGPlugin : public CBGBase
{
          HINSTANCE hlib;
          
          void* (__stdcall *pCreateObject)(int quality,BOOL mute);
          void  (__stdcall *pDestroyObject)(void *obj);
          BOOL  (__stdcall *pIsMotion)(void *obj);
          BOOL  (__stdcall *pPlay)(void *obj);
          BOOL  (__stdcall *pPause)(void *obj);
          BOOL  (__stdcall *pPaintTo)(void *obj,HDC hdc,int x,int y,int width,int height);
          void  (__stdcall *pOnResize)(void *obj,int width,int height);
          void  (__stdcall *pSetCallback)(void *obj,TBGCallback cb,void *cb_parm);
          
          void *p_obj;

  public:
          CBGPlugin(const char *dllpath,int quality,BOOL mute);
          ~CBGPlugin();

          BOOL IsLoaded() const;

          BOOL IsMotion() const;
          BOOL Play();
          BOOL Pause();
          BOOL PaintTo(HDC hdc,int x,int y,int width,int height);
          void OnResize(int width,int height);
          void SetCallback(TBGCallback cb,void *cb_parm);

  private:
          void ClearVars();

};



#endif
