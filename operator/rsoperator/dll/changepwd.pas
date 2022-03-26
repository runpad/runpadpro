unit changepwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TChangePwdForm = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label1: TLabel;
    EditOldPwd: TEdit;
    Label2: TLabel;
    EditNewPwd: TEdit;
    Label3: TLabel;
    EditNewPwd2: TEdit;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function ShowChangePwdFormModal(var old_pwd,new_pwd:string):boolean;


implementation

uses lang;

{$R *.dfm}

function ShowChangePwdFormModal(var old_pwd,new_pwd:string):boolean;
var f:TChangePwdForm;
begin
 Result:=false;
 f:=TChangePwdForm.Create(nil);
 if f.ShowModal=mrOk then
  begin
   old_pwd:=f.EditOldPwd.Text;
   new_pwd:=f.EditNewPwd.Text;
   Result:=true;
  end;
 f.Free;
end;

procedure TChangePwdForm.FormCreate(Sender: TObject);
var i:TIcon;
begin
 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(203),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;
end;

procedure TChangePwdForm.FormDestroy(Sender: TObject);
begin
 Image1.Picture.Assign(nil);
end;

procedure TChangePwdForm.FormShow(Sender: TObject);
begin
 EditOldPwd.Text:='';
 EditNewPwd.Text:='';
 EditNewPwd2.Text:='';
 EditOldPwd.SetFocus;
end;

procedure TChangePwdForm.ButtonOKClick(Sender: TObject);
begin
 if EditNewPwd.Text<>EditNewPwd2.Text then
  begin
   MessageBox(Handle,S_DIFFPWDS,S_ERR,MB_OK or MB_ICONERROR);
   EditNewPwd.SetFocus;
  end
 else
  ModalResult:=mrOk;
end;

end.
