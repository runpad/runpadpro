
#include "include.h"



CConfigurator::CConfigurator(int _machine_type,int _lang)
{
  m_machine_type = _machine_type;
  m_lang = _lang;

  m_starttime = GetTickCount();

  lstrcpy(s_licfeat,"");

  b_sett_set = FALSE;
  b_lic_set = FALSE;

  m_int_state = STATE_WAITING;

  m_lasterror = ERR_NONE;
  lstrcpy(s_lasterror,"");
}


CConfigurator::~CConfigurator()
{
}


// must be called before each call to GetLicFeat() or GetCfgVar() !!!!!
BOOL CConfigurator::CanAccess()
{
  if ( b_sett_set && b_lic_set )
     {
       return TRUE;
     }

  if ( GetTickCount() - m_starttime > GetWaitTime() )
     {
       // try to get from cache, or default

       if ( !b_sett_set )
          {
            if ( !ReadSettingsFromCache(m_lang,m_machine_type) )
               {
                 CfgReadConfig(NULL,0,m_lang,m_machine_type); //default settings
                 m_int_state = STATE_FROMDEF;
               }
            else
               {
                 m_int_state = STATE_FROMCACHE;
               }

            b_sett_set = TRUE;
          }

       if ( !b_lic_set )
          {
            if ( !ReadLicFeatFromCache(s_licfeat,sizeof(s_licfeat)) )
               {
                 lstrcpy(s_licfeat,""); //default is nothing
               }

            b_lic_set = TRUE;
          }

       return TRUE;
     }
  else
     {
       return FALSE;
     }
}


const char* CConfigurator::GetLicFeat()
{
  assert(CanAccess());

  return s_licfeat;
}


void CConfigurator::OnCfgReceived(const void *buff,int buff_size)
{
  if ( !b_sett_set )  //only first is accepted
     {
       if ( buff_size == 0 )
          {
            if ( !ReadSettingsFromCache(m_lang,m_machine_type) )
               {
                 CfgReadConfig(NULL,0,m_lang,m_machine_type); //default settings
                 m_int_state = STATE_FROMDEF;
               }
            else
               {
                 m_int_state = STATE_FROMCACHE;
               }
          }
       else
          {
            CfgReadConfig(buff,buff_size,m_lang,m_machine_type);
            WriteSettingsToCache(buff,buff_size);
            m_int_state = STATE_FROMSERVER;
          }

       b_sett_set = TRUE;
     }
}


void CConfigurator::OnServerVarsReceived(const CNetCmd &cmd)
{
  if ( !b_lic_set )  //only first is accepted
     {
       const char *s = cmd.GetParmAsString(NETPARM_S_LICFEATURES,"");

       lstrcpyn(s_licfeat,s,sizeof(s_licfeat));
       WriteLicFeatToCache(s_licfeat);

       b_lic_set = TRUE;
     }
}


unsigned CConfigurator::GetWaitTime() const
{
  return (m_machine_type == MACHINE_TYPE_OPERATOR || m_machine_type == MACHINE_TYPE_HOME) ? 60000 : 15000;
}


int CConfigurator::GetState() const
{
  return (!b_sett_set || !b_lic_set) ? STATE_WAITING : m_int_state;
}


void CConfigurator::SetLastErrorI(int err)
{
  m_lasterror = err;
}


void CConfigurator::SetLastErrorS(const char *err)
{
  lstrcpyn(s_lasterror,err?err:"",sizeof(s_lasterror));
}

