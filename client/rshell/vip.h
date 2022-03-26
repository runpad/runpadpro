
#ifndef ___VIP_H___
#define ___VIP_H___


void OnBodyVipAck(const CNetCmd &cmd,unsigned src_guid);
BOOL CloseVIPSession(BOOL silent);
BOOL LoginVIPSession(BOOL new_user,const char *s_login,const char *s_pass,BOOL silent);
BOOL LoginVIPSessionForce(const char *s_login,BOOL silent);
void M_Vipsession(void);
void VipOnHWIdent(CHWIdent::EHWIdentDevice device,const char *device_id);



#endif
