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
unit BFObjectPushClient;

{$I BF.inc}

interface

uses
  BFOBEXClient, Classes, BFDiscovery, BFClients;

type
  // The TBFObjectPushClient allows you to send files to the remote device.
  // It is an implementation of the OBEX Object Push Profile client.
  TBFObjectPushClient = class(TBFOBEXClient)
  protected
    // Override inherited methods.
    procedure InternalClose; override;
    procedure InternalOpen; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

    // Returns vCard file from remote device and save it with specified name.
    procedure Get(SaveTo: string);
    // Sends stream to remote device.
    procedure Put(Stream: TStream; FileName: string); overload;
    // Sends file with FileName to the remote device.
    procedure Put(FileName: string); overload;
  end;

  _TBFObjectPushClientX = class(_TBFOBEXClientX)
  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    procedure Get(SaveTo: string);
    procedure Put(Stream: TStream; FileName: string); overload;
    procedure Put(FileName: string); overload;
  end;

// Sends specified file to specified device. Returns True if file sended.
function OPPSendFile(ADevice: TBFBluetoothDevice; AFileName: string; AAuthentication: Boolean; Async: Boolean): Boolean; overload;
function OPPSendFile(ADevice: TBFIrDADevice; AFileName: string; AAuthentication: Boolean; Async: Boolean): Boolean; overload;
function OPPSendFile(AAddress: string; AFileName: string; ABluetooth: Boolean; AAuthentication: Boolean; Async: Boolean): Boolean; overload;

implementation

uses
  BFAPI, Windows, SysUtils, BFStrings;

function OPPSendFile(ADevice: TBFBluetoothDevice; AFileName: string; AAuthentication: Boolean; Async: Boolean): Boolean; overload;
begin
  Result := OPPSendFile(ADevice.Address, AFileName, True, AAuthentication, Async);
end;

function OPPSendFile(ADevice: TBFIrDADevice; AFileName: string; AAuthentication: Boolean; Async: Boolean): Boolean; overload;
begin
  Result := OPPSendFile(ADevice.Address, AFileName, False, AAuthentication, Async);
end;

function OPPSendFile(AAddress: string; AFileName: string; ABluetooth: Boolean; AAuthentication: Boolean; Async: Boolean): Boolean; overload;
begin
  Result := False;
  with TBFObjectPushClient.Create(nil) do begin
    if ABluetooth then
      with BluetoothTransport do begin
        Authentication := AAuthentication;
        Address := AAddress;
      end

    else begin
      Transport := atIrDA;
      IrDATransport.Address := AAddress;
    end;

    PacketSize := 2048;
    WriteBuffer := 2048;
    ReadBuffer := 2048;

    try
      Open;
      Put(AFileName);

      Result := True;

    except
    end;

    if Active then Close;

    Free;
  end;
end;

{ TBFObjectPushClient }

constructor TBFObjectPushClient.Create(AOwner: TComponent);
begin
  inherited;

  // Just set service to which connect.
  BluetoothTransport.ServiceUUID := OBEXObjectPushServiceClass_UUID;
end;

procedure TBFObjectPushClient.Get(SaveTo: string);
var
  Data: TBFByteArray;
  Answer: Byte;
  Header: Byte;
  FileSize: DWORD;
  Size: Word;
  Abort: Boolean;
  Index: Word;
  Loop: Integer;
  AObject: TBFByteArray;
