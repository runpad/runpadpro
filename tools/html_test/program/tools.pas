
unit tools;

interface

uses Registry;


function ReadRegStr(reg:TRegistry;const key,value,def:string):string;
function WriteRegStr(reg:TRegistry;const key,value,data:string):boolean;
function WriteRegDword(reg:TRegistry;const key,value:string;data:cardinal):boolean;


implementation


function ReadRegStr(reg:TRegistry;const key,value,def:string):string;
begin
 Result:=def;
 if reg.OpenKey(key,false) then  // do not use OpenKeyReadOnly here, because of WOW64
  begin
   try
    Result:=reg.ReadString(value);
    if Result='' then
     Result:=def;
   except
   end;
   reg.CloseKey;
  end;
end;


function WriteRegStr(reg:TRegistry;const key,value,data:string):boolean;
begin
 Result:=false;
 if reg.OpenKey(key,true) then  // do not use CreateKey here, because of WOW64
  begin
   try
    reg.WriteString(value,data);
    Result:=true;
   except
   end;
   reg.CloseKey;
  end;
end;


function WriteRegDword(reg:TRegistry;const key,value:string;data:cardinal):boolean;
begin
 Result:=false;
 if reg.OpenKey(key,true) then  // do not use CreateKey here, because of WOW64
  begin
   try
    reg.WriteInteger(value,integer(data));
    Result:=true;
   except
   end;
   reg.CloseKey;
  end;
end;



end.
