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
unit BFSyncClient;

{$I BF.inc}

interface

uses
  BFOBEXClient, Windows, Classes, BFAPI, BFClients;

type
  // Type of object to read or save.
  //   soCalendar    - Calendar records
  //   soDevInfo     - Device Information file (read-only)
  //   soInCalls     - incoming calls
  //   soInMessages  - incoming messages
  //   soMisCalls    - missed calls
  //   soOutCalls    - outgoing calls
  //   soOutMessages - outgoing messages
  //   soPhoneBook   - phonebook records
  TBFSyncObjectType = (soCalendar, soDevInfo, soInCalls, soInMessages, soMisCalls, soOutCalls, soOutMessages, soPhoneBook);

  // Base class for clients that based on sync profile.
  TBFCustomSyncClient = class(TBFOBEXClient)
  private
    FConnectionID: DWORD;

    procedure InternalLoad(ObjectName: string; Stream: TStringList);
    procedure InternalSave(ObjectName: string; Stream: TStringList);
    procedure Get(ObjectName: string; var AObject: TBFByteArray);
    procedure Put(ObjectName: string; AObject: TBFByteArray);

  protected
    // Overloaded methid.
    procedure InternalClose; override;
    // Overloaded methid.
    procedure InternalOpen; override;

    // Reads an object into the data stream.
    procedure ReadObject(AObject: TBFSyncObjectType; AData: TStringList); virtual;
    // Write an object from data stream.
    procedure WriteObject(AObject: TBFSyncObjectType; AData: TStringList); virtual;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
  end;

  // OBEX Syncronization profile client.
  TBFSyncClient = class(TBFCustomSyncClient)
  public
    // Reads an object into the data stream.
    procedure ReadObject(AObject: TBFSyncObjectType; AData: TStringList); override;
    // Write an object from data stream.
    procedure WriteObject(AObject: TBFSyncObjectType; AData: TStringList); override;
  end;

  _TBFCustomSyncClientX = class(_TBFOBEXClientX)
  end;

  // OBEX Syncronization profile client.
  _TBFSyncClientX = class(_TBFCustomSyncClientX)
  protected
    function GetComponentClass: TBFCustomClientClass; override;
    
  public
    procedure ReadObject(AObject: TBFSyncObjectType; AData: TStringList);
    procedure WriteObject(AObject: TBFSyncObjectType; AData: TStringList);
  end;

implementation

uses
  SysUtils, BFStrings;

{ TBFCustomSyncClient }

constructor TBFCustomSyncClient.Create(AOwner: TComponent);
begin
  inherited;

  FConnectionID := 0;

  with BluetoothTransport do begin
    Authentication := True;
    ServiceUUID := IrMCSyncServiceClass_UUID;
  end;
end;

procedure TBFCustomSyncClient.Get(ObjectName: string; var AObject: TBFByteArray);
var
  Data: TBFByteArray;
  TempFileName: WideString;
  Answer: Byte;
  Header: Byte;
  Size: Word;
  Index: Word;
  Loop: Integer;
begin
  // Read specified file.
  SetLength(AObject, 0);
  RaiseNotActive;

  SetLength(Data, 11);
  Data[0]  := $83;
  Data[1]  := $00;
  Data[2]  := $0A;
  Data[3]  := $CB;
  Data[4]  := Hi(HiWord(FConnectionID));
  Data[5]  := Lo(HiWord(FConnectionID));
  Data[6]  := Hi(LoWord(FConnectionID));
  Data[7]  := Lo(LoWord(FConnectionID));
  Data[8]  := $01;
  Data[9]  := $00;
  Data[10] := $00;

  TempFileName := WideString(ObjectName);
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

  try
    try
      repeat
        Write(Data);
        ReadOBEXPacket(Data);
        CheckOBEXError(Data);

        Answer := Data[0];

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

        if Answer = $90 then begin
          SetLength(Data, 8);
          Data[0]  := $83;
          Data[1]  := $00;
          Data[2]  := $08;
          Data[3]  := $CB;
          Data[4]  := Hi(HiWord(FConnectionID));
          Data[5]  := Lo(HiWord(FConnectionID));
          Data[6]  := Hi(LoWord(FConnectionID));
          Data[7]  := Lo(LoWord(FConnectionID));
        end;
      until Answer = $A0;

    except
      SetLength(AObject, 0);

      raise;
    end;

  finally
    SetLength(Data, 0);
  end;
