
#include "include.h"



BOOL SearchParam(const char *s)
{
  for ( int n = 1; n < __argc; n++ )
      if ( !lstrcmpi(__argv[n],s) )
         return TRUE;

  return FALSE;
}


BOOL IsSilent()
{
  return SearchParam("-silent");
}


void Message(const char *s)
{
  if ( !IsSilent() )
     {
       printf("%s\n",s);
     }
}


int main()
{
  int rc = 1;
  
  CMyService oService;
  CServiceManager *sm = CServiceManager::Create(&oService);
  
  if ( SearchParam("-install") )
     {
       if ( sm->HighLevelInstall() )
          {
            Message("OK");
            rc = 0;
          }
       else
          {
            Message("failed");
          }
     }
  else
  if ( SearchParam("-uninstall") )
     {
       if ( sm->HighLevelUninstall() )
          {
            Message("OK");
            rc = 0;
          }
       else
          {
            Message("failed");
          }
     }
  else
  if ( SearchParam(PARM_PROCESS) )
     {
       SessionWorker();
       rc = 0;
     }
  else
     {
       rc = sm->HighLevelProcess() ? 0 : 1;
     }

  sm->Release();
  return rc;
}



