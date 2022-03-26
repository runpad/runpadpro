unit desk_host;

interface

uses
  Windows, Forms, desk, theme;



function Desk_Create(conn:pointer;const url:pchar):HWND; cdecl;
procedure Desk_Destroy(); cdecl;
function Desk_IsVisible:longbool; cdecl;
procedure Desk_Show(); cdecl;
procedure Desk_Hide(); cdecl;
procedure Desk_Repaint(); cdecl;
procedure Desk_Refresh(); cdecl;
procedure Desk_BringToBottom(); cdecl;
procedure Desk_Navigate(const url:pchar); cdecl;
procedure Desk_OnDisplayChange(); cdecl;
procedure Desk_OnEndSession(); cdecl;
procedure Desk_OnStatusStringChanged(); cdecl;
procedure Desk_OnActiveSheetChanged(); cdecl;
procedure Desk_OnPageShaded(); cdecl;


implementation


var    
    g_form : TRSDeskForm = nil;


function Desk_Create(conn:pointer;const url:pchar):HWND;
begin
 if g_form=nil then
  begin
   g_form:=TRSDeskForm.MyCreate(PDeskExternalConnection(conn));
   g_form.MyNavigate(url);
   g_form.MyShow();
  end
 else
  begin
   g_form.MyNavigate(url);
  end;

 Result:=g_form.Handle;
end;


procedure Desk_Destroy();
begin
 if g_form<>nil then
  begin
   g_form.Destroy;
   g_form:=nil;
  end;
end;


function Desk_IsVisible:longbool;
begin
 Result:= (g_form<>nil) and g_form.MyIsVisible();
end;


procedure Desk_Show();
begin
 if g_form<>nil then
   g_form.MyShow();
end;


procedure Desk_Hide();
begin
 if g_form<>nil then
   g_form.MyHide();
end;


procedure Desk_Repaint();
begin
 if g_form<>nil then
   g_form.MyRepaint();
end;


procedure Desk_Refresh();
begin
 if g_form<>nil then
   g_form.MyRefresh();
end;


procedure Desk_BringToBottom();
begin
 if g_form<>nil then
   g_form.MyBringToBottom();
end;


procedure Desk_Navigate(const url:pchar);
begin
 if g_form<>nil then
   g_form.MyNavigate(url);
end;


procedure Desk_OnDisplayChange();
begin
 if g_form<>nil then
   g_form.MyOnDisplayChange();
end;


procedure Desk_OnEndSession();
begin
 if g_form<>nil then
   g_form.MyOnEndSession();
end;


procedure Desk_OnStatusStringChanged();
begin
 if g_form<>nil then
   g_form.MyOnStatusStringChanged();
end;


procedure Desk_OnActiveSheetChanged();
begin
 if g_form<>nil then
   g_form.MyOnActiveSheetChanged();
end;


procedure Desk_OnPageShaded();
begin
 if g_form<>nil then
   g_form.MyOnPageShaded();
end;


end.
