
#include "include.h"



CNetObj::CNetObj()
{
  TSTRING server_ip_t;
  ReadGlobalConfig(machine_type,machine_loc,machine_desc,server_ip_t);
  time_to_resend_classname = 0;
  
  h_ev_connect = CreateEvent(NULL,FALSE,FALSE,NULL);
  p_net = new CNetClient(HKLM,REGPATH,"server_ip",NETPORT,h_ev_connect,NULL);

  p_upd = new CUpdate();
  p_cfg = NULL;
  
  h_ev_finish = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,NULL);
  //SetThreadPriority(h_thread,THREAD_PRIORITY_IDLE);
}


CNetObj::~CNetObj()
{
  SetEvent(h_ev_finish);
  WaitForSingleObject(h_thread,10000);
  SmartThreadFinish(h_thread);
  CloseHandle(h_ev_finish);
  h_ev_finish = NULL;

  p_cfg = NULL;

  delete p_upd;
  p_upd = NULL;

  delete p_net;
  p_net = NULL;

  CloseHandle(h_ev_connect);
  h_ev_connect = NULL;
}


DWORD WINAPI CNetObj::ThreadProcWrapper(LPVOID lpParameter)
{
  CNetObj *obj = (CNetObj*)lpParameter;
  return obj->ThreadProc();
}


DWORD CNetObj::ThreadProc()
{
  CNetCmd cmd; //out of loop
  unsigned last_poll_time = GetTickCount() - 60000;
  BOOL is_rfm = FALSE;
  BOOL is_rd = FALSE;

  p_upd->StartupActions(); // some needed...

  p_cfg = new CConfigurator(machine_type,0/*lang*/);
  p_cfg->SetLastErrorI(CConfigurator::ERR_NOTCONNECTED);
  p_cfg->SetLastErrorS("");
 
  BOOL b_cfg_req_sent = FALSE;
  BOOL b_cfg_set_event = FALSE;
  
  do {

    if ( IsConnectEvent() )
       {
         SendStaticInfoToServer();
         SendDynamicInfoToServer();

         if ( !b_cfg_req_sent )
            {
              if ( !p_cfg->CanAccess() )
                 {
                   {
                     CNetCmd cmd(NETCMD_GETENV_REQ);
                     cmd.AddIntParm(NETPARM_I_GUID,NETGUID_SERVER);
                     NetSend(cmd);
                   }

                   NetSend(CNetCmd(NETCMD_GETSETTINGS_REQ));

                   p_cfg->SetLastErrorI(CConfigurator::ERR_NORESPONCE);
                   p_cfg->SetLastErrorS("");
                 }

              b_cfg_req_sent = TRUE;
            }
       }

    if ( NetIsConnected() )
       {
         PollServer(last_poll_time,is_rfm,is_rd);

         if ( time_to_resend_classname > 0 && GetNowOurTime() >= time_to_resend_classname )
            {
              SendStaticInfoToServer();
              time_to_resend_classname = 0;
            }
            
         for ( int count = 0; count < 5; count++ )
             {
               unsigned src_guid = NETGUID_UNKNOWN;
               if ( NetGet(cmd,&src_guid) )
                  {
                    if ( cmd.IsValid() && src_guid != NETGUID_UNKNOWN )
                       {
                         OnNetCmdReceived(cmd,src_guid);
                       }

                    cmd.Clear();
                    cmd.Compact(8192); //optimization
                  }
               else
                  break;
             }
       }

    if ( p_cfg->CanAccess() )  // poll config
       {
         if ( !b_cfg_set_event )
            {
              b_cfg_set_event = TRUE;
              OnCfgReceived();
            }
       }


    DWORD rc = WaitForSingleObject(h_ev_finish,30);
    if ( rc == WAIT_FAILED )
       Sleep(30);
    else
    if ( rc == WAIT_OBJECT_0 )
       break;

  } while (1);

  delete p_cfg;
  p_cfg = NULL;

  return 1;
}


BOOL CNetObj::NetSend(const CNetCmd& cmd,unsigned dest_guid)
{
  return p_net->Push(cmd,dest_guid);
}


BOOL CNetObj::NetGet(CNetCmd& cmd,unsigned *_src_guid)
{
  return p_net->Pop(cmd,_src_guid);
}


BOOL CNetObj::NetFlush(unsigned timeout)
{
  return p_net->Flush(timeout);
}


