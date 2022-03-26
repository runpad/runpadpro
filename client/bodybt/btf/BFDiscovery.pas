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
unit BFDiscovery;

{$I BF.inc}

interface

uses
  BFBase, Contnrs, Windows, BFAPI, Classes, Messages, CommCtrl;

type
  // Representation of the Bluetooth service.
  TBFBluetoothService = class(TBFBaseClass)
  private
    FChannel: Byte;
    FComment: string;
    FName: string;
    FUUID: TGUID;
    FUUID16: Word;

    procedure ClearFields;

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFBluetoothService to another.
    procedure Assign(AService: TBFBluetoothService);

    // Channel number.
    property Channel: Byte read FChannel;
    // The service's comment.
    property Comment: string read FComment;
    // The service's name.
    property Name: string read FName;
    // The service's UUID.
    property UUID: TGUID read FUUID;
    // The service's short UUID.
    property UUID16: Word read FUUID16;
  end;

  // The List of a Bluetooth services.
  TBFBluetoothServices = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetService(const Index: Integer): TBFBluetoothService;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFBluetoothServiceList to another.
    procedure Assign(AList: TBFBluetoothServices);

    // Items coun in the list.
    property Count: Integer read GetCount;
    // Services zero based array.
    property Service[const Index: Integer]: TBFBluetoothService read GetService; default;
  end;

  TBFBluetoothRadio = class;

  // Represents Bluetooth device.
  TBFBluetoothDevice = class(TBFBaseClass)
  private
    FAddress: string;
    FAuthenticated: Boolean;
    FBTAddress: BTH_ADDR;
    FConnected: Boolean;
    FClassOfDevice: DWORD;
    FLastSeen: TDateTime;
    FLastUsed: TDateTime;
    FName: string;
    FRadio: TBFBluetoothRadio;
    FRemembered: Boolean;
    FServices: TBFBluetoothServices;

    function GetClassOfDeviceName: string;
    function GetName: string;

    procedure ClearFields;
    procedure SetName(const Value: string);
    procedure SetRadio(const Value: TBFBluetoothRadio);

  public
    // Default constructor.
    constructor Create(ARadio: TBFBluetoothRadio);
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFBluetoothDevice to another.
    procedure Assign(ADevice: TBFBluetoothDevice);
    // This procedure pairs device.
    procedure Pair(PassKey: string);
    // This procedure unpair device.
    procedure Unpair;

    // The device's address in string representation.
    property Address: string read FAddress;
    // Returns True if device already authenticated by the system.
    property Authenticated: Boolean read FAuthenticated;
    // The device's address.
    property BTAddress: BTH_ADDR read FBTAddress;
    // Returns True if device connected.
    property Connected: Boolean read FConnected;
    // Class Of Device (COD).
    property ClassOfDevice: DWORD read FClassOfDevice;
    // Returns decoded name of the device COD.
    property ClassOfDeviceName: string read GetClassOfDeviceName;
    // Returns date and time when device was last seen. May be 0.
    property LastSeen: TDateTime read FLastSeen;
    // Returns date and tiem when device was last used. May be 0.
    property LastUsed: TDateTime read FLastUsed;
    // The device's name.
    // To update MS cash about device write new device name.
    property Name: string read GetName write SetName;
    // Radio where device found.
    property Radio: TBFBluetoothRadio read FRadio write SetRadio;
    // Returns True if device remembered by the system.
    property Remembered: Boolean read FRemembered;
    // Returns services list which supported by the device.
    property Services: TBFBluetoothServices read FServices;
  end;

  // Represents the Bluetooth devices list.
  TBFBluetoothDevices = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetDevice(const Index: Integer): TBFBluetoothDevice;
    function IndexOf(Addr: BTH_ADDR): Integer;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFBluetoothDevices to another.
    procedure Assign(AList: TBFBluetoothDevices);

    // Numbers of the devices in the list.
    property Count: Integer read GetCount;
    // The devices zero based array.
    property Device[const Index: Integer]: TBFBluetoothDevice read GetDevice; default;
  end;

  // Represents the vitual COM port associated with the Bluetooth connection.
  TBFCOMPort = class(TBFBaseClass)
  private
    FNumber: Byte;
    FName: string;

    procedure ClearFields;

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFBluetoothCOMPort to another.
    procedure Assign(Port: TBFCOMPort);

    // The COM port's number.
    property Number: Byte read FNumber;
    // The COM port's name (such as COM1, COM2 etc.).
    property Name: string read FName;
  end;

  // The virtual Bluetooth COM ports list.
  TBFCOMPorts = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetPort(const Index: Integer): TBFCOMPort;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFCOMPorts to another.
    procedure Assign(AList: TBFCOMPorts);

    // Numbers of COM ports in the list.
    property Count: Integer read GetCount;
    // The COM ports zero based array.
    property Port[const Index: Integer]: TBFCOMPort read GetPort; default;
  end;

  // Represents the Bluetooth local radio device.
  TBFBluetoothRadio = class(TBFBaseClass)
  private
    FAddress: string;
    FBluetoothAPI: TBFBluetoothAPI;
    FBTAddress: BTH_ADDR;
    FClassOfDevice: DWORD;
    FManufacturer: Word;
    FName: string;
    FSubversion: Word;

    function GetClassOfDeviceName: string;
    function GetConnectable: Boolean;
    function GetDiscoverable: Boolean;
    function GetFullName: string;
    function GetRadioHandle: THandle;
    function GetVersion: string;

    procedure ClearFields;
    procedure SetDiscoverable(const Value: Boolean);
    procedure SetConnectable(const Value: Boolean);
    procedure SetName(const Value: string);

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFBluetoothRadio to another.
    procedure Assign(ARadio: TBFBluetoothRadio);

    // The radio's address in string representation.
    property Address: string read FAddress;
    // The BluetoothAPI used by this radio.
    property BluetoothAPI: TBFBluetoothAPI read FBluetoothAPI;
    // The radio's address.
    property BTAddress: BTH_ADDR read FBTAddress;
    // The radio's class of device.
    property ClassOfDevice: DWORD read FClassOfDevice;
    // The radios' class of device in string representation.
    property ClassOfDeviceName: string read GetClassOfDeviceName;
    // Returns true if device in connactable mode.
    property Connectable: Boolean read GetConnectable write SetConnectable;
    // Returns true if device in discoverable mode. Set to true to
    // set device into discoverable mode, set to false to turn discoverable
    // mode off.
    property Discoverable: Boolean read GetDiscoverable write SetDiscoverable;
    // Full name including API, Address and name
    property FullName: string read GetFullName;
    // The radio's manufacturer code.
    property Manufacturer: Word read FManufacturer;
    // The radio's name.
    property Name: string read FName write SetName;
    // The radio's LMP subversion.
    property Subversion: Word read FSubversion;
    // Returns API version
    property Version: string read GetVersion;
  end;

  // Represents the local Bluetooth radios list.
  TBFBluetoothRadios = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetRadio(const Index: Integer): TBFBluetoothRadio;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFBluetoothRadios to another.
    procedure Assign(AList: TBFBluetoothRadios);

    // Numbers of radios in the list.
    property Count: Integer read GetCount;
    // The radios zero based array.
    property Radio[const Index: Integer]: TBFBluetoothRadio read GetRadio; default;
  end;

  // Represents the IrDA device
  TBFIrDADevice = class(TBFBaseClass)
  private
    FAddress: string;
    FCharSet: Byte;
    FHints1: Byte;
    FHints2: Byte;
    FIrDAAddress: IRDA_ADDR;
    FName: string;

    {$IFDEF BCB}
    function GetIrDAAddress: Integer;
    {$ENDIF}
    function GetName: string;

    procedure ClearFields;

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFIrDADevice to another.
    procedure Assign(ADevice: TBFIrDADevice);

    // The device's address in string representation.
    property Address: string read FAddress;
    // The device's char set.
    property CharSet: Byte read FCharSet;
    // The device's hints 1.
    property Hints1: Byte read FHints1;
    // The device's hints 2.
    property Hints2: Byte read FHints2;
    // The device's address.
    {$IFDEF BCB}
    property IrDAAddress: Integer read GetIrDAAddress;
    {$ELSE}
    property IrDAAddress: IRDA_ADDR read FIrDAAddress;
    {$ENDIF}
    // The device's name.
    property Name: string read GetName;
  end;

  // Representation of the IrDA devices list.
  TBFIrDADevices = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetDevice(const Index: Integer): TBFIrDADevice;
    function IndexOf(Addr: IRDA_ADDR): Integer;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFIrDADevices to another.
    procedure Assign(AList: TBFIrDADevices);

    // Numbers of devices in the list.
    property Count: Integer read GetCount;
    // The devices zero based array.
    property Device[const Index: Integer]: TBFIrDADevice read GetDevice; default;
  end;

  // Shared events prototype for TBFxxxDiscovery components.
  TBFDiscoveryEvent = procedure(Sender: TObject) of object;
  // Events prototype for Bluetooth device monitoring.
  TBFBluetoothDeviceMonitoringEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice) of object;
  // Event prototype for device discovery complete.
  TBFBluetoothDiscoveryComplete = procedure(Sender: TObject; Devices: TBFBluetoothDevices) of object;

  // Forward declaration.
  TBFBluetoothMonitoringThread = class;

  // The TBFBluetoothDiscovery component allows you to discovery Bluetooth
  // devices.
  TBFBluetoothDiscovery = class(TBFBaseComponent)
  private
    FDelay: Integer;
    FNonBlocking: Boolean;
    FThread: TBFBluetoothMonitoringThread;

    FOnComplete: TBFBluetoothDiscoveryComplete;
    FOnDeviceFound: TBFBluetoothDeviceMonitoringEvent;
    FOnDeviceLost: TBFBluetoothDeviceMonitoringEvent;
    FOnStartMonitoring: TBFDiscoveryEvent;
    FOnStartSearch: TBFDiscoveryEvent;
    FOnStopMonitoring: TBFDiscoveryEvent;
    FOnStopSearch: TBFDiscoveryEvent;

    function GetMonitoring: Boolean;

    procedure BFNMBluetoothDiscoveryEvent(var Message: TMessage); message BFNM_BLUETOOTH_DISCOVERY_EVENT;
    procedure BFNMDiscoveryCompleteEvent(var Message: TMessage); message BFNM_DISCOVERY_COMPLETE_EVENT;
    procedure DoDeviceFound(ADevice: TBFBluetoothDevice);
    procedure DoDeviceLost(ADevice: TBFBluetoothDevice);
    procedure DoDiscoveryBegin;
    procedure DoDiscoveryEnd;
    procedure DoSearchBegin;
    procedure DoSerachEnd;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Returne True if device availale
    function CheckDevice(const Address: string): Boolean;
    // Discovers devices and returns TBFBluetoothDevices list. If Fast set to
    // True then function returns only remembered devices. Otherwise it
    // make complete search of the Bluetooth devices. Can return nil.
    // Application should dispose returned object.
    // Need Services - if True then discovery services.
    function Discovery(Radio: TBFBluetoothRadio; Fast: Boolean; NeedServices: Boolean = True; Blocking: Boolean = True): TBFBluetoothDevices;
    // Returns list of the virtual Bluetooth COM ports. Can return nil.
    // Application should dispose returned object.
    function EnumCOMPorts: TBFCOMPorts;
    // Returns list of the local Bluetooth radios. Can return nil.
    // Application should dispose returned object.
    function EnumRadios: TBFBluetoothRadios;
    // Shows "Select Bluetooth Device" dialog. If user select device then
    // returns instance of the TBFBluetoothDevice class which describes selected
    // device. Otherwise returns nil. If Fast set to True then function returns
    // only remembered devices. Otherwise it make complete search of the
    // Bluetooth devices. Application should dispose returned object.
    function SelectDevice(Fast: Boolean): TBFBluetoothDevice;

    // Starts devices monitoring.
    procedure StartMonitoring(Radio: TBFBluetoothRadio; AlwaysNew: Boolean = False; NeedServices: Boolean = True);
    // Stops devices monitoring.
    procedure StopMonitoring;

    // Sets to True for start devices monitoring. Sets to False for stop devices
    // monitoring. Returns True if monitoring active otherwise returns false.
    property Monitoring: Boolean read GetMonitoring;

  published
    // Monitoring delay in milliseconds. This is delay between each monitoring
    // loop.
    property Delay: Integer read FDelay write FDelay default 1000;

    // Event occurs when non-blocking discovery complete.
    property OnComplete: TBFBluetoothDiscoveryComplete read FOnComplete write FOnComplete;
    // Event occures when new device found.
    property OnDeviceFound: TBFBluetoothDeviceMonitoringEvent read FOnDeviceFound write FOnDeviceFound;
    // Event occures when old device lost.
    property OnDeviceLost: TBFBluetoothDeviceMonitoringEvent read FOnDeviceLost write FOnDeviceLost;
    // Event occures when monitoring process started.
    property OnStartMonitoring: TBFDiscoveryEvent read FOnStartMonitoring write FOnStartMonitoring;
    // Event occures when the sarching loop begans.
    property OnStartSearch: TBFDiscoveryEvent  read FOnStartSearch write FOnStartSearch;
    // Event occures when monitoring process finished.
    property OnStopMonitoring: TBFDiscoveryEvent read FOnStopMonitoring write FOnStopMonitoring;
    // Event occures when the sarching loop complete.
    property OnStopSearch: TBFDiscoveryEvent  read FOnStopSearch write FOnStopSearch;
  end;

  // Bluetooth devices monitoring thread.
  TBFBluetoothMonitoringThread = class(TBFBaseThread)
  private
    FAlwaysNew: Boolean;
    FDiscovery: TBFBluetoothDiscovery;
    FNeedServices: Boolean;
    FRadio: TBFBluetoothRadio;

  protected
    procedure Execute; override;

  public
    constructor Create(ARadio: TBFBluetoothRadio; ADiscovery: TBFBluetoothDiscovery; AAlwaysNew: Boolean; ANeedServices: Boolean);
    destructor Destroy; override;
  end;

  // Events prototype for IrDA device monitoring.
  TBFIrDADeviceMonitoringEvent = procedure(Sender: TObject; Device: TBFIrDADevice) of object;
  // Event prototype for device discovery complete.
  TBFIrDADiscoveryComplete = procedure(Sender: TObject; Devices: TBFIrDADevices) of object;

  // Forward declaration.
  TBFIrDAMonitoringThread = class;

  // The TBFIrDADiscovery component allows you to discovery IrDA devices.
  TBFIrDADiscovery = class(TBFBaseComponent)
  private
    FDelay: Integer;
    FNonBlocking: Boolean;
    FThread: TBFIrDAMonitoringThread;

    FOnComplete: TBFIrDADiscoveryComplete;
    FOnDeviceFound: TBFIrDADeviceMonitoringEvent;
    FOnDeviceLost: TBFIrDADeviceMonitoringEvent;
    FOnStartMonitoring: TBFDiscoveryEvent;
    FOnStartSearch: TBFDiscoveryEvent;
    FOnStopMonitoring: TBFDiscoveryEvent;
    FOnStopSearch: TBFDiscoveryEvent;

    function GetMonitoring: Boolean;

    procedure BFNMDiscoveryCompleteEvent(var Message: TMessage); message BFNM_DISCOVERY_COMPLETE_EVENT;
    procedure BFNMIrDADiscoveryEvent(var Message: TMessage); message BFNM_IRDA_DISCOVERY_EVENT;
    procedure DoDeviceFound(ADevice: TBFIrDADevice);
    procedure DoDeviceLost(ADevice: TBFIrDADevice);
    procedure DoDiscoveryBegin;
    procedure DoDiscoveryEnd;
    procedure DoSearchBegin;
    procedure DoSerachEnd;
    procedure SetMonitoring(const Value: Boolean);

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Discovers devices and returns TBFIrDADevices list. Can return nil.
    // Application should dispose returned object.
    function Discovery(Blocking: Boolean = True): TBFIrDADevices;
    // Shows "Select IrDA Device" dialog. If user select device then
    // returns instance of the TBFIrDADevice class which describes selected
    // device. Otherwise returns nil. Application should dispose returned
    // object.
    function SelectDevice: TBFIrDADevice;

    // Starts devices monitoring.
    procedure StartMonitoring(AlwaysNew: Boolean = False);
    // Stops devices monitoring.
    procedure StopMonitoring;

    // Sets to True for start devices monitoring. Sets to False for stop devices
    // monitoring. Returns True if monitoring active otherwise returns false.
    property Monitoring: Boolean read GetMonitoring write SetMonitoring;

  published
    // Monitoring delay in milliseconds. This is delay between each monitoring
    // loop.
    property Delay: Integer read FDelay write FDelay default 1000;

    // Event occurs when non-blocking discovery complete.
    property OnComplete: TBFIrDADiscoveryComplete read FOnComplete write FOnComplete;
    // Event occures when new device found.
    property OnDeviceFound: TBFIrDADeviceMonitoringEvent read FOnDeviceFound write FOnDeviceFound;
    // Event occures when old device lost.
    property OnDeviceLost: TBFIrDADeviceMonitoringEvent read FOnDeviceLost write FOnDeviceLost;
    // Event occures when monitoring process started.
    property OnStartMonitoring: TBFDiscoveryEvent read FOnStartMonitoring write FOnStartMonitoring;
    // Event occures when the sarching loop begans.
    property OnStartSearch: TBFDiscoveryEvent  read FOnStartSearch write FOnStartSearch;
    // Event occures when monitoring process finished.
    property OnStopMonitoring: TBFDiscoveryEvent read FOnStopMonitoring write FOnStopMonitoring;
    // Event occures when the sarching loop complete.
    property OnStopSearch: TBFDiscoveryEvent  read FOnStopSearch write FOnStopSearch;
  end;

  // IrDA devices monitoring thread.
  TBFIrDAMonitoringThread = class(TBFBaseThread)
  private
    FAlwaysNew: Boolean;
    FDiscovery: TBFIrDADiscovery;

  protected
    procedure Execute; override;

  public
    constructor Create(Discovery: TBFIrDADiscovery; AAlwaysNew: Boolean);
  end;

  _TBFBluetoothDiscoveryX = class(_TBFActiveXControl)
  private
    FBFBluetoothDiscovery: TBFBluetoothDiscovery;

    function GetDelay: Integer;
    function GetMonitoring: Boolean;
    function GetOnComplete: TBFBluetoothDiscoveryComplete;
    function GetOnDeviceFound: TBFBluetoothDeviceMonitoringEvent;
    function GetOnDeviceLost: TBFBluetoothDeviceMonitoringEvent;
    function GetOnStartMonitoring: TBFDiscoveryEvent;
    function GetOnStartSearch: TBFDiscoveryEvent;
    function GetOnStopMonitoring: TBFDiscoveryEvent;
    function GetOnStopSearch: TBFDiscoveryEvent;

    procedure SetDelay(const Value: Integer);
    procedure SetOnComplete(const Value: TBFBluetoothDiscoveryComplete);
    procedure SetOnDeviceFound(const Value: TBFBluetoothDeviceMonitoringEvent);
    procedure SetOnDeviceLost(const Value: TBFBluetoothDeviceMonitoringEvent);
    procedure SetOnStartMonitoring(const Value: TBFDiscoveryEvent);
    procedure SetOnStartSearch(const Value: TBFDiscoveryEvent);
    procedure SetOnStopMonitoring(const Value: TBFDiscoveryEvent);
    procedure SetOnStopSearch(const Value: TBFDiscoveryEvent);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CheckDevice(const Address: string): Boolean;
    function Discovery(Radio: TBFBluetoothRadio; Fast: Boolean; NeedServices: Boolean = True; Blocking: Boolean = True): TBFBluetoothDevices;
    function EnumCOMPorts: TBFCOMPorts;
    function EnumRadios: TBFBluetoothRadios;
    function SelectDevice(Fast: Boolean): TBFBluetoothDevice;

    procedure StartMonitoring(Radio: TBFBluetoothRadio; AlwaysNew: Boolean = False; NeedServices: Boolean = True);
    procedure StopMonitoring;

    property Monitoring: Boolean read GetMonitoring;

  published
    property Delay: Integer read GetDelay write SetDelay;

    property OnComplete: TBFBluetoothDiscoveryComplete read GetOnComplete write SetOnComplete;
    property OnDeviceFound: TBFBluetoothDeviceMonitoringEvent read GetOnDeviceFound write SetOnDeviceFound;
    property OnDeviceLost: TBFBluetoothDeviceMonitoringEvent read GetOnDeviceLost write SetOnDeviceLost;
    property OnStartMonitoring: TBFDiscoveryEvent read GetOnStartMonitoring write SetOnStartMonitoring;
    property OnStartSearch: TBFDiscoveryEvent  read GetOnStartSearch write SetOnStartSearch;
    property OnStopMonitoring: TBFDiscoveryEvent read GetOnStopMonitoring write SetOnStopMonitoring;
    property OnStopSearch: TBFDiscoveryEvent  read GetOnStopSearch write SetOnStopSearch;
  end;

  _TBFIrDADiscoveryX = class(_TBFActiveXControl)
  private
    FBFIrDADiscovery: TBFIrDADiscovery;

    function GetDelay: Integer;
    function GetMonitoring: Boolean;
    function GetOnComplete: TBFIrDADiscoveryComplete;
    function GetOnDeviceFound: TBFIrDADeviceMonitoringEvent;
    function GetOnDeviceLost: TBFIrDADeviceMonitoringEvent;
    function GetOnStartMonitoring: TBFDiscoveryEvent;
    function GetOnStartSearch: TBFDiscoveryEvent;
    function GetOnStopMonitoring: TBFDiscoveryEvent;
    function GetOnStopSearch: TBFDiscoveryEvent;

    procedure SetDelay(const Value: Integer);
    procedure SetMonitoring(const Value: Boolean);
    procedure SetOnComplete(const Value: TBFIrDADiscoveryComplete);
    procedure SetOnDeviceFound(const Value: TBFIrDADeviceMonitoringEvent);
    procedure SetOnDeviceLost(const Value: TBFIrDADeviceMonitoringEvent);
    procedure SetOnStartMonitoring(const Value: TBFDiscoveryEvent);
    procedure SetOnStartSearch(const Value: TBFDiscoveryEvent);
    procedure SetOnStopMonitoring(const Value: TBFDiscoveryEvent);
    procedure SetOnStopSearch(const Value: TBFDiscoveryEvent);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Discovery(Blocking: Boolean = True): TBFIrDADevices;
    function SelectDevice: TBFIrDADevice;

    procedure StartMonitoring(AlwaysNew: Boolean = False);
    procedure StopMonitoring;

    property Monitoring: Boolean read GetMonitoring write SetMonitoring;

  published
    property Delay: Integer read GetDelay write SetDelay;

    property OnComplete: TBFIrDADiscoveryComplete read GetOnComplete write SetOnComplete;
    property OnDeviceFound: TBFIrDADeviceMonitoringEvent read GetOnDeviceFound write SetOnDeviceFound;
    property OnDeviceLost: TBFIrDADeviceMonitoringEvent read GetOnDeviceLost write SetOnDeviceLost;
    property OnStartMonitoring: TBFDiscoveryEvent read GetOnStartMonitoring write SetOnStartMonitoring;
    property OnStartSearch: TBFDiscoveryEvent  read GetOnStartSearch write SetOnStartSearch;
    property OnStopMonitoring: TBFDiscoveryEvent read GetOnStopMonitoring write SetOnStopMonitoring;
    property OnStopSearch: TBFDiscoveryEvent  read GetOnStopSearch write SetOnStopSearch;
  end;

