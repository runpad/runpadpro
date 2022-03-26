
#ifndef ___G_VARS_H___
#define ___G_VARS_H___


#include "types.h"


// global
extern int curr_lang;

// API functions
extern BOOL (__cdecl *GetInputTextPos)(HWND parent,char pwdchar,int x,int y,int w,int h,int maxlen,const char *text,char *out);
extern BOOL (__cdecl *ShowStartupMasterDialog)(void*);
extern BOOL (__cdecl *ShowSaverWindow)(HWND,int,const char*,char*);
extern HWND (__cdecl *Desk_Create)(void *conn,const char *url);
extern void (__cdecl *Desk_Destroy)();
extern BOOL (__cdecl *Desk_IsVisible)();
extern void (__cdecl *Desk_Show)();
extern void (__cdecl *Desk_Hide)();
extern void (__cdecl *Desk_Repaint)();
extern void (__cdecl *Desk_Refresh)();
extern void (__cdecl *Desk_BringToBottom)();
extern void (__cdecl *Desk_Navigate)(const char *url);
extern void (__cdecl *Desk_OnDisplayChange)();
extern void (__cdecl *Desk_OnEndSession)();
extern void (__cdecl *Desk_OnStatusStringChanged)();
extern void (__cdecl *Desk_OnActiveSheetChanged)();
extern void (__cdecl *Desk_OnPageShaded)();

// API vars
extern HINSTANCE our_instance;
extern TPATH our_currpath;
extern BOOL is_vista;
extern BOOL is_w2k;
extern unsigned msgloop_starttime;
extern HCURSOR cur_wait;
extern HCURSOR cur_arrow;
extern HCURSOR cur_drag;
extern BOOL is_wtsenumproc_bug_present;

// dynamically changed vars
extern THEME theme;
extern int is_volume_mute;
extern MSG last_processed_message;
extern TSTRING vip_session;
extern TPATH vip_folder;
extern TPATH user_folder;
extern BOOL protect_run_from_api;
extern BOOL sql_base_ready;
extern BOOL monitor_off;

// license vars
extern TSTRING lic_feat;

// config related vars
extern int g_cfg_recv_type;
extern TSTRING g_cfg_recv_msg;

// machine-config vars
extern int machine_type;
extern TSTRING machine_loc;
extern TSTRING machine_desc;
extern TSTRING server_ip_internal;
extern int def_lang;
extern BOOL show_langs_at_startup;
extern TSTRING allowed_services_ips;



#endif
