library bodywb;

uses
  Windows, tlhelp32, shellapi, Classes, SysUtils, StrUtils,
  main in 'main.pas',
  global in 'global.pas';


{$R resource.res}
{$INCLUDE ..\..\common\version.inc}


procedure OnGPF(const err_text:string;var msg:TMsg);
var list:TStringList;
    os:OSVERSIONINFO;
    snap:THandle;
    module:MODULEENTRY32;
    rc:boolean;
    t:array[0..MAX_PATH]of char;
    err_file:string;
    w:HWND;
begin
 list:=TStringList.Create;

 list.Add('');
 list.Add('Внимание !!!');
 list.Add('Произошла ошибка в программе WB');
 list.Add('Просьба передать эту информацию в службу поддержки Runpad Shell');
 list.Add('Также опишите ситуацию возникновения ошибки');
 list.Add('Рекомендуется также выполнить обновление Internet Explorer');
 list.Add('');

 list.Add('Runpad Ver: '+RUNPAD_VERSION_STR);
 list.Add('');

 FillChar(os,sizeof(os),0);
 os.dwOSVersionInfoSize:=sizeof(os);
 if GetVersionEx(os) then
  begin
   list.Add('OS: '+inttostr(os.dwMajorVersion)+'.'+inttostr(os.dwMinorVersion)+', build '+inttostr(os.dwBuildNumber)+' '+string(os.szCSDVersion));
   list.Add('');
  end;

 list.Add('Last message: '+inttostr(msg.message));
 list.Add('');

 list.Add('Last URL: '+g_last_url);
 list.Add('');

 list.Add(err_text);
 list.Add('');

 snap:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,0);
 if snap<>INVALID_HANDLE_VALUE then
  begin
   FillChar(module,sizeof(module),0);
   module.dwSize:=sizeof(module);
   rc:=Module32First(snap,module);
   while rc do
    begin
     list.Add(Format('Base: 0x%.8x, Size: 0x%.8x, Name: %s',[cardinal(module.modBaseAddr),module.modBaseSize,string(module.szExePath)]));
     rc:=Module32Next(snap,module);
    end;

   Windows.CloseHandle(snap);
   list.Add('');
  end;

 t[0]:=#0;
 GetTempPath(sizeof(t),t);
 err_file:=IncludeTrailingPathDelimiter(string(t))+'wb_err.txt';

 try
  Windows.DeleteFile(pchar(err_file));
  list.SaveToFile(err_file);
  w:=FindWindow('_RunpadClass',nil);
  if w=0 then
   ShellExecute(0,nil,pchar(err_file),nil,nil,SW_NORMAL)
  else
   PostMessage(w,g_config.msg_runprogram,integer(GlobalAddAtom(pchar(err_file))),0);
 except
 end;

 list.Free;
end;


procedure MyMessageHandler(var Msg: TMsg; var Handled: Boolean);
var form : TBodyIEForm;
    n : integer;
begin
 Handled:=false;

 if Msg.message = DWORD(msg_download_begin) then
  begin
   AddDownloadProcess();
   Handled:=true;
   exit;
  end;

 if Msg.message = DWORD(msg_download_end) then
  begin
   RemoveDownloadProcess();
   Handled:=true;
   exit;
  end;

 for n:=0 to GetBrowsersCount-1 do
  begin
   form:=GetBrowserAt(n);
   if form<>nil then
     if form.ProcessOwnMessage(msg) then
      begin
       Handled:=true;
       exit;
      end;
  end;
end;


procedure MessageLoop;
var msg:TMsg;
    handled : boolean;
    t : array [0..1024] of char;
begin
  while GetMessage(msg,0,0,0) do
  begin
   handled:=false;
   MyMessageHandler(msg,handled);
   if not handled then
    begin
     TranslateMessage(msg);

     try
      DispatchMessage(msg);
     except
      t[0]:=#0;
      ExceptionErrorMessage(ExceptObject,ExceptAddr,t,sizeof(t));
      OnGPF(string(t),msg);
     end;
    end;
  end;
end;


procedure TimerProc(hwnd:HWND;message,id,time:cardinal); stdcall;
begin
 CheckForClose;
end;


procedure ShowBrowser(const url:pchar;simple,notopmost:longbool;dfunc:TDownloadFileAsync;cfg:PCONFIG) cdecl;
var timer_id : cardinal;
begin
  msg_download_begin:=RegisterWindowMessage('rpdownloadui_begin');
  msg_download_end:=RegisterWindowMessage('rpdownloadui_end');
  msg_viewsource:=RegisterWindowMessage('IDM_VIEWSOURCE');
  msg_vipend:=RegisterWindowMessage('_RPVIPSessionEnd');
  msg_navigatefailed:=RegisterWindowMessage('_RPNavigateFailed');
  msg_langchanged:=RegisterWindowMessage('_RPLanguageChanged');
  msg_redirection:=RegisterWindowMessage('_RPURLRedirection');

  g_config:=cfg;
  is_simple:=simple;
  is_notopmost:=notopmost;
  pDownloadFileAsync:=dfunc;

  if AddBrowser(0,string(url),true)<>nil then
   begin
    timer_id:=SetTimer(0,0,5000,@TimerProc);
    MessageLoop;
    KillTimer(0,timer_id);
    BrowsersCleanup;
   end;
end;


exports
 ShowBrowser;


begin
end.
