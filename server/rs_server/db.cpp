
#include "include.h"


class CStr2SQL
{
          char *s_esc;

  public:
          CStr2SQL(CSQLLib *lib,const char *s) : s_esc(NULL)
          {
            if ( s && lib )
               {
                 s_esc = (char*)sys_alloc(lstrlen(s)*2+1);
                 s_esc[0] = 0;
                 lib->EscapeString(s,s_esc);
               }
          }
          ~CStr2SQL()
          {
            if ( s_esc )
               sys_free(s_esc);
          }

          const char* Text() const { return s_esc ? s_esc : ""; }
          operator const char* () const { return Text(); }
};



CDBLibGCRP::CDBLibGCRP()
{
  gc = NULL;
  rp = NULL;
  m_dbtype_gc = SQL_TYPE_UNKNOWN;
  m_dbtype_rp = SQL_TYPE_UNKNOWN;
}


CDBLibGCRP::~CDBLibGCRP()
{
  Free();
}


void CDBLibGCRP::SetLib(int type_gc,int type_rp)
{
  if ( m_dbtype_gc != type_gc )
     {
       if ( gc )
          delete gc;
       gc = (type_gc == SQL_TYPE_UNKNOWN ? NULL : new CSQLLib(type_gc));
       m_dbtype_gc = type_gc;
     }

  if ( m_dbtype_rp != type_rp )
     {
       if ( rp )
          delete rp;
       rp = (type_rp == SQL_TYPE_UNKNOWN ? NULL : new CSQLLib(type_rp));
       m_dbtype_rp = type_rp;
     }
}


void CDBLibGCRP::Free()
{
  if ( gc )
     delete gc;
  gc = NULL;
  if ( rp )
     delete rp;
  rp = NULL;

  m_dbtype_gc = SQL_TYPE_UNKNOWN;
  m_dbtype_rp = SQL_TYPE_UNKNOWN;
}


void CDBLibGCRP::ClearWithoutFree()
{
  gc = NULL;
  rp = NULL;
  m_dbtype_gc = SQL_TYPE_UNKNOWN;
  m_dbtype_rp = SQL_TYPE_UNKNOWN;
}


BOOL CDBLibGCRP::Connect(const char *server)
{
  if ( rp && rp->IsConnected() )
     return TRUE;

  if ( !rp )
     return FALSE;
  
  if ( !rp->ConnectAsInternalUser(server) )
     return FALSE;

  if ( gc )
     {
       gc->Connect(server,"pm_service","rfnfgekmnf","GameClass");
     }

  return TRUE;
}


BOOL CDBLibGCRP::IsConnected()
{
  return rp && rp->IsConnected();
}


BOOL CDBLibGCRP::PollServer()
{
  return IsConnected() ? rp->PollServer() : FALSE;
}


void CDBLibGCRP::Disconnect()
{
  if ( rp && rp->IsConnected() )
     rp->Disconnect();

  if ( gc && gc->IsConnected() )
     gc->Disconnect();
}


const char* CDBLibGCRP::GetLastError()
{
  return rp ? rp->GetLastError() : "";
}





CDBObj::CDBObj(HKEY root,const char *key,const char *value_server,const char *value_dbtype_rp,const char *value_dbtype_gc)
{
  reg_root = root;
  reg_key = sys_copystring(key);
  reg_value_server = sys_copystring(value_server);
  reg_value_dbtype_rp = sys_copystring(value_dbtype_rp);
  reg_value_dbtype_gc = sys_copystring(value_dbtype_gc);
  last_reg_read_time = GetTickCount() - 60000;

  server_name[0] = 0;
  dbtype_rp = SQL_TYPE_UNKNOWN;
  dbtype_gc = SQL_TYPE_UNKNOWN;

  last_poll_time = GetTickCount();

  b_connected = FALSE;
  hwnd = NULL;

  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,&id_thread);
}


CDBObj::~CDBObj()
{
  PostThreadMessage(id_thread,WM_QUIT,0,0);
  if ( WaitForSingleObject(h_thread,15000) == WAIT_TIMEOUT )
     {
       TerminateThread(h_thread,0);
       b_connected = FALSE;
       hwnd = NULL;
       gcrp.ClearWithoutFree(); //avoid FreeLibrary() from another thread!
     }
  CloseHandle(h_thread);

  if ( reg_key )
     sys_free(reg_key);
  if ( reg_value_server )
     sys_free(reg_value_server);
  if ( reg_value_dbtype_rp )
     sys_free(reg_value_dbtype_rp);
  if ( reg_value_dbtype_gc )
     sys_free(reg_value_dbtype_gc);
}


