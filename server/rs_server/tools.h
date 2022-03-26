
#ifndef __TOOLS_H__
#define __TOOLS_H__



void UpdateEnvStrings(CNetCmd &dest,const char *src_buff,unsigned src_size);
void AddLicInfoToEnv(CNetCmd &env);
void SmartThreadFinish(HANDLE &h);

void WakeupOnLAN(const char *s_ip,const char *s_mac);



#endif
