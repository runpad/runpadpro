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
unit BFObjectPushServer;

{$I BF.inc}

interface

uses
  BFOBEXServer, Windows, BFAPI, Classes, BFServers;

type
  // Implementation of OBE Object Push profile.
  TBFObjectPushServer = class(TBFOBEXServer)
  private
    FObject: TBFByteArray;
    FObjectName: string;
    FObjectSize: DWORD;
    
  protected
    function BuildSDP(APort: DWORD; AName: string; var ACOD: DWORD; var SDPRecord: TBFByteArray): Boolean; override;

    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure ReadOBEXPacket; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;
  end;

  _TBFObjectPushServerX = class(_TBFOBEXServerX)
  protected
    function GetComponentClass: TBFCustomServerClass; override;
  end;

implementation

{ TBFObjectPushServer }

function TBFObjectPushServer.BuildSDP(APort: DWORD; AName: string; var ACOD: DWORD; var SDPRecord: TBFByteArray): Boolean;
var
  Loop: Integer;
begin
  Result := True;
  ACOD := COD_SERVICE_OBJECT_XFER;

  SetLength(SDPRecord, Length(AName) + 44);

  SDPRecord[0] := $35;
  SDPRecord[1] := Length(SDPRecord) - 2;
  SDPRecord[2] := $09;
  SDPRecord[3] := $00;
  SDPRecord[4] := $01;
  SDPRecord[5] := $35;
  SDPRecord[6] := $03;
  SDPRecord[7] := $19;
  SDPRecord[8] := $11;
  SDPRecord[9] := $05;
  SDPRecord[10] := $09;
  SDPRecord[11] := $00;
  SDPRecord[12] := $04;
  SDPRecord[13] := $35;
  SDPRecord[14] := $11;
  SDPRecord[15] := $35;
  SDPRecord[16] := $03;
  SDPRecord[17] := $19;
  SDPRecord[18] := $01;
  SDPRecord[19] := $00;
  SDPRecord[20] := $35;
  SDPRecord[21] := $05;
  SDPRecord[22] := $19;
  SDPRecord[23] := $00;
  SDPRecord[24] := $03;
  SDPRecord[25] := $08;
  if APort = DWORD(BT_PORT_ANY) then
    SDPRecord[26] := $01
  else
    SDPRecord[26] := Lo(APort);
  SDPRecord[27] := $35;
  SDPRecord[28] := $03;
  SDPRecord[29] := $19;
  SDPRecord[30] := $00;
  SDPRecord[31] := $08;
  SDPRecord[32] := $09;
  SDPRecord[33] := $01;
  SDPRecord[34] := $00;
  SDPRecord[35] := $25;
  SDPRecord[36] := Length(AName);

  for Loop := 0 to Length(AName) - 1 do SDPRecord[37 + Loop] := Ord(AName[Loop + 1]);
  Loop := 37 + Length(AName);

  SDPRecord[Loop] := $09;
  SDPRecord[Loop + 1] := $03;
  SDPRecord[Loop + 2] := $03;
  SDPRecord[Loop + 3] := $35;
  SDPRecord[Loop + 4] := $02;
  SDPRecord[Loop + 5] := $08;
  SDPRecord[Loop + 6] := $FF;
end;

constructor TBFObjectPushServer.Create(AOwner: TComponent);
begin
  inherited;

  BluetoothTransport.ServiceUUID := OBEXObjectPushServiceClass_UUID;
  IrDATransport.Service := 'OBEX';

  SetLength(FObject, 0);
  FObjectName := '';
  FObjectSize := 0;
end;

destructor TBFObjectPushServer.Destroy;
begin
  SetLength(FObject, 0);
  
  inherited;
end;

procedure TBFObjectPushServer.DoConnect;
begin
  inherited;

  SetLength(FObject, 0);
  FObjectName := '';
  FObjectSize := 0;
end;

procedure TBFObjectPushServer.DoDisconnect;
begin
  SetLength(FObject, 0);
  FObjectName := '';
  FObjectSize := 0;

  inherited;
end;

procedure TBFObjectPushServer.ReadOBEXPacket;
var
  Cmd: Byte;
  Size: Word;
  Data: TBFByteArray;
  TmpData: TBFByteArray;
  Header: Byte;
  HeaderSize: Word;
  Index: Word;
  AAbort: Boolean;
  ObjectIndex: DWORD;
  Complete: Boolean;
