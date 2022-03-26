
#define _WIN32_WINNT  0x0501   //WinXP

#include <windows.h>
#include "h_sql.h"



void CSQLLib::ClearVars()
{
  lib = NULL;

  pFinishLibrary = NULL;
  pConnect = NULL;
  pDisconnect = NULL;
  pIsConnected = NULL;
  pPollServer = NULL;
  pGetLastError = NULL;
  pEscapeString = NULL;
  pExec = NULL;
  pCallStoredProc = NULL;
  pInplaceCallStoredProc = NULL;
  pCreateUser = NULL;
  pChangeCurrentPwd = NULL;
  pChangeOtherPwd = NULL;
  pRemoveUserFromCurrentBase = NULL;
  pBeginTransaction = NULL;
  pCommitTransaction = NULL;
  pRollbackTransaction = NULL;
  pRuleCheck = NULL;
  pPrepareDB = NULL;
  pApplyUserRights = NULL;
  pConnectAsInternalUser = NULL;
  pConnectAsBackupOperator = NULL;
  pConnectAsNormalUser = NULL;
  pIsMSSQLSyntax = NULL;
  pIsMySQLSyntax = NULL;
  
  obj = NULL;
}


void CSQLLib::LoadLib(const char *dll_name)
{
  lib = ((dll_name && dll_name[0]) ? LoadLibrary(dll_name) : NULL);

  *(void**)&pFinishLibrary               = (void*)GetProcAddress(lib,"SQL_FinishLibrary");
  *(void**)&pConnect                     = (void*)GetProcAddress(lib,"SQL_Connect");
  *(void**)&pDisconnect                  = (void*)GetProcAddress(lib,"SQL_Disconnect");
  *(void**)&pIsConnected                 = (void*)GetProcAddress(lib,"SQL_IsConnected");
  *(void**)&pPollServer                  = (void*)GetProcAddress(lib,"SQL_PollServer");
  *(void**)&pGetLastError                = (void*)GetProcAddress(lib,"SQL_GetLastError");
  *(void**)&pEscapeString                = (void*)GetProcAddress(lib,"SQL_EscapeString");
  *(void**)&pExec                        = (void*)GetProcAddress(lib,"SQL_Exec");
  *(void**)&pCallStoredProc              = (void*)GetProcAddress(lib,"SQL_CallStoredProc");
  *(void**)&pInplaceCallStoredProc       = (void*)GetProcAddress(lib,"SQL_InplaceCallStoredProc");
  *(void**)&pCreateUser                  = (void*)GetProcAddress(lib,"SQL_CreateUser");
  *(void**)&pChangeCurrentPwd            = (void*)GetProcAddress(lib,"SQL_ChangeCurrentPwd");
  *(void**)&pChangeOtherPwd              = (void*)GetProcAddress(lib,"SQL_ChangeOtherPwd");
  *(void**)&pRemoveUserFromCurrentBase   = (void*)GetProcAddress(lib,"SQL_RemoveUserFromCurrentBase");
  *(void**)&pBeginTransaction            = (void*)GetProcAddress(lib,"SQL_BeginTransaction");
  *(void**)&pCommitTransaction           = (void*)GetProcAddress(lib,"SQL_CommitTransaction");
  *(void**)&pRollbackTransaction         = (void*)GetProcAddress(lib,"SQL_RollbackTransaction");
  *(void**)&pRuleCheck                   = (void*)GetProcAddress(lib,"SQL_RuleCheck");
  *(void**)&pPrepareDB                   = (void*)GetProcAddress(lib,"SQL_PrepareDB");
  *(void**)&pApplyUserRights             = (void*)GetProcAddress(lib,"SQL_ApplyUserRights");
  *(void**)&pConnectAsInternalUser       = (void*)GetProcAddress(lib,"SQL_ConnectAsInternalUser");
  *(void**)&pConnectAsBackupOperator     = (void*)GetProcAddress(lib,"SQL_ConnectAsBackupOperator");
  *(void**)&pConnectAsNormalUser         = (void*)GetProcAddress(lib,"SQL_ConnectAsNormalUser");
  *(void**)&pIsMSSQLSyntax               = (void*)GetProcAddress(lib,"SQL_IsMSSQLSyntax");
  *(void**)&pIsMySQLSyntax               = (void*)GetProcAddress(lib,"SQL_IsMySQLSyntax");
}


CSQLLib::CSQLLib(int type)
{
  ClearVars();
  
  const char *name = NULL;
  
  if ( type == SQL_TYPE_MSSQL )
     name = SQL_DLL_MSSQL;
  else
  if ( type == SQL_TYPE_MYSQL )
     name = SQL_DLL_MYSQL;

  LoadLib(name);
}


CSQLLib::CSQLLib(const char *dll_name)
{
  ClearVars();
  LoadLib(dll_name);
}


CSQLLib::~CSQLLib()
{
  Disconnect();

  if ( pFinishLibrary )
     pFinishLibrary();
  
  if ( lib )
     FreeLibrary(lib);

  ClearVars();
}


