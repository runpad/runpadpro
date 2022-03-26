
#ifndef __SOMEINFO_H__
#define __SOMEINFO_H__


class CConfigurator;
class CNetClient;

void PrepareSomeInfo(CNetCmd &cmd,const CConfigurator *_cfg,const CNetClient *_net);
void PrepareRollbackInfo(CNetCmd &cmd,CConfigurator *_cfg);


#endif
