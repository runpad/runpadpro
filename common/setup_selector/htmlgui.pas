
unit HTMLGUI;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}

interface

uses ActiveX, Windows, Classes, MyWebBrowser;


type
     TAllowedKeys = set of byte;

     THTMLGUIOnCancel = procedure(ASender: TObject) of object;
     THTMLGUIOnHelp = procedure(ASender: TObject) of object;
     
     THTMLGUI = class(TMyWebBrowser)
     private
        FAllowedKeys : TAllowedKeys;
        FAllowedCtrlKeys : TAllowedKeys;
        FOnCancel : THTMLGUIOnCancel;
        FOnHelp : THTMLGUIOnHelp;
        FOleInPlaceActiveObject : IOleInPlaceActiveObject;
        procedure WebBrowserNewWindow2(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
        procedure WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
     public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        function ProcessMessage(var msg:TMsg):boolean;
        procedure SetAllowedKeys(const keys:TAllowedKeys);
        function GetAllowedKeys:TAllowedKeys;
        procedure SetAllowedCtrlKeys(const keys:TAllowedKeys);
        function GetAllowedCtrlKeys:TAllowedKeys;
        procedure SetZoom(scale_perc:integer);
     published
        property OnCancel: THTMLGUIOnCancel read FOnCancel write FOnCancel;
        property OnHelp: THTMLGUIOnHelp read FOnHelp write FOnHelp;
     end;


implementation

uses Messages;



constructor THTMLGUI.Create(AOwner: TComponent);
begin
 inherited;

 FAllowedKeys:=[VK_RETURN,VK_TAB,VK_DELETE,VK_INSERT,VK_SHIFT];
 FAllowedCtrlKeys:=[ord('A'),ord('Z'),ord('X'),ord('C'),ord('V')];
 FOnCancel:=nil;
 FOnHelp:=nil;

 ContextMenuEnabled:=false;
 Border3DEnabled:=false;
 ScrollEnabled:=false;
 TextSelectEnabled:=false;
 AllowFileDownload:=false;
 AllowAlerts:=false;
 DLOptions:=[dlImages, dlVideos, dlSounds, dlNoJava, dlNoActiveXDownload, dlSilent];

 OnNewWindow2 := WebBrowserNewWindow2;
 OnWindowClosing := WebBrowserWindowClosing;

 FOleInPlaceActiveObject:=nil;
 if Self.Application<>nil then
    Self.Application.QueryInterface(IOleInPlaceActiveObject,FOleInPlaceActiveObject);
end;

destructor THTMLGUI.Destroy;
begin
 FOleInPlaceActiveObject:=nil;

 inherited;
end;

procedure THTMLGUI.WebBrowserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
 Cancel:=TRUE;
end;

procedure THTMLGUI.WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
begin
 Cancel:=TRUE;
end;

procedure THTMLGUI.SetAllowedKeys(const keys:TAllowedKeys);
begin
 FAllowedKeys:=keys;
end;

function THTMLGUI.GetAllowedKeys:TAllowedKeys;
begin
 Result:=FAllowedKeys;
end;

procedure THTMLGUI.SetAllowedCtrlKeys(const keys:TAllowedKeys);
begin
 FAllowedCtrlKeys:=keys;
end;

function THTMLGUI.GetAllowedCtrlKeys:TAllowedKeys;
begin
 Result:=FAllowedCtrlKeys;
end;

procedure THTMLGUI.SetZoom(scale_perc:integer);
var V : OleVariant;
begin
 if Document<>nil then
  begin
   try
    V := scale_perc;
    ExecWB(63{OLECMDID_OPTICAL_ZOOM}, OLECMDEXECOPT_DONTPROMPTUSER, V);
   except end;
  end;
end;

function THTMLGUI.ProcessMessage(var msg:TMsg):boolean;
var key: integer;
    is_ctrl,{is_alt,}is_shift: boolean;
begin
 Result:=false;

 if FOleInPlaceActiveObject<>nil then
  begin
   if IsDialogMessage(Handle,Msg) then
    begin
     Result:=true;

     if (Msg.message = WM_KEYDOWN) or (Msg.message = WM_KEYUP) then
      begin
       key:=Msg.wParam;
       
       is_ctrl:=(GetAsyncKeyState(VK_CONTROL) and $8000)<>0;
       //is_alt:=(GetAsyncKeyState(VK_MENU) and $8000)<>0;
       is_shift:=(GetAsyncKeyState(VK_SHIFT) and $8000)<>0;

       if is_shift{(key in [VK_SHIFT,VK_LSHIFT,VK_RSHIFT])} and (not (VK_SHIFT in FAllowedKeys)) then
        exit;

       if (Msg.message = WM_KEYDOWN) and (key = VK_F1) then
        begin
         if Assigned(FOnHelp) then
          begin
           FOnHelp(self);
           exit;
          end;
        end;

       if (Msg.message = WM_KEYDOWN) and (key = VK_ESCAPE) then
        begin
         if Assigned(FOnCancel) then
          begin
           FOnCancel(self);
           exit;
          end;
        end;

       if (key in FAllowedKeys) or ((key in FAllowedCtrlKeys) and is_ctrl) then
         Result:=FOleInPlaceActiveObject.TranslateAccelerator(Msg)=S_OK;
      end;
    end;
  end;
end;


end.
