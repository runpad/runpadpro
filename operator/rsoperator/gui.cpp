
#include "include.h"



CGUI::CGUI()
{
  lib = LoadLibrary("rsoperator.dll");

  *(void**)&pCreateWindow      = (void*)GetProcAddress(lib,"GUI_CreateWindow");
  *(void**)&pDestroyWindow     = (void*)GetProcAddress(lib,"GUI_DestroyWindow");
  *(void**)&pShowWindow        = (void*)GetProcAddress(lib,"GUI_ShowWindow");
  *(void**)&pHideWindow        = (void*)GetProcAddress(lib,"GUI_HideWindow");
  *(void**)&pIsWindowVisible   = (void*)GetProcAddress(lib,"GUI_IsWindowVisible");
  *(void**)&pGetWindowHandle   = (void*)GetProcAddress(lib,"GUI_GetWindowHandle");
  *(void**)&pTextBox           = (void*)GetProcAddress(lib,"GUI_TextBox");
  *(void**)&pSendMessageBox    = (void*)GetProcAddress(lib,"GUI_SendMessageBox");
  *(void**)&pForceConfirmBox   = (void*)GetProcAddress(lib,"GUI_ForceConfirmBox");
  *(void**)&pAutoLogonBox      = (void*)GetProcAddress(lib,"GUI_AutoLogonBox");
  *(void**)&pTurnShellBox      = (void*)GetProcAddress(lib,"GUI_TurnShellBox");
  *(void**)&pFileBox           = (void*)GetProcAddress(lib,"GUI_FileBox");
  *(void**)&pFolderBox         = (void*)GetProcAddress(lib,"GUI_FolderBox");
  *(void**)&pCopyFilesBox      = (void*)GetProcAddress(lib,"GUI_CopyFilesBox");
  *(void**)&pStartupDialog     = (void*)GetProcAddress(lib,"GUI_StartupDialog");
  *(void**)&pClientUpdateBox   = (void*)GetProcAddress(lib,"GUI_ClientUpdateBox");
  *(void**)&pClientUninstallBox   = (void*)GetProcAddress(lib,"GUI_ClientUninstallBox");

  obj = NULL;
}


CGUI::~CGUI()
{
  DestroyMainWindow();

  if ( lib )
     FreeLibrary(lib);
}


BOOL CGUI::IsLibraryLoaded()
{
  return lib 
         && pCreateWindow 
         && pDestroyWindow 
         && pShowWindow 
         && pHideWindow 
         && pIsWindowVisible 
         && pGetWindowHandle 
         && pTextBox
         && pSendMessageBox
         && pForceConfirmBox
         && pAutoLogonBox
         && pTurnShellBox
         && pFileBox
         && pFolderBox
         && pCopyFilesBox
         && pStartupDialog
         && pClientUpdateBox
         && pClientUninstallBox;
}


void CGUI::CreateMainWindow(const TGUICONNECTION *p)
{
  if ( !obj )
     {
       if ( IsLibraryLoaded() )
          {
            obj = pCreateWindow(p);
          }
     }
}


void CGUI::DestroyMainWindow()
{
  if ( obj )
     {
       if ( IsLibraryLoaded() )
          {
            pDestroyWindow(obj);
            obj = NULL;
          }
     }
}


void CGUI::ShowMainWindow()
{
  if ( obj && IsLibraryLoaded() )
     {
       pShowWindow(obj);
     }
}


void CGUI::HideMainWindow()
{
  if ( obj && IsLibraryLoaded() )
     {
       pHideWindow(obj);
     }
}


BOOL CGUI::IsMainWindowVisible()
{
  return obj && IsLibraryLoaded() && pIsWindowVisible(obj);
}


HWND CGUI::GetMainWindowHandle()
{
  return (obj && IsLibraryLoaded()) ? pGetWindowHandle(obj) : NULL;
}


BOOL CGUI::TextBox(char *_text,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,int max_len,BOOL allow_empty,const char *history_id)
{
  return IsLibraryLoaded() ? pTextBox(_text,instance,icon_idx,title,text,def,max_len,allow_empty,history_id) : FALSE;
}


BOOL CGUI::SendMessageBox(char *_text,int max_length,int *_delay)
{
  return IsLibraryLoaded() ? pSendMessageBox(_text,max_length,_delay) : FALSE;
}


