
#include <windows.h>
#include <wininet.h>
#include "m_tplink.h"



BOOL Restart_TPLink(const char *host)
{
  BOOL rc = FALSE;
  
  const char *method = "GET";
  const char *url = "/rebootinfo.cgi";
  const char *headers = "Authorization: Basic YWRtaW46YWRtaW4=\r\n";
  
  HINTERNET hInternet = InternetOpenA("Test",INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0);
  if ( hInternet )
     {
       HINTERNET hConnect = InternetConnectA(hInternet,host,INTERNET_DEFAULT_HTTP_PORT,NULL,NULL,INTERNET_SERVICE_HTTP,0,0);
       if ( hConnect )
          {
            HINTERNET hReq = HttpOpenRequestA(hConnect,method,url,NULL,NULL,NULL,0,0);
            if ( hReq )
               {
                 if ( HttpSendRequestA(hReq,headers,-1,NULL,0) )
                    {
                      rc = TRUE;
                    }

                 InternetCloseHandle(hReq);
               }

            InternetCloseHandle(hConnect);
          }

       InternetCloseHandle(hInternet);
     }

  return rc;
}

