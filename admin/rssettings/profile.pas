unit profile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TProfileForm = class(TForm)
    EditName: TEdit;
    Label1: TLabel;
    ComboBoxProfiles: TComboBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    CheckBoxUseBase: TCheckBox;
    Label2: TLabel;
    ComboBoxMachineType: TComboBox;
    Label3: TLabel;
    ComboBoxLang: TComboBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBoxUseBaseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(const profiles:array of string);
    destructor Destroy; override;
  end;


function ShowAddProfileFormModal(const profiles:array of string;var name,base:string;var machine_type,lang:integer):boolean;


implementation

uses lang, global;

{$R *.dfm}


function FromIdx2MachineType(idx:integer):integer;
begin
 Result:=MACHINE_TYPE_GAMECLUB;
 case idx of
  0: Result:=MACHINE_TYPE_GAMECLUB;
  1: Result:=MACHINE_TYPE_INETCAFE;
  2: Result:=MACHINE_TYPE_OPERATOR;
  3: Result:=MACHINE_TYPE_ORGANIZATION;
  4: Result:=MACHINE_TYPE_TERMINAL;
  5: Result:=MACHINE_TYPE_HOME;
  6: Result:=MACHINE_TYPE_OTHER;
 end;
end;

function ShowAddProfileFormModal(const profiles:array of string;var name,base:string;var machine_type,lang:integer):boolean;
var f:TProfileForm;
begin
 Result:=false;
 f:=TProfileForm.CreateForm(profiles);
 if f.ShowModal=mrOk then
  begin
   name:=f.EditName.Text;
   if f.ComboBoxProfiles.ItemIndex=-1 then
    base:=''
   else
    base:=f.ComboBoxProfiles.Items[f.ComboBoxProfiles.ItemIndex];
   machine_type:=FromIdx2MachineType(f.ComboBoxMachineType.ItemIndex);
   lang:=f.ComboBoxLang.ItemIndex;
   Result:=true;
  end;
 f.Free;
end;


constructor TProfileForm.CreateForm(const profiles:array of string);
var n:integer;
begin
 inherited Create(nil);

 EditName.Text:='Profile1';
 CheckBoxUseBase.Checked:=false;
 ComboBoxProfiles.Enabled:=false;
 for n:=0 to high(profiles) do
  ComboBoxProfiles.Items.Add(profiles[n]);
 ComboBoxProfiles.ItemIndex:=-1;
 ComboBoxMachineType.ItemIndex:=0;
 ComboBoxLang.ItemIndex:=0;
end;

destructor TProfileForm.Destroy;
begin

 inherited;
end;

procedure TProfileForm.ButtonOKClick(Sender: TObject);
var n,idx:integer;
begin
 if trim(EditName.Text)='' then
  MessageBox(Handle,S_EMPTYPROFILENAME,S_ERR,MB_OK or MB_ICONERROR)
 else
  begin
   idx:=-1;
   for n:=0 to ComboBoxProfiles.Items.Count-1 do
    if AnsiCompareText(ComboBoxProfiles.Items[n],EditName.Text)=0 then
     begin
      idx:=n;
      break;
     end;

   if idx<>-1 then
    MessageBox(Handle,S_PROFILEEXISTS,S_ERR,MB_OK or MB_ICONERROR)
   else
    ModalResult:=mrOk;
  end;
end;

procedure TProfileForm.FormShow(Sender: TObject);
begin
 EditName.SetFocus;
end;

procedure TProfileForm.CheckBoxUseBaseClick(Sender: TObject);
begin
 if CheckBoxUseBase.Checked then
  begin
   ComboBoxProfiles.Enabled:=true;
  end
 else
  begin
   ComboBoxProfiles.ItemIndex:=-1;
   ComboBoxProfiles.Enabled:=false;
  end;
end;

end.
