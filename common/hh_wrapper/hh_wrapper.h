
#ifndef __HH_WRAPPER_H__
#define __HH_WRAPPER_H__


#ifdef __cplusplus
extern "C" {
#endif


__declspec(dllimport) HWND __cdecl HHW_DisplayTopic(HWND parent,
                                                    const char *filename,
                                                    const char *url,
                                                    const char *winname);

__declspec(dllimport) void __cdecl HHW_Close(void);


#ifdef __cplusplus
}; //extern "C"
#endif



#endif

