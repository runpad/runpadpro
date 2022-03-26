program rsrdclient;

uses
  Forms, Windows, Messages, Dialogs, Parms, SysUtils, Controls,
  main in 'main.pas' {RDForm};

{$R *.res}

{$INCLUDE rsrdclient.inc}


function TryConnect:boolean;
var form:TParmsForm;
begin
 Result:=false;
 if ParamCount=1 then
  begin
   if not RA_Connect(pchar(ParamStr(1))) then
     MessageBox(0,pchar('Не удалось подключиться к удаленному компьютеру '+ParamStr(1)+#13#10'Убедитесь, что на нем установлена клиентская часть программы'),'Ошибка',MB_OK or MB_ICONERROR)
   else
    begin
     g_computer:=ParamStr(1);
     Result:=true;
    end;
  end
 else
  begin
   form:=TParmsForm.Create(nil);
   if form.ShowModal=mrOk then
     Result:=true;
   form.Free;
  end;
end;


begin
  if not CheckAtStartup(0,false) then
   Exit;
  
  ReadParms;

  Application.Initialize;
  Application.Title := 'Удаленное управление';

  RA_Init();

  if not TryConnect then
   begin
    RA_Done();
    Exit;
   end;

  SaveParms;
  RA_UpdatePictureType(g_picture_type);
  RA_UpdateFPS(GetFPSByIdx(g_fps_idx));

  Application.CreateForm(TRDForm, RDForm);
  Application.Run;

  RA_Disconnect();
  RA_Done();
end.
