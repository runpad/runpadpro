unit g_conn;

interface

uses ADODB, DB;


{$INCLUDE ..\h_sql.inc}


type TServerConn = class(TObject)
     private
      p_conn : TADOConnection;
      m_lasterror : string;
      m_buff : array [0..300] of char; //used for store lasterror as pchar
      m_lastnativeerror : integer;

     public
      constructor Create(const s_server,s_login,s_pwd,s_base:string);
      destructor Destroy; override;

      function GetLastError:pchar;
      function GetLastNativeError:integer;
      function IsConnected:boolean;

      function ExecSQL(const s:string;timeout:integer=SQL_DEF_TIMEOUT;_record_count:pinteger=nil;cb:TEXECSQLCBPROC=nil;cb_parm:pointer=nil;call_cb_at_begin:boolean=false):boolean;
      function CallStoredProc(const s_proc:string;timeout:integer=SQL_DEF_TIMEOUT;argv:PSTOREDPROCPARAM=nil;argc:integer=0):boolean;

     private
      function GetLastNativeErrorInternal:integer;
      procedure SetLastError(const s:string);
      procedure Disconnect;
      procedure ProcessResultInternal(ADOQuery:TADOQuery;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:boolean);
      procedure DisconnectIfNeeded;
      procedure ProcessStoredProcParams(cmd:TADOCommand;argv:PSTOREDPROCPARAM;argc:integer);
     end;


implementation

uses Windows, SysUtils, StrUtils, Classes, Variants;



constructor TServerConn.Create(const s_server,s_login,s_pwd,s_base:string);
begin
 inherited Create;

 m_lastnativeerror:=0;
 m_lasterror:='';
 p_conn:=nil;

 if (s_server<>'') and (s_login<>'') then
  begin
   try
     p_conn := TADOConnection.Create(nil);
     p_conn.CommandTimeout := SQL_DEF_TIMEOUT;
     p_conn.ConnectionTimeout := 12;
     p_conn.ConnectOptions := coConnectUnspecified;
     p_conn.CursorLocation := clUseClient;
     p_conn.IsolationLevel := ilUnspecified;
     p_conn.KeepConnection := true;
     p_conn.LoginPrompt := false;
     p_conn.Mode := cmReadWrite;
     p_conn.Provider := 'SQLOLEDB.1';
     p_conn.ConnectionString := 'Provider=SQLOLEDB.1;'
         + 'Persist Security Info=True;'
         + 'User ID="'+s_login+'";'
         + 'Initial Catalog='+s_base+';'
         + 'Data Source='+s_server+';'
         + 'Password="'+s_pwd+'"';
     p_conn.Open;
   except
    on E: Exception do begin m_lasterror:=E.Message; m_lastnativeerror:=GetLastNativeErrorInternal(); end;
   else
   end;

   if (p_conn<>nil) and (not p_conn.Connected) then
    begin
     p_conn.Free;
     p_conn:=nil;
    end;
  end;
end;

destructor TServerConn.Destroy;
begin
 if p_conn<>nil then
  begin
   if p_conn.Connected then
    try
     p_conn.Close;
    except end;
   p_conn.Free;
   p_conn:=nil;
  end;

 inherited;
end;

procedure TServerConn.Disconnect;
begin
 SetLastError('');

 if p_conn<>nil then
  begin
   if p_conn.Connected then
    try
     p_conn.Close;
    except end;
   p_conn.Free;
   p_conn:=nil;
  end;
end;

function TServerConn.GetLastError:pchar;
begin
 StrLCopy(m_buff,pchar(m_lasterror),sizeof(m_buff)-1);
 Result:=m_buff;
end;

function TServerConn.GetLastNativeErrorInternal:integer;
begin
 Result:=0;

 if p_conn<>nil then
  begin
   if (p_conn.Errors<>nil) and (p_conn.Errors.Count>0) then
    begin
     Result:=p_conn.Errors[0].NativeError;
    end;
  end;
end;

function TServerConn.GetLastNativeError:integer;
begin
 Result:=m_lastnativeerror;
end;

procedure TServerConn.SetLastError(const s:string);
begin
 m_lasterror:=s;
 m_lastnativeerror:=0;
end;

function TServerConn.IsConnected:boolean;
begin
 Result:=p_conn<>nil;  //must be fast
