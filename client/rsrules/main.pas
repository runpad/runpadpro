unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ShDocVw, MyWebBrowser;

type
  TRulesForm = class(TForm)
    Panel1: TPanel;
    PanelHost: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ButtonAgree: TButton;
    ButtonDecline: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ButtonAgreeClick(Sender: TObject);
    procedure ButtonDeclineClick(Sender: TObject);
  private
    { Private declarations }
    w_parent : HWND;
    is_ls : boolean;
    filename : string;
    WebBrowser : TMyWebBrowser;
    RichEdit : TRichEdit;
    procedure WebBrowserNewWindow2(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
    procedure WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
    procedure WebBrowserNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure InitiateRebootLogOff;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    constructor CreateForm(_w_parent:HWND;_is_ls:boolean;const _filename:string);
    destructor Destroy; override;
    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var Message: TWMEndSession); message WM_ENDSESSION;
    function ShowModal: Integer; override;
  end;


procedure ShowRulesWindowModal(wnd:HWND;is_ls:boolean;const filename:string);

  
implementation

{$R *.dfm}
{$I ..\rp_shared\rp_shared.inc}


procedure ShowRulesWindowModal(wnd:HWND;is_ls:boolean;const filename:string);
var f:TRulesForm;
begin
 f:=TRulesForm.CreateForm(wnd,is_ls,filename);
 f.ShowModal;
 f.Free;
end;

function TRulesForm.ShowModal: Integer;
var msg : TMsg;
begin
  CancelDrag;
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  ReleaseCapture;

  Include(FFormState, fsModal);
  Show;
  SendMessage(Handle, CM_ACTIVATE, 0, 0);
  ModalResult := 0;

  while GetMessage(msg,0,0,0) do
   begin
    TranslateMessage(msg);
    DispatchMessage(msg);
   end;

  Result := ModalResult;
  SendMessage(Handle, CM_DEACTIVATE, 0, 0);
  Hide;
  Exclude(FFormState, fsModal);
end;

procedure TRulesForm.CreateParams(var Params: TCreateParams);
begin
 inherited;

 if is_ls then
  Params.ExStyle:=Params.ExStyle or WS_EX_TOPMOST;

 Params.WndParent:=w_parent;

 if is_ls then
  StrCopy(Params.WinClassName,'TRulesLSForm');
end;

constructor TRulesForm.CreateForm(_w_parent:HWND;_is_ls:boolean;const _filename:string);
begin
 w_parent:=_w_parent;
 is_ls:=_is_ls;
 filename:=_filename;
 WebBrowser:=nil;
 RichEdit:=nil;

 inherited Create(nil);

 if AnsiLowerCase(ExtractFileExt(filename))<>'.rtf' then
  begin
   WebBrowser:=TMyWebBrowser.Create(nil);
   TWinControl(WebBrowser).Parent:=PanelHost;
   with TWebBrowser(WebBrowser) do
    begin
     Align := alClient;
     TabStop := false;
     OnNewWindow2 := WebBrowserNewWindow2;
     OnNavigateComplete2 := WebBrowserNavigateComplete2;
     OnWindowClosing := WebBrowserWindowClosing;
     try
      OleObject.Silent:=true;
      OleObject.RegisterAsDropTarget:=false;
      OleObject.RegisterAsBrowser:=true;
     except end;
    end;
  end
 else
  begin
   RichEdit:=TRichEdit.Create(nil);
   TWinControl(RichEdit).Parent:=PanelHost;
   with RichEdit do
    begin
     Align := alClient;
     TabStop := False;
     BevelInner := bvNone;
     BevelOuter := bvNone;
     ReadOnly := True;
     ScrollBars := ssVertical;
    end;
  end;

 if not is_ls then
  begin
   Caption:=LS(LS_INFO);
   ButtonAgree.Caption:=LS(900);
   ButtonDecline.Caption:=LS(901);
  end
 else
  begin
   Caption:=LS(903);
   ButtonAgree.Caption:=LS(900);
   ButtonDecline.Caption:=LS(901);
  end;
end;

destructor TRulesForm.Destroy;
begin
 FreeAndNil(WebBrowser);
 FreeAndNil(RichEdit);

 inherited;
end;

procedure TRulesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caNone;
end;

procedure TRulesForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=false;
end;

procedure TRulesForm.FormShow(Sender: TObject);
begin
 ButtonAgree.SetFocus;

 if WebBrowser<>nil then
  begin
   try
    WebBrowser.Navigate(WideString(filename));
   except end;
  end
 else
 if RichEdit<>nil then
  begin
   try
    RichEdit.Lines.LoadFromFile(filename);
   except end;
  end;
end;

procedure TRulesForm.WebBrowserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
 Cancel:=true;
end;

procedure TRulesForm.WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
begin
 Cancel:=true;
end;

procedure TRulesForm.WebBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 try
  WebBrowser.SetFocusToDoc;
 except end;
end;

procedure TRulesForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
 Message.Result:=1;
end;

procedure TRulesForm.WMEndSession(var Message: TWMEndSession);
begin
 if Message.EndSession then
  begin
   if not is_ls then
     ButtonAgreeClick(nil);
  end;
 Message.Result:=0;
end;

procedure TRulesForm.ButtonAgreeClick(Sender: TObject);
begin
 if not is_ls then
  PostMessage(FindWindow('_RunpadClass',nil),WM_USER+132,0,0)
 else
  PostQuitMessage(1);
end;

procedure TRulesForm.ButtonDeclineClick(Sender: TObject);
begin
 if not is_ls then
  PostMessage(FindWindow('_RunpadClass',nil),WM_USER+133,0,0)
 else
  InitiateRebootLogOff();
end;

procedure TRulesForm.InitiateRebootLogOff;
begin
 if GetSystemMetrics($1000 {SM_REMOTESESSION})<>0 then
  begin
   //terminal session
   ExitWindowsEx(EWX_LOGOFF,0);
  end
 else
  begin
   SysReboot(false);
  end;
end;


end.