BOOL CGUI::ForceConfirmBox(BOOL *_is_hard)
{
  return IsLibraryLoaded() ? pForceConfirmBox(_is_hard) : FALSE;
}


BOOL CGUI::AutoLogonBox(char *_domain,char *_login,char *_pwd,BOOL *_io_force)
{
  return IsLibraryLoaded() ? pAutoLogonBox(_domain,_login,_pwd,_io_force) : FALSE;
}


BOOL CGUI::TurnShellBox(BOOL is_turnon,BOOL *_allusers,char *_domain,char *_login,char *_pwd)
{
  return IsLibraryLoaded() ? pTurnShellBox(is_turnon,_allusers,_domain,_login,_pwd) : FALSE;
}


BOOL CGUI::FileBox(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id,const char *filter)
{
  return IsLibraryLoaded() ? pFileBox(_path,instance,icon_idx,title,text,def,history_id,filter) : FALSE;
}


BOOL CGUI::FolderBox(char *_path,HINSTANCE instance,int icon_idx,const char *title,const char *text,const char *def,const char *history_id)
{
  return IsLibraryLoaded() ? pFolderBox(_path,instance,icon_idx,title,text,def,history_id) : FALSE;
}


BOOL CGUI::ExecCmdLineBox(char *_path)
{
  return IsLibraryLoaded() ? pTextBox(_path,lib,236,S_EXECCMDLINE,S_ENTERCMDLINE,"",MAX_PATH-1,FALSE,"ExecCmdLine") : FALSE;
}


BOOL CGUI::ExecRegFileBox(char *_path)
{
  return IsLibraryLoaded() ? pFileBox(_path,lib,237,S_EXECREGFILE,S_ENTERNETPATH,"","ExecRegFile","REG Files\0*.reg\0\0") : FALSE;
}


BOOL CGUI::ExecBatFileBox(char *_path)
{
  return IsLibraryLoaded() ? pFileBox(_path,lib,238,S_EXECBATFILE,S_ENTERNETPATH,"","ExecBatFile","BAT/CMD Files\0*.bat;*.cmd\0\0") : FALSE;
}


BOOL CGUI::CopyFilesBox(char *_pathfrom,char *_pathto,BOOL *_killtasks)
{
  return IsLibraryLoaded() ? pCopyFilesBox(_pathfrom,_pathto,_killtasks) : FALSE;
}


void CGUI::MsgBox(const char *s)
{
  MessageBox(GetMainWindowHandle(),s,S_INFO,MB_OK | MB_ICONINFORMATION);
}


void CGUI::ErrBox(const char *s)
{
  MessageBox(GetMainWindowHandle(),s,S_ERR,MB_OK | MB_ICONERROR);
}


void CGUI::WarnBox(const char *s)
{
  MessageBox(GetMainWindowHandle(),s,S_INFO,MB_OK | MB_ICONWARNING);
}


BOOL CGUI::ConfirmYesNo(const char *s)
{
  return MessageBox(GetMainWindowHandle(),s,S_QUESTION,MB_YESNO | MB_ICONQUESTION) == IDYES;
}


BOOL CGUI::ConfirmYesNoWarn(const char *s)
{
  return MessageBox(GetMainWindowHandle(),s,S_QUESTION,MB_YESNO | MB_ICONWARNING | MB_DEFBUTTON2) == IDYES;
}


BOOL CGUI::ConfirmOkCancel(const char *s)
{
  return MessageBox(GetMainWindowHandle(),s,S_QUESTION,MB_OKCANCEL | MB_ICONQUESTION) == IDOK;
}


BOOL CGUI::StartupDialog(STARTUPDIALOGINFO *i)
{
  return IsLibraryLoaded() ? pStartupDialog(i) : FALSE;
}


BOOL CGUI::ClientUpdateBox(BOOL *_imm,BOOL *_force)
{
  return IsLibraryLoaded() ? pClientUpdateBox(_imm,_force) : FALSE;
}


BOOL CGUI::ClientUninstallBox(BOOL *_imm,BOOL *_force)
{
  return IsLibraryLoaded() ? pClientUninstallBox(_imm,_force) : FALSE;
}


