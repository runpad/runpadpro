


CExecStatCollector::CExecStatCollector(const TENVENTRY *list,unsigned listcount)
  : CCollector(NETCMD_EXECSTAT_ACK,list,listcount)
{
  GetFileNameInTempDir("info.stat",m_filename);
  m_file = sys_fcreate(m_filename);
}


CExecStatCollector::~CExecStatCollector()
{
  if ( m_file )
     sys_fclose(m_file);
}


void CExecStatCollector::OnDataAccepted(const CNetCmd &cmd,unsigned src_guid)
{
  if ( m_file )
     {
       const char *buff = cmd.GetCmdBuffPtr();
       unsigned size = cmd.GetCmdBuffSize();

       if ( buff && size )
          {
            sys_fwrite_txt(m_file,"m");

            int num = 1; // :)
            int ip = 0;
            const TTargetList &list = GetTargetList();
            for ( int n = 0; n < list.size(); n++ )
                if ( list[n].guid == src_guid )
                   {
                     ip = inet_addr(list[n].ip);
                     num = GetNumberFromString(list[n].machine_desc,-1);
                     if ( num == -1 )
                        num = GetNumberFromString(list[n].comp_name,-1);
                     if ( num == -1 )
                        num = GetNumberFromString(list[n].user_name,-1);
                     if ( num <= 0 || num > 255 )
                        num = 1;
                     break;
                   }

            sys_fwrite(m_file,(const char *)&num,1);
            sys_fwrite(m_file,(const char *)&ip,4);
            sys_fwrite(m_file,buff,size);
          }
     }
}


void CExecStatCollector::OnFinish()
{
  if ( m_file )
     {
       if ( sys_fsize(m_file) > 0 )
          {
            sys_fclose(m_file);
            m_file = NULL; //to correct destructor work

            char cmdline[MAX_PATH*2];
            wsprintf(cmdline,"\"%s\\%s\" \"%s\"",our_currpath,"rsstat.exe",m_filename);

            RunProcess(cmdline,our_currpath);
          }
     }
}


int CExecStatCollector::GetNumberFromString(const char *s,int def)
{
  if ( IsStrEmpty(s) )
     return def;
  
  char *out = (char*)sys_zalloc(lstrlen(s)+1); //zero clears

  char *p = out;
  for ( int n = 0; n < lstrlen(s); n++ )
      if ( s[n] >= '0' && s[n] <= '9' )
         *p++ = s[n];

  int num = (IsStrEmpty(out) ? def : StrToInt(out));

  sys_free(out);

  return num;
}


