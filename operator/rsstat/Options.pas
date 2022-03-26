unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Registry, ShellApi;

type
  TFormOptions = class(TForm)
    ButtonOk: TSpeedButton;
    ButtonCancel: TSpeedButton;
    Notebook: TNotebook;
    GroupBox1: TGroupBox;
    teRatingMax: TEdit;
    rbRatingAuto: TRadioButton;
    rbRatingMax: TRadioButton;
    TreeView: TTreeView;
    LabelCaption: TLabel;
    LabelVersion: TLabel;
    StaticText: TStaticText;
    GroupBox2: TGroupBox;
    dtpTimeFrom: TDateTimePicker;
    dtpTimeTill: TDateTimePicker;
    udRatingMax: TUpDown;
    LabelCopyright: TLabel;
    LabelHyperlink: TLabel;
    cbTime: TComboBox;
    lFrom: TLabel;
    lTill: TLabel;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure rbRatingMaxClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbTimeChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    function FormHelp(Command: Word; Data: Integer;
      var CallHelp: Boolean): Boolean;
    procedure LabelHyperlinkMouseEnter(Sender: TObject);
    procedure LabelHyperlinkMouseLeave(Sender: TObject);
    procedure LabelHyperlinkClick(Sender: TObject);
  private
    procedure LoadSettings(defaults: boolean);
    procedure SaveSettings;
    { Private declarations }
  public
    function ScaleRatingAuto(defaults: boolean): boolean;
    function ScaleRating(defaults: boolean): integer;
    function ScaleDateManual(defaults: boolean): integer;
    function ScaleDateFrom(defaults: boolean): TDateTime;
    function ScaleDateTill(defaults: boolean): TDateTime;

    function ScaleDateManualFrom(): TDateTime;
    function ScaleDateManualTill(): TDateTime;
    { Public declarations }
  end;

var
  FormOptions: TFormOptions;

implementation

{$R *.dfm}

const REGPATH = 'Software\RunpadProOperator\Stat';


function TFormOptions.ScaleRatingAuto(defaults: boolean): boolean;
var
  reg: TRegistry;
begin
  Result := true;
  if defaults then
    exit;
  reg := TRegistry.Create();
  if reg.OpenKeyReadOnly(REGPATH) then
    try
      Result := reg.ReadBool('ScaleRatingAuto');
    except end;
  reg.Free;
end;

function TFormOptions.ScaleRating(defaults: boolean): integer;
var
  reg: TRegistry;
begin
  Result := 24;
  if defaults then
    exit;
  reg := TRegistry.Create();
  if reg.OpenKeyReadOnly(REGPATH) then
    try
      Result := reg.ReadInteger('ScaleRating');
    except end;
  reg.Free;
end;

function TFormOptions.ScaleDateManual(defaults: boolean): integer;
var
  reg: TRegistry;
begin
  Result := 0;
  if defaults then
    exit;
  reg := TRegistry.Create();
  if reg.OpenKeyReadOnly(REGPATH) then
    try
      Result := reg.ReadInteger('ScaleDateManual');
    except end;
  reg.Free;
end;

function TFormOptions.ScaleDateFrom(defaults: boolean): TDateTime;
var
  reg: TRegistry;
begin
  Result := Now;
  if defaults then
    exit;
  reg := TRegistry.Create();
  if reg.OpenKeyReadOnly(REGPATH) then
    try
      Result := reg.ReadDate('ScaleDateFrom');
    except end;
  reg.Free;
end;

function TFormOptions.ScaleDateTill(defaults: boolean): TDateTime;
var
  reg: TRegistry;
begin
  Result := Now;
  if defaults then
    exit;
  reg := TRegistry.Create();
  if reg.OpenKeyReadOnly(REGPATH) then
    try
      Result := reg.ReadDate('ScaleDateTill');
    except end;
  reg.Free;
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function TFormOptions.ScaleDateManualFrom(): TDateTime;
begin
  case ScaleDateManual(false) of
    0: Result := Now; // Auto
    1: Result := Now - 365; //Last year
    2: Result := Now - 90; //Last 3 month
    3: Result := Now - 30; //Last month
    4: Result := Now - 7; //Last week
    else Result := ScaleDateFrom(false);//Manual
    end; {case}
