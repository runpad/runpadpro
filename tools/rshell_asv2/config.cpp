
#include "include.h"



static const char* m_env[13] = 
{
  "%A2_TIMEPASSED%",
  "%A2_TIMEREMAINED%",
  "%A2_TRAFFICI%",
  "%A2_TRAFFICO%",
  "%A2_TRAFFICLIMI%",
  "%A2_TRAFFICLIMO%",
  "%A2_CURRENTUSER%",
  "%A2_COMPNUMBER%",
  "%A2_TARIFF%",
  "%A2_CASHPASSED%",
  "%A2_CASHPASSEDONLYTRAFFIC%",
  "%A2_CASHCREDIT%",
  "%A2_CASHREST%",
};

#ifndef ADDLANGS
static const char* m_desc[13] = 
{
  NULL,
  "осталось\t\t",
  "вх. трафик\t\t",
  "исх. трафик\t\t",
  "вх. трафик (max)\t",
  "исх. трафик (max)\t",
  "ник клиента\t\t",
  NULL,
  "тариф\t\t\t",
  NULL,
  NULL,
  NULL,
  "остаток\t\t",
};
#else
static const char* m_desc[13] = 
{
  NULL,
  "left\t\t",
  "in traffic\t\t",
  "out traffic\t\t",
  "in traffic (max)\t",
  "out traffic (max)\t",
  "client nick\t\t",
  NULL,
  "rate\t\t\t",
  NULL,
  NULL,
  NULL,
  "balance\t\t",
};
#endif


CConfig::CConfig()
{
  m_rshell = new CRShell();

  lstrcpy(m_orig_status,"");
  lstrcpy(m_curr_status,"");
  lstrcpy(m_curr_tariff,"{C3CAFED0-22F2-4b90-94AB-BFCD6D3378E8}"); // random string
  lstrcpy(m_curr_user,"");

  last_update_time = GetTickCount() - 301000;

  h_event_recv_data = CreateEvent(NULL,FALSE,FALSE,"rshell_asv2_Event_RecvData");
  b_got_packet = FALSE;

  for ( int n = 0; n < sizeof(m_vars)/sizeof(m_vars[0]); n++ )
      {
        lstrcpy(m_vars[n],"-");
      }

  char filename[MAX_PATH];
  lstrcpy(filename,our_currpath);
  PathAppend(filename,"rshell_asv2.ini");
  if ( !IsFileExist(filename) )
     lstrcpy(filename,"rshell_asv2.ini");  // will be in Windows dir

  ReadTrimmedStringFromIniFile(filename,"Main","StatusString",m_orig_status);

  {
    char s[MAX_PATH] = "0";
    ReadTrimmedStringFromIniFile(filename,"Main","UpdateInterval",s);
    int t = StrToInt(s);
    if ( t < 1 )
       t = 1;
    if ( t > 300 )
       t = 300;
    update_interval = t;
  }
  
  {
    char s[MAX_PATH] = "";
    ReadTrimmedStringFromIniFile(filename,"Main","VipLogin",s);
    use_vip_login = (!lstrcmpi(s,"") || !lstrcmpi(s,"1") || !lstrcmpi(s,"Yes") || !lstrcmpi(s,"True"));
  }


  // read tariffs
  for ( int n = 0; ; n++ )
      {
        char key[MAX_PATH];
        sprintf(key,"Tariff%d",n+1);

        char s_name[MAX_PATH] = "";
        
        if ( !ReadTrimmedStringFromIniFile(filename,key,"Name",s_name) )
           break;

        // check if this name is unique
        BOOL find = FALSE;
        for ( int m = 0; m < m_tariffs.size(); m++ )
            if ( !lstrcmpi(m_tariffs[m]->name,s_name) )
               {
                 find = TRUE;
                 break;
               }

        if ( !find )
           {
             char s_show[MAX_PATH] = "";
             BOOL b_use_show = ReadTrimmedStringFromIniFile(filename,key,"Show",s_show);
             char s_hide[MAX_PATH] = "";
             BOOL b_use_hide = ReadTrimmedStringFromIniFile(filename,key,"Hide",s_hide);

             if ( !b_use_show && !b_use_hide )
                continue;

             if ( b_use_show && b_use_hide )
                continue;

             TARIFF *t = new TARIFF;
             lstrcpy(t->name,s_name);
             t->p_show = NULL;
             t->p_hide = NULL;

             if ( b_use_show )
                t->p_show = CreateStringList(s_show);
             if ( b_use_hide )
                t->p_hide = CreateStringList(s_hide);

             m_tariffs.push_back(t);
           }
      }
}


CConfig::~CConfig()
{
  for ( int n = 0; n < m_tariffs.size(); n++ )
      {
        TARIFF *t = m_tariffs[n];

        if ( t->p_show )
           DestroyStringList(t->p_show);
        if ( t->p_hide )
           DestroyStringList(t->p_hide);

        delete t;
      }

  m_tariffs.clear();

  CloseHandle(h_event_recv_data);
  
  SAFEDELETE(m_rshell);
}


void CConfig::GetVarsDesc(char *text,int max)
{
  if ( text )
     {
       char *temp = (char*)malloc(4096);

       temp[0] = 0;
       
       for ( int n = 0; n < sizeof(m_vars)/sizeof(m_vars[0]); n++ )
           {
             if ( m_desc[n] )
                {
                  lstrcat(temp,m_desc[n]);
                  lstrcat(temp,m_vars[n]);
                  lstrcat(temp,"\n");
                }
           }

       lstrcpyn(text,temp,max);

       free(temp);
     }
}


