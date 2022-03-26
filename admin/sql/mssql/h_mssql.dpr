
library h_mssql;

uses SysUtils, Classes, g_conn;


var 
    g_numobjects : integer = 0;  //number of allocated objects


// global constants (runpad-specific)
const RUNPAD_BASE = 'RunpadPro';
const RUNPAD_USER = 'rsp_service';
const RUNPAD_BACKUP_USER = 'rsp_backupoperator';
const RUNPAD_PWD  = 'cthdbc';


////////////////////////////////////////
// low-level SQL functions
////////////////////////////////////////

procedure SQL_FinishLibrary() cdecl; // usually called before FreeLibrary(this_lib)
begin
 if g_numobjects=0 then
  begin
   // nothing to do...
  end;
end;

function SQL_Connect(const s_server,s_login,s_pwd,s_base:pchar):pointer cdecl;
var obj:TServerConn;
begin
 try
  obj:=TServerConn.Create(s_server,s_login,s_pwd,s_base);
 except
  obj:=nil;  //should never happens
 end;

 if obj<>nil then
  inc(g_numobjects);

 Result:=obj;
end;

procedure SQL_Disconnect(obj:pointer) cdecl;
begin
 if obj<>nil then
  begin
   TServerConn(obj).Free;
   dec(g_numobjects);
  end;
end;

function SQL_IsConnected(obj:pointer):longbool cdecl;
begin
 if obj<>nil then
  Result:=TServerConn(obj).IsConnected()
 else
  Result:=false;
end;

function SQL_PollServer(obj:pointer):longbool cdecl;
begin
 Result:=false;
 if obj<>nil then
  begin
   if TServerConn(obj).IsConnected() then
    begin
     TServerConn(obj).ExecSQL('SELECT 1');
     Result:=TServerConn(obj).IsConnected();
    end;
  end;
end;

function SQL_GetLastError(obj:pointer):pchar cdecl;
begin
 if obj<>nil then
  Result:=TServerConn(obj).GetLastError()
 else
  Result:='NULL object passed';
end;

// must be allocated at least [strlen(from)*2+1] for "_to"
procedure SQL_EscapeString(obj:pointer;const from:pchar;_to:pchar) cdecl;
var ss,s:string;
    n:integer;
