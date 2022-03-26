

class CHTMLTableParser : public CDynBuff
{
  public:
         CHTMLTableParser(const char *s);
};

CHTMLTableParser::CHTMLTableParser(const char *s)
  : CDynBuff()
{
  if ( IsStrEmpty(s) )
     {
       AddStringSZ("&nbsp;");
     }
  else
     {
       for ( int n = 0; n < lstrlen(s); n++ )
           {
             char c = s[n];

             if ( c == '<' )
                AddStringNoTerm("&lt;");
             else
             if ( c == '>' )
                AddStringNoTerm("&gt;");
             else
             if ( c == '&' )
                AddStringNoTerm("&amp;");
             else
             if ( c == '\n' )
                AddStringNoTerm("<br>");
             //else
             //if ( c == ' ' )
             //   AddStringNoTerm("&nbsp;");
             else
             if ( c != '\r' )
                AddChar(c);
           }

       AddStringSZ(""); //terminator
     }
}




CHTMLCollector::CHTMLCollector(const char *title,int accept_cmd_id,const TENVENTRY *list,unsigned listcount)
  : CCollector(accept_cmd_id,list,listcount)
{
  m_title = sys_copystring(title);
}


CHTMLCollector::~CHTMLCollector()
{
  if ( m_title )
     sys_free(m_title);
}


void CHTMLCollector::OnDataAccepted(const CNetCmd &cmd,unsigned src_guid)
{
  recvd.push_back( std::pair<CNetCmd,unsigned>(cmd,src_guid) );
}


void CHTMLCollector::OnFinish()
{
  if ( recvd.size() > 0 )
     {
       // build list of all fields
       TFields fields;
       
       for ( int n = 0; n < recvd.size(); n++ )
           {
             const char *p = recvd[n].first.GetCmdBuffPtr();
             unsigned size = recvd[n].first.GetCmdBuffSize();

             if ( p && size && p[size-1] == 0 )
                {
                  while ( size > 0 )
                  {
                    if ( !*p )
                       break;

                    char *s = sys_copystring(p);
                    char *equ = StrStr(s,"=");
                    if ( equ && equ != s )
                       {
                         *equ = 0;

                         BOOL find = FALSE;
                         for ( int n = 0; n < fields.size(); n++ )
                             if ( !lstrcmpi(fields[n],s) )
                                {
                                  find = TRUE;
                                  break;
                                }

                         if ( !find )
                            {
                              fields.push_back(s);
                            }
                         else
                            {
                              sys_free(s);
                            }
                       }
                    else
                       {
                         sys_free(s);
                         break;
                       }

                    size -= lstrlen(p) + 1;
                    p += lstrlen(p) + 1;
                  }
                }
           }

       if ( fields.size() > 0 )
          {
            // build unsorted dataset
            TDataSet dataset;
            
            const TTargetList& targets = GetTargetList();
            for ( int n = 0; n < targets.size(); n++ )
                {
                  TRecord *rec = new TRecord();

                  const CNetCmd *cmd = NULL;
                  unsigned des_guid = targets[n].guid;
                  for ( int k = 0; k < recvd.size(); k++ )
                      if ( recvd[k].second == des_guid )
                         {
                           cmd = &recvd[k].first;
                           break;
                         }

                  for ( int m = 0; m < fields.size(); m++ )
                      {
                        rec->push_back(cmd ? sys_copystring(cmd->GetParmAsString(fields[m],NULL)) : NULL);
                      }
                  
                  dataset.push_back(TDataSetEntry(rec,&targets[n]));
                }

            // sort dataset
            for ( int m = 0; m < dataset.size(); m++ )
            for ( int n = 0; n < dataset.size()-1; n++ )
                {
                  if ( CompareEnvs(dataset[n].second,dataset[n+1].second) > 0 )
                     {
                       TDataSetEntry t = dataset[n];
                       dataset[n] = dataset[n+1];
                       dataset[n+1] = t;
                     }
                }

            // add internal field with machine id to dataset
            for ( int n = 0; n < dataset.size(); n++ )
                {
                  TRecord *rec = dataset[n].first;
                  const TENVENTRY *env = dataset[n].second;

                  char *s = (char*)sys_alloc(lstrlen(env->machine_loc)+lstrlen(env->machine_desc)+lstrlen(env->comp_name)+lstrlen(env->domain)+lstrlen(env->user_name)+MAX_PATH);

                  wsprintf(s,"%s\\%s",env->machine_loc,env->machine_desc);
                  if ( lstrcmpi(env->machine_desc,env->comp_name) )
                     {
                       lstrcat(s," (");
                       lstrcat(s,env->comp_name);
                       lstrcat(s,")");
                     }
                  if ( !IsStrEmpty(env->user_name) )
                     {
                       lstrcat(s," [");
                       if ( lstrcmpi(env->domain,env->comp_name) )
                          {
                            lstrcat(s,env->domain);
                            lstrcat(s,"\\");
                          }
                       lstrcat(s,env->user_name);
                       lstrcat(s,"]");
                     }

                  rec->insert(rec->begin(),s);
                }

            // add internal field to the begining of fields list
            fields.insert(fields.begin(),sys_copystring(S_NETPARM_MACHINEID));

            // write to HTML-file and execute
            char filename[MAX_PATH];
            GetFileNameInTempDir("rs_operator_html_coll.html",filename);
            if ( WriteHTML(filename,m_title,fields,dataset) )
               {
                 ShellExecute(NULL,NULL,filename,NULL,NULL,SW_SHOWMAXIMIZED);
               }

            // free dataset
            for ( int n = 0; n < dataset.size(); n++ )
                {
                  TRecord *rec = dataset[n].first;

                  for ( int m = 0; m < rec->size(); m++ )
                      {
                        char *s = (*rec)[m];
                        if ( s )
                           sys_free(s);
                        (*rec)[m] = NULL;
                      }

                  rec->clear();
                  delete rec;

                  dataset[n].first = NULL;
                }
            dataset.clear();
          }

       // free fileds list
       for ( int n = 0; n < fields.size(); n++ )
           {
             sys_free(fields[n]);
             fields[n] = NULL;
           }
       fields.clear();
     }
}