end;

procedure TBFCustomSyncClient.InternalClose;
var
  Data: TBFByteArray;
begin
  // Close OBEX session.
  if ((Transport = atCOM) and FOBEXActive) or (Transport <> atCOM) then begin
    SetLength(Data, 8);
    Data[0] := $81;
    Data[1] := $00;
    Data[2] := $08;
    Data[3] := $CB;
    Data[4] := Hi(HiWord(FConnectionID));
    Data[5] := Lo(HiWord(FConnectionID));
    Data[6] := Hi(LoWord(FConnectionID));
    Data[7] := Lo(LoWord(FConnectionID));

    try
      Write(Data);
      ReadOBEXPacket(Data);
    except
    end;
  end;

  FConnectionID := 0;

  inherited;
end;

procedure TBFCustomSyncClient.InternalLoad(ObjectName: string; Stream: TStringList);
var
  Data: TBFByteArray;
begin
  RaiseNotActive;

  Stream.Clear;

  SetLength(Data, 0);

  try
    Get(ObjectName, Data);

    if Length(Data) > 0 then begin
      SetLength(Data, Length(Data) + 1);
      Data[Length(Data) - 1] := $00;
      Stream.Text := string(Data);
    end;

 finally
   SetLength(Data, 0);
 end;
end;

procedure TBFCustomSyncClient.InternalOpen;
var
  Data: TBFByteArray;
  Index: Word;
  Header: Byte;
  Size: Word;
begin
  inherited;

  // Open OBEX session.
  SetLength(Data, 19);

  Data[0] := $80;
  Data[1] := $00;
  Data[2] := $13;
  Data[3] := $10;
  Data[4] := $00;
  Data[5] := Hi(PacketSize);
  Data[6] := Lo(PacketSize);
  Data[7]  := $46;
  Data[8]  := $00;
  Data[9]  := $0C;
  Data[10] := Ord('I');
  Data[11] := Ord('R');
  Data[12] := Ord('M');
  Data[13] := Ord('C');
  Data[14] := Ord('-');
  Data[15] := Ord('S');
  Data[16] := Ord('Y');
  Data[17] := Ord('N');
  Data[18] := Ord('C');

  try
    Write(Data);
    ReadOBEXPacket(Data);
    CheckOBEXError(Data, 7);

  except
    inherited InternalClose;
    FActive := False;

    raise;
  end;

  FServerPacketSize := Data[5] shl 8 or Data[6];

  Index := 7;
  while Index < Length(Data) do begin
    Header := Data[Index];
    case Header and $C0 of
      $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
      $80: Size := 1;
      $C0: Size := 5;
    else
      Size := 0;
    end;

    if Header = $CB then begin
      FConnectionID := Data[Index + 1] shl 24 or Data[Index + 2] shl 16 or Data[Index + 3] shl 8 or Data[Index + 4];
      Break;

    end else
      Inc(Index, Size);
  end;
end;

procedure TBFCustomSyncClient.InternalSave(ObjectName: string; Stream: TStringList);
var
  Data: TBFByteArray;
begin
  RaiseNotActive;
  
  SetLength(Data, 0);
  Data := TBFByteArray(Stream.Text);

  try
    Put(ObjectName, Data);

  finally
    SetLength(Data, 0);
  end;
end;

procedure TBFCustomSyncClient.Put(ObjectName: string; AObject: TBFByteArray);
var
  Data: TBFByteArray;
  FileSize: DWORD;
  TempFileName: WideString;
  Loop: Word;
  Index: Word;
  Position: DWORD;
