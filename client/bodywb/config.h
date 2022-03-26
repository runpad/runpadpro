

typedef char TSTRING[MAX_PATH];
typedef char TPATH[MAX_PATH];

typedef struct {
int msg_flash_notify;
int msg_runprogram;
int msg_site_restrict1;
int msg_site_restrict2;
int msg_shellexecute;

TSTRING regpath;

BOOL use_std_downloader;
int max_download_windows;
int max_download_size;
BOOL use_allowed_download_types;
TSTRING allowed_download_types;
TSTRING download_autorun;
BOOL allow_run_downloaded;
BOOL dont_show_download_speed;
int download_speed_limit;
BOOL wb_flash_disable;
TSTRING ie_home_page;
BOOL protect_run_in_ie;
int max_ie_windows;
BOOL ie_clean_history;
BOOL allow_ie_print;
BOOL disallow_add2fav;
BOOL disable_view_html;
TSTRING bodywb_caption;
BOOL rus2eng_wb;
BOOL wb_search_bars;
TPATH fav_path;
BOOL bodymail_integration;
} TCONFIG;


extern TCONFIG g_config;


extern void ReadConfig(void);