DWORD WINAPI CDBObj::ThreadProcWrapper(LPVOID lpParameter)
{
  CDBObj *obj = (CDBObj*)lpParameter;
  return obj->ThreadProc();
}


LRESULT CALLBACK CDBObj::WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  CDBObj *obj = (CDBObj*)GetProp(hwnd,"this");

  if ( obj )
     {
       return obj->WindowProc(hwnd,message,wParam,lParam);
     }
  else
     {
       return DefWindowProc(hwnd,message,wParam,lParam);
     }
}


LRESULT CDBObj::WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam)
{
  switch ( message )
  {
    case WM_USER:
                     return OnCmdProcess(wParam,(DWORD_PTR)lParam);
    
    case WM_DESTROY:
                     RemoveProp(hwnd,"this");
                     break;

    case WM_CLOSE:
                     return 0;

  };

  return DefWindowProc(hwnd,message,wParam,lParam);
}


DWORD CDBObj::ThreadProc()
{
  CoInitializeEx(NULL,COINIT_APARTMENTTHREADED);

  SetThreadLocale(0x419); // needed for mssql

  HINSTANCE instance = GetModuleHandle(NULL);
  
  WNDCLASS wc;
  ZeroMemory(&wc,sizeof(wc));
  wc.lpfnWndProc = WindowProcWrapper;
  wc.hInstance = instance;
  wc.lpszClassName = "_RunpadProServerMessageOnlyWindowClass";
  ATOM class_atom = RegisterClass(&wc);

  HWND t_hwnd = CreateWindowEx(0,(LPCSTR)class_atom,NULL,0,0,0,0,0,HWND_MESSAGE,NULL,instance,NULL);
  SetProp(t_hwnd,"this",(HANDLE)this);
  hwnd = t_hwnd;

  HANDLE h_event = CreateEvent(NULL,FALSE,FALSE,NULL);

  ADD2LOG(("---- CDBObj Log started ----"));

  while ( 1 )
  {
    MSG msg;
    if ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
       {
       	 if ( !GetMessage(&msg,NULL,0,0) )
       	    break;
       	 DispatchMessage(&msg);
       }
    else 
       { 
         OnIdle();
         MsgWaitForMultipleObjects(1,&h_event,FALSE,2000,QS_ALLINPUT);
       }
  };

  ADD2LOG(("---- CDBObj Log finished ----"));

  Disconnect();

  CloseHandle(h_event);

  t_hwnd = hwnd;
  hwnd = NULL;
  DestroyWindow(t_hwnd);

  UnregisterClass((LPCSTR)class_atom,instance);
  
  gcrp.Free();

  CoUninitialize();
  return 1;
}


void CDBObj::RetrieveServerName(BOOL *_changed)
{
  if ( _changed )
     *_changed = FALSE;
  
  if ( GetTickCount() - last_reg_read_time > 30000 )
     {
       char name[MAX_PATH];
       ReadRegStr(reg_root,reg_key,reg_value_server,name,"");
       int type_rp = ReadRegDword(reg_root,reg_key,reg_value_dbtype_rp,SQL_TYPE_UNKNOWN);
       int type_gc = ReadRegDword(reg_root,reg_key,reg_value_dbtype_gc,SQL_TYPE_UNKNOWN);
       last_reg_read_time = GetTickCount();

       if ( lstrcmpi(name,server_name) || type_rp != dbtype_rp || type_gc != dbtype_gc )
          {
            lstrcpy(server_name,name);
            dbtype_rp = type_rp;
            dbtype_gc = type_gc;

            if ( _changed )
               *_changed = TRUE;
          }

       ADD2LOG(("Retrieve SQL-server name: \"%s\" (%d,%d)",server_name,dbtype_rp,dbtype_gc));
     }
}


void CDBObj::Disconnect()
{
  b_connected = FALSE;
  gcrp.Disconnect();
}


void CDBObj::UpdateActualConnectionStatus()
{
  b_connected = gcrp.IsConnected();  // the state gcrp.IsConnected() can be changed before after SQL-query execution

  if ( GetTickCount() - last_poll_time > 30000 )
     {
       gcrp.PollServer();
       last_poll_time = GetTickCount();
     }

  b_connected = gcrp.IsConnected();  //actual state
}


void CDBObj::Connect()
{
  if ( !b_connected )
     {
       if ( server_name[0] )
          {
            gcrp.SetLib(dbtype_gc,dbtype_rp);

            ADD2LOG(("Connecting..."));
            
            b_connected = gcrp.Connect(server_name);

            if ( b_connected )
               {
                 ADD2LOG(("Connected OK!"));
               }
            else
               {
                 const char *err = gcrp.GetLastError();
                 ADD2LOG(("Connection failed: %s",err?err:""));
               }
          }
     }
}


