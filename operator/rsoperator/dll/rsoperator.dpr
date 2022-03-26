library rsoperator;

uses
  Windows, StrUtils, SysUtils,
  global, textbox, usermessage, forceconfirm, autologon, turnshell, filebox, copyfiles, startup, clientupdate, clientuninstall,
  main in 'main.pas' {RSOperatorForm};

{$R resource.res}



function GUI_CreateWindow(p:PHostConnection):pointer cdecl;
var f:TRSOperatorForm;
begin
 f:=TRSOperatorForm.CreateForm(p);
 Result:=f;
end;

procedure GUI_DestroyWindow(obj:pointer) cdecl;
begin
 TRSOperatorForm(obj).Free;
end;

procedure GUI_ShowWindow(obj:pointer) cdecl;
begin
 if obj<>nil then
  TRSOperatorForm(obj).SelfShow();
end;

procedure GUI_HideWindow(obj:pointer) cdecl;
begin
 if obj<>nil then
  TRSOperatorForm(obj).SelfHide();
end;

function GUI_IsWindowVisible(obj:pointer):longbool cdecl;
begin
 Result:=(obj<>nil) and TRSOperatorForm(obj).IsSelfVisible();
end;

function GUI_GetWindowHandle(obj:pointer):HWND cdecl;
begin
 Result:=0;
 if (obj<>nil) then
  Result:=TRSOperatorForm(obj).GetSelfHWND();
end;

function GUI_TextBox(out_text:pchar;instance:cardinal;icon_idx:integer;const title,text,def:pchar;maxlength:integer;allow_empty:longbool;const list_id:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 s:='';
 if ShowTextBoxFormModal(s,instance,icon_idx,title,text,def,maxlength-1,allow_empty,list_id) then
  begin
   StrLCopy(out_text,pchar(s),maxlength-1);
   Result:=true;
  end;
end;

function GUI_SendMessageBox(out_text:pchar;max_length:integer;out_delay:pinteger):longbool cdecl;
var text:string;
    delay:integer;
begin
 Result:=false;
 text:='';
 delay:=0;
 if ShowUserMessageFormModal(text,delay,max_length-1) then
  begin
   StrLCopy(out_text,pchar(text),max_length-1);
   out_delay^:=delay;
   Result:=true;
  end;
end;

function GUI_ForceConfirmBox(is_hard:PBOOL):longbool cdecl;
var b:boolean;
begin
 Result:=false;
 b:=is_hard^;
 if ShowForceConfirmFormModal(b) then
  begin
   is_hard^:=b;
   Result:=true;
  end;
end;

function GUI_AutoLogonBox(out_domain,out_login,out_pwd:pchar;inout_force:PBOOL):longbool cdecl;
var domain,login,pwd:string;
    force:boolean;
begin
 Result:=false;
 domain:='';
 login:='';
 pwd:='';
 force:=inout_force^;
 if ShowAutoLogonFormModal(domain,login,pwd,force) then
  begin
   StrLCopy(out_domain,pchar(domain),MAX_PATH-1);
   StrLCopy(out_login,pchar(login),MAX_PATH-1);
   StrLCopy(out_pwd,pchar(pwd),MAX_PATH-1);
   inout_force^:=force;
   Result:=true;
  end;
end;

function GUI_TurnShellBox(is_turnon:BOOL;out_allusers:PBOOL;out_domain,out_login,out_pwd:pchar):longbool cdecl;
var domain,login,pwd:string;
    allusers:boolean;
begin
 Result:=false;
 domain:='';
 login:='';
 pwd:='';
 allusers:=true;
 if ShowTurnShellFormModal(is_turnon,allusers,domain,login,pwd) then
  begin
   out_allusers^:=allusers;
   StrLCopy(out_domain,pchar(domain),MAX_PATH-1);
   StrLCopy(out_login,pchar(login),MAX_PATH-1);
   StrLCopy(out_pwd,pchar(pwd),MAX_PATH-1);
   Result:=true;
  end;
end;

function GUI_FileBox(out_path:pchar;instance:cardinal;icon_idx:integer;const title,text,def:pchar;const list_id:pchar;const filter:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 s:='';
 if ShowFileBoxFormModal(s,instance,icon_idx,title,text,def,list_id,filter) then
  begin
   StrLCopy(out_path,pchar(s),MAX_PATH-1);
   Result:=true;
  end;
end;

function GUI_FolderBox(out_path:pchar;instance:cardinal;icon_idx:integer;const title,text,def:pchar;const list_id:pchar):longbool cdecl;
var s:string;
begin
 Result:=false;
 s:='';
 if ShowFolderBoxFormModal(s,instance,icon_idx,title,text,def,list_id) then
  begin
   StrLCopy(out_path,pchar(s),MAX_PATH-1);
   Result:=true;
  end;
end;

function GUI_CopyFilesBox(out_pathfrom,out_pathto:pchar;out_killtasks:PBOOL):longbool cdecl;
var pathfrom,pathto:string;
    killtasks:boolean;
begin
 Result:=false;
 pathfrom:='';
 pathto:='';
 killtasks:=false;
 if ShowCopyFilesFormModal(pathfrom,pathto,killtasks) then
  begin
   StrLCopy(out_pathfrom,pchar(pathfrom),MAX_PATH-1);
   StrLCopy(out_pathto,pchar(pathto),MAX_PATH-1);
   out_killtasks^:=killtasks;
   Result:=true;
  end;
end;

function GUI_StartupDialog(p:PStartupInfo):longbool cdecl;
begin
 Result:=ShowStartupMasterDialog(p);
end;

function GUI_ClientUpdateBox(out_imm,out_force:PBOOL):longbool cdecl;
var imm,force:boolean;
begin
 Result:=false;
 imm:=false;
 force:=false;
 if ShowClientUpdateFormModal(imm,force) then
  begin
   out_imm^:=imm;
   out_force^:=force;
   Result:=true;
  end;
end;

function GUI_ClientUninstallBox(out_imm,out_force:PBOOL):longbool cdecl;
var imm,force:boolean;
begin
 Result:=false;
 imm:=true;
 force:=false;
 if ShowClientUninstallFormModal(imm,force) then
  begin
   out_imm^:=imm;
   out_force^:=force;
   Result:=true;
  end;
end;



exports
       GUI_CreateWindow,
       GUI_DestroyWindow,
       GUI_ShowWindow,
       GUI_HideWindow,
       GUI_IsWindowVisible,
       GUI_GetWindowHandle,
       GUI_TextBox,
       GUI_SendMessageBox,
       GUI_ForceConfirmBox,
       GUI_AutoLogonBox,
       GUI_TurnShellBox,
       GUI_FileBox,
       GUI_FolderBox,
       GUI_CopyFilesBox,
       GUI_StartupDialog,
       GUI_ClientUpdateBox,
       GUI_ClientUninstallBox;


begin
end.


