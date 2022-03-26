unit desk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, theme, theme_html, theme_plugin;


type
  TRSDeskForm = class(TForm)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    theme : TTheme;
    conn : PDeskExternalConnection;

    procedure OnRClick();
    procedure OnMouseDown();

  public
    { Public declarations }

    constructor MyCreate(p:PDeskExternalConnection);
    destructor Destroy; override;

    procedure DefaultHandler(var Message); override;

    procedure WMQueryEndSession(var Message: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var Message: TWMEndSession); message WM_ENDSESSION;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMActivateApp(var Message: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMClose(var Message: TWMClose); message WM_CLOSE;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMSysKeyDown(var Message: TWMSysKeyDown); message WM_SYSKEYDOWN;
    procedure WMSysKeyUp(var Message: TWMSysKeyUp); message WM_SYSKEYUP;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    procedure WMSysChar(var Message: TWMSysChar); message WM_SYSCHAR;

    function MyIsVisible:boolean;
    procedure MyShow();
    procedure MyHide();
    procedure MyRepaint();
    procedure MyRefresh();
    procedure MyNavigate(const url:string);
    procedure MyOnDisplayChange();
    procedure MyOnEndSession();
    procedure MyBringToBottom();
    procedure MyOnStatusStringChanged();
    procedure MyOnActiveSheetChanged();
    procedure MyOnPageShaded();
  end;



implementation

uses StrUtils;

{$R *.dfm}



const WM_XBUTTONDOWN    =              $020B;
const WM_XBUTTONUP      =              $020C;
const WM_XBUTTONDBLCLK  =              $020D;

var 
    hook1 : cardinal = 0;
    hook2 : cardinal = 0;
    g_hwnd : HWND = 0;
    msg_rclick : cardinal = WM_NULL;
    msg_mousedown : cardinal = WM_NULL;




function IsHookInterestWindow(w:HWND):boolean;
begin
 if (w<>0) and IsWindow(w) then
  begin
   if (GetWindowLong(w,GWL_STYLE) and WS_CHILD)<>0 then
    Result:=(GetAncestor(w,GA_ROOT)=g_hwnd)
   else
    Result:=(w=g_hwnd);
  end
 else
  Result:=false;
end;

//function IsFlashWindow(w:HWND):boolean;
//var s:array[0..MAX_PATH] of char;
//begin
// if (w<>0) and IsWindow(w) and ((GetWindowLong(w,GWL_STYLE) and WS_CHILD)<>0) then
//  begin
//   s[0]:=#0;
//   GetClassName(w,s,sizeof(s));
//   Result:=(string(s)='MacromediaFlashPlayerActiveX');
//  end
// else
//  Result:=false;
//end;

function CBTProc(code: integer; wParam: integer; lParam: integer): integer stdcall;
begin
 if code >= 0 then
  begin
   if (code=HCBT_ACTIVATE) or (code=HCBT_SETFOCUS) then
    begin
     if IsHookInterestWindow(wParam) then
      begin
       Result:=1;
       exit;
      end;
    end;
  end;
 Result := CallNextHookEx(hook1, Code, wParam, lParam);
end;

function GMProc(code: integer; wParam: integer; lParam: integer): integer stdcall;
var p:PMSG;
begin
 if code >= 0 then
  begin
   p:=PMSG(lParam);
   if (p^.message=WM_LBUTTONDOWN) or
      (p^.message=WM_LBUTTONUP) or
      (p^.message=WM_LBUTTONDBLCLK) or
      (p^.message=WM_RBUTTONDOWN) or
      (p^.message=WM_RBUTTONUP) or
      (p^.message=WM_RBUTTONDBLCLK) or
      (p^.message=WM_MBUTTONDOWN) or
      (p^.message=WM_MBUTTONUP) or
      (p^.message=WM_MBUTTONDBLCLK) or
      (p^.message=WM_XBUTTONDOWN) or
      (p^.message=WM_XBUTTONUP) or
      (p^.message=WM_XBUTTONDBLCLK) or
      (p^.message=WM_MOUSEWHEEL) or
      (p^.message=WM_MOUSEMOVE) or
      (p^.message=WM_KEYDOWN) or
      (p^.message=WM_KEYUP) or
      (p^.message=WM_SYSKEYDOWN) or
      (p^.message=WM_SYSKEYUP) or
      (p^.message=WM_SYSCHAR) or
      (p^.message=WM_CHAR) then
     begin
      if IsHookInterestWindow(p^.hwnd) then
       begin
        if (p^.message=WM_LBUTTONDOWN) or 
           (p^.message=WM_RBUTTONDOWN) or 
           (p^.message=WM_MBUTTONDOWN) then
          PostMessage(g_hwnd,msg_mousedown,0,0);
        if p^.message=WM_RBUTTONUP then
          PostMessage(g_hwnd,msg_rclick,0,0);
        
        if (p^.message<>WM_LBUTTONDOWN) and
           (p^.message<>WM_LBUTTONUP) and
           (p^.message<>WM_LBUTTONDBLCLK) and
           (p^.message<>WM_MOUSEMOVE) then
         begin
          p^.message:=WM_NULL;
          Result:=0;
          exit;
         end
        else
         begin
          if p^.message=WM_MOUSEMOVE then
           begin
            if (p^.wParam and MK_LBUTTON)<>0 then
             begin
              p^.message:=WM_NULL;
              Result:=0;
              exit;
             end;
           end;
         end;
       end;
     end;
  end;

 Result := CallNextHookEx(hook2, Code, wParam, lParam);
end;

procedure InitHooks(w:HWND);
begin
 if g_hwnd=0 then
  g_hwnd:=w;
 if hook1=0 then
  hook1:=SetWindowsHookEx(WH_CBT,CBTProc,0,GetCurrentThreadId());
 if hook2=0 then
  hook2:=SetWindowsHookEx(WH_GETMESSAGE,GMProc,0,GetCurrentThreadId());
end;

procedure DoneHooks;
begin
 if hook1<>0 then
  UnhookWindowsHookEx(hook1);
 hook1:=0;
 if hook2<>0 then
  UnhookWindowsHookEx(hook2);
 hook2:=0;
 g_hwnd:=0;
end;

procedure TRSDeskForm.DefaultHandler(var Message);
begin
 with TMessage(Message) do
   if msg=msg_rclick then
     OnRClick()
   else
   if msg=msg_mousedown then
     OnMouseDown()
   else
     inherited;
end;

constructor TRSDeskForm.MyCreate(p:PDeskExternalConnection);
begin
 inherited Create(nil);
 
 theme:=nil;
 conn:=p;
 
 SetWindowLong(Handle,GWL_USERDATA,$49474541);  //MAGIC_WID
 SetWindowLong(Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW {or WS_EX_NOACTIVATE});
 SetWindowLong(Handle,GWL_STYLE,integer(WS_POPUP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS));

 InitHooks(Handle);
 
 SetWindowPos(Handle,HWND_BOTTOM,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN),SWP_NOACTIVATE);