// maybe called from another thread!
BOOL CDBObj::IsConnected()
{
  return b_connected;  //we check var here to speedup when thread in connection state
}


void CDBObj::OnIdle()
{
  BOOL b_changed = FALSE;
  RetrieveServerName(&b_changed);

  if ( b_changed )
     {
       Disconnect();
     }

  UpdateActualConnectionStatus();

  Connect();
}


// maybe called from another thread!
BOOL CDBObj::SendThreadMessage(int cmd,DWORD_PTR data,int *_exit_code)
{
  BOOL rc = FALSE;

  if ( _exit_code )
     *_exit_code = 0;
  
  if ( hwnd )
     {
       DWORD_PTR exit_code = 0;
       if ( SendMessageTimeout(hwnd,WM_USER,cmd,(LPARAM)data,SMTO_BLOCK,60000/*todo:max or infitite must be!*/,&exit_code) )
          {
            rc = TRUE;

            if ( _exit_code )
               *_exit_code = exit_code;
          }
     }

  return rc;
}


// maybe called from another thread!
// warning! IsConnected() is not checked here, so can be slowdown in N-sec
void CDBObj::GetLastErrorSlow(char *_err,int max)
{
  if ( _err && max > 0 )
     {
       _err[0] = 0;

       CDynBuff *buff = new CDynBuff();

       (*buff) += "";  // dummy

       int exit_code = 0;
       if ( SendThreadMessage(CMD_GETLASTERROR,(DWORD_PTR)buff,&exit_code) )
          {
            char *src = (char*)exit_code;
            if ( src )
               {
                 lstrcpyn(_err,src,max);
                 sys_free(src);
               }
          }

       delete buff;
     }
}


