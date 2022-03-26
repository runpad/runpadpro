program rsbrowser;

uses
  Windows,
  Forms,
  main in 'main.pas' {RSFolderBrowserForm},
  search in 'search.pas' {SearchFilesForm};


{$R *.res}

{$I ..\rp_shared\rp_shared.inc}
{$I ..\common\version.inc}


procedure CmdLine;
begin
 if ParamCount<>1 then
  Halt;
end;


begin
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then
   Exit;
  CmdLine;
  Application.Initialize;
  Application.CreateForm(TRSFolderBrowserForm, RSFolderBrowserForm);
  Application.CreateForm(TSearchFilesForm, SearchFilesForm);
  Application.Run;
end.
