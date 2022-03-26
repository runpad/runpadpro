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
unit BFClients;

{$I BF.inc}

interface

uses
  BFBase, Classes, Windows, BFAPI, Messages, BFDiscovery;

type
  // Forward declaration.
  TBFCustomClient = class;
  TBFCustomClientClass = class of TBFCustomClient;

  // The base class for client transports.
  TBFCustomClientTransport = class(TPersistent)
  private
    FClient: TBFCustomClient;

    procedure RaiseClientActive;
    procedure RaiseClientNotActive;

  public
    // Default constructor.
    constructor Create(AClient: TBFCustomClient); virtual;
  end;

  // Bluetooth transport connection params.
  TBFBluetoothClientTransport = class(TBFCustomClientTransport)
  private
    FAddress: string;
    FAuthentication: Boolean;
    FDetectedPort: DWORD;
    FDevice: TBFBluetoothDevice;
    FEncryption: Boolean;
    FPort: DWORD;
    FRadio: TBFBluetoothRadio;
    FService: string;
    FServiceUUID: TGUID;

    function GetSignalPower: Byte;

    procedure SetAddress(const Value: string);
    procedure SetAuthentication(const Value: Boolean);
    procedure SetDevice(const Value: TBFBluetoothDevice);
    procedure SetEncryption(const Value: Boolean);
    procedure SetPort(const Value: DWORD);
    procedure SetRadio(const Value: TBFBluetoothRadio);
    procedure SetService(const Value: string);
    procedure SetServiceUUID(const Value: TGUID);

  protected
    property DetectedPort: DWORD read FDetectedPort write FDetectedPort;
    
  public
    // Default constructor.
    constructor Create(AClient: TBFCustomClient); override;
    // Default destructor.
    destructor Destroy; override;

    // TBFBluetoothDevice object. Note: You can dispose assigned object
    // because here stored copy of it.
    property Device: TBFBluetoothDevice read FDevice write SetDevice;
    // Radio on which will work.
    property Radio: TBFBluetoothRadio read FRadio write SetRadio;
    // Service UUID to which client should be connected.
    property ServiceUUID: TGUID read FServiceUUID write SetServiceUUID;
    // Returns bluetooth signal power between dongle and connected device.
    property SignalPower: Byte read GetSignalPower;

  published
    // The Bluetooth device address in '(xx:xx:xx:xx:xx:xx)' format, where
    // xx - hexadecimal digits (for example: (00:bb:ca:07:11:22)), to which
    // client should be connected to.
    property Address: string read FAddress write SetAddress;
    // Sets to True enabling authentication for this client connection.
    property Authentication: Boolean read FAuthentication write SetAuthentication default False;
    // Sets to true enables encription for this client connection.
    property Encryption: Boolean read FEncryption write SetEncryption default False;
    // Port to which client should be connected. Usually must be BT_PORT_ANY.
    property Port: DWORD read FPort write SetPort default DWORD(BT_PORT_ANY);
    // Service name to which client should be connected. If you want connect
    // to your own or unsecified service then use ServiceUUID property.
    property Service: string read FService write SetService;
  end;

  TBFPublicBluetoothClientTransport = class(TBFBluetoothClientTransport)
  public
    property DetectedPort;
  end;

  // COM port baud rates.
  TBFBaudRate = (br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
                 br19200, br38400, br56000, br57600, br115200, br128000,
                 br256000);
  // COM port byte size.
  TBFByteSize = (bs4, bs5, bs6, bs7, bs8);
  // COM port parity.
  TBFParity = (paNone, paOdd, paEven, paMark, paSpace);
  // COM port stop bits.
  TBFStopBits = (sb1, sb15, sb2);
  // COM port hardware handshake types.
  TBFHardwareHandshake = (hhNone, hhRTSCTS);
  // COM port software handshake types.
  TBFSoftwareHandshake = (shNone, shXONXOFF);
  // Phone models for OBEX over COM.
  TBFModel = (dmUnknown, dmSiemens, dmSonyEricsson, dmMotorolaC650);

  // COM Port transport connection params.
  TBFCOMPortClientTransport = class(TBFCustomClientTransport)
  private
    FBaudRate: TBFBaudRate;
    FByteSize: TBFByteSize;
    FHardwareHandshake: TBFHardwareHandshake;
    FInitCommand: string;
    FModel: TBFModel;
    FParity: TBFParity;
    FPort: Byte;
    FSoftwareHandshake: TBFSoftwareHandshake;
    FStopBits: TBFStopBits;

    procedure SetBaudRate(const Value: TBFBaudRate);
    procedure SetByteSize(const Value: TBFByteSize);
    procedure SetHardwareHandshake(const Value: TBFHardwareHandshake);
    procedure SetInitCommand(const Value: string);
    procedure SetModel(const Value: TBFModel);
    procedure SetParity(const Value: TBFParity);
    procedure SetPort(const Value: Byte);
    procedure SetSoftwareHandshake(const Value: TBFSoftwareHandshake);
    procedure SetStopBits(const Value: TBFStopBits);

  public
    // Default constructor.
    constructor Create(AClient: TBFCustomClient); override;

    // Shows settings dialog.
    procedure ShowSettings;

  published
    // COM port baud rate.
    property BaudRate: TBFBaudRate read FBaudRate write SetBaudRate default br115200;
    // COM port byte size.
    property ByteSize: TBFByteSize read FByteSize write SetByteSize default bs8;
    // COM port hardware handshake mode.
    property HardwareHandshake: TBFHardwareHandshake read FHardwareHandshake write SetHardwareHandshake default hhNone;
    // Init command for OBEX over COM port. You should provide your own init
    // commands for unsupported models in this property. In this case do not
    // modify Model property.
    property InitCommand: string read FInitCommand write SetInitCommand;
    // Model for OBEX over COM port.
    property Model: TBFModel read FModel write SetModel default dmUnknown;
    // COM port parity.
    property Parity: TBFParity read FParity write SetParity default paNone;
    // COM port number.
    property Port: Byte read FPort write SetPort default 1;
    // COM port software handshake mode.
    property SoftwareHandshake: TBFSoftwareHandshake read FSoftwareHandshake write SetSoftwareHandshake default shNone;
    // COM port stop bits.
    property StopBits: TBFStopBits read FStopBits write SetStopBits default sb1;
  end;

  // IrDA transport connection params.
  TBFIrDAClientTransport = class(TBFCustomClientTransport)
  private
    FAddress: string;
    FDevice: TBFIrDADevice;
    FService: string;

    procedure CheckAddress(Value: string);
    procedure SetAddress(const Value: string);
    procedure SetDevice(const Value: TBFIrDADevice);
    procedure SetService(const Value: string);

  public
    // Defaul constructor.
    constructor Create(AClient: TBFCustomClient); override;
    // Default destructor.
    destructor Destroy; override;

    // IrDA device object
    property Device: TBFIrDADevice read FDevice write SetDevice;

  published
    // The IrDA device address in '(xx:xx:xx:xx)' format, where
    // xx - hexadecimal digits (for example: (00:bb:ca:07)), to which
    // client should be connected to.
    property Address: string read FAddress write SetAddress;
    // Remote service name.
    property Service: string read FService write SetService;
  end;

  TBFClientReadThreadClass = class of TBFClientReadThread;
  // Client read thread.
  TBFClientReadThread = class(TBFBaseThread)
  private
    // Data guard criticalsection.
    FCriticalSection: TRTLCriticalSection;
    // Data arrived event.
    FDataEvent: THandle;
    // Last error code.
    FLastError: DWORD;
    // Overlapped read structure.
    FOverlapped: TOverlapped;

    // Reads data from COM port.
    procedure ReadCOM;
    // Reads data from socket.
    procedure ReadWinSock;

  protected
    // Readed data buffer.
    FBuffer: TBFByteArray;
    // Owner.
    FClient: TBFCustomClient;

    // Checking is events presents in buffer. This function actubal only for AT
    // commands client and its descendats. Ancessors shpould always call
    // inheroted method.
    procedure CheckEvents; virtual;
    // Thread procedure.
    procedure Execute; override;
    // Locks data.
    procedure Lock;
    // Unlock data.
    procedure Unlock;

  public
    // Default constructor.
    constructor Create(AClient: TBFCustomClient);
    // Default destructor.
    destructor Destroy; override;

    // Reads data from buffer. Returns last error code.
    function Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean): DWORD;
  end;

  // Simple client events prototype.
  TBFClientEvent = procedure (Sender: TObject) of object;

  // The base class for Bluetooth Framework clients.
  // Application should never create instances of this class.
  TBFCustomClient = class(TBFBaseComponent)
  private
    FBluetoothTransport: TBFBluetoothClientTransport;
    FCID: Word;
    FCOMPortTransport: TBFCOMPortClientTransport;
    FConnectTimeOut: DWORD;
    FEvent: WSAEVENT;
    FHandle: THandle;
    FIrDATransport: TBFIrDAClientTransport;
    FNeed9WireMode: Boolean;
    FOverlapped: TOverlapped;
    FReadBuffer: DWORD;
    FReadTimeOut: DWORD;
    FSocket: TSocket;
    FStateClose: Boolean;
    FThread: TBFClientReadThread;
    FTransport: TBFAPITransport;
    FWriteBuffer: DWORD;
    FWriteTimeOut: DWORD;

    FOnData: TBFClientEvent;
    FOnDisconnect: TBFClientEvent;

    function GetChannel: Byte;

    procedure BFNMClientEvent(var Msg: TMessage); message BFNM_CLIENT_EVENT;
    procedure BFNMTosClientConnected(var Message: TMessage); message BFNM_TOS_CLIENTCONNECTED;
    procedure CheckDeviceConnected;
    procedure CloseBluetoothIVT;
    procedure CloseBluetoothMS;
    procedure CloseBluetoothTos;
    procedure CloseBluetoothTransport;
    procedure CloseBluetoothWD;
    procedure CloseCOMTransport;
    procedure CloseIrDATransport;
    procedure CloseWinSock;
    procedure InternalRead(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean);
    procedure InternalWrite(Data: TBFByteArray);
    procedure InternalWriteCOM(Data: TBFByteArray);
    procedure InternalWriteWinSock(Data: TBFByteArray);
    procedure OpenBluetoothCOM(PortName: string);
    procedure OpenBluetoothIVT;
    procedure OpenBluetoothMS;
    procedure OpenBluetoothTos;
    procedure OpenBluetoothTransport;
    procedure OpenBluetoothWD;
    procedure OpenCOMTransport;
    procedure OpenIrDATransport;
    procedure SetActive(const Value: Boolean);
    procedure SetBluetoothTransport(const Value: TBFBluetoothClientTransport);
    procedure SetCOMPortTransport(const Value: TBFCOMPortClientTransport);
    procedure SetConnectTimeOut(const Value: DWORD);
    procedure SetIrDATransport(const Value: TBFIrDAClientTransport);
    procedure SetNeed9WireMode(const Value: Boolean);
    procedure SetReadBuffer(const Value: DWORD);
    procedure SetReadTimeOut(const Value: DWORD);
    procedure SetTransport(const Value: TBFAPITransport);
    procedure SetWriteBuffer(const Value: DWORD);
    procedure SetWriteTimeOut(const Value: DWORD);

  protected
    FActive: Boolean;

    // Returns class of the read thread.
    function GetThreadClass: TBFClientReadThreadClass; virtual;

    // Calls OnData event.
    procedure DoData; virtual;
    // Closes a client connection.
    // NEVER CALL THIS METHOD INTERNALLY OR EXTERNALLY. USE CLOSE.
    procedure InternalClose; virtual;
    // Opens a client connection.
    // NEVER CALL THIS METHOD INTERNALLY OR EXTERNALLY. USE OPEN.
    procedure InternalOpen; virtual;
    // Raises an exception if connection active.
    procedure RaiseActive;
    // Raises an exception if client not connected.
    procedure RaiseNotActive;
    // Reads data from the connection.
    procedure Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean = False); virtual;
    // Writes data to the connection.
    procedure Write(Data: TBFByteArray); virtual;

    // Only for write.
    property Need9WireMode: Boolean write SetNeed9WireMode;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Closes active connection.
    procedure Close;
    // Opens connection to the remote device.
    procedure Open;
    // Shows "Connect" dialog and open connection. Returns name of the davice.
    procedure OpenDevice;

    // Returns True if client connected to the remote device. Otherwise returns
    // False. Sets to True to connect to remote device.
    property Active: Boolean read FActive write SetActive;

  published
    // Settings for Bluetooth connection.
    property BluetoothTransport: TBFBluetoothClientTransport read FBluetoothTransport write SetBluetoothTransport;
    // Settings for COM port connection.
    property COMPortTransport: TBFCOMPortClientTransport read FCOMPortTransport write SetCOMPortTransport;
    // Timeout for connect.
    property ConnectTimeOut: DWORD read FConnectTimeOut write SetConnectTimeOut default 20000;
    // Settings for IrDA connection.
    property IrDATransport: TBFIrDAClientTransport read FIrDATransport write SetIrDATransport;
    // Internal read buffer size.
    property ReadBuffer: DWORD read FReadBuffer write SetReadBuffer default 512;
    // Read time out in milliseconds. 0 means infinite.
    property ReadTimeOut: DWORD read FReadTimeOut write SetReadTimeOut default 30000;
    // Type of transport (connection).
    property Transport: TBFAPITransport read FTransport write SetTransport default atBluetooth;
    // Internal write buffer size.
    property WriteBuffer: DWORD read FWriteBuffer write SetWriteBuffer default 512;
    // Write time out in milliseconds. 0 means infinite.
    property WriteTimeOut: DWORD read FWriteTimeOut write SetWriteTimeOut default 30000;

    // Event occurs when data available for reading.
    property OnData: TBFClientEvent read FOnData write FOnData;
    // Event occures when remote device close connection or connection closed by
    // calling Close method or by sets Active to False.
    property OnDisconnect: TBFClientEvent read FOnDisconnect write FOnDisconnect;
  end;

  _TBFCustomClientX = class(_TBFActiveXControl)
  private
    function GetActive: Boolean;
    function GetBluetoothTransport: TBFBluetoothClientTransport;
    function GetCOMPortTransport: TBFCOMPortClientTransport;
    function GetConnectTimeOut: DWORD;
    function GetIrDATransport: TBFIrDAClientTransport;
    function GetOnData: TBFClientEvent;
    function GetOnDisconnect: TBFClientEvent;
    function GetReadBuffer: DWORD;
    function GetReadTimeOut: DWORD;
    function GetTransport: TBFAPITransport;
    function GetWriteBuffer: DWORD;
    function GetWriteTimeOut: DWORD;

    procedure SetActive(const Value: Boolean);
    procedure SetBluetoothTransport(const Value: TBFBluetoothClientTransport);
    procedure SetCOMPortTransport(const Value: TBFCOMPortClientTransport);
    procedure SetConnectTimeOut(const Value: DWORD);
    procedure SetIrDATransport(const Value: TBFIrDAClientTransport);
    procedure SetOnData(const Value: TBFClientEvent);
    procedure SetOnDisconnect(const Value: TBFClientEvent);
    procedure SetReadBuffer(const Value: DWORD);
    procedure SetReadTimeOut(const Value: DWORD);
    procedure SetTransport(const Value: TBFAPITransport);
    procedure SetWriteBuffer(const Value: DWORD);
    procedure SetWriteTimeOut(const Value: DWORD);

  protected
    FBFCustomClient: TBFCustomClient;
    
    function GetComponentClass: TBFCustomClientClass; virtual; abstract;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open;
    procedure OpenDevice;

    property Active: Boolean read GetActive write SetActive;

  published
    property BluetoothTransport: TBFBluetoothClientTransport read GetBluetoothTransport write SetBluetoothTransport;
    property COMPortTransport: TBFCOMPortClientTransport read GetCOMPortTransport write SetCOMPortTransport;
    property ConnectTimeOut: DWORD read GetConnectTimeOut write SetConnectTimeOut;
    property IrDATransport: TBFIrDAClientTransport read GetIrDATransport write SetIrDATransport;
    property ReadBuffer: DWORD read GetReadBuffer write SetReadBuffer;
    property ReadTimeOut: DWORD read GetReadTimeOut write SetReadTimeOut;
    property Transport: TBFAPITransport read GetTransport write SetTransport;
    property WriteBuffer: DWORD read GetWriteBuffer write SetWriteBuffer;
    property WriteTimeOut: DWORD read GetWriteTimeOut write SetWriteTimeOut;

    property OnData: TBFClientEvent read GetOnData write SetOnData;
    property OnDisconnect: TBFClientEvent read GetOnDisconnect write SetOnDisconnect;
  end;