function EnumServices(const Address: string; const Fast: Boolean; Radio: TBFBluetoothRadio): TBFBluetoothServices;
function GetFirstRadio: TBFBluetoothRadio;

implementation

uses
  BFSDPParser, ActiveX, SysUtils, Registry, BFSelectBluetoothDevice, Forms,
  BFClient, Controls, BFSelectIrDADevice, BFD5Support,
  BFStrings{$IFDEF DELPHI5}, ComObj, ComCtrls, BFClients{$ENDIF};

type
  TBFToshibaSupport = class(TBFBaseClass)
  private
    FWnd: THandle;

    procedure WndProc(var Message: TMessage);

  public
    constructor Create;
    destructor Destroy; override;
  end;

  procedure TBFToshibaSupport.WndProc(var Message: TMessage);
  begin
    with Message do
      if (Msg >= BFNM_MIN_NUMBER) and (Msg <= BFNM_MAX_NUMBER) then
        try
          Dispatch(Message);

        except
          {$IFDEF DELPHI5}
          Application.HandleException(nil);
          {$ELSE}
          if Assigned(ApplicationHandleException) then ApplicationHandleException(Self);
          {$ENDIF}
        end

      else
        Result := DefWindowProc(FWnd, Msg, WParam, LParam);
  end;

  constructor TBFToshibaSupport.Create;
  begin
    FWnd := {$IFNDEF DELPHI5}Classes.{$ENDIF}AllocateHWnd(WndProc);
  end;

  destructor TBFToshibaSupport.Destroy;
  begin
    {$IFNDEF DELPHI5}Classes.{$ENDIF}DeallocateHWnd(FWnd);

    inherited;
  end;

