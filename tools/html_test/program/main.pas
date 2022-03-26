unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, desk, StdCtrls, ExtCtrls, CheckLst, ComCtrls, StrUtils, ShellApi, Registry, tools, XPMan;

//{$DEFINE SAVE_LAST_URL}

type
  TMainForm = class(TForm)
    Label1: TLabel;
    EditURL: TEdit;
    Label2: TLabel;
    EditSheetName: TEdit;
    Label3: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label4: TLabel;
    EditStatus: TEdit;
    Label5: TLabel;
    EditVIP: TEdit;
    Label6: TLabel;
    MemoText: TMemo;
    ButtonRefresh: TButton;
    ListViewSheets: TListView;
    Label7: TLabel;
    EditSheetPic: TEdit;
    Label8: TLabel;
    EditMachineDesc: TEdit;
    XPManifest1: TXPManifest;
    ButtonSet: TButton;
    ButtonReset: TButton;
    Label9: TLabel;
    EditMachineLoc: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSheetsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewSheetsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditStatusChange(Sender: TObject);
    procedure ButtonSetClick(Sender: TObject);
    procedure ButtonResetClick(Sender: TObject);
  private
    { Private declarations }
    dsk : TRSDeskForm;
    allow_change : boolean;

    function GetSheetItemByNum(idx:integer):TListItem;
  public
    { Public declarations }
    function  GetMachineLoc : pchar;
    function  GetMachineDesc : pchar;
    function  GetVipSessionName : pchar;
    function  GetStatusString : pchar;
    function  GetInfoText : pchar;
    function  GetNumSheets : integer;
    function  GetSheetName(idx:integer) : pchar;
    function  IsSheetActive (idx:integer) : longbool;
    procedure SetSheetActive(idx:integer;active:longbool);
    function  GetSheetBGPic(idx:integer) : pchar;
    function  IsPageShaded() : longbool;
    procedure DoShellExec(const _exe,_args:pchar);
    function GetInputText(const title,text:pchar):pchar;
    procedure Alert(const text:pchar);
    function GetInputTextPos(pwdchar:char;x,y,w,h,maxlen:integer;const intext:pchar):pchar;

    procedure WMHotkey(var Message: TWMHotkey); message WM_HOTKEY;

    procedure SwitchShowHide;
  end;

var
    MainForm : TMainForm = nil;


implementation

uses textbox, inputpos;

{$R *.dfm}

var
    conn : TDeskExternalConnection;


function  G_GetMachineLoc : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetMachineLoc
 else
  Result:='';
end;

function  G_GetMachineDesc : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetMachineDesc
 else
  Result:='';
end;

function  G_GetVipSessionName : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetVipSessionName
 else
  Result:='';
end;

function  G_GetStatusString : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetStatusString
 else
  Result:='';
end;

function  G_GetInfoText : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetInfoText
 else
  Result:='';
end;

function  G_GetNumSheets : integer; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetNumSheets
 else
  Result:=0;
end;

function  G_GetSheetName(idx:integer) : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetSheetName(idx)
 else
  Result:='';
end;

function  G_IsSheetActive (idx:integer) : longbool; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.IsSheetActive(idx)
 else
  Result:=false;
end;

procedure G_SetSheetActive(idx:integer;active:longbool); cdecl;
begin
 if assigned(MainForm) then
  MainForm.SetSheetActive(idx,active);
end;

function  G_GetSheetBGPic(idx:integer) : pchar; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetSheetBGPic(idx)
 else
  Result:='';
end;

function  G_IsPageShaded () : longbool; cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.IsPageShaded()
 else
  Result:=false;
end;

procedure G_DoShellExec(const exe,args:pchar); cdecl;
begin
 if assigned(MainForm) then
  MainForm.DoShellExec(exe,args);
end;

function G_GetInputText(const title,text:pchar):pchar cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetInputText(title,text)
 else
  Result:=nil;
end;

procedure G_Alert(const text:pchar) cdecl;
begin
 if assigned(MainForm) then
  MainForm.Alert(text);
end;

function G_GetInputTextPos(pwdchar:char;x,y,w,h,maxlen:integer;const intext:pchar):pchar cdecl;
begin
 if assigned(MainForm) then
  Result:=MainForm.GetInputTextPos(pwdchar,x,y,w,h,maxlen,intext)
 else
  Result:=nil;
end;


var buff : array [0..1024] of char;

function s2p(s:string):pchar;
begin
 StrLCopy(buff,pchar(s),sizeof(buff)-1);
 Result:=buff;
end;

