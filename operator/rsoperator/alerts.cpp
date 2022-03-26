
#include "include.h"


#include "alert_call.inc"
#include "alert_burn.inc"
#include "alert_bt.inc"




CAlert::CAlert(HWND hwnd,int id,int message,BOOL vis,HINSTANCE instance,int icon_idx,const char *tip)
{
  m_hwnd = hwnd;
  m_id = id;
  m_icon = (HICON)LoadImage(instance, MAKEINTRESOURCE(icon_idx), IMAGE_ICON, 16, 16, LR_SHARED);
  m_icon_blank = (HICON)LoadImage(our_instance, MAKEINTRESOURCE(IDI_EMPTY), IMAGE_ICON, 16, 16, LR_SHARED);

  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = m_hwnd;
  i.uID = m_id;
  i.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
  i.uCallbackMessage = message;
  i.hIcon = vis ? m_icon : m_icon_blank;
  lstrcpyn(i.szTip,tip?tip:"",sizeof(i.szTip)-1);
  Shell_NotifyIcon(NIM_ADD,&i);
}


CAlert::~CAlert()
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = m_hwnd;
  i.uID = m_id;
  Shell_NotifyIcon(NIM_DELETE,&i);
}


int CAlert::GetId() const
{
  return m_id;
}


void CAlert::Hide()
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = m_hwnd;
  i.uID = m_id;
  i.uFlags = NIF_STATE;
  i.dwStateMask = NIS_HIDDEN;
  i.dwState = NIS_HIDDEN;
  Shell_NotifyIcon(NIM_MODIFY,&i);
}


void CAlert::Blink(BOOL vis)
{
  NOTIFYICONDATA i;
  ZeroMemory(&i,sizeof(i));
  i.cbSize = sizeof(i);
  i.hWnd = m_hwnd;
  i.uID = m_id;
  i.uFlags = NIF_ICON;
  i.hIcon = vis ? m_icon : m_icon_blank;
  Shell_NotifyIcon(NIM_MODIFY,&i);
}



CAlerts::CAlerts(HWND hwnd,int message)
{
  m_hwnd = hwnd;
  m_message = message;
  m_current_id = START_ALERT_ID;
  m_vis = TRUE;
}


CAlerts::~CAlerts()
{
  for ( TAlerts::iterator it = alerts.begin(); it != alerts.end(); ++it )
      {
        CAlert *a = *it;
        *it = NULL;
        if ( a )
           delete a;
      }

  alerts.clear();
}


void CAlerts::Blink()
{
  m_vis = !m_vis;
  
  for ( TAlerts::iterator it = alerts.begin(); it != alerts.end(); ++it )
      {
        if ( *it )
           (*it)->Blink(m_vis);
      }
}


void CAlerts::OnTrayMessage(int id,int msg)
{
  if ( msg == WM_LBUTTONDBLCLK )
     {
       for ( TAlerts::iterator it = alerts.begin(); it != alerts.end(); ++it )
           {
             CAlert *a = *it;
             
             if ( a && a->GetId() == id )
                {
                  alerts.erase(it);
                  a->Hide();
                  a->Execute();
                  delete a;
                  break;
                }
           }
     }
}

