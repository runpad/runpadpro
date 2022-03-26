unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, XPMan;

type
  TBodyMouseForm = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    GroupBox1: TGroupBox;
    TrackBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    ButtonFixOn: TButton;
    ButtonFixOff: TButton;
    Image1: TImage;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonFixOnClick(Sender: TObject);
    procedure ButtonFixOffClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
    old_values : array [0..2] of integer;
    old_speed : integer;
    restore_old : boolean;
    function SetMouseCurve(x:pointer;x_size:integer;y:pointer;y_size:integer):boolean;
    procedure UpdateMouseParms;
  public
    { Public declarations }
  end;


var
   BodyMouseForm : TBodyMouseForm;


implementation

uses Registry, ShellApi;

{$R *.dfm}
{$I ..\rp_shared\rp_shared.inc}


procedure TBodyMouseForm.FormCreate(Sender: TObject);
var t:integer;
    i:TIcon;
begin
 Caption:=LS(1200);
 Application.Title:=Caption;
 GroupBox1.Caption:=' '+LS(1201)+' ';
 Label1.Caption:=LS(1202);
 Label2.Caption:=LS(1203);
 RadioGroup1.Caption:=' '+LS(1204)+' ';
 RadioGroup1.Items[0]:=LS(1205);
 RadioGroup1.Items[1]:=LS(1206);
 RadioGroup1.Items[2]:=LS(1207);
 RadioGroup1.Items[3]:=LS(1208);
 ButtonFixOn.Caption:=LS(1209);
 ButtonFixOff.Caption:=LS(1210);
 ButtonOK.Caption:=LS(LS_OK);
 ButtonCancel.Caption:=LS(LS_CANCEL);

 i:=TIcon.Create();
 i.Handle:=DuplicateIcon(0,LoadImage(hinstance,'MAINICON',IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 SystemParametersInfo(SPI_GETMOUSE,0,@old_values,0);
 SystemParametersInfo(SPI_GETMOUSESPEED,0,@old_speed,0);

 t:=old_speed;
 if t < 1 then
  t:=1;
 if t > 20 then
  t:=20;
 TrackBar.Position:=(t*10) div 19;

 t:=old_values[2];
 if t < 0 then
  t:=0;
 if t > 3 then
  t:=3;
 RadioGroup1.ItemIndex:=t;

 restore_old:=true;
end;

procedure TBodyMouseForm.FormDestroy(Sender: TObject);
begin
 if restore_old then
  begin
   SystemParametersInfo(SPI_SETMOUSE,0,@old_values,SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
   SystemParametersInfo(SPI_SETMOUSESPEED,0,pointer(old_speed),SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
  end;

 Image1.Picture.Assign(nil);
end;

procedure TBodyMouseForm.FormShow(Sender: TObject);
begin
 ButtonOK.SetFocus;
end;

procedure TBodyMouseForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
  ButtonOKClick(Sender);
 if key=VK_ESCAPE then
  ButtonCancelClick(Sender);
end;

procedure TBodyMouseForm.UpdateMouseParms;
var sens : integer;
    values : array[0..2] of integer;
begin
 sens:=((TrackBar.Position*19) div 10) + 1;
 SystemParametersInfo(SPI_SETMOUSESPEED,0,pointer(sens),SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
 values[0]:=old_values[0];
 values[1]:=old_values[1];
 values[2]:=RadioGroup1.ItemIndex;
 SystemParametersInfo(SPI_SETMOUSE,0,@values,SPIF_UPDATEINIFILE or SPIF_SENDCHANGE);
end;

procedure TBodyMouseForm.TrackBarChange(Sender: TObject);
begin
 UpdateMouseParms;
end;

procedure TBodyMouseForm.RadioGroup1Click(Sender: TObject);
begin
 UpdateMouseParms;
end;

procedure TBodyMouseForm.ButtonCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TBodyMouseForm.ButtonOKClick(Sender: TObject);
begin
 restore_old:=false;
 Close;
end;

function TBodyMouseForm.SetMouseCurve(x:pointer;x_size:integer;y:pointer;y_size:integer):boolean;
var reg:TRegistry;
begin
 Result:=false;
 reg:=TRegistry.Create;
 reg.LazyWrite:=false;
 if reg.OpenKey('Control Panel\Mouse',true) then
  begin
   try
    reg.WriteBinaryData('SmoothMouseXCurve',x^,x_size);
    reg.WriteBinaryData('SmoothMouseYCurve',y^,y_size);
    Result:=true;
   except
   end;
   reg.CloseKey;
  end;
 reg.Free;
 UpdateMouseParms;
end;

procedure TBodyMouseForm.ButtonFixOnClick(Sender: TObject);
const x : array [0..39] of byte = ($00,$00,$00,$00,$00,$00,$00,$00,$00,$a0,$00,$00,$00,$00,$00,$00,$00,$40,$01,$00,$00,$00,$00,$00,$00,$80,$02,$00,$00,$00,$00,$00,$00,$00,$05,$00,$00,$00,$00,$00);
const y : array [0..39] of byte = ($00,$00,$00,$00,$00,$00,$00,$00,$66,$a6,$02,$00,$00,$00,$00,$00,$cd,$4c,$05,$00,$00,$00,$00,$00,$a0,$99,$0a,$00,$00,$00,$00,$00,$38,$33,$15,$00,$00,$00,$00,$00);
begin
 if SetMouseCurve(@x,sizeof(x),@y,sizeof(y)) then
  MessageBox(Handle,LSP(1211),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
end;

procedure TBodyMouseForm.ButtonFixOffClick(Sender: TObject);
const x : array [0..39] of byte = ($00,$00,$00,$00,$00,$00,$00,$00,$15,$6e,$00,$00,$00,$00,$00,$00,$00,$40,$01,$00,$00,$00,$00,$00,$29,$dc,$03,$00,$00,$00,$00,$00,$00,$00,$28,$00,$00,$00,$00,$00);
const y : array [0..39] of byte = ($00,$00,$00,$00,$00,$00,$00,$00,$b8,$5e,$01,$00,$00,$00,$00,$00,$cd,$4c,$05,$00,$00,$00,$00,$00,$cd,$4c,$18,$00,$00,$00,$00,$00,$00,$00,$38,$02,$00,$00,$00,$00);
begin
 if SetMouseCurve(@x,sizeof(x),@y,sizeof(y)) then
  MessageBox(Handle,LSP(1211),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
end;

end.
