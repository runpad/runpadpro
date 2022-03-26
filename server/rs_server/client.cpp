
#include "include.h"



CClient::CRecvBuff::CRecvBuff()
{
  ClearVars();
}

CClient::CRecvBuff::~CRecvBuff()
{
  Free();
}

void CClient::CRecvBuff::ClearVars()
{
  ZeroMemory(static_buff,sizeof(static_buff));
  dynamic_buff = NULL;
  dynamic_len = 0;
  recv_bytes = 0;
}

void CClient::CRecvBuff::Free()
{
  if ( dynamic_buff )
     sys_free(dynamic_buff);
  ClearVars();
}



CClient::CPacket2Send::CPacket2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned _guid)
{
  src_guid = _guid;

  p_cmd = new CNetCmd(cmd_id);
  if ( data_buff && data_size )
     {
       p_cmd->AddBuff(data_buff,data_size);
     }
}

CClient::CPacket2Send::~CPacket2Send()
{
  delete p_cmd;
}

unsigned CClient::CPacket2Send::GetSrcGuid() const
{
  return src_guid;
}

const CNetCmd* CClient::CPacket2Send::GetCmd() const
{
  return p_cmd;
}




CClient::CClient(CServer *_server,CDBObj *_db,int _socket,int _ip,unsigned _guid)
{
  InitializeCriticalSection(&o_cs);

  p_server = _server;
  p_db = _db;
  h_socket = _socket;
  m_ip = _ip;
  m_guid = _guid;

  int v = 3000;
  setsockopt(h_socket,SOL_SOCKET,SO_SNDTIMEO,(const char *)&v,sizeof(v));

  p_env = new CNetCmd(NETCMD_GETENV_ACK);
  p_env->AddIntParm(NETPARM_I_GUID,_guid);
  IN_ADDR addr; addr.S_un.S_addr = _ip;
  p_env->AddStringParm(NETPARM_S_IP,inet_ntoa(addr));

  h_stop_event = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = CreateThread(NULL,0,ThreadProcWrapper,this,0,NULL);
}


CClient::~CClient()
{
  //SetEvent(h_stop_event);  //AsyncTerminate() must be called first
  if ( WaitForSingleObject(h_thread,0) == WAIT_TIMEOUT )
     TerminateThread(h_thread,0);
  CloseHandle(h_thread);
  h_thread = NULL;

  CloseHandle(h_stop_event);

  if ( h_socket != INVALID_SOCKET )
     {
       shutdown(h_socket,SD_BOTH);
       closesocket(h_socket);
       h_socket = INVALID_SOCKET;
     }

  CleanupSendQueue();

  delete p_env;

  DeleteCriticalSection(&o_cs);
}


void CClient::AsyncTerminate()
{
  CCSGuard g(o_cs);
  SetEvent(h_stop_event);
}


BOOL CClient::IsServer() const
{
  return FALSE;
}


BOOL CClient::IsUser() const
{
  CCSGuard g(o_cs);
  return !lstrcmpi(p_env->GetParmAsString(NETPARM_S_CLASS,""),NETCLASS_USER);
}


BOOL CClient::IsComputer() const
{
  CCSGuard g(o_cs);
  return !lstrcmpi(p_env->GetParmAsString(NETPARM_S_CLASS,""),NETCLASS_COMPUTER);
}


BOOL CClient::IsOperator() const
{
  CCSGuard g(o_cs);
  return !lstrcmpi(p_env->GetParmAsString(NETPARM_S_CLASS,""),NETCLASS_OPERATOR);
}


BOOL CClient::IsClassKnown() const
{
  CCSGuard g(o_cs);
  const char *s = p_env->GetParmAsString(NETPARM_S_CLASS,"");
  return !lstrcmpi(s,NETCLASS_USER) || !lstrcmpi(s,NETCLASS_COMPUTER) || !lstrcmpi(s,NETCLASS_OPERATOR);
}


unsigned CClient::GetGUID() const
{
  return m_guid;
}


BOOL CClient::IsActive() const
{
  CCSGuard g(o_cs);
  return WaitForSingleObject(h_thread,0) == WAIT_TIMEOUT;
}


