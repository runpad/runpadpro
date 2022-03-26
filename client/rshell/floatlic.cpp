
#include "include.h"
//#import "msxml3.dll"
#include "msxml3.tlh"

#include "floatlic_http.inc"



///////////////////////////////////////


static const unsigned STD_LIC_BUSY_TIMEOUT_SEC = 60;
static const unsigned LIC_POLL_SEC = 28;


///////////////////////////////////////


class CFloatLicTools
{
  public:
          static BOOL GetLicListFromXML(MSXML2::IXMLDOMDocumentPtr xml,std::vector<int>& _list);
          static int GetIntLicName(const std::string& licname);
          static std::string GetUrlForLicStatUpdate(const std::string& server,const std::string& licname,int licidx,unsigned timeout_sec);
          static std::string GetUrlForBusyLicsReq(const std::string& server,const std::string& licname);
          static BOOL IsProcessOrAnyChildPresent(int pid);
          static BOOL IsAnyOneProcessFromListIsRunning(const std::string& exes);
          static BOOL IsLicKeeped(const std::string& licname,int& _licidx);
          static void SetLicKeep(const std::string& licname,int licidx,unsigned keeptime_sec);
          static void ShutdownSteam(DWORD wait_timeout_ms=0);

  private:
          static std::string GetUrlInternal(const char *server,const char *parms=NULL);
};



BOOL CFloatLicTools::GetLicListFromXML(MSXML2::IXMLDOMDocumentPtr xml,std::vector<int>& _list)
{
  BOOL rc = FALSE;

  _list.clear();

  try
  {
    if ( xml )
       {
         MSXML2::IXMLDOMElementPtr el = xml->documentElement;
         if ( el )
            {
              if ( !lstrcmpi(el->tagName,"response") )
                 {
                   rc = TRUE;

                   MSXML2::IXMLDOMNodeListPtr list = el->getElementsByTagName("lic");
                   if ( list )
                      {
                        for ( int n = 0; n < list->length; n++ )
                            {
                              MSXML2::IXMLDOMNodePtr node = list->Getitem(n);
                              if ( node )
                                 {
                                   if ( node->childNodes && node->childNodes->length > 0 )
                                      {
                                        _variant_t v = node->childNodes->Getitem(0)->nodeValue;
                                        _list.push_back((int)v);
                                      }
                                 }
                            }
                      }
                 }
            }
       }
  }
  catch(_com_error &e)
  {
  }

  return rc;
}


int CFloatLicTools::GetIntLicName(const std::string& licname)
{
  std::string s = licname;

  for ( int n = 0; n < s.size(); n++ )
      {
        s[n] = (char)CharUpper((LPSTR)(unsigned char)s[n]);
      }

  return CalculateHashBobJankins((const unsigned char*)s.c_str(),s.size(),0) & 0x7FFFFFFF;
}


std::string CFloatLicTools::GetUrlInternal(const char *server,const char *parms)
{
  std::string s;

  s += "http://";
  s += NNS(server);
  s += "/licman";

  if ( !IsStrEmpty(parms) )
     {
       s += "?";
       s += NNS(parms);
     }

  return s;
}


std::string CFloatLicTools::GetUrlForLicStatUpdate(const std::string& server,const std::string& licname,int licidx,unsigned timeout_sec)
{
  char s[MAX_PATH];
  sprintf(s,"action=%s&licname=%d&licidx=%d&delta=%d","update",GetIntLicName(licname),licidx,timeout_sec);
  return GetUrlInternal(server.c_str(),s);
}


std::string CFloatLicTools::GetUrlForBusyLicsReq(const std::string& server,const std::string& licname)
{
  char s[MAX_PATH];
  sprintf(s,"action=%s&licname=%d","getlist",GetIntLicName(licname));
  return GetUrlInternal(server.c_str(),s);
}


BOOL CFloatLicTools::IsProcessOrAnyChildPresent(int pid)
{
  BOOL rc = FALSE;
  
  if ( pid != -1 )
     {
       rc = (IsProcessExists(pid) || FindLastProcessChild(pid) != -1);
     }

  return rc;
}


