
unit tools;

interface

uses Windows;


const URL_PART_NONE       = 0;
const URL_PART_SCHEME     = 1;
const URL_PART_HOSTNAME   = 2;
const URL_PART_USERNAME   = 3;
const URL_PART_PASSWORD   = 4;
const URL_PART_PORT       = 5;
const URL_PART_QUERY      = 6;


function UrlGetPart(const pszIn:pchar; pszOut:pchar; pcchOut:pcardinal; dwPart,dwFlags:cardinal):HRESULT; stdcall;
function GetUrlHost(const url:string):string;
function PathMatchSpec(const filename,spec:pchar):BOOL stdcall;




implementation

uses SysUtils;


function UrlGetPart(const pszIn:pchar; pszOut:pchar; pcchOut:pcardinal; dwPart,dwFlags:cardinal):HRESULT; stdcall; external 'shlwapi.dll' name 'UrlGetPartA';
function PathMatchSpec(const filename,spec:pchar):BOOL stdcall; external 'shlwapi.dll' name 'PathMatchSpecA';



function GetUrlPartInternal(const url:string;part:integer):string;
var t:array [0..MAX_PATH-1] of char;
    rc:cardinal;
begin
 Result:='';

 if url='' then
  exit;

 t[0]:=#0;
 rc:=sizeof(t);
 UrlGetPart(pchar(url),@t,@rc,part,0);

 Result:=string(t);
end;


function GetUrlHost(const url:string):string;
begin
 Result:=GetUrlPartInternal(url,URL_PART_HOSTNAME);
end;



end.