function TMainForm.GetSheetItemByNum(idx:integer):TListItem;
var n,i:integer;
begin
  Result:=nil;
  i:=0;
  for n:=0 to ListViewSheets.Items.Count-1 do
   if trim(ListViewSheets.Items[n].Caption)<>'' then
    begin
     if i=idx then
      begin
       Result:=ListViewSheets.Items[n];
       break;
      end;
     inc(i);
    end;
end;

function  TMainForm.GetMachineLoc : pchar;
begin
  Result:=s2p(EditMachineLoc.Text);
end;

function  TMainForm.GetMachineDesc : pchar;
begin
  Result:=s2p(EditMachineDesc.Text);
end;

function  TMainForm.GetVipSessionName : pchar;
begin
  Result:=s2p(EditVIP.Text);
end;

function  TMainForm.GetStatusString : pchar;
begin
  Result:=s2p(Editstatus.Text);
end;

function  TMainForm.GetInfoText : pchar;
begin
  Result:=s2p(MemoText.Text);
end;

function  TMainForm.GetNumSheets : integer;
var n,count:integer;
begin
  count:=0;
  for n:=0 to ListViewSheets.Items.Count-1 do
   if GetSheetItemByNum(n)<>nil then
    inc(count);
  Result:=count;
end;

function  TMainForm.GetSheetName(idx:integer) : pchar;
var item:TListItem;
begin
  Result:='';
  item:=GetSheetItemByNum(idx);
  if item<>nil then
   Result:=s2p(item.Caption);
end;

function  TMainForm.IsSheetActive (idx:integer) : longbool;
var item:TListItem;
begin
  Result:=false;
  item:=GetSheetItemByNum(idx);
  if item<>nil then
   Result:=item.Selected;
end;

procedure TMainForm.SetSheetActive(idx:integer;active:longbool);
var item:TListItem;
begin
  item:=GetSheetItemByNum(idx);
  if item<>nil then
   item.Selected:=active;
end;

function  TMainForm.GetSheetBGPic(idx:integer) : pchar;
var item:TListItem;
begin
  Result:='';
  item:=GetSheetItemByNum(idx);
  if item<>nil then
   Result:=s2p(item.SubItems[0]);
end;

function  TMainForm.IsPageShaded () : longbool;
begin
  Result:=ParamCount>0; //!!!
end;

procedure TMainForm.DoShellExec(const _exe,_args:pchar);
var exe,args:string;
    p:array[0..1024]of char;