begin
 s:=string(from);
 ss:='';

 for n:=1 to length(s) do
  begin
   if s[n]<>'''' then
    ss:=ss+s[n]
   else
    ss:=ss+s[n]+s[n];
  end;

 StrCopy(_to,pchar(ss));
end;

function SQL_Exec(obj:pointer;const query:pchar;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:longbool):longbool cdecl;
begin
 if _record_count<>nil then
  _record_count^:=0;
 
 if obj<>nil then
  Result:=TServerConn(obj).ExecSQL(query,timeout,_record_count,cb,cb_parm,call_cb_at_begin)
 else
  Result:=false;
end;

function SQL_CallStoredProc(obj:pointer;const s_proc:pchar;timeout:integer;argv:PSTOREDPROCPARAM;argc:integer):longbool cdecl;
begin
 if obj<>nil then
  Result:=TServerConn(obj).CallStoredProc(s_proc,timeout,argv,argc)
 else
  Result:=false;
end;


////////////////////////////////////////
// our internal functions
////////////////////////////////////////

function IsEmpty(const p:pchar):boolean;
begin
 Result:=(p=nil) or (p^=#0);
end;

function IsNotEmpty(const p:pchar):boolean;
begin
 Result:=not IsEmpty(p);
end;

function EscapeString(obj:pointer;const from:string):string;
var t:pchar;
    s:string;
begin
 t:=nil;
 GetMem(t,length(from)*2+1);
 t^:=#0;
 SQL_EscapeString(obj,pchar(from),t);
 s:=string(t);
 FreeMem(t);
 Result:=s;
end;

function Query(obj:pointer;const q:string;timeout:integer=SQL_DEF_TIMEOUT;_record_count:pinteger=nil;cb:TEXECSQLCBPROC=nil;cb_parm:pointer=nil;call_cb_at_begin:boolean=false):boolean;
begin
 Result:=SQL_Exec(obj,pchar(q),timeout,_record_count,cb,cb_parm,call_cb_at_begin);
end;

function CreateLogin(obj:pointer;const login,pwd,base:string):boolean;
var s:string;
    cnt:integer;
begin
 Result:=false;
 if (obj<>nil) and (login<>'') then
  begin
   s:='SELECT * FROM master.dbo.syslogins WHERE name='''+EscapeString(obj,login)+'''';
   cnt:=0;
   if Query(obj,s,SQL_DEF_TIMEOUT,@cnt) then
    begin
     if cnt>0 then
      Result:=true
     else
      begin
       s:='CREATE LOGIN '+login+' WITH PASSWORD='''+EscapeString(obj,pwd)+''',CHECK_POLICY=OFF';
       if base<>'' then
        s:=s+',DEFAULT_DATABASE='+base;
       Result:=Query(obj,s);
       if not Result then
        begin
         // old behaviour:
         s:='EXEC sp_addlogin '''+EscapeString(obj,login)+''','''+EscapeString(obj,pwd)+'''';
         if base<>'' then
          s:=s+','''+EscapeString(obj,base)+'''';
         Result:=Query(obj,s);
        end;
      end;
    end;
  end;
end;

function AddUserInternal(obj:pointer;const login,role:string):boolean;
var s:string;
    count:integer;
begin
 Result:=false;
 if (obj<>nil) and (login<>'') then
  begin
   s:='SELECT * FROM master.dbo.syslogins, dbo.sysusers WHERE master.dbo.syslogins.name=dbo.sysusers.name AND master.dbo.syslogins.name='''+EscapeString(obj,login)+''' AND master.dbo.syslogins.sid=dbo.sysusers.sid';
   count:=0;
   if Query(obj,s,SQL_DEF_TIMEOUT,@count) then
    begin
     if count>0 then
      Result:=true
     else
      begin
       s:='EXEC sp_dropuser '''+EscapeString(obj,login)+'''';
       Query(obj,s); //we do not control result here
       
       s:='EXEC sp_adduser '''+EscapeString(obj,login)+'''';
       if role<>'' then
        s:=s+','''+EscapeString(obj,login)+''','''+role+'''';
       Result:=Query(obj,s);
      end;
    end;
  end;
end;

function AddUserToCurrentBase(obj:pointer;const login:string):boolean;
begin
 Result:=AddUserInternal(obj,login,'');
end;

function AddUserAsBackupOperatorToCurrentBase(obj:pointer;const login:string):boolean;
begin
 Result:=AddUserInternal(obj,login,'db_backupoperator');
end;

function IsBaseExists(obj:pointer;const name:string):boolean;
var s:string;
    count:integer;
begin
 Result:=false;
 if (obj<>nil) and (name<>'') then
  begin
   s:='SELECT name FROM master.dbo.sysdatabases WHERE name='''+EscapeString(obj,name)+'''';
   count:=0;
   if Query(obj,s,SQL_DEF_TIMEOUT,@count) then
    Result:=count>0;
  end;
end;

function IsObjectExists(obj:pointer;const name:string):boolean;
var s:string;
    count:integer;
begin
 Result:=false;
 if (obj<>nil) and (name<>'') then
  begin
   s:='SELECT name FROM dbo.sysobjects WHERE name='''+EscapeString(obj,name)+'''';
   count:=0;
   if Query(obj,s,SQL_DEF_TIMEOUT,@count) then
    Result:=count>0;
  end;
end;


////////////////////////////////////////
// high-level SQL functions
////////////////////////////////////////

function SQL_InplaceCallStoredProc(obj:pointer;const s_proc,params:pchar;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:longbool):longbool cdecl;
var s:string;
begin
 if IsEmpty(params) then
  s:='EXEC '+string(s_proc)
 else
  s:='EXEC '+string(s_proc)+' '+string(params);

 Result:=Query(obj,s,timeout,_record_count,cb,cb_parm,call_cb_at_begin);
end;

function SQL_CreateUser(obj:pointer;const name,pwd:pchar):longbool cdecl;
begin
 Result:=false;

 if (obj<>nil) and IsNotEmpty(name) then
  begin
   if CreateLogin(obj,name,pwd,'') then
    begin
     if AddUserToCurrentBase(obj,name) then
      Result:=true;
    end;
  end;
end;

function SQL_ChangeCurrentPwd(obj:pointer;const old_pwd,new_pwd:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 if obj<>nil then
  begin
   s:='EXEC sp_password @new='''+EscapeString(obj,string(new_pwd))+''',@old='''+EscapeString(obj,string(old_pwd))+'''';
   Result:=Query(obj,s);
   if (not Result) and IsEmpty(old_pwd) then
    begin
     s:='EXEC sp_password @new='''+EscapeString(obj,string(new_pwd))+'''';
     Result:=Query(obj,s);
    end;
  end;
end;

function SQL_ChangeOtherPwd(obj:pointer;const login,pwd:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 if IsNotEmpty(login) then
  begin
   s:='EXEC sp_password @new='''+EscapeString(obj,string(pwd))+''',@loginame='''+EscapeString(obj,string(login))+'''';
   Result:=Query(obj,s);
  end;
end;

function SQL_RemoveUserFromCurrentBase(obj:pointer;const login:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 if IsNotEmpty(login) then
  begin
   s:='EXEC sp_dropuser '''+EscapeString(obj,string(login))+'''';
   Result:=Query(obj,s);
  end;
end;

function SQL_BeginTransaction(obj:pointer;timeout:integer):longbool cdecl;
begin
 Result:=Query(obj,'BEGIN TRANSACTION',timeout);
end;

function SQL_CommitTransaction(obj:pointer;timeout:integer):longbool cdecl;
begin
 Result:=Query(obj,'COMMIT TRANSACTION',timeout);
end;

function SQL_RollbackTransaction(obj:pointer;timeout:integer):longbool cdecl;
begin
 Result:=Query(obj,'ROLLBACK TRANSACTION',timeout);
end;

function SQL_IsMSSQLSyntax():longbool cdecl;
begin
 Result:=true;
end;

function SQL_IsMySQLSyntax():longbool cdecl;
begin
 Result:=false;
end;


////////////////////////////////////////
// Runpad-specific functions
////////////////////////////////////////

function SQL_RuleCheck(obj:pointer;const s_rule,s_computerloc,s_computerdesc,s_computername,s_ip,s_userdomain,s_username:pchar;s_langid:integer):longbool cdecl;
var s:string;
    cnt:integer;
begin
 if IsEmpty(s_rule) then
  begin
   Result:=true;   //empty rule is equals to TRUE
   exit;
  end;

 s:=
   'DECLARE @computerloc   VARCHAR(256)'+#10+
   'DECLARE @computerdesc  VARCHAR(256)'+#10+
   'DECLARE @computername  VARCHAR(256)'+#10+
   'DECLARE @ip            VARCHAR(256)'+#10+
   'DECLARE @userdomain    VARCHAR(256)'+#10+
   'DECLARE @username      VARCHAR(256)'+#10+
   'DECLARE @langid        INT'+#10+
   'SELECT @computerloc=''%s'''+#10+
   'SELECT @computerdesc=''%s'''+#10+
   'SELECT @computername=''%s'''+#10+
   'SELECT @ip=''%s'''+#10+
   'SELECT @userdomain=''%s'''+#10+
   'SELECT @username=''%s'''+#10+
   'SELECT @langid=%d'+#10+
   'IF %s'+#10+
   'SELECT 1';

 s:=Format(s,[EscapeString(obj,string(s_computerloc)),
              EscapeString(obj,string(s_computerdesc)),
              EscapeString(obj,string(s_computername)),
              EscapeString(obj,string(s_ip)),
              EscapeString(obj,string(s_userdomain)),
              EscapeString(obj,string(s_username)),
              s_langid,
              string(s_rule)]);

 cnt:=0;
 Result:=Query(obj,s,SQL_DEF_TIMEOUT,@cnt) and (cnt>0);
