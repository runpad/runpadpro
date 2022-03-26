
#include "include.h"



void OurTimeToSystemTime(OURTIME d,SYSTEMTIME *st)
{
  if ( st )
     {
       __int64 delta = (__int64)(d*864000000000.0);

       const int n_year = 1899;
       const int n_month = 12;
       const int n_day = 30;
       const int n_hour = 0;
       const int n_min = 0;
       const int n_sec = 0;

       const SYSTEMTIME n_st = {n_year,n_month,0,n_day,n_hour,n_min,n_sec,0};

       __int64 n_ft = 0;
       
       SystemTimeToFileTime(&n_st,(FILETIME*)&n_ft);

       __int64 i_ft = n_ft + delta;

       FileTimeToSystemTime((const FILETIME*)&i_ft,st);
     }
}


OURTIME SystemTimeToOurTime(const SYSTEMTIME *st)
{
  double rc = 0.0;
  
  if ( st )
     {
       int i_year = st->wYear;
       int i_month = st->wMonth;
       int i_day = st->wDay;
       int i_hour = st->wHour;
       int i_min = st->wMinute;
       int i_sec = st->wSecond;
       int i_ms = st->wMilliseconds;

       const int n_year = 1899;
       const int n_month = 12;
       const int n_day = 30;
       const int n_hour = 0;
       const int n_min = 0;
       const int n_sec = 0;
       const int n_ms = 0;

       const SYSTEMTIME i_st = {i_year,i_month,0,i_day,i_hour,i_min,i_sec,i_ms};
       const SYSTEMTIME n_st = {n_year,n_month,0,n_day,n_hour,n_min,n_sec,n_ms};

       __int64 i_ft = 0, n_ft = 0;

       SystemTimeToFileTime(&i_st,(FILETIME*)&i_ft);
       SystemTimeToFileTime(&n_st,(FILETIME*)&n_ft);

       __int64 delta = i_ft - n_ft;

       rc = (double)delta/864000000000.0;
     }

  return rc;
}


OURTIME GetNowOurTime()
{
  SYSTEMTIME st;
  GetLocalTime(&st);

  return SystemTimeToOurTime(&st);
}


