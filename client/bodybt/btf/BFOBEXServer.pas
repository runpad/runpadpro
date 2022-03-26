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
unit BFOBEXServer;

{$I BF.inc}

interface

uses
  BFServers, BFAPI, Windows, Classes;

type
  // OnObject event prototype.
  TServerObjectEvent = procedure (Sender: TObject; AName: string; AObject: TBFByteArray) of object;
  // OnProgress event prototype.
  TServerProgressEvent = procedure (Sender: TObject; AName: string; APosition: DWORD; ASize: DWORD; var AAbort: Boolean) of object;
  
  // Base class for all OBEX based servers.
  TBFOBEXServer = class(TBFCustomServer)
  private
    FPacketSize: Word;

    FOnObject: TServerObjectEvent;
    FOnProgress: TServerProgressEvent;

    procedure SetPacketSize(const Value: Word);

  protected
    // Internal buffer data.
    FData: TBFByteArray;

    // Closes the server.
    procedure InternalClose; override;
    // Opens server. Never call it from other palces. Always call Open.
    procedure InternalOpen; override;

    procedure DoConnect; override;
    procedure DoData(Data: TBFByteArray); override;
    procedure DoDisconnect; override;
    procedure DoObject(AName: string; AObject: TBFByteArray);
    procedure DoProgress(AName: string; APosition: DWORD; ASize: DWORD; var AAbort: Boolean);
    // Reads OBEX packet from connection. Ancessor should ovverride this method
    // to decode packes.
    procedure ReadOBEXPacket; virtual; abstract;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

  published
    // OBEX packet size.
    property PacketSize: Word read FPacketSize write SetPacketSize default 512;

    // Event occurs when object received.
    property OnObject: TServerObjectEvent read FOnObject write FOnObject;
    // Event occurs while object receiving.
    property OnProgress: TServerProgressEvent read FOnProgress write FOnProgress;
  end;

  _TBFOBEXServerX = class(_TBFCustomServerX)
  private
    function GetOnObject: TServerObjectEvent;
    function GetOnProgress: TServerProgressEvent;
    function GetPacketSize: Word;

    procedure SetOnObject(const Value: TServerObjectEvent);
    procedure SetOnProgress(const Value: TServerProgressEvent);
    procedure SetPacketSize(const Value: Word);
    
  protected
    function GetComponentClass: TBFCustomServerClass; override;

  published
    property PacketSize: Word read GetPacketSize write SetPacketSize;

    property OnObject: TServerObjectEvent read GetOnObject write SetOnObject;
    property OnProgress: TServerProgressEvent read GetOnProgress write SetOnProgress;
  end;

implementation

uses
  SysUtils;

{ TBFOBEXServer }

constructor TBFOBEXServer.Create(AOwner: TComponent);
begin
  inherited;

  SetLength(FData, 0);
  FPacketSize := 512;

  FOnObject := nil;
  FOnProgress := nil;
end;

destructor TBFOBEXServer.Destroy;
begin
  SetLength(FData, 0);
  
  inherited;
end;

procedure TBFOBEXServer.DoConnect;
begin
  SetLength(FData, 0);

  inherited;
end;

procedure TBFOBEXServer.DoData(Data: TBFByteArray);
var
  DataLength: Integer;
  Loop: Integer;
begin
  // Copy data to buffer.
  DataLength := Length(FData);

  SetLength(FData, DataLength + Length(Data));
  for Loop := 0 to Length(Data) - 1 do FData[DataLength + Loop] := Data[Loop];

  // Now checks OBEX packets.
  ReadOBEXPacket;

  inherited;
end;

procedure TBFOBEXServer.DoDisconnect;
begin
  SetLength(FData, 0);
  
  inherited;
end;

procedure TBFOBEXServer.DoObject(AName: string; AObject: TBFByteArray);
begin
  if Assigned(FOnObject) then
    try
      FOnObject(Self, AName, AObject);
    except
    end;

  SetLength(AObject, 0);
end;

