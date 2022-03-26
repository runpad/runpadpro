
#include "stdafx.h"
#include <shlwapi.h>
#include "rs_api.h"
#include "impl.h"
#include "utils.h"
#include "../rshell/messages.h"



static HWND GetRSWindow(void)
{
  return FindWindow("_RunpadClass",NULL);
}


static DWORD SendRSMessage(int message,int wParam,int lParam)
{
  DWORD rc = 0;
  HWND w = GetRSWindow();

  if ( !w )
     return 0;

  if ( SendMessageTimeout(w,message,wParam,lParam,SMTO_BLOCK/*|SMTO_ABORTIFHUNG*/,15000,(PDWORD_PTR)&rc) == 0 )
     return 0;

  return rc;
}


static BOOL PostRSMessage(int message,int wParam,int lParam)
{
  HWND w = GetRSWindow();

  if ( !w )
     return FALSE;

  PostMessage(w,message,wParam,lParam);

  return TRUE;
}


static BOOL IsShellActive(void)
{
  return GetRSWindow() ? TRUE : FALSE;
}




// exported

BOOL RegisterComponent(BOOL bReg,const CLSID &clsid,const char *desc,const char *model)
{
  BOOL rc = FALSE;
  
  HINSTANCE inst = _Module.GetModuleInstance();
  
  char path[MAX_PATH];
  path[0] = 0;
  GetModuleFileName(inst,path,sizeof(path));
  
  LPOLESTR wid = NULL;
  if ( StringFromCLSID(clsid,&wid) == S_OK )
     {
       char id[MAX_PATH];
       id[0] = 0;
       WideCharToMultiByte(CP_ACP,0,wid,-1,id,MAX_PATH,NULL,NULL);

       CoTaskMemFree(wid);

       if ( id[0] )
          {
            if ( bReg )
               {
                 rc = ActiveXRegister(id,desc,path,model);
               }
            else
               {
                 rc = ActiveXUnregister(id);
               }
          }
     }

  return rc;
}


BOOL RS_GetShellState(RSHELLSTATE* pState)
{
  if ( !pState )
     return FALSE;

  if ( IsShellActive() )
     {
       *pState = RSS_ACTIVE;
       return TRUE;
     }

  *pState = RSS_TURNEDON;  //for Backward compatibility
  return TRUE;
}


BOOL RS_GetShellExecutable(LPSTR lpszExePath, DWORD cbPathLen, DWORD* lpdwPID)
{
  if ( lpszExePath )
     *lpszExePath = 0;

  if ( lpdwPID )
     *lpdwPID = -1;
  
  if ( !lpszExePath && !lpdwPID )
     return FALSE;
  
  if ( !IsShellActive() )
     return FALSE;
  
  if ( lpszExePath )
     {
       if ( cbPathLen >= MAX_PATH )
          {
            lstrcpy(lpszExePath,"rshell.exe");  // for backward compatibility
          }
     }

  if ( lpdwPID )
     {
       HWND shell_wnd = GetRSWindow();

       if ( shell_wnd )
          {
            DWORD shell_pid = -1;
            GetWindowThreadProcessId(shell_wnd,&shell_pid);
            *lpdwPID = shell_pid;
          }
     }

  return TRUE;
}


BOOL RS_GetShellPid(DWORD* lpdwPID)
{
  return RS_GetShellExecutable(NULL,0,lpdwPID);
}


BOOL RS_TurnShell(BOOL bNewState)
{
  return FALSE; // bwc
}


BOOL RS_GetShellMode(DWORD* lpdwFlags)
{
  if ( !lpdwFlags )
     return FALSE;

  *lpdwFlags = -1;

  if ( !IsShellActive() )
     return FALSE;

  DWORD uAdmin = 0; //bwc
  DWORD uMonitor = SendRSMessage(RS_GETMONITORSTATE,0,0) ? 1 : 0;
  DWORD uInput = SendRSMessage(RS_GETINPUTSTATE,0,0) ? 1 : 0;
  DWORD uBlocked = SendRSMessage(RS_GETBLOCKED,0,0) ? 1 : 0;

  *lpdwFlags = (uAdmin << 0) | (uMonitor << 1) | (uInput << 2) | (uBlocked << 3);

  return TRUE;
}


