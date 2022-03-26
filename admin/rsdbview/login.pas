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
    inplicity : boolean;
  public
    { Public declarations }
    constructor CreateForm(); overload;
    constructor CreateForm(server:string;server_type:integer;login,pwd:string); overload;
    destructor Destroy; override;
    function GetServerType:integer;
    function GetServer:string;
    function GetLogin:string;
    function GetPwd:string;
    procedure WriteConfig;
    procedure DefaultHandler(var Message); override;
  end;



implementation

uses tools;

{$R *.dfm}

var msg_ok : cardinal = WM_NULL;


procedure TLoginForm.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    if msg=msg_ok then
      begin
       if ButtonOK.Enabled then
        ButtonOKClick(nil);
      end
    else
      inherited;
end;

constructor TLoginForm.CreateForm();
var s_server:string;
    p:array[0..MAX_PATH] of char;
    nSize:cardinal;
    server_type : integer;
    use_lm:boolean;
    allow_empty:boolean;
begin
 inherited Create(nil);

 inplicity:=false;
 use_lm:=IsOperator;
 allow_empty:=IsOperator;

 s_server:=ReadConfigStr(use_lm,'','sql_server','');
 if (s_server='') and (not allow_empty) then
  begin
   p[0]:=#0;
   nSize:=sizeof(p);
   GetComputerName(p,nSize);
   s_server:=p;
  end;
 EditServer.Text:=s_server;

 server_type:=ReadConfigInt(use_lm,'','sql_type_rp',0);
 if (server_type<0) or (server_type>ComboBoxServerType.Items.Count-1) then
  server_type:=0;
 ComboBoxServerType.ItemIndex:=server_type;

 EditLogin.Text:=ReadConfigStr(false,'','last_login_name','');
 EditPwd.Text:='';
end;

constructor TLoginForm.CreateForm(server:string;server_type:integer;login,pwd:string);
begin
 inherited Create(nil);

 inplicity:=true;

 EditServer.Text:=server;
 if (server_type<0) or (server_type>ComboBoxServerType.Items.Count-1) then
  server_type:=0;
 ComboBoxServerType.ItemIndex:=server_type;
 EditLogin.Text:=login;
 EditPwd.Text:=pwd;
end;

destructor TLoginForm.Destroy;
begin

 inherited;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
 Label3.Enabled:=not IsOperator;
 Label4.Enabled:=not IsOperator;
 EditServer.Enabled:=not IsOperator;
 ComboBoxServerType.Enabled:=not IsOperator;

 if not inplicity then
  EditPwd.Text:='';

 EditServerChange(Sender);

 if (EditServer.Text='') and EditServer.Enabled then
  EditServer.SetFocus
 else
 if (EditLogin.Text='') and EditLogin.Enabled then
  EditLogin.SetFocus
 else
 if (EditPwd.Text='') and EditPwd.Enabled then
  EditPwd.SetFocus
 else
 if ButtonOK.Enabled then
  ButtonOK.SetFocus
 else
  ButtonCancel.SetFocus;

 if inplicity then
  begin
   inplicity:=false;
   if ButtonOK.Enabled then
    PostMessage(Handle,msg_ok,0,0);
  end;
end;

procedure TLoginForm.ButtonOKClick(Sender: TObject);
var
 Label1_Enabled,
 Label2_Enabled,
 Label3_Enabled,
 Label4_Enabled,
 EditServer_Enabled,
 EditLogin_Enabled,
 EditPwd_Enabled,
 ComboBoxServerType_Enabled,
 ButtonOK_Enabled,
 ButtonCancel_Enabled : boolean;
begin
 Label1_Enabled:=             Label1.Enabled;
 Label2_Enabled:=             Label2.Enabled;
 Label3_Enabled:=             Label3.Enabled;
 Label4_Enabled:=             Label4.Enabled;
 EditServer_Enabled:=         EditServer.Enabled;
 EditLogin_Enabled:=          EditLogin.Enabled;
 EditPwd_Enabled:=            EditPwd.Enabled;
 ComboBoxServerType_Enabled:= ComboBoxServerType.Enabled;
 ButtonOK_Enabled:=           ButtonOK.Enabled;
 ButtonCancel_Enabled:=       ButtonCancel.Enabled;

 Label1.Enabled:=             false;
 Label2.Enabled:=             false;
 Label3.Enabled:=             false;
 Label4.Enabled:=             false;
 EditServer.Enabled:=         false;
 EditLogin.Enabled:=          false;
 EditPwd.Enabled:=            false;
 ComboBoxServerType.Enabled:= false;
 ButtonOK.Enabled:=           false;
 ButtonCancel.Enabled:=       false;

 WaitCursor(true,false);
 Update;

 Sleep(300);

 WaitCursor(false,false);

 Label1.Enabled:=             Label1_Enabled;
 Label2.Enabled:=             Label2_Enabled;
 Label3.Enabled:=             Label3_Enabled;
 Label4.Enabled:=             Label4_Enabled;
 EditServer.Enabled:=         EditServer_Enabled;
 EditLogin.Enabled:=          EditLogin_Enabled;
 EditPwd.Enabled:=            EditPwd_Enabled;
 ComboBoxServerType.Enabled:= ComboBoxServerType_Enabled;
 ButtonOK.Enabled:=           ButtonOK_Enabled;
 ButtonCancel.Enabled:=       ButtonCancel_Enabled;

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
 if not IsOperator then
  begin
   WriteConfigStr(false,'','sql_server',EditServer.Text);
   WriteConfigInt(false,'','sql_type_rp',ComboBoxServerType.ItemIndex);
  end;
 WriteConfigStr(false,'','last_login_name',EditLogin.Text);
end;


begin
 msg_ok:=RegisterWindowMessage('_RSTLoginForm_MsgOK');
end.
