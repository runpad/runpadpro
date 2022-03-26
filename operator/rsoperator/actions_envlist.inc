
static CDynBuff env_list;



void UpdateEnvList(const char *buff,unsigned size)
{
  if ( buff && size )
     {
       if ( env_list.GetBuffSize() == 0 )
          {
            env_list.AddBuff(buff,size);
          }
       else
          {
            if ( size != env_list.GetBuffSize() )
               {
                 env_list.Clear();
                 env_list.AddBuff(buff,size);
               }
            else
               {
                 if ( memcmp(buff,env_list.GetBuffPtr(),size) )
                    {
                      env_list.Clear();
                      env_list.AddBuff(buff,size);
                    }
               }
          }
     }
  else
     {
       env_list.Clear();
     }
}


void ClearEnvList()
{
  env_list.Clear();
}


int GetEnvListCount()
{
  return env_list.GetBuffSize() >= sizeof(int) ? *(const int*)env_list.GetBuffPtr() : 0;
}


void GetEnvListAt(int idx,TENVENTRY *out)
{
  if ( out )
     {
       ZeroMemory(out,sizeof(*out));
       out->guid = NETGUID_UNKNOWN;

       int count = GetEnvListCount();
       if ( idx >= 0 && idx < count )
          {
            const char *buff = env_list.GetBuffPtr();
            int size = env_list.GetBuffSize();

            if ( buff && size )
               {
                 if ( size >= sizeof(int) )
                    {
                      buff += sizeof(int); //skip count
                      size -= sizeof(int);

                      int n = 0;
                      
                      while ( size > 0 )
                      {
                        if ( size < sizeof(int) )
                           break;
                        int delta = *(const int*)buff;
                        buff += sizeof(int);
                        size -= sizeof(int);

                        if ( delta < 0 )
                           break;

                        if ( delta > size )
                           break;

                        if ( n == idx )
                           {
                             if ( delta > 0 )
                                {
                                  CNetCmd env(NETCMD_GETENV_ACK);
                                  env.AddBuff(buff,delta);

                                  out->guid = env.GetParmAsInt(NETPARM_I_GUID,NETGUID_UNKNOWN);
                                  lstrcpyn(out->class_name,env.GetParmAsString(NETPARM_S_CLASS,""),MAX_PATH);
                                  lstrcpyn(out->ip,env.GetParmAsString(NETPARM_S_IP,""),MAX_PATH);
                                  lstrcpyn(out->mac,env.GetParmAsString(NETPARM_S_MAC,""),MAX_PATH);
                                  lstrcpyn(out->runpad_ver,env.GetParmAsString(NETPARM_S_VERSION,""),MAX_PATH);
                                  lstrcpyn(out->machine_loc,env.GetParmAsString(NETPARM_S_MACHINELOC,""),MAX_PATH);
                                  lstrcpyn(out->machine_desc,env.GetParmAsString(NETPARM_S_MACHINEDESC,""),MAX_PATH);
                                  lstrcpyn(out->comp_name,env.GetParmAsString(NETPARM_S_COMPNAME,""),MAX_PATH);
                                  lstrcpyn(out->domain,env.GetParmAsString(NETPARM_S_DOMAIN,""),MAX_PATH);
                                  lstrcpyn(out->user_name,env.GetParmAsString(NETPARM_S_USERNAME,""),MAX_PATH);
                                  lstrcpyn(out->vip_session,env.GetParmAsString(NETPARM_S_VIPSESSION,""),MAX_PATH);
                                  lstrcpyn(out->active_task,env.GetParmAsString(NETPARM_S_ACTIVETASK,""),MAX_PATH);
                                  out->monitor_state = env.GetParmAsBool(NETPARM_B_MONITORSTATE,TRUE);
                                  out->blocked_state = env.GetParmAsBool(NETPARM_B_BLOCKEDSTATE,FALSE);
                                  out->is_rfm = env.GetParmAsBool(NETPARM_B_RFMSERVICE,FALSE);
                                  out->is_rd = env.GetParmAsBool(NETPARM_B_RDSERVICE,FALSE);
                                  out->is_rollback = env.GetParmAsBool(NETPARM_B_ISROLLBACK,FALSE);
                                }
                             break;
                           }
                        else
                           {
                             buff += delta;
                             size -= delta;
                           }

                        n++;
                      }
                    }
               }
          }
     }
}


