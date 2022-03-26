

type TMaxPathString = array [0..MAX_PATH-1] of char;


type TOldLnkFileInfo = record
 name          : TMaxPathString;
 exe           : TMaxPathString;
 arg           : TMaxPathString;
 cwd           : TMaxPathString;
 showcmd       : integer;
 icon          : TMaxPathString;
 icon_idx      : integer;
 vcd           : TMaxPathString;
 desc          : TMaxPathString;
 sshot         : TMaxPathString;
 allow_one     : longbool;
 runas_domain  : TMaxPathString;
 runas_user    : TMaxPathString;
 runas_pwd     : TMaxPathString;
 vcd_num       : integer;
 saver         : TMaxPathString;
 run_script    : TMaxPathString;
end;
POldLnkFileInfo = ^TOldLnkFileInfo;


type TOldLnkFileProc = function(const i:POldLnkFileInfo;parm:pointer):longbool cdecl;


procedure OldLnkFile_Iterate(const path:pchar;proc:TOldLnkFileProc;parm:pointer) cdecl; external 'rssettings.dll';

function DLL_CreateFlashDrivesEnumerator():cardinal cdecl; external 'rssettings.dll';
procedure DLL_DestroyFlashDrivesEnumerator(h:cardinal) cdecl; external 'rssettings.dll';
function DLL_GetNextFlashDrive(h:cardinal;pidx:pinteger;s_inst:pchar;maxlen:integer):longbool cdecl; external 'rssettings.dll';

