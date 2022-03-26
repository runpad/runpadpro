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
unit BFAPI;

{$I BF.inc}

interface

uses
  BFBase, Windows, Messages, ActiveX, BFStrings, Classes, CommCtrl;

const
  CR = #$0D;
  LF = #$0A;
  CRLF = CR + LF;
  CTRLZ = ^Z;

  RESP_OK = CRLF + 'OK' + CRLF;
  RESP_ERROR = 'ERROR';
  RESP_OTHER = CRLF + '>';

  DEVICE_ADDRESS_LENGTH = 6;
  DEVICE_CLASS_LENGTH = 3;

  BFNM_MIN_NUMBER                = WM_USER + 3000;
  BFNM_BLUETOOTH_DISCOVERY_EVENT = WM_USER + 3000;
  BFNM_IRDA_DISCOVERY_EVENT      = WM_USER + 3001;
  BFNM_AUTHENTICATION_EVENT      = WM_USER + 3002;
  BFNM_KEYPAD_EVENT              = WM_USER + 3003;
  BFNM_SMS_DELIVER_EVENT         = WM_USER + 3004;
  BFNM_SMS_REPORT_EVENT          = WM_USER + 3005;
  BFNM_SERVER_EVENT              = WM_USER + 3006;
  BFNM_CLIENT_EVENT              = WM_USER + 3007;
  BFNM_DISCOVERY_COMPLETE_EVENT  = WM_USER + 3008;
  BFNM_TOS_CONNECTSDP            = WM_USER + 3009;
  BFNM_TOS_DISCOVERY             = WM_USER + 3010;
  BFNM_TOS_SSAEND                = WM_USER + 3011;
  BFNM_TOS_REFRESHEND            = WM_USER + 3012;
  BFNM_TOS_CLIENTCONNECTED       = WM_USER + 3013;
  BFNM_MASSSENDER_EVENT          = WM_USER + 3014;
  BFNM_MAX_NUMBER                = WM_USER + 3099;

  NM_DISCOVERY_BEGIN = 1;
  NM_DISCOVERY_END = 2;
  NM_DISCOVERY_SEARCH_BEGIN = 3;
  NM_DISCOVERY_SEARCH_END = 4;
  NM_DISCOVERY_DEVICE_FOUND = 5;
  NM_DISCOVERY_DEVICE_LOST = 6;
  NM_AUTHENTICATION_PIN = 7;
  NM_AUTHENTICATION_RESULT = 8;
  NM_SERVER_DATA = 9;
  NM_SERVER_CONNECT = 10;
  NM_SERVER_DISCONNECT = 11;
  NM_WD_SERVER_DATA = 12;
  NM_CLIENT_DATA = 13;
  NM_CLIENT_CLOSE = 14;
  NM_SENDER_STARTED = 15;
  NM_SENDER_STOPPED = 16;
  NM_SENDER_DISCOVERY_STARTED = 17;
  NM_SENDER_DISCOVERY_COMPLETE = 18;
  NM_SENDER_ACCEPT_DEVICE = 19;
  NM_SENDER_NEED_FILE = 20;
  NM_SENDER_SEND_START = 21;
  NM_SENDER_SEND_COMPLETE = 22;
  NM_SENDER_SEND_VCARD_COMPLETE = 23;
  NM_SENDER_SEND_VCARD_START = 24;
  NM_SENDER_SEND_FILE_COMPLETE = 25;
  NM_SENDER_SEND_FILE_START = 26;
  NM_SENDER_PROGRESS = 27;

  UNKNOWN_PORT = $FFFFFFFF;

type
  BTH_ADDR = Int64;
  IRDA_ADDR = array [0..3] of Char;

  PBTUUID = ^BTUUID;
  BTUUID = array [0..15] of Byte;

  // Array of bytes.
  TBFByteArray = array of Byte;

  // Supported API transports.
  TBFAPITransport = (atBluetooth, atIrDA, atCOM);
  TBFAPITransports = set of TBFAPITransport;
  // Supported Bluetooth APIs.
  TBFBluetoothAPI = (baBlueSoleil, baWinSock, baWidComm, baToshiba);
  PBFBluetoothAPI = ^TBFBluetoothAPI;
  TBFBluetoothAPIs = set of TBFBluetoothAPI;

  // Bluesoleil and MS Bluetooth address as Bytes array.
  TBluetoothAddress = array [0..DEVICE_ADDRESS_LENGTH - 1] of Byte;
  PBluetoothAddress = ^TBluetoothAddress;
  // BlueSoleil Class Of Device representation.
  TBluetoothClassOfDevice = array [0..DEVICE_CLASS_LENGTH - 1] of Byte;

  // API class.
  TBFAPI = class(TBFBaseClass)
  private
    FBluetoothAPIs: TBFBluetoothAPIs;
    FBSLibrary: THandle;
    FTosLibrary: THandle;
    FWDLibrary: THandle;
    FWSLibrary: THandle;
    FTransports: TBFAPITransports;
    FWinSockBluetooth: Boolean;
    FWinSockInitialized: Boolean;
    FWinSockIrDA: Boolean;
    FWnd: HWND;
    FRAPILibrary: THandle;

    function GetActiveSync: Boolean;
    function TransportTagToName(ATag: TBFAPITransport): string;

    procedure LoadAPIs;
    procedure UnloadAPIs;
    procedure WndProc(var Message: TMessage);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Converts BlueSoleil Bluetooth adress to BTH_ADDR.
    function BlueSoleilAddressToBTAddress(Addr: TBluetoothAddress): BTH_ADDR;
    // Converts BlueSoleil Bluetooth adress to string.
    function BlueSoleilAddressToString(Addr: TBluetoothAddress): string;
    // Converts BlueSoleil Class of device to Bluetooth COD.
    function BlueSoleilClassOfDeviceToCOD(COD: TBluetoothClassOfDevice; WidComm: Boolean = False): DWORD;
    // Conver ClassOfDevice to String.
    function ClassOfDeviceToString(ClassOfDevice: DWORD): string;
    // Converts IrDA address to string representation.
    function IrDAAddressToString(IrDAAddress: IRDA_ADDR): string;
    // Reverse Bluetooth address for using with Toshiba API.
    function ReverseToshibaBTAddress(BTAddress: TBluetoothAddress): TBluetoothAddress;
    // Converts string bluetooth adress to TBluetoothAddress
    function StringToBluetoothAddress(Address: string): TBluetoothAddress;
    // Converts string representation of the IrDA address to native IrDA address.
    function StringToIrDAAddress(Address: string): IRDA_ADDR;
    // Converts service name to UUID.
    function StringToUUID(Name: string): TGUID;
    // Convert UUID to BTUUID.
    function UUIDToBtUUID(GUID: TGUID): BTUUID;
    // Converts UUID to service name.
    function UUIDToString(UUID: TGUID): string;
    // Converts long UUID to short UUID 16.
    function UUIDToUUID16(UUID: TGUID): Word;
    // Converts short UUID 16 to long UUID.
    function UUID16ToUUID(UUID16: Word): TGUID;

    // Checks Bluetooth adress format.
    procedure CheckBluetoothAddress(Address: string);
    // Raises exception if requeried transport not supported or not
    // available.
    procedure CheckTransport(ATransport: TBFAPITransport);
    // Raises Toshiba errors.
    procedure RaiseTosError(Status: Integer);

    property ActiveSync: Boolean read GetActiveSync;
    // Which API used for Bluetooth communications.
    property BluetoothAPIs: TBFBluetoothAPIs read FBluetoothAPIs;
    // Returns set of available transports.
    property Transports: TBFAPITransports read FTransports;
  end;

  // TBFAPIInfo is a component for easy access to API information.
  TBFAPIInfo = class(TBFBaseComponent)
  private
    function GetBluetoothAPIs: TBFBluetoothAPIs;
    function GetTransports: TBFAPITransports;
    function GetActiveSync: Boolean;

  public
    // Raises exception if requeried transport not supported or not
    // available.
    procedure CheckTransport(ATransport: TBFAPITransport);
    // Redetect APIs;
    procedure Redetect;

  published
    property ActiveSync: Boolean read GetActiveSync;
    // Which API used for Bluetooth communications.
    property BluetoothAPIs: TBFBluetoothAPIs read GetBluetoothAPIs;
    // Returns set of available transports.
    property Transports: TBFAPITransports read GetTransports;
  end;

  _TBFAPIInfoX = class(_TBFActiveXControl)
  private
    FBFAPIInfo: TBFAPIInfo;

    function GetBluetoothAPIs: TBFBluetoothAPIs;
    function GetTransports: TBFAPITransports;
    function GetActiveSync: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CheckTransport(ATransport: TBFAPITransport);
    procedure Redetect;

  published
    property ActiveSync: Boolean read GetActiveSync;
    property BluetoothAPIs: TBFBluetoothAPIs read GetBluetoothAPIs;
    property Transports: TBFAPITransports read GetTransports;
  end;

const
  WSADESCRIPTION_LEN = 256;
  WSASYS_STATUS_LEN = 128;

  INQUIRY_PAIRED = $02;
  INQUIRY_GENERAL_REFRESH = $03;

  // Maximum discovered devices.
  MAX_DEVICE_COUNT = 100;
  // Deximum discovered service.
  MAX_SERVICES = 50;
  // Maximun discovered IrDA devices. More then 10 is not normal. ut who knowns?
  DEVICE_LIST_LEN = 10;

  MAX_DEVICE_NAME_LENGTH = 64;
  MAX_SERVICE_NAME_LENGTH = 128;
  MAX_PIN_CODE_LENGTH = 16;

  BTSTATUS_FAIL = $00000000;
  BTSTATUS_SUCCESS = $00000001;
  BTSTATUS_SYSTEM_ERROR = $00000002;
  BTSTATUS_BT_NOT_READY = $00000003;
  BTSTATUS_ALREADY_PAIRED = $00000004;
  BTSTATUS_AUTHENTICATE_FAILED = $00000005;
  BTSTATUS_BT_BUSY = $00000006;
  BTSTATUS_CONNECTION_EXIST = $00000007;
  BTSTATUS_CONNECTION_NOT_EXIST = $00000008;
  BTSTATUS_PARAMETER_ERROR = $00000009;
  BTSTATUS_SERVICE_NOT_EXIST = $0000000a;
  BTSTATUS_DEVICE_NOT_EXIST = $0000000b;

  BTSTATUS_STRINGS: array [BTSTATUS_FAIL..BTSTATUS_DEVICE_NOT_EXIST] of string =
    (StrBTStatusStringGeneralFail,
     StrBTStatusStringGeneralSuccess,
     StrBTStatusStringSystemError,
     StrBTStatusStringBluetoothNotReady,
     StrBTStatusStringBlusoleilAlreadyPaired,
     StrBTStatusStringAuthenticationFails,
     StrBTStatusStringBluetoothBusy,
     StrBTStatusStringConnectionExists,
     StrBTStatusStringConnectionNotExists,
     StrBTStatusStringParameterError,
     StrBTStatusStringServiceNotExists,
     StrBTStatusStringDeviceNotExists);

  MASK_CONNECT_STATUS = $00000040;
  MASK_DEVICE_CLASS = $00000002;
  MASK_LMP_VERSION = $00000008;
  MASK_DEVICE_NAME = $00000001;
  MASK_DEVICE_ADDRESS = $00000004;
  MASK_PAIR_STATUS = $00000080;
  MASK_SIGNAL_STRENGTH = $00000800;

  BTM_SEC_OUT_AUTHENTICATE = $0010;
  BTM_SEC_OUT_ENCRYPT = $0020;

  LUP_CONTAINERS = $0002;
  LUP_RETURN_NAME = $0010;
  LUP_RETURN_TYPE = $0020;
  LUP_RETURN_COMMENT = $0080;
  LUP_RETURN_ADDR = $0100;
  LUP_RETURN_BLOB = $0200;
  LUP_FLUSHCACHE = $1000;
  LUP_RES_SERVICE = $8000;

  COD_FORMAT_MASK = $000003;
  COD_MINOR_DEVICE_CLASS_MASK = $0000FC;
  COD_MAJOR_DEVICE_CLASS_MASK = $001F00;
  COD_SERVICE_CLASS_MASK = $FFE000;
  COD_DEVICE_CLASS_MASK = COD_MAJOR_DEVICE_CLASS_MASK or COD_MINOR_DEVICE_CLASS_MASK;

  COD_SRVCLS_LIMITED = $002000;
  COD_SRVCLS_POSITION = $010000;
  COD_SRVCLS_NETWORK = $020000;
  COD_SRVCLS_RENDER = $040000;
  COD_SRVCLS_CAPTURE = $080000;
  COD_SRVCLS_OBJECT = $100000;
  COD_SRVCLS_AUDIO = $200000;
  COD_SRVCLS_TELEPHONE = $400000;
  COD_SRVCLS_INFOR = $800000;

  COD_DEVCLS_MISC = $000000;
  COD_DEVCLS_COMPUTER = $000100;
  COD_DEVCLS_PHONE = $000200;
  COD_DEVCLS_LAP = $000300;
  COD_DEVCLS_AUDIO = $000400;
  COD_DEVCLS_PERIPHERAL = $000500;
  COD_DEVCLS_IMAGE = $000600;
  COD_DEVCLS_UNCLASSIFIED = $001F00;

  COD_COMPCLS_UNCLASSIFIED = COD_DEVCLS_COMPUTER or $000000;
  COD_COMPCLS_DESKTOP = COD_DEVCLS_COMPUTER or $000004;
  COD_COMPCLS_SERVER = COD_DEVCLS_COMPUTER or $000008;
  COD_COMPCLS_LAPTOP = COD_DEVCLS_COMPUTER or $00000C;
  COD_COMPCLS_HANDHELD = COD_DEVCLS_COMPUTER or $000010;
  COD_COMPCLS_PALMSIZED = COD_DEVCLS_COMPUTER or $000014;
  COD_COMPCLS_WEARABLE = COD_DEVCLS_COMPUTER or $000018;

  COD_PHONECLS_UNCLASSIFIED = COD_DEVCLS_PHONE or $000000;
  COD_PHONECLS_CELLULAR = COD_DEVCLS_PHONE or $000004;
  COD_PHONECLS_CORDLESS = COD_DEVCLS_PHONE or $000008;
  COD_PHONECLS_SMARTPHONE = COD_DEVCLS_PHONE or $00000C;
  COD_PHONECLS_WIREDMODEM = COD_DEVCLS_PHONE or $000010;
  COD_PHONECLS_COMMONISDNACCESS = COD_DEVCLS_PHONE or $000014;
  COD_PHONECLS_SIMCARDREADER = COD_DEVCLS_PHONE or $000018;

  COD_LAP_FULL = COD_DEVCLS_LAP or $000000;
  COD_LAP_17 = COD_DEVCLS_LAP or $000002;
  COD_LAP_33 = COD_DEVCLS_LAP or $000004;
  COD_LAP_50 = COD_DEVCLS_LAP or $000006;
  COD_LAP_67 = COD_DEVCLS_LAP or $000008;
  COD_LAP_83 = COD_DEVCLS_LAP or $00000A;
  COD_LAP_99 = COD_DEVCLS_LAP or $00000C;
  COD_LAP_NOSRV = COD_DEVCLS_LAP or $00000D;

  COD_AV_UNCLASSIFIED = COD_DEVCLS_AUDIO or $000000;
  COD_AV_HEADSET = COD_DEVCLS_AUDIO or $000004;
  COD_AV_HANDSFREE = COD_DEVCLS_AUDIO or $000008;
  COD_AV_HEADANDHAND = COD_DEVCLS_AUDIO or $00000C;
  COD_AV_MICROPHONE = COD_DEVCLS_AUDIO or $000010;
  COD_AV_LOUDSPEAKER = COD_DEVCLS_AUDIO or $000014;
  COD_AV_HEADPHONES = COD_DEVCLS_AUDIO or $000018;
  COD_AV_PORTABLEAUDIO = COD_DEVCLS_AUDIO or $00001C;
  COD_AV_CARAUDIO = COD_DEVCLS_AUDIO or $000020;
  COD_AV_SETTOPBOX = COD_DEVCLS_AUDIO or $000024;
  COD_AV_HIFIAUDIO = COD_DEVCLS_AUDIO or $000028;
  COD_AV_VCR = COD_DEVCLS_AUDIO or $00002C;
  COD_AV_VIDEOCAMERA = COD_DEVCLS_AUDIO or $000030;
  COD_AV_CAMCORDER = COD_DEVCLS_AUDIO or $000034;
  COD_AV_VIDEOMONITOR = COD_DEVCLS_AUDIO or $000038;
  COD_AV_VIDEODISPANDLOUDSPK = COD_DEVCLS_AUDIO or $00003C;
  COD_AV_VIDEOCONFERENCE = COD_DEVCLS_AUDIO or $000040;
  COD_AV_GAMEORTOY = COD_DEVCLS_AUDIO or $000048;

  COD_PERIPHERAL_KEYBOARD = COD_DEVCLS_PERIPHERAL or $000040;
  COD_PERIPHERAL_POINT = COD_DEVCLS_PERIPHERAL or $000080;
  COD_PERIPHERAL_KEYORPOINT = COD_DEVCLS_PERIPHERAL or $0000C0;
  COD_PERIPHERAL_UNCLASSIFIED = COD_DEVCLS_PERIPHERAL or $000000;
  COD_PERIPHERAL_JOYSTICK = COD_DEVCLS_PERIPHERAL or $000004;
  COD_PERIPHERAL_GAMEPAD = COD_DEVCLS_PERIPHERAL or $000008;
  COD_PERIPHERAL_REMCONTROL = COD_DEVCLS_PERIPHERAL or $00000C;
  COD_PERIPHERAL_SENSE = COD_DEVCLS_PERIPHERAL or $000010;

  COD_IMAGE_DISPLAY = COD_DEVCLS_IMAGE or $000010;
  COD_IMAGE_CAMERA = COD_DEVCLS_IMAGE or $000020;
  COD_IMAGE_SCANNER = COD_DEVCLS_IMAGE or $000040;
  COD_IMAGE_PRINTER = COD_DEVCLS_IMAGE or $000080;

  COD_SERVICE_OBJECT_XFER = $0080;

  NS_BTH = 16;
  AF_BTH = 32;

  MAX_PROTOCOL_CHAIN = 7;
  WSAPROTOCOL_LEN = 255;

  BLUETOOTH_MAX_NAME_SIZE = 248;

  SDP_TYPE_SEQUENCE = $06;

  AF_IRDA = 26;
  BF_IRDA = AF_IRDA;

  SOCK_STREAM = 1;

  SOL_IRLMP = $00FF;

  IRLMP_ENUMDEVICES = $00000010;
  IRLMP_9WIRE_MODE = $00000016;

  SOCKET_ERROR = -1;

  BD_NAME_LEN = 248;

  MAX_DEVICES = 50;

  BT_PORT_ANY = -1;

  DCB_BINARY = $00000001;
  DCB_PARITYCHECK = $00000002;
  DCB_RTSCONTROLENABLE = $00001000;
  DCB_DTRCONTROLENABLE = $00000010;
  DCB_OUTXCTSFLOW = $00000004;
  DCB_RTSCONTROLHANDSHAKE = $00002000;
  DCB_OUTX = $00000100;
  DCB_INX = $00000200;

  FD_READ_BIT = 0;
  FD_READ = 1 shl FD_READ_BIT;
  FD_ACCEPT_BIT = 3;
  FD_ACCEPT = 1 shl FD_ACCEPT_BIT;
  FD_CONNECT_BIT = 4;
  FD_CONNECT = 1 shl FD_CONNECT_BIT;
  FD_CLOSE_BIT = 5;
  FD_CLOSE = 1 shl FD_CLOSE_BIT;

  FD_MAX_EVENTS = 10;

  SOL_SOCKET = $FFFF;

  SO_SNDBUF = $1001;
  SO_RCVBUF = $1002;
  SO_SNDTIMEO = $1005;
  SO_RCVTIMEO = $1006;
  SO_REUSEADDR = $0004; 

  BTHPROTO_RFCOMM = $0003;
  BTHPROTO_L2CAP = $0100;
  SOL_RFCOMM = BTHPROTO_RFCOMM;

  WSAECONNABORTED = 10053;
  WSAECONNRESET = 10054;
  WSAETIMEDOUT = 10060;

  BT_MAX_SERVICE_NAME_LEN = 100;

  SO_BTH_AUTHENTICATE = $80000001;
  SO_BTH_ENCRYPT = $00000002;

  IAS_MAX_OCTET_STRING = 1024;
  IAS_MAX_USER_STRING = 256;
  IAS_MAX_CLASSNAME = 64;
  IAS_MAX_ATTRIBNAME = 256;

  IAS_SET_ATTRIB_MAX_LEN = 32;

  IAS_ATTRIB_STR = $00000003;
  IRLMP_IAS_SET = $00000011;

  EVENT_AUTHENTICATION = $01;
  EVENT_PIN_CODE_REQUEST = $02;
  EVENT_CONNECTION_STATUS = $03;
  EVENT_DUN_RAS_CALLBACK = $04;
  EVENT_ERROR = $05;
  EVENT_INQUIRY_DEVICE_REPORT = $06;
  EVENT_SPPEX_CONNECTION_STATUS = $07;
  EVENT_BLUETOOTH_STATUS = $08;
  EVENT_PAN_NOTIFICATION = $09;
  EVENT_AUTHORIZE_REQUEST = $0A;

  STATUS_INCOMING_CONNECT = $01;
  STATUS_INCOMING_DISCONNECT = $03;

  BTM_SEC_NONE = $00;
  BTM_SEC_IN_AUTHENTICATE = $02;
  BTM_SEC_IN_ENCRYPT = $04;

  BLUETOOTH_SERVICE_DISABLE  = $00;
  BLUETOOTH_SERVICE_ENABLE   = $01;

  L2CAP_PROTOCOL_UUID: TGUID = '{00000100-0000-1000-8000-00805F9B34FB}';

  BaseBluetoothServiceClassID_UUID: TGUID = '{00000000-0000-1000-8000-00805F9B34FB}';

  ServiceDiscoveryServerServiceClassID_UUID: TGUID = '{00001000-0000-1000-8000-00805F9B34FB}';
  BrowseGroupDescriptorServiceClassID_UUID: TGUID = '{00001001-0000-1000-8000-00805F9B34FB}';
  PublicBrowseGroupServiceClass_UUID: TGUID = '{00001002-0000-1000-8000-00805F9B34FB}';
  SerialPortServiceClass_UUID: TGUID = '{00001101-0000-1000-8000-00805F9B34FB}';
  LANAccessUsingPPPServiceClass_UUID: TGUID = '{00001102-0000-1000-8000-00805F9B34FB}';
  DialupNetworkingServiceClass_UUID: TGUID = '{00001103-0000-1000-8000-00805F9B34FB}';
  IrMCSyncServiceClass_UUID: TGUID = '{00001104-0000-1000-8000-00805F9B34FB}';
  OBEXObjectPushServiceClass_UUID: TGUID = '{00001105-0000-1000-8000-00805F9B34FB}';
  OBEXFileTransferServiceClass_UUID: TGUID = '{00001106-0000-1000-8000-00805F9B34FB}';
  IrMCSyncCommandServiceClass_UUID: TGUID = '{00001107-0000-1000-8000-00805F9B34FB}';
  HeadsetServiceClass_UUID: TGUID = '{00001108-0000-1000-8000-00805F9B34FB}';
  CordlessTelephonyServiceClass_UUID: TGUID = '{00001109-0000-1000-8000-00805F9B34FB}';
  AudioSourceServiceClass_UUID: TGUID = '{0000110A-0000-1000-8000-00805F9B34FB}';
  AudioSinkServiceClass_UUID: TGUID = '{0000110B-0000-1000-8000-00805F9B34FB}';
  AVRemoteControlTargetServiceClass_UUID: TGUID = '{0000110C-0000-1000-8000-00805F9B34FB}';
  AdvancedAudioDistributionServiceClass_UUID: TGUID = '{0000110D-0000-1000-8000-00805F9B34FB}';
  AVRemoteControlServiceClass_UUID: TGUID = '{0000110E-0000-1000-8000-00805F9B34FB}';
  VideoConferencingServiceClass_UUID: TGUID = '{0000110F-0000-1000-8000-00805F9B34FB}';
  IntercomServiceClass_UUID: TGUID = '{00001110-0000-1000-8000-00805F9B34FB}';
  FaxServiceClass_UUID: TGUID = '{00001111-0000-1000-8000-00805F9B34FB}';
  HeadsetAudioGatewayServiceClass_UUID: TGUID = '{00001112-0000-1000-8000-00805F9B34FB}';
  WAPServiceClass_UUID: TGUID = '{00001113-0000-1000-8000-00805F9B34FB}';
  WAPClientServiceClass_UUID: TGUID = '{00001114-0000-1000-8000-00805F9B34FB}';
  PANUServiceClass_UUID: TGUID = '{00001115-0000-1000-8000-00805F9B34FB}';
  NAPServiceClass_UUID: TGUID = '{00001116-0000-1000-8000-00805F9B34FB}';
  GNServiceClass_UUID: TGUID = '{00001117-0000-1000-8000-00805F9B34FB}';
  DirectPrintingServiceClass_UUID: TGUID = '{00001118-0000-1000-8000-00805F9B34FB}';
  ReferencePrintingServiceClass_UUID: TGUID = '{00001119-0000-1000-8000-00805F9B34FB}';
  ImagingServiceClass_UUID: TGUID = '{0000111A-0000-1000-8000-00805F9B34FB}';
  ImagingResponderServiceClass_UUID: TGUID = '{0000111B-0000-1000-8000-00805F9B34FB}';
  ImagingAutomaticArchiveServiceClass_UUID: TGUID = '{0000111C-0000-1000-8000-00805F9B34FB}';
  ImagingReferenceObjectsServiceClass_UUID: TGUID = '{0000111D-0000-1000-8000-00805F9B34FB}';
  HandsfreeServiceClass_UUID: TGUID = '{0000111E-0000-1000-8000-00805F9B34FB}';
  HandsfreeAudioGatewayServiceClass_UUID: TGUID = '{0000111F-0000-1000-8000-00805F9B34FB}';
  DirectPrintingReferenceObjectsServiceClass_UUID: TGUID = '{00001120-0000-1000-8000-00805F9B34FB}';
  ReflectedUIServiceClass_UUID: TGUID = '{00001121-0000-1000-8000-00805F9B34FB}';
  BasicPringingServiceClass_UUID: TGUID = '{00001122-0000-1000-8000-00805F9B34FB}';
  PrintingStatusServiceClass_UUID: TGUID = '{00001123-0000-1000-8000-00805F9B34FB}';
  HumanInterfaceDeviceServiceClass_UUID: TGUID = '{00001124-0000-1000-8000-00805F9B34FB}';
  HardcopyCableReplacementServiceClass_UUID: TGUID = '{00001125-0000-1000-8000-00805F9B34FB}';
  HCRPrintServiceClass_UUID: TGUID = '{00001126-0000-1000-8000-00805F9B34FB}';
  HCRScanServiceClass_UUID: TGUID = '{00001127-0000-1000-8000-00805F9B34FB}';
  CommonISDNAccessServiceClass_UUID: TGUID = '{00001128-0000-1000-8000-00805F9B34FB}';
  VideoConferencingGWServiceClass_UUID: TGUID = '{00001129-0000-1000-8000-00805F9B34FB}';
  UDIMTServiceClass_UUID: TGUID = '{0000112A-0000-1000-8000-00805F9B34FB}';
  UDITAServiceClass_UUID: TGUID = '{0000112B-0000-1000-8000-00805F9B34FB}';
  AudioVideoServiceClass_UUID: TGUID = '{0000112C-0000-1000-8000-00805F9B34FB}';
  SIMAccessServiceClass_UUID: TGUID = '{0000112D-0000-1000-8000-00805F9B34FB}';
  PnPInformationServiceClass_UUID: TGUID = '{00001200-0000-1000-8000-00805F9B34FB}';
  GenericNetworkingServiceClass_UUID: TGUID = '{00001201-0000-1000-8000-00805F9B34FB}';
  GenericFileTransferServiceClass_UUID: TGUID = '{00001202-0000-1000-8000-00805F9B34FB}';
  GenericAudioServiceClass_UUID: TGUID = '{00001203-0000-1000-8000-00805F9B34FB}';
  GenericTelephonyServiceClass_UUID: TGUID = '{00001204-0000-1000-8000-00805F9B34FB}';
  NokiaOBEXPCSuiteServiceClass_UUID: TGUID = '{00005005-0000-1000-8000-0002EE000001}';
  SyncMLClientServiceClass_UUID: TGUID = '{00000002-0000-1000-8000-0002EE000002}';

