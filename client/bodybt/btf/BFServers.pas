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
unit BFServers;

{$I BF.inc}

interface

uses
  Classes, BFBase, Windows, BFAPI, Messages, BFDiscovery;

type
  // Forward declaration.
  TBFCustomServer = class;
  TBFCustomServerClass = class of TBFCustomServer;

  // Base class for servers transport.
  TBFCustomServerTransport = class(TPersistent)
  private
    FServer: TBFCustomServer;

    procedure RaiseServerActive;
    procedure RaiseClientNotConnected;

  public
    // Default constructor.
    constructor Create(AServer: TBFCustomServer); virtual;
  end;

  // Bluetooth server transport params.
  TBFBluetoothServerTransport = class(TBFCustomServerTransport)
  private
    FAuthentication: Boolean;
    FEncryption: Boolean;
    FPort: DWORD;
    FRadio: TBFBluetoothRadio;
    FService: string;
    FServiceUUID: TGUID;

    function GetSignalPower: Byte;

    procedure SetAuthentication(const Value: Boolean);
    procedure SetEncryption(const Value: Boolean);
    procedure SetPort(const Value: DWORD);
    procedure SetRadio(const Value: TBFBluetoothRadio);
    procedure SetService(const Value: string);
    procedure SetServiceUUID(const Value: TGUID);

  public
    // Default constructor.
    constructor Create(AServer: TBFCustomServer); override;
    // Default destructor
    destructor Destroy; override;

    // Radio
    property Radio: TBFBluetoothRadio read FRadio write SetRadio;
    // Service UUID for server.
    property ServiceUUID: TGUID read FServiceUUID write SetServiceUUID;
    // Returns bluetooth signal power between dongle and connected device.
    property SignalPower: Byte read GetSignalPower;

  published
    // Sets to True for enable authentication for server.
    property Authentication: Boolean read FAuthentication write SetAuthentication default False;
    // Sets to True for enable encryption.
    property Encryption: Boolean read FEncryption write SetEncryption default False;
    // Server port number.
    property Port: DWORD read FPort write SetPort default DWORD(BT_PORT_ANY);
    // Service name.
    property Service: string read FService write SetService;
  end;

  // IrDA server transport params.
  TBFIrDAServerTransport = class(TBFCustomServerTransport)
  private
    FService: string;

    procedure SetService(const Value: string);

  public
    // Default constructor.
    constructor Create(AServer: TBFCustomServer); override;

  published
    // Service for server.
    property Service: string read FService write SetService;
  end;

  TBFCustomServerThreadClass = class of TBFCustomServerThread;
  // Base server thread class.
  TBFCustomServerThread = class(TBFBaseThread)
  private
    FListenSocket: TSocket;
    FOverlapped: TOverlapped;
    FServer: TBFCustomServer;

    // Force close client connections.
    procedure Disconnect;
    // Notifi main thread about connection.
    procedure DoConnect;
    // Sends data to main thread.
    procedure DoData(Data: TBFByteArray);
    // Close client connections.
    procedure DoDisconnect;
    procedure ListenBluetooth;
    procedure ListenBluetoothIVT;
    procedure ListenBluetoothMS;
    procedure ListenBluetoothTos;
    procedure ListenBluetoothWD;
    procedure ListenCOMPort;
    procedure ListenIrDA;
    procedure ListenWinSock;

  protected
    // Thread procedure.
    procedure Execute; override;

  public
    // Default constructor.
    constructor Create(AServer: TBFCustomServer);
    // Default destructor.
    destructor Destroy; override;
  end;

  // Server's events prototype.
  TBFServerEvent = procedure (Sender: TObject) of object;

  // Base server class.
  TBFCustomServer = class(TBFBaseComponent)
  private
    FActive: Boolean;
    FBLOB: BLOB;
    FBluetoothTransport: TBFBluetoothServerTransport;
    FBTHSetService: PBTH_SET_SERVICE;
    FBTHSetServiceSize: DWORD;
    FConnected: Boolean;
    FEvent: THandle;
    FHandle: THandle;
    FIrDATransport: TBFIrDAServerTransport;
    FManualSDP: Boolean;
    FOverlapped: TOverlapped;
    FReadBuffer: DWORD;
    FRemoteAddress: string;
    FRemoteName: string;
    FSDPVersion: DWORD;
    FServerSocket: TSocket;
    FThread: TBFCustomServerThread;
    FTransport: TBFAPITransport;
    FWriteBuffer: DWORD;
    FWSAQuerySet: WSAQUERYSET;

    FOnConnect: TBFServerEvent;
    FOnDisconnect: TBFServerEvent;

    function GetRemoteAddress: string;
    function GetRemoteName: string;

    procedure BFNMServerEvent(var Msg: TMessage); message BFNM_SERVER_EVENT;
    procedure CloseBluetooth;
    procedure CloseBluetoothIVT;
    procedure CloseBluetoothMS;
    procedure CloseBluetoothTos;
    procedure CloseBluetoothWD;
    procedure CloseCOMTransport;
    procedure CloseIrDA;
    procedure CloseWinSock;
    procedure OpenBluetooth;
    procedure OpenBluetoothCOM(PortName: string);
    procedure OpenBluetoothIVT;
    procedure OpenBluetoothMS;
    procedure OpenBluetoothTos;
    procedure OpenBluetoothWD;
    procedure OpenIrDA;
    procedure RegisterBluetoothServiceMS;
    procedure SetActive(const Value: Boolean);
    procedure SetBluetoothTransport(const Value: TBFBluetoothServerTransport);
    procedure SetIrDATransport(const Value: TBFIrDAServerTransport);
    procedure SetReadBuffer(const Value: DWORD);
    procedure SetTransport(const Value: TBFAPITransport);
    procedure SetWriteBuffer(const Value: DWORD);
    procedure UnregisterBluetoothServiceMS;
    procedure WriteBluetooth(Data: TBFByteArray);
    procedure WriteCOM(Data: TBFByteArray);
    procedure WriteIrDA(Data: TBFByteArray);
    procedure WriteWD(Data: TBFByteArray);
    procedure WriteWinSock(Data: TBFByteArray);

  protected
    // Builds SDP.
    function BuildSDP(APort: DWORD; AName: string; var ACOD: DWORD; var SDPRecord: TBFByteArray): Boolean; virtual;
    // Returns class of the server thread.
    function GetServerThreadClass: TBFCustomServerThreadClass; virtual;

    // Calls when client connected.
    procedure DoConnect; virtual;
    // Calls when data available from client.
    procedure DoData(Data: TBFByteArray); virtual;
    // Calls when client disconnected.
    procedure DoDisconnect; virtual;
    // Closes the server.
    procedure InternalClose; virtual;
    // Opens server. Never call it from other palces. Always call Open.
    procedure InternalOpen; virtual;
    // Raises an exception when server active.
    procedure RaiseActive;
    // Raises an exception when client not connected.
    procedure RaiseNotConnected;
    // Writes data to the connection.
    procedure Write(Data: TBFByteArray); virtual;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Closes the server.
    procedure Close;
    // Opens the server.
    procedure Open;

    // Returns True if server active. Setst to True to open server.
    property Active: Boolean read FActive write SetActive;
    // Returns True if client connected to the server. Sets to True for
    // disconnect.
    property Connected: Boolean read FConnected;
    // Remote device address.
    property RemoteAddress: string read GetRemoteAddress;
    // Remote device name.
    property RemoteName: string read GetRemoteName;

  published
    // Bluetooth transport params.
    property BluetoothTransport: TBFBluetoothServerTransport read FBluetoothTransport write SetBluetoothTransport;
    // IrDA transport params.
    property IrDATransport: TBFIrDAServerTransport read FIrDATransport write SetIrDATransport;
    // Read buffer size.
    property ReadBuffer: DWORD read FReadBuffer write SetReadBuffer default 512;
    // Used transport.
    property Transport: TBFAPITransport read FTransport write SetTransport default atBluetooth;
    // Write buffer.
    property WriteBuffer: DWORD read FWriteBuffer write SetWriteBuffer default 512;

    // Event occurs when client connects to the server.
    property OnConnect: TBFServerEvent read FOnConnect write FOnConnect;
    // Event occurs when client disconnects from the server.
    property OnDisconnect: TBFServerEvent read FOnDisconnect write FOnDisconnect;
  end;

  _TBFCustomServerX = class(_TBFActiveXControl)
  private
    function GetActive: Boolean;
    function GetBluetoothTransport: TBFBluetoothServerTransport;
    function GetConnected: Boolean;
    function GetIrDATransport: TBFIrDAServerTransport;
    function GetOnConnect: TBFServerEvent;
    function GetOnDisconnect: TBFServerEvent;
    function GetReadBuffer: DWORD;
    function GetRemoteAddress: string;
    function GetRemoteName: string;
    function GetTransport: TBFAPITransport;
    function GetWriteBuffer: DWORD;

    procedure SetActive(const Value: Boolean);
    procedure SetBluetoothTransport( const Value: TBFBluetoothServerTransport);
    procedure SetIrDATransport(const Value: TBFIrDAServerTransport);
    procedure SetOnConnect(const Value: TBFServerEvent);
    procedure SetOnDisconnect(const Value: TBFServerEvent);
    procedure SetReadBuffer(const Value: DWORD);
    procedure SetTransport(const Value: TBFAPITransport);
    procedure SetWriteBuffer(const Value: DWORD);

  protected
    FBFCustomServer: TBFCustomServer;
    
    function GetComponentClass: TBFCustomServerClass; virtual; abstract;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open;

    property Active: Boolean read GetActive write SetActive;
    property Connected: Boolean read GetConnected;
    property RemoteAddress: string read GetRemoteAddress;
    property RemoteName: string read GetRemoteName;

  published
    property BluetoothTransport: TBFBluetoothServerTransport read GetBluetoothTransport write SetBluetoothTransport;
    property IrDATransport: TBFIrDAServerTransport read GetIrDATransport write SetIrDATransport;
    property ReadBuffer: DWORD read GetReadBuffer write SetReadBuffer;
    property Transport: TBFAPITransport read GetTransport write SetTransport;
    property WriteBuffer: DWORD read GetWriteBuffer write SetWriteBuffer;

    property OnConnect: TBFServerEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TBFServerEvent read GetOnDisconnect write SetOnDisconnect;
  end;

