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
    Label3: TLabel;
    EditServer: TEdit;
    Label1: TLabel;
    EditLogin: TEdit;
    Label2: TLabel;
    EditPwd: TEdit;
    Label4: TLabel;
    ComboBoxServerType: TComboBox;
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

uses tools;

{$R *.dfm}


constructor TLoginForm.CreateForm();
var s_server:string;
    p:array[0..MAX_PATH] of char;
    nSize:cardinal;
    server_type : integer;
begin
 inherited Create(nil);

 s_server:=ReadConfigStr('','sql_server','');
 if s_server='' then
  begin
   p[0]:=#0;
   nSize:=sizeof(p);
   GetComputerName(p,nSize);
   s_server:=p;
  end;
 EditServer.Text:=s_server;

 server_type:=ReadConfigInt('','sql_type_rp',0);
 if (server_type<0) or (server_type>ComboBoxServerType.Items.Count-1) then
  server_type:=0;
 ComboBoxServerType.ItemIndex:=server_type;

 EditLogin.Text:=ReadConfigStr('','last_login_name','');
end;

destructor TLoginForm.Destroy;
begin

 inherited;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
 EditPwd.Text:='';
 EditServerChange(Sender);
 if EditServer.Text='' then
  EditServer.SetFocus
 else
 if EditLogin.Text='' then
  EditLogin.SetFocus
 else
 if EditPwd.Text='' then
  EditPwd.SetFocus
 else
  ButtonOK.SetFocus;
end;

procedure TLoginForm.ButtonOKClick(Sender: TObject);
begin
 Label1.Enabled:=false;
 Label2.Enabled:=false;
 Label3.Enabled:=false;
 Label4.Enabled:=false;
 EditServer.Enabled:=false;
 EditLogin.Enabled:=false;
 EditPwd.Enabled:=false;
 ComboBoxServerType.Enabled:=false;
 ButtonOK.Enabled:=false;
 ButtonCancel.Enabled:=false;
 WaitCursor(true,false);
 Update;

 Sleep(300);

 WaitCursor(false,false);
 Label1.Enabled:=true;
 Label2.Enabled:=true;
 Label3.Enabled:=true;
 Label4.Enabled:=true;
 EditServer.Enabled:=true;
 EditLogin.Enabled:=true;
 EditPwd.Enabled:=true;
 ComboBoxServerType.Enabled:=true;
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
 WriteConfigStr('','sql_server',EditServer.Text);
 WriteConfigInt('','sql_type_rp',ComboBoxServerType.ItemIndex);
 WriteConfigStr('','last_login_name',EditLogin.Text);
end;

end.
