library BodyOffice;

uses
  ComServ, Windows, Messages,
  DirectoryList in 'DirectoryList.pas' {DTExtensibility2: CoClass},
  BodyOffice_TLB in 'BodyOffice_TLB.pas',
  OpnSavF in 'OpnSavF.pas' {OpenSaveForm};


exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}


begin

end.
