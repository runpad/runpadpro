
#include "include.h"

#include "a_wol.inc"



/*__declspec(noinline)*/ void UpdateEnvStrings(CNetCmd &dest,const char *src_buff,unsigned src_size)
{
  //USER_POLYBUFFER
  
  if ( src_buff && src_size )
     {
       if ( src_buff[src_size-1] == 0 )
          {
            if ( !dest.GetCmdBuffSize() )
               {
                 dest.AddBuff(src_buff,src_size);
               }
            else
               {
                 CNetCmd temp(dest.GetCmdId());
                 temp.AddBuff(src_buff,src_size);

                 const char *p = dest.GetCmdBuffPtr();
                 unsigned len = dest.GetCmdBuffSize();
                 assert(p);
                 assert(len);

                 if ( p[len-1] == 0 )
                    {
                      while ( len > 0 )
                      {
                        char *s = sys_copystring(p);
                        char *eq = StrStrI(s,"=");

                        if ( eq )
                           {
                             *eq = 0;
                             const char *name = s;
                             const char *value = eq+1;

                             if ( name[0] )
                                {
                                  if ( !temp.FindValueByName(name) )
                                     {
                                       temp.AddStringParm(name,value);
                                     }
                                }
                           }

                        sys_free(s);

                        len -= lstrlen(p)+1;
                        p += lstrlen(p)+1;
                      }

                      dest = temp;
                    }
               }
          }
     }
}


void AddLicInfoToEnv(CNetCmd &env)
{
  env.AddStringParm(NETPARM_S_LICORGANIZATION,LIC_DEMO_ORGANIZATION);
  env.AddStringParm(NETPARM_S_LICOWNER,LIC_DEMO_OWNER);
  env.AddIntParm(NETPARM_I_LICMACHINES,LIC_DEMO_MACHINES);
  env.AddStringParm(NETPARM_S_LICFEATURES,LIC_DEMO_FEAT);
}


void SmartThreadFinish(HANDLE &h)
{
  if ( h )
     {
       if ( WaitForSingleObject(h,0) == WAIT_TIMEOUT )
          {
            TerminateThread(h,0);
          }

       CloseHandle(h);
       h = NULL;
     }
}
