
#include "include.h"



CMyService::CMyService()
{
  p_screen = NULL;
  p_events = NULL;
}


CMyService::~CMyService()
{
  Stop();
}


BOOL CMyService::IsExecuted() const
{
  return (p_screen != NULL || p_events != NULL);
}


BOOL CMyService::Start()
{
  if ( !p_screen )
     {
       p_screen = new CListenerScreen();
     }
  
  if ( !p_events )
     {
       p_events = new CListenerEvents();
     }

  return TRUE;
}


BOOL CMyService::Stop()
{
  if ( p_screen )
     {
       p_screen->AsyncTerminateRequest();
     }

  if ( p_events )
     {
       p_events->AsyncTerminateRequest();
     }

  SAFEDELETE(p_screen);
  SAFEDELETE(p_events);

  return TRUE;
}