// maybe called from another thread!
BOOL CDBObj::VipLogin(const char *s_login, const char *s_pwd)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_login;
       (*buff) += s_pwd;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_VIPLOGIN,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::VipLoginByPwd(const char *s_pwd,char *_login)
{
  BOOL rc = FALSE;

  if ( _login )
     _login[0] = 0;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_pwd;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_VIPLOGINBYPWD,(DWORD_PTR)buff,&exit_code) )
          {
            char *t = (char*)exit_code;
            if ( t )
               {
                 if ( _login )
                    lstrcpyn(_login,t,MAX_PATH);

                 sys_free(t);
                 rc = TRUE;
               }
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::VipRegister(const char *s_login, const char *s_pwd)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_login;
       (*buff) += s_pwd;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_VIPREGISTER,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::VipDelete(const char *s_login)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_login;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_VIPDELETE,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::VipClearPass(const char *s_login)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_login;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_VIPCLEARPASS,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::AddServiceString(
               const char* s_computerloc,
               const char* s_computerdesc,
               const char* s_computername,
               const char* s_ip,
               const char* s_userdomain,
               const char* s_username,
               const char* s_vipname,
               int s_id,
               int s_count,
               int s_kbsize,
               int s_time,
               const char* s_comment
              )
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_computerloc;
       (*buff) += s_computerdesc;
       (*buff) += s_computername;
       (*buff) += s_ip;
       (*buff) += s_userdomain;
       (*buff) += s_username;
       (*buff) += s_vipname;
       (*buff) += s_id;
       (*buff) += s_count;
       (*buff) += s_kbsize;
       (*buff) += s_time;
       (*buff) += s_comment;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_ADDSERVICESTRING,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::AddEventString(
               const char* s_computerloc,
               const char* s_computerdesc,
               const char* s_computername,
               const char* s_ip,
               const char* s_userdomain,
               const char* s_username,
               const char* s_vipname,
               int s_level,
               const char* s_comment
              )
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_computerloc;
       (*buff) += s_computerdesc;
       (*buff) += s_computername;
       (*buff) += s_ip;
       (*buff) += s_userdomain;
       (*buff) += s_username;
       (*buff) += s_vipname;
       (*buff) += s_level;
       (*buff) += s_comment;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_ADDEVENTSTRING,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::AddUserResponse( 
               const char *s_kind,
               const char *s_title,
               const char *s_name,
               const char *s_age,
               const char *s_text
               )
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_kind;
       (*buff) += s_title;
       (*buff) += s_name;
       (*buff) += s_age;
       (*buff) += s_text;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_ADDUSERRESPONSE,(DWORD_PTR)buff,&exit_code) )
          {
            rc = (BOOL)exit_code;
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::SettingsReq(
               const char *s_computerloc,
               const char *s_computerdesc,
               const char *s_computername,
               const char *s_ip,
               const char *s_userdomain,
               const char *s_username,
               int s_langid,
               CNetCmd &out)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_computerloc;
       (*buff) += s_computerdesc;
       (*buff) += s_computername;
       (*buff) += s_ip;
       (*buff) += s_userdomain;
       (*buff) += s_username;
       (*buff) += s_langid;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_SETTINGSREQ,(DWORD_PTR)buff,&exit_code) )
          {
            CDynBuff *t = (CDynBuff*)exit_code;
            if ( t )
               {
                 out += *t;
                 delete t;
                 rc = TRUE;
               }
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::CompSettingsReq(
               const char *s_computerloc,
               const char *s_computerdesc,
               const char *s_computername,
               const char *s_ip,
               CNetCmd &out)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += s_computerloc;
       (*buff) += s_computerdesc;
       (*buff) += s_computername;
       (*buff) += s_ip;
       
       int exit_code = 0;
       if ( SendThreadMessage(CMD_COMPSETTINGSREQ,(DWORD_PTR)buff,&exit_code) )
          {
            CDynBuff *t = (CDynBuff*)exit_code;
            if ( t )
               {
                 out += *t;
                 delete t;
                 rc = TRUE;
               }
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
BOOL CDBObj::GetClientUpdateOrderedList(BOOL is_no_shell,TStringPairVector &out)
{
  BOOL rc = FALSE;
  
  if ( IsConnected() )
     {
       CDynBuff *buff = new CDynBuff();

       (*buff) += "dummy";

       int exit_code = 0;
       if ( SendThreadMessage(is_no_shell?CMD_CLIENTUPDATENOSHELLLISTREQ:CMD_CLIENTUPDATELISTREQ,(DWORD_PTR)buff,&exit_code) )
          {
            TStringPairVector *t = (TStringPairVector*)exit_code;
            if ( t )
               {
                 out = *t;
                 delete t;
                 rc = TRUE;
               }
          }

       delete buff;
     }

  return rc;
}


// maybe called from another thread!
void* CDBObj::GetClientUpdateFile(BOOL is_no_shell,const char *path,const char *crc32,unsigned *_size)
{
  void *rc = NULL;
  
  if ( _size )
     *_size = 0;

  if ( IsStrEmpty(path) || IsStrEmpty(crc32) )
     return rc;
  
  if ( !IsConnected() )
     return rc;

  CDynBuff *buff = new CDynBuff();

  (*buff) += path;
  (*buff) += crc32;

  int exit_code = 0;
  if ( SendThreadMessage(is_no_shell?CMD_CLIENTUPDATENOSHELLFILEREQ:CMD_CLIENTUPDATEFILEREQ,(DWORD_PTR)buff,&exit_code) )
     {
       UPDFILE *t = (UPDFILE*)exit_code;
       if ( t )
          {
            if ( _size )
               *_size = t->size;
            rc = t->buff;
            delete t;
          }
     }

  delete buff;

  return rc;
}



BOOL CDBObj::OnCmdProcess(int cmd,DWORD_PTR data)
{
  BOOL rc = FALSE;

  if ( data )
     {
       CSQLLib *rp = gcrp.GetRPObj();
       CSQLLib *gc = gcrp.GetGCObj();

       CDynBuff buff(*(const CDynBuff*)data);  //we copy parms
       const char *p = buff.GetBuffPtr();

       if ( p )
          {
            switch ( cmd )
            {
              case CMD_GETLASTERROR:
              {
                rc = (BOOL)sys_copystring(gcrp.GetLastError());
                break;
              }
              
              case CMD_VIPLOGIN:
              {
                const char *s_login = p; p += lstrlen(p)+1;
                const char *s_pwd = p; p += lstrlen(p)+1;

                if ( !IsStrEmpty(s_login) )
                   {
                     // first login in RP base
                     if ( rp )
                        {
                          char *s = (char*)sys_alloc(lstrlen(s_login)*2+lstrlen(s_pwd)*2+MAX_PATH);
                          wsprintf(s,"\'%s\',\'%s\'",CStr2SQL(rp,s_login).Text(),CStr2SQL(rp,s_pwd).Text());
                          
                          int count = 0;
                          if ( rp->InplaceCallStoredProc("PVipLogin",s,SQL_DEF_TIMEOUT,&count) && count > 0 )
                             rc = TRUE;

                          sys_free(s);
                        }

                     if ( !rc )
                        {
                          // try to login in GC base
                          if ( gc )
                             {
                               GCVIPLOGIN i;
                               i.name = s_login;
                               i.pwd = s_pwd;
                               i.find = FALSE;

                               if ( gc->InplaceCallStoredProc("AccountsSelect",NULL,SQL_DEF_TIMEOUT,NULL,GCVipLoginProc,&i) && i.find )
                                  rc = TRUE;
                             }
                        }
                   }

                break;
              }

              case CMD_VIPLOGINBYPWD:
              {
                const char *s_pwd = p; p += lstrlen(p)+1;

                if ( !IsStrEmpty(s_pwd) )
                   {
                     if ( rp )
                        {
                          char *s = (char*)sys_alloc(lstrlen(s_pwd)*2+MAX_PATH);
                          // maybe better sprintf here???
                          wsprintf(s,"\'%s\'",CStr2SQL(rp,s_pwd).Text());
                          
                          char s_login[MAX_PATH] = "";
                          
                          if ( rp->InplaceCallStoredProc("PVipLoginByPwd",s,SQL_DEF_TIMEOUT,NULL,RPVipLoginByPwdProc,s_login) )
                             {
                               if ( !IsStrEmpty(s_login) )
                                  {
                                    rc = (BOOL)sys_copystring(s_login);
                                  }
                             }

                          sys_free(s);
                        }
                   }

                break;
              }

              case CMD_VIPREGISTER:
              {
                const char *s_login = p; p += lstrlen(p)+1;
                const char *s_pwd = p; p += lstrlen(p)+1;

                if ( !IsStrEmpty(s_login) )
                   {
                     if ( rp )
                        {
                          char *s = (char*)sys_alloc(lstrlen(s_login)*2+lstrlen(s_pwd)*2+MAX_PATH);
                          wsprintf(s,"\'%s\',\'%s\'",CStr2SQL(rp,s_login).Text(),CStr2SQL(rp,s_pwd).Text());
                          
                          int count = 0;
                          if ( rp->InplaceCallStoredProc("PVipRegister",s,SQL_DEF_TIMEOUT,&count) && count > 0 )
                             rc = TRUE;

                          sys_free(s);
                        }
                   }

                break;
              }

              case CMD_VIPDELETE:
              {
                const char *s_login = p; p += lstrlen(p)+1;

                if ( !IsStrEmpty(s_login) )
                   {
                     if ( rp )
                        {
                          char *s = (char*)sys_alloc(lstrlen(s_login)*2+MAX_PATH);
                          wsprintf(s,"\'%s\'",CStr2SQL(rp,s_login).Text());
                          
                          if ( rp->InplaceCallStoredProc("PVipDelete",s) )
                             rc = TRUE;

                          sys_free(s);
                        }
                   }

                break;
              }

              case CMD_VIPCLEARPASS:
              {
                const char *s_login = p; p += lstrlen(p)+1;

                if ( !IsStrEmpty(s_login) )
                   {
                     if ( rp )
                        {
                          char *s = (char*)sys_alloc(lstrlen(s_login)*2+MAX_PATH);
                          wsprintf(s,"\'%s\'",CStr2SQL(rp,s_login).Text());
                          
                          if ( rp->InplaceCallStoredProc("PVipClearPass",s) )
                             rc = TRUE;

                          sys_free(s);
                        }
                   }

                break;
              }

              case CMD_ADDSERVICESTRING:
              {
                const char* s_computerloc = p; p += lstrlen(p)+1;
                const char* s_computerdesc = p; p += lstrlen(p)+1;
                const char* s_computername = p; p += lstrlen(p)+1;
                const char* s_ip = p; p += lstrlen(p)+1;
                const char* s_userdomain = p; p += lstrlen(p)+1;
                const char* s_username = p; p += lstrlen(p)+1;
                const char* s_vipname = p; p += lstrlen(p)+1;
                int s_id = *(int*)p; p += sizeof(int);
                int s_count = *(int*)p; p += sizeof(int);
                int s_kbsize = *(int*)p; p += sizeof(int);
                int s_time = *(int*)p; p += sizeof(int);
                const char* s_comment = p; p += lstrlen(p)+1;

                if ( rp )
                   {
                     TSTOREDPROCPARAM argv[] =
                     {
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerloc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerdesc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computername,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_ip,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_userdomain,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_username,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_vipname,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_id,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_count,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_kbsize,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_time,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_comment,0},
                     };

                     if ( rp->CallStoredProc("PAddServiceString",SQL_DEF_TIMEOUT,argv,sizeof(argv)/sizeof(argv[0])) )
                        {
                          rc = TRUE;
                        }
                   }

                if ( gc )
                   {
                     TSTOREDPROCPARAM argv[] =
                     {
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerloc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerdesc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computername,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_ip,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_userdomain,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_username,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_vipname,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_id,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_count,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_kbsize,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_time,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_comment,0},
                     };

                     if ( gc->CallStoredProc("ServicesRunpadInsert3",SQL_DEF_TIMEOUT,argv,sizeof(argv)/sizeof(argv[0])) )
                        {
                        }
                   }
                
                break;
              }

              case CMD_ADDEVENTSTRING:
              {
                const char* s_computerloc = p; p += lstrlen(p)+1;
                const char* s_computerdesc = p; p += lstrlen(p)+1;
                const char* s_computername = p; p += lstrlen(p)+1;
                const char* s_ip = p; p += lstrlen(p)+1;
                const char* s_userdomain = p; p += lstrlen(p)+1;
                const char* s_username = p; p += lstrlen(p)+1;
                const char* s_vipname = p; p += lstrlen(p)+1;
                int s_level = *(int*)p; p += sizeof(int);
                const char* s_comment = p; p += lstrlen(p)+1;

                if ( rp )
                   {
                     TSTOREDPROCPARAM argv[] =
                     {
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerloc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computerdesc,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_computername,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_ip,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_userdomain,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_username,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_vipname,0},
                       {SQL_PD_INPUT,SQL_DT_INTEGER,(void*)&s_level,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_comment,0},
                     };

                     if ( rp->CallStoredProc("PAddEventString",SQL_DEF_TIMEOUT,argv,sizeof(argv)/sizeof(argv[0])) )
                        {
                          rc = TRUE;
                        }
                   }

                break;
              }

              case CMD_ADDUSERRESPONSE:
              {
                const char *s_kind = p; p += lstrlen(p)+1;
                const char *s_title = p; p += lstrlen(p)+1;
                const char *s_name = p; p += lstrlen(p)+1;
                const char *s_age = p; p += lstrlen(p)+1;
                const char *s_text = p; p += lstrlen(p)+1;

                if ( rp )
                   {
                     TSTOREDPROCPARAM argv[] =
                     {
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_kind,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_title,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_name,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_age,0},
                       {SQL_PD_INPUT,SQL_DT_STRING,(void*)s_text,0},
                     };

                     if ( rp->CallStoredProc("PAddUserResponse",SQL_DEF_TIMEOUT,argv,sizeof(argv)/sizeof(argv[0])) )
                        {
                          rc = TRUE;
                        }
                   }

                break;
              }

              case CMD_SETTINGSREQ:
              {
                const char* s_computerloc = p; p += lstrlen(p)+1;
                const char* s_computerdesc = p; p += lstrlen(p)+1;
                const char* s_computername = p; p += lstrlen(p)+1;
                const char* s_ip = p; p += lstrlen(p)+1;
                const char* s_userdomain = p; p += lstrlen(p)+1;
                const char* s_username = p; p += lstrlen(p)+1;
                int s_langid = *(int*)p; p += sizeof(int);

                if ( rp )
                   {
                     RULESCOLLECT i;
                     i.count = 0;

                     if ( rp->Exec("SELECT * FROM TSettingsRules ORDER BY number ASC",SQL_DEF_TIMEOUT,NULL,RulesCollectionProc,&i) )
                        {
                          if ( i.count > 0 )
                             {
                               const char *p = i.rules.GetBuffPtr();

                               for ( int n = 0; n < i.count; n++ )
                                   {
                                     const char *s_rule = p; p += lstrlen(p)+1;
                                     const char *s_varprof = p; p += lstrlen(p)+1;
                                     const char *s_cntprof = p; p += lstrlen(p)+1;

                                     if ( IsRuleAppliedInternal(rp,s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_langid) )
                                        {
                                          CDynBuff *out = new CDynBuff();

                                          if ( !LoadSettingsProfileInternal(rp,"TVarsProfiles",s_varprof,out) )
                                             {
                                               delete out;
                                               break;
                                             }
                                          if ( !LoadSettingsProfileInternal(rp,"TContentProfiles",s_cntprof,out) )
                                             {
                                               delete out;
                                               break;
                                             }

                                          rc = (BOOL)out;
                                          break;
                                        }
                                   }
                             }
                        }
                   }

                break;
              }

              case CMD_COMPSETTINGSREQ:
              {
                const char* s_computerloc = p; p += lstrlen(p)+1;
                const char* s_computerdesc = p; p += lstrlen(p)+1;
                const char* s_computername = p; p += lstrlen(p)+1;
                const char* s_ip = p; p += lstrlen(p)+1;

                if ( rp )
                   {
                     RULESCOLLECT i;
                     i.count = 0;

                     if ( rp->Exec("SELECT * FROM TCompSettingsRules ORDER BY number ASC",SQL_DEF_TIMEOUT,NULL,RulesCollectionProc,&i) )
                        {
                          if ( i.count > 0 )
                             {
                               const char *p = i.rules.GetBuffPtr();

                               for ( int n = 0; n < i.count; n++ )
                                   {
                                     const char *s_rule = p; p += lstrlen(p)+1;
                                     const char *s_varprof = p; p += lstrlen(p)+1;
                                     const char *s_cntprof = p; p += lstrlen(p)+1; //unused

                                     if ( IsRuleAppliedInternal(rp,s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,"","",0) )
                                        {
                                          CDynBuff *out = new CDynBuff();

                                          if ( !LoadSettingsProfileInternal(rp,"TCompProfiles",s_varprof,out) )
                                             {
                                               delete out;
                                               break;
                                             }

                                          rc = (BOOL)out;
                                          break;
                                        }
                                   }
                             }
                        }
                   }

                break;
              }

              case CMD_CLIENTUPDATELISTREQ:
              case CMD_CLIENTUPDATENOSHELLLISTREQ:
              {
                if ( rp )
                   {
                     TStringPairVector *i = new TStringPairVector();
                     
                     const char *query = (cmd == CMD_CLIENTUPDATELISTREQ ? "SELECT path, crc32 FROM TClientUpdate ORDER BY path ASC" : "SELECT path, crc32 FROM TClientUpdateNoShell ORDER BY path ASC" );
                     
                     if ( rp->Exec(query,25,NULL,ClientUpdateListCollectionProc,i) )
                        {
                          rc = (BOOL)i;
                        }
                     else
                        {
                          delete i;
                        }
                   }

                break;
              }

              case CMD_CLIENTUPDATEFILEREQ:
              case CMD_CLIENTUPDATENOSHELLFILEREQ:
              {
                const char* s_path = p; p += lstrlen(p)+1;
                const char* s_crc32 = p; p += lstrlen(p)+1;

                if ( rp )
                   {
                     UPDFILE *i = new UPDFILE;
                     i->buff = NULL;
                     i->size = 0;

                     char query[MAX_PATH];
                     wsprintf(query,"SELECT data FROM %s WHERE path=\'%s\' AND crc32=\'%s\'",cmd==CMD_CLIENTUPDATEFILEREQ?"TClientUpdate":"TClientUpdateNoShell",CStr2SQL(rp,s_path).Text(),CStr2SQL(rp,s_crc32).Text());
                     
                     if ( rp->Exec(query,25,NULL,ClientUpdateFileCollectionProc,i) )
                        {
                          rc = (BOOL)i;
                        }
                     else
                        {
                          delete i;
                        }
                   }

                break;
              }

            };
          }
     }

  return rc;
}


