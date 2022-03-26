

CAlertCallOperator::CAlertCallOperator(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid)
  : CAlert(hwnd,id,message,vis,NULL,32516/*IDI_INFORMATION*/,S_CALLOPERATOR), m_cmd(cmd), m_client_guid(src_guid)
{
}


CAlertCallOperator::~CAlertCallOperator()
{
}


void CAlertCallOperator::Execute()
{
  NetSend(CNetCmd(NETCMD_CALLOPERATOR_ACK),m_client_guid);

  const char *s_loc = m_cmd.GetParmAsString(NETPARM_S_MACHINELOC,"");
  const char *s_desc = m_cmd.GetParmAsString(NETPARM_S_MACHINEDESC,"");
  const char *s_domain = m_cmd.GetParmAsString(NETPARM_S_DOMAIN,"");
  const char *s_user = m_cmd.GetParmAsString(NETPARM_S_USERNAME,"");

  char s[MAX_PATH*2];
  wsprintf(s,S_CALLOPERATORTEXT,s_loc,s_desc,s_domain,s_user);
  
  gui->MsgBox(s);
}