void CClient::GetCopyOfEnv(CNetCmd &env) const
{
  CCSGuard g(o_cs);
  env = *p_env;
}


BOOL CClient::Push(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid)
{
  BOOL rc = FALSE;
  
  if ( IsActive() && IsClassKnown() )
     {
       rc = Push2Send(cmd_id,data_buff,data_size,src_guid);
     }

  return rc;
}


BOOL CClient::Push2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid)
{
  CCSGuard g(o_cs);

  BOOL rc = FALSE;

  if ( send_queue.size() < max_queue_packets )
     {
       CPacket2Send *p = new CPacket2Send(cmd_id,data_buff,data_size,src_guid);
       send_queue.push_back(p);
       rc = TRUE;
     }

  return rc;
}


BOOL CClient::Push2Send(const CNetCmd &cmd,unsigned src_guid)
{
  return Push2Send(cmd.GetCmdId(),cmd.GetCmdBuffPtr(),cmd.GetCmdBuffSize(),src_guid);
}


DWORD WINAPI CClient::ThreadProcWrapper(LPVOID lpParameter)
{
  CClient *obj = (CClient*)lpParameter;
  return obj->ThreadProc();
}


DWORD CClient::ThreadProc()
{
  unsigned last_recv_time = GetTickCount();
  
  do {

   BOOL recv_err = FALSE;
   TryRecv(&recv_err,last_recv_time);
   if ( recv_err )
      break;

   BOOL send_err = FALSE;
   TrySend(&send_err);
   if ( send_err )
      break;

   if ( WaitForSingleObject(h_stop_event,0) == WAIT_OBJECT_0 )
      break;

   if ( GetTickCount() - last_recv_time > 60*1000 )
      break;

   Sleep(50);

  } while (1);

  shutdown(h_socket,SD_BOTH);

  return 1;
}


void CClient::TryRecv(BOOL *_err,unsigned &last_recv_time)
{
  BOOL rc = TRUE;

  unsigned recv_packets = 0;
  
  do {

   timeval tv;
   tv.tv_sec = 0;
   tv.tv_usec = 0;
   
   fd_set rset;
   rset.fd_count = 1;
   rset.fd_array[0] = h_socket;
   
   int count = select(0,&rset,NULL,NULL,&tv);
   if ( count == SOCKET_ERROR )
      {
        rc = FALSE;
        break;
      }

   if ( count == 0 )
      break;

   CRecvBuff &rb = recv_buff;
   
   if ( rb.recv_bytes < sizeof(rb.static_buff) )
      {
        // we on static buffer (id,len retrieval)
        
        char *dest_buff = rb.static_buff + rb.recv_bytes;
        unsigned dest_size = sizeof(rb.static_buff) - rb.recv_bytes;
        
        int recv_bytes = recv(h_socket,dest_buff,dest_size,0);
        if ( recv_bytes <= 0 )
           {
             rc = FALSE;
             break;
           }

        rb.recv_bytes += recv_bytes;

        if ( rb.recv_bytes >= sizeof(int) )
           {
             int id = ((int*)rb.static_buff)[0];
             if ( id != MAGIC_ID )
                {
                  rc = FALSE;
                  break;
                }
           }

        if ( rb.recv_bytes == sizeof(rb.static_buff) )
           {
             unsigned len = ((unsigned*)rb.static_buff)[1];

             if ( len == 0 )
                {
                  //NULL packet
                  rc = FALSE;
                  break;
                }
             else
                {
                  if ( len > max_packet_size )
                     {
                       rc = FALSE;
                       break;
                     }
                  
                  assert(!rb.dynamic_buff);
                  rb.dynamic_len = len;
                  rb.dynamic_buff = (char*)sys_alloc(len);

                  if ( !rb.dynamic_buff )
                     {
                       rc = FALSE;
                       break;
                     }
                }
           }
        else
        if ( rb.recv_bytes > sizeof(rb.static_buff) )
           {
             assert(FALSE);
           }
      }
   else
      {
        // we on dynamic buffer (data retrieval)
        assert(rb.dynamic_buff);
        assert(rb.dynamic_len);
        assert(rb.recv_bytes < sizeof(rb.static_buff) + rb.dynamic_len);

        char *dest_buff = rb.dynamic_buff + rb.recv_bytes - sizeof(rb.static_buff);
        unsigned dest_size = sizeof(rb.static_buff) + rb.dynamic_len - rb.recv_bytes;

        int recv_bytes = recv(h_socket,dest_buff,dest_size,0);
        if ( recv_bytes <= 0 )
           {
             rc = FALSE;
             break;
           }

        rb.recv_bytes += recv_bytes;

        if ( rb.recv_bytes == sizeof(rb.static_buff) + rb.dynamic_len )
           {
             //got packet
             if ( rb.dynamic_len < sizeof(unsigned) + sizeof(unsigned) )
                {
                  rc = FALSE;
                  break;
                }
             else
                {
                  unsigned dest_guid = ((const unsigned*)rb.dynamic_buff)[0];
                  unsigned cmd_id = ((const unsigned*)rb.dynamic_buff)[1];
                  unsigned data_size = rb.dynamic_len - (sizeof(unsigned) + sizeof(unsigned));
                  const void *data_buff = data_size ? (const unsigned*)rb.dynamic_buff + 2 : NULL;

                  ProcessCommand(cmd_id,data_buff,data_size,dest_guid);

                  last_recv_time = GetTickCount(); //assume that ProcessCommand is momental :)

                  recv_packets++;

                  rb.Free();
                }
           }
        else
        if ( rb.recv_bytes > sizeof(rb.static_buff) + rb.dynamic_len )
           {
             assert(FALSE);
           }
      }

  } while ( recv_packets < 5 );

  if ( !rc )
     {
       recv_buff.Free();
     }

  if ( _err )
     {
       *_err = !rc;
     }
}


