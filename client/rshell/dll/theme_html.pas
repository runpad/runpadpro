
unit theme_html;

interface

uses Windows, Classes, Controls, theme, MyWebBrowser;


type
     TThemeHTML = class(TTheme)
     private
      conn : PDeskExternalConnection;
      WebBrowser : TMyWebBrowser;
      last_nav_url: string;
     
     public
      class function IsMyURL(const url:string):boolean;

      constructor Create(host_wnd:HWND; host_ctrl:TWinControl; 
                         _conn:PDeskExternalConnection; const url:string); overload;
      destructor Destroy; override;
      
      function IsLoaded:boolean; override;
      procedure Refresh; override;
      procedure Repaint; override;
      procedure OnStatusStringChanged; override;
      procedure OnActiveSheetChanged; override;
      procedure OnPageShaded; override;
      procedure OnDisplayChanged; override;

     private
      procedure WebBrowserBeforeNavigate2(Sender: TObject;
        const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
        Headers: OleVariant; var Cancel: WordBool);
      procedure WebBrowserNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
      procedure WebBrowserNewWindow2(Sender: TObject; var ppDisp: IDispatch;
        var Cancel: WordBool);
      procedure WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
      procedure WebBrowserDocumentComplete(Sender: TObject;
        const pDisp: IDispatch; var URL: OleVariant);
      function WebBrowserScriptError(const err_text:string) : boolean;

      function RSGetMachineLoc(Params: array of OleVariant): OleVariant;
      function RSGetMachineDesc(Params: array of OleVariant): OleVariant;
      function RSGetVipSessionName(Params: array of OleVariant): OleVariant;
      function RSGetNumSheets(Params: array of OleVariant): OleVariant;
      function RSGetSheetName(Params: array of OleVariant): OleVariant;
      function RSIsSheetActive(Params: array of OleVariant): OleVariant;
      function RSSetSheetActive(Params: array of OleVariant): OleVariant;
      function RSGetSheetBGPic(Params: array of OleVariant): OleVariant;
      function RSGetStatusString(Params: array of OleVariant): OleVariant;
      function RSGetInfoText(Params: array of OleVariant): OleVariant;
      function RSIsPageShaded(Params: array of OleVariant): OleVariant;
      function RSGetResTranslatedUrl(Params: array of OleVariant): OleVariant;
      function RSDoShellExec(Params: array of OleVariant): OleVariant;
      function RSGetInputText(Params: array of OleVariant): OleVariant;
      function RSAlert(Params: array of OleVariant): OleVariant;
      function RSInputWrapper(Params: array of OleVariant): OleVariant;

      function IsNeedToZoomInternal():boolean;
     end;



implementation

uses SysUtils, StrUtils, Registry, Variants, SHDocVw, tools;


const URL_DONT_UNESCAPE_EXTRA_INFO    = $02000000;
const URL_UNESCAPE_INPLACE            = $00100000;
const URL_ESCAPE_SPACES_ONLY          = $04000000;

function PathIsURL(const pszPath:pchar):longbool; stdcall; external 'shlwapi.dll' name 'PathIsURLA';
function UrlUnescape(pszURL,pszUnescaped:pchar; pcchUnescaped:PDWORD; dwFlags:DWORD):HRESULT; stdcall; external 'shlwapi.dll' name 'UrlUnescapeA';
function UrlEscape(const pszURL:pchar; pszEscaped:pchar; pcchEscaped:PDWORD; dwFlags:DWORD):HRESULT; stdcall; external 'shlwapi.dll' name 'UrlEscapeA';


function ComputeResUID(const lib_path,res_name:string):cardinal;
var s:string;
    n:cardinal;
    summ:cardinal;
begin
 s:=AnsiLowerCase(lib_path+'/'+res_name);
 summ:=$A27A2396;
 for n:=1 to length(s) do
  inc(summ,cardinal(ord(s[n]))*n*n);
 Result:=summ;
end;


function ExtractResFile(const href,abs_url,local_url:string):string;
var s,lib_path,res_name:string;
    idx:integer;
    p:array[0..1024] of char;
    dwSize:DWORD;
    err,lib,res,g,data_size:cardinal;
    data_buff:pointer;
    f:integer;
