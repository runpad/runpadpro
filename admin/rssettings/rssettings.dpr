program rssettings;

uses
  Forms,
  main in 'main.pas' {RSSettingsForm},
  tip in 'tip.pas' {TipForm};

{$R *.res}
{$R resource.res}

{$I ..\common\version.inc}


begin
  Application.Initialize;
  Application.Title := S_VERSION;
  Application.CreateForm(TRSSettingsForm, RSSettingsForm);
  Application.CreateForm(TTipForm, TipForm);
  Application.Run;
end.
