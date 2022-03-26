function UrlEncode(const Str: string): string;
var
  i, Len : Integer;
  Ch     : Char;
begin
  Result := '';
  Len    := Length(Str);
  for i := 1 to Len do begin
    Ch:=Str[i];
    if Ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + Ch
    else begin
      if Ch = ' ' then 
        Result := Result + '+' 
      else begin
        Result := Result + '%' + IntToHex(integer(Ch), 2);
      end;
    end;
  end;
end; { UrlEncode }


function UrlEncodeUTF8(const Str: string): string;
var
  i, Len : Integer;
  Ch     : Char;
  s      : string;
begin
  Result := '';
  Len    := Length(Str);
  for i := 1 to Len do begin
    Ch:=Str[i];
    if Ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then
      Result := Result + Ch
    else begin
      if Ch = ' ' then 
        Result := Result + '+' else 
      begin
        s := AnsiToUtf8(Ch);
        Result := Result + '%' + IntToHex(integer(s[1]), 2);
        if Length(s) > 1 then
          Result := Result + '%' + IntToHex(integer(s[2]), 2);
      end;
    end;
  end;
end; { UrlEncodeUTF8 }
