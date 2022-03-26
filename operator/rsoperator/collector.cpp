
#include "include.h"


#include "collector_html.inc"
#include "collector_pic.inc"
#include "collector_stat.inc"


CCollector* CCollector::g_collector = NULL;



CCollector::CCollector(int accept_cmd_id,const TENVENTRY *list,unsigned listcount)
{
  m_cmdid = accept_cmd_id;

  for ( unsigned n = 0; n < listcount; n++ )
      {
        targets.push_back(list[n]);
      }
}


CCollector::~CCollector()
{
}


BOOL CALLBACK CCollector::DialogProcWrapper(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       SetProp(hwnd,"this_pointer",(HANDLE)lParam);
     }

  CCollector *obj = (CCollector*)GetProp(hwnd,"this_pointer");

  return obj ? obj->DialogProc(hwnd,message,wParam,lParam) : FALSE;
}


BOOL CCollector::DialogProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       SetTimer(hwnd, 1, 300, NULL);
       PostMessage(hwnd, WM_TIMER, (WPARAM)1, (LPARAM)0);
       SetFocus(GetDlgItem(hwnd,IDCANCEL));
     }
  
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       KillTimer(hwnd,1);
       EndDialog(hwnd,0);
     }
  
  if ( message == WM_TIMER && wParam == 1 )
     {
       char old[MAX_PATH] = "";
       GetDlgItemText(hwnd,IDC_LABEL,old,sizeof(old));

       char s[MAX_PATH];
       wsprintf(s,S_NETDATARETRIEVED,recvd.size(),targets.size());

       if ( lstrcmp(old,s) )
          {
            SetDlgItemText(hwnd,IDC_LABEL,s);
            UpdateWindow(hwnd);
          }

       if ( recvd.size() == targets.size() )
          {
            PostMessage(hwnd, WM_CLOSE, (WPARAM)0, (LPARAM)0);
          }
     }

  return FALSE;
}


void CCollector::ShowDialog()
{
  DialogBoxParam(our_instance,MAKEINTRESOURCE(IDD_NETWAIT),gui->GetMainWindowHandle(),DialogProcWrapper,(LPARAM)this);
}


void CCollector::Append(const CNetCmd &cmd,unsigned src_guid)
{
  if ( cmd.GetCmdId() == m_cmdid )
     {
       BOOL find = FALSE;
       for ( unsigned n = 0; n < targets.size(); n++ )
           {
             if ( targets[n].guid == src_guid )
                {
                  find = TRUE;
                  break;
                }
           }

       if ( find )
          {
            BOOL find = FALSE;
            for ( unsigned n = 0; n < recvd.size(); n++ )
                {
                  if ( recvd[n] == src_guid )
                     {
                       find = TRUE;
                       break;
                     }
                }

            if ( !find )
               {
                 recvd.push_back(src_guid);
                 OnDataAccepted(cmd,src_guid);
               }
          }
     }
}


void CCollector::Finish()
{
  if ( recvd.size() == 0 )
     {
       //gui->ErrBox(S_NOTDATARECVD);  we do not need modal loop here
     }
  else
     {
       OnFinish();
     }
}


const CCollector::TTargetList& CCollector::GetTargetList()
{
  return targets;
}


const CCollector::TRecvdList& CCollector::GetRecvdList()
{
  return recvd;
}