void CClient::TrySend(BOOL *_err)
{
  BOOL rc = TRUE;

  unsigned sent_packets = 0;
  
  do {

    CPacket2Send *packet = NULL;
    {
      CCSGuard oGuard(o_cs);

      if ( send_queue.size() == 0 )
         break;
      packet = send_queue[0];
    }

    unsigned guid = packet->GetSrcGuid();
    const CNetCmd *p_cmd = packet->GetCmd();
    int cmd_id = p_cmd->GetCmdId();
    const char *buff = (const char*)p_cmd->GetCmdBuffPtr();
    unsigned len = p_cmd->GetCmdBuffSize();
    int packet_id = MAGIC_ID;
    unsigned total_len = sizeof(guid) + sizeof(cmd_id) + len;

    BOOL err = FALSE;
    err = err ? err : (send(h_socket,(const char*)&packet_id,sizeof(packet_id),0) != sizeof(packet_id));
    err = err ? err : (send(h_socket,(const char*)&total_len,sizeof(total_len),0) != sizeof(total_len));
    err = err ? err : (send(h_socket,(const char*)&guid,sizeof(guid),0) != sizeof(guid));
    err = err ? err : (send(h_socket,(const char*)&cmd_id,sizeof(cmd_id),0) != sizeof(cmd_id));

    if ( buff && len )
       {
         const char *p = buff;

         while ( len > 0 )
         {
           static const int MAXPACKET = 17520;
           unsigned sendsize = (len > MAXPACKET ? MAXPACKET : len);
           
           err = err ? err : (send(h_socket,p,sendsize,0) != sendsize);
           p += sendsize;
           len -= sendsize;
         };
       }

    if ( err )
       {
         rc = FALSE;
         break;
       }
    else
       {
         CCSGuard oGuard(o_cs);

         assert(send_queue.size()>0);
         delete packet;
         send_queue.erase(send_queue.begin());
         sent_packets++;
       }

  } while ( sent_packets < 5 );

  if ( _err )
     {
       *_err = !rc;
     }
}


void CClient::CleanupSendQueue()
{
  //CCSGuard g(o_cs);  not needed in destructor

  do {

   TPackets::iterator it = send_queue.begin();
   if ( it == send_queue.end() )
      break;

   delete *it;
   send_queue.erase(it);

  } while (1);
}


