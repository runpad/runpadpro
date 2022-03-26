
#include "include.h"




CConfig::CConfig()
{
  m_rshell = new CRShell();

  lstrcpy(m_infopath,"");
  lstrcpy(m_orig_status,"");
  lstrcpy(m_curr_status,"");
  last_update_time = GetTickCount() - 301000;
  update_interval = 1000;
  curr_machine = 0;
  b_got_packet = FALSE;


  char filename[MAX_PATH];
  lstrcpy(filename,our_currpath);
  PathAppend(filename,"rshell_ams.ini");
  if ( !IsFileExist(filename) )
     lstrcpy(filename,"rshell_ams.ini");  // will be in Windows dir

  ReadTrimmedStringFromIniFile(filename,"Main","InfoPath",m_infopath);
  ReadTrimmedStringFromIniFile(filename,"Main","StatusString",m_orig_status);

  {
    char s[MAX_PATH] = "0";
    ReadTrimmedStringFromIniFile(filename,"Main","UpdateInterval",s);
    int t = StrToInt(s);
    if ( t < 10 )
       t = 10;
    if ( t > 1000 )
       t = 1000;
    update_interval = t;
  }

  {
    char s[MAX_PATH] = "";
    ReadTrimmedStringFromIniFile(filename,"Main","Machine",s);

    if ( IsStrEmpty(s) )
       {
         char env[MAX_PATH] = "";
         GetEnvironmentVariable("RS_MACHINE",env,sizeof(env));

         char s[MAX_PATH] = "";
         for ( int n = 0; n < lstrlen(env); n++ )
             if ( env[n] >= '0' && env[n] <= '9' )
                {
                  char t[2];
                  t[0] = env[n];
                  t[1] = 0;
                  lstrcat(s,t);
                }
         
         int t = StrToInt(s);
         if ( t < 1 || t > 999 )
            t = 0;
         curr_machine = t;
       }
    else
       {
         int t = StrToInt(s);
         if ( t < 1 || t > 999 )
            t = 0;
         curr_machine = t;
       }
  }
}


CConfig::~CConfig()
{
  SAFEDELETE(m_rshell);
}


void CConfig::GetVarsDesc(char *text,int max)
{
  if ( text )
     {
       lstrcpyn(text,m_curr_status,max);
     }
}