procedure TBFOBEXServer.DoProgress(AName: string; APosition, ASize: DWORD; var AAbort: Boolean);
begin
  if Assigned(FOnProgress) then
    try
      FOnProgress(Self, AName, APosition, ASize, AAbort);
    except
    end;
end;

procedure TBFOBEXServer.InternalClose;
var
  DevInfoEx: BLUETOOTH_DEVICE_INFO_EX;
  DevInfoExSize: DWORD;
  DevInfo: IVTBLUETOOTH_DEVICE_INFO;
  DevInfoSize: DWORD;
  COD: DWORD;
begin
  if (Transport = atBluetooth) and (BluetoothTransport.Radio.BluetoothAPI = baBlueSoleil) then begin
    DevInfoExSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
    FillChar(DevInfoEx, DevInfoExSize, 0);
    DevInfoEx.dwSize := DevInfoExSize;

    BT_GetLocalDeviceInfo(MASK_DEVICE_CLASS, DevInfoEx);

    COD := API.BlueSoleilClassOfDeviceToCOD(DevInfoEx.classOfDevice);
    COD := COD and not COD_SRVCLS_OBJECT;

    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      classOfDevice[2] := Lo(HiWord(COD));
      classOfDevice[1] := Hi(LoWord(COD));
      classOfDevice[0] := Lo(LoWord(COD));
    end;

    BT_SetLocalDeviceInfo(MASK_DEVICE_CLASS, @DevInfo);
  end;

  inherited;
end;

procedure TBFOBEXServer.InternalOpen;
var
  DevInfoEx: BLUETOOTH_DEVICE_INFO_EX;
  DevInfoExSize: DWORD;
  DevInfo: IVTBLUETOOTH_DEVICE_INFO;
  DevInfoSize: DWORD;
  COD: DWORD;
begin
  inherited;

  if (Transport = atBluetooth) and (BluetoothTransport.Radio.BluetoothAPI = baBlueSoleil) then begin
    DevInfoExSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
    FillChar(DevInfoEx, DevInfoExSize, 0);
    DevInfoEx.dwSize := DevInfoExSize;

    BT_GetLocalDeviceInfo(MASK_DEVICE_CLASS, DevInfoEx);

    COD := API.BlueSoleilClassOfDeviceToCOD(DevInfoEx.classOfDevice);
    COD := COD or COD_SRVCLS_OBJECT;

    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      classOfDevice[2] := Lo(HiWord(COD));
      classOfDevice[1] := Hi(LoWord(COD));
      classOfDevice[0] := Lo(LoWord(COD));
    end;

    BT_SetLocalDeviceInfo(MASK_DEVICE_CLASS, @DevInfo);
  end;
end;

procedure TBFOBEXServer.SetPacketSize(const Value: Word);
begin
  if Value <> FPacketSize then begin
    RaiseActive;

    FPacketSize := Value;
  end;
end;

{ TBFOBEXServerX }
         
function _TBFOBEXServerX.GetComponentClass: TBFCustomServerClass;
begin
  Result := TBFOBEXServer;
end;

function _TBFOBEXServerX.GetOnObject: TServerObjectEvent;
begin
  Result := TBFOBEXServer(FBFCustomServer).OnObject;
end;

function _TBFOBEXServerX.GetOnProgress: TServerProgressEvent;
begin
  Result := TBFOBEXServer(FBFCustomServer).OnProgress;
end;

function _TBFOBEXServerX.GetPacketSize: Word;
begin
  Result := TBFOBEXServer(FBFCustomServer).PacketSize;
end;

procedure _TBFOBEXServerX.SetOnObject(const Value: TServerObjectEvent);
begin
  TBFOBEXServer(FBFCustomServer).OnObject := Value;
end;

procedure _TBFOBEXServerX.SetOnProgress(const Value: TServerProgressEvent);
begin
  TBFOBEXServer(FBFCustomServer).OnProgress := Value;
end;

procedure _TBFOBEXServerX.SetPacketSize(const Value: Word);
begin
  TBFOBEXServer(FBFCustomServer).PacketSize := Value;
end;

end.