function EnumServices(const Address: string; const Fast: Boolean; Radio: TBFBluetoothRadio): TBFBluetoothServices;
var
  NoRadio: Boolean;

  function EnumServicesMS: TBFBluetoothServices;
  var
    ServiceQuerySet: WSAQUERYSET;
    ServiceQuerySetSize: DWORD;
    Protocol: TGUID;
    ServiceFlags: DWORD;
    ServiceBuffer: Pointer;
    ServiceBufferSize: DWORD;
    ServiceResults: LPWSAQUERYSET;
    AService: TBFBluetoothService;
    ResService: DWORD;
    LookupService: THandle;
    AData: TBFByteArray;
    Parser: TBFSDPParser;
    Records: TBFSDPServiceRecords;
    ARecord: TBFSDPServiceRecord;
    Attribute: TBFSDPAttribute;
    Element: TBFSDPElement;
    IsUnicode: Boolean;
    Wide: WideString;
    Found: Boolean;
    Loop: Integer;
    AWord: Word;

  begin
    ServiceBufferSize := 6144;
    GetMem(ServiceBuffer, ServiceBufferSize);

    Result := TBFBluetoothServices.Create;

    try
      ServiceQuerySetSize := SizeOf(WSAQUERYSET);
      FillChar(ServiceQuerySet, ServiceQuerySetSize, 0);
      Protocol := L2CAP_PROTOCOL_UUID;

      with ServiceQuerySet do begin
        dwSize := ServiceQuerySetSize;
        lpServiceClassId := @Protocol;
        dwNameSpace := NS_BTH;
        lpszContext := PChar(Address);
      end;

      ServiceFlags := LUP_RES_SERVICE or LUP_RETURN_NAME or LUP_RETURN_TYPE or LUP_RETURN_ADDR or LUP_RETURN_COMMENT or LUP_RETURN_BLOB;
      if not Fast then ServiceFlags := ServiceFlags or LUP_FLUSHCACHE;

      // Loock services
      ResService := WSALookupServiceBegin(@ServiceQuerySet, ServiceFlags, LookupService);
      if ResService = 0 then begin
        while ResService = 0 do begin
          FillChar(ServiceBuffer^, ServiceBufferSize, 0);
          ServiceResults := LPWSAQUERYSET(ServiceBuffer);

          ResService := WSALookupServiceNext(LookupService, ServiceFlags, ServiceBufferSize, ServiceResults);

          if ResService = 0 then
            if Assigned(ServiceResults^.lpBlob) then
              if Assigned(ServiceResults^.lpBlob^.pBlobData) then begin
                SetLength(AData, ServiceResults^.lpBlob^.cbSize);
                CopyMemory(AData, ServiceResults^.lpBlob^.pBlobData, ServiceResults^.lpBlob^.cbSize);

                Parser := TBFSDPParser.Create(AData);

                Records := Parser.Records;
                if Records.Count > 0 then begin
                  ARecord := Records[0];

                  Attribute := ARecord.Attribute[SDP_ATTRIB_PROFILE_DESCRIPTOR_LIST];
                  Found := Assigned(Attribute);
                  if not Found then Attribute := ARecord.Attribute[SDP_ATTRIB_CLASS_ID_LIST];
                  
                  if Assigned(Attribute) then
                    if Attribute.Elements.Count > 0 then begin
                      AService := TBFBluetoothService.Create;

                      if not Found then begin
                        Element := nil;

                        for Loop := 0 to Attribute.Elements.Count - 1 do begin
                           case Attribute.Elements[Loop].Size of
                             2: AWord := Attribute.Elements[Loop].AsWord;
                             4: AWord := LoWord(Attribute.Elements[Loop].AsDWord);
                           else
                             AWord := Attribute.Elements[Loop].Data[2] * $0100 + Attribute.Elements[Loop].Data[3];
                           end;

                           if AWord <> LoWord(SerialPortServiceClass_UUID.D1) then begin
                             Element := Attribute.Elements[Loop];
                             Break;
                           end;
                        end;

                        if not Assigned(Element) then Element := Attribute.Elements[0];

                      end else
                        Element := Attribute.Elements[0];

                      case Element.Size of
                        2: begin
                             AService.FUUID16 := Element.AsWord;
                             AService.FUUID := BaseBluetoothServiceClassID_UUID;
                             AService.FUUID.D1 := AService.FUUID16;
                           end;
                        4: begin
                             AService.FUUID16 := LoWord(Element.AsDWord);
                             AService.FUUID := BaseBluetoothServiceClassID_UUID;
                             AService.FUUID.D1 := AService.FUUID16;
                           end;

                      else
                        AService.FUUID.D1 := Element.Data[0] * $01000000 + Element.Data[1] * $010000 + Element.Data[2] * $0100 + Element.Data[3];
                        AService.FUUID.D2 := Element.Data[4] * $0100 + Element.Data[5];
                        AService.FUUID.D3 := Element.Data[6] * $0100 + Element.Data[7];
                        AService.FUUID.D4[0] := Element.Data[8];
                        AService.FUUID.D4[1] := Element.Data[9];
                        AService.FUUID.D4[2] := Element.Data[10];
                        AService.FUUID.D4[3] := Element.Data[11];
                        AService.FUUID.D4[4] := Element.Data[12];
                        AService.FUUID.D4[5] := Element.Data[13];
                        AService.FUUID.D4[6] := Element.Data[14];
                        AService.FUUID.D4[7] := Element.Data[15];

                        AService.FUUID16 := LoWord(AService.FUUID.D1);
                      end;

                      Attribute := ARecord.Attribute[SDP_ATTRIB_PROTOCOL_DESCRIPTOR_LIST];
                      if Assigned(Attribute) then
                        if Attribute.Elements.Count > 2 then begin
                          Element := Attribute.Elements[2];
                          AService.FChannel := Element.AsByte;
                        end;

                      IsUnicode := False;
                      Attribute := ARecord.Attribute[SDP_ATTRIB_LANG_BASE_ATTRIB_ID_LIST];
                      if Assigned(Attribute) then
                        if Attribute.Elements.Count > 1 then begin
                          Element := Attribute.Elements[1];
                          IsUnicode := Element.AsWord <> $006A;
                        end;

                      Attribute := ARecord.Attribute[SDP_ATTRIB_SERVICE_NAME];
                      if Assigned(Attribute) then
                        if Attribute.Elements.Count > 0 then begin
                          Element := Attribute.Elements[0];

                          if IsUnicode then begin
                            SetLength(Wide, Round(Element.Size / 2));
                            CopyMemory(Pointer(Wide), Element.Data, Element.Size);
                            AService.FName := string(Wide);

                          end else begin
                            SetLength(AService.FName, Element.Size);
                            CopyMemory(Pointer(AService.FName), Element.Data, Element.Size);
                          end;
                        end;

                      Attribute := ARecord.Attribute[SDP_ATTRIB_SERVICE_DESCRIPTION];
                      if Assigned(Attribute) then
                        if Attribute.Elements.Count > 0 then begin
                          Element := Attribute.Elements[0];

                          if IsUnicode then begin
                            SetLength(Wide, Round(Element.Size / 2));
                            CopyMemory(Pointer(Wide), Element.Data, Element.Size);
                            AService.FComment := string(Wide);

                          end else begin
                            SetLength(AService.FComment, Element.Size);
                            CopyMemory(Pointer(AService.FComment), Element.Data, Element.Size);
                          end;
                        end;

                      Result.FList.Add(AService);
                    end;
                end;

                Parser.Free;
              end;
        end;

        WSALookupServiceEnd(LookupService);
      end;

    finally
      FreeMem(ServiceBuffer);
    end;
  end;

  function EnumServicesWD: TBFBluetoothServices;
  var
    AServices: SERVICE_LIST;
    AService: TBFBluetoothService;
    Loop: Integer;
  begin
    Result := TBFBluetoothServices.Create;

    if WD_Discovery(API.StringToBluetoothAddress(Address), @AServices, False) then
      for Loop := 0 to AServices.dwCount - 1 do begin
        AService := TBFBluetoothService.Create;
        AService.FName := Utf8ToAnsi(string(AServices.Services[Loop].Name));
        AService.FChannel := Lo(LoWord(AServices.Services[Loop].Channel));
        AService.FUUID := AServices.Services[Loop].Uuid;
        AService.FUUID16 := API.UUIDToUUID16(AService.FUUID);

        Result.FList.Add(AService);
      end;
  end;

  function EnumServicesIVT: TBFBluetoothServices;
  var
    ServiceListSize: DWORD;
    ServiceList: array [0..MAX_SERVICES - 1] of GENERAL_SERVICE_INFO;
    Res: DWORD;
    DevInfo: IVTBLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    ServiceCount: DWORD;
    ServiceIndex: Integer;
    AService: TBFBluetoothService;
    ServiceClassLength: DWORD;
    ServiceClassList: array [0..MAX_SERVICES - 1] of SPPEX_SERVICE_INFO;
  begin
    Result := TBFBluetoothServices.Create;

    ServiceListSize := SizeOf(ServiceList);
    FillChar(ServiceList, ServiceListSize, 0);
    ServiceList[0].dwSize := SizeOf(GENERAL_SERVICE_INFO);

    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    DevInfo.dwSize := DevInfoSize;
    DevInfo.address := API.StringToBluetoothAddress(Address);

    Res := BT_BrowseServices(@DevInfo, True, @ServiceListSize, ServiceList[0]);
    if Res = BTSTATUS_SUCCESS then begin
      ServiceCount := Round(ServiceListSize / SizeOf(GENERAL_SERVICE_INFO));
      for ServiceIndex := 0 to ServiceCount - 1 do begin
        ServiceClassLength := SizeOf(ServiceClassList);
        FillChar(ServiceClassList, ServiceClassLength, 0);

        with ServiceClassList[0] do begin
          dwSize := SizeOf(SPPEX_SERVICE_INFO);
          serviceClassUuid128 := API.UUID16ToUUID(ServiceList[ServiceIndex].wServiceClassUuid16);
        end;

        Res := BT_SearchSPPExServices(@DevInfo, ServiceClassLength, @ServiceClassList);
        if Res = BTSTATUS_SUCCESS then begin
          AService := TBFBluetoothService.Create;
          
          with AService do begin
            FUUID := API.UUID16ToUUID(ServiceList[ServiceIndex].wServiceClassUuid16);
            FUUID16 := ServiceList[ServiceIndex].wServiceClassUuid16;
            FName := string(ServiceList[ServiceIndex].szServiceName);
            FChannel := ServiceClassList[0].ucServiceChannel;
          end;

          Result.FList.Add(AService);
        end;
      end;
    end;
  end;

  function EnumServicesTos: TBFBluetoothServices;
  var
    AService: TBFBluetoothService;
    Adr: TBluetoothAddress;
    CID: Word;
    TosSupp: TBFToshibaSupport;
    Status: Long;
    UUIDList: BTUUIDLIST;
    Size: DWORD;
    Pattern: PBYTE;
    SSAResult: PBTSDPSSARESULT;
    AttrSize: DWORD;
    Attr: PBYTE;
    Attributes: BTUNIVATTRIBUTE;
    Analyzed: PBTANALYZEDATTRLIST2;
    Loop: Integer;
    ResUUIDList: PBTUUIDLIST;
    AUUID128: string;
    Ndx: Integer;
    ProtNdx: Integer;
    ProtParams: BTPROTOCOLPARAM;
    ProtParamsSize: DWORD;
    Err: Boolean;
    DevInfoList: PBTDEVINFOLIST;
    Msg: TMsg;
  begin
    Result := TBFBluetoothServices.Create;

    with API do Adr := ReverseToshibaBTAddress(StringToBluetoothAddress(Address));

    with UUIDList do begin
      dwUUIDInfoNum := 1;
      with BTUUIDInfo[0] do begin
        wUUIDType := 128;
        BtUUID := API.UUIDToBtUUID(L2CAP_PROTOCOL_UUID);
      end;
    end;
    Attributes := TOSBTAPI_ATR_SERVICECLASSIDLIST or TOSBTAPI_ATR_SERVICENAME or TOSBTAPI_ATR_SERVICEDESCRIPTION or TOSBTAPI_ATR_PROTOCOLDESCRIPTORLIST;
    Pattern := nil;
    Attr := nil;
    SSAResult := nil;
    Analyzed := nil;
    SSAResult := nil;
    Err := True;

    if BtMakeServiceSearchPattern2(@UUIDList, Size, Pattern, Status) then begin
      if BtMakeAttributeIDList2(Attributes, AttrSize, Attr, Status) then begin
        if Fast then
          Err := not BtServiceSearchAttributeSDDB2(Adr, Size, Pattern, AttrSize, Attr, SSAResult, Status)

        else begin
          CID := 0;
          TosSupp := TBFToshibaSupport.Create;

          if BtConnectSDP(Adr, CID, Status, TosSupp.FWnd, BFNM_TOS_CONNECTSDP, 0) then begin
            while True do
              if PeekMessage(Msg, TosSupp.FWnd, BFNM_TOS_CONNECTSDP, BFNM_TOS_CONNECTSDP, PM_REMOVE) then
                with Msg do
                  if (WParam = TOSBTAPI_NM_CONNECTSDP_ERROR) or (WParam = TOSBTAPI_NM_CONNECTSDP_END) then
                    Break;

            if Status >= TOSBTAPI_NO_ERROR then
              if BtServiceSearchAttribute2(CID, Size, Pattern, AttrSize, Attr, SSAResult, Status, TosSupp.FWnd, BFNM_TOS_SSAEND, 0) then begin
                while True do
                  if PeekMessage(Msg, TosSupp.FWnd, BFNM_TOS_SSAEND, BFNM_TOS_SSAEND, PM_REMOVE) then
                    with Msg do
                      if (WParam = TOSBTAPI_NM_SSA_ERROR) or (WParam = TOSBTAPI_NM_SSA_END) then
                        Break;

                Err := Status < TOSBTAPI_NO_ERROR;
              end;

            BtDisconnectSDP(CID, Status);
            Sleep(500);
          end;

          DevInfoList := nil;

          if BtRefreshSDDB2(False, Adr, DevInfoList, Status, TosSupp.FWnd, BFNM_TOS_REFRESHEND, 0) then
            while True do
              if PeekMessage(Msg, TosSupp.FWnd, BFNM_TOS_REFRESHEND, BFNM_TOS_REFRESHEND, PM_REMOVE) then
                with Msg do
                  if (WParam = TOSBTAPI_NM_REFRESHSDDB_ERROR) or (WParam = TOSBTAPI_NM_REFRESHSDDB_END) then
                    Break;

          if Assigned(DevInfoList) then BtMemFree(DevInfoList);

          Sleep(500);
          
          TosSupp.Free;
        end;

        if Assigned(Attr) then BtMemFree(Attr);
      end;

      if Assigned(Pattern) then BtMemFree(Pattern);
    end;

    if not Err then begin
      if BtAnalyzeServiceAttributeLists2(Attributes, SSAResult, Analyzed, Status) then begin
        with Analyzed^ do
          for Loop := 0 to dwNum - 1 do begin
            AService := TBFBluetoothService.Create;

            with BtAnalyzedAttr[Loop] do begin
              if BtAnalyzedAttribute and TOSBTAPI_ATR_SERVICECLASSIDLIST <> 0 then begin
                ResUUIDList := pMemServiceClassIDList;

                if Assigned(ResUUIDList) then begin
                  with ResUUIDList^ do
                    if dwUUIDInfoNum > 0 then
                      with BTUUIDInfo[0] do
                        case wUUIDType of
                          16, 32: with AService do begin
                                    FUUID16 := BtUUID[2] shl 8 or BtUUID[3];
                                    FUUID := API.UUID16ToUUID(FUUID16);
                                  end;

                          128: begin
                                 AUUID128 := '{';
                                 for Ndx := 0 to 3 do AUUID128 := AUUID128 + IntToHex(BtUUID[Ndx], 2);
                                 AUUID128 := AUUID128 + '-';
                                 for Ndx := 4 to 5 do AUUID128 := AUUID128 + IntToHex(BtUUID[Ndx], 2);
                                 AUUID128 := AUUID128 + '-';
                                 for Ndx := 6 to 7 do AUUID128 := AUUID128 + IntToHex(BtUUID[Ndx], 2);
                                 AUUID128 := AUUID128 + '-';
                                 for Ndx := 8 to 9 do AUUID128 := AUUID128 + IntToHex(BtUUID[Ndx], 2);
                                 AUUID128 := AUUID128 + '-';
                                 for Ndx := 10 to 15 do AUUID128 := AUUID128 + IntToHex(BtUUID[Ndx], 2);
                                 AUUID128 := AUUID128 + '}';

                                 with AService do begin
                                   FUUID := StringToGUID(AUUID128);
                                   FUUID16 := API.UUIDToUUID16(FUUID);
                                 end;
                               end;
                        end;
                end;
              end;

              if BtAnalyzedAttribute and TOSBTAPI_ATR_SERVICENAME <> 0 then
                with btsServiceName do
                  if Assigned(pbString) and (dwSize > 0) then
                    AService.FName := Copy(string(PChar(pbString)), 1, dwSize);

              if BtAnalyzedAttribute and TOSBTAPI_ATR_SERVICEDESCRIPTION <> 0 then
                with btsServiceDescription do
                  if Assigned(pbString) and (dwSize > 0) then
                    AService.FComment := Copy(string(PChar(pbString)), 1, dwSize);

              if BtAnalyzedAttribute and TOSBTAPI_ATR_PROTOCOLDESCRIPTORLIST <> 0 then
                if Assigned(pMemProtocolDescriptorList) then
                  with pMemProtocolDescriptorList^ do
                    for Ndx := 0 to dwProtocolListNum - 1 do
                      if Assigned(pMemProtocolList[Ndx]) then
                        with pMemProtocolList[Ndx]^ do begin
                          ProtParamsSize := SizeOf(BTPROTOCOLPARAM);

                          for ProtNdx := 0 to dwProtocolListNum - 1 do
                            if Assigned(pMemProtocolList[ProtNdx]) then begin
                              FillChar(ProtParams, ProtParamsSize, 0);
                              ProtParams.dwSize := ProtParamsSize;

                              if BtAnalyzeProtocolParameter2(pMemProtocolList[ProtNdx], ProtParams, Status) then
                                if ProtParams.dwEnableParam and $00000008 <> 0 then begin
                                  AService.FChannel := ProtParams.bSCN;

                                  Break;
                                end;
                            end;
                        end;
            end;

            Result.FList.Add(AService);
          end;

        if Assigned(Analyzed) then BtFreePBTANALYZEDATTRLIST2(Analyzed, Status);
      end;

      if Assigned(SSAResult) then BtMemFree(SSAResult);
    end;
  end;

begin
  // If there is no radio specified try to use first founded.
  if not Assigned(Radio) then begin
    NoRadio := True;
    Radio := GetFirstRadio;

  end else
    NoRadio := False;

  try
    case Radio.BluetoothAPI of
      baBlueSoleil: Result := EnumServicesIVT;
      baWinSock: Result := EnumServicesMS;
      baWidComm: Result := EnumServicesWD;
      baToshiba: Result := EnumServicesTos;

    else
      Result := nil;
    end;

  finally
    if NoRadio then Radio.Free;
  end;
end;

function GetFirstRadio: TBFBluetoothRadio;
var
  Discovery: TBFBluetoothDiscovery;
  Radios: TBFBluetoothRadios;
begin
  Result := nil;
  
  Discovery := TBFBluetoothDiscovery.Create(nil);

  try
    Radios := Discovery.EnumRadios;

    if Assigned(Radios) then
      try
        if Radios.Count > 0 then begin
          Result := TBFBluetoothRadio.Create;
          Result.Assign(Radios[0]);
        end;
        
      finally
        Radios.Free;
      end;

  finally
    Discovery.Free;
  end;
end;

{ TBFBluetoothService }

procedure TBFBluetoothService.Assign(AService: TBFBluetoothService);
begin
  ClearFields;

  if Assigned(AService) then begin
    FChannel := AService.FChannel;
    FComment := AService.FComment;
    FName := AService.FName;
    FUUID := AService.FUUID;
    FUUID16 := AService.FUUID16;
  end;
end;

procedure TBFBluetoothService.ClearFields;
begin
  FChannel := 0;
  FComment := '';
  FName := '';
  FUUID := GUID_NULL;
  FUUID16 := 0;
end;

constructor TBFBluetoothService.Create;
begin
  ClearFields;
end;

{ TBFBluetoothServices }

procedure TBFBluetoothServices.Assign(AList: TBFBluetoothServices);
var
  Loop: Integer;
  AService: TBFBluetoothService;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
      AService := TBFBluetoothService.Create;
      AService.Assign(AList[Loop]);
      FList.Add(AService);
    end;
end;

constructor TBFBluetoothServices.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFBluetoothServices.Destroy;
begin
  FList.Free;
  
  inherited;
end;

function TBFBluetoothServices.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFBluetoothServices.GetService(const Index: Integer): TBFBluetoothService;
begin
  Result := TBFBluetoothService(FList[Index]);
end;

{ TBFBluetoothDevice }

procedure TBFBluetoothDevice.Assign(ADevice: TBFBluetoothDevice);
begin
  ClearFields;

  if Assigned(ADevice) then begin
    FAddress := ADevice.FAddress;
    FAuthenticated := ADevice.FAuthenticated;
    FBTAddress := ADevice.FBTAddress;
    FConnected := ADevice.FConnected;
    FClassOfDevice := ADevice.FClassOfDevice;
    FLastSeen := ADevice.FLastSeen;
    FLastUsed := ADevice.FLastUsed;
    FName := ADevice.FName;
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(ADevice.FRadio);
    FRemembered := ADevice.FRemembered;
    FServices.Assign(ADevice.FServices);
  end;
end;

procedure TBFBluetoothDevice.ClearFields;
begin
  FAddress := '';
  FAuthenticated := False;
  FBTAddress := 0;
  FConnected := False;
  FClassOfDevice := 0;
  FLastSeen := 0;
  FLastUsed := 0;
  FName := '';
  FRadio.Free;
  FRadio := nil;
  FRemembered := False;
  FServices.FList.Clear;
end;

constructor TBFBluetoothDevice.Create(ARadio: TBFBluetoothRadio);
begin
  FRadio := TBFBluetoothRadio.Create;
  FRadio.Assign(ARadio);
  
  FServices := TBFBluetoothServices.Create;
end;

