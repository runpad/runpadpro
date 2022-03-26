unit CDO_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 22.09.2004 12:27:49 from Type Library described below.

// ************************************************************************  //
// Type Lib: c:\windows\system32\cdosys.dll (1)
// LIBID: {CD000000-8B95-11D1-82DB-00C04FB1625D}
// LCID: 0
// Helpfile: c:\windows\system32\cdosys.chm
// HelpString: Microsoft CDO for Windows 2000 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v2.5 ADODB, (C:\Program Files\Common Files\System\ado\msado25.tlb)
// Errors:
//   Hint: Parameter 'Interface' of IBodyPart.GetInterface changed to 'Interface_'
//   Hint: Parameter 'var' of IMessages.FileName changed to 'var_'
//   Hint: Member 'To' of 'IMessage' changed to 'To_'
//   Hint: Parameter 'Interface' of IMessage.GetInterface changed to 'Interface_'
//   Hint: Parameter 'Interface' of IConfiguration.GetInterface changed to 'Interface_'
//   Hint: Member 'To' of 'IMessage' changed to 'To_'
//   Error creating palette bitmap of (TMessage) : Server C:\WINDOWS\System32\cdosys.dll contains no icons
//   Error creating palette bitmap of (TConfiguration) : Server C:\WINDOWS\System32\cdosys.dll contains no icons
//   Error creating palette bitmap of (TDropDirectory) : Server C:\WINDOWS\System32\cdosys.dll contains no icons
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, ADODB_TLB, Classes, Graphics, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  CDOMajorVersion = 1;
  CDOMinorVersion = 0;

  LIBID_CDO: TGUID = '{CD000000-8B95-11D1-82DB-00C04FB1625D}';

  IID_IBodyParts: TGUID = '{CD000023-8B95-11D1-82DB-00C04FB1625D}';
  IID_IBodyPart: TGUID = '{CD000021-8B95-11D1-82DB-00C04FB1625D}';
  IID_IDataSource: TGUID = '{CD000029-8B95-11D1-82DB-00C04FB1625D}';
  IID_IMessages: TGUID = '{CD000025-8B95-11D1-82DB-00C04FB1625D}';
  IID_IMessage: TGUID = '{CD000020-8B95-11D1-82DB-00C04FB1625D}';
  IID_IConfiguration: TGUID = '{CD000022-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_Message: TGUID = '{CD000001-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_Configuration: TGUID = '{CD000002-8B95-11D1-82DB-00C04FB1625D}';
  IID_IDropDirectory: TGUID = '{CD000024-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_DropDirectory: TGUID = '{CD000004-8B95-11D1-82DB-00C04FB1625D}';
  IID_ISMTPScriptConnector: TGUID = '{CD000030-8B95-11D1-82DB-00C04FB1625D}';
  IID_ISMTPOnArrival: TGUID = '{CD000026-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_SMTPConnector: TGUID = '{CD000008-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPEarlyScriptConnector: TGUID = '{CD000034-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPOnPostEarly: TGUID = '{CD000033-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_NNTPEarlyConnector: TGUID = '{CD000011-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPPostScriptConnector: TGUID = '{CD000031-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPOnPost: TGUID = '{CD000027-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_NNTPPostConnector: TGUID = '{CD000009-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPFinalScriptConnector: TGUID = '{CD000032-8B95-11D1-82DB-00C04FB1625D}';
  IID_INNTPOnPostFinal: TGUID = '{CD000028-8B95-11D1-82DB-00C04FB1625D}';
  CLASS_NNTPFinalConnector: TGUID = '{CD000010-8B95-11D1-82DB-00C04FB1625D}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum CdoConfigSource
type
  CdoConfigSource = TOleEnum;
const
  cdoDefaults = $FFFFFFFF;
  cdoIIS = $00000001;
  cdoOutlookExpress = $00000002;

// Constants for enum CdoDSNOptions
type
  CdoDSNOptions = TOleEnum;
const
  cdoDSNDefault = $00000000;
  cdoDSNNever = $00000001;
  cdoDSNFailure = $00000002;
  cdoDSNSuccess = $00000004;
  cdoDSNDelay = $00000008;
  cdoDSNSuccessFailOrDelay = $0000000E;

// Constants for enum CdoEventStatus
type
  CdoEventStatus = TOleEnum;
const
  cdoRunNextSink = $00000000;
  cdoSkipRemainingSinks = $00000001;

// Constants for enum cdoImportanceValues
type
  cdoImportanceValues = TOleEnum;
const
  cdoLow = $00000000;
  cdoNormal = $00000001;
  cdoHigh = $00000002;

// Constants for enum CdoMessageStat
type
  CdoMessageStat = TOleEnum;
const
  cdoStatSuccess = $00000000;
  cdoStatAbortDelivery = $00000002;
  cdoStatBadMail = $00000003;

// Constants for enum CdoMHTMLFlags
type
  CdoMHTMLFlags = TOleEnum;
const
  cdoSuppressNone = $00000000;
  cdoSuppressImages = $00000001;
  cdoSuppressBGSounds = $00000002;
  cdoSuppressFrames = $00000004;
  cdoSuppressObjects = $00000008;
  cdoSuppressStyleSheets = $00000010;
  cdoSuppressAll = $0000001F;

// Constants for enum CdoNNTPProcessingField
type
  CdoNNTPProcessingField = TOleEnum;
const
  cdoPostMessage = $00000001;
  cdoProcessControl = $00000002;
  cdoProcessModerator = $00000004;

// Constants for enum CdoPostUsing
type
  CdoPostUsing = TOleEnum;
const
  cdoPostUsingPickup = $00000001;
  cdoPostUsingPort = $00000002;

// Constants for enum cdoPriorityValues
type
  cdoPriorityValues = TOleEnum;
const
  cdoPriorityNonUrgent = $FFFFFFFF;
  cdoPriorityNormal = $00000000;
  cdoPriorityUrgent = $00000001;

// Constants for enum CdoProtocolsAuthentication
type
  CdoProtocolsAuthentication = TOleEnum;
const
  cdoAnonymous = $00000000;
  cdoBasic = $00000001;
  cdoNTLM = $00000002;

// Constants for enum CdoReferenceType
type
  CdoReferenceType = TOleEnum;
const
  cdoRefTypeId = $00000000;
  cdoRefTypeLocation = $00000001;

// Constants for enum CdoSendUsing
type
  CdoSendUsing = TOleEnum;
const
  cdoSendUsingPickup = $00000001;
  cdoSendUsingPort = $00000002;

// Constants for enum cdoSensitivityValues
type
  cdoSensitivityValues = TOleEnum;
const
  cdoSensitivityNone = $00000000;
  cdoPersonal = $00000001;
  cdoPrivate = $00000002;
  cdoCompanyConfidential = $00000003;

// Constants for enum CdoTimeZoneId
type
  CdoTimeZoneId = TOleEnum;
const
  cdoUTC = $00000000;
  cdoGMT = $00000001;
  cdoSarajevo = $00000002;
  cdoParis = $00000003;
  cdoBerlin = $00000004;
  cdoEasternEurope = $00000005;
  cdoPrague = $00000006;
  cdoAthens = $00000007;
  cdoBrasilia = $00000008;
  cdoAtlanticCanada = $00000009;
  cdoEastern = $0000000A;
  cdoCentral = $0000000B;
  cdoMountain = $0000000C;
  cdoPacific = $0000000D;
  cdoAlaska = $0000000E;
  cdoHawaii = $0000000F;
  cdoMidwayIsland = $00000010;
  cdoWellington = $00000011;
  cdoBrisbane = $00000012;
  cdoAdelaide = $00000013;
  cdoTokyo = $00000014;
  cdoSingapore = $00000015;
  cdoBangkok = $00000016;
  cdoBombay = $00000017;
  cdoAbuDhabi = $00000018;
  cdoTehran = $00000019;
  cdoBaghdad = $0000001A;
  cdoIsrael = $0000001B;
  cdoNewfoundland = $0000001C;
  cdoAzores = $0000001D;
  cdoMidAtlantic = $0000001E;
  cdoMonrovia = $0000001F;
  cdoBuenosAires = $00000020;
  cdoCaracas = $00000021;
  cdoIndiana = $00000022;
  cdoBogota = $00000023;
  cdoSaskatchewan = $00000024;
  cdoMexicoCity = $00000025;
  cdoArizona = $00000026;
  cdoEniwetok = $00000027;
  cdoFiji = $00000028;
  cdoMagadan = $00000029;
  cdoHobart = $0000002A;
  cdoGuam = $0000002B;
  cdoDarwin = $0000002C;
  cdoBeijing = $0000002D;
  cdoAlmaty = $0000002E;
  cdoIslamabad = $0000002F;
  cdoKabul = $00000030;
  cdoCairo = $00000031;
  cdoHarare = $00000032;
  cdoMoscow = $00000033;
  cdoFloating = $00000034;
  cdoCapeVerde = $00000035;
  cdoCaucasus = $00000036;
  cdoCentralAmerica = $00000037;
  cdoEastAfrica = $00000038;
  cdoMelbourne = $00000039;
  cdoEkaterinburg = $0000003A;
  cdoHelsinki = $0000003B;
  cdoGreenland = $0000003C;
  cdoRangoon = $0000003D;
  cdoNepal = $0000003E;
  cdoIrkutsk = $0000003F;
  cdoKrasnoyarsk = $00000040;
  cdoSantiago = $00000041;
  cdoSriLanka = $00000042;
  cdoTonga = $00000043;
  cdoVladivostok = $00000044;
  cdoWestCentralAfrica = $00000045;
  cdoYakutsk = $00000046;
  cdoDhaka = $00000047;
  cdoSeoul = $00000048;
  cdoPerth = $00000049;
  cdoArab = $0000004A;
  cdoTaipei = $0000004B;
  cdoSydney2000 = $0000004C;
  cdoInvalidTimeZone = $0000004D;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IBodyParts = interface;
  IBodyPartsDisp = dispinterface;
  IBodyPart = interface;
  IBodyPartDisp = dispinterface;
  IDataSource = interface;
  IDataSourceDisp = dispinterface;
  IMessages = interface;
  IMessagesDisp = dispinterface;
  IMessage = interface;
  IMessageDisp = dispinterface;
  IConfiguration = interface;
  IConfigurationDisp = dispinterface;
  IDropDirectory = interface;
  IDropDirectoryDisp = dispinterface;
  ISMTPScriptConnector = interface;
  ISMTPScriptConnectorDisp = dispinterface;
  ISMTPOnArrival = interface;
  ISMTPOnArrivalDisp = dispinterface;
  INNTPEarlyScriptConnector = interface;
  INNTPEarlyScriptConnectorDisp = dispinterface;
  INNTPOnPostEarly = interface;
  INNTPOnPostEarlyDisp = dispinterface;
  INNTPPostScriptConnector = interface;
  INNTPPostScriptConnectorDisp = dispinterface;
  INNTPOnPost = interface;
  INNTPOnPostDisp = dispinterface;
  INNTPFinalScriptConnector = interface;
  INNTPFinalScriptConnectorDisp = dispinterface;
  INNTPOnPostFinal = interface;
  INNTPOnPostFinalDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Message = IMessage;
  Configuration = IConfiguration;
  DropDirectory = IDropDirectory;
  SMTPConnector = ISMTPScriptConnector;
  NNTPEarlyConnector = INNTPEarlyScriptConnector;
  NNTPPostConnector = INNTPPostScriptConnector;
  NNTPFinalConnector = INNTPFinalScriptConnector;


// *********************************************************************//
// Interface: IBodyParts
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000023-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IBodyParts = interface(IDispatch)
    ['{CD000023-8B95-11D1-82DB-00C04FB1625D}']
    function Get_Count: Integer; safecall;
    function Get_Item(Index: Integer): IBodyPart; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Delete(varBP: OleVariant); safecall;
    procedure DeleteAll; safecall;
    function Add(Index: Integer): IBodyPart; safecall;
    property Count: Integer read Get_Count;
    property Item[Index: Integer]: IBodyPart read Get_Item; default;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IBodyPartsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000023-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IBodyPartsDisp = dispinterface
    ['{CD000023-8B95-11D1-82DB-00C04FB1625D}']
    property Count: Integer readonly dispid 1;
    property Item[Index: Integer]: IBodyPart readonly dispid 0; default;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Delete(varBP: OleVariant); dispid 2;
    procedure DeleteAll; dispid 3;
    function Add(Index: Integer): IBodyPart; dispid 4;
  end;

// *********************************************************************//
// Interface: IBodyPart
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000021-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IBodyPart = interface(IDispatch)
    ['{CD000021-8B95-11D1-82DB-00C04FB1625D}']
    function Get_BodyParts: IBodyParts; safecall;
    function Get_ContentTransferEncoding: WideString; safecall;
    procedure Set_ContentTransferEncoding(const pContentTransferEncoding: WideString); safecall;
    function Get_ContentMediaType: WideString; safecall;
    procedure Set_ContentMediaType(const pContentMediaType: WideString); safecall;
    function Get_Fields: Fields; safecall;
    function Get_Charset: WideString; safecall;
    procedure Set_Charset(const pCharset: WideString); safecall;
    function Get_FileName: WideString; safecall;
    function Get_DataSource: IDataSource; safecall;
    function Get_ContentClass: WideString; safecall;
    procedure Set_ContentClass(const pContentClass: WideString); safecall;
    function Get_ContentClassName: WideString; safecall;
    procedure Set_ContentClassName(const pContentClassName: WideString); safecall;
    function Get_Parent: IBodyPart; safecall;
    function AddBodyPart(Index: Integer): IBodyPart; safecall;
    procedure SaveToFile(const FileName: WideString); safecall;
    function GetEncodedContentStream: _Stream; safecall;
    function GetDecodedContentStream: _Stream; safecall;
    function GetStream: _Stream; safecall;
    function GetFieldParameter(const FieldName: WideString; const Parameter: WideString): WideString; safecall;
    function GetInterface(const Interface_: WideString): IDispatch; safecall;
    property BodyParts: IBodyParts read Get_BodyParts;
    property ContentTransferEncoding: WideString read Get_ContentTransferEncoding write Set_ContentTransferEncoding;
    property ContentMediaType: WideString read Get_ContentMediaType write Set_ContentMediaType;
    property Fields: Fields read Get_Fields;
    property Charset: WideString read Get_Charset write Set_Charset;
    property FileName: WideString read Get_FileName;
    property DataSource: IDataSource read Get_DataSource;
    property ContentClass: WideString read Get_ContentClass write Set_ContentClass;
    property ContentClassName: WideString read Get_ContentClassName write Set_ContentClassName;
    property Parent: IBodyPart read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  IBodyPartDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000021-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IBodyPartDisp = dispinterface
    ['{CD000021-8B95-11D1-82DB-00C04FB1625D}']
    property BodyParts: IBodyParts readonly dispid 200;
    property ContentTransferEncoding: WideString dispid 201;
    property ContentMediaType: WideString dispid 202;
    property Fields: Fields readonly dispid 203;
    property Charset: WideString dispid 204;
    property FileName: WideString readonly dispid 205;
    property DataSource: IDataSource readonly dispid 207;
    property ContentClass: WideString dispid 208;
    property ContentClassName: WideString dispid 209;
    property Parent: IBodyPart readonly dispid 210;
    function AddBodyPart(Index: Integer): IBodyPart; dispid 250;
    procedure SaveToFile(const FileName: WideString); dispid 251;
    function GetEncodedContentStream: _Stream; dispid 252;
    function GetDecodedContentStream: _Stream; dispid 253;
    function GetStream: _Stream; dispid 254;
    function GetFieldParameter(const FieldName: WideString; const Parameter: WideString): WideString; dispid 255;
    function GetInterface(const Interface_: WideString): IDispatch; dispid 160;
  end;

// *********************************************************************//
// Interface: IDataSource
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000029-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IDataSource = interface(IDispatch)
    ['{CD000029-8B95-11D1-82DB-00C04FB1625D}']
    function Get_SourceClass: WideString; safecall;
    function Get_Source: IUnknown; safecall;
    function Get_IsDirty: WordBool; safecall;
    procedure Set_IsDirty(pIsDirty: WordBool); safecall;
    function Get_SourceURL: WideString; safecall;
    function Get_ActiveConnection: _Connection; safecall;
    procedure SaveToObject(const Source: IUnknown; const InterfaceName: WideString); safecall;
    procedure OpenObject(const Source: IUnknown; const InterfaceName: WideString); safecall;
    procedure SaveTo(const SourceURL: WideString; const ActiveConnection: IDispatch; 
                     Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                     Options: RecordOpenOptionsEnum; const UserName: WideString; 
                     const Password: WideString); safecall;
    procedure Open(const SourceURL: WideString; const ActiveConnection: IDispatch; 
                   Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                   Options: RecordOpenOptionsEnum; const UserName: WideString; 
                   const Password: WideString); safecall;
    procedure Save; safecall;
    procedure SaveToContainer(const ContainerURL: WideString; const ActiveConnection: IDispatch; 
                              Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                              Options: RecordOpenOptionsEnum; const UserName: WideString; 
                              const Password: WideString); safecall;
    property SourceClass: WideString read Get_SourceClass;
    property Source: IUnknown read Get_Source;
    property IsDirty: WordBool read Get_IsDirty write Set_IsDirty;
    property SourceURL: WideString read Get_SourceURL;
    property ActiveConnection: _Connection read Get_ActiveConnection;
  end;

// *********************************************************************//
// DispIntf:  IDataSourceDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000029-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IDataSourceDisp = dispinterface
    ['{CD000029-8B95-11D1-82DB-00C04FB1625D}']
    property SourceClass: WideString readonly dispid 207;
    property Source: IUnknown readonly dispid 208;
    property IsDirty: WordBool dispid 209;
    property SourceURL: WideString readonly dispid 210;
    property ActiveConnection: _Connection readonly dispid 211;
    procedure SaveToObject(const Source: IUnknown; const InterfaceName: WideString); dispid 251;
    procedure OpenObject(const Source: IUnknown; const InterfaceName: WideString); dispid 252;
    procedure SaveTo(const SourceURL: WideString; const ActiveConnection: IDispatch; 
                     Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                     Options: RecordOpenOptionsEnum; const UserName: WideString; 
                     const Password: WideString); dispid 253;
    procedure Open(const SourceURL: WideString; const ActiveConnection: IDispatch; 
                   Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                   Options: RecordOpenOptionsEnum; const UserName: WideString; 
                   const Password: WideString); dispid 254;
    procedure Save; dispid 255;
    procedure SaveToContainer(const ContainerURL: WideString; const ActiveConnection: IDispatch; 
                              Mode: ConnectModeEnum; CreateOptions: RecordCreateOptionsEnum; 
                              Options: RecordOpenOptionsEnum; const UserName: WideString; 
                              const Password: WideString); dispid 256;
  end;

// *********************************************************************//
// Interface: IMessages
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000025-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IMessages = interface(IDispatch)
    ['{CD000025-8B95-11D1-82DB-00C04FB1625D}']
    function Get_Item(Index: Integer): IMessage; safecall;
    function Get_Count: Integer; safecall;
    procedure Delete(Index: Integer); safecall;
    procedure DeleteAll; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Get_FileName(var_: OleVariant): WideString; safecall;
    property Item[Index: Integer]: IMessage read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property FileName[var_: OleVariant]: WideString read Get_FileName;
  end;

// *********************************************************************//
// DispIntf:  IMessagesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000025-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IMessagesDisp = dispinterface
    ['{CD000025-8B95-11D1-82DB-00C04FB1625D}']
    property Item[Index: Integer]: IMessage readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    procedure Delete(Index: Integer); dispid 2;
    procedure DeleteAll; dispid 3;
    property _NewEnum: IUnknown readonly dispid -4;
    property FileName[var_: OleVariant]: WideString readonly dispid 5;
  end;

// *********************************************************************//
// Interface: IMessage
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000020-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IMessage = interface(IDispatch)
    ['{CD000020-8B95-11D1-82DB-00C04FB1625D}']
    function Get_BCC: WideString; safecall;
    procedure Set_BCC(const pBCC: WideString); safecall;
    function Get_CC: WideString; safecall;
    procedure Set_CC(const pCC: WideString); safecall;
    function Get_FollowUpTo: WideString; safecall;
    procedure Set_FollowUpTo(const pFollowUpTo: WideString); safecall;
    function Get_From: WideString; safecall;
    procedure Set_From(const pFrom: WideString); safecall;
    function Get_Keywords: WideString; safecall;
    procedure Set_Keywords(const pKeywords: WideString); safecall;
    function Get_MimeFormatted: WordBool; safecall;
    procedure Set_MimeFormatted(pMimeFormatted: WordBool); safecall;
    function Get_Newsgroups: WideString; safecall;
    procedure Set_Newsgroups(const pNewsgroups: WideString); safecall;
    function Get_Organization: WideString; safecall;
    procedure Set_Organization(const pOrganization: WideString); safecall;
    function Get_ReceivedTime: TDateTime; safecall;
    function Get_ReplyTo: WideString; safecall;
    procedure Set_ReplyTo(const pReplyTo: WideString); safecall;
    function Get_DSNOptions: CdoDSNOptions; safecall;
    procedure Set_DSNOptions(pDSNOptions: CdoDSNOptions); safecall;
    function Get_SentOn: TDateTime; safecall;
    function Get_Subject: WideString; safecall;
    procedure Set_Subject(const pSubject: WideString); safecall;
    function Get_To_: WideString; safecall;
    procedure Set_To_(const pTo: WideString); safecall;
    function Get_TextBody: WideString; safecall;
    procedure Set_TextBody(const pTextBody: WideString); safecall;
    function Get_HTMLBody: WideString; safecall;
    procedure Set_HTMLBody(const pHTMLBody: WideString); safecall;
    function Get_Attachments: IBodyParts; safecall;
    function Get_Sender: WideString; safecall;
    procedure Set_Sender(const pSender: WideString); safecall;
    function Get_Configuration: IConfiguration; safecall;
    procedure Set_Configuration(const pConfiguration: IConfiguration); safecall;
    procedure _Set_Configuration(const pConfiguration: IConfiguration); safecall;
    function Get_AutoGenerateTextBody: WordBool; safecall;
    procedure Set_AutoGenerateTextBody(pAutoGenerateTextBody: WordBool); safecall;
    function Get_EnvelopeFields: Fields; safecall;
    function Get_TextBodyPart: IBodyPart; safecall;
    function Get_HTMLBodyPart: IBodyPart; safecall;
    function Get_BodyPart: IBodyPart; safecall;
    function Get_DataSource: IDataSource; safecall;
    function Get_Fields: Fields; safecall;
    function Get_MDNRequested: WordBool; safecall;
    procedure Set_MDNRequested(pMDNRequested: WordBool); safecall;
    function AddRelatedBodyPart(const URL: WideString; const Reference: WideString; 
                                ReferenceType: CdoReferenceType; const UserName: WideString; 
                                const Password: WideString): IBodyPart; safecall;
    function AddAttachment(const URL: WideString; const UserName: WideString; 
                           const Password: WideString): IBodyPart; safecall;
    procedure CreateMHTMLBody(const URL: WideString; Flags: CdoMHTMLFlags; 
                              const UserName: WideString; const Password: WideString); safecall;
    function Forward: IMessage; safecall;
    procedure Post; safecall;
    function PostReply: IMessage; safecall;
    function Reply: IMessage; safecall;
    function ReplyAll: IMessage; safecall;
    procedure Send; safecall;
    function GetStream: _Stream; safecall;
    function GetInterface(const Interface_: WideString): IDispatch; safecall;
    property BCC: WideString read Get_BCC write Set_BCC;
    property CC: WideString read Get_CC write Set_CC;
    property FollowUpTo: WideString read Get_FollowUpTo write Set_FollowUpTo;
    property From: WideString read Get_From write Set_From;
    property Keywords: WideString read Get_Keywords write Set_Keywords;
    property MimeFormatted: WordBool read Get_MimeFormatted write Set_MimeFormatted;
    property Newsgroups: WideString read Get_Newsgroups write Set_Newsgroups;
    property Organization: WideString read Get_Organization write Set_Organization;
    property ReceivedTime: TDateTime read Get_ReceivedTime;
    property ReplyTo: WideString read Get_ReplyTo write Set_ReplyTo;
    property DSNOptions: CdoDSNOptions read Get_DSNOptions write Set_DSNOptions;
    property SentOn: TDateTime read Get_SentOn;
    property Subject: WideString read Get_Subject write Set_Subject;
    property To_: WideString read Get_To_ write Set_To_;
    property TextBody: WideString read Get_TextBody write Set_TextBody;
    property HTMLBody: WideString read Get_HTMLBody write Set_HTMLBody;
    property Attachments: IBodyParts read Get_Attachments;
    property Sender: WideString read Get_Sender write Set_Sender;
    property Configuration: IConfiguration read Get_Configuration write Set_Configuration;
    property AutoGenerateTextBody: WordBool read Get_AutoGenerateTextBody write Set_AutoGenerateTextBody;
    property EnvelopeFields: Fields read Get_EnvelopeFields;
    property TextBodyPart: IBodyPart read Get_TextBodyPart;
    property HTMLBodyPart: IBodyPart read Get_HTMLBodyPart;
    property BodyPart: IBodyPart read Get_BodyPart;
    property DataSource: IDataSource read Get_DataSource;
    property Fields: Fields read Get_Fields;
    property MDNRequested: WordBool read Get_MDNRequested write Set_MDNRequested;
  end;

// *********************************************************************//
// DispIntf:  IMessageDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000020-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IMessageDisp = dispinterface
    ['{CD000020-8B95-11D1-82DB-00C04FB1625D}']
    property BCC: WideString dispid 101;
    property CC: WideString dispid 103;
    property FollowUpTo: WideString dispid 105;
    property From: WideString dispid 106;
    property Keywords: WideString dispid 107;
    property MimeFormatted: WordBool dispid 110;
    property Newsgroups: WideString dispid 111;
    property Organization: WideString dispid 112;
    property ReceivedTime: TDateTime readonly dispid 114;
    property ReplyTo: WideString dispid 115;
    property DSNOptions: CdoDSNOptions dispid 116;
    property SentOn: TDateTime readonly dispid 119;
    property Subject: WideString dispid 120;
    property To_: WideString dispid 121;
    property TextBody: WideString dispid 123;
    property HTMLBody: WideString dispid 124;
    property Attachments: IBodyParts readonly dispid 125;
    property Sender: WideString dispid 126;
    property Configuration: IConfiguration dispid 127;
    property AutoGenerateTextBody: WordBool dispid 128;
    property EnvelopeFields: Fields readonly dispid 129;
    property TextBodyPart: IBodyPart readonly dispid 130;
    property HTMLBodyPart: IBodyPart readonly dispid 131;
    property BodyPart: IBodyPart readonly dispid 132;
    property DataSource: IDataSource readonly dispid 133;
    property Fields: Fields readonly dispid 134;
    property MDNRequested: WordBool dispid 135;
    function AddRelatedBodyPart(const URL: WideString; const Reference: WideString; 
                                ReferenceType: CdoReferenceType; const UserName: WideString; 
                                const Password: WideString): IBodyPart; dispid 150;
    function AddAttachment(const URL: WideString; const UserName: WideString; 
                           const Password: WideString): IBodyPart; dispid 151;
    procedure CreateMHTMLBody(const URL: WideString; Flags: CdoMHTMLFlags; 
                              const UserName: WideString; const Password: WideString); dispid 152;
    function Forward: IMessage; dispid 153;
    procedure Post; dispid 154;
    function PostReply: IMessage; dispid 155;
    function Reply: IMessage; dispid 156;
    function ReplyAll: IMessage; dispid 157;
    procedure Send; dispid 158;
    function GetStream: _Stream; dispid 159;
    function GetInterface(const Interface_: WideString): IDispatch; dispid 160;
  end;

// *********************************************************************//
// Interface: IConfiguration
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000022-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IConfiguration = interface(IDispatch)
    ['{CD000022-8B95-11D1-82DB-00C04FB1625D}']
    function Get_Fields: Fields; safecall;
    procedure Load(LoadFrom: CdoConfigSource; const URL: WideString); safecall;
    function GetInterface(const Interface_: WideString): IDispatch; safecall;
    property Fields: Fields read Get_Fields;
  end;

// *********************************************************************//
// DispIntf:  IConfigurationDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000022-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IConfigurationDisp = dispinterface
    ['{CD000022-8B95-11D1-82DB-00C04FB1625D}']
    property Fields: Fields readonly dispid 0;
    procedure Load(LoadFrom: CdoConfigSource; const URL: WideString); dispid 50;
    function GetInterface(const Interface_: WideString): IDispatch; dispid 160;
  end;

// *********************************************************************//
// Interface: IDropDirectory
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000024-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IDropDirectory = interface(IDispatch)
    ['{CD000024-8B95-11D1-82DB-00C04FB1625D}']
    function GetMessages(const DirName: WideString): IMessages; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDropDirectoryDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000024-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  IDropDirectoryDisp = dispinterface
    ['{CD000024-8B95-11D1-82DB-00C04FB1625D}']
    function GetMessages(const DirName: WideString): IMessages; dispid 200;
  end;

// *********************************************************************//
// Interface: ISMTPScriptConnector
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000030-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  ISMTPScriptConnector = interface(IDispatch)
    ['{CD000030-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// DispIntf:  ISMTPScriptConnectorDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000030-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  ISMTPScriptConnectorDisp = dispinterface
    ['{CD000030-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// Interface: ISMTPOnArrival
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000026-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  ISMTPOnArrival = interface(IDispatch)
    ['{CD000026-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnArrival(const Msg: IMessage; var EventStatus: CdoEventStatus); safecall;
  end;

// *********************************************************************//
// DispIntf:  ISMTPOnArrivalDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000026-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  ISMTPOnArrivalDisp = dispinterface
    ['{CD000026-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnArrival(const Msg: IMessage; var EventStatus: CdoEventStatus); dispid 256;
  end;

// *********************************************************************//
// Interface: INNTPEarlyScriptConnector
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000034-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPEarlyScriptConnector = interface(IDispatch)
    ['{CD000034-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// DispIntf:  INNTPEarlyScriptConnectorDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000034-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPEarlyScriptConnectorDisp = dispinterface
    ['{CD000034-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// Interface: INNTPOnPostEarly
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000033-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPostEarly = interface(IDispatch)
    ['{CD000033-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPostEarly(const Msg: IMessage; var EventStatus: CdoEventStatus); safecall;
  end;

// *********************************************************************//
// DispIntf:  INNTPOnPostEarlyDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000033-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPostEarlyDisp = dispinterface
    ['{CD000033-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPostEarly(const Msg: IMessage; var EventStatus: CdoEventStatus); dispid 256;
  end;

// *********************************************************************//
// Interface: INNTPPostScriptConnector
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000031-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPPostScriptConnector = interface(IDispatch)
    ['{CD000031-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// DispIntf:  INNTPPostScriptConnectorDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000031-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPPostScriptConnectorDisp = dispinterface
    ['{CD000031-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// Interface: INNTPOnPost
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000027-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPost = interface(IDispatch)
    ['{CD000027-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPost(const Msg: IMessage; var EventStatus: CdoEventStatus); safecall;
  end;

// *********************************************************************//
// DispIntf:  INNTPOnPostDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000027-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPostDisp = dispinterface
    ['{CD000027-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPost(const Msg: IMessage; var EventStatus: CdoEventStatus); dispid 256;
  end;

// *********************************************************************//
// Interface: INNTPFinalScriptConnector
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000032-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPFinalScriptConnector = interface(IDispatch)
    ['{CD000032-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// DispIntf:  INNTPFinalScriptConnectorDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000032-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPFinalScriptConnectorDisp = dispinterface
    ['{CD000032-8B95-11D1-82DB-00C04FB1625D}']
  end;

// *********************************************************************//
// Interface: INNTPOnPostFinal
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000028-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPostFinal = interface(IDispatch)
    ['{CD000028-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPostFinal(const Msg: IMessage; var EventStatus: CdoEventStatus); safecall;
  end;

// *********************************************************************//
// DispIntf:  INNTPOnPostFinalDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CD000028-8B95-11D1-82DB-00C04FB1625D}
// *********************************************************************//
  INNTPOnPostFinalDisp = dispinterface
    ['{CD000028-8B95-11D1-82DB-00C04FB1625D}']
    procedure OnPostFinal(const Msg: IMessage; var EventStatus: CdoEventStatus); dispid 256;
  end;

// *********************************************************************//
// The Class CoMessage provides a Create and CreateRemote method to          
// create instances of the default interface IMessage exposed by              
// the CoClass Message. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoMessage = class
    class function Create: IMessage;
    class function CreateRemote(const MachineName: string): IMessage;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TMessage
// Help String      : Defines an object used to manage a message.
// Default Interface: IMessage
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TMessageProperties= class;
{$ENDIF}
  TMessage = class(TOleServer)
  private
    FIntf:        IMessage;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TMessageProperties;
    function      GetServerProperties: TMessageProperties;
{$ENDIF}
    function      GetDefaultInterface: IMessage;
  protected
    procedure InitServerData; override;
    function Get_BCC: WideString;
    procedure Set_BCC(const pBCC: WideString);
    function Get_CC: WideString;
    procedure Set_CC(const pCC: WideString);
    function Get_FollowUpTo: WideString;
    procedure Set_FollowUpTo(const pFollowUpTo: WideString);
    function Get_From: WideString;
    procedure Set_From(const pFrom: WideString);
    function Get_Keywords: WideString;
    procedure Set_Keywords(const pKeywords: WideString);
    function Get_MimeFormatted: WordBool;
    procedure Set_MimeFormatted(pMimeFormatted: WordBool);
    function Get_Newsgroups: WideString;
    procedure Set_Newsgroups(const pNewsgroups: WideString);
    function Get_Organization: WideString;
    procedure Set_Organization(const pOrganization: WideString);
    function Get_ReceivedTime: TDateTime;
    function Get_ReplyTo: WideString;
    procedure Set_ReplyTo(const pReplyTo: WideString);
    function Get_DSNOptions: CdoDSNOptions;
    procedure Set_DSNOptions(pDSNOptions: CdoDSNOptions);
    function Get_SentOn: TDateTime;
    function Get_Subject: WideString;
    procedure Set_Subject(const pSubject: WideString);
    function Get_To_: WideString;
    procedure Set_To_(const pTo: WideString);
    function Get_TextBody: WideString;
    procedure Set_TextBody(const pTextBody: WideString);
    function Get_HTMLBody: WideString;
    procedure Set_HTMLBody(const pHTMLBody: WideString);
    function Get_Attachments: IBodyParts;
    function Get_Sender: WideString;
    procedure Set_Sender(const pSender: WideString);
    function Get_Configuration: IConfiguration;
    procedure Set_Configuration(const pConfiguration: IConfiguration);
    procedure _Set_Configuration(const pConfiguration: IConfiguration);
    function Get_AutoGenerateTextBody: WordBool;
    procedure Set_AutoGenerateTextBody(pAutoGenerateTextBody: WordBool);
    function Get_EnvelopeFields: Fields;
    function Get_TextBodyPart: IBodyPart;
    function Get_HTMLBodyPart: IBodyPart;
    function Get_BodyPart: IBodyPart;
    function Get_DataSource: IDataSource;
    function Get_Fields: Fields;
    function Get_MDNRequested: WordBool;
    procedure Set_MDNRequested(pMDNRequested: WordBool);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IMessage);
    procedure Disconnect; override;
    function AddRelatedBodyPart(const URL: WideString; const Reference: WideString; 
                                ReferenceType: CdoReferenceType; const UserName: WideString; 
                                const Password: WideString): IBodyPart;
    function AddAttachment(const URL: WideString; const UserName: WideString; 
                           const Password: WideString): IBodyPart;
    procedure CreateMHTMLBody(const URL: WideString; Flags: CdoMHTMLFlags; 
                              const UserName: WideString; const Password: WideString);
    function Forward: IMessage;
    procedure Post;
    function PostReply: IMessage;
    function Reply: IMessage;
    function ReplyAll: IMessage;
    procedure Send;
    function GetStream: _Stream;
    function GetInterface(const Interface_: WideString): IDispatch;
    property DefaultInterface: IMessage read GetDefaultInterface;
    property ReceivedTime: TDateTime read Get_ReceivedTime;
    property SentOn: TDateTime read Get_SentOn;
    property Attachments: IBodyParts read Get_Attachments;
    property EnvelopeFields: Fields read Get_EnvelopeFields;
    property TextBodyPart: IBodyPart read Get_TextBodyPart;
    property HTMLBodyPart: IBodyPart read Get_HTMLBodyPart;
    property BodyPart: IBodyPart read Get_BodyPart;
    property DataSource: IDataSource read Get_DataSource;
    property Fields: Fields read Get_Fields;
    property BCC: WideString read Get_BCC write Set_BCC;
    property CC: WideString read Get_CC write Set_CC;
    property FollowUpTo: WideString read Get_FollowUpTo write Set_FollowUpTo;
    property From: WideString read Get_From write Set_From;
    property Keywords: WideString read Get_Keywords write Set_Keywords;
    property MimeFormatted: WordBool read Get_MimeFormatted write Set_MimeFormatted;
    property Newsgroups: WideString read Get_Newsgroups write Set_Newsgroups;
    property Organization: WideString read Get_Organization write Set_Organization;
    property ReplyTo: WideString read Get_ReplyTo write Set_ReplyTo;
    property DSNOptions: CdoDSNOptions read Get_DSNOptions write Set_DSNOptions;
    property Subject: WideString read Get_Subject write Set_Subject;
    property To_: WideString read Get_To_ write Set_To_;
    property TextBody: WideString read Get_TextBody write Set_TextBody;
    property HTMLBody: WideString read Get_HTMLBody write Set_HTMLBody;
    property Sender: WideString read Get_Sender write Set_Sender;
    property Configuration: IConfiguration read Get_Configuration write Set_Configuration;
    property AutoGenerateTextBody: WordBool read Get_AutoGenerateTextBody write Set_AutoGenerateTextBody;
    property MDNRequested: WordBool read Get_MDNRequested write Set_MDNRequested;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TMessageProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TMessage
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TMessageProperties = class(TPersistent)
  private
    FServer:    TMessage;
    function    GetDefaultInterface: IMessage;
    constructor Create(AServer: TMessage);
  protected
    function Get_BCC: WideString;
    procedure Set_BCC(const pBCC: WideString);
    function Get_CC: WideString;
    procedure Set_CC(const pCC: WideString);
    function Get_FollowUpTo: WideString;
    procedure Set_FollowUpTo(const pFollowUpTo: WideString);
    function Get_From: WideString;
    procedure Set_From(const pFrom: WideString);
    function Get_Keywords: WideString;
    procedure Set_Keywords(const pKeywords: WideString);
    function Get_MimeFormatted: WordBool;
    procedure Set_MimeFormatted(pMimeFormatted: WordBool);
    function Get_Newsgroups: WideString;
    procedure Set_Newsgroups(const pNewsgroups: WideString);
    function Get_Organization: WideString;
    procedure Set_Organization(const pOrganization: WideString);
    function Get_ReceivedTime: TDateTime;
    function Get_ReplyTo: WideString;
    procedure Set_ReplyTo(const pReplyTo: WideString);
    function Get_DSNOptions: CdoDSNOptions;
    procedure Set_DSNOptions(pDSNOptions: CdoDSNOptions);
    function Get_SentOn: TDateTime;
    function Get_Subject: WideString;
    procedure Set_Subject(const pSubject: WideString);
    function Get_To_: WideString;
    procedure Set_To_(const pTo: WideString);
    function Get_TextBody: WideString;
    procedure Set_TextBody(const pTextBody: WideString);
    function Get_HTMLBody: WideString;
    procedure Set_HTMLBody(const pHTMLBody: WideString);
    function Get_Attachments: IBodyParts;
    function Get_Sender: WideString;
    procedure Set_Sender(const pSender: WideString);
    function Get_Configuration: IConfiguration;
    procedure Set_Configuration(const pConfiguration: IConfiguration);
    procedure _Set_Configuration(const pConfiguration: IConfiguration);
    function Get_AutoGenerateTextBody: WordBool;
    procedure Set_AutoGenerateTextBody(pAutoGenerateTextBody: WordBool);
    function Get_EnvelopeFields: Fields;
    function Get_TextBodyPart: IBodyPart;
    function Get_HTMLBodyPart: IBodyPart;
    function Get_BodyPart: IBodyPart;
    function Get_DataSource: IDataSource;
    function Get_Fields: Fields;
    function Get_MDNRequested: WordBool;
    procedure Set_MDNRequested(pMDNRequested: WordBool);
  public
    property DefaultInterface: IMessage read GetDefaultInterface;
  published
    property BCC: WideString read Get_BCC write Set_BCC;
    property CC: WideString read Get_CC write Set_CC;
    property FollowUpTo: WideString read Get_FollowUpTo write Set_FollowUpTo;
    property From: WideString read Get_From write Set_From;
    property Keywords: WideString read Get_Keywords write Set_Keywords;
    property MimeFormatted: WordBool read Get_MimeFormatted write Set_MimeFormatted;
    property Newsgroups: WideString read Get_Newsgroups write Set_Newsgroups;
    property Organization: WideString read Get_Organization write Set_Organization;
    property ReplyTo: WideString read Get_ReplyTo write Set_ReplyTo;
    property DSNOptions: CdoDSNOptions read Get_DSNOptions write Set_DSNOptions;
    property Subject: WideString read Get_Subject write Set_Subject;
    property To_: WideString read Get_To_ write Set_To_;
    property TextBody: WideString read Get_TextBody write Set_TextBody;
    property HTMLBody: WideString read Get_HTMLBody write Set_HTMLBody;
    property Sender: WideString read Get_Sender write Set_Sender;
    property Configuration: IConfiguration read Get_Configuration write Set_Configuration;
    property AutoGenerateTextBody: WordBool read Get_AutoGenerateTextBody write Set_AutoGenerateTextBody;
    property MDNRequested: WordBool read Get_MDNRequested write Set_MDNRequested;
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoConfiguration provides a Create and CreateRemote method to          
// create instances of the default interface IConfiguration exposed by              
// the CoClass Configuration. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoConfiguration = class
    class function Create: IConfiguration;
    class function CreateRemote(const MachineName: string): IConfiguration;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TConfiguration
// Help String      : Defines an object used to store configuration information for CDO objects.
// Default Interface: IConfiguration
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TConfigurationProperties= class;
{$ENDIF}
  TConfiguration = class(TOleServer)
  private
    FIntf:        IConfiguration;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TConfigurationProperties;
    function      GetServerProperties: TConfigurationProperties;
{$ENDIF}
    function      GetDefaultInterface: IConfiguration;
  protected
    procedure InitServerData; override;
    function Get_Fields: Fields;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IConfiguration);
    procedure Disconnect; override;
    procedure Load(LoadFrom: CdoConfigSource; const URL: WideString);
    function GetInterface(const Interface_: WideString): IDispatch;
    property DefaultInterface: IConfiguration read GetDefaultInterface;
    property Fields: Fields read Get_Fields;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TConfigurationProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TConfiguration
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TConfigurationProperties = class(TPersistent)
  private
    FServer:    TConfiguration;
    function    GetDefaultInterface: IConfiguration;
    constructor Create(AServer: TConfiguration);
  protected
    function Get_Fields: Fields;
  public
    property DefaultInterface: IConfiguration read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoDropDirectory provides a Create and CreateRemote method to          
// create instances of the default interface IDropDirectory exposed by              
// the CoClass DropDirectory. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDropDirectory = class
    class function Create: IDropDirectory;
    class function CreateRemote(const MachineName: string): IDropDirectory;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TDropDirectory
// Help String      : Defines an object used to access messages located on the file system.
// Default Interface: IDropDirectory
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TDropDirectoryProperties= class;
{$ENDIF}
  TDropDirectory = class(TOleServer)
  private
    FIntf:        IDropDirectory;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TDropDirectoryProperties;
    function      GetServerProperties: TDropDirectoryProperties;
{$ENDIF}
    function      GetDefaultInterface: IDropDirectory;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IDropDirectory);
    procedure Disconnect; override;
    function GetMessages(const DirName: WideString): IMessages;
    property DefaultInterface: IDropDirectory read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TDropDirectoryProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TDropDirectory
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TDropDirectoryProperties = class(TPersistent)
  private
    FServer:    TDropDirectory;
    function    GetDefaultInterface: IDropDirectory;
    constructor Create(AServer: TDropDirectory);
  protected
  public
    property DefaultInterface: IDropDirectory read GetDefaultInterface;
  published
  end;
{$ENDIF}


// *********************************************************************//
// The Class CoSMTPConnector provides a Create and CreateRemote method to          
// create instances of the default interface ISMTPScriptConnector exposed by              
// the CoClass SMTPConnector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoSMTPConnector = class
    class function Create: ISMTPScriptConnector;
    class function CreateRemote(const MachineName: string): ISMTPScriptConnector;
  end;

// *********************************************************************//
// The Class CoNNTPEarlyConnector provides a Create and CreateRemote method to          
// create instances of the default interface INNTPEarlyScriptConnector exposed by              
// the CoClass NNTPEarlyConnector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNNTPEarlyConnector = class
    class function Create: INNTPEarlyScriptConnector;
    class function CreateRemote(const MachineName: string): INNTPEarlyScriptConnector;
  end;

// *********************************************************************//
// The Class CoNNTPPostConnector provides a Create and CreateRemote method to          
// create instances of the default interface INNTPPostScriptConnector exposed by              
// the CoClass NNTPPostConnector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNNTPPostConnector = class
    class function Create: INNTPPostScriptConnector;
    class function CreateRemote(const MachineName: string): INNTPPostScriptConnector;
  end;

// *********************************************************************//
// The Class CoNNTPFinalConnector provides a Create and CreateRemote method to          
// create instances of the default interface INNTPFinalScriptConnector exposed by              
// the CoClass NNTPFinalConnector. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNNTPFinalConnector = class
    class function Create: INNTPFinalScriptConnector;
    class function CreateRemote(const MachineName: string): INNTPFinalScriptConnector;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoMessage.Create: IMessage;
begin
  Result := CreateComObject(CLASS_Message) as IMessage;
end;

class function CoMessage.CreateRemote(const MachineName: string): IMessage;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Message) as IMessage;
end;

procedure TMessage.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CD000001-8B95-11D1-82DB-00C04FB1625D}';
    IntfIID:   '{CD000020-8B95-11D1-82DB-00C04FB1625D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TMessage.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IMessage;
  end;
end;

procedure TMessage.ConnectTo(svrIntf: IMessage);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TMessage.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TMessage.GetDefaultInterface: IMessage;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TMessage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TMessageProperties.Create(Self);
{$ENDIF}
end;

destructor TMessage.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TMessage.GetServerProperties: TMessageProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TMessage.Get_BCC: WideString;
begin
    Result := DefaultInterface.BCC;
end;

procedure TMessage.Set_BCC(const pBCC: WideString);
  { Warning: The property BCC has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BCC := pBCC;
end;

function TMessage.Get_CC: WideString;
begin
    Result := DefaultInterface.CC;
end;

procedure TMessage.Set_CC(const pCC: WideString);
  { Warning: The property CC has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CC := pCC;
end;

function TMessage.Get_FollowUpTo: WideString;
begin
    Result := DefaultInterface.FollowUpTo;
end;

procedure TMessage.Set_FollowUpTo(const pFollowUpTo: WideString);
  { Warning: The property FollowUpTo has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FollowUpTo := pFollowUpTo;
end;

function TMessage.Get_From: WideString;
begin
    Result := DefaultInterface.From;
end;

procedure TMessage.Set_From(const pFrom: WideString);
  { Warning: The property From has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.From := pFrom;
end;

function TMessage.Get_Keywords: WideString;
begin
    Result := DefaultInterface.Keywords;
end;

procedure TMessage.Set_Keywords(const pKeywords: WideString);
  { Warning: The property Keywords has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Keywords := pKeywords;
end;

function TMessage.Get_MimeFormatted: WordBool;
begin
    Result := DefaultInterface.MimeFormatted;
end;

procedure TMessage.Set_MimeFormatted(pMimeFormatted: WordBool);
begin
  DefaultInterface.Set_MimeFormatted(pMimeFormatted);
end;

function TMessage.Get_Newsgroups: WideString;
begin
    Result := DefaultInterface.Newsgroups;
end;

procedure TMessage.Set_Newsgroups(const pNewsgroups: WideString);
  { Warning: The property Newsgroups has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Newsgroups := pNewsgroups;
end;

function TMessage.Get_Organization: WideString;
begin
    Result := DefaultInterface.Organization;
end;

procedure TMessage.Set_Organization(const pOrganization: WideString);
  { Warning: The property Organization has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Organization := pOrganization;
end;

function TMessage.Get_ReceivedTime: TDateTime;
begin
    Result := DefaultInterface.ReceivedTime;
end;

function TMessage.Get_ReplyTo: WideString;
begin
    Result := DefaultInterface.ReplyTo;
end;

procedure TMessage.Set_ReplyTo(const pReplyTo: WideString);
  { Warning: The property ReplyTo has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ReplyTo := pReplyTo;
end;

function TMessage.Get_DSNOptions: CdoDSNOptions;
begin
    Result := DefaultInterface.DSNOptions;
end;

procedure TMessage.Set_DSNOptions(pDSNOptions: CdoDSNOptions);
begin
  DefaultInterface.Set_DSNOptions(pDSNOptions);
end;

function TMessage.Get_SentOn: TDateTime;
begin
    Result := DefaultInterface.SentOn;
end;

function TMessage.Get_Subject: WideString;
begin
    Result := DefaultInterface.Subject;
end;

procedure TMessage.Set_Subject(const pSubject: WideString);
  { Warning: The property Subject has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Subject := pSubject;
end;

function TMessage.Get_To_: WideString;
begin
    Result := DefaultInterface.To_;
end;

procedure TMessage.Set_To_(const pTo: WideString);
  { Warning: The property To_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.To_ := pTo;
end;

function TMessage.Get_TextBody: WideString;
begin
    Result := DefaultInterface.TextBody;
end;

procedure TMessage.Set_TextBody(const pTextBody: WideString);
  { Warning: The property TextBody has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TextBody := pTextBody;
end;

function TMessage.Get_HTMLBody: WideString;
begin
    Result := DefaultInterface.HTMLBody;
end;

procedure TMessage.Set_HTMLBody(const pHTMLBody: WideString);
  { Warning: The property HTMLBody has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HTMLBody := pHTMLBody;
end;

function TMessage.Get_Attachments: IBodyParts;
begin
    Result := DefaultInterface.Attachments;
end;

function TMessage.Get_Sender: WideString;
begin
    Result := DefaultInterface.Sender;
end;

procedure TMessage.Set_Sender(const pSender: WideString);
  { Warning: The property Sender has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Sender := pSender;
end;

function TMessage.Get_Configuration: IConfiguration;
begin
    Result := DefaultInterface.Configuration;
end;

procedure TMessage.Set_Configuration(const pConfiguration: IConfiguration);
begin
  DefaultInterface.Set_Configuration(pConfiguration);
end;

procedure TMessage._Set_Configuration(const pConfiguration: IConfiguration);
  { Warning: The property Configuration has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Configuration := pConfiguration;
end;

function TMessage.Get_AutoGenerateTextBody: WordBool;
begin
    Result := DefaultInterface.AutoGenerateTextBody;
end;

procedure TMessage.Set_AutoGenerateTextBody(pAutoGenerateTextBody: WordBool);
begin
  DefaultInterface.Set_AutoGenerateTextBody(pAutoGenerateTextBody);
end;

function TMessage.Get_EnvelopeFields: Fields;
begin
    Result := DefaultInterface.EnvelopeFields;
end;

function TMessage.Get_TextBodyPart: IBodyPart;
begin
    Result := DefaultInterface.TextBodyPart;
end;

function TMessage.Get_HTMLBodyPart: IBodyPart;
begin
    Result := DefaultInterface.HTMLBodyPart;
end;

function TMessage.Get_BodyPart: IBodyPart;
begin
    Result := DefaultInterface.BodyPart;
end;

function TMessage.Get_DataSource: IDataSource;
begin
    Result := DefaultInterface.DataSource;
end;

function TMessage.Get_Fields: Fields;
begin
    Result := DefaultInterface.Fields;
end;

function TMessage.Get_MDNRequested: WordBool;
begin
    Result := DefaultInterface.MDNRequested;
end;

procedure TMessage.Set_MDNRequested(pMDNRequested: WordBool);
begin
  DefaultInterface.Set_MDNRequested(pMDNRequested);
end;

function TMessage.AddRelatedBodyPart(const URL: WideString; const Reference: WideString; 
                                     ReferenceType: CdoReferenceType; const UserName: WideString; 
                                     const Password: WideString): IBodyPart;
begin
  Result := DefaultInterface.AddRelatedBodyPart(URL, Reference, ReferenceType, UserName, Password);
end;

function TMessage.AddAttachment(const URL: WideString; const UserName: WideString; 
                                const Password: WideString): IBodyPart;
begin
  Result := DefaultInterface.AddAttachment(URL, UserName, Password);
end;

procedure TMessage.CreateMHTMLBody(const URL: WideString; Flags: CdoMHTMLFlags; 
                                   const UserName: WideString; const Password: WideString);
begin
  DefaultInterface.CreateMHTMLBody(URL, Flags, UserName, Password);
end;

function TMessage.Forward: IMessage;
begin
  Result := DefaultInterface.Forward;
end;

procedure TMessage.Post;
begin
  DefaultInterface.Post;
end;

function TMessage.PostReply: IMessage;
begin
  Result := DefaultInterface.PostReply;
end;

function TMessage.Reply: IMessage;
begin
  Result := DefaultInterface.Reply;
end;

function TMessage.ReplyAll: IMessage;
begin
  Result := DefaultInterface.ReplyAll;
end;

procedure TMessage.Send;
begin
  DefaultInterface.Send;
end;

function TMessage.GetStream: _Stream;
begin
  Result := DefaultInterface.GetStream;
end;

function TMessage.GetInterface(const Interface_: WideString): IDispatch;
begin
  Result := DefaultInterface.GetInterface(Interface_);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TMessageProperties.Create(AServer: TMessage);
begin
  inherited Create;
  FServer := AServer;
end;

function TMessageProperties.GetDefaultInterface: IMessage;
begin
  Result := FServer.DefaultInterface;
end;

function TMessageProperties.Get_BCC: WideString;
begin
    Result := DefaultInterface.BCC;
end;

procedure TMessageProperties.Set_BCC(const pBCC: WideString);
  { Warning: The property BCC has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.BCC := pBCC;
end;

function TMessageProperties.Get_CC: WideString;
begin
    Result := DefaultInterface.CC;
end;

procedure TMessageProperties.Set_CC(const pCC: WideString);
  { Warning: The property CC has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.CC := pCC;
end;

function TMessageProperties.Get_FollowUpTo: WideString;
begin
    Result := DefaultInterface.FollowUpTo;
end;

procedure TMessageProperties.Set_FollowUpTo(const pFollowUpTo: WideString);
  { Warning: The property FollowUpTo has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.FollowUpTo := pFollowUpTo;
end;

function TMessageProperties.Get_From: WideString;
begin
    Result := DefaultInterface.From;
end;

procedure TMessageProperties.Set_From(const pFrom: WideString);
  { Warning: The property From has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.From := pFrom;
end;

function TMessageProperties.Get_Keywords: WideString;
begin
    Result := DefaultInterface.Keywords;
end;

procedure TMessageProperties.Set_Keywords(const pKeywords: WideString);
  { Warning: The property Keywords has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Keywords := pKeywords;
end;

function TMessageProperties.Get_MimeFormatted: WordBool;
begin
    Result := DefaultInterface.MimeFormatted;
end;

procedure TMessageProperties.Set_MimeFormatted(pMimeFormatted: WordBool);
begin
  DefaultInterface.Set_MimeFormatted(pMimeFormatted);
end;

function TMessageProperties.Get_Newsgroups: WideString;
begin
    Result := DefaultInterface.Newsgroups;
end;

procedure TMessageProperties.Set_Newsgroups(const pNewsgroups: WideString);
  { Warning: The property Newsgroups has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Newsgroups := pNewsgroups;
end;

function TMessageProperties.Get_Organization: WideString;
begin
    Result := DefaultInterface.Organization;
end;

procedure TMessageProperties.Set_Organization(const pOrganization: WideString);
  { Warning: The property Organization has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Organization := pOrganization;
end;

function TMessageProperties.Get_ReceivedTime: TDateTime;
begin
    Result := DefaultInterface.ReceivedTime;
end;

function TMessageProperties.Get_ReplyTo: WideString;
begin
    Result := DefaultInterface.ReplyTo;
end;

procedure TMessageProperties.Set_ReplyTo(const pReplyTo: WideString);
  { Warning: The property ReplyTo has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.ReplyTo := pReplyTo;
end;

function TMessageProperties.Get_DSNOptions: CdoDSNOptions;
begin
    Result := DefaultInterface.DSNOptions;
end;

procedure TMessageProperties.Set_DSNOptions(pDSNOptions: CdoDSNOptions);
begin
  DefaultInterface.Set_DSNOptions(pDSNOptions);
end;

function TMessageProperties.Get_SentOn: TDateTime;
begin
    Result := DefaultInterface.SentOn;
end;

function TMessageProperties.Get_Subject: WideString;
begin
    Result := DefaultInterface.Subject;
end;

procedure TMessageProperties.Set_Subject(const pSubject: WideString);
  { Warning: The property Subject has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Subject := pSubject;
end;

function TMessageProperties.Get_To_: WideString;
begin
    Result := DefaultInterface.To_;
end;

procedure TMessageProperties.Set_To_(const pTo: WideString);
  { Warning: The property To_ has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.To_ := pTo;
end;

function TMessageProperties.Get_TextBody: WideString;
begin
    Result := DefaultInterface.TextBody;
end;

procedure TMessageProperties.Set_TextBody(const pTextBody: WideString);
  { Warning: The property TextBody has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.TextBody := pTextBody;
end;

function TMessageProperties.Get_HTMLBody: WideString;
begin
    Result := DefaultInterface.HTMLBody;
end;

procedure TMessageProperties.Set_HTMLBody(const pHTMLBody: WideString);
  { Warning: The property HTMLBody has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.HTMLBody := pHTMLBody;
end;

function TMessageProperties.Get_Attachments: IBodyParts;
begin
    Result := DefaultInterface.Attachments;
end;

function TMessageProperties.Get_Sender: WideString;
begin
    Result := DefaultInterface.Sender;
end;

procedure TMessageProperties.Set_Sender(const pSender: WideString);
  { Warning: The property Sender has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Sender := pSender;
end;

function TMessageProperties.Get_Configuration: IConfiguration;
begin
    Result := DefaultInterface.Configuration;
end;

procedure TMessageProperties.Set_Configuration(const pConfiguration: IConfiguration);
begin
  DefaultInterface.Set_Configuration(pConfiguration);
end;

procedure TMessageProperties._Set_Configuration(const pConfiguration: IConfiguration);
  { Warning: The property Configuration has a setter and a getter whose
    types do not match. Delphi was unable to generate a property of
    this sort and so is using a Variant as a passthrough. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.Configuration := pConfiguration;
end;

function TMessageProperties.Get_AutoGenerateTextBody: WordBool;
begin
    Result := DefaultInterface.AutoGenerateTextBody;
end;

procedure TMessageProperties.Set_AutoGenerateTextBody(pAutoGenerateTextBody: WordBool);
begin
  DefaultInterface.Set_AutoGenerateTextBody(pAutoGenerateTextBody);
end;

function TMessageProperties.Get_EnvelopeFields: Fields;
begin
    Result := DefaultInterface.EnvelopeFields;
end;

function TMessageProperties.Get_TextBodyPart: IBodyPart;
begin
    Result := DefaultInterface.TextBodyPart;
end;

function TMessageProperties.Get_HTMLBodyPart: IBodyPart;
begin
    Result := DefaultInterface.HTMLBodyPart;
end;

function TMessageProperties.Get_BodyPart: IBodyPart;
begin
    Result := DefaultInterface.BodyPart;
end;

function TMessageProperties.Get_DataSource: IDataSource;
begin
    Result := DefaultInterface.DataSource;
end;

function TMessageProperties.Get_Fields: Fields;
begin
    Result := DefaultInterface.Fields;
end;

function TMessageProperties.Get_MDNRequested: WordBool;
begin
    Result := DefaultInterface.MDNRequested;
end;

procedure TMessageProperties.Set_MDNRequested(pMDNRequested: WordBool);
begin
  DefaultInterface.Set_MDNRequested(pMDNRequested);
end;

{$ENDIF}

class function CoConfiguration.Create: IConfiguration;
begin
  Result := CreateComObject(CLASS_Configuration) as IConfiguration;
end;

class function CoConfiguration.CreateRemote(const MachineName: string): IConfiguration;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Configuration) as IConfiguration;
end;

procedure TConfiguration.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CD000002-8B95-11D1-82DB-00C04FB1625D}';
    IntfIID:   '{CD000022-8B95-11D1-82DB-00C04FB1625D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TConfiguration.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IConfiguration;
  end;
end;

procedure TConfiguration.ConnectTo(svrIntf: IConfiguration);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TConfiguration.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TConfiguration.GetDefaultInterface: IConfiguration;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TConfiguration.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TConfigurationProperties.Create(Self);
{$ENDIF}
end;

destructor TConfiguration.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TConfiguration.GetServerProperties: TConfigurationProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TConfiguration.Get_Fields: Fields;
begin
    Result := DefaultInterface.Fields;
end;

procedure TConfiguration.Load(LoadFrom: CdoConfigSource; const URL: WideString);
begin
  DefaultInterface.Load(LoadFrom, URL);
end;

function TConfiguration.GetInterface(const Interface_: WideString): IDispatch;
begin
  Result := DefaultInterface.GetInterface(Interface_);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TConfigurationProperties.Create(AServer: TConfiguration);
begin
  inherited Create;
  FServer := AServer;
end;

function TConfigurationProperties.GetDefaultInterface: IConfiguration;
begin
  Result := FServer.DefaultInterface;
end;

function TConfigurationProperties.Get_Fields: Fields;
begin
    Result := DefaultInterface.Fields;
end;

{$ENDIF}

class function CoDropDirectory.Create: IDropDirectory;
begin
  Result := CreateComObject(CLASS_DropDirectory) as IDropDirectory;
end;

class function CoDropDirectory.CreateRemote(const MachineName: string): IDropDirectory;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DropDirectory) as IDropDirectory;
end;

procedure TDropDirectory.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{CD000004-8B95-11D1-82DB-00C04FB1625D}';
    IntfIID:   '{CD000024-8B95-11D1-82DB-00C04FB1625D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TDropDirectory.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IDropDirectory;
  end;
end;

procedure TDropDirectory.ConnectTo(svrIntf: IDropDirectory);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TDropDirectory.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TDropDirectory.GetDefaultInterface: IDropDirectory;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TDropDirectory.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TDropDirectoryProperties.Create(Self);
{$ENDIF}
end;

destructor TDropDirectory.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TDropDirectory.GetServerProperties: TDropDirectoryProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TDropDirectory.GetMessages(const DirName: WideString): IMessages;
begin
  Result := DefaultInterface.GetMessages(DirName);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TDropDirectoryProperties.Create(AServer: TDropDirectory);
begin
  inherited Create;
  FServer := AServer;
end;

function TDropDirectoryProperties.GetDefaultInterface: IDropDirectory;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

class function CoSMTPConnector.Create: ISMTPScriptConnector;
begin
  Result := CreateComObject(CLASS_SMTPConnector) as ISMTPScriptConnector;
end;

class function CoSMTPConnector.CreateRemote(const MachineName: string): ISMTPScriptConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SMTPConnector) as ISMTPScriptConnector;
end;

class function CoNNTPEarlyConnector.Create: INNTPEarlyScriptConnector;
begin
  Result := CreateComObject(CLASS_NNTPEarlyConnector) as INNTPEarlyScriptConnector;
end;

class function CoNNTPEarlyConnector.CreateRemote(const MachineName: string): INNTPEarlyScriptConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NNTPEarlyConnector) as INNTPEarlyScriptConnector;
end;

class function CoNNTPPostConnector.Create: INNTPPostScriptConnector;
begin
  Result := CreateComObject(CLASS_NNTPPostConnector) as INNTPPostScriptConnector;
end;

class function CoNNTPPostConnector.CreateRemote(const MachineName: string): INNTPPostScriptConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NNTPPostConnector) as INNTPPostScriptConnector;
end;

class function CoNNTPFinalConnector.Create: INNTPFinalScriptConnector;
begin
  Result := CreateComObject(CLASS_NNTPFinalConnector) as INNTPFinalScriptConnector;
end;

class function CoNNTPFinalConnector.CreateRemote(const MachineName: string): INNTPFinalScriptConnector;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_NNTPFinalConnector) as INNTPFinalScriptConnector;
end;

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TMessage, TConfiguration, TDropDirectory]);
end;

end.
