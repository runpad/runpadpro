
#include "include.h"


// контент
CContent g_content;


// общие настройки
TPATH wait_server_path;
int wait_server_timeout;
BOOL only_one_cpu;
int shutdown_action;

// быстрое отключение
int fastexit_idle_timeout;
BOOL fastexit_use_keyboard;
BOOL fastexit_use_fixed_pwd;
TSTRING fastexit_fixed_pwd_md5;
BOOL fastexit_use_flash;
TLONGSTRING fastexit_flash_list;

// интерфейс: вид
int def_sheet_color;
int curr_theme2d;
TPATH curr_desktop_theme;
BOOL dont_show_theme_errors;
TSTRING html_status_text1;
TLONGSTRING html_status_text2;
BOOL icons_winstyle;
BOOL do_icon_highlight;
int ubericon_effect;
BOOL use_desk_shader;
BOOL high_quality_bg_video;
BOOL dont_show_empty_icons;
BOOL det_empty_icons_by_icon_path;
BOOL dont_show_icon_names;
BOOL use_system_icon_spacing;
int icon_spacing_w;
int icon_spacing_h;
int icon_size_h;
int icon_size_w;
int close_sheet_idle;
int min_grouped_windows;
BOOL disable_desktop_composition;
TCFGLIST2 user_tools;
BOOL sheet_init_maximize;
TSTRING startup_sheet_name;

// интерфейс: меню
BOOL winkey_enable;
BOOL vip_in_menu;
BOOL show_book_in_menu;
BOOL monitor_off_in_menu;
BOOL logoff_in_menu;
BOOL reboot_in_menu;
BOOL shutdown_in_menu;
BOOL gc_info_in_menu;
BOOL mycomp_in_menu;
BOOL calladmin_in_menu;

// безопасность: системные запреты
BOOL sysrestrict00;
BOOL sysrestrict01;
BOOL sysrestrict02;
BOOL sysrestrict03;
BOOL sysrestrict04;
BOOL sysrestrict05;
BOOL sysrestrict06;
BOOL sysrestrict07;
BOOL sysrestrict08;
BOOL sysrestrict09;
BOOL sysrestrict10;
BOOL sysrestrict11;
BOOL sysrestrict12;
BOOL sysrestrict13;
BOOL sysrestrict14;
BOOL sysrestrict15;
BOOL sysrestrict16;
BOOL sysrestrict17;
BOOL sysrestrict18;
BOOL sysrestrict19;
BOOL sysrestrict20;
BOOL sysrestrict21;
BOOL sysrestrict22;
BOOL sysrestrict23;
BOOL sysrestrict24;
BOOL sysrestrict25;
BOOL sysrestrict26;
BOOL sysrestrict27;
BOOL sysrestrict28;
BOOL sysrestrict29;

// безопасность: файловая система
BOOL restrict_copyhook;
BOOL restrict_shellexechook;
TSTRING protected_protos;
TLONGSTRING allowed_ext;
int disks_hidden;
int disks_disabled;
BOOL restrict_file_dialogs;
BOOL allow_newfolder_opensave;
TSTRING apps_opensave_prohibited;
BOOL allow_use_flash;
BOOL allow_use_diskette;
BOOL allow_use_cdrom;
TPATH net_flash;
TPATH net_diskette;
TPATH net_cdrom;
BOOL allow_flash_stat;
BOOL allow_dvd_stat;
int clean_user_folder;
TPATH user_folder_base;
TSTRING uf_format;
BOOL allow_run_from_folder_shortcuts;

// безопасность: окна, процессы и пр.
TCFGLIST2 disable_windows;
BOOL close_not_active_windows;
TCFGLIST1 disallow_run;
TCFGLIST1 allow_run;
BOOL disallow_power_keys;
BOOL disable_input_when_monitor_off;
BOOL safe_console;
BOOL safe_winamp;
BOOL safe_mplayerc;
BOOL safe_powerdvd;
BOOL safe_torrent;
BOOL safe_garena;

// безопасность: CTRL+ALT+DEL
BOOL use_cad_catcher;
BOOL cad_taskman;
BOOL cad_killall;
BOOL cad_gcinfo;
BOOL cad_reboot;
BOOL cad_shutdown;
BOOL cad_monitoroff;
BOOL cad_logoff;

// безопасность: трей
int max_vis_tray_icons;
BOOL safe_tray;
TCFGLIST1 safe_tray_icons;
TCFGLIST1 hidden_tray_icons;

// запуск ярлыков
BOOL allow_run_only_one;
BOOL protect_bodytools_when_nosql;
BOOL protect_run_when_nosql;
BOOL protect_in_safe_mode;
BOOL protect_run_at_startup;
BOOL use_blocker;
TPATH blocker_file;
int ssaver_idle;
TPATH alcohol_path;
TPATH daemon_path;
TPATH daemon_pro_path;
TCFGLIST2 lic_manager;

// запуск ярлыков: статистика
BOOL stat_enable;
int clear_stat_interval;
BOOL do_web_stat;
TSTRING stat_excl;

// оборудование
BOOL allow_printer_control;
BOOL allow_hwident_ibutton;

// файлы: перенаправление для VIP
BOOL redirect_sys_folders;
BOOL redirect_personal;
BOOL redirect_appdata;
BOOL redirect_localappdata;
TPATH personal_path;
TPATH vip_basefolder;
int vip_folder_limit;
BOOL force_viplogin_from_api;

