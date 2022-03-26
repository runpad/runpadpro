
#ifndef __H_SQL_H__
#define __H_SQL_H__


// dll names
#define SQL_DLL_MSSQL  "h_mssql.dll"
#define SQL_DLL_MYSQL  "h_mysql.dll"

// dll types (do not change values, only add 0,1,2,3.....!)
#define SQL_TYPE_UNKNOWN    -1
#define SQL_TYPE_MSSQL      0
#define SQL_TYPE_MYSQL      1


#include "h_sql_inc.h"


class CSQLLib
{
         typedef void (__cdecl *TSQLFinishLibrary)();
         typedef void* (__cdecl *TSQLConnect)(const char *s_server,const char *s_login,const char *s_pwd,const char *s_base);
         typedef void (__cdecl *TSQLDisconnect)(void *obj);
         typedef BOOL (__cdecl *TSQLIsConnected)(void *obj);
         typedef BOOL (__cdecl *TSQLPollServer)(void *obj);
         typedef const char* (__cdecl *TSQLGetLastError)(void *obj);
         typedef void (__cdecl *TSQLEscapeString)(void *obj,const char *from,char *to);
         typedef BOOL (__cdecl *TSQLExec)(void *obj,const char *query,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin);
         typedef BOOL (__cdecl *TSQLCallStoredProc)(void *obj,const char *s_proc,int timeout,TSTOREDPROCPARAM *argv,int argc);
         typedef BOOL (__cdecl *TSQLInplaceCallStoredProc)(void *obj,const char *s_proc,const char *params,int timeout,int *_record_count,TEXECSQLCBPROC cb,void *cb_parm,BOOL call_cb_at_begin);
         typedef BOOL (__cdecl *TSQLCreateUser)(void *obj,const char *name,const char *pwd);
         typedef BOOL (__cdecl *TSQLChangeCurrentPwd)(void *obj,const char *old_pwd,const char *new_pwd);
         typedef BOOL (__cdecl *TSQLChangeOtherPwd)(void *obj,const char *login,const char *pwd);
         typedef BOOL (__cdecl *TSQLRemoveUserFromCurrentBase)(void *obj,const char *login);
         typedef BOOL (__cdecl *TSQLBeginTransaction)(void *obj,int timeout);
         typedef BOOL (__cdecl *TSQLCommitTransaction)(void *obj,int timeout);
         typedef BOOL (__cdecl *TSQLRollbackTransaction)(void *obj,int timeout);
         typedef BOOL (__cdecl *TSQLRuleCheck)(void *obj,const char *s_rule,const char *s_computerloc,const char *s_computerdesc,const char *s_computername,const char *s_ip,const char *s_userdomain,const char *s_username,int s_langid);
         typedef BOOL (__cdecl *TSQLPrepareDB)(void *obj);
         typedef BOOL (__cdecl *TSQLApplyUserRights)(void *obj,const char *user,BOOL ur_editcosts,BOOL ur_deloldrecords,BOOL ur_editcompvars,BOOL ur_editvars,BOOL ur_editcontent,BOOL ur_editcomprules,BOOL ur_editrules,BOOL ur_vipwork);
         typedef void* (__cdecl *TSQLConnectAsInternalUser)(const char *s_server);
         typedef void* (__cdecl *TSQLConnectAsBackupOperator)(const char *s_server);
         typedef void* (__cdecl *TSQLConnectAsNormalUser)(const char *s_server,const char *s_login,const char *s_pwd);
         typedef BOOL (__cdecl *TSQLIsMSSQLSyntax)();
         typedef BOOL (__cdecl *TSQLIsMySQLSyntax)();
         
         HINSTANCE lib;

