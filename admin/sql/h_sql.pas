
unit h_sql;

interface


// dll names
const SQL_DLL_MSSQL = 'h_mssql.dll';
const SQL_DLL_MYSQL = 'h_mysql.dll';

// dll types (do not change values, only add 0,1,2,....!)
const SQL_TYPE_UNKNOWN   = -1;
const SQL_TYPE_MSSQL     = 0;
const SQL_TYPE_MYSQL     = 1;


{$INCLUDE h_sql.inc}



type TSQLFinishLibrary = procedure() cdecl;
type TSQLConnect = function(const s_server,s_login,s_pwd,s_base:pchar):pointer cdecl;
type TSQLDisconnect = procedure(obj:pointer) cdecl;
type TSQLIsConnected = function(obj:pointer):longbool cdecl;
type TSQLPollServer = function(obj:pointer):longbool cdecl;
type TSQLGetLastError = function(obj:pointer):pchar cdecl;
type TSQLEscapeString = procedure(obj:pointer;const from:pchar;_to:pchar) cdecl;
type TSQLExec = function(obj:pointer;const query:pchar;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:longbool):longbool cdecl;
type TSQLCallStoredProc = function(obj:pointer;const s_proc:pchar;timeout:integer;argv:PSTOREDPROCPARAM;argc:integer):longbool cdecl;
type TSQLInplaceCallStoredProc = function(obj:pointer;const s_proc,params:pchar;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:longbool):longbool cdecl;
type TSQLCreateUser = function(obj:pointer;const name,pwd:pchar):longbool cdecl;
type TSQLChangeCurrentPwd = function(obj:pointer;const old_pwd,new_pwd:pchar):longbool cdecl;
type TSQLChangeOtherPwd = function(obj:pointer;const login,pwd:pchar):longbool cdecl;
type TSQLRemoveUserFromCurrentBase = function(obj:pointer;const login:pchar):longbool cdecl;
type TSQLBeginTransaction = function(obj:pointer;timeout:integer):longbool cdecl;
type TSQLCommitTransaction = function(obj:pointer;timeout:integer):longbool cdecl;
type TSQLRollbackTransaction = function(obj:pointer;timeout:integer):longbool cdecl;
type TSQLRuleCheck = function(obj:pointer;const s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username:pchar;s_langid:integer):longbool cdecl;
type TSQLPrepareDB = function(obj:pointer):longbool cdecl;
type TSQLApplyUserRights = function(obj:pointer;const user:pchar;ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork:longbool):longbool cdecl;
type TSQLConnectAsInternalUser = function(const s_server:pchar):pointer cdecl;
type TSQLConnectAsBackupOperator = function(const s_server:pchar):pointer cdecl;
type TSQLConnectAsNormalUser = function(const s_server,s_login,s_pwd:pchar):pointer cdecl;
type TSQLIsMSSQLSyntax = function():longbool cdecl;
type TSQLIsMySQLSyntax = function():longbool cdecl;


