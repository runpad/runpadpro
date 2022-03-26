program bodyiso;

uses
  Forms, Windows, Messages,
  main in 'main.pas' {BodyISOForm},
  OpnSavF in 'OpnSavF.pas' {OpenSaveForm};


{$R *.res}
{$R images.res}

var w:HWND;

begin
  if FindWindow('TBodyISOForm',nil)<>0 then
   Exit;

  w:=FindWindow('_RunpadClass',nil);
  if w=0 then
   Exit;

  if SendMessage(w,WM_USER+187,0,0)=0 then
   Exit;

  Application.Initialize;
  Application.CreateForm(TBodyISOForm, BodyISOForm);
  Application.CreateForm(TOpenSaveForm, OpenSaveForm);
  Application.Run;
end.