int CHTMLCollector::CompareEnvs(const TENVENTRY *e1,const TENVENTRY *e2)
{
  int cmp = lstrcmpi(e1->machine_loc,e2->machine_loc);
  if ( cmp == 0 )
     cmp = lstrcmpi(e1->machine_desc,e2->machine_desc);
  if ( cmp == 0 )
     cmp = lstrcmpi(e1->comp_name,e2->comp_name);
  if ( cmp == 0 )
     cmp = lstrcmpi(e1->domain,e2->domain);
  if ( cmp == 0 )
     cmp = lstrcmpi(e1->user_name,e2->user_name);
  return cmp;
}



static const char *htmlInfoHead = \
"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n" \
"<html>\n" \
"<head>\n" \
"<title>%s</title>\n" \
"<style type=\"text/css\">\n" \
"     body {\n" \
"                MARGIN-LEFT:      20px;\n" \
"                MARGIN-RIGHT:     20px;\n" \
"                MARGIN-TOP:       20px;\n" \
"                MARGIN-BOTTOM:    20px;\n" \
"                FONT-FAMILY:      Verdana;\n" \
"                FONT-SIZE:        8pt;\n" \
"                COLOR:            #000000;\n" \
"                BACKGROUND-COLOR: #FFFFFF;\n" \
"     }\n" \
"     td {\n" \
"                FONT-FAMILY:      Verdana;\n" \
"                FONT-SIZE:        8pt;\n" \
"     }\n" \
"</style>\n" \
"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1251\">\n" \
"</head>\n" \
"<body>\n" \
"<table border=0 cellspacing=1 cellpadding=4 bgcolor=#FFFFFF>\n" \
"<tr><td nowrap align=center><b>%s</b></td></tr>\n"\
"<tr><td>\n";

static const char *htmlInfoFoot = \
"</td></tr></table>\n" \
"</body></html>";

static const char *htmlInfoTableStart = \
"<table border=1 cellspacing=1 cellpadding=4 bgcolor=#F5F5F5>\n";
static const char *htmlInfoTableEnd = \
"</table>\n";

static const char *htmlInfoTableLineStart = \
"<tr>\n";
static const char *htmlInfoTableLineEnd = \
"</tr>\n";

static const char *htmlInfoTableLineItemStart = \
"<td nowrap align=center>";
static const char *htmlInfoTableLineItemEnd = \
"</td>\n";

static const char *htmlInfoTableHeadItem = \
"<td nowrap align=center><b>%s</b></td>\n";



