
#include "include.h"



CScreenProcessing::CScreenProcessing()
{
  InitializeCriticalSection(&o_cs);

  m_back = NULL;
  m_primary = NULL;
  m_work = NULL;
}


CScreenProcessing::~CScreenProcessing()
{
  SAFEDELETE(m_back);
  SAFEDELETE(m_primary);
  SAFEDELETE(m_work);

  DeleteCriticalSection(&o_cs);
}


BOOL CScreenProcessing::ReallocateBuffIfNeeded(CBuff7* &buff, BOOL grayscale, int sw, int sh)
{
  if ( !buff || !buff->IsScreenMatch(grayscale,sw,sh) )
     {
       SAFEDELETE(buff);
       buff = new CBuff7(grayscale,sw,sh);
       return TRUE;
     }

  return FALSE;
}


// not true multithreaded!
void CScreenProcessing::PrepareFrame(BOOL need_clean,BOOL grayscale,void **_buff,int *_size,int *_w,int *_h)
{
  CCSGuard g(o_cs);
  
  *_buff = NULL;
  *_size = 0;
  *_w = 0;
  *_h = 0;
  
  BOOL b_clean = need_clean;

  int sw = GetSystemMetrics(SM_CXSCREEN);
  int sh = GetSystemMetrics(SM_CYSCREEN);
  
  b_clean |= ReallocateBuffIfNeeded(m_back, grayscale, sw, sh);
  b_clean |= ReallocateBuffIfNeeded(m_primary, grayscale, sw, sh);
  b_clean |= ReallocateBuffIfNeeded(m_work, grayscale, sw, sh);

  m_primary->Capture();
  
  *_size = CRLE7::Compress(m_primary->GetBits(),b_clean?NULL:m_back->GetBits(),m_work->GetBits(),sw*sh);
  *_buff = (void*)m_work->GetBits();
  *_w = sw;
  *_h = sh;

  SwapBuffers();
}


void CScreenProcessing::SwapBuffers()
{
  CBuff7 *t = m_primary;
  m_primary = m_back;
  m_back = t;
}

