program bodycam;

uses
  Forms, Windows, Messages,
  main in 'main.pas' {BodyCamForm};

{$R *.res}
{$R resource.res}

{$INCLUDE ..\rp_shared\rp_shared.inc}


procedure Err(const s:string);
begin
 MessageBox(0,pchar(s),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
end;

procedure Msg(const s:string);
begin
 MessageBox(0,pchar(s),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
end;


var r_w : HWND;


begin
  if (Windows.GetVersion() and $80000000)<>0 then
   begin
    Err(LS(4000));
    Exit;
   end;

  if FindWindow('TBodyCamForm',nil)<>0 then
   begin
    Msg(LS(4001));
    Exit;
   end;

  r_w := FindWindow('_RunpadClass',nil);
  if r_w=0 then
   begin
    Err('Runpad Shell not active');
    Exit;
   end;
       
  if SendMessage(r_w,WM_USER+187,0,0)=0 then
   Exit;

  if ParamCount<>1 then
   begin
    Msg(LS(4009));
    Exit;
   end;

  dest_folder:=ParamStr(1);

  Application.Initialize;
  Application.Title:=LS(4002);
  Application.CreateForm(TBodyCamForm, BodyCamForm);
  Application.Run;
end.
