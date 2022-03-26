program rsstat;

uses
  Forms, Windows,
  main in 'main.pas' {FormStat},
  Options in 'Options.pas' {FormOptions};

{$R *.res}

function InitApplication: Boolean;
var
  Wnd: HWND;
  i: integer;
  h: THandle;
  s: string;
begin
  user_message := RegisterWindowMessage('TFormStat');
  Wnd := FindWindow('TFormStat', nil);
  if Wnd<>0 then
    begin
      for i:=1 to ParamCount do
        begin
          s := ParamStr(i);
          if Length(s) >= 255 then
          begin
            MessageBox(0, PChar('Длина пути превышает установленный предел:'#10#13 + s + #10#13'Обратитесь к разработчику'), 'Ошибка', MB_OK);
            Result := false;
            Exit;
          end;

          h := GlobalAddAtom(PChar(s));

          if h=0 then
          begin
            MessageBox(0, PChar('Ошибка при передаче пути:'#10#13 + s + #10#13'Обратитесь к разработчику'), 'Ошибка', MB_OK);
            Result := false;
            Exit;
          end;

          SendMessage(Wnd, user_message, h, 0);
          GlobalDeleteAtom(h);
        end;
      Result := false;
      Exit;
    end;

  i := Length(Application.ExeName);
  while (i>1) and (Application.ExeName[i]<>'\') do
    i := i-1;
  Application.HelpFile := Copy(Application.ExeName, 1, i) + 'rsstat.hlp';

  Result := true;
end;

begin
  Application.Initialize;
  Application.Title := 'Статистика запуска программ';

  if not InitApplication then Exit;

  Application.CreateForm(TFormStat, FormStat);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.Run;
end.
