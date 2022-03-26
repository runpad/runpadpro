
#ifndef __SAVER_H__
#define __SAVER_H__



#define SAVER_NULL 0
#define SAVER_IN   1
#define SAVER_OUT  2
#define SAVER_MAX  10

typedef struct {
int direction;
char title[MAX_PATH];
char help[2048];
int quota;
char base_folder[MAX_PATH];
char allowed_exts[MAX_PATH];
char allowed_masks[MAX_PATH];
char save_as[MAX_PATH];
char *files[SAVER_MAX];
int num_files;
char *parms[SAVER_MAX];
char *def_parms[SAVER_MAX];
int num_parms;
BOOL copy_with_folder;
char in_source[MAX_PATH];
} TSAVER;



int GetSaversCount(void);
TSAVER* GetSaverAt(int idx);
void FreeSaver(void);
void LoadSaver(const char *token);
void M_Saver(const char *icon_name,const char *icon_cwd,int saver_idx,const char *src_for_in_direction);
int TrackSaverPopup(const char *saver_token,int x,int y);



#endif

