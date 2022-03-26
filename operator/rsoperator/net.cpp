
#include "include.h"



static HANDLE g_ev_connect = NULL;
static HANDLE g_ev_disconnect = NULL;
static CNetClient *net = NULL;


void OnNetConnect();
void OnNetDisconnect();
void OnNetBeforeRecv();
void OnNetCmdReceived(const CNetCmd &cmd,unsigned src_guid);



void NetInit()
{
  g_ev_connect = CreateEvent(NULL,FALSE,FALSE,NULL);
  g_ev_disconnect = CreateEvent(NULL,FALSE,FALSE,NULL);
  net = new CNetClient(HKEY_LOCAL_MACHINE,REGPATH,"server_ip",NETPORT,g_ev_connect,g_ev_disconnect);
}


void NetDone()
{
  if ( net )
     {
       delete net;
       net = NULL;
     }
      
  if ( g_ev_connect )
     {  
       CloseHandle(g_ev_connect);
       g_ev_connect = NULL;
     }

  if ( g_ev_disconnect )
     {  
       CloseHandle(g_ev_disconnect);
       g_ev_disconnect = NULL;
     }
}


BOOL NetFlush(unsigned timeout)
{
  return net ? net->Flush(timeout) : TRUE;
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


BOOL IsNetDisconnectEvent()
{
  BOOL rc = FALSE;
  
  if ( g_ev_disconnect )
     {
       if ( WaitForSingleObject(g_ev_disconnect,0) == WAIT_OBJECT_0 )
          {
            rc = TRUE;
          }
     }

  return rc;
}


BOOL NetIsConnected()
{
  return net ? net->IsConnected() : FALSE;
}


BOOL NetSend(const CNetCmd& cmd,unsigned dest_guid)
{
  return net ? net->Push(cmd,dest_guid) : FALSE;
}


BOOL NetGet(CNetCmd& cmd,unsigned *_src_guid)
{
  return net ? net->Pop(cmd,_src_guid) : FALSE;
}


void NetProcessing()
{
  if ( IsNetConnectEvent() )
     {
       OnNetConnect();
     }

  if ( IsNetDisconnectEvent() )
     {
       OnNetDisconnect();
     }

  OnNetBeforeRecv();
     
  for ( int count = 0; count < 5; count++ )
      {
        CNetCmd cmd; //rallocations here isn't critical, but using static buff is dangerous!
        unsigned src_guid = NETGUID_UNKNOWN;
        if ( !NetGet(cmd,&src_guid) )
           break;

        if ( cmd.IsValid() && src_guid != NETGUID_UNKNOWN )
           {
             OnNetCmdReceived(cmd,src_guid);
           }
      }
}


void SendStaticInfoToServer()
{
  char s[MAX_PATH];
  CNetCmd cmd(NETCMD_UPDATESELFENV);

  cmd.AddStringParm(NETPARM_S_CLASS,NETCLASS_OPERATOR); //we are operator
  cmd.AddStringParm(NETPARM_S_COMPNAME,MyGetComputerName(s));
  cmd.AddStringParm(NETPARM_S_DOMAIN,GetDomainName(s));
  cmd.AddStringParm(NETPARM_S_USERNAME,MyGetUserName(s));
  
  NetSend(cmd);
}


void OnNetConnect()
{
  SendStaticInfoToServer();
}


void OnNetDisconnect()
{
  ClearEnvList();
}


void OnNetBeforeRecv()
{
  static unsigned last_send_time = 0;

  if ( GetTickCount() - last_send_time > 7000 )
     {
       if ( NetIsConnected() )
          {
            CNetCmd req(NETCMD_GETALLENV_REQ);
            NetSend(req);
          }
       else
          {
            ClearEnvList();
          }

       last_send_time = GetTickCount();
     }
}


void OnNetCmdReceived(const CNetCmd &cmd,unsigned src_guid)
{
  ProcessReceivedCmd(cmd,src_guid);
}

