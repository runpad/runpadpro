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
unit BFOBEXClient;

{$I BF.inc}

interface

uses
  BFClients, BFAPI, Classes;

type
  // OnProgress event prototype.
  //   AName - current object name
  //   Index - current object index
  //   Count - total objects count
  //   Position - transferred bytes
  //   Size - total object size
  //   Abort - sets to True to terminate transferring.
  TBFProgressEvent = procedure(Sender: TObject; AName: string; Index: Integer; Count: Integer; Position: Integer; Size: Integer; var Abort: Boolean) of object;

  // The base class for OBEX clients. Application should never create instances
  // of this class. Use ancessors.
  TBFOBEXClient = class(TBFCustomClient)
  private
    FLastError: Byte;
    FPacketSize: Word;

    FOnProgress: TBFProgressEvent;

    function _GetLastError: Byte;

    procedure SetPacketSize(const Value: Word);

  protected
    FOBEXActive: Boolean;
    FServerPacketSize: Word;

    // Check is OBEX error present.
    procedure CheckOBEXError(Data: TBFByteArray; Index: Word = 3);
    // Call OnProgress
    procedure DoProgress(AName: string; Index: Integer; Count: Integer; Position: Integer; Size: Integer; var Abort: Boolean);
    // Overrided method
    procedure InternalClose; override;
    // Overrided method
    procedure InternalOpen; override;
    // Reading OBEX packet from connection.
    procedure ReadOBEXPacket(var Data: TBFByteArray);

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Returns last OBEX error. Resets after reading.
    property LastError: Byte read _GetLastError;

  published
    // OBEX packet size.
    property PacketSize: Word read FPacketSize write SetPacketSize default 512;

    // On progress event. Occures during object transfering. If you need
    // aborting process then you must handle this event.
    property OnProgress: TBFProgressEvent read FOnProgress write FOnProgress;
  end;

  _TBFOBEXClientX = class(_TBFCustomClientX)
  private
    function _GetLastError: Byte;
    function GetOnProgress: TBFProgressEvent;
    function GetPacketSize: Word;

    procedure SetOnProgress(const Value: TBFProgressEvent);
    procedure SetPacketSize(const Value: Word);
    
  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    property LastError: Byte read _GetLastError;

  published
    property PacketSize: Word read GetPacketSize write SetPacketSize;

    property OnProgress: TBFProgressEvent read GetOnProgress write SetOnProgress;
  end;

implementation

uses
  SysUtils, Windows, BFStrings;

{ TBFOBEXClient }

procedure TBFOBEXClient.CheckOBEXError(Data: TBFByteArray; Index: Word);
var
  Description: string;
  Code: Byte;
  Header: Byte;
  Size: Word;
  Message: string;
  {$IFDEF DELPHI5}
  Tmp: Word;
  {$ENDIF}
begin
  FLastError := 0;
  
  // Checking OBEX error
  if Length(Data) = 0 then Exit;

  Code := Data[0];
  if (Code <> $90) and (Code <> $A0) and (Code <> $A1) and (Code <> $A2) then begin
    FLastError := Code;
    Description := '';

    while Index < Length(Data) do begin
      Header := Data[Index];
      case Header and $C0 of
        $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
        $80: Size := 1;
        $C0: Size := 5;
      else
        Size := 0;
      end;

      if Header <> $05 then
        Inc(Index, Size)

      else begin
        Size := Index + Size;
        Inc(Index, 3);

        while Index < Size do begin
          // Shit. It is succs, but delphi 5 do not compile normal code
          // which is in ELSE section. It is INTERNAL ERROR.
          // Fuck...
          {$IFDEF DELPHI5}
          Tmp := Data[Index] shl 8 or Data[Index + 1];
          Description := Description + string(WideString(WideChar(Tmp)));
          {$ELSE}
          Description := Description + string(WideString(WideChar(Data[Index] shl 8 or Data[Index + 1])));
          {$ENDIF}
          Inc(Index, 2);
        end;

        Break;
      end;
    end;

    case Code of
      $A3: Message := 'Non Authoritative';
      $A4: Message := 'No Content';
      $A5: Message := 'Reset Content';
      $A6: Message := 'Partial Content';

      $B0: Message := 'Multiple Choises';
      $B1: Message := 'Moved Permanently';
      $B2: Message := 'Moved Temporary';
      $B3: Message := 'See Other';
      $B4: Message := 'Not Modified';
      $B5: Message := 'Use Proxy';

      $C0: Message := 'Bad Request';
      $C1: Message := 'Unauthorized';
      $C2: Message := 'Payment Required';
      $C3: Message := 'Forbidden';
      $C4: Message := 'Not Found';
      $C5: Message := 'Method Not Allowed';
      $C6: Message := 'Not Acceptable';
      $C7: Message := 'Proxy Authentication Required';
      $C8: Message := 'Request Time Out';
      $C9: Message := 'Conflict';
      $CA: Message := 'Gone';
      $CB: Message := 'Length Required';
      $CC: Message := 'Precondition Failed';
      $CD: Message := 'Requested Entity Too Large';
      $CE: Message := 'Request URL Too Large';
      $CF: Message := 'Unsupported Media Type';

      $D0: Message := 'Internal Server Error';
      $D1: Message := 'Not Implemented';
      $D2: Message := 'Bad Gateway';
      $D3: Message := 'Service Unavailable';
      $D4: Message := 'Gateway Time Out';
      $D5: Message := 'HTTP Version Not Supported';

      $E0: Message := 'Database Full';
      $E1: Message := 'Database Locked';

    else
      Message := 'Unknown Error';
    end;

    Message := 'OBEX Error: ($' + IntToHex(Code, 2) + ') ' + Message + #$0A#$0D + Description;

    raise Exception.Create(Message);
  end;
