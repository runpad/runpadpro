
#include <windows.h>
#include <shlwapi.h>
#include "tools.h"
#include "config.h"


#define REGPATH   "Software\\RunpadProShell"

TCONFIG g_config = 
{
  WM_USER+191, 
  WM_USER+118, 
  WM_USER+172, 
  WM_USER+101, 
  WM_USER+166, 

  REGPATH,

  0,
};


static const struct {
const char *name;
int type;
void *value;
int def;
} vars[] =
{
  {"use_std_downloader",0,&g_config.use_std_downloader,FALSE}, 
  {"max_download_windows",0,&g_config.max_download_windows,0},  
  {"max_download_size",0,&g_config.max_download_size,0}, 
  {"use_allowed_download_types",0,&g_config.use_allowed_download_types,FALSE}, 
  {"allowed_download_types",1,g_config.allowed_download_types,(int)""}, 
  {"download_autorun",1,g_config.download_autorun,(int)""}, 
  {"allow_run_downloaded",0,&g_config.allow_run_downloaded,FALSE}, 
  {"dont_show_download_speed",0,&g_config.dont_show_download_speed,FALSE}, 
  {"download_speed_limit",0,&g_config.download_speed_limit,0}, 
  {"wb_flash_disable",0,&g_config.wb_flash_disable,FALSE}, 
  {"ie_home_page",1,g_config.ie_home_page,(int)""}, 
  {"protect_run_in_ie",0,&g_config.protect_run_in_ie,TRUE}, 
  {"max_ie_windows",0,&g_config.max_ie_windows,0}, 
  {"ie_clean_history",0,&g_config.ie_clean_history,TRUE}, 
  {"allow_ie_print",0,&g_config.allow_ie_print,FALSE}, 
  {"disallow_add2fav",0,&g_config.disallow_add2fav,FALSE}, 
  {"disable_view_html",0,&g_config.disable_view_html,FALSE}, 
  {"bodywb_caption",1,g_config.bodywb_caption,(int)"%TITLE% - %APP%"}, 
  {"rus2eng_wb",0,&g_config.rus2eng_wb,FALSE}, 
  {"wb_search_bars",0,&g_config.wb_search_bars,TRUE}, 
  {"fav_path",1,g_config.fav_path,(int)""}, 
  {"bodymail_integration",0,&g_config.bodymail_integration,TRUE}, 
};



void ReadConfig(void)
{
  int n;

  for ( n = 0; n < sizeof(vars)/sizeof(vars[0]); n++ )
      {
        if ( vars[n].type )
           {
             ReadRegStr(HKEY_CURRENT_USER,REGPATH,vars[n].name,vars[n].value,(const char *)vars[n].def);
           }
        else
           {
             *(int*)vars[n].value = ReadRegDword(HKEY_CURRENT_USER,REGPATH,vars[n].name,vars[n].def);
           }
      }
}


