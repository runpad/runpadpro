

CAlertNetBurn::CAlertNetBurn(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid)
  : CAlert(hwnd,id,message,vis,our_instance,IDI_BURN,S_NETBURN), m_cmd(cmd), m_client_guid(src_guid)
{
}


CAlertNetBurn::~CAlertNetBurn()
{
}


void CAlertNetBurn::Execute()
{
  NetSend(CNetCmd(NETCMD_NETBURN_ACK),m_client_guid);

  const char *s_loc = m_cmd.GetParmAsString(NETPARM_S_MACHINELOC,"");
  const char *s_desc = m_cmd.GetParmAsString(NETPARM_S_MACHINEDESC,"");
  const char *s_domain = m_cmd.GetParmAsString(NETPARM_S_DOMAIN,"");
  const char *s_user = m_cmd.GetParmAsString(NETPARM_S_USERNAME,"");
  const char *s_path = m_cmd.GetParmAsString(NETPARM_S_PATH,"");

  char s[MAX_PATH*3];
  wsprintf(s,S_NETBURNTEXT,s_loc,s_desc,s_domain,s_user,s_path);
  
  if ( gui->ConfirmOkCancel(s) )
     {
       char s[MAX_PATH];
       if ( GetLocalFileInClientShellDir("bodyburn.exe",s) )
          {
            char cwd[MAX_PATH];
            lstrcpy(cwd,s);
            PathRemoveFileSpec(cwd);

            char cmdline[MAX_PATH*2];
            wsprintf(cmdline,"\"%s\" \"%s\"",s,s_path);

            if ( !RunProcess(cmdline,cwd) )
               {
               }
          }
       else
          {
            gui->ErrBox(S_SHELLNOTINSTALLED);
          }
     }
}

