unit startup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, ExtCtrls;

type
     TSTRING = array [0..MAX_PATH-1] of char;

     TStartupInfo = record
      small_icon : cardinal;
      big_icon : cardinal;
      sql_server : TSTRING;
      dbtype_rp : integer;
      runpad_server : TSTRING;
      autorun : longbool;
     end;
     PStartupInfo = ^TStartupInfo;


type
  TRSStartupForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    ButtonNext: TButton;
    ButtonPrev: TButton;
    ButtonCancel: TButton;
    Panel3: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    TabSheet5: TTabSheet;
    Label8: TLabel;
    Memo1: TMemo;
    Label13: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonNextClick(Sender: TObject);
    procedure ButtonPrevClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TabSheet4Show(Sender: TObject);
  private
    { Private declarations }
    info : PStartupInfo;
    can_close : boolean;
    procedure SwitchToPage(idx:integer);
    procedure UpdateButtons;
  public
    { Public declarations }
    constructor CreateForm(p:PStartupInfo);
    destructor Destroy(); override;
  end;


function ShowStartupMasterDialog(p:PStartupInfo):boolean;


implementation

uses tools, lang, h_sql;

{$R *.dfm}


function ShowStartupMasterDialog(p:PStartupInfo):boolean;
var f:TRSStartupForm;
begin
 f:=TRSStartupForm.CreateForm(p);
 Result:=f.ShowModal=idok;
 f.Free;
end;


constructor TRSStartupForm.CreateForm(p:PStartupInfo);
var n:integer;
begin
 inherited Create(nil);

 info:=p;
 can_close:=false;

 Caption:='Мастер установок Runpad Pro Оператор';
 Label1.Caption:='Нажмите "Далее" для запуска мастера';
 Label6.Caption:='Имя машины с SQL-базой:';
 Label13.Caption:='Тип базы:';
 Label3.Caption:='Сервер Runpad Pro:';
 CheckBox1.Caption:='Добавить программу оператора в автозагрузку';
 Label8.Caption:='Работа мастера завершена!'#13#10#13#10'Мастер всегда можно запустить повторно из-под учетной записи администратора для изменения настроек'#13#10#13#10#13#10#13#10#13#10'-------'#13#10'Нажмите "Завершить" для выхода';

 Edit3.Text:=info.sql_server;
 ComboBox1.ItemIndex:=info.dbtype_rp;
 Edit1.Text:=info.runpad_server;
 CheckBox1.Checked:=info.autorun;

 SwitchToPage(0);
 for n:=0 to PageControl.PageCount-1 do
  PageControl.Pages[n].TabVisible:=false;
 SwitchToPage(0);

 SendMessage(Handle, WM_SETICON, ICON_SMALL, info.small_icon);
 SendMessage(Handle, WM_SETICON, ICON_BIG, info.big_icon);
end;

destructor TRSStartupForm.Destroy();
begin
 if ModalResult=mrOk then
  begin
   StrCopy(info.sql_server,pchar(Edit3.Text));
   StrCopy(info.runpad_server,pchar(Edit1.Text));
   info.dbtype_rp:=ComboBox1.ItemIndex;
   info.autorun:=CheckBox1.Checked;
  end;

 SendMessage(Handle, WM_SETICON, ICON_SMALL, 0);
 SendMessage(Handle, WM_SETICON, ICON_BIG, 0);

 inherited;
end;

procedure TRSStartupForm.UpdateButtons;
var page,numpages:integer;
    s_cancel,s_next,s_prev,s_finish:string;
begin
 s_next:='Далее >>';
 s_prev:='<< Назад';
 s_finish:='Завершить';
 s_cancel:='Отмена';

 page:=PageControl.ActivePageIndex;
 numpages:=PageControl.PageCount;

 if page=0 then
  begin
   ButtonPrev.Visible:=false;
   ButtonNext.Visible:=true;
   ButtonNext.Caption:=s_next;
   ButtonCancel.Visible:=true;
   ButtonCancel.Caption:=s_cancel;
  end
 else
 if page=numpages-1 then
  begin
   ButtonPrev.Visible:=false;
   ButtonCancel.Visible:=false;
   ButtonNext.Visible:=true;
   ButtonNext.Caption:=s_finish;
  end
 else
  begin
   ButtonCancel.Visible:=true;
   ButtonCancel.Caption:=s_cancel;
   ButtonPrev.Visible:=true;
   ButtonPrev.Caption:=s_prev;
   ButtonNext.Visible:=true;
   ButtonNext.Caption:=s_next;
  end;

 try
  ButtonNext.SetFocus;
 except end;
end;

procedure TRSStartupForm.SwitchToPage(idx:integer);
begin
 if PageControl.ActivePageIndex<>idx then
  PageControl.ActivePageIndex:=idx;
end;

procedure TRSStartupForm.FormShow(Sender: TObject);
begin
 SetForegroundWindow(Handle);
 UpdateButtons;
end;

procedure TRSStartupForm.ButtonNextClick(Sender: TObject);
var page,numpages:integer;
begin
 page:=PageControl.ActivePageIndex;
 numpages:=PageControl.PageCount;

 if page=numpages-1 then
  begin
   can_close:=true;
   ModalResult:=mrOk;
  end
 else
  begin
   inc(page);
   PageControl.ActivePageIndex:=page;
   UpdateButtons;
  end;
end;

procedure TRSStartupForm.ButtonPrevClick(Sender: TObject);
var page:integer;
begin
 page:=PageControl.ActivePageIndex;
 if page>0 then
  begin
   dec(page);
   PageControl.ActivePageIndex:=page;
   UpdateButtons;
  end;
end;

procedure TRSStartupForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=can_close or (ButtonCancel.Visible and ButtonCancel.Enabled);
 if CanClose and ButtonCancel.Visible then
  begin
   if MessageBox(Handle,'Прервать работу мастера?','Вопрос',MB_YESNO or MB_DEFBUTTON2 or MB_ICONQUESTION)<>IDYES then
    CanClose:=false;
  end;
end;

procedure TRSStartupForm.TabSheet4Show(Sender: TObject);
var rp:string;
begin
 if ComboBox1.ItemIndex<>-1 then
  rp:=ComboBox1.Items[ComboBox1.ItemIndex]
 else
  rp:='';

 Memo1.Clear;
 Memo1.Lines.Add(Label6.Caption);
 Memo1.Lines.Add(' '+Edit3.Text);
 Memo1.Lines.Add(Label13.Caption);
 Memo1.Lines.Add(' '+rp);
 Memo1.Lines.Add(Label3.Caption);
 Memo1.Lines.Add(' '+Edit1.Text);
 Memo1.Lines.Add('Автозагрузка:');
 if CheckBox1.Checked then
  Memo1.Lines.Add(' '+'Да')
 else
  Memo1.Lines.Add(' '+'Нет');
end;

end.
