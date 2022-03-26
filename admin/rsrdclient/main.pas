unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, XPMan, parms;

type
  TRDForm = class(TForm)
    PaintBox: TPaintBox;
    PopupMenu: TPopupMenu;
    MenuScreenGray: TMenuItem;
    MenuScreenColor: TMenuItem;
    N1: TMenuItem;
    MenuFullscreen: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    XPManifest1: TXPManifest;
    MenuSpectator: TMenuItem;
    MenuFPS: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure MenuScreenGrayClick(Sender: TObject);
    procedure MenuScreenColorClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure MenuFullscreenClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure MenuFPSClick(Sender: TObject);
    procedure MenuSpectatorClick(Sender: TObject);
  private
    { Private declarations }
    first_time_data_arrived : boolean;
    function IsInFullScreen:boolean;
    procedure AddInputEvent(message,wParam,lParam:integer;time:cardinal);
    procedure UpdateCaption;
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure OnDataArrived();
    procedure OnDisconnect();
    procedure OnWorkFinished();
  end;

var
  RDForm: TRDForm;

implementation

{$R *.dfm}

{$INCLUDE rsrdclient.inc}


var msg_data_arrived : cardinal = 0;
var msg_disconnected : cardinal = 0;
var msg_work_finished : cardinal = 0;


procedure TRDForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
var p:TPoint;
    l:integer;
    is_ctrl,is_alt,key_down:boolean;
begin
 if Msg.message=msg_data_arrived then
   begin
     OnDataArrived();
     Handled := True;
   end
 else
 if Msg.message=msg_work_finished then
   begin
     OnWorkFinished();
     Handled := True;
   end
 else
 if Msg.message=msg_disconnected then
   begin
     OnDisconnect();
     Handled := True;
   end
 else
 if Msg.hwnd=Handle then
  begin
   if (Msg.message=WM_MOUSEMOVE) or
      (Msg.message=WM_LBUTTONDOWN) or
      (Msg.message=WM_LBUTTONUP) or
      (Msg.message=WM_LBUTTONDBLCLK) or
      (Msg.message=WM_RBUTTONDOWN) or
      (Msg.message=WM_RBUTTONUP) or
      (Msg.message=WM_RBUTTONDBLCLK) or
      (Msg.message=WM_MBUTTONDOWN) or
      (Msg.message=WM_MBUTTONUP) or
      (Msg.message=WM_MBUTTONDBLCLK) then
     begin
      p.x:=integer(smallint(LOWORD(Msg.lParam)));
      p.y:=integer(smallint(HIWORD(Msg.lParam)));
      inc(p.x,HorzScrollBar.ScrollPos);
      inc(p.y,VertScrollBar.ScrollPos);
      l:=MAKELONG(word(smallint(p.x)),word(smallint(p.y)));
      AddInputEvent(Msg.message,Msg.wParam,l,Msg.time);
     end;

   if (Msg.message=WM_MOUSEWHEEL) then
     begin
      p.x:=integer(smallint(LOWORD(Msg.lParam)));
      p.y:=integer(smallint(HIWORD(Msg.lParam)));
      ScreenToClient(p);
      inc(p.x,HorzScrollBar.ScrollPos);
      inc(p.y,VertScrollBar.ScrollPos);
      l:=MAKELONG(word(smallint(p.x)),word(smallint(p.y)));
      AddInputEvent(Msg.message,Msg.wParam,l,Msg.time);
     end;

   if (Msg.message=WM_KEYUP) or
      (Msg.message=WM_KEYDOWN) or
      (Msg.message=WM_SYSKEYUP) or
      (Msg.message=WM_SYSKEYDOWN) then
     begin
      if (Msg.wParam<>VK_LWIN) and (Msg.wParam<>VK_RWIN) and (Msg.wParam<>VK_PAUSE) and
         (Msg.wParam<>VK_LCONTROL) and (Msg.wParam<>VK_RCONTROL) and (Msg.wParam<>VK_CONTROL) and
         (Msg.wParam<>VK_LMENU) and (Msg.wParam<>VK_RMENU) and (Msg.wParam<>VK_MENU) then
       begin
        is_ctrl:=((GetAsyncKeyState(VK_CONTROL) and $8000)<>0);
        is_alt:=((GetAsyncKeyState(VK_MENU) and $8000)<>0);
        key_down:=(Msg.message=WM_KEYDOWN) or (Msg.message=WM_SYSKEYDOWN);

        if key_down and is_ctrl then
          AddInputEvent(WM_KEYDOWN,VK_CONTROL,$001D0001,Msg.time);
        if key_down and is_alt then
          AddInputEvent(WM_SYSKEYDOWN,VK_MENU,$00380001,Msg.time);
        AddInputEvent(Msg.message,Msg.wParam,Msg.lParam,Msg.time);
        if key_down and is_ctrl then
          AddInputEvent(WM_KEYUP,VK_CONTROL,$001D0001,Msg.time);
        if key_down and is_alt then
          AddInputEvent(WM_SYSKEYUP,VK_MENU,$00380001,Msg.time);

        if ((Msg.wParam=VK_LSHIFT) or (Msg.wParam=VK_RSHIFT) or (Msg.wParam=VK_SHIFT)) and 
           key_down and (is_alt or is_ctrl) then
          AddInputEvent(WM_KEYUP,VK_SHIFT,$002A0001,Msg.time); //fix for CTRL+SHIFT+ESC, etc.
       end;

      if (Msg.message=WM_KEYDOWN) and (Msg.wParam=VK_PAUSE) then
       begin
        GetCursorPos(p);
        PopupMenu.Popup(p.x,p.y);
       end;
     end;

   if (Msg.message=WM_SYSKEYUP) or
      (Msg.message=WM_SYSKEYDOWN) or
      (Msg.message=WM_KEYUP) or
      (Msg.message=WM_KEYDOWN) or
      (Msg.message=WM_SYSCHAR) then
     Handled:=true;
  end;
