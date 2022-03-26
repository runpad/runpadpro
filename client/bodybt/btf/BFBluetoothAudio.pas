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
unit BFBluetoothAudio;

{$I BF.inc}

interface

uses
  BFBase, BFDiscovery, Windows, Classes, BFAPI;

type
  TBFBluetoothAudio = class(TBFBaseComponent)
  private
    FActive: Boolean;
    FAddress: string;
    FAuthentication: Boolean;
    FDevice: TBFBluetoothDevice;
    FEncryption: Boolean;
    FHandle: DWORD;
    FPort: DWORD;
    FRadio: TBFBluetoothRadio;
    FService: string;
    FServiceUUID: TGUID;

    procedure RaiseActive;
    procedure SetActive(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetAuthentication(const Value: Boolean);
    procedure SetDevice(const Value: TBFBluetoothDevice);
    procedure SetEncryption(const Value: Boolean);
    procedure SetPort(const Value: DWORD);
    procedure SetService(const Value: string);
    procedure SetServiceUUID(const Value: TGUID);
    procedure SetRadio(const Value: TBFBluetoothRadio);

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Closes active connection.
    procedure Close;
    // Opens connection to the remote device.
    procedure Open;

    // Returns True if client connected to the remote device. Otherwise returns
    // False. Sets to True to connect to remote device.
    property Active: Boolean read FActive write SetActive;

    // TBFBluetoothDevice object. Note: You can dispose assigned object
    // because here stored copy of it.
    property Device: TBFBluetoothDevice read FDevice write SetDevice;
    // Radio
    property Radio: TBFBluetoothRadio read FRadio write SetRadio;
    // Service UUID to which client should be connected.
    property ServiceUUID: TGUID read FServiceUUID write SetServiceUUID;

  published
    // The Bluetooth device address in '(xx:xx:xx:xx:xx:xx)' format, where
    // xx - hexadecimal digits (for example: (00:bb:ca:07:11:22)), to which
    // client should be connected to.
    property Address: string read FAddress write SetAddress;
    // Sets to True enabling authentication for this client connection.
    property Authentication: Boolean read FAuthentication write SetAuthentication default True;
    // Sets to True enables encription for this client connection.
    property Encryption: Boolean read FEncryption write SetEncryption default False;
    // Port to which client should be connected. Usually must be BT_PORT_ANY.
    property Port: DWORD read FPort write SetPort default DWORD(BT_PORT_ANY);
    // Service name to which client should be connected. If you want connect
    // to your own or unsecified service then use ServiceUUID property.
    property Service: string read FService write SetService;
  end;

  _TBFBluetoothAudioX = class(_TBFActiveXControl)
  private
    FBFBluetoothAudio: TBFBluetoothAudio;

    function GetActive: Boolean;
    function GetAddress: string;
    function GetAuthentication: Boolean;
    function GetDevice: TBFBluetoothDevice;
    function GetEncryption: Boolean;
    function GetPort: DWORD;
    function GetRadio: TBFBluetoothRadio;
    function GetService: string;
    function GetServiceUUID: TGUID;

    procedure SetActive(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetAuthentication(const Value: Boolean);
    procedure SetDevice(const Value: TBFBluetoothDevice);
    procedure SetEncryption(const Value: Boolean);
    procedure SetPort(const Value: DWORD);
    procedure SetRadio(const Value: TBFBluetoothRadio);
    procedure SetService(const Value: string);
    procedure SetServiceUUID(const Value: TGUID);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open;

    property Active: Boolean read GetActive write SetActive;

    property Device: TBFBluetoothDevice read GetDevice write SetDevice;
    property Radio: TBFBluetoothRadio read GetRadio write SetRadio;
    property ServiceUUID: TGUID read GetServiceUUID write SetServiceUUID;

  published  
    property Address: string read GetAddress write SetAddress;
    property Authentication: Boolean read GetAuthentication write SetAuthentication;
    property Encryption: Boolean read GetEncryption write SetEncryption;
    property Port: DWORD read GetPort write SetPort;
    property Service: string read GetService write SetService;
  end;

implementation

uses
  SysUtils, BFStrings, BFAuthenticator,
  ActiveX{$IFDEF DELPHI5},BFD5Support, ComObj{$ENDIF};

{ TBFBluetoothAudio }

procedure TBFBluetoothAudio.Close;

  procedure CloseIVT;
  begin
    if FActive then begin
      BT_DisconnectService(FHandle);
      FHandle := 0;
    end;
  end;

  procedure CloseMS;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

  procedure CloseTos;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

  procedure CloseWD;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

begin
  // Simple call InternalClose
  if FActive then begin
    // Check API and call needed procedure.
    case FRadio.BluetoothAPI of
      baBlueSoleil: CloseIVT;
      baWinSock: CloseMS;
      baWidComm: CloseWD;
      baToshiba: CloseTos;
    end;

    FActive := False;
  end;
end;

constructor TBFBluetoothAudio.Create(AOwner: TComponent);
begin
  inherited;

  FActive := False;
  FAddress := '(00:00:00:00:00:00)';
  FAuthentication := True;
  FDevice := nil;
  FEncryption := False;
  FHandle := 0;
  FPort := DWORD(BT_PORT_ANY);
  FRadio := nil;
  FService := StrHeadset;
  FServiceUUID := HeadsetServiceClass_UUID;
end;

destructor TBFBluetoothAudio.Destroy;
begin
  Close;

  if Assigned(FDevice) then FDevice.Free;
  if Assigned(FRadio) then FRadio.Free;

  inherited;
end;

procedure TBFBluetoothAudio.Open;
var
  ARadio: TBFBluetoothRadio;

  procedure OpenIVT;
  var
    DevInfo: IVTBLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    Serv: GENERAL_SERVICE_INFO;
    ServSize: DWORD;
    Res: DWORD;
  begin
    // Preparing address and service records
    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      address := API.StringToBluetoothAddress(FAddress)
    end;

    ServSize := SizeOf(GENERAL_SERVICE_INFO);
    FillChar(Serv, ServSize, 0);
    with Serv do begin
      dwSize := ServSize;
      wServiceClassUuid16 := API.UUIDToUUID16(FServiceUUID);
    end;

    // Connection to specified service
    Res := BT_ConnectService(@DevInfo, @Serv, nil, FHandle);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);
  end;

  procedure OpenMS;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

  procedure OpenTos;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

  procedure OpenWD;
  begin
    raise Exception.Create(StrStackUnsupported);
  end;

begin
  RaiseActive;

  // Check is Bluetooth available.
  API.CheckTransport(atBluetooth);

  if not Assigned(FRadio) then begin
    ARadio := GetFirstRadio;
    Radio := ARadio;
    ARadio.Free;
  end;

  if not Assigned(FRadio) then raise Exception.Create(StrRadioRequired);

  // Now detect low-level API
  case FRadio.BluetoothAPI of
    baBlueSoleil: OpenIVT;
    baWinSock: OpenMS;
    baWidComm: OpenWD;
    baToshiba: OpenTos;
  end;

  // If all OK then active connection.
  FActive := True;
end;

procedure TBFBluetoothAudio.RaiseActive;
begin
  if FActive then raise Exception.Create(StrClientConnected);
end;

procedure TBFBluetoothAudio.SetActive(const Value: Boolean);
begin
  if Value then
    Open

  else
    Close;
end;

procedure TBFBluetoothAudio.SetAddress(const Value: string);
begin
  if Value <> FAddress then begin
    RaiseActive;

    if Value = '' then
      FAddress := '(00:00:00:00:00:00)'

    else begin
      API.CheckBluetoothAddress(Value);
      FAddress := Value;
    end;
  end;
end;

procedure TBFBluetoothAudio.SetAuthentication(const Value: Boolean);
begin
  if Value <> FAuthentication then begin
    RaiseActive;

    FAuthentication := Value;

    // If we disable Authentication so we must disable an Encryption.
    if not Value then FEncryption := False;
  end;
end;

procedure TBFBluetoothAudio.SetDevice(const Value: TBFBluetoothDevice);
begin
  if Value <> FDevice then begin
    RaiseActive;

    if Assigned(FDevice) then begin
      FDevice.Free;
      FDevice := nil;
    end;

    if Assigned(Value) then begin
      FDevice := TBFBluetoothDevice.Create(nil);
      FDevice.Assign(Value);
    end;

    if Assigned(FDevice) then begin
      if FAddress <> FDevice.Address then FAddress := FDevice.Address;

      if Assigned(FRadio) then begin
        FRadio.Free;
        FRadio := nil;
      end;

      if Assigned(FDevice.Radio) then begin
        FRadio := TBFBluetoothRadio.Create;
        FRadio.Assign(FDevice.Radio);
      end;
    end;
  end;
end;

procedure TBFBluetoothAudio.SetEncryption(const Value: Boolean);
begin
  if Value <> FEncryption then begin
    RaiseActive;

    FEncryption := Value;

    // If we enabling Encryption we also must anabling an authentication.
    if Value then FAuthentication := True;
  end;
end;

procedure TBFBluetoothAudio.SetPort(const Value: DWORD);
begin
  if Value <> FPort then begin
    RaiseActive;

    if (Value > 30) and (Value <> DWORD(BT_PORT_ANY)) then raise Exception.Create(StrInvalidPortNumber);

    FPort := Value;
  end;
end;

procedure TBFBluetoothAudio.SetRadio(const Value: TBFBluetoothRadio);
begin
  RaiseActive;

  if Assigned(FRadio) then begin
    FRadio.Free;
    FRadio := nil;
  end;

  if Assigned(Value) then begin
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothAudio.SetService(const Value: string);
var
  Tmp: TGUID;
begin
  if Value <> Service then begin
    RaiseActive;

    FService := Value;

    Tmp := API.StringToUUID(Value);
    if not CompareGUIDs(Tmp, GUID_NULL) then FServiceUUID := Tmp;
  end;
end;

procedure TBFBluetoothAudio.SetServiceUUID(const Value: TGUID);
var
  Tmp: string;
begin
  if not CompareGUIDs(Value, FServiceUUID) then begin
    RaiseActive;

    FServiceUUID := Value;

    Tmp := API.UUIDToString(FServiceUUID);
    if Tmp <> 'Unknown' then FService := Tmp;
  end;
end;

{ TBFBluetoothAudioX }

procedure _TBFBluetoothAudioX.Close;
begin
  FBFBluetoothAudio.Close;
end;

constructor _TBFBluetoothAudioX.Create(AOwner: TComponent);
begin
  inherited;

  FBFBluetoothAudio := TBFBluetoothAudio.Create(nil);
end;

destructor _TBFBluetoothAudioX.Destroy;
begin
  FBFBluetoothAudio.Free;
  
  inherited;
end;

function _TBFBluetoothAudioX.GetActive: Boolean;
begin
  Result := FBFBluetoothAudio.Active;
end;

function _TBFBluetoothAudioX.GetAddress: string;
begin
  Result := FBFBluetoothAudio.Address;
end;

function _TBFBluetoothAudioX.GetAuthentication: Boolean;
begin
  Result := FBFBluetoothAudio.Authentication;
end;

function _TBFBluetoothAudioX.GetDevice: TBFBluetoothDevice;
begin
  Result := FBFBluetoothAudio.Device;
end;

function _TBFBluetoothAudioX.GetEncryption: Boolean;
begin
  Result := FBFBluetoothAudio.Encryption;
end;

function _TBFBluetoothAudioX.GetPort: DWORD;
begin
  Result := FBFBluetoothAudio.Port;
end;

function _TBFBluetoothAudioX.GetRadio: TBFBluetoothRadio;
begin
  Result := FBFBluetoothAudio.Radio;
end;

function _TBFBluetoothAudioX.GetService: string;
begin
  Result := FBFBluetoothAudio.Service;
end;

function _TBFBluetoothAudioX.GetServiceUUID: TGUID;
begin
  Result := FBFBluetoothAudio.ServiceUUID;
end;

procedure _TBFBluetoothAudioX.Open;
begin
  FBFBluetoothAudio.Open;
end;

procedure _TBFBluetoothAudioX.SetActive(const Value: Boolean);
begin
  FBFBluetoothAudio.Active := Value;
end;

procedure _TBFBluetoothAudioX.SetAddress(const Value: string);
begin
  FBFBluetoothAudio.Address := Value;
end;

procedure _TBFBluetoothAudioX.SetAuthentication(const Value: Boolean);
begin
  FBFBluetoothAudio.Authentication := Value;
end;

procedure _TBFBluetoothAudioX.SetDevice(const Value: TBFBluetoothDevice);
begin
  FBFBluetoothAudio.Device := Value;
end;

procedure _TBFBluetoothAudioX.SetEncryption(const Value: Boolean);
begin
  FBFBluetoothAudio.Encryption := Value;
end;

procedure _TBFBluetoothAudioX.SetPort(const Value: DWORD);
begin
  FBFBluetoothAudio.Port := Value;
end;

procedure _TBFBluetoothAudioX.SetRadio(const Value: TBFBluetoothRadio);
begin
  FBFBluetoothAudio.Radio := Value;
end;

procedure _TBFBluetoothAudioX.SetService(const Value: string);
begin
  FBFBluetoothAudio.Service := Value;
end;

procedure _TBFBluetoothAudioX.SetServiceUUID(const Value: TGUID);
begin
  FBFBluetoothAudio.ServiceUUID := ServiceUUID;
end;

end.