BOOL CNetObj::NetIsConnected()
{
  return p_net->IsConnected();
}


BOOL CNetObj::IsConnectEvent()
{
  return WaitForSingleObject(h_ev_connect,0) == WAIT_OBJECT_0;
}


void CNetObj::PollServer(unsigned &last_poll_time,BOOL &old_rfm,BOOL &old_rd)
{
  #define BOOLDIFFERS(a,b)    (((a) && !(b)) || (!(a) && (b)))
  
  if ( GetTickCount() - last_poll_time > 20000 )
     {
       BOOL is_rfm = IsServiceRunning(SERVICE_NAME_RFM);
       BOOL is_rd = IsServiceRunning(SERVICE_NAME_RD);

       if ( BOOLDIFFERS(is_rfm,old_rfm) || BOOLDIFFERS(is_rd,old_rd) )
          {
            old_rfm = is_rfm;
            old_rd = is_rd;
            
            CNetCmd cmd(NETCMD_UPDATESELFENV);
            cmd.AddBoolParm(NETPARM_B_RFMSERVICE,is_rfm);
            cmd.AddBoolParm(NETPARM_B_RDSERVICE,is_rd);
            NetSend(cmd);
          }
       else
          {
            NetSend(CNetCmd(NETCMD_POLLSERVER));
          }
       
       last_poll_time = GetTickCount();
     }
}


void CNetObj::SendStaticInfoToServer()
{
  char s[MAX_PATH];
  CNetCmd cmd(NETCMD_UPDATESELFENV);

  cmd.AddStringParm(NETPARM_S_CLASS,NETCLASS_COMPUTER); //we are computer
  cmd.AddStringParm(NETPARM_S_MACHINELOC,machine_loc);
  cmd.AddStringParm(NETPARM_S_MACHINEDESC,machine_desc);
  cmd.AddStringParm(NETPARM_S_COMPNAME,MyGetComputerName(s));
  cmd.AddStringParm(NETPARM_S_MAC,GetMyMACAsString(s));
  cmd.AddStringParm(NETPARM_S_VERSION,RUNPAD_VERSION_STR);
  
  NetSend(cmd);
}


void CNetObj::SendDynamicInfoToServer()
{
  CNetCmd cmd(NETCMD_UPDATESELFENV);

  cmd.AddBoolParm(NETPARM_B_RFMSERVICE,IsServiceRunning(SERVICE_NAME_RFM));
  cmd.AddBoolParm(NETPARM_B_RDSERVICE,IsServiceRunning(SERVICE_NAME_RD));

  int st_rlb = -1;
  CRollback().GetRollbackStatus(st_rlb);
  if (    st_rlb == CRollback::ST_RLB_ON_ON 
      // || st_rlb == CRollback::ST_RLB_ON_ON_SAVE
       || st_rlb == CRollback::ST_RLB_ON_OFF 
      // || st_rlb == CRollback::ST_RLB_ON_OFF_SAVE 
     )
     {
       cmd.AddBoolParm(NETPARM_B_ISROLLBACK,TRUE);
     }
  else
     {
       cmd.AddBoolParm(NETPARM_B_ISROLLBACK,FALSE);
     }
  
  NetSend(cmd);
}


