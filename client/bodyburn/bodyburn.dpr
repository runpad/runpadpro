program bodyburn;

uses
  Forms, Windows, Messages,
  main in 'main.pas' {BodyBurnForm};


{$R *.res}

{$I ..\rp_shared\rp_shared.inc}
{$I ..\common\version.inc}


function Check:boolean;
var Wnd : HWND;
  i : integer;
  h : THandle;
  s : string;
  user_message : cardinal;
begin
  Wnd := FindWindow('TBodyBurnForm', nil);
  if Wnd<>0 then
    begin
      user_message := RegisterWindowMessage(ADD_MESSAGE_NAME);
      for i:=1 to ParamCount do
        begin
          s := ParamStr(i);
          h := GlobalAddAtom(PChar(s));
          if h<>0 then
           PostMessage(Wnd, user_message, h, 0);
        end;
      Result := false;
      Exit;
    end;

  Result:=true;
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
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then Exit;
  
  if not Check then Exit;

  if not CheckGCBase then Exit;

  Application.Initialize;
  Application.Title := 'Запись на диск';
  Application.CreateForm(TBodyBurnForm, BodyBurnForm);
  Application.Run;
end.