implementation

uses
  SysUtils, BFStrings, ActiveX, Contnrs, BFOBEXServer,
  BFD5Support{$IFDEF TRIAL}, Dialogs{$ENDIF};

var
  // This is servers list for IVT.
  IVTServers: TObjectList = nil;
  IVTCriticalSection: TRTLCriticalSection;
  {$IFDEF TRIAL}
  TotalSended: Integer = 0;
  {$ENDIF}

procedure IVTCallback(dwServerHandle: DWORD; lpBdAddr: PByte; ucStatus: UCHAR; dwConnetionHandle: DWORD); cdecl;
var
  Loop: Integer;
  Server: TBFCustomServer;
  DevInfo: BLUETOOTH_DEVICE_INFO_EX;
  DevInfoSize: DWORD;
begin
  EnterCriticalSection(IVTCriticalSection);

  Server := nil;

  for Loop := 0 to IVTServers.Count - 1 do
    if TBFCustomServer(IVTServers[Loop]).FHandle = dwServerHandle then begin
      Server := TBFCustomServer(IVTServers[Loop]);
      Break;
    end;

  if Assigned(Server) then
    case ucStatus of
      STATUS_INCOMING_CONNECT: begin
                                 with Server do begin
                                   FRemoteName := StrUnknown;

                                   // Get remote device address.
                                   FRemoteAddress := API.BlueSoleilAddressToString(PBluetoothAddress(lpBdAddr)^);

                                   // Get remote device name.
                                   DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
                                   FillChar(DevInfo, DevInfoSize, 0);
                                   with DevInfo do begin
                                     dwSize := DevInfoSize;
                                     address := PBluetoothAddress(lpBdAddr)^;
                                   end;

                                   if BT_GetRemoteDeviceInfo(MASK_DEVICE_NAME, DevInfo) = BTSTATUS_SUCCESS then FRemoteName := string(DevInfo.szName);
                                 end;

                                 SendMessage(Server.Wnd, BFNM_SERVER_EVENT, NM_SERVER_CONNECT, 0);
                                 Server.FThread.Resume;
                               end;
                               
      STATUS_INCOMING_DISCONNECT: begin
                                    SendMessage(Server.Wnd, BFNM_SERVER_EVENT, NM_SERVER_DISCONNECT, 0);
                                    Server.FThread.Suspend;
                                  end;  
    end;

  LeaveCriticalSection(IVTCriticalSection);
end;

procedure RegisterIVTServer(AObject: TObject);
begin
  EnterCriticalSection(IVTCriticalSection);

  with IVTServers do begin
    Add(AObject);

    if Count = 1 then BT_RegisterCallback(EVENT_SPPEX_CONNECTION_STATUS, @IVTCallback);
  end;

  LeaveCriticalSection(IVTCriticalSection);
end;

procedure UnregisterIVTServer(AObject: TObject);
begin
  EnterCriticalSection(IVTCriticalSection);

  with IVTServers do begin
    if Count = 1 then BT_UnregisterCallback(EVENT_SPPEX_CONNECTION_STATUS);

    Delete(IndexOf(AObject));
  end;

  LeaveCriticalSection(IVTCriticalSection);
end;

{ TBFCustomServerTransport }

constructor TBFCustomServerTransport.Create(AServer: TBFCustomServer);
begin
  FServer := AServer;
end;

procedure TBFCustomServerTransport.RaiseClientNotConnected;
begin
  FServer.RaiseNotConnected;
end;

procedure TBFCustomServerTransport.RaiseServerActive;
begin
  // Raises an exception if server active.
  FServer.RaiseActive;
end;

{ TBFBluetoothServerTransport }

constructor TBFBluetoothServerTransport.Create(AServer: TBFCustomServer);
begin
  inherited;

  FAuthentication := False;
  FEncryption := False;
  FPort := DWORD(BT_PORT_ANY);
  FRadio := nil;
  FService := 'Unknown';
  FServiceUUID := GUID_NULL;
end;

destructor TBFBluetoothServerTransport.Destroy;
begin
  if Assigned(FRadio) then FRadio.Free;
  
  inherited;
