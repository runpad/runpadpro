
#ifndef __ACTIONS_H__
#define __ACTIONS_H__


typedef struct {
int guid;
char class_name[MAX_PATH];
char ip[MAX_PATH];
char mac[MAX_PATH];
char runpad_ver[MAX_PATH];
char machine_loc[MAX_PATH];
char machine_desc[MAX_PATH];
char comp_name[MAX_PATH];
char domain[MAX_PATH];
char user_name[MAX_PATH];
char vip_session[MAX_PATH];
char active_task[MAX_PATH];
BOOL monitor_state;
BOOL blocked_state;
BOOL is_rfm;
BOOL is_rd;
BOOL is_rollback;
} TENVENTRY;


void ExecFunction(int fid,const TENVENTRY *list,int listcount);
void ProcessReceivedCmd(const CNetCmd &cmd,unsigned src_guid);

void UpdateEnvList(const char *buff,unsigned size);
void ClearEnvList();
int GetEnvListCount();
void GetEnvListAt(int idx,TENVENTRY *out);

void WakeupOnLAN(const char *ip,const char *mac);



#endif