void CConfig::TryReadData()
{
  if ( !IsStrEmpty(m_infopath) && curr_machine != 0 )
     {
       if ( GetTickCount() - last_update_time > update_interval*1000 )
          {
            char section[MAX_PATH];
            wsprintf(section,"%d",curr_machine);

            const int alloc_size = 7000;
            char *pairs = (char*)malloc(alloc_size);
            ZeroMemory(pairs,alloc_size);

            GetPrivateProfileSection(section,pairs,alloc_size-2,m_infopath);

            if ( pairs[0] )
               {
                 struct {
                  const char *s_env;
                  const char *s_ini;
                  char s_value[MAX_PATH];
                 } list[] = 
                 {
                   {"%AMS_TIME_LEFT%",     "~??0923235",    ""}, // 0
                   {"%AMS_END_TIME%",      "~??1231232",    ""}, // 1
                   
                   {"%AMS_IP%",            "ip=",           ""}, // 2
                   {"%AMS_EMPTY%",         "Empty=",        ""}, // 3
                   {"%AMS_NIGHT%",         "Night=",        ""}, // 4
                   {"%AMS_DOWN%",          "Down=",         ""}, // 5
                   {"%AMS_NICK%",          "Nick=",         ""}, // 6
                   {"%AMS_NUMBER%",        "Number=",       ""}, // 7
                   {"%AMS_BEGIN%",         "Begin=",        ""}, // 8
                   {"%AMS_TIME%",          "Time=",         ""}, // 9
                   {"%AMS_ABONEMENT%",     "Abonement=",    ""}, // 10
                   {"%AMS_PO_FACTU%",      "po_factu=",     ""}, // 11
                   {"%AMS_CASH%",          "cash=",         ""}, // 12
                   {"%AMS_INET%",          "Inet=",         ""}, // 13
                   {"%AMS_RESERVED%",      "Reserved=",     ""}, // 14
                   {"%AMS_I_IN%",          "i_in=",         ""}, // 15
                   {"%AMS_I_OUT%",         "i_out=",        ""}, // 16
                   {"%AMS_L_IN%",          "l_in=",         ""}, // 17
                   {"%AMS_L_OUT%",         "l_out=",        ""}, // 18
                   {"%AMS_LIM_I_IN%",      "lim_i_in=",     ""}, // 19
                   {"%AMS_LIM_I_OUT%",     "lim_i_out=",    ""}, // 20
                   {"%AMS_CREDIT%",        "credit=",       ""}, // 21
                   {"%AMS_KASSA%",         "Kassa=",        ""}, // 22
                   {"%AMS_DELTA_I_IN%",    "delta_i_in=",   ""}, // 23
                   {"%AMS_DELTA_I_OUT%",   "delta_i_out=",  ""}, // 24
                   {"%AMS_CREDITSUM%",     "creditsum=",    ""}, // 25
                   {"%AMS_GAMES%",         "Games=",        ""}, // 26
                 };
                 
                 // read variables data
                 for ( int n = 0; n < sizeof(list)/sizeof(list[0]); n++ )
                     {
                       const char *p = pairs;

                       while ( *p )
                       {
                         if ( !StrCmpNI(p,list[n].s_ini,lstrlen(list[n].s_ini)) )
                            {
                              lstrcpyn(list[n].s_value,p+lstrlen(list[n].s_ini),sizeof(list[n].s_value));
                              break;
                            }

                         p += lstrlen(p)+1;
                       };
                     }

                 // compose some our variables
                 {
                   const char *s_begin = list[8].s_value;
                   const char *s_payed = list[9].s_value;

                   if ( !IsStrEmpty(s_begin) && !IsStrEmpty(s_payed) )
                      {
                        char t[MAX_PATH];
                        lstrcpy(t,s_begin);
                        for ( int n = 0; n < lstrlen(t); n++ )
                            if ( t[n] == '.' || t[n] == '/' || t[n] == ':' )
                               t[n] = ' ';

                        int i_day=0,i_month=0,i_year=0,i_hour=0,i_min=0,i_sec=0;
                        sscanf(t,"%d %d %d %d %d %d",&i_day,&i_month,&i_year,&i_hour,&i_min,&i_sec);

                        if ( i_day && i_month && i_year )
                           {
                             SYSTEMTIME st;
                             st.wYear = i_year;
                             st.wMonth = i_month;
                             st.wDay = i_day;
                             st.wHour = i_hour;
                             st.wMinute = i_min;
                             st.wSecond = i_sec;
                             st.wMilliseconds = 0;

                             __int64 begin_time = 0;
                             SystemTimeToFileTime(&st,(FILETIME*)&begin_time);

                             if ( begin_time )
                                {
                                  char t[MAX_PATH];
                                  lstrcpy(t,s_payed);
                                  for ( int n = 0; n < lstrlen(t); n++ )
                                      if ( t[n] == '.' || t[n] == '/' || t[n] == ':' )
                                         t[n] = ' ';

                                  int i_hour=0,i_min=0,i_sec=0;
                                  sscanf(t,"%d %d %d",&i_hour,&i_min,&i_sec);

                                  __int64 payed_time = (__int64)((i_hour*60 + i_min)*60 + i_sec) * 10000000;

                                  SYSTEMTIME st;
                                  GetLocalTime(&st);

                                  __int64 curr_time = 0;
                                  SystemTimeToFileTime(&st,(FILETIME*)&curr_time);

                                  if ( curr_time >= begin_time )
                                     {
                                       __int64 end_time = begin_time + payed_time;
                                       __int64 left_time = end_time - curr_time;
                                       if ( left_time < 0 )
                                          left_time = 0;

                                       SYSTEMTIME st;
                                       FileTimeToSystemTime((const FILETIME*)&end_time,&st);
                                       sprintf(list[1].s_value,"%02d:%02d",st.wHour,st.wMinute);

                                       int left_hours = (int)(left_time/10000000) / (60*60);
                                       int left_minutes = ((int)(left_time/10000000) % (60*60)) / 60;
                                       
                                       sprintf(list[0].s_value,"%02d:%02d",left_hours,left_minutes);
                                     }
                                }
                           }
                      }
                 }

                 // expand status string
                 char s[MAX_PATH];
                 lstrcpy(s,m_orig_status);
                 for ( int n = 0; n < sizeof(list)/sizeof(list[0]); n++ )
                     {
                       StrReplaceI(s,list[n].s_env,list[n].s_value);
                     }

                 // update it
                 BOOL b_status_changed = (lstrcmp(m_curr_status,s) != 0);
                 if ( b_status_changed )
                    {
                      lstrcpy(m_curr_status,s);

                      if ( !IsStrEmpty(m_curr_status) )
                         {
                           m_rshell->SetStatusString(m_curr_status);
                         }
                    }
               
                 b_got_packet = TRUE;
               }

            free(pairs);

            last_update_time = GetTickCount();
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
            //last_update_time = GetTickCount();
          }
     }
}


void CConfig::ShowInfoMessage()
{
  if ( b_got_packet )
     {
       if ( !IsStrEmpty(m_curr_status) )
          {
            char s[MAX_PATH];
            
            lstrcpy(s,m_curr_status);
            
            SYSTEMTIME st;
            GetLocalTime(&st);

            char t[MAX_PATH];
            wsprintf(t,"%02d:%02d",st.wHour,st.wMinute);
            
            StrReplaceI(s,"%TIME%",t);
            
            m_rshell->ShowMessage(s);
          }
     }
}


