


CAlertNetBT::CAlertNetBT(HWND hwnd,int id,int message,BOOL vis,const CNetCmd &cmd,unsigned src_guid)
  : CAlert(hwnd,id,message,vis,our_instance,IDI_BT,S_NETBT), m_cmd(cmd), m_client_guid(src_guid)
{
}


CAlertNetBT::~CAlertNetBT()
{
}


void CAlertNetBT::Execute()
{
  NetSend(CNetCmd(NETCMD_NETBT_ACK),m_client_guid);

  const char *s_loc = m_cmd.GetParmAsString(NETPARM_S_MACHINELOC,"");
  const char *s_desc = m_cmd.GetParmAsString(NETPARM_S_MACHINEDESC,"");
  const char *s_domain = m_cmd.GetParmAsString(NETPARM_S_DOMAIN,"");
  const char *s_user = m_cmd.GetParmAsString(NETPARM_S_USERNAME,"");
  const char *s_path = m_cmd.GetParmAsString(NETPARM_S_PATH,"");
  BOOL is_mobile_content = m_cmd.GetParmAsBool(NETPARM_B_MOBILECONTENT);

  char s[MAX_PATH*3];
  wsprintf(s,S_NETBTTEXT,s_loc,s_desc,s_domain,s_user,s_path);
  
  if ( gui->ConfirmOkCancel(s) )
     {
       char s[MAX_PATH];
       if ( GetLocalFileInClientShellDir("bodybt.exe",s) )
          {
            SendBTFilesFromFolder(s,is_mobile_content,s_path);
          }
       else
          {
            gui->ErrBox(S_SHELLNOTINSTALLED);
          }
     }
}


BOOL CAlertNetBT::BTCallbackFunc(const char *file,WIN32_FIND_DATA *f,void *h)
{
  CDynBuff *buff = (CDynBuff*)h;
  buff->AddStringNoTerm(" \"");
  buff->AddStringNoTerm(file);
  buff->AddStringNoTerm("\"");
  return TRUE;
}


void CAlertNetBT::SendBTFilesFromFolder(const char *bodybt,BOOL mobile_content,const char *folder)
{
  CDynBuff buff;

  buff.AddStringNoTerm("\"");
  buff.AddStringNoTerm(bodybt);
  buff.AddStringNoTerm("\" -send");
  if ( mobile_content )
     buff.AddStringNoTerm("2");

  unsigned old_size = buff.GetBuffSize();

  ScanDir(folder,SCAN_FILE | SCAN_HIDDEN,BTCallbackFunc,&buff);

  unsigned new_size = buff.GetBuffSize();
 
  buff.AddStringSZ(""); //zero terminator

  if ( new_size == old_size )
     {
       gui->ErrBox(S_ERRNOBTFILES);
     }
  else
     {
       char cwd[MAX_PATH];
       lstrcpy(cwd,bodybt);
       PathRemoveFileSpec(cwd);

       RunProcess(buff.GetBuffPtr(),cwd);
     }
}


