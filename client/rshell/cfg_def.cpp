
#include "include.h"


#ifdef LS
#undef LS
#endif

#define LS(id,lang) _LS(id,lang)

static const char* _LS(int id,int lang)
{
  return id == -1 ? NULL : GetLangStrByLangId(lang,id);
}

static const char* _LS(const char* id,int lang)
{
  return id == NULL ? NULL : ((unsigned)id <= 0xFFFF ? GetLangStrByLangId(lang,(int)id) : id);
}

static const char* _LS(DWORD_PTR id,int lang)
{
  return id == NULL ? NULL : ((unsigned)id <= 0xFFFF ? GetLangStrByLangId(lang,(int)id) : (const char*)id);
}




enum {
CFG_TYPE_NONE = 0,
CFG_TYPE_BOOL,
CFG_TYPE_INT,
CFG_TYPE_PATH,
CFG_TYPE_STRING,
CFG_TYPE_LONGSTRING,
CFG_TYPE_LIST1,
CFG_TYPE_LIST2,
CFG_TYPE_CONTENT,
};


typedef struct {
TSTRING s_name;
TPATH s_icon_path;
int i_color;
int i_bg_color;
TPATH s_bg_pic;
TPATH s_bg_thumb_pic;
int i_time_min;
int i_time_max;
TSTRING s_vip_users;
TPATH s_rules;
BOOL is_internet_sheet;
} TSHEETVARS;

typedef struct {
TSTRING s_name;
TPATH s_exe;
TSTRING s_arg;
TPATH s_cwd;
TPATH s_icon_path;
int i_icon_idx;
TSTRING s_pwd;
BOOL b_allow_only_one;
TSTRING s_runas_domain;
TSTRING s_runas_user;
TSTRING s_runas_pwd;
int i_show_cmd;
int i_vcd_num;
TPATH s_vcd;
TLONGSTRING s_saver;
TPATH s_sshot;
TLONGSTRING s_desc;
TLONGSTRING s_script1;
TSTRING s_group;
TPATH s_floatlic;
} TSHORTCUTVARS;



// constants for sheet and shortcut
#define S_SH_S_NAME                   "s_name"
#define S_SH_S_ICON_PATH              "s_icon_path"
#define S_SH_I_COLOR                  "i_color"
#define S_SH_I_BG_COLOR               "i_bg_color"
#define S_SH_S_BG_PIC                 "s_bg_pic"
#define S_SH_S_BG_THUMB_PIC           "s_bg_thumb_pic"
#define S_SH_I_TIME_MIN               "i_time_min"
#define S_SH_I_TIME_MAX               "i_time_max"
#define S_SH_S_VIP_USERS              "s_vip_users"
#define S_SH_S_RULES                  "s_rules"
#define S_SH_IS_INTERNET_SHEET        "is_internet_sheet"
#define S_SH_S_EXE                    "s_exe"
#define S_SH_S_ARG                    "s_arg"
#define S_SH_S_CWD                    "s_cwd"
#define S_SH_I_ICON_IDX               "i_icon_idx"
#define S_SH_S_PWD                    "s_pwd"
#define S_SH_B_ALLOW_ONLY_ONE         "b_allow_only_one"
#define S_SH_S_RUNAS_DOMAIN           "s_runas_domain"
#define S_SH_S_RUNAS_USER             "s_runas_user"
#define S_SH_S_RUNAS_PWD              "s_runas_pwd"
#define S_SH_I_SHOW_CMD               "i_show_cmd"
#define S_SH_I_VCD_NUM                "i_vcd_num"
#define S_SH_S_VCD                    "s_vcd"
#define S_SH_S_SAVER                  "s_saver"
#define S_SH_S_SSHOT                  "s_sshot"
#define S_SH_S_DESC                   "s_desc"
#define S_SH_S_SCRIPT1                "s_script1"
#define S_SH_S_GROUP                  "s_group"
#define S_SH_S_FLOATLIC               "s_floatlic"



typedef struct {
int name_id;
const char *icon_path;
int color;
int bg_color;
const char *bg_pic;
const char *bg_thumb_pic;
int time_min;
int time_max;
const char *vip_users;
int rules_id;
BOOL is_internet;
} TDEFSHEET;