end;

procedure TRDForm.FormCreate(Sender: TObject);
var n:integer;
    item:TMenuItem;
begin
 first_time_data_arrived:=TRUE;

 GdiSetBatchLimit(1);
 
 UpdateCaption;

 for n:=0 to GetFPSListCount-1 do
  begin
   item:=TMenuItem.Create(MenuFPS);
   item.Caption:=GetNameFPSByIdx(n);
   item.OnClick:=MenuFPSClick;
   MenuFPS.Add(item);
  end;

 PaintBox.Left:=0;
 PaintBox.Top:=0;
 PaintBox.Width:=Screen.Width;
 PaintBox.Height:=Screen.Height;
 BorderIcons:=[biSystemMenu,biMinimize,biMaximize];
 BorderStyle:=bsSizeable;
 AutoSize:=false;
 AutoScroll:=true;
 WindowState:=wsNormal;

 msg_data_arrived:=RegisterWindowMessage(HELPER_MSG_DATA);
 msg_disconnected:=RegisterWindowMessage(HELPER_MSG_DISCONNECTED);
 msg_work_finished:=RegisterWindowMessage(HELPER_MSG_FINISHED);
 Application.OnMessage:=AppMessage;
end;

procedure TRDForm.OnWorkFinished();
begin
 MessageBox(Handle,'Работа демо-версии завершена','Информация',MB_OK or MB_ICONINFORMATION);
 Close;
end;

