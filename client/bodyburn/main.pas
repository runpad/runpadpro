unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, frame1, frame2,
  frame3, frame4;

type
  TBodyBurnForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Panel4: TPanel;
    ButtonBack: TBitBtn;
    ButtonForward: TBitBtn;
    Page1: TPage1;
    Page2: TPage2;
    Page3: TPage3;
    Page4: TPage4;
    ButtonBurn: TBitBtn;
    ButtonStop: TBitBtn;
    Image1: TImage;
    LabelTitle: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonForwardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonBurnClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure AddFilesFromCommandLine;
  private
    { Private declarations }
    procedure WMDropFiles(var M: TWMDropFiles); message WM_DROPFILES;
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure AcceptFiles(hDrop: THandle);
    procedure AddFileToWrite(s:string);
    procedure SwitchToPage(num:integer);
    procedure GoBack;
    procedure GoForward;
    procedure CollectDrivesInfo;
    function GetPageNum:integer;
    procedure OnSuccessBurn(is_dvd:boolean;total_size:integer;title:string);
    procedure UpdateButtonsFocus;
  public
    { Public declarations }
    procedure DefaultHandler(var Message); override;
  end;

const
   ADD_MESSAGE_NAME = 'TBodyBurnForm.AddFile';

var
  BodyBurnForm: TBodyBurnForm;


implementation

uses shellapi, global;

{$R *.dfm}
{$INCLUDE bodyburn.inc}

var
    user_message : cardinal = 0;
    last_net_file : string = '';


procedure TBodyBurnForm.DefaultHandler(var Message);
var
  s: string;
  buf: array[0..256] of char;
begin
  with TMessage(Message) do
    if msg=user_message then
      begin
        if wParam<>0 then
         begin
          buf[0]:=#0;
          GlobalGetAtomName(wParam, buf, 255);
          GlobalDeleteAtom(wParam);
          s:=buf;
          if (s<>'') and (GetPageNum()=1) and (Visible) then
           AddFileToWrite(s);
         end;
      end
    else
      inherited;
end;

function IdleCallback(parm:pointer):longbool; cdecl;
begin
 Application.ProcessMessages;
 Result:=false;//ignored
end;