type
  PBFPIN = ^TBFPIN;
  TBFPIN = array [0..MAX_PIN_CODE_LENGTH - 1] of Char;

  TUUIDString = record
    Name: string;
    UUID: TGUID;
  end;

  HBLUETOOTH_CONTAINER_ELEMENT = THandle;

  PWSAData = ^WSAData;
  WSAData = record
    wVersion: Word;
    wHighVersion: Word;
    szDescription: array [0..WSADESCRIPTION_LEN - 1] of Char;
    szSystemStatus: array [0..WSASYS_STATUS_LEN - 1] of Char;
    iMaxSockets: Word;
    iMaxUdpDg: Word;
    lpVendorInfo: PChar;
  end;

  PBLUETOOTH_FIND_RADIO_PARAMS = ^BLUETOOTH_FIND_RADIO_PARAMS;
  BLUETOOTH_FIND_RADIO_PARAMS = record
    dwSize: DWORD;
  end;

  HBLUETOOTH_RADIO_FIND = THandle;

  PIVTBLUETOOTH_DEVICE_INFO = ^IVTBLUETOOTH_DEVICE_INFO;
  IVTBLUETOOTH_DEVICE_INFO = record
    dwSize: DWORD;
    address: TBluetoothAddress;
    classOfDevice: TBluetoothClassOfDevice;
    szName: array [0..MAX_DEVICE_NAME_LENGTH- 1] of Char;
    bPaired: BOOL;
  end;

  PBLUETOOTH_ADDRESS = ^BLUETOOTH_ADDRESS;
  BLUETOOTH_ADDRESS = record
    case Integer of
      0: (ullLong: BTH_ADDR);
      1: (rgBytes: TBluetoothAddress);
  end;

  PBLUETOOTH_DEVICE_INFO_EX = ^BLUETOOTH_DEVICE_INFO_EX;
  BLUETOOTH_DEVICE_INFO_EX = record
    dwSize: DWORD;
    address: TBluetoothAddress;
    classOfDevice: TBluetoothClassOfDevice;
    szName: array [0..MAX_DEVICE_NAME_LENGTH - 1] of Char;
    bPaired: BOOL;
    ucLmpVersion: UCHAR;
    wManuName: Word;
    wLmpSubversion: Word;
    reserved: array [0..15] of Byte;
    wClockOffset: Word;
    bConnected: BOOL;
    dwDataRecvBytes: DWORD;
    dwDataSentBytes: DWORD;
    cSignalStrength: Char;
  end;

  PGENERAL_SERVICE_INFO = ^GENERAL_SERVICE_INFO;
  GENERAL_SERVICE_INFO = record
    dwSize: DWORD;
    dwServiceHandle: DWORD;
    wServiceClassUuid16: Word;
    szServiceName: array [0..MAX_SERVICE_NAME_LENGTH - 1] of Char;
  end;

  WSAECOMPARATOR = (COMP_EQUAL, COMP_NOTLESS);

  PWSAVERSION = ^WSAVERSION;
  LPWSAVERSION = PWSAVERSION;
  WSAVERSION = record
    dwVersion: DWORD;
    ecHow: WSAECOMPARATOR;
  end;

  PAFPROTOCOLS = ^AFPROTOCOLS;
  LPAFPROTOCOLS = PAFPROTOCOLS;
  AFPROTOCOLS = record
    iAddressFamily: Integer;
    iProtocol: Integer;
  end;

  u_short = Word;

  LPSOCKADDR = ^sockaddr;
  psockaddr = ^sockaddr;
  sockaddr = record
    sa_family: u_short;
    sa_data: array [0..13] of Char;
  end;

  PSOCKET_ADDRESS = ^SOCKET_ADDRESS;
  LPSOCKET_ADDRESS = PSOCKET_ADDRESS;
  SOCKET_ADDRESS = record
    lpSockaddr: LPSOCKADDR;
    iSockaddrLength: Integer;
  end;

  PCSADDR_INFO = ^CSADDR_INFO;
  LPCSADDR_INFO = PCSADDR_INFO;
  CSADDR_INFO = record
    LocalAddr: SOCKET_ADDRESS;
    RemoteAddr: SOCKET_ADDRESS;
    iSocketType: Integer;
    iProtocol: Integer;
  end;

  LPBYTE = PBYTE;

  PBLOB = ^BLOB;
  LPBLOB = PBLOB;
  BLOB = record
    cbSize: ULONG;
    pBlobData: LPBYTE;
  end;

  PWSAQUERYSET = ^WSAQUERYSET;
  LPWSAQUERYSET = PWSAQUERYSET;
  WSAQUERYSET = record
    dwSize: DWORD;
    lpszServiceInstanceName: LPSTR;
    lpServiceClassId: PGUID;
    lpVersion: LPWSAVERSION;
    lpszComment: LPSTR;
    dwNameSpace: DWORD;
    lpNSProviderId: PGUID;
    lpszContext: LPSTR;
    dwNumberOfProtocols: DWORD;
    lpafpProtocols: LPAFPROTOCOLS;
    lpszQueryString: LPSTR;
    dwNumberOfCsAddrs: DWORD;
    lpcsaBuffer: LPCSADDR_INFO;
    dwOutputFlags: DWORD;
    lpBlob: LPBLOB;
  end;

  HANDLE = THandle;

  LPWSAPROTOCOLCHAIN = ^WSAPROTOCOLCHAIN;
  WSAPROTOCOLCHAIN = record
    ChainLen: Integer;
    ChainEntries: array [0..MAX_PROTOCOL_CHAIN - 1] of DWORD;
  end;

  LPWSAPROTOCOL_INFO = ^WSAPROTOCOL_INFO;
  WSAPROTOCOL_INFO = record
    dwServiceFlags1: DWORD;
    dwServiceFlags2: DWORD;
    dwServiceFlags3: DWORD;
    dwServiceFlags4: DWORD;
    dwProviderFlags: DWORD;
    ProviderId: TGUID;
    dwCatalogEntryId: DWORD;
    ProtocolChain: WSAPROTOCOLCHAIN;
    iVersion: Integer;
    iAddressFamily: Integer;
    iMaxSockAddr: Integer;
    iMinSockAddr: Integer;
    iSocketType: Integer;
    iProtocol: Integer;
    iProtocolMaxOffset: Integer;
    iNetworkByteOrder: Integer;
    iSecurityScheme: Integer;
    dwMessageSize: DWORD;
    dwProviderReserved: DWORD;
    szProtocol: array [0..WSAPROTOCOL_LEN] of Char;
  end;

  PSOCKADDR_BTH = ^SOCKADDR_BTH;
  SOCKADDR_BTH = packed record
    addressFamily: Word;
    btAddr: BTH_ADDR;
    serviceClassId: TGUID;
    port: ULONG;
  end;

  SDP_TYPE = DWORD;
  SDP_SPECIFICTYPE = DWORD;

  PSDP_LARGE_INTEGER_16 = ^SDP_LARGE_INTEGER_16;
  LPSDP_LARGE_INTEGER_16 = ^SDP_LARGE_INTEGER_16;
  SDP_LARGE_INTEGER_16 = record
    LowPart: Int64;
    HighPart: Int64;
  end;

  PSDP_ULARGE_INTEGER_16 = ^SDP_ULARGE_INTEGER_16;
  LPSDP_ULARGE_INTEGER_16 = ^SDP_ULARGE_INTEGER_16;
  SDP_ULARGE_INTEGER_16 = record
    LowPart: Int64;
    HighPart: Int64;
  end;

  TSpdElementDataString = record
    value: PBYTE;
    length: ULONG;
  end;

  TSpdElementDataUrl = record
    value: PBYTE;
    length: ULONG;
  end;

  TSpdElementDataSequence = record
    value: PBYTE;
    length: ULONG;
  end;

  TSpdElementDataAlternative = record
    value: PBYTE;
    length: ULONG;
  end;

  PSDP_ELEMENT_DATA = ^SDP_ELEMENT_DATA;
  LPSDP_ELEMENT_DATA = ^SDP_ELEMENT_DATA;
  SDP_ELEMENT_DATA = record
    type_: SDP_TYPE;
    specificType: SDP_SPECIFICTYPE;
    case Integer of
        0: (int128: SDP_LARGE_INTEGER_16);
        1: (int64: LONGLONG);
        2: (int32: Integer);
        3: (int16: SHORT);
        4: (int8: CHAR);
        5: (uint128: SDP_ULARGE_INTEGER_16);
        6: (uint64: Int64);
        7: (uint32: ULONG);
        8: (uint16: Word);
        9: (uint8: UCHAR);
        10: (booleanVal: UCHAR);
        11: (uuid128: TGUID);
        12: (uuid32: ULONG);
        13: (uuid16: Word);
        14: (string_: TSpdElementDataString);
        15: (url: TSpdElementDataUrl);
        16: (sequence: TSpdElementDataSequence);
        17: (alternative: TSpdElementDataAlternative);
  end;

  PBLUETOOTH_DEVICE_INFO = ^BLUETOOTH_DEVICE_INFO;
  BLUETOOTH_DEVICE_INFO = record
    dwSize: DWORD;
    Address: BLUETOOTH_ADDRESS;
    ulClassofDevice: ULONG;
    fConnected: BOOL;
    fRemembered: BOOL;
    fAuthenticated: BOOL;
    stLastSeen: SYSTEMTIME;
    stLastUsed: SYSTEMTIME;
    szName: array [0..BLUETOOTH_MAX_NAME_SIZE - 1] of WideChar;
  end;

  PBLUETOOTH_RADIO_INFO = ^BLUETOOTH_RADIO_INFO;
  BLUETOOTH_RADIO_INFO = record
    dwSize: DWORD;
    address: BLUETOOTH_ADDRESS;
    szName: array [0..BLUETOOTH_MAX_NAME_SIZE - 1] of WideChar;
    ulClassofDevice: ULONG;
    lmpSubversion: Word;
    manufacturer: Word;
  end;

  TSocket = Cardinal;

  u_char = Byte;

  PIRDA_DEVICE_INFO = ^IRDA_DEVICE_INFO;
  LPIRDA_DEVICE_INFO = PIRDA_DEVICE_INFO;
  IRDA_DEVICE_INFO = record
    irdaDeviceID: IRDA_ADDR;
    irdaDeviceName: array [0..21] of Char;
    irdaDeviceHints1: u_char;
    irdaDeviceHints2: u_char;
    irdaCharSet: u_char;
  end;

  PDEVICELIST = ^DEVICELIST;
  LPDEVICELIST = PDEVICELIST;
  DEVICELIST = record
    numDevice: ULONG;
    Device: array [0..0] of IRDA_DEVICE_INFO;
  end;

  PDEV_VER_INFO = ^DEV_VER_INFO;
  DEV_VER_INFO = packed record
    bd_addr: TBluetoothAddress;
    hci_version: Byte;
    hci_revision: Word;
    lmp_version: Byte;
    manufacturer: Word;
    lmp_sub_version: Word;
  end;

  BD_NAME = array [0..BD_NAME_LEN - 1] of Char;
  PBD_NAME = ^BD_NAME;

  PDEVICE = ^DEVICE;
  DEVICE = record
    bda: TBluetoothAddress;
    dev_class: TBluetoothClassOfDevice;
    bd_name: BD_NAME;
    b_paired: BOOL;
    b_connected: BOOL;
  end;

  PDEVICE_LIST = ^DEVICE_LIST;
  DEVICE_LIST = record
    dwCount: DWORD;
    Devices: array [0..MAX_DEVICES - 1] of DEVICE;
  end;

  PSERVICE = ^SERVICE;
  SERVICE = record
    Uuid: TGUID;
    Channel: DWORD;
    Name: array [0..BT_MAX_SERVICE_NAME_LEN - 1] of Char;
  end;

  PSERVICE_LIST = ^SERVICE_LIST;
  SERVICE_LIST = record
    dwCount: DWORD;
    Services: array [0..MAX_SERVICES - 1] of SERVICE;
  end;

  PSOCKADDR_IRDA = ^SOCKADDR_IRDA;
  LPSOCKADDR_IRDA = PSOCKADDR_IRDA;
  SOCKADDR_IRDA = record
    irdaAddressFamily: u_short;
    irdaDeviceID: IRDA_ADDR;
    irdaServiceName: array [0..24] of Char;
  end;

  LPHANDLE = PHANDLE;
  WSAEVENT = HANDLE;
  LPWSAEVENT = LPHANDLE;
  PWSAEVENT = PHANDLE;

  LPWSANETWORKEVENTS = ^WSANETWORKEVENTS;
  WSANETWORKEVENTS = record
    lNetworkEvents: Longint;
    iErrorCode: array [0..FD_MAX_EVENTS - 1] of Integer;
  end;

  PSPPEX_SERVICE_INFO = ^SPPEX_SERVICE_INFO;
  SPPEX_SERVICE_INFO = record
    dwSize: DWORD;
    dwSDAPRecordHanlde: DWORD;
    serviceClassUuid128: TGUID;
    szServiceName: array [0..MAX_SERVICE_NAME_LENGTH - 1] of Char;
    ucServiceChannel: UCHAR;
    ucComIndex: UCHAR;
  end;

  PIAS_SET = ^IAS_SET;
  LPIAS_SET = PIAS_SET;
  TirdaAttribOctetSeq = record
    Len: u_short;
    OctetSeq: array [0..IAS_MAX_OCTET_STRING - 1] of u_char;
  end;

  TirdaAttribUsrStr = record
    Len: u_char;
    CharSet: u_char;
    UsrStr: array [0..IAS_MAX_USER_STRING - 1] of u_char;
  end;

  WSAESETSERVICEOP = (RNRSERVICE_REGISTER, RNRSERVICE_DEREGISTER, RNRSERVICE_DELETE); 

  Long = Integer;

  u_long = cardinal;

  IAS_SET = record
    irdaClassName: array [0..IAS_MAX_CLASSNAME - 1] of Char;
    irdaAttribName: array [0..IAS_MAX_ATTRIBNAME - 1] of Char;
    irdaAttribType: u_long;
    irdaAttribute: record
                     case Byte of
                       0: (irdaAttribInt: Long);
                       1: (irdaAttribOctetSeq: TirdaAttribOctetSeq);
                       2: (irdaAttribUsrStr: TirdaAttribUsrStr);
                   end;
  end;

  BOND_RETURN_CODE = (SUCCESS, BAD_PARAMETER, NO_BT_SERVER, ALREADY_BONDED, FAIL, REPEATED_ATTEMPTS);

  PBTH_SET_SERVICE = ^BTH_SET_SERVICE;
  LPBTH_SET_SERVICE = PBTH_SET_SERVICE;
  BTH_SET_SERVICE = packed record
    pSdpVersion: PULONG;
    pRecordHandle: PHandle;
    fCodService: ULONG;
    Reserved: array [0..4] of ULONG;
    ulRecordLength: ULONG;
    pRecord: array [0..0] of UCHAR;
  end;

  UINT32 = DWORD;
  INT32 = Integer;

  PBT_CONN_STATS = ^tBT_CONN_STATS;
  tBT_CONN_STATS = record
    bIsConnected: UINT32;
    Rssi: INT32;
    BytesSent: UINT32;
    BytesRcvd: UINT32;
    Duration: UINT32;
  end;

  HBLUETOOTH_AUTHENTICATION_REGISTRATION = THandle;

  PFN_BLUETOOTH_ENUM_ATTRIBUTES_CALLBACK = function (uAttribId: ULONG; pValueStream: PBYTE; cbStreamSize: ULONG; pvParam: Pointer): BOOL; stdcall;
  PFN_AUTHENTICATION_CALLBACK = function (pvParam: Pointer; pDevice: PBLUETOOTH_DEVICE_INFO): BOOL; stdcall;

