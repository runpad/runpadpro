
#ifndef UTILS_H
#define UTILS_H


#ifdef __cplusplus
extern "C" {
#endif


void sys_memzero(void *buff,int size);
void sys_memset(void *buff,int b,int size);
void sys_memcpy(void *dest,void *src,int size);
void *sys_alloc(int size);
void sys_free(void *buff);
void *sys_fopen(char *filename);
void *sys_fcreate(char *filename);
void sys_fclose(void *h);
int sys_fread(void *h,void *buff,int len);
int sys_fwrite(void *h,void *buff,int len);
int sys_fsize(void *h);
void sys_fseek(void *h,int pos);
int sys_clock(void);
BOOL FileExist(const char *s);
void GetDirFromPath(char *path,char *dir);


#ifdef __cplusplus
}; //extern "C"
#endif


#endif
