
unit lang;

interface

function S_WARNING         :pchar;
function S_INFO            :pchar;
function S_ERROR           :pchar;
function S_QUESTION        :pchar;
function S_TITLE           :pchar;
function S_LABELKIND       :pchar;
function S_LABELTITLE      :pchar;
function S_LABELNAME       :pchar;
function S_LABELAGE        :pchar;
function S_BUTTONSEND      :pchar;
function S_BUTTONCANCEL    :pchar;
function S_KIND1           :pchar;
function S_KIND2           :pchar;
function S_KIND3           :pchar;
function S_DEFTEXT         :pchar;
function S_AGE0            :pchar;
function S_EMPTYPARMS      :pchar;
function S_SUCCESS         :pchar;


implementation

uses SysUtils, Windows;

{$INCLUDE ..\rp_shared\RP_Shared.inc}


function S_WARNING         :pchar;  begin Result:=GetLangStr(LS_WARNING); end;
function S_INFO            :pchar;  begin Result:=GetLangStr(LS_INFO); end;
function S_ERROR           :pchar;  begin Result:=GetLangStr(LS_ERROR); end;
function S_QUESTION        :pchar;  begin Result:=GetLangStr(LS_QUESTION); end;
function S_TITLE           :pchar;  begin Result:=GetLangStr(200); end;
function S_LABELKIND       :pchar;  begin Result:=GetLangStr(201); end;
function S_LABELTITLE      :pchar;  begin Result:=GetLangStr(202); end;
function S_LABELNAME       :pchar;  begin Result:=GetLangStr(203); end;
function S_LABELAGE        :pchar;  begin Result:=GetLangStr(204); end;
function S_BUTTONSEND      :pchar;  begin Result:=GetLangStr(205); end;
function S_BUTTONCANCEL    :pchar;  begin Result:=GetLangStr(206); end;
function S_KIND1           :pchar;  begin Result:=GetLangStr(207); end;
function S_KIND2           :pchar;  begin Result:=GetLangStr(208); end;
function S_KIND3           :pchar;  begin Result:=GetLangStr(209); end;
function S_DEFTEXT         :pchar;  begin Result:=GetLangStr(210); end;
function S_AGE0            :pchar;  begin Result:=GetLangStr(211); end;
function S_EMPTYPARMS      :pchar;  begin Result:=GetLangStr(212); end;
function S_SUCCESS         :pchar;  begin Result:=GetLangStr(213); end;




end.