type
     TSQLLib = class(TObject)
     private
      lib: cardinal;
      pFinishLibrary              : TSQLFinishLibrary;
      pConnect                    : TSQLConnect;
      pDisconnect                 : TSQLDisconnect;
      pIsConnected                : TSQLIsConnected;
      pPollServer                 : TSQLPollServer;
      pGetLastError               : TSQLGetLastError;
      pEscapeString               : TSQLEscapeString;
      pExec                       : TSQLExec;
      pCallStoredProc             : TSQLCallStoredProc;
      pInplaceCallStoredProc      : TSQLInplaceCallStoredProc;
      pCreateUser                 : TSQLCreateUser;
      pChangeCurrentPwd           : TSQLChangeCurrentPwd;
      pChangeOtherPwd             : TSQLChangeOtherPwd;
      pRemoveUserFromCurrentBase  : TSQLRemoveUserFromCurrentBase;
      pBeginTransaction           : TSQLBeginTransaction;
      pCommitTransaction          : TSQLCommitTransaction;
      pRollbackTransaction        : TSQLRollbackTransaction;
      pRuleCheck                  : TSQLRuleCheck;
      pPrepareDB                  : TSQLPrepareDB;
      pApplyUserRights            : TSQLApplyUserRights;
      pConnectAsInternalUser      : TSQLConnectAsInternalUser;
      pConnectAsBackupOperator    : TSQLConnectAsBackupOperator;
      pConnectAsNormalUser        : TSQLConnectAsNormalUser;
      pIsMSSQLSyntax              : TSQLIsMSSQLSyntax;
      pIsMySQLSyntax              : TSQLIsMySQLSyntax;
      obj: pointer;

     public
      constructor Create(dll_type:integer); overload;
      constructor Create(const dll_name:string); overload;
      constructor Create(); overload;
      destructor Destroy; override;

      function Connect(const s_server,s_login,s_pwd,s_base:string):boolean;
      function ConnectAsInternalUser(const s_server:string):boolean;
      function ConnectAsBackupOperator(const s_server:string):boolean;
      function ConnectAsNormalUser(const s_server,s_login,s_pwd:string):boolean;
      procedure Disconnect();
      function IsConnected():boolean;
      function PollServer():boolean;
      function GetLastError():string;
      function EscapeString(const from:string):string;
      function Exec(const query:string;timeout:integer=SQL_DEF_TIMEOUT;_record_count:pinteger=nil;cb:TEXECSQLCBPROC=nil;cb_parm:pointer=nil;call_cb_at_begin:boolean=false):boolean;
      function CallStoredProc(const s_proc:string;timeout:integer=SQL_DEF_TIMEOUT;argv:PSTOREDPROCPARAM=nil;argc:integer=0):boolean;
      function InplaceCallStoredProc(const s_proc:string;const params:string='';timeout:integer=SQL_DEF_TIMEOUT;_record_count:pinteger=nil;cb:TEXECSQLCBPROC=nil;cb_parm:pointer=nil;call_cb_at_begin:boolean=false):boolean;
      function CreateUser(const name,pwd:string):boolean;
      function ChangeCurrentPwd(const old_pwd,new_pwd:string):boolean;
      function ChangeOtherPwd(const login,pwd:string):boolean;
      function RemoveUserFromCurrentBase(const login:string):boolean;
      function BeginTransaction(timeout:integer=SQL_DEF_TIMEOUT):boolean;
      function CommitTransaction(timeout:integer=SQL_DEF_TIMEOUT):boolean;
      function RollbackTransaction(timeout:integer=SQL_DEF_TIMEOUT):boolean;
      function RuleCheck(const s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username:string;s_langid:integer):boolean;
      function PrepareDB():boolean;
      function ApplyUserRights(const user:string;ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork:boolean):boolean;
      function IsMSSQLSyntax():boolean;
      function IsMySQLSyntax():boolean;

     private
      procedure ClearVars();
      procedure LoadLib(const s:string);
     end;


implementation

uses Windows;



procedure TSQLLib.ClearVars();
begin
 lib:=0;
 pFinishLibrary:=nil;
 pConnect:=nil;
 pDisconnect:=nil;
 pIsConnected:=nil;
 pPollServer:=nil;
 pGetLastError:=nil;
 pEscapeString:=nil;
 pExec:=nil;
 pCallStoredProc:=nil;
 pInplaceCallStoredProc:=nil;
 pCreateUser:=nil;
 pChangeCurrentPwd:=nil;
 pChangeOtherPwd:=nil;
 pRemoveUserFromCurrentBase:=nil;
 pBeginTransaction:=nil;
 pCommitTransaction:=nil;
 pRollbackTransaction:=nil;
 pRuleCheck:=nil;
 pPrepareDB:=nil;
 pApplyUserRights:=nil;
 pConnectAsInternalUser:=nil;
 pConnectAsBackupOperator:=nil;
 pConnectAsNormalUser:=nil;
 pIsMSSQLSyntax:=nil;
 pIsMySQLSyntax:=nil;
 obj:=nil;
end;