end;

function TFormOptions.ScaleDateManualTill(): TDateTime;
begin
  case ScaleDateManual(false) of
    0: Result := Now; // Auto
    1: Result := Now; //Last year
    2: Result := Now; //Last 3 month
    3: Result := Now; //Last month
    4: Result := Now; //Last week
    else Result := ScaleDateTill(false);//Manual
    end; {case}
end;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


procedure TFormOptions.LoadSettings(defaults: boolean);
begin
  udRatingMax.Position := ScaleRating(defaults);
  if ScaleRatingAuto(defaults) then
    rbRatingAuto.Checked := true
  else
    rbRatingMax.Checked := true;

  dtpTimeFrom.DateTime := ScaleDateFrom(defaults);
  dtpTimeTill.DateTime := ScaleDateTill(defaults);
  cbTime.ItemIndex := ScaleDateManual(defaults);
  cbTimeChange(cbTime);
end;


procedure TFormOptions.SaveSettings;
var
  reg:TRegistry;
  i : integer;
  b : boolean;
  date1, date2 : TDateTime;
begin
  reg := TRegistry.Create();
  if reg.OpenKey(REGPATH, true) then
    begin

      b := true;
      if rbRatingMax.Checked then
        b := false;
      i := udRatingMax.Position;
      try
        reg.WriteBool('ScaleRatingAuto', b);
        reg.WriteInteger('ScaleRating', i);
      except end;  

      i := cbTime.ItemIndex;
      date1 := dtpTimeFrom.DateTime;
      date2 := dtpTimeTill.DateTime;
      try
        reg.WriteInteger('ScaleDateManual', i);
        reg.WriteDate('ScaleDateFrom', date1);
        reg.WriteDate('ScaleDateTill', date2);
      except end;

      reg.CloseKey;
    end;
  reg.Free;
end;


procedure TFormOptions.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  Notebook.PageIndex := Node.ImageIndex;
  StaticText.Caption := Node.Text + ' ';
end;

procedure TFormOptions.FormActivate(Sender: TObject);
begin
  LoadSettings(false);
end;

procedure TFormOptions.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormOptions.ButtonOkClick(Sender: TObject);
begin
  SaveSettings;
  ModalResult := mrOk;
end;

procedure TFormOptions.rbRatingMaxClick(Sender: TObject);
begin
  teRatingMax.Enabled := rbRatingMax.Checked;
  udRatingMax.Enabled := rbRatingMax.Checked;
end;

procedure TFormOptions.cbTimeChange(Sender: TObject);
var
  ManualEnbled: boolean;
begin
  ManualEnbled := cbTime.ItemIndex = cbTime.Items.Count-1;
  dtpTimeFrom.Visible := ManualEnbled;
  dtpTimeTill.Visible := ManualEnbled;
  lFrom.Visible := ManualEnbled;
  lTill.Visible := ManualEnbled;
end;

procedure TFormOptions.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
    ButtonOk.Click;
  if Key=VK_ESCAPE then
    ButtonCancel.Click;  
end;

function TFormOptions.FormHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  Result := True;
  if Command = HELP_CONTEXTPOPUP then begin
    WinHelp(Handle, PChar(Application.HelpFile), Command, Data);
    CallHelp := False;
  end;
end;

procedure TFormOptions.LabelHyperlinkMouseEnter(Sender: TObject);
begin
  LabelHyperlink.Font.Color := clBlue;
end;

procedure TFormOptions.LabelHyperlinkMouseLeave(Sender: TObject);
begin
  LabelHyperlink.Font.Color := clWindowText;
end;

procedure TFormOptions.LabelHyperlinkClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://www.runpad-shell.com', nil, nil, SW_SHOWNORMAL);
end;

end.