end;

function G_GetNumFields(obj:pointer):integer cdecl;
var ADOQuery:TADOQuery;
begin
 Result:=0;
 ADOQuery:=TADOQuery(obj);
 if ADOQuery<>nil then
   Result:=ADOQuery.FieldCount;
end;

function G_GetFieldByName(obj:pointer;const name:pchar):pointer cdecl;  //returns TField
var ADOQuery:TADOQuery;
begin
 Result:=nil;
 ADOQuery:=TADOQuery(obj);
 if ADOQuery<>nil then
   Result:=ADOQuery.FindField(name);
end;

function G_GetFieldByIdx(obj:pointer;idx:integer):pointer cdecl;  //returns TField
var ADOQuery:TADOQuery;
begin
 Result:=nil;
 ADOQuery:=TADOQuery(obj);
 if ADOQuery<>nil then
  begin
   if ADOQuery.Fields<>nil then
    begin
     if (idx>=0) and (idx<ADOQuery.Fields.Count) then
       Result:=ADOQuery.Fields[idx];
    end;
  end;
end;

procedure G_GetFieldDisplayName(obj:pointer;field:pointer;_out:pchar) cdecl;  //reserve MAX_PATH for _out
var f:TField;
begin
 if _out<>nil then
  begin
   StrCopy(_out,'');
   f:=TField(field);
   if f<>nil then
     StrLCopy(_out,pchar(f.DisplayName),MAX_PATH-1);
  end;
end;

function G_GetFieldDataType(obj:pointer;field:pointer):integer cdecl;  //returns TFieldType
var f:TField;
begin
 Result:=integer(ftUnknown);
 f:=TField(field);
 if f<>nil then
  Result:=integer(f.DataType);
end;

function G_GetFieldValueAsInt(obj:pointer;field:pointer):integer cdecl;
var f:TField;
begin
 Result:=0;
 f:=TField(field);
 if f<>nil then
  begin
   try
    Result:=integer(f.Value);
   except end;
  end;
end;

function G_GetFieldValueAsDouble(obj:pointer;field:pointer):double cdecl;
var f:TField;
begin
 Result:=0.0;
 f:=TField(field);
 if f<>nil then
  begin
   try
    Result:=double(f.Value);
   except end;
  end;
end;

function G_GetFieldValueAsDateTime(obj:pointer;field:pointer):double cdecl;
var f:TField;
begin
 Result:=0.0;
 f:=TField(field);
 if f<>nil then
  begin
   try
    Result:=TDateTime(f.Value);
   except end;
  end;
end;

function G_GetFieldValueAsString(obj:pointer;field:pointer):pchar cdecl; //returns allocated string
var f:TField;
    s:string;
    buff:pchar;
begin
 Result:=nil;
 f:=TField(field);
 if f<>nil then
  begin
   try
    s:=string(f.Value);
   except
    s:='';
   end;
   GetMem(buff,Length(s)+1);
   StrCopy(buff,pchar(s));
   Result:=buff;
  end;
end;

function G_GetFieldValueAsBlob(obj:pointer;field:pointer;_size:pinteger):pointer cdecl; //returns allocated blob
var ADOQuery:TADOQuery;
    f:TField;
    str:TStream;
    buff:pointer;
begin
 Result:=nil;
 if _size<>nil then
  _size^:=0;
 if (obj<>nil) and (field<>nil) then
  begin
   ADOQuery:=TADOQuery(obj);
   f:=TField(field);
   if f.IsBlob then
    begin
     try
      str:=ADOQuery.CreateBlobStream(f,bmRead);
     except
      str:=nil;
     end;
     if str<>nil then
      begin
       if str.Size>0 then
        begin
         try
          GetMem(buff,str.Size);
         except
          buff:=nil;
         end;
         if buff<>nil then
          begin
           str.Seek(0,soFromBeginning);
           if str.Read(buff^,str.Size)<>str.Size then
            begin
             FreeMem(buff);
             buff:=nil;
            end
           else
            begin
             if _size<>nil then
              _size^:=str.Size;
             Result:=buff;
            end;
          end;
        end;
       str.Free;
      end;
    end;
  end;
end;