procedure TSQLLib.LoadLib(const s:string);
begin
 if s<>'' then
  lib:=LoadLibrary(pchar(s))
 else
  lib:=0;

 pFinishLibrary              := GetProcAddress(lib,'SQL_FinishLibrary');
 pConnect                    := GetProcAddress(lib,'SQL_Connect');
 pDisconnect                 := GetProcAddress(lib,'SQL_Disconnect');
 pIsConnected                := GetProcAddress(lib,'SQL_IsConnected');
 pPollServer                 := GetProcAddress(lib,'SQL_PollServer');
 pGetLastError               := GetProcAddress(lib,'SQL_GetLastError');
 pEscapeString               := GetProcAddress(lib,'SQL_EscapeString');
 pExec                       := GetProcAddress(lib,'SQL_Exec');
 pCallStoredProc             := GetProcAddress(lib,'SQL_CallStoredProc');
 pInplaceCallStoredProc      := GetProcAddress(lib,'SQL_InplaceCallStoredProc');
 pCreateUser                 := GetProcAddress(lib,'SQL_CreateUser');
 pChangeCurrentPwd           := GetProcAddress(lib,'SQL_ChangeCurrentPwd');
 pChangeOtherPwd             := GetProcAddress(lib,'SQL_ChangeOtherPwd');
 pRemoveUserFromCurrentBase  := GetProcAddress(lib,'SQL_RemoveUserFromCurrentBase');
 pBeginTransaction           := GetProcAddress(lib,'SQL_BeginTransaction');
 pCommitTransaction          := GetProcAddress(lib,'SQL_CommitTransaction');
 pRollbackTransaction        := GetProcAddress(lib,'SQL_RollbackTransaction');
 pRuleCheck                  := GetProcAddress(lib,'SQL_RuleCheck');
 pPrepareDB                  := GetProcAddress(lib,'SQL_PrepareDB');
 pApplyUserRights            := GetProcAddress(lib,'SQL_ApplyUserRights');
 pConnectAsInternalUser      := GetProcAddress(lib,'SQL_ConnectAsInternalUser');
 pConnectAsBackupOperator    := GetProcAddress(lib,'SQL_ConnectAsBackupOperator');
 pConnectAsNormalUser        := GetProcAddress(lib,'SQL_ConnectAsNormalUser');
 pIsMSSQLSyntax              := GetProcAddress(lib,'SQL_IsMSSQLSyntax');
 pIsMySQLSyntax              := GetProcAddress(lib,'SQL_IsMySQLSyntax');
end;

constructor TSQLLib.Create();
begin
 inherited Create();

 ClearVars();
end;

constructor TSQLLib.Create(dll_type:integer);
var name:string;
begin
 inherited Create();

 ClearVars();

 name:='';
 if dll_type = SQL_TYPE_MSSQL then
   name := SQL_DLL_MSSQL
 else
 if dll_type = SQL_TYPE_MYSQL then
   name := SQL_DLL_MYSQL;

 LoadLib(name);
end;

constructor TSQLLib.Create(const dll_name:string);
begin
 inherited Create();

 ClearVars();
 LoadLib(dll_name);
end;

destructor TSQLLib.Destroy;
begin
 Disconnect();

 if @pFinishLibrary<>nil then
  pFinishLibrary();
 
 if lib<>0 then
  FreeLibrary(lib);

 ClearVars();

 inherited;
end;

function TSQLLib.Connect(const s_server,s_login,s_pwd,s_base:string):boolean;
begin
 Disconnect();

 if @pConnect=nil then
  begin
   Result:=false;
   Exit;
  end;

 obj:=pConnect(pchar(s_server),pchar(s_login),pchar(s_pwd),pchar(s_base));

 Result:=IsConnected();
end;

function TSQLLib.ConnectAsInternalUser(const s_server:string):boolean;
begin
 Disconnect();

 if @pConnectAsInternalUser=nil then
  begin
   Result:=false;
   Exit;
  end;

 obj:=pConnectAsInternalUser(pchar(s_server));

 Result:=IsConnected();
end;

function TSQLLib.ConnectAsBackupOperator(const s_server:string):boolean;
begin
 Disconnect();

 if @pConnectAsBackupOperator=nil then
  begin
   Result:=false;
   Exit;
  end;

 obj:=pConnectAsBackupOperator(pchar(s_server));

 Result:=IsConnected();
end;

function TSQLLib.ConnectAsNormalUser(const s_server,s_login,s_pwd:string):boolean;
begin
 Disconnect();

 if @pConnectAsNormalUser=nil then
  begin
   Result:=false;
   Exit;
  end;

 obj:=pConnectAsNormalUser(pchar(s_server),pchar(s_login),pchar(s_pwd));

 Result:=IsConnected();
end;

procedure TSQLLib.Disconnect();
begin
 if obj<>nil then
  begin
   if @pDisconnect<>nil then
    pDisconnect(obj);

   obj:=nil; 
  end;
end;

function TSQLLib.IsConnected():boolean;
begin
 Result:=(obj<>nil) and (@pIsConnected<>nil) and (pIsConnected(obj));
end;

function TSQLLib.PollServer():boolean;
begin
 Result:=(obj<>nil) and (@pPollServer<>nil) and (pPollServer(obj));
