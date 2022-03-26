unit user;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TUserForm = class(TForm)
    EditName: TEdit;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label2: TLabel;
    EditPwd: TEdit;
    Label3: TLabel;
    EditPwd2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure ButtonOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(const name:string);
    destructor Destroy; override;
  end;


function ShowUserFormModal(var name,pwd:string):boolean;


implementation

uses StrUtils, lang;

{$R *.dfm}


function ShowUserFormModal(var name,pwd:string):boolean;
var f:TUserForm;
begin
 Result:=false;
 f:=TUserForm.CreateForm(name);
 if f.ShowModal=mrOk then
  begin
   name:=f.EditName.Text;
   pwd:=f.EditPwd.Text;
   Result:=true;
  end;
 f.Free;
end;


constructor TUserForm.CreateForm(const name:string);
begin
 inherited Create(nil);

 if name='' then
  begin
   EditName.Text:='operator';
   EditName.Enabled:=true;
   Label5.Visible:=true;
   Label4.Visible:=true;
   Caption:=S_ADDNEWUSERTODB;
  end
 else
  begin
   EditName.Text:=name;
   EditName.Enabled:=false;
   Label5.Visible:=false;
   Label4.Visible:=false;
   Caption:=S_CHANGEUSERDBPWD;
  end;
end;

destructor TUserForm.Destroy;
begin

 inherited;
end;

procedure TUserForm.ButtonOKClick(Sender: TObject);
begin
 if EditPwd.Text<>EditPwd2.Text then
  begin
   MessageBox(Handle,S_DIFFERENTPWDS,S_ERR,MB_OK or MB_ICONERROR);
   Exit;
  end;
 if EditName.Enabled then
  begin
   if trim(EditName.Text)='' then
    begin
     MessageBox(Handle,S_EMPTYUSERNAME,S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;
   if AnsiContainsText(EditName.Text,' ') or
      AnsiContainsText(EditName.Text,'''') or
      AnsiContainsText(EditName.Text,'"') or
      (EditName.Text[1] in ['0'..'9']) or
      (AnsiCompareText(EditName.Text,'sa')=0) or
      (AnsiCompareText(EditName.Text,'root')=0) then
    begin
     MessageBox(Handle,S_USERNAME_INVCHARS,S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;
   ModalResult:=mrOk;
  end
 else
  begin
   {if trim(EditPwd.Text)='' then
    begin
     MessageBox(Handle,S_EMPTYUSERPWD,S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;}
   ModalResult:=mrOk;
  end;
end;

procedure TUserForm.FormShow(Sender: TObject);
begin
 if EditName.Enabled then
  EditName.SetFocus
 else
  EditPwd.SetFocus;
end;

end.