void CConfig::IncomingPacket(const char *buff)
{
  if ( !IsStrEmpty(buff) )
     {
       int alloc_size = lstrlen(buff)+20;  // at least +14 !!!
       char *temp = (char*)malloc(alloc_size);
       ZeroMemory(temp,alloc_size);
       lstrcpy(temp,buff);
       
       for ( int n = 0; n < alloc_size; n++ )
           if ( temp[n] == '\2' )
              temp[n] = '\0';
       
       const char *p = temp;
       
       const char *header = "AstaInfoDataBlock";
       if ( !lstrcmpi(p,header) )
          {
            p += lstrlen(p)+1;

            for ( int n = 0; n < sizeof(m_vars)/sizeof(m_vars[0]); n++ )
                {
                  lstrcpyn(m_vars[n],p,MAX_PATH);
                  PathRemoveBlanks(m_vars[n]);
                  p += lstrlen(p)+1;
                }

            BOOL b_tariff_changed = (lstrcmpi(m_vars[8],m_curr_tariff) != 0);
            if ( b_tariff_changed )
               {
                 lstrcpy(m_curr_tariff,m_vars[8]);
                 ProcessNewTariff();
               }

            BOOL b_user_changed = (lstrcmpi(m_vars[6],m_curr_user) != 0);
            if ( b_user_changed )
               {
                 lstrcpy(m_curr_user,m_vars[6]);
                 ProcessNewUser();
               }
            
            char s[MAX_PATH];
            lstrcpy(s,m_orig_status);
            for ( int n = 0; n < sizeof(m_vars)/sizeof(m_vars[0]); n++ )
                {
                  StrReplaceI(s,m_env[n],m_vars[n]);
                }

            BOOL b_status_changed = (lstrcmp(m_curr_status,s) != 0);
            if ( b_status_changed )
               {
                 lstrcpy(m_curr_status,s);

                 if ( !IsStrEmpty(m_curr_status) )
                    {
                      if ( GetTickCount() - last_update_time > update_interval*1000 )
                         {
                           m_rshell->SetStatusString(m_curr_status);
                           last_update_time = GetTickCount();
                         }
                    }
               }
          
            SetEvent(h_event_recv_data); // fire event!
            b_got_packet = TRUE;
          }

       free(temp);
     }
}


void CConfig::ProcessNewTariff()
{
  if ( m_tariffs.size() > 0 )
     {
       const TARIFF *tar = NULL;
       
       for ( int n = 0; n < m_tariffs.size(); n++ )
           {
             if ( !lstrcmpi(m_tariffs[n]->name,m_curr_tariff) )
                {
                  tar = m_tariffs[n];
                  break;
                }
           }

       if ( tar == NULL )
          {
            m_rshell->EnableSheets(NULL,TRUE);
          }
       else
          {
            if ( tar->p_show )
               {
                 m_rshell->EnableSheets(NULL,FALSE);
                 
                 const TSTRINGLIST *list = tar->p_show;
                 for ( int n = 0; n < list->size(); n++ )
                     {
                       m_rshell->EnableSheets((*list)[n],TRUE);
                     }
               }
            else
            if ( tar->p_hide )
               {
                 m_rshell->EnableSheets(NULL,TRUE);
                 
                 const TSTRINGLIST *list = tar->p_hide;
                 for ( int n = 0; n < list->size(); n++ )
                     {
                       m_rshell->EnableSheets((*list)[n],FALSE);
                     }
               }
            else
               {
                 //assert(FALSE);
                 m_rshell->EnableSheets(NULL,TRUE);
               }
          }
     }
}


void CConfig::ProcessNewUser()
{
  if ( use_vip_login )
     {
       if ( IsStrEmpty(m_curr_user) || !StrCmpNI(m_curr_user,"КОД ",4)/*fix for non-vip users*/ )
          {
            m_rshell->VipLogout();
          }
       else
          {
            m_rshell->VipLogin(m_curr_user);
          }
     }
}


void CConfig::ForceSendInfoToRShell()
{
  if ( b_got_packet )
     {
       // status string
       if ( !IsStrEmpty(m_curr_status) )
          {
            m_rshell->SetStatusString(m_curr_status);
            last_update_time = GetTickCount();
          }

       // sheets
       ProcessNewTariff();

       // vip user
       ProcessNewUser();
     }
}


CConfig::TSTRINGLIST* CConfig::CreateStringList(const char *src)
{
  if ( !src )
     return NULL;

  int alloc_size = lstrlen(src)+10;
  char *temp = (char*)malloc(alloc_size);
  ZeroMemory(temp,alloc_size);
  lstrcpy(temp,src);

  for ( int n = 0; n < alloc_size; n++ )
      if ( temp[n] == ';' )
         temp[n] = 0;

  const char *p = temp;
  TSTRINGLIST *list = new TSTRINGLIST;

  while ( *p )
  {
    char s[MAX_PATH];

    lstrcpyn(s,p,sizeof(s));
    PathRemoveBlanks(s);

    if ( !IsStrEmpty(s) )
       {
         char *copy = sys_copystring(s);
         list->push_back(copy);
       }

    p += lstrlen(p)+1;
  }

  free(temp);

  return list;
}


void CConfig::DestroyStringList(CConfig::TSTRINGLIST* &list)
{
  if ( list )
     {
       for ( int n = 0; n < list->size(); n++ )
           {
             char *s = (*list)[n];
             if ( s )
                {
                  free(s);
                }
           }

       list->clear();
       SAFEDELETE(list);
     }
}