BOOL CFloatLicTools::IsAnyOneProcessFromListIsRunning(const std::string& exes)
{
  BOOL rc = FALSE;

  TStringList *sl = CreateStringListFromMultiLineStringIgnoreEmptys(exes.c_str()," ",',');
  if ( sl )
     {
       if ( sl->size() > 0 )
          {
            CSessionProcessList pl;

            do {

              char filename[MAX_PATH] = "";
              int pid = -1;
              
              if ( !pl.GetNext(&pid,filename) )
                 break;

              if ( filename == PathFindFileName(filename) )
                 {
                   char s[MAX_PATH] = "";
                   GetExePathByPid(pid,s);
                   if ( !IsStrEmpty(s) )
                      {
                        lstrcpy(filename,s);
                      }
                 }

              BOOL find = FALSE;

              for ( int n = 0; n < sl->size(); n++ )
                  {
                    const char *s = (*sl)[n];
                    if ( !IsStrEmpty(s) )
                       {
                         char t[MAX_PATH];
                         lstrcpy(t,s);
                         DoEnvironmentSubst(t,sizeof(t));
                         
                         const char *cmp1;
                         const char *cmp2;
                         
                         if ( filename == PathFindFileName(filename) || 
                              t == PathFindFileName(t) )
                            {
                              cmp1 = PathFindFileName(t);
                              cmp2 = PathFindFileName(filename);
                            }
                         else
                            {
                              cmp1 = t;
                              cmp2 = filename;
                            }

                         if ( PathMatchSpec(cmp2,cmp1) )
                            {
                              find = TRUE;
                              break;
                            }
                       }
                  }

              if ( find )
                 {
                   rc = TRUE;
                   break;
                 }

            } while (1);

          }

       FreeStringList(sl);
     }

  return rc;
}


BOOL CFloatLicTools::IsLicKeeped(const std::string& licname,int& _licidx)
{
  BOOL rc = FALSE;
  
  char key[MAX_PATH];
  sprintf(key,"%s\\%s\\%d",REGPATH,"licman",GetIntLicName(licname));

  char s[MAX_PATH];
  ReadRegStr(HKCU,key,"time",s,"0");
  double t = 0.0;
  sscanf(s,"%lf",&t);

  if ( t > GetNowOurTime() )
     {
       _licidx = ReadRegDword(HKCU,key,"idx",-1);
       rc = TRUE;
     }

  return rc;
}


void CFloatLicTools::SetLicKeep(const std::string& licname,int licidx,unsigned keeptime_sec)
{
  char key[MAX_PATH];
  sprintf(key,"%s\\%s\\%d",REGPATH,"licman",GetIntLicName(licname));

  char s[MAX_PATH];
  sprintf(s,"%0.15f",GetNowOurTime()+(double)keeptime_sec/86400.0);
  WriteRegStr(HKCU,key,"time",s);

  WriteRegDword(HKCU,key,"idx",licidx);
}


