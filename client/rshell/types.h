
#ifndef ___TYPES_H___
#define ___TYPES_H___


#define MIN(a,b)  (((a)<(b))?(a):(b))
#define MAX(a,b)  (((a)>(b))?(a):(b))

#define NNS(str)   ((str)?(str):"")
#define NNSW(str)   ((str)?(str):L"")

#define FREEANDNULL(x)   { if (x) sys_free(x); x = NULL; }
#define SAFESYSFREE   FREEANDNULL
#define SAFERELEASE(obj)   { if ( obj ) obj->Release(); obj = NULL; }
#define SAFEDELETE(obj)   { if ( obj ) delete obj; obj = NULL; }


#define REGPATH   "Software\\RunpadProShell"
#define RSRD_MUTEX "Local\\RSRDRunning"
#define G_EVENT_WIA_DEVICE_CONNECTED "Global\\RSWIADEVICECONNECTED"


#define SHEET_ANI_FRAMES    12
#define SHEET_UP        0 //always 0!
#define SHEET_DOWN      (SHEET_ANI_FRAMES-1)

#define MAXTHEMESHEETBORDER 8
#define MAXTHEMEHEIGHT      32
#define MAXTHEMEBUTTONSIZE  3072
#define MAXTHEMEREGIONS     8
#define MAXTHEMEDIVIDERSIZE 1024

typedef struct {
int x,y;
int width;
} THEMEREGION;

typedef struct {
int icons_pack; //0, 1, ...
float gamma; //set 1.0 to no change
int brightness; //-255..+255
BOOL is_light; //is theme light or dark
BOOL classic_button;
int transparent_pad; //vertical pad for button (window invisible/transparent part)
int panel_height; //only visible window part
int sheet_height;
int sheet_border; //left and right drawing border width
int button_pad; // left pad for button (between begin and first sheet)
int sheets_pad; // pad between two sheets
int inner_hpad; //inner pad (left/right) for icon and text drawing
int inner_vpad; //inner pad (top/bottom) for icon and text drawing
RECT button_rect;
int regions_count;
THEMEREGION regions[MAXTHEMEREGIONS];
unsigned char panel[MAXTHEMEHEIGHT]; //bar
int divider_width;
unsigned char divider[MAXTHEMEDIVIDERSIZE];
unsigned char sheet_borderl_up[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_borderr_up[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_center_up[MAXTHEMEHEIGHT];
unsigned char sheet_borderl_down[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_borderr_down[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_center_down[MAXTHEMEHEIGHT];
unsigned char sheet_borderl_hl[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_borderr_hl[MAXTHEMESHEETBORDER][MAXTHEMEHEIGHT];
unsigned char sheet_center_hl[MAXTHEMEHEIGHT];
unsigned char button_up[MAXTHEMEBUTTONSIZE];
unsigned char button_down[MAXTHEMEBUTTONSIZE];
unsigned char button_hl[MAXTHEMEBUTTONSIZE];
} THEME2D;

typedef struct {
void *buff; //RGB
int w,h;
} PIC;

typedef struct {
int grad1;
int grad2;
int skin_color;
int underline;
int clock;
int title;
int menutitle;
int menu;
int menu_admin;
int tooltip_back;
int tooltip_text;
int light;
int dark;
int activetext;
int inactivetext;
int borderline;
} THEME;

typedef struct {
unsigned char b,g,r,a;
} BGRA;

typedef struct {
int grayscale;
int w;
int h;
void *bits;
HBITMAP bitmap;
HBITMAP old_bitmap;
HDC hdc;
} RBUFF;


#define HKCU  HKEY_CURRENT_USER
#define HKLM  HKEY_LOCAL_MACHINE
#define HKCR  HKEY_CLASSES_ROOT

#define REG_CLASSES  "Software\\Classes\\"


// shutdown actions
enum {
SHA_SHUTDOWN = 0,
SHA_HIBERNATE = 1,
SHA_SUSPEND = 2,
};


//events (remember to add string in f3_events.inc-file !!!!!)
#define EL_STARTSHELL      0xABD76601
#define EL_OFFSHELL        0xABD76602
#define EL_LOGOFF          0xABD76603
#define EL_REBOOT          0xABD76604
#define EL_SHUTDOWN        0xABD76605

//services
#define GCID_FLASHDISK             1
#define GCID_PICTURESCAN           2
#define GCID_ISO                   3
#define GCID_BURNDVD               4
#define GCID_BURNCD                5
#define GCID_BTSEND                6
#define GCID_BTRECV                7
#define GCID_MAIL                  8
#define GCID_PRINTER               9
#define GCID_INSERTDVD             10
#define GCID_MOBILECONTENT         11
#define GCID_DIGITALCAMERA         12



#define MAGIC_WID	0x49474541	// magic windows DWORD


#define SCAN_FILE	1
#define SCAN_DIR	2
#define SCAN_HIDDEN	4

typedef BOOL (*SCANFUNC)(const char *,WIN32_FIND_DATA *,void *);
typedef int (*REGENUMKEYFUNC)(HKEY h,const char *key,void *param);
typedef int (*REGENUMVALUEFUNC)(const char *name,const char *data,void *param);
typedef BOOL (*SCANPROCESSESPROC)(int pid,const char *exe_path,void *parm);



#endif
