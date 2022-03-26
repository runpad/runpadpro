unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ToolWin, StdCtrls, ExtCtrls, Menus,
  IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME, IdMessage,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP;

type
  TBodyMailForm = class(TForm)
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar1: TToolBar;
    ImageList: TImageList;
    ButtonSend: TToolButton;
    ToolButton2: TToolButton;
    ButtonImp: TToolButton;
    ButtonAtt: TToolButton;
    PanelBottom: TPanel;
    PanelImp: TPanel;
    PanelHeaders: TPanel;
    PanelNames: TPanel;
    PanelFields: TPanel;
    EditFromName: TEdit;
    EditFromAddress: TEdit;
    EditTo: TEdit;
    EditSubject: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PanelAtt: TPanel;
    PanelText: TPanel;
    Memo: TMemo;
    PopupMenu1: TPopupMenu;
    MenuDel: TMenuItem;
    Encoder64: TIdEncoderMIME;
    IdSMTP: TIdSMTP;
    procedure FormCreate(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonImpClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditSubjectChange(Sender: TObject);
    procedure ButtonAttClick(Sender: TObject);
    procedure AttClick(Sender: TObject);
    procedure MenuDelClick(Sender: TObject);
    procedure IdSMTPWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
  private
    { Private declarations }
    click_att:integer;
    imp:integer;
    atts:TStringList;
    labels:array of TLabel;
    procedure EnableAtts;
    procedure DisableAtts;
    procedure UpdateAtts;
    procedure AddAtt(s:string);
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMDropFiles(var M: TWMDropFiles); message WM_DROPFILES;
    procedure AcceptFiles(hDrop: THandle);
    procedure SetStatus(s:string);
    procedure SendMail;
    function PrepareBody(boundary:string):TStringList;
    function Win2Koi(const src:string):string;
    function Win2KoiCoded(const src:string):string;
    procedure OnSuccessMail(from_name,from_addr,to_addr,subj:string);
    procedure OnLanguageChange();
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  BodyMailForm: TBodyMailForm;
  mail_smtp : string = '';
  mail_user : string = '';
  mail_password : string = '';
  mail_port : integer = 25;
  mail_hardcoded : boolean = false;
  mail_from_name : string = '';
  mail_from_address : string = '';
  mail_footer : string = '';
  mail_to : string = '';



implementation

uses commctrl, shellapi, lang, opnsavf;

{$R *.dfm}

{$INCLUDE ..\rp_shared\RP_Shared.inc}

var  lang_change_message : cardinal;


procedure TBodyMailForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=lang_change_message then
   begin
     OnLanguageChange();
     Handled := True;
   end;
end;

procedure TBodyMailForm.OnLanguageChange();
begin
 ButtonSend.Hint:=S_BUTTONSEND;
 ButtonImp.Hint:=S_BUTTONIMP;
 ButtonAtt.Hint:=S_BUTTONATT;
 Label1.Caption:=S_LABEL1;
 Label2.Caption:=S_LABEL2;
 Label3.Caption:=S_LABEL3;
 Label4.Caption:=S_LABEL4;
 MenuDel.Caption:=S_MENUDEL;
end;

procedure TBodyMailForm.FormCreate(Sender: TObject);
var n:integer;
begin
 imp:=0;
 atts:=TStringList.Create;
 labels:=nil;

 lang_change_message := RegisterWindowMessage('_RPLanguageChanged');
 Application.OnMessage:=AppMessage;

 ImageList.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 5, 1);
 ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(100)));
 ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(101)));
 ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(102)));

 ButtonSend.Hint:=S_BUTTONSEND;
 ButtonImp.Hint:=S_BUTTONIMP;
 ButtonAtt.Hint:=S_BUTTONATT;
 Label1.Caption:=S_LABEL1;
 Label2.Caption:=S_LABEL2;
 Label3.Caption:=S_LABEL3;
 Label4.Caption:=S_LABEL4;
 MenuDel.Caption:=S_MENUDEL;
 Application.Title:=S_TITLE;
 Caption:=S_TITLE;

 if not mail_hardcoded then
  begin
   EditFromName.Text:='John Smith';
   EditFromAddress.Text:='john@smith.com';
  end
 else
  begin
   EditFromName.Text:=mail_from_name;
   EditFromAddress.Text:=mail_from_address;
   EditFromName.Enabled:=false;
   EditFromAddress.Enabled:=false;
  end;

 if mail_to='' then
  begin
   EditTo.Text:='man1@mail.ru, man2@domain.com';
   EditTo.Enabled:=true;
  end
 else
  begin
   EditTo.Text:=mail_to;
   EditTo.Enabled:=false;
  end;

 DragAcceptFiles(Handle,TRUE);

 idSMTP.Host:=mail_smtp;
 idSMTP.Port:=mail_port;
 idSMTP.Username:=mail_user;
 idSMTP.Password:=mail_password;
 if (mail_user<>'') and (mail_password<>'') then
  idSMTP.AuthenticationType:=atLogin
 else
  idSMTP.AuthenticationType:=atNone;

 for n:=1 to ParamCount do
  AddAtt(ParamStr(n));
