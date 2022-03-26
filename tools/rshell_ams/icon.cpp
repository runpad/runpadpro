
#include "include.h"




CTrayIcon::CTrayIcon(HWND hwnd,int message,const char *initial_tip)
{
  ZeroMemory(&m_info,sizeof(m_info));
  m_info.cbSize = sizeof(m_info);
  m_info.hWnd = hwnd;
  m_info.uID = 1;
  m_info.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
  m_info.uCallbackMessage = message;
  m_info.hIcon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(101),IMAGE_ICON,16,16,LR_SHARED);
  lstrcpyn(m_info.szTip,initial_tip,sizeof(m_info.szTip));

  Shell_NotifyIcon(NIM_ADD,(NOTIFYICONDATA*)&m_info);
}


CTrayIcon::~CTrayIcon()
{
  Shell_NotifyIcon(NIM_DELETE,(NOTIFYICONDATA*)&m_info);
}


void CTrayIcon::DisplayInfoTip(const char *text)
{
  m_info.uFlags = NIF_INFO;
  lstrcpyn(m_info.szInfo,text,sizeof(m_info.szInfo));
  m_info.uTimeout = 10000;
  lstrcpyn(m_info.szInfoTitle,"Информация",sizeof(m_info.szInfoTitle));
  m_info.dwInfoFlags = NIIF_INFO;

  Shell_NotifyIcon(NIM_MODIFY,(NOTIFYICONDATA*)&m_info);
}


void CTrayIcon::RecreateIcon()
{
  m_info.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;

  Shell_NotifyIcon(NIM_ADD,(NOTIFYICONDATA*)&m_info);
}