end;

function PrepareDBInternal(obj:pointer;sql:TStringList):boolean;
var b_needchangeowner : boolean;
begin
 Result:=false;

 //create our database
 b_needchangeowner:=false;
 if not IsBaseExists(obj,RUNPAD_BASE) then
  begin
   if not Query(obj,'CREATE DATABASE '+RUNPAD_BASE) then
    Exit;
   b_needchangeowner:=true;
  end;

 if not Query(obj,'USE '+RUNPAD_BASE) then
  Exit;

 if b_needchangeowner then
  begin
   Query(obj,'EXEC sp_changedbowner ''sa''');
  end;

 //create prices table
 if not IsObjectExists(obj,'TPrices') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TPrices(');
   SQL.Add(' id          INT,');
   SQL.Add(' name        VARCHAR(256),');
   SQL.Add(' price_count FLOAT,');
   SQL.Add(' price_size  FLOAT,');
   SQL.Add(' price_time  FLOAT,');
   SQL.Add(' price_fixed FLOAT)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create services table
 if not IsObjectExists(obj,'TServices') then
  begin
   SQL.Clear;
   SQL.Add('CREATE TABLE TServices(');
   SQL.Add(' comp_loc    VARCHAR(256),');
   SQL.Add(' comp_desc   VARCHAR(256),');
   SQL.Add(' comp_name   VARCHAR(256),');
   SQL.Add(' comp_ip     VARCHAR(256),');
   SQL.Add(' user_domain VARCHAR(256),');
   SQL.Add(' user_name   VARCHAR(256),');
   SQL.Add(' vip_name    VARCHAR(256),');
   SQL.Add(' id          INT,');
   SQL.Add(' data_count  INT,');
   SQL.Add(' data_size   INT,');
   SQL.Add(' data_time   INT,');
   SQL.Add(' comments    VARCHAR(512),');
   SQL.Add(' time        DATETIME,');
   SQL.Add(' cost        FLOAT)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create services-insertion stored proc
 if not IsObjectExists(obj,'PAddServiceString') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PAddServiceString');
   SQL.Add('@comp_loc    VARCHAR(256),');
   SQL.Add('@comp_desc   VARCHAR(256),');
   SQL.Add('@comp_name   VARCHAR(256),');
   SQL.Add('@comp_ip     VARCHAR(256),');
   SQL.Add('@user_domain VARCHAR(256),');
   SQL.Add('@user_name   VARCHAR(256),');
   SQL.Add('@vip_name    VARCHAR(256),');
   SQL.Add('@id          INT,');
   SQL.Add('@data_count  INT,');
   SQL.Add('@data_size   INT,');
   SQL.Add('@data_time   INT,');
   SQL.Add('@comments    VARCHAR(512)');
   SQL.Add('AS');
   SQL.Add('DECLARE @_cnt INT');
   SQL.Add('DECLARE @_res FLOAT');
   SQL.Add('SELECT @_cnt=Count(TPrices.id) FROM TPrices WHERE TPrices.id=@id');
   SQL.Add('IF @_cnt=0');
   SQL.Add(' SELECT @_res=0');
   SQL.Add('ELSE');
   SQL.Add(' SELECT @_res=Avg(TPrices.price_count*@data_count+TPrices.price_size*@data_size+TPrices.price_time*@data_time+TPrices.price_fixed) FROM TPrices WHERE TPrices.id=@id');
   SQL.Add('INSERT INTO TServices VALUES(@comp_loc,@comp_desc,@comp_name,@comp_ip,@user_domain,@user_name,@vip_name,@id,@data_count,@data_size,@data_time,@comments,GETDATE(),@_res)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create events table
 if not IsObjectExists(obj,'TEvents') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TEvents(');
   SQL.Add(' comp_loc    VARCHAR(256),');
   SQL.Add(' comp_desc   VARCHAR(256),');
   SQL.Add(' comp_name   VARCHAR(256),');
   SQL.Add(' comp_ip     VARCHAR(256),');
   SQL.Add(' user_domain VARCHAR(256),');
   SQL.Add(' user_name   VARCHAR(256),');
   SQL.Add(' vip_name    VARCHAR(256),');
   SQL.Add(' level       INT,');
   SQL.Add(' comments    VARCHAR(512),');
   SQL.Add(' time        DATETIME)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create events-insertion stored proc
 if not IsObjectExists(obj,'PAddEventString') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PAddEventString');
   SQL.Add('@comp_loc    VARCHAR(256),');
   SQL.Add('@comp_desc   VARCHAR(256),');
   SQL.Add('@comp_name   VARCHAR(256),');
   SQL.Add('@comp_ip     VARCHAR(256),');
   SQL.Add('@user_domain VARCHAR(256),');
   SQL.Add('@user_name   VARCHAR(256),');
   SQL.Add('@vip_name    VARCHAR(256),');
   SQL.Add('@level       INT,');
   SQL.Add('@comments    VARCHAR(512)');
   SQL.Add('AS');
   SQL.Add('INSERT INTO TEvents VALUES(@comp_loc,@comp_desc,@comp_name,@comp_ip,@user_domain,@user_name,@vip_name,@level,@comments,GETDATE())');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create user-responses table
 if not IsObjectExists(obj,'TUserResponses') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TUserResponses(');
   SQL.Add(' msg_kind    VARCHAR(256),');
   SQL.Add(' msg_title   VARCHAR(256),');
   SQL.Add(' user_name   VARCHAR(256),');
   SQL.Add(' user_age    VARCHAR(256),');
   SQL.Add(' msg_text    TEXT,');
   SQL.Add(' time        DATETIME)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create user-responses-insertion stored proc
 if not IsObjectExists(obj,'PAddUserResponse') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PAddUserResponse');
   SQL.Add('@msg_kind    VARCHAR(256),');
   SQL.Add('@msg_title   VARCHAR(256),');
   SQL.Add('@user_name   VARCHAR(256),');
   SQL.Add('@user_age    VARCHAR(256),');
   SQL.Add('@msg_text    TEXT');
   SQL.Add('AS');
   SQL.Add('INSERT INTO TUserResponses VALUES(@msg_kind,@msg_title,@user_name,@user_age,@msg_text,GETDATE())');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users table
 if not IsObjectExists(obj,'TVipUsers') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TVipUsers(');
   SQL.Add(' user_name   VARCHAR(256),');
   SQL.Add(' user_pwd    VARCHAR(256))');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users stored proc for Login
 if not IsObjectExists(obj,'PVipLogin') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVipLogin');
   SQL.Add('@user_name   VARCHAR(256),');
   SQL.Add('@user_pwd    VARCHAR(256)');
   SQL.Add('AS');
   SQL.Add('SELECT * FROM TVipUsers WHERE user_name=@user_name AND user_pwd=@user_pwd');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users stored proc for Login by password only
 if not IsObjectExists(obj,'PVipLoginByPwd') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVipLoginByPwd');
   SQL.Add('@user_pwd    VARCHAR(256)');
   SQL.Add('AS');
   SQL.Add('SELECT * FROM TVipUsers WHERE user_pwd=@user_pwd');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users stored proc for Register
 if not IsObjectExists(obj,'PVipRegister') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVipRegister');
   SQL.Add('@user_name  VARCHAR(256),');
   SQL.Add('@user_pwd   VARCHAR(256)');
   SQL.Add('AS');
   SQL.Add('IF @user_pwd=''''');
   SQL.Add('BEGIN');
   SQL.Add(' IF NOT EXISTS (SELECT * FROM TVipUsers WHERE user_name=@user_name)');
   SQL.Add('  BEGIN');
   SQL.Add('   INSERT INTO TVipUsers VALUES(@user_name,@user_pwd)');
   SQL.Add('   SELECT 1');
   SQL.Add('  END');
   //SQL.Add(' ELSE');
   //SQL.Add('  SELECT NULL FROM TVipUsers');
   SQL.Add('END');
   SQL.Add('ELSE');
   SQL.Add('BEGIN');
   SQL.Add(' UPDATE TVipUsers SET user_pwd=@user_pwd WHERE user_name=@user_name AND user_pwd=''''');
   SQL.Add(' SELECT * FROM TVipUsers WHERE user_name=@user_name AND user_pwd=@user_pwd');
   SQL.Add('END');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users stored proc for Delete
 if not IsObjectExists(obj,'PVipDelete') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVipDelete');
   SQL.Add('@user_name  VARCHAR(256)');
   SQL.Add('AS');
   SQL.Add('DELETE FROM TVipUsers WHERE user_name=@user_name');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VIP-users stored proc for ClearPass
 if not IsObjectExists(obj,'PVipClearPass') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVipClearPass');
   SQL.Add('@user_name  VARCHAR(256)');
   SQL.Add('AS');
   SQL.Add('UPDATE TVipUsers SET user_pwd='''' WHERE user_name=@user_name');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create DB-users table
 if not IsObjectExists(obj,'TDBUsers') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TDBUsers(');
   SQL.Add(' user_name   VARCHAR(256),');
   SQL.Add(' user_rights TEXT)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create CompProfiles table
 if not IsObjectExists(obj,'TCompProfiles') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TCompProfiles(');
   SQL.Add(' name   VARCHAR(256),');
   SQL.Add(' data   IMAGE)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create CompProfiles stored proc for Add/Modify
 if not IsObjectExists(obj,'PCompProfilesAddModify') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PCompProfilesAddModify');
   SQL.Add('@name  VARCHAR(256),');
   SQL.Add('@data  IMAGE');
   SQL.Add('AS');
   SQL.Add('IF EXISTS (SELECT name FROM TCompProfiles WHERE name=@name)');
   SQL.Add(' UPDATE TCompProfiles SET data=@data WHERE name=@name');
   SQL.Add('ELSE');
   SQL.Add(' INSERT INTO TCompProfiles VALUES(@name,@data)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VarsProfiles table
 if not IsObjectExists(obj,'TVarsProfiles') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TVarsProfiles(');
   SQL.Add(' name   VARCHAR(256),');
   SQL.Add(' data   IMAGE)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create VarsProfiles stored proc for Add/Modify
 if not IsObjectExists(obj,'PVarsProfilesAddModify') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PVarsProfilesAddModify');
   SQL.Add('@name  VARCHAR(256),');
   SQL.Add('@data  IMAGE');
   SQL.Add('AS');
   SQL.Add('IF EXISTS (SELECT name FROM TVarsProfiles WHERE name=@name)');
   SQL.Add(' UPDATE TVarsProfiles SET data=@data WHERE name=@name');
   SQL.Add('ELSE');
   SQL.Add(' INSERT INTO TVarsProfiles VALUES(@name,@data)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create ContentProfiles table
 if not IsObjectExists(obj,'TContentProfiles') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TContentProfiles(');
   SQL.Add(' name   VARCHAR(256),');
   SQL.Add(' data   IMAGE)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create ContentProfiles stored proc for Add/Modify
 if not IsObjectExists(obj,'PContentProfilesAddModify') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PContentProfilesAddModify');
   SQL.Add('@name  VARCHAR(256),');
   SQL.Add('@data  IMAGE');
   SQL.Add('AS');
   SQL.Add('IF EXISTS (SELECT name FROM TContentProfiles WHERE name=@name)');
   SQL.Add(' UPDATE TContentProfiles SET data=@data WHERE name=@name');
   SQL.Add('ELSE');
   SQL.Add(' INSERT INTO TContentProfiles VALUES(@name,@data)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create rules table (for computer)
 if not IsObjectExists(obj,'TCompSettingsRules') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TCompSettingsRules(');
   SQL.Add(' number           INT,');
   SQL.Add(' rule_string      TEXT,');
   SQL.Add(' comp_profile     VARCHAR(256))');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create rules table (for user)
 if not IsObjectExists(obj,'TSettingsRules') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TSettingsRules(');
   SQL.Add(' number           INT,');
   SQL.Add(' rule_string      TEXT,');
   SQL.Add(' vars_profile     VARCHAR(256),');
   SQL.Add(' content_profile  VARCHAR(256))');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create client-update table
 if not IsObjectExists(obj,'TClientUpdate') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TClientUpdate(');
   SQL.Add(' path           VARCHAR(256),');
   SQL.Add(' crc32          VARCHAR(256),');
   SQL.Add(' data           IMAGE)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create client-update stored proc for Add
 if not IsObjectExists(obj,'PClientUpdateAdd') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PClientUpdateAdd');
   SQL.Add('@path   VARCHAR(256),');
   SQL.Add('@crc32  VARCHAR(256),');
   SQL.Add('@data   IMAGE');
   SQL.Add('AS');
   SQL.Add('INSERT INTO TClientUpdate VALUES(@path,@crc32,@data)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create client-update table
 if not IsObjectExists(obj,'TClientUpdateNoShell') then
  begin
   SQL.Clear();
   SQL.Add('CREATE TABLE TClientUpdateNoShell(');
   SQL.Add(' path           VARCHAR(256),');
   SQL.Add(' crc32          VARCHAR(256),');
   SQL.Add(' data           IMAGE)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 //create client-update stored proc for Add
 if not IsObjectExists(obj,'PClientUpdateNoShellAdd') then
  begin
   SQL.Clear();
   SQL.Add('CREATE PROC PClientUpdateNoShellAdd');
   SQL.Add('@path   VARCHAR(256),');
   SQL.Add('@crc32  VARCHAR(256),');
   SQL.Add('@data   IMAGE');
   SQL.Add('AS');
   SQL.Add('INSERT INTO TClientUpdateNoShell VALUES(@path,@crc32,@data)');
   if not Query(obj,SQL.Text) then
    Exit;
  end;

 // process internal runpad users
 if not CreateLogin(obj,RUNPAD_BACKUP_USER,RUNPAD_PWD,'') then
  Exit;
 if not AddUserAsBackupOperatorToCurrentBase(obj,RUNPAD_BACKUP_USER) then
  Exit;
 
 if not CreateLogin(obj,RUNPAD_USER,RUNPAD_PWD,RUNPAD_BASE) then
  Exit;
 if not AddUserToCurrentBase(obj,RUNPAD_USER) then
  Exit;

 SQL.Clear();
 SQL.Add('GRANT EXECUTE ON PAddServiceString TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PAddEventString TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PAddUserResponse TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PVipLogin TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PVipLoginByPwd TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PVipRegister TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PVipDelete TO '+RUNPAD_USER);
 SQL.Add('GRANT EXECUTE ON PVipClearPass TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TCompProfiles TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TVarsProfiles TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TContentProfiles TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TCompSettingsRules TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TSettingsRules TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TClientUpdate TO '+RUNPAD_USER);
 SQL.Add('GRANT SELECT ON TClientUpdateNoShell TO '+RUNPAD_USER);
 if not Query(obj,SQL.Text) then
  Exit;

 Result:=true;
end;

function SQL_PrepareDB(obj:pointer):longbool cdecl;
var sql:TStringList;
begin
 Result:=false;

 if obj<>nil then //optimization
  begin
   sql:=TStringList.Create();
   Result:=PrepareDBInternal(obj,sql);
   sql.Free;
  end;
end;

function SQL_ApplyUserRights(obj:pointer;const user:pchar;ur_editcosts,ur_deloldrecords,ur_editcompvars,ur_editvars,ur_editcontent,ur_editcomprules,ur_editrules,ur_vipwork:longbool):longbool cdecl;
var q:TStringList;
    user_name:string;
begin
 Result:=false;

 user_name:=string(user);

 if user_name<>'' then
  begin
   q:=TStringList.Create;

   if ur_editcosts then
    begin
     q.Add('GRANT SELECT,INSERT,UPDATE ON TPrices TO '+user_name);
     q.Add('DENY DELETE ON TPrices TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT,INSERT ON TPrices TO '+user_name);
     q.Add('DENY DELETE,UPDATE ON TPrices TO '+user_name);
    end;

   if ur_deloldrecords then
    begin
     q.Add('GRANT SELECT,DELETE ON TServices TO '+user_name);
     q.Add('GRANT SELECT,DELETE ON TEvents TO '+user_name);
     q.Add('GRANT SELECT,DELETE ON TUserResponses TO '+user_name);
     q.Add('DENY INSERT,UPDATE ON TServices TO '+user_name);
     q.Add('DENY INSERT,UPDATE ON TEvents TO '+user_name);
     q.Add('DENY INSERT,UPDATE ON TUserResponses TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TServices TO '+user_name);
     q.Add('GRANT SELECT ON TEvents TO '+user_name);
     q.Add('GRANT SELECT ON TUserResponses TO '+user_name);
     q.Add('DENY INSERT,UPDATE,DELETE ON TServices TO '+user_name);
     q.Add('DENY INSERT,UPDATE,DELETE ON TEvents TO '+user_name);
     q.Add('DENY INSERT,UPDATE,DELETE ON TUserResponses TO '+user_name);
    end;

   q.Add('GRANT SELECT ON TDBUsers TO '+user_name);

   if ur_editcompvars then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TCompProfiles TO '+user_name);
     q.Add('GRANT EXECUTE ON PCompProfilesAddModify TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TCompProfiles TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TCompProfiles TO '+user_name);
     q.Add('DENY EXECUTE ON PCompProfilesAddModify TO '+user_name);
    end;

   if ur_editvars then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TVarsProfiles TO '+user_name);
     q.Add('GRANT EXECUTE ON PVarsProfilesAddModify TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TVarsProfiles TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TVarsProfiles TO '+user_name);
     q.Add('DENY EXECUTE ON PVarsProfilesAddModify TO '+user_name);
    end;

   if ur_editcontent then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TContentProfiles TO '+user_name);
     q.Add('GRANT EXECUTE ON PContentProfilesAddModify TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TContentProfiles TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TContentProfiles TO '+user_name);
     q.Add('DENY EXECUTE ON PContentProfilesAddModify TO '+user_name);
    end;

   if ur_editcomprules then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TCompSettingsRules TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TCompSettingsRules TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TCompSettingsRules TO '+user_name);
    end;

   if ur_editrules then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TSettingsRules TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TSettingsRules TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TSettingsRules TO '+user_name);
    end;

   if ur_vipwork then
    begin
     q.Add('GRANT SELECT,DELETE,UPDATE,INSERT ON TVipUsers TO '+user_name);
     q.Add('GRANT EXECUTE ON PVipLogin TO '+user_name);
     q.Add('GRANT EXECUTE ON PVipRegister TO '+user_name);
     q.Add('GRANT EXECUTE ON PVipDelete TO '+user_name);
     q.Add('GRANT EXECUTE ON PVipClearPass TO '+user_name);
    end
   else
    begin
     q.Add('GRANT SELECT ON TVipUsers TO '+user_name);
     q.Add('DENY DELETE,UPDATE,INSERT ON TVipUsers TO '+user_name);
     q.Add('DENY EXECUTE ON PVipLogin TO '+user_name);
     q.Add('DENY EXECUTE ON PVipRegister TO '+user_name);
     q.Add('DENY EXECUTE ON PVipDelete TO '+user_name);
     q.Add('DENY EXECUTE ON PVipClearPass TO '+user_name);
    end;

   Result:=Query(obj,q.Text);
   
   q.Free;
  end;
end;

function SQL_ConnectAsInternalUser(const s_server:pchar):pointer cdecl;
begin
 Result:=SQL_Connect(s_server,RUNPAD_USER,RUNPAD_PWD,RUNPAD_BASE);
end;

function SQL_ConnectAsBackupOperator(const s_server:pchar):pointer cdecl;
begin
 Result:=SQL_Connect(s_server,RUNPAD_BACKUP_USER,RUNPAD_PWD,'');
end;

function SQL_ConnectAsNormalUser(const s_server,s_login,s_pwd:pchar):pointer cdecl;
begin
 Result:=SQL_Connect(s_server,s_login,s_pwd,RUNPAD_BASE);
end;



exports
      // low-level SQL-functions
      SQL_FinishLibrary,
      SQL_Connect,
      SQL_Disconnect,
      SQL_IsConnected,
      SQL_PollServer,
      SQL_GetLastError,
      SQL_EscapeString,
      SQL_Exec,
      SQL_CallStoredProc,

      // high-level SQL-functions
      SQL_InplaceCallStoredProc,
      SQL_CreateUser,
      SQL_ChangeCurrentPwd,
      SQL_ChangeOtherPwd,
      SQL_RemoveUserFromCurrentBase,
      SQL_BeginTransaction,
      SQL_CommitTransaction,
      SQL_RollbackTransaction,
      SQL_IsMSSQLSyntax,
      SQL_IsMySQLSyntax,

      // runpad-specific functions
      SQL_RuleCheck,
      SQL_PrepareDB,
      SQL_ApplyUserRights,
      SQL_ConnectAsInternalUser,
      SQL_ConnectAsBackupOperator,
      SQL_ConnectAsNormalUser;


begin
end.