void CFloatLicTools::ShutdownSteam(DWORD wait_timeout_ms)
{
  int pid = ReadRegDword(HKCU,"Software\\Valve\\Steam\\ActiveProcess","pid",0);
  if ( pid != 0 && pid != -1 )
     {
       if ( IsProcessExists(pid) )
          {
            CSessionProcessList pl;

            BOOL find = FALSE;

            do {

              char filename[MAX_PATH] = "";
              int f_pid = -1;
              
              if ( !pl.GetNext(&f_pid,filename) )
                 break;

              if ( !lstrcmpi(PathFindFileName(filename),"steam.exe") && f_pid == pid )
                 {
                   find = TRUE;
                   break;
                 }

            } while (1);

            if ( find )
               {
                 char s[MAX_PATH];
                 ReadRegStr(HKLM,"SOFTWARE\\Valve\\Steam","InstallPath",s,"");
                 if ( IsStrEmpty(s) )
                    {
                      ReadRegStr64(HKLM,"SOFTWARE\\Valve\\Steam","InstallPath",s,"");  // paranoja
                    }
                 if ( IsStrEmpty(s) )
                    {
                      lstrcpy(s,"%ProgramFiles%\\Steam"); // steam.exe is x86
                    }

                 DoEnvironmentSubst(s,MAX_PATH);

                 char dir[MAX_PATH];
                 lstrcpy(dir,s);

                 PathAppend(s,"steam.exe");

                 if ( IsFileExist(s) )
                    {
                      char cmdline[MAX_PATH];
                      sprintf(cmdline,"\"%s\" -shutdown",s);

                      STARTUPINFO si;
                      PROCESS_INFORMATION pi;

                      ZeroMemory(&si,sizeof(si));
                      si.cb = sizeof(si);
                      if ( CreateProcess(NULL,cmdline,NULL,NULL,FALSE,0,NULL,dir,&si,&pi) )
                         {
                           HANDLE h = OpenProcess(SYNCHRONIZE,FALSE,pid);
                           if ( h )
                              {
                                WaitForSingleObject(h,wait_timeout_ms);
                                CloseHandle(h);
                              }
                           else
                              {
                                WaitForSingleObject(pi.hProcess,wait_timeout_ms);
                                Sleep(wait_timeout_ms?3000:0);
                              }
                           
                           CloseHandle(pi.hProcess);
                           CloseHandle(pi.hThread);
                         }
                    }
               }
          }
     }
}



///////////////////////////////////////


CFloatLicSingle::CFloatLicSingle(const char *envname,const char *envvalue,const char *licname,int licidx,const char *exes,BOOL steam,const char *server,unsigned exedelayload)
  : m_envname(NNS(envname)), m_envvalue(NNS(envvalue)), m_licname(NNS(licname)), m_licidx(licidx), m_pid(-1), m_exelist(NNS(exes)), b_is_steam(steam), m_server(NNS(server)), m_exedelayload(exedelayload)
{
  m_last_poll_time = GetTickCount();
  m_starttime = GetNowOurTime();
}


CFloatLicSingle::~CFloatLicSingle()
{
}


void CFloatLicSingle::SetEnvForThisProcess() const
{
  if ( !m_envname.empty() )
     {
       SetEnvironmentVariable(m_envname.c_str(),m_envvalue.c_str());
     }
}


void CFloatLicSingle::ClearEnvForThisProcess() const
{
  if ( !m_envname.empty() )
     {
       SetEnvironmentVariable(m_envname.c_str(),NULL);
     }
}


BOOL CFloatLicSingle::IsLicNameEqu(const char *licname) const
{
  return (lstrcmpi(m_licname.c_str(),NNS(licname)) == 0);
}


void CFloatLicSingle::SendServerBusyRequest(unsigned timeout_sec) const
{
  if ( !m_server.empty() )
     {
       std::string url = CFloatLicTools::GetUrlForLicStatUpdate(m_server,m_licname,m_licidx,timeout_sec);
       CHttpRequestAsyncNoAnswer::Execute(url.c_str());
     }
}


BOOL CFloatLicSingle::Poll(BOOL &_is_dead)
{
  BOOL rc = FALSE;

  if ( GetTickCount() - m_last_poll_time > LIC_POLL_SEC*1000 )
     {
       rc = TRUE;

       _is_dead = IsDead();

       if ( !_is_dead )
          {
            SendServerBusyRequest(STD_LIC_BUSY_TIMEOUT_SEC);
          }

       m_last_poll_time = GetTickCount();
     }

  return rc;
}


BOOL CFloatLicSingle::IsDead() const
{
  BOOL rc = FALSE;
  
  if ( !m_exelist.empty() )
     {
       // check exe-list, ignore pid
       if ( m_exedelayload && GetNowOurTime() - m_starttime < 0.00001157407407407*m_exedelayload )
          {
          }
       else
          {
            if ( !CFloatLicTools::IsAnyOneProcessFromListIsRunning(m_exelist) )  // todo: for steam check parent
               {
                 rc = TRUE;
               }
          }
     }
  else
     {
       // use pid only
       if ( !CFloatLicTools::IsProcessOrAnyChildPresent(m_pid) )
          {
            rc = TRUE;
          }
     }

  return rc;
}



///////////////////////////////////////


CFloatLic CFloatLic::g_floatlicman;


