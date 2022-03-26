
#ifndef __TOOLS_H__
#define __TOOLS_H__


#define SCAN_FILE	1
#define SCAN_DIR	2
#define SCAN_HIDDEN	4

typedef BOOL (*SCANDIRFUNC)(const char *,WIN32_FIND_DATA *,void *);


BOOL GetLocalFileInClientShellDir(const char *local,char *out);
BOOL RunProcess(const char *cmdline,const char *cwd);
void ScanDir(const char *path,int type,SCANDIRFUNC func,void *user);
char* GetLocalPath(const char *local,char *out);
ULARGE_INTEGER GetULValue(unsigned v);
LARGE_INTEGER GetILValue(int v);


#endif

