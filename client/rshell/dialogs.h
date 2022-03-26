
#ifndef ___DIALOGS_H___
#define ___DIALOGS_H___


void TextMessageBox(const char *text,int newdesktop,int delay_in_sec);
void PictureBox(const char *filename);
const char *GetString(const char *_title,const char *_text,int _attr,int _max,const char *_data);
const char *GetStringParentHwnd(HWND parent,const char *_title,const char *_text,int _attr,int _max,const char *_data);
void MsgBox(const char *text);
void MsgBoxW(const WCHAR *text);
void WarnBox(const char *text);
void ErrBox(const char *text);
void ErrBoxW(const WCHAR *text);
void MsgBoxTray(const char *text,int delay=7);
void WarnBoxTray(const char *text,int delay=7);
void ErrBoxTray(const char *text,int delay=7);
int Confirm(const char *text);
int ConfirmW(const WCHAR *text);
int ShaderConfirm(const char *text);
int ConfirmYESNO(const char *text);
int ConfirmYESNODefNOW(const WCHAR *text);
int RetryCancel(const char *text);
BOOL IsShaderWindow(HWND w);
void CreateShaderInternal(HDC hdc,RBUFF *buff);
HWND CreateShader(void);
void DestroyShader(HWND w);
const char* ShowPassword(const char *title);
const char* ShowPasswordParentHwnd(HWND parent,const char *title);
int GetLangDialog(int max_time_sec);


#endif
