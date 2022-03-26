

static CNetClient *g_net = NULL;
static HANDLE g_ev_connect = NULL;
static OURTIME time_to_resend_classname = 0;



void NetInit()
{
  if ( !g_net )
     {
       g_ev_connect = CreateEvent(NULL,FALSE,FALSE,NULL);
       g_net = new CNetClient(HKLM,REGPATH,"server_ip",NETPORT,g_ev_connect,NULL);
     }
}


void NetDone()
{
  if ( g_net )
     {
       delete g_net;
       g_net = NULL;

       if ( g_ev_connect )
          CloseHandle(g_ev_connect);
       g_ev_connect = NULL;
     }
}


int NetGetLastWinsockErrorNonRepresentative()
{
  return g_net ? g_net->GetLastWinsockErrorNonRepresentative() : 0;
}


int NetGetServerIP()
{
  return g_net ? g_net->GetServerIP() : 0;
}


BOOL IsNetConnectEvent()
{
  BOOL rc = FALSE;
  
  if ( g_ev_connect )
     {
       if ( WaitForSingleObject(g_ev_connect,0) == WAIT_OBJECT_0 )
          {
            rc = TRUE;
          }
     }

  return rc;
}


BOOL NetIsConnected()
{
  return g_net ? g_net->IsConnected() : FALSE;
}


BOOL NetSend(const CNetCmd& cmd,unsigned dest_guid)
{
  return g_net ? g_net->Push(cmd,dest_guid) : FALSE;
}


BOOL NetGet(CNetCmd& cmd,unsigned *_src_guid)
{
  return g_net ? g_net->Pop(cmd,_src_guid) : FALSE;
}


BOOL NetFlush(unsigned timeout)
{
  return g_net ? g_net->Flush(timeout) : TRUE;
}


BOOL NetSendFile(const char *file,int cmd_id,unsigned dest_guid,BOOL b_delete)
{
  BOOL rc = FALSE;
  
  int size = 0;
  void *buff = ReadFullFile(file,&size);
  if ( buff )
     {
       CNetCmd ack(cmd_id);
       ack.AddBuff(buff,size);
       rc = NetSend(ack,dest_guid);
       sys_free(buff);
     }

  if ( b_delete && rc )
     {
       sys_deletefile(file);
     }

  return rc;
}


BOOL NetSendStream(IStream *stream,int cmd_id,unsigned dest_guid)
{
  BOOL rc = FALSE;

  if ( !stream )
     return rc;
  
  HGLOBAL g = NULL;

  if ( GetHGlobalFromStream(stream,&g) == S_OK && g )
     {
       unsigned size = GlobalSize(g);

       if ( size > 0 )
          {
            void *buff = GlobalLock(g);

            if ( buff )
               {
                 CNetCmd ack(cmd_id);
                 ack.AddBuff(buff,size);
                 rc = NetSend(ack,dest_guid);

                 GlobalUnlock(g);
               }
          }
     }

  return rc;
}


BOOL NetSendResource(int res_id,int cmd_id,unsigned dest_guid)
{
  BOOL rc = FALSE;
  
  int size = 0;
  void *buff = LoadRawResource(res_id,&size);
  if ( buff && size > 0 )
     {
       CNetCmd ack(cmd_id);
       ack.AddBuff(buff,size);
       rc = NetSend(ack,dest_guid);
     }

  return rc;
}


static void PollServerInternal(BOOL got_packet,int packet_value)
{
  static unsigned last_poll_time = 0;
  static unsigned last_ack_time = 0;

  if ( got_packet )
     {
       last_ack_time = GetTickCount();
       sql_base_ready = (packet_value == 1);
     }
  else
     {
       if ( GetTickCount() - last_poll_time > 20000 )
          {
            if ( NetIsConnected() ) //optimization
               NetSend(CNetCmd(NETCMD_SQLTEST_REQ));
            last_poll_time = GetTickCount();
          }

       if ( GetTickCount() - last_ack_time > 60000 )
          {
            sql_base_ready = FALSE;
          }
     }
}