void CNetObj::OnNetCmdReceived(const CNetCmd &cmd,unsigned src_guid)
{
  switch ( cmd.GetCmdId() )
  {
    case NETCMD_CLASSNAMENOTUPDATED_ACK:
    {
      time_to_resend_classname = GetNowOurTime() + 0.0003472222222;  // +30 sec
      break;
    }
    
    case NETCMD_REBOOT:
    case NETCMD_SHUTDOWN:
    {
      BOOL force = cmd.GetParmAsBool(NETPARM_B_FORCE);
      BOOL do_reboot = (cmd.GetCmdId()==NETCMD_REBOOT);
      DoRebootShutdown(do_reboot,force);
      break;
    }
    
    case NETCMD_SUSPEND:
    case NETCMD_HIBERNATE:
    {
      BOOL force = cmd.GetParmAsBool(NETPARM_B_FORCE);
      BOOL do_suspend = (cmd.GetCmdId()==NETCMD_SUSPEND);
      DoSuspendHibernate(do_suspend,force);
      break;
    }
    
    case NETCMD_OFFSHELL:
    case NETCMD_ONSHELL:
    {
      if ( IsShellInstalled() )
         {
           BOOL state = (cmd.GetCmdId() == NETCMD_ONSHELL);

           if ( cmd.GetParmAsBool(NETPARM_B_ALLUSERS) )
              {
                TurnShell4AllUsers(state);
              }
           else
              {
                const char *s_domain = cmd.GetParmAsString(NETPARM_S_DOMAIN,"");
                const char *s_user = cmd.GetParmAsString(NETPARM_S_USERNAME,"");
                const char *s_password = cmd.GetParmAsString(NETPARM_S_PASSWORD,"");

                if ( s_user && s_user[0] )
                   {
                     TurnShell4User(state,s_domain,s_user,s_password);
                   }
              }

           if ( SaveRollback1() )
              {
                SendDynamicInfoToServer();
              }
         }
      break;
    }

    case NETCMD_OFFAUTOLOGON:
    case NETCMD_ONAUTOLOGON:
    {
      BOOL state = (cmd.GetCmdId() == NETCMD_ONAUTOLOGON);

      if ( state )
         {
           const char *s_domain = cmd.GetParmAsString(NETPARM_S_DOMAIN,"");
           const char *s_user = cmd.GetParmAsString(NETPARM_S_USERNAME,"");
           const char *s_password = cmd.GetParmAsString(NETPARM_S_PASSWORD,"");

           if ( s_user && s_user[0] )
              {
                BOOL force = cmd.GetParmAsBool(NETPARM_B_FORCE);
                TurnAutologonOn(force,s_domain,s_user,s_password);
              }
         }
      else
         {
           TurnAutologonOff();
         }

      if ( SaveRollback1() )
         {
           SendDynamicInfoToServer();
         }

      break;
    }

    case NETCMD_SOMEINFO_REQ:
    {
      CNetCmd cmd(NETCMD_SOMEINFO_ACK);
      PrepareSomeInfo(cmd,p_cfg,p_net);
      NetSend(cmd,src_guid);
      break;
    }

    case NETCMD_TIMESYNC:
    {
      SYSTEMTIME st;
      st.wYear = cmd.GetParmAsInt(NETPARM_I_YEAR);
      st.wMonth = cmd.GetParmAsInt(NETPARM_I_MONTH);
      st.wDay = cmd.GetParmAsInt(NETPARM_I_DAY);
      st.wDayOfWeek = 0; //ignored
      st.wHour = cmd.GetParmAsInt(NETPARM_I_HOUR);
      st.wMinute = cmd.GetParmAsInt(NETPARM_I_MINUTE);
      st.wSecond = cmd.GetParmAsInt(NETPARM_I_SECOND);
      st.wMilliseconds = 0;
      if ( st.wYear && st.wMonth && st.wDay )
         {
           SetLocalTime(&st);
           SetLocalTime(&st);
         }
      break;
    }

    case NETCMD_CLIENTUPDATEPROPOSITION:
    {
      CNetCmd cmd_out(IsShellInstalled()?NETCMD_CLIENTUPDATELIST_REQ:NETCMD_CLIENTUPDATENOSHELLLIST_REQ);

      if ( p_upd->OnProposition(cmd,cmd_out) )
         {
           NetSend(cmd_out);
         }
      break;
    }

    case NETCMD_CLIENTUPDATELIST_ACK:
    case NETCMD_CLIENTUPDATENOSHELLLIST_ACK:
    {
      CNetCmd cmd_out(IsShellInstalled()?NETCMD_CLIENTUPDATEFILES_REQ:NETCMD_CLIENTUPDATENOSHELLFILES_REQ);

      if ( p_upd->OnListAck(cmd,cmd_out) )
         {
           NetSend(cmd_out);
         }
      break;
    }

    case NETCMD_CLIENTUPDATEFILES_ACK:
    case NETCMD_CLIENTUPDATENOSHELLFILES_ACK:
    {
      if ( p_upd->OnFilesAck(cmd,p_cfg,this) )
         {
         }
      break;
    }

    case NETCMD_GETENV_ACK:
    {
      if ( src_guid == NETGUID_SERVER )
         {
           if ( cmd.GetParmAsInt(NETPARM_I_GUID,NETGUID_UNKNOWN) == NETGUID_SERVER )
              {
                p_cfg->OnServerVarsReceived(cmd);
              }
         }
      break;
    }

    case NETCMD_GETSETTINGS_OK_ACK:
    {
      if ( src_guid == NETGUID_SERVER )
         {
           if ( !p_cfg->CanAccess() )
              {
                p_cfg->OnCfgReceived(cmd.GetCmdBuffPtr(),cmd.GetCmdBuffSize()); // can be NULL,0
                p_cfg->SetLastErrorI(CConfigurator::ERR_NONE);
                p_cfg->SetLastErrorS("");
              }
         }
      break;
    }

    case NETCMD_GETSETTINGS_ERR_ACK:
    {
      if ( src_guid == NETGUID_SERVER )
         {
           int rc = cmd.GetParmAsInt(NETPARM_I_RESULT,NETERR_SETTINGS_DBNOTREADY);

           if ( rc == NETERR_SETTINGS_DBNOTREADY && (machine_type == MACHINE_TYPE_OPERATOR || machine_type == MACHINE_TYPE_HOME) )
              {
                if ( !p_cfg->CanAccess() ) // to avoid infinite sending
                   {
                     NetSend(CNetCmd(NETCMD_GETSETTINGS_REQ));
                     // todo: something like delay here will be good...

                     p_cfg->SetLastErrorI(CConfigurator::ERR_DBNOTREADY);
                     p_cfg->SetLastErrorS(cmd.GetParmAsString(NETPARM_S_RESULT,""));
                   }
              }
           else
              {
                if ( !p_cfg->CanAccess() )
                   {
                     p_cfg->OnCfgReceived(NULL,0); // to speedup recv process

                     if ( rc == NETERR_SETTINGS_DBNOTREADY )
                        p_cfg->SetLastErrorI(CConfigurator::ERR_DBNOTREADY);
                     else
                     if ( rc == NETERR_SETTINGS_OUTOFLICENSE )
                        p_cfg->SetLastErrorI(CConfigurator::ERR_OUTOFLICENSE);
                     else
                        p_cfg->SetLastErrorI(CConfigurator::ERR_SERVER);

                     p_cfg->SetLastErrorS(cmd.GetParmAsString(NETPARM_S_RESULT,""));
                   }
              }
         }
      break;
    }

    case NETCMD_ROLLBACKINFO_REQ:
    {
      CNetCmd cmd(NETCMD_ROLLBACKINFO_ACK);
      PrepareRollbackInfo(cmd,p_cfg);
      NetSend(cmd,src_guid);
      break;
    }

    case NETCMD_RLBSAVE1:
    {
      if ( SaveRollback1() )
         {
           SendDynamicInfoToServer();
         }
      break;
    }

    case NETCMD_RLBSAVE2:
    {
      CRollback rlb;

      int st_rlb = -1;
      if ( rlb.GetRollbackStatus(st_rlb) )
         {
           if ( st_rlb == CRollback::ST_RLB_ON_ON || st_rlb == CRollback::ST_RLB_ON_ON_SAVE )
              {
                rlb.RollbackDeactivate(TRUE);
                SendDynamicInfoToServer();
              }
         }
      break;
    }

    case NETCMD_CLIENTUNINSTALL:
    {
      if ( !IsShellInstalled() )
         {
           BOOL b_restart = cmd.GetParmAsBool(NETPARM_B_IMMEDIATELY);
           BOOL b_force = cmd.GetParmAsBool(NETPARM_B_FORCE);
           
           char s[MAX_PATH] = "";
           GetFileNameInTempDir("rshell_svc_tmp.exe",s);
           if ( !IsStrEmpty(s) && StrStr(s,"\\") )
              {
                char src[MAX_PATH] = "";
                GetModuleFileName(GetModuleHandle(NULL),src,sizeof(src));
                if ( CopyFile(src,s,FALSE) )
                   {
                     char src[MAX_PATH] = "";
                     GetFileNameInLocalAppDir("rp_shared.dll",src);
                     char s2[MAX_PATH] = "";
                     GetFileNameInTempDir("rp_shared.dll",s2);
                     if ( CopyFile(src,s2,FALSE) )
                        {
                          char cmdline[MAX_PATH];
                          sprintf(cmdline,"\"%s\" {94F74927-976F-4743-911D-900EA71441D8}",s);

                          if ( b_restart )
                             {
                               lstrcat(cmdline," -restart");
                               if ( b_force )
                                  {
                                    lstrcat(cmdline," -force");
                                  }
                             }
                          
                          if ( RunProcessWithShowWindow(cmdline,SW_HIDE) )
                             {
                               // nothing to do...
                             }
                        }
                   }
              }
         }
      break;
    }


  };
}


