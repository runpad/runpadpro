unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ActiveX, MyWebBrowser, HTMLGUI;

type
  TSetupForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    html : THTMLGUI;
    msg_selection : cardinal;

    { Private declarations }
    procedure WebBrowserBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowserNavigateComplete2(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserCancel(Sender: TObject);
    procedure WebBrowserHelp(Sender: TObject);

    function _MakeSelection(Params: array of OleVariant): OleVariant;
    function _ShowHelp(Params: array of OleVariant): OleVariant;
    function _ShowAlert(Params: array of OleVariant): OleVariant;

    procedure OnAppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure ProcessSelection(num:integer);
  public
    { Public declarations }
  end;

var
  SetupForm: TSetupForm;

implementation

uses ShellApi, StrUtils;

{$R *.dfm}

{$I ..\version.inc}


function GetLocalFilePath(const local:string):string;
begin
 Result:=IncludeTrailingPathDelimiter(ExtractFileDir(GetModuleName(0)))+local;
end;

procedure TSetupForm.FormCreate(Sender: TObject);
begin
 msg_selection:=RegisterWindowMessage('_SetupSelectorMsgSelection');

 html:=THTMLGUI.Create(self);
 html.Align:=alClient;
 html.DLOptions:=html.DLOptions+[{dlForceOffline}];
 html.ScrollEnabled:=true; //because frames are used
 html.SetAllowedKeys([VK_RETURN]);
 html.SetAllowedCtrlKeys([]);
 html.OnBeforeNavigate2 := WebBrowserBeforeNavigate2;
 html.OnNavigateComplete2 := WebBrowserNavigateComplete2;
 html.OnCancel := WebBrowserCancel;
 html.OnHelp := WebBrowserHelp;
 html.Bind('makeSelection',_MakeSelection);
 html.Bind('showHelp',_ShowHelp);
 html.Bind('showAlert',_ShowAlert);
 TWinControl(html).Parent:=self;

 Caption:=GLOBAL_VERSION;

 Application.OnMessage:=OnAppMessage;

 html.Navigate('res://'+GetModuleName(0)+'/index.htm');
end;

procedure TSetupForm.FormDestroy(Sender: TObject);
begin
 try
  if html.Busy then
   html.Stop;
 except end;
 
 Application.OnMessage:=nil;

 TWinControl(html).Parent:=nil;
 FreeAndNil(html);
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
 SetForegroundWindow(Handle);
end;

procedure TSetupForm.OnAppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=msg_selection then
  begin
   Handled:=true;
   ProcessSelection(Msg.wParam);
  end
 else
  Handled:=(html<>nil) and html.ProcessMessage(Msg);
end;

procedure TSetupForm.WebBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
 Cancel:=not AnsiStartsText('res://',string(url));
end;

procedure TSetupForm.WebBrowserNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 html.SetZoom(100);
end;

procedure TSetupForm.WebBrowserCancel(Sender: TObject);
begin
 Close;
end;

procedure TSetupForm.WebBrowserHelp(Sender: TObject);
begin
 _ShowHelp([]);
end;

function TSetupForm._MakeSelection(Params: array of OleVariant): OleVariant;
var sel:integer;
begin
 if length(params)=1 then
  begin
   try
    sel:=params[0];
   except
    sel:=-1;
   end;

   PostMessage(Handle,msg_selection,sel,0);
  end;
 Result:=unassigned;
end;

function TSetupForm._ShowHelp(Params: array of OleVariant): OleVariant;
begin
 ShellExecute(0,nil,pchar(GetLocalFilePath('help_setup.chm')),nil,nil,SW_SHOWNORMAL);
 Result:=unassigned;
end;

function TSetupForm._ShowAlert(Params: array of OleVariant): OleVariant;
var s:widestring;
begin
 if length(params)=1 then
  begin
   try
    s:=params[0];
   except
    s:='';
   end;
   Windows.MessageBoxW(Handle,pwidechar(s),pwidechar(widestring('Информация')),MB_OK or MB_ICONWARNING);
  end;
 Result:=unassigned;
end;

procedure TSetupForm.ProcessSelection(num:integer);
var s,cwd:string;
    p:array[0..MAX_PATH] of char;
    si:_STARTUPINFOA;
    pi:_PROCESS_INFORMATION;
begin
 if (num>=0) and (num<=4) then
  begin
   s:=GetLocalFilePath('inst_'+inttostr(num+1)+'.exe');
   cwd:=ExtractFileDir(s);
   StrCopy(p,pchar(s));
   FillChar(si,sizeof(si),0);
   si.cb:=sizeof(si);
   if CreateProcess(nil,p,nil,nil,false,0,nil,pchar(cwd),si,pi) then
    begin
     WaitForSingleObject(pi.hProcess,INFINITE);
     Windows.CloseHandle(pi.hProcess);
     Windows.CloseHandle(pi.hThread);
     Close;
    end;
  end
 else
  Close;
end;


initialization
  OleInitialize(nil);

finalization
  OleUninitialize;

end.
