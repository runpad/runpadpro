
unit tools;

interface

uses Windows, Forms, Messages, Graphics, Controls, Classes, Registry;


type
  TMinModalWrapper = class(TForm)
  public
    function ShowModal:integer; override;
  end;

function ReadRegStr(reg:TRegistry;const key,value,def:string):string;


implementation


function TMinModalWrapper.ShowModal: Integer;
var msg : TMsg;
begin
  CancelDrag;
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  ReleaseCapture;

  Include(FFormState, fsModal);
  Show;
  SendMessage(Handle, CM_ACTIVATE, 0, 0);
  ModalResult := 0;

  while GetMessage(msg,0,0,0) do
   begin
    TranslateMessage(msg);
    DispatchMessage(msg);
    if ModalResult<>0 then
     break;
   end;

  Result := ModalResult;
  SendMessage(Handle, CM_DEACTIVATE, 0, 0);
  Hide;
  Exclude(FFormState, fsModal);
end;

function ReadRegStr(reg:TRegistry;const key,value,def:string):string;
begin
 Result:=def;
 if reg.OpenKeyReadOnly(key) then  // on WOW64 cannot access to 64-bit keys!
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


end.