BOOL CSQLLib::Connect(const char *s_server,const char *s_login,const char *s_pwd,const char *s_base)
{
  Disconnect();

  if ( !pConnect )
     return FALSE;

  obj = pConnect(s_server,s_login,s_pwd,s_base);

  return IsConnected();
}


BOOL CSQLLib::ConnectAsInternalUser(const char *s_server)
{
  Disconnect();

  if ( !pConnectAsInternalUser )
     return FALSE;

  obj = pConnectAsInternalUser(s_server);

  return IsConnected();
}


BOOL CSQLLib::ConnectAsBackupOperator(const char *s_server)
{
  Disconnect();

  if ( !pConnectAsBackupOperator )
     return FALSE;

  obj = pConnectAsBackupOperator(s_server);

  return IsConnected();
}


BOOL CSQLLib::ConnectAsNormalUser(const char *s_server,const char *s_login,const char *s_pwd)
{
  Disconnect();

  if ( !pConnectAsNormalUser )
     return FALSE;

  obj = pConnectAsNormalUser(s_server,s_login,s_pwd);

  return IsConnected();
}


void CSQLLib::Disconnect()
{
  if ( obj )
     {
       if ( pDisconnect )
          pDisconnect(obj);

       obj = NULL;
     }
}


BOOL CSQLLib::IsConnected()
{
  return obj && pIsConnected && pIsConnected(obj);
}


BOOL CSQLLib::PollServer()
{
  return obj && pPollServer && pPollServer(obj);
}


const char* CSQLLib::GetLastError()
{
  const char *s = ( pGetLastError && obj ) ? pGetLastError(obj) : "NULL object passed";
  s = (s ? s : "");
  lstrcpyn(m_buff,s,sizeof(m_buff)-1);
  return m_buff;
}


void CSQLLib::EscapeString(const char *from,char *to)
{
  if ( pEscapeString )
     {
       pEscapeString(obj,from,to); // function must accept NULL object!
     }
  else
     {
       lstrcpy(to,from?from:"");
     }
}


BOOL CSQLLib::Exec(const char *query,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  return obj && pExec && pExec(obj,query,timeout,_record_count,cb,cb_parm,call_cb_at_begin);
}


BOOL CSQLLib::CallStoredProc(const char *s_proc,int timeout,TSTOREDPROCPARAM *argv,int argc)
{
  return obj && pCallStoredProc && pCallStoredProc(obj,s_proc,timeout,argv,argc);
}


BOOL CSQLLib::InplaceCallStoredProc(const char *s_proc,const char *params,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin)
{
  return obj && pInplaceCallStoredProc && pInplaceCallStoredProc(obj,s_proc,params,timeout,_record_count,cb,cb_parm,call_cb_at_begin);
}


BOOL CSQLLib::CreateUser(const char *name,const char *pwd)
{
  return obj && pCreateUser && pCreateUser(obj,name,pwd);
}


BOOL CSQLLib::ChangeCurrentPwd(const char *old_pwd,const char *new_pwd)
{
  return obj && pChangeCurrentPwd && pChangeCurrentPwd(obj,old_pwd,new_pwd);
}


BOOL CSQLLib::ChangeOtherPwd(const char *login,const char *pwd)
{
  return obj && pChangeOtherPwd && pChangeOtherPwd(obj,login,pwd);
}


BOOL CSQLLib::RemoveUserFromCurrentBase(const char *login)
{
  return obj && pRemoveUserFromCurrentBase && pRemoveUserFromCurrentBase(obj,login);
}


BOOL CSQLLib::BeginTransaction(int timeout)
{
  return obj && pBeginTransaction && pBeginTransaction(obj,timeout);
}


BOOL CSQLLib::CommitTransaction(int timeout)
{
  return obj && pCommitTransaction && pCommitTransaction(obj,timeout);
}


BOOL CSQLLib::RollbackTransaction(int timeout)
{
  return obj && pRollbackTransaction && pRollbackTransaction(obj,timeout);
}


BOOL CSQLLib::RuleCheck(const char *s_rule,const char *s_computerloc,const char *s_computerdesc,const char *s_computername,const char *s_ip,const char *s_userdomain,const char *s_username,int s_langid)
{
  return obj && pRuleCheck && pRuleCheck(obj,s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username,s_langid);
}


BOOL CSQLLib::PrepareDB()
{
  return obj && pPrepareDB && pPrepareDB(obj);
}


BOOL CSQLLib::ApplyUserRights(const char *user,BOOL ur_editcosts,BOOL ur_deloldrecords,BOOL ur_editcompvars,BOOL ur_editvars,BOOL ur_editcontent,BOOL ur_editcomprules,BOOL ur_editrules,BOOL ur_vipwork)
{
  return obj && pApplyUserRights && pApplyUserRights(obj,user,ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork);
}


BOOL CSQLLib::IsMSSQLSyntax()
{
  return pIsMSSQLSyntax && pIsMSSQLSyntax();
}


BOOL CSQLLib::IsMySQLSyntax()
{
  return pIsMySQLSyntax && pIsMySQLSyntax();
}