implementation

uses
  SysUtils, ActiveX, BFSelectDevice, Forms, BFAuthenticator, BFStrings, 
  BFCOMSettings, BFSerialPortClient, BFD5Support{$IFDEF TRIAL}, Dialogs{$ENDIF};

{$IFDEF TRIAL}
var
  TotalSended: Integer = 0;
{$ENDIF}

// Donot localize
const
  BFMODEL_OBEX_INIT_COMMANDS: array [TBFModel] of string = ('', 'AT^SQWE=3', 'AT+CPROT=0', 'AT+MODE=22');

{ TBFCustomTransport }

constructor TBFCustomClientTransport.Create(AClient: TBFCustomClient);
begin
  FClient := AClient;
end;

procedure TBFCustomClientTransport.RaiseClientActive;
begin
  // Raises an exception if client active.
  TBFCustomClient(FClient).RaiseActive;
end;

procedure TBFCustomClientTransport.RaiseClientNotActive;
begin
  // Raises an exception if client not active.
  TBFCustomClient(FClient).RaiseNotActive;
end;

{ TBFBluetoothClientTransport }

constructor TBFBluetoothClientTransport.Create(AClient: TBFCustomClient);
begin
  inherited;

  // Initialize.
  FAddress := '(00:00:00:00:00:00)';
  FAuthentication := False;
  FDetectedPort := UNKNOWN_PORT;
  FDevice := nil;
  FEncryption := False;
  FPort := DWORD(BT_PORT_ANY);
  FRadio := nil;
  FService := StrUnknown;
  FServiceUUID := GUID_NULL;
end;

destructor TBFBluetoothClientTransport.Destroy;
begin
  if Assigned(FDevice) then FDevice.Free;
  if Assigned(FRadio) then FRadio.Free;
  
  inherited;
end;

function TBFBluetoothClientTransport.GetSignalPower: Byte;

  function GetBlueSoleilSignalPower: Byte;
  var
    DeviceInfoExSize: DWORD;
    DeviceInfoEx: BLUETOOTH_DEVICE_INFO_EX;
    Res: DWORD;
  begin
    DeviceInfoExSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
    FillChar(DeviceInfoEx, DeviceInfoExSize, 0);
    with DeviceInfoEx do begin
      dwSize := DeviceInfoExSize;
      address := API.StringToBluetoothAddress(FAddress);
    end;

    Res := BT_GetRemoteDeviceInfo(MASK_SIGNAL_STRENGTH, DeviceInfoEx);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

    Result := Byte(DeviceInfoEx.cSignalStrength);
  end;

  function GetWidCommSignalPower: Byte;
  var
    Stat: tBT_CONN_STATS;
  begin
    FillChar(Stat, SizeOf(tBT_CONN_STATS), 0);

    if not WD_GetConnectionStats(API.StringToBluetoothAddress(FAddress), @Stat) then raise Exception.Create(StrSignalPowerDetectError);

    Result := LoWord(Lo(Stat.Rssi));
  end;

  function GetTosSignalPower: Byte;
  var
    Handle: Word;
    Status: Long;
    Quality: Byte;
  begin
    Quality := 0;
    if not BtGetConnectionHandle(FClient.FCID, Handle, Status) then API.RaiseTosError(Status);
    if not BtGetLinkQuality(Handle, Quality, Status) then API.RaiseTosError(Status);

    Result := Quality;
  end;