begin
  Complete := False;
  SetLength(TmpData, 0);

  // Decode OBEX command.
  while True do
    if Length(FData) > 2 then begin
      Cmd := FData[0];
      Size := FData[1] shl 8 or FData[2];

      if Length(FData) >= Size then begin
        TmpData := Copy(FData, 0, Size);
        FData := Copy(FData, Size, DWORD(Length(FData)) - Size);

        case Cmd of
          $80: begin // OBEX connect.
                 FObjectName := '';
                 FObjectSize := 0;
                 SetLength(FObject, 0);

                 SetLength(Data, 7);

                 Data[0] := $A0;
                 Data[1] := $00;
                 Data[2] := $07;
                 Data[3] := $10;
                 Data[4] := $00;
                 Data[5] := Hi(Self.PacketSize);
                 Data[6] := Lo(Self.PacketSize);

                 Write(Data);

                 SetLength(Data, 0);
               end;

          $81: begin // OBEX disconnect.
                 FObjectName := '';
                 FObjectSize := 0;
                 SetLength(FObject, 0);

                 SetLength(Data, 3);

                 Data[0] := $A0;
                 Data[1] := $00;
                 Data[2] := $03;

                 Write(Data);

                 SetLength(Data, 0);
               end;

          $02, $82: begin // OBEX put.
                      if FObjectName = '' then begin
                        Index := 3;
                        while Index < Size do begin
                          Header := TmpData[Index];

                          case Header and $C0 of
                            $00, $40: HeaderSize := TmpData[Index + 1] shl 8 or TmpData[Index + 2];
                            $80: HeaderSize := 1;
                            $C0: HeaderSize := 5;
                          else
                            HeaderSize := 0;
                          end;

                          if Header = $01 then begin
                            HeaderSize := Index + HeaderSize;
                            Inc(Index, 3);

                            while Index < HeaderSize do begin
                              FObjectName := FObjectName + string(WideString(WideChar(TmpData[Index] shl 8 or TmpData[Index + 1])));
                              Inc(Index, 2);
                            end;

                            Break;
                          end;

                          Inc(Index, HeaderSize);
                        end;
                      end;

                      if FObjectSize = 0 then begin
                        Index := 3;
                        while Index < Size do begin
                          Header := TmpData[Index];

                          case Header and $C0 of
                            $00, $40: HeaderSize := TmpData[Index + 1] shl 8 or TmpData[Index + 2];
                            $80: HeaderSize := 1;
                            $C0: HeaderSize := 5;
                          else
                            HeaderSize := 0;
                          end;

                          if Header = $C3 then begin
                            FObjectSize := TmpData[Index + 1] shl 24 or TmpData[Index + 2] shl 16 or TmpData[Index + 3] shl 8 or TmpData[Index + 4];
                            Break;
                          end;

                          Inc(Index, HeaderSize);
                        end;
                      end;

                      AAbort := False; 
                      DoProgress(FObjectName, Length(FObject), FObjectSize, AAbort);

                      if AAbort then begin
                        SetLength(Data, 3);

                        Data[0] := $FF;
                        Data[1] := $00;
                        Data[2] := $03;

                        Write(Data);

                        SetLength(Data, 0);

                      end else begin
                        Index := 3;
                        while Index < Size do begin
                          Header := TmpData[Index];

                          case Header and $C0 of
                            $00, $40: HeaderSize := TmpData[Index + 1] shl 8 or TmpData[Index + 2];
                            $80: HeaderSize := 1;
                            $C0: HeaderSize := 5;
                          else
                            HeaderSize := 0;
                          end;

                          if Header in [$48, $49] then begin
                            ObjectIndex := Length(FObject);
                            SetLength(FObject, ObjectIndex + HeaderSize - 3);
                            HeaderSize := Index + HeaderSize;
                            Inc(Index, 3);

                            while Index < HeaderSize do begin
                              FObject[ObjectIndex] := TmpData[Index];
                              Inc(Index);
                              Inc(ObjectIndex);
                            end;

                            if (Header = $49) or (Cmd = $82) then begin
                              DoObject(FObjectName, FObject);

                              SetLength(FObject, 0);
                              FObjectName := '';
                              FObjectSize := 0;

                              Complete := True;
                            end;

                            Break;
                          end;

                          Inc(Index, HeaderSize);
                        end;

                        SetLength(Data, 3);

                        if Complete then
                          Data[0] := $A0
                        else
                          Data[0] := $90;
                        Data[1] := $00;
                        Data[2] := $03;
                      end;

                      Write(Data);
                      SetLength(Data, 0);
                   end;
        else
          SetLength(Data, 3);

          Data[0] := $C0;
          Data[1] := $00;
          Data[2] := $03;

          Write(Data);

          SetLength(Data, 0);
        end;

      end else
        Break;

    end else
      Break;
end;

{ TBFObjectPushServerX }

function _TBFObjectPushServerX.GetComponentClass: TBFCustomServerClass;
begin
  Result := TBFObjectPushServer;
end;

end.
