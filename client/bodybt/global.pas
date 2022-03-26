
unit global;

interface


function IsNetBurn:boolean;
function GetNetBurnTimeFolder:string;


implementation

uses Registry, SysUtils, Windows;


var determined : boolean = false;
    net_burn_path : string = '';


function IsNetBurn:boolean;
var reg:TRegistry;
begin
 if not determined then
  begin
   net_burn_path:='';
   reg:=TRegistry.Create(KEY_READ);
   if reg.OpenKeyReadOnly('Software\RunpadProShell') then
     begin
       try
         net_burn_path := reg.ReadString('net_bt_path');
       except end;
       reg.CloseKey;
     end;
   reg.Free;
   determined:=true;
  end;

 Result:=net_burn_path<>'';
end;


function GetNetBurnTimeFolder:string;
var s:string;
    buff:array[0..MAX_PATH] of char;
    len:cardinal;
begin
 Result:='';

 if net_burn_path='' then
  exit;

 buff[0]:=#0;
 len:=sizeof(buff);
 GetComputerName(buff,len);
 
 FmtStr(s,'%s_%s\',[string(buff),FormatDateTime('yyyy_mm_dd_hh_nn_ss',Now())]);
 s:=IncludeTrailingPathDelimiter(net_burn_path)+s;

 CreateDirectory(pchar(IncludeTrailingPathDelimiter(net_burn_path)),nil);
 if not CreateDirectory(pchar(s),nil) then
  Result:=''
 else
  Result:=s;
end;


end.