BOOL __cdecl CDBObj::GCVipLoginProc(TEXECSQLCBSTRUCT *i)
{
  BOOL rc = TRUE;
  
  void *f_name = i->GetFieldByName(i->obj,"name");
  void *f_pwd = i->GetFieldByName(i->obj,"password");

  if ( f_name && f_pwd )
     {
       char *s_name = i->GetFieldValueAsString(i->obj,f_name);
       char *s_pwd = i->GetFieldValueAsString(i->obj,f_pwd);

       if ( s_name && s_pwd )
          {
            GCVIPLOGIN *cmp = (GCVIPLOGIN*)i->user_parm;

            if ( !lstrcmpi(cmp->name,s_name) && !lstrcmpi(cmp->pwd,s_pwd) )
               {
                 cmp->find = TRUE;
                 rc = FALSE;
               }
          }

       if ( s_name )
          i->FreePointer(s_name);
       if ( s_pwd )
          i->FreePointer(s_pwd);
     }

  return rc;
}


BOOL __cdecl CDBObj::RPVipLoginByPwdProc(TEXECSQLCBSTRUCT *i)
{
  void *f_name = i->GetFieldByName(i->obj,"user_name");

  if ( f_name )
     {
       char *s_name = i->GetFieldValueAsString(i->obj,f_name);

       if ( s_name )
          {
            char *dest = (char*)i->user_parm;
            lstrcpyn(dest,s_name,MAX_PATH);
          }

       if ( s_name )
          i->FreePointer(s_name);
     }

  return FALSE; //only first is accepted
}


