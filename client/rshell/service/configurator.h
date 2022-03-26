
#ifndef __CONFIGURATOR_H__
#define __CONFIGURATOR_H__



class CConfigurator
{
  public:
          enum {
           STATE_WAITING,      // waiting for settings retrieval
           STATE_FROMCACHE,    // settings was retrieved from local cache
           STATE_FROMDEF,      // settings was set as default settings
           STATE_FROMSERVER,   // settings was received fro mserver
          };

          enum {
           ERR_NONE,           // no error
           ERR_NOTCONNECTED,   // not connected to server
           ERR_NORESPONCE,     // no answer from server
           ERR_DBNOTREADY,     // SQL-DB not ready
           ERR_OUTOFLICENSE,   // licensing error
           ERR_SERVER,         // other error (maybe rules)
          };
          
  private:
          
          int m_machine_type;
          int m_lang;
          unsigned m_starttime;

          char s_licfeat[MAX_PATH];
          
          BOOL b_sett_set;  // received, read from cache, or set default
          BOOL b_lic_set;   // received, read from cache, or set default

          int m_int_state; // used only with b_sett_set, b_lic_set

          int m_lasterror;
          char s_lasterror[MAX_PATH];

  public:
          CConfigurator(int _machine_type,int _lang);
          ~CConfigurator();

          BOOL CanAccess();  // must be called before each call to GetLicFeat() or GetCfgVar() !!!!!

          const char* GetLicFeat();
          template<class _T>
          const _T& GetCfgVar(const _T& v);

          void OnCfgReceived(const void *buff,int buff_size);
          void OnServerVarsReceived(const CNetCmd &cmd);

          int GetState() const;

          int GetLastErrorI() const { return m_lasterror; }
          const char* GetLastErrorS() const { return s_lasterror; }
          void SetLastErrorI(int err);
          void SetLastErrorS(const char *err);

  private:
          unsigned GetWaitTime() const;

};


#include "configurator.hpp"


#endif