begin
  RaiseClientNotActive;

  case FRadio.BluetoothAPI of
    baBlueSoleil: Result := GetBlueSoleilSignalPower;
    baWinSock: raise Exception.Create(StrMSStackUnsupported);
    baWidComm: Result := GetWidCommSignalPower;
    baToshiba: Result := GetTosSignalPower;

  else
    raise Exception.Create(StrFeatureNotSupported);
  end;
end;

procedure TBFBluetoothClientTransport.SetAddress(const Value: string);
begin
  if Value <> FAddress then begin
    RaiseClientActive;

    if Value = '' then
      FAddress := '(00:00:00:00:00:00)'

    else begin
      API.CheckBluetoothAddress(Value);
      FAddress := Value;
    end;

    FDetectedPort := UNKNOWN_PORT;

    if Assigned(FDevice) then begin
      FDevice.Free;
      FDevice := nil;
    end;
  end;
end;

procedure TBFBluetoothClientTransport.SetAuthentication(const Value: Boolean);
begin
  if Value <> FAuthentication then begin
    RaiseClientActive;
    FAuthentication := Value;
    // If we disable Authentication so we must disable an Encryption.
    if not Value then FEncryption := False;
  end;
end;

procedure TBFBluetoothClientTransport.SetDevice(const Value: TBFBluetoothDevice);
begin
  RaiseClientActive;

  if Assigned(FDevice) then begin
    FDevice.Free;
    FDevice := nil;
  end;

  if Assigned(Value) then begin
    FDevice := TBFBluetoothDevice.Create(nil);
    FDevice.Assign(Value);
  end;

  if Assigned(FDevice) then begin
    if FAddress <> FDevice.Address then begin
      FAddress := FDevice.Address;
      FDetectedPort := UNKNOWN_PORT;
    end;
    
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

procedure TBFBluetoothClientTransport.SetEncryption(const Value: Boolean);
begin
  if Value <> FEncryption then begin
    RaiseClientActive;
    FEncryption := Value;
    // If we enabling Encryption we also must anabling an authentication.
    if Value then FAuthentication := True;
  end;
end;

procedure TBFBluetoothClientTransport.SetPort(const Value: DWORD);
begin
  if Value <> FPort then begin
    RaiseClientActive;
    if (Value > 30) and (Value <> DWORD(BT_PORT_ANY)) then raise Exception.Create(StrInvalidPortNumber);
    FPort := Value;
    
    if FPort <> DWORD(BT_PORT_ANY) then
      FDetectedPort := FPort
    else
      FDetectedPort := UNKNOWN_PORT;
  end;
end;

procedure TBFBluetoothClientTransport.SetRadio(const Value: TBFBluetoothRadio);
begin
  RaiseClientActive;

  if Assigned(FRadio) then begin
    FRadio.Free;
    FRadio := nil;
  end;

  if Assigned(Value) then begin
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothClientTransport.SetService(const Value: string);
var
  Tmp: TGUID;
begin
  if Value <> Service then begin
    RaiseClientActive;

    FService := Value;

    Tmp := API.StringToUUID(Value);
    if not CompareGUIDs(Tmp, GUID_NULL) then FServiceUUID := Tmp;

    FDetectedPort := UNKNOWN_PORT;
  end;
end;

procedure TBFBluetoothClientTransport.SetServiceUUID(const Value: TGUID);
var
  Tmp: string;
begin
  if not CompareGUIDs(Value, FServiceUUID) then begin
    RaiseClientActive;

    FServiceUUID := Value;

    Tmp := API.UUIDToString(FServiceUUID);
    if Tmp <> 'Unknown' then FService := Tmp;

    FDetectedPort := UNKNOWN_PORT;
  end;
end;

{ TBFCOMPortClientTransport }

constructor TBFCOMPortClientTransport.Create(AClient: TBFCustomClient);
begin
  inherited;

  FBaudRate := br115200;
  FByteSize := bs8;
  FHardwareHandshake := hhNone;;
  FInitCommand := '';
  FModel := dmUnknown;
  FParity := paNone;
  FPort := 1;
  FSoftwareHandshake := shNone;
  FStopBits := sb1;
end;

procedure TBFCOMPortClientTransport.SetBaudRate(const Value: TBFBaudRate);
begin
  if Value <> FBaudRate then begin
    RaiseClientActive;
    FBaudRate := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetByteSize(const Value: TBFByteSize);
begin
  if Value <> FByteSize then begin
    RaiseClientActive;
    FByteSize := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetHardwareHandshake(const Value: TBFHardwareHandshake);
begin
  if Value <> FHardwareHandshake then begin
    RaiseClientActive;
    FHardwareHandshake := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetInitCommand(const Value: string);
var
  Loop: TBFModel;
begin
  if Value <> FInitCommand then begin
    RaiseClientActive;
    FInitCommand := Trim(AnsiUppercase(Value));

    FModel := dmUnknown;

    for Loop := Low(BFMODEL_OBEX_INIT_COMMANDS) to High(BFMODEL_OBEX_INIT_COMMANDS) do
      if FInitCommand = BFMODEL_OBEX_INIT_COMMANDS[Loop] then begin
        FModel := Loop;
        Break;
      end;
  end;
end;

procedure TBFCOMPortClientTransport.SetModel(const Value: TBFModel);
begin
  if Value <> FModel then begin
    RaiseClientActive;
    FModel := Value;
    if FModel <> dmUnknown then
      FInitCommand := BFMODEL_OBEX_INIT_COMMANDS[FModel]
    else
      FInitCommand := '';
  end;
end;

procedure TBFCOMPortClientTransport.SetParity(const Value: TBFParity);
begin
  if Value <> FParity then begin
    RaiseClientActive;
    FParity := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetPort(const Value: Byte);
begin
  if Value <> FPort then begin
    RaiseClientActive;
    FPort := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetSoftwareHandshake(const Value: TBFSoftwareHandshake);
begin
  if Value <> FSoftwareHandshake then begin
    RaiseClientActive;
    FSoftwareHandshake := Value;
  end;
end;

procedure TBFCOMPortClientTransport.SetStopBits(const Value: TBFStopBits);
begin
  if Value <> FStopBits then begin
    RaiseClientActive;
    FStopBits := Value;
  end;
end;

procedure TBFCOMPortClientTransport.ShowSettings;
begin
  RaiseClientActive;
  
  with TfmCOMSettings.Create(FClient) do begin
    ShowModal;
    Free;
  end; 
end;

{ TBFIrDAClientTransport }

procedure TBFIrDAClientTransport.CheckAddress(Value: string);
var
  Loop: Integer;
begin
  if Length(Value) <> 13 then raise Exception.CreateFmt(StrInvalidAddressFormat, [StrIrDA]);

  if (Value[1] <> '(') or (Value[4] <> ':') or
     (Value[7] <> ':') or (Value[10] <> ':') or (Value[13] <> ')') then raise Exception.CreateFmt(StrInvalidAddressFormat, [StrIrDA]);

  for Loop := 1 to 13 do
    if not IsDelimiter('():0123456789ABCDEFabcdef', Value, Loop) then
       raise Exception.CreateFmt(StrInvalidAddressFormat, [StrIrDA]);
end;

constructor TBFIrDAClientTransport.Create(AClient: TBFCustomClient);
begin
  inherited;

  FAddress := '(00:00:00:00)';
  FDevice := nil;
  FService := '';
end;

destructor TBFIrDAClientTransport.Destroy;
begin
  if Assigned(FDevice) then FDevice.Free;
  
  inherited;
end;

procedure TBFIrDAClientTransport.SetAddress(const Value: string);
begin
  if Value <> FAddress then begin
    RaiseClientActive;

    if Value = '' then
      FAddress := '(00:00:00:00)'

    else begin
      CheckAddress(Value);
      FAddress := Value;
    end;
  end;
end;

procedure TBFIrDAClientTransport.SetDevice(const Value: TBFIrDADevice);
begin
  if Value <> FDevice then begin
    if Assigned(FDevice) then begin
      FDevice.Free;
      FDevice := nil;
    end;

    if Assigned(Value) then begin
      FDevice := TBFIrDADevice.Create;
      FDevice.Assign(Value);
    end;

    if Assigned(FDevice) then
      if FAddress <> FDevice.Address then
        FAddress := FDevice.Address;
  end;
end;

procedure TBFIrDAClientTransport.SetService(const Value: string);
begin
  if Value <> FService then begin
    RaiseClientActive;
    FService := Value;
  end;
end;

{ TBFCustomClient }

procedure TBFCustomClient.BFNMClientEvent(var Msg: TMessage);
begin
  case Msg.WParam of
    NM_CLIENT_DATA: DoData;
    NM_CLIENT_CLOSE: Close;
  end;

  Msg.Result := Integer(True);
end;

procedure TBFCustomClient.BFNMTosClientConnected(var Message: TMessage);
begin
  with Message do
    if (WParam = TOSBTAPI_NM_CONNECTCOMM_ERROR) or (WParam = TOSBTAPI_NM_CONNECTCOMM_END) then
      SetEvent(LParam);
end;

procedure TBFCustomClient.CheckDeviceConnected;
begin
  if FBluetoothTransport.FRadio.BluetoothAPI = baWidComm then
    if not WD_IsRemoteDeviceConnected(API.StringToBluetoothAddress(FBluetoothTransport.FAddress)) then
      raise Exception.Create(StrRemoteDeviceNotFound);
end;