BOOL __cdecl CDBObj::RulesCollectionProc(TEXECSQLCBSTRUCT *i)
{
  void *f_rule = i->GetFieldByName(i->obj,"rule_string");
  void *f_profile1 = i->GetFieldByName(i->obj,"vars_profile");
  void *f_profile2 = i->GetFieldByName(i->obj,"content_profile");
  void *f_profile3 = i->GetFieldByName(i->obj,"comp_profile");

  if ( f_rule && ((f_profile1 && f_profile2) || f_profile3) )
     {
       char *s_rule = i->GetFieldValueAsString(i->obj,f_rule);
       char *s_profile1 = f_profile1 ? i->GetFieldValueAsString(i->obj,f_profile1) : NULL;
       char *s_profile2 = f_profile2 ? i->GetFieldValueAsString(i->obj,f_profile2) : NULL;
       char *s_profile3 = f_profile3 ? i->GetFieldValueAsString(i->obj,f_profile3) : NULL;

       if ( (!IsStrEmpty(s_profile1) && !IsStrEmpty(s_profile2)) || !IsStrEmpty(s_profile3) )
          {
            RULESCOLLECT *r = (RULESCOLLECT*)i->user_parm;
            r->rules += s_rule;
            if ( !IsStrEmpty(s_profile1) && !IsStrEmpty(s_profile2) )
               {
                 r->rules += s_profile1;
                 r->rules += s_profile2;
               }
            else
               {
                 r->rules += s_profile3;
                 r->rules += "";
               }
            r->count++;
          }

       if ( s_rule )
          i->FreePointer(s_rule);
       if ( s_profile1 )
          i->FreePointer(s_profile1);
       if ( s_profile2 )
          i->FreePointer(s_profile2);
       if ( s_profile3 )
          i->FreePointer(s_profile3);
     }

  return TRUE;
}


