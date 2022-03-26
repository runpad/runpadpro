program bodybt;

{$I BF.inc}

uses
  Windows, Messages, Forms, Classes, SysUtils, lang,
  main in 'main.pas' {BodyBTForm};

{$R *.res}
{$R images.res}


function CmdLine:boolean;
var n:integer;
begin
  Result:=false;
  g_mode:=MODE_NONE;

  if (ParamCount>1) then
   begin
    if (ParamStr(1)='-send') or (ParamStr(1)='-send2') then
     begin
      FileList:=TStringList.Create;
      for n:=2 to ParamCount do
       FileList.Add(ParamStr(n));
      g_mode:=MODE_SEND;
      g_mobile_content:=(ParamStr(1)='-send2');
      Result:=true;
     end
    else
    if ParamStr(1)='-recv' then
     begin
      DestDir:=ParamStr(2);
      if DirectoryExists(DestDir) then
       begin
        g_mode:=MODE_RECV;
        g_mobile_content:=false;
        Result:=true;
       end;
     end;
   end;
end;

function Check:boolean;
begin
 Result:=FindWindow('_RunpadClass',nil)<>0;
end;

function CheckLoaded:boolean;
begin
 Result:=FindWindow('TBodyBTForm',nil)=0;
end;

function CheckGCBase:boolean;
var w:HWND;
begin
 Result:=false;
 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
  Result:=SendMessage(w,WM_USER+187,0,0)<>0;
end;



begin
  if not Check then 
   Exit;

  if not CheckLoaded then 
   begin
    MessageBox(0,S_ALREADYRUN,S_INFO,MB_OK or MB_ICONINFORMATION);
    Exit;
   end;

  if not CmdLine then 
   Exit;

  if not CheckGCBase then
   Exit;

  user_message := RegisterWindowMessage(BEGIN_MESSAGE_NAME);

  Application.Initialize;
  Application.Title := S_TITLE;
  Application.CreateForm(TBodyBTForm, BodyBTForm);
  Application.Run;

  if Assigned(FileList) then
   FileList.Free;
end.