static const struct {
BOOL need_parsing;
const char *name;
const char *display_name;
} field_infos[] = 
{
  {TRUE,  S_NETPARM_MACHINEID,    S_FIELD_MACHINEID}, //internal
  {TRUE,  NETPARM_S_HWINFO,       S_FIELD_HWINFO},
  {TRUE,  NETPARM_S_VERSION,      S_FIELD_RUNPADVER},
  {TRUE,  NETPARM_S_COMPSETTINGS, S_FIELD_COMPSETTINGS},
  {TRUE,  NETPARM_S_USERSETTINGS, S_FIELD_USERSETTINGS},
  {TRUE,  NETPARM_S_OURSERVICES,  S_FIELD_OURSERVICES},
  {FALSE, NETPARM_S_DISKSSPACE,   S_FIELD_DISKSSPACE},
  {FALSE, NETPARM_S_CPUTEMP,      S_FIELD_CPUTEMP},
  {FALSE, NETPARM_S_MBMTEMP,      S_FIELD_MBMTEMP},
  {FALSE, NETPARM_S_CPUCOOLER,    S_FIELD_CPUCOOLER},
  {FALSE, NETPARM_S_GPUTEMP,      S_FIELD_GPUTEMP},
  {TRUE,  NETPARM_S_RLBVERSION,   S_FIELD_RLBVERSION},
  {TRUE,  NETPARM_S_RLBLICENSE,   S_FIELD_RLBLICENSE},
  {TRUE,  NETPARM_S_RLBDRVNOW,    S_FIELD_RLBDRVNOW},
  {TRUE,  NETPARM_S_RLBDRVAFTER,  S_FIELD_RLBDRVAFTER},
  {TRUE,  NETPARM_S_RLBRLBNOW,    S_FIELD_RLBRLBNOW},
  {TRUE,  NETPARM_S_RLBRLBAFTER,  S_FIELD_RLBRLBAFTER},
  {TRUE,  NETPARM_S_RLBDISKS,     S_FIELD_RLBDISKS},
  {TRUE,  NETPARM_S_RLBPATHS,     S_FIELD_RLBPATHS},
  {FALSE, S_NETPARM_SCREEN,       S_FIELD_SCREEN},   //internal
  {FALSE, S_NETPARM_WEBCAM,       S_FIELD_WEBCAM},   //internal
};



BOOL CHTMLCollector::IsFieldNeedParsing(const TFields &fields,int idx)
{
  BOOL rc = TRUE;

  if ( idx >= 0 && idx < fields.size() )
     {
       const char *name = fields[idx];

       for ( int n = 0; n < sizeof(field_infos)/sizeof(field_infos[0]); n++ )
           {
             if ( !lstrcmpi(field_infos[n].name,name) )
                {
                  rc = field_infos[n].need_parsing;
                  break;
                }
           }
     }

  return rc;
}


BOOL CHTMLCollector::WriteHTML(const char *filename,const char *title,const TFields &fields,const TDataSet &dataset)
{
  BOOL rc = FALSE;

  void *h = sys_fcreate(filename);
  if ( h )
     {
       // head with title
       char *t = (char*)sys_alloc(lstrlen(htmlInfoHead)+2*lstrlen(title)+MAX_PATH);
       sprintf(t,htmlInfoHead,title,title);
       sys_fwrite_txt(h,t);
       sys_free(t);

       sys_fwrite_txt(h,htmlInfoTableStart);

       // head with fileds
       sys_fwrite_txt(h,htmlInfoTableLineStart);
       for ( int n = 0; n < fields.size(); n++ )
           {
             const char *name = fields[n];
             const char *display_name = name;

             for ( int m = 0; m < sizeof(field_infos)/sizeof(field_infos[0]); m++ )
                 {
                   if ( !lstrcmpi(field_infos[m].name,name) )
                      {
                        display_name = field_infos[m].display_name;
                        break;
                      }
                 }

             char *s = (char*)sys_alloc(lstrlen(htmlInfoTableHeadItem)+lstrlen(display_name)+MAX_PATH);
             sprintf(s,htmlInfoTableHeadItem,display_name);
             sys_fwrite_txt(h,s);
             sys_free(s);
           }
       sys_fwrite_txt(h,htmlInfoTableLineEnd);

       // dataset
       for ( int n = 0; n < dataset.size(); n++ )
           {
             sys_fwrite_txt(h,htmlInfoTableLineStart);

             const TRecord *rec = dataset[n].first;
             
             for ( int m = 0; m < rec->size(); m++ )
                 {
                   sys_fwrite_txt(h,htmlInfoTableLineItemStart);

                   if ( IsFieldNeedParsing(fields,m) )
                      {
                        sys_fwrite_txt(h,CHTMLTableParser((*rec)[m]));
                      }
                   else
                      {
                        const char *s = (*rec)[m];
                        if ( IsStrEmpty(s) )
                           s = "&nbsp;";
                        sys_fwrite_txt(h,s);
                      }

                   sys_fwrite_txt(h,htmlInfoTableLineItemEnd);
                 }

             sys_fwrite_txt(h,htmlInfoTableLineEnd);
           }

       sys_fwrite_txt(h,htmlInfoTableEnd);

       // footer
       sys_fwrite_txt(h,htmlInfoFoot);
       sys_fclose(h);
       rc = TRUE;
     }

  return rc;
}