procedure G_FreePointer(p:pointer) cdecl; //free data returned by GetFieldValueAsString, GetFieldValueAsBlob
begin
 if p<>nil then
  try
   FreeMem(p);
  except
  end;
end;

procedure TServerConn.DisconnectIfNeeded;
var ADOQuery:TADOQuery;
    need_disconnect:boolean;
    old_error:string;
    old_nativeerror:integer;
begin
 need_disconnect:=false;
 
 if p_conn<>nil then
  begin
   try
    ADOQuery:=TADOQuery.Create(nil);
   except
    ADOQuery:=nil;
   end;

   if ADOQuery<>nil then
    begin
     ADOQuery.AutoCalcFields:=false;
     ADOQuery.CommandTimeout:=5;
     ADOQuery.Connection:=p_conn;
     ADOQuery.CursorLocation:=clUseClient;
     ADOQuery.CursorType:=ctStatic;
     ADOQuery.ParamCheck:=false;
     ADOQuery.ExecuteOptions:=[eoExecuteNoRecords];
     ADOQuery.SQL.SetText('SELECT 1');
     try
      ADOQuery.ExecSQL;
     except 
      need_disconnect:=true;
     end;

     ADOQuery.Free;
    end;
  end;

 if need_disconnect then
  begin
   old_error:=m_lasterror;
   old_nativeerror:=m_lastnativeerror;
   Disconnect;
   m_lasterror:=old_error;
   m_lastnativeerror:=old_nativeerror;
  end;
end;

function TServerConn.ExecSQL(const s:string;timeout:integer;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:boolean):boolean;
var ADOQuery:TADOQuery;
begin
 Result:=false;

 SetLastError('');

 if _record_count<>nil then
  _record_count^:=0;

 if p_conn=nil then
  begin
   SetLastError('Not connected to server');
   Exit;
  end;

 if s='' then
  begin
   SetLastError('Empty query');
   Exit;
  end;

 try
  ADOQuery:=TADOQuery.Create(nil);
 except
  ADOQuery:=nil;
 end;

 if ADOQuery=nil then
  begin
   SetLastError('Cannot allocate TADOQuery');
   Exit;
  end;
  
 ADOQuery.AutoCalcFields:=false;
 ADOQuery.CommandTimeout:=timeout;
 ADOQuery.Connection:=p_conn;
 ADOQuery.CursorLocation:=clUseClient;
 ADOQuery.CursorType:=ctStatic;
 ADOQuery.ParamCheck:=false;
 ADOQuery.SQL.SetText(pchar(s));

 if (_record_count=nil) and (@cb=nil) then
  begin
   ADOQuery.ExecuteOptions:=[eoExecuteNoRecords];
   try
    ADOQuery.ExecSQL;
    Result:=true;
   except 
    on E: Exception do begin m_lasterror:=E.Message; m_lastnativeerror:=GetLastNativeErrorInternal(); end;
   else
   end;
  end
 else
  begin
   ADOQuery.ExecuteOptions:=[];
   try
    ADOQuery.Open;
    Result:=true;
    ProcessResultInternal(ADOQuery,_record_count,cb,cb_parm,call_cb_at_begin);
   except
    on E: Exception do begin m_lasterror:=E.Message; m_lastnativeerror:=GetLastNativeErrorInternal(); end;
   else
   end;

   if ADOQuery.Active then
    try
     ADOQuery.Close;
    except end;
  end;

 ADOQuery.Free;

 // check if we're disconnected from server
 if not Result then
  DisconnectIfNeeded; 
end;

procedure TServerConn.ProcessResultInternal(ADOQuery:TADOQuery;_record_count:pinteger;cb:TEXECSQLCBPROC;cb_parm:pointer;call_cb_at_begin:boolean);
var i:TEXECSQLCBSTRUCT;
    do_iteration:boolean;
