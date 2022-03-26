
#include "include.h"

// global
int curr_lang = 0; //russian

// API functions
BOOL (__cdecl *GetInputTextPos)(HWND parent,char pwdchar,int x,int y,int w,int h,int maxlen,const char *text,char *out);
BOOL (__cdecl *ShowStartupMasterDialog)(void*) = NULL;
BOOL (__cdecl *ShowSaverWindow)(HWND,int,const char*,char*) = NULL;
HWND (__cdecl *Desk_Create)(void *conn,const char *url) = NULL;
void (__cdecl *Desk_Destroy)() = NULL;
BOOL (__cdecl *Desk_IsVisible)() = NULL;
void (__cdecl *Desk_Show)() = NULL;
void (__cdecl *Desk_Hide)() = NULL;
void (__cdecl *Desk_Repaint)() = NULL;
void (__cdecl *Desk_Refresh)() = NULL;
void (__cdecl *Desk_BringToBottom)() = NULL;
void (__cdecl *Desk_Navigate)(const char *url) = NULL;
void (__cdecl *Desk_OnDisplayChange)() = NULL;
void (__cdecl *Desk_OnEndSession)() = NULL;
void (__cdecl *Desk_OnStatusStringChanged)() = NULL;
void (__cdecl *Desk_OnActiveSheetChanged)() = NULL;
void (__cdecl *Desk_OnPageShaded)() = NULL;


// API vars
HINSTANCE our_instance = NULL;
TPATH our_currpath = "";
BOOL is_vista = FALSE;
BOOL is_w2k = FALSE;
unsigned msgloop_starttime = 0;
HCURSOR cur_wait = NULL;
HCURSOR cur_arrow = NULL;
HCURSOR cur_drag = NULL;
BOOL is_wtsenumproc_bug_present = FALSE;

// dynamically changed vars
THEME theme = {0,};
int is_volume_mute = -1;
MSG last_processed_message = {NULL,WM_NULL,0,0,0,{0,0}};
TSTRING vip_session = "";
TPATH vip_folder = "";
TPATH user_folder = "";
BOOL protect_run_from_api = FALSE;
BOOL sql_base_ready = FALSE;
BOOL monitor_off = FALSE;

// license vars
TSTRING lic_feat = "";

// config related vars
int g_cfg_recv_type = 0;
TSTRING g_cfg_recv_msg = "";

// machine-config vars
int machine_type;
TSTRING machine_loc = "";
TSTRING machine_desc = "";
TSTRING server_ip_internal = ""; //used only in some functions
int def_lang;
BOOL show_langs_at_startup;
TSTRING allowed_services_ips;

