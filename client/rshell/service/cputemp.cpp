
#include "include.h"

#include "cputemp_winbond.h"
#include "cputemp_ite.h"



static BOOL GetCPUTemperature(int *_out1,int *_out2,int *_out3)
{
  BOOL rc = FALSE;
  
  *_out1 = 0;
  *_out2 = 0;
  *_out3 = 0;

  HANDLE h = CreateFile("\\\\.\\giveio", GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
  if ( h == INVALID_HANDLE_VALUE )
     return rc;
  CloseHandle(h);

  int t1=0,t2=0,t3=0;
  
  __try
  {
    if ( !GetCPUTemp_ITE(&t1,&t2,&t3) )
       {
         GetCPUTemp_Winbond(&t1,&t2,&t3);  //Winbond is last
       }
  }
  __except ( EXCEPTION_EXECUTE_HANDLER )
  {
  }

  *_out1 = t1;
  *_out2 = t2;
  *_out3 = t3;

  rc = (t1 != 0 || t2 != 0 || t3 != 0);

  return rc;
}


static void GetCPUTempStringInternal(int temp,char *s)
{
  if ( s )
     {
       if ( temp == 0 || temp >= 128 )
          lstrcpy(s,"N/A");
       else
       if ( temp < 65 )
          wsprintf(s,"%d",temp);
       else
          wsprintf(s,"<font color=red><b>%d</b></font>",temp);
     }
}


static void GetCPUCoolerStringInternal(int cooler,char *s)
{
  if ( s )
     {
       if ( cooler == 0 )
          lstrcpy(s,"N/A");
       else
          wsprintf(s,"%d",cooler);
     }
}


void GetCPUTemperatureHTMLString(char *s1,char *s2,char *s3)
{
  if ( s1 || s2 || s3 )
     {
       int temp1=0,temp2=0,cooler=0;
       
       GetCPUTemperature(&temp1,&temp2,&cooler);

       if ( s1 )
          GetCPUTempStringInternal(temp1,s1);

       if ( s2 )
          GetCPUTempStringInternal(temp2,s2);

       if ( s3 )
          GetCPUCoolerStringInternal(cooler,s3);
     }
}
