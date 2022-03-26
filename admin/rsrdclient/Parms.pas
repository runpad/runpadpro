
unit parms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Registry;

{$INCLUDE rsrdclient.inc}

type
  TParmsForm = class(TForm)
    Panel1: TPanel;
    Image: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    EditComputer: TEdit;
    Label3: TLabel;
    ComboQuality: TComboBox;
    Label4: TLabel;
    ComboFPS: TComboBox;
    CheckBoxFS: TCheckBox;
    CheckBoxSpectator: TCheckBox;
    Bevel2: TBevel;
    ButtonConnect: TButton;
    ButtonCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure EditComputerChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var g_computer : string;
var g_picture_type : integer;
var g_fps_idx : integer;
var g_start_fs : boolean;
var g_spectator : boolean;


procedure ReadParms;
procedure SaveParms;
function GetFPSListCount:integer;
function GetFPSByIdx(idx:integer):single;
function GetNameFPSByIdx(idx:integer):string;


implementation

{$R *.dfm}


const fps_list : array [0..10] of single =
                 (0.2, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 7.0, 8.0, 10.0, 12.0);


function GetFPSListCount:integer;
begin
 Result:=sizeof(fps_list) div sizeof(fps_list[0]);
end;

function GetFPSByIdx(idx:integer):single;
begin
 if idx<0 then
  idx:=0;
 if idx >= (sizeof(fps_list) div sizeof(fps_list[0])) then
  idx:=(sizeof(fps_list) div sizeof(fps_list[0])) - 1;
 Result:=fps_list[idx];
end;

function GetNameFPSByIdx(idx:integer):string;
var fps:single;
begin
 fps:=GetFPSByIdx(idx);
 Result:=Format('%2.1f кадров/сек',[fps]);
end;

procedure ReadParms;
var reg:TRegistry;
begin
  g_computer:='';
  g_picture_type:=SCREEN_RLE7B_GRAY;
  g_fps_idx:=4;
  g_start_fs:=false;
  g_spectator:=false;

  reg := TRegistry.Create;
  if reg.OpenKeyReadOnly('Software\RSRD') then
    begin
      try
        g_computer := reg.ReadString('Computer');
      except end;
      try
        g_picture_type := reg.ReadInteger('PictureType');
      except end;
      try
        g_fps_idx := reg.ReadInteger('FPSIndex');
      except end;
      try
        g_start_fs := reg.ReadBool('StartFS');
      except end;
      try
        g_spectator := reg.ReadBool('Spectator');
      except end;
      reg.CloseKey;
    end;
  reg.Free;

  if (g_picture_type<>SCREEN_RLE7B_GRAY) and (g_picture_type<>SCREEN_RLE7B_COLOR) then
     g_picture_type:=SCREEN_RLE7B_GRAY;

  if g_fps_idx<0 then
   g_fps_idx:=0;
  if g_fps_idx>=GetFPSListCount then
   g_fps_idx:=GetFPSListCount-1;
end;


procedure SaveParms;
var reg:TRegistry;
begin
  reg := TRegistry.Create;
  if reg.OpenKey('Software\RSRD',TRUE) then
    begin
      try
        reg.WriteString('Computer',g_computer);
      except end;
      try
        reg.WriteInteger('PictureType',g_picture_type);
      except end;
      try
        reg.WriteInteger('FPSIndex',g_fps_idx);
      except end;
      try
        reg.WriteBool('StartFS',g_start_fs);
      except end;
      try
        reg.WriteBool('Spectator',g_spectator);
      except end;
      reg.CloseKey;
    end;
  reg.Free;
end;


procedure TParmsForm.FormCreate(Sender: TObject);
var n:integer;
begin
 Label1.Color:=RGB(16,100,143);
 EditComputer.Text:=g_computer;
 if g_picture_type=SCREEN_RLE7B_GRAY then
  ComboQuality.ItemIndex:=0
 else
  ComboQuality.ItemIndex:=1;
 for n:=0 to GetFPSListCount-1 do
  ComboFPS.Items.Add(GetNameFPSByIdx(n));
 ComboFPS.ItemIndex:=g_fps_idx;
 CheckBoxFS.Checked:=g_start_fs;
 CheckBoxSpectator.Checked:=g_spectator;
 ButtonConnect.Enabled:=EditComputer.Text<>'';
end;

procedure TParmsForm.FormShow(Sender: TObject);
begin
 EditComputer.SetFocus;
end;

procedure TParmsForm.ButtonConnectClick(Sender: TObject);
begin
 Label2.Enabled:=false;
 Label3.Enabled:=false;
 Label4.Enabled:=false;
 EditComputer.Enabled:=false;
 ComboQuality.Enabled:=false;
 ComboFPS.Enabled:=false;
 CheckBoxFS.Enabled:=false;
 CheckBoxSpectator.Enabled:=false;
 ButtonConnect.Enabled:=false;
 ButtonCancel.Enabled:=false;
 Screen.Cursor:=crHourGlass;
 Update;
 Application.ProcessMessages;

 if not RA_Connect(pchar(EditComputer.Text)) then
   MessageBox(Handle,pchar('Не удалось подключиться к удаленному компьютеру '+EditComputer.Text+#13#10'Убедитесь, что на нем установлена клиентская часть программы'),'Ошибка',MB_OK or MB_ICONERROR)
 else
  begin
   g_computer:=EditComputer.Text;
   if ComboQuality.ItemIndex=0 then
     g_picture_type:=SCREEN_RLE7B_GRAY
   else
     g_picture_type:=SCREEN_RLE7B_COLOR;
   g_fps_idx:=ComboFPS.ItemIndex;
   g_start_fs:=CheckBoxFS.Checked;
   g_spectator:=CheckBoxSpectator.Checked;

   ModalResult:=mrOk;
  end;

 Label2.Enabled:=true;
 Label3.Enabled:=true;
 Label4.Enabled:=true;
 EditComputer.Enabled:=true;
 ComboQuality.Enabled:=true;
 ComboFPS.Enabled:=true;
 CheckBoxFS.Enabled:=true;
 CheckBoxSpectator.Enabled:=true;
 ButtonConnect.Enabled:=true;
 ButtonCancel.Enabled:=true;
 Screen.Cursor:=crDefault;
end;

procedure TParmsForm.EditComputerChange(Sender: TObject);
begin
 ButtonConnect.Enabled:=EditComputer.Text<>'';
end;


end.