begin
  SetLength(AObject, 0);
  FileSize := 0;
  Abort := False;

  RaiseNotActive;

  SetLength(Data, 22);
  Data[0]  := $83;
  Data[1]  := $00;
  Data[2]  := $16;
  Data[3]  := $01;
  Data[4]  := $00;
  Data[5]  := $03;
  Data[6]  := $42;
  Data[7]  := $00;
  Data[8]  := $10;
  Data[9] := Ord('t'); // text/x-vCard
  Data[10] := Ord('e');
  Data[11] := Ord('x');
  Data[12] := Ord('t');
  Data[13] := Ord('/');
  Data[14] := Ord('x');
  Data[15] := Ord('-');
  Data[16] := Ord('v');
  Data[17] := Ord('C');
  Data[18] := Ord('a');
  Data[19] := Ord('r');
  Data[20] := Ord('d');
  Data[21] := $00;

  try
    try
      Answer := 0;

      repeat
        Write(Data);
        ReadOBEXPacket(Data);
        CheckOBEXError(Data);

        if Length(Data) = 0 then Break;

        Answer := Data[0];

        if FileSize = 0 then begin
          Index := 3;

          while Index < Length(Data) do begin
            Header := Data[Index];
            case Header and $C0 of
              $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
              $80: Size := 2;
              $C0: Size := 5;

            else
              Size := 0;
            end;

            if Header = $C3 then begin
              FileSize := Data[Index + 1] shl 24 or Data[Index + 2] shl 16 or Data[Index + 3] shl 8 or Data[Index + 4];
              Break;
            end;

            Inc(Index, Size);
          end;
        end;

        Index := 3;
        while Index < Length(Data) do begin
          Header := Data[Index];
          case Header and $C0 of
            $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
            $80: Size := 2;
            $C0: Size := 5;

          else
            Size := 0;
          end;

          if (Header = $48) or (Header = $49) then begin
            Inc(Index, 3);

            Size := Size - 3;
            SetLength(AObject, DWORD(Length(AObject)) + Size);

            for Loop := 0 to Size - 1 do AObject[DWORD(Length(AObject)) - Size + DWORD(Loop)] := Data[Index + Loop];

            Break;
          end;

          Inc(Index, Size);
        end;

        Abort := False;
        DoProgress(SaveTo, 1, 1, Length(AObject), FileSize, Abort);

        if Abort then begin
          SetLength(Data, 3);
          Data[0] := $FF;
          Data[1] := $00;
          Data[2] := $03;

          Write(Data);
          ReadOBEXPacket(Data);
          try
            CheckOBEXError(Data, 3);

          except
            Close;

            raise;
          end;

          Break;

        end else
          if Answer = $90 then begin
            SetLength(Data, 3);
            Data[0]  := $83;
            Data[1]  := $00;
            Data[2]  := $03;
          end;
      until Answer = $A0;

    except
      SetLength(AObject, 0);

      raise;
    end;

  finally
    SetLength(Data, 0);
  end;

  if Length(AObject) > 0 then
    with TFileStream.Create(SaveTo, fmCreate or fmShareExclusive) do begin
      Write(PChar(Data)^, Length(Data));
      Free;
    end;
end;

procedure TBFObjectPushClient.InternalClose;
var
  Data: TBFByteArray;
begin
  if ((Transport = atCOM) and FOBEXActive) or (Transport <> atCOM) then begin
    // Close OBEX session.
    SetLength(Data, 3);
    Data[0] := $81;
    Data[1] := $00;
    Data[2] := $03;

    try
      Write(Data);
      ReadOBEXPacket(Data);
    except
    end;
  end;

  inherited;
end;

procedure TBFObjectPushClient.InternalOpen;
var
  Data: TBFByteArray;
begin
  inherited;

  // Initialize OBEX session.
  SetLength(Data, 7);

  Data[0] := $80;
  Data[1] := $00;
  Data[2] := $07;
  Data[3] := $10;
  Data[4] := $00;
  Data[5] := Hi(PacketSize);
  Data[6] := Lo(PacketSize);

  try
    Write(Data);
    ReadOBEXPacket(Data);
    CheckOBEXError(Data, 7);

  except
    inherited InternalClose;
    raise;
  end;

  // If all OK retrive server packet size;
  FServerPacketSize := Data[5] shl 8 or Data[6];
end;

procedure TBFObjectPushClient.Put(Stream: TStream; FileName: string);
var
  Data: TBFByteArray;
  FileSize: DWORD;
  TempFileName: WideString;
  Loop: Word;
  Index: Word;
  Position: DWORD;
  Abort: Boolean;
  AByte: Byte;
