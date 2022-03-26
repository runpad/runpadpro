unit my_preview;

interface

uses SysUtils, Windows, Classes, Forms, Controls, Graphics, ExtCtrls, PREVIEWLib_TLB, WMPLib_TLB;

type
     TMyPreview = class(TPanel)
      private
       p_pic : TPreview;
       p_wmp : TWindowsMediaPlayer;
       p_icon : TImage;
       procedure FreeControls;
       procedure ShowEmptyFile(s:string;do_preview:boolean);
       procedure ShowPictureFile(s:string;do_preview:boolean);
       procedure ShowAudioFile(s:string;do_preview:boolean);
       procedure ShowVideoFile(s:string;do_preview:boolean);
       procedure ShowUnknownFile(s:string;do_preview:boolean);
       procedure InitHooks;
       procedure DoneHooks;
      public
       constructor Create(AOwner: TComponent); override;
       destructor Destroy; override;
       procedure PreviewFile(s:string;do_preview:boolean);
     end;


implementation

uses Messages, lang, tools, config, wmppreview, ShellApi;


var
  hHook : cardinal = 0;


function HookMouse(code: integer; wParam: integer; lParam: integer): integer; stdcall;
var s: array[0..MAX_PATH] of char;
    w:HWND;
begin
 if code>=0 then
  if (wParam = WM_RBUTTONDOWN) or (wParam = WM_RBUTTONUP)
  or (wParam = WM_LBUTTONDOWN) or (wParam = WM_LBUTTONUP)
  or (wParam = WM_MBUTTONDOWN) or (wParam = WM_MBUTTONUP)
  or (wParam = WM_LBUTTONDBLCLK)
  or (wParam = WM_RBUTTONDBLCLK)
  or (wParam = WM_MBUTTONDBLCLK) then
   begin
    w:=PMouseHookStruct(lParam).hwnd;
    repeat
     if (w=0) or (w=GetDesktopWindow()) or ((GetWindowLong(w,GWL_STYLE) and WS_CHILD)=0) then
       break;
     s[0]:=#0;
     GetClassName(w,@s,sizeof(s));
     if string(s)='TMyPreview' then
      begin
       Result:=1;
       exit;
      end;
     w:=Windows.GetParent(w);
    until false;
   end;

 Result:=CallNextHookEx(hHook, code, wParam, lParam);
end;

procedure TMyPreview.InitHooks;
begin
 if hHook=0 then
  hHook:=SetWindowsHookEx(WH_MOUSE,@HookMouse,0,GetCurrentThreadId());
end;

procedure TMyPreview.DoneHooks;
begin
 if hHook<>0 then
  begin
   UnhookWindowsHookEx(hHook);
   hHook:=0;
  end;
end;

constructor TMyPreview.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);

 hHook:=0;
 p_pic:=nil;
 p_wmp:=nil;
 p_icon:=nil;

 BevelInner:=bvNone;
 BevelOuter:=bvNone;
 BorderStyle:=bsNone;
 Font.Color:=clGray;
 Caption:='';

 InitHooks;
end;


destructor TMyPreview.Destroy;
begin
 DoneHooks;
 FreeControls;

 inherited Destroy;
end;


procedure TMyPreview.FreeControls;
begin
 if p_pic<>nil then
  begin
   p_pic.Parent:=nil;
   p_pic.Free;
   p_pic:=nil;
  end;

 if p_wmp<>nil then
  begin
   try
    p_wmp.close;
   except end;
   p_wmp.Parent:=nil;
   p_wmp.Free;
   p_wmp:=nil;
  end;

 if p_icon<>nil then
  begin
   p_icon.Picture.Assign(nil);
   p_icon.Parent:=nil;
   p_icon.Free;
   p_icon:=nil;
  end;

 Caption:='';
end;


procedure TMyPreview.ShowEmptyFile(s:string;do_preview:boolean);
begin
 FreeControls;
 Caption:=S_SELECT_FILE;
end;

procedure TMyPreview.ShowPictureFile(s:string;do_preview:boolean);
var w:HWND;
begin
 if p_pic=nil then
  begin
   FreeControls;
   try
    p_pic:=TPreview.Create(nil);
   except
    p_pic:=nil;
   end;
   if p_pic=nil then
    begin
     Caption:=S_ERR_ACTIVEX;
     exit;
    end
   else
    begin
     p_pic.Align:=alClient;
     p_pic.TabStop:=false;
     p_pic.Visible:=false;
     p_pic.Parent:=self;

     w:=FindWindowEx(p_pic.Handle,0,'ShImgVw:CPreviewWnd',nil);
     if w<>0 then
      begin
       w:=FindWindowEx(w,0,'ToolbarWindow32',nil);
       if w<>0 then
        ShowWindow(w,SW_HIDE);
      end;

     p_pic.Visible:=true;
    end;
  end;

 WaitCursor(true);
 try
  p_pic.ShowFile(s,0);
 except
 end;
 WaitCursor(false);
end;

procedure TMyPreview.ShowAudioFile(s:string;do_preview:boolean);
var i:TIcon;
begin
 if p_wmp=nil then
  begin
   FreeControls;
   try
    p_wmp:=TWindowsMediaPlayer.Create(nil);
   except
    p_wmp:=nil;
   end;
   if p_wmp=nil then
    begin
     Caption:=S_ERR_ACTIVEX;
     exit;
    end
   else
    begin
     if p_wmp.settings<>nil then
      p_wmp.settings.enableErrorDialogs:=false;
     p_wmp.enableContextMenu:=false;
     p_wmp.uiMode:='invisible'; 
     p_wmp.TabStop:=false;
     p_wmp.Visible:=false;
     p_wmp.Parent:=self;
    end;
  end;

 Caption:='';
 if p_icon=nil then
  begin
   p_icon:=TImage.Create(nil);
   p_icon.Center:=true;
   p_icon.AutoSize:=false;
   p_icon.Stretch:=false;
   p_icon.Align:=alClient;
   p_icon.Parent:=self;
   i:=TIcon.Create();
   i.Handle:=DuplicateIcon(0,LoadImage(hinstance,MAKEINTRESOURCE(140),IMAGE_ICON,48,48,LR_SHARED));
   p_icon.Picture.Assign(i);
   i.Free;
  end;

 WaitCursor(true);
 try
  p_wmp.URL:=s;
 except
 end;
 WaitCursor(false);
end;

procedure TMyPreview.ShowVideoFile(s:string;do_preview:boolean);
begin
 FreeControls;
 if do_preview then
   ShowPreviewVideo(s);
 Caption:=S_PREVIEW_EXT;
end;

procedure TMyPreview.ShowUnknownFile(s:string;do_preview:boolean);
begin
 FreeControls;
 Caption:=S_UNKNOWN_FILE;
end;

procedure TMyPreview.PreviewFile(s:string;do_preview:boolean);
begin
 if trim(s)='' then
  ShowEmptyFile(s,do_preview)
 else
 if IsPictureFile(s) then
  ShowPictureFile(s,do_preview)
 else
 if IsAudioFile(s) then
  ShowAudioFile(s,do_preview)
 else
 if IsVideoFile(s) then
  ShowVideoFile(s,do_preview)
 else
  ShowUnknownFile(s,do_preview);
end;

end.