end;

procedure TBodyMailForm.FormDestroy(Sender: TObject);
var n:integer;
begin
 DragAcceptFiles(Handle,FALSE);

 if assigned(labels) then
  begin
   for n:=0 to length(labels)-1 do
    if assigned(labels[n]) then
     begin
      labels[n].Free;
      labels[n]:=nil;
     end;
   labels:=nil;
  end;

 if Assigned(atts) then
  begin
   atts.Free;
   atts:=nil;
  end;
end;

procedure TBodyMailForm.FormShow(Sender: TObject);
begin
//
end;

procedure TBodyMailForm.FormConstrainedResize(Sender: TObject;
  var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
 MinWidth:=400;
 MinHeight:=400;
end;

procedure TBodyMailForm.FormResize(Sender: TObject);
var w:integer;
begin
 w:=PanelFields.Width - EditFromName.Left*2;
 EditFromName.Width:=w;
 EditFromAddress.Width:=w;
 EditTo.Width:=w;
 EditSubject.Width:=w;
end;

procedure TBodyMailForm.EnableAtts;
var n:integer;
begin
 if assigned(labels) then
  begin
   for n:=0 to length(labels)-1 do
    if assigned(labels[n]) then
      labels[n].Enabled:=true;
  end;
end;

procedure TBodyMailForm.DisableAtts;
var n:integer;
begin
 if assigned(labels) then
  begin
   for n:=0 to length(labels)-1 do
    if assigned(labels[n]) then
      labels[n].Enabled:=false;
  end;
end;

procedure TBodyMailForm.ButtonImpClick(Sender: TObject);
begin
 inc(imp);
 if imp>2 then
  imp:=0;
 if imp=0 then
  begin
   PanelImp.Caption:='';
   PanelImp.Visible:=false;
  end
 else
 if imp=1 then
  begin
   PanelImp.Caption:=S_IMP_HIGH;
   PanelImp.Visible:=true;
   PanelImp.Font.Color:=clRed;
  end
 else
  begin
   PanelImp.Caption:=S_IMP_LOW;
   PanelImp.Visible:=true;
   PanelImp.Font.Color:=clBlue;
  end;
end;

procedure TBodyMailForm.ButtonSendClick(Sender: TObject);
begin
 if (EditFromName.Text='') or (EditFromAddress.Text='') or (EditTo.Text='') then
  begin
   MessageBox(Handle,S_EMPTY_FIELDS,S_WARNING,MB_OK or MB_ICONWARNING);
  end
 else
  begin
   ButtonSend.Enabled:=false;
   ButtonImp.Enabled:=false;
   ButtonAtt.Enabled:=false;
   EditFromName.Enabled:=false;
   EditFromAddress.Enabled:=false;
   EditTo.Enabled:=false;
   EditSubject.Enabled:=false;
   Label1.Enabled:=false;
   Label2.Enabled:=false;
   Label3.Enabled:=false;
   Label4.Enabled:=false;
   DisableAtts;
   Memo.Enabled:=false;
   Update;
   Screen.Cursor:=crHourGlass;
   Application.ProcessMessages;

   SendMail();

   Screen.Cursor:=crDefault;
   ButtonSend.Enabled:=true;
   ButtonImp.Enabled:=true;
   ButtonAtt.Enabled:=true;
   if not mail_hardcoded then
    begin
     EditFromName.Enabled:=true;
     EditFromAddress.Enabled:=true;
    end;
   if mail_to='' then
    EditTo.Enabled:=true;
   EditSubject.Enabled:=true;
   Label1.Enabled:=true;
   Label2.Enabled:=true;
   Label3.Enabled:=true;
   Label4.Enabled:=true;
   EnableAtts;
   Memo.Enabled:=true;
  end;
end;

procedure TBodyMailForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if not ButtonImp.Enabled then
  CanClose:=false
 else
  begin
   if (Memo.Text<>'') or (EditSubject.Text<>'') or (atts.Count<>0) then
    CanClose:=true//MessageBox(handle,S_CAN_CLOSE,S_QUESTION,MB_YESNO or MB_ICONQUESTION)=idYES
   else
    CanClose:=true;
  end;
end;

procedure TBodyMailForm.WMQueryEndSession(var M: TWMQueryEndSession);
begin
  M.Result:=1;
end;

procedure TBodyMailForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  Close;
 if (key=ord('S')) and (ssAlt in Shift) then
  ButtonSendClick(Sender);
end;

procedure TBodyMailForm.WMDropFiles(var M: TWMDropFiles);
begin
  AcceptFiles(M.Drop);
  DragFinish(M.Drop);
  M.Result := 0;
end;

procedure TBodyMailForm.AcceptFiles(hDrop: THandle);
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
      if (s<>'') and (ButtonImp.Enabled) then
       AddAtt(s);
    end;
end;

procedure TBodyMailForm.AddAtt(s:string);
var n:integer;
begin
 if s<>'' then
  begin
   if FileExists(s) and (not DirectoryExists(s)) then
    begin
     atts.Add(s);
     if assigned(labels) then
      n:=length(labels)
     else
      n:=0;
     setlength(labels,n+1);
     labels[n]:=TLabel.Create(self);
     with labels[n] do
      begin
       Parent:=PanelAtt;
       Caption:=ExtractFileName(s)+' ('+inttostr(GetDirectorySize(pchar(s)))+' KB)';
       Font.Style:=[fsUnderline];
       Cursor:=crHandPoint;
       OnClick:=AttClick;
       ShowHint:=true;
       Hint:=S_ATT_HINT;
      end;
     UpdateAtts;
    end;
  end;
end;

procedure TBodyMailForm.UpdateAtts;
var n,c:integer;
begin
 if assigned(labels) then
  c:=length(labels)
 else
  c:=0;

 for n:=0 to c-1 do
  with labels[n] do
   begin
    Left:=8;
    Top:=8+(Height+2)*n;
    Tag:=n;
   end;

 if c>0 then
  begin
   PanelAtt.Height:=labels[c-1].Top+labels[c-1].Height+8;
   PanelAtt.Visible:=true;
  end
 else
  begin
   PanelAtt.Height:=8;
   PanelAtt.Visible:=false;
  end;
end;

procedure TBodyMailForm.EditSubjectChange(Sender: TObject);
var s:string;
begin
 s:=EditSubject.Text;
 if s='' then
  s:=S_TITLE;
 Caption:=s;
 Application.Title:=s;
end;

procedure TBodyMailForm.ButtonAttClick(Sender: TObject);
var s:string;
begin
 if OpenSaveForm.ExecuteOpenFile('*.*|*.*',s) and (s<>'') then
   AddAtt(s);
end;

procedure TBodyMailForm.AttClick(Sender: TObject);
var l:TLabel;
    p:TPoint;
begin
 l:=Sender as TLabel;
 click_att:=l.tag;
 GetCursorPos(p);
 PopupMenu1.Popup(p.x,p.y);
end;

procedure TBodyMailForm.MenuDelClick(Sender: TObject);
var n:integer;
begin
 atts.Delete(click_att);

 labels[click_att].Free;
 for n:=click_att to length(labels)-2 do
  labels[n]:=labels[n+1];
 setlength(labels,length(labels)-1);

 UpdateAtts;
end;

procedure TBodyMailForm.SetStatus(s:string);
begin
 StatusBar.Panels[0].Text:=s;
end;

const win2koi_t : array [0..255] of byte =
(
     $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,
     $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,
     $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,
     $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,
     $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,
     $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,
     $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,
     $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F,
     $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8A,$8B,$8C,$8D,$8E,$8F,
     $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9A,$9B,$9C,$9D,$9E,$9F,
     $A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7,$A8,$A9,$AA,$AB,$AC,$AD,$AE,$AF,
     $B0,$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$BA,$BB,$BC,$BD,$BE,$BF,
     $E1,$E2,$F7,$E7,$E4,$E5,$F6,$FA,$E9,$EA,$EB,$EC,$ED,$EE,$EF,$F0,
     $F2,$F3,$F4,$F5,$E6,$E8,$E3,$FE,$FB,$FD,$FF,$F9,$F8,$FC,$E0,$F1,
     $C1,$C2,$D7,$C7,$C4,$C5,$D6,$DA,$C9,$CA,$CB,$CC,$CD,$CE,$CF,$D0,
     $D2,$D3,$D4,$D5,$C6,$C8,$C3,$DE,$DB,$DD,$DF,$D9,$D8,$DC,$C0,$D1
);

function TBodyMailForm.Win2Koi(const src:string):string;
var s:string;
    n:integer;
begin
 s:='';
 for n:=1 to length(src) do
  s:=s+chr(win2koi_t[ord(src[n])]);
 Result:=s;
end;

function TBodyMailForm.Win2KoiCoded(const src:string):string;
var n:integer;
begin
 Result:=src;
 if src<>'' then
  begin
   for n:=1 to length(src) do
    if ord(src[n])>=128 then
     begin
      Result:='=?koi8-r?B?'+Encoder64.EncodeString(Win2Koi(src))+'?=';
      break;
     end;
  end;
end;


procedure AddMultiLineString2List(var list:TStringList;s:string);
var t:TStringList;
    n:integer;
begin
 t:=TStringList.Create;
 t.Text:=s;
 for n:=0 to t.Count-1 do
  list.Add(t.Strings[n]);
 t.Free;
end;


function TBodyMailForm.PrepareBody(boundary:string):TStringList;
var str:TStringList;
    n:integer;
    fs:TFileStream;
    err:boolean;
begin
 str:=TStringList.Create;

 if atts.Count=0 then
  begin
   //simple mail
   for n:=0 to Memo.Lines.Count-1 do
     str.Add(Win2Koi(Memo.Lines[n]));
   if mail_footer<>'' then
    begin
     str.Add('');
     str.Add('------');
     AddMultiLineString2List(str,Win2Koi(mail_footer));
    end;
  end
 else
  begin
   str.Add('This is a multi-part message in MIME format.');
   str.Add('');

   //text
   str.Add('--'+boundary);
   str.Add('Content-Type: text/plain;format=flowed;charset="koi8-r";reply-type=original');
   str.Add('Content-Transfer-Encoding: 8bit');
   str.Add('');
   for n:=0 to Memo.Lines.Count-1 do
     str.Add(Win2Koi(Memo.Lines[n]));
   if mail_footer<>'' then
    begin
     str.Add('');
     str.Add('------');
     AddMultiLineString2List(str,Win2Koi(mail_footer));
    end;
   str.Add('');

   //atts
   for n:=0 to atts.count-1 do
    begin
     str.Add('--'+boundary);
     str.Add('Content-Type: application/octet-stream;name="'+Win2KoiCoded(ExtractFileName(atts[n]))+'"');
     str.Add('Content-Transfer-Encoding: base64');
     str.Add('Content-Disposition: attachment;filename="'+Win2KoiCoded(ExtractFileName(atts[n]))+'"');
     str.Add('');

     err:=false;
     try
      fs:=TFileStream.Create(atts[n],fmOpenRead);
     except
      fs:=nil;
      err:=true;
     end;
     if fs=nil then
      err:=true;
      
     if fs<>nil then
      begin
       try
        while fs.Position<fs.Size do
         str.Add(Encoder64.Encode(fs,57));
       except
        err:=true;
       end;
       fs.Free;
      end;

     if err then
      begin
       str.Free;
       Result:=nil;
       exit;
      end;

     str.Add('');
    end;

   //finalize
   str.Add('--'+boundary+'--');
  end;

 str.Add('');
 Result:=str;
end;

procedure TBodyMailForm.SendMail;
var msg:TIdMessage;
    str:TStringList;
    err:boolean;
    boundary:string;
begin
 err:=false;
 msg:=nil;
 SetStatus(S_PREPARE_MSG);
 Application.ProcessMessages;

 boundary:=Format('----=_NextPart_%X',[cardinal(GetTickCount()*GetTickCount())]);

 str:=PrepareBody(boundary);
 if str<>nil then
  begin
   try
    msg:=TIdMessage.Create(nil);
    msg.SetBody(str);
    msg.AddHeader('MIME-Version: 1.0');
    if atts.Count=0 then
     begin
      msg.ContentType:='text/plain;format=flowed;charset="koi8-r";reply-type=original';
      msg.ContentTransferEncoding:='8bit';
     end
    else
     begin
      msg.ContentType:='multipart/mixed;boundary="'+boundary+'"';
     end;
    msg.From.Name:=Win2KoiCoded(EditFromName.Text);
    msg.From.Address:=trim(EditFromAddress.Text);
    if imp=1 then
     msg.Priority:=mpHigh
    else
    if imp=2 then
     msg.Priority:=mpLow;
    msg.Recipients.EMailAddresses:=trim(EditTo.Text);
    msg.Subject:=Win2KoiCoded(EditSubject.Text);

    //msg.SaveToFile('c:\!!!.eml');  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    try
     SetStatus(S_CONNECT);
     Application.ProcessMessages;
     idSMTP.Connect();
     if idSMTP.AuthenticationType=atLogin then
      begin
       SetStatus(S_AUTH);
       Application.ProcessMessages;
       idSMTP.Authenticate;
      end;
     SetStatus(S_SENDING);
     Application.ProcessMessages;
     idSMTP.Send(msg);
     SetStatus(S_DISCONNECTING);
     Application.ProcessMessages;
     idSMTP.Disconnect();
    except
     if idSMTP.Connected then
       idSMTP.Disconnect();
     err:=true;
     MessageBox(handle,S_ERR_SEND2,S_ERROR,MB_OK or MB_ICONERROR);
    end;
   except
    err:=true;
    MessageBox(handle,S_ERR_MSG,S_ERROR,MB_OK or MB_ICONERROR);
   end;
  end
 else
  begin
   err:=true;
   MessageBox(handle,S_ERR_ATT,S_ERROR,MB_OK or MB_ICONERROR);
  end;

 msg.Free;
 str.Free;

 if err then
  SetStatus(S_ERR_SEND)
 else
  begin
   SetStatus(S_SUCCESS_SEND);
   OnSuccessMail(EditFromName.Text,EditFromAddress.Text,EditTo.Text,EditSubject.Text);
   MessageBox(handle,S_SUCCESS_SEND,S_INFO,MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TBodyMailForm.IdSMTPWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
 Application.ProcessMessages;
end;

procedure TBodyMailForm.OnSuccessMail(from_name,from_addr,to_addr,subj:string);
var w:HWND;
    atom1,atom2:cardinal;
begin
  w:=FindWindow('_RunpadClass',nil);
  if w<>0 then
   begin
    atom1:=GlobalAddAtom(pchar(from_name));
    atom2:=GlobalAddAtom(pchar(subj));
    PostMessage(w,WM_USER+183,atom1,atom2);
   end;
end;

end.
