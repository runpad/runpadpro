unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TLoginForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    EditServer: TEdit;
    ComboBoxServerType: TComboBox;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    EditLogin: TEdit;
    EditPwd: TEdit;
    CheckBoxSavePwd: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure EditServerChange(Sender: TObject);
    procedure EditLoginChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm();
    destructor Destroy; override;
    function GetServerType:integer;
    function GetServer:string;
    function GetLogin:string;
    function GetPwd:string;
    procedure WriteConfig;
  end;



implementation

uses tools, h_sql, lang;

{$R *.dfm}


constructor TLoginForm.CreateForm();
var s_server:string;
    server_type,size : integer;
begin
 inherited Create(nil);

 s_server:=ReadConfigStr(TRUE,'','sql_server','');
 EditServer.Text:=s_server;

 server_type:=ReadConfigInt(TRUE,'','sql_type_rp',SQL_TYPE_UNKNOWN);
 if (server_type<0) or (server_type>ComboBoxServerType.Items.Count-1) then
  server_type:=-1;
 ComboBoxServerType.ItemIndex:=server_type;

 EditLogin.Text:=ReadConfigStr(FALSE,'','last_login_name','');
 CheckBoxSavePwd.Checked:=ReadConfigInt(FALSE,'','save_pwd',0)<>0;
 if CheckBoxSavePwd.Checked then
  EditPwd.Text:=SimplePasswordDecrypt(ReadConfigStr(FALSE,'','pwd',''))
 else
  EditPwd.Text:='';

 EditServer.Enabled:=false;
 ComboBoxServerType.Enabled:=false;
 size:=Panel3.Height;
 Panel3.Visible:=false;
 Height:=Height-size;
end;

destructor TLoginForm.Destroy;
begin

 inherited;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
 if not CheckBoxSavePwd.Checked then
  EditPwd.Text:='';
 EditServerChange(Sender);
 if EditLogin.Text='' then
  EditLogin.SetFocus
 else
 if EditPwd.Text='' then
  EditPwd.SetFocus
 else
  ButtonOK.SetFocus;

 if (EditServer.Text='') or (ComboBoxServerType.ItemIndex=-1) then
  MessageBox(Handle,S_NOSERVERSPECIFIED,S_ERR,MB_OK or MB_ICONERROR);
end;

procedure TLoginForm.ButtonOKClick(Sender: TObject);
begin
 Label1.Enabled:=false;
 Label2.Enabled:=false;
// Label3.Enabled:=false;
// Label4.Enabled:=false;
// EditServer.Enabled:=false;
 EditLogin.Enabled:=false;
 EditPwd.Enabled:=false;
// ComboBoxServerType.Enabled:=false;
 ButtonOK.Enabled:=false;
 ButtonCancel.Enabled:=false;
 WaitCursor(true,false);
 Update;

 Sleep(300);

 WaitCursor(false,false);
 Label1.Enabled:=true;
 Label2.Enabled:=true;
// Label3.Enabled:=true;
// Label4.Enabled:=true;
// EditServer.Enabled:=true;
 EditLogin.Enabled:=true;
 EditPwd.Enabled:=true;
// ComboBoxServerType.Enabled:=true;
 ButtonOK.Enabled:=true;
 ButtonCancel.Enabled:=true;

 ModalResult:=mrOK;
end;

procedure TLoginForm.EditServerChange(Sender: TObject);
begin
 ButtonOK.Enabled:=(trim(EditServer.Text)<>'') and (trim(EditLogin.Text)<>'');
end;

procedure TLoginForm.EditLoginChange(Sender: TObject);
begin
 EditServerChange(Sender);
end;

function TLoginForm.GetServerType:integer;
begin
 Result:=ComboBoxServerType.ItemIndex;
end;

function TLoginForm.GetServer:string;
begin
 Result:=trim(EditServer.Text);
end;

function TLoginForm.GetLogin:string;
begin
 Result:=trim(EditLogin.Text);
end;

function TLoginForm.GetPwd:string;
begin
 Result:=trim(EditPwd.Text);
end;

procedure TLoginForm.WriteConfig;
begin
 //WriteConfigStr('','sql_server',EditServer.Text);
 //WriteConfigInt('','sql_type_rp',ComboBoxServerType.ItemIndex);
 WriteConfigStr(FALSE,'','last_login_name',EditLogin.Text);
 if CheckBoxSavePwd.Checked then
  begin
   WriteConfigInt(FALSE,'','save_pwd',1);
   WriteConfigStr(FALSE,'','pwd',SimplePasswordEncrypt(EditPwd.Text));
  end
 else
  begin
   WriteConfigInt(FALSE,'','save_pwd',0);
   WriteConfigStr(FALSE,'','pwd','');
  end;
end;

end.
