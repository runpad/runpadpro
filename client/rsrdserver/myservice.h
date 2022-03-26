
#ifndef __MYSERVICE_H__
#define __MYSERVICE_H__


class CListener;

class CMyService : public CService
{
          CListener *p_screen;
          CListener *p_events;

  public:
          CMyService();
          ~CMyService();
          
          const char* GetName() const { return NAME_SERVICE; }
          const char* GetDisplayName() const { return DESC_SERVICE; }
          BOOL IsInteractive() const { return FALSE; }
          BOOL Start();
          BOOL Stop();
          BOOL IsExecuted() const;
};



#endif