begin
 exe:=string(_exe);
 args:=string(_args);

 if exe<>'' then
  begin
   if AnsiStartsText('http:',exe) or
      AnsiStartsText('https:',exe) or
      AnsiStartsText('ftp:',exe) or
      AnsiStartsText('mailto:',exe) or
      AnsiStartsText('callto:',exe) then
    begin
     ShellExecute(0,nil,_exe,nil,nil,SW_SHOWNORMAL);
    end
   else
    begin
     exe:=AnsiReplaceText(exe,'/','\');
     StrCopy(p,pchar(exe));
     DoEnvironmentSubst(p,sizeof(p));
     exe:=p;

     if args='' then
      ShellExecute(0,nil,pchar(exe),nil,pchar(ExtractFilePath(exe)),SW_SHOWNORMAL)
     else
      ShellExecute(0,nil,pchar(exe),_args,pchar(ExtractFilePath(exe)),SW_SHOWNORMAL);
    end;
  end;
end;

function TMainForm.GetInputText(const title,text:pchar):pchar;
var out_text:string;
begin
 out_text:='';
 if ShowTextBoxFormModal(out_text,title,text,'',1000) then
  Result:=s2p(out_text)
 else
  Result:=nil;
end;

procedure TMainForm.Alert(const text:pchar);
begin
 MessageBox(Handle,text,'Информация',MB_OK or MB_ICONWARNING);
end;

function TMainForm.GetInputTextPos(pwdchar:char;x,y,w,h,maxlen:integer;const intext:pchar):pchar;
var inout:string;
begin
 inout:=intext;
 if ShowInputPosFormModal(pwdchar,x,y,w,h,maxlen,inout) then
  Result:=s2p(inout)
 else
  Result:=s2p(string(intext));
end;


procedure TMainForm.WMHotkey(var Message: TWMHotkey);
begin
 if Message.HotKey = 1 then
   SwitchShowHide;
 Message.Result:=0;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var n:integer;
    item:TListItem;
    curr_dir,last_url:string;
    reg:TRegistry;
begin
 allow_change:=false;

 reg:=TRegistry.Create(KEY_READ);
 last_url:=ReadRegStr(reg,'Software\RunpadProClientHTMLTest','last_url','');
 reg.Free;
 if last_url='' then
  begin
   curr_dir:=IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
   last_url:=curr_dir+'default\themes\01\index.html';
  end;

 EditURL.Text:=last_url;

 ListViewSheets.Items.Clear;
 for n:=0 to 49 do
  begin
   item:=ListViewSheets.Items.Add;
   if n < 9 then
    begin
     item.Caption:='Закладка '+inttostr(n+1);
     item.SubItems.Add(curr_dir+'default\bg\pic0'+inttostr(n+1)+'.jpg');
    end
   else
    begin
     item.Caption:='';
     item.SubItems.Add('');
    end;
  end;
 ListViewSheets.Selected:=nil;

 EditSheetName.Text:='';
 EditSheetPic.Text:='';

 EditStatus.Text:='Это статусная строка';
 EditVIP.Text:='';
 EditMachineDesc.Text:='25';
 EditMachineLoc.Text:='Организация';

 conn.OnDocumentComplete:=nil;
 conn.OnRClick:=nil;
 conn.OnMouseDown:=nil;
 conn.GetMachineLoc:=G_GetMachineLoc;
 conn.GetMachineDesc:=G_GetMachineDesc;
 conn.GetVipSessionName:=G_GetVipSessionName;
 conn.GetStatusString:=G_GetStatusString;
 conn.GetInfoText:=G_GetInfoText;
 conn.GetNumSheets:=G_GetNumSheets;
 conn.GetSheetName:=G_GetSheetName;
 conn.IsSheetActive:=G_IsSheetActive;
 conn.SetSheetActive:=G_SetSheetActive;
 conn.GetSheetBGPic:=G_GetSheetBGPic;
 conn.IsPageShaded:=G_IsPageShaded;
 conn.DoShellExec:=G_DoShellExec;
 conn.GetInputText:=G_GetInputText;
 conn.Alert:=G_Alert;
 conn.GetInputTextPos:=G_GetInputTextPos;

 dsk:=TRSDeskForm.MyCreate(@conn);

 Left:=Screen.Width - Width - 20;
 Top:=(Screen.Height - Height) div 2;

 RegisterHotKey(Handle,1,MOD_WIN,VK_F12);

 allow_change:=true;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not dsk.MyIsVisible then
   begin
    dsk.MyShow;
    dsk.MyNavigate(EditUrl.Text);
    EditUrl.SetFocus;
   end
  else
   begin
    try
     ListViewSheets.ItemFocused:=ListViewSheets.Selected;
    except end;
   end;

  SetForegroundWindow(Handle);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
{$IFDEF SAVE_LAST_URL}
var reg:TRegistry;
{$ENDIF}
begin
{$IFDEF SAVE_LAST_URL}
 reg:=TRegistry.Create(KEY_WRITE);
 WriteRegStr(reg,'Software\RunpadProClientHTMLTest','last_url',EditURL.Text);
 reg.Free;
{$ENDIF}

 allow_change:=false;
 UnregisterHotKey(Handle,1);
 FreeAndNil(dsk);
end;

procedure TMainForm.ListViewSheetsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TMainForm.ListViewSheetsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var i : TListItem;
begin
 if not allow_change then
  exit;

 i:=ListViewSheets.Selected;

 if i=nil then
  begin
   EditSheetName.Text:='';
   EditSheetPic.Text:='';
  end
 else
  begin
   EditSheetName.Text:=i.Caption;
   EditSheetPic.Text:=i.SubItems[0];
  end;

 Update;
 dsk.MyOnActiveSheetChanged;
end;

procedure TMainForm.ButtonRefreshClick(Sender: TObject);
begin
 dsk.MyNavigate(EditURL.Text);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  Close;
end;

procedure TMainForm.EditStatusChange(Sender: TObject);
begin
 if visible then
  dsk.MyOnStatusStringChanged;
end;

procedure TMainForm.SwitchShowHide;
begin
 if Visible then
  Hide
 else
  Show;
end;

procedure TMainForm.ButtonSetClick(Sender: TObject);
var i : TListItem;
begin
 i:=ListViewSheets.Selected;

 if i<>nil then
  begin
   allow_change:=false;
   i.Caption:=EditSheetName.Text;
   i.SubItems[0]:=EditSheetPic.Text;
   Update;
   allow_change:=true;
   dsk.MyRefresh;
  end;
end;

procedure TMainForm.ButtonResetClick(Sender: TObject);
begin
 EditSheetName.Text:='';
 EditSheetPic.Text:='';
 ButtonSetClick(Sender);
end;

end.
