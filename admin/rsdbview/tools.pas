unit tools;

interface


function IsOperator:boolean;
procedure WriteConfigStr(use_lm:boolean;local_key,value,data:string);
procedure WriteConfigInt(use_lm:boolean;local_key,value:string;data:integer);
function ReadConfigStr(use_lm:boolean;local_key,value,def:string):string;
function ReadConfigInt(use_lm:boolean;local_key,value:string;def:integer):integer;
procedure SHExecLocalFile(s:string);
function ExecLocalFile(s:string):boolean;
procedure WaitCursor(state:boolean;process_messages:boolean);
function GetLocalPath(local:string):string;


implementation

uses global, SysUtils, Windows, Messages, Registry, Shellapi, Forms, Controls;


function IsOperator:boolean;
begin
 Result:=not FileExists(GetLocalPath(RSSETTINGS_EXE));
end;

procedure WriteConfigStr(use_lm:boolean;local_key,value,data:string);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if use_lm then
  reg.RootKey:=HKEY_LOCAL_MACHINE;
 if reg.OpenKey(REGPATH+local_key,true) then
   begin
     try
       reg.WriteString(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

procedure WriteConfigInt(use_lm:boolean;local_key,value:string;data:integer);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if use_lm then
  reg.RootKey:=HKEY_LOCAL_MACHINE;
 if reg.OpenKey(REGPATH+local_key,true) then
   begin
     try
       reg.WriteInteger(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

function ReadConfigStr(use_lm:boolean;local_key,value,def:string):string;
var reg:TRegistry;
    s:string;
begin
 s:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if use_lm then
  reg.RootKey:=HKEY_LOCAL_MACHINE;
 if reg.OpenKeyReadOnly(REGPATH+local_key) then
   begin
     try
      s:=reg.ReadString(value);
      if s='' then
        s:=def;
     except end;
     reg.CloseKey;
   end;
 reg.Free;
 Result:=s;
end;

function ReadConfigInt(use_lm:boolean;local_key,value:string;def:integer):integer;
var reg:TRegistry;
    rc:integer;
begin
 rc:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if use_lm then
  reg.RootKey:=HKEY_LOCAL_MACHINE;
 if reg.OpenKeyReadOnly(REGPATH+local_key) then
   begin
     try
      rc:=reg.ReadInteger(value);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
 Result:=rc;
end;

procedure SHExecLocalFile(s:string);
var cmd:string;
begin
 cmd:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))+s;
 ShellExecute(0, nil, pchar(cmd), nil, nil, SW_SHOWNORMAL);
end;

function ExecLocalFile(s:string):boolean;
var cwd:string;
    p:array[0..MAX_PATH] of char;
    si:_STARTUPINFOA;
    pi:_PROCESS_INFORMATION;
begin
 cwd:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
 StrCopy(p,pchar(cwd+s));
 FillChar(si,sizeof(si),0);
 si.cb:=sizeof(si);
 Result:=CreateProcess(nil,p,nil,nil,false,0,nil,pchar(cwd),si,pi);
end;

procedure WaitCursor(state:boolean;process_messages:boolean);
begin
 if state then
  begin
   Screen.Cursor:=crHourGlass;
   if process_messages then
     Application.ProcessMessages;
  end
 else
  begin
   Screen.Cursor:=crDefault;
  end;
end;

function GetLocalPath(local:string):string;
var s:array[0..MAX_PATH] of char;
begin
 s[0]:=#0;
 GetModuleFileName(hInstance,s,sizeof(s));
 Result:=IncludeTrailingPathDelimiter(ExtractFilePath(s))+local;
end;


end.