// проводник
TCFGLIST2 addon_folders;
BOOL allow_save_to_addon_folders;
BOOL allow_drag_anywhere;
BOOL allow_write_to_removable;
TCFGLIST2 menu_ext;
TCFGLIST2 menu_ext_rev;
TPATH winrar_path;
BOOL delete_to_recycle;
BOOL disallow_copy_from_lnkfolder;
BOOL show_hiddens_in_bodyexpl;

// браузер IE: общие
BOOL use_bodytool_ie;
BOOL disallow_sites;
TCFGLIST1 disallowed_sites;
TCFGLIST1 allowed_sites;
TCFGLIST1 redirected_urls;
TSTRING redirection_url;
TSTRING ie_local_res;
TSTRING ie_disallowed_protos;
TSTRING safe_ie_exts;
TSTRING safe_ie_protos;
TPATH fav_path;
BOOL disallow_add2fav;
TSTRING ie_open_with_mp;
TSTRING ie_open_with_ext;
BOOL wb_flash_disable;
BOOL allow_ie_print;
int max_ie_windows;
BOOL ie_clean_history;
BOOL rus2eng_wb;
BOOL close_ie_when_nosheet;
BOOL ftp_enable;
BOOL protect_run_in_ie;
BOOL wb_search_bars;
BOOL disable_view_html;
BOOL ie_use_sett;
TSTRING ie_sett_proxy;
TSTRING ie_sett_port;
TSTRING ie_sett_autoconfig;
TSTRING ie_home_page;
TSTRING bodywb_caption;

// браузер IE: загрузчик
BOOL use_std_downloader;
TSTRING allowed_download_types;
BOOL use_allowed_download_types;
TSTRING std_downloader_sites;
int max_download_windows;
int max_download_size;
int download_speed_limit;
TSTRING download_autorun;
BOOL dont_show_download_speed;
BOOL allow_run_downloaded;

// утилиты: MediaPlayer
BOOL use_bodytool_mp;
TSTRING safe_mp_exts;
TSTRING safe_mp_exts_winamp;
TSTRING safe_mp_protos;
TPATH alternate_mp;

// утилиты: мобильный телефон / bluetooth
TCFGLIST2 mobile_content;
TSTRING mobile_files_audio;
TSTRING mobile_files_video;
TSTRING mobile_files_pictures;
BOOL mobile_bodyexpl_integration;
BOOL allow_bt_stat;
BOOL bt_integration;
TPATH net_bt_path;

// утилиты: запись дисков
BOOL allow_burn_stat;
BOOL burn_integration;
TSTRING law_protected_files;
TPATH net_burn_path;
TPATH on_burn_complete;

// утилиты: Mail
BOOL allow_mail_stat;
BOOL bodymail_integration;
TSTRING bodymail_smtp;
TSTRING bodymail_user;
TSTRING bodymail_password;
int bodymail_port;
BOOL bodymail_hardcoded;
TSTRING bodymail_from_name;
TSTRING bodymail_from_address;
TSTRING bodymail_footer;
TSTRING bodymail_to;

// утилиты: диспетчер задач
TCFGLIST1 hide_tm_programs;
BOOL safe_taskmgr;
BOOL safe_taskmgr2;
BOOL safe_taskmgr3;
BOOL kill_hidden_tasks;

// утилиты: прочие
BOOL use_bodytool_office;
BOOL protect_run_in_office;
BOOL ext_office_print;
BOOL show_office_menu;
BOOL use_bodytool_notepad;
TSTRING safe_notepad_exts;
BOOL use_bodytool_imgview;
BOOL use_bodytool_pdf;
BOOL show_pdf_panel;
BOOL use_bodytool_swf;
TSTRING inject_scan;
BOOL allow_scan_stat;
BOOL tray_indic;
BOOL tray_minimize_all;
BOOL tray_mixer;
BOOL tray_microphone;
BOOL allow_photocam;

// обслуживание: удаление
TCFGLIST1 delete_folders;
BOOL clean_temp_dir;
BOOL clean_ie_dir;
BOOL clean_cookies;
BOOL clear_recycle_bin;
BOOL clear_print_spooler;

// обслуживание: автозапуск
BOOL autoplay_cda;
TPATH autoplay_cda_cmd;
BOOL autoplay_dvd;
TPATH autoplay_dvd_cmd;
BOOL autoplay_cdr;
TPATH autoplay_cdr_cmd;
BOOL autoplay_flash;
TPATH autoplay_flash_cmd;

// обслуживание: автозагрузка
TSTRING welcome_path;
TCFGLIST2 autorun_items;
BOOL disable_autorun;
BOOL show_la_at_startup;
TPATH la_startup_path;

// обслуживание: volume control
int maxvol_master;  // 0-100
int maxvol_wave;    // 0-100
int minvol_master;  // 0-100
int minvol_wave;    // 0-100
BOOL maxvol_enable;

// обслуживание: mouse control
int adj_mouse_speed;
int adj_mouse_acc;
BOOL allow_mouse_adj;

// обслуживание: scandisk
BOOL do_scandisk;
int scandisk_hours;
int scandisk_disks;

// обслуживание: display mode
BOOL restore_dm_at_startup;
int def_vmode_width;
int def_vmode_height;
int def_vmode_bpp;
int display_freq;

// обслуживание: прочее
int turn_off_idle;
BOOL use_logoff_in_turn_off_idle;
TPATH client_restore;
BOOL use_time_limitation;
TSTRING time_limitation_intervals;
int time_limitation_action;


//////////////////////////////////////////////////
// comp_specific vars
//////////////////////////////////////////////////

// rollback
BOOL use_rollback;
int rollback_disks;
TCFGLIST1 rollback_excl;
BOOL used_another_rollback;

