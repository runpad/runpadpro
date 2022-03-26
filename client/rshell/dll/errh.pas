
unit errh;

interface

uses ActiveX, Variants;


function GetScriptErrorText(const vaIn: OleVariant): string;



implementation

uses Windows, Messages, Classes, mshtml, OleCtrls, ComObj;



function GetScriptErrorTextInternal(const vaIn: OleVariant): string;
var
  CurUnknown: IUnknown;
  CurDocument: IHTMLDocument2;
  CurWindow: IHTMLWindow2;
  EventObject: IHTMLEventObj;

  function GetProperty(const PropName: PWideChar): OleVariant;
   var
      DispParams: TDispParams;
      Disp, Status: Integer;
      PPropName: PWideChar;
   begin
      DispParams.rgvarg := nil;
      DispParams.rgdispidNamedArgs := nil;
      DispParams.cArgs := 0;
      DispParams.cNamedArgs := 0;
      PPropName := PropName;
      Status := EventObject.GetIDsOfNames(GUID_NULL, @PPropName, 1, LOCALE_SYSTEM_DEFAULT, @Disp);
      if Status = 0 then
       begin
        Status := EventObject.Invoke(disp, GUID_NULL, LOCALE_SYSTEM_DEFAULT,
           DISPATCH_PROPERTYGET, DispParams, @Result, nil, nil);
        if Status <> 0 then
          Result:='';
       end
      else
       Result:='';
   end;

begin
  Result := '';

  CurUnknown := IUnknown(TVarData(vaIn).VUnknown);
  if CurUnknown<>nil then
   begin
    CurDocument:=nil;
    CurUnknown.QueryInterface(IID_IHTMLDocument2,CurDocument);
    if CurDocument<>nil then
     begin
      CurWindow := CurDocument.Get_parentWindow;
      CurDocument := nil;
      if CurWindow<>nil then
       begin
        EventObject := CurWindow.Get_event;
        if EventObject<>nil then
         begin
          Result:=
                    'url:  ' + string(GetProperty('errorUrl')) + #13#10 +
                    'line: ' + string(GetProperty('errorline')) + #13#10 +
                    'char: ' + string(GetProperty('errorCharacter')) + #13#10 +
                    'code: ' + string(GetProperty('errorCode')) + #13#10 +
                    'msg:  ' + string(GetProperty('errorMessage')) + #13#10 ;

          EventObject:=nil;
         end;

        CurWindow:=nil;
       end;
     end;
   
    CurUnknown:=nil;
   end;
end;


function GetScriptErrorText(const vaIn: OleVariant): string;
begin
 Result:='';

 try
  Result:=GetScriptErrorTextInternal(vaIn);
 except
 end;
end;


end.