static const TDEFSHEET def_sheet_action         = {3118,NULL,RGB(249,135,60),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid01.wmv","%RS_FOLDER%\\default\\bg\\pic01_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_internet       = {3119,NULL,RGB(94,204,51),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid02.wmv","%RS_FOLDER%\\default\\bg\\pic02_resize.jpg",0,24,NULL,-1,TRUE};
static const TDEFSHEET def_sheet_rpg            = {3120,NULL,RGB(94,196,55),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid03.wmv","%RS_FOLDER%\\default\\bg\\pic03_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_adults         = {3121,"%RS_FOLDER%\\default\\icons\\icon01.ico",RGB(244,165,45),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid04.wmv","%RS_FOLDER%\\default\\bg\\pic04_resize.jpg",23,6,NULL,3127,FALSE};
static const TDEFSHEET def_sheet_music          = {3122,NULL,RGB(243,140,65),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vplugins\\vp_voxel.dll","%RS_FOLDER%\\default\\bg\\pic05_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_programs       = {3123,NULL,RGB(255,255,255),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid06.wmv","%RS_FOLDER%\\default\\bg\\pic06_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_simulators     = {3124,NULL,RGB(106,172,156),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid07.wmv","%RS_FOLDER%\\default\\bg\\pic07_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_strategies     = {3125,NULL,RGB(171,164,163),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid08.wmv","%RS_FOLDER%\\default\\bg\\pic08_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_films          = {3126,NULL,RGB(131,226,217),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\vid09.wmv","%RS_FOLDER%\\default\\bg\\pic09_resize.jpg",0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_programs_ts    = {3123,NULL,RGB(255,255,255),0xA0A0A0,NULL,NULL,0,24,NULL,-1,FALSE};
static const TDEFSHEET def_sheet_programs_other = {3123,NULL,RGB(255,255,255),0xA0A0A0,"%RS_FOLDER%\\default\\bg\\pic06.jpg","%RS_FOLDER%\\default\\bg\\pic06_resize.jpg",0,24,NULL,-1,FALSE};


typedef struct {
int name_id;
const char *exe;
const char *arg;
int group_id;
int desc_id;
} TDEFSHORTCUT;

static const TDEFSHORTCUT def_shortcut_00 =
    { 3128,
      "http://www.runpad-shell.com",NULL,
      -1,
      -1 };
static const TDEFSHORTCUT def_shortcut_01 =
    { 3129,
      "%RS_FOLDER%\\bodywb.exe",NULL,
      3221,
      3130 };
static const TDEFSHORTCUT def_shortcut_02 =
    { 3131,
      "%RS_FOLDER%\\bodywb.exe","-simple http://www.runpad-shell.com",
      3221,
      3132 };
static const TDEFSHORTCUT def_shortcut_03 =
    { 3133,
      "%RS_FOLDER%\\bodymail.exe",NULL,
      3221,
      3134 };
static const TDEFSHORTCUT def_shortcut_04 =
    { 3135,
      "%RS_FOLDER%\\bodyexpl.exe",NULL,
      3222,
      3136 };
static const TDEFSHORTCUT def_shortcut_05 =
    { 3137,
      "%RS_FOLDER%\\bodyexpl.exe",NULL,
      3222,
      3138 };
static const TDEFSHORTCUT def_shortcut_06 =
    { 3139,
      "%RS_FOLDER%\\bodywb.exe",NULL,
      3221,
      3140 };
static const TDEFSHORTCUT def_shortcut_07 =
    { 3141,
      "%RS_FOLDER%\\bodyword.exe",NULL,
      3222,
      3142 };
static const TDEFSHORTCUT def_shortcut_08 =
    { 3143,
      "%RS_FOLDER%\\bodyexcel.exe",NULL,
      3222,
      3144 };
static const TDEFSHORTCUT def_shortcut_09 =
    { 3145,
      "%RS_FOLDER%\\bodynotepad.exe",NULL,
      3222,
      3146 };
static const TDEFSHORTCUT def_shortcut_10 =
    { 3147,
      "%RS_FOLDER%\\bodytm.exe",NULL,
      3225,
      3148 };
static const TDEFSHORTCUT def_shortcut_11 =
    { 3149,
      "%RS_FOLDER%\\bodymp.exe",NULL,
      3223,
      3150 };
static const TDEFSHORTCUT def_shortcut_12 =
    { 3151,
      "%RS_FOLDER%\\bodyimgview.exe",NULL,
      3223,
      3152 };
static const TDEFSHORTCUT def_shortcut_13 =
    { 3153,
      "%RS_FOLDER%\\bodyburn.exe",NULL,
      3224,
      3154 };
static const TDEFSHORTCUT def_shortcut_14 =
    { 3155,
      "%RS_FOLDER%\\bodyiso.exe",NULL,
      3224,
      3156 };
static const TDEFSHORTCUT def_shortcut_15 =
    { 3157,
      "%RS_FOLDER%\\bodywinamp.exe",NULL,
      3223,
      3158 };
static const TDEFSHORTCUT def_shortcut_16 =
    { 3159,
      "%RS_FOLDER%\\bodympc.exe",NULL,
      3223,
      3160 };
static const TDEFSHORTCUT def_shortcut_17 =
    { 3161,
      "%RS_FOLDER%\\bodypdvd.exe",NULL,
      3223,
      3162 };
static const TDEFSHORTCUT def_shortcut_18 =
    { 3163,
      "%RS_FOLDER%\\bodyacro.exe",NULL,
      3222,
      3164 };
static const TDEFSHORTCUT def_shortcut_19 =
    { 3165,
      "%RS_FOLDER%\\bodyflash.exe",NULL,
      3223,
      3166 };
static const TDEFSHORTCUT def_shortcut_20 =
    { 3167,
      "%RS_FOLDER%\\bodyscan.exe","-noui",
      3224,
      3168 };
static const TDEFSHORTCUT def_shortcut_21 =
    { 3169,
      "%RS_FOLDER%\\bodyscan.exe",NULL,
      3224,
      3170 };
static const TDEFSHORTCUT def_shortcut_22 =
    { 3171,
      "%RS_FOLDER%\\bodymail.exe",NULL,
      3221,
      3172 };
static const TDEFSHORTCUT def_shortcut_23 =
    { 3173,
      "%RS_FOLDER%\\bodybtw.exe",NULL,
      3224,
      3174 };
static const TDEFSHORTCUT def_shortcut_24 =
    { 3175,
      "%RS_FOLDER%\\bodymobile.exe",NULL,
      3224,
      3176 };
static const TDEFSHORTCUT def_shortcut_25 =
    { 3177,
      "%RS_FOLDER%\\rsspoolcleaner.exe",NULL,
      3225,
      3178 };
static const TDEFSHORTCUT def_shortcut_26 =
    { 3179,
      "%RS_FOLDER%\\bodymouse.exe",NULL,
      3225,
      3180 };
static const TDEFSHORTCUT def_shortcut_27 =
    { 3214,
      "%RS_FOLDER%\\bodycam.exe",NULL,
      3224,
      3215 };
static const TDEFSHORTCUT def_shortcut_28 =
    { 3217,
      "%RS_FOLDER%\\modem_restart.exe",NULL,
      3225,
      3218 };
static const TDEFSHORTCUT def_shortcut_29 =
    { 3128,
      "http://www.runpad-shell.com",NULL,
      3221,
      -1 };
static const TDEFSHORTCUT def_shortcut_30 =
    { 3236,
      "%RS_FOLDER%\\bodyrecycle.exe",NULL,
      3222,
      3237 };



typedef struct {
int machine_type_mask;
const TDEFSHEET *sheet;
const TDEFSHORTCUT *shortcut;
} TDEFCONTENTITEM;


static const TDEFCONTENTITEM def_content[] = 
{
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_29 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_04 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_05 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_30 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_06 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_07 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_08 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_09 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_10 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_11 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_12 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_13 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_14 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_15 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_16 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_17 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_18 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_19 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_25 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_20 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_21 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_22 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_23 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_24 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_26 },
    { MACHINE_TYPE_GAMECLUB|MACHINE_TYPE_INETCAFE|MACHINE_TYPE_HOME,
      &def_sheet_programs, &def_shortcut_27 },

    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_29 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_04 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_05 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_30 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_06 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_07 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_08 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_09 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_10 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_11 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_12 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_13 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_14 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_15 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_16 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_17 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_18 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_19 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_25 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_20 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_21 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_22 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_23 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_24 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_26 },
    { MACHINE_TYPE_TERMINAL,
      &def_sheet_programs_ts, &def_shortcut_27 },

    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_29 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_04 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_05 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_30 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_06 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_07 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_08 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_09 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_10 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_11 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_12 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_13 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_14 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_15 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_16 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_17 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_18 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_19 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_25 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_20 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_21 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_22 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_23 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_24 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_26 },
    { MACHINE_TYPE_OPERATOR|MACHINE_TYPE_ORGANIZATION|MACHINE_TYPE_OTHER,
      &def_sheet_programs_other, &def_shortcut_27 },

    { MACHINE_TYPE_GAMECLUB | MACHINE_TYPE_INETCAFE,
      &def_sheet_internet, &def_shortcut_29 },
    { MACHINE_TYPE_GAMECLUB | MACHINE_TYPE_INETCAFE,
      &def_sheet_internet, &def_shortcut_01 },
    { MACHINE_TYPE_GAMECLUB | MACHINE_TYPE_INETCAFE,
      &def_sheet_internet, &def_shortcut_02 },
    { MACHINE_TYPE_GAMECLUB | MACHINE_TYPE_INETCAFE,
      &def_sheet_internet, &def_shortcut_03 },

    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_action, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_rpg, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_simulators, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_strategies, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_adults, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_music, &def_shortcut_00 },
    { MACHINE_TYPE_GAMECLUB,
      &def_sheet_films, &def_shortcut_00 },

    { MACHINE_TYPE_OPERATOR,
      &def_sheet_programs_other, &def_shortcut_28 },

  {0,NULL,NULL} //terminator
};



typedef struct {
BOOL state;
const char *parm_id;
} TDEFITEMLIST1;

typedef struct {
BOOL state;
const char *parm1_id;
const char *parm2_id;
} TDEFITEMLIST2;

typedef struct {
const char *bwc_name;
BOOL bwc_expand;
const char *name;
int type;
void *value;
const DWORD_PTR def_value;
} TGLOBALCFGITEM;

#define _C(x)  ((DWORD_PTR)(x))


static const TDEFITEMLIST2 def_disable_windows[] = 
{
  {TRUE, "#32770",                      "Find Printers"},   // todo: russian
  {TRUE, "#32770",                      "Мастер установки принтеров"},
  {TRUE, "#32770",                      "Мастер нового оборудования"},
  {TRUE, "#32770",                      "Add Printer Wizard"},
  {TRUE, "#32770",                      "Мастер подключения к Интернету"},
  {TRUE, "#32770",                      "Internet Connection Wizard"},
  {FALSE,"#32770",                      "Print*"},
  {FALSE,"#32770",                      "Печать*"},
  {TRUE, "HH Parent",                   ""},
  {TRUE, "PCHShell Window",             ""},
  {TRUE, "MS_WINHELP",                  ""},
  {TRUE, "MS_WINDOC",                   ""},
  {TRUE, "MS_WINTOPIC_SECONDARY",       ""},
  {TRUE, "ExploreWClass",               ""},
  {TRUE, "CabinetWClass",               ""},
  {FALSE,"ConsoleWindowClass",          ""},
  {TRUE, "IEFrame",                     ""},
  {TRUE, "ATH_Note",                    ""},
  {TRUE, "",                            "ICQ Welcome"},
  {FALSE,"wndclass_desked_gsk",         "Microsoft Visual Basic*"},
  {TRUE, "TTOTAL_CMD",                  ""},
  {TRUE, "HelpPane",                    ""},
  {TRUE, "TskOptionsForm.UnicodeClass", "Skype*"},
  {TRUE, "TOptionsForm.UnicodeClass",   "Skype*"},
  {TRUE, "TPrefForm",                   "Настройки"},
  {TRUE, "#32770",                      "Настройки программы"},
  {TRUE, "#32770",                      "Miranda IM Options"},
  {TRUE, "__oxFrame.class__",           "Options"},
  {TRUE, "__oxFrame.class__",           "Настройки"},
  {TRUE, "__oxFrame.class__",           "Параметры"},
  {TRUE, "#32770",                      "Мои настройки"},
  {TRUE, "#32770",                      "My preferences"},
  {TRUE, "bosa_sdm_*",                  "Добавление гиперссылки"},
  {TRUE, "USurface_*",                  "Выбрать приложение"},
  {FALSE,"USurface_*",                  "Настройки - Steam"},
  {TRUE, "USurface_*",                  "Добавить игру"},
  {TRUE, "USurface_*",                  "Добавление игры"},
  {FALSE,"USurface_*",                  "Настройки"},
{FALSE,NULL,NULL} //terminator
};


static const TDEFITEMLIST1 def_disallow_run[] = 
{
  {FALSE,"notepad.exe"},
  {FALSE,"winhelp.exe"},
  {FALSE,"winhlp32.exe"},
  {FALSE,"explorer.exe"},
  {TRUE, "ctfmon.exe"},
  {TRUE, "utilman.exe"},
  {TRUE, "narrator.exe"},
  {TRUE, "internt.exe"},
  {TRUE, "skypepm.exe"},
  {TRUE, "WindowsPhotoGallery.exe"},
{FALSE,NULL} //terminator
};

static const TDEFITEMLIST1 def_allow_run[] = 
{
  {TRUE, "rundll32.exe"},
  {TRUE, "VC5Tray.exe"},
  {TRUE, "VC6Tray.exe"},
  {TRUE, "mra.exe"},
  {TRUE, "icq.exe"},
  {TRUE, "icqlite.exe"},
  {TRUE, "icq_lite.exe"},
  {TRUE, "lite_icq.exe"},
  {TRUE, "icqrun.exe"},
  {TRUE, "icqsrp.exe"},
  {TRUE, "icqtoolbarpatch.exe"},
  {TRUE, "d2loader.exe"},
  {TRUE, "kill.exe"},
  {TRUE, "ASVClient9x.exe"},
  {TRUE, "ClientInstaller9x.exe"},
  {TRUE, "em_exec.exe"},
  {TRUE, "l2.exe"},
  {TRUE, "LineageII.exe"},
  {TRUE, "IcqUpdater.exe"},
  {TRUE, "IcqLRun.exe"},
  {TRUE, "bodywb.exe"},
  {TRUE, "dinotify.exe"},
  {TRUE, "newdev.exe"},
  {TRUE, "reader_sl.exe"},
  {TRUE, "wmpshare.exe"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_safe_tray_icons[] = 
{
  {TRUE, "winamp.exe"},
  {TRUE, "studio.exe"},
  {TRUE, "icq.exe"},
  {TRUE, "icqlite.exe"},
  {TRUE, "icq_lite.exe"},
  {TRUE, "lite_icq.exe"},
  {TRUE, "rsoperator.exe"},
  {TRUE, "gccl.exe"},
  {TRUE, "ClubClient.exe"},
  {TRUE, "ASVClient9x.exe"},
  {TRUE, "ClubControlClient.exe"},
  {TRUE, "skype.exe"},
  {TRUE, "qip.exe"},
  {TRUE, "miranda32.exe"},
  {TRUE, "magent.exe"},
  {TRUE, "YAHOOM~1.EXE"},
  {TRUE, "Ymsgr_tray.exe"},
  {TRUE, "utorrent.exe"},
  {TRUE, "bittorrent.exe"},
  {TRUE, "rshell_asv2.exe"},
  {TRUE, "steam.exe"},
  {TRUE, "garena.exe"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_hidden_tray_icons[] = 
{
  {FALSE,"r_server.exe"},
  {FALSE,"r_admin.exe"},
  {FALSE,"rserver.exe"},
  {FALSE,"radmin.exe"},
  {FALSE,"VC5Tray.exe"},
  {FALSE,"VC6Tray.exe"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_hide_tm_programs[] =
{
  {TRUE, "ati2evxx.exe"},
  {TRUE, "r_server.exe"},
  {TRUE, "ClubControlClient.exe"},
  {TRUE, "gccl.exe"},
  {TRUE, "gcclsrv.exe"},
  {TRUE, "em_exec.exe"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_disallowed_sites[] = 
{
  {FALSE,"*.mail.ru"},
  {FALSE,"mail.ru"},
  {FALSE,"*.sex.com"},
  {FALSE,"sex.com"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_allowed_sites[] = 
{
  {FALSE,"*.list.ru"},
  {FALSE,"www.winamp.com"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST1 def_redirected_urls[] = 
{
  {FALSE,"http://site.ru/*"},
  {FALSE,"http://www.site.ru/*"},
  {FALSE,"http://site.ru/index.php?id=117"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST2 def_menu_ext[] = 
{
  {FALSE,(const char*)(3181),"D:\\games\\valve\\cstrike"},
{FALSE,NULL,NULL} //terminator
};

static const TDEFITEMLIST2 def_menu_ext_rev[] = 
{
  {FALSE,(const char*)(3182),"C:\\Documents and Settings\\All Users\\Application Data\\NFS underground"},
{FALSE,NULL,NULL} //terminator
};

static const TDEFITEMLIST2 def_addon_folders[] = 
{
  {TRUE,(const char*)(3185),"Y:\\data"},
  {TRUE,(const char*)(3184),"Z:\\data"},
  {TRUE,(const char*)(3183),"\\\\server\\data"},
{FALSE,NULL,NULL} //terminator
};

static const TDEFITEMLIST1 def_delete_folders[] = 
{
  {FALSE,"C:\\DATA\\FILES\\FOLDER"},
  {FALSE,"C:\\DATA\\FILES\\*.dat"},
  {FALSE,"C:\\DATA\\ALL\\*.*"},
{FALSE,NULL} //terminator
};


static const TDEFITEMLIST2 def_autorun_items[] = 
{
  {FALSE,"MyTool1","C:\\tools\\tool1.exe"},
  {FALSE,"MyTool2","C:\\tools\\tool2.exe"},
  {FALSE,"Start Page","$bodywb -simple http://runpad-shell.com"},
{FALSE,NULL,NULL} //terminator
};


static const TDEFITEMLIST2 def_user_tools[] = 
{
  {TRUE, (const char*)(3195),"%RS_FOLDER%\\bodyminimize.exe"},
  {TRUE, (const char*)(3194),"%RS_FOLDER%\\bodywb.exe"},
  {TRUE, (const char*)(3193),"%RS_FOLDER%\\bodyexpl.exe"},
  {TRUE, (const char*)(3192),"%RS_FOLDER%\\bodyburn.exe"},
  {TRUE, (const char*)(3191),"%RS_FOLDER%\\bodymail.exe"},
  {FALSE,(const char*)(3190),"%RS_FOLDER%\\bodyscan.exe"},
  {TRUE, (const char*)(3189),"%RS_FOLDER%\\bodytm.exe"},
  {FALSE,(const char*)(3188),"%WinDir%\\System32\\calc.exe"},
  {FALSE,(const char*)(3187),"%RS_FOLDER%\\bodycalc.exe"},
  {TRUE, (const char*)(3186),"%RS_FOLDER%\\bodymouse.exe"},
{FALSE,NULL,NULL} //terminator
};


static const TDEFITEMLIST2 def_lic_manager[] = 
{
  {FALSE,"WarCraft (15)","war3.exe;w3loader.exe;war3loader.exe;w3start.bat"},
  {FALSE,"DOOM (5)","doom.exe"},
  {FALSE,"Lineage II (10)","l2.exe;lineageii.exe"},
{FALSE,NULL,NULL} //terminator
};


static const TDEFITEMLIST2 def_mobile_content[] = 
{
  {TRUE, (const char*)(3206),  "\\\\server\\mobile\\melody"},
  {TRUE, (const char*)(3205),  "\\\\server\\mobile\\sounds"},
  {TRUE, (const char*)(3204),  "\\\\server\\mobile\\mp3"},
  {TRUE, (const char*)(3203),  "\\\\server\\mobile\\savers"},
  {TRUE, (const char*)(3202),  "\\\\server\\mobile\\otkr"},
  {TRUE, (const char*)(3201),  "\\\\server\\mobile\\pics"},
  {TRUE, (const char*)(3200),  "\\\\server\\mobile\\fotos"},
  {TRUE, (const char*)(3199),  "\\\\server\\mobile\\games"},
  {TRUE, (const char*)(3198),  "\\\\server\\mobile\\video"},
  {TRUE, (const char*)(3197),  "\\\\server\\mobile\\books"},
  {TRUE, (const char*)(3196),  "\\\\server\\mobile\\other"},
{FALSE,NULL,NULL} //terminator
};


static const TDEFITEMLIST1 def_rollback_excl[] = 
{
  {FALSE,"%ProgramFiles%\\MyProgram"},
  {FALSE,"c:\\data\\folder\\"},
{FALSE,NULL} //terminator
};



static const TGLOBALCFGITEM cfg_items[] = 
{
  // общие настройки
  { NULL, FALSE, "wait_server_path",               CFG_TYPE_PATH,    &wait_server_path,                NULL },
  { NULL, FALSE, "wait_server_timeout",            CFG_TYPE_INT,     &wait_server_timeout,             30 },
  { NULL, FALSE, "only_one_cpu",                   CFG_TYPE_BOOL,    &only_one_cpu,                    TRUE },
  { NULL, FALSE, "shutdown_action",                CFG_TYPE_INT,     &shutdown_action,                 0 },

  // быстрое отключение
  { NULL, FALSE, "fastexit_idle_timeout",          CFG_TYPE_INT,     &fastexit_idle_timeout,           30 },
  { NULL, FALSE, "fastexit_use_keyboard",          CFG_TYPE_BOOL,    &fastexit_use_keyboard,           TRUE },
  { NULL, FALSE, "fastexit_use_fixed_pwd",         CFG_TYPE_BOOL,    &fastexit_use_fixed_pwd,          TRUE },
  { NULL, FALSE, "fastexit_fixed_pwd_md5",         CFG_TYPE_STRING,  &fastexit_fixed_pwd_md5,          NULL },
  { NULL, FALSE, "fastexit_use_flash",             CFG_TYPE_BOOL,    &fastexit_use_flash,              FALSE },
  { NULL, FALSE, "fastexit_flash_list",            CFG_TYPE_LONGSTRING, &fastexit_flash_list,          NULL },

  // интерфейс: вид                                  
  { NULL, FALSE, "def_sheet_color",                CFG_TYPE_INT,     &def_sheet_color,                 0xB8ABBE },
  { NULL, FALSE, "curr_theme2d",                   CFG_TYPE_INT,     &curr_theme2d,                    1 },
  { NULL, FALSE, "curr_desktop_theme",             CFG_TYPE_PATH,    &curr_desktop_theme,              _C("%RS_FOLDER%\\default\\themes\\05.theme") },
  { NULL, FALSE, "dont_show_theme_errors",         CFG_TYPE_BOOL,    &dont_show_theme_errors,          FALSE },
  { NULL, FALSE, "html_status_text1",              CFG_TYPE_STRING,  &html_status_text1,               _C("%TIME% (%DATE% - %DOW%) %VIP%") },
  { NULL, FALSE, "html_status_text2",              CFG_TYPE_LONGSTRING, &html_status_text2,            3207 },
  { NULL, FALSE, "icons_winstyle",                 CFG_TYPE_BOOL,    &icons_winstyle,                  FALSE },
  { NULL, FALSE, "do_icon_highlight",              CFG_TYPE_BOOL,    &do_icon_highlight,               TRUE },
  { NULL, FALSE, "ubericon_effect",                CFG_TYPE_INT,     &ubericon_effect,                 1 },
  { NULL, FALSE, "use_desk_shader",                CFG_TYPE_BOOL,    &use_desk_shader,                 TRUE },
  { NULL, FALSE, "high_quality_bg_video",          CFG_TYPE_BOOL,    &high_quality_bg_video,           FALSE },
  { NULL, FALSE, "dont_show_empty_icons",          CFG_TYPE_BOOL,    &dont_show_empty_icons,           TRUE },
  { NULL, FALSE, "det_empty_icons_by_icon_path",   CFG_TYPE_BOOL,    &det_empty_icons_by_icon_path,    FALSE },
  { NULL, FALSE, "dont_show_icon_names",           CFG_TYPE_BOOL,    &dont_show_icon_names,            FALSE },
  { NULL, FALSE, "use_system_icon_spacing",        CFG_TYPE_BOOL,    &use_system_icon_spacing,         TRUE },
  { NULL, FALSE, "icon_spacing_w",                 CFG_TYPE_INT,     &icon_spacing_w,                  110 },
  { NULL, FALSE, "icon_spacing_h",                 CFG_TYPE_INT,     &icon_spacing_h,                  110 },
  { NULL, FALSE, "icon_size_h",                    CFG_TYPE_INT,     &icon_size_h,                     48 },
  { NULL, FALSE, "icon_size_w",                    CFG_TYPE_INT,     &icon_size_w,                     85 },
  { NULL, FALSE, "close_sheet_idle",               CFG_TYPE_INT,     &close_sheet_idle,                13 },
  { NULL, FALSE, "min_grouped_windows",            CFG_TYPE_INT,     &min_grouped_windows,             6 },
  { NULL, FALSE, "disable_desktop_composition",    CFG_TYPE_BOOL,    &disable_desktop_composition,     FALSE },
  { NULL, FALSE, "user_tools",                     CFG_TYPE_LIST2,   &user_tools,                      _C(def_user_tools) },
  { NULL, FALSE, "sheet_init_maximize",            CFG_TYPE_BOOL,    &sheet_init_maximize,             FALSE },
  { NULL, FALSE, "startup_sheet_name",             CFG_TYPE_STRING,  &startup_sheet_name,              NULL },

  // интерфейс: меню                                 
  { NULL, FALSE, "winkey_enable",                  CFG_TYPE_BOOL,    &winkey_enable,                   FALSE },
  { "vip_in_menu", 
    FALSE, "vip_in_menu",                          CFG_TYPE_BOOL,    &vip_in_menu,                     TRUE },
  { NULL, FALSE, "show_book_in_menu",              CFG_TYPE_BOOL,    &show_book_in_menu,               TRUE },
  { NULL, FALSE, "monitor_off_in_menu",            CFG_TYPE_BOOL,    &monitor_off_in_menu,             FALSE },
  { NULL, FALSE, "logoff_in_menu",                 CFG_TYPE_BOOL,    &logoff_in_menu,                  FALSE },
  { NULL, FALSE, "reboot_in_menu",                 CFG_TYPE_BOOL,    &reboot_in_menu,                  TRUE },
  { NULL, FALSE, "shutdown_in_menu",               CFG_TYPE_BOOL,    &shutdown_in_menu,                FALSE },
  { NULL, FALSE, "gc_info_in_menu",                CFG_TYPE_BOOL,    &gc_info_in_menu,                 FALSE },
  { NULL, FALSE, "mycomp_in_menu",                 CFG_TYPE_BOOL,    &mycomp_in_menu,                  TRUE },
  { NULL, FALSE, "calladmin_in_menu",              CFG_TYPE_BOOL,    &calladmin_in_menu,               TRUE },

  // безопасность: системные запреты                 
  { NULL, FALSE, "sysrestrict00",                  CFG_TYPE_BOOL,    &sysrestrict00,                   TRUE },
  { NULL, FALSE, "sysrestrict01",                  CFG_TYPE_BOOL,    &sysrestrict01,                   TRUE },
  { NULL, FALSE, "sysrestrict02",                  CFG_TYPE_BOOL,    &sysrestrict02,                   TRUE },
  { NULL, FALSE, "sysrestrict03",                  CFG_TYPE_BOOL,    &sysrestrict03,                   TRUE },
  { NULL, FALSE, "sysrestrict04",                  CFG_TYPE_BOOL,    &sysrestrict04,                   TRUE },
  { NULL, FALSE, "sysrestrict05",                  CFG_TYPE_BOOL,    &sysrestrict05,                   TRUE },
  { NULL, FALSE, "sysrestrict06",                  CFG_TYPE_BOOL,    &sysrestrict06,                   TRUE },
  { NULL, FALSE, "sysrestrict07",                  CFG_TYPE_BOOL,    &sysrestrict07,                   TRUE },
  { NULL, FALSE, "sysrestrict08",                  CFG_TYPE_BOOL,    &sysrestrict08,                   TRUE },
  { NULL, FALSE, "sysrestrict09",                  CFG_TYPE_BOOL,    &sysrestrict09,                   TRUE },
  { NULL, FALSE, "sysrestrict10",                  CFG_TYPE_BOOL,    &sysrestrict10,                   TRUE },
  { NULL, FALSE, "sysrestrict11",                  CFG_TYPE_BOOL,    &sysrestrict11,                   TRUE },
  { NULL, FALSE, "sysrestrict12",                  CFG_TYPE_BOOL,    &sysrestrict12,                   TRUE },
  { NULL, FALSE, "sysrestrict13",                  CFG_TYPE_BOOL,    &sysrestrict13,                   TRUE },
  { NULL, FALSE, "sysrestrict14_2",                CFG_TYPE_BOOL,    &sysrestrict14,                   FALSE },
  { NULL, FALSE, "sysrestrict15",                  CFG_TYPE_BOOL,    &sysrestrict15,                   TRUE },
  { NULL, FALSE, "sysrestrict16",                  CFG_TYPE_BOOL,    &sysrestrict16,                   TRUE },
  { NULL, FALSE, "sysrestrict17",                  CFG_TYPE_BOOL,    &sysrestrict17,                   TRUE },
  { NULL, FALSE, "sysrestrict18",                  CFG_TYPE_BOOL,    &sysrestrict18,                   TRUE },
  { NULL, FALSE, "sysrestrict19",                  CFG_TYPE_BOOL,    &sysrestrict19,                   TRUE },
  { NULL, FALSE, "sysrestrict20",                  CFG_TYPE_BOOL,    &sysrestrict20,                   FALSE },
  { NULL, FALSE, "sysrestrict21",                  CFG_TYPE_BOOL,    &sysrestrict21,                   TRUE },
  { NULL, FALSE, "sysrestrict22",                  CFG_TYPE_BOOL,    &sysrestrict22,                   TRUE },
  { NULL, FALSE, "sysrestrict23",                  CFG_TYPE_BOOL,    &sysrestrict23,                   TRUE },
  { NULL, FALSE, "sysrestrict24",                  CFG_TYPE_BOOL,    &sysrestrict24,                   TRUE },
  { NULL, FALSE, "sysrestrict25",                  CFG_TYPE_BOOL,    &sysrestrict25,                   FALSE },
  { NULL, FALSE, "sysrestrict26",                  CFG_TYPE_BOOL,    &sysrestrict26,                   FALSE },
  { NULL, FALSE, "sysrestrict27",                  CFG_TYPE_BOOL,    &sysrestrict27,                   TRUE },
  { NULL, FALSE, "sysrestrict28",                  CFG_TYPE_BOOL,    &sysrestrict28,                   TRUE },
  { NULL, FALSE, "sysrestrict29",                  CFG_TYPE_BOOL,    &sysrestrict29,                   TRUE },

  // безопасность: файловая система                  
  { NULL, FALSE, "restrict_copyhook",              CFG_TYPE_BOOL,    &restrict_copyhook,               FALSE },  // TRUE
  { NULL, FALSE, "restrict_shellexechook",         CFG_TYPE_BOOL,    &restrict_shellexechook,          TRUE },
  { NULL, FALSE, "protected_protos",               CFG_TYPE_STRING,  &protected_protos,                _C("mailto;nntp") },
  { NULL, FALSE, "allowed_ext",                    CFG_TYPE_LONGSTRING,  &allowed_ext,                 _C("txt;pdf;doc;docx;xls;xlsx;rtf;sxw;sxc;ods;odt;htm;html;mht;xml;gif;bmp;jpeg;jpg;jpe;png;tif;tiff;asf;asx;wpl;wm;wmx;wmd;wmz;wax;wmv;wvx;cda;avi;mpeg;mpg;mpe;m1v;dat;wma;wav;mp2;mpv2;mp2v;mpa;mp3;m3u;pls;swf;url;ifo;vob;torrent;csv;mkv") },
  { NULL, FALSE, "disks_hidden",                   CFG_TYPE_INT,     &disks_hidden,                    0x0 },
  { NULL, FALSE, "disks_disabled",                 CFG_TYPE_INT,     &disks_disabled,                  0x0 },
  { NULL, FALSE, "restrict_file_dialogs",          CFG_TYPE_BOOL,    &restrict_file_dialogs,           TRUE },
  { NULL, FALSE, "allow_newfolder_opensave",       CFG_TYPE_BOOL,    &allow_newfolder_opensave,        TRUE },
  { NULL, FALSE, "apps_opensave_prohibited",       CFG_TYPE_STRING,  &apps_opensave_prohibited,        _C("launcher.exe;launcher2.exe") },
  { "allow_use_flash",
    FALSE, "allow_use_flash",                      CFG_TYPE_BOOL,    &allow_use_flash,                 TRUE },
  { "allow_use_diskette",
    FALSE, "allow_use_diskette",                   CFG_TYPE_BOOL,    &allow_use_diskette,              TRUE },
  { "allow_use_cdrom",
    FALSE, "allow_use_cdrom",                      CFG_TYPE_BOOL,    &allow_use_cdrom,                 TRUE },
  { "net_flash",
    TRUE,  "net_flash",                            CFG_TYPE_PATH,    &net_flash,                       NULL },
  { "net_diskette",
    TRUE,  "net_diskette",                         CFG_TYPE_PATH,    &net_diskette,                    NULL },
  { "net_cdrom",
    TRUE,  "net_cdrom",                            CFG_TYPE_PATH,    &net_cdrom,                       NULL },
  { NULL, FALSE, "allow_flash_stat",               CFG_TYPE_BOOL,    &allow_flash_stat,                TRUE },
  { NULL, FALSE, "allow_dvd_stat",                 CFG_TYPE_BOOL,    &allow_dvd_stat,                  TRUE },
  { "clean_user_folder",
    FALSE, "clean_user_folder",                    CFG_TYPE_INT,     &clean_user_folder,               4 },
  { "user_folder_base",
    TRUE,  "user_folder_base",                     CFG_TYPE_PATH,    &user_folder_base,                NULL },
  { "uf_format",
    TRUE,  "uf_format",                            CFG_TYPE_STRING,  &uf_format,                       _C("%COMPUTERNAME%_%USERNAME%") },
  { NULL, FALSE, "allow_run_from_folder_shortcuts",CFG_TYPE_BOOL,    &allow_run_from_folder_shortcuts, FALSE },

  // безопасность: окна, процессы и пр.              
  { NULL, FALSE, "disable_windows",                CFG_TYPE_LIST2,   &disable_windows,                 _C(def_disable_windows) },
  { NULL, FALSE, "close_not_active_windows",       CFG_TYPE_BOOL,    &close_not_active_windows,        FALSE },
  { NULL, FALSE, "disallow_run",                   CFG_TYPE_LIST1,   &disallow_run,                    _C(def_disallow_run) },
  { NULL, FALSE, "allow_run",                      CFG_TYPE_LIST1,   &allow_run,                       _C(def_allow_run) },
  { NULL, FALSE, "disallow_power_keys",            CFG_TYPE_BOOL,    &disallow_power_keys,             FALSE },
  { NULL, FALSE, "disable_input_when_monitor_off", CFG_TYPE_BOOL,    &disable_input_when_monitor_off,  TRUE },
  { NULL, FALSE, "safe_console",                   CFG_TYPE_BOOL,    &safe_console,                    TRUE },
  { NULL, FALSE, "safe_winamp",                    CFG_TYPE_BOOL,    &safe_winamp,                     TRUE },
  { NULL, FALSE, "safe_mplayerc",                  CFG_TYPE_BOOL,    &safe_mplayerc,                   TRUE },
  { NULL, FALSE, "safe_powerdvd",                  CFG_TYPE_BOOL,    &safe_powerdvd,                   TRUE },
  { NULL, FALSE, "safe_torrent",                   CFG_TYPE_BOOL,    &safe_torrent,                    TRUE },
  { NULL, FALSE, "safe_garena",                    CFG_TYPE_BOOL,    &safe_garena,                     TRUE },

  // безопасность: CTRL+ALT+DEL                      
  { NULL, FALSE, "use_cad_catcher",                CFG_TYPE_BOOL,    &use_cad_catcher,                 TRUE },
  { NULL, FALSE, "cad_taskman",                    CFG_TYPE_BOOL,    &cad_taskman,                     TRUE },
  { NULL, FALSE, "cad_killall",                    CFG_TYPE_BOOL,    &cad_killall,                     TRUE },
  { NULL, FALSE, "cad_gcinfo",                     CFG_TYPE_BOOL,    &cad_gcinfo,                      FALSE },
  { NULL, FALSE, "cad_reboot",                     CFG_TYPE_BOOL,    &cad_reboot,                      TRUE },
  { NULL, FALSE, "cad_shutdown",                   CFG_TYPE_BOOL,    &cad_shutdown,                    FALSE },
  { NULL, FALSE, "cad_monitoroff",                 CFG_TYPE_BOOL,    &cad_monitoroff,                  TRUE },
  { NULL, FALSE, "cad_logoff",                     CFG_TYPE_BOOL,    &cad_logoff,                      FALSE },

  // безопасность: трей                              
  { NULL, FALSE, "max_vis_tray_icons",             CFG_TYPE_INT,     &max_vis_tray_icons,              15 },
  { NULL, FALSE, "safe_tray",                      CFG_TYPE_BOOL,    &safe_tray,                       TRUE },
  { NULL, FALSE, "safe_tray_icons",                CFG_TYPE_LIST1,   &safe_tray_icons,                 _C(def_safe_tray_icons) },
  { NULL, FALSE, "hidden_tray_icons",              CFG_TYPE_LIST1,   &hidden_tray_icons,               _C(def_hidden_tray_icons) },

  // запуск ярлыков                                  
  { NULL, FALSE, "allow_run_only_one",             CFG_TYPE_BOOL,    &allow_run_only_one,              FALSE },
  { NULL, FALSE, "protect_bodytools_when_nosql",   CFG_TYPE_BOOL,    &protect_bodytools_when_nosql,    TRUE },
  { NULL, FALSE, "protect_run_when_nosql",         CFG_TYPE_BOOL,    &protect_run_when_nosql,          FALSE },
  { NULL, FALSE, "protect_in_safe_mode",           CFG_TYPE_BOOL,    &protect_in_safe_mode,            TRUE },
  { NULL, FALSE, "protect_run_at_startup",         CFG_TYPE_BOOL,    &protect_run_at_startup,          FALSE },
  { NULL, FALSE, "use_blocker",                    CFG_TYPE_BOOL,    &use_blocker,                     TRUE },
  { NULL, FALSE, "blocker_file",                   CFG_TYPE_PATH,    &blocker_file,                    NULL },
  { NULL, FALSE, "ssaver_idle",                    CFG_TYPE_INT,     &ssaver_idle,                     0 },
  { NULL, FALSE, "alcohol_path",                   CFG_TYPE_PATH,    &alcohol_path,                    NULL },
  { NULL, FALSE, "daemon_path",                    CFG_TYPE_PATH,    &daemon_path,                     _C("%ProgramFiles%\\DAEMON Tools Lite\\DTLite.exe") },
  { NULL, FALSE, "daemon_pro_path",                CFG_TYPE_PATH,    &daemon_pro_path,                 _C("%ProgramFiles%\\DAEMON Tools Pro\\DTAgent.exe") },
  { NULL, FALSE, "lic_manager",                    CFG_TYPE_LIST2,   &lic_manager,                     _C(def_lic_manager) },

  // запуск ярлыков: статистика                      
  { NULL, FALSE, "stat_enable",                    CFG_TYPE_BOOL,    &stat_enable,                     TRUE },
  { NULL, FALSE, "clear_stat_interval",            CFG_TYPE_INT,     &clear_stat_interval,             3 },
  { NULL, FALSE, "do_web_stat",                    CFG_TYPE_BOOL,    &do_web_stat,                     TRUE },
  { NULL, FALSE, "stat_excl",                      CFG_TYPE_STRING,  &stat_excl,                       _C("jpeg;jpg;jpe;gif;png;bmp;mp3;mp2;wma;ogg;url") },

  // оборудование                                    
  { NULL, FALSE, "allow_printer_control",          CFG_TYPE_BOOL,    &allow_printer_control,           TRUE },
  { NULL, FALSE, "allow_hwident_ibutton",          CFG_TYPE_BOOL,    &allow_hwident_ibutton,           FALSE },

  // файлы: перенаправление для VIP
  { NULL, FALSE, "redirect_sys_folders",           CFG_TYPE_BOOL,    &redirect_sys_folders,            FALSE },
  { NULL, FALSE, "redirect_personal",              CFG_TYPE_BOOL,    &redirect_personal,               FALSE },
  { NULL, FALSE, "redirect_appdata",               CFG_TYPE_BOOL,    &redirect_appdata,                TRUE },
  { NULL, FALSE, "redirect_localappdata",          CFG_TYPE_BOOL,    &redirect_localappdata,           TRUE },
  { NULL, FALSE, "personal_path",                  CFG_TYPE_PATH,    &personal_path,                   NULL },
  { NULL, FALSE, "vip_basefolder",                 CFG_TYPE_PATH,    &vip_basefolder,                  NULL },
  { NULL, FALSE, "vip_folder_limit",               CFG_TYPE_INT,     &vip_folder_limit,                0 },
  { NULL, FALSE, "force_viplogin_from_api",        CFG_TYPE_BOOL,    &force_viplogin_from_api,         TRUE },

  // проводник                                       
  { "addon_folders",
    TRUE,  "addon_folders",                        CFG_TYPE_LIST2,   &addon_folders,                   _C(def_addon_folders) },
  { "allow_save_to_addon_folders",
    FALSE, "allow_save_to_addon_folders",          CFG_TYPE_BOOL,    &allow_save_to_addon_folders,     FALSE },
  { "allow_drag_anywhere",
    FALSE, "allow_drag_anywhere",                  CFG_TYPE_BOOL,    &allow_drag_anywhere,             TRUE },
  { "allow_write_to_removable",
    FALSE, "allow_write_to_removable",             CFG_TYPE_BOOL,    &allow_write_to_removable,        TRUE },
  { "menu_ext",
    TRUE,  "menu_ext",                             CFG_TYPE_LIST2,   &menu_ext,                        _C(def_menu_ext) },
  { "menu_ext_rev",
    TRUE,  "menu_ext_rev",                         CFG_TYPE_LIST2,   &menu_ext_rev,                    _C(def_menu_ext_rev) },
  { "winrar_path",
    TRUE,  "winrar_path",                          CFG_TYPE_PATH,    &winrar_path,                     _C("C:\\Program Files\\WinRAR\\WinRAR.exe") },
  { "delete_to_recycle",
    FALSE, "delete_to_recycle",                    CFG_TYPE_BOOL,    &delete_to_recycle,               FALSE },
  { "disallow_copy_from_lnkfolder",
    FALSE, "disallow_copy_from_lnkfolder",         CFG_TYPE_BOOL,    &disallow_copy_from_lnkfolder,    FALSE },
  { "show_hiddens_in_bodyexpl",
    FALSE, "show_hiddens_in_bodyexpl",             CFG_TYPE_BOOL,    &show_hiddens_in_bodyexpl,        FALSE },

  // браузер IE: общие                               
  { "use_bodytool_ie",
    FALSE, "use_bodytool_ie",                      CFG_TYPE_BOOL,    &use_bodytool_ie,                 TRUE },
  { NULL, FALSE, "disallow_sites",                 CFG_TYPE_BOOL,    &disallow_sites,                  FALSE },
  { NULL, FALSE, "disallowed_sites",               CFG_TYPE_LIST1,   &disallowed_sites,                _C(def_disallowed_sites) },
  { NULL, FALSE, "allowed_sites",                  CFG_TYPE_LIST1,   &allowed_sites,                   _C(def_allowed_sites) },
  { NULL, FALSE, "redirected_urls",                CFG_TYPE_LIST1,   &redirected_urls,                 _C(def_redirected_urls) },
  { NULL, FALSE, "redirection_url",                CFG_TYPE_STRING,  &redirection_url,                 _C("http://") },
  { NULL, FALSE, "ie_local_res",                   CFG_TYPE_STRING,  &ie_local_res,                    _C("txt;htm;html;xml;gif;jpeg;jpg;jpe;png;mht;swf;js;css;ico;avi;wmv;wma;mp3;mpg;mpeg;doc;xls;rtf;pdf") },
  { NULL, FALSE, "ie_disallowed_protos",           CFG_TYPE_STRING,  &ie_disallowed_protos,            _C("mailto;nntp;ms-help") },
  { NULL, FALSE, "safe_ie_exts",                   CFG_TYPE_STRING,  &safe_ie_exts,                    _C("htm;html;xml;mht") },
  { NULL, FALSE, "safe_ie_protos",                 CFG_TYPE_STRING,  &safe_ie_protos,                  _C("http;https;ftp;gopher") },
  { "fav_path",
    TRUE,  "fav_path",                             CFG_TYPE_PATH,    &fav_path,                        _C("%RS_VIPFOLDER%\\IEFav") },
  { "disallow_add2fav",
    FALSE, "disallow_add2fav",                     CFG_TYPE_BOOL,    &disallow_add2fav,                FALSE },
  { NULL, FALSE, "ie_open_with_mp",                CFG_TYPE_STRING,  &ie_open_with_mp,                 _C("avi;wmv;mpg;mpeg;mpe") },
  { NULL, FALSE, "ie_open_with_ext",               CFG_TYPE_STRING,  &ie_open_with_ext,                _C("doc;xls;rtf;pdf") },
  { "wb_flash_disable",
    FALSE, "wb_flash_disable",                     CFG_TYPE_BOOL,    &wb_flash_disable,                FALSE },
  { "allow_ie_print",
    FALSE, "allow_ie_print",                       CFG_TYPE_BOOL,    &allow_ie_print,                  TRUE },
  { "max_ie_windows",
    FALSE, "max_ie_windows",                       CFG_TYPE_INT,     &max_ie_windows,                  0 },
  { "ie_clean_history",
    FALSE, "ie_clean_history",                     CFG_TYPE_BOOL,    &ie_clean_history,                TRUE },
  { "rus2eng_wb",
    FALSE, "rus2eng_wb",                           CFG_TYPE_BOOL,    &rus2eng_wb,                      FALSE },
  { NULL, FALSE, "close_ie_when_nosheet",          CFG_TYPE_BOOL,    &close_ie_when_nosheet,           FALSE },
  { NULL, FALSE, "ftp_enable",                     CFG_TYPE_BOOL,    &ftp_enable,                      TRUE },
  { "protect_run_in_ie",
    FALSE, "protect_run_in_ie",                    CFG_TYPE_BOOL,    &protect_run_in_ie,               TRUE },
  { "wb_search_bars",
    FALSE, "wb_search_bars",                       CFG_TYPE_BOOL,    &wb_search_bars,                  TRUE },
  { "disable_view_html",
    FALSE, "disable_view_html",                    CFG_TYPE_BOOL,    &disable_view_html,               FALSE },
  { NULL, FALSE, "ie_use_sett",                    CFG_TYPE_BOOL,    &ie_use_sett,                     FALSE },
  { NULL, FALSE, "ie_sett_proxy",                  CFG_TYPE_STRING,  &ie_sett_proxy,                   NULL },
  { NULL, FALSE, "ie_sett_port",                   CFG_TYPE_STRING,  &ie_sett_port,                    NULL },
  { NULL, FALSE, "ie_sett_autoconfig",             CFG_TYPE_STRING,  &ie_sett_autoconfig,              NULL },
  { "ie_home_page",
    TRUE,  "ie_home_page",                         CFG_TYPE_STRING,  &ie_home_page,                    _C("about:blank") },
  { "bodywb_caption",
    FALSE,  "bodywb_caption",                      CFG_TYPE_STRING,  &bodywb_caption,                  _C("%TITLE% - %APP%") },

  // браузер IE: загрузчик                           
  { "use_std_downloader", 
    FALSE, "use_std_downloader",                   CFG_TYPE_BOOL,    &use_std_downloader,              FALSE },
  { "allowed_download_types",
    FALSE, "allowed_download_types",               CFG_TYPE_STRING,  &allowed_download_types,          _C("mp3;avi;doc;txt;jpg") },
  { "use_allowed_download_types",
    FALSE, "use_allowed_download_types",           CFG_TYPE_BOOL,    &use_allowed_download_types,      FALSE },
  { "std_downloader_sites",
    FALSE, "std_downloader_sites",                 CFG_TYPE_STRING,  &std_downloader_sites,            _C("rapidshare.*; *.rapidshare.*; 5ballov.ru; *.5ballov.ru; *.era.com.ua; era.com.ua; antimuh.ru; *.antimuh.ru; *.mail.yandex.net; mbox.i.ua; *.attachmail.ru") },
  { "max_download_windows",
    FALSE, "max_download_windows",                 CFG_TYPE_INT,     &max_download_windows,            0 },
  { "max_download_size",
    FALSE, "max_download_size",                    CFG_TYPE_INT,     &max_download_size,               0 },
  { "download_speed_limit",
    FALSE, "download_speed_limit",                 CFG_TYPE_INT,     &download_speed_limit,            0 },
  { "download_autorun",
    FALSE, "download_autorun",                     CFG_TYPE_STRING,  &download_autorun,                _C("m3u;pls;wpl") },
  { "dont_show_download_speed",
    FALSE, "dont_show_download_speed",             CFG_TYPE_BOOL,    &dont_show_download_speed,        FALSE },
  { "allow_run_downloaded",
    FALSE, "allow_run_downloaded",                 CFG_TYPE_BOOL,    &allow_run_downloaded,            FALSE },

  // утилиты: MediaPlayer                            
  { NULL, FALSE, "use_bodytool_mp",                CFG_TYPE_BOOL,    &use_bodytool_mp,                 TRUE },
  { NULL, FALSE, "safe_mp_exts",                   CFG_TYPE_STRING,  &safe_mp_exts,                    _C("asf;asx;wpl;wm;wmx;wmd;wmz;wax;wmv;wvx;cda;avi;mpeg;mpg;mpe;m1v;dat;mid;midi;rmi;aif;aifc;aiff;au;snd") },
  { NULL, FALSE, "safe_mp_exts_winamp",            CFG_TYPE_STRING,  &safe_mp_exts_winamp,             _C("wma;wav;mp2;mpv2;mp2v;mpa;mp3;m3u;pls") },
  { NULL, FALSE, "safe_mp_protos",                 CFG_TYPE_STRING,  &safe_mp_protos,                  _C("MMS;MMST;MMSU") },
  { NULL, FALSE, "alternate_mp",                   CFG_TYPE_PATH,    &alternate_mp,                    NULL },

  // утилиты: мобильный телефон / bluetooth          
  { "mobile_content",
    TRUE,  "mobile_content",                       CFG_TYPE_LIST2,   &mobile_content,                  _C(def_mobile_content) },
  { "mobile_files_audio",
    FALSE, "mobile_files_audio",                   CFG_TYPE_STRING,  &mobile_files_audio,              _C("mp3;mp2;mp4;wma;wav;snd;au;aif;mid;midi;rmi") },
  { "mobile_files_video",
    FALSE, "mobile_files_video",                   CFG_TYPE_STRING,  &mobile_files_video,              _C("avi;3gp;mpg;mpeg;mpe;dat;wmv") },
  { "mobile_files_pictures",
    FALSE, "mobile_files_pictures",                CFG_TYPE_STRING,  &mobile_files_pictures,           _C("jpg;jpeg;jpe;bmp;dib;gif;ico;tiff;tif;png") },
  { "mobile_bodyexpl_integration",
    FALSE, "mobile_bodyexpl_integration",          CFG_TYPE_BOOL,    &mobile_bodyexpl_integration,     TRUE },
  { NULL, FALSE, "allow_bt_stat",                  CFG_TYPE_BOOL,    &allow_bt_stat,                   TRUE },
  { "bt_integration",
    FALSE, "bt_integration",                       CFG_TYPE_BOOL,    &bt_integration,                  TRUE },
  { "net_bt_path",
    TRUE,  "net_bt_path",                          CFG_TYPE_PATH,    &net_bt_path,                     NULL },

  // утилиты: запись дисков                          
  { NULL, FALSE, "allow_burn_stat",                CFG_TYPE_BOOL,    &allow_burn_stat,                 TRUE },
  { "burn_integration",
    FALSE, "burn_integration",                     CFG_TYPE_BOOL,    &burn_integration,                TRUE },
  { "law_protected_files",
    FALSE, "law_protected_files",                  CFG_TYPE_STRING,  &law_protected_files,             _C("vob;bup") },
  { "net_burn_path",
    TRUE,  "net_burn_path",                        CFG_TYPE_PATH,    &net_burn_path,                   NULL },
  { NULL, FALSE, "on_burn_complete",               CFG_TYPE_PATH,    &on_burn_complete,                _C("my_cd_tool.exe %TYPE% %SIZE% %TITLE%") },

  // утилиты: Mail                                   
  { NULL, FALSE, "allow_mail_stat",                CFG_TYPE_BOOL,    &allow_mail_stat,                 TRUE },
  { "bodymail_integration",
    FALSE, "bodymail_integration",                 CFG_TYPE_BOOL,    &bodymail_integration,            TRUE },
  { "bodymail_smtp",
    FALSE, "bodymail_smtp",                        CFG_TYPE_STRING,  &bodymail_smtp,                   NULL },
  { "bodymail_user",
    FALSE, "bodymail_user",                        CFG_TYPE_STRING,  &bodymail_user,                   NULL },
  { "bodymail_password",
    FALSE, "bodymail_password",                    CFG_TYPE_STRING,  &bodymail_password,               NULL },
  { "bodymail_port",
    FALSE, "bodymail_port",                        CFG_TYPE_INT,     &bodymail_port,                   25 },
  { "bodymail_hardcoded",
    FALSE, "bodymail_hardcoded",                   CFG_TYPE_BOOL,    &bodymail_hardcoded,              FALSE },
  { "bodymail_from_name",
    FALSE, "bodymail_from_name",                   CFG_TYPE_STRING,  &bodymail_from_name,              3208 },
  { "bodymail_from_address",
    FALSE, "bodymail_from_address",                CFG_TYPE_STRING,  &bodymail_from_address,           _C("org@domain.com") },
  { "bodymail_footer",
    FALSE, "bodymail_footer",                      CFG_TYPE_STRING,  &bodymail_footer,                 3209 },
  { "bodymail_to",
    FALSE, "bodymail_to",                          CFG_TYPE_STRING,  &bodymail_to,                     NULL },

  // утилиты: диспетчер задач                        
  { "hide_tm_programs",
    TRUE,  "hide_tm_programs",                     CFG_TYPE_LIST1,   &hide_tm_programs,                _C(def_hide_tm_programs) },
  { NULL, FALSE, "safe_taskmgr",                   CFG_TYPE_BOOL,    &safe_taskmgr,                    FALSE },
  { NULL, FALSE, "safe_taskmgr2",                  CFG_TYPE_BOOL,    &safe_taskmgr2,                   FALSE },
  { NULL, FALSE, "safe_taskmgr3",                  CFG_TYPE_BOOL,    &safe_taskmgr3,                   FALSE },
  { "kill_hidden_tasks",
    FALSE, "kill_hidden_tasks",                    CFG_TYPE_BOOL,    &kill_hidden_tasks,               FALSE },

  // утилиты: прочие                                 
  { NULL, FALSE, "use_bodytool_office",            CFG_TYPE_BOOL,    &use_bodytool_office,             TRUE },
  { "protect_run_in_office",
    FALSE, "protect_run_in_office",                CFG_TYPE_BOOL,    &protect_run_in_office,           TRUE },
  { "ext_office_print",
    FALSE, "ext_office_print",                     CFG_TYPE_BOOL,    &ext_office_print,                FALSE },
  { "show_office_menu",
    FALSE, "show_office_menu",                     CFG_TYPE_BOOL,    &show_office_menu,                FALSE },
  { "use_bodytool_notepad", 
    FALSE, "use_bodytool_notepad",                 CFG_TYPE_BOOL,    &use_bodytool_notepad,            TRUE },
  { NULL, FALSE, "safe_notepad_exts",              CFG_TYPE_STRING,  &safe_notepad_exts,               _C("txt;log;ini") },
  { NULL, FALSE, "use_bodytool_imgview",           CFG_TYPE_BOOL,    &use_bodytool_imgview,            TRUE },
  { NULL, FALSE, "use_bodytool_pdf",               CFG_TYPE_BOOL,    &use_bodytool_pdf,                TRUE },
  { "show_pdf_panel",
    FALSE, "show_pdf_panel",                       CFG_TYPE_BOOL,    &show_pdf_panel,                  FALSE },
  { NULL, FALSE, "use_bodytool_swf",               CFG_TYPE_BOOL,    &use_bodytool_swf,                TRUE },
  { NULL, FALSE, "inject_scan",                    CFG_TYPE_STRING,  &inject_scan,                     _C("ScanTwain.exe; Photoshp.exe") },
  { NULL, FALSE, "allow_scan_stat",                CFG_TYPE_BOOL,    &allow_scan_stat,                 TRUE },
  { NULL, FALSE, "tray_indic",                     CFG_TYPE_BOOL,    &tray_indic,                      TRUE },
  { NULL, FALSE, "tray_minimize_all",              CFG_TYPE_BOOL,    &tray_minimize_all,               FALSE },
  { NULL, FALSE, "tray_mixer",                     CFG_TYPE_BOOL,    &tray_mixer,                      TRUE },
  { NULL, FALSE, "tray_microphone",                CFG_TYPE_BOOL,    &tray_microphone,                 FALSE },
  { "allow_photocam",
    FALSE, "allow_photocam",                       CFG_TYPE_BOOL,    &allow_photocam,                  TRUE },

  // обслуживание: удаление                          
  { NULL, FALSE, "delete_folders",                 CFG_TYPE_LIST1,   &delete_folders,                  _C(def_delete_folders) },
  { NULL, FALSE, "clean_temp_dir",                 CFG_TYPE_BOOL,    &clean_temp_dir,                  FALSE },
  { NULL, FALSE, "clean_ie_dir",                   CFG_TYPE_BOOL,    &clean_ie_dir,                    FALSE },
  { NULL, FALSE, "clean_cookies",                  CFG_TYPE_BOOL,    &clean_cookies,                   FALSE },
  { NULL, FALSE, "clear_recycle_bin",              CFG_TYPE_BOOL,    &clear_recycle_bin,               FALSE },
  { NULL, FALSE, "clear_print_spooler",            CFG_TYPE_BOOL,    &clear_print_spooler,             FALSE },

  // обслуживание: автозапуск                        
  { NULL, FALSE, "autoplay_cda",                   CFG_TYPE_BOOL,    &autoplay_cda,                    FALSE },
  { NULL, FALSE, "autoplay_cda_cmd",               CFG_TYPE_PATH,    &autoplay_cda_cmd,                _C("c:\\mplayerc.exe %1") },
  { NULL, FALSE, "autoplay_dvd",                   CFG_TYPE_BOOL,    &autoplay_dvd,                    TRUE },
  { NULL, FALSE, "autoplay_dvd_cmd",               CFG_TYPE_PATH,    &autoplay_dvd_cmd,                _C("$bodymp /dvd %1") },
  { NULL, FALSE, "autoplay_cdr",                   CFG_TYPE_BOOL,    &autoplay_cdr,                    TRUE },
  { NULL, FALSE, "autoplay_cdr_cmd",               CFG_TYPE_PATH,    &autoplay_cdr_cmd,                _C("$bodyburn") },
  { NULL, FALSE, "autoplay_flash",                 CFG_TYPE_BOOL,    &autoplay_flash,                  TRUE },
  { NULL, FALSE, "autoplay_flash_cmd",             CFG_TYPE_PATH,    &autoplay_flash_cmd,              _C("$bodyexpl $flash") },

  // обслуживание: автозагрузка                      
  { NULL, FALSE, "welcome_path",                   CFG_TYPE_STRING,  &welcome_path,                    NULL },
  { NULL, FALSE, "autorun_items",                  CFG_TYPE_LIST2,   &autorun_items,                   _C(def_autorun_items) },
  { NULL, FALSE, "disable_autorun",                CFG_TYPE_BOOL,    &disable_autorun,                 FALSE },
  { NULL, FALSE, "show_la_at_startup",             CFG_TYPE_BOOL,    &show_la_at_startup,              FALSE },
  { NULL, FALSE, "la_startup_path",                CFG_TYPE_PATH,    &la_startup_path,                 3220 },

  // обслуживание: volume control                    
  { NULL, FALSE, "maxvol_master",                  CFG_TYPE_INT,     &maxvol_master,                   100 },
  { NULL, FALSE, "maxvol_wave",                    CFG_TYPE_INT,     &maxvol_wave,                     100 },
  { NULL, FALSE, "minvol_master",                  CFG_TYPE_INT,     &minvol_master,                   0 },
  { NULL, FALSE, "minvol_wave",                    CFG_TYPE_INT,     &minvol_wave,                     0 },
  { NULL, FALSE, "maxvol_enable",                  CFG_TYPE_BOOL,    &maxvol_enable,                   FALSE },

  // обслуживание: mouse control                     
  { NULL, FALSE, "adj_mouse_speed",                CFG_TYPE_INT,     &adj_mouse_speed,                 0 },
  { NULL, FALSE, "adj_mouse_acc",                  CFG_TYPE_INT,     &adj_mouse_acc,                   0 },
  { NULL, FALSE, "allow_mouse_adj",                CFG_TYPE_BOOL,    &allow_mouse_adj,                 FALSE },

  // обслуживание: scandisk                          
  { NULL, FALSE, "do_scandisk",                    CFG_TYPE_BOOL,    &do_scandisk,                     FALSE },
  { NULL, FALSE, "scandisk_hours",                 CFG_TYPE_INT,     &scandisk_hours,                  24 },
  { NULL, FALSE, "scandisk_disks",                 CFG_TYPE_INT,     &scandisk_disks,                  0x4 },

  // обслуживание: display mode                      
  { NULL, FALSE, "restore_dm_at_startup",          CFG_TYPE_BOOL,    &restore_dm_at_startup,           FALSE },
  { NULL, FALSE, "def_vmode_width",                CFG_TYPE_INT,     &def_vmode_width,                 -1 },
  { NULL, FALSE, "def_vmode_height",               CFG_TYPE_INT,     &def_vmode_height,                -1 },
  { NULL, FALSE, "def_vmode_bpp",                  CFG_TYPE_INT,     &def_vmode_bpp,                   32 },
  { NULL, FALSE, "display_freq",                   CFG_TYPE_INT,     &display_freq,                    -1 },

  // обслуживание: прочее                            
  { NULL, FALSE, "turn_off_idle",                  CFG_TYPE_INT,     &turn_off_idle,                   0 },
  { NULL, FALSE, "use_logoff_in_turn_off_idle",    CFG_TYPE_BOOL,    &use_logoff_in_turn_off_idle,     FALSE },
  { NULL, FALSE, "client_restore",                 CFG_TYPE_PATH,    &client_restore,                  NULL },
  { NULL, FALSE, "use_time_limitation",            CFG_TYPE_BOOL,    &use_time_limitation,             FALSE },
  { NULL, FALSE, "time_limitation_intervals",      CFG_TYPE_STRING,  &time_limitation_intervals,       _C("8:00-13:30,14:30-18:00") },
  { NULL, FALSE, "time_limitation_action",         CFG_TYPE_INT,     &time_limitation_action,          0 },

  // контент
  { NULL, FALSE, "g_content",                      CFG_TYPE_CONTENT, &g_content,                       _C(def_content) },


//////////////////////////////////////////////////
// comp_specific vars
//////////////////////////////////////////////////

  // rollback
  { NULL, FALSE, "use_rollback",                   CFG_TYPE_BOOL,    &use_rollback,                    FALSE },
  { NULL, FALSE, "rollback_disks",                 CFG_TYPE_INT,     &rollback_disks,                  0x4 },
  { NULL, FALSE, "rollback_excl",                  CFG_TYPE_LIST1,   &rollback_excl,                   _C(def_rollback_excl) },
  { NULL, FALSE, "used_another_rollback",          CFG_TYPE_BOOL,    &used_another_rollback,           FALSE },

};




class CConfig
{
          static const int MAXLISTITEMS_BWC = 200;  // the same value in rssettings\setupvars.pas, rp_shared and some bodytools
  
  public:
          static void ReadConfig(const void *block,int block_size,int lang,int machine_type);
          static void WriteBWCConfig();
          static void* WriteConfig(BOOL write_vars,BOOL write_content,int *_size);

  private:
          static BOOL ReadConfigBool(const char* &src,int &src_size,BOOL *p_value);
          static BOOL ReadConfigInt(const char* &src,int &src_size,int *p_value);
          static BOOL ReadConfigStr(const char* &src,int &src_size,char *p_value,int max);
          static BOOL ReadConfigShortcut(const char* &src,int &src_size,CSheet *sh,int lang,int machine_type);
          static BOOL ReadConfigSheet(const char* &src,int &src_size,CContent *cnt,int lang,int machine_type);
          static BOOL ReadConfigItem(const void *block,int block_size,const char *d_name,int d_type,void *d_value,int lang,int machine_type);
          static void ReadConfigItemsList(const TGLOBALCFGITEM *list,int list_count,const char *block,int block_size,int lang,int machine_type);
          static void GetDefConfigItem(const TGLOBALCFGITEM *item,int lang,int machine_type);
          static void LoadDefShortcut(CContent *dest,const TDEFSHEET *def_sheet,const TDEFSHORTCUT *def_shortcut,int lang,int machine_type);
          static void WriteBWCList1(const char *bwc_name,const TCFGLIST1 *list,BOOL need_expand);
          static void WriteBWCList2(const char *bwc_name,const TCFGLIST2 *list,BOOL need_expand);
          static void WriteSingleItem(const TGLOBALCFGITEM *item,CBuff &buff);
          static void WriteSingleSheet(const CSheet *sheet,CBuff &buff);
          static void WriteSingleShortcut(const CShortcut *shortcut,CBuff &buff);
          static TGLOBALCFGITEM* FindCfgItem(const char *name,int type);
          static CContent* FindContentItem();

  public:        
          static BOOL CfgGetBoolValue(const char *name);
          static void CfgSetBoolValue(const char *name,BOOL value);
          static int CfgGetIntValue(const char *name);
          static void CfgSetIntValue(const char *name,int value);
          static const char* CfgGetPathValue(const char *name);
          static void CfgSetPathValue(const char *name,const char *value);
          static const char* CfgGetStringValue(const char *name);
          static void CfgSetStringValue(const char *name,const char *value);
          static const char* CfgGetLongStringValue(const char *name);
          static void CfgSetLongStringValue(const char *name,const char *value);
          static BOOL CfgGetList1Value(const char *name,int idx,const char **parm1);
          static void CfgSetList1Value(const char *name,int idx,BOOL state,const char *parm1);
          static BOOL CfgGetList2Value(const char *name,int idx,const char **parm1,const char **parm2);
          static void CfgSetList2Value(const char *name,int idx,BOOL state,const char *parm1,const char *parm2);
          static int CfgGetCntSheetsCount();
          static CSheet* CfgGetCntSheetAt(int idx);
          static int CfgGetCntShortcutsCount(const CSheet *sh);
          static CShortcut* CfgGetCntShortcutAt(CSheet *sh,int idx);
          static void CfgGetCntSheetVars(const CSheet *sh,TSHEETVARS *out);
          static void CfgGetCntShortcutVars(const CShortcut *sh,TSHORTCUTVARS *out);
          static CSheet* CfgAddCntSheet(const char *name);
          static CShortcut* CfgAddCntShortcut(CSheet *sh,const char *name);
          static void CfgSetCntSheetVars(CSheet *sh,TSHEETVARS *in);
          static void CfgSetCntShortcutVars(CShortcut *sh,TSHORTCUTVARS *in);
          static void CfgMoveCntSheet(int from,int to);
          static void CfgMoveCntShortcut(CSheet *sh,int from,int to);
          static void CfgDelCntSheet(int idx);
          static void CfgDelCntShortcut(CSheet *sh,int idx);
          static void CfgClearCnt();

};



BOOL CConfig::ReadConfigBool(const char* &src,int &src_size,BOOL *p_value)
{
  BOOL rc = FALSE;

  if ( src && src_size > 0 )
     {
       if ( src_size >= sizeof(BOOL) )
          {
            *p_value = *(const BOOL *)src;

            src += sizeof(BOOL);
            src_size -= sizeof(BOOL);

            rc = TRUE;
          }
     }

  return rc;
}


BOOL CConfig::ReadConfigInt(const char* &src,int &src_size,int *p_value)
{
  BOOL rc = FALSE;

  if ( src && src_size > 0 )
     {
       if ( src_size >= sizeof(int) )
          {
            *p_value = *(const int *)src;

            src += sizeof(int);
            src_size -= sizeof(int);

            rc = TRUE;
          }
     }

  return rc;
}


BOOL CConfig::ReadConfigStr(const char* &src,int &src_size,char *p_value,int max)
{
  BOOL rc = FALSE;

  if ( src && src_size > 0 && max > 0 )
     {
       int count = 0;
       
       do {
         char c = *src++;
         src_size--;

         *p_value++ = c;
         count++;

         if ( count == max || src_size == 0 || c == 0 )
            {
              rc = (c == 0);
              break;
            }

       } while ( 1 );
     }

  return rc;
}


BOOL CConfig::ReadConfigShortcut(const char* &src,int &src_size,CSheet *sh,int lang,int machine_type)
{
  int size;

  if ( !ReadConfigInt(src,src_size,&size) )
     return FALSE;

  if ( size < 0 || size > src_size )
     return FALSE;

  TSTRING s_name = "";
  TPATH s_exe = "";
  TSTRING s_arg = "";
  TPATH s_cwd = "";
  TPATH s_icon_path = "";
  int i_icon_idx = 0;
  TSTRING s_pwd = "";
  BOOL b_allow_only_one = TRUE;
  TSTRING s_runas_domain = "";
  TSTRING s_runas_user = "";
  TSTRING s_runas_pwd = "";
  int i_show_cmd = SW_NORMAL;
  int i_vcd_num = -1;
  TPATH s_vcd = "";
  TLONGSTRING s_saver = "";
  TPATH s_sshot = "";
  TLONGSTRING s_desc = "";
  TLONGSTRING s_script1 = "";
  TSTRING s_group = "";
  TPATH s_floatlic = "";
     
  const TGLOBALCFGITEM list[] = 
  {
    { NULL, FALSE, S_SH_S_NAME,           CFG_TYPE_STRING,    &s_name          ,           NULL },
    { NULL, FALSE, S_SH_S_EXE,            CFG_TYPE_PATH,      &s_exe           ,           NULL },
    { NULL, FALSE, S_SH_S_ARG,            CFG_TYPE_STRING,    &s_arg           ,           NULL },
    { NULL, FALSE, S_SH_S_CWD,            CFG_TYPE_PATH,      &s_cwd           ,           NULL },
    { NULL, FALSE, S_SH_S_ICON_PATH,      CFG_TYPE_PATH,      &s_icon_path     ,           NULL },
    { NULL, FALSE, S_SH_I_ICON_IDX,       CFG_TYPE_INT,       &i_icon_idx      ,           0 },
    { NULL, FALSE, S_SH_S_PWD,            CFG_TYPE_STRING,    &s_pwd           ,           NULL },
    { NULL, FALSE, S_SH_B_ALLOW_ONLY_ONE, CFG_TYPE_BOOL,      &b_allow_only_one,           TRUE },
    { NULL, FALSE, S_SH_S_RUNAS_DOMAIN,   CFG_TYPE_STRING,    &s_runas_domain  ,           NULL },
    { NULL, FALSE, S_SH_S_RUNAS_USER,     CFG_TYPE_STRING,    &s_runas_user    ,           NULL },
    { NULL, FALSE, S_SH_S_RUNAS_PWD,      CFG_TYPE_STRING,    &s_runas_pwd     ,           NULL },
    { NULL, FALSE, S_SH_I_SHOW_CMD,       CFG_TYPE_INT,       &i_show_cmd      ,           SW_NORMAL },
    { NULL, FALSE, S_SH_I_VCD_NUM,        CFG_TYPE_INT,       &i_vcd_num       ,           -1 },
    { NULL, FALSE, S_SH_S_VCD,            CFG_TYPE_PATH,      &s_vcd           ,           NULL },
    { NULL, FALSE, S_SH_S_SAVER,          CFG_TYPE_LONGSTRING,&s_saver         ,           NULL },
    { NULL, FALSE, S_SH_S_SSHOT,          CFG_TYPE_PATH,      &s_sshot         ,           NULL },
    { NULL, FALSE, S_SH_S_DESC,           CFG_TYPE_LONGSTRING,&s_desc          ,           NULL },
    { NULL, FALSE, S_SH_S_SCRIPT1,        CFG_TYPE_LONGSTRING,&s_script1       ,           NULL },
    { NULL, FALSE, S_SH_S_GROUP,          CFG_TYPE_STRING,    &s_group         ,           NULL },
    { NULL, FALSE, S_SH_S_FLOATLIC,       CFG_TYPE_PATH,      &s_floatlic      ,           NULL },
  };

  ReadConfigItemsList(list,sizeof(list)/sizeof(list[0]),src,size,lang,machine_type);

  if ( !s_name[0] )
     return FALSE;

  if ( !sh->FindShortcutByName(s_name) )
     {
       CShortcut *shortcut = new CShortcut(s_name,s_exe,s_arg,s_cwd,s_icon_path,i_icon_idx,s_pwd,b_allow_only_one,s_runas_domain,s_runas_user,s_runas_pwd,i_show_cmd,i_vcd_num,s_vcd,s_saver,s_sshot,s_desc,s_script1,s_group,s_floatlic);
       sh->AddShortcut(shortcut);
     }

  src += size;
  src_size -= size;

  return TRUE;
}


BOOL CConfig::ReadConfigSheet(const char* &src,int &src_size,CContent *cnt,int lang,int machine_type)
{
  int sizeof_header;

  if ( !ReadConfigInt(src,src_size,&sizeof_header) )
     return FALSE;

  if ( sizeof_header < 0 || sizeof_header > src_size )
     return FALSE;


  TSTRING s_name = "";
  TPATH s_icon_path = "";
  int i_color = 0;
  int i_bg_color = 0;
  TPATH s_bg_pic = "";
  TPATH s_bg_thumb_pic = "";
  int i_time_min = 0;
  int i_time_max = 24;
  TSTRING s_vip_users = "";
  TPATH s_rules = "";
  BOOL is_internet_sheet = FALSE;
  
  const TGLOBALCFGITEM list[] = 
  {
    { NULL, FALSE, S_SH_S_NAME,            CFG_TYPE_STRING,  &s_name           ,  NULL },
    { NULL, FALSE, S_SH_S_ICON_PATH,       CFG_TYPE_PATH,    &s_icon_path      ,  NULL },
    { NULL, FALSE, S_SH_I_COLOR,           CFG_TYPE_INT,     &i_color          ,  0 },
    { NULL, FALSE, S_SH_I_BG_COLOR,        CFG_TYPE_INT,     &i_bg_color       ,  0 },
    { NULL, FALSE, S_SH_S_BG_PIC,          CFG_TYPE_PATH,    &s_bg_pic         ,  NULL },
    { NULL, FALSE, S_SH_S_BG_THUMB_PIC,    CFG_TYPE_PATH,    &s_bg_thumb_pic   ,  NULL },
    { NULL, FALSE, S_SH_I_TIME_MIN,        CFG_TYPE_INT,     &i_time_min       ,  0 },
    { NULL, FALSE, S_SH_I_TIME_MAX,        CFG_TYPE_INT,     &i_time_max       ,  24 },
    { NULL, FALSE, S_SH_S_VIP_USERS,       CFG_TYPE_STRING,  &s_vip_users      ,  NULL },
    { NULL, FALSE, S_SH_S_RULES,           CFG_TYPE_PATH,    &s_rules          ,  NULL },
    { NULL, FALSE, S_SH_IS_INTERNET_SHEET, CFG_TYPE_BOOL,    &is_internet_sheet,  FALSE },
  };

  ReadConfigItemsList(list,sizeof(list)/sizeof(list[0]),src,sizeof_header,lang,machine_type);

  if ( !s_name[0] )
     return FALSE;

  src += sizeof_header;
  src_size -= sizeof_header;
  
  CSheet *sh = new CSheet(s_name,s_icon_path,i_color,i_bg_color,s_bg_pic,s_bg_thumb_pic,i_time_min,i_time_max,s_vip_users,s_rules,is_internet_sheet);

  int numshortcuts;
  
  if ( !ReadConfigInt(src,src_size,&numshortcuts) || numshortcuts < 0 )
     {
       delete sh;
       return FALSE;
     }

  for ( int n = 0; n < numshortcuts; n++ )
      {
        if ( !ReadConfigShortcut(src,src_size,sh,lang,machine_type) )
           {
             delete sh;
             return FALSE;
           }
      }

  if ( !cnt->FindSheetByName(s_name) )
     {
       cnt->AddSheet(sh);
     }
  else
     {
       delete sh;
     }

  return TRUE;
}


BOOL CConfig::ReadConfigItem(const void *block,int block_size,const char *d_name,int d_type,void *d_value,int lang,int machine_type)
{
  BOOL rc = FALSE;

  const char *src = (const char *)block;
  int src_size = block_size;
  
  while ( src_size > 0 )
  {
    char c_name[MAX_PATH];
    int c_type;
    int c_size;
    
    if ( !ReadConfigStr(src,src_size,c_name,sizeof(c_name)) )
       break;

    if ( !c_name[0] )
       break;

    if ( !ReadConfigInt(src,src_size,&c_type) )
       break;

    if ( c_type == CFG_TYPE_NONE )
       break;

    if ( !ReadConfigInt(src,src_size,&c_size) )
       break;

    if ( c_size <= 0 || c_size > src_size )
       break;

    if ( !lstrcmp(c_name,d_name) )
       {
         if ( c_type != d_type )
            break;

         switch ( c_type )
         {
           case CFG_TYPE_BOOL:
                                 if ( c_size == sizeof(BOOL) )
                                    {
                                      BOOL c_value;
                                      
                                      if ( !ReadConfigBool(src,src_size,&c_value) )
                                         break;

                                      *(BOOL*)d_value = c_value;
                                      rc = TRUE;
                                    }
                                 break;
           case CFG_TYPE_INT:
                                 if ( c_size == sizeof(int) )
                                    {
                                      int c_value;
                                      
                                      if ( !ReadConfigInt(src,src_size,&c_value) )
                                         break;

                                      *(int*)d_value = c_value;
                                      rc = TRUE;
                                    }
                                 break;
           case CFG_TYPE_PATH:
                                 if ( c_size <= sizeof(TPATH) )
                                    {
                                      TPATH c_value;
                                      
                                      if ( !ReadConfigStr(src,src_size,c_value,sizeof(c_value)) )
                                         break;

                                      lstrcpy((char*)d_value,c_value);
                                      rc = TRUE;
                                    }
                                 break;
           case CFG_TYPE_STRING:
                                 if ( c_size <= sizeof(TSTRING) )
                                    {
                                      TSTRING c_value;
                                      
                                      if ( !ReadConfigStr(src,src_size,c_value,sizeof(c_value)) )
                                         break;

                                      lstrcpy((char*)d_value,c_value);
                                      rc = TRUE;
                                    }
                                 break;
           case CFG_TYPE_LONGSTRING:
                                 if ( c_size <= sizeof(TLONGSTRING) )
                                    {
                                      TLONGSTRING c_value;
                                      
                                      if ( !ReadConfigStr(src,src_size,c_value,sizeof(c_value)) )
                                         break;

                                      lstrcpy((char*)d_value,c_value);
                                      rc = TRUE;
                                    }
                                 break;
           case CFG_TYPE_LIST1:
                                 if ( c_size >= sizeof(int) )
                                    {
                                      int count;
                                      
                                      if ( !ReadConfigInt(src,src_size,&count) )
                                         break;

                                      if ( count < 0 )
                                         break;

                                      TCFGLIST1 *list = (TCFGLIST1*)d_value;

                                      list->clear();
                                      rc = TRUE;

                                      for ( int n = 0; n < count; n++ )
                                          {
                                            BOOL state;
                                            if ( !ReadConfigBool(src,src_size,&state) )
                                               break;
                                            
                                            TSTRING parm1;
                                            if ( !ReadConfigStr(src,src_size,parm1,sizeof(parm1)) )
                                               break;

                                            list->push_back(CCfgEntry1());
                                            list->back().Load(state,parm1);
                                          }
                                    }
                                 break;
           case CFG_TYPE_LIST2:
                                 if ( c_size >= sizeof(int) )
                                    {
                                      int count;
                                      
                                      if ( !ReadConfigInt(src,src_size,&count) )
                                         break;

                                      if ( count < 0 )
                                         break;

                                      TCFGLIST2 *list = (TCFGLIST2*)d_value;

                                      list->clear();
                                      rc = TRUE;

                                      for ( int n = 0; n < count; n++ )
                                          {
                                            BOOL state;
                                            if ( !ReadConfigBool(src,src_size,&state) )
                                               break;
                                            
                                            TSTRING parm1;
                                            if ( !ReadConfigStr(src,src_size,parm1,sizeof(parm1)) )
                                               break;

                                            TSTRING parm2;
                                            if ( !ReadConfigStr(src,src_size,parm2,sizeof(parm2)) )
                                               break;

                                            list->push_back(CCfgEntry2());
                                            list->back().Load(state,parm1,parm2);
                                          }
                                    }
                                 break;
           case CFG_TYPE_CONTENT:
                                 if ( c_size >= sizeof(int) )
                                    {
                                      int count;
                                      
                                      if ( !ReadConfigInt(src,src_size,&count) )
                                         break;

                                      if ( count < 0 )
                                         break;

                                      CContent *cnt = (CContent*)d_value;
                                      cnt->Clear();
                                      rc = TRUE;

                                      for ( int n = 0; n < count; n++ )
                                          {
                                            if ( !ReadConfigSheet(src,src_size,cnt,lang,machine_type) )
                                               break;
                                          }
                                    }
                                 break;
         };

         break;
       }
    else
       {
         // skip data
         src += c_size;
         src_size -= c_size;
       }
  };

  return rc;
}


void CConfig::LoadDefShortcut(CContent *cnt,const TDEFSHEET *def_sheet,const TDEFSHORTCUT *def_shortcut,int lang,int machine_type)
{
  if ( def_sheet && def_shortcut )
     {
       const char *name = LS(def_sheet->name_id,lang);

       if ( name && name[0] )
          {
            CSheet *sheet = cnt->FindSheetByName(name);

            if ( !sheet )
               {
                 const char *icon_path = def_sheet->icon_path;
                 int color = def_sheet->color;
                 int bg_color = def_sheet->bg_color;
                 const char *bg_pic = def_sheet->bg_pic;
                 const char *bg_thumb_pic = def_sheet->bg_thumb_pic;
                 int time_min = def_sheet->time_min;
                 int time_max = def_sheet->time_max;
                 const char *vip_users = def_sheet->vip_users;
                 const char *rules = LS(def_sheet->rules_id,lang);
                 BOOL is_internet = def_sheet->is_internet;

                 sheet = new CSheet(name,icon_path,color,bg_color,bg_pic,bg_thumb_pic,time_min,time_max,vip_users,rules,is_internet);
                 cnt->AddSheet(sheet);
               }

            const char *s_name = LS(def_shortcut->name_id,lang);
            const char *s_exe = def_shortcut->exe;
            const char *s_arg = def_shortcut->arg;
            const char *s_desc = LS(def_shortcut->desc_id,lang);
            const char *s_group = LS(def_shortcut->group_id,lang);

            if ( !sheet->FindShortcutByName(s_name) )
               {
                 CShortcut *shortcut = new CShortcut(s_name,s_exe,s_arg,NULL,NULL,0,NULL,TRUE,NULL,NULL,NULL,SW_NORMAL,-1,NULL,NULL,NULL,s_desc,NULL,s_group,NULL);
                 sheet->AddShortcut(shortcut);
               }
          }
     }
}


void CConfig::GetDefConfigItem(const TGLOBALCFGITEM *item,int lang,int machine_type)
{
  const char *def_str = NULL;

  DWORD_PTR def = item->def_value;

  switch ( item->type )
  {
    case CFG_TYPE_BOOL:
                           *(BOOL*)item->value = (BOOL)def;
                           break;
    case CFG_TYPE_INT:
                           *(int*)item->value = (int)def;
                           break;
    case CFG_TYPE_PATH:
                           def_str = LS(def,lang);
                           lstrcpyn((char*)item->value,def_str?def_str:"",sizeof(TPATH));
                           break;
    case CFG_TYPE_STRING:
                           def_str = LS(def,lang);
                           lstrcpyn((char*)item->value,def_str?def_str:"",sizeof(TSTRING));
                           break;
    case CFG_TYPE_LONGSTRING:
                           def_str = LS(def,lang);
                           lstrcpyn((char*)item->value,def_str?def_str:"",sizeof(TLONGSTRING));
                           break;
    case CFG_TYPE_LIST1:
                           {
                             TCFGLIST1 *dest = (TCFGLIST1*)item->value;
                             
                             dest->clear();

                             const TDEFITEMLIST1 *src = (const TDEFITEMLIST1*)def;
                             if ( src )
                                {
                                  do {
                                   BOOL state = src->state;
                                   const char *parm = LS(src->parm_id,lang);
                                   
                                   if ( !state && !src->parm_id )
                                      break;

                                   src++;

                                   dest->push_back(CCfgEntry1());
                                   dest->back().Load(state,parm);

                                  } while (1);
                                }
                           }
                           break;
    case CFG_TYPE_LIST2:
                           {
                             TCFGLIST2 *dest = (TCFGLIST2*)item->value;
                             
                             dest->clear();

                             const TDEFITEMLIST2 *src = (const TDEFITEMLIST2*)def;
                             if ( src )
                                {
                                  do {
                                   BOOL state = src->state;
                                   const char *parm1 = LS(src->parm1_id,lang);
                                   const char *parm2 = LS(src->parm2_id,lang);
                                   
                                   if ( !state && !src->parm1_id && !src->parm2_id )
                                      break;

                                   src++;

                                   dest->push_back(CCfgEntry2());
                                   dest->back().Load(state,parm1,parm2);

                                  } while (1);
                                }
                           }
                           break;
    case CFG_TYPE_CONTENT:
                           {
                             CContent *dest = (CContent*)item->value;

                             dest->Clear();

                             const TDEFCONTENTITEM *src = (const TDEFCONTENTITEM*)def;
                             if ( src )
                                {
                                  do {
                                   int type_mask = src->machine_type_mask;
                                   const TDEFSHEET *def_sheet = src->sheet;
                                   const TDEFSHORTCUT *def_shortcut = src->shortcut;

                                   src++;

                                   if ( !def_sheet || !def_shortcut )
                                      break;

                                   if ( type_mask & machine_type )
                                      {
                                        LoadDefShortcut(dest,def_sheet,def_shortcut,lang,machine_type);
                                      }

                                  } while (1);
                                }
                           }
                           break;
  };
}


void CConfig::ReadConfigItemsList(const TGLOBALCFGITEM *list,int list_count,const char *block,int block_size,int lang,int machine_type)
{
  for ( int n = 0; n < list_count; n++ )
      {
        const TGLOBALCFGITEM *item = list+n;

        if ( !ReadConfigItem(block,block_size,item->name,item->type,item->value,lang,machine_type) )
           {
             GetDefConfigItem(item,lang,machine_type);
           }
      }
}


void CConfig::ReadConfig(const void *block,int block_size,int lang,int machine_type)
{
  ReadConfigItemsList(cfg_items,sizeof(cfg_items)/sizeof(cfg_items[0]),(const char*)block,block_size,lang,machine_type);
}


void CConfig::WriteBWCList1(const char *bwc_name,const TCFGLIST1 *list,BOOL need_expand)
{
  char key[MAX_PATH];
  wsprintf(key,"%s\\%s",REGPATH,bwc_name);

  DeleteRegKey(HKCU,key);

  HKEY h;
  if ( RegCreateKeyEx(HKCU,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       const int count = MAX(MAXLISTITEMS_BWC,list->size());
       
       for ( int n = 0; n < count; n++ )
           {
             BOOL state;
             const char *parm1;
             
             if ( n < list->size() )
                {
                  state = (*list)[n].GetState();
                  parm1 = (*list)[n].GetParm();
                }
             else
                {
                  state = FALSE;
                  parm1 = NULL;
                }

             char s[32];
             wsprintf(s,"state_%d",n+1);
             WriteRegDwordP(h,s,state?1:0);
             wsprintf(s,"parm1_%d",n+1);
             WriteRegStrP(h,s,parm1?(need_expand?CPathExpander(parm1):parm1):"");
             wsprintf(s,"parm2_%d",n+1);
             WriteRegStrP(h,s,"");
           }
     
       RegCloseKey(h);
     }
}


void CConfig::WriteBWCList2(const char *bwc_name,const TCFGLIST2 *list,BOOL need_expand)
{
  char key[MAX_PATH];
  wsprintf(key,"%s\\%s",REGPATH,bwc_name);

  DeleteRegKey(HKCU,key);

  HKEY h;
  if ( RegCreateKeyEx(HKCU,key,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       const int count = MAX(MAXLISTITEMS_BWC,list->size());
       
       for ( int n = 0; n < count; n++ )
           {
             BOOL state;
             const char *parm1;
             const char *parm2;
             
             if ( n < list->size() )
                {
                  state = (*list)[n].GetState();
                  parm1 = (*list)[n].GetParm1();
                  parm2 = (*list)[n].GetParm2();
                }
             else
                {
                  state = FALSE;
                  parm1 = NULL;
                  parm2 = NULL;
                }

             char s[32];
             wsprintf(s,"state_%d",n+1);
             WriteRegDwordP(h,s,state?1:0);
             wsprintf(s,"parm1_%d",n+1);
             WriteRegStrP(h,s,parm1?parm1:"");
             wsprintf(s,"parm2_%d",n+1);
             WriteRegStrP(h,s,parm2?(need_expand?CPathExpander(parm2):parm2):"");
           }
     
       RegCloseKey(h);
     }
}



void CConfig::WriteBWCConfig()
{
  for ( int n = 0; n < sizeof(cfg_items)/sizeof(cfg_items[0]); n++ )
      {
        const TGLOBALCFGITEM *item = &cfg_items[n];

        if ( item->bwc_name && item->bwc_name[0] )
           {
             switch ( item->type )
             {
               case CFG_TYPE_BOOL:
                                    WriteRegDword(HKCU,REGPATH,item->bwc_name,(*(BOOL*)item->value)?1:0);
                                    break;
               case CFG_TYPE_INT:
                                    WriteRegDword(HKCU,REGPATH,item->bwc_name,*(int*)item->value);
                                    break;
               case CFG_TYPE_PATH:
               case CFG_TYPE_STRING:
               case CFG_TYPE_LONGSTRING:
                                    if ( item->bwc_expand )
                                       WriteRegStr(HKCU,REGPATH,item->bwc_name,CPathExpander((const char*)item->value));
                                    else
                                       WriteRegStr(HKCU,REGPATH,item->bwc_name,(const char*)item->value);
                                    break;
               case CFG_TYPE_LIST1:
                                    WriteBWCList1(item->bwc_name,(const TCFGLIST1*)item->value,item->bwc_expand);
                                    break;
               case CFG_TYPE_LIST2:
                                    WriteBWCList2(item->bwc_name,(const TCFGLIST2*)item->value,item->bwc_expand);
                                    break;
             };
           }
      }
}


void* CConfig::WriteConfig(BOOL write_vars,BOOL write_content,int *_size)
{
  *_size = 0;

  if ( !write_vars && !write_content )
     return NULL;

  int size = 0;
  
  {
    CBuff oBuff(NULL); //write emulator
    
    for ( int n = 0; n < sizeof(cfg_items)/sizeof(cfg_items[0]); n++ )
        {
          const TGLOBALCFGITEM *item = &cfg_items[n];

          if ( (item->type == CFG_TYPE_CONTENT && write_content) ||
               (item->type != CFG_TYPE_CONTENT && write_vars) )
             {
               WriteSingleItem(item,oBuff);
             }
        }

    size = oBuff.GetSize();
  }

  if ( !size )
     return NULL;

  char *orig_buff = (char*)sys_alloc(size);

  {
    CBuff oBuff(orig_buff);
    
    for ( int n = 0; n < sizeof(cfg_items)/sizeof(cfg_items[0]); n++ )
        {
          const TGLOBALCFGITEM *item = &cfg_items[n];

          if ( (item->type == CFG_TYPE_CONTENT && write_content) ||
               (item->type != CFG_TYPE_CONTENT && write_vars) )
             {
               WriteSingleItem(item,oBuff);
             }
        }
  }

  *_size = size;
  return (void*)orig_buff;
}


void CConfig::WriteSingleItem(const TGLOBALCFGITEM *item,CBuff &buff)
{
  buff.AddString(item->name);
  buff.AddInt(item->type);
  
  switch ( item->type )
  {
    case CFG_TYPE_BOOL:
                          buff.Push();
                          buff.AddBool(*(BOOL*)item->value);
                          buff.Pop();
                          break;
    case CFG_TYPE_INT:
                          buff.Push();
                          buff.AddInt(*(int*)item->value);
                          buff.Pop();
                          break;
    case CFG_TYPE_PATH:
    case CFG_TYPE_STRING:
    case CFG_TYPE_LONGSTRING:
                          buff.Push();
                          buff.AddString((const char*)item->value);
                          buff.Pop();
                          break;
    case CFG_TYPE_LIST1:
                          {
                            buff.Push();

                            const TCFGLIST1 *list = (const TCFGLIST1*)item->value;
                            int count = 0;
                            for ( int n = 0; n < list->size(); n++ )
                                if ( !(*list)[n].IsEmpty() )
                                   count++;

                            buff.AddInt(count);

                            for ( int n = 0; n < list->size(); n++ )
                                if ( !(*list)[n].IsEmpty() )
                                   {
                                     const CCfgEntry1 *item = &(*list)[n];
                                     buff.AddBool(item->GetState());
                                     buff.AddString(item->GetParm());
                                   }
                                   
                            buff.Pop();
                          }
                          break;
    case CFG_TYPE_LIST2:
                          {
                            buff.Push();

                            const TCFGLIST2 *list = (const TCFGLIST2*)item->value;
                            int count = 0;
                            for ( int n = 0; n < list->size(); n++ )
                                if ( !(*list)[n].IsEmpty() )
                                   count++;

                            buff.AddInt(count);

                            for ( int n = 0; n < list->size(); n++ )
                                if ( !(*list)[n].IsEmpty() )
                                   {
                                     const CCfgEntry2 *item = &(*list)[n];
                                     buff.AddBool(item->GetState());
                                     buff.AddString(item->GetParm1());
                                     buff.AddString(item->GetParm2());
                                   }
                                   
                            buff.Pop();
                          }
                          break;
    case CFG_TYPE_CONTENT:
                          {
                            buff.Push();

                            const CContent *cnt = (const CContent*)item->value;

                            buff.AddInt(cnt->GetCount()); //sheets_count

                            for ( int n = 0; n < cnt->GetCount(); n++ )
                                {
                                  WriteSingleSheet(&(*cnt)[n],buff);
                                }

                            buff.Pop();
                          }
                          break;
    default:
                          buff.AddInt(0);  //assert()
                          break;
  };
}


void CConfig::WriteSingleSheet(const CSheet *sheet,CBuff &buff)
{
  // header
  buff.Push();

  const char* s_name = sheet->GetName();
  const char* s_icon_path = sheet->GetIconPath();
  int i_color = sheet->GetColor();
  int i_bg_color = sheet->GetBGColor();
  const char* s_bg_pic = sheet->GetBGPath();
  const char* s_bg_thumb_pic = sheet->GetBGThumbPath();
  int i_time_min = sheet->GetTimeMin();
  int i_time_max = sheet->GetTimeMax();
  const char* s_vip_users = sheet->GetVIPUsers();
  const char* s_rules = sheet->GetRulesPath();
  BOOL is_internet_sheet = sheet->IsInternetSheet();
  
  const TGLOBALCFGITEM list[] = 
  {
    { NULL, FALSE, S_SH_S_NAME,            CFG_TYPE_STRING,  (void*)s_name            , NULL },
    { NULL, FALSE, S_SH_S_ICON_PATH,       CFG_TYPE_PATH,    (void*)s_icon_path       , NULL },
    { NULL, FALSE, S_SH_I_COLOR,           CFG_TYPE_INT,     (void*)&i_color          , NULL },
    { NULL, FALSE, S_SH_I_BG_COLOR,        CFG_TYPE_INT,     (void*)&i_bg_color       , NULL },
    { NULL, FALSE, S_SH_S_BG_PIC,          CFG_TYPE_PATH,    (void*)s_bg_pic          , NULL },
    { NULL, FALSE, S_SH_S_BG_THUMB_PIC,    CFG_TYPE_PATH,    (void*)s_bg_thumb_pic    , NULL },
    { NULL, FALSE, S_SH_I_TIME_MIN,        CFG_TYPE_INT,     (void*)&i_time_min       , NULL },
    { NULL, FALSE, S_SH_I_TIME_MAX,        CFG_TYPE_INT,     (void*)&i_time_max       , NULL },
    { NULL, FALSE, S_SH_S_VIP_USERS,       CFG_TYPE_STRING,  (void*)s_vip_users       , NULL },
    { NULL, FALSE, S_SH_S_RULES,           CFG_TYPE_PATH,    (void*)s_rules           , NULL },
    { NULL, FALSE, S_SH_IS_INTERNET_SHEET, CFG_TYPE_BOOL,    (void*)&is_internet_sheet, NULL },
  };

  for ( int n = 0; n < sizeof(list)/sizeof(list[0]); n++ )
      {
        const TGLOBALCFGITEM *item = &list[n];
        WriteSingleItem(item,buff);
      }

  buff.Pop();

  //shortcuts
  buff.AddInt(sheet->GetCount());  //numshortcuts

  for ( int n = 0; n < sheet->GetCount(); n++ )
      {
        WriteSingleShortcut(&(*sheet)[n],buff);
      }
}


void CConfig::WriteSingleShortcut(const CShortcut *shortcut,CBuff &buff)
{
  buff.Push();

  const char* s_name = shortcut->GetName();
  const char* s_exe = shortcut->GetExePath();
  const char* s_arg = shortcut->GetArg();
  const char* s_cwd = shortcut->GetCWD();
  const char* s_icon_path = shortcut->GetIconPath();
  int i_icon_idx = shortcut->GetIconIdx();
  const char* s_pwd = shortcut->GetPassword();
  BOOL b_allow_only_one = shortcut->GetAllowOnlyOne();
  const char* s_runas_domain = shortcut->GetRunAsDomain();
  const char* s_runas_user = shortcut->GetRunAsUser();
  const char* s_runas_pwd = shortcut->GetRunAsPassword();
  int i_show_cmd = shortcut->GetShowCmd();
  int i_vcd_num = shortcut->GetVCDNum();
  const char* s_vcd = shortcut->GetVCDPath();
  const char* s_saver = shortcut->GetSaver();
  const char* s_sshot = shortcut->GetSShotPath();
  const char* s_desc = shortcut->GetDescription();
  const char* s_script1 = shortcut->GetScript1();
  const char* s_group = shortcut->GetGroup();
  const char* s_floatlic = shortcut->GetFloatLic();

  const TGLOBALCFGITEM list[] = 
  {
    { NULL, FALSE, S_SH_S_NAME,           CFG_TYPE_STRING,    (void*)s_name           ,           NULL },
    { NULL, FALSE, S_SH_S_EXE,            CFG_TYPE_PATH,      (void*)s_exe            ,           NULL },
    { NULL, FALSE, S_SH_S_ARG,            CFG_TYPE_STRING,    (void*)s_arg            ,           NULL },
    { NULL, FALSE, S_SH_S_CWD,            CFG_TYPE_PATH,      (void*)s_cwd            ,           NULL },
    { NULL, FALSE, S_SH_S_ICON_PATH,      CFG_TYPE_PATH,      (void*)s_icon_path      ,           NULL },
    { NULL, FALSE, S_SH_I_ICON_IDX,       CFG_TYPE_INT,       (void*)&i_icon_idx      ,           NULL },
    { NULL, FALSE, S_SH_S_PWD,            CFG_TYPE_STRING,    (void*)s_pwd            ,           NULL },
    { NULL, FALSE, S_SH_B_ALLOW_ONLY_ONE, CFG_TYPE_BOOL,      (void*)&b_allow_only_one,           NULL },
    { NULL, FALSE, S_SH_S_RUNAS_DOMAIN,   CFG_TYPE_STRING,    (void*)s_runas_domain   ,           NULL },
    { NULL, FALSE, S_SH_S_RUNAS_USER,     CFG_TYPE_STRING,    (void*)s_runas_user     ,           NULL },
    { NULL, FALSE, S_SH_S_RUNAS_PWD,      CFG_TYPE_STRING,    (void*)s_runas_pwd      ,           NULL },
    { NULL, FALSE, S_SH_I_SHOW_CMD,       CFG_TYPE_INT,       (void*)&i_show_cmd      ,           NULL },
    { NULL, FALSE, S_SH_I_VCD_NUM,        CFG_TYPE_INT,       (void*)&i_vcd_num       ,           NULL },
    { NULL, FALSE, S_SH_S_VCD,            CFG_TYPE_PATH,      (void*)s_vcd            ,           NULL },
    { NULL, FALSE, S_SH_S_SAVER,          CFG_TYPE_LONGSTRING,(void*)s_saver          ,           NULL },
    { NULL, FALSE, S_SH_S_SSHOT,          CFG_TYPE_PATH,      (void*)s_sshot          ,           NULL },
    { NULL, FALSE, S_SH_S_DESC,           CFG_TYPE_LONGSTRING,(void*)s_desc           ,           NULL },
    { NULL, FALSE, S_SH_S_SCRIPT1,        CFG_TYPE_LONGSTRING,(void*)s_script1        ,           NULL },
    { NULL, FALSE, S_SH_S_GROUP,          CFG_TYPE_STRING,    (void*)s_group          ,           NULL },
    { NULL, FALSE, S_SH_S_FLOATLIC,       CFG_TYPE_PATH,      (void*)s_floatlic       ,           NULL },
  };

  for ( int n = 0; n < sizeof(list)/sizeof(list[0]); n++ )
      {
        const TGLOBALCFGITEM *item = &list[n];

        BOOL is_empty_string = (item->type == CFG_TYPE_STRING || item->type == CFG_TYPE_LONGSTRING || item->type == CFG_TYPE_PATH) && 
                               (!item->value || !*(const char*)item->value);
        
        if ( !is_empty_string ) //optimization
           {
             WriteSingleItem(item,buff);
           }
      }

  buff.Pop();
}


TGLOBALCFGITEM* CConfig::FindCfgItem(const char *name,int type)
{
  TGLOBALCFGITEM *rc = NULL;
  
  if ( name && name[0] )
     {
       for ( int n = 0; n < sizeof(cfg_items)/sizeof(cfg_items[0]); n++ )
           {
             if ( !lstrcmp(cfg_items[n].name,name) )
                {
                  if ( type == cfg_items[n].type )
                     {
                       rc = (TGLOBALCFGITEM*)&cfg_items[n];
                     }

                  break;
                }
           }
     }

  return rc;
}


BOOL CConfig::CfgGetBoolValue(const char *name)
{
  BOOL rc = FALSE;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_BOOL);

  if ( item )
     {
       rc = *(BOOL*)item->value;
     }

  return rc;
}


void CConfig::CfgSetBoolValue(const char *name,BOOL value)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_BOOL);

  if ( item )
     {
       *(BOOL*)item->value = value;
     }
}


int CConfig::CfgGetIntValue(const char *name)
{
  int rc = 0;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_INT);

  if ( item )
     {
       rc = *(int*)item->value;
     }

  return rc;
}


void CConfig::CfgSetIntValue(const char *name,int value)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_INT);

  if ( item )
     {
       *(int*)item->value = value;
     }
}


const char* CConfig::CfgGetPathValue(const char *name)
{
  const char* rc = NULL;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_PATH);

  if ( item )
     {
       rc = (const char*)item->value;
     }

  return rc;
}


void CConfig::CfgSetPathValue(const char *name,const char *value)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_PATH);

  if ( item )
     {
       lstrcpyn((char*)item->value,value?value:"",sizeof(TPATH));
     }
}


const char* CConfig::CfgGetStringValue(const char *name)
{
  const char* rc = NULL;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_STRING);

  if ( item )
     {
       rc = (const char*)item->value;
     }

  return rc;
}


void CConfig::CfgSetStringValue(const char *name,const char *value)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_STRING);

  if ( item )
     {
       lstrcpyn((char*)item->value,value?value:"",sizeof(TSTRING));
     }
}


const char* CConfig::CfgGetLongStringValue(const char *name)
{
  const char* rc = NULL;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LONGSTRING);

  if ( item )
     {
       rc = (const char*)item->value;
     }

  return rc;
}


void CConfig::CfgSetLongStringValue(const char *name,const char *value)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LONGSTRING);

  if ( item )
     {
       lstrcpyn((char*)item->value,value?value:"",sizeof(TLONGSTRING));
     }
}


BOOL CConfig::CfgGetList1Value(const char *name,int idx,const char **parm1)
{
  BOOL state = FALSE;

  *parm1 = NULL;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LIST1);

  if ( item )
     {
       const TCFGLIST1 *list = (const TCFGLIST1*)item->value;

       if ( idx >= 0 && idx < list->size() )
          {
            state = (*list)[idx].GetState();
            *parm1 = (*list)[idx].GetParm();
          }
       else
          {
            state = FALSE;
            *parm1 = "";
          }
     }

  return state;
}


void CConfig::CfgSetList1Value(const char *name,int idx,BOOL state,const char *parm1)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LIST1);

  if ( item )
     {
       TCFGLIST1 *list = (TCFGLIST1*)item->value;

       if ( idx >= list->size() )
          {
            list->resize(idx+1);
          }

       if ( idx >= 0 && idx < list->size() )
          {
            (*list)[idx].Load(state,parm1);
          }
     }
}



BOOL CConfig::CfgGetList2Value(const char *name,int idx,const char **parm1,const char **parm2)
{
  BOOL state = FALSE;

  *parm1 = NULL;
  *parm2 = NULL;
  
  const TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LIST2);

  if ( item )
     {
       const TCFGLIST2 *list = (const TCFGLIST2*)item->value;

       if ( idx >= 0 && idx < list->size() )
          {
            state = (*list)[idx].GetState();
            *parm1 = (*list)[idx].GetParm1();
            *parm2 = (*list)[idx].GetParm2();
          }
       else
          {
            state = FALSE;
            *parm1 = "";
            *parm2 = "";
          }
     }

  return state;
}


void CConfig::CfgSetList2Value(const char *name,int idx,BOOL state,const char *parm1,const char *parm2)
{
  TGLOBALCFGITEM* item = FindCfgItem(name,CFG_TYPE_LIST2);

  if ( item )
     {
       TCFGLIST2 *list = (TCFGLIST2*)item->value;

       if ( idx >= list->size() )
          {
            list->resize(idx+1);
          }

       if ( idx >= 0 && idx < list->size() )
          {
            (*list)[idx].Load(state,parm1,parm2);
          }
     }
}


CContent* CConfig::FindContentItem()
{
  TGLOBALCFGITEM* item = FindCfgItem("g_content",CFG_TYPE_CONTENT);
  return item ? (CContent*)item->value : NULL;
}


int CConfig::CfgGetCntSheetsCount()
{
  const CContent *cnt = FindContentItem();
  return cnt ? cnt->GetCount() : 0;
}


CSheet* CConfig::CfgGetCntSheetAt(int idx)
{
  CSheet *rc = NULL;
  
  CContent *cnt = FindContentItem();
  if ( cnt )
     {
       if ( idx >= 0 && idx < cnt->GetCount() )
          {
            rc = &(*cnt)[idx];
          }
     }

  return rc;
}


int CConfig::CfgGetCntShortcutsCount(const CSheet *sh)
{
  return sh ? sh->GetCount() : 0;
}


CShortcut* CConfig::CfgGetCntShortcutAt(CSheet *sh,int idx)
{
  CShortcut *rc = NULL;

  if ( sh )
     {
       if ( idx >= 0 && idx < sh->GetCount() )
          {
            rc = &(*sh)[idx];
          }
     }

  return rc;
}


void CConfig::CfgGetCntSheetVars(const CSheet *sh,TSHEETVARS *out)
{
  if ( sh )
     {
       lstrcpy(out->s_name,sh->GetName());
       lstrcpy(out->s_icon_path,sh->GetIconPath());
       out->i_color = sh->GetColor();
       out->i_bg_color = sh->GetBGColor();
       lstrcpy(out->s_bg_pic,sh->GetBGPath());
       lstrcpy(out->s_bg_thumb_pic,sh->GetBGThumbPath());
       out->i_time_min = sh->GetTimeMin();
       out->i_time_max = sh->GetTimeMax();
       lstrcpy(out->s_vip_users,sh->GetVIPUsers());
       lstrcpy(out->s_rules,sh->GetRulesPath());
       out->is_internet_sheet = sh->IsInternetSheet();
     }
  else
     {
       ZeroMemory(out,sizeof(*out));
     }
}


void CConfig::CfgGetCntShortcutVars(const CShortcut *sh,TSHORTCUTVARS *out)
{
  if ( sh )
     {
       lstrcpy(out->s_name,sh->GetName());
       lstrcpy(out->s_exe,sh->GetExePath());
       lstrcpy(out->s_arg,sh->GetArg());
       lstrcpy(out->s_cwd,sh->GetCWD());
       lstrcpy(out->s_icon_path,sh->GetIconPath());
       out->i_icon_idx = sh->GetIconIdx();
       lstrcpy(out->s_pwd,sh->GetPassword());
       out->b_allow_only_one = sh->GetAllowOnlyOne();
       lstrcpy(out->s_runas_domain,sh->GetRunAsDomain());
       lstrcpy(out->s_runas_user,sh->GetRunAsUser());
       lstrcpy(out->s_runas_pwd,sh->GetRunAsPassword());
       out->i_show_cmd = sh->GetShowCmd();
       out->i_vcd_num = sh->GetVCDNum();
       lstrcpy(out->s_vcd,sh->GetVCDPath());
       lstrcpy(out->s_saver,sh->GetSaver());
       lstrcpy(out->s_sshot,sh->GetSShotPath());
       lstrcpy(out->s_desc,sh->GetDescription());
       lstrcpy(out->s_script1,sh->GetScript1());
       lstrcpy(out->s_group,sh->GetGroup());
       lstrcpy(out->s_floatlic,sh->GetFloatLic());
     }
  else
     {
       ZeroMemory(out,sizeof(*out));
     }
}


CSheet* CConfig::CfgAddCntSheet(const char *name)
{
  CSheet *rc = NULL;

  if ( !IsStrEmpty(name) )
     {
       CContent *cnt = FindContentItem();
       if ( cnt )
          {
            if ( !cnt->FindSheetByName(name) )
               {
                 rc = new CSheet(name,NULL,0,0,NULL,NULL,0,24,NULL,NULL,FALSE);
                 cnt->AddSheet(rc);
               }
          }
     }

  return rc;
}


CShortcut* CConfig::CfgAddCntShortcut(CSheet *sh,const char *name)
{
  CShortcut *rc = NULL;

  if ( sh && !IsStrEmpty(name) )
     {
       if ( !sh->FindShortcutByName(name) )
          {
            rc = new CShortcut(name,NULL,NULL,NULL,NULL,0,NULL,TRUE,NULL,NULL,NULL,SW_SHOWNORMAL,-1,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
            sh->AddShortcut(rc);
          }
     }

  return rc;
}


void CConfig::CfgSetCntSheetVars(CSheet *sh,TSHEETVARS *in)
{
  if ( sh && in )
     {
       sh->LoadVarsOnly( in->s_name,
                         in->s_icon_path,
                         in->i_color,
                         in->i_bg_color,
                         in->s_bg_pic,
                         in->s_bg_thumb_pic,
                         in->i_time_min,
                         in->i_time_max,
                         in->s_vip_users,
                         in->s_rules,
                         in->is_internet_sheet );
     }
}


void CConfig::CfgSetCntShortcutVars(CShortcut *sh,TSHORTCUTVARS *in)
{
  if ( sh && in )
     {
       sh->LoadVarsOnly( in->s_name,
                         in->s_exe,
                         in->s_arg,
                         in->s_cwd,
                         in->s_icon_path,
                         in->i_icon_idx,
                         in->s_pwd,
                         in->b_allow_only_one,
                         in->s_runas_domain,
                         in->s_runas_user,
                         in->s_runas_pwd,
                         in->i_show_cmd,
                         in->i_vcd_num,
                         in->s_vcd,
                         in->s_saver,
                         in->s_sshot,
                         in->s_desc,
                         in->s_script1,
                         in->s_group,
                         in->s_floatlic );
     }
}


void CConfig::CfgMoveCntSheet(int from,int to)
{
  CContent *cnt = FindContentItem();
  if ( cnt )
     {
       cnt->MoveSheet(from,to);
     }
}


void CConfig::CfgMoveCntShortcut(CSheet *sh,int from,int to)
{
  if ( sh )
     {
       sh->MoveShortcut(from,to);
     }
}


void CConfig::CfgDelCntSheet(int idx)
{
  CContent *cnt = FindContentItem();
  if ( cnt )
     {
       cnt->DelSheet(idx);
     }
}


void CConfig::CfgDelCntShortcut(CSheet *sh,int idx)
{
  if ( sh )
     {
       sh->DelShortcut(idx);
     }
}


void CConfig::CfgClearCnt()
{
  CContent *cnt = FindContentItem();
  if ( cnt )
     {
       cnt->Clear();
     }
}



// export functions


CFG_EXPORT void CFG_DECL CfgReadConfig(const void *block,int block_size,int lang,int machine_type)
{
  CConfig::ReadConfig(block,block_size,lang,machine_type);
}

CFG_EXPORT void CFG_DECL CfgWriteBWCConfig()
{
  CConfig::WriteBWCConfig();
}

CFG_EXPORT void* CFG_DECL CfgWriteConfig(BOOL write_vars,BOOL write_content,int *_size)
{
  return CConfig::WriteConfig(write_vars,write_content,_size);
}

CFG_EXPORT void CFG_DECL CfgFreeBlock(void *block)
{
  if ( block )
     sys_free(block);
}

CFG_EXPORT BOOL CFG_DECL CfgGetBoolValue(const char *name)
{
  return CConfig::CfgGetBoolValue(name);
}

CFG_EXPORT void CFG_DECL CfgSetBoolValue(const char *name,BOOL value)
{
  CConfig::CfgSetBoolValue(name,value);
}

CFG_EXPORT int CFG_DECL CfgGetIntValue(const char *name)
{
  return CConfig::CfgGetIntValue(name);
}

CFG_EXPORT void CFG_DECL CfgSetIntValue(const char *name,int value)
{
  CConfig::CfgSetIntValue(name,value);
}

CFG_EXPORT const char* CFG_DECL CfgGetPathValue(const char *name)
{
  return CConfig::CfgGetPathValue(name);
}

CFG_EXPORT void CFG_DECL CfgSetPathValue(const char *name,const char *value)
{
  CConfig::CfgSetPathValue(name,value);
}

CFG_EXPORT const char* CFG_DECL CfgGetStringValue(const char *name)
{
  return CConfig::CfgGetStringValue(name);
}

CFG_EXPORT void CFG_DECL CfgSetStringValue(const char *name,const char *value)
{
  CConfig::CfgSetStringValue(name,value);
}

CFG_EXPORT const char* CFG_DECL CfgGetLongStringValue(const char *name)
{
  return CConfig::CfgGetLongStringValue(name);
}

CFG_EXPORT void CFG_DECL CfgSetLongStringValue(const char *name,const char *value)
{
  CConfig::CfgSetLongStringValue(name,value);
}

CFG_EXPORT BOOL CFG_DECL CfgGetList1Value(const char *name,int idx,const char **parm1)
{
  return CConfig::CfgGetList1Value(name,idx,parm1);
}

CFG_EXPORT void CFG_DECL CfgSetList1Value(const char *name,int idx,BOOL state,const char *parm1)
{
  CConfig::CfgSetList1Value(name,idx,state,parm1);
}

CFG_EXPORT BOOL CFG_DECL CfgGetList2Value(const char *name,int idx,const char **parm1,const char **parm2)
{
  return CConfig::CfgGetList2Value(name,idx,parm1,parm2);
}

CFG_EXPORT void CFG_DECL CfgSetList2Value(const char *name,int idx,BOOL state,const char *parm1,const char *parm2)
{
  CConfig::CfgSetList2Value(name,idx,state,parm1,parm2);
}

CFG_EXPORT int CFG_DECL CfgGetCntSheetsCount()
{
  return CConfig::CfgGetCntSheetsCount();
}

CFG_EXPORT CSheet* CFG_DECL CfgGetCntSheetAt(int idx)
{
  return CConfig::CfgGetCntSheetAt(idx);
}

CFG_EXPORT int CFG_DECL CfgGetCntShortcutsCount(const CSheet *sh)
{
  return CConfig::CfgGetCntShortcutsCount(sh);
}

CFG_EXPORT CShortcut* CFG_DECL CfgGetCntShortcutAt(CSheet *sh,int idx)
{
  return CConfig::CfgGetCntShortcutAt(sh,idx);
}

CFG_EXPORT void CFG_DECL CfgGetCntSheetVars(const CSheet *sh,TSHEETVARS *out)
{
  CConfig::CfgGetCntSheetVars(sh,out);
}

CFG_EXPORT void CFG_DECL CfgGetCntShortcutVars(const CShortcut *sh,TSHORTCUTVARS *out)
{
  CConfig::CfgGetCntShortcutVars(sh,out);
}

CFG_EXPORT CSheet* CFG_DECL CfgAddCntSheet(const char *name)
{
  return CConfig::CfgAddCntSheet(name);
}

CFG_EXPORT CShortcut* CFG_DECL CfgAddCntShortcut(CSheet *sh,const char *name)
{
  return CConfig::CfgAddCntShortcut(sh,name);
}

CFG_EXPORT void CFG_DECL CfgSetCntSheetVars(CSheet *sh,TSHEETVARS *in)
{
  CConfig::CfgSetCntSheetVars(sh,in);
}

CFG_EXPORT void CFG_DECL CfgSetCntShortcutVars(CShortcut *sh,TSHORTCUTVARS *in)
{
  CConfig::CfgSetCntShortcutVars(sh,in);
}

CFG_EXPORT void CFG_DECL CfgMoveCntSheet(int from,int to)
{
  CConfig::CfgMoveCntSheet(from,to);
}

CFG_EXPORT void CFG_DECL CfgMoveCntShortcut(CSheet *sh,int from,int to)
{
  CConfig::CfgMoveCntShortcut(sh,from,to);
}

CFG_EXPORT void CFG_DECL CfgDelCntSheet(int idx)
{
  CConfig::CfgDelCntSheet(idx);
}

CFG_EXPORT void CFG_DECL CfgDelCntShortcut(CSheet *sh,int idx)
{
  CConfig::CfgDelCntShortcut(sh,idx);
}

CFG_EXPORT void CFG_DECL CfgClearCnt()
{
  CConfig::CfgClearCnt();
}

CFG_EXPORT void CFG_DECL CfgStr2MD5(const char *str,char *md5_str)
{
  CMD5::Str2MD5(str,md5_str);
}

