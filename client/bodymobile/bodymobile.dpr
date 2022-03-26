program bodymobile;

uses
  Forms, Windows, Messages, SysUtils, lang,
  main in 'main.pas' {BodyMobileForm};


{$R *.res}
{$R resource.res}



function Check:boolean;
begin
 Result:=FindWindow('_RunpadClass',nil)<>0;
end;

function CheckLoaded:boolean;
begin
 Result:=FindWindow('TBodyMobileForm',nil)=0;
end;



begin
  if not Check then 
   Exit;

  if not CheckLoaded then 
   begin
    MessageBox(0,S_ALREADYRUN,S_INFO,MB_OK or MB_ICONINFORMATION);
    Exit;
   end;
  
  Application.Initialize;
  Application.Title := 'Мобильный контент';
  Application.CreateForm(TBodyMobileForm, BodyMobileForm);
  Application.Run;
end.
