
#include "include.h"



CRShell::CRShell()
{
  m_obj = NULL;
  
  #ifdef RPPRO_ONLY
  CoCreateInstance(CLSID_RunpadProShell,NULL,CLSCTX_INPROC_SERVER,IID_IRunpadProShell,(void**)&m_obj);
  #else
  CoCreateInstance(CLSID_RunpadShell2,NULL,CLSCTX_INPROC_SERVER,IID_IRunpadShell2,(void**)&m_obj);
  #endif
}


CRShell::~CRShell()
{
  SAFERELEASE(m_obj);
}


void CRShell::SetStatusString(const char *text)
{
  if ( m_obj )
     {
       m_obj->ShowInfoMessage(text,RSMSG_STATUS);
     }
}


void CRShell::EnableSheets(const char *name,BOOL b_enable)
{
  if ( m_obj )
     {
       m_obj->EnableSheets(name,b_enable);
     }
}


void CRShell::ShowMessage(const char *s)
{
  if ( m_obj )
     {
       m_obj->ShowInfoMessage(s,MAKELONG(RSMSG_DESKTOP,3));
     }
}