void PollServer(void)
{
  PollServerInternal(FALSE,0);
}


static void OnSQLTestAck(const CNetCmd &cmd,unsigned src_guid)
{
  const char *p = cmd.GetCmdBuffPtr();
  int value = p ? *p : 0;
  PollServerInternal(TRUE,value);
}


void AddServiceString2SQLBase(int s_id,int s_count,int s_size,int s_time,const char *s_comments)
{
  if ( !IsLicenseWithMO() )
     {
       s_count = 0;
       s_size = 0;
       s_time = 0;
       s_comments = STR_002;
     }

  CNetCmd cmd(NETCMD_ADDSERVICESTR2BASE);
  cmd.AddIntParm(NETPARM_I_ID,s_id);
  cmd.AddIntParm(NETPARM_I_COUNT,s_count);
  cmd.AddIntParm(NETPARM_I_SIZE,s_size);
  cmd.AddIntParm(NETPARM_I_TIME,s_time);
  cmd.AddStringParm(NETPARM_S_COMMENTS,s_comments);
  NetSend(cmd);
}


void AddEventString2SQLBaseInternal(int s_level,const char *s_comments)
{
  CNetCmd cmd(NETCMD_ADDEVENTSTR2BASE);
  cmd.AddIntParm(NETPARM_I_LEVEL,s_level);
  cmd.AddStringParm(NETPARM_S_COMMENTS,s_comments);
  NetSend(cmd);
}


void SendMessageToOperator(const char *msg,BOOL to_all)
{
  char s[MAX_PATH];
  CNetCmd cmd(NETCMD_CALLOPERATOR_REQ);
  cmd.AddStringParm(NETPARM_S_MACHINELOC,machine_loc);
  cmd.AddStringParm(NETPARM_S_MACHINEDESC,machine_desc);
  cmd.AddStringParm(NETPARM_S_DOMAIN,GetDomainName(s));
  cmd.AddStringParm(NETPARM_S_USERNAME,MyGetUserName(s));
  cmd.AddStringParm(NETPARM_S_TEXT,msg);
  NetSend(cmd,to_all ? NETGUID_ALL_OPERATORS_WITHOUTME : NETGUID_FIRST_OPERATOR);
}


static void UpdateActiveTaskString(void)
{
  static unsigned last_update_time = 0;
  static char last_string[MAX_PATH] = "";

  if ( GetTickCount() - last_update_time > 4000 )
     {
       char s[MAX_PATH];
       
       s[0] = 0;
       GetActiveTaskString(s);

       if ( lstrcmpi(s,last_string) )
          {
            if ( NetIsConnected() ) //optimization
               SendDynamicInfoToServer();
            lstrcpy(last_string,s);
          }

       last_update_time = GetTickCount();
     }
}


void SendDynamicInfoToServer()
{
  char s[MAX_PATH];
  CNetCmd cmd(NETCMD_UPDATESELFENV);

  cmd.AddBoolParm(NETPARM_B_MONITORSTATE,!monitor_off);
  cmd.AddBoolParm(NETPARM_B_BLOCKEDSTATE,protect_run_from_api);
  cmd.AddStringParm(NETPARM_S_ACTIVETASK,GetActiveTaskString(s));
  cmd.AddStringParm(NETPARM_S_VIPSESSION,vip_session);
  cmd.AddIntParm(NETPARM_I_LANGID,curr_lang); //must be in static and dynamic info!

  NetSend(cmd);
}


