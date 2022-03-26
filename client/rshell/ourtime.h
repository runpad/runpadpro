
#ifndef __OURTIME_H__
#define __OURTIME_H__



typedef double OURTIME;   // in delphi format


void OurTimeToSystemTime(OURTIME d,SYSTEMTIME *st);
OURTIME SystemTimeToOurTime(const SYSTEMTIME *st);
OURTIME GetNowOurTime();



#endif