end;

constructor TBFOBEXClient.Create(AOwner: TComponent);
begin
  inherited;

  FOBEXActive := False;
  FPacketSize := 512;
  FServerPacketSize := $0000;

  Need9WireMode := False;
  IrDATransport.Service := 'OBEX';

  FOnProgress := nil;
end;

destructor TBFOBEXClient.Destroy;
begin
  FOnProgress := nil;
  
  inherited;
end;

procedure TBFOBEXClient.DoProgress(AName: string; Index: Integer; Count: Integer; Position: Integer; Size: Integer; var Abort: Boolean);
begin
  Abort := False;
  if Assigned(FOnProgress) then FOnProgress(Self, AName, Index, Count, Position, Size, Abort);
end;

procedure TBFOBEXClient.InternalClose;
begin
  inherited;

  FOBEXActive := False;
end;

procedure TBFOBEXClient.InternalOpen;

  procedure ExecuteATCommand(Cmd: string);
  var
    Loop: Integer;
    Data: TBFByteArray;
    Size: DWORD;
    Resp: string;
  begin
    Cmd := Cmd + CR;
    SetLength(Data, Length(Cmd));
    for Loop := 1 to Length(Cmd) do Data[Loop - 1] := Ord(Cmd[Loop]);
    Write(Data);

    SetLength(Data, 0);
    Resp := '';

    while True do begin
      Size := 255;
      Read(Data, Size);

      if Length(Data) = 0 then Break;

      Resp := Resp + string(Data);

      if (Pos(RESP_OK, Resp) > 0) or (Pos(RESP_ERROR, Resp) > 0) or (Pos(RESP_OTHER, Resp) > 0) then Break;
    end;

    if Pos(RESP_ERROR, Resp) > 0 then raise Exception.CreateFmt(StrErrorInitializeOBEXSession, [CRLF + Resp]);
  end;

begin
  inherited;

  if Transport = atCOM then
    try
      // The Siemens require pause.
      ExecuteATCommand('ATZ');
      Sleep(500);

      if COMPortTransport.InitCommand <> '' then ExecuteATCommand(COMPortTransport.InitCommand);
      Sleep(500);

      FOBEXActive := True;

    except
      inherited Close;

      raise;
    end;
end;

procedure TBFOBEXClient.ReadOBEXPacket(var Data: TBFByteArray);
var
  Size: DWORD;
  TempData: TBFByteArray;
  Index: Integer;
  Loop: Integer;
begin
  // Reading OBEX packet from the connection.
  try
    try
      // Firstly read header
      Size := 3;
      SetLength(Data, 3);
      Read(Data, Size);

      if Size > 0 then begin
        // and determine size of packet.
        Size := Data[1] shl 8 or Data[2];
        SetLength(Data, Size);
        Dec(Size, 3);
        Index := 3;

        // Then read other part of the packet.
        while Index < Length(Data) do begin
          SetLength(TempData, Size);
          Read(TempData, Size);

          for Loop := 0 to Size - 1 do begin
            Data[Index] := TempData[Loop];
            Inc(Index);
          end;

          Size := Length(Data) - 3 - Integer(Size);
        end;
      end;

    except
      SetLength(Data, 0);

      raise;
    end;

  finally
    SetLength(TempData, 0);
  end;
end;

procedure TBFOBEXClient.SetPacketSize(const Value: Word);
begin
  if Value <> FPacketSize then begin
    RaiseActive;
    if Value = 0 then raise Exception.Create(StrInvalidPacketSize);
    FPacketSize := Value;
  end;
end;

function TBFOBEXClient._GetLastError: Byte;
begin
  Result := FLastError;
  FLastError := 0;
end;

{ TBFOBEXClientX }

function _TBFOBEXClientX._GetLastError: Byte;
begin
  Result := TBFOBEXClient(FBFCustomClient)._GetLastError;
end;

function _TBFOBEXClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFOBEXClient;
end;

function _TBFOBEXClientX.GetOnProgress: TBFProgressEvent;
begin
  Result := TBFOBEXClient(FBFCustomClient).OnProgress;
end;

function _TBFOBEXClientX.GetPacketSize: Word;
begin
  Result := TBFOBEXClient(FBFCustomClient).PacketSize;
end;

procedure _TBFOBEXClientX.SetOnProgress(const Value: TBFProgressEvent);
begin
  TBFOBEXClient(FBFCustomClient).OnProgress := Value;
end;

procedure _TBFOBEXClientX.SetPacketSize(const Value: Word);
begin
  TBFOBEXClient(FBFCustomClient).PacketSize := Value;
end;

end.
