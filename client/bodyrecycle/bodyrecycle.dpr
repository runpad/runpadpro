program bodyrecycle;

uses
  Forms,
  main in 'main.pas' {BodyRecycleForm};

{$R *.res}
{$R images.res}


begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TBodyRecycleForm, BodyRecycleForm);
  Application.Run;
end.