         TSQLFinishLibrary             pFinishLibrary;
         TSQLConnect                   pConnect;
         TSQLDisconnect                pDisconnect;
         TSQLIsConnected               pIsConnected;
         TSQLPollServer                pPollServer;
         TSQLGetLastError              pGetLastError;
         TSQLEscapeString              pEscapeString;
         TSQLExec                      pExec;
         TSQLCallStoredProc            pCallStoredProc;
         TSQLInplaceCallStoredProc     pInplaceCallStoredProc;
         TSQLCreateUser                pCreateUser;
         TSQLChangeCurrentPwd          pChangeCurrentPwd;
         TSQLChangeOtherPwd            pChangeOtherPwd;
         TSQLRemoveUserFromCurrentBase pRemoveUserFromCurrentBase;
         TSQLBeginTransaction          pBeginTransaction;
         TSQLCommitTransaction         pCommitTransaction;
         TSQLRollbackTransaction       pRollbackTransaction;
         TSQLRuleCheck                 pRuleCheck;
         TSQLPrepareDB                 pPrepareDB;
         TSQLApplyUserRights           pApplyUserRights;
         TSQLConnectAsInternalUser     pConnectAsInternalUser;
         TSQLConnectAsBackupOperator   pConnectAsBackupOperator;
         TSQLConnectAsNormalUser       pConnectAsNormalUser;
         TSQLIsMSSQLSyntax             pIsMSSQLSyntax;
         TSQLIsMySQLSyntax             pIsMySQLSyntax;

         void *obj;
         char m_buff[300];  //used only to store lasterror

  public:
         CSQLLib(int type);
         CSQLLib(const char *dll_name);
         ~CSQLLib();

         BOOL Connect(const char *s_server,const char *s_login,const char *s_pwd,const char *s_base);
         BOOL ConnectAsInternalUser(const char *s_server);
         BOOL ConnectAsBackupOperator(const char *s_server);
         BOOL ConnectAsNormalUser(const char *s_server,const char *s_login,const char *s_pwd);
         void Disconnect();
         BOOL IsConnected();
         BOOL PollServer();
         const char *GetLastError();
         void EscapeString(const char *from,char *to);
         BOOL Exec(const char *query,int timeout=SQL_DEF_TIMEOUT,int *_record_count=NULL,TEXECSQLCBPROC cb=NULL,void *cb_parm=NULL,BOOL call_cb_at_begin=FALSE);
         BOOL CallStoredProc(const char *s_proc,int timeout=SQL_DEF_TIMEOUT,TSTOREDPROCPARAM *argv=NULL,int argc=0);
         BOOL InplaceCallStoredProc(const char *s_proc,const char *params=NULL,int timeout=SQL_DEF_TIMEOUT,int *_record_count=NULL,TEXECSQLCBPROC cb=NULL,void *cb_parm=NULL,BOOL call_cb_at_begin=FALSE);
         BOOL CreateUser(const char *name,const char *pwd);
         BOOL ChangeCurrentPwd(const char *old_pwd,const char *new_pwd);
         BOOL ChangeOtherPwd(const char *login,const char *pwd);
         BOOL RemoveUserFromCurrentBase(const char *login);
         BOOL BeginTransaction(int timeout=SQL_DEF_TIMEOUT);
         BOOL CommitTransaction(int timeout=SQL_DEF_TIMEOUT);
         BOOL RollbackTransaction(int timeout=SQL_DEF_TIMEOUT);
         BOOL RuleCheck(const char *s_rule,const char *s_computerloc,const char *s_computerdesc,const char *s_computername,const char *s_ip,const char *s_userdomain,const char *s_username,int s_langid);
         BOOL PrepareDB();
         BOOL ApplyUserRights(const char *user,BOOL ur_editcosts,BOOL ur_deloldrecords,BOOL ur_editcompvars,BOOL ur_editvars,BOOL ur_editcontent,BOOL ur_editcomprules,BOOL ur_editrules,BOOL ur_vipwork);
         BOOL IsMSSQLSyntax();
         BOOL IsMySQLSyntax();

  private:
         void ClearVars();
         void LoadLib(const char *dll_name);
};


#endif
