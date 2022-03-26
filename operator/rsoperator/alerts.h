
#ifndef __ALERTS_H__
#define __ALERTS_H__



class CAlert
{
          HWND m_hwnd;
          int m_id;
          HICON m_icon;
          HICON m_icon_blank;

  public:
          CAlert(HWND hwnd,int id,int message,BOOL vis,HINSTANCE instance,int icon_idx,const char *tip);
          virtual ~CAlert();

          int GetId() const;
          void Hide();
          void Blink(BOOL vis);

          virtual void Execute() = 0;
};


class CAlertCallOperator : public CAlert
{
          CNetCmd m_cmd;
          unsigned m_client_guid;

  public:
          CAlertCallOperator(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid);
          ~CAlertCallOperator();

          void Execute();
};


class CAlertNetBurn : public CAlert
{
          CNetCmd m_cmd;
          unsigned m_client_guid;

  public:
          CAlertNetBurn(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid);
          ~CAlertNetBurn();

          void Execute();
};


class CAlertNetBT : public CAlert
{
          CNetCmd m_cmd;
          unsigned m_client_guid;

  public:
          CAlertNetBT(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid);
          ~CAlertNetBT();

          void Execute();

  private:
          void SendBTFilesFromFolder(const char *s_exe,BOOL is_mobile_content,const char *folder);
          static BOOL BTCallbackFunc(const char *file,WIN32_FIND_DATA *f,void *h);

};



class CAlerts
{
          static const int START_ALERT_ID = 0x1000;  //do not change
          static const int MAXALERTS = 20;
          
          typedef std::vector<CAlert*> TAlerts;
          TAlerts alerts;

          HWND m_hwnd;
          int m_message;
          int m_current_id;
          BOOL m_vis;

  public:
          CAlerts(HWND hwnd,int message);
          ~CAlerts();

          template< class _T >
          void Add(const CNetCmd &cmd,unsigned src_guid);
          void Blink();
          void OnTrayMessage(int id,int msg);
};



#include "alerts.hpp"



#endif

