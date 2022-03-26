
#include "include.h"

#include "ati/adl_sdk.h"
#include "nvidia/nvapi.h"

#include "gpu_ati.inc"
#include "gpu_nvidia.inc"



static BOOL GetGPUTemperature(int *_out)
{
  *_out = 0;
  
  int t = 0;
  if ( !GetGPUTemp_ATI(&t) )
     {
       if ( !GetGPUTemp_NVidia1(&t) )
          {
          //  GetGPUTemp_NVidia2(&t);   //deprecated
          }
     }

  *_out = t;
  
  return t != 0;
}


// same function in service
static void GetTempStringInternal(int temp,char *s)
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


void GetGPUTemperatureHTMLString(char *s)
{
  if ( s )
     {
       int temp=0;
       GetGPUTemperature(&temp);
       GetTempStringInternal(temp,s);
     }
}


