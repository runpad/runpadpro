unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, ActiveX, h_sql;

type
  TDBBackupForm = class(TForm)
    Panel2: TPanel;
    Bevel2: TBevel;
    Panel3: TPanel;
    PageControl: TPageControl;
    TabSheet0: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet3: TTabSheet;
    ButtonForward: TButton;
    ButtonCancel: TButton;
    Label1: TLabel;
    EditAdminLogin: TEdit;
    Label2: TLabel;
    EditAdminPwd: TEdit;
    Label4: TLabel;
    MemoLog: TMemo;
    Label6: TLabel;
    RadioBackup: TRadioButton;
    RadioRestore: TRadioButton;
    RadioPassword: TRadioButton;
    TabSheet1: TTabSheet;
    Label7: TLabel;
    Label3: TLabel;
    EditServer: TEdit;
    Label8: TLabel;
    ComboBoxServerType: TComboBox;
    Label5: TLabel;
    Label9: TLabel;
    ButtonFileSave: TButton;
    TabSheet4: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    ButtonFileOpen: TButton;
    TabSheet6: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label21: TLabel;
    Panel1: TPanel;
    Label22: TLabel;
    Memo1: TMemo;
    Label23: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabSheet0Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonForwardClick(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure ButtonFileSaveClick(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure ButtonFileOpenClick(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure EditServerChange(Sender: TObject);
    procedure ComboBoxServerTypeChange(Sender: TObject);
    procedure EditAdminLoginChange(Sender: TObject);
  private
    { Private declarations }
    procedure AddLog(s:string);
    function PrepareDataBase():boolean;
  public
    { Public declarations }
  end;

var
  DBBackupForm: TDBBackupForm;

implementation

uses Registry, StrUtils;

{$R *.dfm}

// must be changed in DBConf too
const RUNPAD_BASE = 'RunpadPro';
const REGPATH = 'Software\RunpadProAdmin';



procedure TDBBackupForm.FormCreate(Sender: TObject);
var reg:TRegistry;
    s_server:string;
    db_type:integer;
    p:array[0..MAX_PATH] of char;
    nSize:cardinal;
begin
 CoInitialize(nil);

 Caption:=Application.Title;
 PageControl.ActivePageIndex:=0;

 RadioBackup.Checked:=true;

 s_server:='';
 db_type:=SQL_TYPE_UNKNOWN;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly(REGPATH) then
   begin
     try
       s_server := reg.ReadString('sql_server');
     except
       s_server:='';
     end;
     try
       db_type := reg.ReadInteger('sql_type_rp');
     except
       db_type:=SQL_TYPE_UNKNOWN;
     end;
     reg.CloseKey;
   end;
 reg.Free;
 if s_server='' then
  begin
   p[0]:=#0;
   nSize:=sizeof(p);
   GetComputerName(p,nSize);
   s_server:=p;
  end;
 if db_type = SQL_TYPE_UNKNOWN then
  db_type := SQL_TYPE_MSSQL;

 EditServer.Text:=s_server;
 ComboBoxServerType.ItemIndex:=db_type;

 EditAdminLogin.Text:='';
 EditAdminPwd.Text:='';

 Label9.Caption:='';
 Label11.Caption:='';
end;

procedure TDBBackupForm.FormDestroy(Sender: TObject);
begin
 CoUninitialize();
end;

procedure TDBBackupForm.FormShow(Sender: TObject);
begin
//
end;

procedure TDBBackupForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=ButtonCancel.Enabled and ButtonCancel.Visible;
end;

procedure TDBBackupForm.TabSheet0Show(Sender: TObject);
begin
//
end;

procedure TDBBackupForm.TabSheet1Show(Sender: TObject);
begin
 ComboBoxServerTypeChange(Sender);

 if EditServer.Text='' then
  EditServer.SetFocus
 else
 if (ComboBoxServerType.ItemIndex=-1) and (ComboBoxServerType.Enabled) then
  ComboBoxServerType.SetFocus;
end;

procedure TDBBackupForm.TabSheet2Show(Sender: TObject);
begin
 ButtonForward.Enabled:=(EditAdminLogin.Text<>'');

 if EditAdminLogin.Text='' then
  EditAdminLogin.SetFocus
 else
 if EditAdminPwd.Text='' then
  EditAdminPwd.SetFocus;
end;

procedure TDBBackupForm.TabSheet3Show(Sender: TObject);
begin
 ButtonForward.Enabled:=(Label9.Caption<>'');

 if Label9.Caption='' then
   ButtonFileSave.SetFocus;
end;

procedure TDBBackupForm.TabSheet4Show(Sender: TObject);
begin
 ButtonForward.Enabled:=(Label11.Caption<>'');

 if Label11.Caption='' then
   ButtonFileOpen.SetFocus;
end;

procedure TDBBackupForm.TabSheet5Show(Sender: TObject);
begin
//
end;

procedure TDBBackupForm.TabSheet6Show(Sender: TObject);
begin
//
end;

procedure TDBBackupForm.ButtonFileOpenClick(Sender: TObject);
begin
 if OpenDialog.Execute then
  begin
   Label11.Caption:=OpenDialog.FileName;
   ButtonForward.Enabled:=true;
   ButtonForward.SetFocus;
  end;
end;

procedure TDBBackupForm.ButtonFileSaveClick(Sender: TObject);
begin
 if SaveDialog.Execute then
  begin
   Label9.Caption:=SaveDialog.FileName;
   ButtonForward.Enabled:=true;
   ButtonForward.SetFocus;
  end;
end;

procedure TDBBackupForm.EditServerChange(Sender: TObject);
begin
 ComboBoxServerTypeChange(Sender);
end;

procedure TDBBackupForm.ComboBoxServerTypeChange(Sender: TObject);
begin
 if Visible then
  begin
   Panel1.Visible:=ComboBoxServerType.ItemIndex=1;
   ButtonForward.Enabled:=(EditServer.Text<>'') and (ComboBoxServerType.ItemIndex=0);
  end;
end;

procedure TDBBackupForm.EditAdminLoginChange(Sender: TObject);
begin
 if Visible then
  ButtonForward.Enabled:=(EditAdminLogin.Text<>'');
end;

procedure TDBBackupForm.AddLog(s:string);
begin
 MemoLog.Lines.Add(s);
 Application.ProcessMessages;
end;

procedure TDBBackupForm.ButtonCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TDBBackupForm.ButtonForwardClick(Sender: TObject);
var idx:integer;
    reg:TRegistry;
begin
 idx:=PageControl.ActivePageIndex;
 case idx of
 0: begin
     if RadioBackup.Checked or RadioRestore.Checked then
      begin
       if RadioBackup.Checked then
        Caption:='Сохранение базы данных Runpad Pro'
       else
        Caption:='Восстановление базы данных Runpad Pro';
       idx:=1;
      end
     else
      begin
       Caption:='Восстановление пароля администратора БД';
       idx:=6;
      end;
    end;
 1: begin
     if RadioBackup.Checked then
      idx:=3
     else
      idx:=2;
    end;
 2: begin
     idx:=4;
    end;
 3: begin
     idx:=5;
    end;
 4: begin
     idx:=5;
    end;
 5: begin
     if PrepareDataBase() then
      begin
       reg:=TRegistry.Create;
       if reg.OpenKey(REGPATH,true) then
         begin
           try
             reg.WriteString('sql_server',EditServer.Text);
           except end;
           try
             reg.WriteInteger('sql_type_rp',ComboBoxServerType.ItemIndex);
           except end;
           reg.CloseKey;
         end;
       reg.Free;

       ButtonForward.Visible:=false;
      end;
    end;
 6: begin
     Caption:=Application.Title;
     idx:=0;
    end;
 end;{case}

 if ButtonForward.Enabled and ButtonForward.Visible then
  ButtonForward.SetFocus
 else
 if ButtonCancel.Enabled and ButtonCancel.Visible then
  ButtonCancel.SetFocus;
 if idx<>PageControl.ActivePageIndex then
  PageControl.ActivePageIndex:=idx;
end;

function TDBBackupForm.PrepareDataBase:boolean;
var q,s_server,s_login,s_pwd,s_file : string;
    db_type:integer;
    lib:TSQLLib;
    rc,use_backup_login:boolean;
begin
 Result:=false;

 s_server:=EditServer.Text;
 db_type:=ComboBoxServerType.ItemIndex;

 if RadioBackup.Checked then
  begin
   s_login:='';
   s_pwd:='';
   s_file:=Label9.Caption;
   use_backup_login:=true;
  end
 else
  begin
   s_login:=EditAdminLogin.Text;
   s_pwd:=EditAdminPwd.Text;
   s_file:=Label11.Caption;
   use_backup_login:=false;
  end;

 Screen.Cursor:=crHourGlass;
 ButtonCancel.Enabled:=false;
 ButtonForward.Enabled:=false;
 Update;

 lib:=TSQLLib.Create(db_type);

 AddLog('Подключение к серверу...');

 if use_backup_login then
  rc:=lib.ConnectAsBackupOperator(s_server)
 else
  rc:=lib.Connect(s_server,s_login,s_pwd,'');

 if rc then
  begin
   AddLog('Выполнение...');

   if use_backup_login then
    begin
     Windows.DeleteFile(pchar(s_file));
     q:='BACKUP DATABASE '+RUNPAD_BASE+' TO DISK='''+lib.EscapeString(s_file)+'''';
     Result:=lib.Exec(q,300);
     if not Result then
       AddLog('Error: '+lib.GetLastError);
    end
   else
    begin
     q:='RESTORE DATABASE '+RUNPAD_BASE+' FROM DISK='''+lib.EscapeString(s_file)+''' WITH REPLACE';
     Result:=lib.Exec(q,300);
     if not Result then
      begin
       AddLog('Error: '+lib.GetLastError);
       AddLog('Убедитесь, что пользователь имеет права администратора БД и файл выбран верно');
       AddLog('Также необходимо временно удалить сервер Runpad и отключить другие подключения к базе Runpad перед выполнением операции!');
      end
     else
      begin
       if lib.Exec('USE '+RUNPAD_BASE) then
        begin
         lib.Exec('EXEC sp_changedbowner ''sa''');
        end;
      end;
    end;

   AddLog('Отключение от сервера...');
   lib.Disconnect();

   if Result then
    begin
     AddLog('');
     AddLog('Завершено успешно!');
     AddLog('Нажмите "Выход" для завершения');
     if RadioRestore.Checked then
      begin
       //AddLog('');
       AddLog('Внимание!!! Не забудьте запустить утилиту конфигурации базы Runpad, а потом заново создать пользователей в программе глобальных настроек Runpad!!!');
      end;
    end;
  end
 else
   AddLog('Error: '+lib.GetLastError);

 lib.Free;

 ButtonCancel.Enabled:=true;
 ButtonForward.Enabled:=true;
 Screen.Cursor:=crDefault;
end;

end.