destructor TBFBluetoothDevice.Destroy;
begin
  if Assigned(FRadio) then FRadio.Free;
  if Assigned(FServices) then FServices.Free;

  inherited;
end;

function TBFBluetoothDevice.GetClassOfDeviceName: string;
begin
  Result := API.ClassOfDeviceToString(FClassOfDevice);
end;

function TBFBluetoothDevice.GetName: string;
begin
  if FName = '' then
    Result := StrDeviceNameUnknown

  else
    Result := FName;
end;

procedure TBFBluetoothDevice.Pair(PassKey: string);

  procedure PairIVT;
  var
    DevInfo: IVTBLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    Res: DWORD;
  begin
    DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);
    with DevInfo do begin
      dwSize := DevInfoSize;
      address := API.StringToBluetoothAddress(FAddress);
    end;

    Res := BT_PairDevice(@DevInfo, Length(PassKey), PByte(PChar(PassKey)), True, False);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);
  end;

  procedure PairMS;
  var
    DevInfo: BLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
    WidePassKey: WideString;
    Res: DWORD;
  begin
    if Length(PassKey) > 0 then begin
      DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
      FillChar(DevInfo, DevInfoSize, 0);

      with DevInfo do begin
        dwSize := DevInfoSize;
        Address.ullLong := FBTAddress;
      end;

      WidePassKey := WideString(PassKey);
      if WidePassKey[Length(WidePassKey)] <> #0 then WidePassKey := WidePassKey + #0;

      Res := BluetoothAuthenticateDevice(0, 0, DevInfo, PWideChar(WidePassKey), Length(WidePassKey) - 1);
      if Res <> ERROR_SUCCESS then begin
        SetLastError(Res);
        RaiseLastOSError;
      end;
    end;
  end;

  procedure PairWD;
  var
    Res: BOND_RETURN_CODE;
  begin
    Res := WD_Bond(API.StringToBluetoothAddress(FAddress), PChar(PassKey));
    if (Res <> SUCCESS) and (Res <> ALREADY_BONDED) then raise Exception.Create(StrUnablePairingWithDevice);
  end;

begin
  if not Assigned(FRadio) then raise Exception.Create(StrRadioRequired);

  case FRadio.BluetoothAPI of
    baBlueSoleil: PairIVT;
    baWinSock: PairMS;
    baWidComm: PairWD;
    baToshiba: raise Exception.Create(StrNotSupportedByCurrentBluetoothAPI);
  end;
end;

procedure TBFBluetoothDevice.SetName(const Value: string);

  procedure SetNameBS;
  var
    DevInfo: BLUETOOTH_DEVICE_INFO_EX;
    DevInfoSize: DWORD;
    NameLen: Integer;
    Res: DWORD;
  begin
    DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
    FillChar(DevInfo, DevInfoSize, 0);

    DevInfo.dwSize := DevInfoSize;
    DevInfo.address := API.StringToBluetoothAddress(FAddress);
    NameLen := Length(Value);
    if NameLen > MAX_DEVICE_NAME_LENGTH then NameLen := MAX_DEVICE_NAME_LENGTH;

    StrLCopy(DevInfo.szName, PChar(Value), NameLen);

    Res := BT_SetRemoteDeviceInfo(MASK_DEVICE_NAME, @DevInfo);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);
  end;
  
  procedure SetNameMS;
  var
    DevInfo: BLUETOOTH_DEVICE_INFO;
    DevInfoSize: DWORD;
  begin
    DevInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
    FillChar(DevInfo, DevInfoSize, 0);

    with DevInfo do begin
      dwSize := DevInfoSize;
      Address.ullLong := FBTAddress;
      StringToWideChar(Value, szName, BLUETOOTH_MAX_NAME_SIZE);
    end;

    if BluetoothUpdateDeviceRecord(DevInfo) <> ERROR_SUCCESS then raise Exception.Create(StrCanNotUpdateDeviceRecord);
  end;

  procedure SetNameWD;
  begin
    { TODO : Установка имени WD }
  end;

  procedure SetNameTos;
  begin
    { TODO : Установка имени Tos }
  end;

begin
  if not Assigned(FRadio) then raise Exception.Create(StrRadioRequired);
  
  if Value <> FName then begin
    API.CheckTransport(atBluetooth);

    case FRadio.BluetoothAPI of
      baBlueSoleil: SetNameBS;
      baWinSock: SetNameMS;
      baWidComm: SetNameWD;
      baToshiba: SetNameTos;
    end;

    FName := Value;
  end;
end;

procedure TBFBluetoothDevice.SetRadio(const Value: TBFBluetoothRadio);
begin
  if not Assigned(Value) then raise Exception.Create(StrRadioRequired);
  
  if Assigned(FRadio) then begin
    FRadio.Free;
    FRadio := nil;
  end;

  if Assigned(Value) then begin
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothDevice.Unpair;

  procedure UnpairMS;
  var
    Address: BLUETOOTH_ADDRESS;
  begin
    FillChar(Address, SizeOf(BLUETOOTH_ADDRESS), 0);
    Address.ullLong := FBTAddress;
    BluetoothRemoveDevice(Address);
  end;

  procedure UnpairBS;
  var
    Address: TBluetoothAddress;
  begin
    Address := API.StringToBluetoothAddress(FAddress);
    BT_UnpairDevice(@Address);
  end;

  procedure UnpairWD;
  var
    Address: TBluetoothAddress;
  begin
    Address := API.StringToBluetoothAddress(FAddress);
    WD_UnBond(Address);
  end;

  procedure UnpairTos;
  var
    Status: Long;
    DevList: BTDEVICELIST;
  begin
    with DevList do begin
      dwDevListNum := 1;
      with API do BdAddr := ReverseToshibaBTAddress(StringToBluetoothAddress(FAddress));
    end;

    if not BtRemoveRemoteDevice(@DevList, Status) then API.RaiseTosError(Status);
  end;

begin
  if not Assigned(FRadio) then raise Exception.Create(StrRadioRequired);
  
  case FRadio.BluetoothAPI of
    baBlueSoleil: UnpairBS;
    baWinSock: UnpairMS;
    baWidComm: UnpairWD;
    baToshiba: UnpairTos;
  end;
end;

{ TBFBluetoothDevices }

procedure TBFBluetoothDevices.Assign(AList: TBFBluetoothDevices);
var
  Loop: Integer;
  ADevice: TBFBluetoothDevice;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
      ADevice := TBFBluetoothDevice.Create(nil);
      ADevice.Assign(AList[Loop]);
      FList.Add(ADevice);
    end;
end;

constructor TBFBluetoothDevices.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFBluetoothDevices.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFBluetoothDevices.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFBluetoothDevices.GetDevice(const Index: Integer): TBFBluetoothDevice;
begin
  Result := TBFBluetoothDevice(FList[Index]);
end;

function TBFBluetoothDevices.IndexOf(Addr: BTH_ADDR): Integer;
var
  Loop: Integer;
begin
  Result := -1;
  
  for Loop := 0 to Count - 1 do
    if Device[Loop].FBTAddress = Addr then begin
      Result := Loop;
      Break;
    end;
end;

{ TBFCOMPort }

procedure TBFCOMPort.Assign(Port: TBFCOMPort);
begin
  ClearFields;

  if Assigned(Port) then begin
    FNumber := Port.FNumber;
    FName := Port.FName;
  end;
end;

procedure TBFCOMPort.ClearFields;
begin
  FNumber := 0;
  FName := '';
end;

constructor TBFCOMPort.Create;
begin
  ClearFields;
end;

{ TBFIrDADevice }

procedure TBFIrDADevice.Assign(ADevice: TBFIrDADevice);
begin
  ClearFields;

  if Assigned(ADevice) then begin
    FAddress := ADevice.FAddress;
    FCharSet := ADevice.FCharSet;
    FHints1 := ADevice.FHints1;
    FHints2 := ADevice.FHints2;
    FIrDAAddress := ADevice.FIrDAAddress;
    FName := ADevice.FName;
  end;
end;

procedure TBFIrDADevice.ClearFields;
begin
  FAddress := '';
  FCharSet := 0;
  FHints1 := 0;
  FHints2 := 0;
  FIrDAAddress := NULL_IRDA_ADDR;
  FName := '';
end;

constructor TBFIrDADevice.Create;
begin
  ClearFields;
end;

{$IFDEF BCB}
function TBFIrDADevice.GetIrDAAddress: Integer;
begin
  Result := Integer(FIrDAAddress);
end;
{$ENDIF}

function TBFIrDADevice.GetName: string;
begin
  if FName = '' then
    Result := StrDeviceNameUnknown
  else
    Result := FName;
end;

{ TBFCOMPorts }

procedure TBFCOMPorts.Assign(AList: TBFCOMPorts);
var
  Loop: Integer;
  APort: TBFCOMPort;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
      APort := TBFCOMPort.Create;
      APort.Assign(AList[Loop]);
      FList.Add(APort);
    end;
end;

constructor TBFCOMPorts.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFCOMPorts.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFCOMPorts.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFCOMPorts.GetPort(const Index: Integer): TBFCOMPort;
begin
  Result := TBFCOMPort(FList[Index]);
end;

{ TBFBluetoothRadio }

procedure TBFBluetoothRadio.Assign(ARadio: TBFBluetoothRadio);
begin
  ClearFields;

  if Assigned(ARadio) then begin
    FAddress := ARadio.FAddress;
    FBluetoothAPI := ARadio.FBluetoothAPI;
    FBTAddress := ARadio.FBTAddress;
    FClassOfDevice := ARadio.FClassOfDevice;
    FManufacturer := ARadio.FManufacturer;
    FName := ARadio.FName;
    FSubversion := ARadio.FSubversion;
  end;
end;

procedure TBFBluetoothRadio.ClearFields;
begin
  FAddress := '(00:00:00:00:00:00)';
  FBluetoothAPI := baBlueSoleil;
  FBTAddress := 0;
  FClassOfDevice := 0;
  FManufacturer := 0;
  FName := '';
  FSubversion := 0;
end;

constructor TBFBluetoothRadio.Create;
begin
  ClearFields;
end;

function TBFBluetoothRadio.GetClassOfDeviceName: string;
begin
  Result := API.ClassOfDeviceToString(FClassOfDevice);
end;

function TBFBluetoothRadio.GetConnectable: Boolean;
var
  Radio: THandle;
  Mode: Word;
  Status: Long;
begin
  Result := False;
  
  API.CheckTransport(atBluetooth);

  case FBluetoothAPI of
    baWinSock: begin
                 Radio := GetRadioHandle;
                 Result := BluetoothIsConnectable(Radio);
                 CloseHandle(Radio);
               end;

    baToshiba: if BtGetConnectabilityMode(Mode, Status) then
                 Result := Mode = TOSBTAPI_CONNECTABLE

               else
                 API.RaiseTosError(Status);

  else
    Result := False; //raise Exception.Create(StrFeatureNotSupported);
  end;
end;

function TBFBluetoothRadio.GetDiscoverable: Boolean;
var
  Radio: THandle;
  Mode: Word;
  Status: Long;
begin
  Result := False;

  API.CheckTransport(atBluetooth);

  case FBluetoothAPI of
    baWinSock: begin
                 Radio := GetRadioHandle;
                 Result := BluetoothIsDiscoverable(Radio);
                 CloseHandle(Radio);
               end;

    baToshiba: if BtGetDiscoverabilityMode(Mode, Status) then
                 Result := Mode = TOSBTAPI_DISCOVERABLE

               else
                 API.RaiseTosError(Status);
  else
    Result := False; //raise Exception.Create(StrFeatureNotSupported);
  end;
end;

function TBFBluetoothRadio.GetFullName: string;
begin
  Result := '';
  case FBluetoothAPI of
    baBlueSoleil: Result := 'BlueSolei [';
    baWinSock: Result := 'Microsoft [';
    baWidComm: Result := 'WidComm [';
    baToshiba: Result := 'Toshiba [';
  else
    Result := 'Unknown [';
  end;

  Result := Result + FAddress + '] (' + FName + ')';
end;

function TBFBluetoothRadio.GetRadioHandle: THandle;
var
  Find: HBLUETOOTH_RADIO_FIND;
  FindParams: BLUETOOTH_FIND_RADIO_PARAMS;
  Radio: THandle;
  RadioInfo: BLUETOOTH_RADIO_INFO;
  RadioInfoSize: DWORD;
begin
  Result := 0;

  FindParams.dwSize := SizeOf(BLUETOOTH_FIND_RADIO_PARAMS);
  RadioInfoSize := SizeOf(BLUETOOTH_RADIO_INFO);

  Find := BluetoothFindFirstRadio(@FindParams, Radio);
  if Find <> 0 then begin
    repeat
      FillChar(RadioInfo, RadioInfoSize, 0);
      RadioInfo.dwSize := RadioInfoSize;

      if BluetoothGetRadioInfo(Radio, RadioInfo) = 0 then
        if FAddress = API.BlueSoleilAddressToString(RadioInfo.address.rgBytes) then begin
          Result := Radio;
          Break;
        end;

        CloseHandle(Radio);
    until not BluetoothFindNextRadio(Find, Radio);

    BluetoothFindRadioClose(Find);
  end;

  if Result = 0 then raise Exception.Create(StrLocalRadioNotFounded);
end;

function TBFBluetoothRadio.GetVersion: string;
var
  Buf: array [0..MAX_PATH - 1] of Char;
  BufSize: Integer;
  Ver: DWORD;
begin
  BufSize := SizeOf(Buf);
  FillChar(Buf, BufSize, 0);

  case FBluetoothAPI of
    baBlueSoleil: begin
                    Ver := BT_GetVersion;
                    Result := IntToStr(Ver);
                  end;  
    baWinSock: Result := '0202'; // Always return $0202.
    baWidComm: begin
                 WD_GetVersion(Buf, BufSize);
                 Result := string(Buf);
               end;  
    baToshiba: ;
  end;
end;

procedure TBFBluetoothRadio.SetConnectable(const Value: Boolean);
var
  Radio: Handle;
begin
  API.CheckTransport(atBluetooth);

  if FBluetoothAPI = baWinSock then begin
    Radio := GetRadioHandle;

    try
      if not BluetoothEnableIncomingConnections(Radio, Value) then raise Exception.Create(StrCantMakeConnactable);

    finally
      CloseHandle(Radio);
    end;

  end else
    raise Exception.Create(StrFeatureNotSupported);
end;

procedure TBFBluetoothRadio.SetDiscoverable(const Value: Boolean);
var
  Radio: Handle;
begin
  API.CheckTransport(atBluetooth);

  if FBluetoothAPI = baWinSock then begin
    Radio := GetRadioHandle;

    try
      if not BluetoothEnableDiscovery(Radio, Value) then raise Exception.Create(StrCantMakeDiscoverable);

    finally
      CloseHandle(Radio);
    end;
    
  end else
    raise Exception.Create(StrFeatureNotSupported);
end;

