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
unit BFGSMModemClient;

{$I BF.inc}

interface

uses
  BFBase, Contnrs, BFATCommandClient, Classes, BFClients, Messages, BFAPI,
  BFvCard;

type
  // SMS status:
  //   mtUnknown   - Unknown;
  //   mtRecUnread - Received unreaded;
  //   mtRecRead   - Received readed;
  //   mtStoUnsent - Stored unsent;
  //   mtStoSent   - Stored sent;
  //   mtAll       - all SMSes, uses for reading SMSes from mobile device.
  //                 SMS never have this status.
  TBFSMSStatus = (msNone, msRecUnread, msRecRead, msStoUnsent, msStoSent, msAll);
  // SMS type:
  //   mtiNone          - Unknonw;
  //   mtiDeliver       - Ougoing SMS;
  //   mtiSubmit        - Incoming SMS;
  //   mtiDeliverReport - Incoming delivery report.
  TBFSMSType = (mtNone, mtDeliver, mtSubmit, mtDeliverReport);
  // Supported (used) device's memeory for SMS storing:
  //   mmUnknown - memory unknown. This valu used inly for gethering device
  //               capabilities;
  //   mmBoth    - use SIM and device memory;
  //   mmDevice  - use only device memory;
  //   mmSIM     - use only SIM memory.
  // NOTE that mmBoth <> [mmDevice, mmSIM] !!! It is different things!!!
  TBFSMSMemory = (mmUnknown, mmBoth, mmDevice, mmSIM);
  // Set of supported memories.
  TBFSMSMemories = set of TBFSMSMemory;
  // Device's SMS memories types:
  //   mmtReadDelete - used for read and delete SMS;
  //   mmtWriteSend  - used for write and send SMS;
  //   mmtReceive    - used for receive SMS.
  TBFSMSMemoryType = (mmtReadDelete, mmtWriteSend, mmtReceive);
  // SMS text encoding;
  TBFSMSEncoding = (se8Bit, seUnicode, se7Bit);

  // Forward declaration.
  TBFSMSes = class;

  // Representation of the SMS.
  TBFSMS = class(TBFBaseClass)
  private
    FDate: TDateTime;
    FEncoding: TBFSMSEncoding;
    FIndex: Integer;
    // Internal fields.
    FLongCount: Byte;
    FLongIndex: Byte;
    FLongReference: Byte;
    //
    FNested: TBFSMSes;
    FPhone: string;
    FReference: Byte;
    FServiceCenter: string;
    FSmsType: TBFSMSType;
    FStatus: TBFSMSStatus;
    FText: string;

    procedure ClearFields;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFSMS to another.
    procedure Assign(ASMS: TBFSMS);

    // SMS date.
    property Date: TDateTime read FDate;
    // SMS Text encoding.
    property Encoding: TBFSMSEncoding read FEncoding;
    // SMS index in device memory.
    property Index: Integer read FIndex;
    // SMSes numbers in long SMS
    property LongCount: Byte read FLongCount;
    // SMS index in long SMS
    property LongIndex: Byte read FLongIndex;
    // Long SMS reference number
    property LongReference: Byte read FLongReference;
    // Nested SMSes (for long SMS, for short SMS it is empty list but not nil).
    property Nested: TBFSMSes read FNested;
    // Phone number.
    property Phone: string read FPhone;
    // Reference number of the SMS.
    property Reference: Byte read FReference;
    // Service center number.
    property ServiceCenter: string read FServiceCenter;
    // Type of the SMS.
    property SmsType: TBFSMSType read FSMSType;
    // Status of the SMS.
    property Status: TBFSMSStatus read FStatus;
    // SMS text.
    property Text: string read FText;
  end;

  // The list of SMSes.
  TBFSMSes = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetSMS(const Index: Integer): TBFSMS;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one nstance of the list to another.
    procedure Assign(AList: TBFSMSes);
    // Loads SMSes from specified file.
    procedure LoadFromFile(FileName: string);
    // Loads SMSes from stream.
    procedure LoadFromStream(Stream: TStream);
    // Saves SMSes to specified file.
    procedure SaveToFile(FileName: string);
    // Saves SMSes to stream.
    procedure SaveToStream(Stream: TStream);

    // Intems count in the list.
    property Count: Integer read GetCount;
    // SMSes zero based array.
    property SMS[const Index: Integer]: TBFSMS read GetSMS; default;
  end;

  // Simple SMSes events prototype.
  TBFSMSEvent = procedure(Sender: TObject; Index: Integer) of object;
  // OnNew event prototype.
  //   AType - incoming SMS type;
  //   AMemory - memory to which sms was received;
  //   AIndex - a SMS index in the specified memory.
  TBFSMSNewEvent = procedure(Sender: TObject; AType: TBFSMSType; AMemory: TBFSMSMemory; AIndex: Integer) of object;
  // OnProgress event prototype.
  //   AIndex - current sending/saving SMS index;
  //   ATotal - total numbers of the SMSes to send/save.
  TBFSMSProgressEvent = procedure(Sender: TObject; AIndex: Integer; ATotal: Integer) of object;
  // TBFSMS OnSendStart event prototype. ATotal - total numbers of SMSes to
  // be sended/saved.
  TBFSMSSendStartEvent = procedure(Sender: TObject; ATotal: Integer) of object;

  // Keypad event monitoring thread.
  TBFSMSEventThread = class(TBFClientReadThread)
  protected
    // Checking is events presents in the buffer
    procedure CheckEvents; override;
  end;

  // Type of power supply.
  //   psBattery     - battery
  //   psNotBattery  - charge
  //   psNoBattery   - battery absent
  //   psError       - unknown
  TBFPowerSupply = (psBattery, psNotBattery, psNoBattery, psError);

  // Battery charge status.
  TBFBatteryCharge = record
    // Supply
    PowerSupply: TBFPowerSupply;
    // Percent (0..100)
    Percent: Byte;
  end;

  // Key types. The keys with SE preffix is SonyEricsson specified.
  // Also keys with Siemens preffis is Siemens specified.
  // Not all keys supported by all devices.
  TBFKey = (keyHash, keyPercent, keyAsterisk, key0, key1, key2, key3, key4, key5,
            key6, key7, key8, key9, keyLeftArrow, keyRightArrow, keyClear, keyEnd,
            keySend, keyDownArrow, keyPause, keyDelete, keySoftKey1, keySoftKey2,
            keyUpArrow, keyVolumeDown, keyLock, keyPower, keyVolumeUp, keyOperator,
            keyHeadset, keySiemensLeftSideKeyUp, keySiemensLeftSideKeyDown,
            keySiemensRightSideKey, keySEJoyPress, keySECamera, keySEReturn,
            keySEVideCall, keySECameraFocus, keySEFlipClose, keySEFlipOpen,
            keySECameraLensClose, keySECameraLensOpen, keySEJackeynifClose,
            keySEJackeynifOpen, keySEMultitask, keySEFlashLamp, keySEPTT,
            keySEMediaPlayer, keySEFire, keySEUpLeft, keySEUpRight,
            keySEDownLeft, keySEDownRight, keySEGameA, keySEGameB,
            keySEGameC, keySEGameD, keyJoyPress);

  // Keypad event prototypes.
  TBFKeypadEvent = procedure (Sender: TObject; Key: TBFKey) of object;

  // Phone book types:
  //   phSIMFixDialing  (FD) - SIM fix-dialing phonebook
  //   phSIM            (SM) - SIM phonebook
  //   phME             (ME) - ME phonebook
  //   phMEDialed       (DC) - ME Dialled Calls List
  //   phOwnNumber      (ON) - SIM (or ME) own numbers (MSISDNs) list
  //   phSIMLastDialing (LD) - SIM last-dialling phonebook
  //   phMEMissed       (MC) - ME missed (unanswered received) calls list
  //   phMEReceived     (RC) - ME received calls list
  TBFPhoneBook = (phSIMFixDialing, phSIM, phME, phMEDialed, phOwnNumber, phSIMLastDialing, phMEMissed, phMEReceived);
  TBFPhoneBooks = set of TBFPhoneBook;

  // Representation of the SMS client.
  // Returns information about mobile device (usually mobile phone).
  // Not all models supports all features.
  // If feature not supported by model then property returns
  // an empty result.
  // This client allow you to control keys on the mobile phone.
  // Not supported by all models. Some keys are specified for models.
  TBFGSMModemClient = class(TBFATCommandsClient)
  private
    FDisableATCommand: Boolean;
    FEncoding: TBFSMSEncoding;
    FKeypadSupported: Boolean;
    FMassSendingStarted: Boolean;
    FSMSEnabled: Boolean;
    FValidPeriod: Byte;

    FOnDown: TBFKeypadEvent;
    FOnNew: TBFSMSNewEvent;
    FOnPhonebookProgress: TBFSMSProgressEvent;
    FOnProgress: TBFSMSProgressEvent;
    FOnSendComplete: TBFSMSEvent;
    FOnSendStart: TBFSMSSendStartEvent;
    FOnUp: TBFKeypadEvent;

    function ComposePDU(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ALong: Boolean; ANeedReport: Boolean; ACnt: Byte; ANdx: Byte; ARef: Byte; var SCANumLength: Byte): string;
    function DecomposePDU(PDU: string; Index: Integer; Stat: Byte): TBFSMS;
    function InternalMakeSMS(Send: Boolean; AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Integer;
    function GetBatteryCharge: TBFBatteryCharge;
    function GetClock: string;
    function GetIMEI: string;
    function GetIMSI: string;
    function GetKeypadSupported: Boolean;
    function GetManufacturer: string;
    function GetModel: string;
    function GetPhonebook: TBFPhoneBook;
    function GetPhonebookRecordsCount: Integer;
    function GetPrefferedMemory(const MemoryType: TBFSMSMemoryType): TBFSMSMemory;
    function GetServiceCenter: string;
    function GetSignal: Byte;
    function GetSoftVersion: string;
    function GetSupportedPhonebooks: TBFPhoneBooks;
    function GetSupportedMemories(const MemoryType: TBFSMSMemoryType): TBFSMSMemories;

    function SMSEncodeDate(AYear: string; ADay: string; AMonth: string; AHour: string; AMinute: string; ASecond : String) : TDateTime;
    function StrToMemory(Str: string): TBFSMSMemory;

    procedure BFNMKeypadEvent(var Message: TMessage); message BFNM_KEYPAD_EVENT;
    procedure BFNMSMSDeliverEvent(var Message: TMessage); message BFNM_SMS_DELIVER_EVENT;
    procedure BFNMSMSReportEvent(var Message: TMessage); message BFNM_SMS_REPORT_EVENT;
    procedure CheckPhoneNumber(APhone: string);
    procedure CheckSMSEnabled;
    procedure DoDown(Key: TBFKey);
    procedure DoUp(Key: TBFKey);
    procedure SetPhonebook(const Value: TBFPhoneBook);
    procedure SetPrefferedMemory(const MemoryType: TBFSMSMemoryType; Value: TBFSMSMemory);
    procedure SetServiceCenter(const Value: string);

  protected
    // Returns class of the read thread.
    function GetThreadClass: TBFClientReadThreadClass; override;

    procedure InternalClose; override;
    procedure InternalOpen; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

    // Converts char to TBFKey.
    function CharToKey(Char: string): TBFKey;
    // Converts TBFKey to char.
    function KeyToChar(Key: TBFKey): string;
    // Reads records from selected phonebook.
    function ReadPhonebook: TBFvCards;
    // Reads SMS by its index from memory type specified for memory
    // mmtReadDelete. Application should free returned object.
    function ReadSMS(Index: Integer): TBFSMS;
    // Reads SMSes with specified status from memory type specified for memory
    // mmtReadDelete. Application should free returned object.
    function ReadSMSes(SMSStatus: TBFSMSStatus; MakeNested: Boolean = True): TBFSMSes;
    // Saves SMS into device memoty type specified for memoty mmtWriteSend.
    // AServiceCenter - service center number.
    // APhone - phone number to which SMS may be sended later. Can be empty.
    // AText - SMS text. Component automatically makes long SMSes.
    // AFlash - if True then FLASH SMS will be saved.
    // ANeedReport - sets to True if you need status report for SMS delivery.
    //               If it is a long SMS then status report will asked only for
    //               last SMS from long SMSes list.
    // Returns SMS index int the specified SMS memory. If it is long SMS then
    // returns index only for first SMS from the SMSes group.
    function SaveSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Integer;
    // Sends SMS without saving to device memory.
    // AServiceCenter - service center number.
    // APhone - phone number to which SMS may be sended later. Can be empty.
    // AText - SMS text. Component automatically makes long SMSes.
    // AFlash - if True then FLASH SMS will be saved.
    // ANeedReport - sets to True if you need status report for SMS delivery.
    // Returns SMS reference number. For long SMS returns reference number for
    // last SMS from SMSes groupd.
    function SendSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Byte; overload;
    // Sends SMS from device memory type specified for memory mmtWriteSend by
    // its index.
    // APhone - phone number to which SMS should be sent.
    // ANeedReport - sets to True if you need status report for SMS delivery.
    // Returns SMS reference number.
    // If you want send long saved SMS you should call this procedure for all
    // SMSes in the long SMS group.
    function SendSMS(AIndex: Integer; APhone: string; ANeedReport: Boolean): Byte; overload;

    // Enable mass sending SMS mechanism.
    procedure BeginMassSending;
    // Deletes SMS by its index from memory type specified for memory
    // mmtReadDelete.
    procedure DeleteSMS(Index: Integer);
    // Disable mass sending SMS mechanism.
    procedure EndMassSending;
    // Send push key to the remote device. Key is one of the keys specified
    // in TBFKey enumeration. Time - how time key was pressed. Pause - pause
    // between each press.
    procedure PushKey(Key: TBFKey; Time: Byte; Pause: Byte);
    // Saves phonebook into phone.
    procedure WritePhonebook(vCards: TBFvCards);

    // Battary charge level.
    // Not for all models.
    property BatteryCharge: TBFBatteryCharge read GetBatteryCharge;
    // Current device's clock state.
    // Not for all models.
    property Clock: string read GetClock;
    // IMEI number.
    // Not for all models.
    property IMEI: string read GetIMEI;
    // SIM card IMSI number.
    // Not for all models.
    property IMSI: string read GetIMSI;
    // True if connected device supported this feature.
    property KeypadSupported: Boolean read GetKeypadSupported;
    // Manufacturer name.
    // Not for all models.
    property Manufacturer: string read GetManufacturer;
    // Returns True if masssending started.
    property MassSendingStarted: Boolean read FMassSendingStarted;
    // Model name.
    // Not for all models.
    property Model: string read GetModel;
    // Reads and sets preferred memory for specified memory types.
    property PrefferedMemory[const MemoryType: TBFSMSMemoryType]: TBFSMSMemory read GetPrefferedMemory write SetPrefferedMemory;
    // Current selected phonebook.
    property Phonebook: TBFPhoneBook read GetPhonebook write SetPhonebook;
    // Returns phonebook cells numbers.
    property PhonebookRecordsCount: Integer read GetPhonebookRecordsCount;
    // Returns True if phone supports SMS.
    property SMSEnabled: Boolean read FSMSEnabled;
    // Reads and sets SMS Service Center number.
    property ServiceCenter: string read GetServiceCenter write SetServiceCenter;
    // Network signal level.
    // Not for all models.
    property Signal: Byte read GetSignal;
    // Firmware version.
    // Not for all models.
    property SoftVersion: string read GetSoftVersion;
    // Returns supported phonebooks.
    property SupportedPhonebooks: TBFPhoneBooks read GetSupportedPhonebooks;
    // Returns supported memories for specified memory type.
    property SupportedMemories[const MemoryType: TBFSMSMemoryType]: TBFSMSMemories read GetSupportedMemories;

  published
    // Disables executing all internal AT commands.
    property DisableATCommand: Boolean read FDisableATCommand write FDisableATCommand default False;
    // SMS text encoding.
    property Encoding: TBFSMSEncoding read FEncoding write FEncoding default seUnicode;
    // Validity period for SMS (VP).
    // 0-143   - (VP + 1) x 5 minutes (i.e 5 minutes intervals up to 12 hours)
    // 144-167 - 12 hours + ((VP-143) x 30 minutes)
    // 168-196 - (VP-166) x 1 day
    // 197-255 - (VP - 192) x 1 week
    property ValidPeriod: Byte read FValidPeriod write FValidPeriod default 255;

    // Occures when key pressed on remote device.
    property OnDown: TBFKeypadEvent read FOnDown write FOnDown;
    // Occures when key released on remote device.
    property OnUp: TBFKeypadEvent read FOnUp write FOnUp;
    // Event occures when new sms was received.
    property OnNew: TBFSMSNewEvent read FOnNew write FOnNew;
    // Phonebook reading progress
    property OnPhonebookProgress: TBFSMSProgressEvent read FOnPhonebookProgress write FOnPhonebookProgress;
    // Event occures during sending/saving SMS. Calls for each SMS in long SMS
    // groups. Or calls once if it is standard short SMS.
    property OnProgress: TBFSMSProgressEvent read FOnProgress write FOnProgress;
    // Event occures when send/save SMS procedure complete.
    property OnSendComplete: TBFSMSEvent read FOnSendComplete write FOnSendComplete;
    // Event occures when send/save SMS procedure begins.
    property OnSendStart: TBFSMSSendStartEvent read FOnSendStart write FOnSendStart;
  end;

  _TBFGSMModemClientX = class(_TBFATCommandsClientX)
  private
    function GetBatteryCharge: TBFBatteryCharge;
    function GetClock: string;
    function GetDisableATCommand: Boolean;
    function GetEncoding: TBFSMSEncoding;
    function GetIMEI: string;
    function GetIMSI: string;
    function GetKeypadSupported: Boolean;
    function GetManufacturer: string;
    function GetMassSendingStarted: Boolean;
    function GetModel: string;
    function GetOnDown: TBFKeypadEvent;
    function GetOnNew: TBFSMSNewEvent;
    function GetOnPhonebookProgress: TBFSMSProgressEvent;
    function GetOnProgress: TBFSMSProgressEvent;
    function GetOnSendComplete: TBFSMSEvent;
    function GetOnSendStart: TBFSMSSendStartEvent;
    function GetOnUp: TBFKeypadEvent;
    function GetPhonebook: TBFPhoneBook;
    function GetPhonebookRecordsCount: Integer;
    function GetPrefferedMemory(const MemoryType: TBFSMSMemoryType): TBFSMSMemory;
    function GetServiceCenter: string;
    function GetSignal: Byte;
    function GetSMSEnabled: Boolean;
    function GetSoftVersion: string;
    function GetSupportedMemories(const MemoryType: TBFSMSMemoryType): TBFSMSMemories;
    function GetSupportedPhonebooks: TBFPhoneBooks;
    function GetValidPeriod: Byte;

    procedure SetDisableATCommand(const Value: Boolean);
    procedure SetEncoding(const Value: TBFSMSEncoding);
    procedure SetOnDown(const Value: TBFKeypadEvent);
    procedure SetOnNew(const Value: TBFSMSNewEvent);
    procedure SetOnPhonebookProgress(const Value: TBFSMSProgressEvent);
    procedure SetOnProgress(const Value: TBFSMSProgressEvent);
    procedure SetOnSendComplete(const Value: TBFSMSEvent);
    procedure SetOnSendStart(const Value: TBFSMSSendStartEvent);
    procedure SetOnUp(const Value: TBFKeypadEvent);
    procedure SetPhonebook(const Value: TBFPhoneBook);
    procedure SetPrefferedMemory(const MemoryType: TBFSMSMemoryType; const Value: TBFSMSMemory);
    procedure SetServiceCenter(const Value: string);
    procedure SetValidPeriod(const Value: Byte);

  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    function CharToKey(Char: string): TBFKey;
    function KeyToChar(Key: TBFKey): string;
    function ReadPhonebook: TBFvCards;
    function ReadSMS(Index: Integer): TBFSMS;
    function ReadSMSes(SMSStatus: TBFSMSStatus; MakeNested: Boolean = True): TBFSMSes;
    function SaveSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Integer;
    function SendSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Byte; overload;
    function SendSMS(AIndex: Integer; APhone: string; ANeedReport: Boolean): Byte; overload;

    procedure BeginMassSending;
    procedure DeleteSMS(Index: Integer);
    procedure EndMassSending;
    procedure PushKey(Key: TBFKey; Time: Byte; Pause: Byte);
    procedure WritePhonebook(vCards: TBFvCards);

    property BatteryCharge: TBFBatteryCharge read GetBatteryCharge;
    property Clock: string read GetClock;
    property IMEI: string read GetIMEI;
    property IMSI: string read GetIMSI;
    property KeypadSupported: Boolean read GetKeypadSupported;
    property Manufacturer: string read GetManufacturer;
    property MassSendingStarted: Boolean read GetMassSendingStarted;
    property Model: string read GetModel;
    property PrefferedMemory[const MemoryType: TBFSMSMemoryType]: TBFSMSMemory read GetPrefferedMemory write SetPrefferedMemory;
    property Phonebook: TBFPhoneBook read GetPhonebook write SetPhonebook;
    property PhonebookRecordsCount: Integer read GetPhonebookRecordsCount;
    property SMSEnabled: Boolean read GetSMSEnabled;
    property ServiceCenter: string read GetServiceCenter write SetServiceCenter;
    property Signal: Byte read GetSignal;
    property SoftVersion: string read GetSoftVersion;
    property SupportedPhonebooks: TBFPhoneBooks read GetSupportedPhonebooks;
    property SupportedMemories[const MemoryType: TBFSMSMemoryType]: TBFSMSMemories read GetSupportedMemories;

  published
    property DisableATCommand: Boolean read GetDisableATCommand write SetDisableATCommand;
    property Encoding: TBFSMSEncoding read GetEncoding write SetEncoding;
    property ValidPeriod: Byte read GetValidPeriod write SetValidPeriod;

    property OnDown: TBFKeypadEvent read GetOnDown write SetOnDown;
    property OnUp: TBFKeypadEvent read GetOnUp write SetOnUp;
    property OnNew: TBFSMSNewEvent read GetOnNew write SetOnNew;
    property OnPhonebookProgress: TBFSMSProgressEvent read GetOnPhonebookProgress write SetOnPhonebookProgress;
    property OnProgress: TBFSMSProgressEvent read GetOnProgress write SetOnProgress;
    property OnSendComplete: TBFSMSEvent read GetOnSendComplete write SetOnSendComplete;
    property OnSendStart: TBFSMSSendStartEvent read GetOnSendStart write SetOnSendStart;
  end;

implementation

uses
  BFStrings, Windows, SysUtils{$IFDEF DELPHI6}, DateUtils, Controls{$ENDIF};

const
  BF_KEYPAD_CHARS: array [TBFKey] of string =
    ('#', '%','*', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '<',
     '>', 'C', 'E', 'S', 'V', 'W', 'Y', '[', ']', '^', ':+', ':-', ':M',
     'D', 'L', 'P', 'U', ':J', ':C', ':O', ':R', 'H', ':M', ':F', ':(',
     ':)', ':{', ':}', ':[', ':]', ':D', ':L', ':P', ':S', ':=', ':<', ':|',
     ':V', ':>', ':1', ':2', ':3', ':4', 'F');

  NPC7 = 32;
  NPC8 = Ord(' ');

  ASCII_TO_GSM: array [0..255] of SmallInt = (
		NPC7,       {     0      null [NUL]                              }
		NPC7,       {     1      start of heading [SOH]                  }
		NPC7,       {     2      start of text [STX]                     }
		NPC7,       {     3      end of text [ETX]                       }
		NPC7,       {     4      end of transmission [EOT]               }
		NPC7,       {     5      enquiry [ENQ]                           }
		NPC7,       {     6      acknowledge [ACK]                       }
                NPC7,       {     7      bell [BEL]                              }
                NPC7,       {     8      backspace [BS]                          }
                NPC7,       {     9      horizontal tab [HT]                     }
                10,         {    10      line feed [LF]                          }
                NPC7,       {    11      vertical tab [VT]                       }
		10 + 256,   {    12      form feed [FF]                          }
		13,         {    13      carriage return [CR]                    }
                NPC7,       {    14      shift out [SO]                          }
                NPC7,       {    15      shift in [SI]                           }
                NPC7,       {    16      data link escape [DLE]                  }
                NPC7,       {    17      device control 1 [DC1]                  }
		NPC7,       {    18      device control 2 [DC2]                  }
                NPC7,       {    19      device control 3 [DC3]                  }
                NPC7,       {    20      device control 4 [DC4]                  }
                NPC7,       {    21      negative acknowledge [NAK]              }
                NPC7,       {    22      synchronous idle [SYN]                  }
		NPC7,       {    23      end of trans. block [ETB]               }
		NPC7,       {    24      cancel [CAN]                            }
		NPC7,       {    25      end of medium [EM]                      }
                NPC7,       {    26      substitute [SUB]                        }
                NPC7,       {    27      escape [ESC]                            }
                NPC7,       {    28      file separator [FS]                     }
                NPC7,       {    29      group separator [GS]                    }
                NPC7,       {    30      record separator [RS]                   }
                NPC7,       {    31      unit separator [US]                     }
		32,         {    32      space                                   }
                33,         {    33    ! exclamation mark                        }
		34,         {    34    " double quotation mark                   }
		35,         {    35    # number sign                             }
		2,          {    36    $ dollar sign                             }
                37,         {    37    % percent sign                            }
                38,         {    38    & ampersand                               }
		39,         {    39    ' apostrophe                              }
                40,         {    40    ( left parenthesis                        }
                41,         {    41    ) right parenthesis                       }
                42,         {    42    * asterisk                                }
                43,         {    43    + plus sign                               }
		44,         {    44    , comma                                   }
                45,         {    45    - hyphen                                  }
                46,         {    46    . period                                  }
		47,         {    47    / slash,                                  }
		48,         {    48    0 digit 0                                 }
		49,         {    49    1 digit 1                                 }
		50,         {    50    2 digit 2                                 }
		51,         {    51    3 digit 3                                 }
                52,         {    52    4 digit 4                                 }
                53,         {    53    5 digit 5                                 }
                54,         {    54    6 digit 6                                 }
                55,         {    55    7 digit 7                                 }
                56,         {    56    8 digit 8                                 }
                57,         {    57    9 digit 9                                 }
		58,         {    58    : colon                                   }
                59,         {    59    ; semicolon                               }
		60,         {    60    < less-than sign                          }
                61,         {    61    = equal sign                              }
                62,         {    62    > greater-than sign                       }
		63,         {    63    ? question mark                           }
		0,          {    64    @ commercial at sign                      }
		65,         {    65    A uppercase A                             }
		66,         {    66    B uppercase B                             }
		67,         {    67    C uppercase C                             }
		68,         {    68    D uppercase D                             }
		69,         {    69    E uppercase E                             }
		70,         {    70    F uppercase F                             }
                71,         {    71    G uppercase G                             }
		72,         {    72    H uppercase H                             }
		73,         {    73    I uppercase I                             }
                74,         {    74    J uppercase J                             }
		75,         {    75    K uppercase K                             }
                76,         {    76    L uppercase L                             }
		77,         {    77    M uppercase M                             }
                78,         {    78    N uppercase N                             }
                79,         {    79    O uppercase O                             }
                80,         {    80    P uppercase P                             }
                81,         {    81    Q uppercase Q                             }
                82,         {    82    R uppercase R                             }
                83,         {    83    S uppercase S                             }
		84,         {    84    T uppercase T                             }
                85,         {    85    U uppercase U                             }
                86,         {    86    V uppercase V                             }
                87,         {    87    W uppercase W                             }
                88,         {    88    X uppercase X                             }
		89,         {    89    Y uppercase Y                             }
		90,         {    90    Z uppercase Z                             }
		60 + 256,   {    91    [ left square bracket                     }
		47 + 256,   {    92    \ backslash                               }
		62 + 256,   {    93    ] right square bracket                    }
		20 + 256,   {    94    ^ circumflex accent                       }
		17,         {    95    _ underscore                              }
		-39,        {    96    ` back apostrophe                         }
		97,         {    97    a lowercase a                             }
		98,         {    98    b lowercase b                             }
                99,         {    99    c lowercase c                             }
		100,        {   100    d lowercase d                             }
		101,        {   101    e lowercase e                             }
                102,        {   102    f lowercase f                             }
		103,        {   103    g lowercase g                             }
                104,        {   104    h lowercase h                             }
                105,        {   105    i lowercase i                             }
                106,        {   106    j lowercase j                             }
                107,        {   107    k lowercase k                             }
		108,        {   108    l lowercase l                             }
                109,        {   109    m lowercase m                             }
		110,        {   110    n lowercase n                             }
                111,        {   111    o lowercase o                             }
                112,        {   112    p lowercase p                             }
                113,        {   113    q lowercase q                             }
                114,        {   114    r lowercase r                             }
                115,        {   115    s lowercase s                             }
                116,        {   116    t lowercase t                             }
                117,        {   117    u lowercase u                             }
                118,        {   118    v lowercase v                             }
		119,        {   119    w lowercase w                             }
		120,        {   120    x lowercase x                             }
		121,        {   121    y lowercase y                             }
		122,        {   122    z lowercase z                             }
		40 + 256,   (*   123    { left brace                            *)
		64 + 256,   {   124    | vertical bar                            }
		41 + 256,   (*   125    } right brace                           *)
		61 + 256,   {   126    ~ tilde accent                            }
		NPC7,       {   127      delete [DEL]                            }
		NPC7,       {   128                                              }
		NPC7,       {   129                                              }
		-39,        {   130      low left rising single quote            }
		-102,       {   131      lowercase italic f                      }
		-34,        {   132      low left rising double quote            }
		NPC7,       {   133      low horizontal ellipsis                 }
		NPC7,       {   134      dagger mark                             }
		NPC7,       {   135      double dagger mark                      }
		NPC7,       {   136      letter modifying circumflex             }
                NPC7,       {   137      per thousand (mille) sign               }
                -83,        {   138      uppercase S caron or hacek              }
                -39,        {   139      left single angle quote mark            }
                -214,       {   140      uppercase OE ligature                   }
                NPC7,       {   141                                              }
                NPC7,       {   142                                              }
                NPC7,       {   143                                              }
		NPC7,       {   144                                              }
                -39,        {   145      left single quotation mark              }
                -39,        {   146      right single quote mark                 }
		-34,        {   147      left double quotation mark              }
		-34,        {   148      right double quote mark                 }
                -42,        {   149      round filled bullet                     }
		-45,        {   150      en dash                                 }
		-45,        {   151      em dash                                 }
                -39,        {   152      small spacing tilde accent              }
                NPC7,       {   153      trademark sign                          }
                -115,       {   154      lowercase s caron or hacek              }
		-39,        {   155      right single angle quote mark           }
		-111,       {   156      lowercase oe ligature                   }
                NPC7,       {   157                                              }
                NPC7,       {   158                                              }
                -89,        {   159      uppercase Y dieresis or umlaut          }
                -32,        {   160      non-breaking space                      }
                64,         {   161    ¡ inverted exclamation mark               }
		-99,        {   162    ¢ cent sign                               }
                1,          {   163    £ pound sterling sign                     }
                36,         {   164    ¤ general currency sign                   }
                3,          {   165    ¥ yen sign                                }
                -33,        {   166    ¦ broken vertical bar                     }
                95,         {   167    § section sign                            }
		-34,        {   168    ¨ spacing dieresis or umlaut              }
		NPC7,       {   169    © copyright sign                          }
                NPC7,       {   170    ª feminine ordinal indicator              }
                -60,        {   171    « left (double) angle quote               }
		NPC7,       {   172    ¬ logical not sign                        }
                -45,        {   173    ­ soft hyphen                             }
		NPC7,       {   174    ® registered trademark sign               }
                NPC7,       {   175    ¯ spacing macron (long) accent            }
                NPC7,       {   176    ° degree sign                             }
                NPC7,       {   177    ± plus-or-minus sign                      }
                -50,        {   178    ² superscript 2                           }
		-51,        {   179    ³ superscript 3                           }
		-39,        {   180    ´ spacing acute accent                    }
		-117,       {   181    µ micro sign                              }
                NPC7,       {   182    ¶ paragraph sign, pilcrow sign            }
                NPC7,       {   183    · middle dot, centered dot                }
                NPC7,       {   184    ¸ spacing cedilla                         }
                -49,        {   185    ¹ superscript 1                           }
                NPC7,       {   186    º masculine ordinal indicator             }
                -62,        {   187    » right (double) angle quote (guillemet)  }
		NPC7,       {   188    ¼ fraction 1/4                            }
                NPC7,       {   189    ½ fraction 1/2                            }
                NPC7,       {   190    ¾ fraction 3/4                            }
                96,         {   191    ¿ inverted question mark                  }
		-65,        {   192    À uppercase A grave                       }
                -65,        {   193    Á uppercase A acute                       }
		-65,        {   194    Â uppercase A circumflex                  }
                -65,        {   195    Ã uppercase A tilde                       }
                91,         {   196    Ä uppercase A dieresis or umlaut          }
		14,         {   197    Å uppercase A ring                        }
                28,         {   198    Æ uppercase AE ligature                   }
                9,          {   199    Ç uppercase C cedilla                     }
		-31,        {   200    È uppercase E grave                       }
                31,         {   201    É uppercase E acute                       }
                -31,        {   202    Ê uppercase E circumflex                  }
                -31,        {   203    Ë uppercase E dieresis or umlaut          }
		-73,        {   204    Ì uppercase I grave                       }
                -73,        {   205    Í uppercase I acute                       }
                -73,        {   206    Î uppercase I circumflex                  }
		-73,        {   207    Ï uppercase I dieresis or umlaut          }
		-68,        {   208    Ð uppercase ETH                           }
		93,         {   209    Ñ uppercase N tilde                       }
                -79,        {   210    Ò uppercase O grave                       }
                -79,        {   211    Ó uppercase O acute                       }
                -79,        {   212    Ô uppercase O circumflex                  }
                -79,        {   213    Õ uppercase O tilde                       }
		92,         {   214    Ö uppercase O dieresis or umlaut          }
                -42,        {   215    × multiplication sign                     }
		11,         {   216    Ø uppercase O slash                       }
                -85,        {   217    Ù uppercase U grave                       }
		-85,        {   218    Ú uppercase U acute                       }
		-85,        {   219    Û uppercase U circumflex                  }
                94,         {   220    Ü uppercase U dieresis or umlaut          }
                -89,        {   221    Ý uppercase Y acute                       }
		NPC7,       {   222    Þ uppercase THORN                         }
                30,         {   223    ß lowercase sharp s, sz ligature          }
                127,        {   224    à lowercase a grave                       }
                -97,        {   225    á lowercase a acute                       }
		-97,        {   226    â lowercase a circumflex                  }
                -97,        {   227    ã lowercase a tilde                       }
		123,        {   228    ä lowercase a dieresis or umlaut          }
                15,         {   229    å lowercase a ring                        }
                29,         {   230    æ lowercase ae ligature                   }
                -9,         {   231    ç lowercase c cedilla                     }
                4,          {   232    è lowercase e grave                       }
		5,          {   233    é lowercase e acute                       }
                -101,       {   234    ê lowercase e circumflex                  }
                -101,       {   235    ë lowercase e dieresis or umlaut          }
                7,          {   236    ì lowercase i grave                       }
		7,          {   237    í lowercase i acute                       }
		-105,       {   238    î lowercase i circumflex                  }
                -105,       {   239    ï lowercase i dieresis or umlaut          }
		NPC7,       {   240    ð lowercase eth                           }
                125,        {   241    ñ lowercase n tilde                       }
		8,          {   242    ò lowercase o grave                       }
		-111,       {   243    ó lowercase o acute                       }
		-111,       {   244    ô lowercase o circumflex                  }
		-111,       {   245    õ lowercase o tilde                       }
		124,        {   246    ö lowercase o dieresis or umlaut          }
		-47,        {   247    ÷ division sign                           }
		12,         {   248    ø lowercase o slash                       }
		6,          {   249    ù lowercase u grave                       }
		-117,       {   250    ú lowercase u acute                       }
		-117,       {   251    û lowercase u circumflex                  }
		126,        {   252    ü lowercase u dieresis or umlaut          }
		-121,       {   253    ý lowercase y acute                       }
		NPC7,       {   254    þ lowercase thorn                         }
		-121        {   255    ÿ lowercase y dieresis or umlaut          }
                );

  GSM_TO_ASCII: array [0..127] of Byte = (
		64,         {  0      @  COMMERCIAL AT                           }
		163,        {  1      £  POUND SIGN                              }
		36,         {  2      $  DOLLAR SIGN                             }
		165,        {  3      ¥  YEN SIGN                                }
		232,        {  4      è  LATIN SMALL LETTER E WITH GRAVE         }
		233,        {  5      é  LATIN SMALL LETTER E WITH ACUTE         }
		249,        {  6      ù  LATIN SMALL LETTER U WITH GRAVE         }
		236,        {  7      ì  LATIN SMALL LETTER I WITH GRAVE         }
		242,        {  8      ò  LATIN SMALL LETTER O WITH GRAVE         }
		199,        {  9      Ç  LATIN CAPITAL LETTER C WITH CEDILLA     }
		10,         {  10        LINE FEED                               }
                216,        {  11     Ø  LATIN CAPITAL LETTER O WITH STROKE      }
                248,        {  12     ø  LATIN SMALL LETTER O WITH STROKE        }
                13,         {  13        CARRIAGE RETURN                         }
                197,        {  14     Å  LATIN CAPITAL LETTER A WITH RING ABOVE  }
                229,        {  15     å  LATIN SMALL LETTER A WITH RING ABOVE    }
		NPC8,       {  16        GREEK CAPITAL LETTER DELTA              }
                95,         {  17     _  LOW LINE                                }
                NPC8,       {  18        GREEK CAPITAL LETTER PHI                }
                NPC8,       {  19        GREEK CAPITAL LETTER GAMMA              }
                NPC8,       {  20        GREEK CAPITAL LETTER LAMBDA             }
                NPC8,       {  21        GREEK CAPITAL LETTER OMEGA              }
                NPC8,       {  22        GREEK CAPITAL LETTER PI                 }
                NPC8,       {  23        GREEK CAPITAL LETTER PSI                }
                NPC8,       {  24        GREEK CAPITAL LETTER SIGMA              }
		NPC8,       {  25        GREEK CAPITAL LETTER THETA              }
		NPC8,       {  26        GREEK CAPITAL LETTER XI                 }
		27,         {  27        ESCAPE TO EXTENSION TABLE               }
                198,        {  28     Æ  LATIN CAPITAL LETTER AE                 }
                230,        {  29     æ  LATIN SMALL LETTER AE                   }
		223,        {  30     ß  LATIN SMALL LETTER SHARP S (German)     }
                201,        {  31     É  LATIN CAPITAL LETTER E WITH ACUTE       }
                32,         {  32        SPACE                                   }
                33,         {  33     !  EXCLAMATION MARK                        }
                34,         {  34     "  QUOTATION MARK                          }
                35,         {  35     #  NUMBER SIGN                             }
                164,        {  36     ¤  CURRENCY SIGN                           }
                37,         {  37     %  PERCENT SIGN                            }
                38,         {  38     &  AMPERSAND                               }
                39,         {  39     '  APOSTROPHE                              }
                40,         {  40     (  LEFT PARENTHESIS                        }
		41,         {  41     )  RIGHT PARENTHESIS                       }
                42,         {  42     *  ASTERISK                                }
                43,         {  43     +  PLUS SIGN                               }
                44,         {  44     ,  COMMA                                   }
                45,         {  45     -  HYPHEN-MINUS                            }
                46,         {  46     .  FULL STOP                               }
                47,         {  47     /  SOLIDUS (SLASH)                         }
                48,         {  48     0  DIGIT ZERO                              }
                49,         {  49     1  DIGIT ONE                               }
                50,         {  50     2  DIGIT TWO                               }
		51,         {  51     3  DIGIT THREE                             }
		52,         {  52     4  DIGIT FOUR                              }
                53,         {  53     5  DIGIT FIVE                              }
		54,         {  54     6  DIGIT SIX                               }
		55,         {  55     7  DIGIT SEVEN                             }
                56,         {  56     8  DIGIT EIGHT                             }
                57,         {  57     9  DIGIT NINE                              }
                58,         {  58     :  COLON                                   }
                59,         {  59     ;  SEMICOLON                               }
                60,         {  60     <  LESS-THAN SIGN                          }
                61,         {  61     =  EQUALS SIGN                             }
                62,         {  62     >  GREATER-THAN SIGN                       }
                63,         {  63     ?  QUESTION MARK                           }
                161,        {  64     ¡  INVERTED EXCLAMATION MARK               }
		65,         {  65     A  LATIN CAPITAL LETTER A                  }
		66,         {  66     B  LATIN CAPITAL LETTER B                  }
                67,         {  67     C  LATIN CAPITAL LETTER C                  }
                68,         {  68     D  LATIN CAPITAL LETTER D                  }
                69,         {  69     E  LATIN CAPITAL LETTER E                  }
                70,         {  70     F  LATIN CAPITAL LETTER F                  }
                71,         {  71     G  LATIN CAPITAL LETTER G                  }
                72,         {  72     H  LATIN CAPITAL LETTER H                  }
                73,         {  73     I  LATIN CAPITAL LETTER I                  }
                74,         {  74     J  LATIN CAPITAL LETTER J                  }
                75,         {  75     K  LATIN CAPITAL LETTER K                  }
                76,         {  76     L  LATIN CAPITAL LETTER L                  }
		77,         {  77     M  LATIN CAPITAL LETTER M                  }
		78,         {  78     N  LATIN CAPITAL LETTER N                  }
                79,         {  79     O  LATIN CAPITAL LETTER O                  }
                80,         {  80     P  LATIN CAPITAL LETTER P                  }
		81,         {  81     Q  LATIN CAPITAL LETTER Q                  }
                82,         {  82     R  LATIN CAPITAL LETTER R                  }
		83,         {  83     S  LATIN CAPITAL LETTER S                  }
		84,         {  84     T  LATIN CAPITAL LETTER T                  }
                85,         {  85     U  LATIN CAPITAL LETTER U                  }
                86,         {  86     V  LATIN CAPITAL LETTER V                  }
                87,         {  87     W  LATIN CAPITAL LETTER W                  }
                88,         {  88     X  LATIN CAPITAL LETTER X                  }
		89,         {  89     Y  LATIN CAPITAL LETTER Y                  }
                90,         {  90     Z  LATIN CAPITAL LETTER Z                  }
		196,        {  91     Ä  LATIN CAPITAL LETTER A WITH DIAERESIS   }
                214,        {  92     Ö  LATIN CAPITAL LETTER O WITH DIAERESIS   }
                209,        {  93     Ñ  LATIN CAPITAL LETTER N WITH TILDE       }
                220,        {  94     Ü  LATIN CAPITAL LETTER U WITH DIAERESIS   }
                167,        {  95     §  SECTION SIGN                            }
                191,        {  96     ¿  INVERTED QUESTION MARK                  }
                97,         {  97     a  LATIN SMALL LETTER A                    }
                98,         {  98     b  LATIN SMALL LETTER B                    }
                99,         {  99     c  LATIN SMALL LETTER C                    }
                100,        {  100    d  LATIN SMALL LETTER D                    }
                101,        {  101    e  LATIN SMALL LETTER E                    }
		102,        {  102    f  LATIN SMALL LETTER F                    }
		103,        {  103    g  LATIN SMALL LETTER G                    }
                104,        {  104    h  LATIN SMALL LETTER H                    }
                105,        {  105    i  LATIN SMALL LETTER I                    }
		106,        {  106    j  LATIN SMALL LETTER J                    }
                107,        {  107    k  LATIN SMALL LETTER K                    }
                108,        {  108    l  LATIN SMALL LETTER L                    }
                109,        {  109    m  LATIN SMALL LETTER M                    }
                110,        {  110    n  LATIN SMALL LETTER N                    }
                111,        {  111    o  LATIN SMALL LETTER O                    }
		112,        {  112    p  LATIN SMALL LETTER P                    }
		113,        {  113    q  LATIN SMALL LETTER Q                    }
		114,        {  114    r  LATIN SMALL LETTER R                    }
                115,        {  115    s  LATIN SMALL LETTER S                    }
		116,        {  116    t  LATIN SMALL LETTER T                    }
		117,        {  117    u  LATIN SMALL LETTER U                    }
		118,        {  118    v  LATIN SMALL LETTER V                    }
                119,        {  119    w  LATIN SMALL LETTER W                    }
                120,        {  120    x  LATIN SMALL LETTER X                    }
                121,        {  121    y  LATIN SMALL LETTER Y                    }
                122,        {  122    z  LATIN SMALL LETTER Z                    }
                228,        {  123    ä  LATIN SMALL LETTER A WITH DIAERESIS     }
                246,        {  124    ö  LATIN SMALL LETTER O WITH DIAERESIS     }
                241,        {  125    ñ  LATIN SMALL LETTER N WITH TILDE         }
		252,        {  126    ü  LATIN SMALL LETTER U WITH DIAERESIS     }
		224         {  127    à  LATIN SMALL LETTER A WITH GRAVE         }
                );

function ConvertGSMToASCII(GSMString: string): string;
var
  Ndx: Integer;
  AChar: Char;
begin
  Result := '';

  Ndx := 0;
  while Ndx < Length(GSMString) do begin
    Inc(Ndx);

    AChar := Chr(GSM_TO_ASCII[Ord(GSMString[Ndx])]);

    if AChar = #27 then begin
      Inc(Ndx);

      case Ord(GSMString[Ndx]) of
        10: AChar := #12;
	20: AChar := '^';
	40: AChar := '{';
	41: AChar := '}';
	47: AChar := '\';
	60: AChar := '[';
	61: AChar := '~';
        62: AChar := ']';
	64: AChar := '|';

      else
        AChar := Chr(NPC8);
      end;
    end;

    Result := Result + AChar;
  end;
end;

function ConvertASCIIToGSM(ASCIIString: string): string;
var
  Ndx: Integer;
  AChar: SmallInt;
begin
  Result := '';

  for Ndx := 1 to Length(ASCIIString) do begin
    AChar := Abs(ASCII_TO_GSM[Ord(ASCIIString[Ndx])]);

    if AChar > 256 then begin
      Result := Result + #27;
      Dec(AChar, 256);
    end;

    Result := Result + Char(AChar);
  end;
end;

function _CharToKey(Char: string): TBFKey;
var
  Loop: TBFKey;
begin
  Result := keyHash; // Make compiler happy.

  for Loop := Low(BF_KEYPAD_CHARS) to High(BF_KEYPAD_CHARS) do
    if BF_KEYPAD_CHARS[Loop] = Char then begin
      Result := Loop;
      Break;
    end;
end;

{ Support functions }
function DecodeUTF2(PDU: string): string;
var
  Tmp: TBFByteArray;
  Byte1: Byte;
  Byte2: Byte;
  Loop: Integer;
begin
  SetLength(Tmp, 0);
  Loop := 1;

  while Loop <= Length(PDU) do begin
    Byte1 := StrToInt('$' + PDU[Loop] + PDU[Loop + 1]);
    Inc(Loop, 2);
    Byte2 := StrToInt('$' + PDU[Loop] + PDU[Loop + 1]);
    Inc(Loop, 2);
    SetLength(Tmp, Length(Tmp) + 2);
    Tmp[Length(Tmp) - 2] := Byte2;
    Tmp[Length(Tmp) - 1] := Byte1;
  end;

  Result := string(WideString(Tmp));
  SetLength(Tmp, 0);
end;

function Decode7Bit(PDU: string; SkipFirst: Boolean): string;
var
  Tmp: string;
  Byte1: Byte;
  Loop: Integer;
begin
  Tmp := '';
  Loop := 1;

  while Loop <= Length(PDU) do begin
    Byte1 := StrToInt('$' + PDU[Loop] + PDU[Loop + 1]);
    Tmp := Tmp + Char(Byte1);
    Inc(Loop, 2);
  end;

  Result := '';

  for Loop := 0 to Length(Tmp) - 1 do begin
    if Loop mod 7 = 0 then
      Result := Result + Chr(Ord(Tmp[Loop + 1]) and $7F)
    else
      if Loop mod 7 = 6 then begin
        Result := Result + Chr(((Ord(Tmp[Loop + 1]) shl 6) or (Ord(Tmp[Loop]) shr 2)) and $7F);
        Result := Result + Chr(Ord(Tmp[Loop + 1]) shr 1 and $7F);
      end else
        Result := Result + Chr(((Ord(Tmp[Loop + 1]) shl (Loop mod 7)) or (Ord(Tmp[Loop]) shr (8 - (Loop mod 7)))) and $7F);
  end;

  if SkipFirst and (Length(Result) > 7) then Result := Copy(Result, 8, Length(Result));

  Result := ConvertGSMToASCII(Result);
end;

function Decode8Bit(PDU: string): string;
var
  Tmp: TBFByteArray;
  Byte1: Byte;
  Loop: Integer;
begin
  SetLength(Tmp, 0);
  Loop := 1;

  while Loop <= Length(PDU) do begin
    Byte1 := StrToInt('$' + PDU[Loop] + PDU[Loop + 1]);
    Inc(Loop, 2);
    SetLength(Tmp, Length(Tmp) + 1);
    Tmp[Length(Tmp) - 1] := Byte1;
  end;

  Result := string(Tmp);
  SetLength(Tmp, 0);
end;

{ TBFSMS }

procedure TBFSMS.Assign(ASMS: TBFSMS);
begin
  ClearFields;

  if Assigned(ASMS) then begin
    FDate := ASMS.Date;
    FEncoding := ASMS.Encoding;
    FIndex := ASMS.Index;
    FNested.Assign(ASMS.Nested);
    FPhone := ASMS.FPhone;
    FReference := ASMS.FReference;
    FServiceCenter := ASMS.FServiceCenter;
    FSmsType := ASMS.FSmsType;
    FStatus := ASMS.FStatus;
    FText := ASMS.FText;
  end;
end;

procedure TBFSMS.ClearFields;
begin
  FDate := 0;
  FEncoding := seUnicode;
  FIndex := 0;
  FLongCount := 0;
  FLongIndex := 0;
  FLongReference := 0;
  FNested.FList.Clear;
  FPhone := '';
  FReference := 0;
  FServiceCenter := '';
  FSmsType := mtNone;
  FStatus := msNone;
  FText := '';
end;

constructor TBFSMS.Create;
begin
  FNested := TBFSMSes.Create;
  ClearFields;
end;

destructor TBFSMS.Destroy;
begin
  FNested.Free;

  inherited;
end;

procedure TBFSMS.LoadFromStream(Stream: TStream);
var
  HaveNested: Boolean;
  Loop: Integer;
  SMS: TBFSMS;
begin
  with Stream do begin
    ReadBuffer(FDate, SizeOf(TDateTime));
    ReadBuffer(FIndex, SizeOf(Integer));
    ReadBuffer(FLongCount, SizeOf(Byte));
    ReadBuffer(FLongIndex, SizeOf(Byte));
    ReadBuffer(FLongReference, SizeOf(Byte));
    ReadBuffer(HaveNested, SizeOf(Boolean));

    if HaveNested then begin
      ReadBuffer(Loop, SizeOf(Integer));
      while Loop > 0 do begin
        SMS := TBFSMS.Create;
        SMS.LoadFromStream(Stream);
        FNested.FList.Add(SMS);
        Dec(Loop);
      end;
    end;

    ReadBuffer(Loop, SizeOf(Integer));
    SetLength(FPhone, Loop);
    ReadBuffer(PChar(FPhone)^, Loop);
    ReadBuffer(FReference, SizeOf(Byte));
    ReadBuffer(Loop, SizeOf(Integer));
    SetLength(FServiceCenter, Loop);
    ReadBuffer(PChar(FServiceCenter)^, Loop);
    ReadBuffer(FSmsType, SizeOf(TBFSMSType));
    ReadBuffer(FStatus, SizeOf(TBFSMSStatus));
    ReadBuffer(Loop, SizeOf(Integer));
    SetLength(FText, Loop);
    ReadBuffer(PChar(FText)^, Loop);
  end;
end;

procedure TBFSMS.SaveToStream(Stream: TStream);
var
  HaveNested: Boolean;
  Loop: Integer;
begin
  with Stream do begin
    WriteBuffer(FDate, SizeOf(TDateTime));
    WriteBuffer(FIndex, SizeOf(Integer));
    WriteBuffer(FLongCount, SizeOf(Byte));
    WriteBuffer(FLongIndex, SizeOf(Byte));
    WriteBuffer(FLongReference, SizeOf(Byte));
    HaveNested := Assigned(FNested);
    WriteBuffer(HaveNested, SizeOf(Boolean));
    if HaveNested then begin
      Loop := FNested.Count;
      WriteBuffer(Loop, SizeOf(Integer));
      for Loop := 0 to FNested.Count - 1 do FNested[Loop].SaveToStream(Stream);
    end;
    Loop := Length(FPhone);
    WriteBuffer(Loop, SizeOf(Integer));
    WriteBuffer(PChar(FPhone)^, Loop);
    WriteBuffer(FReference, SizeOf(Byte));
    Loop := Length(FServiceCenter);
    WriteBuffer(Loop, SizeOf(Integer));
    WriteBuffer(PChar(FServiceCenter)^, Loop);
    WriteBuffer(FSmsType, SizeOf(TBFSMSType));
    WriteBuffer(FStatus, SizeOf(TBFSMSStatus));
    Loop := Length(FText);
    WriteBuffer(Loop, SizeOf(Integer));
    WriteBuffer(PChar(FText)^, Loop);
  end;
end;

{ TBFSMSes }

procedure TBFSMSes.Assign(AList: TBFSMSes);
var
  Loop: Integer;
  ASMS: TBFSMS;
begin
  FList.Clear;

  if Assigned(AList) then
    for Loop := 0 to AList.Count - 1 do begin
      ASMS := TBFSMS.Create;
      ASMS.Assign(AList[Loop]);
      FList.Add(ASMS);
    end;
end;

constructor TBFSMSes.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFSMSes.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFSMSes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFSMSes.GetSMS(const Index: Integer): TBFSMS;
begin
  Result := TBFSMS(FList[Index]);
end;

{ TBFKeypadEventThread }

procedure TBFSMSEventThread.CheckEvents;
const
  CMTI_EVENT = CRLF + '+CMTI:';
  CDSI_EVENT = CRLF + '+CDSI:';
  CKEV_EVENT = CRLF + '+CKEV:';

  procedure CheckSMSEvents(Ev: string);
  var
    OldBuf: TBFByteArray;
    Position: Integer;
    MemStr: string;
    Ndx: Integer;
    Mem: TBFSMSMemory;
    TmpBuf: TBFByteArray;
    Event: string;
    Loop: Integer;
  begin
    OldBuf := FBuffer;
    Position := Pos(Ev, string(FBuffer)) - 1;

    while Position >= 0 do begin
      TmpBuf := Copy(FBuffer, Position + 2, Length(FBuffer) - Position - 2);
      if Position > 0 then
        FBuffer := Copy(FBuffer, 0, Position)
      else
        SetLength(FBuffer, 0);

      Position := Pos(CRLF, string(TmpBuf)) - 1;
      if Position < 0 then begin
        FBuffer := OldBuf;
        Break;
      end;

      Event := Copy(string(TmpBuf), 1, Position);

      if Position + 2 <= Length(TmpBuf) then begin
        TmpBuf := Copy(TmpBuf, Position + 2, Length(TmpBuf));

        for Loop := 0 to Length(TmpBuf) - 1 do begin
          SetLength(FBuffer, Length(FBuffer) + 1);
          FBuffer[Length(FBuffer) - 1] := TmpBuf[Loop];
        end;
      end;

      if Event <> '' then begin
        Event := Copy(Event, Pos('"', Event) + 1, Length(Event));
        MemStr := Trim(Copy(Event, 1, Pos('"', Event) - 1));
        Event := Trim(Copy(Event, Pos(',', Event) + 1, Length(Event)));
        Ndx := StrToInt(Event);
        if MemStr = 'SM' then
          Mem := mmSIM
        else
          if MemStr = 'ME' then
            Mem := mmDevice
          else
            if MemStr = 'MT' then
              Mem := mmBoth
            else
              Mem := mmUnknown;

        if Ev = CMTI_EVENT then
          PostMessage(FClient.Wnd, BFNM_SMS_DELIVER_EVENT, Integer(Mem), Ndx)

        else
          PostMessage(FClient.Wnd, BFNM_SMS_REPORT_EVENT, Integer(Mem), Ndx)
      end;

      Position := Pos(Ev, string(FBuffer)) - 1;
    end;
  end;

  procedure CheckKeypadEvent;
  var
    OldBuf: TBFByteArray;
    Position: Integer;
    Event: string;
    TmpBuf: TBFByteArray;
    Loop: Integer;
    KeyStr: string;
    Key: TBFKey;
    Ev: Byte;
  begin
    OldBuf := FBuffer;
    Position := Pos(CKEV_EVENT, string(FBuffer)) - 1;

    while Position >= 0 do begin
     TmpBuf := Copy(FBuffer, Position + 2, Length(FBuffer) - Position - 2);
      if Position > 0 then
        FBuffer := Copy(FBuffer, 0, Position)
      else
        SetLength(FBuffer, 0);

      Position := Pos(CRLF, string(TmpBuf)) - 1;
      if Position < 0 then begin
        FBuffer := OldBuf;
        Break;
      end;

      Event := Copy(string(TmpBuf), 1, Position);

      if Position + 2 <= Length(TmpBuf) then begin
        TmpBuf := Copy(TmpBuf, Position + 2, Length(TmpBuf));

        for Loop := 0 to Length(TmpBuf) - 1 do begin
          SetLength(FBuffer, Length(FBuffer) + 1);
          FBuffer[Length(FBuffer) - 1] := TmpBuf[Loop];
        end;
      end;

      if Event <> '' then begin
        if Pos('"', Event) > 0 then
          Event := AnsiUppercase(Trim(Copy(Event, Pos('"', Event) + 1, Length(Event))))
        else
          Event := AnsiUppercase(Trim(Copy(Event, Pos(':', Event) + 1, Length(Event))));
        if Pos('"', Event) > 0 then
          KeyStr := Copy(Event, 1, Pos('"', Event) - 1)
        else
          KeyStr := Copy(Event, 1, Pos(',', Event) - 1);
        Event := Trim(Copy(Event, Pos(',', Event) + 1, Length(Event)));
        Ev := StrToInt(Event);
        Key := _CharToKey(KeyStr);

        PostMessage(FClient.Wnd, BFNM_KEYPAD_EVENT, Integer(Key), Ev);
      end;

      Position := Pos(CKEV_EVENT, string(FBuffer)) - 1;
    end;
  end;

begin
  CheckSMSEvents(CMTI_EVENT);
  CheckSMSEvents(CDSI_EVENT);
  CheckKeypadEvent;

  inherited;
end;

procedure TBFSMSes.LoadFromFile(FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  LoadFromStream(Stream);
  Stream.Free;
end;

procedure TBFSMSes.LoadFromStream(Stream: TStream);
var
  Loop: Integer;
  ASMS: TBFSMS;
begin
  FList.Clear;

  Stream.ReadBuffer(Loop, SizeOf(Integer));

  while Loop > 0 do begin
    ASMS := TBFSMS.Create;
    ASMS.LoadFromStream(Stream);
    FList.Add(ASMS);
    Dec(Loop);
  end;
end;

procedure TBFSMSes.SaveToFile(FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  SaveToStream(STream);
  Stream.Free;
end;

procedure TBFSMSes.SaveToStream(Stream: TStream);
var
  Loop: Integer;
begin
  Loop := Count;
  Stream.WriteBuffer(Loop, SizeOf(Integer));
  for Loop := 0 to Count - 1 do SMS[Loop].SaveToStream(Stream);
end;

{ TBFGSMModemClient }

procedure TBFGSMModemClient.BeginMassSending;
var
  Resp: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  if FMassSendingStarted then raise Exception.Create(StrSMSMassSendingStarted);

  ExecuteATCommand('AT+CMMS=2', Resp);

  FMassSendingStarted := True;
end;

procedure TBFGSMModemClient.BFNMKeypadEvent(var Message: TMessage);
var
  Key: TBFKey;
  Event: Byte;
begin
  Key := TBFKey(Message.WParam);
  Event := Byte(Lo(Message.LParam));

  case Event of
    0: DoUp(Key);
    1: DoDown(Key);
  end;

  Message.Result := Integer(True);
end;

procedure TBFGSMModemClient.BFNMSMSDeliverEvent(var Message: TMessage);
var
  Ndx: Integer;
  Memory: TBFSMSMemory;
begin
  Ndx := Message.LParam;
  Memory := TBFSMSMemory(Message.WParam);

  if Assigned(FOnNew) then
    try
      FOnNew(Self, mtDeliver, Memory, Ndx);
    except
    end;

  Message.Result := Integer(True);
end;

procedure TBFGSMModemClient.BFNMSMSReportEvent(var Message: TMessage);
var
  Ndx: Integer;
  Memory: TBFSMSMemory;
begin
  Ndx := Message.LParam;
  Memory := TBFSMSMemory(Message.WParam);

  if Assigned(FOnNew) then
    try
      FOnNew(Self, mtDeliverReport, Memory, Ndx);
    except
    end;

  Message.Result := Integer(True);
end;

function TBFGSMModemClient.CharToKey(Char: string): TBFKey;
begin
  Result := _CharToKey(Char);
end;

procedure TBFGSMModemClient.CheckPhoneNumber(APhone: string);
var
  Loop: Integer;
begin
  // Checking phone number.
  for Loop := 1 to Length(APhone) do
    if not IsDelimiter('+0123456789', APhone, Loop) then
      raise Exception.Create(StrInvalidPhoneNumber);
end;

procedure TBFGSMModemClient.CheckSMSEnabled;
begin
  if not FSMSEnabled then raise Exception.Create(StrSMSNotSupported);
end;

function TBFGSMModemClient.ComposePDU(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ALong: Boolean; ANeedReport: Boolean; ACnt: Byte; ANdx: Byte; ARef: Byte; var SCANumLength: Byte): string;
var
  SCALen: Byte;
  Num: string;
  Loop: Integer;
  Str: WideString;
  FirstByte: Byte;
  DCS: Byte;
  Temp: string;

  function MakeLongOrNot: string;
  begin
    if ALong then begin
      Result := IntToHex(SCALen + 6, 2);
      Result := Result + '050003' + IntToHex(ARef, 2) + IntToHex(ACnt, 2) + IntToHex(ANdx, 2);

    end else
      Result := IntToHex(SCALen, 2);
  end;

  function Encode7Bit(Txt: string): string;
  var
    Loop: Integer;
    Ndx: Integer;
  begin
    Result := '';

    Ndx := 1;
    Loop := 0;
    while Ndx <= Length(Txt) do begin
      if Ndx = Length(Txt) then
        Result := Result + IntToHex(Ord(Txt[Ndx]) shr (Loop mod 7) and $7F, 2)
        
      else
        Result := Result + IntToHex((Ord(Txt[Ndx]) shr (Loop mod 7) and $7F) or (Ord(Txt[Ndx + 1]) shl (7 - (Loop mod 7)) and $FF), 2);

      if Loop mod 7 = 6 then Inc(Ndx);

      Inc(Ndx);
      Inc(Loop);
    end;
  end;

begin
  // Preparing.
  Result := '';
  SCANumLength := 0;

  RaiseNotActive;

  // Check params.
  if AServiceCenter <> '' then CheckPhoneNumber(AServiceCenter);
  if APhone <> '' then CheckPhoneNumber(APhone);
  if AText = '' then raise Exception.Create(StrSMSTextRequire);

  // Encode service center number. (SCA)
  if AServiceCenter = '' then begin
    Result := '00';
    SCANumLength := 2;

  end else begin
    // Encode number type.
    if AServiceCenter[1] = '+' then begin
      AServiceCenter := Copy(AServiceCenter, 2, Length(AServiceCenter));
      Num := '91';
    end else
      Num := '81';

    if Length(AServiceCenter) mod 2 <> 0 then AServiceCenter := AServiceCenter + 'F';

    Loop := 1;
    while Loop <= Length(AServiceCenter) do begin
      Num := Num + AServiceCenter[Loop + 1] + AServiceCenter[Loop];
      Inc(Loop, 2);
    end;

    SCALen := Round(Length(Num) / 2);
    Result := IntToHex(SCALen, 2) + Num;
    SCANumLength := Length(Num) + 2;
  end;

  // Encode SMS flags. (PDU-type)
  FirstByte := $11;
  if ALong then FirstByte := FirstByte or $40;
  if ANeedReport and ((not ALong) or (ALong and (ACnt = ANdx))) then FirstByte := FirstByte or $20;
  Result := Result + IntToHex(FirstByte, 2) + '00';

  // Encode phone number. (DA)
  if APhone <> '' then begin
    if APhone[1] = '+' then begin
      APhone := Copy(APhone, 2, Length(APhone));
      Num := '91';
    end else
      Num := '81';

    if Length(APhone) mod 2 <> 0 then APhone := APhone + 'F';

    Loop := 1;
    while Loop <= Length(APhone) do begin
      Num := Num + APhone[Loop + 1] + APhone[Loop];
      Inc(Loop, 2);
    end;

    SCALen := Length(Num) - 2;
    if Num[Length(Num) - 1] = 'F' then SCALen := SCALen - 1;
    Result := Result + IntToHex(SCALen, 2) + Num;

  end else
    Result := Result + '0081';

  // PID
  Result := Result + '00';

  // Compose DCS
  // Encoding.
  case FEncoding of
    se8Bit: DCS := $04;
    seUnicode: DCS := $08;
    se7Bit: DCS := $00;

  else
    DCS := $00; // makes compiler happy.
    FEncoding := se7Bit;
  end;

  // Flash
  if AFlash then DCS := DCS or $10;

  // Set DCS
  Result := Result + IntToHex(DCS, 2);

  // Valid period (VP)
  Result := Result + IntToHex(FValidPeriod, 2);
  // ====== End of changes

  // UDL and UD.
  // Well. Case may be better but...
  if FEncoding = se8Bit then begin
    // 8bit encoding.
    SCALen := Length(AText);

    // Encode long SMS flags.
    Result := Result + MakeLongOrNot;

    // Encode SMS text.
    for Loop := 1 to SCALen do Result := Result + IntToHex(Ord(AText[Loop]), 2);

  end else
    if FEncoding = seUnicode then begin
      // Unicode encoding.
      SCALen := Length(AText) * 2;
      Str := WideString(AText);

      // Encode long SMS flags.
      Result := Result + MakeLongOrNot;

      // Encode SMS text.
      for Loop := 1 to Length(Str) do begin
        Result := Result + IntToHex(Hi(Ord(Str[Loop])), 2);
        Result := Result + IntToHex(Lo(Ord(Str[Loop])), 2);
      end;

    end else begin
      // 7 Bit.
      Temp := '';

      if ALong then begin
        SetLength(Temp, 7);
        for Loop := 1 to 7 do Temp[Loop] := #00;
      end;

      for Loop := 1 to Length(AText) do Temp := Temp + AText[Loop];
      AText := Encode7Bit(Temp);

      if ALong then AText := Copy(AText, 13, Length(AText));

      // Encode long SMS flags.
      SCALen := Length(Temp);
      if ALong then SCALen := SCALen - 6;
      Result := Result + MakeLongOrNot;

      // Encode SMS text.
      Result := Result + AText;
    end;
end;

constructor TBFGSMModemClient.Create(AOwner: TComponent);
begin
  FKeypadSupported := False;
  FMassSendingStarted := False;
  FSMSEnabled := False;

  inherited;

  FDisableATCommand := False;
  FEncoding := seUnicode;
  FValidPeriod := 255;
  
  // Initialization.
  FOnNew := nil;
  FOnPhonebookProgress := nil;
  FOnProgress := nil;
  FOnSendComplete := nil;
  FOnSendStart := nil;
  FOnDown := nil;
  FOnUp := nil;
end;

function TBFGSMModemClient.DecomposePDU(PDU: string; Index: Integer; Stat: Byte): TBFSMS;
var
  SCALen: Byte;
  SCAType: Byte;
  SCA: string;
  Ndx: Integer;
  Tmp: Char;
  PDUType: Byte;
  MTI: TBFSMSType;
  DCS: Byte;
  SCTS: string;
  ADate: string;
  ATime: string;
  HaveUDH: Boolean;
  UDHL: Byte;
  TmpUDH: string;
  UDH: string;
  UDHHdr: Byte;
begin
  if PDU <> '' then begin
    Result := TBFSMS.Create;
    Result.FIndex := Index;
    Result.FStatus := TBFSMSStatus(Stat + 1);

    SCALen := StrToInt('$' + PDU[1] + PDU[2]);
    PDU := Copy(PDU, 3, Length(PDU));
    if SCALen > 0 then begin
      SCALen := SCALen - 1;
      SCAType := StrToInt('$' + PDU[1] + PDU[2]);
      PDU := Copy(PDU, 3, Length(PDU));
      SCA := Copy(PDU, 1, SCALen * 2);
      PDU := Copy(PDU, SCALen * 2 + 1, Length(PDU));
      Ndx := 1;
      while Ndx < Length(SCA) do begin
        Tmp := SCA[Ndx];
        SCA[Ndx] := SCA[Ndx + 1];
        SCA[Ndx + 1] := Tmp;
        Inc(Ndx, 2);
      end;
      if SCA <> '' then
        if SCA[Length(SCA)] = 'F' then
          SetLength(SCA, Length(SCA) - 1);
      if SCAType = $91 then SCA := '+' + SCA;
      Result.FServiceCenter := SCA;
    end;

    PDUType := StrToInt('$' + PDU[1] + PDU[2]);
    PDU := Copy(PDU, 3, Length(PDU));

    MTI := mtNone;
    case PDUType and $03 of
      0: if Result.FStatus in [msRecUnread, msRecRead] then MTI := mtDeliver;
      1: if Result.FStatus in [msStoUnsent, msStoSent] then MTI := mtSubmit;
      2: if Result.FStatus in [msRecUnread, msRecRead] then MTI := mtDeliverReport;
    end;

    HaveUDH := PDUType and $40 <> 0;

    if MTI = mtNone then begin
      Result.Free;
      Result := nil;

    end else begin
      Result.FSmsType := MTI;

      if MTI in [mtSubmit, mtDeliverReport] then begin
        Result.FReference := StrToInt('$' + PDU[1] + PDU[2]);
        PDU := Copy(PDU, 3, Length(PDU));
      end;

      SCALen := StrToInt('$' + PDU[1] + PDU[2]);
      if Odd(SCALen) then Inc(SCALen);
      PDU := Copy(PDU, 3, Length(PDU));
      SCAType := StrToInt('$' + PDU[1] + PDU[2]);
      PDU := Copy(PDU, 3, Length(PDU));

      if SCALen > 0 then begin
        SCA := Copy(PDU, 1, SCALen);
        PDU := Copy(PDU, SCALen + 1, Length(PDU));
        // Text number!!!
        // Megafon uses $D0
        // Beeline uses $D1
        if SCAType in [$D0, $D1] then
          Result.FPhone := Decode7Bit(SCA, False)
        else begin
          // Standard or other number.
          Ndx := 1;
          while Ndx < Length(SCA) do begin
            Tmp := SCA[Ndx];
            SCA[Ndx] := SCA[Ndx + 1];
            SCA[Ndx + 1] := Tmp;
            Inc(Ndx, 2);
          end;
          if SCA <> '' then
            if SCA[Length(SCA)] = 'F' then
              SetLength(SCA, Length(SCA) - 1);
          if SCAType = $91 then SCA := '+' + SCA;
          Result.FPhone := SCA;
        end;

      end else
        Result.FPhone := '';

      if MTI = mtDeliverReport then begin
        Result.FText := '';

        SCTS := Copy(PDU, 1, 14);
        PDU := Copy(PDU, 15, Length(PDU));

        Result.FDate := SMSEncodeDate(SCTS[2] + SCTS[1], SCTS[6] + SCTS[5], SCTS[4] + SCTS[3], SCTS[8] + SCTS[7], SCTS[10] + SCTS[9], SCTS[12] + SCTS[11]);

        SCTS := Copy(PDU, 1, 14);
        ADate := SCTS[6] + SCTS[5] + '.' + SCTS[4] + SCTS[3] + '.' + SCTS[2] + SCTS[1];
        ATime := SCTS[8] + SCTS[7] + ':' + SCTS[10] + SCTS[9] + ':' + SCTS[12] + SCTS[11];
        Result.FText := ADate + ' ' + ATime;

      end else begin
        PDU := Copy(PDU, 3, Length(PDU));
        DCS :=  StrToInt('$' + PDU[1] + PDU[2]);
        PDU := Copy(PDU, 3, Length(PDU));

        if MTI  = mtDeliver then begin
          SCTS := Copy(PDU, 1, 14);
          PDU := Copy(PDU, 15, Length(PDU));
        end else begin
          case PDUType and $18 of
            $10: PDU := Copy(PDU, 3, Length(PDU));
            $18: PDU := Copy(PDU, 15, Length(PDU));
          end;
          SCTS := '';
        end;
        if SCTS <> '' then Result.FDate := SMSEncodeDate(SCTS[2] + SCTS[1], SCTS[6] + SCTS[5], SCTS[4] + SCTS[3], SCTS[8] + SCTS[7], SCTS[10] + SCTS[9], SCTS[12] + SCTS[11]);

        PDU := Copy(PDU, 3, Length(PDU));

        TmpUDH := '';
        if HaveUDH then begin
          UDHL := StrToInt('$' + PDU[1] + PDU[2]);
          if UDHL > 0 then begin
            UDH := Copy(PDU, 3, UDHL * 2);
            TmpUDH := PDU[1] + PDU[2] + UDH;
            PDU := Copy(PDU, UDHL * 2 + 3, Length(PDU));

            while UDH <> '' do begin
              UDHHdr := StrToInt('$' + UDH[1] + UDH[2]);
              UDH := Copy(UDH, 3, Length(UDH));

              case UDHHdr of
                0: begin
                     UDH := Copy(UDH, 3, Length(UDH));
                     with Result do begin
                       FLongReference := StrToInt('$' + UDH[1] + UDH[2]);
                       FLongCount := StrToInt('$' + UDH[3] + UDH[4]);
                       FLongIndex := StrToInt('$' + UDH[5] + UDH[6]);
                     end;
                     UDH := '';
                   end;
                8: begin
                     UDH := Copy(UDH, 5, Length(UDH));
                     with Result do begin
                       FLongReference := StrToInt('$' + UDH[1] + UDH[2]);
                       FLongCount := StrToInt('$' + UDH[3] + UDH[4]);
                       FLongIndex := StrToInt('$' + UDH[5] + UDH[6]);
                     end;
                     UDH := '';
                  end
              else
                UDHHdr := StrToInt('$' + UDH[1] + UDH[2]);
                if 3 + UDHHdr * 2 >= Length(UDH) then
                  UDH := ''

                else
                  UDH := Copy(UDH, UDHHdr * 2 + 3, Length(UDH));
              end;
            end;
            
          end else
            UDH := '';
        end;

        case DCS and $0C of
          0: begin
               Result.FText := Decode7Bit(TmpUDH + PDU, TmpUDH <> '');
               Result.FEncoding := se7Bit;
             end;
          4: begin
               Result.FText := Decode8Bit(PDU);
               Result.FEncoding := se8Bit;
             end;
          8: begin
               Result.FText := DecodeUTF2(PDU);
               Result.FEncoding := seUnicode;
             end;  
        end;
      end;
    end;

  end else
    Result := nil;
end;

procedure TBFGSMModemClient.DeleteSMS(Index: Integer);
var
  Resp: string;
begin
  RaiseNotActive;
  
  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  // Delete SMS.
  ExecuteATCommand('AT+CMGD=' + IntToStr(Index), Resp);
end;

procedure TBFGSMModemClient.DoDown(Key: TBFKey);
begin
  if Assigned(FOnDown) then
    try
      FOnDown(Self, Key);

    except
    end;
end;

procedure TBFGSMModemClient.DoUp(Key: TBFKey);
begin
  if Assigned(FOnUp) then
    try
      FOnUp(Self, Key);

    except
    end;
end;

procedure TBFGSMModemClient.EndMassSending;
var
  Resp: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  if not FMassSendingStarted then raise Exception.Create(StrSMSMassSendingNotStarted);

  ExecuteATCommand('AT+CMMS=0', Resp);

  FMassSendingStarted := False;
end;

function TBFGSMModemClient.GetBatteryCharge: TBFBatteryCharge;
var
  Resp: string;
  Tmp: string;
  Loop: Integer;
  Err: Boolean;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  FillChar(Result, SizeOf(TBFBatteryCharge), 0);

  // Is command supported
  try
    ExecuteATCommand('AT+CBC?', Resp);
    Err := False;
  except
    Err := True;
  end;

  // Try ohter command.
  if Err then begin
    try
      ExecuteATCommand('AT+CBC', Resp);
      Err := False;
    except
      Err := True;
    end;
  end;

  // If readed then decode.
  if not Err then begin
    Resp := Trim(Copy(Resp, Pos('+CBC: ', Resp) + 6, Length(Resp)));
    Tmp := Trim(Copy(Resp, 1, Pos(',', Resp) - 1));
    try
      case StrToInt(Tmp) of
        0: Result.PowerSupply := psBattery;
        1: Result.PowerSupply := psNotBattery;
        2: Result.PowerSupply := psNoBattery;
      else
        Result.PowerSupply := psError;
      end;

    except
      Result.PowerSupply := psError;
    end;

    Tmp := '';
    Resp := Trim(Copy(Resp, Pos(',', Resp) + 1, Length(Resp)));
    for Loop := 1 to Length(Resp) do
      if IsDelimiter('0123456789', Resp, Loop) then
        Tmp := Tmp + Resp[Loop]
      else
        Break;

    try
      Result.Percent := StrToInt(Tmp);
    except
    end;
  end;
end;

function TBFGSMModemClient.GetClock: string;
var
  Resp: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  try
    ExecuteATCommand('AT+CCLK?', Resp);
    Resp := Copy(Resp, Pos('+CCLK: "', Resp) + 8, Length(Resp));
    Delete(Resp, Pos('"', Resp), Length(Resp));
    Result := Resp;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetIMEI: string;
var
  Resp: string;
  Strings: TStringList;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CGSN', Resp);

    Strings := TStringList.Create;
    Strings.Text := Resp;

    try
      Result := Strings[2];
    except
      Result := '';
    end;

    Strings.Free;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetIMSI: string;
var
  Resp: string;
  Strings: TStringList;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CIMI', Resp);

    Strings := TStringList.Create;
    Strings.Text := Resp;

    try
      Result := Strings[2];

    except
      Result := '';
    end;

    Strings.Free;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetKeypadSupported: Boolean;
begin
  RaiseNotActive;

  Result := FKeypadSupported;
end;

function TBFGSMModemClient.GetManufacturer: string;
var
  Resp: string;
  Strings: TStringList;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CGMI', Resp);

    Strings := TStringList.Create;
    Strings.Text := Resp;

    try
      Result := Strings[2];
    except
      Result := '';
    end;

    Strings.Free;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetModel: string;
var
  Resp: string;
  Strings: TStringList;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CGMM', Resp);

    Strings := TStringList.Create;
    Strings.Text := Resp;

    try
      Result := Strings[2];
    except
      Result := '';
    end;

    Strings.Free;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetPhonebook: TBFPhoneBook;
var
  Res: string;
begin
  RaiseNotActive;

  Result := phSIMFixDialing;

  if FDisableATCommand then Exit;

  ExecuteATCommand('AT+CPBS?', Res);

  if Pos('FD', Res) > 0 then
    Result := phSIMFixDialing
  else
    if Pos('SM', Res) > 0 then
      Result := phSIM
    else
      if Pos('ME', Res) > 0 then
        Result := phME
      else
        if Pos('DC', Res) > 0 then
          Result := phMEDialed
        else
          if Pos('ON', Res) > 0 then
            Result := phOwnNumber
          else
            if Pos('LD', Res) > 0 then
              Result := phSIMLastDialing
            else
              if Pos('MC', Res) > 0 then
                Result := phMEMissed
              else
                if Pos('MC', Res) > 0 then
                  Result := phMEMissed
                else
                  if Pos('RC', Res) > 0 then
                    Result := phMEReceived
                  else
                    raise Exception.Create(StrUnknowPhonebook);
end;

function TBFGSMModemClient.GetPhonebookRecordsCount: Integer;
var
  Res: string;
  FirstStr: string;
  LastStr: string;
  First: Integer;
  Last: Integer;
begin
  Result := 0;
  
  RaiseNotActive;

  if FDisableATCommand then Exit;

  ExecuteATCommand('AT+CPBW=?', Res);

  Res := Trim(Res);

  Res := Trim(Copy(Res, Pos('+CPBW: (', Res) + 8, Length(Res)));
  FirstStr := Trim(Copy(Res, 1, Pos('-', Res) - 1));

  Res := Trim(Copy(Res, Pos('-', Res) + 1, Length(Res)));
  LastStr := Trim(Copy(Res, 1, Pos(')', Res) - 1));

  First := StrToInt(FirstStr);
  Last :=  StrToInt(LastStr);

  Result := Last - First;
end;

function TBFGSMModemClient.GetPrefferedMemory(const MemoryType: TBFSMSMemoryType): TBFSMSMemory;
var
  Resp: string;
  ReadMem: string;
  WriteMem: string;
  RecMem: string;
begin
  RaiseNotActive;

  Result := mmUnknown;

  if FDisableATCommand then Exit;
  
  CheckSMSEnabled;

  // Get preferred memories.
  ExecuteATCommand('AT+CPMS?', Resp);

  // Decode ReadDelete memory
  Resp := Copy(Resp, Pos('"', Resp) + 1, Length(Resp));
  ReadMem := AnsiUppercase(Trim(Copy(Resp, 1, Pos('"', Resp) - 1)));
  Resp := Copy(Resp, Pos('"', Resp) + 1, Length(Resp));
  Resp := Copy(Resp, Pos('"', Resp) + 1, Length(Resp));

  // Decode writeSend memory
  WriteMem := AnsiUppercase(Trim(Copy(Resp, 1, Pos('"', Resp) - 1)));
  Resp := Copy(Resp, Pos('"', Resp) + 1, Length(Resp));
  Resp := Copy(Resp, Pos('"', Resp) + 1, Length(Resp));

  // Decode Receice memory.
  RecMem := AnsiUppercase(Trim(Copy(Resp, 1, Pos('"', Resp) - 1)));

  // Preparing result.
  case MemoryType of
    mmtReadDelete: Result := StrToMemory(ReadMem);
    mmtWriteSend: Result := StrToMemory(WriteMem);
    mmtReceive: Result := StrToMemory(RecMem);
  else
    Result := mmUnknown;
  end;
end;

function TBFGSMModemClient.GetServiceCenter: string;
var
  Plus: Boolean;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  CheckSMSEnabled;

  // Get Service center number.
  ExecuteATCommand('AT+CSCA?', Result);

  // Decode result.
  Result := AnsiUppercase(Trim(Result));
  Plus := (Pos(',145', Result) > 0) or (Pos(', 145', Result) > 0);
  Result := Copy(Result, Pos('+CSCA: "', Result) + 8, Length(Result) - Pos('+CSCA: "', Result) - 8);
  Result := Copy(Result, 1, Pos('"', Result) - 1);

  if Plus and (Pos('+', Result) = 0) then Result := '+' + Result;
end;

function TBFGSMModemClient.GetSignal: Byte;
var
  Resp: string;
begin
  RaiseNotActive;

  Result := 0;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CSQ', Resp);

    Resp := Copy(Resp, Pos('CSQ: ', Resp) + 4, Length(Resp));
    Resp := Copy(Resp, 1, Pos(',', Resp) - 1);
    Resp := Trim(Resp);
    Result := StrToInt(Resp);

  except
    Result := 99;
  end;
end;

function TBFGSMModemClient.GetSoftVersion: string;
var
  Resp: string;
  Strings: TStringList;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  try
    ExecuteATCommand('AT+CGMR', Resp);

    Strings := TStringList.Create;
    Strings.Text := Resp;

    try
      Result := Strings[2];
    except
      Result := '';
    end;

    Strings.Free;

  except
    Result := '';
  end;
end;

function TBFGSMModemClient.GetSupportedMemories(const MemoryType: TBFSMSMemoryType): TBFSMSMemories;
var
  Resp: string;
  ReadMem: string;
  WriteMem: string;
  RecMem: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  CheckSMSEnabled;

  // Asks for supported memories.
  ExecuteATCommand('AT+CPMS=?', Resp);
  Resp := AnsiUppercase(Trim(Copy(Resp, Pos(':', Resp) + 2, Length(Resp))));

  // Decode ReadDelete memory.
  ReadMem := Copy(Resp, 1, Pos('),', Resp) - 1);
  Resp := Copy(Resp, Pos('),', Resp) + 2, Length(Resp));

  // Decode WriteSend memoty.
  WriteMem := Copy(Resp, 1, Pos('),', Resp) - 1);
  Resp := Copy(Resp, Pos('),', Resp) + 2, Length(Resp));

  // Decode Receive memory.
  RecMem := Resp;

  // Preparing result.
  Result := [];

  case MemoryType of
    mmtReadDelete: Resp := ReadMem;
    mmtWriteSend: Resp := WriteMem;
    mmtReceive: Resp := RecMem;
  else
    Resp := '';
  end;

  if Pos('ME', Resp) > 0 then Result := Result + [mmDevice];
  if Pos('SM', Resp) > 0 then Result := Result + [mmSIM];
  if Pos('MT', Resp) > 0 then Result := Result + [mmBoth];
end;

function TBFGSMModemClient.GetSupportedPhonebooks: TBFPhoneBooks;
var
  Res: string;
begin
  Result := [];

  RaiseNotActive;

  if FDisableATCommand then Exit;

  ExecuteATCommand('AT+CPBS=?', Res);

  if Pos('FD', Res) > 0 then Result := Result + [phSIMFixDialing];
  if Pos('SM', Res) > 0 then Result := Result + [phSIM];
  if Pos('ME', Res) > 0 then Result := Result + [phME];
  if Pos('DC', Res) > 0 then Result := Result + [phMEDialed];
  if Pos('ON', Res) > 0 then Result := Result + [phOwnNumber];
  if Pos('LD', Res) > 0 then Result := Result + [phSIMLastDialing];
  if Pos('MC', Res) > 0 then Result := Result + [phMEMissed];
  if Pos('MC', Res) > 0 then Result := Result + [phMEMissed];
  if Pos('RC', Res) > 0 then Result := Result + [phMEReceived];
end;

function TBFGSMModemClient.GetThreadClass: TBFClientReadThreadClass;
begin
  Result := TBFSMSEventThread;
end;

procedure TBFGSMModemClient.InternalClose;
begin
  inherited;

  FKeypadSupported := False;
end;

function TBFGSMModemClient.InternalMakeSMS(Send: Boolean; AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Integer;
const
  SMS_LENGTH_UNICODE = 66;
  SMS_LENGTH_8BIT    = 116;
  SMS_LENGTH_7BIT    = 145;

var
  Ref: Byte;
  Cnt: Byte;
  Long: Boolean;
  Ndx: Byte;
  Tmp: string;
  PDU: string;
  SCANumLength: Byte;
  Cmd: string;
  Resp: string;
  FirstIndex: Integer;
  Posi: Integer;
  ASize: Byte;
begin
  Result := 0;

  if FDisableATCommand then Exit;

  FirstIndex := -1;

  CheckSMSEnabled;
  RaiseNotActive;

  // Make long SMS reference.
  Ref := Round(Random(255));

  case FEncoding of
    se8Bit: ASize := SMS_LENGTH_8BIT;
    seUnicode: ASize := SMS_LENGTH_UNICODE;
    se7Bit: begin
              ASize := SMS_LENGTH_7BIT;
              AText := ConvertASCIIToGSM(AText);
            end;
  else
    ASize := SMS_LENGTH_7BIT; // Makes compiler happy
  end;

  // Calculate SMS numbers.
  if Length(AText) <= ASize then
    Cnt := 1

  else begin
    Cnt := Trunc(Length(AText) / ASize);
    if Trunc(Length(AText) / ASize) <> Length(AText) / ASize then Inc(Cnt);
  end;

  // Is long?
  Long := Cnt > 1;

  if Assigned(FOnSendStart) then
    try
      FOnSendStart(Self, Cnt);
    except
    end;

  // Making SMSes.
  for Ndx := 1 to Cnt do begin
    if Assigned(FOnProgress) then FOnProgress(Self, Ndx, Cnt);

    // Prepare SMS text.
    if Cnt = 1 then
      Tmp := AText

    else begin
      Tmp := Copy(AText, 1, ASize);
      if Length(AText) <= ASize then
        AText := ''

      else
        AText := Copy(AText, ASize + 1, Length(AText));
    end;

    // Preparing PDU.
    PDU := ComposePDU(AServiceCenter, APhone, Tmp, AFlash, Long, ANeedReport, Cnt, Ndx, Ref, SCANumLength);

    // Making command to send or save SMS.
    if Send then
      Cmd := 'AT+CMGS=' + IntToStr(Round((Length(PDU) - SCANumLength) / 2))

    else
      Cmd := 'AT+CMGW=' + IntToStr(Round((Length(PDU) - SCANumLength) / 2));

    // Prepare to send/save SMS..
    ExecuteATCommand(Cmd, Resp);
    // ...and writing PDU.
    ExecuteATCommand(PDU + CTRLZ, Resp);
    
    try
      Resp := AnsiUppercase(Resp);
      Posi := Pos('CMGW:', Resp);
      if Posi > 0 then begin
        Resp := Trim(Copy(Resp, Posi + 5, Length(Resp)));
        Resp := Trim(Copy(Resp, 1, Pos('OK', Resp) - 1));

      end else begin
        Posi := Pos('CMGS:', Resp);

        if Posi > 0 then begin
          Resp := Trim(Copy(Resp, Posi + 5, Length(Resp)));
          Resp := Trim(Copy(Resp, 1, Pos('OK', Resp) - 1));
        end;
      end;

      Result := StrToInt(Resp);
      if FirstIndex = -1 then FirstIndex := Result;

    except
    end;
  end;

  if Long and (not Send) then Result := FirstIndex;

  if Assigned(FOnSendComplete) then FOnSendComplete(Self, Result);
end;

procedure TBFGSMModemClient.InternalOpen;
var
  Resp: string;
  ModeStr: string;
  MTStr: string;
  BMStr: string;
  DSStr: string;
  CNMIStr: string;

  procedure ReplaceDef(var Str: string);
  var
    StartNum: Integer;
    EndNum: Integer;
    OldStr: string;
    Loop: Integer;
  begin
    OldStr := Str;

    try
      while Pos('-', Str) > 0 do begin
        StartNum := StrToInt(Copy(Str, Pos('-', Str) - 1, 1));
        EndNum := StrToInt(Copy(Str, Pos('-', Str) + 1, 1));

        Str := '';

        for Loop := StartNum to EndNum - 1 do Str := Str + IntToStr(Loop) + ',';

        Str := Str + IntToStr(EndNum);
      end;

    except
      Str := OldStr;
    end;
  end;
  
begin
  inherited;

  try
    ExecuteATCommand('ATE1', Resp);
  except
  end;

  try
    ExecuteATCommand('ATQ0', Resp);
  except
  end;

  try
    ExecuteATCommand('ATV1', Resp);
  except
  end;

  // Init Keypad
  // By default not supported.
  FKeypadSupported := False;

  // Try initialize client
  try
    ExecuteATCommand('AT+CKPD=?', Resp);
    // All OK. Feature suppoted.
    FKeypadSupported := True;

    ExecuteATCommand('AT+CMEC=2', Resp);

    // Try register events nofitication.
    try
      ExecuteATCommand('AT+CMER=2,1,0,0', Resp);

    except
      try
        ExecuteATCommand('AT+CMER=3,2,0,0', Resp);

      except
      end;
    end;

  except
  end;

  // Init SMS
  FSMSEnabled := False;

  // For nokia phones.
  try
    ExecuteATCommand('AT+CFUN=1', Resp);
  except
  end;

  try
    // Preparing for SMS PDU mode.
    ExecuteATCommand('AT+CMGF=0', Resp);

    FSMSEnabled := True;

    try
      // Check available SMS events.
      ExecuteATCommand('AT+CNMI=?', Resp);
      Resp := AnsiUppercase(Trim(Resp));

      // Decode responce.
      Resp := Copy(Resp, Pos('(', Resp) + 1, Length(Resp));
      ModeStr := Copy(Resp, 1, Pos(')', Resp) - 1);
      ReplaceDef(ModeStr);
      Resp := Copy(Resp, Pos('(', Resp) + 1, Length(Resp));
      MTStr := Copy(Resp, 1, Pos(')', Resp) - 1);
      ReplaceDef(MTStr);
      Resp := Copy(Resp, Pos('(', Resp) + 1, Length(Resp));
      BMStr := Copy(Resp, 1, Pos(')', Resp) - 1);
      ReplaceDef(BMStr);
      Resp := Copy(Resp, Pos('(', Resp) + 1, Length(Resp));
      DSStr := Copy(Resp, 1, Pos(')', Resp) - 1);
      ReplaceDef(DSStr);

      // Prepare command for notification enabling.
      CNMIStr := 'AT+CNMI=';
      if Pos('2', ModeStr) > 0 then
        CNMIStr := CNMIStr + '2'
      else
        if Pos('1', ModeStr) > 0 then
          CNMIStr := CNMIStr + '1'
        else
          CNMIStr := '';

      if CNMIStr <> '' then
        if Pos('1', MTStr) > 0 then
          CNMIStr := CNMIStr + ',1'
        else
          CNMIStr := CNMIStr + ',0';

      if CNMIStr <> '' then CNMIStr := CNMIStr + ',0';

      if CNMIStr <> '' then
        if Pos('2', DSStr) > 0 then
          CNMIStr := CNMIStr + ',2'
        else
          CNMIStr := CNMIStr + ',0';

      // Enable SMS notification
      if CNMIStr <> '' then ExecuteATCommand(CNMIStr, Resp);

    except
      // We can work without notification!
    end;

  except
  end;
end;

function TBFGSMModemClient.KeyToChar(Key: TBFKey): string;
begin
  Result := BF_KEYPAD_CHARS[Key];
end;

procedure TBFGSMModemClient.PushKey(Key: TBFKey; Time, Pause: Byte);
var
  Resp: string;
  ACmd: string;
begin
  if FDisableATCommand then Exit;
  
  if FKeypadSupported then begin
    ACmd := 'AT+CKPD=' + KeyToChar(Key);
    if Time > 0 then begin
      ACmd := ACmd + ', ' + IntToStr(Time);
      if Pause > 0 then ACmd := ACmd + ', ' + IntToStr(Pause);
    end;

    try
      ExecuteATCommand(ACmd, Resp);

    except
      ACmd := 'AT+CKPD="' + KeyToChar(Key) + '"';
      if Time > 0 then begin
        ACmd := ACmd + ', ' + IntToStr(Time);
        if Pause > 0 then ACmd := ACmd + ', ' + IntToStr(Pause);
      end;

      ExecuteATCommand(ACmd, Resp);
    end;
  end else
    raise Exception.Create(StrFeatureNotSupported);
end;

function TBFGSMModemClient.ReadPhonebook: TBFvCards;
var
  Res: string;
  FirstStr: string;
  LastStr: string;
  First: Integer;
  Last: Integer;
  Cmd: string;
  vCard: TBFvCard;
  Phone: string;
  AName: string;
  Err: Boolean;
  CharSetUnicode: Boolean;
  Ndx: Integer;
  Str: WideString;
  DefCharSet: string;
  Loop: Integer;
begin
  Result := nil;

  RaiseNotActive;

  if FDisableATCommand then Exit;

  // Detecting default character set
  ExecuteATCommand('AT+CSCS?', Res);

  Res := Copy(Res, Pos('"', Res) + 1, Length(Res));
  Res := Copy(Res, 1, Pos('"', Res) - 1);
  DefCharSet := Res;

  // Detect supported character sets
  ExecuteATCommand('AT+CSCS=?', Res);

  // And change it to needed.
  if Pos('UCS2', Res) > 0 then begin
    ExecuteATCommand('AT+CSCS="UCS2"', Res);

    CharSetUnicode := True;

  end else begin
    CharSetUnicode := False;

    if Pos('IRA', Res) > 0 then ExecuteATCommand('AT+CSCS="IRA"', Res);
  end;

  try
    Result := TBFvCards.Create;

    try
      // Reading phone book.
      ExecuteATCommand('AT+CPBR=?', Res);

      Res := Trim(Res);

      Res := Trim(Copy(Res, Pos('+CPBR: (', Res) + 8, Length(Res)));
      FirstStr := Trim(Copy(Res, 1, Pos('-', Res) - 1));

      Res := Trim(Copy(Res, Pos('-', Res) + 1, Length(Res)));
      LastStr := Trim(Copy(Res, 1, Pos(')', Res) - 1));

      First := StrToInt(FirstStr);
      Last :=  StrToInt(LastStr);

      for Loop := First to Last do begin
        if Assigned(FOnPhonebookProgress) then FOnPhonebookProgress(Self, Loop, Last);

        Cmd := 'AT+CPBR=' + IntToStr(Loop);

        Err := False;
        try
          ExecuteATCommand(Cmd, Res);

        except
          on E: Exception do begin
            if Pos('ERROR', E.Message) > 0 then
              Err := True

            else begin
              Result.Free;

              raise;
            end;
          end;
        end;

        if Err then Continue;

        if Pos('+CPBR', Res) > 0 then begin
          if Pos(',"', Res) = 0 then Continue;
          
          vCard := TBFvCard.Create;

          Res := Trim(Copy(Res, Pos(',"', Res) + 2, Length(Res)));
          Phone := Trim(Copy(Res, 1, Pos('",', Res) - 1));
          with vCard.TelecomInfo.Phone1 do begin
            Attributes := [ptPreferred];
            Number := Phone;
          end;

          Res := Trim(Copy(Res, Pos('",', Res) + 2, Length(Res)));
          if Pos(',', Res) > 0 then Res := Trim(Copy(Res, Pos(',', Res) + 1, Length(Res)));
          if Pos('"', Res) > 0 then Res := Trim(Copy(Res, Pos('"', Res) + 1, Length(Res)));
          if Pos('"', Res) > 0 then Res := Trim(Copy(Res, 1, Pos('"', Res) - 1));
          if Pos(CRLF, Res) > 0 then Res := Trim(Copy(Res, 1, Pos(CRLF, Res) - 1));

          AName := Trim(Res);

          // If unicode then decode it
          if CharSetUnicode then begin
            Ndx := 1;
            Str := '';

            while Ndx < Length(AName) do begin
              Str := Str + WideChar(StrToInt('$' + Copy(AName, Ndx, 4)));
              Inc(Ndx, 4);
            end;

            AName := string(Str);
          end;

          vCard.Identification.Name.FamilyName := AName;

          if (vCard.Identification.Name.FamilyName = '') and (vCard.TelecomInfo.Phone1.Number = '') then begin
            vCard.Free;

            Continue;
          end;

          Result.Add(vCard);
        end;
      end;

    except
      Result.Free;

      raise;
    end;

  finally
    // Restoring charset
    try
      ExecuteATCommand('AT+CSCS="' + DefCharSet + '"', Res);

    except
    end;
  end;
end;

function TBFGSMModemClient.ReadSMS(Index: Integer): TBFSMS;
var
  Resp: string;
  RespLines: TStringList;
  Loop: Integer;
  Stat: Byte;
  PDU: string;
begin
  Result := nil;

  RaiseNotActive;

  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  // Reading SMSes
  ExecuteATCommand('AT+CMGR=' + IntToStr(Index), Resp);

  RespLines := TStringList.Create;

  try
    with RespLines do begin
      Text := Resp;
      Delete(0);
      Delete(0);
      Delete(Count - 1);
      Delete(Count - 1);
    end;

  except
    RespLines.Clear;
  end;

  Loop := 0;

  try
    try
      while Loop <= RespLines.Count - 1 do begin
        Resp := RespLines[Loop];

        if Resp <> '' then begin
          Delete(Resp, 1, Pos(':', Resp));
          Resp := Trim(Resp);

          Stat := StrToInt(Copy(Resp, 1, Pos(',', Resp) - 1));
          Delete(Resp, 1, Pos(',', Resp));

          Inc(Loop);

          Resp := RespLines[Loop];
          PDU := Trim(Resp);
          if PDU <> '' then begin
            Result := DecomposePDU(PDU, Index, Stat);
            if Assigned(Result) then Break;
          end;
        end;

        Inc(Loop);
      end;

    finally
      RespLines.Free;
    end;

  except
    // If somthing wrong then clear result and re-reise exception.
    if Assigned(Result) then Result.Free;

    raise;
  end;
end;

function TBFGSMModemClient.ReadSMSes(SMSStatus: TBFSMSStatus; MakeNested: Boolean = True): TBFSMSes;
var
  Stat: Byte;
  Resp: string;
  RespLines: TStringList;
  Loop: Integer;
  Index: Integer;
  PDU: string;
  SMS: TBFSMS;
  Loop1: Integer;
  NewSMS: TBFSMS;
  Found: Boolean;
begin
  Result := nil;
  
  // Preparing.
  RaiseNotActive;

  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  if SMSStatus = msNone then
    raise Exception.Create(StrInvalidSMSType)
  else
    Stat := Byte(SMSStatus) - 1;

  // Reading SMSes
  ExecuteATCommand('AT+CMGL=' + IntToStr(Stat), Resp);

  RespLines := TStringList.Create;

  if Pos('+CMGL: ', Resp) > 0 then begin
    Resp := Copy(Resp, Pos('+CMGL: ', Resp), Length(Resp));

    if Pos(RESP_OK, Resp) > 0 then Resp := Copy(Resp, 1, Pos(RESP_OK, Resp) - 1);

  end else
     Resp := '';

  try
    RespLines.Text := Resp;

  except
    RespLines.Clear;
  end;

  Loop := 0;

  Result := TBFSMSes.Create;

  try
    try
      while Loop <= RespLines.Count - 1 do begin
        Resp := RespLines[Loop];

        if Resp <> '' then begin
          Delete(Resp, 1, Pos(':', Resp));
          Resp := Trim(Resp);

          Index := StrToInt(Copy(Resp, 1, Pos(',', Resp) - 1));
          Delete(Resp, 1, Pos(',', Resp));

          Stat := StrToInt(Copy(Resp, 1, Pos(',', Resp) - 1));

          Inc(Loop);

          try
            Resp := RespLines[Loop];
            PDU := Trim(Resp);
            if PDU <> '' then begin
              SMS := DecomposePDU(PDU, Index, Stat);
              if Assigned(SMS) then Result.FList.Add(SMS);
            end;

          except
          end;
        end;

        Inc(Loop);
      end;

    finally
      RespLines.Free;
    end;

  except
    // If somthing wrong then clear result and re-reise exception.
    Result.Free;
    raise;
  end;

  if MakeNested then begin
    // If we here then all OK. Now checks for long SMS and make it as nested.
    Loop := 0;
    while Loop < Result.Count do begin
      // Check is it long SMS?
      if (Result[Loop].FLongReference > 0) and (Result[Loop].FLongIndex = 1) and (Result[Loop].Nested.Count = 0) then begin
        // Searching SMS with same long reference number and type.
        // Also it must have long index = 0.
        Loop1 := 0;
        Found := False;
        while Loop1 < Result.Count do
          if (Result[Loop1].FLongReference = Result[Loop].FLongReference) and (Result[Loop1].FLongIndex > 1) and (Result[Loop1].FSmsType = Result[Loop].FSmsType) and (Result[Loop1].FStatus = Result[Loop].FStatus) then begin
            // If we found it then add current SMS as nested for new founded sms.
            NewSMS := TBFSMS.Create;
            NewSMS.Assign(Result[Loop1]);
            Result[Loop].FNested.FList.Add(NewSMS);
            Result.FList.Delete(Loop1);
            Found := True;

          end else
            Inc(Loop1);

        if Found then
          Loop := 0

        else
          Inc(Loop);

      end else
        Inc(Loop);
    end;
  end;
end;

function TBFGSMModemClient.SaveSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Integer;
begin
  Result := InternalMakeSMS(False, AServiceCenter, APhone, AText, AFlash, ANeedReport);
end;

function TBFGSMModemClient.SendSMS(AIndex: Integer; APhone: string; ANeedReport: Boolean): Byte;
var
  Resp: string;
begin
  Result := 0;
  
  RaiseNotActive;

  if FDisableATCommand then Exit;

  CheckSMSEnabled;

  // Check phone number.
  if APhone = '' then raise Exception.Create(StrPhoneNumberRequired);
  CheckPhoneNumber(APhone);

  // Compose command to send SMS.
  Resp :='AT+CMSS=' + IntToStr(AIndex) + ',"';
  if APhone[1] = '+' then begin
    APhone := Copy(APhone, 2, Length(APhone));
    Resp := Resp + APhone + '",145';
  end else
    Resp := Resp + APhone + '",129';

  // Sending SMS
  ExecuteATCommand(Resp, Resp);
  Resp := AnsiUppercase(Trim(Resp));

  // Decoding respons
  Resp := Copy(Resp, Pos(':', Resp) + 1, Length(Resp));
  Resp := Trim(Resp);
  Resp := Copy(Resp, 1, Pos(#$0D, Resp) - 1);
  Resp := Trim(Resp);

  // Returns reference number.
  try
    Result := StrToInt(Resp);
  except
    // ??? But sometimes no number.
    Result := 0;
  end;
end;

function TBFGSMModemClient.SendSMS(AServiceCenter: string; APhone: string; AText: string; AFlash: Boolean; ANeedReport: Boolean): Byte;
begin
  Result := InternalMakeSMS(True, AServiceCenter, APhone, AText, AFlash, ANeedReport);
end;

procedure TBFGSMModemClient.SetPhonebook(const Value: TBFPhoneBook);
var
  Res: string;
  Cmd: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;
  
  Cmd := 'AT+CPBS="';

  case Value of
    phSIMFixDialing: Cmd := Cmd + 'FD';
    phSIM: Cmd := Cmd + 'SM';
    phME: Cmd := Cmd + 'ME';
    phMEDialed: Cmd := Cmd + 'DC';
    phOwnNumber: Cmd := Cmd + 'ON';
    phSIMLastDialing: Cmd := Cmd + 'LD';
    phMEMissed: Cmd := Cmd + 'MC';
    phMEReceived: Cmd := Cmd + 'RC';
  end;

  Cmd := Cmd + '"';
  
  ExecuteATCommand(Cmd, Res);
end;

procedure TBFGSMModemClient.SetPrefferedMemory(const MemoryType: TBFSMSMemoryType; Value: TBFSMSMemory);
var
  Resp: string;
  ReadMem: TBFSMSMemory;
  WriteMem: TBFSMSMemory;
  RecMem: TBFSMSMemory;
  ReadMemStr: string;
  WriteMemStr: string;
  RecMemStr: string;
  NewMemStr: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  // Get current preffer.
  ReadMem := PrefferedMemory[mmtReadDelete];
  WriteMem := PrefferedMemory[mmtWriteSend];
  RecMem := PrefferedMemory[mmtReceive];

  // Checnge memory.
  case ReadMem of
    mmBoth: ReadMemStr := 'MT';
    mmDevice: ReadMemStr := 'ME';
    mmSIM: ReadMemStr := 'SM';
  else
    ReadMemStr := 'SM';
  end;

  case WriteMem of
    mmBoth: WriteMemStr := 'MT';
    mmDevice: WriteMemStr := 'ME';
    mmSIM: WriteMemStr := 'SM';
  else
    WriteMemStr := 'SM';
  end;

  case RecMem of
    mmBoth: RecMemStr := 'MT';
    mmDevice: RecMemStr := 'ME';
    mmSIM: RecMemStr := 'SM';
  else
    RecMemStr := 'SM';
  end;

  case Value of
    mmBoth: NewMemStr := 'MT';
    mmDevice: NewMemStr := 'ME';
    mmSIM: NewMemStr := 'SM';
  else
    NewMemStr := 'SM';
  end;

  // Preparing command.
  case MemoryType of
    mmtReadDelete: Resp := 'AT+CPMS="' + NewMemStr + '", "' + WriteMemStr + '", "' + RecMemStr + '"';
    mmtWriteSend: Resp := 'AT+CPMS="' + ReadMemStr + '", "' + NewMemStr + '", "' + RecMemStr + '"';
    mmtReceive: Resp := 'AT+CPMS="' + ReadMemStr + '", "' + WriteMemStr + '", "' + NewMemStr + '"';
  else
    Resp := '';
  end;

  // Sets preferred memory.
  if Resp <> '' then ExecuteATCommand(Resp, Resp);
end;

procedure TBFGSMModemClient.SetServiceCenter(const Value: string);
var
  Resp: string;
  PhoneType: string;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  // Checking phone number.
  CheckPhoneNumber(Value);

  // Decode number type.
  if (Length(Value) > 0) and (Value[1] = '+') then
    PhoneType := '145'
  else
    PhoneType := '129';

  // Setting number.
  ExecuteATCommand('AT+CSCA="' + Value + '", ' + PhoneType, Resp);
end;

function TBFGSMModemClient.SMSEncodeDate(AYear: String; ADay: String; AMonth: String; AHour: String; AMinute: String; ASecond: String): TDateTime;
var
  Year: Word;
  Day: Word;
  Month: Word;
  Hour: Word;
  Minute: Word;
  Second: Word;
begin
  try
    Year := StrToInt(AYear);
    if Year < 2000 then Year := 2000 + Year;
  except
    Year := 1900;
  end;

  try
    Month := StrToInt(AMonth);
  except
    Month := 1;
  end;

  try
    Day := StrToInt(ADay);
  except
    Day := 1;
  end;

  try
    Hour := StrToInt(AHour);
  except
    Hour := 0;
  end;

  try
    Minute := StrToInt(AMinute);
  except
    Minute := 0;
  end;

  try
    Second := StrToInt(ASecond);
  except
    Second := 0;
  end;

  {$IFDEF DELPHI5}
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Minute, Second, 0);
  {$ELSE}
  Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0);
  {$ENDIF}
end;

function TBFGSMModemClient.StrToMemory(Str: string): TBFSMSMemory;
begin
  if Str = 'SM' then
    Result := mmSIM
  else
    if Str = 'ME' then
      Result := mmDevice
    else
      if Str = 'MT' then
        Result := mmBoth
      else
        Result := mmUnknown;
end;

procedure TBFGSMModemClient.WritePhonebook(vCards: TBFvCards);
var
  Res: string;
  CharSetUnicode: Boolean;
  DefCharSet: string;
  FirstStr: string;
  LastStr: string;
  First: Integer;
  Last: Integer;
  Loop: Integer;
  Num: string;
  AName: string;
  Cmd: string;
  ChrPos: Integer;
  Ndx: Integer;
  UniStr: WideString;
begin
  RaiseNotActive;

  if FDisableATCommand then Exit;

  // Detecting default character set
  ExecuteATCommand('AT+CSCS?', Res);

  Res := Copy(Res, Pos('"', Res) + 1, Length(Res));
  Res := Copy(Res, 1, Pos('"', Res) - 1);
  DefCharSet := Res;

  // Detect supported character sets
  ExecuteATCommand('AT+CSCS=?', Res);

  // And change it to needed.
  if Pos('UCS2', Res) > 0 then begin
    ExecuteATCommand('AT+CSCS="UCS2"', Res);

    CharSetUnicode := True;

  end else begin
    CharSetUnicode := False;

    if Pos('IRA', Res) > 0 then ExecuteATCommand('AT+CSCS="IRA"', Res);
  end;

  try
    // Writing phone book.
    ExecuteATCommand('AT+CPBW=?', Res);

    Res := Trim(Res);

    Res := Trim(Copy(Res, Pos('+CPBW: (', Res) + 8, Length(Res)));
    FirstStr := Trim(Copy(Res, 1, Pos('-', Res) - 1));

    Res := Trim(Copy(Res, Pos('-', Res) + 1, Length(Res)));
    LastStr := Trim(Copy(Res, 1, Pos(')', Res) - 1));

    First := StrToInt(FirstStr);
    Last :=  StrToInt(LastStr);

    Ndx := First;
    Loop := 0;

    while Ndx <= Last do begin
      if Assigned(FOnPhonebookProgress) then FOnPhonebookProgress(Self, Ndx, Last);

      if Loop < vCards.Count then begin
        Num := vCards[Loop].TelecomInfo.Phone1.Number;
        AName := vCards[Loop].Identification.Name.FamilyName;

      end else begin
        Num := '';
        AName := '';
      end;

      if (Num = '') and (AName = '') then
        Cmd := 'AT+CPBW=' + IntToStr(Ndx)

      else begin
        Cmd := 'AT+CPBW=' + IntToStr(Ndx) + ',"' + Num + '",';
        if (Length(Num) > 0) and (Num[1] = '+') then
          Cmd := Cmd + '145,"'
        else
          Cmd := Cmd + '129,"';

        if not CharSetUnicode then
          Cmd := Cmd + AName + '"'

        else begin
          UniStr := WideString(AName);
          for ChrPos := 1 to Length(UniStr) do Cmd := Cmd + IntToHex(Ord(UniStr[ChrPos]), 4);

          Cmd := Cmd + '"';
        end;
      end;

      ExecuteATCommand(Cmd, Res);

      Inc(Loop);
      Inc(Ndx);
    end;

  finally
    // Restoring charset
    try
      ExecuteATCommand('AT+CSCS="' + DefCharSet + '"', Res);

    except
    end;
  end;
end;

{ TBFGSMModemClientX }

procedure _TBFGSMModemClientX.BeginMassSending;
begin
  TBFGSMModemClient(FBFCustomClient).BeginMassSending;
end;

function _TBFGSMModemClientX.CharToKey(Char: string): TBFKey;
begin
  Result := TBFGSMModemClient(FBFCustomClient).CharToKey(Char); 
end;

procedure _TBFGSMModemClientX.DeleteSMS(Index: Integer);
begin
  TBFGSMModemClient(FBFCustomClient).DeleteSMS(Index);
end;

procedure _TBFGSMModemClientX.EndMassSending;
begin
  TBFGSMModemClient(FBFCustomClient).EndMassSending;
end;

function _TBFGSMModemClientX.GetBatteryCharge: TBFBatteryCharge;
begin
  Result := TBFGSMModemClient(FBFCustomClient).BatteryCharge;
end;

function _TBFGSMModemClientX.GetClock: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Clock;
end;

function _TBFGSMModemClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFGSMModemClient;
end;

function _TBFGSMModemClientX.GetDisableATCommand: Boolean;
begin
  Result := TBFGSMModemClient(FBFCustomClient).DisableATCommand;
end;

function _TBFGSMModemClientX.GetEncoding: TBFSMSEncoding;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Encoding;
end;

function _TBFGSMModemClientX.GetIMEI: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).IMEI;
end;

function _TBFGSMModemClientX.GetIMSI: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).IMSI;
end;

function _TBFGSMModemClientX.GetKeypadSupported: Boolean;
begin
  Result := TBFGSMModemClient(FBFCustomClient).KeypadSupported;
end;

function _TBFGSMModemClientX.GetManufacturer: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Manufacturer;
end;

function _TBFGSMModemClientX.GetMassSendingStarted: Boolean;
begin
  Result := TBFGSMModemClient(FBFCustomClient).MassSendingStarted;
end;

function _TBFGSMModemClientX.GetModel: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Model;
end;

function _TBFGSMModemClientX.GetOnDown: TBFKeypadEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnDown;
end;

function _TBFGSMModemClientX.GetOnNew: TBFSMSNewEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnNew;
end;

function _TBFGSMModemClientX.GetOnPhonebookProgress: TBFSMSProgressEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnPhonebookProgress;
end;

function _TBFGSMModemClientX.GetOnProgress: TBFSMSProgressEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnProgress;
end;

function _TBFGSMModemClientX.GetOnSendComplete: TBFSMSEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnSendComplete;
end;

function _TBFGSMModemClientX.GetOnSendStart: TBFSMSSendStartEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnSendStart;
end;

function _TBFGSMModemClientX.GetOnUp: TBFKeypadEvent;
begin
  Result := TBFGSMModemClient(FBFCustomClient).OnUp;
end;

function _TBFGSMModemClientX.GetPhonebook: TBFPhoneBook;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Phonebook;
end;

function _TBFGSMModemClientX.GetPhonebookRecordsCount: Integer;
begin
  Result := TBFGSMModemClient(FBFCustomClient).PhonebookRecordsCount;
end;

function _TBFGSMModemClientX.GetPrefferedMemory(const MemoryType: TBFSMSMemoryType): TBFSMSMemory;
begin
  Result := TBFGSMModemClient(FBFCustomClient).PrefferedMemory[MemoryType];
end;

function _TBFGSMModemClientX.GetServiceCenter: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).ServiceCenter;
end;

function _TBFGSMModemClientX.GetSignal: Byte;
begin
  Result := TBFGSMModemClient(FBFCustomClient).Signal;
end;

function _TBFGSMModemClientX.GetSMSEnabled: Boolean;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SMSEnabled;
end;

function _TBFGSMModemClientX.GetSoftVersion: string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SoftVersion;
end;

function _TBFGSMModemClientX.GetSupportedMemories(const MemoryType: TBFSMSMemoryType): TBFSMSMemories;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SupportedMemories[MemoryType];
end;

function _TBFGSMModemClientX.GetSupportedPhonebooks: TBFPhoneBooks;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SupportedPhonebooks;
end;

function _TBFGSMModemClientX.GetValidPeriod: Byte;
begin
  Result := TBFGSMModemClient(FBFCustomClient).ValidPeriod;
end;

function _TBFGSMModemClientX.KeyToChar(Key: TBFKey): string;
begin
  Result := TBFGSMModemClient(FBFCustomClient).KeyToChar(Key);
end;

procedure _TBFGSMModemClientX.PushKey(Key: TBFKey; Time, Pause: Byte);
begin
  TBFGSMModemClient(FBFCustomClient).PushKey(Key, Time, Pause);
end;

function _TBFGSMModemClientX.ReadPhonebook: TBFvCards;
begin
  Result := TBFGSMModemClient(FBFCustomClient).ReadPhonebook;
end;

function _TBFGSMModemClientX.ReadSMS(Index: Integer): TBFSMS;
begin
  Result := TBFGSMModemClient(FBFCustomClient).ReadSMS(Index);
end;

function _TBFGSMModemClientX.ReadSMSes(SMSStatus: TBFSMSStatus; MakeNested: Boolean): TBFSMSes;
begin
  Result := TBFGSMModemClient(FBFCustomClient).ReadSMSes(SMSStatus, MakeNested);
end;

function _TBFGSMModemClientX.SaveSMS(AServiceCenter, APhone, AText: string; AFlash, ANeedReport: Boolean): Integer;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SaveSMS(AServiceCenter, APhone, AText, AFlash, ANeedReport);
end;

function _TBFGSMModemClientX.SendSMS(AIndex: Integer; APhone: string; ANeedReport: Boolean): Byte;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SendSMS(AIndex, APhone, ANeedReport);
end;

function _TBFGSMModemClientX.SendSMS(AServiceCenter, APhone, AText: string; AFlash, ANeedReport: Boolean): Byte;
begin
  Result := TBFGSMModemClient(FBFCustomClient).SendSMS(AServiceCenter, APhone, AText, AFlash, ANeedReport);
end;

procedure _TBFGSMModemClientX.SetDisableATCommand(const Value: Boolean);
begin
  TBFGSMModemClient(FBFCustomClient).DisableATCommand := Value;
end;

procedure _TBFGSMModemClientX.SetEncoding(const Value: TBFSMSEncoding);
begin
  TBFGSMModemClient(FBFCustomClient).Encoding := Value;
end;

procedure _TBFGSMModemClientX.SetOnDown(const Value: TBFKeypadEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnDown := Value;
end;

procedure _TBFGSMModemClientX.SetOnNew(const Value: TBFSMSNewEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnNew := Value;
end;

procedure _TBFGSMModemClientX.SetOnPhonebookProgress(const Value: TBFSMSProgressEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnPhonebookProgress := Value;
end;

procedure _TBFGSMModemClientX.SetOnProgress(const Value: TBFSMSProgressEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnProgress := Value;
end;

procedure _TBFGSMModemClientX.SetOnSendComplete(const Value: TBFSMSEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnSendComplete := Value;
end;

procedure _TBFGSMModemClientX.SetOnSendStart(const Value: TBFSMSSendStartEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnSendStart := Value;
end;

procedure _TBFGSMModemClientX.SetOnUp(const Value: TBFKeypadEvent);
begin
  TBFGSMModemClient(FBFCustomClient).OnUp := Value;
end;

procedure _TBFGSMModemClientX.SetPhonebook(const Value: TBFPhoneBook);
begin
  TBFGSMModemClient(FBFCustomClient).Phonebook := Value;
end;

procedure _TBFGSMModemClientX.SetPrefferedMemory(const MemoryType: TBFSMSMemoryType; const Value: TBFSMSMemory);
begin
  TBFGSMModemClient(FBFCustomClient).PrefferedMemory[MemoryType] := Value;
end;

procedure _TBFGSMModemClientX.SetServiceCenter(const Value: string);
begin
  TBFGSMModemClient(FBFCustomClient).ServiceCenter := Value;
end;

procedure _TBFGSMModemClientX.SetValidPeriod(const Value: Byte);
begin
  TBFGSMModemClient(FBFCustomClient).ValidPeriod := Value;
end;

procedure _TBFGSMModemClientX.WritePhonebook(vCards: TBFvCards);
begin
  TBFGSMModemClient(FBFCustomClient).WritePhonebook(vCards);
end;

initialization
  // Use random numbers for self generation reference numbers for
  // long SMSes.
  Randomize;

end.
