unit startup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, StdCtrls, ExtCtrls;

type
     TSTRING = array [0..MAX_PATH-1] of char;
     TGetLicInfo = procedure(lic_organization,lic_owner,lic_machines,lic_type,lic_modules:ppchar); cdecl;
     TSetLicKey = procedure(key:pchar); cdecl;

     TStartupInfo = record
      GetLicInfo : TGetLicInfo;
      SetLicKey : TSetLicKey;
      small_icon : cardinal;
      big_icon : cardinal;
      server_name : TSTRING;
      dbtype_rp : integer;
      dbtype_gc : integer;
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
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    TabSheet5: TTabSheet;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Memo1: TMemo;
    Label13: TLabel;
    ComboBox1: TComboBox;
    Label14: TLabel;
    ComboBox2: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
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
    procedure UpdateLicInfo;
  public
    { Public declarations }
    constructor CreateForm(p:PStartupInfo);
    destructor Destroy(); override;
  end;


function ShowStartupMasterDialog(p:PStartupInfo):longbool; cdecl;


implementation

{$R *.dfm}


{$INCLUDE ..\..\admin\sql\h_sql.inc}


function GetLocalPath(local:string):string;
var s:array[0..MAX_PATH] of char;
begin
 s[0]:=#0;
 GetModuleFileName(hInstance,s,sizeof(s));
 Result:=IncludeTrailingPathDelimiter(ExtractFilePath(s))+local;
end;


function ShowStartupMasterDialog(p:PStartupInfo):longbool; cdecl;
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

 Caption:='Мастер установок Runpad Pro Сервер';
 Label1.Caption:='Нажмите "Далее" для запуска мастера';
 GroupBox1.Caption:=' Информация о лицензии ';
 Label3.Caption:='Организация:';
 Label4.Caption:='Владелец:';
 Label5.Caption:='Кол-во копий:';
 Label7.Caption:='Тип лицензии:';
 Label15.Caption:='Модули:';
 Label6.Caption:='Имя машины с SQL-базой:';
 Label13.Caption:='База Runpad Pro:';
 Label14.Caption:='База GameClass:';
 Label8.Caption:='Работа мастера завершена!'#13#10#13#10'Мастер всегда можно запустить повторно из-под учетной записи администратора для изменения настроек'#13#10#13#10#13#10#13#10#13#10'-------'#13#10'Нажмите "Завершить" для выхода';

 UpdateLicInfo();

 Edit3.Text:=info.server_name;
 ComboBox1.ItemIndex:=info.dbtype_rp;
 ComboBox2.ItemIndex:=info.dbtype_gc;

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
   StrCopy(info.server_name,pchar(Edit3.Text));
   info.dbtype_rp:=ComboBox1.ItemIndex;
   info.dbtype_gc:=ComboBox2.ItemIndex;
  end;

 SendMessage(Handle, WM_SETICON, ICON_SMALL, 0);
 SendMessage(Handle, WM_SETICON, ICON_BIG, 0);

 inherited;
end;

procedure TRSStartupForm.UpdateLicInfo;
var lic_organization,lic_owner,lic_machines,lic_type,lic_modules:pchar;
begin
 lic_organization:=nil;
 lic_owner:=nil;
 lic_machines:=nil;
 lic_type:=nil;
 lic_modules:=nil;

 info.GetLicInfo(@lic_organization,@lic_owner,@lic_machines,@lic_type,@lic_modules);

 Label9.Caption:=lic_organization;
 Label10.Caption:=lic_owner;
 Label11.Caption:=lic_machines;
 Label12.Caption:=lic_type;
 Label16.Caption:=lic_modules;
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
var rp,gc:string;
begin
 if ComboBox1.ItemIndex<>-1 then
  rp:=ComboBox1.Items[ComboBox1.ItemIndex]
 else
  rp:='';
 if ComboBox2.ItemIndex<>-1 then
  gc:=ComboBox2.Items[ComboBox2.ItemIndex]
 else
  gc:='';

 Memo1.Clear;
 Memo1.Lines.Add(Label3.Caption);
 Memo1.Lines.Add(' '+Label9.Caption);
 Memo1.Lines.Add(Label4.Caption);
 Memo1.Lines.Add(' '+Label10.Caption);
 Memo1.Lines.Add(Label5.Caption);
 Memo1.Lines.Add(' '+Label11.Caption);
 Memo1.Lines.Add(Label7.Caption);
 Memo1.Lines.Add(' '+Label12.Caption);
 Memo1.Lines.Add(Label15.Caption);
 Memo1.Lines.Add(' '+Label16.Caption);
 Memo1.Lines.Add(Label6.Caption);
 Memo1.Lines.Add(' '+Edit3.Text);
 Memo1.Lines.Add(Label13.Caption);
 Memo1.Lines.Add(' '+rp);
 Memo1.Lines.Add(Label14.Caption);
 Memo1.Lines.Add(' '+gc);
end;

end.
