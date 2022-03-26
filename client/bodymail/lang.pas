
unit lang;

interface

function S_WARNING         :pchar;
function S_INFO            :pchar;
function S_ERROR           :pchar;
function S_QUESTION        :pchar;
function S_IMP_HIGH        :pchar;
function S_IMP_LOW         :pchar;
function S_EMPTY_FIELDS    :pchar;
function S_CAN_CLOSE       :pchar;
function S_TITLE           :pchar;
function S_ATT_HINT        :pchar;
function S_PREPARE_MSG     :pchar;
function S_ERR_SEND        :pchar;
function S_ERR_SEND2       :pchar;
function S_SUCCESS_SEND    :pchar;
function S_ERR_ATT         :pchar;
function S_ERR_MSG         :pchar;
function S_CONNECT         :pchar;
function S_AUTH            :pchar;
function S_SENDING         :pchar;
function S_DISCONNECTING   :pchar;
function S_NO_SMTP         :pchar;
function S_BUTTONSEND      :pchar;
function S_BUTTONIMP       :pchar;
function S_BUTTONATT       :pchar;
function S_LABEL1          :pchar;
function S_LABEL2          :pchar;
function S_LABEL3          :pchar;
function S_LABEL4          :pchar;
function S_MENUDEL         :pchar;


implementation

uses SysUtils, Windows;

{$INCLUDE ..\rp_shared\RP_Shared.inc}



function S_WARNING         :pchar;  begin Result:=GetLangStr(LS_WARNING); end;
function S_INFO            :pchar;  begin Result:=GetLangStr(LS_INFO); end;
function S_ERROR           :pchar;  begin Result:=GetLangStr(LS_ERROR); end;
function S_QUESTION        :pchar;  begin Result:=GetLangStr(LS_QUESTION); end;

function S_IMP_HIGH        :pchar;  begin Result:=GetLangStr(400); end;
function S_IMP_LOW         :pchar;  begin Result:=GetLangStr(401); end;
function S_EMPTY_FIELDS    :pchar;  begin Result:=GetLangStr(402); end;
function S_CAN_CLOSE       :pchar;  begin Result:=GetLangStr(403); end;
function S_TITLE           :pchar;  begin Result:=GetLangStr(404); end;
function S_ATT_HINT        :pchar;  begin Result:=GetLangStr(405); end;
function S_PREPARE_MSG     :pchar;  begin Result:=GetLangStr(406); end;
function S_ERR_SEND        :pchar;  begin Result:=GetLangStr(407); end;
function S_ERR_SEND2       :pchar;  begin Result:=GetLangStr(408); end;
function S_SUCCESS_SEND    :pchar;  begin Result:=GetLangStr(409); end;
function S_ERR_ATT         :pchar;  begin Result:=GetLangStr(410); end;
function S_ERR_MSG         :pchar;  begin Result:=GetLangStr(411); end;
function S_CONNECT         :pchar;  begin Result:=GetLangStr(412); end;
function S_AUTH            :pchar;  begin Result:=GetLangStr(413); end;
function S_SENDING         :pchar;  begin Result:=GetLangStr(414); end;
function S_DISCONNECTING   :pchar;  begin Result:=GetLangStr(415); end;
function S_NO_SMTP         :pchar;  begin Result:=GetLangStr(416); end;
function S_BUTTONSEND      :pchar;  begin Result:=GetLangStr(417); end;
function S_BUTTONIMP       :pchar;  begin Result:=GetLangStr(418); end;
function S_BUTTONATT       :pchar;  begin Result:=GetLangStr(419); end;
function S_LABEL1          :pchar;  begin Result:=GetLangStr(420); end;
function S_LABEL2          :pchar;  begin Result:=GetLangStr(421); end;
function S_LABEL3          :pchar;  begin Result:=GetLangStr(422); end;
function S_LABEL4          :pchar;  begin Result:=GetLangStr(423); end;
function S_MENUDEL         :pchar;  begin Result:=GetLangStr(424); end;



end.