procedure TBFBluetoothRadio.SetName(const Value: string);

  procedure SetNameIVT;
  var
    DeviceInfo: IVTBLUETOOTH_DEVICE_INFO;
    DeviceInfoSize: DWORD;
    Res: DWORD;
  begin
    DeviceInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
    FillChar(DeviceInfo, DeviceInfoSize, 0);

    DeviceInfo.dwSize := DeviceInfoSize;
    StrLCopy(DeviceInfo.szName, PChar(Value), Length(Value));

    Res := BT_SetLocalDeviceInfo(MASK_DEVICE_NAME, @DeviceInfo);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);
  end;

  procedure SetNameMS;
  var
    ReverseAddress: string;
    AKeyName: string;
    CompName: array [0..MAX_COMPUTERNAME_LENGTH - 1] of Char;
    ACode: DWORD;
    Written: DWORD;
    CompNameSize: DWORD;

    function GetRegistryPath: string;
    const
      A_KEY_NAME = 'SYSTEM\CurrentControlSet\Enum\USB';

    var
      SubKeys: TStringList;
      Loop: Integer;
    begin
      Result := '';
      SubKeys := TStringList.Create;

      with TRegistry.Create do begin
        Access := KEY_READ;
        RootKey := HKEY_LOCAL_MACHINE;

        if OpenKey(A_KEY_NAME, False) then begin
          GetKeyNames(SubKeys);

          CloseKey;

          for Loop := 0 to SubKeys.Count - 1 do
            if OpenKey(A_KEY_NAME + '\' + SubKeys[Loop], False) then begin
              if KeyExists(ReverseAddress) then Result := A_KEY_NAME + '\' + SubKeys[Loop] + '\' + ReverseAddress + '\Device Parameters';

              CloseKey;

              if Result <> '' then Break;
            end;
        end;

        Free;
      end;

      SubKeys.Free;
    end;

  begin
    ReverseAddress := FAddress[17] + FAddress[18] + FAddress[14] + FAddress[15] + FAddress[11] + FAddress[12] + FAddress[8] + FAddress[9] + FAddress[5] + FAddress[6] + FAddress[2] + FAddress[3];
    AKeyName := GetRegistryPath;
    if AKeyName = '' then raise Exception.Create(StrUnableChangeRadioName);

    CompNameSize := SizeOf(CompName);
    FillChar(CompName, CompNameSize, 0);
    if not GetComputerName(CompName, CompNameSize) then RaiseLastOSError;

    with TRegistry.Create do begin
      RootKey := HKEY_LOCAL_MACHINE;

      if OpenKey(AKeyName, False) then begin
        if string(CompName) = Value then
          DeleteValue('Local Name')

        else
          WriteBinaryData('Local Name', PChar(Value + #0)^, Length(Value) + 1);

        CloseKey;
      end;

      Free;
    end;

    ACode := 4;

    if not DeviceIoControl(GetRadioHandle, $00220FD4, @ACode, 4, nil, 0, Written, nil) then RaiseLastOSError;
  end;

  procedure SetNameTos;
  var
    AName: FRIENDLYNAME;
    Status: Long;
    Len: DWORD;
  begin
    FillChar(AName, SizeOf(FRIENDLYNAME), 0);

    if Length(Value) > SizeOf(FRIENDLYNAME) then
      Len := SizeOf(FRIENDLYNAME)

    else
      Len := Length(Value);

    StrLCopy(AName, PChar(Value), Len);

    if not BtSetLocalDeviceName(@AName, Status) then API.RaiseTosError(Status);
  end;

  procedure SetNameWD;
  var
    AName: BD_NAME;
    Len: DWORD;
  begin
    FillChar(AName, SizeOf(BD_NAME), 0);
    if Length(Value) > BD_NAME_LEN then
      Len := BD_NAME_LEN

    else
      Len := Length(Value);

    StrLCopy(AName, PChar(Value), Len);

    if not WD_SetLocalDeviceName(AName) then raise Exception.Create(StrUnableToSetLocalRadioName);

    FName := string(AName);
  end;

begin
  if FName <> Value then begin
    API.CheckTransport(atBluetooth);

    case FBluetoothAPI of
      baBlueSoleil: SetNameIVT;
      baToshiba: SetNameTos;
      baWinSock: SetNameMS;
      baWidComm: SetNameWD;
    end;

    FName := Value;
  end;
end;

{ TBFBluetoothRadios }

procedure TBFBluetoothRadios.Assign(AList: TBFBluetoothRadios);
var
  Loop: Integer;
  ARadio: TBFBluetoothRadio;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
     ARadio := TBFBluetoothRadio.Create;
     ARadio.Assign(AList[Loop]);
     FList.Add(ARadio);
    end;
end;

constructor TBFBluetoothRadios.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFBluetoothRadios.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFBluetoothRadios.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFBluetoothRadios.GetRadio(const Index: Integer): TBFBluetoothRadio;
begin
  Result := TBFBluetoothRadio(FList[Index]);
end;

{ TBFIrDADevices }

procedure TBFIrDADevices.Assign(AList: TBFIrDADevices);
var
  Loop: Integer;
  ADevice: TBFIrDADevice;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
      ADevice := TBFIrDADevice.Create;
      ADevice.Assign(AList[Loop]);
      FList.Add(ADevice);
    end;
end;

constructor TBFIrDADevices.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFIrDADevices.Destroy;
begin
  FList.Free;
  
  inherited;
end;

function TBFIrDADevices.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFIrDADevices.GetDevice(const Index: Integer): TBFIrDADevice;
begin
  Result := TBFIrDADevice(FList[Index]);
end;

function TBFIrDADevices.IndexOf(Addr: IRDA_ADDR): Integer;
var
  Loop: Integer;
begin
  Result := -1;

  for Loop := 0 to Count - 1 do
    if Device[Loop].FIrDAAddress = Addr then begin
      Result := Loop;
      Break;
    end;
end;

{ TBFBluetoothDiscovery }

procedure TBFBluetoothDiscovery.BFNMBluetoothDiscoveryEvent(var Message: TMessage);
begin
  case Message.LParam of
    NM_DISCOVERY_BEGIN: DoDiscoveryBegin;
    NM_DISCOVERY_END: DoDiscoveryEnd;
    NM_DISCOVERY_SEARCH_BEGIN: DoSearchBegin;
    NM_DISCOVERY_SEARCH_END: DoSerachEnd;
    NM_DISCOVERY_DEVICE_FOUND: DoDeviceFound(TBFBluetoothDevice(Message.WParam));
    NM_DISCOVERY_DEVICE_LOST: DoDeviceLost(TBFBluetoothDevice(Message.WParam));
  end;

  Message.Result := Integer(True);
end;

constructor TBFBluetoothDiscovery.Create(AOwner: TComponent);
begin
  inherited;

  FDelay := 1000;
  FNonBlocking := False;
  FThread := nil;

  FOnComplete := nil;
  FOnDeviceFound := nil;
  FOnDeviceLost := nil;
  FOnStartMonitoring := nil;
  FOnStartSearch := nil;
  FOnStopMonitoring := nil;
  FOnStopSearch := nil;
end;

destructor TBFBluetoothDiscovery.Destroy;
begin
  StopMonitoring;
  
  inherited;
end;

type
  TBluetoothDiscoveryThread = class(TThread)
  private
    FFast: Boolean;
    FNeedServices: Boolean;
    FRadio: TBFBluetoothRadio;
    FWnd: HWND;

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner: TBFBluetoothDiscovery; AFast: Boolean; ANeedServices: Boolean; ARadio: TBFBluetoothRadio);
  end;

  constructor TBluetoothDiscoveryThread.Create(AOwner: TBFBluetoothDiscovery; AFast: Boolean; ANeedServices: Boolean; ARadio: TBFBluetoothRadio);
  begin
    FFast := AFast;
    FNeedServices := ANeedServices;
    FRadio := TBFBluetoothRadio.Create;
    FRadio.Assign(ARadio);
    FWnd := AOwner.Wnd;

    FreeOnTerminate := True;
    inherited Create(False);
  end;

  procedure TBluetoothDiscoveryThread.Execute;
  var
    Discovery: TBFBluetoothDiscovery;
    Devices: TBFBluetoothDevices;
  begin
    Devices := nil;

    try
      Discovery := TBFBluetoothDiscovery.Create(nil);

      try
        Devices := Discovery.Discovery(FRadio, FFast, FNeedServices, True);

      finally
        Discovery.Free;
      end;

    except
    end;

    try
      if not PostMessage(FWnd, BFNM_DISCOVERY_COMPLETE_EVENT, Integer(Devices), 0) then raise Exception.Create('Post message error');

    except
      if Assigned(Devices) then Devices.Free;
    end;
  end;

function TBFBluetoothDiscovery.Discovery(Radio: TBFBluetoothRadio; Fast: Boolean; NeedServices: Boolean = True; Blocking: Boolean = True): TBFBluetoothDevices;
var
  NoRadio: Boolean;

  function DiscoveryIVT: TBFBluetoothDevices;
  var
    Flag: UCHAR;
    DeviceList: array [0..MAX_DEVICE_COUNT - 1] of IVTBLUETOOTH_DEVICE_INFO;
    DeviceListSize: DWORD;
    Res: DWORD;
    DeviceCount: DWORD;
    DeviceIndex: Integer;
    ADevice: TBFBluetoothDevice;
    DeviceInfoExSize: DWORD;
    DeviceInfoEx: BLUETOOTH_DEVICE_INFO_EX;
    Mask: DWORD;
  begin
    // Discovery type.
    if Fast then
      Flag := INQUIRY_PAIRED
    else
      Flag := INQUIRY_GENERAL_REFRESH;

    // Initialize.
    DeviceListSize := SizeOf(DeviceList);
    FillChar(DeviceList, DeviceListSize, 0);
    DeviceList[0].dwSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);

    Res := BT_InquireDevices(Flag, 10, @DeviceListSize, DeviceList[0]);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

    DeviceCount := Round(DeviceListSize / SizeOf(IVTBLUETOOTH_DEVICE_INFO));

    Result := TBFBluetoothDevices.Create;

    for DeviceIndex := 0 to DeviceCount - 1 do begin
      ADevice := TBFBluetoothDevice.Create(Radio);
      with ADevice do begin
        FAddress := API.BlueSoleilAddressToString(DeviceList[DeviceIndex].address);
        FAuthenticated := DeviceList[DeviceIndex].bPaired;
        FBTAddress := API.BlueSoleilAddressToBTAddress(DeviceList[DeviceIndex].address);
        FClassOfDevice := API.BlueSoleilClassOfDeviceToCOD(DeviceList[DeviceIndex].classOfDevice);
        FName := string(DeviceList[DeviceIndex].szName);
        FRemembered := DeviceList[DeviceIndex].bPaired;

        // Extended information.
        DeviceInfoExSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
        FillChar(DeviceInfoEx, DeviceInfoExSize, 0);
        with DeviceInfoEx do begin
          dwSize := DeviceInfoExSize;
          address := DeviceList[DeviceIndex].address;
        end;
        Mask := MASK_CONNECT_STATUS;
        // If we stiil not recognize the device name so we mus do it now
        if FName = '' then Mask := Mask or MASK_DEVICE_NAME;
        Res := BT_GetRemoteDeviceInfo(Mask, DeviceInfoEx);
        if Res = BTSTATUS_SUCCESS then begin
          FConnected := DeviceInfoEx.bConnected;
          // Need we name?
          if Mask and MASK_DEVICE_NAME <> 0 then FName := string(DeviceInfoEx.szName);
        end;

        if NeedServices then FServices := EnumServices(FAddress, Fast, Radio);
      end;

      Result.FList.Add(ADevice);
    end;
  end;

  function DiscoveryWD: TBFBluetoothDevices;
  var
    ADevices: DEVICE_LIST;
    Loop: Integer;
    ADevice: TBFBluetoothDevice;
  begin
    if WD_Inquiry(@ADevices, Fast) then begin
      Result := TBFBluetoothDevices.Create;

      for Loop := 0 to ADevices.dwCount - 1 do begin
        ADevice := TBFBluetoothDevice.Create(Radio);

        with ADevice, ADevices.Devices[Loop] do begin
          FAddress := API.BlueSoleilAddressToString(bda);
          FAuthenticated := b_paired;
          FBTAddress := API.BlueSoleilAddressToBTAddress(bda);
          FConnected := b_connected;
          FClassOfDevice := API.BlueSoleilClassOfDeviceToCOD(dev_class, True);
          FName := Utf8ToAnsi(string(bd_name));
          FRemembered := FAuthenticated;
          if NeedServices then FServices := EnumServices(FAddress, Fast, Radio);
        end;

        Result.FList.Add(ADevice);
      end;

    end else
      Result := nil;
  end;

  function DiscoveryMS: TBFBluetoothDevices;
  var
    Flags: DWORD;
    QuerySet: WSAQUERYSET;
    QuerySetSize: DWORD;
    ResDevice: DWORD;
    LookupDevice: THandle;
    Buffer: array [0..4096] of Byte;
    BufferSize: DWORD;
    Results: LPWSAQUERYSET;
    CSAddr: PCSADDR_INFO;
    Addr: array [0..255] of Char;
    AddrSize: DWORD;
    ADevice: TBFBluetoothDevice;
    DeviceInfo: BLUETOOTH_DEVICE_INFO;
    DeviceInfoSize: DWORD;
  begin
    Result := TBFBluetoothDevices.Create;

    // Discovery type.
    Flags := LUP_RETURN_NAME or LUP_CONTAINERS or LUP_RETURN_ADDR or LUP_RETURN_TYPE;
    if not Fast then Flags := Flags or LUP_FLUSHCACHE;

    // Initialize.
    QuerySetSize := SizeOf(WSAQUERYSET);
    FillChar(QuerySet, QuerySetSize, 0);

    with QuerySet do begin
      dwSize := QuerySetSize;
      dwNameSpace := NS_BTH;
    end;

    // Discovering devices.
    ResDevice := WSALookupServiceBegin(@QuerySet, Flags, LookupDevice);
    if ResDevice = 0 then begin
      while ResDevice = 0 do begin
        BufferSize := SizeOf(Buffer);
        FillChar(Buffer, BufferSize, 0);
        Results := LPWSAQUERYSET(@Buffer);

        ResDevice := WSALookupServiceNext(LookupDevice, Flags, BufferSize, Results);
        if ResDevice = 0 then begin
          CSAddr := PCSADDR_INFO(Results^.lpcsaBuffer);

          if Assigned(CSAddr) then begin
            AddrSize := SizeOf(Addr);
            FillChar(Addr, AddrSize, 0);

            if WSAAddressToString(CSAddr^.RemoteAddr.lpSockaddr, CSAddr^.RemoteAddr.iSockaddrLength, nil, Addr, AddrSize) = 0 then begin
              ADevice := TBFBluetoothDevice.Create(Radio);

              with ADevice do begin
                FAddress := Copy(string(Addr), 1, Pos(')', string(Addr)));
                FBTAddress := PSOCKADDR_BTH(CSAddr^.RemoteAddr.lpSockaddr)^.btAddr;
                FName := string(Results^.lpszServiceInstanceName);

                if NeedServices then FServices := EnumServices(FAddress, Fast, Radio);
              end;

              // Extended information. WinSock do not provide extended information
              // so we need use MS Bluetooth API.
              DeviceInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
              FillChar(DeviceInfo, DeviceInfoSize, 0);
              with DeviceInfo do begin
                dwSize := DeviceInfoSize;
                Address.ullLong := ADevice.FBTAddress;
              end;

              if BluetoothGetDeviceInfo(0, DeviceInfo) = 0 then
                with ADevice do begin
                  FAuthenticated := DeviceInfo.fAuthenticated;
                  FConnected := DeviceInfo.fConnected;
                  FClassOfDevice := DeviceInfo.ulClassofDevice;
                  FRemembered := DeviceInfo.fRemembered;
                  // If name was not recognized in WSAXXX then try retrive it here.
                  if (Trim(FName) = '') or (FName = StrDeviceNameUnknown) then FName := string(WideString(DeviceInfo.szName));
                  // This try/except block protect as when last seen date is
                  // unspecified. So it is normal!!! Do not asks me anymore
                  // why here is exception. Just read this comment and thinking a
                  // little. And you undertand!!!
                  try
                    FLastSeen := SystemTimeToDateTime(DeviceInfo.stLastSeen);
                  except
                    FLastSeen := 0;
                  end;
                  // Read comment above!!!
                  try
                    FLastUsed := SystemTimeToDateTime(DeviceInfo.stLastUsed);
                  except
                    FLastUsed := 0
                  end;
                end;

              Result.FList.Add(ADevice);
            end;
          end;
        end;
      end;

      WSALookupServiceEnd(LookupDevice);
    end;
  end;

  function DiscoveryTos: TBFBluetoothDevices;
  var
    DevInfoList: PBTDEVINFOLIST;
    Status: Long;
    Res: DWORD;
    Loop: Integer;
    Device: TBFBluetoothDevice;
    DevInfo: PBTDEVINFO;
    AInfo: PBTDEVINFO;
    ATime: FILETIME;
    Msg: TMsg;
  begin
    Result := TBFBluetoothDevices.Create;

    if Fast then begin
      DevInfo := nil;

      if BtGetRemoteDeviceList2(TOSBTAPI_DEVCOND_NOTHING, ATime, Res, DevInfo, Status) then
        if Assigned(DevInfo) then begin
          AInfo := DevInfo;

          for Loop := 0 to Res - 1 do begin
            Device := TBFBluetoothDevice.Create(Radio);
            with Device do begin
              with API do begin
                FAddress := BlueSoleilAddressToString(ReverseToshibaBTAddress(AInfo^.BdAddr));
                FBTAddress := BlueSoleilAddressToBTAddress(ReverseToshibaBTAddress(AInfo^.BdAddr));
              end;
              FAuthenticated := False;
              FConnected := False;
              FClassOfDevice := AInfo^.ClassOfDevice;
              FLastSeen := 0;
              FLastUsed := 0;
              FName := Utf8ToAnsi(string(AInfo^.FriendlyName));
              FRemembered := True;

              if NeedServices then FServices := EnumServices(FAddress, Fast, Radio);
            end;

            Result.FList.Add(Device);

            AInfo := PBTDEVINFO(Integer(AInfo) + SizeOf(BTDEVINFO));
          end;

          BtMemFree(DevInfo);
        end;

    end else begin
      DevInfoList := nil;

      if BtDiscoverRemoteDevice2(DevInfoList, TOSBTAPI_DD_NORMAL, Status, Wnd, BFNM_TOS_DISCOVERY, 0) then begin
        while True do
          if PeekMessage(Msg, Wnd, BFNM_TOS_DISCOVERY, BFNM_TOS_DISCOVERY, PM_REMOVE) then
            with Msg do
              if (WParam = TOSBTAPI_NM_DISCOVERDEVICE_ERROR) or (WParam = TOSBTAPI_NM_DISCOVERDEVICE_END) then
                Break;

        if Assigned(DevInfoList) then begin
          if Status >= TOSBTAPI_NO_ERROR then
            for Loop := 0 to DevInfoList^.dwDevListNum - 1 do begin
              Device := TBFBluetoothDevice.Create(Radio);

              with Device do begin
                with API do begin
                  FAddress := BlueSoleilAddressToString(ReverseToshibaBTAddress(DevInfoList^.DevInfo[Loop].BdAddr));
                  FBTAddress := BlueSoleilAddressToBTAddress(ReverseToshibaBTAddress(DevInfoList^.DevInfo[Loop].BdAddr));
                end;
                FAuthenticated := False;
                FConnected := False;
                FClassOfDevice := DevInfoList^.DevInfo[Loop].ClassOfDevice;
                FLastSeen := 0;
                FLastUsed := 0;
                FName := Utf8ToAnsi(string(DevInfoList^.DevInfo[Loop].FriendlyName));
                FRemembered := False;

                if NeedServices then FServices := EnumServices(FAddress, Fast, Radio);
              end;

              Result.FList.Add(Device);
            end;

          BtMemFree(DevInfoList);
        end;
      end;
    end;
  end;

begin
  // If no Bluetooth transport then raise an exception.
  API.CheckTransport(atBluetooth);

  // If there is no radio specified try to use first founded.
  if not Assigned(Radio) then begin
    NoRadio := True;
    Radio := GetFirstRadio;

  end else
    NoRadio := False;
  
  // If there is no radio - raise an exception.
  if not Assigned(Radio) then raise Exception.Create(StrRadioRequired);

  if Blocking then
    case Radio.FBluetoothAPI of
      baBlueSoleil: Result := DiscoveryIVT;
      baWidComm: Result := DiscoveryWD;
      baWinSock: Result := DiscoveryMS;
      baToshiba: Result := DiscoveryTos;

    else
      Result := nil;
    end

  else begin
    Result := nil;

    if not FNonBlocking then begin
      FNonBlocking := True;

      TBluetoothDiscoveryThread.Create(Self, Fast, NeedServices, Radio);

    end else
      raise Exception.Create(StrNonBlockingStarted);
  end;

  if NoRadio then Radio.Free;
end;

procedure TBFBluetoothDiscovery.DoDeviceFound(ADevice: TBFBluetoothDevice);
begin
  try
    if Assigned(FOnDeviceFound) then FOnDeviceFound(Self, ADevice);
  finally
    // Do not forget dispose object.
    ADevice.Free;
  end;
end;

procedure TBFBluetoothDiscovery.DoDeviceLost(ADevice: TBFBluetoothDevice);
begin
  try
    if Assigned(FOnDeviceLost) then FOnDeviceLost(Self, ADevice);
  finally
    // Do not forget dispose object.
    ADevice.Free;
  end;
end;

procedure TBFBluetoothDiscovery.DoDiscoveryBegin;
begin
  if Assigned(FOnStartMonitoring) then FOnStartMonitoring(Self);
end;

procedure TBFBluetoothDiscovery.DoDiscoveryEnd;
begin
  if Assigned(FOnStopMonitoring) then FOnStopMonitoring(Self);
end;

procedure TBFBluetoothDiscovery.DoSearchBegin;
begin
  if Assigned(FOnStartSearch) then FOnStartSearch(Self);
end;

procedure TBFBluetoothDiscovery.DoSerachEnd;
begin
  if Assigned(FOnStopSearch) then FOnStopSearch(Self);
end;

function TBFBluetoothDiscovery.EnumCOMPorts: TBFCOMPorts;
var
  Values: TStringList;
  PortStr: string;
  Loop: Integer;
  Port: TBFCOMPort;
begin
  Result := TBFCOMPorts.Create;

  try
    Values := TStringList.Create;

    try
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_LOCAL_MACHINE;

          if OpenKey('HARDWARE\DEVICEMAP\SERIALCOMM', False) then begin
            GetValueNames(Values);

            for Loop := 0 to Values.Count - 1 do begin
              PortStr := ReadString(Values[Loop]);

              if (Length(PortStr) > 3) and (Copy(PortStr, 1, 3) = 'COM') then begin
                Port := TBFCOMPort.Create;

                with Port do begin
                  FName := PortStr;
                  FNumber := StrToInt(Copy(PortStr, 4, Length(PortStr)));
                end;

                Result.FList.Add(Port);
              end;
            end;

            CloseKey;
          end;

        finally
          Free;
        end;

    finally
      Values.Free;
    end;

  except
    Result.Free;

    raise;
  end;
end;

function TBFBluetoothDiscovery.EnumRadios: TBFBluetoothRadios;
var
  Radios: TBFBluetoothRadios;

  procedure EnumRadioIVT;
  var
    DeviceInfo: BLUETOOTH_DEVICE_INFO_EX;
    DeviceInfoSize: DWORD;
    Res: DWORD;
    ARadio: TBFBluetoothRadio;
  begin
    DeviceInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO_EX);
    FillChar(DeviceInfo, DeviceInfoSize, 0);
    DeviceInfo.dwSize := DeviceInfoSize;

    Res := BT_GetLocalDeviceInfo(MASK_DEVICE_CLASS or MASK_LMP_VERSION or MASK_DEVICE_NAME or MASK_DEVICE_ADDRESS, DeviceInfo);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);

    ARadio := TBFBluetoothRadio.Create;

    with ARadio do begin
      FAddress := API.BlueSoleilAddressToString(DeviceInfo.address);
      FBluetoothAPI := baBlueSoleil;
      FBTAddress := API.BlueSoleilAddressToBTAddress(DeviceInfo.address);
      FClassOfDevice := API.BlueSoleilClassOfDeviceToCOD(DeviceInfo.classOfDevice);
      FManufacturer := DeviceInfo.wManuName;
      FName := UTF8Decode(string(DeviceInfo.szName));
      FSubversion := DeviceInfo.wLmpSubversion;
    end;

    Radios.FList.Add(ARadio);
  end;

  procedure EnumRadioMS;
  var
    Find: HBLUETOOTH_RADIO_FIND;
    FindParams: BLUETOOTH_FIND_RADIO_PARAMS;
    RadioInfo: BLUETOOTH_RADIO_INFO;
    RadioInfoSize: DWORD;
    HRadio: THandle;
    ARadio: TBFBluetoothRadio;
  begin
    FindParams.dwSize := SizeOf(BLUETOOTH_FIND_RADIO_PARAMS);
    RadioInfoSize := SizeOf(BLUETOOTH_RADIO_INFO);

    Find := BluetoothFindFirstRadio(@FindParams, HRadio);
    if Find <> 0 then begin
      repeat
        FillChar(RadioInfo, RadioInfoSize, 0);
        RadioInfo.dwSize := RadioInfoSize;

        if BluetoothGetRadioInfo(HRadio, RadioInfo) = 0 then begin
          ARadio := TBFBluetoothRadio.Create;

          with ARadio, RadioInfo do begin
            FAddress := API.BlueSoleilAddressToString(address.rgBytes);
            FBluetoothAPI := baWinSock;
            FBTAddress := address.ullLong;
            FClassOfDevice := ulClassofDevice;
            FManufacturer := manufacturer;
            FName := string(WideString(szName));
            FSubversion := lmpSubversion;
          end;

          Radios.FList.Add(ARadio);
        end;

        CloseHandle(HRadio);
      until not BluetoothFindNextRadio(Find, HRadio);

      BluetoothFindRadioClose(Find);
    end;
  end;

  procedure EnumRadioTos;
  var
    Status: Long;
    DevInfo: BTLOCALDEVINFO2;
    ARadio: TBFBluetoothRadio;
    COD: CLASSOFDEV;
    AName: FRIENDLYNAME;
  begin
    Result := nil;

    FillChar(DevInfo, SizeOf(BTLOCALDEVINFO2), 0);

    if BtGetLocalInfo2(@DevInfo, Status) then begin
      ARadio := TBFBluetoothRadio.Create;

      with ARadio, DevInfo do begin
        with API do begin
          FAddress := BlueSoleilAddressToString(ReverseToshibaBTAddress(DevInfo.BdAddr));
          FBluetoothAPI := baToshiba;
          FBTAddress := BlueSoleilAddressToBTAddress(ReverseToshibaBTAddress(DevInfo.BdAddr));
        end;

        with Version do begin
          FManufacturer := wManufactureName;
          FSubversion := wLMPSubVer;
        end;

        FillChar(COD, SizeOf(CLASSOFDEV), 0);
        if BtGetClassOfDevice(@COD, Status) then FClassOfDevice := COD;

        FillChar(AName, SizeOf(FRIENDLYNAME), 0);
        if BtGetLocalDeviceName(@AName, Status) then FName := Utf8ToAnsi(string(AName));
      end;

      Radios.FList.Add(ARadio);

    end else
      API.RaiseTosError(Status);
  end;

  procedure EnumRadioWD;
  var
    DevVerInfo: DEV_VER_INFO;
    ARadio: TBFBluetoothRadio;
    AName: BD_NAME;
  begin
    FillChar(DevVerInfo, SizeOf(DEV_VER_INFO), 0);
    FillChar(AName, SizeOf(BD_NAME), 0);

    if WD_GetLocalDeviceVersionInfo(@DevVerInfo) then begin
      ARadio := TBFBluetoothRadio.Create;

      with ARadio, DevVerInfo do begin
        FAddress := API.BlueSoleilAddressToString(bd_addr);
        FBluetoothAPI := baWidComm;
        FBTAddress := API.BlueSoleilAddressToBTAddress(bd_addr);
        FManufacturer := DevVerInfo.manufacturer;
        FSubversion := lmp_sub_version;
      end;

      if WD_GetLocalDeviceName(@AName) then ARadio.FName := Utf8ToAnsi(string(AName));

      Radios.FList.Add(ARadio);

    end else
      raise Exception.Create(StrUnableToReadLocalRadioInfo);
  end;

