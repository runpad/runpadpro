program bodybook;

uses
  Forms, Windows, Messages,
  main in 'main.pas' {BodyBookForm};

{$R *.res}

{$I ..\rp_shared\rp_shared.inc}
{$I ..\common\version.inc}


function CheckSQLBase:boolean;
var w:HWND;
begin
 Result:=false;
 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
  Result:=SendMessage(w,WM_USER+198,0,0)<>0; //strict check!
end;


begin
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then
   Exit;

  if not CheckSQLBase then
   Exit;
  
  Application.Initialize;
  Application.CreateForm(TBodyBookForm, BodyBookForm);
  Application.Run;
end.
