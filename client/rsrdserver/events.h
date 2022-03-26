
#ifndef __EVENTS_H__
#define __EVENTS_H__


class CEvents
{
         CRITICAL_SECTION o_cs;
         
         unsigned last_time_ldown;
         unsigned last_time_rdown;
         unsigned last_time_mdown;
  
  public:
         CEvents();
         ~CEvents();
         
         void OnInputEvent(int message,int wParam,int lParam,unsigned time);
  
  private:
         void SendInputEvent(int message,int wParam,int lParam,unsigned time);
};


#endif
