
unit theme_plugin;

interface

uses Windows, Classes, Controls, theme;


type
     TThemeCreate = function(host_wnd:HWND; _conn:PDeskExternalConnection) : pointer stdcall;
     TThemeDestroy = procedure(obj:pointer) stdcall;
     TThemeRefresh = procedure(obj:pointer) stdcall;
     TThemeRepaint = procedure(obj:pointer) stdcall;
     TThemeOnStatusStringChanged = procedure(obj:pointer) stdcall;
     TThemeOnActiveSheetChanged = procedure(obj:pointer) stdcall;
     TThemeOnPageShaded = procedure(obj:pointer) stdcall;
     TThemeOnDisplayChanged = procedure(obj:pointer) stdcall;
     
     TThemePlugin = class(TTheme)
     private
      conn : PDeskExternalConnection;
      hlib : cardinal;
      hobj : pointer;

      pThemeCreate                : TThemeCreate;
      pThemeDestroy               : TThemeDestroy;
      pThemeRefresh               : TThemeRefresh;
      pThemeRepaint               : TThemeRepaint;
      pThemeOnStatusStringChanged : TThemeOnStatusStringChanged;
      pThemeOnActiveSheetChanged  : TThemeOnActiveSheetChanged;
      pThemeOnPageShaded          : TThemeOnPageShaded;
      pThemeOnDisplayChanged      : TThemeOnDisplayChanged;
      
     public
      class function IsMyURL(const url:string):boolean;

      constructor Create(host_wnd:HWND; host_ctrl:TWinControl; 
                         _conn:PDeskExternalConnection; const url:string); overload;
      destructor Destroy; override;
      
      function IsLoaded:boolean; override;
      procedure Refresh; override;
      procedure Repaint; override;
      procedure OnStatusStringChanged(); override;
      procedure OnActiveSheetChanged(); override;
      procedure OnPageShaded(); override;
      procedure OnDisplayChanged(); override;

     end;



implementation

uses SysUtils, StrUtils;


function PathIsURL(const pszPath:pchar):longbool; stdcall; external 'shlwapi.dll' name 'PathIsURLA';


class function TThemePlugin.IsMyURL(const url:string):boolean;
begin
 // we do not check file's existence here:
 Result:=(url<>'') and (not PathIsURL(pchar(url))) and ((AnsiCompareText(ExtractFileExt(url),'.dll')=0) or (AnsiCompareText(ExtractFileExt(url),'.theme')=0));
end;


constructor TThemePlugin.Create(host_wnd:HWND; host_ctrl:TWinControl; 
                              _conn:PDeskExternalConnection; const url:string);
var old_err : cardinal;
begin
 inherited Create();

 conn:=_conn;
 hlib:=0;
 hobj:=nil;

 pThemeCreate                := nil;
 pThemeDestroy               := nil;
 pThemeRefresh               := nil;
 pThemeRepaint               := nil;
 pThemeOnStatusStringChanged := nil;
 pThemeOnActiveSheetChanged  := nil;
 pThemeOnPageShaded          := nil;
 pThemeOnDisplayChanged      := nil;

 if url<>'' then
  begin
   old_err:=Windows.SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
   hlib:=LoadLibrary(pchar(url));
   Windows.SetErrorMode(old_err);

   if hlib<>0 then
    begin
     pThemeCreate                := GetProcAddress(hlib,'ThemeCreate');
     pThemeDestroy               := GetProcAddress(hlib,'ThemeDestroy');
     pThemeRefresh               := GetProcAddress(hlib,'ThemeRefresh');
     pThemeRepaint               := GetProcAddress(hlib,'ThemeRepaint');
     pThemeOnStatusStringChanged := GetProcAddress(hlib,'ThemeOnStatusStringChanged');
     pThemeOnActiveSheetChanged  := GetProcAddress(hlib,'ThemeOnActiveSheetChanged');
     pThemeOnPageShaded          := GetProcAddress(hlib,'ThemeOnPageShaded');
     pThemeOnDisplayChanged      := GetProcAddress(hlib,'ThemeOnDisplayChanged');

     if (@pThemeCreate<>nil) and
        (@pThemeDestroy<>nil) and
        (@pThemeRefresh<>nil) and
        (@pThemeRepaint<>nil) and
        (@pThemeOnStatusStringChanged<>nil) and
        (@pThemeOnActiveSheetChanged<>nil) and
        (@pThemeOnPageShaded<>nil) and
        (@pThemeOnDisplayChanged<>nil) then
      begin
       hobj:=pThemeCreate(host_wnd,_conn);
      end;
    end;
  end;
end;


destructor TThemePlugin.Destroy;
begin
 conn:=nil;

 if hobj<>nil then
  begin
   pThemeDestroy(hobj);
   hobj:=nil;
  end;

 if hlib<>0 then
  begin
   FreeLibrary(hlib);
   hlib:=0;
  end;

 inherited;
end;


function TThemePlugin.IsLoaded:boolean;
begin
 Result:=hobj<>nil;
end;


procedure TThemePlugin.Refresh;
begin
 if hobj<>nil then
  pThemeRefresh(hobj);
end;


procedure TThemePlugin.Repaint;
begin
 if hobj<>nil then
  pThemeRepaint(hobj);
end;


procedure TThemePlugin.OnStatusStringChanged();
begin
 if hobj<>nil then
  pThemeOnStatusStringChanged(hobj);
end;


procedure TThemePlugin.OnActiveSheetChanged();
begin
 if hobj<>nil then
  pThemeOnActiveSheetChanged(hobj);
end;


procedure TThemePlugin.OnPageShaded();
begin
 if hobj<>nil then
  pThemeOnPageShaded(hobj);
end;


procedure TThemePlugin.OnDisplayChanged();
begin
 if hobj<>nil then
  pThemeOnDisplayChanged(hobj);
end;



end.