begin
 if (_record_count<>nil) or (@cb<>nil) then
  begin
   if _record_count<>nil then
    _record_count^:=ADOQuery.RecordCount;

   if @cb<>nil then
    begin
     i.user_parm:=cb_parm;
     i.obj:=ADOQuery;
     i.numrecords:=ADOQuery.RecordCount;
     i.GetNumFields:=G_GetNumFields;
     i.GetFieldByName:=G_GetFieldByName;
     i.GetFieldByIdx:=G_GetFieldByIdx;
     i.GetFieldDisplayName:=G_GetFieldDisplayName;
     i.GetFieldDataType:=G_GetFieldDataType;
     i.GetFieldValueAsInt:=G_GetFieldValueAsInt;
     i.GetFieldValueAsDouble:=G_GetFieldValueAsDouble;
     i.GetFieldValueAsDateTime:=G_GetFieldValueAsDateTime;
     i.GetFieldValueAsString:=G_GetFieldValueAsString;
     i.GetFieldValueAsBlob:=G_GetFieldValueAsBlob;
     i.FreePointer:=G_FreePointer;

     do_iteration:=true;
     
     if call_cb_at_begin then
      begin
       i.idx:=-1;
       if not cb(@i) then
        do_iteration:=false;
      end;

     if do_iteration then
      begin
       i.idx:=0;
       ADOQuery.First;
       while not ADOQuery.Eof do
        begin
         if not cb(@i) then
          break;
         inc(i.idx);
         ADOQuery.Next;
        end;
      end;
    end;
  end;
end;

function TServerConn.CallStoredProc(const s_proc:string;timeout:integer;argv:PSTOREDPROCPARAM;argc:integer):boolean;
var cmd:TADOCommand;
begin
 Result:=false;

 SetLastError('');

 if p_conn=nil then
  begin
   SetLastError('Not connected to server');
   Exit;
  end;

 if s_proc='' then
  begin
   SetLastError('Empty proc name');
   Exit;
  end;
 
 try
  cmd:=TADOCommand.Create(nil);
 except
  cmd:=nil;
 end;

 if cmd=nil then  
  begin
   SetLastError('Cannot allocate TADOCommand');
   Exit;
  end;
   
 try
  cmd.Connection := p_conn;
  cmd.CommandTimeout := timeout;
  cmd.CommandType := cmdStoredProc;
  cmd.CommandText := s_proc;
  cmd.ParamCheck := false;
  cmd.ExecuteOptions := [eoExecuteNoRecords];

  ProcessStoredProcParams(cmd,argv,argc);

  cmd.Execute;
  Result:=true;
 except
  on E: Exception do begin m_lasterror:=E.Message; m_lastnativeerror:=GetLastNativeErrorInternal(); end;
 else
 end;

 cmd.Free;

 // check if we're disconnected from server
 if not Result then
  DisconnectIfNeeded; 
end;

procedure TServerConn.ProcessStoredProcParams(cmd:TADOCommand;argv:PSTOREDPROCPARAM;argc:integer);
var n:integer;
    str:TMemoryStream;
    p:PSTOREDPROCPARAM;
    b_set:boolean;
begin
 if (argv<>nil) and (argc>0) then
  begin
   for n:=0 to argc-1 do
    begin
     p:=PSTOREDPROCPARAM(cardinal(argv)+cardinal(n)*sizeof(TSTOREDPROCPARAM));
     with cmd.Parameters.AddParameter do
      begin
       b_set:=false;
       if (TParameterDirection(p.Direction)=pdInput) then
        begin
         case TFieldType(p.DataType) of
          ftString:         if p.Value<>nil then
                            begin
                             Value:=string(pchar(p.Value));
                             b_set:=true;
                            end;
          ftInteger:        if p.Value<>nil then
                            begin
                             Value:=pinteger(p.Value)^;
                             b_set:=true;
                            end;
          ftFloat:          if p.Value<>nil then
                            begin
                             Value:=pdouble(p.Value)^;
                             b_set:=true;
                            end;
          ftDateTime:       if p.Value<>nil then
                            begin 
                             Value:=PDateTime(p.Value)^;
                             b_set:=true;
                            end;
          ftBlob:           if (p.Value<>nil) and (p.BlobSize>0) then
                            begin
                             str:=TMemoryStream.Create;
                             if str.Write(p.Value^,p.BlobSize)=p.BlobSize then
                              begin
                               Attributes:=[paLong,paNullable];
                               try
                                LoadFromStream(str,ftBlob);
                                b_set:=true;
                               except
                               end;
                              end;
                             str.Free;
                            end;
         end;{case}
        end;
       Direction:=TParameterDirection(p.Direction);
       DataType:=TFieldType(p.DataType);
       if not b_set then
        Value:=NULL;
      end;
    end;
  end;
end;


end.
