unit TurnShell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TTurnShellForm = class(TForm)
    Image1: TImage;
    ButtonCancel: TButton;
    Label2: TLabel;
    EditLogin: TEdit;
    EditDomain: TEdit;
    EditPwd: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RadioButtonAll: TRadioButton;
    RadioButtonUser: TRadioButton;
    Memo1: TMemo;
    ButtonOnOff: TButton;
    procedure FormShow(Sender: TObject);
    procedure RadioButtonAllClick(Sender: TObject);
    procedure RadioButtonUserClick(Sender: TObject);
    procedure ButtonOnOffClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(is_turnon:boolean);
    destructor Destroy; override;
  end;


function ShowTurnShellFormModal(is_turnon:boolean;var out_allusers:boolean;var out_domain,out_login,out_pwd:string):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowTurnShellFormModal(is_turnon:boolean;var out_allusers:boolean;var out_domain,out_login,out_pwd:string):boolean;
var f:TTurnShellForm;
begin
 Result:=false;
 f:=TTurnShellForm.CreateForm(is_turnon);
 if f.ShowModal=mrOk then
  begin
   out_allusers:=f.RadioButtonAll.Checked;
   out_domain:=f.EditDomain.Text;
   out_login:=f.EditLogin.Text;
   out_pwd:=f.EditPwd.Text;
   Result:=true;
  end;
 f.Free;
end;

constructor TTurnShellForm.CreateForm(is_turnon:boolean);
var i:TIcon;
begin
 inherited Create(nil);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(235),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 if is_turnon then
  begin
   Caption:=S_TURNSHELLON;
   ButtonOnOff.Caption:=S_TURNSHELLON_BTN;
  end
 else
  begin
   Caption:=S_TURNSHELLOFF;
   ButtonOnOff.Caption:=S_TURNSHELLOFF_BTN;
 end;

 EditDomain.Text:='';
 EditLogin.Text:='';
 EditPwd.Text:='';

 RadioButtonUser.Checked:=true;
end;

destructor TTurnShellForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TTurnShellForm.FormShow(Sender: TObject);
begin
 if EditLogin.Enabled then
  EditLogin.SetFocus
 else
  ButtonOnOff.SetFocus;
end;

procedure TTurnShellForm.RadioButtonAllClick(Sender: TObject);
begin
 if RadioButtonAll.Checked then
  begin
   Label2.Enabled:=false;
   Label3.Enabled:=false;
   Label4.Enabled:=false;
   EditDomain.Enabled:=false;
   EditDomain.Text:='';
   EditLogin.Enabled:=false;
   EditLogin.Text:='';
   EditPwd.Enabled:=false;
   EditPwd.Text:='';
  end;
end;

procedure TTurnShellForm.RadioButtonUserClick(Sender: TObject);
begin
 if RadioButtonUser.Checked then
  begin
   Label2.Enabled:=true;
   Label3.Enabled:=true;
   Label4.Enabled:=true;
   EditDomain.Enabled:=true;
   EditLogin.Enabled:=true;
   EditPwd.Enabled:=true;
   if Visible and EditLogin.Enabled then
    EditLogin.SetFocus;
  end;
end;

procedure TTurnShellForm.ButtonOnOffClick(Sender: TObject);
begin
 if RadioButtonUser.Checked then
  begin
   if (trim(EditLogin.Text)='') or (trim(EditPwd.Text)='') then
    begin
     MessageBox(Handle,S_EMPTYLOGINPWD,S_ERR,MB_OK or MB_ICONERROR);
     if (trim(EditLogin.Text)='') then
      EditLogin.SetFocus
     else
      EditPwd.SetFocus;
     Exit;
    end;
  end;

 ModalResult:=mrOk;
end;

end.
