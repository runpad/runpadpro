
#ifndef __CONNECTION_H__
#define __CONNECTION_H__



typedef struct {
   void (__cdecl *OnError)(const char *err_text);
   void (__cdecl *OnRClick)();
   void (__cdecl *OnMouseDown)();
   const char* (__cdecl *GetMachineLoc)();
   const char* (__cdecl *GetMachineDesc)();
   const char* (__cdecl *GetVipSessionName)();
   const char* (__cdecl *GetStatusString)();
   const char* (__cdecl *GetInfoText)();
   int (__cdecl *GetNumSheets)();
   const char* (__cdecl *GetSheetName)(int idx);
   BOOL (__cdecl *IsSheetActive)(int idx);
   void (__cdecl *SetSheetActive)(int idx, BOOL active);
   const char* (__cdecl *GetSheetBGPic)(int idx);
   BOOL (__cdecl *IsPageShaded)();
   BOOL (__cdecl *IsWaitCursor)();
   BOOL (__cdecl *CanUseGFX)();
   void (__cdecl *DoShellExec)(const char *exe,const char *args);
   const char* (__cdecl *GetInputText)(const char *title,const char *text);
   void (__cdecl *Alert)(const char *text);
   const char* (__cdecl *GetInputTextPos)(char pwdchar,int x,int y,int w,int h,int maxlen,const char *text);
} TDeskExternalConnection;



#endif