begin
 Result:=local_url;

 if (abs_url='') or (local_url='') then
  Exit;

 if (not AnsiStartsText('res://',href)) or (length(href)<length('res://X:\a')) then
  Exit;

 s:=Copy(href,7,length(href)-6);
 if s[1]='/' then
  s:=Copy(s,2,length(s)-1);

 idx:=AnsiPos('/',s);
 if idx<>0 then
  setlength(s,idx-1);

 StrLCopy(p,pchar(s),sizeof(p)-1);
 dwSize:=sizeof(p)-1;
 UrlUnescape(p,nil,@dwSize,URL_DONT_UNESCAPE_EXTRA_INFO or URL_UNESCAPE_INPLACE);
 lib_path:=p;

 err:=SetErrorMode(SEM_FAILCRITICALERRORS);
 lib:=LoadLibraryEx(pchar(lib_path),0,0);
 if lib=0 then
  lib:=LoadLibraryEx(pchar(lib_path),0,LOAD_LIBRARY_AS_DATAFILE);
 SetErrorMode(err);
 if lib<>0 then
  begin
   res_name:=abs_url;
   res:=FindResource(lib,pchar(AnsiUpperCase(res_name)),pchar(23));
   if res<>0 then
    begin
     g:=LoadResource(lib,res);
     if g<>0 then
      begin
       data_buff:=LockResource(g);
       if data_buff<>nil then
        begin
         data_size:=SizeofResource(lib,res);

         p[0]:=#0;
         GetTempPath(sizeof(p),p);
         s:=p;

         if s<>'' then
          begin
           s:=IncludeTrailingPathDelimiter(s)+'rs_themes_res_tmp\';
           CreateDirectory(pchar(s),nil);

           s:=s+Format('%.8x%s',[ComputeResUID(lib_path,res_name),ExtractFileExt(res_name)]);

           f:=FileCreate(s);
           if f<>-1 then
            begin
             FileWrite(f,data_buff^,data_size);
             FileClose(f);
            end;

           if FileExists(s) then
            begin
             dwSize:=sizeof(p)-1;
             p[0]:=#0;
             if UrlEscape(pchar(s),p,@dwSize,URL_ESCAPE_SPACES_ONLY)=S_OK then
              s:=p;

             s:='file://'+s;
             Result:=s;
            end;
          end;
        end;
      end;
    end;
   FreeLibrary(lib);
  end;
end;