procedure TBFCustomClient.Close;
begin
  // Simple call InternalClose
  if FActive then begin
    InternalClose;
    FActive := False;
    if Assigned(FOnDisconnect) then FOnDisconnect(Self);
  end;
end;

procedure TBFCustomClient.CloseBluetoothIVT;
begin
  CloseCOMTransport;

  if FSocket <> INVALID_SOCKET then begin
    BT_DisconnectSPPExService(FSocket);
    FSocket := INVALID_SOCKET;
  end;
end;

procedure TBFCustomClient.CloseBluetoothMS;
begin
  CloseWinSock;
end;

procedure TBFCustomClient.CloseBluetoothTos;
var
  PortName: string;
  Status: Long;
begin
  CloseCOMTransport;

  if FCID <> 0 then begin
    BtDisconnectCOMM(PChar('COM' + IntToStr(FSocket)), Status);
    FCID := 0;
  end;

  // Remove connection.
  if FSocket <> INVALID_SOCKET then begin
    PortName := 'COM' + IntToStr(FSocket);
    BtDestroyCOMM(PChar(PortName), Status);
    FSocket := INVALID_SOCKET;
  end;
end;

procedure TBFCustomClient.CloseBluetoothTransport;
begin
  // Check API and call needed procedure.
  case FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: CloseBluetoothIVT;
    baWinSock: CloseBluetoothMS;
    baWidComm: CloseBluetoothWD;
    baToshiba: CloseBluetoothTos;
  end;
end;

procedure TBFCustomClient.CloseBluetoothWD;
begin
  CloseCOMTransport;

  // Remove connection.
  if FSocket <> INVALID_SOCKET then begin
    WD_RemoveCOMPortAssociation(LoWord(FSocket));
    FSocket := INVALID_SOCKET;
  end;
end;

procedure TBFCustomClient.CloseCOMTransport;
begin
  with FOverlapped do
    if hEvent <> 0 then
      CloseHandle(hEvent);

  FillChar(FOverlapped, SizeOf(TOverlapped), 0);

  // Just close the hanldle
  if FHandle <> INVALID_HANDLE_VALUE then begin
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  end;
end;

procedure TBFCustomClient.CloseIrDATransport;
begin
  // Simple close winsock transport.
  CloseWinSock;
end;

procedure TBFCustomClient.CloseWinSock;
begin
  // Clear events.
  if FEvent <> WSA_INVALID_EVENT then begin
    if FSocket <> INVALID_SOCKET then WSAEventSelect(FSocket, FEvent, 0);
    WSACloseEvent(FEvent);
    FEvent := WSA_INVALID_EVENT;
  end;

  // Close socket
  if FSocket <> INVALID_SOCKET then begin
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
  end;
end;

constructor TBFCustomClient.Create(AOwner: TComponent);
begin
  inherited;

  // Initialization.
  FActive := False;
  FBluetoothTransport := TBFBluetoothClientTransport.Create(Self);
  FCID := 0;
  FCOMPortTransport := TBFCOMPortClientTransport.Create(Self);
  FConnectTimeOut := 20000;
  FEvent := WSA_INVALID_EVENT;
  FHandle := INVALID_HANDLE_VALUE;
  FIrDATransport := TBFIrDAClientTransport.Create(Self);
  FNeed9WireMode := True;
  FillChar(FOverlapped, SizeOf(TOverlapped), 0);
  FReadBuffer := 512;
  FReadTimeOut := 30000;
  FSocket := INVALID_SOCKET;
  FStateClose := False;
  FThread := nil;
  FTransport := atBluetooth;
  FWriteBuffer := 512; 
  FWriteTimeOut := 30000;

  FOnData := nil;
  FOnDisconnect := nil;
end;

destructor TBFCustomClient.Destroy;
begin
  FOnDisconnect := nil;
  // Firstly close the connection.
  Close;

  // Then cleanup.
  FBluetoothTransport.Free;
  FCOMPortTransport.Free;
  FIrDATransport.Free;

  inherited;
end;

procedure TBFCustomClient.DoData;
var
 OK: Boolean;
begin
  if Assigned(FThread) then
    with FThread do begin
      Lock;
      OK := Length(FBuffer) > 0;
      Unlock;
    end

  else
    OK := False;

  if OK then
    if Assigned(FOnData) then
      FOnData(Self);
end;

function TBFCustomClient.GetChannel: Byte;
var
  Services: TBFBluetoothServices;
  Found: Boolean;
  Loop: Integer;
begin
  if FBluetoothTransport.FDetectedPort = UNKNOWN_PORT then
    if FBluetoothTransport.FPort <> DWORD(BT_PORT_ANY) then
      Result := FBluetoothTransport.FPort

    else begin
      Result := 255;

      Services := EnumServices(FBluetoothTransport.FAddress, False, FBluetoothTransport.FRadio);

      if Assigned(Services) then begin
        for Loop := 0 to Services.Count - 1 do begin
          Found := CompareGUIDs(Services[Loop].UUID, FBluetoothTransport.FServiceUUID);

          if Found then
            if (Self is TBFSerialPortClient) then
              Found := ((TBFSerialPortClient(Self).AutoDetect and (FBluetoothTransport.Service = Services[Loop].Name)) or (not TBFSerialPortClient(Self).AutoDetect));

          if Found then begin
            Result := Services[Loop].Channel;
            FBluetoothTransport.FDetectedPort := Result;
            Break;
          end;
        end;

        Services.Free;
      end;
    end

  else
    Result := FBluetoothTransport.FDetectedPort;
end;

function TBFCustomClient.GetThreadClass: TBFClientReadThreadClass;
begin
  Result := TBFClientReadThread;
end;

procedure TBFCustomClient.InternalClose;
begin
  // Stops reading thread.
  if Assigned(FThread) then begin
    with FThread do begin
      Terminate;

      with FOverlapped do
        if hEvent <> 0 then
          SetEvent(hEvent);

      if FEvent <> 0 then SetEvent(FEvent);

      if Suspended then Resume;
      
      WaitFor;
      Free;
    end;

    FThread := nil;
  end;

  // Just call specific routine.
  case FTransport of
    atBluetooth: CloseBluetoothTransport;
    atCOM: CloseCOMTransport;
    atIrDA: CloseIrDATransport;
  end;
end;

procedure TBFCustomClient.InternalOpen;
begin
  // Check which transport we must open.
  case FTransport of
    atBluetooth: OpenBluetoothTransport;
    atCOM: OpenCOMTransport;
    atIrDA: OpenIrDATransport;
  end;

  // Create read thread.
  FThread := GetThreadClass.Create(Self);

  // If all OK then active connection.
  FActive := True;
end;

procedure TBFCustomClient.InternalRead(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean);
var
  Res: DWORD;
begin
  if FStateClose then begin
    Size := 0;
    SetLength(Data, 0);

  end else begin
    {$IFDEF TRIAL}
    // 20mb
    if TotalSended > 20971520 then begin
      ShowMessage('Demo version can not read/send more then 20Mb of data.' + CRLF +
                  'To obtain a full version visit http://www.btframework.com/order.htm');

      Size := 0;
      SetLength(Data, 0);

      Exit;
    end;
    {$ENDIF}

    // Preparing.
    SetLength(Data, Size);

    Res := FThread.Read(Data, Size, WaitForData);
    if Res <> NOERROR then begin
      Size := 0;
      SetLength(Data, Size);

      FStateClose := True;
      Close;

      SetLastError(WSAECONNABORTED);
      RaiseLastOSError;
    end;

    {$IFDEF TRIAL}
    if Res = NOERROR then Inc(TotalSended, Length(Data));
    {$ENDIF}
  end;
end;

procedure TBFCustomClient.InternalWrite(Data: TBFByteArray);
begin
  {$IFDEF TRIAL}
  // 20mb
  if TotalSended > 20971520 then begin
    ShowMessage('Demo version can not read/send more then 20Mb of data.' + CRLF +
                'To obtain a full version visit http://www.btframework.com/order.htm');
    Exit;
  end;
  {$ENDIF}

  // Check transport and call routine.
  case FTransport of
    atBluetooth: case FBluetoothTransport.FRadio.BluetoothAPI of
                   baBlueSoleil: InternalWriteCOM(Data);
                   baWinSock: InternalWriteWinSock(Data);
                   baWidComm: InternalWriteCOM(Data);
                   baToshiba: InternalWriteCOM(Data);
                 end;
    atIrDA: InternalWriteWinSock(Data);
    atCOM: InternalWriteCOM(Data);
  end;

  {$IFDEF TRIAL}
  Inc(TotalSended, Length(Data));
  {$ENDIF}
end;

procedure TBFCustomClient.InternalWriteCOM(Data: TBFByteArray);
var
  Sended: DWORD;
  Error: DWORD;
  OffSet: Integer;
begin
  OffSet := 0;

  while OffSet < Length(Data) do begin
    if (not (Self is TBFSerialPortClient)) and (FTransport = atBluetooth) and (FBluetoothTransport.FRadio.BluetoothAPI = baToshiba) and IsWinXP then begin
      EscapeCommFunction(FHandle, CLRRTS);
      EscapeCommFunction(FHandle, SETDTR);
    end;

    if not WriteFile(FHandle, Pointer(Integer(Pointer(Data)) + OffSet)^, Length(Data) - OffSet, Sended, @FOverlapped) then begin
      Error := GetLastError;

      if Error <> ERROR_IO_PENDING then begin
        SetLastError(Error);

        RaiseLastOSError;

      end else begin
        GetOverlappedResult(FHandle, FOverlapped, Sended, True);
        OffSet := OffSet + Integer(Sended);
        //WaitForSingleObject(FOverlapped.hEvent, INFINITE);
      end;

    end else
      Break;

    if (not (Self is TBFSerialPortClient)) and (FTransport = atBluetooth) and (FBluetoothTransport.FRadio.BluetoothAPI = baToshiba) and IsWinXP then begin
      EscapeCommFunction(FHandle, CLRDTR);
      EscapeCommFunction(FHandle, SETRTS);
    end;
  end;