BOOL RS_IsShellOwnedWindow(HWND hWnd, BOOL* lpbOwned)
{
  if ( !lpbOwned )
     return FALSE;

  *lpbOwned = FALSE;
  
  if ( !hWnd || !IsWindow(hWnd) )
     return FALSE;

  HWND shell_wnd = GetRSWindow();

  if ( !shell_wnd )
     return TRUE;

  DWORD shell_pid = -1, pid = -1;

  GetWindowThreadProcessId(shell_wnd,&shell_pid);
  GetWindowThreadProcessId(hWnd,&pid);

  if ( shell_pid == pid )
     {
       *lpbOwned = TRUE;
     }
  else
     {
       HWND owner = GetWindow(hWnd,GW_OWNER);
       if ( owner )
          {
            DWORD pid = -1;
            GetWindowThreadProcessId(owner,&pid);

            if ( pid == shell_pid )
               {
                 *lpbOwned = TRUE;
               }
          }
     }

  return TRUE;
}


BOOL RS_GetFolderPath(RSHELLFOLDER dwFolderType, LPSTR lpszPath, DWORD cbPathLen)
{
  if ( lpszPath )
     *lpszPath = 0;

  if ( !lpszPath || cbPathLen < MAX_PATH )
     return FALSE;

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom = (ATOM)SendRSMessage(RS_GETSHELLFOLDERS,dwFolderType,0);

  if ( !atom )
     return TRUE; // maybe null string

  GlobalGetAtomName(atom,lpszPath,cbPathLen);
  GlobalDeleteAtom(atom);

  if ( lpszPath[0] )
     PathAddBackslash(lpszPath);

  return TRUE;
}


BOOL RS_GetMachineNumber(DWORD* lpdwNum)
{
  if ( !lpdwNum )
     return FALSE;

  *lpdwNum = 0;

  if ( !IsShellActive() )
     return FALSE;
   
  DWORD num = SendRSMessage(RS_GETMACHINENUM,0,0);

  if ( num == 0 )
     return FALSE;

  *lpdwNum = num;
  return TRUE;
}


BOOL RS_GetCurrentSheet(LPSTR lpszName, DWORD cbNameLen)
{
  if ( lpszName )
     *lpszName = 0;

  if ( !lpszName || cbNameLen < MAX_PATH )
     return FALSE;

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom = (ATOM)SendRSMessage(RS_GETCURRENTSHEET,0,0);

  if ( !atom )
     return TRUE; // maybe null string

  GlobalGetAtomName(atom,lpszName,cbNameLen);
  GlobalDeleteAtom(atom);

  return TRUE;
}


BOOL RS_EnableSheets(LPCSTR lpszName, BOOL bEnable)
{
  if ( !IsShellActive() )
     return FALSE;

  ATOM atom = GlobalAddAtom(lpszName);

  return PostRSMessage(RS_ENABLESHEETS,(int)atom,(int)bEnable);
}


BOOL RS_RegisterClient(LPCSTR lpszClientName, LPCSTR lpszClientPath, DWORD dwFlags)
{
  if ( !lpszClientName || !lpszClientName[0] || !lpszClientPath || !lpszClientPath[0] )
     return FALSE;

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom1 = GlobalAddAtom(lpszClientName);
  ATOM atom2 = GlobalAddAtom(lpszClientPath);

  return PostRSMessage(RS_REGISTERCLIENT,(int)atom1,(int)atom2);
}


BOOL RS_ShowInfoMessage(LPCSTR lpszText, DWORD dwFlags)
{
  if ( !lpszText || !lpszText[0] )
     return FALSE;

  if ( lstrlen(lpszText) > 255 )
     return FALSE;

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom = GlobalAddAtom(lpszText);

  return PostRSMessage(RS_SHOWMESSAGE,(int)atom,dwFlags);
}


