unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ImgList, StdCtrls, Grids, ActiveX,
  login, h_sql;


type TCOLINFO = record
      defwidth:integer;
      title:string;
      expr_ms:string;
      expr_my:string;
     end;
     PCOLINFO = ^TCOLINFO;


type
  TDBViewForm = class(TForm)
    Panel1: TPanel;
    ImageTop: TImage;
    ImageBottom: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ButtonConnect: TToolButton;
    ButtonDisconnect: TToolButton;
    Bevel2: TBevel;
    Panel3: TPanel;
    ImageList1: TImageList;
    Panel4: TPanel;
    Bevel3: TBevel;
    TabControl: TTabControl;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    PanelTools: TPanel;
    ButtonHTML: TButton;
    ButtonDelOldRecords: TButton;
    PanelPrices: TPanel;
    LabelSum: TLabel;
    EditSum: TEdit;
    ButtonPrices: TButton;
    Panel11: TPanel;
    CoolBarServices: TCoolBar;
    ToolBarServices: TToolBar;
    PanelViewParms: TPanel;
    LabelTime1: TLabel;
    DateTimePicker1: TDateTimePicker;
    LabelMachine1: TLabel;
    PanelViewParmsEx: TPanel;
    LabelVIP: TLabel;
    EditVIP: TEdit;
    PanelRefresh: TPanel;
    ButtonRefresh: TButton;
    ImageCenter: TImage;
    PanelEvents: TPanel;
    CheckBoxEventsImp: TCheckBox;
    ImageList2: TImageList;
    Panel8: TPanel;
    PanelUserResponse: TPanel;
    Panel10: TPanel;
    StringGrid: TStringGrid;
    MemoUserResponse: TMemo;
    EditMachine1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ToolButtonServiceClick(Sender: TObject);
    procedure ToolButtonAllServicesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure StringGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StringGridClick(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure EditVIPKeyPress(Sender: TObject; var Key: Char);
    procedure ButtonDelOldRecordsClick(Sender: TObject);
    procedure ButtonPricesClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure ButtonHTMLClick(Sender: TObject);
    procedure CheckBoxEventsImpClick(Sender: TObject);
    procedure StringGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditMachine1KeyPress(Sender: TObject; var Key: Char);
  private
    sql : TSQLLib;
    LoginForm : TLoginForm;
    msg_login : cardinal;
    msg_foreground : cardinal;
    { Private declarations }
    procedure UpdateView(conn:boolean);
    function TryConnect(server:string;server_type:integer;login,pwd:string):boolean;
    procedure UpdateStatusString(s:string);
    procedure UpdateSum;
    procedure UpdateUserResponseText;
    procedure SelectAllInGrid();
    function DeleteRecordsFromTable(table,field:string;t:TDateTime):boolean;
    procedure WriteStringCRLF(h:integer;s:string);
    function ConvertString2HTML(s:string):string;
    procedure SQLFillQuery(page:integer;query:TStrings;time:TDateTime;machine_desc:string);
    function GetColWidthByNum(page,idx:integer):integer;
    function GetFieldStrValueByNum(page,idx:integer;i:PEXECSQLCBSTRUCT):string;
    procedure GetTableNameAndTimeFieldName(page:integer;var s_table,s_field:string);
    procedure WriteAllColWidths();
    procedure ShowErrorAndConfirmExecDBConf(const err:string);
    function SelectColExpr(const i:PCOLINFO):string;
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    function DBTableCBProc(i:PEXECSQLCBSTRUCT):boolean;
  end;

var
  DBViewForm: TDBViewForm;

implementation

uses CommCtrl, ShellApi, prices, tools, tip, global, lang, VistaAltFixUnit;

{$R *.dfm}


type
     TSERVICE = record
      id:integer;
      title:string;
      dbname:string;
     end;

const NUMSERVICES = 12;

const services : array [1..NUMSERVICES] of TSERVICE =
(
 (id:4;  title:'Записанные DVD';       dbname:'записан DVD'),
 (id:5;  title:'Записанные CD';        dbname:'записан CD'),
 (id:3;  title:'Созданные ISO';        dbname:'создан ISO-образ'),
 (id:2;  title:'Сканирование';         dbname:'сканирование'),
 (id:6;  title:'Bluetooth-передача';   dbname:'bluetooth-передача'),
 (id:7;  title:'Bluetooth-прием';      dbname:'bluetooth-прием'),
 (id:11; title:'Мобильный контент';    dbname:'мобильный контент'),
 (id:9;  title:'Работа с принтером';   dbname:'печать'),
 (id:1;  title:'Работа с Flash';       dbname:'работа с flash'),
 (id:8;  title:'Отправленные e-mail';  dbname:'отправлен e-mail'),
 (id:10; title:'DVD-фильмы';           dbname:'DVD-фильм'),
 (id:12; title:'Работа с фотокамерой'; dbname:'загружены фото')
);


const PRICE_CELL_IDX = 9; //idx in col_services[]
const PRICE_CELL_IDX_SUMM = 5; //idx in col_services_summ[]

var col_services : array [0..10] of TCOLINFO =
(
  (defwidth:85;  title:'Время';       expr_ms:'TServices.time';                                        expr_my:''),
  (defwidth:100; title:'Услуга';      expr_ms:'TPrices.name';                                          expr_my:''),
  (defwidth:100; title:'Зал/Машина';  expr_ms:'TServices.comp_loc+''/''+TServices.comp_desc';          expr_my:'CONCAT(TServices.comp_loc,''/'',TServices.comp_desc)'),
  (defwidth:100; title:'Имя (IP)';    expr_ms:'TServices.comp_name+'' (''+TServices.comp_ip+'')''';    expr_my:'CONCAT(TServices.comp_name,'' ('',TServices.comp_ip,'')'')'),
  (defwidth:100; title:'Domain/User'; expr_ms:'TServices.user_domain+''/''+TServices.user_name';       expr_my:'CONCAT(TServices.user_domain,''/'',TServices.user_name)'),
  (defwidth:70;  title:'VIP';         expr_ms:'TServices.vip_name';                                    expr_my:''),
  (defwidth:50;  title:'ед.';         expr_ms:'TServices.data_count';                                  expr_my:''),
  (defwidth:50;  title:'КБ';          expr_ms:'TServices.data_size';                                   expr_my:''),
  (defwidth:50;  title:'сек.';        expr_ms:'TServices.data_time';                                   expr_my:''),
  (defwidth:60;  title:'Цена';        expr_ms:'TServices.cost';                                        expr_my:''),
  (defwidth:400; title:'Описание';    expr_ms:'TServices.comments';                                    expr_my:'')
);

var col_services_summ : array [0..5] of TCOLINFO =
(
  (defwidth:170; title:'Период';      expr_ms:'1';                           expr_my:''),
  (defwidth:100; title:'Услуга';      expr_ms:'TPrices.name';                expr_my:''),
  (defwidth:50;  title:'ед.';         expr_ms:'SUM(TServices.data_count)';   expr_my:''),
  (defwidth:50;  title:'КБ';          expr_ms:'SUM(TServices.data_size)';    expr_my:''),
  (defwidth:50;  title:'сек.';        expr_ms:'SUM(TServices.data_time)';    expr_my:''),
  (defwidth:60;  title:'Цена';        expr_ms:'SUM(TServices.cost)';         expr_my:'')
);

var col_events : array [0..6] of TCOLINFO =
(
  (defwidth:85;  title:'Время';       expr_ms:'time';                            expr_my:''),
  (defwidth:55;  title:'Важность';    expr_ms:'level';                           expr_my:''),
  (defwidth:100; title:'Зал/Машина';  expr_ms:'comp_loc+''/''+comp_desc';        expr_my:'CONCAT(comp_loc,''/'',comp_desc)'),
  (defwidth:100; title:'Имя (IP)';    expr_ms:'comp_name+'' (''+comp_ip+'')''';  expr_my:'CONCAT(comp_name,'' ('',comp_ip,'')'')'),
  (defwidth:100; title:'Domain/User'; expr_ms:'user_domain+''/''+user_name';     expr_my:'CONCAT(user_domain,''/'',user_name)'),
  (defwidth:70;  title:'VIP';         expr_ms:'vip_name';                        expr_my:''),
  (defwidth:400; title:'Описание';    expr_ms:'comments';                        expr_my:'')
);


const USERRESPONSE_CELL_IDX = 5; // idx in col_responses[]

var col_responses : array [0..5] of TCOLINFO =
(
  (defwidth:85;  title:'Дата';       expr_ms:'time';        expr_my:''),
  (defwidth:85;  title:'Тип';        expr_ms:'msg_kind';    expr_my:''),
  (defwidth:75;  title:'Имя';        expr_ms:'user_name';   expr_my:''),
  (defwidth:50;  title:'Возраст';    expr_ms:'user_age';    expr_my:''),
  (defwidth:400; title:'Заголовок';  expr_ms:'msg_title';   expr_my:''),
  (defwidth:600; title:'Текст';      expr_ms:'msg_text';    expr_my:'')
);


function TDBViewForm.SelectColExpr(const i:PCOLINFO):string;
var base:string;
begin
 base:=i.expr_ms;
 if base='' then
  base:=i.expr_my;

 if sql.IsMSSQLSyntax then
  Result:=i.expr_ms
 else
  Result:=i.expr_my;

 if Result='' then
  Result:=base;
end;

procedure TDBViewForm.SQLFillQuery(page:integer;query:TStrings;time:TDateTime;machine_desc:string);
var c,n:integer;
    s:string;
begin
 query.Clear();

 if page=0 then
  begin  //services
   query.Add('SELECT');
   c:=sizeof(col_services) div sizeof(col_services[0]);
   for n:=0 to c-1 do
    begin
     query.Add(SelectColExpr(@col_services[n])+' AS '''+sql.EscapeString(col_services[n].title)+'''');
     if n<>c-1 then
      query.Add(',');
    end;
   query.Add('FROM TServices, TPrices');
   query.Add('WHERE TServices.id=TPrices.id');
   s:='';
   for n:=1 to NUMSERVICES do
    if ToolBarServices.Buttons[n].Down then
     s:=s+inttostr(services[n].id)+',';
   if length(s)>0 then
     setlength(s,length(s)-1)
   else
     s:='-1';
   query.Add('AND TServices.id IN ('+s+')');
   query.Add('AND TServices.time>='''+FormatDateTime('yyyy-mm-dd',time)+'''');
   if machine_desc<>'' then
    query.Add('AND TServices.comp_desc='''+sql.EscapeString(machine_desc)+'''');
   if EditVIP.Text<>'' then
    query.Add('AND TServices.vip_name='''+sql.EscapeString(EditVIP.Text)+'''');
   query.Add('ORDER BY TServices.time DESC');
  end
 else
 if page=1 then
  begin  //services_summ
   query.Add('SELECT');
   c:=sizeof(col_services_summ) div sizeof(col_services_summ[0]);
   for n:=0 to c-1 do
    begin
     query.Add(SelectColExpr(@col_services_summ[n])+' AS '''+sql.EscapeString(col_services_summ[n].title)+'''');
     if n<>c-1 then
      query.Add(',');
    end;
   query.Add('FROM TServices, TPrices');
   query.Add('WHERE TServices.id=TPrices.id');
   s:='';
   for n:=1 to NUMSERVICES do
     s:=s+inttostr(services[n].id)+',';
   if length(s)>0 then
     setlength(s,length(s)-1)
   else
     s:='-1';
   query.Add('AND TServices.id IN ('+s+')');
   query.Add('AND TServices.time>='''+FormatDateTime('yyyy-mm-dd',time)+'''');
   if machine_desc<>'' then
    query.Add('AND TServices.comp_desc='''+sql.EscapeString(machine_desc)+'''');
   query.Add('GROUP BY TPrices.name');
  end
 else
 if page=2 then
  begin  //events
   query.Add('SELECT');
   c:=sizeof(col_events) div sizeof(col_events[0]);
   for n:=0 to c-1 do
    begin
     query.Add(SelectColExpr(@col_events[n])+' AS '''+sql.EscapeString(col_events[n].title)+'''');
     if n<>c-1 then
      query.Add(',');
    end;
   query.Add('FROM TEvents');
   query.Add('WHERE time>='''+FormatDateTime('yyyy-mm-dd',time)+'''');
   if machine_desc<>'' then
    query.Add('AND comp_desc='''+sql.EscapeString(machine_desc)+'''');
   if CheckBoxEventsImp.Checked then
    query.Add('AND level>0');
   query.Add('ORDER BY time DESC');
  end
 else
 if page=3 then
  begin  //responses
   query.Add('SELECT');
   c:=sizeof(col_responses) div sizeof(col_responses[0]);
   for n:=0 to c-1 do
    begin
     query.Add(SelectColExpr(@col_responses[n])+' AS '''+sql.EscapeString(col_responses[n].title)+'''');
     if n<>c-1 then
      query.Add(',');
    end;
   query.Add('FROM TUserResponses');
   query.Add('WHERE time>='''+FormatDateTime('yyyy-mm-dd',time)+'''');
   query.Add('ORDER BY time DESC');
  end;
end;

function TDBViewForm.GetColWidthByNum(page,idx:integer):integer;
var count:integer;
    p:array of TCOLINFO;
begin
 Result:=0;
 if page=0 then
  begin  //services
   p:=@col_services;
   count:=length(col_services);
  end
 else
 if page=1 then
  begin  //services_summ
   p:=@col_services_summ;
   count:=length(col_services_summ);
  end
 else
 if page=2 then
  begin  //events
   p:=@col_events;
   count:=length(col_events);
  end
 else
 if page=3 then
  begin  //responses
   p:=@col_responses;
   count:=length(col_responses);
  end
 else
  exit;
 if idx>=count then
  exit;
 Result:=ReadConfigInt(false,OURAPPNAME+'\Page'+inttostr(page),'colwidth'+inttostr(idx),p[idx].defwidth);
end;

procedure TDBViewForm.WriteAllColWidths();
var n:integer;
begin
 if TabControl.Visible and StringGrid.Visible then
  for n:=0 to StringGrid.ColCount-1 do
   WriteConfigInt(false,OURAPPNAME+'\Page'+inttostr(TabControl.TabIndex),'colwidth'+inttostr(n),StringGrid.ColWidths[n]);
end;

function GetFieldValueAsDelphiString(i:PEXECSQLCBSTRUCT;f:pointer):string;
var p:pchar;
begin
 Result:='';
 p:=i.GetFieldValueAsString(i.obj,f);
 if p<>nil then
  begin
   Result:=p;
   i.FreePointer(p);
  end;
end;

function TDBViewForm.GetFieldStrValueByNum(page,idx:integer;i:PEXECSQLCBSTRUCT):string;
var f:pointer;
begin
 Result:='';

 f:=i.GetFieldByIdx(i.obj,idx);
 if f=nil then
  exit;

 if page=0 then
  begin  //services
   case idx of
   0:  Result:=FormatDateTime('dd/mm/yy hh:nn',i.GetFieldValueAsDateTime(i.obj,f));
   1:  Result:=GetFieldValueAsDelphiString(i,f);
   2:  Result:=GetFieldValueAsDelphiString(i,f);
   3:  Result:=GetFieldValueAsDelphiString(i,f);
   4:  Result:=GetFieldValueAsDelphiString(i,f);
   5:  Result:=GetFieldValueAsDelphiString(i,f);
   6:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   7:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   8:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   9:  Result:=Format('%1.2f',[i.GetFieldValueAsDouble(i.obj,f)]);
   10: Result:=GetFieldValueAsDelphiString(i,f);
   end;
  end
 else
 if page=1 then
  begin  //services_summ
   case idx of
   0:  Result:=FormatDateTime('dd/mm/yy',DateTimePicker1.DateTime)+' - '+FormatDateTime('dd/mm/yy',now()); //todo: pass now() and DateTimePicker1.DateTime thru parameters to this function
   1:  Result:=GetFieldValueAsDelphiString(i,f);
   2:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   3:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   4:  Result:=inttostr(i.GetFieldValueAsInt(i.obj,f));
   5:  Result:=Format('%1.2f',[i.GetFieldValueAsDouble(i.obj,f)]);
   end;
  end
 else
 if page=2 then
  begin  //events
   case idx of
   0:  Result:=FormatDateTime('dd/mm/yy hh:nn',i.GetFieldValueAsDateTime(i.obj,f));
   1:  if i.GetFieldValueAsInt(i.obj,f)>0 then Result:=S_IMP else Result:='';
   2:  Result:=GetFieldValueAsDelphiString(i,f);
   3:  Result:=GetFieldValueAsDelphiString(i,f);
   4:  Result:=GetFieldValueAsDelphiString(i,f);
   5:  Result:=GetFieldValueAsDelphiString(i,f);
   6:  Result:=GetFieldValueAsDelphiString(i,f);
   end;
  end
 else
 if page=3 then
  begin  //responses
   case idx of
   0:  Result:=FormatDateTime('dd/mm/yy',i.GetFieldValueAsDateTime(i.obj,f));
   1:  Result:=GetFieldValueAsDelphiString(i,f);
   2:  Result:=GetFieldValueAsDelphiString(i,f);
   3:  Result:=GetFieldValueAsDelphiString(i,f);
   4:  Result:=GetFieldValueAsDelphiString(i,f);
   5:  Result:=GetFieldValueAsDelphiString(i,f);
   end;
  end;
end;

procedure TDBViewForm.GetTableNameAndTimeFieldName(page:integer;var s_table,s_field:string);
begin
 s_table:='';
 s_field:='';
 if page=0 then
  begin  //services
   s_table:='TServices';
   s_field:='time';
  end
 else
 if page=1 then
  begin  //services_summ
   s_table:='TServices';
   s_field:='time';
  end
 else
 if page=2 then
  begin  //events
   s_table:='TEvents';
   s_field:='time';
  end
 else
 if page=3 then
  begin  //responses
   s_table:='TUserResponses';
   s_field:='time';
  end;
end;

procedure TDBViewForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=msg_login then
  begin
   if ButtonConnect.Enabled then
    ButtonConnectClick(nil);
   Handled := True;
  end
 else
 if Msg.message=msg_foreground then
  begin
   Application.Restore;
   Application.BringToFront();
   Handled := True;
  end;
end;

procedure TDBViewForm.FormCreate(Sender: TObject);
var n:integer;
    btn:TToolButton;
    s_server,s_login,s_pwd:string;
    i_server_type:integer;
begin
 CoInitialize(nil);

 if IsOperator then
  REGPATH:=REGPATH_OPERATOR
 else
  REGPATH:=REGPATH_ADMIN;

 sql:=nil;

 if (ParamCount=3) or (ParamCount=4) then
  begin
   s_server:=ParamStr(1);
   i_server_type:=StrToIntDef(ParamStr(2),SQL_TYPE_UNKNOWN);
   s_login:=ParamStr(3);
   if ParamCount=4 then
    s_pwd:=ParamStr(4)
   else
    s_pwd:='';
   LoginForm:=TLoginForm.CreateForm(s_server,i_server_type,s_login,s_pwd);
  end
 else
  LoginForm:=TLoginForm.CreateForm();

 ThousandSeparator:=#0;
 DecimalSeparator:='.';
 DateSeparator:='/';
 TimeSeparator:=':';

 ImageList1.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 2, 1);
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(100)));
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(101)));

 ImageList2.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 4, 1);
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(110)));
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(110))); // also
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(111)));
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(112)));

 DateTimePicker1.DateTime:=now()-14.0; //two weeks

 for n:=NUMSERVICES downto 1 do
  begin
   btn:=TToolButton.Create(ToolBarServices);
   with btn do
    begin
     Style:=tbsCheck;
     Wrap:=true;
     Caption:='  '+services[n].title+'  ';
     Down:=true;
     OnClick:=ToolButtonServiceClick;
     Parent:=ToolBarServices;
    end;
  end;
 btn:=TToolButton.Create(ToolBarServices);
 with btn do
  begin
   Style:=tbsButton;
   Wrap:=true;
   Caption:='  '+S_ALLSERVICES+'  ';
   OnClick:=ToolButtonAllServicesClick;
   Parent:=ToolBarServices;
  end;

 with StringGrid do
  begin
   FixedRows:=0;
   FixedCols:=0;
   ColCount:=0;
   RowCount:=0;
  end;

 Width:=1024;
 Left:=(Screen.Width-Width) div 2;
 Top:=(Screen.Height-Height) div 2;
 Constraints.MinHeight:=Height;
 Constraints.MinWidth:=750;
 WindowState:=wsMaximized;

 UpdateView(false);

 msg_login:=RegisterWindowMessage('_RSDBViewLogin');
 msg_foreground:=RegisterWindowMessage('_RSDBViewSetForeground');
 Application.OnMessage := AppMessage;

 TVistaAltFix.Create(Self);
end;

procedure TDBViewForm.FormDestroy(Sender: TObject);
begin
 Application.OnMessage := nil;
 FreeAndNil(LoginForm);
 FreeAndNil(sql);
 CoUninitialize();
end;

procedure TDBViewForm.FormShow(Sender: TObject);
begin
 PostMessage(Handle,msg_login,0,0);
end;

procedure TDBViewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (not ButtonConnect.Enabled) and (ButtonDisconnect.Enabled) then
  ButtonDisconnectClick(sender);
end;

procedure TDBViewForm.UpdateStatusString(s:string);
begin
 StatusBar.Panels[1].Text:=' '+s;
 Application.ProcessMessages;
end;

procedure TDBViewForm.ButtonConnectClick(Sender: TObject);
var rc:boolean;
begin
 if LoginForm.ShowModal=mrOK then
  begin
   UpdateStatusString(S_CONNECTING);
   Update;
   WaitCursor(true,true);

   rc:=TryConnect(LoginForm.GetServer,LoginForm.GetServerType,LoginForm.GetLogin,LoginForm.GetPwd);

   WaitCursor(false,false);

   if rc then
    begin
     LoginForm.WriteConfig;
     UpdateView(true);
     //TipForm.ShowTip(?);
    end
   else
     UpdateStatusString(S_ERR_IN_CONNECT);
  end;
end;

procedure TDBViewForm.ButtonDisconnectClick(Sender: TObject);
begin
 WaitCursor(true,false);
 UpdateView(false);
 FreeAndNil(sql);
 WaitCursor(false,false);
end;

function TDBViewForm.TryConnect(server:string;server_type:integer;login,pwd:string):boolean;
var n,cnt:integer;
    err:boolean;
    err_str:string;
begin
 Result:=false;

 FreeAndNil(sql);
 sql:=TSQLLib.Create(server_type);

 if sql.ConnectAsNormalUser(server,login,pwd) then
  begin
   //insert new services into pricestable
   err:=false;
   for n:=1 to NUMSERVICES do
    begin
     cnt:=0;
     if not sql.Exec('SELECT * FROM TPrices WHERE id='''+inttostr(services[n].id)+'''',SQL_DEF_TIMEOUT,@cnt) then
      begin
       err:=true;
       break;
      end;
     if cnt<=0 then
      begin
       if not sql.Exec('INSERT INTO TPrices VALUES('+inttostr(services[n].id)+','''+sql.EscapeString(services[n].dbname)+''',0,0,0,0)') then
        begin
         err:=true;
         break;
        end;
      end;
    end;

   if not err then
     Result:=true;
  end;

 if not Result then
  begin
   err_str:=sql.GetLastError;
   FreeAndNil(sql);
   ShowErrorAndConfirmExecDBConf(err_str);
  end;
end;

procedure TDBViewForm.ShowErrorAndConfirmExecDBConf(const err:string);
begin
 MessageBox(Handle,pchar(S_ERR_CONNECT+#13#10+#13#10+err),S_ERR,MB_OK or MB_ICONERROR);
 TipForm.ShowTip(0);
end;

procedure TDBViewForm.UpdateView(conn:boolean);
var n:integer;
begin
 if conn then
  begin
   ButtonConnect.Enabled:=false;
   ButtonDisconnect.Enabled:=true;

   StringGrid.Visible:=false;

   for n:=1 to ToolBarServices.ButtonCount-1 do
    ToolBarServices.Buttons[n].Down:=true;
   EditMachine1.Text:='';
   EditVIP.Text:='';
   CheckBoxEventsImp.Checked:=false;

   Caption:=Application.Title + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')';
   UpdateStatusString(S_CONNECTED + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')');

   TabControl.TabIndex:=0;
   TabControlChange(nil);
   TabControl.Visible:=true;
  end
 else
  begin
   ButtonConnect.Enabled:=true;
   ButtonDisconnect.Enabled:=false;

   TabControl.Visible:=false;

   Caption:=Application.Title;
   UpdateStatusString(S_NOTCONNECTED);
  end;
end;

procedure TDBViewForm.TabControlChange(Sender: TObject);
var page:integer;
begin
 PanelViewParmsEx.Visible:=false;
 CoolBarServices.Visible:=false;
 PanelPrices.Visible:=false;
 PanelEvents.Visible:=false;
 PanelUserResponse.Visible:=false;

 page:=TabControl.TabIndex;
 if page=0 then
  begin  //services
   PanelViewParmsEx.Visible:=true;
   CoolBarServices.Visible:=true;
   PanelPrices.Visible:=true;
  end
 else
 if page=1 then
  begin  //services_summ
   PanelPrices.Visible:=true;
  end
 else
 if page=2 then
  begin  //events
   PanelEvents.Visible:=true;
  end
 else
 if page=3 then
  begin  //responses
   PanelUserResponse.Visible:=true;
  end;

 ButtonRefreshClick(sender);
end;

procedure TDBViewForm.DateTimePicker1Change(Sender: TObject);
begin
 if visible and TabControl.Visible and PanelViewParms.Visible then
  ButtonRefreshClick(Sender);
end;

procedure TDBViewForm.ToolButtonServiceClick(Sender: TObject);
begin
 if visible and TabControl.Visible and CoolBarServices.Visible then
  ButtonRefreshClick(Sender);
end;

procedure TDBViewForm.ToolButtonAllServicesClick(Sender: TObject);
var n:integer;
    do_down:boolean;
begin
 do_down:=false;
 for n:=1 to ToolBarServices.ButtonCount-1 do
  if not ToolBarServices.Buttons[n].Down then
   do_down:=true;

 for n:=1 to ToolBarServices.ButtonCount-1 do
  ToolBarServices.Buttons[n].Down:=do_down;

 ButtonRefreshClick(Sender);
end;

procedure TDBViewForm.EditMachine1KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  ButtonRefreshClick(Sender);
end;

procedure TDBViewForm.EditVIPKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  ButtonRefreshClick(Sender);
end;

procedure TDBViewForm.CheckBoxEventsImpClick(Sender: TObject);
begin
 if visible and TabControl.Visible and PanelEvents.Visible then
   ButtonRefreshClick(sender);
end;

procedure TDBViewForm.SelectAllInGrid();
var r:TGridRect;
begin
 with StringGrid do
  begin
   try
    r.Left:=0;
    r.Top:=1;
    r.Right:=ColCount-1;
    r.Bottom:=RowCount-1;
    Selection:=r;
   except
   end;
  end;
end;

procedure TDBViewForm.StringGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=ord('A')) and (ssCtrl in Shift) then
  begin
   SelectAllInGrid;
   StringGridClick(Sender);
  end;
 if key=VK_F5 then
  begin
   if ButtonRefresh.Visible and ButtonRefresh.Enabled then
    ButtonRefreshClick(Sender);
  end;
end;

procedure TDBViewForm.StringGridClick(Sender: TObject);
begin
 if TabControl.TabIndex=0 then
  begin  //services
   UpdateSum;
  end
 else
 if TabControl.TabIndex=1 then
  begin  //services_summ
   UpdateSum;
  end
 else
 if TabControl.TabIndex=2 then
  begin  //events
  end
 else
 if TabControl.TabIndex=3 then
  begin  //responses
   UpdateUserResponseText;
  end;
end;

procedure TDBViewForm.StringGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if button=mbLeft then
   WriteAllColWidths();
end;

function TDBViewForm.DeleteRecordsFromTable(table,field:string;t:TDateTime):boolean;
var s:string;
begin
 Result:=false;
 s:=S_DELRECORDS_CONFIRM+' '+FormatDateTime('dd/mm/yyyy',t)+' ?';
 if MessageBox(Handle,pchar(s),S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
  begin
   WaitCursor(true,true);

   if not sql.Exec('DELETE FROM '+table+' WHERE '+field+'<'''+FormatDateTime('yyyy-mm-dd',t)+'''',45) then
    MessageBox(Handle,pchar(S_NODEL_PERMISSIONS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR)
   else
    Result:=true;

   WaitCursor(false,false);
  end;
end;

procedure TDBViewForm.ButtonDelOldRecordsClick(Sender: TObject);
var s_table,s_field:string;
begin
 GetTableNameAndTimeFieldName(TabControl.TabIndex,s_table,s_field);
 if DeleteRecordsFromTable(s_table,s_field,DateTimePicker1.DateTime) then
  ButtonRefreshClick(Sender);
end;

function TDBViewForm.DBTableCBProc(i:PEXECSQLCBSTRUCT):boolean;
var n,page:integer;
    t:array[0..MAX_PATH] of char;
begin
 page:=TabControl.TabIndex;

 if i.idx=-1 then
  begin
   with StringGrid do
     begin
      ColCount:=i.GetNumFields(i.obj);
      RowCount:=1+i.numrecords;
      for n:=0 to ColCount-1 do
       begin
        ColWidths[n]:=GetColWidthByNum(page,n);
        t[0]:=#0;
        i.GetFieldDisplayName(i.obj,i.GetFieldByIdx(i.obj,n),t);
        Cells[n,0]:=t;
       end;
     end;
  end
 else
  begin
   for n:=0 to StringGrid.ColCount-1 do
    StringGrid.Cells[n,i.idx+1]:=GetFieldStrValueByNum(page,n,i);
  end;

 Result:=true;
end;

function DBTableCBProcWrapper(parm:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TDBViewForm(parm.user_parm).DBTableCBProc(parm);
end;

procedure TDBViewForm.ButtonRefreshClick(Sender: TObject);
var err:boolean;
    page:integer;
    time:TDateTime;
    machine_desc:string;
    query:TStringList;
begin
 StringGrid.Visible:=false;
 ButtonHTML.Enabled:=false;
 ButtonDelOldRecords.Enabled:=false;
 StringGridClick(sender);
 Update;
 WaitCursor(true,true);

 page:=TabControl.TabIndex;
 machine_desc:=EditMachine1.Text;
 time:=DateTimePicker1.DateTime;

 query:=TStringList.Create;
 SQLFillQuery(page,query,time,machine_desc);

 if not sql.Exec(query.Text,20,nil,DBTableCBProcWrapper,self,true) then
  begin
   ShowErrorAndConfirmExecDBConf(sql.GetLastError);
   err:=true;
  end
 else
  begin
   err:=false;
   with StringGrid do
    if RowCount=1 then
     begin
      RowCount:=2;
      FixedRows:=1;
      Rows[1].Clear;
     end
    else
    if RowCount>1 then
     begin
      FixedRows:=1;
     end
    else
     err:=true;
  end;

 FreeAndNil(query);
 WaitCursor(false,false);

 if not err then
  begin
   StringGrid.TopRow:=1;//StringGrid.RowCount-1;
   StringGrid.LeftCol:=0;
   SelectAllInGrid();
   StringGrid.Visible:=true;
   if TabControl.Visible then
    StringGrid.SetFocus;
   StringGridClick(sender);
   ButtonHTML.Enabled:=true;
   ButtonDelOldRecords.Enabled:=true;
  end;
end;

procedure TDBViewForm.UpdateSum;
var summ:real;
    page,n,cell_idx:integer;
begin
 page:=TabControl.TabIndex;

 if (not PanelPrices.Visible) or ((page<>0) and (page<>1)) then
  exit;

 with StringGrid do
  if (not Visible) or (RowCount<2) or (Cells[0,1]='') or (Selection.Top<=0) or (Selection.Bottom<Selection.Top) then
   begin
    EditSum.Enabled:=false;
    EditSum.Text:='';
    LabelSum.Enabled:=false;
   end
  else
   begin
    if page=0 then
     cell_idx:=PRICE_CELL_IDX
    else
     cell_idx:=PRICE_CELL_IDX_SUMM;
    summ:=0;
    for n:=Selection.Top to Selection.Bottom do
     begin
      try
       summ:=summ+StrToFloatDef(Cells[cell_idx,n],0);
      except end;
     end;
    EditSum.Enabled:=true;
    LabelSum.Enabled:=true;
    EditSum.Text:=Format('%1.2f',[summ]);
   end;
end;

procedure TDBViewForm.UpdateUserResponseText;
var s:string;
begin
 if (not PanelUserResponse.Visible) or (TabControl.TabIndex<>3) then
  exit;

 with StringGrid do
  if (not Visible) or (RowCount<2) or (Cells[0,1]='') or (Selection.Top<=0) or (Selection.Bottom<Selection.Top) then
   begin
    MemoUserResponse.Text:='';
   end
  else
   begin
    try
     s:=Cells[USERRESPONSE_CELL_IDX,Selection.Top];
    except
     s:='';
    end;
    MemoUserResponse.Text:=s;
   end;
end;

procedure TDBViewForm.ButtonPricesClick(Sender: TObject);
var f:TPricesForm;
begin
 f:=TPricesForm.CreateForm(sql);
 f.ShowModal;
 f.Free;
end;

procedure TDBViewForm.WriteStringCRLF(h:integer;s:string);
var crlf:string;
begin
 FileWrite(h,pointer(@s[1])^,length(s));
 crlf:=#13#10;
 FileWrite(h,pointer(@crlf[1])^,2);
end;

function TDBViewForm.ConvertString2HTML(s:string):string;
var t:string;
    n:integer;
begin
 t:='';
 for n:=1 to length(s) do
  if s[n]='<' then
   t:=t+'&lt;'
  else
  if s[n]='>' then
   t:=t+'&gt;'
  else
  if s[n]='&' then
   t:=t+'&amp;'
  else
  if s[n]=' ' then
   t:=t+'&nbsp;'
  else
  if s[n]=#13 then
   t:=t+'<br>'
  else
  if s[n]<>#10 then
   t:=t+s[n];
 Result:=t;
end;

procedure TDBViewForm.ButtonHTMLClick(Sender: TObject);
var h,n,m:integer;
    p:array[0..MAX_PATH] of char;
    rs,s,filename:string;
begin
 WaitCursor(true,true);
 p[0]:=#0;
 GetTempPath(sizeof(p),@p);
 filename:=IncludeTrailingPathDelimiter(string(p))+'rsdbview_tmp_log.html';
 h:=FileCreate(filename);
 if h <> -1 then
  begin
   WriteStringCRLF(h,'<html>');
   WriteStringCRLF(h,'<head>');
   WriteStringCRLF(h,'<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">');
   WriteStringCRLF(h,'<title>'+TabControl.Tabs[TabControl.TabIndex]+' [Runpad Pro]'+'</title>');
   WriteStringCRLF(h,'<style type="text/css">');
   WriteStringCRLF(h,'body, td, p {font-family:Verdana;font-size:8pt;}');
   WriteStringCRLF(h,'</style>');
   WriteStringCRLF(h,'</head>');
   WriteStringCRLF(h,'<body>');
   WriteStringCRLF(h,'<table cellspacing=0 cellpadding=2 border=1>');

   for m:=0 to StringGrid.RowCount-1 do
    begin
     rs:='<tr>';
     for n:=0 to StringGrid.ColCount-1 do
      begin
       s:=ConvertString2HTML(StringGrid.Cells[n,m]);
       if s='' then
        s:='&nbsp;';
       if m=0 then
        s:='<td bgcolor=#EEEEEE>'+s+'</td>'
       else
        s:='<td>'+s+'</td>';
       rs:=rs+s;
      end;
     rs:=rs+'</tr>';
     WriteStringCRLF(h,rs);
    end;

   WriteStringCRLF(h,'</table>');
   WriteStringCRLF(h,'</body>');
   WriteStringCRLF(h,'</html>');
   FileClose(h);
   ShellExecute(0,nil,pchar(filename),nil,nil,SW_SHOWNORMAL);
  end
 else
  MessageBox(Handle,S_ERR_SAVEINTEMP,S_ERR,MB_OK or MB_ICONERROR);
 WaitCursor(false,false);
end;

end.
