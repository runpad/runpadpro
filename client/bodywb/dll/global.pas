unit global;

interface

uses Windows, ActiveX, main;


type TSTRING = array [0..MAX_PATH-1] of char;
type TPATH = array [0..MAX_PATH-1] of char;

type TCONFIG = record
 msg_flash_notify : integer;
 msg_runprogram : integer;
 msg_site_restrict1 : integer;
 msg_site_restrict2 : integer;
 msg_shellexecute : integer;

 regpath : TSTRING;

 use_std_downloader : longbool;
 max_download_windows : integer;
 max_download_size : integer;
 use_allowed_download_types : longbool;
 allowed_download_types : TSTRING;
 download_autorun : TSTRING;
 allow_run_downloaded : longbool;
 dont_show_download_speed : longbool;
 download_speed_limit : integer;
 wb_flash_disable : longbool;
 ie_home_page : TSTRING;
 protect_run_in_ie : longbool;
 max_ie_windows : integer;
 ie_clean_history : longbool;
 allow_ie_print : longbool;
 disallow_add2fav : longbool;
 disable_view_html : longbool;
 bodywb_caption : TSTRING;
 rus2eng_wb : longbool;
 wb_search_bars : longbool;
 fav_path : TPATH;
 bodymail_integration : longbool;
end;
PCONFIG = ^TCONFIG;


function AddBrowser(parent:HWND;const url:string;show:boolean):IDispatch;
function GetBrowsersCount:integer;
function GetBrowserAt(idx:integer):TBodyIEForm;
procedure RemoveBrowser(form:TBodyIEForm);
procedure HideBrowser(form:TBodyIEForm);
procedure BrowsersCleanup;
procedure AddDownloadProcess;
procedure RemoveDownloadProcess;
procedure CheckForClose;
procedure DownloadFileAsync(const url,referer:string);
procedure CorrectFileUrl(var s:string);
function WinExecW(const _cmdline:widestring):boolean;

type 
 TDownloadFileAsync = procedure(const url,referer:pchar;msg_begin,msg_end:integer) cdecl;


var
 g_config : PCONFIG = nil;
 is_simple : boolean = false;
 is_notopmost : boolean = false;
 pDownloadFileAsync : TDownloadFileAsync = nil;

 msg_download_begin : integer = 0;
 msg_download_end : integer = 0;
 msg_viewsource : integer = 0;
 msg_vipend : integer = 0;
 msg_navigatefailed : integer = 0;
 msg_langchanged : integer = 0;
 msg_redirection : integer = 0;

 g_last_url : string = '';


implementation

uses SysUtils,Registry,Forms,StrUtils;

{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}


var
  browsers : array of TBodyIEForm;
  downloads : integer = 0;



function EnumIEWindowsProc(hwnd:HWND;lParam:integer):longbool; stdcall;
type PInteger = ^integer;
var pcounter : PInteger;
    s : array [0..260] of char;
    p : pchar;
begin
 pcounter:=PInteger(lParam);
 p:=@s;
 s[0]:=#0;
 GetClassName(hwnd,p,sizeof(s));
 if string(p)='TBodyIEForm' then
  begin
   if IsWindowVisible(hwnd) then
     inc(pcounter^);
  end;

 Result:=true;
end;


function EnumAllOurWindowsProc(hwnd:HWND;lParam:integer):longbool; stdcall;
type PInteger = ^integer;
var pcounter : PInteger;
    pid : cardinal;
    s : array [0..260] of char;
begin
 pcounter:=PInteger(lParam);

 pid:=0;
 GetWindowThreadProcessId(hwnd,@pid);
 if pid=GetCurrentProcessId() then
  begin
   if IsWindowVisible(hwnd) then
    begin
     s[0]:=#0;
     GetClassName(hwnd,@s,sizeof(s));
     if (string(s)<>'SysShadow') and (string(s)<>'Internet Explorer_Hidden') then //fix
      inc(pcounter^);
    end;
  end;

 Result:=true;
end;



function CheckIEWindowsCount(parent:HWND):boolean;
var maxw,counter:integer;
begin
  maxw:=g_config.max_ie_windows;

  if maxw=0 then
   begin
    Result:=true;
    exit;
   end;

  counter:=0;
  EnumWindows(@EnumIEWindowsProc,integer(@counter));

  if counter<maxw then
   begin
    Result:=true;
    exit;
   end;

  MessageBox(parent,LSP(1506),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION or MB_TOPMOST);

  Result:=false;
end;



