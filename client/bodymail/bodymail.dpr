program bodymail;

uses
  Forms, Windows, Messages, Registry, lang,
  main in 'main.pas' {BodyMailForm},
  OpnSavF in 'OpnSavF.pas' {OpenSaveForm};

{$R *.res}
{$R images.res}

{$I ..\rp_shared\rp_shared.inc}
{$I ..\common\version.inc}



procedure ReadConfig;
var reg:TRegistry;
begin
 mail_smtp:='';
 mail_user:='';
 mail_password:='';
 mail_port:=25;
 mail_hardcoded:=false;
 mail_from_name:='';
 mail_from_address:='';
 mail_footer:='';
 mail_to:='';

 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell') then
  begin
   try
    mail_smtp:=reg.ReadString('bodymail_smtp');
   except end;
   try
    mail_user:=reg.ReadString('bodymail_user');
   except end;
   try
    mail_password:=reg.ReadString('bodymail_password');
   except end;
   try
    mail_port:=reg.ReadInteger('bodymail_port');
   except end;
   try
    mail_hardcoded:=reg.ReadBool('bodymail_hardcoded');
   except end;
   try
    mail_from_name:=reg.ReadString('bodymail_from_name');
   except end;
   try
    mail_from_address:=reg.ReadString('bodymail_from_address');
   except end;
   try
    mail_footer:=reg.ReadString('bodymail_footer');
   except end;
   try
    mail_to:=reg.ReadString('bodymail_to');
   except end;
   reg.CloseKey;
  end;
 reg.Free;

 if mail_smtp='' then
  begin
   MessageBox(0,S_NO_SMTP,S_INFO,MB_OK or MB_ICONWARNING);
   Halt;
  end;

 if not mail_hardcoded then
  begin
   mail_footer:='';
   mail_to:='';
  end;

 if mail_hardcoded then
  begin
   if (mail_from_name='') or (mail_from_address='') then
    mail_hardcoded:=false;
  end;
end;

function CheckGCBase:boolean;
var w:HWND;
begin
 Result:=false;
 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
  Result:=SendMessage(w,WM_USER+187,0,0)<>0;
end;


begin
  if not CheckRPVersion(RUNPAD_VERSION_DIG) then
   Exit;

  if not CheckGCBase then
   Exit;

  ReadConfig;
  Application.Initialize;
  Application.CreateForm(TBodyMailForm, BodyMailForm);
  Application.CreateForm(TOpenSaveForm, OpenSaveForm);
  Application.Run;
end.
