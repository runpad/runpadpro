unit frame3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Buttons, erase;

type
  TPage3 = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    ComboBoxSpeed: TComboBox;
    CheckBoxMultiSession: TCheckBox;
    CheckBoxVerify: TCheckBox;
    EditLabel: TEdit;
    Label3: TLabel;
    ButtonErase: TBitBtn;
    ComboBoxDrives: TComboBox;
    Label4: TLabel;
    procedure ComboBoxDrivesChange(Sender: TObject);
    procedure ButtonEraseClick(Sender: TObject);
  private
    { Private declarations }
    function GetDevNum:integer;
    procedure CreateSpeedsListForDevice(dev_num:integer);
  public
    { Public declarations }
    procedure OnShow(Sender:TObject);
    procedure OnCreate(Sender:TObject);
    procedure CollectDrivesInfo(is_dvd:boolean);
    procedure GetParams(var dev_num:integer;var speed:integer;var title:string;var multi:boolean;var verify:boolean);
  end;

implementation

uses global;

{$R *.dfm}
{$INCLUDE bodyburn.inc}


procedure TPage3.OnCreate(Sender:TObject);
begin
 EditLabel.Text:='Мой диск';
 CheckBoxMultiSession.Checked:=false;
 CheckBoxVerify.Checked:=false;
 ButtonErase.Enabled:=false;
 Label4.Visible:=false;

 if IsNetBurn() then
  begin
   Label1.Visible:=false;
   Label2.Visible:=false;
   ComboBoxDrives.Visible:=false;
   ComboBoxSpeed.Visible:=false;
   ButtonErase.Visible:=false;
   CheckBoxMultiSession.Visible:=false;
   CheckBoxVerify.Visible:=false;

   CheckBoxMultiSession.Checked:=false;
   CheckBoxVerify.Checked:=false;
  end;
end;

procedure TPage3.OnShow(Sender:TObject);
begin
//
end;

procedure TPage3.CreateSpeedsListForDevice(dev_num:integer);
var n,speeds_count:integer;
begin
 ComboBoxSpeed.Items.Clear;
 ComboBoxSpeed.ItemIndex:=-1;
 if dev_num<>-1 then
  begin
   speeds_count:=BurnGetDevSpeedsCount(dev_num);
   for n:=0 to speeds_count-1 do
    ComboBoxSpeed.Items.Add('x'+inttostr(BurnGetDevSpeedAt(dev_num,n)));
   if speeds_count>0 then
    ComboBoxSpeed.ItemIndex:=0;
  end;
end;

procedure TPage3.CollectDrivesInfo(is_dvd:boolean);
var n,dev_count,dev_num:integer;
begin
 ComboBoxDrives.Items.Clear;
 ComboBoxDrives.ItemIndex:=-1;
 dev_num:=-1;
 dev_count:=BurnCreateDevList(is_dvd);
 for n:=0 to dev_count-1 do
   if BurnIsDriveAllowed(n,IsNetBurn(),not IsNetBurn()) then
    begin
     ComboBoxDrives.Items.Add(string(BurnGetDevName(n)));
     if dev_num=-1 then
      dev_num:=n;
    end;
 if dev_num<>-1 then
  ComboBoxDrives.ItemIndex:=0;

 CreateSpeedsListForDevice(dev_num);

 ButtonErase.Enabled:=dev_num<>-1;
 Label4.Visible:=dev_num=-1;
end;

function TPage3.GetDevNum:integer;
var dev_num,n,c:integer;
begin
 dev_num:=-1;
 c:=0;
 n:=0;
 while c<ComboBoxDrives.Items.Count do
  begin
   if BurnIsDriveAllowed(n,IsNetBurn(),not IsNetBurn()) then
    begin
     if c=ComboBoxDrives.ItemIndex then
      begin
       dev_num:=n;
       break;
      end;
     inc(c);
    end;
   inc(n);
  end;

 Result:=dev_num;
end;

procedure TPage3.GetParams(var dev_num:integer;var speed:integer;var title:string;var multi:boolean;var verify:boolean);
begin
 dev_num:=GetDevNum();
 speed:=BurnGetDevSpeedAt(dev_num,ComboBoxSpeed.ItemIndex);
 title:=EditLabel.Text;
 multi:=CheckBoxMultiSession.Checked;
 verify:=CheckBoxVerify.Checked;
end;

procedure TPage3.ComboBoxDrivesChange(Sender: TObject);
begin
 if visible then
   CreateSpeedsListForDevice(GetDevNum());
end;

procedure TPage3.ButtonEraseClick(Sender: TObject);
var dev_num : integer;
    EraseForm : TEraseDiscForm;
begin
 dev_num:=GetDevNum();
 if dev_num<>-1 then
  if MessageBox(Handle,'Выполнить очистку RW-диска?'#13#10'Это может занять несколько минут','Вопрос',MB_YESNO or MB_ICONQUESTION)=IDYES then
   begin
    ComboBoxDrives.Enabled:=false;
    ComboBoxSpeed.Enabled:=false;
    EditLabel.Enabled:=false;
    CheckBoxMultiSession.Enabled:=false;
    CheckBoxVerify.Enabled:=false;
    ButtonErase.Enabled:=false;
    Update;
    Application.ProcessMessages;

    EraseForm:=TEraseDiscForm.Create(nil);
    EraseForm.dev_num:=dev_num;
    EraseForm.ShowModal;
    EraseForm.Free;

    ComboBoxDrives.Enabled:=true;
    ComboBoxSpeed.Enabled:=true;
    EditLabel.Enabled:=true;
    CheckBoxMultiSession.Enabled:=true;
    CheckBoxVerify.Enabled:=true;
    ButtonErase.Enabled:=true;
   end;
end;

end.