CFloatLic::CFloatLic()
{
  m_uid = 0;
  b_executed = FALSE;

  b_is_steam = FALSE;
  m_keeptime = 0;
  m_exedelayload = 0;
  b_do_not_promt = FALSE;
  b_lics_recvd = FALSE;
  m_wnd = NULL;
}


CFloatLic::~CFloatLic()
{
  for ( int n = 0; n < m_list.size(); n++ )
      {
        SAFEDELETE(m_list[n]);
      }
  m_list.clear();
}


void CFloatLic::_Add(CFloatLicSingle *i)
{
  if ( i )
     {
       m_list.push_back(i);
     }
}


CFloatLicSingle* CFloatLic::_Execute(const char *serverpath,const char *envname)
{
  CFloatLicSingle *item = NULL;

  if ( !IsStrEmpty(serverpath) && !IsStrEmpty(envname) )
     {
       if ( !b_executed )
          {
            b_executed = TRUE;

            m_uid++;  // go next UID
            m_licname = "";
            m_server = "";
            m_exelist = "";
            b_is_steam = FALSE;
            m_keeptime = 0;
            m_exedelayload = 0;
            b_do_not_promt = FALSE;
            m_lics.clear();
            b_lics_recvd = FALSE;
            m_wnd = NULL;

            if ( !NetIsConnected() )
               {
                 ErrBox(LS(3230));
               }
            else
               {
                 CNetCmd cmd(NETCMD_FLOATLIC2SERVER_REQ);
                 cmd.AddIntParm(NETPARM_I_ID,m_uid);
                 cmd.AddStringParm(NETPARM_S_PATH,serverpath);
                 NetSend(cmd);

                 if ( DialogBoxParam(our_instance,MAKEINTRESOURCE(IDD_LICMAN),GetMainWnd(),DlgProcWrapper,(LPARAM)this) == 1 )
                    {
                      if ( !b_lics_recvd )
                         {
                           ErrBox(LS(3091));
                         }
                      else
                      if ( m_licname.empty() || m_lics.size() == 0 )
                         {
                           ErrBox(LS(3240));  // invalid file format or not found
                         }
                      else
                         {
                           if ( m_keeptime > 0 )
                              {
                                // try to get keeped license
                                m_keeptime = MAX(m_keeptime,STD_LIC_BUSY_TIMEOUT_SEC);
                                
                                int idx = -1;
                                if ( CFloatLicTools::IsLicKeeped(m_licname,idx) )
                                   {
                                     if ( idx >= 0 && idx < m_lics.size() )
                                        {
                                          char s[MAX_PATH];
                                          sprintf(s,LS(3242),idx);
                                          if ( b_do_not_promt || ConfirmYESNO(s) )
                                             {
                                               item = new CFloatLicSingle(envname,m_lics[idx].second.c_str(),m_licname.c_str(),idx,m_exelist.c_str(),b_is_steam,m_server.c_str(),m_exedelayload);
                                               item->SendServerBusyRequest(STD_LIC_BUSY_TIMEOUT_SEC);
                                             }
                                        }
                                   }
                              }
                           
                           if ( !item )
                              {
                                // try to get free license from list
                                std::vector<int> freelics;
                                for ( int n = 0; n < m_lics.size(); n++ )
                                    {
                                      if ( !m_lics[n].first )
                                         {
                                           freelics.push_back(n);
                                         }
                                    }

                                if ( freelics.size() > 0 )
                                   {
                                     srand(GetTickCount());

                                     TLICSELINFO i;
                                     i.obj = this;
                                     i.list = &freelics;
                                     i.def_idx = rand() % freelics.size();  // select random by default
                                     i.timeout_sec = 6;

                                     int sel_idx =  b_do_not_promt ? i.def_idx :
                                                        DialogBoxParam(our_instance,MAKEINTRESOURCE(IDD_LICSELECT),GetMainWnd(),DlgSelProcWrapper,(LPARAM)&i);

                                     if ( sel_idx >= 0 && sel_idx < freelics.size() )
                                        {
                                          int licnum = freelics[sel_idx];
                                          item = new CFloatLicSingle(envname,m_lics[licnum].second.c_str(),m_licname.c_str(),licnum,m_exelist.c_str(),b_is_steam,m_server.c_str(),m_exedelayload);
                                          item->SendServerBusyRequest(m_keeptime?m_keeptime:STD_LIC_BUSY_TIMEOUT_SEC);

                                          if ( m_keeptime )
                                             {
                                               CFloatLicTools::SetLicKeep(m_licname,licnum,m_keeptime);
                                             }
                                        }
                                   }
                                else
                                   {
                                     MsgBox(LS(3020));  // all licensed occupied
                                   }
                              }
                         }
                    }
               }

            b_executed = FALSE;
          }
     }

  return item;
}


