////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                          Bluetooth Framework (tm)                          //
//                          ------------------------                          //
//                                                                            //
//                   Copyright (C) 2006-2007 Mike Petrichenko                 //
//                            Soft Service Company                            //
//                                                                            //
//                            All  Rights Reserved                            //
//                                                                            //
//  ------------------------------------------------------------------------  //
//                                                                            //
//  Company contacts (any questions):                                         //
//    ICQ    : 190812766                                                      //
//    MSN    : mike@btframework.com                                           //
//    Phone  : +7 962 456 95 77                                               //
//             +7 962 456 95 78                                               //
//    Fax    : +1 206 309 08 44                                               //
//    WWW    : http://www.btframework.com                                     //
//             (http://www.btframework.ru/index_ru.htm)                       //
//    E-Mail : admin@btframework.com                                          //
//                                                                            //
//  Technical support  : support@btframework.com                              //
//  Sales department   : shop@btframework.com                                 //
//                       marina@btframework.com                               //
//  Customers support  : manager@btframework.com                              //
//                       marina@btframework.com                               //
//  Developer (author) : mike@btframework.com                                 //
//  Web master         : postmaster@btframework.com                           //
//                                                                            //
//  ------------------------------------------------------------------------  //
//                                                                            //
//  NOTICE:                                                                   //
//  -------                                                                   //
//      WE STOPS FREE OR ORDERED TECHNICAL SUPPORT IF YOU CHANGE THIS FILE    //
//    WITHOUT OUR AGREEMENT. ONLY SERTIFIED CHANGES ARE ALLOWED.              //
//                                                                            //
//  ------------------------------------------------------------------------  //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
unit BFD5Support;

{$I BF.inc}

interface

{$IFDEF DELPHI5}
type
  UTF8String = type string;

function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
function Utf8Decode(const S: UTF8String): WideString;
function Utf8ToAnsi(const S: UTF8String): string;
function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
function Utf8Encode(const WS: WideString): UTF8String;
function AnsiToUtf8(const S: string): UTF8String;
procedure RaiseLastOSError;
function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;
{$ENDIF}

implementation

{$IFDEF DELPHI5}
uses
  SysUtils;

function EncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): TDateTime;
begin
  Result := EncodeDate(AYear, AMonth, ADay);
  Result := Result + EncodeTime(AHour, AMinute, ASecond, AMilliSecond);
end;

procedure RaiseLastOSError;
begin
  RaiseLastWin32Error;
end;

function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
var
  I: Cardinal;
  Count: Cardinal;
  C: Byte;
  WC: Cardinal;
begin
  if not Assigned(Source) then begin
    Result := 0;
    Exit;
  end;

  Result := Cardinal(-1);
  Count := 0;
  I := 0;

  if Assigned(Dest) then begin
    while (I < SourceBytes) and (Count < MaxDestChars) do begin
      WC := Cardinal(Source[I]);
      Inc(I);

      if (WC and $80) <> 0 then begin
        WC := WC and $3F;
        if I > SourceBytes then Exit;

        if (WC and $20) <> 0 then begin
          C := Byte(Source[I]);
          Inc(I);

          if ((C and $C0) <> $80) or (I > SourceBytes) then Exit;

          WC := (WC shl 6) or (C and $3F);
        end;

        C := Byte(Source[I]);
        Inc(I);
        if (C and $C0) <> $80 then Exit;

        Dest[Count] := WideChar((WC shl 6) or (C and $3F));

      end else
        Dest[Count] := WideChar(WC);

      Inc(Count);
    end;

    if Count >= MaxDestChars then Count := MaxDestChars-1;
    Dest[Count] := #0;

  end else
    while (I <= SourceBytes) do begin
      C := Byte(Source[I]);
      Inc(I);

      if (C and $80) <> 0 then begin
        if ((C and $F0) = $F0) or ((C and $40) = 0) or (I > SourceBytes) or ((Byte(Source[I]) and $C0) <> $80) then Exit;

        Inc(I);

        if (I > SourceBytes) or (((C and $20) <> 0) and ((Byte(Source[I]) and $C0) <> $80)) then Exit;

        Inc(I);
      end;

      Inc(Count);
    end;

  Result := Count + 1;
end;

function Utf8Decode(const S: UTF8String): WideString;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := Utf8ToUnicode(PWideChar(Temp), Length(Temp) + 1, PChar(S), Length(S));

  if L > 0 then
    SetLength(Temp, L - 1)
  else
    Temp := '';

  Result := Temp;
end;

function Utf8ToAnsi(const S: UTF8String): string;
begin
  Result := Utf8Decode(S);
end;

function UnicodeToUtf8(Dest: PChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
var
  I: Cardinal;
  Count: Cardinal;
  C: Cardinal;
begin
  Result := 0;

  if not Assigned(Source) then Exit;

  Count := 0;
  I := 0;

  if Assigned(Dest) then begin
    while (I < SourceChars) and (Count < MaxDestBytes) do begin
      C := Cardinal(Source[I]);
      Inc(I);

      if C <= $7F then begin
        Dest[Count] := Char(C);
        Inc(Count);

      end else
        if C > $7FF then begin
          if Count + 3 > MaxDestBytes then Break;

          Dest[Count] := Char($E0 or (C shr 12));
          Dest[Count + 1] := Char($80 or ((C shr 6) and $3F));
          Dest[Count + 2] := Char($80 or (C and $3F));
          Inc(Count, 3);

        end else begin
          if Count + 2 > MaxDestBytes then Break;

          Dest[Count] := Char($C0 or (C shr 6));
          Dest[Count + 1] := Char($80 or (C and $3F));
          Inc(Count, 2);
        end;
    end;

    if Count >= MaxDestBytes then Count := MaxDestBytes - 1;
    Dest[Count] := #0;

  end else
    while I < SourceChars do begin
      C := Integer(Source[I]);
      Inc(I);

      if C > $7F then begin
        if C > $7FF then Inc(Count);
        Inc(Count);
      end;

      Inc(Count);
    end;

  Result := Count + 1;
end;

function Utf8Encode(const WS: WideString): UTF8String;
var
  L: Integer;
  Temp: UTF8String;
begin
  Result := '';
  if WS = '' then Exit;
  SetLength(Temp, Length(WS) * 3);

  L := UnicodeToUtf8(PChar(Temp), Length(Temp)+1, PWideChar(WS), Length(WS));
  if L > 0 then
    SetLength(Temp, L - 1)

  else
    Temp := '';

  Result := Temp;
end;

function AnsiToUtf8(const S: string): UTF8String;
begin
  Result := Utf8Encode(S);
end;
{$ENDIF}

end.
