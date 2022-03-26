
const CFG_DLL_NAME = 'rscfg.dll';


const MACHINE_TYPE_GAMECLUB = 1;
const MACHINE_TYPE_INETCAFE = 2;
const MACHINE_TYPE_OPERATOR = 4;
const MACHINE_TYPE_ORGANIZATION = 8;
const MACHINE_TYPE_TERMINAL = 16;
const MACHINE_TYPE_HOME = 32;
const MACHINE_TYPE_OTHER = 64;

type TPATH = array [0..MAX_PATH-1] of char;
type TSTRING = array [0..MAX_PATH-1] of char;
type TLONGSTRING = array [0..4095] of char;

type TSHEETVARS = record
 s_name: TSTRING;
 s_icon_path: TPATH;
 i_color: integer;
 i_bg_color: integer;
 s_bg_pic: TPATH;
 s_bg_thumb_pic: TPATH;
 i_time_min: integer;
 i_time_max: integer;
 s_vip_users: TSTRING;
 s_rules: TPATH;
 is_internet_sheet: longbool;
end;
type PSHEETVARS = ^TSHEETVARS;

type TSHORTCUTVARS = record
 s_name: TSTRING;
 s_exe: TPATH;
 s_arg: TSTRING;
 s_cwd: TPATH;
 s_icon_path: TPATH;
 i_icon_idx: integer;
 s_pwd: TSTRING;
 b_allow_only_one: longbool;
 s_runas_domain: TSTRING;
 s_runas_user: TSTRING;
 s_runas_pwd: TSTRING;
 i_show_cmd: integer;
 i_vcd_num: integer;
 s_vcd: TPATH;
 s_saver: TLONGSTRING;
 s_sshot: TPATH;
 s_desc: TLONGSTRING;
 s_script1: TLONGSTRING;
 s_group: TSTRING;
 s_floatlic: TPATH;
end;
type PSHORTCUTVARS = ^TSHORTCUTVARS;



procedure CfgReadConfig(block:pointer;block_size:integer;lang:integer;machine_type:integer) 
          cdecl; external CFG_DLL_NAME;
procedure CfgWriteBWCConfig() 
          cdecl; external CFG_DLL_NAME;
function  CfgWriteConfig(write_vars:longbool;write_content:longbool;_size:pinteger):pointer 
          cdecl; external CFG_DLL_NAME;
procedure CfgFreeBlock(block:pointer)
          cdecl; external CFG_DLL_NAME;
function  CfgGetBoolValue(name:pchar):longbool 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetBoolValue(name:pchar;value:longbool) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetIntValue(name:pchar):integer 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetIntValue(name:pchar;value:integer) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetPathValue(name:pchar):pchar 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetPathValue(name:pchar;value:pchar) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetStringValue(name:pchar):pchar 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetStringValue(name:pchar;value:pchar) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetLongStringValue(name:pchar):pchar 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetLongStringValue(name:pchar;value:pchar) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetList1Value(name:pchar;idx:integer;parm1:ppchar):longbool 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetList1Value(name:pchar;idx:integer;state:longbool;parm1:pchar) 
          cdecl; external CFG_DLL_NAME;
function  CfgGetList2Value(name:pchar;idx:integer;parm1:ppchar;parm2:ppchar):longbool 
          cdecl; external CFG_DLL_NAME;
procedure CfgSetList2Value(name:pchar;idx:integer;state:longbool;parm1:pchar;parm2:pchar) 
          cdecl; external CFG_DLL_NAME;
function CfgGetCntSheetsCount():integer
          cdecl; external CFG_DLL_NAME;
function CfgGetCntSheetAt(idx:integer):pointer
          cdecl; external CFG_DLL_NAME;
function CfgGetCntShortcutsCount(sh:pointer):integer
          cdecl; external CFG_DLL_NAME;
function CfgGetCntShortcutAt(sh:pointer;idx:integer):pointer
          cdecl; external CFG_DLL_NAME;
procedure CfgGetCntSheetVars(sh:pointer;_out:PSHEETVARS)
          cdecl; external CFG_DLL_NAME;
procedure CfgGetCntShortcutVars(sh:pointer;_out:PSHORTCUTVARS)
          cdecl; external CFG_DLL_NAME;
function CfgAddCntSheet(name:pchar):pointer
          cdecl; external CFG_DLL_NAME;
function CfgAddCntShortcut(sh:pointer;name:pchar):pointer
          cdecl; external CFG_DLL_NAME;
procedure CfgSetCntSheetVars(sh:pointer;_in:PSHEETVARS)
          cdecl; external CFG_DLL_NAME;
procedure CfgSetCntShortcutVars(sh:pointer;_in:PSHORTCUTVARS)
          cdecl; external CFG_DLL_NAME;
procedure CfgMoveCntSheet(_from,_to:integer)
          cdecl; external CFG_DLL_NAME;
procedure CfgMoveCntShortcut(sh:pointer;_from,_to:integer)
          cdecl; external CFG_DLL_NAME;
procedure CfgDelCntSheet(idx:integer)
          cdecl; external CFG_DLL_NAME;
procedure CfgDelCntShortcut(sh:pointer;idx:integer)
          cdecl; external CFG_DLL_NAME;
procedure CfgClearCnt()
          cdecl; external CFG_DLL_NAME;
procedure CfgStr2MD5(const str:pchar;md5_str:pchar)
          cdecl; external CFG_DLL_NAME;