class function TThemeHTML.IsMyURL(const url:string):boolean;
begin
 // we do not check file's existence here:
 Result:=(url<>'') and (PathIsURL(pchar(url)) or AnsiEndsText('\',url) or AnsiStartsText('.htm',ExtractFileExt(url)));
end;


constructor TThemeHTML.Create(host_wnd:HWND; host_ctrl:TWinControl; 
                              _conn:PDeskExternalConnection; const url:string);
var reg:TRegistry;
    exename,s,s1,s2:string;
    t:array[0..MAX_PATH]of char;
begin
 inherited Create();

 conn:=_conn;
 WebBrowser:=nil;
 last_nav_url:='';

 reg:=TRegistry.Create;
 // with some audio-drivers we have small deadlock when clicking to the html-theme link
 // and doing sheet-animation via PostMessage(RS_SETACTIVESHEET)
 // so, simply remove nav-click sound:
 if reg.OpenKey('AppEvents\Schemes\Apps\Explorer\Navigating\.current',true) then
   begin
    try
     reg.WriteString('','');
    except end;
    reg.CloseKey;
   end;
 if reg.OpenKey('AppEvents\Schemes\Apps\Explorer\ActivatingDocument\.current',true) then
   begin
    try
     reg.WriteString('','');
    except end;
    reg.CloseKey;
   end;

 // Enable IE8+ engine
 t[0]:=#0;
 Windows.GetModuleFileName(0,t,sizeof(t));
 exename:=ExtractFileName(string(t));
 if reg.OpenKey('Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION',true) then
   begin
    try
     reg.WriteInteger(exename,9999);
    except end;
    reg.CloseKey;
   end;
 
 reg.Free;

 // create object
 WebBrowser:=TMyWebBrowser.Create(nil);

 WebBrowser.TabStop:=false;
 WebBrowser.Align:=alClient;

 WebBrowser.ContextMenuEnabled:=false;
 WebBrowser.Border3DEnabled:=false;
 WebBrowser.ScrollEnabled:=false;
// WebBrowser.DPIAware:=true;
 WebBrowser.TextSelectEnabled:=false;
 WebBrowser.AllowFileDownload:=false;
 WebBrowser.AllowAlerts:=false;
 WebBrowser.DLOptions:=[dlImages, dlVideos, dlSounds, dlNoJava, dlNoActiveXDownload{, dlSilent}];

 WebBrowser.OnBeforeNavigate2 := WebBrowserBeforeNavigate2;
 WebBrowser.OnNavigateComplete2 := WebBrowserNavigateComplete2;
 WebBrowser.OnNewWindow2 := WebBrowserNewWindow2;
 WebBrowser.OnWindowClosing := WebBrowserWindowClosing;
 WebBrowser.OnDocumentComplete := WebBrowserDocumentComplete;
 WebBrowser.OnScriptError := WebBrowserScriptError;

 WebBrowser.Bind('getMachineLoc',RSGetMachineLoc);
 WebBrowser.Bind('getMachineDesc',RSGetMachineDesc);
 WebBrowser.Bind('getVipSessionName',RSGetVipSessionName);
 WebBrowser.Bind('getStatusString',RSGetStatusString);
 WebBrowser.Bind('getInfoText',RSGetInfoText);
 WebBrowser.Bind('getNumSheets',RSGetNumSheets);
 WebBrowser.Bind('getSheetName',RSGetSheetName);
 WebBrowser.Bind('isSheetActive',RSIsSheetActive);
 WebBrowser.Bind('setSheetActive',RSSetSheetActive);
 WebBrowser.Bind('getSheetBGPic',RSGetSheetBGPic);
 WebBrowser.Bind('isPageShaded',RSIsPageShaded);
 WebBrowser.Bind('getResTranslatedUrl',RSGetResTranslatedUrl);
 WebBrowser.Bind('doShellExec',RSDoShellExec);
 WebBrowser.Bind('getInputText',RSGetInputText);
 WebBrowser.Bind('alert',RSAlert);
 WebBrowser.Bind('inputWrapper',RSInputWrapper);

 TWinControl(WebBrowser).Parent:=host_ctrl;

 // navigate
 s:=url;
 
 if not PathIsURL(pchar(s)) then
  begin
   if DirectoryExists(s) then
    begin
     s1:=IncludeTrailingPathDelimiter(s)+'index.html';
     s2:=IncludeTrailingPathDelimiter(s)+'index.htm';
     if FileExists(s1) then
      s:=s1
     else
      s:=s2;
    end;
  end;
 
 try
  WebBrowser.Navigate(s);
  last_nav_url:=s;
 except 
 end;

 //Repaint();
end;


destructor TThemeHTML.Destroy;
begin
 conn:=nil;
 
 if WebBrowser<>nil then
  begin
   try
    if WebBrowser.Busy then
     WebBrowser.Stop;
   except end;
   TWinControl(WebBrowser).Parent:=nil;
   WebBrowser.Free;
   WebBrowser:=nil;
  end;

 inherited;
end;


function TThemeHTML.IsLoaded:boolean;
begin
 Result:=true;
end;


procedure TThemeHTML.Refresh;
begin
 if WebBrowser<>nil then
  begin
   try
    //var parm:OleVariant;
    //parm:=3;//REFRESH_COMPLETELY;
    //WebBrowser.Refresh2(parm);
    WebBrowser.Refresh;
   except end;
  end;
end;


procedure TThemeHTML.Repaint;
begin
 if WebBrowser<>nil then
  begin
   WebBrowser.Repaint;
  end;
end;


procedure TThemeHTML.OnStatusStringChanged();
begin
 if WebBrowser<>nil then
  begin
   try
    WebBrowser.InvokeScript('OnStatusStringChanged',[]);
   except
   end;
  end;
end;


procedure TThemeHTML.OnActiveSheetChanged();
begin
 if WebBrowser<>nil then
  begin
   try
    WebBrowser.InvokeScript('OnActiveSheetChanged',[]);
   except
   end;
  end;
end;


procedure TThemeHTML.OnPageShaded();
begin
 if WebBrowser<>nil then
  begin
   try
    WebBrowser.InvokeScript('OnPageShaded',[]);
   except
   end;
  end;
end;


procedure TThemeHTML.OnDisplayChanged();
begin
 Repaint;  //maybe Refresh better?
end;


procedure TThemeHTML.WebBrowserBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
 Cancel:=false;

 //todo: check last_nav_url and URL here for safe browsing...

end;


procedure TThemeHTML.WebBrowserNavigateComplete2(Sender: TObject;  const pDisp: IDispatch; var URL: OleVariant);
begin
 if IsNeedToZoomInternal() then
  WebBrowser.SetZoom(100);
end;


procedure TThemeHTML.WebBrowserNewWindow2(Sender: TObject;
  var ppDisp: IDispatch; var Cancel: WordBool);
begin
 Cancel:=TRUE;
end;


procedure TThemeHTML.WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
begin
 Cancel:=TRUE;
end;


procedure TThemeHTML.WebBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 if (WebBrowser<>nil) and (WebBrowser.Application=pDisp) then
  begin
  end;
end;


function TThemeHTML.WebBrowserScriptError(const err_text:string) : boolean;
begin
 if (conn<>nil) and (@conn.OnError<>nil) then
  conn.OnError(pchar(err_text));

 Result:=true; //continue running scripts
end;


function TThemeHTML.RSGetMachineLoc(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetMachineLoc<>nil) then
   Result:=string(conn.GetMachineLoc())
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetMachineDesc(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetMachineDesc<>nil) then
   Result:=string(conn.GetMachineDesc())
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetVipSessionName(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetVipSessionName<>nil) then
   Result:=string(conn.GetVipSessionName())
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetNumSheets(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetNumSheets<>nil) then
   Result:=conn.GetNumSheets()
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetSheetName(Params: array of OleVariant): OleVariant;
var idx:integer;
begin
 Result:=unassigned;

 if length(Params)=1 then
  begin
   try
    idx:=integer(Params[0]);
    if (conn<>nil) and (@conn.GetSheetName<>nil) then
      Result:=string(conn.GetSheetName(idx));
   except
   end;
  end;
end;


function TThemeHTML.RSIsSheetActive(Params: array of OleVariant): OleVariant;
var idx:integer;
begin
 Result:=unassigned;

 if length(Params)=1 then
  begin
   try
    idx:=integer(Params[0]);
    if (conn<>nil) and (@conn.IsSheetActive<>nil) then
      Result:=conn.IsSheetActive(idx);
   except
   end;
  end;
end;


function TThemeHTML.RSSetSheetActive(Params: array of OleVariant): OleVariant;
var idx:integer;
    state:boolean;
begin
 Result:=unassigned;

 if length(Params)=2 then
  begin
   try
    idx:=integer(Params[1]);
    try
     state:=boolean(Params[0]);

     if (conn<>nil) and (@conn.SetSheetActive<>nil) then
       conn.SetSheetActive(idx,state);
    except
    end;
   except
   end;
  end;
end;


function TThemeHTML.RSGetSheetBGPic(Params: array of OleVariant): OleVariant;
var idx:integer;
begin
 Result:=unassigned;

 if length(Params)=1 then
  begin
   try
    idx:=integer(Params[0]);
    if (conn<>nil) and (@conn.GetSheetBGPic<>nil) then
      Result:=string(conn.GetSheetBGPic(idx));
   except
   end;
  end;
end;


function TThemeHTML.RSGetStatusString(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetStatusString<>nil) then
   Result:=string(conn.GetStatusString())
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetInfoText(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.GetInfoText<>nil) then
   Result:=string(conn.GetInfoText())
 else
   Result:=unassigned;
end;


function TThemeHTML.RSIsPageShaded(Params: array of OleVariant): OleVariant;
begin
 if (conn<>nil) and (@conn.IsPageShaded<>nil) then
   Result:=conn.IsPageShaded()
 else
   Result:=unassigned;
end;


function TThemeHTML.RSGetResTranslatedUrl(Params: array of OleVariant): OleVariant;
var s_href,s_res,s_url : string;
begin
 Result:=unassigned;

 if length(Params)=3 then
  begin
   try
    s_href:=string(Params[2]);
    s_res:=string(Params[1]);
    s_url:=string(Params[0]);

    Result:=ExtractResFile(s_href,s_res,s_url);
   except
   end;
  end;
end;


function TThemeHTML.RSDoShellExec(Params: array of OleVariant): OleVariant;
var exe,args:string;
begin
 Result:=unassigned;

 exe:='';
 args:='';
 
 if length(Params)=2 then
  begin
   try
    exe:=string(Params[1]);
    args:=string(Params[0]);
   except
   end;
  end
 else
 if length(Params)=1 then
  begin
   try
    exe:=string(Params[0]);
   except
   end;
  end;

 if exe<>'' then
  begin
   if (conn<>nil) and (@conn.DoShellExec<>nil) then
     conn.DoShellExec(pchar(exe),pchar(args));
  end;
end;


function TThemeHTML.RSGetInputText(Params: array of OleVariant): OleVariant;
var title,text:string;
begin
 Result:=unassigned;

 if length(Params)=2 then
  begin
   title:='';
   text:='';

   try
    title:=string(Params[1]);
    text:=string(Params[0]);
   except
   end;

   if (conn<>nil) and (@conn.GetInputText<>nil) then
     Result:=widestring(string(conn.GetInputText(pchar(title),pchar(text))));
  end;
end;


function TThemeHTML.RSAlert(Params: array of OleVariant): OleVariant;
var text:string;
begin
 Result:=unassigned;

 if length(Params)=1 then
  begin
   text:='';

   try
    text:=string(Params[0]);
   except
   end;

   if (conn<>nil) and (@conn.Alert<>nil) then
     conn.Alert(pchar(text));
  end;
end;


function GetElAbsX(el:OleVariant):integer;
var t:OleVariant;
begin
 Result:=0;

 try
  t:=el;
  while true do
   begin
    Result := Result + integer(t.offsetLeft);
    t := t.offsetParent;
   end;
 except
 end;

 try
  t:=el;
  while true do
   begin
    t := t.parentElement;
    Result := Result - integer(t.scrollLeft);
   end;
 except
 end;
end;


function GetElAbsY(el:OleVariant):integer;
var t:OleVariant;
begin
 Result:=0;

 try
  t:=el;
  while true do
   begin
    Result := Result + integer(t.offsetTop);
    t := t.offsetParent;
   end;
 except
 end;

 try
  t:=el;
  while true do
   begin
    t := t.parentElement;
    Result := Result - integer(t.scrollTop);
   end;
 except
 end;
end;


function TThemeHTML.RSInputWrapper(Params: array of OleVariant): OleVariant;
var x,y,w,h,maxlen:integer;
    pwdchar:char;
    intext,objtype:string;
    obj:OleVariant;
    is_text,is_pwd:boolean;
begin
 Result:=unassigned;

 if length(Params)=1 then
  begin
   Result:=true;
   
   obj:=Params[0];

   try objtype:=obj.type; except objtype:=''; end;

   is_text:=(AnsiCompareText(objtype,'text')=0) or (AnsiCompareText(objtype,'textarea')=0);
   is_pwd:=AnsiCompareText(objtype,'password')=0;

   if is_text or is_pwd then
    begin
     if is_text then
      pwdchar:=#0
     else
      pwdchar:='*';

     x:=GetElAbsX(obj);
     y:=GetElAbsY(obj);

     try w:=obj.offsetWidth; except w:=100; end;
     try h:=obj.offsetHeight; except h:=20; end;
     try maxlen:=obj.maxLength; except maxlen:=$7FFFFFFF; end;
     try intext:=obj.value; except intext:=''; end;

     if (conn<>nil) and (@conn.GetInputTextPos<>nil) then
      begin
       try
        obj.value:=widestring(string(conn.GetInputTextPos(pwdchar,x,y,w,h,maxlen,pchar(intext))));
       except
       end;
      end;
    end;
  end;
end;


function TThemeHTML.IsNeedToZoomInternal():boolean;
var reg:TRegistry;
    ie_ver_s:string;
    ie_ver_i,idx:integer;
    dc:HDC;
    dpi_x,dpi_y:integer;
begin
 Result:=false;

 reg:=TRegistry.Create();
 reg.RootKey:=HKEY_LOCAL_MACHINE;
 ie_ver_s:=ReadRegStr(reg,'SOFTWARE\Microsoft\Internet Explorer','svcVersion','');
 if ie_ver_s='' then
  ie_ver_s:=ReadRegStr(reg,'SOFTWARE\Microsoft\Internet Explorer','Version','');
 reg.Free;

 idx:=Pos('.',ie_ver_s);
 if idx<>0 then
  ie_ver_i:=StrToIntDef(Copy(ie_ver_s,1,idx-1),0)
 else
  ie_ver_i:=0;

 if ie_ver_i>=11 then
  begin
   dc:=GetDC(0);
   dpi_x:=GetDeviceCaps(dc,LOGPIXELSX);
   dpi_y:=GetDeviceCaps(dc,LOGPIXELSY);
   ReleaseDC(0,dc);
   if (dpi_x>96) or (dpi_y>96) then
    Result:=true;
  end;
end;


end.