end;

destructor TRSDeskForm.Destroy;
begin
 DoneHooks;
 conn:=nil;
 FreeAndNil(theme);

 inherited;
end;

procedure TRSDeskForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=false;
end;

procedure TRSDeskForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caNone;
end;

procedure TRSDeskForm.OnRClick();
begin
 if conn<>nil then
  if @conn.OnRClick<>nil then
   conn.OnRClick();
end;

procedure TRSDeskForm.OnMouseDown();
begin
 if conn<>nil then
  if @conn.OnMouseDown<>nil then
   conn.OnMouseDown();
end;

procedure TRSDeskForm.WMQueryEndSession(var Message: TWMQueryEndSession);
begin
 Message.Result:=1;
end;

procedure TRSDeskForm.WMEndSession(var Message: TWMEndSession);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
 Windows.PaintDesktop(Message.DC);
 Message.Result:=1;
end;

procedure TRSDeskForm.WMActivate(var Message: TWMActivate);
begin
 SetWindowPos(Handle,HWND_BOTTOM,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
 Message.Result:=0;
end;

procedure TRSDeskForm.WMActivateApp(var Message: TWMActivateApp);
begin
 SetWindowPos(Handle,HWND_BOTTOM,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
 Message.Result:=0;
end;

procedure TRSDeskForm.WMMouseActivate(var Message: TWMMouseActivate);
begin
 Message.Result:=MA_NOACTIVATE;
end;

procedure TRSDeskForm.WMClose(var Message: TWMClose);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMWindowPosChanging(var Message: TWMWindowPosChanging);
var p:PWINDOWPOS;
begin
 if IsIconic(Handle) then
  begin
   p:=Message.WindowPos;
   p^.hwnd := Handle;
   p^.hwndInsertAfter := HWND_BOTTOM;
   p^.x := 0;
   p^.y := 0;
   p^.cx := GetSystemMetrics(SM_CXSCREEN);
   p^.cy := GetSystemMetrics(SM_CYSCREEN);
   p^.flags := SWP_NOACTIVATE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW;
   Windows.ShowWindow(Handle,SW_RESTORE);
   Message.Result:=0;
  end
 else
  inherited;
end;

procedure TRSDeskForm.WMSysKeyDown(var Message: TWMSysKeyDown);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMSysKeyUp(var Message: TWMSysKeyUp);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMKeyDown(var Message: TWMKeyDown);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMKeyUp(var Message: TWMKeyUp);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.WMSysChar(var Message: TWMSysChar);
begin
 Message.Result:=0;
end;

procedure TRSDeskForm.MyRepaint();
begin
 if theme<>nil then
  begin
   theme.Repaint;
  end
 else
  begin
   InvalidateRect(Handle,nil,TRUE);
   Windows.UpdateWindow(Handle);
  end;
end;

procedure TRSDeskForm.MyRefresh();
begin
 if theme<>nil then
  begin
   theme.Refresh;
  end
 else
  begin
   MyRepaint();
  end;
end;

procedure TRSDeskForm.MyNavigate(const url:string);
begin
 FreeAndNil(theme);
 
 if TThemePlugin.IsMyURL(url) then
  begin
   theme:=TThemePlugin.Create(Handle,TWinControl(self),conn,url);
  end
 else
 if TThemeHTML.IsMyURL(url) then
  begin
   theme:=TThemeHTML.Create(Handle,TWinControl(self),conn,url);
  end;

 if (theme<>nil) and (not theme.IsLoaded) then
  FreeAndNil(theme);

 if theme=nil then
  MyRepaint();
end;

procedure TRSDeskForm.MyShow();
begin
 if not IsWindowVisible(Handle) then
  begin
   if Visible then
    Visible:=false;
   SetWindowPos(Handle,HWND_BOTTOM,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING or SWP_SHOWWINDOW);
   Visible:=true;
   MyBringToBottom();
   MyRepaint();
  end;
end;

procedure TRSDeskForm.MyHide();
begin
 Visible:=false;
end;

function TRSDeskForm.MyIsVisible:boolean;
begin
 Result:=IsWindowVisible(Handle);
end;   
   
procedure TRSDeskForm.MyOnDisplayChange();
begin
 SetWindowPos(Handle,HWND_BOTTOM,0,0,GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN),SWP_NOACTIVATE);
 if theme<>nil then
  theme.OnDisplayChanged()
 else
  MyRepaint();
end;

procedure TRSDeskForm.MyOnEndSession();
begin
 Visible:=false;
 DoneHooks;
end;

procedure TRSDeskForm.MyBringToBottom();
begin
 SetWindowPos(Handle,HWND_BOTTOM,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_NOSENDCHANGING);
end;

procedure TRSDeskForm.MyOnStatusStringChanged();
begin
 if theme<>nil then
  theme.OnStatusStringChanged();
end;

procedure TRSDeskForm.MyOnActiveSheetChanged();
begin
 if theme<>nil then
  theme.OnActiveSheetChanged();
end;

procedure TRSDeskForm.MyOnPageShaded();
begin
 if theme<>nil then
  theme.OnPageShaded();
end;


initialization
 msg_rclick:=RegisterWindowMessage('RSDeskForm.RClick');
 msg_mousedown:=RegisterWindowMessage('RSDeskForm.MouseDown');
end.