function UserDialog(parm:pointer;typ:integer;data:pointer):integer; cdecl;
begin
 Result:=DLG_RETURN_EXIT;

 if typ=DLG_NON_EMPTY_CDRW then
  begin
   MessageBox(BodyBurnForm.Handle,'Данный RW-диск не пустой'#13#10'Необходимо сначала очистить его перед записью','Ошибка',MB_OK or MB_ICONERROR);
   Result:=DLG_RETURN_EXIT;
  end
 else
 if typ=DLG_FILESEL_IMAGE then
  begin
   if (IsNetBurn()) and (data<>nil) then
    begin
     last_net_file:=GetNetBurnFile();
     StrCopy(pchar(data),pchar(last_net_file));
     Result:=DLG_RETURN_TRUE;
    end
   else
    begin
     MessageBox(BodyBurnForm.Handle,'Операция запрещена','Ошибка',MB_OK or MB_ICONERROR);
     Result:=DLG_RETURN_EXIT;
    end;
  end
 else
 if typ=DLG_WAITCD then
  begin
   MessageBox(BodyBurnForm.Handle,'Вставьте необходимый диск в привод и нажмите "Ok"'#13#10'Возможно диск отсутствует, имеет неверный формат'#13#10'или является не пустым','Информация',MB_OK or MB_ICONINFORMATION);
   Result:=DLG_RETURN_EXIT;
  end;
end;

procedure TBodyBurnForm.AddFilesFromCommandLine;
var i:integer;
begin
 for i:=1 to ParamCount do
   AddFileToWrite(ParamStr(i));
end;

procedure TBodyBurnForm.FormCreate(Sender: TObject);
begin
 user_message := RegisterWindowMessage(ADD_MESSAGE_NAME);

 Page1.OnCreate(self);
 Page2.OnCreate(self);
 Page3.OnCreate(self);
 Page4.OnCreate(self);

 DragAcceptFiles(Handle,TRUE);
 SwitchToPage(1);

 ButtonBack.Visible:=false;
 ButtonForward.Visible:=true;
 ButtonBurn.Visible:=false;
 ButtonStop.Visible:=false;

 ButtonBurn.Enabled:=true;

 AddFilesFromCommandLine;
 
 BurnInit(IdleCallback,UserDialog,self);
end;

procedure TBodyBurnForm.FormDestroy(Sender: TObject);
begin
 BurnDone();
end;

procedure TBodyBurnForm.WMQueryEndSession(var M: TWMQueryEndSession);
begin
 if (GetPageNum=4) and (ButtonStop.Visible) then
  M.Result:=0
 else
  M.Result:=1;
end;

procedure TBodyBurnForm.WMDropFiles(var M: TWMDropFiles);
begin
  AcceptFiles(M.Drop);
  DragFinish(M.Drop);
  M.Result := 0;
end;

procedure TBodyBurnForm.AcceptFiles(hDrop: THandle);
var
  p : array [0..MAX_PATH] of char;
  i,numfiles: integer;
  s : string;
begin
  numfiles := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

  for i:=0 to numfiles - 1 do
    begin
      p[0]:=#0;
      DragQueryFile(hDrop, i, p, MAX_PATH);
      s:=string(p);
      if (s<>'') and (GetPageNum()=1) then
       AddFileToWrite(s);
    end;
end;

procedure TBodyBurnForm.AddFileToWrite(s:string);
begin
 Page1.AddFileToWrite(s);
end;

procedure TBodyBurnForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if (not ButtonForward.Enabled) and (not ButtonBack.Enabled) then
  CanClose:=false
 else
 if ButtonStop.Enabled and ButtonStop.Visible then
  begin
   CanClose:=false;
   ButtonStopClick(Sender);
  end
 else
 if (not ButtonStop.Enabled) and ButtonStop.Visible then
  CanClose:=false
 else
  CanClose:=true;
end;

procedure TBodyBurnForm.SwitchToPage(num:integer);
const actions : array[0..4] of string =
('Подождите...','Выбор файлов для записи','Выбор типа носителя','Параметры записи','Запись диска');
begin
 Page1.Visible:=false;
 Page2.Visible:=false;
 Page3.Visible:=false;
 Page4.Visible:=false;
 if num=1 then
  Page1.OnShow(self);
 if num=2 then
  Page2.OnShow(self);
 if num=3 then
  Page3.OnShow(self);
 if num=4 then
  Page4.OnShow(self);
 Page1.Visible:=(num=1);
 Page2.Visible:=(num=2);
 Page3.Visible:=(num=3);
 Page4.Visible:=(num=4);
 if num in [0..4] then
  LabelTitle.Caption:=actions[num]
 else
  LabelTitle.Caption:='';
end;

function TBodyBurnForm.GetPageNum:integer;
begin
 if Page1.Visible then
  Result:=1
 else
 if Page2.Visible then
  Result:=2
 else
 if Page3.Visible then
  Result:=3
 else
 if Page4.Visible then
  Result:=4
 else
  Result:=0;
end;

procedure TBodyBurnForm.UpdateButtonsFocus;
begin
 if ButtonForward.Enabled and ButtonForward.Visible then
  ButtonForward.SetFocus
 else
 if ButtonBurn.Enabled and ButtonBurn.Visible then
  ButtonBurn.SetFocus
 else
 if ButtonStop.Enabled and ButtonStop.Visible then
  ButtonStop.SetFocus
 else
 if ButtonBack.Enabled and ButtonBack.Visible then
  ButtonBack.SetFocus;
end;

procedure TBodyBurnForm.CollectDrivesInfo;
begin
 SwitchToPage(0);
 ButtonBack.Enabled:=false;
 ButtonForward.Enabled:=false;
 Screen.Cursor:=crHourGlass;
 Update;
 Application.ProcessMessages;
 Page3.CollectDrivesInfo(Page2.IsDVDSelected);
 ButtonBack.Enabled:=true;
 ButtonForward.Enabled:=true;
 Screen.Cursor:=crDefault;
 UpdateButtonsFocus();
end;

procedure TBodyBurnForm.GoBack;
var old_page,new_page : integer;
begin
 old_page:=GetPageNum();
 new_page:=old_page-1;
 SwitchToPage(new_page);
 ButtonBack.Visible:=new_page>1;
 if old_page=4 then
  begin
   ButtonBurn.Visible:=false;
   ButtonStop.Visible:=false;
   ButtonForward.Visible:=true;
  end;
 UpdateButtonsFocus();
end;

procedure TBodyBurnForm.GoForward;
var old_page,new_page : integer;
begin
 old_page:=GetPageNum();
 new_page:=old_page+1;
 if new_page>4 then
  new_page:=1;
 if new_page=3 then
  CollectDrivesInfo;
 SwitchToPage(new_page);
 ButtonBack.Visible:=new_page>1;
 if new_page=4 then
  begin
   ButtonForward.Visible:=false;
   ButtonBurn.Visible:=true;
  end;
 UpdateButtonsFocus();
end;

procedure TBodyBurnForm.FormShow(Sender: TObject);
begin
 UpdateButtonsFocus();
end;

procedure TBodyBurnForm.ButtonBackClick(Sender: TObject);
begin
 GoBack;
end;

procedure TBodyBurnForm.ButtonForwardClick(Sender: TObject);
begin
 GoForward;
end;

function ProgressCallback(parm:pointer;dwProgressInPercent:integer):longbool; cdecl;
begin
 BodyBurnForm.Page4.UpdateProgress(dwProgressInPercent);
 Application.ProcessMessages;
 Result:=false; //ignored
end;

procedure AddLogLine(parm:pointer;typ:integer;text:pchar); cdecl;
var idx:integer;
begin
 if text<>nil then
  begin
   if (typ=NERO_TEXT_STOP) then
    idx:=0
   else
   if (typ=NERO_TEXT_EXCLAMATION) or (typ=NERO_TEXT_DRIVE) or (typ=NERO_TEXT_FILE) then
    idx:=1
   else
    idx:=2;
   BodyBurnForm.Page4.AddLogLine(idx,string(text));
   Application.ProcessMessages;
  end;
end;

procedure SetPhaseCallback(parm:pointer;text:pchar); cdecl;
begin
 if text<>nil then
  begin
   BodyBurnForm.Page4.AddLogLine(-1,string(text));
   BodyBurnForm.Page4.UpdateProgress(0);
   Application.ProcessMessages;
  end;
end;

procedure TBodyBurnForm.ButtonBurnClick(Sender: TObject);
var flags,dev_num,speed:integer;
    flist:pchar;
    title:string;
    rc,verify,multi:boolean;
begin
 Page3.GetParams(dev_num,speed,title,multi,verify);

 if dev_num=-1 then
  begin
   MessageBox(Handle,'Не выбрано устройство записи'#13#10'Возможно Nero Burning Rom не установлен','Сообщение',MB_OK or MB_ICONINFORMATION);
   Exit;
  end;

 flist:=Page1.CreateFList();

 if flist=nil then
  begin
   MessageBox(Handle,'Не выбраны файлы для записи','Сообщение',MB_OK or MB_ICONINFORMATION);
   Exit;
  end;

 Page4.BeforeBurn;
 Page4.AddLogLine(-1,'Предварительная подготовка...');
 ButtonBack.Visible:=false;
 ButtonBurn.Visible:=false;
 ButtonStop.Visible:=true;
 UpdateButtonsFocus();
 Update;
 Application.ProcessMessages;

 flags:=0;
 if multi then
  flags:=flags or NBF_CLOSE_SESSION;
 if verify then
  flags:=flags or NBF_VERIFY;

 rc:=BurnDisc(dev_num,flist,pchar(title),flags,speed,self,ProgressCallback,AddLogLine,SetPhaseCallback,Page1.GetCDType());

 Page4.AfterBurn;
 Page1.FreeFList(flist);

 ButtonStop.Enabled:=true; //needed
 ButtonStop.Visible:=false;

 if rc then
  begin
   OnSuccessBurn(Page2.IsDVDSelected,Page1.GetTotalSize,title);
   if not IsNetBurn() then
    MessageBox(Handle,'Запись диска завершена!','Сообщение',MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(Handle,'Данные успешно скопированы на машину администратора и отправлено административное сообщение'#13#10#13#10'Обратитесь к администратору для получения записанного диска','Сообщение',MB_OK or MB_ICONINFORMATION);
  end
 else
  begin
   MessageBox(Handle,'Ошибка при записи диска'#13#10'См. консоль для детальной информации','Ошибка',MB_OK or MB_ICONERROR);
  end;

 ButtonForward.Visible:=true;
 UpdateButtonsFocus();
end;

procedure TBodyBurnForm.ButtonStopClick(Sender: TObject);
begin
 BurnAsyncCancelOperation();
 ButtonStop.Enabled:=false;
end;


procedure TBodyBurnForm.OnSuccessBurn(is_dvd:boolean;total_size:integer;title:string);
var atom : integer;
    flags : cardinal;
    w:HWND;
begin
  w:=FindWindow('_RunpadClass',nil);
  if w<>0 then
    begin
      atom:=GlobalAddAtom(pchar(title));
      flags:=total_size;
      if is_dvd then
       flags:=flags or $80000000;
      PostMessage(w,WM_USER+173,atom,flags);

      if IsNetBurn() then
        PostMessage(w,WM_USER+178,GlobalAddAtom(pchar(last_net_file)),0);
    end;
end;

end.