void CClient::ProcessCommand(int cmd_id,const void *data_buff,unsigned data_size,unsigned dest_guid)
{
  switch ( dest_guid )
  {
    case NETGUID_UNKNOWN:
    {
      break;
    }

    case NETGUID_LOOPBACK:
    {
      Push2Send(cmd_id,data_buff,data_size,m_guid);
      break;
    }

    case NETGUID_ALL_WITHME:
    case NETGUID_ALL_WITHOUTME:
    case NETGUID_ALL_OPERATORS_WITHME:
    case NETGUID_ALL_OPERATORS_WITHOUTME:
    case NETGUID_ALL_COMPUTERS_WITHME:
    case NETGUID_ALL_COMPUTERS_WITHOUTME:
    case NETGUID_ALL_USERS_WITHME:
    case NETGUID_ALL_USERS_WITHOUTME:
    case NETGUID_FIRST_OPERATOR:
    {
      if ( IsClassKnown() )
         {
           p_server->Push2Send(cmd_id,data_buff,data_size,m_guid,dest_guid);
         }
      break;
    }

    case NETGUID_SERVER:
    {
      ProcessServerCommand(cmd_id,data_buff,data_size);
      break;
    }

    default:
    {
      if ( dest_guid >= NETGUID_FIRST && dest_guid <= NETGUID_LAST )
         {
           if ( IsClassKnown() )
              {
                p_server->Push2Send(cmd_id,data_buff,data_size,m_guid,dest_guid);
              }
         }
      break;
    }
  };
}