begin
  // Sending file.
  RaiseNotActive;

  if not Assigned(Stream) then Exit;

  Stream.Seek(soFromBeginning, 0);

  try
    FileSize := Stream.Size;
    SetLength(Data, 11);
    Data[0] := $02;
    Data[1] := $00;
    Data[2] := $00;
    Data[3] := $C3;
    Data[4] := Hi(HiWord(FileSize));
    Data[5] := Lo(HiWord(FileSize));
    Data[6] := Hi(LoWord(FileSize));
    Data[7] := Lo(LoWord(FileSize));
    Data[8] := $01;
    Data[9] := $00;
    Data[10] := $00;

    TempFileName := WideString(ExtractFileName(FileName));
    if TempFileName[Length(TempFileName)] <> #$0000 then TempFileName := TempFileName + #$0000;

    Data[9] := Hi(LoWord(Length(TempFileName) * 2 + 3));
    Data[10] := Lo(LoWord(Length(TempFileName) * 2 + 3));

    SetLength(Data, Length(Data) + Length(TempFileName) * 2);

    Index := 11;
    for Loop := 1 to Length(TempFileName) do begin
      Data[Index] := Hi(Ord(TempFileName[Loop]));
      Data[Index + 1] := Lo(Ord(TempFileName[Loop]));
      Inc(Index, 2);
    end;

    Data[1] := Hi(LoWord(Length(Data)));
    Data[2] := Lo(LoWord(Length(Data)));

    Write(Data);
    ReadOBEXPacket(Data);
    CheckOBEXError(Data);

    Position := 0;
    Abort := False;

    while Position < FileSize do begin
      Abort := False;
      DoProgress(FileName, 1, 1, Position, FileSize, Abort);

      if Abort then begin
        SetLength(Data, 3);
        Data[0] := $FF;
        Data[1] := $00;
        Data[2] := $03;

        Write(Data);
        try
          ReadOBEXPacket(Data);
          CheckOBEXError(Data, 3);

        except
          Close;

          raise;
        end;

        Break;

      end else begin
        SetLength(Data, FServerPacketSize);
        Data[0] := $02;
        Data[1] := Hi(FServerPacketSize);
        Data[2] := Lo(FServerPacketSize);
        Data[3] := $48;
        Data[4] := Hi(FServerPacketSize - 3);
        Data[5] := Lo(FServerPacketSize - 3);

        Index := 6;
        while (Position < FileSize) and (Index < FServerPacketSize) do begin
          Stream.Read(AByte, 1);
          Data[Index] := AByte;
          Inc(Position);
          Inc(Index);
        end;

        Data[1] := Hi(Index);
        Data[2] := Lo(Index);
        Data[4] := Hi(Index - 3);
        Data[5] := Lo(Index - 3);
        if (Position = FileSize) then begin
          SetLength(Data, Index);
          ABort := False;
          DoProgress(FileName, 1, 1, Position, FileSize, Abort);
        end;

        Write(Data);
        ReadOBEXPacket(Data);
        try
          CheckOBEXError(Data, 3);

        except
          try
            Close;
          except
          end;

          raise;
        end;
      end;
    end;

    SetLength(Data, 6);
    Data[0] := $82;
    Data[1] := $00;
    Data[2] := $06;
    Data[3] := $49;
    Data[4] := $00;
    Data[5] := $03;

    Write(Data);
    ReadOBEXPacket(Data);
    try
      CheckOBEXError(Data, 3);

    except
      try
        Close;
      except
      end;

      raise;
    end;

  finally
    SetLength(Data, 0);
  end;
end;

procedure TBFObjectPushClient.Put(FileName: string);
var
  AFile: TFileStream;
begin
  RaiseNotActive;

  if not FileExists(FileName) then raise Exception.Create(StrFileNotFound);

  AFile := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);

  try
    Put(AFile, ExtractFileName(FileName));

  finally
    AFile.Free;
  end;
end;

{ TBFObjectPushClientX }

procedure _TBFObjectPushClientX.Get(SaveTo: string);
begin
  TBFObjectPushClient(FBFCustomClient).Get(SaveTo);
end;

function _TBFObjectPushClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFObjectPushClient;
end;

procedure _TBFObjectPushClientX.Put(FileName: string);
begin
  TBFObjectPushClient(FBFCustomClient).Put(FileName);
end;

procedure _TBFObjectPushClientX.Put(Stream: TStream; FileName: string);
begin
  TBFObjectPushClient(FBFCustomClient).Put(Stream, FileName);
end;

end.
