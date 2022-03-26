unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ImgList, StdCtrls, Menus,
  login, h_sql, global;


type
  TRSOperatorForm = class(TForm)
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
    ToolButtonSep1: TToolButton;
    Bevel2: TBevel;
    Panel3: TPanel;
    ButtonChangePass: TToolButton;
    ToolButtonSep2: TToolButton;
    ButtonDBView: TToolButton;
    ImageList1: TImageList;
    Panel4: TPanel;
    Bevel3: TBevel;
    ImageCenter: TImage;
    PageControl: TPageControl;
    TabSheet0: TTabSheet;
    ImageList3: TImageList;
    Panel5: TPanel;
    Panel14: TPanel;
    Splitter3: TSplitter;
    CoolBar5: TCoolBar;
    ToolBar5: TToolBar;
    ButtonSelectComps: TToolButton;
    ButtonSelectUsers: TToolButton;
    ButtonRefresh: TToolButton;
    TreeView: TTreeView;
    ImageListFunctions: TImageList;
    ButtonVipUsers: TToolButton;
    ButtonWOL: TToolButton;
    PopupMenuVip: TPopupMenu;
    MenuItemVipAdd: TMenuItem;
    MenuItemVipDel: TMenuItem;
    MenuItemVipClearPass: TMenuItem;
    ImageList2: TImageList;
    ButtonSep3: TToolButton;
    ImageList4: TImageList;
    PanelUnderFunctions: TPanel;
    Panel6: TPanel;
    Bevel4: TBevel;
    PageControlFunctions: TPageControl;
    MemoHint: TMemo;
    Timer1: TTimer;
    FPopup: TPopupMenu;
    procedure ButtonVipUsersClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonChangePassClick(Sender: TObject);
    procedure ButtonDBViewClick(Sender: TObject);
    procedure ButtonWOLClick(Sender: TObject);
    procedure MenuItemVipAddClick(Sender: TObject);
    procedure MenuItemVipDelClick(Sender: TObject);
    procedure MenuItemVipClearPassClick(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure ButtonSelectCompsClick(Sender: TObject);
    procedure ButtonSelectUsersClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure TreeViewCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure TreeViewDeletion(Sender: TObject; Node: TTreeNode);
    procedure TreeViewAddition(Sender: TObject; Node: TTreeNode);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure TreeViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
  private
    { Private declarations }
    host : PHostConnection;
    allow_onchange : boolean;
    sql : TSQLLib;
    user_rights : string;
    LoginForm : TLoginForm;
    procedure CreateFunctionButtons();
    procedure CreateFunctionPopup();
    function IsSQLConnected:boolean;
    procedure UpdateStatusString(panel:integer;s:string;process_messages:boolean);
    procedure UpdateView();
    procedure UpdateMachinesPage();
    procedure ButtonFunctionClick(Sender: TObject);
    procedure MinimizeToTray();
    procedure UpdateServerStatus();
    procedure UpdateCompList();
    procedure UpdateComputerMACs();
    procedure FunctionAction(uid:integer);
    procedure MenuFunctionClick(Sender: TObject);
  public
    { Public declarations }
    constructor CreateForm(p:PHostConnection);
    destructor Destroy; override;

    procedure SelfShow;
    procedure SelfHide;
    function IsSelfVisible:boolean;
    function GetSelfHWND:HWND;

    procedure DefaultHandler(var Message); override;
  end;



implementation

uses ShellApi, CommCtrl, StrUtils, Registry, tools, lang, changepwd, textbox, wol;

{$R *.dfm}


{$I ..\..\..\admin\rssettings\ur.inc}
{$I ..\..\common\version.inc}
{$I fid.inc}

const NETCLASS_SERVER    =   'Server';
const NETCLASS_USER      =   'User';
const NETCLASS_COMPUTER  =   'Computer';
const NETCLASS_OPERATOR  =   'Operator';


type
     TFunction = record
      uid : integer;
      groupname : string;
      caption : string;
      hint : string;
      imageindex : integer;
      button : TToolButton;
      menuitem : TMenuItem;
      no_self_exec : longbool;
      multiselect : longbool;
      allow_computer : longbool;
      allow_user : longbool;
      ur : string; //can be empty
     end;
     PFunction = ^TFunction;

var
     functions : array [0..39] of TFunction =
(
  (uid:FID_REBOOT;               groupname:'Действия';           caption:'Перезагрузить машину';                hint:'Перезагрузить машину';
   imageindex:0;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_REBOOTSHUTDOWN),
  (uid:FID_SHUTDOWN;             groupname:'Действия';           caption:'Выключить машину';                    hint:'Выключить машину';
   imageindex:1;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_REBOOTSHUTDOWN),
  (uid:FID_HIBERNATE;            groupname:'Действия';           caption:'Спящий режим';                        hint:'Переход в спящий режим';
   imageindex:30;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_REBOOTSHUTDOWN),
  (uid:FID_SUSPEND;              groupname:'Действия';           caption:'Ждущий режим';                        hint:'Переход в ждущий режим';
   imageindex:31;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_REBOOTSHUTDOWN),
  (uid:FID_LOGOFF;               groupname:'Действия';           caption:'Завершить сеанс';                     hint:'Завершить сеанс пользователя Windows (LogOff)';
   imageindex:2;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_LOGOFF),
  (uid:FID_KILLALL;              groupname:'Действия';           caption:'Снять все задачи';                    hint:'Снять все активные задачи пользователя';
   imageindex:3;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_KILLTASKS),
  (uid:FID_SENDMESSAGE;          groupname:'Действия';           caption:'Послать сообщение';                   hint:'Отправка сообщения пользователю';
   imageindex:4;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_SENDMESSAGE),
  (uid:FID_TURNMONITORON;        groupname:'Режимы';             caption:'Включить монитор';                    hint:'Включение монитора пользователя';
   imageindex:5;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNMONITOR),
  (uid:FID_TURNMONITOROFF;       groupname:'Режимы';             caption:'Выключить монитор';                   hint:'Выключение монитора пользователя';
   imageindex:6;
   button:nil;  menuitem:nil;   no_self_exec:true;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNMONITOR),
  (uid:FID_UNBLOCK;              groupname:'Режимы';             caption:'Разблокировать пользователя';         hint:'Отключить экран блокировки пользователя';
   imageindex:7;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNBLOCK),
  (uid:FID_BLOCK;                groupname:'Режимы';             caption:'Заблокировать пользователя';          hint:'Включить экран блокировки пользователя';
   imageindex:8;
   button:nil;  menuitem:nil;   no_self_exec:true;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNBLOCK),
  (uid:FID_RESTOREVMODE;         groupname:'Режимы';             caption:'Восстановить видеорежим';             hint:'Восстановить видеорежим на первоначальный';
   imageindex:9;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_RESTOREVMODE),
  (uid:FID_SOMEINFOCOMP;         groupname:'Информация';         caption:'Общие сведения (Comp)';               hint:'Получить общие сведения о машинах';
   imageindex:10;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_MACHINESINFO{''}),
  (uid:FID_SOMEINFOUSER;         groupname:'Информация';         caption:'Общие сведения (User)';               hint:'Получить общие сведения о пользователях';
   imageindex:10;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_MACHINESINFO{''}),
  (uid:FID_EXECSTAT;             groupname:'Информация';         caption:'Статистика запуска';                  hint:'Статистика запуска приложений на клиентских машинах';
   imageindex:11;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:''{UR_X_MACHINESINFO}),
  (uid:FID_SCREEN;               groupname:'Информация';         caption:'Экраны пользователей';                hint:'Просмотр текущих экранов пользователей';
   imageindex:12;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:''{UR_X_MACHINESINFO}),
  (uid:FID_WEBCAM;               groupname:'Информация';         caption:'Изображения с веб-камер';             hint:'Просмотр текущих изображений с веб-камер';
   imageindex:13;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:''{UR_X_MACHINESINFO}),
  (uid:FID_SCREENCONTROL;        groupname:'Информация';         caption:'Наблюдение экранов';                  hint:'Непрерывное наблюдение за экранами пользователей';
   imageindex:14;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:FALSE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:''{UR_X_MACHINESINFO}),
  (uid:FID_WEBCAMCONTROL;        groupname:'Информация';         caption:'Наблюдение с веб-камер';              hint:'Непрерывное наблюдение с веб-камер';
   imageindex:15;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:FALSE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:''{UR_X_MACHINESINFO}),
  (uid:FID_TURNSHELLON;          groupname:'Администрирование';  caption:'Включить шелл';                       hint:'Включить шелл для одного или всех пользователей машины';
   imageindex:16;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_TURNSHELL),
  (uid:FID_TURNSHELLOFF;         groupname:'Администрирование';  caption:'Отключить шелл';                      hint:'Отключить шелл для одного или всех пользователей машины';
   imageindex:17;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_TURNSHELL),
  (uid:FID_TURNCURRENTSHELLOFF;  groupname:'Администрирование';  caption:'Отключить шелл этого пользователя';   hint:'Отключить шелл только на этом текущем загруженном пользователе Windows выбранных машин';
   imageindex:17;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNSHELL),
  (uid:FID_TEMPTURNSHELLOFF;     groupname:'Администрирование';  caption:'Временно отключить шелл';             hint:'Временно отключить шелл (до перезагрузки или LogOff)';
   imageindex:37;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_TURNSHELL),
  (uid:FID_TURNAUTOLOGONON;      groupname:'Администрирование';  caption:'Включить AutoLogon';                  hint:'Включить автоматический логон пользователей на компьютере';
   imageindex:18;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_TURNAUTOLOGON),
  (uid:FID_TURNAUTOLOGONOFF;     groupname:'Администрирование';  caption:'Отключить AutoLogon';                 hint:'Отключить автоматический логон пользователей на компьютере';
   imageindex:19;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_TURNAUTOLOGON),
  (uid:FID_TIMESYNC;             groupname:'Администрирование';  caption:'Синхронизировать время';              hint:'Синхронизировать время на клиентских машинах с сервером';
   imageindex:20;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;    allow_user:FALSE;
   ur:UR_X_TIMESYNC),
  (uid:FID_CLEAREXECSTAT;        groupname:'Администрирование';  caption:'Очистить статистику';                 hint:'Очистить статистику запуска приложений';
   imageindex:21;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_CLEARSTAT),
  (uid:FID_CLIENTUPDATE;         groupname:'Администрирование';  caption:'Обновить клиентскую часть';            hint:'Обновить клиентскую часть на выбранных машинах до новой версии';
   imageindex:29;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_CLIENTUPDATE),
  (uid:FID_CLIENTUNINSTALL;      groupname:'Администрирование';  caption:'Удалить клиентскую часть';            hint:'Удалить клиентскую часть без шелла на выбранных машинах';
   imageindex:36;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_CLIENTUNINSTALL),
  (uid:FID_EXECUTECMDLINE;       groupname:'Файлы';              caption:'Выполнить';                           hint:'Запуск приложений на машине пользователя';
   imageindex:22;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_EXECUTE),
  (uid:FID_EXECUTEREG;           groupname:'Файлы';              caption:'Добавить в реестр';                   hint:'Запустить .reg-файл на машине пользователя';
   imageindex:23;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_EXECUTE),
  (uid:FID_EXECUTEBAT;           groupname:'Файлы';              caption:'Запустить bat-файл';                  hint:'Запустить .bat-файл на машине пользователя';
   imageindex:24;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_EXECUTE),
  (uid:FID_COPYFILES;            groupname:'Файлы';              caption:'Копировать файлы пользователям';      hint:'Копировать файлы на пользовательские машины';
   imageindex:25;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_COPYDELFILES),
  (uid:FID_DELETEFILES;          groupname:'Файлы';              caption:'Удалить файлы';                       hint:'Удалить предописанные файлы на пользовательских машинах';
   imageindex:26;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:FALSE;    allow_user:TRUE;
   ur:UR_X_COPYDELFILES),
  (uid:FID_RFM;                  groupname:'Управление';         caption:'Удаленный файловый менеджер';         hint:'Запустить удаленный файловый менеджер для выбранных машин';
   imageindex:27;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_RFM),
  (uid:FID_RD;                   groupname:'Управление';         caption:'Управление рабочим столом';           hint:'Запустить программу управления рабочим столом';
   imageindex:28;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:FALSE; allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_RSRD),
  (uid:FID_RLBINFO;              groupname:'Rollback (откат)';   caption:'Текущий статус отката';               hint:'Показывает текущее состояние отката для выбранных машин';
   imageindex:32;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_ROLLBACK),
  (uid:FID_RLBSAVE1;             groupname:'Rollback (откат)';   caption:'Сохранить на одну перезагрузку';      hint:'Сохранить данные (отключить откат) на одну перезагрузку';
   imageindex:33;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_ROLLBACK),
  (uid:FID_RLBSAVE2;             groupname:'Rollback (откат)';   caption:'Сохранить на две перезагрузки';       hint:'Сохранить данные (отключить откат) на две перезагрузки';
   imageindex:34;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:FALSE;
   ur:UR_X_ROLLBACK),
  (uid:FID_RLBHELP;              groupname:'Rollback (откат)';   caption:'Помощь';                              hint:'Помощь по функциям Rollback';
   imageindex:35;
   button:nil;  menuitem:nil;   no_self_exec:false;
   multiselect:TRUE;  allow_computer:TRUE;     allow_user:TRUE;
   ur:'')

);


var msg_login : cardinal = WM_NULL;
var msg_close : cardinal = WM_NULL;



procedure TRSOperatorForm.CreateFunctionButtons();
var n,idx:integer;
    p:PFunction;
    page:TTabSheet;
    panel:TPanel;
    tb:TToolBar;
    btn:TToolButton;
    olda:TAlign;
begin
 FillImageList(ImageListFunctions,32,100,38);

 for idx:=high(functions) downto low(functions) do
  begin
   p:=@functions[idx];

   page:=nil;
   for n:=0 to PageControlFunctions.PageCount-1 do
    if PageControlFunctions.Pages[n].Caption=p.groupname then
     begin
      page:=PageControlFunctions.Pages[n];
      break;
     end;
   if page=nil then
    begin
     page:=TTabSheet.Create(self);
     page.PageControl:=PageControlFunctions;
     page.Caption:=p.groupname;
     page.PageIndex:=0;
    end;

   panel:=nil;
   for n:=0 to page.ControlCount-1 do
    if page.Controls[n].ClassName='TPanel' then
     begin
      panel:=page.Controls[n] as TPanel;
      break;
     end;
   if panel=nil then
    begin
     panel:=TPanel.Create(self);
     panel.Parent:=page;
     panel.Align:=alClient;
     panel.BevelInner:=bvRaised;
     panel.BevelOuter:=bvLowered;
     panel.Caption:='';
     panel.Color:=clMedGray;
    end;

   tb:=nil;
   for n:=0 to panel.ControlCount-1 do
    if panel.Controls[n].ClassName='TToolBar' then
     begin
      tb:=panel.Controls[n] as TToolBar;
      break;
     end;
   if tb=nil then
    begin
     tb:=TToolBar.Create(self);
     tb.Parent:=panel;
     tb.Align:=alLeft;
     tb.AutoSize:=true;
     tb.Caption:='';
     tb.EdgeBorders:=[];
     tb.Flat:=true;
     tb.Indent:=7;
     tb.ShowCaptions:=true;
     tb.Transparent:=true;
     tb.Wrapable:=true;
     tb.List:=true;
     tb.Images:=ImageListFunctions;
    end;

   btn:=TToolButton.Create(tb);
   btn.Parent:=tb;
   btn.Caption:=p.caption;
   btn.Hint:=p.hint;
   btn.ImageIndex:=p.imageindex;
   btn.ShowHint:=false; //!!! some problems with this hints and XP-themes (shadows are remains sometimes)
   btn.Style:=tbsButton;
   btn.Wrap:=false;
   btn.Tag:=p.uid;
   btn.OnClick:=ButtonFunctionClick;

   olda:=tb.Align;
   tb.Align:=alNone;
   tb.Align:=olda;

   p.button:=btn;
  end;

 PageControlFunctions.ActivePageIndex:=0;
end;

procedure TRSOperatorForm.CreateFunctionPopup();
var menu, item : TMenuItem;
    n,m : integer;
    f : PFunction;
begin
 for n:=0 to PageControlFunctions.PageCount-1 do
  begin
   menu:=TMenuItem.Create(FPopup);
   menu.Caption:=PageControlFunctions.Pages[n].Caption;

   for m:=low(functions) to high(functions) do
    begin
     f:=@functions[m];
     if f.groupname=menu.Caption then
      begin
       item:=TMenuItem.Create(menu);
       item.Caption:=f.caption;
       item.Tag:=f.uid;
       item.OnClick:=MenuFunctionClick;
       menu.Add(item);
       f.menuitem:=item;
      end;
    end;

   FPopup.Items.Add(menu);
  end;
end;

function TRSOperatorForm.IsSQLConnected:boolean;
begin
 Result:=sql<>nil;
end;

procedure TRSOperatorForm.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    if msg=msg_login then
     begin
      if ButtonConnect.Enabled then
       ButtonConnectClick(nil);
     end
    else
    if msg=msg_close then
     begin
      Close;
     end
    else
      inherited;
end;

constructor TRSOperatorForm.CreateForm(p:PHostConnection);
var hIcon:cardinal;
begin
 inherited Create(nil);

 host:=p;
 allow_onchange:=true;
 sql:=nil;
 user_rights:='';
 LoginForm:=TLoginForm.CreateForm();

 hIcon := LoadImage(HInstance, PChar(200), IMAGE_ICON, 16, 16, LR_SHARED);
 SendMessage(Handle, WM_SETICON, ICON_SMALL, hIcon);
 hIcon := LoadImage(HInstance, PChar(200), IMAGE_ICON, 32, 32, LR_SHARED);
 SendMessage(Handle, WM_SETICON, ICON_BIG, hIcon);

 FillImageList(ImageList1,32,150,6);
 FillImageList(ImageList2,16,201,1);
 FillImageList(ImageList3,32,210,3);
 FillImageList(ImageList4,16,220,3);

 CreateFunctionButtons();
 CreateFunctionPopup(); // must be after CreateFunctionButtons()

 ButtonDBView.Enabled:=FileExists(GetLocalPath(PATH_DBVIEW));

 Constraints.MinHeight:=Height;
 Constraints.MinWidth:=Width;
 if Screen.Width>800 then
  begin
   Width:=1000;
   Left:=(Screen.Width-Width) div 2;
  end;
 if ReadConfigInt(FALSE,OURAPPNAME,'WindowMaximized',0)<>0 then
  WindowState:=wsMaximized;

 UpdateView();

 Timer1.Enabled:=true;
end;

destructor TRSOperatorForm.Destroy;
begin
 Timer1.Enabled:=false;

 SendMessage(Handle, WM_SETICON, ICON_SMALL, 0);
 SendMessage(Handle, WM_SETICON, ICON_BIG, 0);

 FreeAndNil(LoginForm);
 FreeAndNil(sql);
 allow_onchange:=false;

 inherited;
end;

procedure TRSOperatorForm.SelfShow;
begin
 Visible:=true;
 if Windows.IsIconic(Handle) then
  ShowWindow(Handle,SW_RESTORE);
 SetForegroundWindow(Handle);
end;

procedure TRSOperatorForm.SelfHide;
begin
 Visible:=false;
end;

function TRSOperatorForm.IsSelfVisible:boolean;
begin
 Result:=Visible;
end;

function TRSOperatorForm.GetSelfHWND:HWND;
begin
 Result:=Handle;
end;

procedure TRSOperatorForm.FormShow(Sender: TObject);
begin
 UpdateCompList();
 UpdateServerStatus();
 UpdateComputerMACs();

 TreeView.SetFocus;

 if not IsSQLConnected then
  PostMessage(Handle,msg_login,0,0);
end;

procedure TRSOperatorForm.FormResize(Sender: TObject);
var maxw:integer;
begin
 if (not Windows.IsIconic(Handle)) and Visible then
  begin
   if Windows.IsZoomed(Handle) then
    maxw:=1
   else
    maxw:=0;
   WriteConfigInt(FALSE,OURAPPNAME,'WindowMaximized',maxw);
  end;
end;

procedure TRSOperatorForm.UpdateStatusString(panel:integer;s:string;process_messages:boolean);
begin
 StatusBar.Panels[panel].Text:=' '+s;
 if process_messages then
  Application.ProcessMessages;
end;

procedure TRSOperatorForm.UpdateView();
begin
 if IsSQLConnected then
  begin
   ButtonConnect.Enabled:=false;
   ButtonDisconnect.Enabled:=true;
   ButtonChangePass.Enabled:=true;
   ButtonVipUsers.Enabled:=true;
   Caption:=S_VERSION + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')';
   UpdateStatusString(1,S_SQLCONNECTED + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')',false);
  end
 else
  begin
   ButtonConnect.Enabled:=true;
   ButtonDisconnect.Enabled:=false;
   ButtonChangePass.Enabled:=false;
   ButtonVipUsers.Enabled:=false;
   Caption:=S_VERSION + ' - ' + S_NOTSQLCONNECTEDTITLE;
   UpdateStatusString(1,S_NOTSQLCONNECTED,false);
  end;

 host.OnTitleChanged(pchar(Caption));
 UpdateCompList();
 UpdateServerStatus();
 UpdateMachinesPage();
end;

procedure TRSOperatorForm.UpdateMachinesPage();
var item:TTreeNode;
    n:integer;
    p:PFUNCTION;
    is_multiselect:boolean;
    computer_count,user_count:integer;
    is_computer,is_user,is_something:boolean;
    b_enabled:boolean;
    s:string;
    i:PENVENTRYDELPHI;
    list:TStringList;
begin
 // buttons
 computer_count:=0;
 user_count:=0;
 for n:=0 to TreeView.SelectionCount-1 do
  begin
   item:=TreeView.Selections[n];
   if item.Level=1 then
    inc(computer_count);
   if item.Level=2 then
    inc(user_count);
  end;
 is_multiselect:=computer_count + user_count > 1;
 is_computer:=computer_count > 0;
 is_user:=user_count > 0;
 is_something:=is_computer or is_user;

 for n:=low(functions) to high(functions) do
  begin
   p:=@functions[n];

   b_enabled:=true;
   if (not is_something) or
      ((not p.multiselect) and is_multiselect) or
      ((not p.allow_computer) and is_computer) or
      ((not p.allow_user) and is_user) or
      ((p.ur<>'') and (not AnsiContainsText(user_rights,p.ur))) then
     b_enabled:=false;

   if p.button.Enabled<>b_enabled then
     p.button.Enabled:=b_enabled;
   if p.menuitem.Enabled<>b_enabled then
     p.menuitem.Enabled:=b_enabled;
  end;

 // panel with buttons and memo
 if Panel6.Visible<>is_something then
  Panel6.Visible:=is_something;

 // status report
 computer_count:=0;
 user_count:=0;
 for n:=0 to TreeView.Items.Count-1 do
  begin
   item:=TreeView.Items[n];
   if item.Level=1 then
    inc(computer_count);
   if item.Level=2 then
    inc(user_count);
  end;
 if (computer_count>0) or (user_count>0) then
  s:=Format(S_COMPUSERREPORT,[computer_count,user_count])
 else
  s:='';
 if StatusBar.Panels[3].Text<>s then
  StatusBar.Panels[3].Text:=s;

 // memo
 if (TreeView.Selected<>nil) and (TreeView.Selected.Level>0) then
  begin
   i:=PENVENTRYDELPHI(TreeView.Selected.Data);

   list:=TStringList.Create;
   list.Add(Format(S_INFOFMT_GUID,[i.guid]));
   list.Add(Format(S_INFOFMT_CLASS,[i.class_name]));
   list.Add(Format(S_INFOFMT_IP,[i.ip]));
   list.Add(Format(S_INFOFMT_MAC,[i.mac]));
   list.Add(Format(S_INFOFMT_RPVER,[i.runpad_ver]));
   list.Add(Format(S_INFOFMT_MACHINELOC,[i.machine_loc]));
   list.Add(Format(S_INFOFMT_MACHINEDESC,[i.machine_desc]));
   list.Add(Format(S_INFOFMT_COMPNAME,[i.comp_name]));
   if TreeView.Selected.Level=2 then
    begin
     list.Add(Format(S_INFOFMT_DOMAIN,[i.domain]));
     list.Add(Format(S_INFOFMT_USERNAME,[i.user_name]));
     list.Add(Format(S_INFOFMT_VIPSESSION,[i.vip_session]));
     list.Add(Format(S_INFOFMT_ACTIVETASK,[i.active_task]));
     if i.monitor_state then
      list.Add(S_INFOFMT_MONITORON)
     else
      list.Add(S_INFOFMT_MONITOROFF);
     if i.blocked_state then
      list.Add(S_INFOFMT_BLOCKON)
     else
      list.Add(S_INFOFMT_BLOCKOFF);
    end
   else
    begin
     if i.is_rfm then
      list.Add(S_INFOFMT_RFMON)
     else
      list.Add(S_INFOFMT_RFMOFF);
     if i.is_rd then
      list.Add(S_INFOFMT_RDON)
     else
      list.Add(S_INFOFMT_RDOFF);
     if i.is_rollback then
      list.Add(S_INFOFMT_RLBON)
     else
      list.Add(S_INFOFMT_RLBOFF);
    end;

   if MemoHint.Text<>list.Text then
    MemoHint.Text:=list.Text;

   list.Free;
  end
 else
  begin
   if MemoHint.Text<>'' then
    MemoHint.Text:='';
  end;
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

function SelectUserRightsCB(i:PEXECSQLCBSTRUCT):longbool cdecl;
var f:pointer;
begin
 f:=i.GetFieldByName(i.obj,'user_rights');
 if f<>nil then
  pstring(i.user_parm)^:=GetFieldValueAsDelphiString(i,f);
 Result:=false;
end;

procedure TRSOperatorForm.ButtonConnectClick(Sender: TObject);
var cnt:integer;
    err:string;
begin
 if LoginForm.ShowModal=mrOk then
  begin
   UpdateStatusString(1,S_SQLCONNECTING,false);
   Update;
   WaitCursor(true,true);

   FreeAndNil(sql);
   sql:=TSQLLib.Create(LoginForm.GetServerType);

   if sql.ConnectAsNormalUser(LoginForm.GetServer,LoginForm.GetLogin,LoginForm.GetPwd) then
    begin
     cnt:=0;
     user_rights:='';
     if (not sql.Exec('SELECT user_rights FROM TDBUsers WHERE user_name='''+sql.EscapeString(LoginForm.GetLogin)+'''',SQL_DEF_TIMEOUT,@cnt,SelectUserRightsCB,@user_rights))
        or (cnt<=0) then
      begin
       user_rights:='';
       MessageBox(Handle,pchar(S_USERNOTADDED2DB+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
      end;
     LoginForm.WriteConfig;
     UpdateView();
    end
   else
    begin
     err:=sql.GetLastError;
     FreeAndNil(sql);
     UpdateStatusString(1,S_ERRSQLCONNECT,false);
     MessageBox(Handle,pchar(S_ERRCONNECTINGTOSQL+#13#10+#13#10+err),S_ERR,MB_OK or MB_ICONERROR);
    end;
   WaitCursor(false,false);
  end;
end;

procedure TRSOperatorForm.ButtonDisconnectClick(Sender: TObject);
begin
 WaitCursor(true,false);
 user_rights:='';
 FreeAndNil(sql); //this first to correct UpdateView() work
 UpdateView();
 WaitCursor(false,false);
end;

procedure TRSOperatorForm.ButtonChangePassClick(Sender: TObject);
var s_old,s_new:string;
    rc:boolean;
begin
 s_old:='';
 s_new:='';
 if ShowChangePwdFormModal(s_old,s_new) then
  begin
   Update;
   WaitCursor(true,true);

   rc:=sql.ChangeCurrentPwd(s_old,s_new);

   WaitCursor(false,false);

   if rc then
    MessageBox(Handle,S_PWDCHANGED,S_INFO,MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(Handle,pchar(S_PWDNOTCHANGED+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TRSOperatorForm.ButtonDBViewClick(Sender: TObject);
var s:string;
begin
 Application.CancelHint; // remove hint from screen

 s:=GetLocalPath(PATH_DBVIEW);
 if IsSQLConnected then
  s:='"'+s+'" "'+LoginForm.GetServer+'" "'+inttostr(LoginForm.GetServerType)+'" "'+LoginForm.GetLogin+'" "'+LoginForm.GetPwd+'"';
 ExecLocalFile(PATH_DBVIEW,s);
end;

procedure TRSOperatorForm.ButtonWOLClick(Sender: TObject);
begin
 UpdateComputerMACs();
 ShowWOLFormModal(host);
end;

procedure TRSOperatorForm.MenuItemVipAddClick(Sender: TObject);
var s:string;
    rc:boolean;
    cnt:integer;
begin
 if ShowTextBoxFormModal(s,hinstance,230,S_VIPADD,S_ENTERVIPNAME,'',250,false,'VipUsers') then
  begin
   Update;
   WaitCursor(true,true);

   cnt:=0;
   rc:=sql.InplaceCallStoredProc('PVipRegister',''''+sql.EscapeString(s)+''',''''',SQL_DEF_TIMEOUT,@cnt) and (cnt>0);

   WaitCursor(false,false);

   if rc then
    MessageBox(Handle,S_VIPADDED,S_INFO,MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(Handle,pchar(S_ERRVIPADD+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TRSOperatorForm.MenuItemVipDelClick(Sender: TObject);
var s:string;
    rc:boolean;
begin
 if ShowTextBoxFormModal(s,hinstance,231,S_VIPDEL,S_ENTERVIPNAME,'',250,false,'VipUsers') then
  begin
   Update;
   WaitCursor(true,true);

   rc:=sql.InplaceCallStoredProc('PVipDelete',''''+sql.EscapeString(s)+'''');

   WaitCursor(false,false);

   if rc then
    MessageBox(Handle,S_VIPDELETED,S_INFO,MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(Handle,pchar(S_ERRVIPDELETE+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TRSOperatorForm.MenuItemVipClearPassClick(Sender: TObject);
var s:string;
    rc:boolean;
begin
 if ShowTextBoxFormModal(s,hinstance,232,S_VIPCLEARPWD,S_ENTERVIPNAME,'',250,false,'VipUsers') then
  begin
   Update;
   WaitCursor(true,true);

   rc:=sql.InplaceCallStoredProc('PVipClearPass',''''+sql.EscapeString(s)+'''');

   WaitCursor(false,false);

   if rc then
    MessageBox(Handle,S_VIPCLEARED,S_INFO,MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(Handle,pchar(S_ERRVIPCLEAR+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TRSOperatorForm.ButtonVipUsersClick(Sender: TObject);
var p:TPoint;
begin
 p.x:=0;
 p.y:=ButtonVipUsers.Height;
 p:=ButtonVipUsers.ClientToScreen(p);
 ButtonVipUsers.DropdownMenu.Popup(p.x,p.y);
end;

procedure TRSOperatorForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
 if allow_onchange then
   UpdateMachinesPage();
end;

procedure TRSOperatorForm.TreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TRSOperatorForm.ButtonSelectCompsClick(Sender: TObject);
var zal,comp:TTreeNode;
    nodes:array of TTreeNode;
begin
 allow_onchange:=false;
 Treeview.Items.BeginUpdate;

 nodes:=nil;
 zal:=TreeView.Items.GetFirstNode;
 while zal<>nil do
  begin
   zal.Expand(false);
   comp:=zal.getFirstChild;
   while comp<>nil do
    begin
     comp.Collapse(true);
     SetLength(nodes,Length(nodes)+1);
     nodes[high(nodes)]:=comp;
     comp:=comp.getNextSibling;
    end;
   zal:=zal.getNextSibling;
  end;
 TreeView.ClearSelection();
 TreeView.Select(nodes);
 nodes:=nil;

 TreeView.TopItem:=TreeView.Items.GetFirstNode;

 Treeview.Items.EndUpdate;
 allow_onchange:=true;

 UpdateMachinesPage();
end;

procedure TRSOperatorForm.ButtonSelectUsersClick(Sender: TObject);
var n:integer;
begin
 allow_onchange:=false;
 Treeview.Items.BeginUpdate;

 TreeView.FullExpand;
 TreeView.ClearSelection();
 for n:=TreeView.Items.Count-1 downto 0 do
  if TreeView.Items[n].Level=2 then
   TreeView.Select(TreeView.Items[n],[ssCtrl,ssLeft]);

 TreeView.TopItem:=TreeView.Items.GetFirstNode;

 Treeview.Items.EndUpdate;
 allow_onchange:=true;

 UpdateMachinesPage();
end;

procedure TRSOperatorForm.FunctionAction(uid:integer);
var f:PFUNCTION;
    env:PENVENTRYDELPHI;
    n:integer;
    list_ar : array of TENVENTRY;
    d : PENVENTRY;
begin
 f:=nil;
 for n:=low(functions) to high(functions) do
  begin
   if functions[n].uid=uid then
    begin
     f:=@functions[n];
     break;
    end;
  end;

 if f<>nil then
  begin
   list_ar:=nil;

   for n:=0 to TreeView.SelectionCount-1 do
    with TreeView.Selections[n] do
     if (Level=1) or (Level=2) then
      begin
       env:=PENVENTRYDELPHI(Data);
       if (not f.no_self_exec) or (not host.IsOurIP(pchar(env.ip))) then
        begin
         SetLength(list_ar,Length(list_ar)+1);
         d:=@list_ar[high(list_ar)];
         d.guid:=env.guid;
         StrLCopy(d.class_name,pchar(env.class_name),sizeof(TSTRING)-1);
         StrLCopy(d.ip,pchar(env.ip),sizeof(TSTRING)-1);
         StrLCopy(d.mac,pchar(env.mac),sizeof(TSTRING)-1);
         StrLCopy(d.runpad_ver,pchar(env.runpad_ver),sizeof(TSTRING)-1);
         StrLCopy(d.machine_loc,pchar(env.machine_loc),sizeof(TSTRING)-1);
         StrLCopy(d.machine_desc,pchar(env.machine_desc),sizeof(TSTRING)-1);
         StrLCopy(d.comp_name,pchar(env.comp_name),sizeof(TSTRING)-1);
         StrLCopy(d.domain,pchar(env.domain),sizeof(TSTRING)-1);
         StrLCopy(d.user_name,pchar(env.user_name),sizeof(TSTRING)-1);
         StrLCopy(d.vip_session,pchar(env.vip_session),sizeof(TSTRING)-1);
         StrLCopy(d.active_task,pchar(env.active_task),sizeof(TSTRING)-1);
         d.monitor_state:=env.monitor_state;
         d.blocked_state:=env.blocked_state;
         d.is_rfm:=env.is_rfm;
         d.is_rd:=env.is_rd;
         d.is_rollback:=env.is_rollback;
        end;
      end;

   if Length(list_ar)>0 then
    begin
     Update;
     WaitCursor(true,false);
     host.ExecFunction(uid,@list_ar[0],Length(list_ar));
     WaitCursor(false,false);
    end;

   list_ar:=nil;
  end;
end;

procedure TRSOperatorForm.ButtonFunctionClick(Sender: TObject);
begin
 FunctionAction((Sender as TToolButton).Tag);
end;

procedure TRSOperatorForm.MenuFunctionClick(Sender: TObject);
begin
 FunctionAction((Sender as TMenuItem).Tag);
end;

procedure TRSOperatorForm.MinimizeToTray();
var w:HWND;
    r,r2:TRect;
begin
 if Visible and (not Windows.IsIconic(Handle)) and (GetForegroundWindow()=Handle) then
  begin
   w:=FindWindow('Shell_TrayWnd',nil);
   if w<>0 then
    begin
     w:=FindWindowEx(w,0,'TrayNotifyWnd',nil);
     if w<>0 then
      begin
       GetWindowRect(w,r);
       r.Right:=r.Left+1;
       r.Bottom:=r.Top+1;
       GetWindowRect(Handle,r2);
       DrawAnimatedRects(Handle,IDANI_CAPTION,r2,r);
      end;
    end;
  end;
end;

procedure TRSOperatorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caHide;
 MinimizeToTray();
end;

procedure TRSOperatorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  begin
   PostMessage(Handle,msg_close,0,0);
   //key:=255;
  end;
end;

procedure TRSOperatorForm.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (not (ssCtrl in Shift)) and (not (ssShift in Shift)) then
  begin
   if key in [VK_UP,VK_DOWN,VK_LEFT,VK_RIGHT,VK_PRIOR,VK_NEXT,VK_HOME,VK_END,VK_BACK,ord('0')..ord('9'),ord('A')..ord('Z'),VK_ADD,VK_SUBTRACT] then
    begin
     TreeView.ClearSelection(true);
     UpdateMachinesPage();
    end;
  end;
 if key=VK_F5 then
  begin
   if ButtonRefresh.Enabled then
    ButtonRefreshClick(Sender);
  end;
end;

procedure TRSOperatorForm.UpdateServerStatus();
var p:array[0..MAX_PATH] of char;
    b_conn:boolean;
    s:string;
    panel:TStatusPanel;
begin
 p[0]:=#0;
 host.GetServerName(p);
 b_conn:=host.IsServerConnected();

 if b_conn then
  s:=' '+S_SERVERCONNECTED+' "'+string(p)+'"'
 else
  s:=' '+S_SERVERCONNECTING+' "'+string(p)+'"...';

 panel:=StatusBar.Panels[2];
 if panel.Text<>s then
  begin
   if b_conn then
    panel.Style:=psText
   else
    panel.Style:=psOwnerDraw;

   panel.Text:=s;
  end;
end;

function FindGuidInList(guid:cardinal;var list:array of PENVENTRYDELPHI):integer;
var n:integer;
    find:boolean;
begin
 find:=false;
 for n:=0 to high(list) do
  if (list[n]<>nil) and (list[n].guid=guid) then
   begin
    find:=true;
    break;
   end;
 if find then
  Result:=n
 else
  Result:=-1;
end;


function IsTreeViewNeedToBeSorted(node:TTreeNode):boolean;
var next:TTreeNode;
    cmp:integer;
begin
 Result:=false;

 if node=nil then
  exit;

 if @(node.TreeView as TTreeView).OnCompare=nil then
  begin
   Result:=true;
   exit;
  end;

 while true do
  begin
   if IsTreeViewNeedToBeSorted(node.getFirstChild) then
    begin
     Result:=true;
     break;
    end;

   next:=node.getNextSibling;
   if next=nil then
    break;

   cmp:=0;
   (node.TreeView as TTreeView).OnCompare(nil,node,next,0,cmp);
   if cmp>0 then
    begin
     Result:=true;
     break;
    end;

   node:=next;
  end;
end;


procedure TRSOperatorForm.UpdateCompList();
var n,m,count : integer;
    t_env : TENVENTRY;
    env,p : PENVENTRYDELPHI;
    list : array of PENVENTRYDELPHI;
    n_zal,n_comp,n_user,n_zal_next,n_comp_next,n_user_next : TTreeNode;
    s,s2 : string;
    b_computer_was_added : boolean;
begin
 b_computer_was_added:=false;

 allow_onchange:=false;
 TreeView.Items.BeginUpdate;

 // build list of env in delphi format
 list:=nil;

 count:=host.GetEnvListCount();
 for n:=0 to count-1 do
  begin
   host.GetEnvListAt(n,@t_env);
   New(env);
   env.guid:=t_env.guid;
   env.class_name:=t_env.class_name;
   env.ip:=t_env.ip;
   env.mac:=t_env.mac;
   env.runpad_ver:=t_env.runpad_ver;
   env.machine_loc:=t_env.machine_loc;
   env.machine_desc:=t_env.machine_desc;
   env.comp_name:=t_env.comp_name;
   env.domain:=t_env.domain;
   env.user_name:=t_env.user_name;
   env.vip_session:=t_env.vip_session;
   env.active_task:=t_env.active_task;
   env.monitor_state:=t_env.monitor_state;
   env.blocked_state:=t_env.blocked_state;
   env.is_rfm:=t_env.is_rfm;
   env.is_rd:=t_env.is_rd;
   env.is_rollback:=t_env.is_rollback;
   SetLength(list,Length(list)+1);
   list[high(list)]:=env;
  end;
 
// this for debug
{ count:=50;
 for n:=0 to count-1 do
  begin
   New(env);
   env.guid:=n;
   if n mod 2 = 0 then
    env.class_name:=NETCLASS_COMPUTER
   else
    env.class_name:=NETCLASS_USER;
   env.ip:='192.168.0.'+inttostr(n div 2 + 5);
   env.mac:='00:DC:7A:02:13:11';
   env.runpad_ver:='v0.90';
   if n < 20 then
    env.machine_loc:='Компьютерный зал 1'
   else
    env.machine_loc:='VIP-зал';

   env.machine_desc:=inttostr(n div 2 + 1);
   env.comp_name:='COMP'+env.machine_desc;
   env.domain:='domain';
   env.user_name:='user';
   if n mod 8 <> 0 then
    env.vip_session:=''
   else
    env.vip_session:='ivanov';
   case n mod 8 of
    0: env.active_task:='';
    1: env.active_task:='(2) WinWord - Документ1';
    2: env.active_task:='(3) Winamp - fav.mp3';
    3: env.active_task:='(2) Калькулятор';
    4: env.active_task:='DOOM';
    5: env.active_task:='(2) Counter Strike';
    6: env.active_task:='(2) Microsoft Excel - Книга2';
    7: env.active_task:='';
   end;
   env.monitor_state:=true;
   if n mod 5 = 2 then
    env.blocked_state:=true
   else
    env.blocked_state:=false;
   env.is_rfm:=false;
   env.is_rd:=false;
   env.is_rollback:=true;
   SetLength(list,Length(list)+1);
   list[high(list)]:=env;
  end;}

 // iterate tree and delete/modify nodes
 n_zal:=TreeView.Items.GetFirstNode;
 while n_zal<>nil do
  begin
   n_comp:=n_zal.getFirstChild;
   while n_comp<>nil do
    begin
     n_comp_next:=n_comp.getNextSibling;
     env:=PENVENTRYDELPHI(n_comp.Data);
     n:=FindGuidInList(env.guid,list);
     if n<>-1 then
      begin
       env.is_rfm:=list[n].is_rfm;
       env.is_rd:=list[n].is_rd;
       env.is_rollback:=list[n].is_rollback;
       Dispose(list[n]);
       list[n]:=nil;
       n_user:=n_comp.getFirstChild;
       while n_user<>nil do
        begin
         n_user_next:=n_user.getNextSibling;
         env:=PENVENTRYDELPHI(n_user.Data);
         n:=FindGuidInList(env.guid,list);
         if n<>-1 then
          begin
           env.vip_session:=list[n].vip_session;
           env.active_task:=list[n].active_task;
           env.monitor_state:=list[n].monitor_state;
           env.blocked_state:=list[n].blocked_state;
           Dispose(list[n]);
           list[n]:=nil;
          end
         else
          n_user.Delete;
         n_user:=n_user_next;
        end;
      end
     else
      n_comp.Delete;
     n_comp:=n_comp_next;
    end;
   n_zal:=n_zal.getNextSibling;
  end;

 // iterate to add COMPUTERS first
 for n:=0 to high(list) do
  begin
   env:=list[n];
   if env<>nil then
    begin
     if env.class_name=NETCLASS_COMPUTER then
      begin
       n_zal:=nil;
       for m:=0 to TreeView.Items.Count-1 do
        with TreeView.Items[m] do
         if (Level=0) and (AnsiCompareText(PENVENTRYDELPHI(Data).machine_loc,env.machine_loc)=0) then
          begin
           n_zal:=self.TreeView.Items[m];
           break;
          end;
       if n_zal=nil then
        begin
         n_zal:=TreeView.Items.Add(nil,'');
         New(p);
         p.machine_loc:=env.machine_loc;
         n_zal.Data:=p;
        end;
       n_comp:=TreeView.Items.AddChild(n_zal,'');
       n_comp.Data:=env;
       list[n]:=nil;
       n_zal.Expand(false);
       b_computer_was_added:=true;
      end;
    end;
  end;

 // iterate to add USERS next
 for n:=0 to high(list) do
  begin
   env:=list[n];
   if env<>nil then
    begin
     if env.class_name=NETCLASS_USER then
      begin
       n_comp:=nil;
       for m:=0 to TreeView.Items.Count-1 do
        with TreeView.Items[m] do
         if (Level=1) and
            (AnsiCompareText(PENVENTRYDELPHI(Data).machine_loc,env.machine_loc)=0) and
            (AnsiCompareText(PENVENTRYDELPHI(Data).machine_desc,env.machine_desc)=0) and
            (AnsiCompareText(PENVENTRYDELPHI(Data).comp_name,env.comp_name)=0) //assume that in terminal server clients returns here GetComputerName()!!!
            //по хорошему нужно проверять только machine_loc и machine_desc, и если найдено более одного совпадения, то только среди них выбирать то, где и comp_name совпадает
            //а иначе будет проблема если клиент терминала вернет comp_name отличный от GetComputerName()
            then
          begin
           n_comp:=self.TreeView.Items[m];
           break;
          end;
       if n_comp<>nil then
        begin
         n_user:=TreeView.Items.AddChild(n_comp,'');
         n_user.Data:=env;
         list[n]:=nil;
         n_comp.Expand(false);
        end;
      end;
    end;
  end;

 // delete empty zals
 n_zal:=TreeView.Items.GetFirstNode;
 while n_zal<>nil do
  begin
   n_zal_next:=n_zal.getNextSibling;
   if n_zal.getFirstChild=nil then
    n_zal.Delete;
   n_zal:=n_zal_next;
  end;

 // set captions to entire tree
 for n:=0 to TreeView.Items.Count-1 do
  with TreeView.Items[n] do
   begin
    p:=PENVENTRYDELPHI(Data);
    s:='';
    if Level=0 then
     begin
      s:=p.machine_loc;
      if s='' then
       s:=S_DEFZAL;
     end
    else
    if Level=1 then
     begin
      if p.machine_desc<>'' then
       begin
        if AnsiCompareText(p.comp_name,p.machine_desc)<>0 then
         s:=p.machine_desc+' ('+p.comp_name+'/'+p.ip+')'
        else
         s:=p.machine_desc+' ('+p.ip+')';
       end
      else
       begin
        s:=p.comp_name+' ('+p.ip+')';
       end;
      if p.is_rollback then
       s:=s+' '+S_INFO_ROLLBACK;
     end
    else
    if Level=2 then
     begin
      if (p.domain='') or (AnsiCompareText(p.domain,p.comp_name)=0) then
       s:=p.user_name
      else
       s:=p.domain+'\'+p.user_name;
      s2:='';
      //todo: добавить сюда вывод IP если он не совпадает с родительским
      if p.vip_session<>'' then
       begin
        if s2<>'' then
         s2:=s2+', ';
        s2:=s2+S_INFO_VIP+': "'+p.vip_session+'"';
       end;
      if not p.monitor_state then
       begin
        if s2<>'' then
         s2:=s2+', ';
        s2:=s2+S_INFO_MONITOR+': '+S_INFO_OFF;
       end;
      if p.blocked_state then
       begin
        if s2<>'' then
         s2:=s2+', ';
        s2:=s2+S_INFO_BLOCKED;
       end;
      if p.active_task<>'' then
       begin
        if s2<>'' then
         s2:=s2+', ';
        s2:=s2+S_INFO_TASK+': "'+p.active_task+'"';
       end;
      if s2<>'' then
       s:=s+' ('+s2+')';
     end;
    if Text<>s then
     Text:=s;
   end;

 // sort tree
 if IsTreeViewNeedToBeSorted(TreeView.Items.GetFirstNode) then  // optimization because of center-item effect after sorting
  TreeView.AlphaSort(true);

 // free list and remained items
 for n:=0 to high(list) do
  begin
   env:=list[n];
   if env<>nil then
    begin
     Dispose(env);
     list[n]:=nil;
    end;
  end;
 list:=nil;

 TreeView.Items.EndUpdate;
 allow_onchange:=true;

 if b_computer_was_added then
  UpdateComputerMACs();

 UpdateMachinesPage();
end;

procedure TRSOperatorForm.UpdateComputerMACs();
var n:integer;
    p:PENVENTRYDELPHI;
    reg:TRegistry;
begin
 reg:=TRegistry.Create;
 if reg.OpenKey(REGPATH+'\MACs',true) then
   begin
    for n:=0 to TreeView.Items.Count-1 do
     with TreeView.Items[n] do
      begin
       if Level=1 then
        begin
         p:=PENVENTRYDELPHI(Data);
         if p.mac<>'' then
          begin
           try
            reg.WriteString(p.machine_loc+'\'+p.machine_desc+'\'+p.comp_name,p.ip+'\'+p.mac);
           except end; 
          end;
        end;
      end;
    reg.CloseKey;
   end;
 reg.Free;
end;

procedure TRSOperatorForm.Timer1Timer(Sender: TObject);
begin
 if Visible and (Screen.Cursor<>crHourGlass) then
  begin
   UpdateServerStatus();
   UpdateCompList();
  end;
end;

procedure TRSOperatorForm.TreeViewCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
var p1,p2:PENVENTRYDELPHI;
    level:integer;
begin
 Compare:=0;

 if (Node1.Level=Node2.Level) and (Node1.Parent=Node2.Parent) then
  begin
   level:=Node1.Level;
   p1:=PENVENTRYDELPHI(Node1.Data);
   p2:=PENVENTRYDELPHI(Node2.Data);
   if (p1<>nil) and (p2<>nil) then
    begin
     if level=0 then
      begin
       Compare:=AnsiCompareText(p1.machine_loc,p2.machine_loc);
      end
     else
     if level=1 then
      begin
       Compare:=AnsiCompareText(p1.machine_desc,p2.machine_desc);
      end
     else
     if level=2 then
      begin
       Compare:=AnsiCompareText(p1.domain+'\'+p1.user_name,p2.domain+'\'+p2.user_name);
      end;
    end;
  end;
end;

procedure TRSOperatorForm.TreeViewDeletion(Sender: TObject;
  Node: TTreeNode);
var p:PENVENTRYDELPHI;
begin
 if node<>nil then
  if node.Data<>nil then
   begin
    p:=PENVENTRYDELPHI(node.Data);
    Dispose(p);
    node.Data:=nil;
   end;
end;

procedure TRSOperatorForm.TreeViewAddition(Sender: TObject;
  Node: TTreeNode);
begin
 Node.Data:=nil;
 Node.ImageIndex:=Node.Level;
 Node.SelectedIndex:=Node.Level;
 Node.OverlayIndex:=Node.Level;
end;

procedure TRSOperatorForm.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var node:TTreeNode;
begin
 if (not (ssCtrl in Shift)) and (not (ssShift in Shift)) then
  begin
   if Button=mbLeft then
    begin
     node:=TreeView.GetNodeAt(x,y);
     if node<>nil then
      begin
       TreeView.Select([node]);
       UpdateMachinesPage();
      end;
    end;
  end;
end;

procedure TRSOperatorForm.ButtonRefreshClick(Sender: TObject);
begin
 UpdateCompList();
end;

procedure TRSOperatorForm.TreeViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
 Handled:=true;
end;

procedure TRSOperatorForm.TreeViewMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var node:TTreeNode;
    p:TPoint;
begin
 if Button=mbRight then
  begin
   node:=TreeView.GetNodeAt(x,y);
   if (node<>nil) and (not node.Selected) then
    TreeView.Select([node]);
   UpdateMachinesPage();
   if TreeView.SelectionCount>0 then
    begin
     p.x:=x;
     p.y:=y;
     p:=TreeView.ClientToScreen(p);
     FPopup.Popup(p.x,p.y);
    end;
  end;
end;

procedure TRSOperatorForm.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var x,y:integer;
begin
 with StatusBar.Canvas do
  begin
   Font.Style:=[fsBold];
   Font.Color:=clRed;
   x:=rect.Left + 1;
   y:=rect.Top + ((rect.Bottom-rect.Top - TextHeight(Panel.Text)) div 2);
   TextRect(rect,x,y,Panel.Text);
  end;
end;


initialization
 msg_login:=RegisterWindowMessage('_RSOperatorFormLogin');
 msg_close:=RegisterWindowMessage('_RSOperatorFormClose');
end.