void CClient::ProcessServerCommand(int cmd_id,const void *data_buff,unsigned data_size)
{
  CNetCmd req(cmd_id);
  if ( data_buff && data_size )
     {
       req.AddBuff(data_buff,data_size);
     }
  
  switch ( cmd_id )
  {
    case NETCMD_BODYVIP_REQ:
    {
      if ( IsClassKnown() )
         {
           int i_id = req.GetParmAsInt(NETPARM_I_ID,0); //unique req id
           BOOL is_register = req.GetParmAsBool(NETPARM_B_NEWUSER);
           const char *s_login = req.GetParmAsString(NETPARM_S_USERNAME,"");
           const char *s_pass = req.GetParmAsString(NETPARM_S_PASSWORD,"");

           BOOL rc = FALSE;
           
           char login_ack[MAX_PATH] = ""; // used when login by pwd
           const char *out_login = s_login;
           
           if ( is_register )
              {
                rc = p_db->VipRegister(s_login,s_pass);
              }
           else
              {
                if ( !IsStrEmpty(s_login) )
                   {
                     rc = p_db->VipLogin(s_login,s_pass);
                   }
                else
                   {
                     rc = p_db->VipLoginByPwd(s_pass,login_ack);
                     out_login = login_ack;
                   }
              }

           CNetCmd ack(NETCMD_BODYVIP_ACK);
           ack.AddIntParm(NETPARM_I_ID,i_id);
           ack.AddBoolParm(NETPARM_B_NEWUSER,is_register);
           ack.AddStringParm(NETPARM_S_USERNAME,out_login);

           int code;

           if ( rc )
              {
                code = NETERR_VIP_NOERROR;
              }
           else
              {
                code = is_register ? NETERR_VIP_UNKNOWN : NETERR_VIP_WRONGLOGIN;
              }
                 
           ack.AddIntParm(NETPARM_I_RESULT,code);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_SQLTEST_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_SQLTEST_ACK);
           ack.AddChar(p_db->IsConnected()?1:0);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_WOL:
    {
      if ( IsClassKnown() )
         {
           const char *s_ip = req.GetParmAsString(NETPARM_S_IP);
           const char *s_mac = req.GetParmAsString(NETPARM_S_MAC);

           WakeupOnLAN(s_ip,s_mac);
         }
      break;
    }

    case NETCMD_ADDSERVICESTR2BASE:
    case NETCMD_ADDEVENTSTR2BASE:
    case NETCMD_ADDUSERRESPONSE2BASE:
    {
      if ( IsClassKnown() )
         {
           const char* s_computerloc = p_env->GetParmAsString(NETPARM_S_MACHINELOC);
           const char* s_computerdesc = p_env->GetParmAsString(NETPARM_S_MACHINEDESC);
           const char* s_computername = p_env->GetParmAsString(NETPARM_S_COMPNAME);
           const char* s_ip = p_env->GetParmAsString(NETPARM_S_IP);
           const char* s_userdomain = p_env->GetParmAsString(NETPARM_S_DOMAIN);
           const char* s_username = p_env->GetParmAsString(NETPARM_S_USERNAME);
           const char* s_vipname = p_env->GetParmAsString(NETPARM_S_VIPSESSION);

           if ( cmd_id == NETCMD_ADDSERVICESTR2BASE )
              {
                int s_id = req.GetParmAsInt(NETPARM_I_ID);
                int s_count = req.GetParmAsInt(NETPARM_I_COUNT);
                int s_size = req.GetParmAsInt(NETPARM_I_SIZE);
                int s_time = req.GetParmAsInt(NETPARM_I_TIME);
                const char *s_comments = req.GetParmAsString(NETPARM_S_COMMENTS);

                p_db->AddServiceString(s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_vipname,s_id,s_count,s_size,s_time,s_comments);
              }
           else
           if ( cmd_id == NETCMD_ADDEVENTSTR2BASE )
              {
                int s_level = req.GetParmAsInt(NETPARM_I_LEVEL);
                const char *s_comments = req.GetParmAsString(NETPARM_S_COMMENTS);

                p_db->AddEventString(s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_vipname,s_level,s_comments);
              }
           else
           if ( cmd_id == NETCMD_ADDUSERRESPONSE2BASE )
              {
                const char *s_kind = req.GetParmAsString(NETPARM_S_KIND);
                const char *s_title = req.GetParmAsString(NETPARM_S_TITLE);
                const char *s_name = req.GetParmAsString(NETPARM_S_NAME);
                const char *s_age = req.GetParmAsString(NETPARM_S_AGE);
                const char *s_text = req.GetParmAsString(NETPARM_S_TEXT);
                
                p_db->AddUserResponse(s_kind,s_title,s_name,s_age,s_text);
              }
         }
      break;
    }

    case NETCMD_UPDATESELFENV:
    {
      CNetCmd t(*p_env);

      char *old_class = sys_copystring(t.GetParmAsString(NETPARM_S_CLASS,""));
      UpdateEnvStrings(t,req.GetCmdBuffPtr(),req.GetCmdBuffSize());
      char *new_class = sys_copystring(t.GetParmAsString(NETPARM_S_CLASS,""));

      if ( lstrcmpi(new_class,old_class) )
         {
           if ( !IsStrEmpty(new_class) )
              {
                { // clear our class at this moment
                  CCSGuard g(o_cs);
                  const char *s = NETPARM_S_CLASS "=";
                  UpdateEnvStrings(*p_env,s,lstrlen(s)+1);
                }
                
                if ( !p_server->CanAddNewClass(new_class,m_ip,t.GetParmAsBool(NETPARM_B_ISOPERATORSHELL,FALSE)) )
                   { //clear Class
                     const char *s = NETPARM_S_CLASS "=";
                     UpdateEnvStrings(t,s,lstrlen(s)+1);
                   
                     Push2Send(CNetCmd(NETCMD_CLASSNAMENOTUPDATED_ACK));
                   }
              }
         }

      sys_free(new_class);
      sys_free(old_class);
      
      {
        CCSGuard g(o_cs);
        *p_env = t;
      }

      break;
    }

    case NETCMD_GETENV_REQ:
    {
      CNetCmd env(NETCMD_GETENV_ACK);
      p_server->GetCopyOfEnv(env,req.GetParmAsInt(NETPARM_I_GUID,NETGUID_UNKNOWN));
      Push2Send(env);
      break;
    }

    case NETCMD_GETALLENV_REQ:
    {
      CNetCmd env(NETCMD_GETALLENV_ACK);
      p_server->GetCopyOfAllEnv(env);
      Push2Send(env);
      break;
    }

    case NETCMD_GETSETTINGS_REQ:
    {
      if ( IsClassKnown() )
         {
           if ( !p_db->IsConnected() )
              {
                //char err[MAX_PATH] = "";
                //p_db->GetLastErrorSlow(err,sizeof(err));  //slowdown!
                
                CNetCmd cmd(NETCMD_GETSETTINGS_ERR_ACK);
                cmd.AddIntParm(NETPARM_I_RESULT,NETERR_SETTINGS_DBNOTREADY);
                //cmd.AddStringParm(NETPARM_S_RESULT,err);
                Push2Send(cmd);
              }
           else
              {
                const char* s_computerloc = p_env->GetParmAsString(NETPARM_S_MACHINELOC);
                const char* s_computerdesc = p_env->GetParmAsString(NETPARM_S_MACHINEDESC);
                const char* s_computername = p_env->GetParmAsString(NETPARM_S_COMPNAME);
                const char* s_ip = p_env->GetParmAsString(NETPARM_S_IP);
                const char* s_userdomain = p_env->GetParmAsString(NETPARM_S_DOMAIN);  // can be empty
                const char* s_username = p_env->GetParmAsString(NETPARM_S_USERNAME);  // can be empty
                int s_langid = p_env->GetParmAsInt(NETPARM_I_LANGID,0);               // can be empty

                CNetCmd cmd(NETCMD_GETSETTINGS_OK_ACK);

                BOOL rc = IsUser() ? p_db->SettingsReq(s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_langid,cmd) :
                                     p_db->CompSettingsReq(s_computerloc,s_computerdesc,s_computername,s_ip,cmd);
                
                if ( rc )
                   {
                     Push2Send(cmd);
                   }
                else
                   {
                     char err[MAX_PATH] = "";
                     p_db->GetLastErrorSlow(err,sizeof(err));
                     
                     CNetCmd cmd(NETCMD_GETSETTINGS_ERR_ACK);
                     cmd.AddIntParm(NETPARM_I_RESULT,NETERR_SETTINGS_OTHER);
                     cmd.AddStringParm(NETPARM_S_RESULT,err);
                     Push2Send(cmd);
                   }
              }
         }
      else
         {
           CNetCmd cmd(NETCMD_GETSETTINGS_ERR_ACK);
           cmd.AddIntParm(NETPARM_I_RESULT,NETERR_SETTINGS_OUTOFLICENSE);
           Push2Send(cmd);
         }
      break;
    }

    case NETCMD_POLLSERVER:
    {
      break;
    }

    case NETCMD_CLIENTUPDATELIST_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_CLIENTUPDATELIST_ACK);
           p_server->GetClientUpdateList(FALSE,ack);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_CLIENTUPDATEFILES_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_CLIENTUPDATEFILES_ACK);
           p_server->GetClientUpdateFiles(FALSE,req,ack);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_CLIENTUPDATENOSHELLLIST_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_CLIENTUPDATENOSHELLLIST_ACK);
           p_server->GetClientUpdateList(TRUE,ack);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_CLIENTUPDATENOSHELLFILES_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_CLIENTUPDATENOSHELLFILES_ACK);
           p_server->GetClientUpdateFiles(TRUE,req,ack);
           Push2Send(ack);
         }
      break;
    }

    case NETCMD_FLOATLIC2SERVER_REQ:
    {
      if ( IsClassKnown() )
         {
           CNetCmd ack(NETCMD_FLOATLIC2SERVER_ACK);

           ack.AddIntParm(NETPARM_I_ID,req.GetParmAsInt(NETPARM_I_ID));

           char s[MAX_PATH];
           lstrcpyn(s,req.GetParmAsString(NETPARM_S_PATH),MAX_PATH);
           DoEnvironmentSubst(s,MAX_PATH);
           if ( !IsStrEmpty(s) )
              {
                GetFloatLicsFromFile(s,ack);
              }
           
           Push2Send(ack);
         }
      break;
    }

  
  };
}


void CClient::GetFloatLicsFromFile(const char *filename,CNetCmd& _cmd)
{
  if ( !IsStrEmpty(filename) )
     {
       const unsigned max_buff = 32768;
       char *buff = (char*)sys_zalloc(max_buff);  // zero clears
       
       GetPrivateProfileSection("Main",buff,max_buff,filename);

       const char *p = buff;
       while ( *p )
       {
         p += lstrlen(p)+1;
       }
       unsigned len = p-buff;

       if ( len > 0 )
          {
            _cmd.AddBuff(buff,len);
          }

       sys_free(buff);
     }
}