BOOL RS_DoSingleAction(RSHELLACTION dwAction)
{
  if ( !IsShellActive() )
     return FALSE;

  int message = WM_NULL;
  int wParam = 0;
  int lParam = 0;

  switch ( dwAction )
  {
    case RSA_SWITCHTOUSERMODE:
    case RSA_UPDATEDESKTOP:
    case RSA_SHOWPANEL:
    case RSA_LANGSELECTDIALOG:
    case RSA_LANGSELECTRUS:
    case RSA_LANGSELECTENG:
                          return TRUE; //bwc

    case RSA_MINIMIZEALLWINDOWS:
                          message = RS_MINIMIZEALLWINDOWS;
                          break;

    case RSA_KILLALLTASKS:
                          message = RS_KILLALLTASKS;
                          break;

    case RSA_RESTOREVMODE:
                          message = RS_RESTORE_MODE;
                          break;

    case RSA_CLOSECHILDWINDOWS:
                          message = RS_CLOSECHILDS;
                          break;

    case RSA_TURNMONITORON:
                          message = RS_TURNMONITORON;
                          break;

    case RSA_TURNMONITOROFF:
                          message = RS_TURNMONITOROFF;
                          break;

    case RSA_ENDVIPSESSION:
                          message = RS_CLOSEVIPSESSION;
                          break;

    case RSA_RUNPROGRAMDISABLE:
                          message = RS_RUNPROGRAMDISABLE;
                          break;

    case RSA_RUNPROGRAMENABLE:
                          message = RS_RUNPROGRAMENABLE;
                          break;

    case RSA_RUNSCREENSAVER:
                          message = RS_RUNSCREENSAVER;
                          break;

    case RSA_CLOSEACTIVESHEET:
                          message = RS_CLOSEACTIVESHEET;
                          break;

    case RSA_LOGOFF:
                          message = RS_LOGOFF;
                          wParam = 0;
                          break;

    case RSA_LOGOFFFORCE:
                          message = RS_LOGOFF;
                          wParam = 1;
                          break;

    case RSA_SHOWLA:
                          message = RS_SHOWLA;
                          break;

    default:
             return FALSE;
  };

  return PostRSMessage(message,wParam,lParam);
}


static BOOL VipLoginRegister(int cmd,LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
  //if ( !lpszPassword || !lpszPassword[0] || lstrlen(lpszPassword) > 255 )
  //   return FALSE;

  if ( cmd == RS_REGISTERVIPUSER )
     {
       if ( !lpszLogin || !lpszLogin[0] || lstrlen(lpszLogin) > 255 )
          return FALSE;
     }

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom1 = GlobalAddAtom(lpszLogin?lpszLogin:"");
  ATOM atom2 = GlobalAddAtom(lpszPassword?lpszPassword:"");

  if ( !bWait )
     return PostRSMessage(cmd,(int)atom1,(int)atom2);
  else
     return SendRSMessage(cmd,(int)atom1,(int)atom2);
}


BOOL RS_VipLogin(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
  return VipLoginRegister(RS_LOGINVIPSESSION,lpszLogin,lpszPassword,bWait);
}


BOOL RS_VipRegister(LPCSTR lpszLogin, LPCSTR lpszPassword, BOOL bWait)
{
  return VipLoginRegister(RS_REGISTERVIPUSER,lpszLogin,lpszPassword,bWait);
}


BOOL RS_VipLogout(BOOL bWait)
{
  if ( !IsShellActive() )
     return FALSE;

  int cmd = RS_CLOSEVIPSESSION;

  if ( !bWait )
     return PostRSMessage(cmd,0,0);
  else
     return SendRSMessage(cmd,0,0);
}


BOOL RS_TempOffShell(LPCSTR lpszPasswordMD5,BOOL bShowReminder)
{
  if ( !lpszPasswordMD5 || !lpszPasswordMD5[0] || lstrlen(lpszPasswordMD5) > 255 )
     return FALSE;

  if ( !IsShellActive() )
     return FALSE;

  ATOM atom1 = GlobalAddAtom(lpszPasswordMD5);

  return PostRSMessage(RS_TEMPOFFSHELL,(int)atom1,(int)bShowReminder);
}



