unit VistaAltFixUnit;

interface

uses
  ExtCtrls, Classes, Contnrs, AppEvnts;

type
  TVistaAltFix = class(TComponent)
  private
    FList: TObjectList;
    FApplicationEvents: TApplicationEvents;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    function VistaWithTheme: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses
  Forms, Windows, Messages, Buttons, ComCtrls, Controls, StdCtrls, Themes;

type
  TFormObj = class(TObject)
  private
    procedure WndProc(var Message: TMessage);
  public
    Form: TForm;
    OrgProc: TWndMethod;
    Used: Boolean;
    NeedRepaint: Boolean;
    constructor Create(aForm: TForm);
    procedure DoRepaint;
  end;

{ TVistaAltFix }

procedure TVistaAltFix.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
var
  I: Integer;
  J: Integer;
  TestForm: TForm;
begin
  // Initialize
  for I := 0 to FList.Count - 1 do
    TFormObj(FList[i]).Used := False;

  // Check for new forms
  for I := 0 to Screen.FormCount - 1 do
  begin
    TestForm := Screen.Forms[i];
    for J := 0 to FList.Count - 1 do
    begin
      if TFormObj(FList[J]).Form = TestForm then
      begin
        TFormObj(FList[J]).Used := True;
        TestForm := nil;
        Break;
      end;
    end;
    if Assigned(TestForm) then
      FList.Add(TFormObj.Create(TestForm));
  end;

  // Remove destroyed forms, repaint others if needed.
  for I := FList.Count - 1 downto 0 do
  begin
    if not TFormObj(FList[i]).Used then
      FList.Delete(i)
    else
      TFormObj(FList[i]).DoRepaint;
  end;
end;

constructor TVistaAltFix.Create(AOwner: TComponent);
begin
  inherited;
  FList:=nil;
  FApplicationEvents:=nil;

  if VistaWithTheme and not (csDesigning in ComponentState) then
  begin
    FList := TObjectList.Create;
    FApplicationEvents := TApplicationEvents.Create(nil);
    FApplicationEvents.OnIdle := ApplicationEventsIdle;
  end;
end;

destructor TVistaAltFix.Destroy;
begin
  FApplicationEvents.Free;
  FList.Free;
  inherited;
end;

function TVistaAltFix.VistaWithTheme: Boolean;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) and
     (OSVersionInfo.dwMajorVersion >= 6) and
     ThemeServices.ThemesEnabled then
    Result := True
  else
    Result := False;
end;

{ TFormObj }

constructor TFormObj.Create(aForm: TForm);
begin
  inherited Create;
  Form := aForm;
  NeedRepaint:= false;
  Used := True;
  OrgProc := Form.WindowProc;
  Form.WindowProc := WndProc;
end;

procedure TFormObj.DoRepaint;
  procedure DoRepaint(Ctrl: TControl);
  var
    i: integer;
  begin
    if (Ctrl is TWinControl) then
    begin
      TWinControl(Ctrl).Repaint;
      for i := 0 to TWinControl(Ctrl).ControlCount - 1 do
        DoRepaint(TWinControl(Ctrl).Controls[i]);
    end;
  end;

begin
  if NeedRepaint then
  begin
    NeedRepaint := False;
    DoRepaint(Form);
  end;
end;

procedure TFormObj.WndProc(var Message: TMessage);
begin
  OrgProc(Message);
  if (Message.Msg = WM_UPDATEUISTATE) then
    NeedRepaint := True;
end;

end.
