unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, ActiveX, h_sql;

type
  TDBConfForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Panel3: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    LabelTitle: TLabel;
    ButtonForward: TButton;
    ButtonBack: TButton;
    ButtonCancel: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    EditAdminLogin: TEdit;
    Label2: TLabel;
    EditAdminPwd: TEdit;
    Label3: TLabel;
    EditServer: TEdit;
    Label4: TLabel;
    Memo2: TMemo;
    Label5: TLabel;
    Label8: TLabel;
    ComboBoxServerType: TComboBox;
    TabSheet5: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    ButtonOpenFolder: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabSheet1Show(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonForwardClick(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonOpenFolderClick(Sender: TObject);
    procedure TabSheet5Show(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateTitle;
    procedure AddLog(s:string);
    function PrepareDataBase():boolean;
    function SQLWorkWithBase(lib:TSQLLib):boolean;
    function LoadUpdates(lib:TSQLLib;const s_table,s_proc,s_localpath:string):boolean;
    function RecurseAddUpdateFile(lib:TSQLLib;const stored_proc,search_path,base_path,env:string):boolean;
    function AddSingleFile2UpdateTable(lib:TSQLLib;const stored_proc,full_path,shell_path:string):boolean;
  public
    { Public declarations }
  end;

var
  DBConfForm: TDBConfForm;

implementation

uses Registry, StrUtils, ShellApi;

{$R *.dfm}

{$I ..\..\client\z\z_dll.inc}

// must be changed in DBBackup too
const REGPATH = 'Software\RunpadProAdmin';



procedure TDBConfForm.FormCreate(Sender: TObject);
var reg:TRegistry;
    s_server:string;
    db_type:integer;
    p:array[0..MAX_PATH] of char;
    nSize:cardinal;
begin
 CoInitialize(nil);

 Caption:=Application.Title;
 LabelTitle.Color:=RGB(16,100,143);
 PageControl.ActivePageIndex:=0;
 ButtonBack.Visible:=false;

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

 Label9.Caption:=IncludeTrailingPathdelimiter(ExtractFilePath(GetModuleName(0)))+'update\client\rs_folder\default\';
end;

procedure TDBConfForm.FormDestroy(Sender: TObject);
begin
 CoUninitialize();
end;

procedure TDBConfForm.FormShow(Sender: TObject);
begin
 UpdateTitle;
 SetForegroundWindow(Handle);
end;

procedure TDBConfForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=ButtonForward.Visible and ButtonForward.Enabled;
 if CanClose and ButtonCancel.Visible then
  begin
   if MessageBox(Handle,pchar('Необходимо выполнить подготовку базы после установки/обновления администраторской части!'#13#10#13#10'Отменить выполнение?'),'Предупреждение',MB_YESNO or MB_DEFBUTTON2 or MB_ICONWARNING)<>IDYES then
    CanClose:=false;
  end;
end;

procedure TDBConfForm.UpdateTitle;
var idx:integer;
begin
 idx:=PageControl.ActivePageIndex;
 LabelTitle.Caption:=PageControl.Pages[idx].Caption;
end;

procedure TDBConfForm.TabSheet1Show(Sender: TObject);
begin
//
end;

procedure TDBConfForm.TabSheet2Show(Sender: TObject);
begin
 if EditServer.Text='' then
  EditServer.SetFocus
 else
 if (ComboBoxServerType.ItemIndex=-1) and (ComboBoxServerType.Enabled) then
  ComboBoxServerType.SetFocus
 else
 if EditAdminLogin.Text='' then
  EditAdminLogin.SetFocus
 else
  EditAdminPwd.SetFocus;
end;

procedure TDBConfForm.TabSheet3Show(Sender: TObject);
begin
 ButtonForward.SetFocus;
end;

procedure TDBConfForm.TabSheet4Show(Sender: TObject);
begin
 ButtonForward.SetFocus;
end;

procedure TDBConfForm.TabSheet5Show(Sender: TObject);
begin
 ButtonForward.SetFocus;
end;

procedure TDBConfForm.ButtonCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TDBConfForm.ButtonForwardClick(Sender: TObject);
var idx:integer;
    rc:boolean;
    reg:TRegistry;
begin
 idx:=PageControl.ActivePageIndex;
 if idx=0 then //page1
  begin
   PageControl.ActivePageIndex:=idx+1;
   UpdateTitle;
   ButtonBack.Visible:=true;
  end
 else
 if idx=1 then //page2
  begin
   if (trim(EditServer.Text)='') or (trim(EditAdminLogin.Text)='') then
    MessageBox(handle,'Вы должны ввести машину сервера, а также логин/пароль уже существующего администратора БД сервера','Информация',MB_OK or MB_ICONINFORMATION)
   else
    begin
     PageControl.ActivePageIndex:=idx+1;
     UpdateTitle;
    end;
  end
 else
 if idx=2 then //page3
  begin
   PageControl.ActivePageIndex:=idx+1;
   UpdateTitle;
  end
 else
 if idx=3 then //page4
  begin
   if ButtonBack.Visible then
    begin
     ButtonCancel.Visible:=false;
     ButtonBack.Visible:=false;
     ButtonForward.Visible:=false;
     Update;
     Screen.Cursor:=crHourGlass;
     Application.ProcessMessages;
     rc:=PrepareDataBase;
     Screen.Cursor:=crDefault;
     if rc then
      begin
       ButtonForward.Visible:=true;
      end
     else
      begin
       ButtonCancel.Visible:=true;
       ButtonBack.Visible:=true;
       ButtonForward.Visible:=true;
      end;
    end
   else
    begin
     PageControl.ActivePageIndex:=idx+1;
     UpdateTitle;
     ButtonForward.Caption:='Закончить';
    end;
  end
 else
 if idx=4 then //page5
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

   Close;
  end;
end;

procedure TDBConfForm.ButtonBackClick(Sender: TObject);
var idx:integer;
begin
 idx:=PageControl.ActivePageIndex;
 if idx=0 then //page1
  begin
  end
 else
 if idx=1 then //page2
  begin
   PageControl.ActivePageIndex:=idx-1;
   UpdateTitle;
   ButtonBack.Visible:=false;
  end
 else
 if idx=2 then //page3
  begin
   PageControl.ActivePageIndex:=idx-1;
   UpdateTitle;
  end
 else
 if idx=3 then //page4
  begin
   PageControl.ActivePageIndex:=idx-1;
   UpdateTitle;
  end
 else
 if idx=4 then //page5
  begin
  end;
end;

procedure TDBConfForm.AddLog(s:string);
begin
 Memo2.Lines.Add(s);
 Application.ProcessMessages;
end;

function TDBConfForm.PrepareDataBase:boolean;
var s_server,s_login,s_pwd : string;
    db_type:integer;
    lib:TSQLLib;
begin
 Result:=false;

 s_server:=trim(EditServer.Text);
 s_login:=trim(EditAdminLogin.Text);
 s_pwd:=trim(EditAdminPwd.Text);
 db_type:=ComboBoxServerType.ItemIndex;

 lib:=TSQLLib.Create(db_type);

 AddLog('Подключение к серверу...');
 if lib.Connect(s_server,s_login,s_pwd,'') then
  begin
   Result:=SQLWorkWithBase(lib);

   lib.Disconnect();

   if Result then
    begin
     AddLog('');
     AddLog('Завершено успешно!');
     AddLog('Нажмите "Далее" для продолжения');
    end;
  end
 else
   AddLog('Error: '+lib.GetLastError);

 lib.Free;
end;

function TDBConfForm.SQLWorkWithBase(lib:TSQLLib):boolean;
begin
 Result:=false;

 AddLog('Создание структуры базы данных...');
 if not lib.PrepareDB() then
  begin
   AddLog('Error: '+lib.GetLastError);
   Exit;
  end;

 if not LoadUpdates(lib,'TClientUpdate','PClientUpdateAdd','update\client\') then
  Exit;

 if not LoadUpdates(lib,'TClientUpdateNoShell','PClientUpdateNoShellAdd','update\client_no_shell\') then
  Exit;

 Result:=true;
end;

function TDBConfForm.AddSingleFile2UpdateTable(lib:TSQLLib;const stored_proc,full_path,shell_path:string):boolean;
var h:integer;
    fsize,zsize:cardinal;
    fbuff,zbuff:pointer;
    argv:array[0..2] of TSTOREDPROCPARAM;
    t1:array [0..MAX_PATH] of char;
    t2:array [0..MAX_PATH] of char;
begin
 Result:=false;

 AddLog('Загрузка в базу файла обновления "'+ExtractFileName(full_path)+'"...');

 h:=FileOpen(full_path,fmOpenRead or fmShareDenyWrite);
 if h<>-1 then
  begin
   fsize:=FileSeek(h,0,2);

   if fsize>0 then  //todo: support empty files here!!!
    begin
     FileSeek(h,0,0);
     fbuff:=HeapAlloc(GetProcessHeap(),0,fsize);

     if fbuff<>nil then
      begin
       if cardinal(FileRead(h,fbuff^,fsize))=fsize then
        begin
         zsize:=0;
         zbuff:=Z_Compress(fbuff,fsize,@zsize);
         if zbuff<>nil then
          begin
           argv[0].Direction:=SQL_PD_INPUT;
           argv[0].DataType:=SQL_DT_STRING;
           StrCopy(t1,pchar(shell_path));
           argv[0].Value:=@t1;
           argv[0].BlobSize:=0;

           argv[1].Direction:=SQL_PD_INPUT;
           argv[1].DataType:=SQL_DT_STRING;
           StrCopy(t2,pchar(Format('%.8x',[Z_CRC32(fbuff,fsize)])));
           argv[1].Value:=@t2;
           argv[1].BlobSize:=0;

           argv[2].Direction:=SQL_PD_INPUT;
           argv[2].DataType:=SQL_DT_BLOB;
           argv[2].Value:=zbuff;
           argv[2].BlobSize:=zsize;

           if lib.CallStoredProc(stored_proc,30,@argv,length(argv)) then
             Result:=true
           else
             AddLog('Error: '+lib.GetLastError);

           Z_Free(zbuff);
          end;
        end;

       HeapFree(GetProcessHeap(),0,fbuff);
      end
     else
      AddLog('Error: Ошибка выделения памяти');
    end
   else
    AddLog('Error: Файлы нулевой длины не поддерживаются!');

   FileClose(h);
  end;
end;

function TDBConfForm.RecurseAddUpdateFile(lib:TSQLLib;const stored_proc,search_path,base_path,env:string):boolean;
var f:_WIN32_FIND_DATAA;
    h:cardinal;
    rc:boolean;
    s_local,s_full,shell_path:string;
begin
 Result:=true;

 h:=FindFirstFile(pchar(IncludeTrailingPathDelimiter(search_path)+'*.*'),f);
 rc:=h<>INVALID_HANDLE_VALUE;
 while rc do
  begin
   s_local:=string(f.cFileName);
   if (s_local<>'.') and (s_local<>'..') then
    begin
     if (f.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0 then
      begin
       if not RecurseAddUpdateFile(lib,stored_proc,IncludeTrailingPathDelimiter(search_path)+s_local,base_path,env) then
        begin
         Result:=false;
         break;
        end;
      end
     else
      begin
       s_full:=IncludeTrailingPathDelimiter(search_path)+s_local;
       shell_path:=Copy(s_full,length(base_path)+1,length(s_full)-length(base_path));
       if AnsiStartsText('\',shell_path) then
        shell_path:=Copy(shell_path,2,length(shell_path)-1);
       shell_path:=env+'\'+shell_path;
       if not AddSingleFile2UpdateTable(lib,stored_proc,s_full,shell_path) then
        begin
         Result:=false;
         break;
        end;
      end;
    end;
   rc:=FindNextFile(h,f);
  end;
 if h<>INVALID_HANDLE_VALUE then
  Windows.FindClose(h);
end;

function TDBConfForm.LoadUpdates(lib:TSQLLib;const s_table,s_proc,s_localpath:string):boolean;
var f:_WIN32_FIND_DATAA;
    h:cardinal;
    err,rc:boolean;
    s_path,s_local:string;
begin
 err:=true;

 lib.Exec('SET TRANSACTION ISOLATION LEVEL SERIALIZABLE');

 if lib.BeginTransaction() then
  begin
   err:=false;

   if not lib.Exec('DELETE FROM '+s_table) then
    begin
     AddLog('Error: '+lib.GetLastError);
     err:=true;
    end
   else
    begin
     s_path:=IncludeTrailingPathDelimiter(ExtractFilePath(GetModuleName(0)))+s_localpath;
     h:=FindFirstFile(pchar(s_path+'*.*'),f);
     rc:=h<>INVALID_HANDLE_VALUE;
     while rc do
      begin
       if (f.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0 then
        begin
         s_local:=string(f.cFileName);
         if (s_local<>'.') and (s_local<>'..') then
          begin
           if not RecurseAddUpdateFile(lib,s_proc,s_path+s_local,s_path+s_local,'%'+s_local+'%') then
            begin
             err:=true;
             break;
            end;
          end;
        end;
       rc:=FindNextFile(h,f);
      end;
     if h<>INVALID_HANDLE_VALUE then
      Windows.FindClose(h);
    end;

   if not err then
    begin
     err:=not lib.CommitTransaction(300);
     if err then
      AddLog('Error: '+lib.GetLastError);
    end;

   if err then
     lib.RollbackTransaction(300);
  end
 else
  AddLog('Error: '+lib.GetLastError);

 //lib.Exec('SET TRANSACTION ISOLATION LEVEL READ COMMITTED'); //restore default!

 Result:=not err;
end;

procedure TDBConfForm.ButtonOpenFolderClick(Sender: TObject);
begin
 FormStyle:=fsNormal;
 ShellExecute(0,nil,pchar(Label9.Caption),nil,pchar(Label9.Caption),SW_SHOWNORMAL);
end;


end.