end;

function TSQLLib.GetLastError():string;
begin
 if (obj<>nil) and (@pGetLastError<>nil) then
  Result:=string(pGetLastError(obj))
 else
  Result:='NULL object passed';
end;

function TSQLLib.EscapeString(const from:string):string;
var t:pchar;
begin
 if @pEscapeString<>nil then
  begin
   GetMem(t,length(from)*2+1);
   t^:=#0;
   pEscapeString(obj,pchar(from),t); // function must accept NULL object!
   Result:=string(t);
   FreeMem(t);
  end
 else
  Result:=from;
end;

function TSQLLib.Exec(const query:string;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:boolean):boolean;
begin
 Result:=(obj<>nil) and (@pExec<>nil) and (pExec(obj,pchar(query),timeout,_record_count,cb,cb_parm,call_cb_at_begin));
end;

function TSQLLib.CallStoredProc(const s_proc:string;timeout:integer;argv:PSTOREDPROCPARAM;argc:integer):boolean;
begin
 Result:=(obj<>nil) and (@pCallStoredProc<>nil) and (pCallStoredProc(obj,pchar(s_proc),timeout,argv,argc));
end;

function TSQLLib.InplaceCallStoredProc(const s_proc:string;const params:string;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:boolean):boolean;
begin
 Result:=(obj<>nil) and (@pInplaceCallStoredProc<>nil) and (pInplaceCallStoredProc(obj,pchar(s_proc),pchar(params),timeout,_record_count,cb,cb_parm,call_cb_at_begin));
end;

function TSQLLib.CreateUser(const name,pwd:string):boolean;
begin
 Result:=(obj<>nil) and (@pCreateUser<>nil) and (pCreateUser(obj,pchar(name),pchar(pwd)));
end;

function TSQLLib.ChangeCurrentPwd(const old_pwd,new_pwd:string):boolean;
begin
 Result:=(obj<>nil) and (@pChangeCurrentPwd<>nil) and (pChangeCurrentPwd(obj,pchar(old_pwd),pchar(new_pwd)));
end;

function TSQLLib.ChangeOtherPwd(const login,pwd:string):boolean;
begin
 Result:=(obj<>nil) and (@pChangeOtherPwd<>nil) and (pChangeOtherPwd(obj,pchar(login),pchar(pwd)));
end;

function TSQLLib.RemoveUserFromCurrentBase(const login:string):boolean;
begin
 Result:=(obj<>nil) and (@pRemoveUserFromCurrentBase<>nil) and (pRemoveUserFromCurrentBase(obj,pchar(login)));
end;

function TSQLLib.BeginTransaction(timeout:integer):boolean;
begin
 Result:=(obj<>nil) and (@pBeginTransaction<>nil) and (pBeginTransaction(obj,timeout));
end;

function TSQLLib.CommitTransaction(timeout:integer):boolean;
begin
 Result:=(obj<>nil) and (@pCommitTransaction<>nil) and (pCommitTransaction(obj,timeout));
end;

function TSQLLib.RollbackTransaction(timeout:integer):boolean;
begin
 Result:=(obj<>nil) and (@pRollbackTransaction<>nil) and (pRollbackTransaction(obj,timeout));
end;

function TSQLLib.RuleCheck(const s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username:string;s_langid:integer):boolean;
begin
 Result:=(obj<>nil) and (@pRuleCheck<>nil) and (pRuleCheck(obj,pchar(s_rule),pchar(s_computerloc),pchar(s_computerdesc),pchar(s_computername),pchar(s_ip),pchar(s_userdomain),pchar(s_username),s_langid));
end;

function TSQLLib.PrepareDB():boolean;
begin
 Result:=(obj<>nil) and (@pPrepareDB<>nil) and (pPrepareDB(obj));
end;

function TSQLLib.ApplyUserRights(const user:string;ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork:boolean):boolean;
begin
 Result:=(obj<>nil) and (@pApplyUserRights<>nil) and (pApplyUserRights(obj,pchar(user),ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork));
end;

function TSQLLib.IsMSSQLSyntax():boolean;
begin
 Result:=(@pIsMSSQLSyntax<>nil) and pIsMSSQLSyntax();
end;

function TSQLLib.IsMySQLSyntax():boolean;
begin
 Result:=(@pIsMySQLSyntax<>nil) and pIsMySQLSyntax();
end;


end.