function GetBrowsersCount:integer;
begin
 if browsers=nil then
  Result:=0
 else
  Result:=Length(browsers);
end;


function GetBrowserAt(idx:integer):TBodyIEForm;
begin
 if (idx<0) or (idx>=GetBrowsersCount) then
  Result:=nil
 else
  Result:=browsers[idx];
end;


function AddBrowser(parent:HWND;const url:string;show:boolean):IDispatch;
const MUTEXNAME = 'RPBodyExplWindowStarted';
var idx : integer;
    form : TBodyIEForm;
    mutex : cardinal;
begin
 Result:=nil;

 mutex:=OpenMutex(SYNCHRONIZE,FALSE,pchar(MUTEXNAME));
 if mutex<>0 then
  begin
   WaitForSingleObject(mutex,4000);
   Windows.CloseHandle(mutex);
  end;

 if CheckIEWindowsCount(parent) then
  begin
   mutex:=CreateMutex(nil,FALSE,pchar(MUTEXNAME));
   
   idx:=Length(browsers);
   SetLength(browsers,idx+1);

   form:=TBodyIEForm.Create(nil);
   browsers[idx]:=form;
   form.navigate_url:=url;
   Result:=form.GetWebBrowserApp;
   if show then
    begin
     form.WindowState:=wsMaximized;
     form.Show;
    end;

   Windows.CloseHandle(mutex);
  end;
end;


procedure CheckForClose;
var n,counter:integer;
    find:boolean;
begin
 if downloads<>0 then
  exit;
 
 find:=false;
 for n:=0 to GetBrowsersCount-1 do
  if (browsers[n]<>nil) {and (browsers[n].Visible)} then
   begin
    find:=true;
    break;
   end;

 if not find then
  begin
   counter:=0;
   EnumWindows(@EnumAllOurWindowsProc,integer(@counter));
 
   if counter=0 then
    PostQuitMessage(1);  
  end;
end;


procedure RemoveBrowser(form:TBodyIEForm);
var n:integer;
begin
 for n:=0 to GetBrowsersCount-1 do
  begin
   if browsers[n]=form then
    begin
     browsers[n]:=nil;  //do not free it!
     break;
    end;
  end;

 CheckForClose;
end;


procedure HideBrowser(form:TBodyIEForm);
begin
 CheckForClose;
end;


procedure BrowsersCleanup;
var 
 n,counter:integer;
 reg:TRegistry;
 b : TBodyIEForm;
begin
 for n:=0 to GetBrowsersCount-1 do
  begin
   if browsers[n]<>nil then
    begin
     b:=browsers[n];
     browsers[n]:=nil;
     b.Free;  //additional PostQuitMessage() can happens here
    end;
  end;

 browsers:=nil;

 counter:=0;
 EnumWindows(@EnumIEWindowsProc,integer(@counter));

 if counter = 0 then
  begin
   // clean history
   if g_config.ie_clean_history then
    begin
     reg:=TRegistry.Create;
     reg.LazyWrite:=FALSE;
     if reg.OpenKey(string(g_config.regpath), false) then
      begin
        try
         reg.DeleteKey('IEHistory');
        except end;
       reg.CloseKey;
      end;
     reg.Free;
    end;
  end;
end;


procedure AddDownloadProcess;
begin
 inc(downloads);
end;


procedure RemoveDownloadProcess;
begin
 dec(downloads);
 if downloads<0 then
  downloads:=0;
 CheckForClose;
end;


procedure DownloadFileAsync(const url,referer:string);
begin
 if @pDownloadFileAsync<>nil then
   pDownloadFileAsync(pchar(url),pchar(referer),msg_download_begin,msg_download_end);
end;


procedure CorrectFileUrl(var s:string);
begin
 if AnsiStartsText('file:',s) then
  begin
   if AnsiStartsText('file:///',s) then
    Delete(s,7,1);
  end;
end;


function WinExecW(const _cmdline:widestring):boolean;
var si:_STARTUPINFOA;
    pi:_PROCESS_INFORMATION;
    cmdline:widestring;
begin
 Result:=false;
 
 cmdline:=_cmdline;  // because string can be modified inside CreateProcessW()!
 if cmdline<>'' then
  begin
   FillChar(si,sizeof(si),0);
   si.cb:=sizeof(si);
   if CreateProcessW(nil,pwidechar(cmdline),nil,nil,false,0,nil,nil,si,pi) then
    begin
     CloseHandle(pi.hThread);
     CloseHandle(pi.hProcess);
     Result:=true;
    end;
  end;
end;


end.