BOOL CALLBACK CFloatLic::DlgProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       assert( (CFloatLic*)lParam == &GetObj() );
     }

  return GetObj().DlgProc(hwnd,message,wParam,lParam);
}


BOOL CFloatLic::DlgProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       m_wnd = hwnd;
       SetWindowText(hwnd,LS(3016));
       SetDlgItemText(hwnd,IDC_LABEL1,LS(3017));
       SetDlgItemText(hwnd,IDC_LABEL2,LS(3018));
       SetFocus(GetDlgItem(hwnd,IDC_LABEL));
       SetTimer(hwnd,1,7000,NULL);
       SetTimer(hwnd,2,100,NULL);
     }
  else
  if ( message == WM_TIMER && wParam == 2 )
     {
       KillTimer(hwnd,2);
       SetCursor(LoadCursor(NULL,IDC_WAIT));
       SetCapture(hwnd);
     }
  else
  if ( message == WM_TIMER && wParam == 1 )
     {
       SetCursor(LoadCursor(NULL,IDC_ARROW));
       ReleaseCapture();
       m_wnd = NULL;
       EndDialog(hwnd,1);
     }
  else
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       SetCursor(LoadCursor(NULL,IDC_ARROW));
       ReleaseCapture();
       m_wnd = NULL;
       EndDialog(hwnd,0);
     }

  return FALSE;
}


BOOL CALLBACK CFloatLic::DlgSelProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       assert( ((TLICSELINFO*)lParam)->obj == &GetObj() );
     }

  return GetObj().DlgSelProc(hwnd,message,wParam,lParam);
}


BOOL CFloatLic::DlgSelProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  if ( message == WM_INITDIALOG )
     {
       const TLICSELINFO *i = (TLICSELINFO*)lParam;
       SetProp(hwnd,"_info",(HANDLE)lParam);
       
       for ( int n = 0; n < i->list->size(); n++ )
           {
             char s[100];
             sprintf(s," %d",(*i->list)[n]);
             SendDlgItemMessage(hwnd,IDC_COMBO1,LB_ADDSTRING,0,(LPARAM)s);
           }

       SendDlgItemMessage(hwnd,IDC_COMBO1,LB_SETCURSEL,i->def_idx,0);
       
       SetWindowText(hwnd,LS(3241));
       SetDlgItemText(hwnd,IDOK,STR_000);  // international
       
       SetFocus(GetDlgItem(hwnd,IDC_COMBO1));

       SetTimer(hwnd,1,1000,NULL);
     }
  else
  if ( message == WM_COMMAND && LOWORD(wParam) == IDC_COMBO1 && HIWORD(wParam) == LBN_SELCHANGE )
     {
       KillTimer(hwnd,1);
       SetDlgItemText(hwnd,IDOK,STR_000);  // international
     }
  else
  if ( message == WM_TIMER && wParam == 1 )
     {
       TLICSELINFO *i = (TLICSELINFO*)GetProp(hwnd,"_info");
       if ( i )
          {
            i->timeout_sec--;
            if ( i->timeout_sec < 0 )
               {
                 PostMessage(hwnd,WM_COMMAND,IDOK,0);
               }
            else
               {
                 char s[100];
                 sprintf(s,"%s (%d)",STR_000,i->timeout_sec);  // international
                 SetDlgItemText(hwnd,IDOK,s);
                 Beep(500,30);
               }
          }
     }
  else
  if ( message == WM_CLOSE || (message == WM_COMMAND && LOWORD(wParam) == IDCANCEL) )
     {
       RemoveProp(hwnd,"_info");
       EndDialog(hwnd,-1);
     }
  else
  if ( message == WM_COMMAND && LOWORD(wParam) == IDOK )
     {
       RemoveProp(hwnd,"_info");
       EndDialog(hwnd,SendDlgItemMessage(hwnd,IDC_COMBO1,LB_GETCURSEL,0,0));
     }
  
  return FALSE;
}


