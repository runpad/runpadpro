program bodynotepad;

uses
  Forms, Windows,
  MainF in 'MainF.pas' {BodyNotepadForm},
  OpnSavF in 'OpnSavF.pas' {OpenSaveForm};

{$R *.res}

{$I ..\rp_shared\rp_shared.inc}
{$I ..\common\version.inc}


begin
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then
   Exit;

  Application.Initialize;
  Application.Title:=LS(500);
  Application.CreateForm(TBodyNotepadForm, BodyNotepadForm);
  Application.CreateForm(TOpenSaveForm, OpenSaveForm);
  Application.Run;
end.