const
  NULL_IRDA_ADDR: IRDA_ADDR = (#0, #0, #0, #0);
  INVALID_SOCKET = TSocket(not 0);
  WSA_INVALID_EVENT = WSAEVENT(nil);

  UUID_STRINGS_COUNT = 55;
  
  UUID_STRINGS_ARRAY: array [0..UUID_STRINGS_COUNT - 1] of TUUIDString = (
    (Name: StrServiceDiscoveryServer; UUID: '{00001000-0000-1000-8000-00805F9B34FB}'),
    (Name: StrBrowseGroupDescriptor; UUID: '{00001001-0000-1000-8000-00805F9B34FB}'),
    (Name: StrPublicBrowseGroup; UUID: '{00001002-0000-1000-8000-00805F9B34FB}'),
    (Name: StrSerialPort; UUID: '{00001101-0000-1000-8000-00805F9B34FB}'),
    (Name: StrLANAccessUsingPPP; UUID: '{00001102-0000-1000-8000-00805F9B34FB}'),
    (Name: StrDialupNetworking; UUID: '{00001103-0000-1000-8000-00805F9B34FB}'),
    (Name: StrIrMCSync; UUID: '{00001104-0000-1000-8000-00805F9B34FB}'),
    (Name: StrOBEXObjectPush; UUID: '{00001105-0000-1000-8000-00805F9B34FB}'),
    (Name: StrOBEXFileTransfer; UUID: '{00001106-0000-1000-8000-00805F9B34FB}'),
    (Name: StrIrMCSyncCommand; UUID: '{00001107-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHeadset; UUID: '{00001108-0000-1000-8000-00805F9B34FB}'),
    (Name: StrCordlessTelephony; UUID: '{00001109-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAudioSource; UUID: '{0000110A-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAudioSink; UUID: '{0000110B-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAVRemoteControlTarget; UUID: '{0000110C-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAdvancedAudioDistribution; UUID: '{0000110D-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAVRemoteControl; UUID: '{0000110E-0000-1000-8000-00805F9B34FB}'),
    (Name: StrVideoConferencing; UUID: '{0000110F-0000-1000-8000-00805F9B34FB}'),
    (Name: StrIntercom; UUID: '{00001110-0000-1000-8000-00805F9B34FB}'),
    (Name: StrFax; UUID: '{00001111-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHeadsetAudioGateway; UUID: '{00001112-0000-1000-8000-00805F9B34FB}'),
    (Name: StrWAP; UUID: '{00001113-0000-1000-8000-00805F9B34FB}'),
    (Name: StrWAPClient; UUID: '{00001114-0000-1000-8000-00805F9B34FB}'),
    (Name: StrPANU; UUID: '{00001115-0000-1000-8000-00805F9B34FB}'),
    (Name: StrNAP; UUID: '{00001116-0000-1000-8000-00805F9B34FB}'),
    (Name: StrGN; UUID: '{00001117-0000-1000-8000-00805F9B34FB}'),
    (Name: StrDirectPrinting; UUID: '{00001118-0000-1000-8000-00805F9B34FB}'),
    (Name: StrReferencePrinting; UUID: '{00001119-0000-1000-8000-00805F9B34FB}'),
    (Name: StrImaging; UUID: '{0000111A-0000-1000-8000-00805F9B34FB}'),
    (Name: StrImagingResponder; UUID: '{0000111B-0000-1000-8000-00805F9B34FB}'),
    (Name: StrImagingAutomaticArchive; UUID: '{0000111C-0000-1000-8000-00805F9B34FB}'),
    (Name: StrImagingReferenceObjects; UUID: '{0000111D-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHandsfree; UUID: '{0000111E-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHandsfreeAudioGateway; UUID: '{0000111F-0000-1000-8000-00805F9B34FB}'),
    (Name: StrDirectPrintingReferenceObjects; UUID: '{00001120-0000-1000-8000-00805F9B34FB}'),
    (Name: StrReflectedUI; UUID: '{00001121-0000-1000-8000-00805F9B34FB}'),
    (Name: StrBasicPringing; UUID: '{00001122-0000-1000-8000-00805F9B34FB}'),
    (Name: StrPrintingStatus; UUID: '{00001123-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHumanInterfaceDevice; UUID: '{00001124-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHardcopyCableReplacement; UUID: '{00001125-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHCRPrint; UUID: '{00001126-0000-1000-8000-00805F9B34FB}'),
    (Name: StrHCRScan; UUID: '{00001127-0000-1000-8000-00805F9B34FB}'),
    (Name: StrCommonISDNAccess; UUID: '{00001128-0000-1000-8000-00805F9B34FB}'),
    (Name: StrVideoConferencingGW; UUID: '{00001129-0000-1000-8000-00805F9B34FB}'),
    (Name: StrUDIMT; UUID: '{0000112A-0000-1000-8000-00805F9B34FB}'),
    (Name: StrUDITA; UUID: '{0000112B-0000-1000-8000-00805F9B34FB}'),
    (Name: StrAudioVideo; UUID: '{0000112C-0000-1000-8000-00805F9B34FB}'),
    (Name: StrSIMAccess; UUID: '{0000112D-0000-1000-8000-00805F9B34FB}'),
    (Name: StrPnPInformation; UUID: '{00001200-0000-1000-8000-00805F9B34FB}'),
    (Name: StrGenericNetworking; UUID: '{00001201-0000-1000-8000-00805F9B34FB}'),
    (Name: StrGenericFileTransfer; UUID: '{00001202-0000-1000-8000-00805F9B34FB}'),
    (Name: StrGenericAudio; UUID: '{00001203-0000-1000-8000-00805F9B34FB}'),
    (Name: StrGenericTelephony; UUID: '{00001204-0000-1000-8000-00805F9B34FB}'),
    (Name: StrNokiaOBEXPCSuite; UUID: '{00005005-0000-1000-8000-0002EE000001}'),
    (Name: StrSyncMLClient; UUID: '{00000002-0000-1000-8000-0002EE000002}'));

// Standard WinSock functions.
type
  PWSALookupServiceBegin = function (lpqsRestrictions: LPWSAQUERYSET; dwControlFlags: DWORD; var lphLookup: HANDLE): Integer; stdcall;
  PWSALookupServiceEnd = function (hLookup: HANDLE): Integer; stdcall;
  PWSALookupServiceNext = function (hLookup: HANDLE; dwControlFlags: DWORD; var lpdwBufferLength: DWORD; lpqsResults: LPWSAQUERYSET): Integer; stdcall;
  PWSAAddressToString = function (lpsaAddress: LPSOCKADDR; dwAddressLength: DWORD; lpProtocolInfo: LPWSAPROTOCOL_INFO; lpszAddressString: LPTSTR; var lpdwAddressStringLength: DWORD): Integer; stdcall;
  PWSACreateEvent = function : WSAEVENT; stdcall;
  PWSACloseEvent = function (hEvent: WSAEVENT): BOOL; stdcall;
  PWSAEventSelect = function (s: TSocket; hEventObject: WSAEVENT; lNetworkEvents: Longint): Integer; stdcall;
  PWSAEnumNetworkEvents = function (s: TSocket; hEventObject: WSAEVENT; lpNetworkEvents: LPWSANETWORKEVENTS): Integer; stdcall;
  PWSAStringToAddress = function (AddressString: LPTSTR; AddressFamily: Integer; lpProtocolInfo: LPWSAPROTOCOL_INFO; lpAddress: LPSOCKADDR; var lpAddressLength: Integer): Integer; stdcall;
  PWSAWaitForMultipleEvents = function (cEvents: DWORD; lphEvents: PWSAEVENT; fWaitAll: BOOL; dwTimeout: DWORD; fAlertable: BOOL): DWORD; stdcall;
  PWSASetService = function (lpqsRegInfo: LPWSAQUERYSET; essoperation: WSAESETSERVICEOP; dwControlFlags: DWORD): Integer; stdcall;
  Psocket = function (af, type_, protocol: Integer): TSocket; stdcall;
  Pclosesocket = function (s: TSocket): Integer; stdcall;
  Pgetsockopt = function (s: TSocket; level, optname: Integer; optval: PChar; var optlen: Integer): Integer; stdcall;
  Psetsockopt = function (s: TSocket; level, optname: Integer; optval: PChar; optlen: Integer): Integer; stdcall;
  Pconnect = function (s: TSocket; name: PSockAddr; namelen: Integer): Integer; stdcall;
  Precv = function (s: TSocket; var buf; len, flags: Integer): Integer; stdcall;
  Psend = function (s: TSocket; var buf; len, flags: Integer): Integer; stdcall;
  Pbind = function (s: TSocket; name: PSockAddr; namelen: Integer): Integer; stdcall;
  Plisten = function (s: TSocket; backlog: Integer): Integer; stdcall;
  Paccept = function (s: TSocket; addr: PSockAddr; addrlen: PINT): TSocket; stdcall;
  Pgetsockname = function (s: TSocket; name: PSockAddr; var namelen: Integer): Integer; stdcall;
  Pgetpeername = function (s: TSocket; name: PSockAddr; var namelen: Integer): Integer; stdcall;

var
  WSALookupServiceBegin: PWSALookupServiceBegin = nil;
  WSALookupServiceEnd: PWSALookupServiceEnd = nil;
  WSALookupServiceNext: PWSALookupServiceNext = nil;
  WSAAddressToString: PWSAAddressToString = nil;
  WSACreateEvent: PWSACreateEvent = nil;
  WSACloseEvent: PWSACloseEvent = nil;
  WSAEventSelect: PWSAEventSelect = nil;
  WSAEnumNetworkEvents: PWSAEnumNetworkEvents = nil;
  WSAStringToAddress: PWSAStringToAddress = nil;
  WSAWaitForMultipleEvents: PWSAWaitForMultipleEvents = nil;
  WSASetService: PWSASetService = nil;
  socket: Psocket = nil;
  closesocket: Pclosesocket = nil;
  getsockopt: Pgetsockopt = nil;
  setsockopt: Psetsockopt = nil;
  connect: Pconnect = nil;
  recv: Precv = nil;
  send: Psend = nil;
  bind: Pbind = nil;
  listen: Plisten = nil;
  accept: Paccept = nil;
  getsockname: Pgetsockname = nil;
  getpeername: Pgetpeername = nil;

// SetupAPI.
const
  DIGCF_PRESENT = $00000002;

  SPDRP_FRIENDLYNAME = $0000000C;

  COMGUID: TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';

  FAF_ATTRIBUTES = $00000001;
  FAF_CREATION_TIME = $00000002;
  FAF_LASTACCESS_TIME = $00000004;
  FAF_LASTWRITE_TIME = $00000008;
  FAF_SIZE_HIGH = $00000010;
  FAF_SIZE_LOW = $00000020;
  FAF_OID = $00000040;
  FAF_NAME = $00000080;
  FAF_FLAG_COUNT = 8;
  FAF_ATTRIB_CHILDREN = $00001000;
  FAF_ATTRIB_NO_HIDDEN = $00002000;
  FAF_FOLDERS_ONLY = $00004000;
  FAF_NO_HIDDEN_SYS_ROMMODULES = $00008000;

  FAD_OID = $1;
  FAD_FLAGS = $2;
  FAD_NAME = $4;
  FAD_TYPE = $8;
  FAD_NUM_RECORDS = $10;
  FAD_NUM_SORT_ORDER = $20;
  FAD_SIZE = $40;
  FAD_LAST_MODIFIED = $80;
  FAD_SORT_SPECS = $100;
  FAD_FLAG_COUNT = $9;

  CEDB_SORT_DESCENDING = $00000001;
  CEDB_SORT_CASEINSENSITIVE = $00000002;
  CEDB_SORT_UNKNOWNFIRST = $00000004;
  CEDB_SORT_GENERICORDER = $00000008;

  CEDB_MAXDBASENAMELEN = 32;
  CEDB_MAXSORTORDER = 4;

  CEDB_VALIDNAME = $0001;
  CEDB_VALIDTYPE = $0002;
  CEDB_VALIDSORTSPEC = $0004;
  CEDB_VALIDMODTIME = $0008;

  OBJTYPE_INVALID = 0;
  OBJTYPE_FILE = 1;
  OBJTYPE_DIRECTORY = 2;
  OBJTYPE_DATABASE = 3;
  OBJTYPE_RECORD = 4;

  CEDB_AUTOINCREMENT = $00000001;

  CEDB_SEEK_CeOID = $00000001;
  CEDB_SEEK_BEGINNING = $00000002;
  CEDB_SEEK_END = $00000004;
  CEDB_SEEK_CURRENT = $00000008;
  CEDB_SEEK_VALUESMALLER = $00000010;
  CEDB_SEEK_VALUEFIRSTEQUAL = $00000020;
  CEDB_SEEK_VALUEGREATER = $00000040;
  CEDB_SEEK_VALUENEXTEQUAL = $00000080;

  CEVT_I2 = 2;
  CEVT_UI2 = 18;
  CEVT_I4 = 3;
  CEVT_UI4 = 19;
  CEVT_FILETIME = 64;
  CEVT_LPWSTR = 31;
  CEVT_BLOB = 65;

  CEDB_PROPNOTFOUND = $0100;
  CEDB_PROPDELETE = $0200;
  CEDB_MAXDATABLOCKSIZE = 4092;
  CEDB_MAXPROPDATASIZE = CEDB_MAXDATABLOCKSIZE * 16;
  CEDB_MAXRECORDSIZE = 128 * 1024;

  CEDB_ALLOWREALLOC = $00000001;

  SYSMEM_CHANGED  = 0;
  SYSMEM_MUSTREBOOT = 1;
  SYSMEM_REBOOTPENDING = 2;
  SYSMEM_FAILED = 3;

  AC_LINE_OFFLINE = $00;
  AC_LINE_ONLINE = $01;
  AC_LINE_BACKUP_POWER = $02;
  AC_LINE_UNKNOWN = $FF;

  BATTERY_FLAG_HIGH = $01;
  BATTERY_FLAG_LOW = $02;
  BATTERY_FLAG_CRITICAL = $04;
  BATTERY_FLAG_CHARGING = $08;
  BATTERY_FLAG_NO_BATTERY = $80;
  BATTERY_FLAG_UNKNOWN = $FF;

  BATTERY_PERCENTAGE_UNKNOWN = $FF;

  BATTERY_LIFE_UNKNOWN = $FFFFFFFF;

type
  HDEVINFO = Pointer;
  ULONG_PTR = DWORD;

  PSP_DEVINFO_DATA = ^SP_DEVINFO_DATA;
  SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD;
    Reserved: ULONG_PTR;
  end;

  PSP_DEVICE_INTERFACE_DATA = ^SP_DEVICE_INTERFACE_DATA;
  SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: DWORD;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;

  BTFEATURES = array [0..7] of Byte;
  PBTFEATURES = ^BTFEATURES;

  PBTMODULEVER = ^BTMODULEVER;
  BTMODULEVER = packed record
    bHCIVer: Byte;
    wHCIRev: Word;
    bLMPVer: Byte;
    wManufactureName: Word;
    wLMPSubVer: Word;
  end;

  PBTLOCALDEVINFO2 = ^BTLOCALDEVINFO2;
  BTLOCALDEVINFO2 = packed record
    BdAddr: TBluetoothAddress;
    Version: BTMODULEVER;
    Features: BTFEATURES;
    bCountryCode: Byte;
    wACLDataPacketLength: Word;
    bSCODataPacketLength: Byte;
    wACLDataTotalNumPackets: Word;
    wSCODataTotalNumPackets: Word;
  end;

  PFRIENDLYNAME = ^FRIENDLYNAME;
  FRIENDLYNAME = array [0..248 + 2 - 1] of Char;

  PCLASSOFDEV = ^CLASSOFDEV;
  CLASSOFDEV = ULONG;

  PBTDEVINFO = ^BTDEVINFO;
  BTDEVINFO = packed record
    dwStatus: DWORD;
    BdAddr: TBluetoothAddress;
    ClassOfDevice: CLASSOFDEV;
    FriendlyName: FRIENDLYNAME;
  end;

  PBTDEVINFOLIST = ^BTDEVINFOLIST;
  BTDEVINFOLIST = packed record
    dwDevListNum: DWORD;
    DevInfo: array [0..0] of BTDEVINFO;
  end;

  PBTDEVICELIST = ^BTDEVICELIST;
  BTDEVICELIST = packed record
    dwDevListNum: DWORD;
    BdAddr: TBluetoothAddress;
  end;

  PBTUUIDINFO = ^BTUUIDINFO;
  BTUUIDINFO = packed record
    wUUIDType: Word;
    BtUUID: BTUUID;
  end;

  PBTUUIDLIST = ^BTUUIDLIST;
  BTUUIDLIST = packed record
    dwUUIDInfoNum: DWORD;
    BTUUIDInfo: array [0..0] of BTUUIDINFO;
  end;

  PBTSDPSSARESULT = ^BTSDPSSARESULT;
  BTSDPSSARESULT = packed record
    dwAttributeListsByteCount: DWORD;
    bAttributeLists: array [0..0] of Byte;
  end;

  PBTUNIVATTRIBUTE = ^BTUNIVATTRIBUTE;
  BTUNIVATTRIBUTE = DWORD;

  PBTPROTOCOL2 = ^BTPROTOCOL2;
  BTPROTOCOL2 = packed record
    dwSize: DWORD;
    BTUUID_Protocol: BTUUIDINFO;
    wParameterType: Word;
    dwParameter: DWORD;
    pMemParameter: Pointer;
  end;  

  PBTPROTOCOLLIST2 = ^BTPROTOCOLLIST2;
  BTPROTOCOLLIST2 = packed record
    dwProtocolNum: DWORD;
    BtProtocol: array [0..0] of BTPROTOCOL2;
  end;

  PBTPROTOCOLLISTALT2 = ^BTPROTOCOLLISTALT2;
  BTPROTOCOLLISTALT2 = packed record
    dwProtocolListNum: DWORD;
    pMemProtocolList: array [0..0] of PBTPROTOCOLLIST2;
  end;

  PBTLANGBASE = ^BTLANGBASE;
  BTLANGBASE = packed record
    wLanguageID: Word;
    wCharEncodeID: Word;
    wBaseAttributeID: Word;
  end;

  PBTLANGBASELIST = ^BTLANGBASELIST;
  BTLANGBASELIST = packed record
    dwLangBaseListNum: DWORD;
    BtLangBase: array [0..0] of BTLANGBASE;
  end;

  BTBYTEVER = packed record
    bMinor: Byte;
    bMajor: Byte;
  end;

  BTVER = packed record
    case Boolean of
      True: (w: Word);
      False: (b: BTBYTEVER);
  end;

  PBTPROFILEDESC = ^BTPROFILEDESC;
  BTPROFILEDESC = packed record
    BtUUIDInfo: BTUUIDINFO;
    BtVer: BTVER;
  end;

  PBTPROFILEDESCLIST = ^BTPROFILEDESCLIST;
  BTPROFILEDESCLIST = packed record
    dwProfileDescNum: DWORD;
    BtProfileDesc: array [0..0] of BTPROFILEDESC;
  end;

  PBTSTRING = ^BTSTRING;
  BTSTRING = packed record
    dwSize: DWORD;
    pbString: PBYTE;
  end;

  PBTADDPROTOCOLLISTS = ^BTADDPROTOCOLLISTS;
  BTADDPROTOCOLLISTS = packed record
    dwProtocolsNum: DWORD;
    pMemAddProtocolDescLists: array [0..0] of PBTPROTOCOLLISTALT2;
  end;

  PBTANALYZEDATTR2 = ^BTANALYZEDATTR2;
  BTANALYZEDATTR2 = packed record
    dwSize: DWORD;
    BtAnalyzedAttribute: BTUNIVATTRIBUTE;
    dwServiceRecordHandle: DWORD;
    pMemServiceClassIDList: PBTUUIDLIST;
    dwServiceRecordState: DWORD;
    ServiceID: BTUUIDINFO;
    pMemProtocolDescriptorList: PBTPROTOCOLLISTALT2;
    pMemBrowseGroupList: PBTUUIDLIST;
    pMemLanguageBaseAttributeIDList: PBTLANGBASELIST;
    dwServiceInfoTimeToLive: DWORD;
    bServiceAvailability: Byte;
    pMemBtProfileDescList: PBTPROFILEDESCLIST;
    btsDocumentationURL: BTSTRING;
    btsClientExecutableURL: BTSTRING;
    btsIconURL: BTSTRING;
    pMemAddProtocolDescLists: PBTADDPROTOCOLLISTS;
    btsServiceName: BTSTRING;
    btsServiceDescription: BTSTRING;
    btsProviderName: BTSTRING;
  end;

  PBTANALYZEDATTRLIST2 = ^BTANALYZEDATTRLIST2;
  BTANALYZEDATTRLIST2 = packed record
    dwNum: DWORD;
    BtAnalyzedAttr: array [0..0] of BTANALYZEDATTR2;
  end;

  PBTBNEPPARAM = ^BTBNEPPARAM;
  BTBNEPPARAM = packed record
    BtVer: BTVER;
    dwNum: DWORD;
    wSNPT: array [0..0] of Word;
  end;

  PBTPROTOCOLPARAM = ^BTPROTOCOLPARAM;
  BTPROTOCOLPARAM = packed record
    dwSize: DWORD;
    dwEnableParam: DWORD;
    wPSM: Word;
    wTCPPort: Word;
    wUDPPort: Word;
    bSCN: Byte;
    pMemBNEPParam: PBTBNEPPARAM;
  end;

  PBTCOMMINFO = ^BTCOMMINFO;
  BTCOMMINFO = packed record
    dwSize: DWORD;
    nKind: Integer;
    szPortName: array [0..5] of Char;
    bSCN: BYTE;
    wPSM: WORD;
    wCID: WORD;
    BdAddr: TBluetoothAddress;
    wAuthentication: WORD;
    wEncription: WORD;
  end;

  PBTCOMMINFOLIST = ^BTCOMMINFOLIST;
  BTCOMMINFOLIST = packed record
    dwCOMMNum: DWORD;
    BtCOMMInfo: array [0..0] of BTCOMMINFO;
  end;

  TLVGROUP = record
    cbSize: UINT;
    mask: UINT;
    pszHeader: LPWSTR;
    cchHeader: Integer;
    pszFooter: LPWSTR;
    cchFooter: Integer;
    iGroupIdL: Integer;
    stateMask: UINT;
    state: UINT;
    uAlign: UINT;
  end;

  tagLVITEMA = packed record
    mask: UINT;
    iItem: Integer;
    iSubItem: Integer;
    state: UINT;
    stateMask: UINT;
    pszText: PAnsiChar;
    cchTextMax: Integer;
    iImage: Integer;
    lParam: lParam;
    iIndent: Integer;
    iGroupId: Integer;
    cColumns: UINT;
    puColumns: PUINT;
  end;
  TLVITEMA = tagLVITEMA;

  CE_FIND_DATA = record
    dwFileAttributes: DWORD;
    ftCreationTime: FILETIME;
    ftLastAccessTime: FILETIME;
    ftLastWriteTime: FILETIME;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwOID: DWORD;
    cFileName: array [0..MAX_PATH - 1] of WideChar;
  end;
  PCE_FIND_DATA = ^CE_FIND_DATA;

  CE_FIND_DATA_ARRAY = array [0..MaxInt div SizeOf(CE_FIND_DATA) - 1] of CE_FIND_DATA;
  PCE_FIND_DATA_ARRAY = ^CE_FIND_DATA_ARRAY;

  STORE_INFORMATION = record
    dwStoreSize: DWORD;
    dwFreeSize: DWORD;
  end;
  PSTORE_INFORMATION = ^STORE_INFORMATION;

  CEPROPID = DWORD;
  PCEPROPID = ^CEPROPID;
  CE_PROPID_ARRAY = array [0..MaxInt div SizeOf(CEPROPID) - 1] of CEPROPID;
  PCE_PROPID_ARRAY = ^CE_PROPID_ARRAY;

  CEOID = DWORD;
  PCEOID = ^CEOID;

  CEFILEINFO = record
    dwAttributes: DWORD;
    oidParent: CEOID;
    szFileName: array [0..MAX_PATH - 1] of WCHAR;
    ftLastChanged: FILETIME;
    dwLength: DWORD;
  end;

  CEDIRINFO = record
    dwAttributes: DWORD;
    oidParent: CEOID;
    szDirName: array [0..MAX_PATH - 1] of WCHAR;
  end;

  CERECORDINFO = record
    oidParent: CEOID;
  end;

  SORTORDERSPEC = record
    propid: CEPROPID;
    dwFlags: DWORD;
  end;
  PSORTORDERSPEC = ^SORTORDERSPEC;

  CEDBASEINFO = record
    dwFlags: DWORD;
    szDbaseName: array [0..CEDB_MAXDBASENAMELEN - 1] of WCHAR;
    dwDbaseType: DWORD;
    wNumRecords: Word;
    wNumSortOrder: Word;
    dwSize: DWORD;
    ftLastModified: FILETIME;
    rgSortSpecs: array [0..CEDB_MAXSORTORDER - 1] of SORTORDERSPEC;
  end;
  PCEDBASEINFO = ^CEDBASEINFO;

  CEDB_FILE_DATA = record
    OidDb: CEOID ;
    DbInfo: CEDBASEINFO;
  end;
  PCEDB_FILE_DATA = ^CEDB_FILE_DATA;

  CEDB_FILE_DATA_ARRAY = array [0..MaxInt div SizeOf(CEDB_FILE_DATA) - 1] of CEDB_FILE_DATA;
  PCEDB_FILE_DATA_ARRAY = ^CEDB_FILE_DATA_ARRAY;

  CEOIDINFO = record
    wObjType: Word;
    wPad: Word;
    case Integer of
      0: (infFile: CEFILEINFO);
      1: (infDirectory: CEDIRINFO);
      2: (infDatabase: CEDBASEINFO);
      3: (infRecord: CERECORDINFO);
  end;
  PCEOIDINFO = ^CEOIDINFO;

  CEOICONTAINERSTRUCT = record
    OID: CEOID;
    OIDInfo: CEOIDINFO;
  end;
  PCEOICONTAINERSTRUCT = ^CEOICONTAINERSTRUCT;

  CEBLOB = record
    dwCount: DWORD;
    lpb: DWORD;
  end;

  CEVALUNION = record
    iVal: Short;
    uiVal: Word;
    lVal: LongInt;
    ulVal: ULONG ;
    fletime: FILETIME;
    lpwstr: LPWSTR;
    blob: CEBLOB;
  end;

  CEPROPVAL = record
    propid: CEPROPID;
    wLenData: Word;
    wFlags: Word;
    val: CEVALUNION;
  end;

  CEOSVERSIONINFO = record
    wOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[ 0..127] of WCHAR;
  end;
  PCEOSVERSIONINFO = ^CEOSVERSIONINFO;

  SYSTEM_POWER_STATUS_EX = record
    ACLineStatus: Byte;
    BatteryFlag: Byte;
    BatteryLifePercent: Byte;
    Reserved1: Byte;
    BatteryLifeTime: Byte;
    BatteryFullLifeTime: Byte;
    Reserved2: Byte;
    BackupBatteryFlag: Byte;
    BackupBatteryLifePercent: Byte;
    Reserved3: Byte;
    BackupBatteryLifeTime: DWORD;
    BackupBatteryFullLifeTime: DWORD;
  end;
  PSYSTEM_POWER_STATUS_EX = ^SYSTEM_POWER_STATUS_EX;

  SYSTEM_POWER_STATUS_EX_ARRAY = array [0..MaxInt div SizeOf(SYSTEM_POWER_STATUS_EX) - 1] of SYSTEM_POWER_STATUS_EX;
  PSYSTEM_POWER_STATUS_EX_ARRAY =^SYSTEM_POWER_STATUS_EX_ARRAY;

  RAPIINIT = record
    cbSize: DWORD;
    heRapiInit: THandle;
    hrRapiInit: HResult;
  end;
  PRAPIINIT = ^RAPIINIT;

const
  LVM_ENABLEGROUPVIEW = LVM_FIRST + 157;
  LVM_MOVEITEMTOGROUP = LVM_FIRST + 154;
  LVM_INSERTGROUP     = LVM_FIRST + 145;

  LVIF_GROUPID = $0100;

  LVGF_HEADER  = $00000001;
  LVGF_ALIGN   = $00000008;
  LVGF_GROUPID = $00000010;

  LVGA_HEADER_LEFT   = $00000001;
  LVGA_HEADER_CENTER = $00000002;
  LVGA_HEADER_RIGHT  = $00000004;

const
  TOSBTAPI_NONDISCOVERABLE = $0000;
  TOSBTAPI_DISCOVERABLE    = $0001;

  TOSBTAPI_NONCONNECTABLE  = $0000;
  TOSBTAPI_CONNECTABLE     = $0001;

  TOSBTAPI_DD_NORMAL          = $00000000;
  TOSBTAPI_DD_NO_FRIENDLYNAME = $40000000;

  TOSBTAPI_NM_DISCOVERDEVICE_ERROR = $00600000;
  TOSBTAPI_NM_DISCOVERDEVICE_START = $00600001;
  TOSBTAPI_NM_DISCOVERDEVICE_FOUND = $00600080;
  TOSBTAPI_NM_DISCOVERDEVICE_END   = $006000FF;

  TOSBTAPI_DEVCOND_NOTHING       = $00000000;
  TOSBTAPI_DEVCOND_UPDATETIME    = $00000001;
  TOSBTAPI_DEVCOND_SENDBACKTIME  = $00000002;
  TOSBTAPI_DEVCOND_CONNECTEDTIME = $00000004;
  TOSBTAPI_DEVCOND_PAIRINGTIME   = $00000008;
  TOSBTAPI_DEVCOND_TRUSTEDTIME   = $00000010;
  TOSBTAPI_DEVCOND_DISCOVERTIME  = $00000020;
  TOSBTAPI_DEVCOND_OLD           = $00000100;
  TOSBTAPI_DEVCOND_OLDEQUAL      = $00000200;
  TOSBTAPI_DEVCOND_NEWEQUAL      = $00000400;
  TOSBTAPI_DEVCOND_NEW           = $00000800;

  TOSBTAPI_NM_CONNECTSDP_ERROR     = $00700000;
  TOSBTAPI_NM_CONNECTSDP_START     = $00700001;
  TOSBTAPI_NM_CONNECTSDP_CONNECTED = $00700080;
  TOSBTAPI_NM_CONNECTSDP_END       = $007000FF;

  TOSBTAPI_NM_SSA_ERROR   = $00700400;
  TOSBTAPI_NM_SSA_START   = $00700401;
  TOSBTAPI_NM_SSA_RESULT  = $00700480;
  TOSBTAPI_NM_SSA_END     = $007004FF;

  TOSBTAPI_NM_REFRESHSDDB_ERROR    = $00600400;
  TOSBTAPI_NM_REFRESHSDDB_START    = $00600401;
  TOSBTAPI_NM_REFRESHSDDB_1RENEWAL = $00600480;
  TOSBTAPI_NM_REFRESHSDDB_END      = $006004FF;

  TOSBTAPI_NM_CONNECTCOMM_ERROR     = $00800200;
  TOSBTAPI_NM_CONNECTCOMM_START     = $00800201;
  TOSBTAPI_NM_CONNECTCOMM_CONNECTED = $00800280;
  TOSBTAPI_NM_CONNECTCOMM_END       = $008002FF;
  
  TOSBTAPI_ATR_NOTHING                           = $00000000;
  TOSBTAPI_ATR_SERVICERECORDHANDLE               = $00000001; // ID = 0x0000
  TOSBTAPI_ATR_SERVICECLASSIDLIST                = $00000002; // ID = 0x0001
  TOSBTAPI_ATR_SERVICERECORDSTATE                = $00000004; // ID = 0x0002
  TOSBTAPI_ATR_SERVICEID                         = $00000008; // ID = 0x0003
  TOSBTAPI_ATR_PROTOCOLDESCRIPTORLIST            = $00000010; // ID = 0x0004
  TOSBTAPI_ATR_BROWSEGROUPLIST                   = $00000020; // ID = 0x0005
  TOSBTAPI_ATR_LANGUAGEBASEATTRIBUTEIDLIST       = $00000040; // ID = 0x0006
  TOSBTAPI_ATR_SERVICEINFOTIMETOLIVE             = $00000080; // ID = 0x0007
  TOSBTAPI_ATR_SERVICEAVAILABILITY               = $00000100; // ID = 0x0008
  TOSBTAPI_ATR_BLUETOOTHPROFILEDESCRIPTORLST     = $00000200; // ID = 0x0009
  TOSBTAPI_ATR_DOCUMENTATIONURL                  = $00000400; // ID = 0x000A
  TOSBTAPI_ATR_CLIENTEXECUTABLEURL               = $00000800; // ID = 0x000B
  TOSBTAPI_ATR_ICONURL                           = $00001000; // ID = 0x000C
  TOSBTAPI_ATR_SERVICENAME                       = $00002000; // ID = +0x0000 (usualy 0x0100)
  TOSBTAPI_ATR_SERVICEDESCRIPTION                = $00004000; // ID = +0x0001 (usualy 0x0101)
  TOSBTAPI_ATR_PROVIDERNAME                      = $00008000; // ID = +0x0002 (usualy 0x0102)
  TOSBTAPI_ATR_ADDITIONALPROTOCOLDESCRIPTORLISTS = $00010000; // ID = 0x000D

  TOSBTAPI_ATR_ALL                               = $0001FFFF;

  TOSBTAPI_ATR_DI_SPECIFICATIONID                = $00000001; // ID = 0x0200
  TOSBTAPI_ATR_DI_VENDORID                       = $00000002; // ID = 0x0201
  TOSBTAPI_ATR_DI_PRODUCTID                      = $00000004; // ID = 0x0202
  TOSBTAPI_ATR_DI_VERSION                        = $00000008; // ID = 0x0203
  TOSBTAPI_ATR_DI_PRIMARYRECORD                  = $00000010; // ID = 0x0204
  TOSBTAPI_ATR_DI_VENDORSOURCEID                 = $00000020; // ID = 0x0205

  TOSBTAPI_NO_ERROR                            = 0;

  TOSBTAPI_WNG_BDADDR                          = 1; // The device information of specification BD_ADDR is unregistered to SDP-DB
  TOSBTAPI_WNG_TERM_OF_VALIDITY_OVER           = 2; // There is old (being passing an effective deadline) one in the service record in searched

  TOSBTAPI_ERROR                               = -1; // The other error (The un-supported feature and so on)
  TOSBTAPI_ERROR_DEVICE_NOT_READY              = -2; // Invalid handle of device driver
  TOSBTAPI_ERROR_DEVICE_CALL                   = -3; // N:DeviceIoCtrl failure(Driver called error)
  TOSBTAPI_ERROR_MEMORY_ALLOCATE               = -4; // Memory allocate/resize failure
  TOSBTAPI_ERROR_CONNECTION                    = -7; // Connection failure
  TOSBTAPI_ERROR_PARAMETER                     = -9; // Parameter is wrong value
  TOSBTAPI_ERROR_PENDING                       = -10; // N:Pending(for NonBroking Management)
  TOSBTAPI_ERROR_READINVALIDDATA               = -11; // N:Invalid data received

  TOSBTAPI_ERROR_SDPTRANSACTION                = -1000; // SDP transaction failure(excpt TOSBTAPI_ERROR_SDPTRANS_xxxx) 
  TOSBTAPI_ERROR_INQUIRY                       = -1001; // Inquiry failure 
  TOSBTAPI_ERROR_READREMOTENAME                = -1002; // Get RemoteName Management failure 
  TOSBTAPI_ERROR_FUNCTION_NUM                  = -1003; // N:It is unjust that the TosBtSDP function from TosBtAPI specifies a number 
  TOSBTAPI_ERROR_CANNOT_ASSIGN_SCN             = -1004; // Can't assign ServerChannelNumber in BtCreateCOMM() 
  TOSBTAPI_ERROR_CREATECOMM                    = -1005; // BtCreateCOMM()/BtCreateCOMMEx() failure
  TOSBTAPI_ERROR_DESTROYCOMM                   = -1006; // BtDestroyCOMM() failure 
  TOSBTAPI_ERROR_CONNECTCOMM                   = -1007; // BtConnectCOMM() failure 
  TOSBTAPI_ERROR_DISCONNECTCOMM                = -1008; // BtDisconnectCOMM() failure 
  TOSBTAPI_ERROR_POWERSWITCH                   = -1009; // BtSetPowerSwitch()/BtGetPowerSwitch() failure 
  TOSBTAPI_ERROR_CANNOT_ASSIGN_PSM             = -1010; // Can't assign PSM in BtBeginLANEServer() 
  TOSBTAPI_ERROR_BEGINLANESERVER               = -1011; // BtBeginLANEServer() failure 
  TOSBTAPI_ERROR_CONNECTLANE                   = -1012; // BtConnectLANE() failure 
  TOSBTAPI_ERROR_GETLOCALINFO                  = -1013; // BtGetxxxxMode() etc. failure 
  TOSBTAPI_ERROR_DISCONNECTSDP                 = -1014; // BtDisconnectSDP() failure 
  TOSBTAPI_ERROR_NOTIFYCOMM                    = -1015; // BtNotifyCOMM() failure 
  TOSBTAPI_ERROR_ENDLANESERVER                 = -1016; // BtEndLANEServer() failure 
  TOSBTAPI_ERROR_DISCONNECTLANE                = -1017; // BtDisconnectLANE() failure
  TOSBTAPI_ERROR_NOTIFYLANE                    = -1018; // BtNotifyLANE() failure 
  TOSBTAPI_ERROR_SETLOCALINFO                  = -1019; // BtSetxxxxMode() etc. failure 
  TOSBTAPI_ERROR_REFRESHSDDB                   = -1020; // BtRefreshSDDB() failure 
  TOSBTAPI_ERROR_GETCOMMINFOLIST               = -1021; // BtGetCOMMInfoList() failure 
  TOSBTAPI_ERROR_GETCOMMCREATORNAME            = -1022; // BtGetCOMMCreatorName() failure 
  TOSBTAPI_ERROR_GETLANEINFOLIST               = -1023; // BtGetLANEInfoList() failure 
  TOSBTAPI_ERROR_GETLANECREATORNAME            = -1024; // BtGetLANECreatorName() failure 
  TOSBTAPI_ERROR_GETCONNECTEDDEVICELIST        = -1025; // BtGetConnectedDeviceList() failure 
  TOSBTAPI_ERROR_GETCIDLIST                    = -1026; // BtGetCIDList() failure 
  TOSBTAPI_ERROR_GETCONNECTIONHANDLE           = -1027; // BtGetConnectionHandle() failure 
  TOSBTAPI_ERROR_GETLANEMAXCONNECTIONS         = -1028; // BtGetLANEMaxConnections() failure 
  TOSBTAPI_ERROR_ROLEDISCOVERY                 = -1029; // BtRoleDiscovery() failure 
  TOSBTAPI_ERROR_SWITCHROLE                    = -1030; // BtSwitchRole() failure 
  TOSBTAPI_ERROR_SETROLESTATE                  = -1031; // BtSetRoleState() failure 
  TOSBTAPI_ERROR_GETROLESTATE                  = -1032; // BtGetRoleState() failure 
  TOSBTAPI_ERROR_WRONGATTRLISTSRECEIVED        = -1033; // Wrong AttributeLists Response Received 
  TOSBTAPI_ERROR_OPENDRIVERS                   = -1034; // BtOpenDrivers() failure 

  TOSBTAPI_ERROR_CONNECT                       = -1035; // BtConnect() failure 
  TOSBTAPI_ERROR_CONNECT_PSM                   = -1036; // BtConnect() failure - PSM Error 
  TOSBTAPI_ERROR_CONNECT_SECURITY              = -1037; // BtConnect() failure - Security block 
  TOSBTAPI_ERROR_CONNECT_TIMEOUT               = -1038; // BtConnect() failure - Connectiontimeout 
  TOSBTAPI_ERROR_DISCONNECT                    = -1039; // BtDisconnect() failure 
  TOSBTAPI_ERROR_DISCONNECT_TIMEOUT            = -1040; // BtDisconnect() failure - timeout 
  TOSBTAPI_ERROR_LISTEN                        = -1041; // BtListen() failure 
  TOSBTAPI_ERROR_CANCELLISTEN                  = -1042; // BtCancelListen() failure 
  TOSBTAPI_ERROR_ACCEPT                        = -1043; // BtAccept() failure
  TOSBTAPI_ERROR_REJECT                        = -1044; // BtReject() failure 
  TOSBTAPI_ERROR_NOTIFY                        = -1045; // BtNotify() failure 
  TOSBTAPI_ERROR_CANCELNOTIFY                  = -1046; // BtCancelNotify() failure 
  TOSBTAPI_ERROR_CONFIGREQUEST                 = -1047; // BtConfigRequest() failure 
  TOSBTAPI_ERROR_CONFIG_UNACCEPTABLE_PARAMETER = -1048; // BtConfigRequest(), BtConfigResponse() failure - unacceptable parameter 
  TOSBTAPI_ERROR_CONFIG_REJECT_NO_REASON       = -1049; // BtConfigRequest(), BtConfigResponse() failure - Reject with no reason 
  TOSBTAPI_ERROR_CONFIG_UNKNOWN_OPTION         = -1050; // BtConfigRequest(), BtConfigResponse() failure - unknown option 
  TOSBTAPI_ERROR_CONFIG_TIMEOUT                = -1051; // BtConfigRequest() failure - timeout
  TOSBTAPI_ERROR_CONFIGRESPONSE                = -1052; // BtConfigResponse() failure 
  TOSBTAPI_ERROR_SENDDATA                      = -1053; // BtSendData() failure 
  TOSBTAPI_ERROR_SENDDATA_FLUSHTIMEOUT         = -1054; // BtSendData() failure - flush timeout 
  TOSBTAPI_ERROR_SENDDATA_LINK_TERMINATE       = -1055; // BtSendData() failure - link loss 
  TOSBTAPI_ERROR_RECVDATA                      = -1056; // BtRecvData() failure 
  TOSBTAPI_ERROR_SETAUTOCONNECTCOMMINFO        = -1057; // BtSetAutoConnectCOMMInfo() failure 
  TOSBTAPI_ERROR_GETAUTOCONNECTCOMMINFOLIST    = -1058; // BtGetAutoConnectCOMMInfoList() failure 
  TOSBTAPI_ERROR_SETAUTOCONNECTCOMMSTATE       = -1059; // BtSetAutoConnectCOMMState() failure 
  TOSBTAPI_ERROR_ADDHIDDEVICE                  = -1060; // BtAddHIDDevice() failure 
  TOSBTAPI_ERROR_REMOVEHIDDEVICE               = -1061; // BtRemoveHIDDevice() failure 
  TOSBTAPI_ERROR_CONNECTHID                    = -1062; // BtConnectHID() failure 
  TOSBTAPI_ERROR_DISCONNECTHID                 = -1063; // BtDisconnectHID() failure 
  TOSBTAPI_ERROR_GETHIDINFOLIST                = -1064; // BtGetHIDInfoList() failure 
  TOSBTAPI_ERROR_CONFIG_INVALIDCID             = -1065; // BtConfigRequest(), BtConfigResponse() failure - invalid CID 
  TOSBTAPI_ERROR_PANLISTEN                     = -1066; // BtPANListen() failure 
  TOSBTAPI_ERROR_CONNECTPAN                    = -1067; // BtConnectPAN() failure 
  TOSBTAPI_ERROR_DISCONNECTPAN                 = -1068; // BtDisconnectPAN() failure 
  TOSBTAPI_ERROR_NOTIFYPAN                     = -1069; // BtNotifyPAN() failure 
  TOSBTAPI_ERROR_GETPANINFOLIST                = -1070; // BtGetPANInfoList() failure 
  TOSBTAPI_ERROR_PANSWITCHROLE                 = -1071; // BtPANSwitchRole() failure 
  TOSBTAPI_ERROR_PLUGIN_HID                    = -1072; // plugin HID-Driver failure at BtConnectHID() process 
  TOSBTAPI_ERROR_CHANGEHIDSETTINGS             = -1073; // BtChangeHIDSettings() failure 
  TOSBTAPI_ERROR_PANRECVDATA                   = -1074; // BtPANRecvData() failure 

  TOSBTAPI_ERROR_GETPSMLIST                    = -1075; // BtGetPSMList() failure 
  TOSBTAPI_ERROR_ANALYZEDIATTRIBUTELISTS       = -1076; // BtAnalyzeDIAttibuteLists() failure 
  TOSBTAPI_ERROR_GETHCRPINFOLIST               = -1077; // BtGetHCRPInfoList() failure 

  TOSBTAPI_ERROR_BWCAUTH                       = -1078; // BtBWCAuth() failure 
  TOSBTAPI_ERROR_CANHIDHOSTSUPPORT             = -1079; // BtCanHIDHostSupport() failure 
  TOSBTAPI_ERROR_SETLINKSUPERVISIONTIMEOUT     = -1080; // BtSetLinkSupervisionTimeout() failure
  TOSBTAPI_ERROR_GETLINKSUPERVISIONTIMEOUT     = -1081; // BtGetLinkSupervisionTimeout() failure 

  TOSBTAPI_ERROR_SETPERIODICINQUIRYMODE        = -1082; // BtSetPeriodicInquiryMode() failure 
  TOSBTAPI_ERROR_GETPERIODICINQUIRYMODE        = -1083; // BtGetPeriodicInquiryMode() failure
  TOSBTAPI_ERROR_GETLASTINQUIRYTIME            = -1084; // BtGetLastInquiry() failure 
  TOSBTAPI_ERROR_GETLINKQUALITY                = -1085; // BtGetLinkQuality() failure 
  TOSBTAPI_ERROR_GETRSSI                       = -1086; // BtGetRSSI() failure 

  TOSBTAPI_ERROR_SETDEVICEPROPERTYPARAM        = -1087; // BtSetDevicePropertyParam() failure 
  TOSBTAPI_ERROR_GETDEVICEPROPERTYPARAM        = -1088; // BtGetDevicePropertyParam() failure 

  TOSBTAPI_ERROR_SDPTRANS_INSUFFICIENTRESOURCE = -1994; // SDP-Transaction failure(ErrCode=6:Insufficient Resource to satisfy Request) 
  TOSBTAPI_ERROR_SDPTRANS_INVALIDCONTINUSTAT   = -1995; // SDP-Transaction failure(ErrCode=5:Invalid Continuation State) 
  TOSBTAPI_ERROR_SDPTRANS_INVALIDPDUSIZE       = -1996; // SDP-Transaction failure(ErrCode=4:Invalid PDU Size) 
  TOSBTAPI_ERROR_SDPTRANS_INVALIDREQUEST       = -1997; // SDP-Transaction failure(ErrCode=3:Invalid request syntax) 
  TOSBTAPI_ERROR_SDPTRANS_INVALIDHANDLE        = -1998; // SDP-Transaction failure(ErrCode=2:Invalid Service Record Handle) 
  TOSBTAPI_ERROR_SDPTRANS_UNSUPPORTEDVERSION   = -1999; // SDP-Transaction failure(ErrCode=1:Invalid/unsupport SDP version) 
  TOSBTAPI_ERROR_SDPTRANS_DIFFERENCE           = 2000;

  TOSBTAPI_ERROR_FILEOPEN                      = -2000; // N:SDP-DB file open failure 
  TOSBTAPI_ERROR_FILECLOSE                     = -2001; // N:SDP-DB file close failure 
  TOSBTAPI_ERROR_FILEREAD                      = -2002; // Data read from SDP-DB file failure 
  TOSBTAPI_ERROR_FILEWRITE                     = -2003; // Data write to SDP-DB file failure 
  TOSBTAPI_ERROR_GETFILESIZE                   = -2004; // N:Get file size management form SDP-DB file failure 
  TOSBTAPI_ERROR_NOT_SDDBFILE                  = -2005; // N:Opened file is not SDP-DB file or it can't support(with old version) 
  TOSBTAPI_ERROR_RECORD_HANDLE                 = -2006; // Invalied specify service record handle 
  TOSBTAPI_ERROR_SEARCH_PATTERN                = -2007; // Invalied specify search pattern data 
  TOSBTAPI_ERROR_SERVICE_RECORD                = -2008; // Invalied service record data into SDP-DB(possibility to be broken) 
  TOSBTAPI_ERROR_ATTRIBUTE_LIST                = -2009; // Invalied specify attribute list data 
  TOSBTAPI_ERROR_ATTRIBUTE_ID_LIST             = -2010; // Invalied specify attribute ID list data 
  TOSBTAPI_ERROR_SDDB_MAINTENANCE              = -2011; // SDP-DB can not maintenance 
  TOSBTAPI_ERROR_REGISTRY_ACCESS               = -2012; // N:Registry access error 

  TOSBTAPI_ERROR_SERVICENOTRUNNING             = -3000; // TosBtMng.exe not running 
  TOSBTAPI_ERROR_CREATEWINDOW                  = -3001; // The creating of a window for the message reception from TosBtSDP.exe failure 
  TOSBTAPI_ERROR_ATTRLIST_ANALYZE              = -3002; // AttributeList(s) analyze failure 
  TOSBTAPI_ERROR_CALLINGSEQUENCE               = -3003; // Application Window disable 
  TOSBTAPI_ERROR_SERVICENOTREADY               = -3004; // TosBtMng.exe not ready 
  TOSBTAPI_ERROR_EXECBTMNG                     = -3005; // can not execute TosBtMng.exe

// BlueSoleil API functions.
type
  PBT_InitializeLibrary = function : BOOL; cdecl;
  PBT_UninitializeLibrary = procedure; cdecl;
  PBT_IsBlueSoleilStarted = function (dwSeconds: DWORD): BOOL; cdecl;
  PBT_IsBluetoothReady = function (dwSeconds: DWORD): BOOL; cdecl;
  PBT_StartBluetooth = function : DWORD; cdecl;
  PBT_InquireDevices = function (ucInqMode: UCHAR; ucInqTimeLen: UCHAR; lpDevsListLength: PDWORD; var pDevsList: IVTBLUETOOTH_DEVICE_INFO): DWORD; cdecl;
  PBT_GetRemoteDeviceInfo = function (dwMask: DWORD; var pDevInfo: BLUETOOTH_DEVICE_INFO_EX): DWORD; cdecl;
  PBT_BrowseServices = function (pDevInfo: PIVTBLUETOOTH_DEVICE_INFO; bBrowseAllServices: BOOL; lpServiceClassListLength: PDWORD; var pSeriveClassList: GENERAL_SERVICE_INFO): DWORD; cdecl;
  PBT_GetLocalDeviceInfo = function (dwMask: DWORD; var pDevInfo: BLUETOOTH_DEVICE_INFO_EX): DWORD; cdecl;
  PBT_SetLocalDeviceInfo = function (dwMask: DWORD; pDevInfo: PIVTBLUETOOTH_DEVICE_INFO): DWORD; cdecl;
  PBT_DisconnectSPPExService = function (dwConnectionHandle: DWORD): DWORD; cdecl;
  PBT_ConnectSPPExService = function (pDevInfo: PIVTBLUETOOTH_DEVICE_INFO; pServiceInfo: PSPPEX_SERVICE_INFO; lpConnectionHandle: PDWORD): DWORD; cdecl;
  PBT_PairDevice = function (pDevInfo: PIVTBLUETOOTH_DEVICE_INFO; wPinCodeLen: WORD; lpPinCode: PByte; bKeepOldkeyOnFail: BOOL; bShowPincode: BOOL): DWORD; cdecl;
  PBT_StartSPPExService = function (pServiceInfo: PSPPEX_SERVICE_INFO; lpServerHandle: PDWORD): DWORD; cdecl;
  PBT_StopSPPExService = function (dwServerHandle: DWORD): DWORD; cdecl;
  PBT_RegisterCallback = function (ucEvent: UCHAR; pfnCbkFun: Pointer): DWORD; cdecl;
  PBT_UnregisterCallback = function (ucEvent: UCHAR): DWORD; cdecl;
  PBT_UnpairDevice = function (lpBdAddr: PByte): DWORD; cdecl;
  PBT_SearchSPPExServices = function (pDevInfo: PIVTBLUETOOTH_DEVICE_INFO; var lpServiceClassListLength: DWORD; pSeriveClassList: PSPPEX_SERVICE_INFO): DWORD; cdecl;
  PBT_ConnectService = function (pDevInfo: PBLUETOOTH_DEVICE_INFO; pServiceInfo: PGENERAL_SERVICE_INFO; lpParam: PByte; var lpConnectionHandle: DWORD): DWORD; cdecl;
  PBT_DisconnectService = function (dwConnectionHandle: DWORD): DWORD; cdecl;
  PBT_SetRemoteDeviceInfo = function (dwMask: DWORD; pDevInfo: PBLUETOOTH_DEVICE_INFO_EX): DWORD; cdecl;
  PBT_GetVersion = function: DWORD; cdecl;

var
  BT_InitializeLibrary: PBT_InitializeLibrary = nil;
  BT_UninitializeLibrary: PBT_UninitializeLibrary = nil;
  BT_IsBlueSoleilStarted: PBT_IsBlueSoleilStarted = nil;
  BT_IsBluetoothReady: PBT_IsBluetoothReady = nil;
  BT_StartBluetooth: PBT_StartBluetooth = nil;
  BT_InquireDevices: PBT_InquireDevices = nil;
  BT_GetRemoteDeviceInfo: PBT_GetRemoteDeviceInfo = nil;
  BT_BrowseServices: PBT_BrowseServices = nil;
  BT_GetLocalDeviceInfo: PBT_GetLocalDeviceInfo = nil;
  BT_SetLocalDeviceInfo: PBT_SetLocalDeviceInfo = nil;
  BT_DisconnectSPPExService: PBT_DisconnectSPPExService = nil;
  BT_ConnectSPPExService: PBT_ConnectSPPExService = nil;
  BT_PairDevice: PBT_PairDevice = nil;
  BT_StartSPPExService: PBT_StartSPPExService = nil;
  BT_StopSPPExService: PBT_StopSPPExService = nil;
  BT_RegisterCallback: PBT_RegisterCallback = nil;
  BT_UnregisterCallback: PBT_UnregisterCallback = nil;
  BT_UnpairDevice: PBT_UnpairDevice = nil;
  BT_SearchSPPExServices: PBT_SearchSPPExServices = nil;
  BT_ConnectService: PBT_ConnectService = nil;
  BT_DisconnectService: PBT_DisconnectService = nil;
  BT_SetRemoteDeviceInfo: PBT_SetRemoteDeviceInfo = nil;
  BT_GetVersion: PBT_GetVersion = nil;

// WIDCOMM Bluetooth API.
type
  PWD_IsDeviceReady = function : BOOL; stdcall;
  PWD_IsStackServerUp = function : BOOL; stdcall;
  PWD_GetLocalDeviceVersionInfo = function (p_Dev_Ver_Info: PDEV_VER_INFO): BOOL; stdcall;
  PWD_GetLocalDeviceName = function (bdName: PBD_NAME): BOOL; stdcall;
  PWD_SetLocalDeviceName = function (bdName: BD_NAME): BOOL; stdcall;
  PWD_Inquiry = function (Devices: PDEVICE_LIST; bFast: BOOL): BOOL; stdcall;
  PWD_Discovery = function (Addr: TBluetoothAddress; pServiceList: PSERVICE_LIST; bFast: BOOL): BOOL; stdcall;
  PWD_CreateCOMPortAssociation = function (bda: TBluetoothAddress; p_guid: TGUID; szServiceName: LPCSTR; SecurityLevel: Byte; uuid: Word; var p_com_port: Word): BOOL; stdcall;
  PWD_RemoveCOMPortAssociation = function (com_port: Word): BOOL; stdcall;
  PWD_Bond = function (bda: TBluetoothAddress; pin_code: PChar): BOND_RETURN_CODE; stdcall;
  PWD_BondQuery = function (bda: TBluetoothAddress): BOOL; stdcall;
  PWD_OpenServer = function (ServiceUuid: TGUID; szServiceName: LPCTSTR; EncAuthFlags: Byte; dwData: DWORD; Port: Byte; Obex: Boolean; hWnd: THandle; var Handle: DWORD): BOOL; stdcall;
  PWD_CloseServer = procedure (var pHandle: DWORD); stdcall;
  PWD_Write = function (var pHandle: DWORD; pData: Pointer; wDataSize: Word; var pWrited: Word): BOOL; stdcall;
  PWD_UnBond = function (bda: TBluetoothAddress): BOOL; stdcall;
  PWD_IsRemoteDeviceConnected = function (db_addr_remote: TBluetoothAddress): BOOL; stdcall;
  PWD_InitDLL = procedure; stdcall;
  PWD_FreeDLL = procedure; stdcall;
  PWD_GetRemoteAddr = function (var pHandle: DWORD; Addr: PBluetoothAddress): BOOL; stdcall;
  PWD_GetConnectionStats = function (bda: TBluetoothAddress; p_conn_stats: PBT_CONN_STATS): BOOL; stdcall;
  PWD_GetVersion = procedure (Buf: PCHAR; Size: Integer); stdcall;

var
  WD_IsDeviceReady: PWD_IsDeviceReady = nil;
  WD_IsStackServerUp: PWD_IsStackServerUp = nil;
  WD_GetLocalDeviceVersionInfo: PWD_GetLocalDeviceVersionInfo = nil;
  WD_GetLocalDeviceName: PWD_GetLocalDeviceName = nil;
  WD_SetLocalDeviceName: PWD_SetLocalDeviceName = nil;
  WD_Inquiry: PWD_Inquiry = nil;
  WD_Discovery: PWD_Discovery = nil;
  WD_CreateCOMPortAssociation: PWD_CreateCOMPortAssociation = nil;
  WD_RemoveCOMPortAssociation: PWD_RemoveCOMPortAssociation = nil;
  WD_Bond: PWD_Bond = nil;
  WD_BondQuery: PWD_BondQuery = nil;
  WD_OpenServer: PWD_OpenServer = nil;
  WD_CloseServer: PWD_CloseServer = nil;
  WD_Write: PWD_Write = nil;
  WD_UnBond: PWD_UnBond = nil;
  WD_IsRemoteDeviceConnected: PWD_IsRemoteDeviceConnected = nil;
  WD_InitDLL: PWD_InitDLL = nil;
  WD_FreeDLL: PWD_FreeDLL = nil;
  WD_GetRemoteAddr: PWD_GetRemoteAddr = nil;
  WD_GetConnectionStats: PWD_GetConnectionStats = nil;
  WD_GetVersion: PWD_GetVersion = nil;

// Toshiba Bluetooth API
type
  PBtOpenAPI = function (hWndApi: HWND; pszApiName: PChar; var plStatus: Long): BOOL; cdecl;
  PBtCloseAPI = function (var plStatus: Long): BOOL; cdecl;
  PBtExecBtMng = function (var plStatus: Long): BOOL; cdecl;
  PBtGetLocalInfo2 = function (pBtLocalDeviceInfo: PBTLOCALDEVINFO2; var plStatus: Long): BOOL; cdecl;
  PBtSetLocalDeviceName = function (FriendlyName: PFRIENDLYNAME; var plStatu: Long): BOOL; cdecl;
  PBtGetLocalDeviceName = function (FriendlyName: PFRIENDLYNAME; var plStatus: Long): BOOL; cdecl;
  PBtGetClassOfDevice = function (pClassOfDevice: PCLASSOFDEV; var plStatus: Long): BOOL; cdecl;
  PBtGetDiscoverabilityMode = function (var pwDiscoverabilityMode: Word; var plStatus: Long): BOOL; cdecl;
  PBtGetConnectabilityMode = function (var pwConnectabilityMode: Word; var plStatus: Long): BOOL; cdecl;
  PBtDiscoverRemoteDevice2 = function (var pMemDevInfoList: PBTDEVINFOLIST; dwOption: DWORD; var plStatus: Long; hWndApp: HWND; uMessage: UINT; lParam: LPARAM): BOOL; cdecl;
  PBtMemFree = procedure (pMem: Pointer); cdecl;
  PBtGetRemoteDeviceList2 = function (dwDeviceInformationFlag: UINT; ftConditionTime: FILETIME; var pdwDevListNum: DWORD; var pMemDevInfoList: PBTDEVINFO; var lStatus): BOOL; cdecl;
  PBtRemoveRemoteDevice = function (pDeviceList: PBTDEVICELIST; var plStatus): BOOL; cdecl;
  PBtConnectSDP = function (var pBdAddr: TBluetoothAddress; var pwCID: Word; var plStatus: Long; hWndApp: HWND; UMessage: UINT; lParam: LPARAM): BOOL; cdecl;
  PBtDisconnectSDP = function (wCID: Word; var lpStatus: Long): BOOL; cdecl;
  PBtMakeServiceSearchPattern2 = function (pBtServiceClassUUIDs: PBTUUIDLIST; var pdwServiceSearchPatternSize: DWORD; var pMemServiceSearchPattern: PBYTE; var plStatus: Long): BOOL; cdecl;
  PBtServiceSearchAttribute2 = function (wCID: Word; dwServiceSearchPatternSize: DWORD; pbServiceSearchPattern: PBYTE; dwAttributeIDListSize: DWORD; pbAttributeIDList: PBYTE; var pMem_SDP_SSA_Result: PBTSDPSSARESULT; var plStatus: Long; hWndApp: HWND; uMessage: UINT; lParam: LPARAM): BOOL; cdecl;
  PBtMakeAttributeIDList2 = function (BtUnivAttribute: BTUNIVATTRIBUTE; var pdwAttributeIDListSize: DWORD; var pMemAttributeIDList: PBYTE; var plStatus: Long): BOOL; cdecl;
  PBtAnalyzeServiceAttributeLists2 = function (BtUnivAttribute: BTUNIVATTRIBUTE; pBtSDPSSAResult: PBTSDPSSARESULT; var pMemAnalyzedAttributeList: PBTANALYZEDATTRLIST2; var plStatus: Long): BOOL; cdecl;
  PBtFreePBTANALYZEDATTRLIST2 = function (var pMemAnalyzedAttributeList: PBTANALYZEDATTRLIST2; var plStatus: Long): BOOL; cdecl;
  PBtAnalyzeProtocolParameter2 = function (pBtProtocolList: PBTPROTOCOLLIST2; var pBtProtocolParam: BTPROTOCOLPARAM; var plStatus: Long): BOOL; cdecl;
  PBtServiceSearchAttributeSDDB2 = function (var pBdAddr: TBluetoothAddress; dwServiceSearchPatternSize: DWORD; pbServiceSearchPattern: PBYTE; dwAttributeIDListSize: DWORD; pbAttributeIDList: PBYTE; var pMemSDP_SSA_Result: PBTSDPSSARESULT; var plStatus: Long): BOOL; cdecl;
  PBtRefreshSDDB2 = function (fAllVicinityDevice: BOOL; var pBdAddr: TBluetoothAddress; var pMemDevInfoList: PBTDEVINFOLIST; var plStatus: Long; hWndApp: HWND; uMessage: UINT; lParam: LPARAM): BOOL; cdecl;
  PBtCreateCOMM = function (pszPortName: PChar; bSCN: Byte; wPSM: Word; var plStatus: Long): BOOL; cdecl;
  PBtDestroyCOMM = function (pszPortName: PChar; var plStatus: Long): BOOL; cdecl;
  PBtConnectCOMM2 = function (pszPortName: PChar; var pBdAddr: TBluetoothAddress; bServerChannelNum: Byte; wPSM: Word; var pwCID: Word; dwOption: DWORD; var plStatus: Long; hWndApp: HWND; uMessage: UINT; lParam: LPARAM): BOOL; cdecl;
  PBtDisconnectCOMM = function (pszPortName: PChar; var plStatus: Long): BOOL; cdecl;
  PBtGetConnectionHandle = function (wCID: Word; var pwConnectHandle: Word; var plStatus: Long): BOOL; cdecl;
  PBtGetLinkQuality = function (wConnectHandle: Word; var pbLinkQuality: Byte; var plStatus: Long): BOOL; cdecl;
  PBtAssignSCN = function (var pbSCN: Byte; var plStatus: Long): BOOL; cdecl;
  PBtFreeSCN = function (bSCN: Byte; var plStatus: Long): BOOL; cdecl;
  PBtGetCOMMInfoList2 = function (var pMemCOMMInfoList: PBTCOMMINFOLIST; var plStatus: Long): BOOL; cdecl;
  PBtMemAlloc = function (dwBytes: DWORD; dwFlags: DWORD): Pointer; cdecl;

var
  BtOpenAPI: PBtOpenAPI = nil;
  BtCloseAPI: PBtCloseAPI = nil;
  BtExecBtMng: PBtExecBtMng = nil;
  BtGetLocalInfo2: PBtGetLocalInfo2 = nil;
  BtSetLocalDeviceName: PBtSetLocalDeviceName = nil;
  BtGetLocalDeviceName: PBtGetLocalDeviceName = nil;
  BtGetClassOfDevice: PBtGetClassOfDevice = nil;
  BtGetDiscoverabilityMode: PBtGetDiscoverabilityMode = nil;
  BtGetConnectabilityMode: PBtGetConnectabilityMode = nil;
  BtDiscoverRemoteDevice2: PBtDiscoverRemoteDevice2 = nil;
  BtMemFree: PBtMemFree = nil;
  BtGetRemoteDeviceList2: PBtGetRemoteDeviceList2 = nil;
  BtRemoveRemoteDevice: PBtRemoveRemoteDevice = nil;
  BtConnectSDP: PBtConnectSDP = nil;
  BtDisconnectSDP: PBtDisconnectSDP = nil;
  BtMakeServiceSearchPattern2: PBtMakeServiceSearchPattern2 = nil;
  BtServiceSearchAttribute2: PBtServiceSearchAttribute2 = nil;
  BtMakeAttributeIDList2: PBtMakeAttributeIDList2 = nil;
  BtAnalyzeServiceAttributeLists2: PBtAnalyzeServiceAttributeLists2 = nil;
  BtFreePBTANALYZEDATTRLIST2: PBtFreePBTANALYZEDATTRLIST2 = nil;
  BtAnalyzeProtocolParameter2: PBtAnalyzeProtocolParameter2 = nil;
  BtServiceSearchAttributeSDDB2: PBtServiceSearchAttributeSDDB2 = nil;
  BtRefreshSDDB2: PBtRefreshSDDB2 = nil;
  BtCreateCOMM: PBtCreateCOMM = nil;
  BtDestroyCOMM: PBtDestroyCOMM = nil;
  BtConnectCOMM2: PBtConnectCOMM2 = nil;
  BtDisconnectCOMM: PBtDisconnectCOMM = nil;
  BtGetConnectionHandle: PBtGetConnectionHandle = nil;
  BtGetLinkQuality: PBtGetLinkQuality = nil;
  BtAssignSCN: PBtAssignSCN = nil;
  BtFreeSCN: PBtFreeSCN = nil;
  BtGetCOMMInfoList2: PBtGetCOMMInfoList2 = nil;
  BtMemAlloc: PBtMemAlloc = nil;

// Win Bluetooth API functions.
type
  PBluetoothFindFirstRadio = function (const pbtfrp: PBLUETOOTH_FIND_RADIO_PARAMS; var phRadio: THandle): HBLUETOOTH_RADIO_FIND; stdcall;
  PBluetoothFindNextRadio = function (hFind: HBLUETOOTH_RADIO_FIND; var phRadio: THandle): BOOL; stdcall;
  PBluetoothFindRadioClose = function (hFind: HBLUETOOTH_RADIO_FIND): BOOL; stdcall;
  PBluetoothGetDeviceInfo = function (hRadio: THandle; var pbtdi: BLUETOOTH_DEVICE_INFO): DWORD; stdcall;
  PBluetoothGetRadioInfo = function (hRadio: THandle; var pRadioInfo: BLUETOOTH_RADIO_INFO): DWORD; stdcall;
  PBluetoothRegisterForAuthentication = function (pbtdi: PBLUETOOTH_DEVICE_INFO; var phRegHandle: HBLUETOOTH_AUTHENTICATION_REGISTRATION; pfnCallback: PFN_AUTHENTICATION_CALLBACK; pvParam: Pointer): DWORD; stdcall;
  PBluetoothUnregisterAuthentication = function (hRegHandle: HBLUETOOTH_AUTHENTICATION_REGISTRATION): BOOL; stdcall;
  PBluetoothSendAuthenticationResponse = function (hRadio: THandle; pbtdi: PBLUETOOTH_DEVICE_INFO; pszPasskey: LPWSTR): DWORD; stdcall;
  PBluetoothRemoveDevice = function (var pAddress: BLUETOOTH_ADDRESS): DWORD; stdcall;
  PBluetoothSetServiceState = function (hRadio: THandle; pbtdi: PBLUETOOTH_DEVICE_INFO; pGuidService: PGUID; dwServiceFlags: DWORD): DWORD; stdcall;
  PBluetoothUpdateDeviceRecord = function (var pbtdi: BLUETOOTH_DEVICE_INFO): DWORD; stdcall;
  PBluetoothAuthenticateDevice = function (hwndParent: THandle; hRadio: THandle; var pbtdi: BLUETOOTH_DEVICE_INFO; pszPasskey: PWCHAR; ulPasskeyLength: ULONG): DWORD; stdcall;
  PBluetoothSdpGetAttributeValue = function (pRecordStream: PBYTE; cbRecordLength: ULONG; usAttributeId: Word; pAttributeData: PSDP_ELEMENT_DATA): DWORD; stdcall;
  PBluetoothIsDiscoverable = function (hRadio: THandle): BOOL; stdcall;
  PBluetoothIsConnectable = function (hRadio: THandle): BOOL; stdcall;
  PBluetoothEnableDiscovery = function (hRadio: THandle; fEnabled: BOOL): BOOL; stdcall;
  PBluetoothEnableIncomingConnections = function(hRadio: THandle; fEnabled: BOOL): BOOL; stdcall;

var
  BluetoothFindFirstRadio: PBluetoothFindFirstRadio = nil;
  BluetoothFindNextRadio: PBluetoothFindNextRadio = nil;
  BluetoothFindRadioClose: PBluetoothFindRadioClose = nil;
  BluetoothGetDeviceInfo: PBluetoothGetDeviceInfo = nil;
  BluetoothGetRadioInfo: PBluetoothGetRadioInfo = nil;
  BluetoothRegisterForAuthentication: PBluetoothRegisterForAuthentication = nil;
  BluetoothUnregisterAuthentication: PBluetoothUnregisterAuthentication = nil;
  BluetoothSendAuthenticationResponse: PBluetoothSendAuthenticationResponse = nil;
  BluetoothRemoveDevice: PBluetoothRemoveDevice = nil;
  BluetoothSetServiceState: PBluetoothSetServiceState = nil;
  BluetoothUpdateDeviceRecord: PBluetoothUpdateDeviceRecord = nil;
  BluetoothAuthenticateDevice: PBluetoothAuthenticateDevice = nil;
  BluetoothSdpGetAttributeValue: PBluetoothSdpGetAttributeValue = nil;
  BluetoothIsDiscoverable: PBluetoothIsDiscoverable = nil;
  BluetoothIsConnectable: PBluetoothIsConnectable = nil;
  BluetoothEnableDiscovery: PBluetoothEnableDiscovery = nil;
  BluetoothEnableIncomingConnections: PBluetoothEnableIncomingConnections = nil;

type
  PCeRapiInit = function: LongInt; stdcall;
  PCeRapiInitEx = function(RInit: PRAPIINIT): LongInt; stdcall;
  PCeCreateDatabase = function(lpszName: LPWSTR; dwDbaseType: DWORD; wNumSortOrder: Word; rgSortSpecs: PSORTORDERSPEC): CEOID; stdcall;
  PCeDeleteDatabase = function(oidDBase: CEOID): BOOL; stdcall;
  PCeDeleteRecord = function(hDatabase: THandle; oidRecord: CEOID): BOOL; stdcall;
  PCeFindFirstDatabase = function(dwDbaseType: DWORD): THandle; stdcall;
  PCeFindNextDatabase = function(hEnum: THandle): CEOID; stdcall;
  PCeOidGetInfo = function(oid: CEOID; poidInfo: PCEOIDINFO): BOOL; stdcall;
  PCeOpenDatabase = function(poid: PCEOID; lpszName: LPWSTR; propid: CEPROPID; dwFlags: DWORD; hwndNotify: HWND): THandle; stdcall;
  PCeReadRecordProps = function(hDbase: THandle; dwFlags: DWORD; cPropID: PWORD; var rgPropID: PCE_PROPID_ARRAY; Buffer: Pointer; cbBuffer: PDWORD): CEOID; stdcall;
  PCeSeekDatabase = function(hDatabase: THandle; dwSeekType: DWORD; dwValue: LongInt; dwIndex: PDWORD): CEOID; stdcall;
  PCeSetDatabaseInfo = function(oidDbase: CEOID; NewInfo: PCEDBASEINFO): BOOL; stdcall;
  PCeWriteRecordProps = function(hDbase: THandle; oidRecord: CEOID; cPropID: Word; PropVal: CEPROPVAL): CEOID; stdcall;
  PCeFindFirstFile = function(lpFileName: LPCWSTR; lpFindFileData: PCE_FIND_DATA): THandle; stdcall;
  PCeFindNextFile = function(hFindFile: THandle; lpFindFileData: PCE_FIND_DATA): BOOL; stdcall;
  PCeFindClose = function(hFindFile: THandle): BOOL; stdcall;
  PCeGetFileAttributes = function(lpFileName: LPCWSTR): DWORD; stdcall;
  PCeSetFileAttributes = function(FileName: LPCWSTR; dwFileAttributes: DWORD): BOOL; stdcall;
  PCeCreateFile = function(lpFileName: LPCWSTR; dwDesiredAccess: DWORD; dwShareMode: DWORD; lpSecurityAttributes: PSecurityAttributes; dwCreationDistribution: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle; stdcall;
  PCeReadFile = function(hFile: THandle; lpBuffer: Pointer; nNumberOfBytesToRead: DWORD; NumberOfBytesRead: PDWORD; Overlapped: POVERLAPPED): BOOL; stdcall;
  PCeWriteFile = function(hFile: THandle; Buffer: Pointer; NumberOfBytesToWrite: DWORD; NumberOfBytesWritten: PDWORD; OverLapped: POVERLAPPED): BOOL; stdcall;
  PCeCloseHandle = function(hObject: THandle): BOOL; stdcall;
  PCeFindAllDatabases = function(dwDbaseType: DWORD; wFlags: Word; cFindData: PDWORD; var ppFindData: PCEDB_FILE_DATA_ARRAY): BOOL; stdcall;
  PCeGetLastError = function: DWORD; stdcall;
  PGetRapiError = function: LongInt; stdcall ;
  PCeSetFilePointer = function(hFile: THandle; DistanceToMove: LongInt; DistanceToMoveHigh: PULONG; dwMoveMethod: DWORD): DWORD; stdcall;
  PCeSetEndOfFile = function(hFile: THandle): BOOL; stdcall;
  PCeCreateDirectory = function(lpPathName: LPCWSTR; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall;
  PCeRemoveDirectory = function(PathName: LPCWSTR): BOOL; stdcall;
  PCeCreateProcess = function(lpApplicationName: LPCWSTR; lpCommandLine: LPCWSTR; lpProcessAttributes: PSecurityAttributes; lpThreadAttributes: PSecurityAttributes; bInheritHandles: BOOL; dwCreateFlags: DWORD; lpEnvironment: Pointer; lpCurrentDirectory: LPWSTR; lpStartupInfo: PSTARTUPINFO; lpProcessInformation: PProcessInformation): BOOL; stdcall;
  PCeMoveFile = function(lpExistingFileName: LPCWSTR; lpNewFileName: LPCWSTR): BOOL; stdcall;
  PCeCopyFile = function(lpExistingFileName: LPCWSTR; lpNewFileName: LPCWSTR; bFailIfExists: BOOL): BOOL; stdcall;
  PCeDeleteFile = function(lpFileName: LPCWSTR): BOOL; stdcall;
  PCeGetFileSize = function(hFile: THandle; lpFileSizeHigh: PDWORD): DWORD; stdcall;
  PCeRegOpenKeyEx = function(hKey: HKEY; SubKey: LPCWSTR; Reserved: DWORD; samDesired: REGSAM; Result: PHKEY): LongInt; stdcall;
  PCeRegEnumKeyEx = function(hKey: HKEY; dwIndex: DWORD; KeyName: LPWSTR; chName: PDWORD; reserved: PDWORD; szClass: LPWSTR; cchClass: PDWORD; ftLastWrite: PFILETIME): LongInt; stdcall;
  PCeRegCreateKeyEx = function(hKey: HKEY; lpSzSubKey: LPCWSTR; dwReserved: DWORD; lpszClass: LPWSTR; dwOption: DWORD; samDesired: REGSAM; lpSecurityAttributes: PSecurityAttributes; phkResult: PHKEY; lpdwDisposition: PDWORD): LongInt; stdcall;
  PCeRegCloseKey = function(hKey: HKEY): LongInt; stdcall;
  PCeRegDeleteKey = function(hKey: HKEY; lpszSubKey: LPCWSTR): LongInt; stdcall;
  PCeRegEnumValue = function(hKey: HKEY; dwIndex: DWORD; lpszName: LPWSTR; lpcchName: PDWORD; lpReserved: PDWORD; lpszClass: PDWORD; lpcchClass: PBYTE; lpftLastWrite: PDWORD): LongInt; stdcall;
  PCeRegDeleteValue = function(hKey: HKEY; lpszValueName: LPCWSTR): LongInt; stdcall;
  PCeRegQueryInfoKey = function(hKey: HKEY; ClassName: LPWSTR; cchClass: PDWORD; Reserved: PDWORD; cSubKeys: PDWORD; cchMaxSubKeyLen: PDWORD; cchMaxClassLen: PDWORD; cValues: PDWORD; cchMaxValueNameLen: PDWORD; cbMaxValueData: PDWORD; cbSecurityDescriptor: PDWORD; LastWriteTime: PFILETIME): LongInt; stdcall;
  PCeRegQueryValueEx = function(hKey: HKEY; ValueName: LPCWSTR; Reserved: PDWORD; pType: PDWORD; pData: PBYTE; cbData: PDWORD): LongInt; stdcall;
  PCeRegSetValueEx = function(hKey: HKEY; ValueName: LPCWSTR; reserved: DWORD; dwType: DWORD; pData: PBYTE; cbData: DWORD): LongInt; stdcall;
  PCeGetStoreInformation = function(lpsi: PSTORE_INFORMATION): BOOL; stdcall;
  PCeGetSystemMetrics = function(nIndex: Integer): Integer; stdcall;
  PCeGetDesktopDeviceCaps = function(nIndedx: Integer): LongInt; stdcall;
  PCeGetSystemInfo = procedure(lpSystemInfo: PSystemInfo); stdcall;
  PCeSHCreateShortcut = function(ShortCut: LPWSTR; Target: LPWSTR): DWORD; stdcall;
  PCeSHGetShortcutTarget = function(ShortCut: LPWSTR; Target: LPWSTR; cbMax: Integer): BOOL; stdcall;
  PCeCheckPassword = function(lpszPassword: LPWSTR): BOOL; stdcall;
  PCeGetFileTime = function(hFile: THandle; lpCreationTime: PFILETIME; lpLastAccessTime: PFILETIME; lpLastWriteTime: PFILETIME): BOOL; stdcall;
  PCeSetFileTime = function(hFile: THandle; CreationTime: PFILETIME; LastAccessTime: PFILETIME; lastWriteTime: PFILETIME): BOOL; stdcall;
  PCeGetVersionEx = function(lpVersionInfo: PCEOSVERSIONINFO): BOOL; stdcall;
  PCeGetWindow = function(hWnd: HWND; uCmd: UINT): HWND; stdcall;
  PCeGetWindowLong = function(hWnd: HWND; nIndex: Integer): LongInt; stdcall;
  PCeGetWindowText = function(hWnd: HWND; lpString: LPWSTR; nMaxCount: Integer): Integer; stdcall;
  PCeGetClassName = function(hWnd: HWND; lpClassName: LPWSTR; nMaxCount: Integer): Integer; stdcall;
  PCeGlobalMemoryStatus = procedure(lpmst: PMemoryStatus); stdcall;
  PCeGetSystemPowerStatusEx = function(pStatus: PSYSTEM_POWER_STATUS_EX; fUpdate: BOOL): BOOL; stdcall;

  PCeRapiUnInit = function: LongInt; stdcall;
  PCeFindAllFiles = function(Path: PWideChar; Attr: DWORD; var Count: DWORD; var FindData: PCE_FIND_DATA_ARRAY): BOOL; stdcall;
  PCeRapiFreeBuffer = procedure(p: Pointer); stdcall;

var
  CeRapiInit: PCeRapiInit = nil;
  CeRapiUnInit: PCeRapiUnInit = nil;
  CeFindAllFiles: PCeFindAllFiles = nil;
  CeRapiFreeBuffer: PCeRapiFreeBuffer = nil;
  CeRapiInitEx: PCeRapiInitEx = nil;
  CeCreateDatabase: PCeCreateDatabase = nil;
  CeDeleteDatabase: PCeDeleteDatabase = nil;
  CeDeleteRecord: PCeDeleteRecord = nil;
  CeFindFirstDatabase: PCeFindFirstDatabase = nil;
  CeFindNextDatabase: PCeFindNextDatabase = nil;
  CeOidGetInfo: PCeOidGetInfo = nil;
  CeOpenDatabase: PCeOpenDatabase = nil;
  CeReadRecordProps: PCeReadRecordProps = nil;
  CeSeekDatabase: PCeSeekDatabase = nil;
  CeSetDatabaseInfo: PCeSetDatabaseInfo = nil;
  CeWriteRecordProps: PCeWriteRecordProps = nil;
  CeFindFirstFile: PCeFindFirstFile = nil;
  CeFindNextFile: PCeFindNextFile = nil;
  CeFindClose: PCeFindClose = nil;
  CeGetFileAttributes: PCeGetFileAttributes = nil;
  CeSetFileAttributes: PCeSetFileAttributes = nil;
  CeCreateFile: PCeCreateFile = nil;
  CeReadFile: PCeReadFile = nil;
  CeWriteFile: PCeWriteFile = nil;
  CeCloseHandle: PCeCloseHandle = nil;
  CeFindAllDatabases: PCeFindAllDatabases = nil;
  CeGetLastError: PCeGetLastError = nil;
  GetRapiError: PGetRapiError = nil;
  CeSetFilePointer: PCeSetFilePointer = nil;
  CeSetEndOfFile: PCeSetEndOfFile = nil;
  CeCreateDirectory: PCeCreateDirectory = nil;
  CeRemoveDirectory: PCeRemoveDirectory = nil;
  CeCreateProcess: PCeCreateProcess = nil;
  CeMoveFile: PCeMoveFile = nil;
  CeCopyFile: PCeCopyFile = nil;
  CeDeleteFile: PCeDeleteFile = nil;
  CeGetFileSize: PCeGetFileSize = nil;
  CeRegOpenKeyEx: PCeRegOpenKeyEx = nil;
  CeRegEnumKeyEx: PCeRegEnumKeyEx = nil;
  CeRegCreateKeyEx: PCeRegCreateKeyEx = nil;
  CeRegCloseKey: PCeRegCloseKey = nil;
  CeRegDeleteKey: PCeRegDeleteKey = nil;
  CeRegEnumValue: PCeRegEnumValue = nil;
  CeRegDeleteValue: PCeRegDeleteValue = nil;
  CeRegQueryInfoKey: PCeRegQueryInfoKey = nil;
  CeRegQueryValueEx: PCeRegQueryValueEx = nil;
  CeRegSetValueEx: PCeRegSetValueEx = nil;
  CeGetStoreInformation: PCeGetStoreInformation = nil;
  CeGetSystemMetrics: PCeGetSystemMetrics = nil;
  CeGetDesktopDeviceCaps: PCeGetDesktopDeviceCaps = nil;
  CeGetSystemInfo: PCeGetSystemInfo = nil;
  CeSHCreateShortcut: PCeSHCreateShortcut = nil;
  CeSHGetShortcutTarget: PCeSHGetShortcutTarget = nil;
  CeCheckPassword: PCeCheckPassword = nil;
  CeGetFileTime: PCeGetFileTime = nil;
  CeSetFileTime: PCeSetFileTime = nil;
  CeGetVersionEx: PCeGetVersionEx = nil;
  CeGetWindow: PCeGetWindow = nil;
  CeGetWindowLong: PCeGetWindowLong = nil;
  CeGetWindowText: PCeGetWindowText = nil;
  CeGetClassName: PCeGetClassName = nil;
  CeGlobalMemoryStatus: PCeGlobalMemoryStatus = nil;
  CeGetSystemPowerStatusEx: PCeGetSystemPowerStatusEx = nil;

var
  // Global variable - instance of the TBFAPI class.
  // NEVER create, destroy or change thi variable and TBFAPI class instance.
  API: TBFAPI = nil;

function CompareGUIDs(GUID1: TGUID; GUID2: TGUID): Boolean;
function BFBoolToStr(Value: Boolean): string;

function IsWinXP: Boolean;

implementation

uses
  Dialogs, SysUtils, Registry{$IFDEF DELPHI5}, Forms, ComObj{$ENDIF};

function CompareGUIDs(GUID1: TGUID; GUID2: TGUID): Boolean;
begin
  Result := CompareMem(@GUID1, @GUID2, SizeOf(TGUID));
end;

function BFBoolToStr(Value: Boolean): string;
begin
  if Value then
    Result := StrTrue
  else
    Result := StrFalse;
end;

function IsWinXP: Boolean;
var
  OSVersion : TOSVersionInfo;
begin
  OSVersion.dwOSVersionInfoSize := sizeof(OSVersion);
  GetVersionEx(OSVersion);
  Result := (OSVersion.dwMajorVersion = 5) and (OSVersion.dwMinorVersion = 1);
end;

function WSAStartup(wVersionRequired: Word; var lpWSAData: WSAData): Integer; stdcall; external 'ws2_32.dll' name 'WSAStartup';
function WSACleanup: Integer; stdcall; external 'ws2_32.dll' name 'WSACleanup';

{ TBFAPI }

function TBFAPI.BlueSoleilAddressToBTAddress(Addr: TBluetoothAddress): BTH_ADDR;
var
  BluetoothAddress: BLUETOOTH_ADDRESS;
begin
  FillChar(BluetoothAddress, SizeOf(BLUETOOTH_ADDRESS), 0);
  with BluetoothAddress do begin
    rgBytes := Addr;
    Result := ullLong;
  end;
end;

function TBFAPI.BlueSoleilAddressToString(Addr: TBluetoothAddress): string;
var
  Loop: Byte;
begin
  Result := '(' + IntToHex(Addr[5], 2) + ':';
  for Loop := 4 downto 1 do Result := Result + IntToHex(Addr[Loop], 2) + ':';
  Result := Result + IntToHex(Addr[0], 2) + ')';
end;

function TBFAPI.BlueSoleilClassOfDeviceToCOD(COD: TBluetoothClassOfDevice; WidComm: Boolean = False): DWORD;
begin
  if WidComm then
    Result := COD[0] shl 16 or COD[1] shl 8 or COD[2]
    
  else
    Result := COD[2] shl 16 or COD[1] shl 8 or COD[0];
end;

procedure TBFAPI.CheckBluetoothAddress(Address: string);
var
  Loop: Integer;
begin
  // Check Bluetooth address format.
  if Length(Address) <> 19 then raise Exception.CreateFmt(StrInvalidAddressFormat, [StrBluetooth]);

  if (Address[1] <> '(') or (Address[4] <> ':') or (Address[7] <> ':') or
     (Address[10] <> ':') or (Address[13] <> ':') or (Address[16] <> ':') or
     (Address[19] <> ')') then raise Exception.CreateFmt(StrInvalidAddressFormat, [StrBluetooth]);

  for Loop := 1 to 19 do
    if not IsDelimiter('():0123456789ABCDEFabcdef', Address, Loop) then
       raise Exception.CreateFmt(StrInvalidAddressFormat, [StrBluetooth]);
end;

procedure TBFAPI.CheckTransport(ATransport: TBFAPITransport);
begin
  if not (ATransport in FTransports) then raise Exception.CreateFmt(StrTransportNotAvailable, [TransportTagToName(ATransport)]);
end;

function TBFAPI.ClassOfDeviceToString(ClassOfDevice: DWORD): string;
begin
  case ClassOfDevice and COD_DEVICE_CLASS_MASK of
    COD_COMPCLS_UNCLASSIFIED: Result := Format(StrCODComputer, [StrCODUnclissified]);
    COD_COMPCLS_DESKTOP: Result := Format(StrCODComputer, [StrCODComputerDesktop]);
    COD_COMPCLS_SERVER: Result := Format(StrCODComputer, [StrCODComputerServer]);
    COD_COMPCLS_LAPTOP: Result := Format(StrCODComputer, [StrCODComputerLapTop]);
    COD_COMPCLS_HANDHELD: Result := Format(StrCODComputer, [StrCODComputerHanddeld]);
    COD_COMPCLS_PALMSIZED: Result := Format(StrCODComputer, [StrCODComputerPalmSized]);
    COD_COMPCLS_WEARABLE: Result := Format(StrCODComputer, [StrCODComputerWearable]);

    COD_PHONECLS_UNCLASSIFIED: Result := Format(StrCODPhone, [StrCODUnclissified]);
    COD_PHONECLS_CELLULAR: Result := Format(StrCODPhone, [StrCODPhoneCellurar]);
    COD_PHONECLS_CORDLESS: Result := Format(StrCODPhone, [StrCODPhoneCordless]);
    COD_PHONECLS_SMARTPHONE: Result := Format(StrCODPhone, [StrCODPhoneSmartphone]);
    COD_PHONECLS_WIREDMODEM: Result := Format(StrCODPhone, [StrCODPhoneWiredmodem]);
    COD_PHONECLS_COMMONISDNACCESS: Result := Format(StrCODPhone, [StrCODPhoneCommonISDNAccess]);
    COD_PHONECLS_SIMCARDREADER: Result := Format(StrCODPhone, [StrCODPhoneSIMCatdReader]);

    COD_LAP_FULL: Result := Format(StrCODLAP, [StrCODLAPFull]);
    COD_LAP_17: Result := Format(StrCODLAP, [StrCODLAP17]);
    COD_LAP_33: Result := Format(StrCODLAP, [StrCODLAP33]);
    COD_LAP_50: Result := Format(StrCODLAP, [StrCODLAP50]);
    COD_LAP_67: Result := Format(StrCODLAP, [StrCODLAP67]);
    COD_LAP_83: Result := Format(StrCODLAP, [StrCODLAP83]);
    COD_LAP_99: Result := Format(StrCODLAP, [StrCODLAP99]);
    COD_LAP_NOSRV: Result := Format(StrCODLAP, [StrCODLAPNoSrv]);

    COD_AV_UNCLASSIFIED: Result := Format(StrCODAV, [StrCODUnclissified]);
    COD_AV_HEADSET: Result := Format(StrCODAV, [StrCODAVHeadset]);
    COD_AV_HANDSFREE: Result := Format(StrCODAV, [StrCODAVHandsFree]);
    COD_AV_HEADANDHAND: Result := Format(StrCODAV, [StrCODAVHeadAndHand]);
    COD_AV_MICROPHONE: Result := Format(StrCODAV, [StrCODAVMicrophone]);
    COD_AV_LOUDSPEAKER: Result := Format(StrCODAV, [StrCODAVLoudspeaker]);
    COD_AV_HEADPHONES: Result := Format(StrCODAV, [StrCODAVHeadphones]);
    COD_AV_PORTABLEAUDIO: Result := Format(StrCODAV, [StrCODAVPortableAudio]);
    COD_AV_CARAUDIO: Result := Format(StrCODAV, [StrCODAVCarAudio]);
    COD_AV_SETTOPBOX: Result := Format(StrCODAV, [StrCODAVSetTopBox]);
    COD_AV_HIFIAUDIO: Result := Format(StrCODAV, [StrCODAVHiFiAudio]);
    COD_AV_VCR: Result := Format(StrCODAV, [StrCODAVVCR]);
    COD_AV_VIDEOCAMERA: Result := Format(StrCODAV, [StrCODAVVideoCamera]);
    COD_AV_CAMCORDER: Result := Format(StrCODAV, [StrCODAVCamCoder]);
    COD_AV_VIDEOMONITOR: Result := Format(StrCODAV, [StrCODAVVideoMonitor]);
    COD_AV_VIDEODISPANDLOUDSPK: Result := Format(StrCODAV, [StrCODAVVideoDispAndLoudSpk]);
    COD_AV_VIDEOCONFERENCE: Result := Format(StrCODAV, [StrCODAVVideoConference]);
    COD_AV_GAMEORTOY : Result := Format(StrCODAV, [StrCODAVGameOrToy]);

    COD_PERIPHERAL_KEYBOARD: Result := Format(StrCODPeripheral, [StrCODPeripheralKeyborad]);
    COD_PERIPHERAL_POINT: Result := Format(StrCODPeripheral, [StrCODPeripheralPoint]);
    COD_PERIPHERAL_KEYORPOINT: Result := Format(StrCODPeripheral, [StrCODPeripheralKeyOrPoint]);
    COD_PERIPHERAL_UNCLASSIFIED: Result := Format(StrCODPeripheral, [StrCODUnclissified]);
    COD_PERIPHERAL_JOYSTICK: Result := Format(StrCODPeripheral, [StrCODPeripheralJoystick]);
    COD_PERIPHERAL_GAMEPAD: Result := Format(StrCODPeripheral, [StrCODPeripheralGamepad]);
    COD_PERIPHERAL_REMCONTROL: Result := Format(StrCODPeripheral, [StrCODPeripheralRemControl]);
    COD_PERIPHERAL_SENSE: Result := Format(StrCODPeripheral, [StrCODPeripheralSense]);

    COD_IMAGE_DISPLAY: Result := Format(StrCODImage, [StrCODImageDisplay]);
    COD_IMAGE_CAMERA: Result := Format(StrCODImage, [StrCODImageCamera]);
    COD_IMAGE_SCANNER: Result := Format(StrCODImage, [StrCODImageScanner]);
    COD_IMAGE_PRINTER: Result := Format(StrCODImage, [StrCODImagePrinter]);

  else
    Result := Format(StrCODUnknown, [StrUnknown]);
  end;
end;

constructor TBFAPI.Create;
begin
  FWnd := AllocateHWnd(WndProc);

  LoadAPIs;
end;

destructor TBFAPI.Destroy;
begin
  UnloadAPIs;

  DeallocateHWnd(FWnd);

  inherited;
end;

function TBFAPI.IrDAAddressToString(IrDAAddress: IRDA_ADDR): string;
var
  Loop: Byte;
begin
  Result := '(';

  for Loop := 3 downto 0 do begin
    Result := Result + IntToHex(Ord(IrDAAddress[Loop]), 2);
    if Loop > 0 then Result := Result + ':';
  end;

  Result := Result + ')';
end;

procedure TBFAPI.RaiseTosError(Status: Integer);
var
  Str: string;
begin
  case Status of
    TOSBTAPI_ERROR                               : Str := 'The other error (The un-supported feature and so on)';
    TOSBTAPI_ERROR_DEVICE_NOT_READY              : Str := 'Invalid handle of device driver';
    TOSBTAPI_ERROR_DEVICE_CALL                   : Str := 'N:DeviceIoCtrl failure(Driver called error)';
    TOSBTAPI_ERROR_MEMORY_ALLOCATE               : Str := 'Memory allocate/resize failure';
    TOSBTAPI_ERROR_CONNECTION                    : Str := 'Connection failure';
    TOSBTAPI_ERROR_PARAMETER                     : Str := 'Parameter is wrong value';
    TOSBTAPI_ERROR_PENDING                       : Str := 'N:Pending(for NonBroking Management)';
    TOSBTAPI_ERROR_READINVALIDDATA               : Str := 'N:Invalid data received';
    TOSBTAPI_ERROR_SDPTRANSACTION                : Str := 'SDP transaction failure(excpt TOSBTAPI_ERROR_SDPTRANS_xxxx)';
    TOSBTAPI_ERROR_INQUIRY                       : Str := 'Inquiry failure';
    TOSBTAPI_ERROR_READREMOTENAME                : Str := 'Get RemoteName Management failure';
    TOSBTAPI_ERROR_FUNCTION_NUM                  : Str := 'N:It is unjust that the TosBtSDP function from TosBtAPI specifies a number';
    TOSBTAPI_ERROR_CANNOT_ASSIGN_SCN             : Str := 'Can''t assign ServerChannelNumber in BtCreateCOMM()';
    TOSBTAPI_ERROR_CREATECOMM                    : Str := 'BtCreateCOMM()/BtCreateCOMMEx() failure';
    TOSBTAPI_ERROR_DESTROYCOMM                   : Str := 'BtDestroyCOMM() failure';
    TOSBTAPI_ERROR_CONNECTCOMM                   : Str := 'BtConnectCOMM() failure';
    TOSBTAPI_ERROR_DISCONNECTCOMM                : Str := 'BtDisconnectCOMM() failure';
    TOSBTAPI_ERROR_POWERSWITCH                   : Str := 'BtSetPowerSwitch()/BtGetPowerSwitch() failure';
    TOSBTAPI_ERROR_CANNOT_ASSIGN_PSM             : Str := 'Can''t assign PSM in BtBeginLANEServer()';
    TOSBTAPI_ERROR_BEGINLANESERVER               : Str := 'BtBeginLANEServer() failure';
    TOSBTAPI_ERROR_CONNECTLANE                   : Str := 'BtConnectLANE() failure';
    TOSBTAPI_ERROR_GETLOCALINFO                  : Str := 'BtGetxxxxMode() etc. failure';
    TOSBTAPI_ERROR_DISCONNECTSDP                 : Str := 'BtDisconnectSDP() failure';
    TOSBTAPI_ERROR_NOTIFYCOMM                    : Str := 'BtNotifyCOMM() failure';
    TOSBTAPI_ERROR_ENDLANESERVER                 : Str := 'BtEndLANEServer() failure';
    TOSBTAPI_ERROR_DISCONNECTLANE                : Str := 'BtDisconnectLANE() failure';
    TOSBTAPI_ERROR_NOTIFYLANE                    : Str := 'BtNotifyLANE() failure';
    TOSBTAPI_ERROR_SETLOCALINFO                  : Str := 'BtSetxxxxMode() etc. failure';
    TOSBTAPI_ERROR_REFRESHSDDB                   : Str := 'BtRefreshSDDB() failure';
    TOSBTAPI_ERROR_GETCOMMINFOLIST               : Str := 'BtGetCOMMInfoList() failure';
    TOSBTAPI_ERROR_GETCOMMCREATORNAME            : Str := 'BtGetCOMMCreatorName() failure';
    TOSBTAPI_ERROR_GETLANEINFOLIST               : Str := 'BtGetLANEInfoList() failure';
    TOSBTAPI_ERROR_GETLANECREATORNAME            : Str := 'BtGetLANECreatorName() failure';
    TOSBTAPI_ERROR_GETCONNECTEDDEVICELIST        : Str := 'BtGetConnectedDeviceList() failure';
    TOSBTAPI_ERROR_GETCIDLIST                    : Str := 'BtGetCIDList() failure';
    TOSBTAPI_ERROR_GETCONNECTIONHANDLE           : Str := 'BtGetConnectionHandle() failure';
    TOSBTAPI_ERROR_GETLANEMAXCONNECTIONS         : Str := 'BtGetLANEMaxConnections() failure';
    TOSBTAPI_ERROR_ROLEDISCOVERY                 : Str := 'BtRoleDiscovery() failure';
    TOSBTAPI_ERROR_SWITCHROLE                    : Str := 'BtSwitchRole() failure';
    TOSBTAPI_ERROR_SETROLESTATE                  : Str := 'BtSetRoleState() failure';
    TOSBTAPI_ERROR_GETROLESTATE                  : Str := 'BtGetRoleState() failure';
    TOSBTAPI_ERROR_WRONGATTRLISTSRECEIVED        : Str := 'Wrong AttributeLists Response Received';
    TOSBTAPI_ERROR_OPENDRIVERS                   : Str := 'BtOpenDrivers() failure';
    TOSBTAPI_ERROR_CONNECT                       : Str := 'BtConnect() failure';
    TOSBTAPI_ERROR_CONNECT_PSM                   : Str := 'BtConnect() failure - PSM Error';
    TOSBTAPI_ERROR_CONNECT_SECURITY              : Str := 'BtConnect() failure - Security block';
    TOSBTAPI_ERROR_CONNECT_TIMEOUT               : Str := 'BtConnect() failure - Connectiontimeout';
    TOSBTAPI_ERROR_DISCONNECT                    : Str := 'BtDisconnect() failure';
    TOSBTAPI_ERROR_DISCONNECT_TIMEOUT            : Str := 'BtDisconnect() failure - timeout';
    TOSBTAPI_ERROR_LISTEN                        : Str := 'BtListen() failure';
    TOSBTAPI_ERROR_CANCELLISTEN                  : Str := 'BtCancelListen() failure';
    TOSBTAPI_ERROR_ACCEPT                        : Str := 'BtAccept() failure';
    TOSBTAPI_ERROR_REJECT                        : Str := 'BtReject() failure';
    TOSBTAPI_ERROR_NOTIFY                        : Str := 'BtNotify() failure';
    TOSBTAPI_ERROR_CANCELNOTIFY                  : Str := 'BtCancelNotify() failure';
    TOSBTAPI_ERROR_CONFIGREQUEST                 : Str := 'BtConfigRequest() failure';
    TOSBTAPI_ERROR_CONFIG_UNACCEPTABLE_PARAMETER : Str := 'BtConfigRequest(), BtConfigResponse() failure - unacceptable parameter';
    TOSBTAPI_ERROR_CONFIG_REJECT_NO_REASON       : Str := 'BtConfigRequest(), BtConfigResponse() failure - Reject with no reason';
    TOSBTAPI_ERROR_CONFIG_UNKNOWN_OPTION         : Str := 'BtConfigRequest(), BtConfigResponse() failure - unknown option';
    TOSBTAPI_ERROR_CONFIG_TIMEOUT                : Str := 'BtConfigRequest() failure - timeout';
    TOSBTAPI_ERROR_CONFIGRESPONSE                : Str := 'BtConfigResponse() failure';
    TOSBTAPI_ERROR_SENDDATA                      : Str := 'BtSendData() failure';
    TOSBTAPI_ERROR_SENDDATA_FLUSHTIMEOUT         : Str := 'BtSendData() failure - flush timeout';
    TOSBTAPI_ERROR_SENDDATA_LINK_TERMINATE       : Str := 'BtSendData() failure - link loss';
    TOSBTAPI_ERROR_RECVDATA                      : Str := 'BtRecvData() failure';
    TOSBTAPI_ERROR_SETAUTOCONNECTCOMMINFO        : Str := 'BtSetAutoConnectCOMMInfo() failure';
    TOSBTAPI_ERROR_GETAUTOCONNECTCOMMINFOLIST    : Str := 'BtGetAutoConnectCOMMInfoList() failure';
    TOSBTAPI_ERROR_SETAUTOCONNECTCOMMSTATE       : Str := 'BtSetAutoConnectCOMMState() failure';
    TOSBTAPI_ERROR_ADDHIDDEVICE                  : Str := 'BtAddHIDDevice() failure';
    TOSBTAPI_ERROR_REMOVEHIDDEVICE               : Str := 'BtRemoveHIDDevice() failure';
    TOSBTAPI_ERROR_CONNECTHID                    : Str := 'BtConnectHID() failure';
    TOSBTAPI_ERROR_DISCONNECTHID                 : Str := 'BtDisconnectHID() failure';
    TOSBTAPI_ERROR_GETHIDINFOLIST                : Str := 'BtGetHIDInfoList() failure';
    TOSBTAPI_ERROR_CONFIG_INVALIDCID             : Str := 'BtConfigRequest(), BtConfigResponse() failure - invalid CID';
    TOSBTAPI_ERROR_PANLISTEN                     : Str := 'BtPANListen() failure';
    TOSBTAPI_ERROR_CONNECTPAN                    : Str := 'BtConnectPAN() failure';
    TOSBTAPI_ERROR_DISCONNECTPAN                 : Str := 'BtDisconnectPAN() failure';
    TOSBTAPI_ERROR_NOTIFYPAN                     : Str := 'BtNotifyPAN() failure';
    TOSBTAPI_ERROR_GETPANINFOLIST                : Str := 'BtGetPANInfoList() failure';
    TOSBTAPI_ERROR_PANSWITCHROLE                 : Str := 'BtPANSwitchRole() failure';
    TOSBTAPI_ERROR_PLUGIN_HID                    : Str := 'plugin HID-Driver failure at BtConnectHID() process';
    TOSBTAPI_ERROR_CHANGEHIDSETTINGS             : Str := 'BtChangeHIDSettings() failure';
    TOSBTAPI_ERROR_PANRECVDATA                   : Str := 'BtPANRecvData() failure';
    TOSBTAPI_ERROR_GETPSMLIST                    : Str := 'BtGetPSMList() failure';
    TOSBTAPI_ERROR_ANALYZEDIATTRIBUTELISTS       : Str := 'BtAnalyzeDIAttibuteLists() failure';
    TOSBTAPI_ERROR_GETHCRPINFOLIST               : Str := 'BtGetHCRPInfoList() failure';
    TOSBTAPI_ERROR_BWCAUTH                       : Str := 'BtBWCAuth() failure';
    TOSBTAPI_ERROR_CANHIDHOSTSUPPORT             : Str := 'BtCanHIDHostSupport() failure';
    TOSBTAPI_ERROR_SETLINKSUPERVISIONTIMEOUT     : Str := 'BtSetLinkSupervisionTimeout() failure';
    TOSBTAPI_ERROR_GETLINKSUPERVISIONTIMEOUT     : Str := 'BtGetLinkSupervisionTimeout() failure';
    TOSBTAPI_ERROR_SETPERIODICINQUIRYMODE        : Str := 'BtSetPeriodicInquiryMode() failure';
    TOSBTAPI_ERROR_GETPERIODICINQUIRYMODE        : Str := 'BtGetPeriodicInquiryMode() failure';
    TOSBTAPI_ERROR_GETLASTINQUIRYTIME            : Str := 'BtGetLastInquiry() failure';
    TOSBTAPI_ERROR_GETLINKQUALITY                : Str := 'BtGetLinkQuality() failure';
    TOSBTAPI_ERROR_GETRSSI                       : Str := 'BtGetRSSI() failure';
    TOSBTAPI_ERROR_SETDEVICEPROPERTYPARAM        : Str := 'BtSetDevicePropertyParam() failure';
    TOSBTAPI_ERROR_GETDEVICEPROPERTYPARAM        : Str := 'BtGetDevicePropertyParam() failure';
    TOSBTAPI_ERROR_SDPTRANS_INSUFFICIENTRESOURCE : Str := 'SDP-Transaction failure(ErrCode=6:Insufficient Resource to satisfy Request)';
    TOSBTAPI_ERROR_SDPTRANS_INVALIDCONTINUSTAT   : Str := 'SDP-Transaction failure(ErrCode=5:Invalid Continuation State)';
    TOSBTAPI_ERROR_SDPTRANS_INVALIDPDUSIZE       : Str := 'SDP-Transaction failure(ErrCode=4:Invalid PDU Size)';
    TOSBTAPI_ERROR_SDPTRANS_INVALIDREQUEST       : Str := 'SDP-Transaction failure(ErrCode=3:Invalid request syntax)';
    TOSBTAPI_ERROR_SDPTRANS_INVALIDHANDLE        : Str := 'SDP-Transaction failure(ErrCode=2:Invalid Service Record Handle)';
    TOSBTAPI_ERROR_SDPTRANS_UNSUPPORTEDVERSION   : Str := 'SDP-Transaction failure(ErrCode=1:Invalid/unsupport SDP version)';
    TOSBTAPI_ERROR_FILEOPEN                      : Str := 'N:SDP-DB file open failure';
    TOSBTAPI_ERROR_FILECLOSE                     : Str := 'N:SDP-DB file close failure';
    TOSBTAPI_ERROR_FILEREAD                      : Str := 'Data read from SDP-DB file failure';
    TOSBTAPI_ERROR_FILEWRITE                     : Str := 'Data write to SDP-DB file failure';
    TOSBTAPI_ERROR_GETFILESIZE                   : Str := 'N:Get file size management form SDP-DB file failure';
    TOSBTAPI_ERROR_NOT_SDDBFILE                  : Str := 'N:Opened file is not SDP-DB file or it can''t support(with old version)';
    TOSBTAPI_ERROR_RECORD_HANDLE                 : Str := 'Invalied specify service record handle';
    TOSBTAPI_ERROR_SEARCH_PATTERN                : Str := 'Invalied specify search pattern data';
    TOSBTAPI_ERROR_SERVICE_RECORD                : Str := 'Invalied service record data into SDP-DB(possibility to be broken)';
    TOSBTAPI_ERROR_ATTRIBUTE_LIST                : Str := 'Invalied specify attribute list data';
    TOSBTAPI_ERROR_ATTRIBUTE_ID_LIST             : Str := 'Invalied specify attribute ID list data';
    TOSBTAPI_ERROR_SDDB_MAINTENANCE              : Str := 'SDP-DB can not maintenance';
    TOSBTAPI_ERROR_REGISTRY_ACCESS               : Str := 'N:Registry access error';
    TOSBTAPI_ERROR_SERVICENOTRUNNING             : Str := 'TosBtMng.exe not running';
    TOSBTAPI_ERROR_CREATEWINDOW                  : Str := 'The creating of a window for the message reception from TosBtSDP.exe failure';
    TOSBTAPI_ERROR_ATTRLIST_ANALYZE              : Str := 'AttributeList(s) analyze failure';
    TOSBTAPI_ERROR_CALLINGSEQUENCE               : Str := 'Application Window disable';
    TOSBTAPI_ERROR_SERVICENOTREADY               : Str := 'TosBtMng.exe not ready';
    TOSBTAPI_ERROR_EXECBTMNG                     : Str := 'can not execute TosBtMng.exe';

  else
    Str := '';
  end;

  if Str <> '' then begin
    Str := 'TOSHIBA ERROR: ' + IntToStr(Status) + CRLF + Str;
    raise Exception.Create(Str);
  end;
end;

function TBFAPI.StringToBluetoothAddress(Address: string): TBluetoothAddress;
var
  Tmp: string;
begin
  Address := Copy(Address, 2, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[5] := StrToInt(Tmp);
  Address := Copy(Address, 4, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[4] := StrToInt(Tmp);
  Address := Copy(Address, 4, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[3] := StrToInt(Tmp);
  Address := Copy(Address, 4, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[2] := StrToInt(Tmp);
  Address := Copy(Address, 4, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[1] := StrToInt(Tmp);
  Address := Copy(Address, 4, Length(Address));
  Tmp := '$' + Copy(Address, 1, 2);
  Result[0] := StrToInt(Tmp);
end;

function TBFAPI.StringToIrDAAddress(Address: string): IRDA_ADDR;
begin
  Result[3] := Char(StrToInt('$' + Address[2] + Address[3]));
  Result[2] := Char(StrToInt('$' + Address[5] + Address[6]));
  Result[1] := Char(StrToInt('$' + Address[8] + Address[9]));
  Result[0] := Char(StrToInt('$' + Address[11] + Address[12]));
end;

function TBFAPI.StringToUUID(Name: string): TGUID;
var
  Loop: Integer;
begin
  Result := GUID_NULL;

  for Loop := 0 to UUID_STRINGS_COUNT - 1 do
    if UUID_STRINGS_ARRAY[Loop].Name = Name then begin
      Result := UUID_STRINGS_ARRAY[Loop].UUID;
      Break;
    end;
end;

function TBFAPI.ReverseToshibaBTAddress(BTAddress: TBluetoothAddress): TBluetoothAddress;
var
  Ndx: Byte;
begin
  for Ndx := 0 to 5 do Result[Ndx] := BTAddress[5 - Ndx];
end;

function TBFAPI.TransportTagToName(ATag: TBFAPITransport): string;
begin
  case ATag of
    atBluetooth: Result := StrBluetooth;
    atIrDA: Result := StrIrDA;
    atCOM: Result := StrCOM;
  end;
end;

function TBFAPI.UUID16ToUUID(UUID16: Word): TGUID;
begin
  Result := BaseBluetoothServiceClassID_UUID;
  Result.D1 := UUID16;
end;

function TBFAPI.UUIDToString(UUID: TGUID): string;
var
  Loop: Integer;
begin
  Result := StrUnknown;
  for Loop := 0 to UUID_STRINGS_COUNT - 1 do
    if CompareMem(@UUID_STRINGS_ARRAY[Loop].UUID, @UUID, SizeOf(TGUID)) then begin
      Result := UUID_STRINGS_ARRAY[Loop].Name;
      Break;
    end;
end;

function TBFAPI.UUIDToUUID16(UUID: TGUID): Word;
begin
  Result := LoWord(UUID.D1);
end;

procedure TBFAPI.WndProc(var Message: TMessage);
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

function TBFAPI.UUIDToBtUUID(GUID: TGUID): BTUUID;
var
  Str: string;
  Ndx: Byte;
  Pos: Byte;
  AByte: string;
begin
  Str := GUIDToString(GUID);
  Ndx := 2;
  Pos := 0;
  while Ndx < Length(Str) - 1 do
    if Str[Ndx] = '-' then
      Inc(Ndx)

    else begin
      AByte := '$' + Str[Ndx] + Str[Ndx + 1];
      Inc(Ndx, 2);
      Result[Pos] := StrToInt(AByte);
      Inc(Pos);
    end;
end;

procedure TBFAPI.LoadAPIs;
const
  START_DELAY = 5;
  COMMON_API_NAME = 'BluetoothFrameworkCommonAPI';

var
  Data: WSADATA;
  Find: HBLUETOOTH_RADIO_FIND;
  FindParams: BLUETOOTH_FIND_RADIO_PARAMS;
  HRadio: THandle;
  ASocket: TSocket;
  DeviceListBuffer: array [0..SizeOf(DEVICELIST) - SizeOf(IRDA_DEVICE_INFO) + (SizeOf(IRDA_DEVICE_INFO) * DEVICE_LIST_LEN)] of Byte;
  DeviceListSize: Integer;
  DeviceList: PDEVICELIST;
  Status: Long;
  DevInfo: BTLOCALDEVINFO2;
  RAPIInit: Boolean;
begin
  FBSLibrary := 0;
  FTosLibrary := 0;
  FWDLibrary := 0;
  FWSLibrary := 0;
  FRAPILibrary := 0;

  // By default not supports Bluetooth until we do not check it.
  FBluetoothAPIs := [];
  // Always supports COM ports.
  FTransports := [atCOM];

  // Firstly initialize WinSock subsystem.
  FillChar(Data, SizeOf(WSADATA), 0);
  FWinSockInitialized := (WSAStartup($0202, Data) = 0);
  // If WinSock 2.2 available then WinSock supports Bluetooth.
  FWinSockBluetooth := FWinSockInitialized;

  // Check WinSock version 1.1 for IrDA supports.
  if not FWinSockInitialized then begin
    FillChar(Data, SizeOf(WSADATA), 0);
    FWinSockInitialized := (WSAStartup($0101, Data) = 0);
  end;

  // If WinSock initialized then we supports IrDA.
  if FWinSockInitialized then begin
    // Trying to create IrDA socket.
    ASocket := socket(AF_IRDA, SOCK_STREAM, 0);
    FWinSockIrDA := ASocket <> INVALID_SOCKET;

    if FWinSockIrDA then begin
      // Preparing fo discovery.
      DeviceListSize := SizeOf(DeviceListBuffer);
      DeviceList := PDEVICELIST(@DeviceListBuffer);
      DeviceList^.numDevice := 0;

      // Discovery devices.
      FWinSockIrDA := getsockopt(ASocket, SOL_IRLMP, IRLMP_ENUMDEVICES, PChar(DeviceList), DeviceListSize) <> SOCKET_ERROR;

      // Close socket.
      closesocket(ASocket);
    end;

  end else
    FWinSockIrDA := False;

  if FWinSockIrDA then FTransports := FTransports + [atIrDA];

  FRAPILibrary := LoadLibrary('RAPI.DLL');
  if FRAPILibrary <> 0 then begin
    CeRapiInit := GetProcAddress(FRAPILibrary, 'CeRapiInit');
    CeRapiUnInit := GetProcAddress(FRAPILibrary, 'CeRapiUninit');
    CeFindAllFiles := GetProcAddress(FRAPILibrary, 'CeFindAllFiles');
    CeRapiFreeBuffer := GetProcAddress(FRAPILibrary, 'CeRapiFreeBuffer');
    CeRapiInitEx := GetProcAddress(FRAPILibrary, 'CeRapiInitEx');
    CeCreateDatabase := GetProcAddress(FRAPILibrary, 'CeCreateDatabase');
    CeDeleteDatabase := GetProcAddress(FRAPILibrary, 'CeDeleteDatabase');
    CeDeleteRecord := GetProcAddress(FRAPILibrary, 'CeDeleteRecord');
    CeFindFirstDatabase := GetProcAddress(FRAPILibrary, 'CeFindFirstDatabase');
    CeFindNextDatabase := GetProcAddress(FRAPILibrary, 'CeFindNextDatabase');
    CeOidGetInfo := GetProcAddress(FRAPILibrary, 'CeOidGetInfo');
    CeOpenDatabase := GetProcAddress(FRAPILibrary, 'CeOpenDatabase');
    CeReadRecordProps := GetProcAddress(FRAPILibrary, 'CeReadRecordProps');
    CeSeekDatabase := GetProcAddress(FRAPILibrary, 'CeSeekDatabase');
    CeSetDatabaseInfo := GetProcAddress(FRAPILibrary, 'CeSetDatabaseInfo');
    CeWriteRecordProps := GetProcAddress(FRAPILibrary, 'CeWriteRecordProps');
    CeFindFirstFile := GetProcAddress(FRAPILibrary, 'CeFindFirstFile');
    CeFindNextFile := GetProcAddress(FRAPILibrary, 'CeFindNextFile');
    CeFindClose := GetProcAddress(FRAPILibrary, 'CeFindClose');
    CeGetFileAttributes := GetProcAddress(FRAPILibrary, 'CeGetFileAttributes');
    CeSetFileAttributes := GetProcAddress(FRAPILibrary, 'CeSetFileAttributes');
    CeCreateFile := GetProcAddress(FRAPILibrary, 'CeCreateFile');
    CeReadFile := GetProcAddress(FRAPILibrary, 'CeReadFile');
    CeWriteFile := GetProcAddress(FRAPILibrary, 'CeWriteFile');
    CeCloseHandle := GetProcAddress(FRAPILibrary, 'CeCloseHandle');
    CeFindAllDatabases := GetProcAddress(FRAPILibrary, 'CeFindAllDatabases');
    CeGetLastError := GetProcAddress(FRAPILibrary, 'CeGetLastError');
    GetRapiError := GetProcAddress(FRAPILibrary, 'GetRapiError');
    CeSetFilePointer := GetProcAddress(FRAPILibrary, 'CeSetFilePointer');
    CeSetEndOfFile := GetProcAddress(FRAPILibrary, 'CeSetEndOfFile');
    CeCreateDirectory := GetProcAddress(FRAPILibrary, 'CeCreateDirectory');
    CeRemoveDirectory := GetProcAddress(FRAPILibrary, 'CeRemoveDirectory');
    CeCreateProcess := GetProcAddress(FRAPILibrary, 'CeCreateProcess');
    CeMoveFile := GetProcAddress(FRAPILibrary, 'CeMoveFile');
    CeCopyFile := GetProcAddress(FRAPILibrary, 'CeCopyFile');
    CeDeleteFile := GetProcAddress(FRAPILibrary, 'CeDeleteFile');
    CeGetFileSize := GetProcAddress(FRAPILibrary, 'CeGetFileSize');
    CeRegOpenKeyEx := GetProcAddress(FRAPILibrary, 'CeRegOpenKeyEx');
    CeRegEnumKeyEx := GetProcAddress(FRAPILibrary, 'CeRegEnumKeyEx');
    CeRegCreateKeyEx := GetProcAddress(FRAPILibrary, 'CeRegCreateKeyEx');
    CeRegCloseKey := GetProcAddress(FRAPILibrary, 'CeRegCloseKey');
    CeRegDeleteKey := GetProcAddress(FRAPILibrary, 'CeRegDeleteKey');
    CeRegEnumValue := GetProcAddress(FRAPILibrary, 'CeRegEnumValue');
    CeRegDeleteValue := GetProcAddress(FRAPILibrary, 'CeRegDeleteValue');
    CeRegQueryInfoKey := GetProcAddress(FRAPILibrary, 'CeRegQueryInfoKey');
    CeRegQueryValueEx := GetProcAddress(FRAPILibrary, 'CeRegQueryValueEx');
    CeRegSetValueEx := GetProcAddress(FRAPILibrary, 'CeRegSetValueEx');
    CeGetStoreInformation := GetProcAddress(FRAPILibrary, 'CeGetStoreInformation');
    CeGetSystemMetrics := GetProcAddress(FRAPILibrary, 'CeGetSystemMetrics');
    CeGetDesktopDeviceCaps := GetProcAddress(FRAPILibrary, 'CeGetDesktopDeviceCaps');
    CeGetSystemInfo := GetProcAddress(FRAPILibrary, 'CeGetSystemInfo');
    CeSHCreateShortcut := GetProcAddress(FRAPILibrary, 'CeSHCreateShortcut');
    CeSHGetShortcutTarget := GetProcAddress(FRAPILibrary, 'CeSHGetShortcutTarget');
    CeCheckPassword := GetProcAddress(FRAPILibrary, 'CeCheckPassword');
    CeGetFileTime := GetProcAddress(FRAPILibrary, 'CeGetFileTime');
    CeSetFileTime := GetProcAddress(FRAPILibrary, 'CeSetFileTime');
    CeGetVersionEx := GetProcAddress(FRAPILibrary, 'CeGetVersionEx');
    CeGetWindow := GetProcAddress(FRAPILibrary, 'CeGetWindow');
    CeGetWindowLong := GetProcAddress(FRAPILibrary, 'CeGetWindowLong');
    CeGetWindowText := GetProcAddress(FRAPILibrary, 'CeGetWindowText');
    CeGetClassName := GetProcAddress(FRAPILibrary, 'CeGetClassName');
    CeGlobalMemoryStatus := GetProcAddress(FRAPILibrary, 'CeGlobalMemoryStatus');
    CeGetSystemPowerStatusEx := GetProcAddress(FRAPILibrary, 'CeGetSystemPowerStatusEx');

    RAPIInit := Assigned(CeRapiInit) and Assigned(CeRapiUnInit) and Assigned(CeFindAllFiles) and
                Assigned(CeRapiFreeBuffer) and Assigned(CeRapiInitEx) and Assigned(CeCreateDatabase) and
                Assigned(CeDeleteDatabase) and Assigned(CeDeleteRecord) and Assigned(CeFindFirstDatabase) and
                Assigned(CeFindNextDatabase) and Assigned(CeOidGetInfo) and Assigned(CeOpenDatabase) and
                Assigned(CeReadRecordProps) and Assigned(CeSeekDatabase) and Assigned(CeSetDatabaseInfo) and
                Assigned(CeWriteRecordProps) and Assigned(CeFindFirstFile) and Assigned(CeFindNextFile) and
                Assigned(CeFindClose) and Assigned(CeGetFileAttributes) and Assigned(CeSetFileAttributes) and
                Assigned(CeCreateFile) and Assigned(CeReadFile) and Assigned(CeWriteFile) and
                Assigned(CeCloseHandle) and Assigned(CeFindAllDatabases) and Assigned(CeGetLastError) and
                Assigned(GetRapiError) and Assigned(CeSetFilePointer) and Assigned(CeSetEndOfFile) and
                Assigned(CeCreateDirectory) and Assigned(CeRemoveDirectory) and Assigned(CeCreateProcess) and
                Assigned(CeMoveFile) and Assigned(CeCopyFile) and Assigned(CeDeleteFile) and
                Assigned(CeGetFileSize) and Assigned(CeRegOpenKeyEx) and Assigned(CeRegEnumKeyEx) and
                Assigned(CeRegCreateKeyEx) and Assigned(CeRegCloseKey) and Assigned(CeRegDeleteKey) and
                Assigned(CeRegEnumValue) and Assigned(CeRegDeleteValue) and Assigned(CeRegQueryInfoKey) and
                Assigned(CeRegQueryValueEx) and Assigned(CeRegSetValueEx) and Assigned(CeGetStoreInformation) and
                Assigned(CeGetSystemMetrics) and Assigned(CeGetDesktopDeviceCaps) and Assigned(CeGetSystemInfo) and
                Assigned(CeSHCreateShortcut) and Assigned(CeSHGetShortcutTarget) and Assigned(CeCheckPassword) and
                Assigned(CeGetFileTime) and Assigned(CeSetFileTime) and Assigned(CeGetVersionEx) and
                Assigned(CeGetWindow) and Assigned(CeGetWindowLong) and Assigned(CeGetWindowText) and
                Assigned(CeGetClassName) and Assigned(CeGlobalMemoryStatus) and Assigned(CeGetSystemPowerStatusEx);

    if not RAPIInit then begin
      FreeLibrary(FRAPILibrary);
      FRAPILibrary := 0;

      CeRapiInit := nil;
      CeRapiUnInit := nil;
      CeFindAllFiles := nil;
      CeRapiFreeBuffer := nil;
      CeRapiInitEx := nil;
      CeCreateDatabase := nil;
      CeDeleteDatabase := nil;
      CeDeleteRecord := nil;
      CeFindFirstDatabase := nil;
      CeFindNextDatabase := nil;
      CeOidGetInfo := nil;
      CeOpenDatabase := nil;
      CeReadRecordProps := nil;
      CeSeekDatabase := nil;
      CeSetDatabaseInfo := nil;
      CeWriteRecordProps := nil;
      CeFindFirstFile := nil;
      CeFindNextFile := nil;
      CeFindClose := nil;
      CeGetFileAttributes := nil;
      CeSetFileAttributes := nil;
      CeCreateFile := nil;
      CeReadFile := nil;
      CeWriteFile := nil;
      CeCloseHandle := nil;
      CeFindAllDatabases := nil;
      CeGetLastError := nil;
      GetRapiError := nil;
      CeSetFilePointer := nil;
      CeSetEndOfFile := nil;
      CeCreateDirectory := nil;
      CeRemoveDirectory := nil;
      CeCreateProcess := nil;
      CeMoveFile := nil;
      CeCopyFile := nil;
      CeDeleteFile := nil;
      CeGetFileSize := nil;
      CeRegOpenKeyEx := nil;
      CeRegEnumKeyEx := nil;
      CeRegCreateKeyEx := nil;
      CeRegCloseKey := nil;
      CeRegDeleteKey := nil;
      CeRegEnumValue := nil;
      CeRegDeleteValue := nil;
      CeRegQueryInfoKey := nil;
      CeRegQueryValueEx := nil;
      CeRegSetValueEx := nil;
      CeGetStoreInformation := nil;
      CeGetSystemMetrics := nil;
      CeGetDesktopDeviceCaps := nil;
      CeGetSystemInfo := nil;
      CeSHCreateShortcut := nil;
      CeSHGetShortcutTarget := nil;
      CeCheckPassword := nil;
      CeGetFileTime := nil;
      CeSetFileTime := nil;
      CeGetVersionEx := nil;
      CeGetWindow := nil;
      CeGetWindowLong := nil;
      CeGetWindowText := nil;
      CeGetClassName := nil;
      CeGlobalMemoryStatus := nil;
      CeGetSystemPowerStatusEx := nil;
    end;
  end;

  // Now we must check which Bluetooth API available.
  // Firstly check BlueSoleil API.
  FBSLibrary := LoadLibrary('btfunc.dll');
  if FBSLibrary <> 0 then begin
    // BlueSoleil API library presents in the system. Try initialize that API.
    BT_InitializeLibrary := GetProcAddress(FBSLibrary, 'BT_InitializeLibrary');
    BT_IsBlueSoleilStarted := GetProcAddress(FBSLibrary, 'BT_IsBlueSoleilStarted');
    BT_StartBluetooth := GetProcAddress(FBSLibrary, 'BT_StartBluetooth');
    BT_IsBluetoothReady := GetProcAddress(FBSLibrary, 'BT_IsBluetoothReady');
    BT_UninitializeLibrary := GetProcAddress(FBSLibrary, 'BT_UninitializeLibrary');
    BT_InquireDevices := GetProcAddress(FBSLibrary, 'BT_InquireDevices');
    BT_GetRemoteDeviceInfo := GetProcAddress(FBSLibrary, 'BT_GetRemoteDeviceInfo');
    BT_BrowseServices := GetProcAddress(FBSLibrary, 'BT_BrowseServices');
    BT_GetLocalDeviceInfo := GetProcAddress(FBSLibrary, 'BT_GetLocalDeviceInfo');
    BT_SetLocalDeviceInfo := GetProcAddress(FBSLibrary, 'BT_SetLocalDeviceInfo');
    BT_DisconnectSPPExService := GetProcAddress(FBSLibrary, 'BT_DisconnectSPPExService');
    BT_ConnectSPPExService := GetProcAddress(FBSLibrary, 'BT_ConnectSPPExService');
    BT_PairDevice := GetProcAddress(FBSLibrary, 'BT_PairDevice');
    BT_StartSPPExService := GetProcAddress(FBSLibrary, 'BT_StartSPPExService');
    BT_StopSPPExService := GetProcAddress(FBSLibrary, 'BT_StopSPPExService');
    BT_RegisterCallback := GetProcAddress(FBSLibrary, 'BT_RegisterCallback');
    BT_UnregisterCallback := GetProcAddress(FBSLibrary, 'BT_UnregisterCallback');
    BT_UnpairDevice := GetProcAddress(FBSLibrary, 'BT_UnpairDevice');
    BT_SearchSPPExServices := GetProcAddress(FBSLibrary, 'BT_SearchSPPExServices');
    BT_ConnectService := GetProcAddress(FBSLibrary, 'BT_ConnectService');
    BT_DisconnectService := GetProcAddress(FBSLibrary, 'BT_DisconnectService');
    BT_SetRemoteDeviceInfo := GetProcAddress(FBSLibrary, 'BT_SetRemoteDeviceInfo');
    BT_GetVersion := GetProcAddress(FBSLibrary, 'BT_GetVersion');

    if Assigned(BT_InitializeLibrary) and Assigned(BT_IsBlueSoleilStarted) and
       Assigned(BT_StartBluetooth) and Assigned(BT_IsBluetoothReady) and
       Assigned(BT_UninitializeLibrary) and Assigned(BT_InquireDevices) and
       Assigned(BT_GetRemoteDeviceInfo) and Assigned(BT_BrowseServices) and
       Assigned(BT_GetLocalDeviceInfo) and Assigned(BT_SetLocalDeviceInfo) and
       Assigned(BT_DisconnectSPPExService) and Assigned(BT_ConnectSPPExService) and
       Assigned(BT_StartSPPExService) and Assigned(BT_StopSPPExService) and
       Assigned(BT_RegisterCallback) and Assigned(BT_UnregisterCallback) and
       Assigned(BT_PairDevice) and Assigned(BT_UnpairDevice) and Assigned(BT_SearchSPPExServices) and
       Assigned(BT_ConnectService) and Assigned(BT_DisconnectService) and Assigned(BT_SetRemoteDeviceInfo) and
       Assigned(BT_GetVersion) then
      // The BlueSoleil library exports minimal functions set.
      // Now try initializa subsystem.
      if BT_InitializeLibrary then begin
        if not BT_IsBlueSoleilStarted(START_DELAY) then BT_StartBluetooth;
        if BT_IsBluetoothReady(START_DELAY) then FBluetoothAPIs := FBluetoothAPIs + [baBlueSoleil];
        if not (baBlueSoleil in FBluetoothAPIs) then BT_UninitializeLibrary;
      end;
  end;

  // Try to load wbtapi.dll
  FWDLibrary := LoadLibrary('wbtapi.dll');
  if (FWDLibrary <> 0) then begin
    // Immediate unload it.
    FreeLibrary(FWDLibrary);

    // Then try our stub
    FWDLibrary := LoadLibrary('bftowdthunk.dll');

    // If OK then import functions.
    if FWDLibrary <> 0 then begin
      WD_IsDeviceReady := GetProcAddress(FWDLibrary, 'WD_IsDeviceReady');
      WD_IsStackServerUp := GetProcAddress(FWDLibrary, 'WD_IsStackServerUp');
      WD_GetLocalDeviceVersionInfo := GetProcAddress(FWDLibrary, 'WD_GetLocalDeviceVersionInfo');
      WD_GetLocalDeviceName := GetProcAddress(FWDLibrary, 'WD_GetLocalDeviceName');
      WD_SetLocalDeviceName := GetProcAddress(FWDLibrary, 'WD_SetLocalDeviceName');
      WD_Inquiry := GetProcAddress(FWDLibrary, 'WD_Inquiry');
      WD_Discovery := GetProcAddress(FWDLibrary, 'WD_Discovery');
      WD_CreateCOMPortAssociation := GetProcAddress(FWDLibrary, 'WD_CreateCOMPortAssociation');
      WD_RemoveCOMPortAssociation := GetProcAddress(FWDLibrary, 'WD_RemoveCOMPortAssociation');
      WD_Bond := GetProcAddress(FWDLibrary, 'WD_Bond');
      WD_BondQuery := GetProcAddress(FWDLibrary, 'WD_BondQuery');
      WD_OpenServer := GetProcAddress(FWDLibrary, 'WD_OpenServer');
      WD_CloseServer := GetProcAddress(FWDLibrary, 'WD_CloseServer');
      WD_Write := GetProcAddress(FWDLibrary, 'WD_Write');
      WD_UnBond := GetProcAddress(FWDLibrary, 'WD_UnBond');
      WD_IsRemoteDeviceConnected := GetProcAddress(FWDLibrary, 'WD_IsRemoteDeviceConnected');
      WD_InitDLL := GetProcAddress(FWDLibrary, 'WD_InitDLL');
      WD_FreeDLL := GetProcAddress(FWDLibrary, 'WD_FreeDLL');
      WD_GetRemoteAddr := GetProcAddress(FWDLibrary, 'WD_GetRemoteAddr');
      WD_GetConnectionStats := GetProcAddress(FWDLibrary, 'WD_GetConnectionStats');
      WD_GetVersion := GetProcAddress(FWDLibrary, 'WD_GetVersion');

      if Assigned(WD_IsDeviceReady) and Assigned(WD_IsStackServerUp) and
         Assigned(WD_GetLocalDeviceVersionInfo) and Assigned(WD_GetLocalDeviceName) and
         Assigned(WD_SetLocalDeviceName) and Assigned(WD_Inquiry) and
         Assigned(WD_Discovery) and Assigned(WD_CreateCOMPortAssociation) and
         Assigned(WD_RemoveCOMPortAssociation) and Assigned(WD_Bond) and
         Assigned(WD_OpenServer) and Assigned(WD_CloseServer) and
         Assigned(WD_BondQuery) and Assigned(WD_Write) and
         Assigned(WD_UnBond) and Assigned(WD_IsRemoteDeviceConnected) and
         Assigned(WD_InitDLL) and Assigned(WD_FreeDLL) and
         Assigned(WD_GetRemoteAddr) and Assigned(WD_GetConnectionStats) and
         Assigned(WD_GetVersion) then begin
        WD_InitDLL;

        if WD_IsStackServerUp then
          {$IFNDEF ACTIVEX}
          if WD_IsDeviceReady then
          {$ENDIF}
            FBluetoothAPIs := FBluetoothAPIs + [baWidComm];

        if not (baWidComm in FBluetoothAPIs) then WD_FreeDLL;
      end;
    end;
  end;

  FTosLibrary := LoadLibrary('TosBtAPI.dll');
  if FTosLibrary <> 0 then begin
    BtOpenAPI := GetProcAddress(FTosLibrary, 'BtOpenAPI');
    BtCloseAPI := GetProcAddress(FTosLibrary, 'BtCloseAPI');
    BtExecBtMng := GetProcAddress(FTosLibrary, 'BtExecBtMng');
    BtGetLocalInfo2 := GetProcAddress(FTosLibrary, 'BtGetLocalInfo2');
    BtSetLocalDeviceName := GetProcAddress(FTosLibrary, 'BtSetLocalDeviceName');
    BtGetLocalDeviceName := GetProcAddress(FTosLibrary, 'BtGetLocalDeviceName');
    BtGetClassOfDevice := GetProcAddress(FTosLibrary, 'BtGetClassOfDevice');
    BtGetDiscoverabilityMode := GetProcAddress(FTosLibrary, 'BtGetDiscoverabilityMode');
    BtGetConnectabilityMode := GetProcAddress(FTosLibrary, 'BtGetConnectabilityMode');
    BtDiscoverRemoteDevice2 := GetProcAddress(FTosLibrary, 'BtDiscoverRemoteDevice2');
    BtMemFree := GetProcAddress(FTosLibrary, 'BtMemFree');
    BtGetRemoteDeviceList2 := GetProcAddress(FTosLibrary, 'BtGetRemoteDeviceList2');
    BtRemoveRemoteDevice := GetProcAddress(FTosLibrary, 'BtRemoveRemoteDevice');
    BtConnectSDP := GetProcAddress(FTosLibrary, 'BtConnectSDP');
    BtDisconnectSDP := GetProcAddress(FTosLibrary, 'BtDisconnectSDP');
    BtMakeServiceSearchPattern2 := GetProcAddress(FTosLibrary, 'BtMakeServiceSearchPattern2');
    BtServiceSearchAttribute2 := GetProcAddress(FTosLibrary, 'BtServiceSearchAttribute2');
    BtMakeAttributeIDList2 := GetProcAddress(FTosLibrary, 'BtMakeAttributeIDList2');
    BtAnalyzeServiceAttributeLists2 := GetProcAddress(FTosLibrary, 'BtAnalyzeServiceAttributeLists2');
    BtFreePBTANALYZEDATTRLIST2 := GetProcAddress(FTosLibrary, 'BtFreePBTANALYZEDATTRLIST2');
    BtAnalyzeProtocolParameter2 := GetProcAddress(FTosLibrary, 'BtAnalyzeProtocolParameter2');
    BtServiceSearchAttributeSDDB2 := GetProcAddress(FTosLibrary, 'BtServiceSearchAttributeSDDB2');
    BtRefreshSDDB2 := GetProcAddress(FTosLibrary, 'BtRefreshSDDB2');
    BtCreateCOMM := GetProcAddress(FTosLibrary, 'BtCreateCOMM');
    BtDestroyCOMM := GetProcAddress(FTosLibrary, 'BtDestroyCOMM');
    BtConnectCOMM2 := GetProcAddress(FTosLibrary, 'BtConnectCOMM2');
    BtDisconnectCOMM := GetProcAddress(FTosLibrary, 'BtDisconnectCOMM');
    BtGetConnectionHandle := GetProcAddress(FTosLibrary, 'BtGetConnectionHandle');
    BtGetLinkQuality := GetProcAddress(FTosLibrary, 'BtGetLinkQuality');
    BtAssignSCN := GetProcAddress(FTosLibrary, 'BtAssignSCN');
    BtFreeSCN := GetProcAddress(FTosLibrary, 'BtFreeSCN');
    BtGetCOMMInfoList2 := GetProcAddress(FTosLibrary, 'BtGetCOMMInfoList2');
    BtMemAlloc := GetProcAddress(FTosLibrary, 'BtMemAlloc');

    if Assigned(BtOpenAPI) and Assigned(BtCloseAPI) and Assigned(BtExecBtMng) and
       Assigned(BtGetLocalInfo2) and Assigned(BtSetLocalDeviceName) and Assigned(BtGetLocalDeviceName) and
       Assigned(BtGetClassOfDevice) and Assigned(BtGetDiscoverabilityMode) and Assigned(BtGetConnectabilityMode) and
       Assigned(BtDiscoverRemoteDevice2) and Assigned(BtMemFree) and Assigned(BtGetRemoteDeviceList2) and
       Assigned(BtRemoveRemoteDevice) and Assigned(BtConnectSDP) and Assigned(BtDisconnectSDP) and
       Assigned(BtMakeServiceSearchPattern2) and Assigned(BtServiceSearchAttribute2) and Assigned(BtMakeAttributeIDList2) and
       Assigned(BtAnalyzeServiceAttributeLists2) and Assigned(BtFreePBTANALYZEDATTRLIST2) and Assigned(BtAnalyzeProtocolParameter2) and
       Assigned(BtServiceSearchAttributeSDDB2) and Assigned(BtRefreshSDDB2) and Assigned(BtCreateCOMM) and
       Assigned(BtDestroyCOMM) and Assigned(BtConnectCOMM2) and Assigned(BtDisconnectCOMM) and
       Assigned(BtGetConnectionHandle) and Assigned(BtGetLinkQuality) and Assigned(BtAssignSCN) and
       Assigned(BtFreeSCN) and Assigned(BtGetCOMMInfoList2) and Assigned(BtMemAlloc) then
      if BtOpenAPI(FWnd, PChar('Bluetooth Framework' + IntToHex(GetCurrentThreadId, 8)), Status) then begin
        if BtExecBtMng(Status) then begin
          FillChar(DevInfo, SizeOf(BTLOCALDEVINFO2), 0);

          if BtGetLocalInfo2(@DevInfo, Status) then FBluetoothAPIs := FBluetoothAPIs + [baToshiba];
        end;

        if not (baToshiba in FBluetoothAPIs) then BtCloseAPI(Status);
      end;
  end;

  // If Previouse APIs not initialized and WinSock supports Bluetooth
  // then try initialize Microsoft Bluetooth stack.
  FWSLibrary := LoadLibrary('irprops.cpl');
  // Try load bthprops.cpl becouse Windows 2003 not supports irprops.cpl
  if FWSLibrary = 0 then FWSLibrary := LoadLibrary('bthprops.cpl');
  // Library presents in the system and succesfully loaded. So we can try
  // checking Bluetooth functions.
  if FWSLibrary <> 0 then begin
    BluetoothFindFirstRadio := GetProcAddress(FWSLibrary, 'BluetoothFindFirstRadio');
    BluetoothFindNextRadio := GetProcAddress(FWSLibrary, 'BluetoothFindNextRadio');
    BluetoothFindRadioClose := GetProcAddress(FWSLibrary, 'BluetoothFindRadioClose');
    BluetoothGetDeviceInfo := GetProcAddress(FWSLibrary, 'BluetoothGetDeviceInfo');
    BluetoothGetRadioInfo := GetProcAddress(FWSLibrary, 'BluetoothGetRadioInfo');
    BluetoothRegisterForAuthentication := GetProcAddress(FWSLibrary, 'BluetoothRegisterForAuthentication');
    BluetoothUnregisterAuthentication := GetProcAddress(FWSLibrary, 'BluetoothUnregisterAuthentication');
    BluetoothSendAuthenticationResponse := GetProcAddress(FWSLibrary, 'BluetoothSendAuthenticationResponse');
    BluetoothRemoveDevice := GetProcAddress(FWSLibrary, 'BluetoothRemoveDevice');
    BluetoothSetServiceState := GetProcAddress(FWSLibrary, 'BluetoothSetServiceState');
    BluetoothUpdateDeviceRecord := GetProcAddress(FWSLibrary, 'BluetoothUpdateDeviceRecord');
    BluetoothAuthenticateDevice := GetProcAddress(FWSLibrary, 'BluetoothAuthenticateDevice');
    BluetoothSdpGetAttributeValue := GetProcAddress(FWSLibrary, 'BluetoothSdpGetAttributeValue');
    BluetoothIsDiscoverable := GetProcAddress(FWSLibrary, 'BluetoothIsDiscoverable');
    BluetoothIsConnectable := GetProcAddress(FWSLibrary, 'BluetoothIsConnectable');
    BluetoothEnableDiscovery := GetProcAddress(FWSLibrary, 'BluetoothEnableDiscovery');
    BluetoothEnableIncomingConnections := GetProcAddress(FWSLibrary, 'BluetoothEnableIncomingConnections');

    if Assigned(BluetoothFindFirstRadio) and Assigned(BluetoothFindNextRadio) and
       Assigned(BluetoothFindRadioClose) and Assigned(BluetoothGetDeviceInfo) and
       Assigned(BluetoothGetRadioInfo) and Assigned(BluetoothRegisterForAuthentication) and
       Assigned(BluetoothUnregisterAuthentication) and Assigned(BluetoothSendAuthenticationResponse) and
       Assigned(BluetoothRemoveDevice) and Assigned(BluetoothSetServiceState) and
       Assigned(BluetoothUpdateDeviceRecord) and Assigned(BluetoothAuthenticateDevice) and
       Assigned(BluetoothSdpGetAttributeValue) and Assigned(BluetoothIsDiscoverable) and
       Assigned(BluetoothIsConnectable) and Assigned(BluetoothEnableDiscovery) and
       Assigned(BluetoothEnableIncomingConnections)  then begin
      FindParams.dwSize := SizeOf(BLUETOOTH_FIND_RADIO_PARAMS);

      Find := BluetoothFindFirstRadio(@FindParams, HRadio);
      if Find <> 0 then begin
        // Radio Present
        FBluetoothAPIs := FBluetoothAPIs + [baWinSock];
        CloseHandle(HRadio);
        BluetoothFindRadioClose(Find);
      end;
    end;
  end;

  // If some API initialized then we support Bluetooths.
  if (FBluetoothAPIs <> []) then FTransports := FTransports + [atBluetooth];

  // Also clean all function pointers. It must helps us to check when we make
  // mistake in coding.
  if not (baBlueSoleil in FBluetoothAPIs) then begin
    BT_InitializeLibrary := nil;
    BT_UninitializeLibrary := nil;
    BT_IsBlueSoleilStarted := nil;
    BT_IsBluetoothReady := nil;
    BT_StartBluetooth := nil;
    BT_InquireDevices := nil;
    BT_GetRemoteDeviceInfo := nil;
    BT_BrowseServices := nil;
    BT_GetLocalDeviceInfo := nil;
    BT_SetLocalDeviceInfo := nil;
    BT_DisconnectSPPExService := nil;
    BT_ConnectSPPExService := nil;
    BT_PairDevice := nil;
    BT_StartSPPExService := nil;
    BT_StopSPPExService := nil;
    BT_RegisterCallback := nil;
    BT_UnregisterCallback := nil;
    BT_UnpairDevice := nil;
    BT_SearchSPPExServices := nil;
    BT_ConnectService := nil;
    BT_DisconnectService := nil;
    BT_SetRemoteDeviceInfo := nil;
    BT_GetVersion := nil;

    if FBSLibrary <> 0 then begin
      FreeLibrary(FBSLibrary);
      FBSLibrary := 0;
    end;
  end;

  if not (baWidComm in FBluetoothAPIs) then begin
    WD_IsDeviceReady := nil;
    WD_IsStackServerUp := nil;
    WD_GetLocalDeviceVersionInfo := nil;
    WD_GetLocalDeviceName := nil;
    WD_SetLocalDeviceName := nil;
    WD_Inquiry := nil;
    WD_Discovery := nil;
    WD_CreateCOMPortAssociation := nil;
    WD_RemoveCOMPortAssociation := nil;
    WD_Bond := nil;
    WD_BondQuery := nil;
    WD_OpenServer := nil;
    WD_CloseServer := nil;
    WD_Write := nil;
    WD_UnBond := nil;
    WD_IsRemoteDeviceConnected := nil;
    WD_GetRemoteAddr := nil;
    WD_GetConnectionStats := nil;
    WD_GetVersion := nil;

    if FWDLibrary <> 0 then begin
      FreeLibrary(FWDLibrary);
      FWDLibrary := 0;
    end;
  end;

  if not (baToshiba in FBluetoothAPIs) then begin
    BtOpenAPI := nil;
    BtCloseAPI := nil;
    BtExecBtMng := nil;
    BtGetLocalInfo2 := nil;
    BtSetLocalDeviceName := nil;
    BtGetLocalDeviceName := nil;
    BtGetClassOfDevice := nil;
    BtGetDiscoverabilityMode := nil;
    BtGetConnectabilityMode := nil;
    BtDiscoverRemoteDevice2 := nil;
    BtMemFree := nil;
    BtGetRemoteDeviceList2 := nil;
    BtRemoveRemoteDevice := nil;
    BtConnectSDP := nil;
    BtDisconnectSDP := nil;
    BtMakeServiceSearchPattern2 := nil;
    BtServiceSearchAttribute2 := nil;
    BtMakeAttributeIDList2 := nil;
    BtAnalyzeServiceAttributeLists2 := nil;
    BtFreePBTANALYZEDATTRLIST2 := nil;
    BtAnalyzeProtocolParameter2 := nil;
    BtServiceSearchAttributeSDDB2 := nil;
    BtRefreshSDDB2 := nil;
    BtCreateCOMM := nil;
    BtDestroyCOMM := nil;
    BtConnectCOMM2 := nil;
    BtDisconnectCOMM := nil;
    BtGetConnectionHandle := nil;
    BtGetLinkQuality := nil;
    BtAssignSCN := nil;
    BtFreeSCN := nil;
    BtGetCOMMInfoList2 := nil;
    BtMemAlloc := nil;

    if FTosLibrary <> 0 then begin
      FreeLibrary(FTosLibrary);
      FTosLibrary := 0;
    end;
  end;

  if not (baWinSock in FBluetoothAPIs) then begin
    BluetoothFindFirstRadio := nil;
    BluetoothFindNextRadio := nil;
    BluetoothFindRadioClose := nil;
    BluetoothGetDeviceInfo := nil;
    BluetoothGetRadioInfo := nil;
    BluetoothRegisterForAuthentication := nil;
    BluetoothUnregisterAuthentication := nil;
    BluetoothSendAuthenticationResponse := nil;
    BluetoothRemoveDevice := nil;
    BluetoothSetServiceState := nil;
    BluetoothUpdateDeviceRecord := nil;
    BluetoothAuthenticateDevice := nil;
    BluetoothSdpGetAttributeValue := nil;
    BluetoothIsDiscoverable := nil;
    BluetoothIsConnectable := nil;
    BluetoothEnableDiscovery := nil;
    BluetoothEnableIncomingConnections := nil;

    if FWSLibrary <> 0 then begin
      FreeLibrary(FWSLibrary);
      FWSLibrary := 0;
    end;
  end;
end;

procedure TBFAPI.UnloadAPIs;
var
  Status: LONG;
begin
  if ActiveSync then begin
    CeRapiUnInit;

    if FRAPILibrary <> 0 then begin
      FreeLibrary(FRAPILibrary);
      FRAPILibrary := 0;
    end;

    CeRapiInit := nil;
    CeRapiUnInit := nil;
    CeFindAllFiles := nil;
    CeRapiFreeBuffer := nil;
    CeRapiInitEx := nil;
    CeCreateDatabase := nil;
    CeDeleteDatabase := nil;
    CeDeleteRecord := nil;
    CeFindFirstDatabase := nil;
    CeFindNextDatabase := nil;
    CeOidGetInfo := nil;
    CeOpenDatabase := nil;
    CeReadRecordProps := nil;
    CeSeekDatabase := nil;
    CeSetDatabaseInfo := nil;
    CeWriteRecordProps := nil;
    CeFindFirstFile := nil;
    CeFindNextFile := nil;
    CeFindClose := nil;
    CeGetFileAttributes := nil;
    CeSetFileAttributes := nil;
    CeCreateFile := nil;
    CeReadFile := nil;
    CeWriteFile := nil;
    CeCloseHandle := nil;
    CeFindAllDatabases := nil;
    CeGetLastError := nil;
    GetRapiError := nil;
    CeSetFilePointer := nil;
    CeSetEndOfFile := nil;
    CeCreateDirectory := nil;
    CeRemoveDirectory := nil;
    CeCreateProcess := nil;
    CeMoveFile := nil;
    CeCopyFile := nil;
    CeDeleteFile := nil;
    CeGetFileSize := nil;
    CeRegOpenKeyEx := nil;
    CeRegEnumKeyEx := nil;
    CeRegCreateKeyEx := nil;
    CeRegCloseKey := nil;
    CeRegDeleteKey := nil;
    CeRegEnumValue := nil;
    CeRegDeleteValue := nil;
    CeRegQueryInfoKey := nil;
    CeRegQueryValueEx := nil;
    CeRegSetValueEx := nil;
    CeGetStoreInformation := nil;
    CeGetSystemMetrics := nil;
    CeGetDesktopDeviceCaps := nil;
    CeGetSystemInfo := nil;
    CeSHCreateShortcut := nil;
    CeSHGetShortcutTarget := nil;
    CeCheckPassword := nil;
    CeGetFileTime := nil;
    CeSetFileTime := nil;
    CeGetVersionEx := nil;
    CeGetWindow := nil;
    CeGetWindowLong := nil;
    CeGetWindowText := nil;
    CeGetClassName := nil;
    CeGlobalMemoryStatus := nil;
    CeGetSystemPowerStatusEx := nil;
  end;

  // If WinSock subsystem was initialized then uninitialize it.
  if FWinSockInitialized then WSACleanup;

  // Uninitialize BlueSoleil API if it was initialized.
  if baBlueSoleil in FBluetoothAPIs then begin
    BT_UninitializeLibrary;

    if FBSLibrary <> 0 then begin
      FreeLibrary(FBSLibrary);
      FBSLibrary := 0;
    end;

    BT_InitializeLibrary := nil;
    BT_UninitializeLibrary := nil;
    BT_IsBlueSoleilStarted := nil;
    BT_IsBluetoothReady := nil;
    BT_StartBluetooth := nil;
    BT_InquireDevices := nil;
    BT_GetRemoteDeviceInfo := nil;
    BT_BrowseServices := nil;
    BT_GetLocalDeviceInfo := nil;
    BT_SetLocalDeviceInfo := nil;
    BT_DisconnectSPPExService := nil;
    BT_ConnectSPPExService := nil;
    BT_PairDevice := nil;
    BT_StartSPPExService := nil;
    BT_StopSPPExService := nil;
    BT_RegisterCallback := nil;
    BT_UnregisterCallback := nil;
    BT_UnpairDevice := nil;
    BT_SearchSPPExServices := nil;
    BT_ConnectService := nil;
    BT_DisconnectService := nil;
    BT_SetRemoteDeviceInfo := nil;
    BT_GetVersion := nil;
  end;

  // Uniqitialize WidComm API
  if baWidComm in FBluetoothAPIs then begin
    WD_FreeDLL;

    if FWDLibrary <> 0 then begin
      FreeLibrary(FWDLibrary);
      FWDLibrary := 0;
    end;

    WD_IsDeviceReady := nil;
    WD_IsStackServerUp := nil;
    WD_GetLocalDeviceVersionInfo := nil;
    WD_GetLocalDeviceName := nil;
    WD_SetLocalDeviceName := nil;
    WD_Inquiry := nil;
    WD_Discovery := nil;
    WD_CreateCOMPortAssociation := nil;
    WD_RemoveCOMPortAssociation := nil;
    WD_Bond := nil;
    WD_BondQuery := nil;
    WD_OpenServer := nil;
    WD_CloseServer := nil;
    WD_Write := nil;
    WD_UnBond := nil;
    WD_IsRemoteDeviceConnected := nil;
    WD_GetRemoteAddr := nil;
    WD_GetConnectionStats := nil;
    WD_GetVersion := nil;
  end;

  // Uninitialize Toshiba API
  if baToshiba in FBluetoothAPIs then begin
    BtCloseAPI(Status);

    if FTosLibrary <> 0 then begin
      FreeLibrary(FTosLibrary);
      FTosLibrary := 0;
    end;

    BtOpenAPI := nil;
    BtCloseAPI := nil;
    BtExecBtMng := nil;
    BtGetLocalInfo2 := nil;
    BtSetLocalDeviceName := nil;
    BtGetLocalDeviceName := nil;
    BtGetClassOfDevice := nil;
    BtGetDiscoverabilityMode := nil;
    BtGetConnectabilityMode := nil;
    BtDiscoverRemoteDevice2 := nil;
    BtMemFree := nil;
    BtGetRemoteDeviceList2 := nil;
    BtRemoveRemoteDevice := nil;
    BtConnectSDP := nil;
    BtDisconnectSDP := nil;
    BtMakeServiceSearchPattern2 := nil;
    BtServiceSearchAttribute2 := nil;
    BtMakeAttributeIDList2 := nil;
    BtAnalyzeServiceAttributeLists2 := nil;
    BtFreePBTANALYZEDATTRLIST2 := nil;
    BtAnalyzeProtocolParameter2 := nil;
    BtServiceSearchAttributeSDDB2 := nil;
    BtRefreshSDDB2 := nil;
    BtCreateCOMM := nil;
    BtDestroyCOMM := nil;
    BtConnectCOMM2 := nil;
    BtDisconnectCOMM := nil;
    BtGetConnectionHandle := nil;
    BtGetLinkQuality := nil;
    BtAssignSCN := nil;
    BtFreeSCN := nil;
    BtGetCOMMInfoList2 := nil;
    BtMemAlloc := nil;
  end;

  // Uninitialize WinSock
  if baWinSock in FBluetoothAPIs then begin
    if FWSLibrary <> 0 then begin
      FreeLibrary(FWSLibrary);
      FWSLibrary := 0;
    end;

    BluetoothFindFirstRadio := nil;
    BluetoothFindNextRadio := nil;
    BluetoothFindRadioClose := nil;
    BluetoothGetDeviceInfo := nil;
    BluetoothGetRadioInfo := nil;
    BluetoothRegisterForAuthentication := nil;
    BluetoothUnregisterAuthentication := nil;
    BluetoothSendAuthenticationResponse := nil;
    BluetoothRemoveDevice := nil;
    BluetoothSetServiceState := nil;
    BluetoothUpdateDeviceRecord := nil;
    BluetoothAuthenticateDevice := nil;
    BluetoothSdpGetAttributeValue := nil;
    BluetoothIsDiscoverable := nil;
    BluetoothIsConnectable := nil;
    BluetoothEnableDiscovery := nil;
    BluetoothEnableIncomingConnections := nil;
  end;

  FBluetoothAPIs := [];
  FTransports := [atCOM];
end;

function TBFAPI.GetActiveSync: Boolean;
begin
  Result := FRAPILibrary <> 0;
end;

{ TBFAPIInfo }

procedure TBFAPIInfo.CheckTransport(ATransport: TBFAPITransport);
begin
  API.CheckTransport(ATransport);
end;

function TBFAPIInfo.GetActiveSync: Boolean;
begin
  Result := API.ActiveSync;
end;

function TBFAPIInfo.GetBluetoothAPIs: TBFBluetoothAPIs;
begin
  Result := API.FBluetoothAPIs;
end;

function TBFAPIInfo.GetTransports: TBFAPITransports;
begin
  Result := API.FTransports;
end;

{ TBFAPIInfoX }

procedure _TBFAPIInfoX.CheckTransport(ATransport: TBFAPITransport);
begin
  FBFAPIInfo.CheckTransport(ATransport);
end;

constructor _TBFAPIInfoX.Create(AOwner: TComponent);
begin
  inherited;

  FBFAPIInfo := TBFAPIInfo.Create(nil);
end;

destructor _TBFAPIInfoX.Destroy;
begin
  FBFAPIInfo.Free;

  inherited;
end;

function _TBFAPIInfoX.GetActiveSync: Boolean;
begin
  Result := FBFAPIInfo.GetActiveSync;
end;

function _TBFAPIInfoX.GetBluetoothAPIs: TBFBluetoothAPIs;
begin
  Result := FBFAPIInfo.GetBluetoothAPIs;
end;

function _TBFAPIInfoX.GetTransports: TBFAPITransports;
begin
  Result := FBFAPIInfo.GetTransports;
end;

var
  WSALib: THandle = 0;

// At startup we must initialize APIs subsystems.
procedure TBFAPIInfo.Redetect;
begin
  API.UnloadAPIs;
  API.LoadAPIs;
end;

procedure _TBFAPIInfoX.Redetect;
begin
  FBFAPIInfo.Redetect;
end;

initialization
  WSALib := LoadLibrary('ws2_32.dll');
  if WSALib > 0 then begin
    WSALookupServiceBegin := GetProcAddress(WSALib, 'WSALookupServiceBeginA');
    WSALookupServiceEnd := GetProcAddress(WSALib, 'WSALookupServiceEnd');
    WSALookupServiceNext := GetProcAddress(WSALib, 'WSALookupServiceNextA');
    WSAAddressToString := GetProcAddress(WSALib, 'WSAAddressToStringA');
    WSACreateEvent := GetProcAddress(WSALib, 'WSACreateEvent');
    WSACloseEvent := GetProcAddress(WSALib, 'WSACloseEvent');
    WSAEventSelect := GetProcAddress(WSALib, 'WSAEventSelect');
    WSAEnumNetworkEvents := GetProcAddress(WSALib, 'WSAEnumNetworkEvents');
    WSAStringToAddress := GetProcAddress(WSALib, 'WSAStringToAddressA');
    WSAWaitForMultipleEvents := GetProcAddress(WSALib, 'WSAWaitForMultipleEvents');
    WSASetService := GetProcAddress(WSALib, 'WSASetServiceA');
    socket := GetProcAddress(WSALib, 'socket');
    closesocket := GetProcAddress(WSALib, 'closesocket');
    getsockopt := GetProcAddress(WSALib, 'getsockopt');
    setsockopt := GetProcAddress(WSALib, 'setsockopt');
    connect := GetProcAddress(WSALib, 'connect');
    recv := GetProcAddress(WSALib, 'recv');
    send := GetProcAddress(WSALib, 'send');
    bind := GetProcAddress(WSALib, 'bind');
    listen := GetProcAddress(WSALib, 'listen');
    accept := GetProcAddress(WSALib, 'accept');
    getsockname := GetProcAddress(WSALib, 'getsockname');
    getpeername := GetProcAddress(WSALib, 'getpeername');
  end;

  API := TBFAPI.Create;

// At cleanup we must dispose all API's functions.
finalization
  API.Free;
  API := nil;

  if WSALib > 0 then FreeLibrary(WSALib);  

end.
