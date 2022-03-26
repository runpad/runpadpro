program bodyexpl;

uses
  SysUtils,
  DateUtils,
  Windows,
  Forms,
  Registry,
  main in 'main.pas' {BodyExplForm},
  Archive in 'Archive.pas' {FormArchive},
  CreateFolder in 'CreateFolder.pas' {CreateFolderForm},
  RenameFileOrFolder in 'RenameFileOrFolder.pas' {RenameFileOrFolderForm},
  Extract in 'Extract.pas' {FormExtract},
  InProgress in 'InProgress.pas' {FormInProgress},
  selfext in 'selfext.pas' {SEForm},
  search in 'search.pas' {SearchFilesForm};

{$R *.res}
{$R images.res}

{$INCLUDE ..\rp_shared\rp_shared.inc}
{$INCLUDE ..\common\version.inc}


begin
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then
   Exit;

  Application.Initialize;
  //Application.Title := 'Проводник пользователя';
  SetProp(Application.Handle,'_RPBodyExpl',1);
  Application.CreateForm(TBodyExplForm, BodyExplForm);
  Application.CreateForm(TFormArchive, FormArchive);
  Application.CreateForm(TCreateFolderForm, CreateFolderForm);
  Application.CreateForm(TRenameFileOrFolderForm, RenameFileOrFolderForm);
  Application.CreateForm(TFormExtract, FormExtract);
  Application.CreateForm(TFormInProgress, FormInProgress);
  Application.CreateForm(TSEForm, SEForm);
  Application.CreateForm(TSearchFilesForm, SearchFilesForm);
  Application.Run;
  RemoveProp(Application.Handle,'_RPBodyExpl');
end.