begin
  API.CheckTransport(atBluetooth);

  Radios := TBFBluetoothRadios.Create;

  try
    if baBlueSoleil in API.BluetoothAPIs then EnumRadioIVT;
    if baWidComm in API.BluetoothAPIs then EnumRadioWD;
    if baWinSock in API.BluetoothAPIs then EnumRadioMS;
    if baToshiba in API.BluetoothAPIs then EnumRadioTos;

  except
    Radios.Free;

    raise;
  end;

  Result := Radios;
end;

function TBFBluetoothDiscovery.GetMonitoring: Boolean;
begin
  Result := Assigned(FThread);
end;

procedure TBFBluetoothDiscovery.BFNMDiscoveryCompleteEvent(var Message: TMessage);
var
  Devices: TBFBluetoothDevices;
begin
  FNonBlocking := False;
  Devices := TBFBluetoothDevices(Message.wParam);
  if Assigned(FOnComplete) then
    FOnComplete(Self, Devices)
    
  else
    if Assigned(Devices) then
      Devices.Free; 
end;

type
  PfmSelectBluetoothDevice = ^TfmSelectBluetoothDevice;

  TBFBluetoothDiscoveryThread = class(TBFBaseThread)
  private
    FDevices: TBFBluetoothDevices;
    FFast: Boolean;
    FForm: PfmSelectBluetoothDevice;

    procedure FillDevices;

  protected
    procedure Execute; override;

  public
    constructor Create(AForm: PfmSelectBluetoothDevice; Fast: Boolean);
  end;

function TBFBluetoothDiscovery.CheckDevice(const Address: string): Boolean;
var
  Client: TBFClient;
begin
  Client := TBFClient.Create(nil);

  try
    with Client do begin
      BluetoothTransport.Address := Address;
      BluetoothTransport.ServiceUUID := OBEXObjectPushServiceClass_UUID;
      ConnectTimeOut := 5000;
      
      Open;
      Close;
    end;

    Result := True;

  except
    Result := False;
  end;

  Client.Free;
end;

