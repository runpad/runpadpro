program html_test;

uses
  Forms, ActiveX,
  main in 'main.pas' {MainForm};

{$R *.res}

begin
  OleInitialize(nil);

  Application.Initialize;
  Application.CreateForm(TMainForm,MainForm);
  Application.Run;
end.