end;

function TBFBluetoothServerTransport.GetSignalPower: Byte;

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
      address := API.StringToBluetoothAddress(FServer.RemoteAddress);
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

    if not WD_GetConnectionStats(API.StringToBluetoothAddress(FServer.RemoteAddress), @Stat) then raise Exception.Create(StrSignalPowerDetectError);

    Result := LoWord(Lo(Stat.Rssi));
  end;

begin
  RaiseClientNotConnected;
  
  case FRadio.BluetoothAPI of
    baBlueSoleil: Result := GetBlueSoleilSignalPower;
    baWinSock: raise Exception.Create(StrMSStackUnsupported);
    baWidComm: Result := GetWidCommSignalPower;

  else
    raise Exception.Create(StrFeatureNotSupported);
  end;
end;

procedure TBFBluetoothServerTransport.SetAuthentication(const Value: Boolean);
begin
  if Value <> FAuthentication then begin
    RaiseServerActive;

    FAuthentication := Value;
  end;
end;

procedure TBFBluetoothServerTransport.SetEncryption(const Value: Boolean);
begin
  if Value <> FEncryption then begin
    RaiseServerActive;

    FEncryption := Value;
  end;
end;

procedure TBFBluetoothServerTransport.SetPort(const Value: DWORD);
begin
  if Value <> FPort then begin
    RaiseServerActive;

    if (Value > 30) and (Value <> DWORD(BT_PORT_ANY)) then raise Exception.Create(StrInvalidPortNumber);

    FPort := Value;
  end;
end;

procedure TBFBluetoothServerTransport.SetRadio(const Value: TBFBluetoothRadio);
begin
  RaiseServerActive;

  if Assigned(FRadio) then begin
    FRadio.Free;
    FRadio := nil;
  end;

  if Assigned(Value) then begin
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothServerTransport.SetService(const Value: string);
var
  Tmp: TGUID;
begin
  if Value <> Service then begin
    RaiseServerActive;

    FService := Value;

    Tmp := API.StringToUUID(Value);
    if not CompareGUIDs(Tmp, GUID_NULL) then FServiceUUID := Tmp;
  end;
end;

procedure TBFBluetoothServerTransport.SetServiceUUID(const Value: TGUID);
var
  Tmp: string;
begin
  if not CompareGUIDs(Value, FServiceUUID) then begin
    RaiseServerActive;

    FServiceUUID := Value;
    
    Tmp := API.UUIDToString(FServiceUUID);
    if Tmp <> 'Unknown' then FService := Tmp;
  end;
end;

{ TBFIrDAServerTransport }

constructor TBFIrDAServerTransport.Create(AServer: TBFCustomServer);
begin
  inherited;

  FService := '';
end;

procedure TBFIrDAServerTransport.SetService(const Value: string);
begin
  if Value <> FService then begin
    RaiseServerActive;

    FService := Value;
  end;
end;

{ TBFCustomServerThread }

constructor TBFCustomServerThread.Create(AServer: TBFCustomServer);
var
  CreateSuspended: Boolean;
begin
  FreeOnTerminate := False;

  FListenSocket := AServer.FServerSocket;
  FillChar(FOverlapped, SizeOf(TOverlapped), 0);
  FOverlapped.hEvent := CreateEvent(nil, True, False, nil);
  FServer := AServer;

  CreateSuspended := AServer.Transport = atBluetooth;
  if CreateSuspended then CreateSuspended := Assigned(AServer.FBluetoothTransport.FRadio);
  if CreateSuspended then CreateSuspended := AServer.FBluetoothTransport.FRadio.BluetoothAPI <> baWinSock;
  
  inherited Create(CreateSuspended);
end;

procedure TBFCustomServerThread.DoDisconnect;
begin
  SendMessage(FServer.Wnd, BFNM_SERVER_EVENT, NM_SERVER_DISCONNECT, 0);
end;

procedure TBFCustomServerThread.DoConnect;
begin
  SendMessage(FServer.Wnd, BFNM_SERVER_EVENT, NM_SERVER_CONNECT, 0);
end;

procedure TBFCustomServerThread.DoData(Data: TBFByteArray);
begin
  SendMessage(FServer.Wnd, BFNM_SERVER_EVENT, NM_SERVER_DATA, Integer(Data));
end;

procedure TBFCustomServerThread.Execute;
begin
  while not Terminated do
    case FServer.Transport of
      atBluetooth: ListenBluetooth;
      atIrDA: ListenIrDA;
    end;
end;

procedure TBFCustomServerThread.ListenBluetooth;
begin
  // Checks API
  case FServer.FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: ListenBluetoothIVT;
    baWinSock: ListenBluetoothMS;
    baWidComm: ListenBluetoothWD;
    baToshiba: ListenBluetoothTos;
  end;
end;

procedure TBFCustomServerThread.ListenBluetoothIVT;
begin
  ListenCOMPort;
end;

procedure TBFCustomServerThread.ListenBluetoothMS;
begin
  ListenWinSock;
end;

procedure TBFCustomServerThread.ListenBluetoothWD;
begin
end;

procedure TBFCustomServerThread.ListenIrDA;
begin
  ListenWinSock;
end;

procedure TBFCustomServerThread.ListenWinSock;
var
  Events: WSANETWORKEVENTS;
  Data: TBFByteArray;
  Size: DWORD;
  SockAddr: SOCKADDR_BTH;
  SockAddrSize: Integer;
  Addr: array [0..255] of Char;
  AddrSize: DWORD;
  StrAddr: string;
  DevInfo: BLUETOOTH_DEVICE_INFO;
  DevInfoSize: DWORD;
  IrDA: SOCKADDR_IRDA;