// fired only once!
// here we can full access to p_cfg object
// config and licinfo was received either from server or read from cache/default
void CNetObj::OnCfgReceived()
{
  assert(p_cfg->CanAccess());

  // we don't do anything if settings is default
  if ( p_cfg->GetState() == CConfigurator::STATE_FROMCACHE || p_cfg->GetState() == CConfigurator::STATE_FROMSERVER )
     {
       // process rollback
       std::string lic_comments;
       BOOL b_lic = IsRollbackAllowedFromLic(p_cfg->GetLicFeat(),lic_comments);
       BOOL b_cfg = p_cfg->GetCfgVar<BOOL>(use_rollback);
       BOOL b_another_rollback = p_cfg->GetCfgVar<BOOL>(used_another_rollback);

       {
         CRollback rlb;

         int st_drv = -1;
         int st_rlb = -1;

         if ( rlb.GetDriverStatus(st_drv) && rlb.GetRollbackStatus(st_rlb) )
            {
              if ( !b_another_rollback )
                 {
                   if ( !b_lic || !b_cfg )
                      {
                        // we must turn off rollback and driver
                        if ( st_rlb == CRollback::ST_RLB_OFF_OFF || st_rlb == CRollback::ST_RLB_NODRIVER )
                           {
                             if ( st_drv == CRollback::ST_DRV_ON_ON || st_drv == CRollback::ST_DRV_OFF_ON )
                                {
                                  rlb.UninstallDriver();
                                  SendDynamicInfoToServer();
                                }
                           }
                        else
                        if ( st_rlb == CRollback::ST_RLB_ON_ON || st_rlb == CRollback::ST_RLB_ON_ON_SAVE )
                           {
                             rlb.RollbackDeactivate(TRUE);
                             SendDynamicInfoToServer();
                           }
                      }
                   else
                      {
                        // we must turn on rollback and driver
                        if ( st_drv == CRollback::ST_DRV_OFF_OFF || st_drv == CRollback::ST_DRV_ON_OFF )
                           {
                             rlb.InstallDriver();
                             SendDynamicInfoToServer();
                           }
                        else
                        if ( st_drv == CRollback::ST_DRV_ON_ON )
                           {
                             if ( st_rlb == CRollback::ST_RLB_OFF_OFF )
                                {
                                  SetRollbackParmsInternal(p_cfg->GetCfgVar<int>(rollback_disks),p_cfg->GetCfgVar<TCFGLIST1>(rollback_excl));
                                  rlb.RollbackActivate();
                                  SendDynamicInfoToServer();
                                }
                             else
                             if ( st_rlb == CRollback::ST_RLB_OFF_ON || st_rlb == CRollback::ST_RLB_ON_ON_SAVE )
                                {
                                  SetRollbackParmsInternal(p_cfg->GetCfgVar<int>(rollback_disks),p_cfg->GetCfgVar<TCFGLIST1>(rollback_excl));
                                }
                           }
                      }
                 }
            }
       }
     }
  else
     {
       // default settings, we do nothing
     }
}