BOOL CDBObj::LoadSettingsProfileInternal(CSQLLib *sql,const char *s_table,const char *s_profile,CDynBuff *out)
{
  char query[MAX_PATH*2];
  wsprintf(query,"SELECT data FROM %s WHERE name=\'%s\'",s_table,CStr2SQL(sql,s_profile).Text());
  
  unsigned old_size = out->GetBuffSize();

  BOOL rc = sql->Exec(query,25,NULL,LoadSettingsProfileCB,out);

  unsigned new_size = out->GetBuffSize();

  return rc ? (new_size > old_size) : FALSE;
}


BOOL __cdecl CDBObj::LoadSettingsProfileCB(TEXECSQLCBSTRUCT *i)
{
  void *f = i->GetFieldByName(i->obj,"data");

  if ( f )
     {
       int size = 0;
       void *buff = i->GetFieldValueAsBlob(i->obj,f,&size);

       if ( buff && size > 0 )
          {
            CDynBuff *out = (CDynBuff*)i->user_parm;
            out->AddBuff(buff,size);
          }

       if ( buff )
          i->FreePointer(buff);
     }

  return FALSE; //only one is accepted!
}


BOOL CDBObj::IsRuleAppliedInternal(CSQLLib *sql,
                                   const char *s_rule,
                                   const char *s_computerloc,
                                   const char *s_computerdesc,
                                   const char *s_computername,
                                   const char *s_ip,
                                   const char *s_userdomain,
                                   const char *s_username,
                                   int s_langid)
{
  if ( IsStrEmpty(s_rule) )
     return TRUE; //empty rule is equals to TRUE

  return sql->RuleCheck(s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_langid);
}