begin
  // Waiting network events
  if WSAWaitForMultipleEvents(1, @FServer.FEvent, True, INFINITE, False) = WAIT_OBJECT_0 then begin
    // Check events.
    FillChar(Events, SizeOf(WSANETWORKEVENTS), 0);
    WSAEnumNetworkEvents(FListenSocket, FServer.FEvent, @Events);

    case Events.lNetworkEvents of
      FD_ACCEPT: begin
                   WSAEventSelect(FListenSocket, FServer.FEvent, 0);
                   FListenSocket := accept(FListenSocket, nil, nil);
                   WSAEventSelect(FListenSocket, FServer.FEvent, FD_READ or FD_CLOSE);

                   with FServer do begin
                     FRemoteAddress := StrUnknown;
                     FRemoteName := StrUnknown;
                   end;

                   // Resolve remote address.
                   if FServer.Transport = atBluetooth then begin
                     SockAddrSize := SizeOf(SOCKADDR_BTH);
                     FillChar(SockAddr, SockAddrSize, 0);
                     SockAddr.addressFamily := AF_BTH;
                     if getpeername(FListenSocket, @SockAddr, SockAddrSize) <> SOCKET_ERROR then begin
                       AddrSize := SizeOf(Addr);
                       FillChar(Addr, AddrSize, 0);

                       if WSAAddressToString(@SockAddr, SockAddrSize, nil, Addr, AddrSize) <> SOCKET_ERROR then begin
                         StrAddr := string(Addr);
                         if Pos('):', StrAddr) > 0 then StrAddr := Copy(StrAddr, 1, Pos('):', StrAddr));
                         FServer.FRemoteAddress := StrAddr;
                       end;

                       // Resolve remote name. (Only if address resolving success).
                       DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
                       FillChar(DevInfo, DevInfoSize, 0);
                       with DevInfo do begin
                         dwSize := DevInfoSize;
                         Address.ullLong := SockAddr.btAddr;
                       end;

                       if BluetoothGetDeviceInfo(0, DevInfo) = 0 then FServer.FRemoteName := string(DevInfo.szName);
                     end;

                   end else begin
                     SockAddrSize := SizeOf(SOCKADDR_IRDA);
                     FillChar(IrDA, SockAddrSize, 0);
                     IrDA.irdaAddressFamily := AF_IRDA;
                     if getpeername(FListenSocket, @IrDA, SockAddrSize) <> SOCKET_ERROR then begin
                       AddrSize := SizeOf(Addr);
                       FillChar(Addr, AddrSize, 0);

                       if WSAAddressToString(@IrDA, SockAddrSize, nil, Addr, AddrSize) <> SOCKET_ERROR then begin
                         StrAddr := string(Addr);
                         FServer.FRemoteAddress := StrAddr;
                       end;
                     end;
                   end;

                   DoConnect;
                 end;

      FD_READ: begin
                 Size := FServer.FReadBuffer;
                 SetLength(Data, Size);
                 // Have data to read.
                 Size := recv(FListenSocket, PChar(Data)^, Size, 0);

                 // If data available then asend it to main thread. 
                 if (Size > 0) and (Size <> WSAETIMEDOUT) then begin
                   SetLength(Data, Size);
                   DoData(Data);
                 end;

                 // Clean up.
                 SetLength(Data, 0);
               end;

      FD_CLOSE: begin
                  WSAEventSelect(FListenSocket, FServer.FEvent, 0);
                  closesocket(FListenSocket);

                  FListenSocket := FServer.FServerSocket;
                  WSAEventSelect(FListenSocket, FServer.FEvent, FD_ACCEPT or FD_CLOSE);
                  
                  DoDisconnect;
                end;
    end;
  end;
end;

procedure TBFCustomServerThread.Disconnect;
begin
  Terminate;

  if Suspended then Resume;

  with FServer do 
    if (Transport = atIrDA) or ((Transport = atBluetooth) and (FServer.FBluetoothTransport.FRadio.BluetoothAPI = baWinSock)) then begin
      SetEvent(FEvent);

      if FConnected then begin
        WSAEventSelect(FListenSocket, FEvent, 0);
        closesocket(FListenSocket);

        FListenSocket := FServerSocket;
        WSAEventSelect(FListenSocket, FEvent, FD_ACCEPT or FD_CLOSE);
      end;

    end else
      SetEvent(Self.FOverlapped.hEvent);

  DoDisconnect;
end;

procedure TBFCustomServerThread.ListenCOMPort;
var
  COMStat: TCOMStat;
  Mask: DWORD;
  Error: DWORD;
  Data: TBFByteArray;
  Read: DWORD;
begin
  Error := NOERROR;

  // Waiting data.
  if not WaitCommEvent(FServer.FServerSocket, Mask, @FOverlapped) then begin
    Error := GetLastError;

    if Error = ERROR_IO_PENDING then begin
      WaitForSingleObject(FOverlapped.hEvent, INFINITE);
      Error := NOERROR;
    end;
  end;

  // Reading data.
  if (Error = NOERROR) and (not Terminated) then
    if ClearCommError(FServer.FServerSocket, Error, @COMStat) then begin
      Read := COMStat.cbInque;

      if Read > 0 then begin
        SetLength(Data, Read);

        if ReadFile(FServer.FServerSocket, PChar(Data)^, Read, Read, @FOverlapped) then begin
          SetLength(Data, Read);
          DoData(Data);
        end;

        SetLength(Data, 0);
      end;
    end;
end;

destructor TBFCustomServerThread.Destroy;
begin
  CloseHandle(FOverlapped.hEvent);
  
  inherited;
end;

procedure TBFCustomServerThread.ListenBluetoothTos;
begin
end;

{ TBFCustomServer }

procedure TBFCustomServer.BFNMServerEvent(var Msg: TMessage);
type
  PWD_DATA = ^WD_DATA;
  WD_DATA = record
    len: Word;
    p_data: Pointer;
  end;

var
  Data: TBFByteArray;
  Loop: Integer;
  Addr: TBluetoothAddress;
begin
  SetLength(Data, 0);

  try
    case Msg.WParam of
      NM_SERVER_DATA: begin
                        Data := TBFByteArray(Msg.LParam);
                        DoData(Data);
                      end;

      NM_SERVER_CONNECT: if not FConnected then begin
                           if FTransport = atBluetooth then
                             case FBluetoothTransport.FRadio.BluetoothAPI of
                               baWidComm: begin
                                            FRemoteAddress := StrUnknown;
                                            FRemoteName := StrUnknown;

                                            // Get remote device address.
                                            FillChar(Addr, SizeOf(TBluetoothAddress), 0);
                                            if WD_GetRemoteAddr(FHandle, @Addr) then begin
                                              FRemoteAddress := API.BlueSoleilAddressToString(Addr);
                                              
                                              { TODO : Получение имени удаленного устровтса для WidComm }
                                            end;
                                          end;

                               baWinSock: try
                                            UnregisterBluetoothServiceMS;

                                          except
                                          end;
                             end;

                           FConnected := True;
                           DoConnect;
                         end;

      NM_SERVER_DISCONNECT: if FConnected then begin
                              if (FTransport = atBluetooth) and (FBluetoothTransport.FRadio.BluetoothAPI = baWinSock) then
                                try
                                  RegisterBluetoothServiceMS;

                                except
                                end;

                              DoDisconnect;
                              FConnected := False;
                              FRemoteAddress := '';
                              FRemoteName := '';
                            end;

      NM_WD_SERVER_DATA: begin
                           SetLength(Data, PWD_DATA(Msg.LParam)^.len);
                           for Loop := 0 to PWD_DATA(Msg.LParam)^.len - 1 do Data[Loop] := PByte(Integer(PByte(PWD_DATA(Msg.LParam)^.p_data)) + Loop)^;
                           DoData(Data);
                         end;
    end;
  except
  end;

  Msg.Result := Integer(True);
end;

function TBFCustomServer.BuildSDP(APort: DWORD; AName: string; var ACOD: DWORD; var SDPRecord: TBFByteArray): Boolean;
begin
  Result := False;
  SetLength(SDPRecord, 0);
end;

procedure TBFCustomServer.Close;
begin
  // Just check params and calls internal procedure.
  if FActive then begin
    InternalClose;
    FActive := False;
    FRemoteAddress := '';
    FRemoteName := '';
  end;
end;

procedure TBFCustomServer.CloseBluetooth;
begin
  // Check API
  case FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: CloseBluetoothIVT;
    baWinSock: CloseBluetoothMS;
    baWidComm: CloseBluetoothWD;
    baToshiba: CloseBluetoothTos;
  end;
end;

