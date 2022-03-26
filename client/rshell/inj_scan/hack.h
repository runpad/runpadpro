
#ifndef __HACK_H__
#define __HACK_H__


#pragma pack(1)

typedef struct {
void *base_addr;
void *func_addr;
char old_bytes[6];
char pad[2];
} HACK;

#pragma pack()


extern HACK* HackAPIFunction(const char *dll_path,const char *function_name,void *new_func);
extern BOOL UnhackAPIFunction(void *hack_handle);



#endif