{ TBFBluetoothDiscoveryThread }

  procedure TBFBluetoothDiscoveryThread.FillDevices;
  var
    Loop: Integer;
    Discovery: TBFBluetoothDiscovery;
    Radios: TBFBluetoothRadios;
    Group: TLVGROUP;
    Device: TBFBluetoothDevice;
    ItemA: BFAPI.TLVITEMA;
    Ndx: Integer;

    function GetRadioGroup(ARadio: TBFBluetoothRadio): Integer;
    var
      Loop: Integer;
    begin
      Result := -1;

      for Loop := 0 to Radios.Count - 1 do
        if Radios[Loop].BluetoothAPI = ARadio.BluetoothAPI then begin
          Result := Loop;
          Break;
        end;
    end;

  begin
    if Assigned(FDevices) and Assigned(FForm^) then
      with FForm^ do begin
        Tag := Integer(FDevices);
        with ListView.Items do begin
          BeginUpdate;
          Clear;

          for Loop := 0 to FDevices.Count - 1 do
            with Add do begin
              Caption := FDevices[Loop].FName;

              case FDevices[Loop].FClassOfDevice and COD_DEVICE_CLASS_MASK of
                COD_COMPCLS_UNCLASSIFIED: ImageIndex := 7;
                COD_COMPCLS_DESKTOP: ImageIndex := 7;
                COD_COMPCLS_SERVER: ImageIndex := 7;
                COD_COMPCLS_LAPTOP: ImageIndex := 8;
                COD_COMPCLS_HANDHELD: ImageIndex := 8;
                COD_COMPCLS_PALMSIZED: ImageIndex := 8;
                COD_COMPCLS_WEARABLE: ImageIndex := 8;

                COD_PHONECLS_UNCLASSIFIED: ImageIndex := 9;
                COD_PHONECLS_CELLULAR: ImageIndex := 9;
                COD_PHONECLS_CORDLESS: ImageIndex := 9;
                COD_PHONECLS_SMARTPHONE: ImageIndex := 9;
                COD_PHONECLS_WIREDMODEM: ImageIndex := 9;
                COD_PHONECLS_COMMONISDNACCESS: ImageIndex := 9;
                COD_PHONECLS_SIMCARDREADER: ImageIndex := 9;

                COD_LAP_FULL: ImageIndex := 6;
                COD_LAP_17: ImageIndex := 6;
                COD_LAP_33: ImageIndex := 6;
                COD_LAP_50: ImageIndex := 6;
                COD_LAP_67: ImageIndex := 6;
                COD_LAP_83: ImageIndex := 6;
                COD_LAP_99: ImageIndex := 6;
                COD_LAP_NOSRV: ImageIndex := 6;

                COD_AV_UNCLASSIFIED: ImageIndex := 10;
                COD_AV_HEADSET: ImageIndex := 10;
                COD_AV_HANDSFREE: ImageIndex := 10;
                COD_AV_HEADANDHAND: ImageIndex := 10;
                COD_AV_MICROPHONE: ImageIndex := 10;
                COD_AV_LOUDSPEAKER: ImageIndex := 10;
                COD_AV_HEADPHONES: ImageIndex := 10;
                COD_AV_PORTABLEAUDIO: ImageIndex := 10;
                COD_AV_CARAUDIO: ImageIndex := 10;
                COD_AV_SETTOPBOX: ImageIndex := 10;
                COD_AV_HIFIAUDIO: ImageIndex := 10;
                COD_AV_VCR: ImageIndex := 10;
                COD_AV_VIDEOCAMERA: ImageIndex := 10;
                COD_AV_CAMCORDER: ImageIndex := 10;
                COD_AV_VIDEOMONITOR: ImageIndex := 10;
                COD_AV_VIDEODISPANDLOUDSPK: ImageIndex := 10;
                COD_AV_VIDEOCONFERENCE: ImageIndex := 10;
                COD_AV_GAMEORTOY: ImageIndex := 10;

                COD_PERIPHERAL_KEYBOARD: ImageIndex := 5;
                COD_PERIPHERAL_POINT: ImageIndex := 5;
                COD_PERIPHERAL_KEYORPOINT: ImageIndex := 5;
                COD_PERIPHERAL_UNCLASSIFIED: ImageIndex := 5;
                COD_PERIPHERAL_JOYSTICK: ImageIndex := 5;
                COD_PERIPHERAL_GAMEPAD: ImageIndex := 5;
                COD_PERIPHERAL_REMCONTROL: ImageIndex := 5;
                COD_PERIPHERAL_SENSE: ImageIndex := 5;

                COD_IMAGE_DISPLAY: ImageIndex := 4;
                COD_IMAGE_CAMERA: ImageIndex := 2;
                COD_IMAGE_SCANNER: ImageIndex := 12;
                COD_IMAGE_PRINTER: ImageIndex := 11;

              else
                ImageIndex := 0;
              end;

              Data := FDevices[Loop];
            end;

          EndUpdate;
        end;

        stWait.Visible := False;
        ProgressBar.Visible := False;
        btCancel.Enabled := True;

        SendMessage(ListView.Handle, LVM_ENABLEGROUPVIEW, 1, 0);
        
        try
          Discovery := TBFBluetoothDiscovery.Create(nil);

          try
            Radios := Discovery.EnumRadios();

            if Assigned(Radios) then begin
              for Loop := 0 to Radios.Count - 1 do begin
                FillChar(Group, SizeOf(TLVGROUP), 0);

                with Group do begin
                  cbSize := SizeOf(TLVGROUP);
                  mask := LVGF_HEADER or LVGF_ALIGN or LVGF_GROUPID;
                  pszHeader := PWideChar(WideString(Radios[Loop].FullName));
                  cchHeader := Length(Group.pszHeader);
                  iGroupIdL := Loop;
                  uAlign := LVGA_HEADER_LEFT;
                end;

                SendMessage(ListView.Handle, LVM_INSERTGROUP, 0, Longint(@Group));
              end;

              for Loop := 0 to ListView.Items.Count - 1 do begin
                Device := TBFBluetoothDevice(ListView.Items[Loop].Data);
                Ndx := GetRadioGroup(Device.Radio);

                if Ndx > -1 then begin
                  FillChar(ItemA, SizeOf(TLVITEMA), 0);

                  with ItemA do begin
                    mask := LVIF_GROUPID;
                    iItem := Loop;
                    iGroupId := Ndx;
                  end;
                end;

                SendMessage(ListView.Handle, LVM_SETITEM, 0, Longint(@ItemA));
              end;

              Radios.Free;
            end;

          finally
            Discovery.Free;
          end;

        except
        end;
      end;
  end;

  constructor TBFBluetoothDiscoveryThread.Create(AForm: PfmSelectBluetoothDevice; Fast: Boolean);
  begin
    FDevices := nil;
    FFast := Fast;
    FForm := AForm;

    FreeOnTerminate := True;

    inherited Create(False);
  end;

  procedure TBFBluetoothDiscoveryThread.Execute;
  var
    Radios: TBFBluetoothRadios;
    ADevices: TBFBluetoothDevices;
    ADevice: TBFBluetoothDevice;
    Loop: Integer;
    DevNdx: Integer;
  begin
    // Discovery devices.
    with TBFBluetoothDiscovery.Create(nil) do begin
      FDevices := TBFBluetoothDevices.Create;

      try
        Radios := EnumRadios;

        if Assigned(Radios) then begin
          for Loop := 0 to Radios.Count - 1 do
            try
              ADevices := Discovery(Radios[Loop], FFast);

              if Assigned(ADevices) then begin
                for DevNdx := 0 to ADevices.Count - 1 do begin
                  ADevice := TBFBluetoothDevice.Create(nil);
                  ADevice.Assign(ADevices[DevNdx]);
                  FDevices.FList.Add(ADevice);
                end; 

                ADevices.Free;
              end;

            except
            end;

          Radios.Free;
        end;

      except
        if Assigned(FDevices) then begin
          FDevices.Free;
          FDevices := nil;
        end;
      end;

      Free;
    end;

    Synchronize(FillDevices);
  end;

function TBFBluetoothDiscovery.SelectDevice(Fast: Boolean): TBFBluetoothDevice;
var
  AForm: TfmSelectBluetoothDevice;
begin
  Result := nil;
  API.CheckTransport(atBluetooth);

  // Shows select form.
  AForm := TfmSelectBluetoothDevice.Create(Screen.ActiveForm);

  with AForm do begin
    TBFBluetoothDiscoveryThread.Create(@AForm, Fast);

    if ShowModal = mrOK then begin
      // If device selected then copies it into result.
      Result := TBFBluetoothDevice.Create(nil);
      Result.Assign(TBFBluetoothDevice(ListView.Selected.Data));
    end;

    Free;
  end;

  AForm := nil;
end;

procedure TBFBluetoothDiscovery.StartMonitoring(Radio: TBFBluetoothRadio; AlwaysNew: Boolean = False; NeedServices: Boolean = True);
var
  NoRadio: Boolean;
begin
  API.CheckTransport(atBluetooth);

  if not Assigned(Radio) then begin
    NoRadio := True;
    Radio := GetFirstRadio;

  end else
    NoRadio := False;

  if not Assigned(Radio) then raise Exception.Create(StrRadioRequired);

  if not Assigned(FThread) then FThread := TBFBluetoothMonitoringThread.Create(Radio, Self, AlwaysNew, NeedServices);

  if NoRadio then Radio.Free;
end;

procedure TBFBluetoothDiscovery.StopMonitoring;
begin
  if Assigned(FThread) then begin
    with FThread do begin
      Terminate;
      WaitFor;
      Free;
    end;

    FThread := nil;
  end;
end;

{ TBFBluetoothMonitoringThread }

constructor TBFBluetoothMonitoringThread.Create(ARadio: TBFBluetoothRadio; ADiscovery: TBFBluetoothDiscovery; AAlwaysNew: Boolean; ANeedServices: Boolean);
begin
  FAlwaysNew := AAlwaysNew;
  FDiscovery := ADiscovery;
  FNeedServices := ANeedServices;
  FRadio := TBFBluetoothRadio.Create;
  FRadio.Assign(ARadio);

  FreeOnTerminate := False;

  inherited Create(False);
end;

destructor TBFBluetoothMonitoringThread.Destroy;
begin
  FRadio.Free;
  
  inherited;
end;

procedure TBFBluetoothMonitoringThread.Execute;
var
  Discovery: TBFBluetoothDiscovery;
  OldDevices: TBFBluetoothDevices;
  NewDevices: TBFBluetoothDevices;
  Devices: TBFBluetoothDevices;
  Loop: Integer;
  ADevice: TBFBluetoothDevice;
begin
  PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, 0, NM_DISCOVERY_BEGIN);

  // Initialization.
  Discovery := TBFBluetoothDiscovery.Create(FDiscovery);
  OldDevices := TBFBluetoothDevices.Create;
  NewDevices := TBFBluetoothDevices.Create;

  while not Terminated do begin
    PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, 0, NM_DISCOVERY_SEARCH_BEGIN);

    // Trying discovery devices.
    try
      Devices := Discovery.Discovery(FRadio, False, FNeedServices);
    except
      Devices := nil;
    end;

    if Assigned(Devices) then begin
      // Building new devices list. We adds only connected devices. Not
      // remembered.
      for Loop := 0 to Devices.Count - 1 do
        if (FRadio.BluetoothAPI in [baBlueSoleil, baWidComm, baToshiba]) or ((FRadio.BluetoothAPI = baWinSock) and Devices[Loop].Connected) then begin
          ADevice := TBFBluetoothDevice.Create(nil);
          ADevice.Assign(Devices[Loop]);
          NewDevices.FList.Add(ADevice);
        end;

      if FAlwaysNew then
        for Loop := 0 to NewDevices.Count - 1 do begin
          // All founded devices reports as New.
          ADevice := TBFBluetoothDevice.Create(nil);
          ADevice.Assign(NewDevices[Loop]);

          // Main thread must dispose object.
          PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_FOUND);
        end
        
      else
        // Checks for new founded devices.
        for Loop := 0 to NewDevices.Count - 1 do
          if OldDevices.IndexOf(NewDevices[Loop].FBTAddress) = -1 then begin
            // New device found. Send message to main thread about this fact.
            // Main thread MUST dispose object.
            ADevice := TBFBluetoothDevice.Create(nil);
            ADevice.Assign(NewDevices[Loop]);

            PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_FOUND);
          end;

      // Check for losted devices.
      for Loop := 0 to OldDevices.Count - 1 do
        if NewDevices.IndexOf(OldDevices[Loop].FBTAddress) = -1 then begin
          // Old device losted. Send message to main thread about this fact.
          // Main thread MUST dispose object.
          ADevice := TBFBluetoothDevice.Create(nil);
          ADevice.Assign(OldDevices[Loop]);

          PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_LOST);
        end;

      // Now nes devices be a old devices.
      OldDevices.Assign(NewDevices);
      NewDevices.FList.Clear;

      // Dispose object.
      Devices.Free;
    end;

    PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, 0, NM_DISCOVERY_SEARCH_END);

    // Delay.
    Sleep(FDiscovery.FDelay);
  end;

  // Finalization.
  NewDevices.Free;
  OldDevices.Free;
  Discovery.Free;

  PostMessage(FDiscovery.Wnd, BFNM_BLUETOOTH_DISCOVERY_EVENT, 0, NM_DISCOVERY_END);
end;

{ TBFIrDADiscovery }

procedure TBFIrDADiscovery.BFNMDiscoveryCompleteEvent(var Message: TMessage);
var
  Devices: TBFIrDADevices;
begin
  FNonBlocking := False;
  
  Devices := TBFIrDADevices(Message.wParam);
  if Assigned(FOnComplete) then
    FOnComplete(Self, Devices)
    
  else
    if Assigned(Devices) then
      Devices.Free;
end;

procedure TBFIrDADiscovery.BFNMIrDADiscoveryEvent(var Message: TMessage);
begin
  case Message.LParam of
    NM_DISCOVERY_BEGIN: DoDiscoveryBegin;
    NM_DISCOVERY_END: DoDiscoveryEnd;
    NM_DISCOVERY_SEARCH_BEGIN: DoSearchBegin;
    NM_DISCOVERY_SEARCH_END: DoSerachEnd;
    NM_DISCOVERY_DEVICE_FOUND: DoDeviceFound(TBFIrDADevice(Message.WParam));
    NM_DISCOVERY_DEVICE_LOST: DoDeviceLost(TBFIrDADevice(Message.WParam));
  end;

  Message.Result := Integer(True);
end;

constructor TBFIrDADiscovery.Create(AOwner: TComponent);
begin
  inherited;

  // Initialization.
  FDelay := 1000;
  FNonBlocking := False;
  FThread := nil;

  FOnComplete := nil;
  FOnDeviceFound := nil;
  FOnDeviceLost := nil;
  FOnStartMonitoring := nil;
  FOnStartSearch := nil;
  FOnStopMonitoring := nil;
  FOnStopSearch := nil;
end;

destructor TBFIrDADiscovery.Destroy;
begin
  StopMonitoring;

  inherited;
end;

type
  TIrDADiscoveryThread = class(TThread)
  private
    FWnd: HWND;

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner: TBFIrDADiscovery);
  end;

  constructor TIrDADiscoveryThread.Create(AOwner: TBFIrDADiscovery);
  begin
    FWnd := AOwner.Wnd;

    FreeOnTerminate := True;
    inherited Create(False);
  end;

  procedure TIrDADiscoveryThread.Execute;
  var
    Discovery: TBFIrDADiscovery;
    Devices: TBFIrDADevices;
  begin
    Devices := nil;

    try
      Discovery := TBFIrDADiscovery.Create(nil);

      try
        Devices := Discovery.Discovery;

      finally
        Discovery.Free;
      end;

    except
    end;

    try
      if not PostMessage(FWnd, BFNM_DISCOVERY_COMPLETE_EVENT, Integer(Devices), 0) then raise Exception.Create('Post message error');

    except
      if Assigned(Devices) then Devices.Free;
    end;
  end;

function TBFIrDADiscovery.Discovery(Blocking: Boolean = True): TBFIrDADevices;
var
  ASocket: TSocket;
  DeviceListBuffer: array [0..SizeOf(DEVICELIST) - SizeOf(IRDA_DEVICE_INFO) + (SizeOf(IRDA_DEVICE_INFO) * DEVICE_LIST_LEN)] of Byte;
  DeviceListSize: Integer;
  DeviceList: PDEVICELIST;
  Loop: Integer;
  ADevice: TBFIrDADevice;
begin
  API.CheckTransport(atIrDA);

  if Blocking then begin
    // Trying to create IrDA socket.
    ASocket := socket(AF_IRDA, SOCK_STREAM, 0);
    if ASocket = INVALID_SOCKET then RaiseLastOSError;

    try
      // Preparing fo discovery.
      DeviceListSize := SizeOf(DeviceListBuffer);
      DeviceList := PDEVICELIST(@DeviceListBuffer);
      DeviceList^.numDevice := 0;

      // Discovery devices.
      if getsockopt(ASocket, SOL_IRLMP, IRLMP_ENUMDEVICES, PChar(DeviceList), DeviceListSize) = SOCKET_ERROR then RaiseLastOSError;

      // Something found. Parsering...
      Result := TBFIrDADevices.Create;

      for Loop := 0 to DeviceList^.numDevice - 1 do begin
        ADevice := TBFIrDADevice.Create;

        with ADevice, DeviceList^.Device[Loop] do begin
          FAddress := API.IrDAAddressToString(irdaDeviceID);
          FCharSet := irdaCharSet;
          FHints1 := irdaDeviceHints1;
          FHints2 := irdaDeviceHints2;
          FIrDAAddress := irdaDeviceID;
          FName := string(irdaDeviceName);
        end;

        Result.FList.Add(ADevice);
      end;
    
    finally
      // Close socket.
      closesocket(ASocket);
    end;

  end else begin
    Result := nil;

    if not FNonBlocking then begin
      FNonBlocking := True;

      TIrDADiscoveryThread.Create(Self);

    end else
      raise Exception.Create(StrNonBlockingStarted);
  end;