end;

procedure TBFCustomClient.InternalWriteWinSock(Data: TBFByteArray);
var
  Sended: Integer;
  TmpBuf: TBFByteArray;
  Err: DWORD;
begin
  if FStateClose then Exit;

  // Preparing
  SetLength(TmpBuf, 0);
  Sended := 0;
  TmpBuf := Data;

  // Sending...
  while Sended < Length(TmpBuf) do begin
    Sended := send(FSocket, Pointer(TmpBuf)^, Length(TmpBuf), 0);

    if Sended = SOCKET_ERROR then begin
      FStateClose := True;
      Err := GetLastError;
      Close;
      SetLastError(Err);
      RaiseLastOSError;
    end;

    if Sended < Length(TmpBuf) then TmpBuf := Copy(TmpBuf, Sended, Length(TmpBuf) - Sended);
  end;
end;

procedure TBFCustomClient.Open;
begin
  // Just check if client not active and call internal open procedure.
  RaiseActive;
  FStateClose := False;

  InternalOpen;

  // If all OK then active connection.
  FActive := True;
end;

procedure TBFCustomClient.OpenBluetoothCOM(PortName: string);
var
  TimeOuts: TCommTimeouts;
begin
  FHandle := CreateFile(PChar(PortName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if FHandle = INVALID_HANDLE_VALUE then RaiseLastOSError;

  try
    if FBluetoothTransport.FRadio.BluetoothAPI = baWidComm then CheckDeviceConnected;

    // Setting up buffers and timeouts
    if not SetupComm(FHandle, FReadBuffer, FWriteBuffer) then RaiseLastOSError;

    with TimeOuts do begin
      ReadIntervalTimeout := MAXDWORD;
      ReadTotalTimeoutMultiplier := MAXDWORD;
      ReadTotalTimeoutConstant := FReadTimeOut;
      WriteTotalTimeoutMultiplier := 0;
      WriteTotalTimeoutConstant := FWriteTimeOut;
    end;
    if not SetCommTimeouts(FHandle, TimeOuts) then RaiseLastOSError;

    // Try prepare com port.
    if not PurgeComm(FHandle, PURGE_TXCLEAR or PURGE_RXCLEAR) then RaiseLastOSError;

    // Preparing for overlapped I/O.
    if not SetCommMask(FHandle, EV_RXCHAR) then RaiseLastOSError;

    with FOverlapped do begin
      hEvent := CreateEvent(nil, True, False, nil);
      if hEvent = 0 then RaiseLastOSError;
    end;

  except
    // If something wrong then close port
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    // and re-raise an exception.
    raise;
  end;
end;

type
  TBSConnectThread = class(TThread)
  private
    FDevInfo: PIVTBLUETOOTH_DEVICE_INFO;
    FServ: PSPPEX_SERVICE_INFO;
    FSocket: PDWORD;

    FError: DWORD;

  public
    procedure Execute; override;

  public
    constructor Create(DevInfo: PIVTBLUETOOTH_DEVICE_INFO; Serv: PSPPEX_SERVICE_INFO; Socket: PDWORD);
  end;

  procedure TBSConnectThread.Execute;
  begin
    FError := BT_ConnectSPPExService(FDevInfo, FServ, FSocket);
  end;

  constructor TBSConnectThread.Create(DevInfo: PIVTBLUETOOTH_DEVICE_INFO; Serv: PSPPEX_SERVICE_INFO; Socket: PDWORD);
  begin
    FDevInfo := DevInfo;
    FServ := Serv;
    FSocket := Socket;

    FError := 0;

    FreeOnTerminate := False;

    inherited Create(False);
  end;

procedure TBFCustomClient.OpenBluetoothIVT;
var
  DevInfo: IVTBLUETOOTH_DEVICE_INFO;
  DevInfoSize: DWORD;
  Serv: SPPEX_SERVICE_INFO;
  ServSize: DWORD;
  Res: DWORD;
  Services: TBFBluetoothServices;
  Found: Boolean;
  Loop: Integer;
  ThreadHandle: THandle;
begin
  // Preparing address and service records
  DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
  FillChar(DevInfo, DevInfoSize, 0);
  with DevInfo do begin
    dwSize := DevInfoSize;
    address := API.StringToBluetoothAddress(FBluetoothTransport.FAddress);
  end;

  ServSize := SizeOf(SPPEX_SERVICE_INFO);
  FillChar(Serv, ServSize, 0);
  Serv.dwSize := ServSize;

  if FBluetoothTransport.FPort = DWORD(BT_PORT_ANY) then
    with Serv do begin
      serviceClassUuid128 := FBluetoothTransport.FServiceUUID;
      ucServiceChannel := GetChannel;
    end

  else begin
    Services := EnumServices(FBluetoothTransport.FAddress, False, FBluetoothTransport.FRadio);

    if not Assigned(Services) then raise Exception.Create(StrServiceNotFound);

    try
      if Services.Count = 0 then raise Exception.Create(StrServiceNotFound);

      Found := False;

      for Loop := 0 to Services.Count - 1 do
        if Services[Loop].Channel = FBluetoothTransport.Port then begin
          Found := True;

          with Serv, Services[Loop] do begin
            serviceClassUuid128 := UUID;
            ucServiceChannel := Channel;
          end;

          Break;
        end;

      if not Found then raise Exception.Create(StrServiceNotFound);

    finally
      Services.Free;
    end;
  end;

  // Connection to specified service
  //Res := BT_ConnectSPPExService(@DevInfo, @Serv, @FSocket);
  with TBSConnectThread.Create(@DevInfo, @Serv, @FSocket) do begin
    ThreadHandle := Handle;
    Res := WAIT_OBJECT_0 + 1;
    while Res = WAIT_OBJECT_0 + 1 do begin
      Res := MsgWaitForMultipleObjects(1, ThreadHandle, False, INFINITE, QS_PAINT or QS_POSTMESSAGE or QS_SENDMESSAGE or QS_TIMER);

      Application.ProcessMessages;
    end;

    Res := FError;

    Free;
  end;
  if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

  // If connection complete successfully try to open specified com port.
  try
    OpenBluetoothCOM('\\?\COM' + IntToStr(Serv.ucComIndex));

    Sleep(500);

  except
    // If something wrong close connection
    CloseBluetoothTransport;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomClient.OpenBluetoothMS;
var
  Auth: DWORD;
  Addr: SOCKADDR_BTH;
  AddrSize: Integer;
  Res: DWORD;
  Events: WSANETWORKEVENTS;
  APort: DWORD;
  Ticks: DWORD;
begin
  // Create socket.
  FSocket := socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
  if FSocket = INVALID_SOCKET then RaiseLastOSError;

  try
    // Setting socket options.
    if FBluetoothTransport.FAuthentication then begin
      Auth := DWORD(True);
      if setsockopt(FSocket, SOL_RFCOMM, Integer(SO_BTH_AUTHENTICATE), PChar(@Auth), SizeOf(DWORD)) <> 0 then RaiseLastOSError;
    end;
    if FBluetoothTransport.FEncryption then begin
      Auth := DWORD(True);
      if setsockopt(FSocket, SOL_RFCOMM, Integer(SO_BTH_ENCRYPT), PChar(@Auth), SizeOf(DWORD)) <> 0 then RaiseLastOSError;
    end;

    APort := GetChannel;

    // Preparing socket.
    AddrSize := SizeOf(SOCKADDR_BTH);
    FillChar(Addr, AddrSize, 0);
    with Addr do begin
      addressFamily := AF_BTH;
      btAddr := 0;
      serviceClassId := GUID_NULL;
      port := APort;
    end;

    // Resolve address.
    if WSAStringToAddress(PChar(FBluetoothTransport.FAddress), AF_BTH, nil, @Addr, AddrSize) <> 0 then RaiseLastOSError;

    // Setting up service and port.
    with Addr do begin
      serviceClassId := FBluetoothTransport.FServiceUUID;
      port := APort;
    end;

    // Create event.
    FEvent := WSACreateEvent;
    if FEvent = WSA_INVALID_EVENT then RaiseLastOSError;

    try
      // Select event
      if WSAEventSelect(FSocket, FEvent, FD_CONNECT or FD_READ or FD_CLOSE) <> 0 then RaiseLastOSError;

      try
        // Try to connect
        connect(FSocket, @Addr, AddrSize);
        // Waiting for connection complete

        // Try wait for 60 secs. If not connection then drop.
        Ticks := GetTickCount();
        Res := WAIT_OBJECT_0 + 1;
        while Res = WAIT_OBJECT_0 + 1 do begin
          Res := MsgWaitForMultipleObjects(1, FEvent, False, FConnectTimeOut, QS_PAINT or QS_POSTMESSAGE or QS_SENDMESSAGE or QS_TIMER);

          Application.ProcessMessages;

          if GetTickCount() - Ticks >= FConnectTimeOut then begin
            SetLastError(WSAETIMEDOUT);
            Res := WAIT_OBJECT_0 + 5;
          end;
        end;
        if Res <> WAIT_OBJECT_0 then RaiseLastOSError;

        // Check connection result.
        FillChar(Events, SizeOf(WSANETWORKEVENTS), 0);
        if WSAEnumNetworkEvents(FSocket, FEvent, @Events) <> 0 then RaiseLastOSError;

        // If error then raise an exception.
        if Events.iErrorCode[FD_CONNECT_BIT] <> 0 then begin
          SetLastError(Events.iErrorCode[FD_CONNECT_BIT]);
          RaiseLastOSError;
        end;

        // Setting up time outs.
        setsockopt(FSocket, SOL_SOCKET, SO_RCVTIMEO, PChar(@FReadTimeOut), SizeOf(Integer));
        setsockopt(FSocket, SOL_SOCKET, SO_SNDTIMEO, PChar(@FWriteTimeOut), SizeOf(Integer));

        // Try set buffers. Do not check results, becouse it is no matter.
        setsockopt(FSocket, SOL_SOCKET, SO_RCVBUF, PChar(@FReadBuffer), SizeOf(Integer));
        setsockopt(FSocket, SOL_SOCKET, SO_SNDBUF, PChar(@FWriteBuffer), SizeOf(Integer));

      except
        // If someting wrong we must clean up events
        WSAEventSelect(FSocket, FEvent, 0);
        // and re-raise an exception.
        raise;
      end;

    except
      // If someting wrong we must close events
      WSACloseEvent(FEvent);
      FEvent := WSA_INVALID_EVENT;
      // and re-raise an exception.
      raise;
    end;

  except
    // If someting wrong we must close socket
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomClient.OpenBluetoothTos;
var
  PortNum: Word;
  PortName: string;
  Status: Long;
  APort: Byte;
  Adr: TBluetoothAddress;
  Event: THandle;
  Opt: DWORD;
  Res: DWORD;
  COMMInfoList: PBTCOMMINFOLIST;
  Loop: Integer;
  Found: Boolean;
begin
  COMMInfoList := BtMemAlloc(SizeOf(BTCOMMINFOLIST), $00000001);
  if not Assigned(COMMInfoList) then raise Exception.Create(StrMemoryAllocationFailed);

  FillChar(COMMInfoList^, SizeOf(BTCOMMINFOLIST), 0);
  COMMInfoList^.BtCOMMInfo[0].dwSize := SizeOf(BTCOMMINFO);

  try
    if not BtGetCOMMInfoList2(COMMInfoList, Status) then API.RaiseTosError(Status);

    PortNum := 2;
    Found := False;

    while True do begin
      while PortNum <= 255 do begin
        PortName := 'COM' + IntToStr(PortNum);

        for Loop := 0 to COMMInfoList^.dwCOMMNum - 1 do begin
          Found := AnsiUpperCase(Trim(string(COMMInfoList^.BtCOMMInfo[Loop].szPortName))) = PortName;

          if Found then Break;
        end;

        if not Found then Break;

        Inc(PortNum);
      end;

      if Found then API.RaiseTosError(Status);

      if BtCreateCOMM(PChar(PortName), 0, 0, Status) then begin
        FSocket := PortNum;
        Break;

      end else
        if PortNum > 255 then
          API.RaiseTosError(Status);
    end;

  finally
    BtMemFree(COMMInfoList);
  end;

  try
    APort := GetChannel;
    with API do Adr := ReverseToshibaBTAddress(StringToBluetoothAddress(FBluetoothTransport.FAddress));
    Opt := 0;
    if FBluetoothTransport.FAuthentication then Opt := 1;
    if FBluetoothTransport.FEncryption then Opt := 3;

    Event := CreateEvent(nil, True, False, nil);

    try
      if BtConnectCOMM2(PChar(PortName), Adr, APort, 3, FCID, Opt, Status, Wnd, BFNM_TOS_CLIENTCONNECTED, Event) then begin
        Res := WAIT_OBJECT_0 + 1;

        while Res = WAIT_OBJECT_0 + 1 do begin
          Res := MsgWaitForMultipleObjects(1, Event, False, INFINITE, QS_POSTMESSAGE or QS_SENDMESSAGE);

          Application.ProcessMessages;
        end;

        try
          if Status >= TOSBTAPI_NO_ERROR then begin
            OpenBluetoothCOM('\\?\' + PortName);

            Sleep(500);

          end else
            API.RaiseTosError(Status);

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
    FSocket := INVALID_SOCKET;

    raise;
  end;
end;

procedure TBFCustomClient.OpenBluetoothTransport;
var
  Radio: TBFBluetoothRadio;
begin
  // Check is Bluetooth available.
  API.CheckTransport(atBluetooth);

  // If there is no Radio specified - try use the first founded.
  if not Assigned(FBluetoothTransport.FRadio) then begin
    Radio := GetFirstRadio;
    FBluetoothTransport.Radio := Radio;
    Radio.Free;
  end;

  // If still nothing - raise an exception.
  if not Assigned(FBluetoothTransport.FRadio) then raise Exception.Create(StrRadioRequired);

  // Now detect low-level API
  case FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: OpenBluetoothIVT;
    baWinSock: OpenBluetoothMS;
    baWidComm: OpenBluetoothWD;
    baToshiba: OpenBluetoothTos;
  end;
end;

procedure TBFCustomClient.OpenBluetoothWD;
var
  Level: Byte;
  Port: Word;
  Loop: Integer;
  AServiceName: string;
  Services: SERVICE_LIST;
  Tmp: string;
begin
  // Retrive service name :(
  AServiceName := '';
  WD_Discovery(API.StringToBluetoothAddress(FBluetoothTransport.FAddress), @Services, False);

  Tmp := API.UUIDToString(FBluetoothTransport.ServiceUUID);
  for Loop := 0 to Services.dwCount - 1 do
    if CompareGUIDs(Services.Services[Loop].Uuid, FBluetoothTransport.ServiceUUID) then begin
      AServiceName := Services.Services[Loop].Name;
      Break;
    end;

  if AServiceName = '' then raise Exception.Create(StrServiceNotFound);

  Level := 0;
  if FBluetoothTransport.FAuthentication then Level := Level or BTM_SEC_OUT_AUTHENTICATE;
  if FBluetoothTransport.FEncryption then Level := Level or BTM_SEC_OUT_ENCRYPT;

  // Try to bond is needed
  if FBluetoothTransport.FAuthentication and Assigned(gAuthenticator) then gAuthenticator.BondWD(API.StringToBluetoothAddress(FBluetoothTransport.FAddress));

  if not WD_CreateCOMPortAssociation(API.StringToBluetoothAddress(FBluetoothTransport.FAddress), FBluetoothTransport.FServiceUUID, PChar(AServiceName), Level, API.UUIDToUUID16(FBluetoothTransport.FServiceUUID), Port) then raise Exception.Create(StrUnableCreateCOMPort);

  FSocket := Port;

  // If association sets successfully try to open specified com port.
  try
    OpenBluetoothCOM('\\?\COM' + IntToStr(Port));

    Sleep(500);

  except
    // If something wrong close connection
    CloseBluetoothTransport;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomClient.OpenCOMTransport;
var
  DCB: TDCB;
  TimeOuts: TCommTimeouts;
begin
  // Try open port.
  FHandle := CreateFile(PChar('\\.\COM' + IntToStr(FCOMPortTransport.Port)), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if FHandle = INVALID_HANDLE_VALUE then RaiseLastOSError;

  try
    // Try to set comm state.
    FillChar(DCB, SizeOf(TDCB), 0);
    DCB.DCBlength := SizeOf(TDCB);
    if not GetCommState(FHandle, DCB) then RaiseLastOSError;

    DCB.Flags := DCB_BINARY;

    case FCOMPortTransport.FBaudRate of
      br110: DCB.BaudRate := CBR_110;
      br300: DCB.BaudRate := CBR_300;
      br600: DCB.BaudRate := CBR_600;
      br1200: DCB.BaudRate := CBR_1200;
      br2400: DCB.BaudRate := CBR_2400;
      br4800: DCB.BaudRate := CBR_4800;
      br9600: DCB.BaudRate := CBR_9600;
      br14400: DCB.BaudRate := CBR_14400;
      br19200: DCB.BaudRate := CBR_19200;
      br38400: DCB.BaudRate := CBR_38400;
      br56000: DCB.BaudRate := CBR_56000;
      br57600: DCB.BaudRate := CBR_57600;
      br115200: DCB.BaudRate := CBR_115200;
      br128000: DCB.BaudRate := CBR_128000;
      br256000: DCB.BaudRate := CBR_256000;
    end;

    DCB.ByteSize := Byte(FCOMPortTransport.FByteSize) + 4;

    DCB.StopBits := Byte(FCOMPortTransport.FStopBits);

    DCB.Parity := Byte(FCOMPortTransport.FParity);
    if FCOMPortTransport.FParity <> paNone then DCB.Flags := DCB.Flags or DCB_PARITYCHECK;

    if FCOMPortTransport.FHardwareHandshake = hhRTSCTS then DCB.Flags := DCB.Flags or DCB_OUTXCTSFLOW or DCB_RTSCONTROLHANDSHAKE;
    if FCOMPortTransport.FSoftwareHandshake = shXONXOFF then DCB.Flags := DCB.Flags or DCB_OUTX or DCB_INX;
    
    if FReadBuffer div 4 > 4096 then
      DCB.XonLim := 4096
    else
      DCB.XonLim := FReadBuffer div 4;
    DCB.XoffLim := DCB.XonLim;

    DCB.XonChar := #17;
    DCB.XoffChar := #19;

    if not SetCommState(FHandle, DCB) then RaiseLastOSError;
    
    // Set input and output buffers size.
    if not SetupComm(FHandle, FReadBuffer, FWriteBuffer) then RaiseLastOSError;

    // Sets time outs.
    with TimeOuts do begin
      ReadIntervalTimeout := MAXDWORD;
      ReadTotalTimeoutMultiplier := MAXDWORD;
      ReadTotalTimeoutConstant := FReadTimeOut;
      WriteTotalTimeoutMultiplier := 0;
      WriteTotalTimeoutConstant := FWriteTimeOut;
    end;
    if not SetCommTimeouts(FHandle, TimeOuts) then RaiseLastOSError;

    // Preparing COM port.
    if not PurgeComm(FHandle, PURGE_RXCLEAR or PURGE_TXCLEAR) then RaiseLastOSError;
    if not PurgeComm(FHandle, PURGE_RXABORT or PURGE_TXABORT) then RaiseLastOSError;

    // Preparing for overlapped I/O.
    if not SetCommMask(FHandle, EV_RXCHAR) then RaiseLastOSError;

    with FOverlapped do begin
      hEvent := CreateEvent(nil, True, False, nil);
      if hEvent = 0 then RaiseLastOSError;
    end;
    
  except
    // Something wrong. Close file
    CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomClient.OpenDevice;
begin
  // Check client connection status.
  RaiseActive;

  // Shows dialog.
  with TfmSelectDevice.CreateCliented(Owner, Self) do begin
    ShowModal;
    Free;
  end;
end;

procedure TBFCustomClient.OpenIrDATransport;
var
  Enable9WireMode: Integer;
  Addr: SOCKADDR_IRDA;
  AddrSize: Integer;
  Res: DWORD;
  Events: WSANETWORKEVENTS;
begin
  // First;y check is IrDA available.
  API.CheckTransport(atIrDA);

  // Creates socket.
  FSocket := socket(AF_IRDA, SOCK_STREAM, 0);
  if FSocket = INVALID_SOCKET then RaiseLastOSError;

  try
    // Checks for 9Wire mode
    if FNeed9WireMode then begin
      Enable9WireMode := Integer(True);
      if setsockopt(FSocket, SOL_IRLMP, IRLMP_9WIRE_MODE, PChar(@Enable9WireMode), SizeOf(Integer)) = SOCKET_ERROR then RaiseLastOSError;
    end;

    // Sets address.
    AddrSize := SizeOf(SOCKADDR_IRDA);
    FillChar(Addr, AddrSize, 0);
    with Addr do begin
      irdaAddressFamily := AF_IRDA;
      StrLCopy(irdaServiceName, PChar(FIrDATransport.FService), Length(FIrDATransport.FService));
      irdaDeviceID := API.StringToIrDAAddress(FIrDATransport.FAddress);
    end;

    // Creates event
    FEvent := WSACreateEvent;
    if FEvent = WSA_INVALID_EVENT then RaiseLastOSError;

    try
      // Selects specified events.
      if WSAEventSelect(FSocket, FEvent, FD_CONNECT or FD_READ or FD_CLOSE) <> 0 then RaiseLastOSError;

      try
        // Try to connect
        connect(FSocket, @Addr, AddrSize);

        // Try wait for 40 secs. If not connection then drop.
        Res := WAIT_OBJECT_0 + 1;
        while Res = WAIT_OBJECT_0 + 1 do begin
          Res := MsgWaitForMultipleObjects(1, FEvent, False, 40000, QS_SENDMESSAGE);
          Application.ProcessMessages;
        end;
        if Res <> WAIT_OBJECT_0 then RaiseLastOSError;

        // Enum events
        FillChar(Events, SizeOf(WSANETWORKEVENTS), 0);
        if WSAEnumNetworkEvents(FSocket, FEvent, @Events) <> 0 then RaiseLastOSError;

        // and check what happens. If error then raise an exception.
        if Events.iErrorCode[FD_CONNECT_BIT] <> 0 then begin
          SetLastError(Events.iErrorCode[FD_CONNECT_BIT]);
          RaiseLastOSError;
        end;

        // Here is all OK. Try set timeouts. Do not check results, becouse it is
        // no matter.
        setsockopt(FSocket, SOL_SOCKET, SO_RCVTIMEO, PChar(@FReadTimeOut), SizeOf(Integer));
        setsockopt(FSocket, SOL_SOCKET, SO_SNDTIMEO, PChar(@FWriteTimeOut), SizeOf(Integer));

        // Try set buffers. Do not check results, becouse it is no matter.
        setsockopt(FSocket, SOL_SOCKET, SO_RCVBUF, PChar(@FReadBuffer), SizeOf(Integer));
        setsockopt(FSocket, SOL_SOCKET, SO_SNDBUF, PChar(@FWriteBuffer), SizeOf(Integer));
      except
        // If something wrong then free events
        WSAEventSelect(FSocket, FEvent, 0);
        // and re-raise an exception.
        raise;
      end;

    except
      // If something wrong then close event
      WSACloseEvent(FEvent);
      FEvent := WSA_INVALID_EVENT;
      // and re-raise an exception.
      raise;
    end;

  except
    // If something wring then close socket
    closesocket(FSocket);
    FSocket := INVALID_SOCKET;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomClient.RaiseActive;
begin
  if FActive then raise Exception.Create(StrClientConnected);
end;

procedure TBFCustomClient.RaiseNotActive;
begin
  if not FActive then raise Exception.Create(StrClientNotConnected);
end;

procedure TBFCustomClient.Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean = False);
begin
  // Check is client not active..
  RaiseNotActive;
  // and call InternalRead
  InternalRead(Data, Size, WaitForData);
end;

procedure TBFCustomClient.SetActive(const Value: Boolean);
begin
  if Value then
    Open
  else
    Close;
end;

procedure TBFCustomClient.SetBluetoothTransport(const Value: TBFBluetoothClientTransport);
begin
  // To do nothing
end;

procedure TBFCustomClient.SetCOMPortTransport(const Value: TBFCOMPortClientTransport);
begin
  // To do nothing
end;

procedure TBFCustomClient.SetConnectTimeOut(const Value: DWORD);
begin
  if Value <> FConnectTimeOut then begin
    RaiseActive;
    FConnectTimeOut := Value;
  end;
end;

procedure TBFCustomClient.SetIrDATransport(const Value: TBFIrDAClientTransport);
begin
  // To do nothing
end;

procedure TBFCustomClient.SetNeed9WireMode(const Value: Boolean);
begin
  if Value <> FNeed9WireMode then begin
    RaiseActive;
    FNeed9WireMode := Value;
  end;
end;

procedure TBFCustomClient.SetReadBuffer(const Value: DWORD);
begin
  if Value <> FReadBuffer then begin
    if Value = 0 then raise Exception.Create(StrBufferSizeInvalid);
    FReadBuffer := Value;
  end;
end;

procedure TBFCustomClient.SetReadTimeOut(const Value: DWORD);
begin
  if Value <> FReadTimeOut then begin
    RaiseActive;
    FReadTimeOut := Value;
  end;
end;

procedure TBFCustomClient.SetTransport(const Value: TBFAPITransport);
begin
  if Value <> FTransport then begin
    RaiseActive;
    FTransport := Value;
  end;
end;

procedure TBFCustomClient.SetWriteBuffer(const Value: DWORD);
begin
  if Value <> FWriteBuffer then begin
    if Value = 0 then raise Exception.Create(StrBufferSizeInvalid);
    FWriteBuffer := Value;
  end;
end;

procedure TBFCustomClient.SetWriteTimeOut(const Value: DWORD);
begin
  if Value <> FWriteTimeOut then begin
    RaiseActive;
    FWriteTimeOut := Value;
  end;
end;

procedure TBFCustomClient.Write(Data: TBFByteArray);
begin
  // Checks is client connected
  RaiseNotActive;
  // and call InternalWrite
  InternalWrite(Data);
end;

{ TBFClientReadThread }

constructor TBFClientReadThread.Create(AClient: TBFCustomClient);
begin
  // Initialize.
  FreeOnTerminate := False;

  SetLength(FBuffer, 0);
  FClient := AClient;
  InitializeCriticalSection(FCriticalSection);
  FDataEvent := CreateEvent(nil, True, False, nil);
  FLastError := NOERROR;
  FOverlapped.hEvent := CreateEvent(nil, True, False, nil);

  // Starts thread.
  inherited Create(False); 
end;

destructor TBFClientReadThread.Destroy;
begin
  // Cleanup.
  SetLength(FBuffer, 0);
  DeleteCriticalSection(FCriticalSection);
  CloseHandle(FDataEvent);
  CloseHandle(FOverlapped.hEvent);

  inherited;
end;

procedure TBFClientReadThread.Execute;
var
  Err: DWORD;
begin
  while not Terminated do begin
    // Reading last error.
    Lock;
    Err := FLastError;
    Unlock;

    if Err <> NOERROR then
      // If error presents then suspend thread.
      Suspend

    else begin
      // Otherwaise try to read data from connection.
      case FClient.FTransport of
        // Case transport.
        atBluetooth: case FClient.FBluetoothTransport.FRadio.BluetoothAPI of
                       // For bluetooth case API.
                       baBlueSoleil: ReadCOM;
                       baWinSock: ReadWinSock;
                       baWidComm: ReadCOM;
                       baToshiba: ReadCOM;
                     end;
        atIrDA: ReadWinSock;
        atCOM: ReadCOM;
      end;

      Lock;
      if (FLastError = NOERROR) and (Length(FBuffer) > 0) then CheckEvents;
      if (FLastError <> NOERROR) or (Length(FBuffer) > 0) then SetEvent(FDataEvent);
      Unlock;
    end;
  end;
end;

procedure TBFClientReadThread.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TBFClientReadThread.ReadCOM;
var
  COMStat: TCOMStat;
  Mask: DWORD;
  Error: DWORD;
  Data: TBFByteArray;
  ARead: DWORD;
  BufSize: DWORD;
  Loop: DWORD;
begin
  Error := NOERROR;

  // Waiting data.
  Mask := 0;
  if not WaitCommEvent(FClient.FHandle, Mask, @FOverlapped) then begin
    Error := GetLastError;

    if Error = ERROR_IO_PENDING then begin
      WaitForSingleObject(FOverlapped.hEvent, INFINITE);

      Error := NOERROR;

    end else begin
      Lock;
      FLastError := Error;
      Unlock;
    end;
  end;

  // Reading data.
  if (Error = NOERROR) and (not Terminated) then begin
    FillChar(COMStat, SizeOf(TCOMStat), 0);
    if not ClearCommError(FClient.FHandle, Error, @COMStat) then begin
      Error := GetLastError;

      Lock;
      FLastError := Error;
      Unlock;

    end else begin
      ARead := COMStat.cbInque;
      if ARead > 0 then begin
        SetLength(Data, ARead);

        if ReadFile(FClient.FHandle, PChar(Data)^, ARead, ARead, @FOverlapped) then begin
          SetLength(Data, ARead);

          Lock;

          BufSize := Length(FBuffer);
          SetLength(FBuffer, BufSize + ARead);
          for Loop := 0 to ARead - 1 do FBuffer[BufSize + Loop] := Data[Loop];

          Unlock;

        end else begin
          Error := GetLastError;

          if Error = ERROR_IO_PENDING then
            if GetOverlappedResult(FClient.FHandle, FOverlapped, ARead, True) then begin
              SetLength(Data, ARead);

              Lock;

              BufSize := Length(FBuffer);
              SetLength(FBuffer, BufSize + ARead);
              for Loop := 0 to ARead - 1 do FBuffer[BufSize + Loop] := Data[Loop];

              Unlock;

            end else begin
              Error := GetLastError;

              Lock;

              FLastError := Error;

              Unlock;
            end

          else begin
            Lock;

            FLastError := Error;

            Unlock;
          end;

        end;

        SetLength(Data, 0);
      end;
    end;
  end;
end;

function TBFClientReadThread.Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean): DWORD;
var
  Error: DWORD;
begin
  Result := NOERROR;

  Lock;
  Error := FLastError;
  Unlock;

  if Error <> NOERROR then begin
    Lock;
    Result := Error;
    Unlock;

    Size := 0;
    SetLength(Data, Size);

  end else
    // Waits for data.
    if WaitForData then
      while True do
        if WaitForSingleObject(FDataEvent, FClient.FReadTimeOut) = WAIT_OBJECT_0 then begin
          Result := NOERROR;

          Lock;

          if DWORD(Length(FBuffer)) = Size then begin
            // Copy data.
            Data := Copy(FBuffer, 0, Size);
            // Clear buffer.
            SetLength(FBuffer, 0);

            // Reseting event.
            ResetEvent(FDataEvent);

            Unlock;

            Break;

          end else
            if DWORD(Length(FBuffer)) > Size then begin
              SetLength(Data, Size);
              Data := Copy(FBuffer, 0, Size);
              FBuffer := Copy(FBuffer, Size, DWORD(Length(FBuffer)) - Size);

              Unlock;

              Break;
            end;

          Unlock;

        end else begin
          // wait time out. No data.
          Size := 0;
          SetLength(Data, Size);
          
          Lock;
          FLastError := ERROR_TIMEOUT;
          Result := FLastError;
          Unlock;

          Break;
        end

    else
      if WaitForSingleObject(FDataEvent, FClient.FReadTimeOut) = WAIT_OBJECT_0 then begin
        // Data is available.
        Result := NOERROR;

        Lock;

        if DWORD(Length(FBuffer)) <= Size then begin
          Size := Length(FBuffer);
          SetLength(Data, Size);

          if Size = 0 then begin
            // Error
            FLastError := ERROR_TIMEOUT;
            Result := FLastError;

          end else begin
            // Copy data.
            Data := Copy(FBuffer, 0, Size);
            // Clear buffer.
            SetLength(FBuffer, 0);

            // Reseting event.
            ResetEvent(FDataEvent);
          end;

        end else begin
          SetLength(Data, Size);
          Data := Copy(FBuffer, 0, Size);
          FBuffer := Copy(FBuffer, Size, DWORD(Length(FBuffer)) - Size);
        end;

        Unlock;

      end else begin
        // wait time out. No data.
        Size := 0;
        SetLength(Data, Size);

        Lock;
        FLastError := ERROR_TIMEOUT;
        Result := FLastError;
        Unlock;
      end;
end;

procedure TBFClientReadThread.ReadWinSock;
var
  Events: WSANETWORKEVENTS;
  Data: TBFByteArray;
  Size: DWORD;
  BufSize: DWORD;
  Loop: DWORD;
begin
  // Waiting network events
  if WSAWaitForMultipleEvents(1, @FClient.FEvent, True, INFINITE, False) = WAIT_OBJECT_0 then begin
    // Check events.
    FillChar(Events, SizeOf(WSANETWORKEVENTS), 0);
    WSAEnumNetworkEvents(FClient.FSocket, FClient.FEvent, @Events);

    case Events.lNetworkEvents of
      FD_READ: begin
                 Size := FClient.FReadBuffer;
                 SetLength(Data, Size);
                 // Have data to read.
                 Size := recv(FClient.FSocket, PChar(Data)^, Size, 0);

                 if (Size > 0) and (Size <> WSAETIMEDOUT) then begin
                   SetLength(Data, Size);

                   Lock;

                   BufSize := Length(FBuffer);
                   SetLength(FBuffer, BufSize + Size);
                   for Loop := 0 to Size - 1 do FBuffer[BufSize + Loop] := Data[Loop];

                   Unlock;

                   SetLength(Data, 0);

                 end else
                   if (Size = 0) or ((Size <> 0) and (Size <> WSAETIMEDOUT)) then begin
                     // Close connection.
                     Lock;
                     FLastError := WSAETIMEDOUT;
                     Unlock;

                   end;
               end;

      FD_CLOSE: begin
                  // Close event
                  Lock;
                  FLastError := WSAECONNRESET;
                  Unlock;

                  PostMessage(FClient.Wnd, BFNM_CLIENT_EVENT, NM_CLIENT_CLOSE, 0);
                end;
    end;

  end else begin
    Lock;
    FLastError := WSAETIMEDOUT;
    Unlock;
  end;
end;

procedure TBFClientReadThread.Unlock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

procedure TBFClientReadThread.CheckEvents;
begin
  if Length(FBuffer) > 0 then PostMessage(FClient.Wnd, BFNM_CLIENT_EVENT, NM_CLIENT_DATA, 0);
end;

{ TBFCustomClientX }

procedure _TBFCustomClientX.Close;
begin
  FBFCustomClient.Close;
end;

constructor _TBFCustomClientX.Create(AOwner: TComponent);
begin
  inherited;

  FBFCustomClient := GetComponentClass.Create(nil);
end;

destructor _TBFCustomClientX.Destroy;
begin
  FBFCustomClient.Free;

  inherited;
end;

function _TBFCustomClientX.GetActive: Boolean;
begin
  Result := FBFCustomClient.Active;
end;

function _TBFCustomClientX.GetBluetoothTransport: TBFBluetoothClientTransport;
begin
  Result := FBFCustomClient.BluetoothTransport;
end;

function _TBFCustomClientX.GetCOMPortTransport: TBFCOMPortClientTransport;
begin
  Result := FBFCustomClient.COMPortTransport;
end;

function _TBFCustomClientX.GetConnectTimeOut: DWORD;
begin
  Result := FBFCustomClient.ConnectTimeOut;
end;

function _TBFCustomClientX.GetIrDATransport: TBFIrDAClientTransport;
begin
  Result := FBFCustomClient.IrDATransport;
end;

function _TBFCustomClientX.GetOnData: TBFClientEvent;
begin
  Result := FBFCustomClient.OnData;
end;

function _TBFCustomClientX.GetOnDisconnect: TBFClientEvent;
begin
  Result := FBFCustomClient.OnDisconnect;
end;

function _TBFCustomClientX.GetReadBuffer: DWORD;
begin
  Result := FBFCustomClient.ReadBuffer;
end;

function _TBFCustomClientX.GetReadTimeOut: DWORD;
begin
  Result := FBFCustomClient.ReadTimeOut;
end;

function _TBFCustomClientX.GetTransport: TBFAPITransport;
begin
  Result := FBFCustomClient.Transport;
end;

function _TBFCustomClientX.GetWriteBuffer: DWORD;
begin
  Result := FBFCustomClient.WriteBuffer;
end;

function _TBFCustomClientX.GetWriteTimeOut: DWORD;
begin
  Result := FBFCustomClient.WriteTimeOut;
end;

procedure _TBFCustomClientX.Open;
begin
  FBFCustomClient.Open;
end;

procedure _TBFCustomClientX.OpenDevice;
begin
  FBFCustomClient.OpenDevice;
end;

procedure _TBFCustomClientX.SetActive(const Value: Boolean);
begin
  FBFCustomClient.Active := Value;
end;

procedure _TBFCustomClientX.SetBluetoothTransport(const Value: TBFBluetoothClientTransport);
begin
  FBFCustomClient.BluetoothTransport := Value;
end;

procedure _TBFCustomClientX.SetCOMPortTransport(const Value: TBFCOMPortClientTransport);
begin
  FBFCustomClient.COMPortTransport := Value;
end;

procedure _TBFCustomClientX.SetConnectTimeOut(const Value: DWORD);
begin
  FBFCustomClient.ConnectTimeOut := Value;
end;

procedure _TBFCustomClientX.SetIrDATransport(const Value: TBFIrDAClientTransport);
begin
  FBFCustomClient.IrDATransport := Value;
end;

procedure _TBFCustomClientX.SetOnData(const Value: TBFClientEvent);
begin
  FBFCustomClient.OnData := Value;
end;

procedure _TBFCustomClientX.SetOnDisconnect(const Value: TBFClientEvent);
begin
  FBFCustomClient.OnDisconnect := Value;
end;

procedure _TBFCustomClientX.SetReadBuffer(const Value: DWORD);
begin
  FBFCustomClient.ReadBuffer := Value;
end;

procedure _TBFCustomClientX.SetReadTimeOut(const Value: DWORD);
begin
  FBFCustomClient.ReadTimeOut := Value;
end;

procedure _TBFCustomClientX.SetTransport(const Value: TBFAPITransport);
begin
  FBFCustomClient.Transport := Value;
end;

procedure _TBFCustomClientX.SetWriteBuffer(const Value: DWORD);
begin
  FBFCustomClient.WriteBuffer := Value;
end;

procedure _TBFCustomClientX.SetWriteTimeOut(const Value: DWORD);
begin
  FBFCustomClient.WriteTimeOut := Value;
end;

end.
