unit tools;

interface


procedure WriteConfigStr(local_key,value,data:string);
procedure WriteConfigInt(local_key,value:string;data:integer);
function ReadConfigStr(local_key,value,def:string):string;
function ReadConfigInt(local_key,value:string;def:integer):integer;
procedure WaitCursor(state:boolean);
function GetFileNameIcon(s:string):integer;
function PathEqu(s1,s2:string):boolean;
function GetFileSizeKB(s:string):cardinal;
function ExtractFileExtStrict(s:string):string;
procedure RunBodyToolWithParms(tool,parms:string);

implementation

uses SysUtils, Windows, Messages, Registry, Shellapi, Forms, Controls;

{$INCLUDE ..\rp_shared\RP_Shared.inc}


procedure WriteConfigStr(local_key,value,data:string);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKey('Software\RunpadProShell'+local_key,true) then
   begin
     try
       reg.WriteString(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

procedure WriteConfigInt(local_key,value:string;data:integer);
var reg:TRegistry;
begin
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKey('Software\RunpadProShell'+local_key,true) then
   begin
     try
       reg.WriteInteger(value,data);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
end;

function ReadConfigStr(local_key,value,def:string):string;
var reg:TRegistry;
    s:string;
begin
 s:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell'+local_key) then
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

function ReadConfigInt(local_key,value:string;def:integer):integer;
var reg:TRegistry;
    rc:integer;
begin
 rc:=def;
 if local_key<>'' then
  local_key:='\'+local_key;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell'+local_key) then
   begin
     try
      rc:=reg.ReadInteger(value);
     except end;
     reg.CloseKey;
   end;
 reg.Free;
 Result:=rc;
end;

procedure WaitCursor(state:boolean);
begin
 if state then
  begin
   Screen.Cursor:=crHourGlass;
   //Application.ProcessMessages;
  end
 else
  begin
   Screen.Cursor:=crDefault;
  end;
end;

function GetFileNameIcon(s:string):integer;
var info:SHFILEINFO;
begin
 Result:=0;
 if SHGetFileInfo(pchar(s),0,info,sizeof(info),SHGFI_ICON or SHGFI_SMALLICON)<>0 then
  Result:=info.hIcon;
 if Result=0 then
  Result:=CopyIcon(LoadIcon(0,IDI_APPLICATION));
end;

function PathEqu(s1,s2:string):boolean;
begin
 s1:=IncludeTrailingPathDelimiter(s1);
 s2:=IncludeTrailingPathDelimiter(s2);
 Result:=(AnsiCompareText(s1,s2)=0);
end;

function GetFileSizeKB(s:string):cardinal;
begin
 Result:=GetDirectorySize(pchar(s));
end;

function ExtractFileExtStrict(s:string):string;
var ext:string;
begin
 Result:='';
 if s<>'' then
  begin
   ext:=ExtractFileExt(ExtractFileName(s));
   if (length(ext)>0) and (ext[1]='.') then
     ext:=Copy(ext,2,length(ext)-1);
   Result:=ext;  
  end;
end;

procedure RunBodyToolWithParms(tool,parms:string);
var s,command:string;
begin
 Command := ExtractFileDir(ParamStr(0));
 if (Command<>'') then
  begin
   Command := IncludeTrailingPathDelimiter(Command) + tool + '.exe';
   s:='"' + Command + '"';
   if parms<>'' then
    begin
     if parms[1]<>' ' then
      s:=s+' ';
     s:=s+parms;
    end;
   RunProcess(PChar(s));
  end;
end;

end.
