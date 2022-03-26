

CPicCollector::CPicCollector(const char *title,const char *parm_name,int accept_cmd_id,const TENVENTRY *list,unsigned listcount)
  : CHTMLCollector(title,accept_cmd_id,list,listcount)
{
  m_parm_name = sys_copystring(parm_name);
}


CPicCollector::~CPicCollector()
{
  if ( m_parm_name )
     sys_free(m_parm_name);
}


void CPicCollector::OnDataAccepted(const CNetCmd &cmd,unsigned src_guid)
{
  const char *buff = cmd.GetCmdBuffPtr();
  unsigned size = cmd.GetCmdBuffSize();

  if ( buff && size )
     {
       char filename[MAX_PATH];
       char local[MAX_PATH];
       wsprintf(local,"rs_operator_pic_%d.jpg",GetRecvdList().size());
       GetFileNameInTempDir(local,filename);
       if ( WriteFullFile(filename,buff,size) )
          {
            const char *fmt = "<a href=\"file://%s\" target=_blank><img src=\"file://%s\" border=0 height=188></a>";
            char s[MAX_PATH*3];
            wsprintf(s,fmt,filename,filename);

            CNetCmd new_cmd(cmd.GetCmdId());
            new_cmd.AddStringParm(m_parm_name,s);

            CHTMLCollector::OnDataAccepted(new_cmd,src_guid);
          }
     }
}