void SendStaticInfoToServer()
{
  char s[MAX_PATH];
  CNetCmd cmd(NETCMD_UPDATESELFENV);

  cmd.AddStringParm(NETPARM_S_CLASS,NETCLASS_USER); //we are user
  cmd.AddBoolParm(NETPARM_B_ISOPERATORSHELL,(machine_type == MACHINE_TYPE_OPERATOR));
  cmd.AddStringParm(NETPARM_S_MACHINELOC,machine_loc);
  cmd.AddStringParm(NETPARM_S_MACHINEDESC,machine_desc);
  cmd.AddStringParm(NETPARM_S_COMPNAME,MyGetComputerName(s));
  cmd.AddStringParm(NETPARM_S_DOMAIN,GetDomainName(s));
  cmd.AddStringParm(NETPARM_S_USERNAME,MyGetUserName(s));
  cmd.AddIntParm(NETPARM_I_LANGID,curr_lang); //must be in static and dynamic info!
  
  NetSend(cmd);
}


static void OnNetCmdReceived(const CNetCmd &cmd,unsigned src_guid)
{
  switch ( cmd.GetCmdId() )
  {
    case NETCMD_CLASSNAMENOTUPDATED_ACK:
    {
      time_to_resend_classname = GetNowOurTime() + 0.0003472222222;  // +30 sec
      break;
    }
    
    case NETCMD_LOGOFF:
    {
      BOOL force = cmd.GetParmAsBool(NETPARM_B_FORCE);
      if ( force )
         {
           GlobalDoneWithoutApiDone(EL_LOGOFF);
           InternalLogOff(TRUE);
           ApiDone();
           ApiExit(1);
         }
      else
         {
           InternalLogOff(FALSE);
         }
      break;
    }

    case NETCMD_OFFSHELL:
    {
      BOOL all_users = cmd.GetParmAsBool(NETPARM_B_ALLUSERS);
      if ( !all_users )
         {
           if ( IsOurShellTurnedOnForCurrentUser() )
              {
                TurnShellOffForCurrentUser();
                InternalLogOff(FALSE);
              }
         }
      break;
    }

    case NETCMD_TEMPOFFSHELL:
    {
      FE_DoFastExit(TRUE,TRUE);
      break;
    }

    case NETCMD_KILLALLTASKS:
    {
      KillAllTasks();
      CloseActiveSheet(TRUE);
      break;
    }

    case NETCMD_VMODERESTORE:
    {
      if ( !IsFullScreenAppFind() )
         {
           RestoreDisplayMode();
         }
      break;
    }

    case NETCMD_BLOCKMACHINE:
    {
      //if ( machine_type != MACHINE_TYPE_OPERATOR && machine_type != MACHINE_TYPE_HOME )  checks in operator program!
         {
           OnBlockAction();
         }
      break;
    }
 
    case NETCMD_UNBLOCKMACHINE:
    {
      OnUnblockAction();
      break;
    }
 
    case NETCMD_MONITOROFF:
    {
      //if ( machine_type != MACHINE_TYPE_OPERATOR && machine_type != MACHINE_TYPE_HOME )  checks in operator program!
         {
           TurnOffMonitor(disable_input_when_monitor_off,0);
           SendDynamicInfoToServer();
         }
      break;
    }

    case NETCMD_MONITORON:
    {
      TurnOnMonitor();
      SendDynamicInfoToServer();
      break;
    }

    case NETCMD_TEXTMESSAGE:
    {
      int delay = cmd.GetParmAsInt(NETPARM_I_DELAY);
      if ( delay <= 0 )
         delay = 5;  //for backward compatibility

      const char *text = cmd.GetParmAsString(NETPARM_S_TEXT);
      if ( text && text[0] )   
         {
           TextMessageBox(text,TRUE,delay);
         }
      break;
    }
 
    case NETCMD_LICMAN_REQ:
    {
      OnLicManReq(cmd,src_guid);
      break;
    }

    case NETCMD_LICMAN_ACK:
    {
      OnLicManAck(cmd,src_guid);
      break;
    }

    case NETCMD_FLOATLIC2SERVER_ACK:
    {
      CFloatLic::OnServerAck(cmd);
      break;
    }

    case NETCMD_FLOATLIC2CLIENT_REQ:
    {
      CFloatLic::OnClientReq(cmd,src_guid);
      break;
    }

    case NETCMD_FLOATLIC2CLIENT_ACK:
    {
      CFloatLic::OnClientAck(cmd);
      break;
    }

    case NETCMD_BODYVIP_ACK:
    {
      OnBodyVipAck(cmd,src_guid);
      break;
    }

    case NETCMD_SCREEN_REQ:
    case NETCMD_SCREENCONTROL_REQ:
    {
      IStream *s = SaveScreenToStream();
      if ( s )
         {
           int cmd_id = ((cmd.GetCmdId() == NETCMD_SCREEN_REQ) ? NETCMD_SCREEN_ACK : NETCMD_SCREENCONTROL_ACK);
           NetSendStream(s,cmd_id,src_guid);
           s->Release();
         }
      break;
    }

    case NETCMD_VIDEOCONTROLFINISH:
    {
      DisconnectWebCam();
      break;
    }
 
    case NETCMD_WEBCAM_REQ:
    {
      IStream *s = GrabSingleWebCam();
      if ( s )
         {
           NetSendStream(s,NETCMD_WEBCAM_ACK,src_guid);
           s->Release();
         }
      else
         {
           NetSendResource(IDT_WCBLACK,NETCMD_WEBCAM_ACK,src_guid);
         }
      break;
    }

    case NETCMD_VIDEOCONTROL_REQ:
    {
      IStream *s = GrabSeqWebCam();
      if ( s )
         {
           NetSendStream(s,NETCMD_VIDEOCONTROL_ACK,src_guid);
           s->Release();
         }
      break;
    }

    case NETCMD_EXECSTAT_REQ:
    {
      char file[MAX_PATH];
      GetFileNameInTempDir("rs_stat.stat",file);
      sys_deletefile(file);
      SaveStatToFile(file);
      NetSendFile(file,NETCMD_EXECSTAT_ACK,src_guid,TRUE);
      break;
    }

    case NETCMD_EXECSTATCLEAR:
    {
      DeleteAllStat();
      break;
    }

    case NETCMD_SQLTEST_ACK:
    {
      OnSQLTestAck(cmd,src_guid);
      break;
    }

    case NETCMD_NETRUN:
    {
      NetRun(cmd);
      break;
    }

    case NETCMD_COPYFILES:
    {
      NetCopyFiles(cmd);
      break;
    }

    case NETCMD_DELETEFILES:
    {
      NetDeleteFolders(cmd);
      break;
    }

    case NETCMD_CALLOPERATOR_ACK:
    case NETCMD_NETBURN_ACK:
    case NETCMD_NETBT_ACK:
    {
      MsgBoxTray(LS(3027));
      break;
    }

    case NETCMD_SOMEINFO_REQ:
    {
      CNetCmd cmd(NETCMD_SOMEINFO_ACK);
      PrepareSomeInfo(cmd);
      NetSend(cmd,src_guid);
      break;
    }


  };
}


void NetUpdate()
{
  static CNetCmd cmd; //we do not need reallocations!
  
  if ( IsNetConnectEvent() )
     {
       SendStaticInfoToServer();
       SendDynamicInfoToServer();
     }

  //if ( NetIsConnected() ) checks inside this functions
     {
       PollServer();
       UpdateActiveTaskString();
     }

  if ( NetIsConnected() )
     {
       if ( time_to_resend_classname > 0 && GetNowOurTime() >= time_to_resend_classname )
          {
            SendStaticInfoToServer();
            time_to_resend_classname = 0;
          }
     }
     
  for ( int count = 0; count < 5; count++ )
      {
        unsigned src_guid = NETGUID_UNKNOWN;
        if ( !NetGet(cmd,&src_guid) )
           break;

        if ( cmd.IsValid() && src_guid != NETGUID_UNKNOWN )
           {
             OnNetCmdReceived(cmd,src_guid);
           }

        cmd.Clear();
        cmd.Compact(8192); //optimization
      }
}
