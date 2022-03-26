
library rsrules;

uses
  Windows,
  main in 'main.pas' {RulesForm};



procedure ShowRules(parent:HWND;is_ls:longbool;const filename:pchar); cdecl;
begin
 ShowRulesWindowModal(parent,is_ls,string(filename));
end;


exports
 ShowRules;


begin
end.