void CNetObj::SetRollbackParmsInternal(int disks,const TCFGLIST1& exlist)
{
  CRollback::TStringList list;

  // add paths from list
  for ( TCFGLIST1::const_iterator it = exlist.begin(); it != exlist.end(); ++it )
      {
        const CCfgEntry1 &i = *it;

        if ( i.IsActive() )
           {
             const char *_path = i.GetParm();

             if ( !IsStrEmpty(_path) )
                {
                  char path[MAX_PATH] = "";
                  lstrcpyn(path,CPathExpander(_path),sizeof(path)-1);

                  if ( !IsStrEmpty(path) )
                     {
                       CDisableWOW64FSRedirection oWOW64guard; // for 64-bit systems

                       PathAddBackslash(path);
                       SHCreateDirectoryEx(NULL,path,NULL);

                       list.push_back(std::string(path));
                     }
                }
           }
      }

  // add our internal path
  {
    char path[MAX_PATH] = "";
    GetGlobalCommonPath("",path);

    if ( !IsStrEmpty(path) )
       {
         PathAddBackslash(path);
         SHCreateDirectoryEx(NULL,path,NULL);

         list.push_back(std::string(path));
       }
  }

  CRollback().SetExcludePaths(list,FALSE);
  CRollback().SetDisks(disks);
}



