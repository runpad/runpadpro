
#ifndef __WEBCAM_H__
#define __WEBCAM_H__

#include <vector>

class CGrabberSampleCB;
interface ISampleGrabber;


class CWebShot
{
          CRITICAL_SECTION o_cs;
          
          int m_width;
          int m_height;   // can be negative
          int m_bpp;
          void *p_buff;

          double m_time;   // current frame's timestamp
          BOOL b_changed;

  public:
          CWebShot(int width,int height,int bpp);
          ~CWebShot();

          int GetWidth() const { return m_width; }
          int GetHeight() const { return m_height < 0 ? -m_height : m_height; }
          int GetRealHeight() const { return m_height; }
          int GetBPP() const { return m_bpp; }
          unsigned GetDataSize() const { return GetHeight()*GetRowStride(GetWidth(),GetBPP()); }
          int GetRowStride() const { return (GetWidth()*(GetBPP()/8)+3)&~3; }
          BOOL IsDownTop() const { return GetRealHeight() >= 0; }
          BOOL IsTopDown() const { return !IsDownTop(); }

          const void* Lock(BOOL& _frame_changed,double& _time);
          void Unlock();

  protected:
          friend class CGrabberSampleCB;
          
          BOOL UpdateFrameIfNotLocked(double time,int width,int height,int bpp,const void *data,unsigned datasize);

  private:
          BOOL IsFormatTheSame(int width,int height,int bpp) const { return GetWidth() == width && GetRealHeight() == height && m_bpp == bpp; }
          static int GetRowStride(int width,int bpp);
};


class CSingleWebCam
{
          WCHAR *ws_devicepath;
          WCHAR *ws_name;

          IBaseFilter *p_capfilt;
          ICaptureGraphBuilder2 *p_build;
          IGraphBuilder *p_graph;
          IBaseFilter *p_grabberfilt;
          ISampleGrabber *p_grabber;
          IBaseFilter *p_nullfilt;

          CWebShot *p_shot;
          CGrabberSampleCB *p_sample_cb;

          BOOL b_rendered;  // was successfully rendered by RenderStream()?
          unsigned last_render_try_time;

          BOOL b_dead;      // is device removed?

  public:
          CSingleWebCam(IBaseFilter *_filt,const WCHAR *_devicepath,const WCHAR *_name);
          ~CSingleWebCam();

          const WCHAR* GetName() const { return NNSW(ws_name); }
          CWebShot* GetShot() const { return p_shot; }  // can returns NULL

  protected:
          friend class CWebCams;
          
          const WCHAR* GetDevicePath() const { return NNSW(ws_devicepath); }
          BOOL IsDead() const { return b_dead; }
          void Poll();

  private:
          BOOL AreFiltersCreated() const;

};


class CWebCams
{
  public:
          typedef std::vector<CSingleWebCam*> TCams;

  private:        
          ICreateDevEnum *p_devenum;
          TCams m_cams;
          unsigned last_add_try_time;

  public:
          CWebCams();
          ~CWebCams();

          const TCams& GetCamsList() const { return m_cams; }
          void Poll();

  private:
          void AddNewDevicesInternal();
          static WCHAR* ReadStrFromPropBag(IPropertyBag *pPropBag,const WCHAR *prop);

};



class CWebCamsMonitor
{
          CWebCams m_obj;

  public:
          CWebCamsMonitor();
          ~CWebCamsMonitor();

          void Poll();
          void* GetShot(BOOL use_gamma,float gamma,BOOL downtop,BOOL& _changed,int& _width,int& _height,int& _bpp,int& _rowstride);

  private:
          void CopySingleImage24InternalNoCheck(
                void *d_buff,int d_rowstride,int d_width,int d_height,int d_x,int d_y,BOOL d_downtop,
                const void *s_buff,int s_rowstride,int s_w,int s_h,BOOL s_downtop);

};


#endif