procedure TBFCustomServer.CloseBluetoothIVT;
begin
  // Close port.
  CloseCOMTransport;

  // Unregister server.
  UnregisterIVTServer(Self);

  // Stops server.
  BT_StopSPPExService(FHandle);

  FHandle := INVALID_HANDLE_VALUE;
end;

procedure TBFCustomServer.CloseBluetoothMS;
begin
  UnregisterBluetoothServiceMS;

  CloseWinSock;
end;

procedure TBFCustomServer.CloseBluetoothTos;
begin
  { TODO : Закрытие сервера Toshiba }
end;

procedure TBFCustomServer.CloseBluetoothWD;
begin
  WD_CloseServer(FHandle);
  FHandle := INVALID_HANDLE_VALUE;
end;

procedure TBFCustomServer.CloseCOMTransport;
begin
  with FOverlapped do
    if hEvent <> 0 then
      CloseHandle(hEvent);

  FillChar(FOverlapped, SizeOf(TOverlapped), 0);

  // Just close the hanldle
  if FServerSocket <> INVALID_SOCKET then begin
    CloseHandle(FServerSocket);
    FServerSocket := INVALID_SOCKET;
  end;
end;

procedure TBFCustomServer.CloseIrDA;
begin
  CloseWinSock;
end;

procedure TBFCustomServer.CloseWinSock;
begin
  WSAEventSelect(FServerSocket, FEvent, 0);
  closesocket(FServerSocket);
  FServerSocket := INVALID_SOCKET;

  CloseHandle(FEvent);
  FEvent := WSA_INVALID_EVENT;
end;

constructor TBFCustomServer.Create(AOwner: TComponent);
begin
  inherited;

  // Initialization.
  FActive := False;
  FBluetoothTransport := TBFBluetoothServerTransport.Create(Self);
  FConnected := False;
  FEvent := WSA_INVALID_EVENT;
  FIrDATransport := TBFIrDAServerTransport.Create(Self);
  FillChar(FOverlapped, SizeOf(TOverlapped), 0);
  FReadBuffer := 512;
  FRemoteAddress := '';
  FRemoteName := '';
  FServerSocket := INVALID_SOCKET;
  FThread := nil;
  FTransport := atBluetooth;
  FWriteBuffer := 512;

  FOnConnect := nil;
  FOnDisconnect := nil;
end;

destructor TBFCustomServer.Destroy;
begin
  // Firstly close the server.
  Close;

  // Cleanup.
  FBluetoothTransport.Free;
  FIrDATransport.Free;

  inherited;
end;

procedure TBFCustomServer.DoConnect;
begin
  if Assigned(FOnConnect) then FOnConnect(Self);
end;

procedure TBFCustomServer.DoData(Data: TBFByteArray);
begin
  // Here we do nothing. But we should override this procedure in the ancessor
  // classes for work with data.

  {$IFDEF TRIAL}
  Inc(TotalSended, Length(Data));
  // 20mb
  if TotalSended > 20971520 then begin
    ShowMessage('Demo version can not read/send more then 20Mb of data.' + CRLF +
                'To obtain a full version visit http://www.btframework.com/order.htm');
    Exit;
  end;
  {$ENDIF}
end;

procedure TBFCustomServer.DoDisconnect;
begin
  if Assigned(FOnDisconnect) then FOnDisconnect(Self);
end;

function TBFCustomServer.GetRemoteAddress: string;
begin
  RaiseNotConnected;
  Result := FRemoteAddress;
end;

function TBFCustomServer.GetRemoteName: string;
begin
  RaiseNotConnected;
  Result := FRemoteName;
end;

function TBFCustomServer.GetServerThreadClass: TBFCustomServerThreadClass;
begin
  Result := TBFCustomServerThread;
end;

procedure TBFCustomServer.InternalClose;
begin
  // Disconnect clients.
  if Assigned(FThread) then FThread.Disconnect;

  // Closes the transport.
  case Transport of
    atBluetooth: CloseBluetooth;
    atIrDA: CloseIrDA;
  end;

  // Stops reading thread.
  if Assigned(FThread) then begin
    with FThread do begin
      WaitFor;
      Free;
    end;

    FThread := nil;
  end;
end;

procedure TBFCustomServer.InternalOpen;
begin
  // Check transport and call
  case FTransport of
    atBluetooth: OpenBluetooth;
    atIrDA: OpenIrDA;
  else
    raise Exception.Create(StrTransportNotSupported);
  end;

  // Starts srver thread.
  if (FTransport = atIrDA) or ((FTransport = atBluetooth) and (FBluetoothTransport.FRadio.BluetoothAPI <> baWidComm)) then
    FThread := GetServerThreadClass.Create(Self)
  else
    FThread := nil;

  // If all OK then active connection.
  FActive := True;
end;

procedure TBFCustomServer.Open;
begin
  // Just check status and calls internal procedure.
  RaiseActive;

  InternalOpen;
end;

procedure TBFCustomServer.OpenBluetooth;
var
  Radio: TBFBluetoothRadio;
begin
  API.CheckTransport(atBluetooth);

  // If there is no radio specified try to use first founded.
  if not Assigned(FBluetoothTransport.FRadio) then begin
    Radio := GetFirstRadio;
    FBluetoothTransport.Radio := Radio;
    Radio.Free;
  end;

  // If still no radio then raise an exception.
  if not Assigned(FBluetoothTransport.FRadio) then raise Exception.Create(StrRadioRequired);

  // Check API.
  case FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: OpenBluetoothIVT;
    baWinSock: OpenBluetoothMS;
    baWidComm: OpenBluetoothWD;
    baToshiba: OpenBluetoothTos;
  end;
end;