begin
  // Save object.
  RaiseNotActive;

  try
    FileSize := Length(AObject);
    SetLength(Data, 16);
    Data[0] := $02;
    Data[1] := $00;
    Data[2] := $00;
    Data[3] := $CB;
    Data[4] := Hi(HiWord(FConnectionID));
    Data[5] := Lo(HiWord(FConnectionID));
    Data[6] := Hi(LoWord(FConnectionID));
    Data[7] := Lo(LoWord(FConnectionID));
    Data[8] := $C3;
    Data[9] := Hi(HiWord(FileSize));
    Data[10] := Lo(HiWord(FileSize));
    Data[11] := Hi(LoWord(FileSize));
    Data[12] := Lo(LoWord(FileSize));
    Data[13] := $01;
    Data[14] := $00;
    Data[15] := $00;

    TempFileName := WideString(ExtractFileName(ObjectName));
    if TempFileName[Length(TempFileName)] <> #$0000 then TempFileName := TempFileName + #$0000;

    Data[14] := Hi(LoWord(Length(TempFileName) * 2 + 3));
    Data[15] := Lo(LoWord(Length(TempFileName) * 2 + 3));

    SetLength(Data, Length(Data) + Length(TempFileName) * 2);

    Index := 16;
    for Loop := 1 to Length(TempFileName) do begin
      Data[Index] := Hi(Ord(TempFileName[Loop]));
      Data[Index + 1] := Lo(Ord(TempFileName[Loop]));
      Inc(Index, 2);
    end;

    Index := Length(Data);
    SetLength(Data, Length(Data) + 4);
    Data[Index] := $48;
    Data[Index + 1] := $00;
    Data[Index + 2] := $04;
    Data[Index + 3] := AObject[0];

    Data[1] := Hi(LoWord(Length(Data)));
    Data[2] := Lo(LoWord(Length(Data)));

    Write(Data);
    ReadOBEXPacket(Data);
    CheckOBEXError(Data);

    Position := 1;

    while Position < FileSize do begin
      SetLength(Data, FServerPacketSize);
      Data[0] := $02;
      Data[1] := Hi(FServerPacketSize);
      Data[2] := Lo(FServerPacketSize);
      Data[3] := $CB;
      Data[4] := Hi(HiWord(FConnectionID));
      Data[5] := Lo(HiWord(FConnectionID));
      Data[6] := Hi(LoWord(FConnectionID));
      Data[7] := Lo(LoWord(FConnectionID));
      Data[8] := $48;
      Data[9] := Hi(FServerPacketSize - 8);
      Data[10] := Lo(FServerPacketSize - 8);

      Index := 11;
      while (Position < FileSize) and (Index < FServerPacketSize) do begin
        Data[Index] := AObject[Position];
        Inc(Position);
        Inc(Index);
      end;

      Data[1] := Hi(Index);
      Data[2] := Lo(Index);
      Data[9] := Hi(Index - 8);
      Data[10] := Lo(Index - 8);
      if (Position = FileSize) then begin
        Data[0] := $82;
        Data[8] := $49;
        SetLength(Data, Index);
      end;

      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data, 3);
    end;

  finally
    SetLength(Data, 0);
  end;
end;

procedure TBFCustomSyncClient.ReadObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  case AObject of
    soCalendar: InternalLoad('telecom/cal.vcs', AData);
    soDevInfo: InternalLoad('telecom/devinfo.txt', AData);
    soInCalls: InternalLoad('telecom/ich.vcf', AData);
    soInMessages: InternalLoad('telecom/inmsg.vmg', AData);
    soMisCalls: InternalLoad('telecom/mch.vcf', AData);
    soOutCalls: InternalLoad('telecom/och.vcf', AData);
    soOutMessages: InternalLoad('telecom/outmsg.vmg', AData);
    soPhoneBook: InternalLoad('telecom/pb.vcf', AData);
  end;
end;

procedure TBFCustomSyncClient.WriteObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  if AData.Text <> '' then
    case AObject of
      soCalendar: InternalSave('telecom/cal.vcs', AData);
      soDevInfo: raise Exception.Create(StrObjectReadOnly);
      soInCalls: InternalSave('telecom/ich.vcf', AData);
      soInMessages: InternalSave('telecom/inmsg.vmg', AData);
      soMisCalls: InternalSave('telecom/mch.vcf', AData);
      soOutCalls: InternalSave('telecom/och.vcf', AData);
      soOutMessages: InternalSave('telecom/outmsg.vmg', AData);
      soPhoneBook: InternalSave('telecom/pb.vcf', AData);
    end;
end;

{ TBFSyncClient }

procedure TBFSyncClient.ReadObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  inherited;
end;

procedure TBFSyncClient.WriteObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  inherited;
end;

{ TBFSyncClientX }

function _TBFSyncClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFSyncClient;
end;

procedure _TBFSyncClientX.ReadObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  TBFSyncClient(FBFCustomClient).ReadObject(AObject, AData);
end;

procedure _TBFSyncClientX.WriteObject(AObject: TBFSyncObjectType; AData: TStringList);
begin
  TBFSyncClient(FBFCustomClient).WriteObject(AObject, AData);
end;

end.
