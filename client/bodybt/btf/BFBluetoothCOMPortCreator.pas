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
unit BFBluetoothCOMPortCreator;

{$I BF.inc}

interface

uses
  BFBase, BFClients, Windows, Classes, BFAPI, BFDiscovery, Messages;

type
  // Creates virtual COM port associations with Bluetooth Devices.
  TBFBluetoothCOMPortCreator = class(TBFBaseComponent)
  private
    FActive: Boolean;
    FAddress: string;
    FAuthentication: Boolean;
    FAutoDetect: Boolean;
    FCID: Word;
    FCOMNumber: Byte;
    FDevice: TBFBluetoothDevice;
    FEncryption: Boolean;
    FHandle: THandle;
    FPort: DWORD;
    FRadio: TBFBluetoothRadio;
    FService: string;
    FServiceUUID: TGUID;

    function GetCOMNumber: Byte;

    procedure BFNMTosClientConnected(var Message: TMessage); message BFNM_TOS_CLIENTCONNECTED;
    procedure RaiseActive;
    procedure RaiseNotActive;
    procedure SetActive(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetAuthentication(const Value: Boolean);
    procedure SetAutoDetect(const Value: Boolean);
    procedure SetDevice(const Value: TBFBluetoothDevice);
    procedure SetEncryption(const Value: Boolean);
    procedure SetPort(const Value: DWORD);
    procedure SetRadio(const Value: TBFBluetoothRadio);
    procedure SetService(const Value: string);
    procedure SetServiceUUID(const Value: TGUID);

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

    // Created COM port number.
    property COMNumber: Byte read GetCOMNumber;
    // TBFBluetoothDevice object. Note: You can dispose assigned object
    // because here stored copy of it.
    property Device: TBFBluetoothDevice read FDevice write SetDevice;
    // Radio on which working.
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
    // Allows to autodetect nneded service.
    property AutoDetect: Boolean read FAutoDetect write SetAutoDetect default True;
    // Sets to True enables encription for this client connection.
    property Encryption: Boolean read FEncryption write SetEncryption default False;
    // Port to which client should be connected. Usually must be BT_PORT_ANY.
    property Port: DWORD read FPort write SetPort default DWORD(BT_PORT_ANY);
    // Service name to which client should be connected. If you want connect
    // to your own or unsecified service then use ServiceUUID property.
    property Service: string read FService write SetService;
  end;

  _TBFBluetoothCOMPortCreatorX = class(_TBFActiveXControl)
  private
    FBFBluetoothCOMPortCreator: TBFBluetoothCOMPortCreator;

    function GetActive: Boolean;
    function GetAddress: string;
    function GetAuthentication: Boolean;
    function GetAutoDetect: Boolean;
    function GetCOMNumber: Byte;
    function GetDevice: TBFBluetoothDevice;
    function GetEncryption: Boolean;
    function GetPort: DWORD;
    function GetRadio: TBFBluetoothRadio;
    function GetService: string;
    function GetServiceUUID: TGUID;

    procedure SetActive(const Value: Boolean);
    procedure SetAddress(const Value: string);
    procedure SetAuthentication(const Value: Boolean);
    procedure SetAutoDetect(const Value: Boolean);
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

    property COMNumber: Byte read GetCOMNumber;
    property Device: TBFBluetoothDevice read GetDevice write SetDevice;
    property Radio: TBFBluetoothRadio read GetRadio write SetRadio;
    property ServiceUUID: TGUID read GetServiceUUID write SetServiceUUID;

  published
    property Address: string read GetAddress write SetAddress;
    property Authentication: Boolean read GetAuthentication write SetAuthentication;
    property AutoDetect: Boolean read GetAutoDetect write SetAutoDetect;
    property Encryption: Boolean read GetEncryption write SetEncryption;
    property Port: DWORD read GetPort write SetPort;
    property Service: string read GetService write SetService;
  end;

implementation

uses
  BFStrings, ActiveX, SysUtils, Forms, Registry,
  BFAuthenticator{$IFDEF DELPHI5},BFD5Support, ComObj{$ENDIF};

{ TBFBluetoothCOMPortCreator }

procedure TBFBluetoothCOMPortCreator.BFNMTosClientConnected(var Message: TMessage);
begin
  with Message do
    if (WParam = TOSBTAPI_NM_CONNECTCOMM_ERROR) or (WParam = TOSBTAPI_NM_CONNECTCOMM_END) then
      SetEvent(LParam);
end;

procedure TBFBluetoothCOMPortCreator.Close;

  procedure CloseIVT;
  begin
    if FHandle <> INVALID_HANDLE_VALUE then begin
      BT_DisconnectSPPExService(FHandle);
      FHandle := INVALID_HANDLE_VALUE;
      FCOMNumber := 0;
    end;
  end;

  procedure CloseMS;
  var
    DevInfo: BLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
  begin
    DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      Address.rgBytes := API.StringToBluetoothAddress(FAddress);
    end;

    BluetoothSetServiceState(0, @DevInfo, @FServiceUUID, BLUETOOTH_SERVICE_DISABLE);

    FCOMNumber := 0;
  end;

  procedure CloseTos;
  var
    Status: Long;
    PortName: string;
  begin
    if FCID <> 0 then begin
      BtDisconnectCOMM(PChar('COM' + IntToStr(FCOMNumber)), Status);
      FCID := 0;
    end;

    if FCOMNumber <> 0 then begin
      PortName := 'COM' + IntToStr(FCOMNumber);
      BtDestroyCOMM(PChar(PortName), Status);
      FCOMNumber := 0;
    end;
  end;

  procedure CloseWD;
  begin
    if FCOMNumber > 0 then begin
      WD_RemoveCOMPortAssociation(FCOMNumber);
      FCOMNumber := 0;
    end;
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

constructor TBFBluetoothCOMPortCreator.Create(AOwner: TComponent);
begin
  inherited;

  FActive := False;
  FAddress := '(00:00:00:00:00:00)';
  FAuthentication := True;
  FAutoDetect := True;
  FCID := 0;
  FCOMNumber := 0;
  FDevice := nil;
  FEncryption := False;
  FHandle := INVALID_HANDLE_VALUE;
  FPort := DWORD(BT_PORT_ANY);
  FRadio := nil;
  FService := 'Srial Port';
  FServiceUUID := SerialPortServiceClass_UUID;
end;

destructor TBFBluetoothCOMPortCreator.Destroy;
begin
  Close;

  if Assigned(FDevice) then FDevice.Free;
  if Assigned(FRadio) then FRadio.Free;

  inherited;
end;

function TBFBluetoothCOMPortCreator.GetCOMNumber: Byte;
begin
  RaiseNotActive;

  Result := FCOMNumber;
end;

procedure TBFBluetoothCOMPortCreator.Open;
var
  Services: TBFBluetoothServices;
  Found: Boolean;
  Loop: Integer;

  procedure OpenIVT;
  var
    DevInfo: IVTBLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    Serv: SPPEX_SERVICE_INFO;
    ServSize: DWORD;
    Res: DWORD;

    function GetChannel: Byte;
    var
      ServiceClassLength: DWORD;
      ServiceClassList: SPPEX_SERVICE_INFO;
    begin
      if FPort <> DWORD(BT_PORT_ANY) then
        Result := Lo(LoWord(FPort))

      else begin
        ServiceClassLength := SizeOf(SPPEX_SERVICE_INFO);
        FillChar(ServiceClassList, ServiceClassLength, 0);
        ServiceClassList.serviceClassUuid128 := FServiceUUID;

        Res := BT_SearchSPPExServices(@DevInfo, ServiceClassLength, @ServiceClassList);
        if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

        Result := ServiceClassList.ucServiceChannel;
      end;
    end;

  begin
    // Preparing address and service records
    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      address := API.StringToBluetoothAddress(FAddress)
    end;

    ServSize := SizeOf(SPPEX_SERVICE_INFO);
    FillChar(Serv, ServSize, 0);
    with Serv do begin
      dwSize := ServSize;
      ucServiceChannel := GetChannel;
      serviceClassUuid128 := FServiceUUID;
    end;

    // Connection to specified service
    Res := BT_ConnectSPPExService(@DevInfo, @Serv, @FHandle);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

    FCOMNumber := Serv.ucComIndex;
  end;

  procedure OpenMS;
  var
    DevInfo: BLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    Res: DWORD;

    function GetPortNum: Byte;
    var
      Loop: Integer;
      Params: TStringList;
      AKeyName: string;
      PortStr: string;
      SubKeys: TStringList;
      ServiceUUIDStr: string;
      Ndx: Integer;
      Found: Boolean;
    begin
      Result := 0;

      Params := TStringList.Create;
      SubKeys := TStringList.Create;

      with TRegistry.Create do begin
        Access := KEY_READ;
        RootKey := HKEY_LOCAL_MACHINE;

        ServiceUUIDStr := AnsiLowerCase(GUIDToString(FServiceUUID));
        if OpenKey('SYSTEM\CurrentControlSet\Enum\BTHENUM', False) then begin
          GetKeyNames(SubKeys);
          CloseKey;

          Found := False;

          for Ndx := 0 to SubKeys.Count - 1 do
            if Pos(ServiceUUIDStr, SubKeys[Ndx]) > 0 then begin
              AKeyName := 'SYSTEM\CurrentControlSet\Enum\BTHENUM\' + SubKeys[Ndx];

              if OpenKey(AKeyName, False) then begin
                GetKeyNames(Params);
                CloseKey;

                for Loop := 0 to Params.Count - 1 do Params[Loop] := AKeyName + '\' + Params[Loop];

                AKeyName := FAddress[2] + FAddress[3];
                AKeyName := AKeyName + FAddress[5] + FAddress[6];
                AKeyName := AKeyName + FAddress[8] + FAddress[9];
                AKeyName := AKeyName + FAddress[11] + FAddress[12];
                AKeyName := AKeyName + FAddress[14] + FAddress[15];
                AKeyName := AKeyName + FAddress[17] + FAddress[18];

                for Loop := 0 to Params.Count - 1 do
                  if Pos(AKeyName, Params[Loop]) > 0 then
                    if OpenKey(Params[Loop] + '\Control', False) then begin
                      CloseKey;

                      if OpenKey(Params[Loop] + '\Device Parameters', False) then begin
                        PortStr := ReadString('PortName');

                        CloseKey;

                        if Copy(PortStr, 1, 3) = 'COM' then begin
                          PortStr := Trim(Copy(PortStr, 4, Length(PortStr)));

                          Result := StrToInt(PortStr);
                          Found := True;

                          Break;
                        end;
                      end;
                    end;
              end;

              if Found then Break;
            end;
        end;

        Free;
      end;

      Params.Free;
      SubKeys.Free;
    end;

  begin
    FCOMNumber := GetPortNum;

    if FCOMNumber = 0 then begin
      DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
      FillChar(DevInfo, DevInfoSize, 0);
      with DevInfo do begin
        dwSize := DevInfoSize;
        Address.rgBytes := API.StringToBluetoothAddress(FAddress);
      end;

      Res := BluetoothSetServiceState(0, @DevInfo, @FServiceUUID, BLUETOOTH_SERVICE_ENABLE);
      if Res <> ERROR_SUCCESS then begin
        SetLastError(Res);
        RaiseLastOSError;
      end;

      FCOMNumber := GetPortNum;

      if FCOMNumber = 0 then begin
        BluetoothSetServiceState(0, @DevInfo, @FServiceUUID, BLUETOOTH_SERVICE_DISABLE);

        raise Exception.Create(StrMSPortCreateError);
      end;
    end;
  end;

  procedure OpenTos;
  var
    PortNum: Byte;
    PortName: string;
    Status: Long;
    APort: Byte;
    Adr: TBluetoothAddress;
    Event: THandle;
    Opt: DWORD;
    Res: DWORD;

    function GetChannel: Byte;
    var
      Services: TBFBluetoothServices;
      Loop: Integer;
    begin
      if FPort = DWORD(BT_PORT_ANY) then begin
        Result := 0;

        Services := EnumServices(FAddress, False, FRadio);

        if Assigned(Services) then begin
          for Loop := 0 to Services.Count - 1 do
            if CompareGUIDs(Services[Loop].UUID, FServiceUUID) then begin
              Result := Services[Loop].Channel;

              Break;
            end;

          Services.Free;

          if Result = 0 then raise Exception.Create(StrServiceNotFound);

        end else
          raise Exception.Create(StrServiceNotFound);

      end else
        Result := Lo(LoWord(FPort));
    end;

  begin
    for PortNum := 1 to 255 do begin
      PortName := 'COM' + IntToStr(PortNum);

      if BtCreateCOMM(PChar(PortName), 0, 0, Status) then begin
        FCOMNumber := PortNum;

        Break;
      end;
    end;

    if FCOMNumber = 0 then API.RaiseTosError(Status);

    try
      APort := GetChannel;
      with API do Adr := ReverseToshibaBTAddress(StringToBluetoothAddress(FAddress));
      Opt := 0;
      if FAuthentication then Opt := 1;
      if FEncryption then Opt := 3;

      Event := CreateEvent(nil, True, False, nil);

      try
        if BtConnectCOMM2(PChar(PortName), Adr, APort, 3, FCID, Opt, Status, Wnd, BFNM_TOS_CLIENTCONNECTED, Event) then begin
          Res := WAIT_OBJECT_0 + 1;

          while Res = WAIT_OBJECT_0 + 1 do begin
            Res := MsgWaitForMultipleObjects(1, Event, False, INFINITE, QS_POSTMESSAGE or QS_SENDMESSAGE);

            Application.ProcessMessages;
          end;

          try
            if Status < TOSBTAPI_NO_ERROR then API.RaiseTosError(Status);

          except
            BtDisconnectCOMM(PChar(PortName), Status);

            raise;
          end;

        end else
          API.RaiseTosError(Status);

      finally
        CloseHandle(Event);
      end;

    except
      BtDestroyCOMM(PChar(PortName), Status);
      FCOMNumber := 0;

      raise;
    end;
  end;

  procedure OpenWD;
  var
    Level: Byte;
    APort: Word;
    Loop: Integer;
    AServiceName: string;
    Services: SERVICE_LIST;
    Tmp: string;
  begin
    // Retrive service name :(
    AServiceName := '';
    WD_Discovery(API.StringToBluetoothAddress(FAddress), @Services, True);

    Tmp := API.UUIDToString(FServiceUUID);
    for Loop := 0 to Services.dwCount - 1 do
      if API.UUIDToUUID16(Services.Services[Loop].Uuid) = API.UUIDToUUID16(FServiceUUID) then
        if (Tmp = FService) or ((Tmp <> FService) and (FService = Services.Services[Loop].Name)) then begin
          AServiceName := Services.Services[Loop].Name;
          Break;
        end;

    if AServiceName = '' then raise Exception.Create(StrServiceNotFound);

    Level := 0;
    if FAuthentication then Level := Level or BTM_SEC_OUT_AUTHENTICATE;
    if FEncryption then Level := Level or BTM_SEC_OUT_ENCRYPT;

    // Try to bond is needed
    if FAuthentication and Assigned(gAuthenticator) then gAuthenticator.BondWD(API.StringToBluetoothAddress(FAddress));

    if not WD_CreateCOMPortAssociation(API.StringToBluetoothAddress(FAddress), FServiceUUID, PChar(AServiceName), Level, API.UUIDToUUID16(FServiceUUID), APort) then raise Exception.Create(StrUnableCreateCOMPort);

    FCOMNumber := APort;
  end;

begin
  RaiseActive;

  // Check is Bluetooth available.
  API.CheckTransport(atBluetooth);

  if FAutoDetect then begin
    Services := EnumServices(FAddress, false, FRadio);

    Found := False;

    // Searching Serial Port profile first.
    for Loop := 0 to Services.Count - 1 do
      if CompareGUIDs(Services[Loop].UUID, SerialPortServiceClass_UUID) then
        if not Found then begin
          ServiceUUID := Services[Loop].UUID;
          Service := Services[Loop].Name;

          Found := True;

        end else begin
          Found := False;
          Break;
        end;

    // Searching for DUN.
    if not Found then
      for Loop := 0 to Services.Count - 1 do
        if CompareGUIDs(Services[Loop].UUID, DialupNetworkingServiceClass_UUID) then begin
          ServiceUUID := Services[Loop].UUID;
          Service := Services[Loop].Name;
          
          Break;
        end;
  end;

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

procedure TBFBluetoothCOMPortCreator.RaiseActive;
begin
  if FActive then raise Exception.Create(StrClientConnected);
end;

procedure TBFBluetoothCOMPortCreator.RaiseNotActive;
begin
  if not FActive then raise Exception.Create(StrClientNotConnected);
end;

procedure TBFBluetoothCOMPortCreator.SetActive(const Value: Boolean);
begin
  if Value then
    Open

  else
    Close;
end;

procedure TBFBluetoothCOMPortCreator.SetAddress(const Value: string);
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

procedure TBFBluetoothCOMPortCreator.SetAuthentication(const Value: Boolean);
begin
  if Value <> FAuthentication then begin
    RaiseActive;

    FAuthentication := Value;

    // If we disable Authentication so we must disable an Encryption.
    if not Value then FEncryption := False;
  end;
end;

procedure TBFBluetoothCOMPortCreator.SetAutoDetect(const Value: Boolean);
begin
  if Value <> FAutoDetect then begin
    RaiseActive;

    FAutoDetect := Value;
  end;
end;

procedure TBFBluetoothCOMPortCreator.SetDevice(const Value: TBFBluetoothDevice);
begin
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

procedure TBFBluetoothCOMPortCreator.SetEncryption(const Value: Boolean);
begin
  if Value <> FEncryption then begin
    RaiseActive;

    FEncryption := Value;

    // If we enabling Encryption we also must anabling an authentication.
    if Value then FAuthentication := True;
  end;
end;

procedure TBFBluetoothCOMPortCreator.SetPort(const Value: DWORD);
begin
  if Value <> FPort then begin
    RaiseActive;

    if (Value > 30) and (Value <> DWORD(BT_PORT_ANY)) then raise Exception.Create(StrInvalidPortNumber);

    FPort := Value;
  end;
end;

procedure TBFBluetoothCOMPortCreator.SetRadio(const Value: TBFBluetoothRadio);
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

procedure TBFBluetoothCOMPortCreator.SetService(const Value: string);
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

procedure TBFBluetoothCOMPortCreator.SetServiceUUID(const Value: TGUID);
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

{ TBFBluetoothCOMPortCreatorX }

procedure _TBFBluetoothCOMPortCreatorX.Close;
begin
  FBFBluetoothCOMPortCreator.Close;
end;

constructor _TBFBluetoothCOMPortCreatorX.Create(AOwner: TComponent);
begin
  inherited;

  FBFBluetoothCOMPortCreator := TBFBluetoothCOMPortCreator.Create(nil);
end;

destructor _TBFBluetoothCOMPortCreatorX.Destroy;
begin
  FBFBluetoothCOMPortCreator.Free;

  inherited;
end;

function _TBFBluetoothCOMPortCreatorX.GetActive: Boolean;
begin
  Result := FBFBluetoothCOMPortCreator.Active;
end;

function _TBFBluetoothCOMPortCreatorX.GetAddress: string;
begin
  Result := FBFBluetoothCOMPortCreator.Address;
end;

function _TBFBluetoothCOMPortCreatorX.GetAuthentication: Boolean;
begin
  Result := FBFBluetoothCOMPortCreator.Authentication;
end;

function _TBFBluetoothCOMPortCreatorX.GetAutoDetect: Boolean;
begin
  Result := FBFBluetoothCOMPortCreator.AutoDetect;
end;

function _TBFBluetoothCOMPortCreatorX.GetCOMNumber: Byte;
begin
  Result := FBFBluetoothCOMPortCreator.COMNumber;
end;

function _TBFBluetoothCOMPortCreatorX.GetDevice: TBFBluetoothDevice;
begin
  Result := FBFBluetoothCOMPortCreator.Device;
end;

function _TBFBluetoothCOMPortCreatorX.GetEncryption: Boolean;
begin
  Result := FBFBluetoothCOMPortCreator.Encryption;
end;

function _TBFBluetoothCOMPortCreatorX.GetPort: DWORD;
begin
  Result := FBFBluetoothCOMPortCreator.Port;
end;

function _TBFBluetoothCOMPortCreatorX.GetRadio: TBFBluetoothRadio;
begin
  Result := FBFBluetoothCOMPortCreator.Radio;
end;

function _TBFBluetoothCOMPortCreatorX.GetService: string;
begin
  Result := FBFBluetoothCOMPortCreator.Service;
end;

function _TBFBluetoothCOMPortCreatorX.GetServiceUUID: TGUID;
begin
  Result := FBFBluetoothCOMPortCreator.ServiceUUID;
end;

procedure _TBFBluetoothCOMPortCreatorX.Open;
begin
  FBFBluetoothCOMPortCreator.Open;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetActive(const Value: Boolean);
begin
  FBFBluetoothCOMPortCreator.Active := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetAddress(const Value: string);
begin
  FBFBluetoothCOMPortCreator.Address := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetAuthentication(const Value: Boolean);
begin
  FBFBluetoothCOMPortCreator.Authentication := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetAutoDetect(const Value: Boolean);
begin
  FBFBluetoothCOMPortCreator.AutoDetect := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetDevice(const Value: TBFBluetoothDevice);
begin
  FBFBluetoothCOMPortCreator.Device := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetEncryption(const Value: Boolean);
begin
  FBFBluetoothCOMPortCreator.Encryption := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetPort(const Value: DWORD);
begin
  FBFBluetoothCOMPortCreator.Port := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetRadio(const Value: TBFBluetoothRadio);
begin
  FBFBluetoothCOMPortCreator.Radio := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetService(const Value: string);
begin
  FBFBluetoothCOMPortCreator.Service := Value;
end;

procedure _TBFBluetoothCOMPortCreatorX.SetServiceUUID(const Value: TGUID);
begin
  FBFBluetoothCOMPortCreator.ServiceUUID := Value;
end;

end.
