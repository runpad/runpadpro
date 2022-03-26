
unit global;

interface

uses WinTypes;


const PATH_DBVIEW = 'rsdbview.exe';
const REGPATH = 'Software\RunpadProOperator';
const OURAPPNAME = 'RSOperator';


type
    TSTRING = array [0..MAX_PATH-1] of char;

    TENVENTRY = record
     guid : cardinal;
     class_name : TSTRING;
     ip : TSTRING;
     mac : TSTRING;
     runpad_ver : TSTRING;
     machine_loc : TSTRING;
     machine_desc : TSTRING;
     comp_name : TSTRING;
     domain : TSTRING;
     user_name : TSTRING;
     vip_session : TSTRING;
     active_task : TSTRING;
     monitor_state : longbool;
     blocked_state : longbool;
     is_rfm : longbool;
     is_rd : longbool;
     is_rollback : longbool;
    end;
    PENVENTRY = ^TENVENTRY;

    TENVENTRYDELPHI = record
     guid : cardinal;
     class_name : string;
     ip : string;
     mac : string;
     runpad_ver : string;
     machine_loc : string;
     machine_desc : string;
     comp_name : string;
     domain : string;
     user_name : string;
     vip_session : string;
     active_task : string;
     monitor_state : longbool;
     blocked_state : longbool;
     is_rfm : longbool;
     is_rd : longbool;
     is_rollback : longbool;
    end;
    PENVENTRYDELPHI = ^TENVENTRYDELPHI;

    THostConnection = record
     OnTitleChanged : procedure(const title:pchar) cdecl;
     GetServerName : procedure(_out:pchar) cdecl;
     IsServerConnected : function():longbool cdecl;
     GetEnvListCount : function():integer cdecl;
     GetEnvListAt : procedure(idx:integer;_out:PENVENTRY) cdecl;
     WakeupOnLAN : procedure(const ip,mac:pchar) cdecl;
     IsOurIP : function(const ip:pchar):longbool cdecl;
     ExecFunction : procedure(id:integer;const list:PENVENTRY;count:integer) cdecl;
    end;
    PHostConnection = ^THostConnection;


implementation


end.