procedure TBFCustomServer.OpenBluetoothCOM(PortName: string);
begin
  FServerSocket := CreateFile(PChar(PortName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_FLAG_OVERLAPPED, 0);
  if FServerSocket = INVALID_HANDLE_VALUE then begin
    FServerSocket := INVALID_SOCKET;
    RaiseLastOSError;
  end;

  try
    // Setting up buffers and timeouts
    if not SetupComm(FServerSocket, FReadBuffer, FWriteBuffer) then RaiseLastOSError;

    // Try prepare com port.
    if not PurgeComm(FServerSocket, PURGE_TXCLEAR or PURGE_RXCLEAR) then RaiseLastOSError;

    // Preparing for overlapped I/O.
    if not SetCommMask(FServerSocket, EV_RXCHAR) then RaiseLastOSError;

    with FOverlapped do begin
      hEvent := CreateEvent(nil, True, False, nil);
      if hEvent = 0 then RaiseLastOSError;
    end;

  except
    // If something wrong then close port
    CloseHandle(FServerSocket);
    FHandle := INVALID_HANDLE_VALUE;
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomServer.OpenBluetoothIVT;
var
  ServerInfo: SPPEX_SERVICE_INFO;
  ServInfoSize: DWORD;
  Res: DWORD;
begin
  ServInfoSize := SizeOf(SPPEX_SERVICE_INFO);
  FillChar(ServerInfo, ServInfoSize, 0);
  with ServerInfo do begin
    dwSize := ServInfoSize;
    serviceClassUuid128 := FBluetoothTransport.ServiceUUID;
    StrLCopy(szServiceName, PChar(FBluetoothTransport.Service), SizeOf(szServiceName));
    ucServiceChannel := FBluetoothTransport.FPort;
  end;

  // Starts server
  Res := BT_StartSPPExService(@ServerInfo, @FHandle);
  if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

  try
    // Open port.
    OpenBluetoothCOM('\\?\COM' + IntToStr(ServerInfo.ucComIndex));
    // Regitser server.
    RegisterIVTServer(Self);

  except
    // If somthing wrong stops server
    BT_StopSPPExService(FHandle);
    // and re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomServer.OpenBluetoothMS;
var
  Addr: SOCKADDR_BTH;
  AddrSize: Integer;
  Auth: DWORD;
begin
  FManualSDP := False;

  // Create event object.
  FEvent := WSACreateEvent;
  if FEvent = WSA_INVALID_EVENT then RaiseLastOSError;

  try
    // Create socket.
    FServerSocket := BFAPI.socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
    if FServerSocket = INVALID_SOCKET then RaiseLastOSError;

    try
      // Set authentication.
      if FBluetoothTransport.FAuthentication then begin
        Auth := DWORD(FBluetoothTransport.FAuthentication);
        if setsockopt(FServerSocket, SOL_RFCOMM, Integer(SO_BTH_AUTHENTICATE), PChar(@Auth), SizeOf(DWORD)) <> 0 then RaiseLastOSError;
      end;
      // Set encryption.
      if FBluetoothTransport.FEncryption then begin
        Auth := DWORD(True);
        if setsockopt(FServerSocket, SOL_RFCOMM, Integer(SO_BTH_ENCRYPT), PChar(@Auth), SizeOf(DWORD)) <> 0 then RaiseLastOSError;
      end;

      // Preparing server socket data.
      AddrSize := SizeOf(SOCKADDR_BTH);
      FillChar(Addr, AddrSize, 0);
      with Addr do begin
        addressFamily := AF_BTH;
        btAddr := 0;
        serviceClassId := FBluetoothTransport.FServiceUUID;
        port := FBluetoothTransport.FPort;
      end;

      // Binding.
      if bind(FServerSocket, @Addr, AddrSize) <> 0 then RaiseLastOSError;

      RegisterBluetoothServiceMS;

      try
        // Register events.
        if WSAEventSelect(FServerSocket, FEvent, FD_ACCEPT or FD_CLOSE) <> 0 then RaiseLastOSError;

        try
          // Start listening.
          if listen(FServerSocket, 0) <> 0 then RaiseLastOSError;

        except
          // Somthing wrong. Unregister events.
          WSAEventSelect(FServerSocket, FEvent, 0);
          // And re-raise an exceptipon.
          raise;
        end;

      except
        // Somthing wrong. Unregister service.
        UnregisterBluetoothServiceMS;
        // and re-raise an exception.
        raise;
      end;

    except
      // Something wrong. Close socket
      closesocket(FServerSocket);
      FServerSocket := INVALID_SOCKET;
      // and re-raise an exception.
      raise
    end;

  except
    // Somithing wrong delete event
    CloseHandle(FEvent);
    FEvent := WSA_INVALID_EVENT;
    // and re-raise en exception
    raise;
  end;
end;

procedure TBFCustomServer.OpenBluetoothTos;
begin
  { TODO : Открытие сервера Toshiba }
  raise Exception.Create(Format(StrStackUnsupported, [StrToshiba]));
end;

procedure TBFCustomServer.OpenBluetoothWD;
var
  Flags: Byte;
  Obex: BOOL;
begin
  with FBluetoothTransport do begin
    Flags := BTM_SEC_NONE;

    if FAuthentication then Flags := Flags or BTM_SEC_IN_AUTHENTICATE;
    if FEncryption then Flags := Flags or BTM_SEC_IN_ENCRYPT;

    Obex := Self is TBFOBEXServer;

    if not WD_OpenServer(FServiceUUID, PChar(Service), Flags, DWORD(Self), Lo(FPort), Obex, Self.Wnd, FHandle) then begin
      FHandle := INVALID_HANDLE_VALUE;

      raise Exception.Create(StrCanNotCreateServer);
    end;
  end;
end;

procedure TBFCustomServer.OpenIrDA;
var
  ServiceName: string;
  ServiceNameSize: Integer;
  SockAddrSize: Integer;
  ServSockAddr: SOCKADDR_IRDA;
  IASSetBuff: array [0..SizeOf(IAS_SET) - 3 + IAS_MAX_ATTRIBNAME - 1] of Byte;
  IASSetLen: Integer;
  pIASSet: PIAS_SET;
begin
  // Checks is IrDA available.
  API.CheckTransport(atIrDA);

  // Internal temporary variables.
  ServiceName := FIrDATransport.FService;
  ServiceNameSize := Length(ServiceName);

  // Preparing for socket.
  SockAddrSize := SizeOf(SOCKADDR_IRDA);
  FillChar(ServSockAddr, SockAddrSize, 0);
  ServSockAddr.irdaAddressFamily := AF_IRDA;
  StrLCopy(ServSockAddr.irdaServiceName, PChar(ServiceName), ServiceNameSize);

  // Creates event for socket.
  FEvent := WSACreateEvent;
  if FEvent = WSA_INVALID_EVENT then RaiseLastOSError;

  try
    // Creates listen socket.
    FServerSocket := socket(AF_IRDA, SOCK_STREAM, 0);
    if FServerSocket = INVALID_SOCKET then RaiseLastOSError;

    try
      // Preparing service record.
      IASSetLen := SizeOf(IASSetBuff);
      FillChar(IASSetBuff, IASSetLen, 0);
      pIASSet := PIAS_SET(@IASSetBuff);

      with pIASSet^ do begin
        StrLCopy(irdaClassName, PChar(ServiceName), ServiceNameSize);
        irdaAttribName := 'IrDA:TinyTP';
        irdaAttribType := IAS_ATTRIB_STR;
        irdaAttribute.irdaAttribUsrStr.Len := 12
      end;

      // Registers the service.
      if setsockopt(FServerSocket, SOL_IRLMP, IRLMP_IAS_SET, PChar(pIASSet), IASSetLen) = SOCKET_ERROR then RaiseLastOSError;

      // Binds address to socket.
      if bind(FServerSocket, @ServSockAddr, SizeOf(SOCKADDR_IRDA)) <> 0 then RaiseLastOSError;

      // Preparing events.
      if WSAEventSelect(FServerSocket, FEvent, FD_ACCEPT or FD_CLOSE) <> 0 then RaiseLastOSError;

      try
        // Starts listen.
        if listen(FServerSocket, 0) <> 0 then RaiseLastOSError;

      except
        // If somthing wrong then clear events
        WSAEventSelect(FServerSocket, FEvent, 0);
        // and re-raise an exception.
        raise;
      end;

    except
      // If somthing wrong close socket
      closesocket(FServerSocket);
      FServerSocket := INVALID_SOCKET;
      // and re-raise en exception
      raise;
    end;

  except
    // If somthing wrong close event
    CloseHandle(FEvent);
    FEvent := WSA_INVALID_EVENT;
    // And re-raise an exception.
    raise;
  end;
end;

procedure TBFCustomServer.RaiseActive;
begin
  if FActive then raise Exception.Create(StrServerActive); 
end;

procedure TBFCustomServer.RaiseNotConnected;
begin
  if not FConnected then raise Exception.Create(StrNoClientConnection);
end;

procedure TBFCustomServer.RegisterBluetoothServiceMS;
var
  Addr: SOCKADDR_BTH;
  AddrSize: Integer;
  CSAddr: CSADDR_INFO;
  SDPRecord: TBFByteArray;
  APort: DWORD;
  ServiceComment: string;
  ServiceName: string;
  COD: DWORD;
  Loop: Integer;
  QuerySet: WSAQUERYSET;
  QuerySetSize: DWORD;
begin
  // Temprorary variables.
  ServiceComment := 'Bluetooth Framework ' + FBluetoothTransport.Service + #0;
  ServiceName := FBluetoothTransport.Service + #0;

  AddrSize := SizeOf(SOCKADDR_BTH);
  FillChar(Addr, AddrSize, 0);
  with Addr do begin
    addressFamily := AF_BTH;
    btAddr := 0;
    serviceClassId := FBluetoothTransport.FServiceUUID;
  end;

  // Preparing for service registration.
  if getsockname(FServerSocket, @Addr, AddrSize) <> 0 then RaiseLastOSError;

  FillChar(CSAddr, SizeOf(CSADDR_INFO), 0);
  with CSAddr do begin
    with LocalAddr do begin
      iSockaddrLength := SizeOf(SOCKADDR_BTH);
      lpSockaddr := @Addr;
    end;
    iSocketType := SOCK_STREAM;
    iProtocol := BTHPROTO_RFCOMM;
  end;

  SetLength(SDPRecord, 0);

  with Addr do
    if (port = 0) or (port = DWORD(BT_PORT_ANY)) then
      APort := FBluetoothTransport.FPort
    else
      APort := port;

  if BuildSDP(APort, ServiceName, COD, SDPRecord) then begin
    // SDP builded manually. Register SDP records.
    FManualSDP := True;

    FBTHSetServiceSize := SizeOf(BTH_SET_SERVICE) + Length(SDPRecord) - 1;
    GetMem(FBTHSetService, FBTHSetServiceSize);
    FillChar(FBTHSetService^, FBTHSetServiceSize, 0);

    FHandle := 0;
    FSDPVersion := 1;

    with FBTHSetService^ do begin
      pSdpVersion := @FSDPVersion;
      pRecordHandle := @FHandle;
      fCodService := COD;
      ulRecordLength := Length(SDPRecord);
      for Loop := 0 to Length(SDPRecord) - 1 do pRecord[Loop] := SDPRecord[Loop];
    end;

    FillChar(FBLOB, SizeOf(BLOB), 0);
    with FBLOB do begin
      cbSize := FBTHSetServiceSize;
      pBlobData := PBYTE(FBTHSetService);
    end;

    FillChar(FWSAQuerySet, SizeOf(WSAQUERYSET), 0);
    with FWSAQuerySet do begin
      dwSize := sizeof(WSAQUERYSET);
      dwNameSpace := NS_BTH;
      dwNumberOfCsAddrs := 1;
      lpBlob := @FBLOB;
    end;

    try
      // Try register service.
      if WSASetService(@FWSAQuerySet, RNRSERVICE_REGISTER, 0) <> 0 then RaiseLastOSError;
    except
      // If something wrong.
      FreeMem(FBTHSetService, FBTHSetServiceSize);
      FManualSDP := False;
      // and re-raise an exception.
      raise;
    end;

  end else begin
    // Lets Windows builds SDP records.
    FManualSDP := False;
    QuerySetSize := SizeOf(WSAQUERYSET);
    FillChar(QuerySet, QuerySetSize, 0);

    with QuerySet do begin
      dwSize := QuerySetSize;
      dwNumberOfCsAddrs := 1;
      dwNameSpace := NS_BTH;
      lpcsaBuffer := @CSAddr;
      lpszServiceInstanceName := PChar(ServiceName);
      lpszComment := PChar(ServiceComment);
      lpServiceClassId := @FBluetoothTransport.FServiceUUID;
    end;

    if WSASetService(@QuerySet, RNRSERVICE_REGISTER, 0) <> 0 then RaiseLastOSError;
  end;
end;

procedure TBFCustomServer.SetActive(const Value: Boolean);
begin
  if Value <> FActive then
    if Value then
      Open
    else
      Close;
end;

procedure TBFCustomServer.SetBluetoothTransport(const Value: TBFBluetoothServerTransport);
begin
end;

procedure TBFCustomServer.SetIrDATransport(const Value: TBFIrDAServerTransport);
begin
end;

procedure TBFCustomServer.SetReadBuffer(const Value: DWORD);
begin
  if Value <> FReadBuffer then begin
    RaiseActive;

    if Value = 0 then raise Exception.Create(StrBufferSizeInvalid);

    FReadBuffer := Value;
  end;
end;

procedure TBFCustomServer.SetTransport(const Value: TBFAPITransport);
begin
  if Value <> FTransport then begin
    RaiseActive;

    if Value = atCOM then raise Exception.Create(StrComPortTransportNotSupported);

    FTransport := Value;
  end;
end;

procedure TBFCustomServer.SetWriteBuffer(const Value: DWORD);
begin
  if Value <> FWriteBuffer then begin
    RaiseActive;

    if Value = 0 then raise Exception.Create(StrBufferSizeInvalid);

    FWriteBuffer := Value;
  end;
end;

procedure TBFCustomServer.UnregisterBluetoothServiceMS;
var
  Addr: SOCKADDR_BTH;
  AddrSize: Integer;
  CSAddr: CSADDR_INFO;
  QuerySet: WSAQUERYSET;
  QuerySetSize: DWORD;
  ServiceName: string;
  ServiceComment: string;
begin
  // Unregister service.
  if FManualSDP then begin
    WSASetService(@FWSAQuerySet, RNRSERVICE_DELETE, 0);
    FManualSDP := False;
    FillChar(FWSAQuerySet, SizeOf(WSAQUERYSET), 0);
    FreeMem(FBTHSetService);
    FBTHSetService := nil;
    FBTHSetServiceSize := 0;
    FHandle := 0;
    FSDPVersion := 1;
    FillChar(FBLOB, SizeOf(BLOB), 0);

  end else begin
    AddrSize := SizeOf(SOCKADDR_BTH);
    if getsockname(FServerSocket, @Addr, AddrSize) <> 0 then RaiseLastOSError;
    FillChar(CSAddr, SizeOf(CSADDR_INFO), 0);
    with CSAddr do begin
      with LocalAddr do begin
        iSockaddrLength := SizeOf(SOCKADDR_BTH);
        lpSockaddr := @Addr;
      end;
      iSocketType := SOCK_STREAM;
      iProtocol := BTHPROTO_RFCOMM;
    end;

    // Temprorary variables.
    ServiceComment := 'Bluetooth Framework ' + FBluetoothTransport.Service;
    ServiceName := FBluetoothTransport.Service;

    QuerySetSize := SizeOf(WSAQUERYSET);
    FillChar(QuerySet, QuerySetSize, 0);

    with QuerySet do begin
      dwSize := QuerySetSize;
      dwNumberOfCsAddrs := 1;
      dwNameSpace := NS_BTH;
      lpcsaBuffer := @CSAddr;
      lpszServiceInstanceName := PChar(ServiceName);
      lpszComment := PChar(ServiceComment);
      lpServiceClassId := @FBluetoothTransport.FServiceUUID;
    end;

    WSASetService(@QuerySet, RNRSERVICE_DELETE, 0);
  end;
end;

procedure TBFCustomServer.Write(Data: TBFByteArray);
begin
  RaiseNotConnected;

  {$IFDEF TRIAL}
  // 20mb
  if TotalSended > 20971520 then begin
    ShowMessage('Demo version can not send more then 20Mb of data.' + CRLF +
                'To obtain a full version visit http://www.btframework.com/order.htm');
    Exit;
  end;
  {$ENDIF}

  // Checks the transport.
  case FTransport of
    atBluetooth: WriteBluetooth(Data);
    atIrDA: WriteIrDA(Data);
  end;

  {$IFDEF TRIAL}
  Inc(TotalSended, Length(Data));
  {$ENDIF}
end;

procedure TBFCustomServer.WriteBluetooth(Data: TBFByteArray);
begin
  // Checks API
  case FBluetoothTransport.FRadio.BluetoothAPI of
    baBlueSoleil: WriteCOM(Data);
    baWinSock: WriteWinSock(Data);
    baWidComm: WriteWD(Data);
  end;
end;

procedure TBFCustomServer.WriteCOM(Data: TBFByteArray);
var
  Sended: DWORD;
  Error: DWORD;
begin
  if not WriteFile(FServerSocket, PChar(Data)^, Length(Data), Sended, @FOverlapped) then begin
    Error := GetLastError;

    if Error <> ERROR_IO_PENDING then begin
      SetLastError(Error);
      RaiseLastOSError;
    end;

    EscapeCommFunction(FHandle, CLRRTS);
    EscapeCommFunction(FHandle, SETRTS);
  end;
end;

procedure TBFCustomServer.WriteIrDA(Data: TBFByteArray);
begin
  WriteWinSock(Data);
end;

procedure TBFCustomServer.WriteWD(Data: TBFByteArray);
var
  Sended: Word;
  TmpBuf: TBFByteArray;
begin
  SetLength(TmpBuf, 0);

  Sended := 0;
  TmpBuf := Data;
  while Sended < Length(TmpBuf) do begin
    if not WD_Write(FHandle, Pointer(TmpBuf), Length(TmpBuf), Sended) then RaiseLastOSError;

    if Sended < Length(TmpBuf) then TmpBuf := Copy(TmpBuf, Sended, Length(TmpBuf) - Sended);
  end;
end;

procedure TBFCustomServer.WriteWinSock(Data: TBFByteArray);
var
  Sended: Integer;
  TmpBuf: TBFByteArray;
begin
  SetLength(TmpBuf, 0);

  Sended := 0;
  TmpBuf := Data;
  while Sended < Length(TmpBuf) do begin
    Sended := send(FThread.FListenSocket, PChar(TmpBuf)^, Length(TmpBuf), 0);

    if Sended = SOCKET_ERROR then RaiseLastOSError;

    if Sended < Length(TmpBuf) then TmpBuf := Copy(TmpBuf, Sended, Length(TmpBuf) - Sended);
  end;
end;

{ TBFCustomServerX }

procedure _TBFCustomServerX.Close;
begin
  TBFCustomServer(FBFCustomServer).Close;
end;

constructor _TBFCustomServerX.Create(AOwner: TComponent);
begin
  inherited;

  FBFCustomServer := GetComponentClass.Create(nil);
end;

destructor _TBFCustomServerX.Destroy;
begin
  FBFCustomServer.Free;
  
  inherited;
end;

function _TBFCustomServerX.GetActive: Boolean;
begin
  Result := TBFCustomServer(FBFCustomServer).Active;
end;

function _TBFCustomServerX.GetBluetoothTransport: TBFBluetoothServerTransport;
begin
  Result := TBFCustomServer(FBFCustomServer).BluetoothTransport;
end;

function _TBFCustomServerX.GetConnected: Boolean;
begin
  Result := TBFCustomServer(FBFCustomServer).Connected;
end;

function _TBFCustomServerX.GetIrDATransport: TBFIrDAServerTransport;
begin
  Result := TBFCustomServer(FBFCustomServer).IrDATransport;
end;

function _TBFCustomServerX.GetOnConnect: TBFServerEvent;
begin
  Result := TBFCustomServer(FBFCustomServer).OnConnect;
end;

function _TBFCustomServerX.GetOnDisconnect: TBFServerEvent;
begin
  Result := TBFCustomServer(FBFCustomServer).OnDisconnect;
end;

function _TBFCustomServerX.GetReadBuffer: DWORD;
begin
  Result := TBFCustomServer(FBFCustomServer).ReadBuffer;
end;

function _TBFCustomServerX.GetRemoteAddress: string;
begin
  Result := TBFCustomServer(FBFCustomServer).RemoteAddress;
end;

function _TBFCustomServerX.GetRemoteName: string;
begin
  Result := TBFCustomServer(FBFCustomServer).RemoteName;
end;

function _TBFCustomServerX.GetTransport: TBFAPITransport;
begin
  Result := TBFCustomServer(FBFCustomServer).Transport;
end;

function _TBFCustomServerX.GetWriteBuffer: DWORD;
begin
  Result := TBFCustomServer(FBFCustomServer).WriteBuffer;
end;

procedure _TBFCustomServerX.Open;
begin
  TBFCustomServer(FBFCustomServer).Open;
end;

procedure _TBFCustomServerX.SetActive(const Value: Boolean);
begin
  TBFCustomServer(FBFCustomServer).Active := Value;
end;

procedure _TBFCustomServerX.SetBluetoothTransport(const Value: TBFBluetoothServerTransport);
begin
  TBFCustomServer(FBFCustomServer).BluetoothTransport := Value;
end;

procedure _TBFCustomServerX.SetIrDATransport(const Value: TBFIrDAServerTransport);
begin
  TBFCustomServer(FBFCustomServer).IrDATransport := Value;
end;

procedure _TBFCustomServerX.SetOnConnect(const Value: TBFServerEvent);
begin
  TBFCustomServer(FBFCustomServer).OnConnect := Value;
end;

procedure _TBFCustomServerX.SetOnDisconnect(const Value: TBFServerEvent);
begin
  TBFCustomServer(FBFCustomServer).OnDisconnect := Value;
end;

procedure _TBFCustomServerX.SetReadBuffer(const Value: DWORD);
begin
  TBFCustomServer(FBFCustomServer).ReadBuffer := Value;
end;

procedure _TBFCustomServerX.SetTransport(const Value: TBFAPITransport);
begin
  TBFCustomServer(FBFCustomServer).Transport := Value;
end;

procedure _TBFCustomServerX.SetWriteBuffer(const Value: DWORD);
begin
  TBFCustomServer(FBFCustomServer).WriteBuffer := Value;
end;

initialization
  InitializeCriticalSection(IVTCriticalSection);
  IVTServers := TObjectList.Create(False);

finalization
  IVTServers.Free;
  DeleteCriticalSection(IVTCriticalSection);

end.
