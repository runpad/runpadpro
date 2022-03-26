
#include "include.h"



const char* GetParamValue(const char *parm)
{
  const char *rc = NULL;
  
  for ( int n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],parm) )
         {
           if ( n < __argc-1 )
              {
                rc = __argv[n+1];
              }
           else
              {
                rc = "";
              }

           break;
         }

  return rc;
}


void main()
{
  const char *s_port = GetParamValue("-port");
  int i_port = IsStrEmpty(s_port)?0:StrToInt(s_port);
  if ( i_port > 0 )
     {
       CMyService oService(i_port);
       CServiceManager *sm = CServiceManager::Create(&oService);
       sm->HighLevelProcess();
       sm->Release();
     }
}


