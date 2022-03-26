unit AutoLogon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TAutoLogonForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label2: TLabel;
    EditLogin: TEdit;
    EditDomain: TEdit;
    EditPwd: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CheckBoxForce: TCheckBox;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(force:boolean);
    destructor Destroy; override;
  end;


function ShowAutoLogonFormModal(var out_domain,out_login,out_pwd:string;var inout_force:boolean):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowAutoLogonFormModal(var out_domain,out_login,out_pwd:string;var inout_force:boolean):boolean;
var f:TAutoLogonForm;
begin
 Result:=false;
 f:=TAutoLogonForm.CreateForm(inout_force);
 if f.ShowModal=mrOk then
  begin
   out_domain:=f.EditDomain.Text;
   out_login:=f.EditLogin.Text;
   out_pwd:=f.EditPwd.Text;
   inout_force:=f.CheckBoxForce.Checked;
   Result:=true;
  end;
 f.Free;
end;

constructor TAutoLogonForm.CreateForm(force:boolean);
var i:TIcon;
begin
 inherited Create(nil);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(234),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 EditDomain.Text:='';
 EditLogin.Text:='';
 EditPwd.Text:='';
 CheckBoxForce.Checked:=force;
end;

destructor TAutoLogonForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TAutoLogonForm.FormShow(Sender: TObject);
begin
 EditLogin.SetFocus;
end;

procedure TAutoLogonForm.ButtonOKClick(Sender: TObject);
begin
 if (trim(EditLogin.Text)='') then
  begin
   MessageBox(Handle,S_EMPTYLOGINPWD,S_ERR,MB_OK or MB_ICONERROR);
   EditLogin.SetFocus;
  end
 else
 if (trim(EditPwd.Text)='') then
  begin
   MessageBox(Handle,S_EMPTYLOGINPWD,S_ERR,MB_OK or MB_ICONERROR);
   EditPwd.SetFocus;
  end
 else
  begin
   ModalResult:=mrOk;
  end;
end;

end.
