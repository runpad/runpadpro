
#ifndef __SCREEN_H__
#define __SCREEN_H__


class CScreenProcessing
{
          CRITICAL_SECTION o_cs;
         
          CBuff7 *m_back;
          CBuff7 *m_primary;
          CBuff7 *m_work;

  public:
          CScreenProcessing();
          ~CScreenProcessing();

          void PrepareFrame(BOOL need_clean,BOOL grayscale,void **_buff,int *_size,int *_w,int *_h);

  private:
          BOOL ReallocateBuffIfNeeded(CBuff7* &buff, BOOL grayscale, int sw, int sh);
          void SwapBuffers();
};



#endif
