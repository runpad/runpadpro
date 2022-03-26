
#define _WIN32_IE     0x0501   //WinXP
#define _WIN32_WINNT  0x0501   //WinXP
#define _WIN32_DCOM

#include <windows.h>
#include <shlwapi.h>
#include <objbase.h>
#include <commctrl.h>
#include "../../admin/sql/h_sql.h"
#include "../../client/rshell/f0.h"
#include "../../client/rshell/netcmd.h"
#include "../../client/rshell/servicemgr.h"
#include "../rs_server/def.h"
#include "../rs_server/tools.h"


HINSTANCE our_instance;

typedef void (__cdecl *TGetLicInfo)(char **lic_organization,char **lic_owner,char **lic_machines,char **lic_type,char **lic_modules);
typedef void (__cdecl *TSetLicKey)(const char *key);

typedef struct {
TGetLicInfo GetLicInfo;
TSetLicKey SetLicKey;
HICON small_icon;
HICON big_icon;
char server_name[MAX_PATH];
int dbtype_rp;
int dbtype_gc;
} STARTUPDIALOGINFO;

BOOL (__cdecl *ShowStartupMasterDialog)(STARTUPDIALOGINFO*) = NULL;


void __cdecl GetLicInfo(char **_lic_organization,char **_lic_owner,char **_lic_machines,char **_lic_type,char **_lic_modules)
{
  CNetCmd env(NETCMD_GETENV_ACK);
  AddLicInfoToEnv(env);

  static char lic_organization[MAX_PATH];
  static char lic_owner[MAX_PATH];
  static char lic_machines[MAX_PATH];
  static char lic_type[MAX_PATH];
  static char lic_modules[MAX_PATH];
  
  lstrcpyn(lic_organization,env.GetParmAsString(NETPARM_S_LICORGANIZATION,""),MAX_PATH);
  lstrcpyn(lic_owner,env.GetParmAsString(NETPARM_S_LICOWNER,""),MAX_PATH);
  wsprintf(lic_machines,"%d",env.GetParmAsInt(NETPARM_I_LICMACHINES,0));
  if ( StrStrI(env.GetParmAsString(NETPARM_S_LICFEATURES,""),"Server") )
     lstrcpy(lic_type,"Расширенная (с местом оператора)");
  else
     lstrcpy(lic_type,"Базовая");

  BOOL is_rollback = (StrStrI(env.GetParmAsString(NETPARM_S_LICFEATURES,""),"Rollback") != NULL);
  BOOL is_shell = (StrStrI(env.GetParmAsString(NETPARM_S_LICFEATURES,""),"NoShell") == NULL);
  
  if ( is_shell && !is_rollback )
     lstrcpy(lic_modules,"Только Shell (без Rollback)");
  else
  if ( !is_shell && is_rollback )
     lstrcpy(lic_modules,"Только Rollback (без Shell)");
  else
  if ( is_shell && is_rollback )
     lstrcpy(lic_modules,"Shell + Rollback");
  else
     lstrcpy(lic_modules,"");

  *_lic_organization = lic_organization;
  *_lic_owner = lic_owner;
  *_lic_machines = lic_machines;
  *_lic_type = lic_type;
  *_lic_modules = lic_modules;
}


void RestartService()
{
  CServiceMgr s("RunpadProServer");

  DWORD state = -1;
  if ( s.GetServiceStatus(&state) && state == SERVICE_RUNNING )
     {
       s.StopService();
       Sleep(1000);
       s.StartService();
     }
}


void __cdecl SetLicKey(const char *key)
{
}


void ShowDialog(void)
{
  STARTUPDIALOGINFO i;
  
  i.GetLicInfo = GetLicInfo;
  i.SetLicKey = SetLicKey;
  
  i.small_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(101),IMAGE_ICON,16,16,LR_SHARED);
  i.big_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(101),IMAGE_ICON,32,32,LR_SHARED);

  ReadRegStr(HKLM,REGPATH,"sql_server",i.server_name,"");
  if ( !i.server_name[0] )
     MyGetComputerName(i.server_name);
  i.dbtype_rp = ReadRegDword(HKLM,REGPATH,"sql_type_rp",SQL_TYPE_MSSQL);
  i.dbtype_gc = ReadRegDword(HKLM,REGPATH,"sql_type_gc",SQL_TYPE_MSSQL);

  if ( ShowStartupMasterDialog(&i) )
     {
       if ( !i.server_name[0] )
          MyGetComputerName(i.server_name);
       WriteRegStr(HKLM,REGPATH,"sql_server",i.server_name);
       WriteRegDword(HKLM,REGPATH,"sql_type_rp",i.dbtype_rp);
       WriteRegDword(HKLM,REGPATH,"sql_type_gc",i.dbtype_gc);
     }
}


int WINAPI WinMain(HINSTANCE hThisInstance,HINSTANCE hPrevInstance,LPSTR lpszCmdParam,int nCmdShow)
{
  our_instance = GetModuleHandle(NULL);
  
  InitCommonControls();
  CoInitialize(0);

  if ( IsAdminAccount() )
     {
       HINSTANCE lib = LoadLibrary("rs_server_setup.dll");
       *(void**)&ShowStartupMasterDialog = (void*)GetProcAddress(lib,"ShowStartupMasterDialog");

       if ( ShowStartupMasterDialog )
          {
            ShowDialog();
          }

       if ( lib )
          FreeLibrary(lib);
     }
  else
     {
       MessageBox(NULL,"Программа должна быть запущена из-под учетной записи администратора","Ошибка",MB_OK | MB_ICONERROR);
     }

  CoUninitialize();
  return 1;
}