void CFloatLic::_OnServerAck(const CNetCmd& cmd)
{
  if ( b_executed )
     {
       if ( m_uid == cmd.GetParmAsInt(NETPARM_I_ID) )
          {
            if ( !b_lics_recvd )
               {
                 m_licname = cmd.GetParmAsString("Name");
                 m_server = cmd.GetParmAsString("Server");
                 m_exelist = cmd.GetParmAsString("Exe");
                 b_is_steam = cmd.GetParmAsBool("Steam",FALSE);
                 m_keeptime = cmd.GetParmAsInt("Keep",0);
                 m_exedelayload = cmd.GetParmAsInt("ExeDelayLoad",0);
                 b_do_not_promt = cmd.GetParmAsBool("DoNotAsk",FALSE);

                 m_lics.clear();  // paranoja
                 for ( int n = 0; n < 1000; n++ )
                     {
                       char s[MAX_PATH];
                       sprintf(s,"Lic%d",n);
                       const char *s_lic = cmd.GetParmAsString(s);
                       if ( !IsStrEmpty(s_lic) )
                          {
                            m_lics.push_back(TSingleLicInfo(FALSE,std::string(s_lic)));
                          }
                     }

                 b_lics_recvd = TRUE;  // anyway must be set

                 if ( !m_licname.empty() && m_lics.size() > 0 )
                    {
                      if ( m_wnd && IsWindow(m_wnd) )
                         {
                           char s[MAX_PATH];
                           sprintf(s,LS(3019),m_licname.c_str(),m_lics.size());
                           SetDlgItemText(m_wnd,IDC_LABEL,s);
                           UpdateWindow(m_wnd);

                           BOOL got_from_server = FALSE;

                           if ( !m_server.empty() )
                              {
                                // try get busy lics list from server
                                CHttpRequest rq(CFloatLicTools::GetUrlForBusyLicsReq(m_server,m_licname).c_str(),"GET",false);
                                if ( rq.IsCompleted() && rq.GetHttpStatus() == 200 )
                                   {
                                     std::vector<int> l;
                                     if ( CFloatLicTools::GetLicListFromXML(rq.GetResponseAsXML(),l) )
                                        {
                                          got_from_server = TRUE;

                                          for ( int n = 0; n < l.size(); n++ )
                                              {
                                                int idx = l[n];
                                                if ( idx >= 0 && idx < m_lics.size() )
                                                   {
                                                     m_lics[idx].first = TRUE;
                                                   }
                                              }
                                        }
                                   }
                              
                                KillTimer(m_wnd,1);

                                // remove all previous timer messages from queue:
                                MSG msg;
                                while ( PeekMessage(&msg,m_wnd,WM_TIMER,WM_TIMER,PM_NOREMOVE) )
                                {
                                  GetMessage(&msg,m_wnd,WM_TIMER,WM_TIMER);

                                  if ( msg.wParam != 1 )
                                     {
                                       DispatchMessage(&msg);
                                     }
                                }

                                SetTimer(m_wnd,1,got_from_server?1000:5000,NULL);
                              }
                           
                           if ( !got_from_server )
                              {
                                CNetCmd req(NETCMD_FLOATLIC2CLIENT_REQ);
                                req.AddIntParm(NETPARM_I_ID,m_uid);
                                req.AddStringParm(NETPARM_S_NAME,m_licname.c_str());
                                NetSend(req,NETGUID_ALL_USERS_WITHME);
                              }
                         }
                    }
               }
          }
     }
}


