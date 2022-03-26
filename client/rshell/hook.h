
#ifndef __HOOK_H__
#define __HOOK_H__


#ifdef __cplusplus
extern "C" {
#endif


__declspec(dllimport) void __cdecl InitGlobalHook(HWND hwnd);
__declspec(dllimport) void __cdecl DoneGlobalHook(HWND hwnd);
__declspec(dllimport) void __cdecl SetDialogsHook(BOOL state);
__declspec(dllimport) void __cdecl SetWinampHook(BOOL state);
__declspec(dllimport) void __cdecl SetMPlayercHook(BOOL state);
__declspec(dllimport) void __cdecl SetPowerDVDHook(BOOL state);
__declspec(dllimport) void __cdecl SetInputDisableState(BOOL state);
__declspec(dllimport) void __cdecl SetConsoleHook(BOOL state);
__declspec(dllimport) void __cdecl SetTorrentHook(BOOL state);


#ifdef __cplusplus
};
#endif


#endif
