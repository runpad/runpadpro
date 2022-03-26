unit ClientUninstall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TClientUninstallForm = class(TForm)
    Image1: TImage;
    ButtonCancel: TButton;
    Memo1: TMemo;
    ButtonUninstall: TButton;
    CheckBoxForce: TCheckBox;
    RadioButtonImm: TRadioButton;
    RadioButtonPostpond: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonUninstallClick(Sender: TObject);
    procedure RadioButtonPostpondClick(Sender: TObject);
    procedure RadioButtonImmClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(is_imm,is_force:boolean);
    destructor Destroy; override;
  end;


function ShowClientUninstallFormModal(var out_imm,out_force:boolean):boolean;


implementation

uses tools,lang;

{$R *.dfm}

const s_info_text:string =
'Внимание! Удаленно удалить можно только ту клиентскую часть, которая не содержит в своем составе шелла!'+#13#10+
'В противном случае удаление необходимо выполнять непосредственно на клиентской машине (см. документацию)';



function ShowClientUninstallFormModal(var out_imm,out_force:boolean):boolean;
var f:TClientUninstallForm;
begin
 Result:=false;
 f:=TClientUninstallForm.CreateForm(true,false);
 if f.ShowModal=mrOk then
  begin
   out_imm:=f.RadioButtonImm.Checked;
   out_force:=f.CheckBoxForce.Checked;
   Result:=true;
  end;
 f.Free;
end;

constructor TClientUninstallForm.CreateForm(is_imm,is_force:boolean);
var i:TIcon;
begin
 inherited Create(nil);

 Memo1.Text:=s_info_text;

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(243),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 if is_imm then
  RadioButtonImm.Checked:=true
 else
  RadioButtonPostpond.Checked:=true;
 CheckBoxForce.Checked:=is_force;
end;

destructor TClientUninstallForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TClientUninstallForm.FormShow(Sender: TObject);
begin
 ButtonUninstall.SetFocus;
end;

procedure TClientUninstallForm.RadioButtonPostpondClick(Sender: TObject);
begin
 if RadioButtonPostpond.Checked then
  begin
   CheckBoxForce.Enabled:=false;
  end;
end;

procedure TClientUninstallForm.RadioButtonImmClick(Sender: TObject);
begin
 if RadioButtonImm.Checked then
  begin
   CheckBoxForce.Enabled:=true;
  end;
end;

procedure TClientUninstallForm.ButtonUninstallClick(Sender: TObject);
begin
 ModalResult:=mrOk;
end;

end.