end;

procedure TBFIrDADiscovery.DoDeviceFound(ADevice: TBFIrDADevice);
begin
  try
    if Assigned(FOnDeviceFound) then FOnDeviceFound(Self, ADevice);
  finally
    // Do not forget dispose object.
    ADevice.Free;
  end;
end;

procedure TBFIrDADiscovery.DoDeviceLost(ADevice: TBFIrDADevice);
begin
  try
    if Assigned(FOnDeviceLost) then FOnDeviceLost(Self, ADevice);
  finally
    // Do not forget dispose object.
    ADevice.Free;
  end;
end;

procedure TBFIrDADiscovery.DoDiscoveryBegin;
begin
  if Assigned(FOnStartMonitoring) then FOnStartMonitoring(Self);
end;

procedure TBFIrDADiscovery.DoDiscoveryEnd;
begin
  if Assigned(FOnStopMonitoring) then FOnStopMonitoring(Self);
end;

procedure TBFIrDADiscovery.DoSearchBegin;
begin
  if Assigned(FOnStartSearch) then FOnStartSearch(Self);
end;

procedure TBFIrDADiscovery.DoSerachEnd;
begin
  if Assigned(FOnStopSearch) then FOnStopSearch(Self);
end;

function TBFIrDADiscovery.GetMonitoring: Boolean;
begin
  Result := Assigned(FThread);
end;

type
  PfmSelectIrDADevice = ^TfmSelectIrDADevice;

  TBFIrDADiscoveryThread = class(TBFBaseThread)
  private
    FDevices: TBFIrDADevices;
    FForm: PfmSelectIrDADevice;

    procedure FillDevices;

  protected
    procedure Execute; override;

  public
    constructor Create(AForm: PfmSelectIrDADevice);
  end;

  { TBFIrDADiscoveryThread }

  procedure TBFIrDADiscoveryThread.FillDevices;
  var
    Loop: Integer;
  begin
    if Assigned(FDevices) and Assigned(FForm^) then
      with FForm^ do begin
        Tag := Integer(FDevices);
        with ListView.Items do begin
          BeginUpdate;
          Clear;

          for Loop := 0 to FDevices.Count - 1 do
            with Add do begin
              Caption := FDevices[Loop].FName;
              ImageIndex := 0;
              Data := FDevices[Loop];
            end;

          EndUpdate;
        end;

        stWait.Visible := False;
        ProgressBar.Visible := False;
        btCancel.Enabled := True;
      end;
  end;

  constructor TBFIrDADiscoveryThread.Create(AForm: PfmSelectIrDADevice);
  begin
    FDevices := nil;
    FForm := AForm;

    FreeOnTerminate := True;

    inherited Create(False);
  end;

  procedure TBFIrDADiscoveryThread.Execute;
  begin
    // Discovery devices.
    with TBFIrDADiscovery.Create(nil) do begin
      FDevices := Discovery;
      Free;
    end;

    Synchronize(FillDevices);
  end;

function TBFIrDADiscovery.SelectDevice: TBFIrDADevice;
var
  AForm: TfmSelectIrDADevice;
begin
  Result := nil;
  API.CheckTransport(atIrDA);

  // Shows select form.
  AForm := TfmSelectIrDADevice.Create(Screen.ActiveForm);

  with AForm do begin
    TBFIrDADiscoveryThread.Create(@AForm);

    if ShowModal = mrOK then begin
      // If device selected then copies it into result.
      Result := TBFIrDADevice.Create;
      Result.Assign(TBFIrDADevice(ListView.Selected.Data));
    end;

    Free;
  end;

  AForm := nil;
end;

procedure TBFIrDADiscovery.SetMonitoring(const Value: Boolean);
begin
  if Value then
    StartMonitoring
  else
    StopMonitoring;
end;

procedure TBFIrDADiscovery.StartMonitoring(AlwaysNew: Boolean = False);
begin
  API.CheckTransport(atIrDA);

  if not Assigned(FThread) then FThread := TBFIrDAMonitoringThread.Create(Self, AlwaysNew);
end;

procedure TBFIrDADiscovery.StopMonitoring;
begin
  if Assigned(FThread) then begin
    with FThread do begin
      Terminate;
      WaitFor;
      Free;
    end;

    FThread := nil;
  end;
end;

{ TBFIrDAMonitoringThread }

constructor TBFIrDAMonitoringThread.Create(Discovery: TBFIrDADiscovery; AAlwaysNew: Boolean);
begin
  FAlwaysNew := AAlwaysNew;
  FDiscovery := Discovery;

  FreeOnTerminate := False;

  inherited Create(False);
end;

procedure TBFIrDAMonitoringThread.Execute;
var
  Discovery: TBFIrDADiscovery;
  NewDevices: TBFIrDADevices;
  OldDevices: TBFIrDADevices;
  Devices: TBFIrDADevices;
  Loop: Integer;
  ADevice: TBFIrDADevice;
begin
  PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, 0, NM_DISCOVERY_BEGIN);

  // Initialization.
  Discovery := TBFIrDADiscovery.Create(FDiscovery);
  OldDevices := TBFIrDADevices.Create;
  NewDevices := TBFIrDADevices.Create;

  while not Terminated do begin
    PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, 0, NM_DISCOVERY_SEARCH_BEGIN);

    // Trying discovery devices.
    try
      Devices := Discovery.Discovery;
    except
      Devices := nil;
    end;

    // Building new devices list. We adds only connected devices. Not
    // remembered.
    NewDevices.Assign(Devices);

    // Dispose object.
    if Assigned(Devices) then Devices.Free;

    if FAlwaysNew then
      // Devices always reports as new.
      for Loop := 0 to NewDevices.Count - 1 do begin
        // New device found. Send message to main thread about this fact.
        // Main thread MUST dispose object.
        ADevice := TBFIrDADevice.Create;
        ADevice.Assign(NewDevices[Loop]);

        PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_FOUND);
      end

    else
      // Checks for new founded devices.
      for Loop := 0 to NewDevices.Count - 1 do
        if OldDevices.IndexOf(NewDevices[Loop].FIrDAAddress) = -1 then begin
          // New device found. Send message to main thread about this fact.
          // Main thread MUST dispose object.
          ADevice := TBFIrDADevice.Create;
          ADevice.Assign(NewDevices[Loop]);

          PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_FOUND);
        end;

    // Check for losted devices.
    for Loop := 0 to OldDevices.Count - 1 do
      if NewDevices.IndexOf(OldDevices[Loop].FIrDAAddress) = -1 then begin
        // Old device losted. Send message to main thread about this fact.
        // Main thread MUST dispose object.
        ADevice := TBFIrDADevice.Create;
        ADevice.Assign(OldDevices[Loop]);
        
        PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, Integer(ADevice), NM_DISCOVERY_DEVICE_LOST);
      end;

    // Now nes devices be a old devices.
    OldDevices.Assign(NewDevices);
    NewDevices.FList.Clear;

    PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, 0, NM_DISCOVERY_SEARCH_END);

    // Delay.
    Sleep(FDiscovery.FDelay);
  end;

  NewDevices.Free;
  OldDevices.Free;
  Discovery.Free;

  PostMessage(FDiscovery.Wnd, BFNM_IRDA_DISCOVERY_EVENT, 0, NM_DISCOVERY_END);
end;

{ TBFBluetoothDiscoveryX }

function _TBFBluetoothDiscoveryX.CheckDevice(const Address: string): Boolean;
begin
  Result := FBFBluetoothDiscovery.CheckDevice(Address);
end;

constructor _TBFBluetoothDiscoveryX.Create(AOwner: TComponent);
begin
  inherited;

  FBFBluetoothDiscovery := TBFBluetoothDiscovery.Create(nil);
end;

destructor _TBFBluetoothDiscoveryX.Destroy;
begin
  FBFBluetoothDiscovery.Free;

  inherited;
end;

function _TBFBluetoothDiscoveryX.Discovery(Radio: TBFBluetoothRadio; Fast, NeedServices, Blocking: Boolean): TBFBluetoothDevices;
begin
  Result := FBFBluetoothDiscovery.Discovery(Radio, Fast, NeedServices, Blocking);
end;

function _TBFBluetoothDiscoveryX.EnumCOMPorts: TBFCOMPorts;
begin
  Result := FBFBluetoothDiscovery.EnumCOMPorts;
end;

function _TBFBluetoothDiscoveryX.EnumRadios: TBFBluetoothRadios;
begin
  Result := FBFBluetoothDiscovery.EnumRadios;
end;

function _TBFBluetoothDiscoveryX.GetDelay: Integer;
begin
  Result := FBFBluetoothDiscovery.Delay;
end;

function _TBFBluetoothDiscoveryX.GetMonitoring: Boolean;
begin
  Result := FBFBluetoothDiscovery.Monitoring;
end;

function _TBFBluetoothDiscoveryX.GetOnComplete: TBFBluetoothDiscoveryComplete;
begin
  Result := FBFBluetoothDiscovery.OnComplete;
end;

function _TBFBluetoothDiscoveryX.GetOnDeviceFound: TBFBluetoothDeviceMonitoringEvent;
begin
  Result := FBFBluetoothDiscovery.OnDeviceFound;
end;

function _TBFBluetoothDiscoveryX.GetOnDeviceLost: TBFBluetoothDeviceMonitoringEvent;
begin
  Result := FBFBluetoothDiscovery.OnDeviceLost;
end;

function _TBFBluetoothDiscoveryX.GetOnStartMonitoring: TBFDiscoveryEvent;
begin
  Result := FBFBluetoothDiscovery.OnStartMonitoring;
end;

function _TBFBluetoothDiscoveryX.GetOnStartSearch: TBFDiscoveryEvent;
begin
  Result := FBFBluetoothDiscovery.OnStartSearch;
end;

function _TBFBluetoothDiscoveryX.GetOnStopMonitoring: TBFDiscoveryEvent;
begin
  Result := FBFBluetoothDiscovery.OnStopMonitoring;
end;

function _TBFBluetoothDiscoveryX.GetOnStopSearch: TBFDiscoveryEvent;
begin
  Result := FBFBluetoothDiscovery.OnStopSearch;
end;

function _TBFBluetoothDiscoveryX.SelectDevice(Fast: Boolean): TBFBluetoothDevice;
begin
  Result := FBFBluetoothDiscovery.SelectDevice(Fast);
end;

procedure _TBFBluetoothDiscoveryX.SetDelay(const Value: Integer);
begin
  FBFBluetoothDiscovery.Delay := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnComplete(const Value: TBFBluetoothDiscoveryComplete);
begin
  FBFBluetoothDiscovery.OnComplete := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnDeviceFound(const Value: TBFBluetoothDeviceMonitoringEvent);
begin
  FBFBluetoothDiscovery.OnDeviceFound := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnDeviceLost(const Value: TBFBluetoothDeviceMonitoringEvent);
begin
  FBFBluetoothDiscovery.OnDeviceLost := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnStartMonitoring(const Value: TBFDiscoveryEvent);
begin
  FBFBluetoothDiscovery.OnStartMonitoring := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnStartSearch(const Value: TBFDiscoveryEvent);
begin
  FBFBluetoothDiscovery.OnStartSearch := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnStopMonitoring(const Value: TBFDiscoveryEvent);
begin
  FBFBluetoothDiscovery.OnStopMonitoring := Value;
end;

procedure _TBFBluetoothDiscoveryX.SetOnStopSearch(const Value: TBFDiscoveryEvent);
begin
  FBFBluetoothDiscovery.OnStopSearch := Value;
end;

procedure _TBFBluetoothDiscoveryX.StartMonitoring(Radio: TBFBluetoothRadio; AlwaysNew, NeedServices: Boolean);
begin
  FBFBluetoothDiscovery.StartMonitoring(Radio, AlwaysNew, NeedServices);
end;

procedure _TBFBluetoothDiscoveryX.StopMonitoring;
begin
  FBFBluetoothDiscovery.StopMonitoring;
end;

{ TBFIrDADiscoveryX }

constructor _TBFIrDADiscoveryX.Create(AOwner: TComponent);
begin
  inherited;

  FBFIrDADiscovery := TBFIrDADiscovery.Create(nil);
end;

destructor _TBFIrDADiscoveryX.Destroy;
begin
  FBFIrDADiscovery.Free;
  
  inherited;
end;

function _TBFIrDADiscoveryX.Discovery(Blocking: Boolean): TBFIrDADevices;
begin
  Result := FBFIrDADiscovery.Discovery(Blocking);
end;

function _TBFIrDADiscoveryX.GetDelay: Integer;
begin
  Result := FBFIrDADiscovery.Delay;
end;

function _TBFIrDADiscoveryX.GetMonitoring: Boolean;
begin
  Result := FBFIrDADiscovery.Monitoring;
end;

function _TBFIrDADiscoveryX.GetOnComplete: TBFIrDADiscoveryComplete;
begin
  Result := FBFIrDADiscovery.OnComplete;
end;

function _TBFIrDADiscoveryX.GetOnDeviceFound: TBFIrDADeviceMonitoringEvent;
begin
  Result := FBFIrDADiscovery.OnDeviceFound;
end;

function _TBFIrDADiscoveryX.GetOnDeviceLost: TBFIrDADeviceMonitoringEvent;
begin
  Result := FBFIrDADiscovery.OnDeviceLost;
end;

function _TBFIrDADiscoveryX.GetOnStartMonitoring: TBFDiscoveryEvent;
begin
  Result := FBFIrDADiscovery.OnStartMonitoring;
end;

function _TBFIrDADiscoveryX.GetOnStartSearch: TBFDiscoveryEvent;
begin
  Result := FBFIrDADiscovery.OnStartSearch;
end;

function _TBFIrDADiscoveryX.GetOnStopMonitoring: TBFDiscoveryEvent;
begin
  Result := FBFIrDADiscovery.OnStopMonitoring;
end;

function _TBFIrDADiscoveryX.GetOnStopSearch: TBFDiscoveryEvent;
begin
  Result := FBFIrDADiscovery.OnStopSearch;
end;

function _TBFIrDADiscoveryX.SelectDevice: TBFIrDADevice;
begin
  Result := FBFIrDADiscovery.SelectDevice;
end;

procedure _TBFIrDADiscoveryX.SetDelay(const Value: Integer);
begin
  FBFIrDADiscovery.Delay := Value;
end;

procedure _TBFIrDADiscoveryX.SetMonitoring(const Value: Boolean);
begin
  FBFIrDADiscovery.Monitoring := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnComplete(const Value: TBFIrDADiscoveryComplete);
begin
  FBFIrDADiscovery.OnComplete := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnDeviceFound(const Value: TBFIrDADeviceMonitoringEvent);
begin
  FBFIrDADiscovery.OnDeviceFound := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnDeviceLost(const Value: TBFIrDADeviceMonitoringEvent);
begin
  FBFIrDADiscovery.OnDeviceLost := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnStartMonitoring(const Value: TBFDiscoveryEvent);
begin
  FBFIrDADiscovery.OnStartMonitoring := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnStartSearch(const Value: TBFDiscoveryEvent);
begin
  FBFIrDADiscovery.OnStartSearch := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnStopMonitoring(const Value: TBFDiscoveryEvent);
begin
  FBFIrDADiscovery.OnStopMonitoring := Value;
end;

procedure _TBFIrDADiscoveryX.SetOnStopSearch(const Value: TBFDiscoveryEvent);
begin
  FBFIrDADiscovery.OnStopSearch := Value;
end;

procedure _TBFIrDADiscoveryX.StartMonitoring(AlwaysNew: Boolean);
begin
  FBFIrDADiscovery.StartMonitoring(AlwaysNew);
end;

procedure _TBFIrDADiscoveryX.StopMonitoring;
begin
  FBFIrDADiscovery.StopMonitoring;
end;

end.



