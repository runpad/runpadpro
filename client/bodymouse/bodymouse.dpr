program bodymouse;

uses
  Forms,
  Windows,
  Messages,
  main in 'main.pas' {BodyMouseForm};

{$R *.res}


begin
  if FindWindow('TBodyMouseForm',nil)<>0 then
   Exit;

  Application.Initialize;
  Application.CreateForm(TBodyMouseForm, BodyMouseForm);
  Application.Run;
end.