procedure TRDForm.OnDisconnect();
begin
 MessageBox(Handle,'Произошло отключение от удаленного компьютера'#13#10'Возможно Ваш IP не разрешен в настройках удаленного сервиса','Информация',MB_OK or MB_ICONINFORMATION);
 Close;
end;

procedure TRDForm.OnDataArrived();
var dc:HDC;
    w,h:integer;
begin
 dc:=RA_Lock(@w,@h);
 RA_Unlock();
 if dc=0 then
  exit;
 //dc:=0;

 if (w<>PaintBox.Width) or (h<>PaintBox.Height) then
  begin
   if (w<Screen.Width) or (h<Screen.Height) then
    begin
     WindowState:=wsNormal;
     BorderStyle:=bsSingle;
     BorderIcons:=[biSystemMenu,biMinimize];
     PaintBox.Width:=w;
     PaintBox.Height:=h;
     AutoScroll:=False;
     AutoSize:=True;
    end
   else
    begin
     WindowState:=wsNormal;
     BorderStyle:=bsSizeable;
     BorderIcons:=[biSystemMenu,biMinimize,biMaximize];
     AutoSize:=false;
     AutoScroll:=true;
     ClientWidth:=w-50;
     ClientHeight:=h-50;
     PaintBox.Width:=w;
     PaintBox.Height:=h;
    end;
  end;

 if first_time_data_arrived then
  begin
   first_time_data_arrived:=false;
   if g_start_fs then
     MenuFullscreenClick(nil);
  end;

 InvalidateRect(handle,nil,FALSE);
end;

procedure TRDForm.PaintBoxPaint(Sender: TObject);
var dc:HDC;
    w,h:integer;
begin
 dc:=RA_Lock(@w,@h);
 if dc<>0 then
   BitBlt(PaintBox.Canvas.Handle,0,0,w,h,dc,0,0,SRCCOPY);
 RA_Unlock();
end;

procedure TRDForm.PopupMenuPopup(Sender: TObject);
var n:integer;
begin
 for n:=0 to GetFPSListCount-1 do
   MenuFPS.Items[n].Checked:=n=g_fps_idx;
 MenuScreenGray.Checked:=g_picture_type=SCREEN_RLE7B_GRAY;
 MenuScreenColor.Checked:=g_picture_type=SCREEN_RLE7B_COLOR;
 MenuFullscreen.Checked:=IsInFullScreen;
 MenuSpectator.Checked:=g_spectator;
end;

function TRDForm.IsInFullScreen:boolean;
begin
 Result:=(BorderStyle=bsNone);
end;

procedure TRDForm.MenuScreenGrayClick(Sender: TObject);
begin
 g_picture_type:=SCREEN_RLE7B_GRAY;
 RA_UpdatePictureType(g_picture_type);
 SaveParms;
end;

procedure TRDForm.MenuScreenColorClick(Sender: TObject);
begin
 g_picture_type:=SCREEN_RLE7B_COLOR;
 RA_UpdatePictureType(g_picture_type);
 SaveParms;
end;

procedure TRDForm.MenuFullscreenClick(Sender: TObject);
begin
 if IsInFullScreen then
  begin
   BorderStyle:=bsSizeable;
   AutoSize:=false;
   AutoScroll:=true;
   WindowState:=wsMaximized;
  end
 else
  begin
   if (PaintBox.Width=Screen.Width) and (PaintBox.Height=Screen.Height) then
    begin
     BorderStyle:=bsNone;
     AutoScroll:=false;
     AutoSize:=false;
     Left:=0;
     Top:=0;
     Width:=Screen.Width;
     Height:=Screen.Height;
    end;
  end;
end;

procedure TRDForm.N3Click(Sender: TObject);
begin
 Close;
end;

procedure TRDForm.MenuFPSClick(Sender: TObject);
var item:TMenuItem;
begin
 item:=Sender as TMenuItem;
 g_fps_idx:=item.MenuIndex;
 RA_UpdateFPS(GetFPSByIdx(g_fps_idx));
 SaveParms;
end;

procedure TRDForm.MenuSpectatorClick(Sender: TObject);
begin
 g_spectator:=not g_spectator;
 UpdateCaption;
 //SaveParms;
end;

procedure TRDForm.AddInputEvent(message,wParam,lParam:integer;time:cardinal);
begin
 if not g_spectator then
   RA_InputEvent(message,wParam,lParam,time);
end;

procedure TRDForm.UpdateCaption;
begin
 Caption:=g_computer + ' - (Клавиша "Pause" - меню)';
 if g_spectator then
  Caption:=Caption+' [РЕЖИМ НАБЛЮДАТЕЛЯ]';
 Application.Title:=g_computer+' - Удаленное управление';
end;


end.
