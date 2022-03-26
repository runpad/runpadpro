program setup_selector;

uses
  Forms,
  main in 'main.pas' {SetupForm};

{$R *.res}
{$R resource.res}

{$I ..\version.inc}


begin
  Application.Initialize;
  Application.Title:=GLOBAL_VERSION;
  Application.CreateForm(TSetupForm, SetupForm);
  Application.Run;
end.
