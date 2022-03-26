
#define SCAN_FILE	1
#define SCAN_DIR	2
#define SCAN_HIDDEN	4


typedef BOOL (*SCANFUNC)(const char *,WIN32_FIND_DATA *,void *);


void ScanDir(const char *path,int type,SCANFUNC func,void *user);


void *sys_fcreate(const char *filename);
void *sys_fopenr(const char *filename);
void sys_fclose(void *h);
int sys_fwrite(void *h,void *buff,int len);
