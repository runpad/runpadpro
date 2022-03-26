
#ifndef __NET_H__
#define __NET_H__



void NetInit();
void NetDone();
BOOL NetFlush(unsigned timeout);
BOOL IsNetConnectEvent();
BOOL IsNetDisconnectEvent();
BOOL NetIsConnected();
BOOL NetSend(const CNetCmd& cmd,unsigned dest_guid=NETGUID_SERVER);
BOOL NetGet(CNetCmd& cmd,unsigned *_src_guid);
void NetProcessing();




#endif

