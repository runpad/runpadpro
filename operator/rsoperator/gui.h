
#ifndef __GUI_H__
#define __GUI_H__



typedef struct {
void (__cdecl *OnTitleChanged)(const char *new_title);
void (__cdecl *GetServerName)(char *out);
BOOL (__cdecl *IsServerConnected)();
int (__cdecl *GetEnvListCount)();
void (__cdecl *GetEnvListAt)(int idx,TENVENTRY *out);
void (__cdecl *WakeupOnLAN)(const char *ip,const char *mac);
BOOL (__cdecl *IsOurIP)(const char *s_ip);
void (__cdecl *ExecFunction)(int id,const TENVENTRY *list,int count);
} TGUICONNECTION;

typedef struct {
HICON small_icon;
HICON big_icon;
char sql_server[MAX_PATH];
int dbtype_rp;
char runpad_server[MAX_PATH];
BOOL autorun;
} STARTUPDIALOGINFO;



class CGUI
{
          HINSTANCE lib;

          typedef void* (__cdecl *TCreateWindow)(const TGUICONNECTION *p);
          typedef void (__cdecl *TDestroyWindow)(void *obj);
          typedef void (__cdecl *TShowWindow)(void *obj);
          typedef void (__cdecl *THideWindow)(void *obj);
          typedef BOOL (__cdecl *TIsWindowVisible)(void *obj);
          typedef HWND (__cdecl *TGetWindowHandle)(void *obj);
          typedef BOOL (__cdecl *TTextBox)(char *_text,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,int max_len,BOOL allow_empty,const char *history_id);
          typedef BOOL (__cdecl *TSendMessageBox)(char *_text,int max_length,int *_delay);
          typedef BOOL (__cdecl *TForceConfirmBox)(BOOL *_is_hard);
          typedef BOOL (__cdecl *TAutoLogonBox)(char *_domain,char *_login,char *_pwd,BOOL *_io_force);
          typedef BOOL (__cdecl *TTurnShellBox)(BOOL is_turnon,BOOL *_allusers,char *_domain,char *_login,char *_pwd);
          typedef BOOL (__cdecl *TFileBox)(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id,const char *filter);
          typedef BOOL (__cdecl *TFolderBox)(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id);
          typedef BOOL (__cdecl *TCopyFilesBox)(char *_pathfrom,char *_pathto,BOOL *_killtasks);
          typedef BOOL (__cdecl *TStartupDialog)(STARTUPDIALOGINFO *i);
          typedef BOOL (__cdecl *TClientUpdateBox)(BOOL *_imm,BOOL *_force);
          typedef BOOL (__cdecl *TClientUninstallBox)(BOOL *_imm,BOOL *_force);


          TCreateWindow    pCreateWindow;
          TDestroyWindow   pDestroyWindow;
          TShowWindow      pShowWindow;
          THideWindow      pHideWindow;
          TIsWindowVisible pIsWindowVisible;
          TGetWindowHandle pGetWindowHandle;
          TTextBox         pTextBox;
          TSendMessageBox  pSendMessageBox;
          TForceConfirmBox pForceConfirmBox;
          TAutoLogonBox    pAutoLogonBox;
          TTurnShellBox    pTurnShellBox;
          TFileBox         pFileBox;
          TFolderBox       pFolderBox;
          TCopyFilesBox    pCopyFilesBox;
          TStartupDialog   pStartupDialog;
          TClientUpdateBox pClientUpdateBox;
          TClientUninstallBox pClientUninstallBox;

          void *obj;

  public:
          CGUI();
          ~CGUI();

          BOOL IsLibraryLoaded();

          void CreateMainWindow(const TGUICONNECTION *p);
          void DestroyMainWindow();
          void ShowMainWindow();
          void HideMainWindow();
          BOOL IsMainWindowVisible();
          HWND GetMainWindowHandle();

          BOOL TextBox(char *_text,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,int max_len,BOOL allow_empty,const char *history_id);
          BOOL FileBox(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id,const char *filter);
          BOOL FolderBox(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id);

          BOOL SendMessageBox(char *_text,int max_length,int *_delay);
          BOOL ForceConfirmBox(BOOL *_is_hard);
          BOOL AutoLogonBox(char *_domain,char *_login,char *_pwd,BOOL *_io_force);
          BOOL TurnShellBox(BOOL is_turnon,BOOL *_allusers,char *_domain,char *_login,char *_pwd);
          BOOL ExecCmdLineBox(char *_path);
          BOOL ExecRegFileBox(char *_path);
          BOOL ExecBatFileBox(char *_path);
          BOOL CopyFilesBox(char *_pathfrom,char *_pathto,BOOL *_killtasks);
          BOOL ClientUpdateBox(BOOL *_imm,BOOL *_force);
          BOOL ClientUninstallBox(BOOL *_imm,BOOL *_force);

          void MsgBox(const char *s);
          void ErrBox(const char *s);
          void WarnBox(const char *s);
          BOOL ConfirmYesNo(const char *s);
          BOOL ConfirmYesNoWarn(const char *s);
          BOOL ConfirmOkCancel(const char *s);

          BOOL StartupDialog(STARTUPDIALOGINFO *i);
};



#endif