void CFloatLic::_OnClientReq(const CNetCmd& cmd,unsigned src_guid)
{
  const char *name = cmd.GetParmAsString(NETPARM_S_NAME);
  if ( !IsStrEmpty(name) )
     {
       // find requested items
       std::string out;

       for ( int n = 0; n < m_list.size(); n++ )
           {
             const CFloatLicSingle *i = m_list[n];
             if ( i )
                {
                  if ( i->IsLicNameEqu(name) )
                     {
                       char s[16];
                       sprintf(s,"%d",i->GetLicIdx());

                       if ( !out.empty() )
                          {
                            out += ',';
                          }

                       out += s;
                     }
                }
           }

       // send back
       if ( !out.empty() )
          {
            CNetCmd ack(NETCMD_FLOATLIC2CLIENT_ACK);
            ack.AddIntParm(NETPARM_I_ID,cmd.GetParmAsInt(NETPARM_I_ID));
            ack.AddStringParm(NETPARM_S_LIST,out.c_str());
            NetSend(ack,src_guid);
          }
     }
}


void CFloatLic::_OnClientAck(const CNetCmd& cmd)
{
  if ( b_executed )
     {
       if ( m_uid == cmd.GetParmAsInt(NETPARM_I_ID) )
          {
            if ( b_lics_recvd )
               {
                 const char *s_list = cmd.GetParmAsString(NETPARM_S_LIST);
                 if ( !IsStrEmpty(s_list) )
                    {
                      TStringList *sl = CreateStringListFromMultiLineStringIgnoreEmptys(s_list," ",',');
                      if ( sl )
                         {
                           for ( int n = 0; n < sl->size(); n++ )
                               {
                                 const char *s = (*sl)[n];
                                 if ( !IsStrEmpty(s) )
                                    {
                                      int idx = StrToInt(s);
                                      if ( idx >= 0 && idx < m_lics.size() )
                                         {
                                           m_lics[idx].first = TRUE;
                                         }
                                    }
                               }

                           FreeStringList(sl);
                         }
                    }
               }
          }
     }
}


void CFloatLic::_Poll()
{
  BOOL is_steam_game_exited = FALSE;

  for ( int n = 0; n < m_list.size(); n++ )
      {
        CFloatLicSingle *i = m_list[n];
        if ( i )
           {
             BOOL b_need_del = FALSE;

             if ( i->Poll(b_need_del) )
                {
                  if ( b_need_del && i->IsSteam() )
                     {
                       is_steam_game_exited = TRUE;
                     }
                     
                  if ( b_need_del )
                     {
                       SAFEDELETE(m_list[n]);
                     }
                }
           }
      }

  if ( is_steam_game_exited )
     {
       // shutdown steam to release account
       CFloatLicTools::ShutdownSteam();
     }
}


void CFloatLic::_ShutdownSteamAndSteamLicsWait()
{
  BOOL is_steam_game_exited = FALSE;

  for ( int n = 0; n < m_list.size(); n++ )
      {
        CFloatLicSingle *i = m_list[n];
        if ( i )
           {
             if ( i->IsSteam() )
                {
                  is_steam_game_exited = TRUE;
                  SAFEDELETE(m_list[n]);
                }
           }
      }

//  if ( is_steam_game_exited )
     {
       // shutdown steam to release account
       CFloatLicTools::ShutdownSteam(10000);
     }
}


void CFloatLic::Poll()
{
  GetObj()._Poll();
}


void CFloatLic::ShutdownSteamAndSteamLicsWait()
{
  GetObj()._ShutdownSteamAndSteamLicsWait();
}


void CFloatLic::Add(CFloatLicSingle *i)
{
  GetObj()._Add(i);
}


CFloatLicSingle* CFloatLic::Execute(const char *serverpath,const char *envname)
{
  return GetObj()._Execute(serverpath,envname);
}


void CFloatLic::OnServerAck(const CNetCmd& cmd)
{
  GetObj()._OnServerAck(cmd);
}


void CFloatLic::OnClientReq(const CNetCmd& cmd,unsigned src_guid)
{
  GetObj()._OnClientReq(cmd,src_guid);
}


void CFloatLic::OnClientAck(const CNetCmd& cmd)
{
  GetObj()._OnClientAck(cmd);
}