BOOL __cdecl CDBObj::ClientUpdateListCollectionProc(TEXECSQLCBSTRUCT *i)
{
  void *f_path = i->GetFieldByName(i->obj,"path");
  void *f_crc32 = i->GetFieldByName(i->obj,"crc32");

  if ( f_path && f_crc32 )
     {
       char *s_path = i->GetFieldValueAsString(i->obj,f_path);
       char *s_crc32 = i->GetFieldValueAsString(i->obj,f_crc32);

       if ( !IsStrEmpty(s_path) && !IsStrEmpty(s_crc32) )
          {
            TStringPairVector *r = (TStringPairVector*)i->user_parm;
            char *s1 = sys_copystring(s_path);
            char *s2 = sys_copystring(s_crc32);
            r->push_back(TStringPair(s1,s2));
          }

       if ( s_path )
          i->FreePointer(s_path);
       if ( s_crc32 )
          i->FreePointer(s_crc32);
     }

  return TRUE;
}


BOOL __cdecl CDBObj::ClientUpdateFileCollectionProc(TEXECSQLCBSTRUCT *i)
{
  void *f = i->GetFieldByName(i->obj,"data");

  if ( f )
     {
       int size = 0;
       void *buff = i->GetFieldValueAsBlob(i->obj,f,&size);

       if ( buff && size > 0 )
          {
            UPDFILE *out = (UPDFILE*)i->user_parm;
            out->buff = sys_alloc(size);
            out->size = size;
            CopyMemory(out->buff,buff,size);
          }

       if ( buff )
          i->FreePointer(buff);
     }

  return FALSE; //only one is needed
}


