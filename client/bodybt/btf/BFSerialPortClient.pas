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
unit BFSerialPortClient;

{$I BF.inc}

interface

uses
  BFClient, Classes, BFClients;

type
  // Serial port profile client. Can execute AT commands.
  // Application should never change Service and ServiceUUID properties.
  TBFSerialPortClient = class(TBFClient)
  private
    FAutoDetect: Boolean;

    procedure SetAutoDetect(const Value: Boolean);

  protected
    procedure InternalOpen; override;

  public
    constructor Create(AOwner: TComponent); override;

    // Executing spesified AT command. Note, that command must not containt
    // tralling CR ($0D) character. It adds internally by this function.
    procedure ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false); virtual;

  published
    // Allows to autodetect needed service.
    property AutoDetect: Boolean read FAutoDetect write SetAutoDetect default True;
  end;

  _TBFSerialPortClientX = class(_TBFClientX)
  private
    function GetAutoDetect: Boolean;

    procedure SetAutoDetect(const Value: Boolean);

  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    procedure ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false); 

  published
    property AutoDetect: Boolean read GetAutoDetect write SetAutoDetect;
  end;

implementation

uses
  BFAPI, Windows, BFDiscovery, SysUtils;

{ TBFSerialPortClient }

constructor TBFSerialPortClient.Create(AOwner: TComponent);
begin
  inherited;

  with BluetoothTransport do begin
    Authentication := True;
    ServiceUUID := SerialPortServiceClass_UUID;
  end;
  IrDATransport.Service := 'IrDA:IrCOMM';

  FAutoDetect := True;
end;

procedure TBFSerialPortClient.ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false);
var
  Loop: Integer;
  Data: TBFByteArray;
  Size: DWORD;
begin
  // Check is client active.
  RaiseNotActive;

  // Firstly send an AT command.
  // Some programmers neve read the doc. So check is CR presents.
  // But before check is the last char CTRLZ. If yes - we do not need CR
  if Length(Command) > 0 then begin
    Loop := Length(Command);

    if Command[Loop] <> CTRLZ then begin
      if Command[Loop] <> CR then Command := Command + CR;

      // Only if the is no CTRLZ
      if NeedLF then Command := Command + LF;
    end;
  end;

  // Now copy into internal buffer
  SetLength(Data, Length(Command));
  for Loop := 1 to Length(Command) do Data[Loop - 1] := Ord(Command[Loop]);
  // and write it.
  Write(Data);

  // Preparing for read response.
  SetLength(Data, 0);
  Response := '';

  // Reading while connection active and not receive responce
  while True do begin
    Size := 255;
    Read(Data, Size);

    if Length(Data) = 0 then Break;

    Response := Response + string(Data);

    // Check is OK
    if (Pos(RESP_OK, Response) > 0) or (Pos(RESP_ERROR, Response) > 0) or (Pos(RESP_OTHER, Response) > 0) then Break;
  end;
end;

procedure TBFSerialPortClient.InternalOpen;
var
  Services: TBFBluetoothServices;
  Found: Boolean;
  Loop: Integer;
begin
  RaiseActive;

  if Transport = atBluetooth then
    if FAutoDetect and (TBFPublicBluetoothClientTransport(BluetoothTransport).DetectedPort = UNKNOWN_PORT) then begin
      Services := EnumServices(BluetoothTransport.Address, false, BluetoothTransport.Radio);

      Found := False;

      // Searching Serial Port profile first.
      for Loop := 0 to Services.Count - 1 do
        if CompareGUIDs(Services[Loop].UUID, SerialPortServiceClass_UUID) then
          if not Found then begin
            with BluetoothTransport do begin
              ServiceUUID := Services[Loop].UUID;
              Service := Services[Loop].Name;
            end;

            Found := True;
            
          end else begin
            Found := False;
            Break;
          end;

      // Searching for DUN.
      if not Found then
        for Loop := 0 to Services.Count - 1 do
          if CompareGUIDs(Services[Loop].UUID, DialupNetworkingServiceClass_UUID) then begin
            with BluetoothTransport do begin
              ServiceUUID := Services[Loop].UUID;
              Service := Services[Loop].Name;
            end;

            Break;
          end;
    end;

  inherited;
end;

procedure TBFSerialPortClient.SetAutoDetect(const Value: Boolean);
begin
  if Value <> FAutoDetect then begin
    RaiseActive;

    FAutoDetect := Value;
    TBFPublicBluetoothClientTransport(BluetoothTransport).DetectedPort := UNKNOWN_PORT;
  end;
end;

{ TBFSerialPortClientX }

procedure _TBFSerialPortClientX.ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false);
begin
  TBFSerialPortClient(FBFCustomClient).ExecuteATCommand(Command, Response, NeedLF);
end;

function _TBFSerialPortClientX.GetAutoDetect: Boolean;
begin
  Result := TBFSerialPortClient(FBFCustomClient).AutoDetect;
end;

function _TBFSerialPortClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFSerialPortClient;
end;

procedure _TBFSerialPortClientX.SetAutoDetect(const Value: Boolean);
begin
  TBFSerialPortClient(FBFCustomClient).AutoDetect := Value;
end;

end.
