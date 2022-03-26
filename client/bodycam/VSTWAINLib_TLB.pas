unit VSTWAINLib_TLB;

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
// File generated on 13.06.2008 7:59:58 from Type Library described below.

// ************************************************************************  //
// Type Lib: VSTwain.dll (1)
// LIBID: {1169E0C0-9E76-11D7-B1D8-FB63945DE96D}
// LCID: 0
// Helpfile: C:\!!!!!!!!!!!\vstwain.hlp
// HelpString: VintaSoftTwain Control v3.7
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: Enum Member 'Array' of 'enumCapType' changed to 'Array_'
//   Hint: Enum Member 'File' of 'enumTransferMode' changed to 'File_'
//   Hint: Enum Member 'Array' of 'enumCapType' changed to 'Array_'
//   Hint: Enum Member 'File' of 'enumTransferMode' changed to 'File_'
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

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VSTWAINLibMajorVersion = 1;
  VSTWAINLibMinorVersion = 0;

  LIBID_VSTWAINLib: TGUID = '{1169E0C0-9E76-11D7-B1D8-FB63945DE96D}';

  DIID__IVintaSoftTwainEvents: TGUID = '{1169E0CE-9E76-11D7-B1D8-FB63945DE96D}';
  IID_IVintaSoftTwain: TGUID = '{1169E0CC-9E76-11D7-B1D8-FB63945DE96D}';
  CLASS_VintaSoftTwain: TGUID = '{1169E0CD-9E76-11D7-B1D8-FB63945DE96D}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum enumUnitOfMeasure
type
  enumUnitOfMeasure = TOleEnum;
const
  Inches = $00000000;
  Centimeters = $00000001;
  Picas = $00000002;
  Points = $00000003;
  Twips = $00000004;
  Pixels = $00000005;

// Constants for enum enumPixelType
type
  enumPixelType = TOleEnum;
const
  BW = $00000000;
  Gray = $00000001;
  RGB = $00000002;
  Palette = $00000003;
  CMY = $00000004;
  CMYK = $00000005;
  YUV = $00000006;
  YUVK = $00000007;

// Constants for enum enumTiffCompression
type
  enumTiffCompression = TOleEnum;
const
  None = $00000000;
  Packbits = $00000001;
  CCITT_Rle = $00000002;
  CCITT_Group3Fax = $00000003;
  CCITT_Group4Fax = $00000004;
  LZW = $00000005;
  Auto = $00000006;

// Constants for enum enumCapType
type
  enumCapType = TOleEnum;
const
  OneValue = $00000001;
  Array_ = $00000002;
  Range = $00000003;
  Enum = $00000004;

// Constants for enum enumTransferMode
type
  enumTransferMode = TOleEnum;
const
  Native = $00000000;
  Memory = $00000001;
  File_ = $00000002;

// Constants for enum enumFileFormat
type
  enumFileFormat = TOleEnum;
const
  Tiff = $00000000;
  Pict = $00000001;
  Bmp = $00000002;
  XBM = $00000003;
  Jpeg = $00000004;
  FlashPix = $00000005;
  TiffMulti = $00000006;
  Png = $00000007;
  SPIFF = $00000008;
  EXIF = $00000009;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IVintaSoftTwainEvents = dispinterface;
  IVintaSoftTwain = interface;
  IVintaSoftTwainDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  VintaSoftTwain = IVintaSoftTwain;


// *********************************************************************//
// DispIntf:  _IVintaSoftTwainEvents
// Flags:     (4096) Dispatchable
// GUID:      {1169E0CE-9E76-11D7-B1D8-FB63945DE96D}
// *********************************************************************//
  _IVintaSoftTwainEvents = dispinterface
    ['{1169E0CE-9E76-11D7-B1D8-FB63945DE96D}']
    procedure PostScan(flag: Integer); dispid 1;
  end;

// *********************************************************************//
// Interface: IVintaSoftTwain
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1169E0CC-9E76-11D7-B1D8-FB63945DE96D}
// *********************************************************************//
  IVintaSoftTwain = interface(IDispatch)
    ['{1169E0CC-9E76-11D7-B1D8-FB63945DE96D}']
    function StartDevice: Integer; safecall;
    procedure StopDevice; safecall;
    function SelectSource: Integer; safecall;
    function GetSourceProductName(index: Integer): WideString; safecall;
    function Acquire: Integer; safecall;
    function GetImage(index: Integer): IPictureDisp; safecall;
    function GetCurrentImage: IPictureDisp; safecall;
    function GetImageAsHBitmap(index: Integer): Integer; safecall;
    function GetCurrentImageAsHBitmap: Integer; safecall;
    function Register(const user: WideString; const email: WideString; const regCode: WideString): Integer; safecall;
    function Get_disableAfterAcquire: Integer; safecall;
    procedure Set_disableAfterAcquire(pVal: Integer); safecall;
    function Get_showUI: Integer; safecall;
    procedure Set_showUI(pVal: Integer); safecall;
    function Get_autoCleanBuffer: Integer; safecall;
    procedure Set_autoCleanBuffer(pVal: Integer); safecall;
    function Get_sourcesCount: Integer; safecall;
    function Get_sourceIndex: Integer; safecall;
    procedure Set_sourceIndex(pVal: Integer); safecall;
    function Get_maxImages: Integer; safecall;
    procedure Set_maxImages(pVal: Integer); safecall;
    function Get_numImages: Integer; safecall;
    function Get_errorCode: Integer; safecall;
    function Get_errorString: WideString; safecall;
    function SaveImage(index: Integer; const path: WideString): Integer; safecall;
    function Get_jpegQuality: SYSINT; safecall;
    procedure Set_jpegQuality(pVal: SYSINT); safecall;
    function OpenDataSource: Integer; safecall;
    function CloseDataSource: Integer; safecall;
    function Get_xferCount: Integer; safecall;
    procedure Set_xferCount(pVal: Integer); safecall;
    function Get_feederPresent: Integer; safecall;
    function Get_feederEnabled: Integer; safecall;
    procedure Set_feederEnabled(pVal: Integer); safecall;
    function Get_feederLoaded: Integer; safecall;
    function Get_autoFeed: Integer; safecall;
    procedure Set_autoFeed(pVal: Integer); safecall;
    function Get_paperDetectable: Integer; safecall;
    function SetFtpServerParams(const host: WideString; port: SYSINT; const user: WideString; 
                                const password: WideString; const account: WideString): Integer; safecall;
    procedure SetFtpServerAdvParams(passiveMode: Integer; timeout: Integer); safecall;
    function SetFtpProxyServerParams(proxyType: SYSINT; const host: WideString; port: SYSINT; 
                                     const user: WideString; const password: WideString): Integer; safecall;
    function SaveImageToFtp(index: Integer; const serverPath: WideString): Integer; safecall;
    function Get_resolution: Integer; safecall;
    procedure Set_resolution(pVal: Integer); safecall;
    function GetResolutions: OleVariant; safecall;
    function Get_unitOfMeasure: enumUnitOfMeasure; safecall;
    procedure Set_unitOfMeasure(pVal: enumUnitOfMeasure); safecall;
    function GetUnitsOfMeasure: OleVariant; safecall;
    function Get_pixelType: enumPixelType; safecall;
    procedure Set_pixelType(pVal: enumPixelType); safecall;
    function GetPixelTypes: OleVariant; safecall;
    function Get_modalUI: Integer; safecall;
    procedure Set_modalUI(pVal: Integer); safecall;
    function GetImageLayout(out left: Single; out top: Single; out right: Single; out bottom: Single): Integer; safecall;
    function SetImageLayout(left: Single; top: Single; right: Single; bottom: Single): Integer; safecall;
    function Get_pageSize: Integer; safecall;
    procedure Set_pageSize(pVal: Integer); safecall;
    function GetPageSizes: OleVariant; safecall;
    function Get_brightness: Single; safecall;
    procedure Set_brightness(pVal: Single); safecall;
    function Get_brightnessMinValue: Single; safecall;
    function Get_brightnessMaxValue: Single; safecall;
    function Get_autoBright: Integer; safecall;
    procedure Set_autoBright(pVal: Integer); safecall;
    function Get_contrast: Single; safecall;
    procedure Set_contrast(pVal: Single); safecall;
    function Get_contrastMinValue: Single; safecall;
    function Get_contrastMaxValue: Single; safecall;
    function Get_tiffCompression: enumTiffCompression; safecall;
    procedure Set_tiffCompression(pVal: enumTiffCompression); safecall;
    function Get_tiffMultiPage: Integer; safecall;
    procedure Set_tiffMultiPage(pVal: Integer); safecall;
    function Get_ftpState: Smallint; safecall;
    function Get_ftpStateString: WideString; safecall;
    function Get_ftpBytesTotal: Integer; safecall;
    function Get_ftpBytesUploaded: Integer; safecall;
    function Get_ftpErrorCode: Smallint; safecall;
    function Get_ftpErrorString: WideString; safecall;
    procedure Set_ftpCancel(Param1: Integer); safecall;
    function Get_dataSourceState: Integer; safecall;
    function Get_pixelFlavor: Integer; safecall;
    procedure Set_pixelFlavor(pVal: Integer); safecall;
    function Get_duplex: Integer; safecall;
    function Get_duplexEnabled: Integer; safecall;
    procedure Set_duplexEnabled(pVal: Integer); safecall;
    function GetImageAsByteArray(index: Integer): OleVariant; safecall;
    function Get_endOfJob: Integer; safecall;
    function Get_capability: Integer; safecall;
    procedure Set_capability(pVal: Integer); safecall;
    function IsCapSupported: Integer; safecall;
    function Get_capType: enumCapType; safecall;
    procedure Set_capType(pVal: enumCapType); safecall;
    function Get_capValue: Single; safecall;
    procedure Set_capValue(pVal: Single); safecall;
    function Get_capStringValue: WideString; safecall;
    procedure Set_capStringValue(const pVal: WideString); safecall;
    function Get_capDefValue: Single; safecall;
    function Get_capMinValue: Single; safecall;
    procedure Set_capMinValue(pVal: Single); safecall;
    function Get_capMaxValue: Single; safecall;
    procedure Set_capMaxValue(pVal: Single); safecall;
    function Get_capStepSize: Integer; safecall;
    function Get_capNumItems: Integer; safecall;
    procedure Set_capNumItems(pVal: Integer); safecall;
    function Get_capItems: OleVariant; safecall;
    procedure Set_capItems(pVal: OleVariant); safecall;
    function GetCap: Integer; safecall;
    function SetCap: Integer; safecall;
    function IsBlankImage(index: Integer): Integer; safecall;
    function GetImageWidth(index: Integer): Integer; safecall;
    function GetImageHeight(index: Integer): Integer; safecall;
    function GetImageBPP(index: Integer): Integer; safecall;
    function GetImageXRes(index: Integer): Integer; safecall;
    function GetImageYRes(index: Integer): Integer; safecall;
    function SetHttpFormField(const fieldName: WideString; const fieldValue: WideString): Integer; safecall;
    function SetHttpServerParams(const url: WideString; const referer: WideString; timeout: Integer): Integer; safecall;
    function SetHttpProxyServerParams(const server: WideString; port: SYSINT): Integer; safecall;
    function SaveImageToHttp(index: Integer; const fieldName: WideString; const fileName: WideString): Integer; safecall;
    function Get_httpState: Smallint; safecall;
    function Get_httpStateString: WideString; safecall;
    function Get_httpBytesTotal: Integer; safecall;
    function Get_httpBytesUploaded: Integer; safecall;
    function Get_httpErrorCode: Smallint; safecall;
    function Get_httpErrorString: WideString; safecall;
    procedure Set_httpCancel(Param1: Integer); safecall;
    function Get_appProductName: WideString; safecall;
    procedure Set_appProductName(const pVal: WideString); safecall;
    function Get_httpResponseString: WideString; safecall;
    function Get_cancelTransfer: Integer; safecall;
    procedure Set_cancelTransfer(pVal: Integer); safecall;
    function SetHttpFileFromDisk(const filePath: WideString): Integer; safecall;
    function GetImageAsDIB(index: Integer): OleVariant; safecall;
    function Get_httpResponseCode: Integer; safecall;
    function AcquireModal: Integer; safecall;
    function Get_transferMode: enumTransferMode; safecall;
    procedure Set_transferMode(pVal: enumTransferMode); safecall;
    function Get_noiseLevelInBlankImage: Single; safecall;
    procedure Set_noiseLevelInBlankImage(pVal: Single); safecall;
    function DeleteImage(index: Integer): Integer; safecall;
    function GetImageAsHDIB(index: Integer): Integer; safecall;
    function DespeckleImage(index: Integer; level1: SYSINT; level2: SYSINT; radius: SYSINT; 
                            level3: SYSINT): Integer; safecall;
    function DetectImageBorder(index: Integer; borderSize: SYSINT): Integer; safecall;
    function RotateImage(index: Integer; rotationAngle: Integer): Integer; safecall;
    function SetupSource: Integer; safecall;
    function Get_fileName: WideString; safecall;
    procedure Set_fileName(const pVal: WideString); safecall;
    function Get_fileFormat: enumFileFormat; safecall;
    procedure Set_fileFormat(pVal: enumFileFormat); safecall;
    function SetHttpCookie(const cookieValue: WideString): Integer; safecall;
    property disableAfterAcquire: Integer read Get_disableAfterAcquire write Set_disableAfterAcquire;
    property showUI: Integer read Get_showUI write Set_showUI;
    property autoCleanBuffer: Integer read Get_autoCleanBuffer write Set_autoCleanBuffer;
    property sourcesCount: Integer read Get_sourcesCount;
    property sourceIndex: Integer read Get_sourceIndex write Set_sourceIndex;
    property maxImages: Integer read Get_maxImages write Set_maxImages;
    property numImages: Integer read Get_numImages;
    property errorCode: Integer read Get_errorCode;
    property errorString: WideString read Get_errorString;
    property jpegQuality: SYSINT read Get_jpegQuality write Set_jpegQuality;
    property xferCount: Integer read Get_xferCount write Set_xferCount;
    property feederPresent: Integer read Get_feederPresent;
    property feederEnabled: Integer read Get_feederEnabled write Set_feederEnabled;
    property feederLoaded: Integer read Get_feederLoaded;
    property autoFeed: Integer read Get_autoFeed write Set_autoFeed;
    property paperDetectable: Integer read Get_paperDetectable;
    property resolution: Integer read Get_resolution write Set_resolution;
    property unitOfMeasure: enumUnitOfMeasure read Get_unitOfMeasure write Set_unitOfMeasure;
    property pixelType: enumPixelType read Get_pixelType write Set_pixelType;
    property modalUI: Integer read Get_modalUI write Set_modalUI;
    property pageSize: Integer read Get_pageSize write Set_pageSize;
    property brightness: Single read Get_brightness write Set_brightness;
    property brightnessMinValue: Single read Get_brightnessMinValue;
    property brightnessMaxValue: Single read Get_brightnessMaxValue;
    property autoBright: Integer read Get_autoBright write Set_autoBright;
    property contrast: Single read Get_contrast write Set_contrast;
    property contrastMinValue: Single read Get_contrastMinValue;
    property contrastMaxValue: Single read Get_contrastMaxValue;
    property tiffCompression: enumTiffCompression read Get_tiffCompression write Set_tiffCompression;
    property tiffMultiPage: Integer read Get_tiffMultiPage write Set_tiffMultiPage;
    property ftpState: Smallint read Get_ftpState;
    property ftpStateString: WideString read Get_ftpStateString;
    property ftpBytesTotal: Integer read Get_ftpBytesTotal;
    property ftpBytesUploaded: Integer read Get_ftpBytesUploaded;
    property ftpErrorCode: Smallint read Get_ftpErrorCode;
    property ftpErrorString: WideString read Get_ftpErrorString;
    property ftpCancel: Integer write Set_ftpCancel;
    property dataSourceState: Integer read Get_dataSourceState;
    property pixelFlavor: Integer read Get_pixelFlavor write Set_pixelFlavor;
    property duplex: Integer read Get_duplex;
    property duplexEnabled: Integer read Get_duplexEnabled write Set_duplexEnabled;
    property endOfJob: Integer read Get_endOfJob;
    property capability: Integer read Get_capability write Set_capability;
    property capType: enumCapType read Get_capType write Set_capType;
    property capValue: Single read Get_capValue write Set_capValue;
    property capStringValue: WideString read Get_capStringValue write Set_capStringValue;
    property capDefValue: Single read Get_capDefValue;
    property capMinValue: Single read Get_capMinValue write Set_capMinValue;
    property capMaxValue: Single read Get_capMaxValue write Set_capMaxValue;
    property capStepSize: Integer read Get_capStepSize;
    property capNumItems: Integer read Get_capNumItems write Set_capNumItems;
    property capItems: OleVariant read Get_capItems write Set_capItems;
    property httpState: Smallint read Get_httpState;
    property httpStateString: WideString read Get_httpStateString;
    property httpBytesTotal: Integer read Get_httpBytesTotal;
    property httpBytesUploaded: Integer read Get_httpBytesUploaded;
    property httpErrorCode: Smallint read Get_httpErrorCode;
    property httpErrorString: WideString read Get_httpErrorString;
    property httpCancel: Integer write Set_httpCancel;
    property appProductName: WideString read Get_appProductName write Set_appProductName;
    property httpResponseString: WideString read Get_httpResponseString;
    property cancelTransfer: Integer read Get_cancelTransfer write Set_cancelTransfer;
    property httpResponseCode: Integer read Get_httpResponseCode;
    property transferMode: enumTransferMode read Get_transferMode write Set_transferMode;
    property noiseLevelInBlankImage: Single read Get_noiseLevelInBlankImage write Set_noiseLevelInBlankImage;
    property fileName: WideString read Get_fileName write Set_fileName;
    property fileFormat: enumFileFormat read Get_fileFormat write Set_fileFormat;
  end;

// *********************************************************************//
// DispIntf:  IVintaSoftTwainDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1169E0CC-9E76-11D7-B1D8-FB63945DE96D}
// *********************************************************************//
  IVintaSoftTwainDisp = dispinterface
    ['{1169E0CC-9E76-11D7-B1D8-FB63945DE96D}']
    function StartDevice: Integer; dispid 1;
    procedure StopDevice; dispid 2;
    function SelectSource: Integer; dispid 3;
    function GetSourceProductName(index: Integer): WideString; dispid 4;
    function Acquire: Integer; dispid 5;
    function GetImage(index: Integer): IPictureDisp; dispid 6;
    function GetCurrentImage: IPictureDisp; dispid 7;
    function GetImageAsHBitmap(index: Integer): Integer; dispid 8;
    function GetCurrentImageAsHBitmap: Integer; dispid 9;
    function Register(const user: WideString; const email: WideString; const regCode: WideString): Integer; dispid 10;
    property disableAfterAcquire: Integer dispid 11;
    property showUI: Integer dispid 12;
    property autoCleanBuffer: Integer dispid 13;
    property sourcesCount: Integer readonly dispid 14;
    property sourceIndex: Integer dispid 15;
    property maxImages: Integer dispid 16;
    property numImages: Integer readonly dispid 17;
    property errorCode: Integer readonly dispid 18;
    property errorString: WideString readonly dispid 19;
    function SaveImage(index: Integer; const path: WideString): Integer; dispid 20;
    property jpegQuality: SYSINT dispid 21;
    function OpenDataSource: Integer; dispid 22;
    function CloseDataSource: Integer; dispid 23;
    property xferCount: Integer dispid 24;
    property feederPresent: Integer readonly dispid 25;
    property feederEnabled: Integer dispid 26;
    property feederLoaded: Integer readonly dispid 27;
    property autoFeed: Integer dispid 28;
    property paperDetectable: Integer readonly dispid 29;
    function SetFtpServerParams(const host: WideString; port: SYSINT; const user: WideString; 
                                const password: WideString; const account: WideString): Integer; dispid 30;
    procedure SetFtpServerAdvParams(passiveMode: Integer; timeout: Integer); dispid 31;
    function SetFtpProxyServerParams(proxyType: SYSINT; const host: WideString; port: SYSINT; 
                                     const user: WideString; const password: WideString): Integer; dispid 32;
    function SaveImageToFtp(index: Integer; const serverPath: WideString): Integer; dispid 33;
    property resolution: Integer dispid 34;
    function GetResolutions: OleVariant; dispid 35;
    property unitOfMeasure: enumUnitOfMeasure dispid 36;
    function GetUnitsOfMeasure: OleVariant; dispid 37;
    property pixelType: enumPixelType dispid 38;
    function GetPixelTypes: OleVariant; dispid 39;
    property modalUI: Integer dispid 41;
    function GetImageLayout(out left: Single; out top: Single; out right: Single; out bottom: Single): Integer; dispid 42;
    function SetImageLayout(left: Single; top: Single; right: Single; bottom: Single): Integer; dispid 43;
    property pageSize: Integer dispid 44;
    function GetPageSizes: OleVariant; dispid 45;
    property brightness: Single dispid 46;
    property brightnessMinValue: Single readonly dispid 47;
    property brightnessMaxValue: Single readonly dispid 48;
    property autoBright: Integer dispid 49;
    property contrast: Single dispid 50;
    property contrastMinValue: Single readonly dispid 51;
    property contrastMaxValue: Single readonly dispid 52;
    property tiffCompression: enumTiffCompression dispid 53;
    property tiffMultiPage: Integer dispid 54;
    property ftpState: Smallint readonly dispid 55;
    property ftpStateString: WideString readonly dispid 56;
    property ftpBytesTotal: Integer readonly dispid 57;
    property ftpBytesUploaded: Integer readonly dispid 58;
    property ftpErrorCode: Smallint readonly dispid 59;
    property ftpErrorString: WideString readonly dispid 60;
    property ftpCancel: Integer writeonly dispid 61;
    property dataSourceState: Integer readonly dispid 62;
    property pixelFlavor: Integer dispid 63;
    property duplex: Integer readonly dispid 64;
    property duplexEnabled: Integer dispid 65;
    function GetImageAsByteArray(index: Integer): OleVariant; dispid 66;
    property endOfJob: Integer readonly dispid 67;
    property capability: Integer dispid 68;
    function IsCapSupported: Integer; dispid 69;
    property capType: enumCapType dispid 70;
    property capValue: Single dispid 71;
    property capStringValue: WideString dispid 72;
    property capDefValue: Single readonly dispid 73;
    property capMinValue: Single dispid 74;
    property capMaxValue: Single dispid 75;
    property capStepSize: Integer readonly dispid 76;
    property capNumItems: Integer dispid 77;
    property capItems: OleVariant dispid 78;
    function GetCap: Integer; dispid 79;
    function SetCap: Integer; dispid 80;
    function IsBlankImage(index: Integer): Integer; dispid 81;
    function GetImageWidth(index: Integer): Integer; dispid 82;
    function GetImageHeight(index: Integer): Integer; dispid 83;
    function GetImageBPP(index: Integer): Integer; dispid 84;
    function GetImageXRes(index: Integer): Integer; dispid 85;
    function GetImageYRes(index: Integer): Integer; dispid 86;
    function SetHttpFormField(const fieldName: WideString; const fieldValue: WideString): Integer; dispid 87;
    function SetHttpServerParams(const url: WideString; const referer: WideString; timeout: Integer): Integer; dispid 88;
    function SetHttpProxyServerParams(const server: WideString; port: SYSINT): Integer; dispid 89;
    function SaveImageToHttp(index: Integer; const fieldName: WideString; const fileName: WideString): Integer; dispid 90;
    property httpState: Smallint readonly dispid 91;
    property httpStateString: WideString readonly dispid 92;
    property httpBytesTotal: Integer readonly dispid 93;
    property httpBytesUploaded: Integer readonly dispid 94;
    property httpErrorCode: Smallint readonly dispid 95;
    property httpErrorString: WideString readonly dispid 96;
    property httpCancel: Integer writeonly dispid 97;
    property appProductName: WideString dispid 98;
    property httpResponseString: WideString readonly dispid 99;
    property cancelTransfer: Integer dispid 100;
    function SetHttpFileFromDisk(const filePath: WideString): Integer; dispid 101;
    function GetImageAsDIB(index: Integer): OleVariant; dispid 102;
    property httpResponseCode: Integer readonly dispid 103;
    function AcquireModal: Integer; dispid 104;
    property transferMode: enumTransferMode dispid 105;
    property noiseLevelInBlankImage: Single dispid 106;
    function DeleteImage(index: Integer): Integer; dispid 107;
    function GetImageAsHDIB(index: Integer): Integer; dispid 108;
    function DespeckleImage(index: Integer; level1: SYSINT; level2: SYSINT; radius: SYSINT; 
                            level3: SYSINT): Integer; dispid 109;
    function DetectImageBorder(index: Integer; borderSize: SYSINT): Integer; dispid 110;
    function RotateImage(index: Integer; rotationAngle: Integer): Integer; dispid 111;
    function SetupSource: Integer; dispid 112;
    property fileName: WideString dispid 113;
    property fileFormat: enumFileFormat dispid 114;
    function SetHttpCookie(const cookieValue: WideString): Integer; dispid 115;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TVintaSoftTwain
// Help String      : VintaSoftTwain Control v3.7
// Default Interface: IVintaSoftTwain
// Def. Intf. DISP? : No
// Event   Interface: _IVintaSoftTwainEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TVintaSoftTwainPostScan = procedure(ASender: TObject; flag: Integer) of object;

  TVintaSoftTwain = class(TOleControl)
  private
    FOnPostScan: TVintaSoftTwainPostScan;
    FIntf: IVintaSoftTwain;
    function  GetControlInterface: IVintaSoftTwain;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_capItems: OleVariant;
    procedure Set_capItems(pVal: OleVariant);
  public
    function StartDevice: Integer;
    procedure StopDevice;
    function SelectSource: Integer;
    function GetSourceProductName(index: Integer): WideString;
    function Acquire: Integer;
    function GetImage(index: Integer): IPictureDisp;
    function GetCurrentImage: IPictureDisp;
    function GetImageAsHBitmap(index: Integer): Integer;
    function GetCurrentImageAsHBitmap: Integer;
    function Register(const user: WideString; const email: WideString; const regCode: WideString): Integer;
    function SaveImage(index: Integer; const path: WideString): Integer;
    function OpenDataSource: Integer;
    function CloseDataSource: Integer;
    function SetFtpServerParams(const host: WideString; port: SYSINT; const user: WideString; 
                                const password: WideString; const account: WideString): Integer;
    procedure SetFtpServerAdvParams(passiveMode: Integer; timeout: Integer);
    function SetFtpProxyServerParams(proxyType: SYSINT; const host: WideString; port: SYSINT; 
                                     const user: WideString; const password: WideString): Integer;
    function SaveImageToFtp(index: Integer; const serverPath: WideString): Integer;
    function GetResolutions: OleVariant;
    function GetUnitsOfMeasure: OleVariant;
    function GetPixelTypes: OleVariant;
    function GetImageLayout(out left: Single; out top: Single; out right: Single; out bottom: Single): Integer;
    function SetImageLayout(left: Single; top: Single; right: Single; bottom: Single): Integer;
    function GetPageSizes: OleVariant;
    function GetImageAsByteArray(index: Integer): OleVariant;
    function IsCapSupported: Integer;
    function GetCap: Integer;
    function SetCap: Integer;
    function IsBlankImage(index: Integer): Integer;
    function GetImageWidth(index: Integer): Integer;
    function GetImageHeight(index: Integer): Integer;
    function GetImageBPP(index: Integer): Integer;
    function GetImageXRes(index: Integer): Integer;
    function GetImageYRes(index: Integer): Integer;
    function SetHttpFormField(const fieldName: WideString; const fieldValue: WideString): Integer;
    function SetHttpServerParams(const url: WideString; const referer: WideString; timeout: Integer): Integer;
    function SetHttpProxyServerParams(const server: WideString; port: SYSINT): Integer;
    function SaveImageToHttp(index: Integer; const fieldName: WideString; const fileName: WideString): Integer;
    function SetHttpFileFromDisk(const filePath: WideString): Integer;
    function GetImageAsDIB(index: Integer): OleVariant;
    function AcquireModal: Integer;
    function DeleteImage(index: Integer): Integer;
    function GetImageAsHDIB(index: Integer): Integer;
    function DespeckleImage(index: Integer; level1: SYSINT; level2: SYSINT; radius: SYSINT; 
                            level3: SYSINT): Integer;
    function DetectImageBorder(index: Integer; borderSize: SYSINT): Integer;
    function RotateImage(index: Integer; rotationAngle: Integer): Integer;
    function SetupSource: Integer;
    function SetHttpCookie(const cookieValue: WideString): Integer;
    property  ControlInterface: IVintaSoftTwain read GetControlInterface;
    property  DefaultInterface: IVintaSoftTwain read GetControlInterface;
    property sourcesCount: Integer index 14 read GetIntegerProp;
    property numImages: Integer index 17 read GetIntegerProp;
    property errorCode: Integer index 18 read GetIntegerProp;
    property errorString: WideString index 19 read GetWideStringProp;
    property feederPresent: Integer index 25 read GetIntegerProp;
    property feederLoaded: Integer index 27 read GetIntegerProp;
    property paperDetectable: Integer index 29 read GetIntegerProp;
    property brightnessMinValue: Single index 47 read GetSingleProp;
    property brightnessMaxValue: Single index 48 read GetSingleProp;
    property contrastMinValue: Single index 51 read GetSingleProp;
    property contrastMaxValue: Single index 52 read GetSingleProp;
    property ftpState: Smallint index 55 read GetSmallintProp;
    property ftpStateString: WideString index 56 read GetWideStringProp;
    property ftpBytesTotal: Integer index 57 read GetIntegerProp;
    property ftpBytesUploaded: Integer index 58 read GetIntegerProp;
    property ftpErrorCode: Smallint index 59 read GetSmallintProp;
    property ftpErrorString: WideString index 60 read GetWideStringProp;
    property ftpCancel: Integer index 61 write SetIntegerProp;
    property dataSourceState: Integer index 62 read GetIntegerProp;
    property duplex: Integer index 64 read GetIntegerProp;
    property endOfJob: Integer index 67 read GetIntegerProp;
    property capDefValue: Single index 73 read GetSingleProp;
    property capStepSize: Integer index 76 read GetIntegerProp;
    property capItems: OleVariant index 78 read GetOleVariantProp write SetOleVariantProp;
    property httpState: Smallint index 91 read GetSmallintProp;
    property httpStateString: WideString index 92 read GetWideStringProp;
    property httpBytesTotal: Integer index 93 read GetIntegerProp;
    property httpBytesUploaded: Integer index 94 read GetIntegerProp;
    property httpErrorCode: Smallint index 95 read GetSmallintProp;
    property httpErrorString: WideString index 96 read GetWideStringProp;
    property httpCancel: Integer index 97 write SetIntegerProp;
    property httpResponseString: WideString index 99 read GetWideStringProp;
    property httpResponseCode: Integer index 103 read GetIntegerProp;
  published
    property Anchors;
    property disableAfterAcquire: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property showUI: Integer index 12 read GetIntegerProp write SetIntegerProp stored False;
    property autoCleanBuffer: Integer index 13 read GetIntegerProp write SetIntegerProp stored False;
    property sourceIndex: Integer index 15 read GetIntegerProp write SetIntegerProp stored False;
    property maxImages: Integer index 16 read GetIntegerProp write SetIntegerProp stored False;
    property jpegQuality: Integer index 21 read GetIntegerProp write SetIntegerProp stored False;
    property xferCount: Integer index 24 read GetIntegerProp write SetIntegerProp stored False;
    property feederEnabled: Integer index 26 read GetIntegerProp write SetIntegerProp stored False;
    property autoFeed: Integer index 28 read GetIntegerProp write SetIntegerProp stored False;
    property resolution: Integer index 34 read GetIntegerProp write SetIntegerProp stored False;
    property unitOfMeasure: TOleEnum index 36 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property pixelType: TOleEnum index 38 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property modalUI: Integer index 41 read GetIntegerProp write SetIntegerProp stored False;
    property pageSize: Integer index 44 read GetIntegerProp write SetIntegerProp stored False;
    property brightness: Single index 46 read GetSingleProp write SetSingleProp stored False;
    property autoBright: Integer index 49 read GetIntegerProp write SetIntegerProp stored False;
    property contrast: Single index 50 read GetSingleProp write SetSingleProp stored False;
    property tiffCompression: TOleEnum index 53 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property tiffMultiPage: Integer index 54 read GetIntegerProp write SetIntegerProp stored False;
    property pixelFlavor: Integer index 63 read GetIntegerProp write SetIntegerProp stored False;
    property duplexEnabled: Integer index 65 read GetIntegerProp write SetIntegerProp stored False;
    property capability: Integer index 68 read GetIntegerProp write SetIntegerProp stored False;
    property capType: TOleEnum index 70 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property capValue: Single index 71 read GetSingleProp write SetSingleProp stored False;
    property capStringValue: WideString index 72 read GetWideStringProp write SetWideStringProp stored False;
    property capMinValue: Single index 74 read GetSingleProp write SetSingleProp stored False;
    property capMaxValue: Single index 75 read GetSingleProp write SetSingleProp stored False;
    property capNumItems: Integer index 77 read GetIntegerProp write SetIntegerProp stored False;
    property appProductName: WideString index 98 read GetWideStringProp write SetWideStringProp stored False;
    property cancelTransfer: Integer index 100 read GetIntegerProp write SetIntegerProp stored False;
    property transferMode: TOleEnum index 105 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property noiseLevelInBlankImage: Single index 106 read GetSingleProp write SetSingleProp stored False;
    property fileName: WideString index 113 read GetWideStringProp write SetWideStringProp stored False;
    property fileFormat: TOleEnum index 114 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property OnPostScan: TVintaSoftTwainPostScan read FOnPostScan write FOnPostScan;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TVintaSoftTwain.InitControlData;
const
  CEventDispIDs: array [0..0] of DWORD = (
    $00000001);
  CControlData: TControlData2 = (
    ClassID: '{1169E0CD-9E76-11D7-B1D8-FB63945DE96D}';
    EventIID: '{1169E0CE-9E76-11D7-B1D8-FB63945DE96D}';
    EventCount: 1;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnPostScan) - Cardinal(Self);
end;

procedure TVintaSoftTwain.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IVintaSoftTwain;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TVintaSoftTwain.GetControlInterface: IVintaSoftTwain;
begin
  CreateControl;
  Result := FIntf;
end;

function TVintaSoftTwain.Get_capItems: OleVariant;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.capItems;
end;

procedure TVintaSoftTwain.Set_capItems(pVal: OleVariant);
begin
  DefaultInterface.Set_capItems(pVal);
end;

function TVintaSoftTwain.StartDevice: Integer;
begin
  Result := DefaultInterface.StartDevice;
end;

procedure TVintaSoftTwain.StopDevice;
begin
  DefaultInterface.StopDevice;
end;

function TVintaSoftTwain.SelectSource: Integer;
begin
  Result := DefaultInterface.SelectSource;
end;

function TVintaSoftTwain.GetSourceProductName(index: Integer): WideString;
begin
  Result := DefaultInterface.GetSourceProductName(index);
end;

function TVintaSoftTwain.Acquire: Integer;
begin
  Result := DefaultInterface.Acquire;
end;

function TVintaSoftTwain.GetImage(index: Integer): IPictureDisp;
begin
  Result := DefaultInterface.GetImage(index);
end;

function TVintaSoftTwain.GetCurrentImage: IPictureDisp;
begin
  Result := DefaultInterface.GetCurrentImage;
end;

function TVintaSoftTwain.GetImageAsHBitmap(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageAsHBitmap(index);
end;

function TVintaSoftTwain.GetCurrentImageAsHBitmap: Integer;
begin
  Result := DefaultInterface.GetCurrentImageAsHBitmap;
end;

function TVintaSoftTwain.Register(const user: WideString; const email: WideString; 
                                  const regCode: WideString): Integer;
begin
  Result := DefaultInterface.Register(user, email, regCode);
end;

function TVintaSoftTwain.SaveImage(index: Integer; const path: WideString): Integer;
begin
  Result := DefaultInterface.SaveImage(index, path);
end;

function TVintaSoftTwain.OpenDataSource: Integer;
begin
  Result := DefaultInterface.OpenDataSource;
end;

function TVintaSoftTwain.CloseDataSource: Integer;
begin
  Result := DefaultInterface.CloseDataSource;
end;

function TVintaSoftTwain.SetFtpServerParams(const host: WideString; port: SYSINT; 
                                            const user: WideString; const password: WideString; 
                                            const account: WideString): Integer;
begin
  Result := DefaultInterface.SetFtpServerParams(host, port, user, password, account);
end;

procedure TVintaSoftTwain.SetFtpServerAdvParams(passiveMode: Integer; timeout: Integer);
begin
  DefaultInterface.SetFtpServerAdvParams(passiveMode, timeout);
end;

function TVintaSoftTwain.SetFtpProxyServerParams(proxyType: SYSINT; const host: WideString; 
                                                 port: SYSINT; const user: WideString; 
                                                 const password: WideString): Integer;
begin
  Result := DefaultInterface.SetFtpProxyServerParams(proxyType, host, port, user, password);
end;

function TVintaSoftTwain.SaveImageToFtp(index: Integer; const serverPath: WideString): Integer;
begin
  Result := DefaultInterface.SaveImageToFtp(index, serverPath);
end;

function TVintaSoftTwain.GetResolutions: OleVariant;
begin
  Result := DefaultInterface.GetResolutions;
end;

function TVintaSoftTwain.GetUnitsOfMeasure: OleVariant;
begin
  Result := DefaultInterface.GetUnitsOfMeasure;
end;

function TVintaSoftTwain.GetPixelTypes: OleVariant;
begin
  Result := DefaultInterface.GetPixelTypes;
end;

function TVintaSoftTwain.GetImageLayout(out left: Single; out top: Single; out right: Single; 
                                        out bottom: Single): Integer;
begin
  Result := DefaultInterface.GetImageLayout(left, top, right, bottom);
end;

function TVintaSoftTwain.SetImageLayout(left: Single; top: Single; right: Single; bottom: Single): Integer;
begin
  Result := DefaultInterface.SetImageLayout(left, top, right, bottom);
end;

function TVintaSoftTwain.GetPageSizes: OleVariant;
begin
  Result := DefaultInterface.GetPageSizes;
end;

function TVintaSoftTwain.GetImageAsByteArray(index: Integer): OleVariant;
begin
  Result := DefaultInterface.GetImageAsByteArray(index);
end;

function TVintaSoftTwain.IsCapSupported: Integer;
begin
  Result := DefaultInterface.IsCapSupported;
end;

function TVintaSoftTwain.GetCap: Integer;
begin
  Result := DefaultInterface.GetCap;
end;

function TVintaSoftTwain.SetCap: Integer;
begin
  Result := DefaultInterface.SetCap;
end;

function TVintaSoftTwain.IsBlankImage(index: Integer): Integer;
begin
  Result := DefaultInterface.IsBlankImage(index);
end;

function TVintaSoftTwain.GetImageWidth(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageWidth(index);
end;

function TVintaSoftTwain.GetImageHeight(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageHeight(index);
end;

function TVintaSoftTwain.GetImageBPP(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageBPP(index);
end;

function TVintaSoftTwain.GetImageXRes(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageXRes(index);
end;

function TVintaSoftTwain.GetImageYRes(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageYRes(index);
end;

function TVintaSoftTwain.SetHttpFormField(const fieldName: WideString; const fieldValue: WideString): Integer;
begin
  Result := DefaultInterface.SetHttpFormField(fieldName, fieldValue);
end;

function TVintaSoftTwain.SetHttpServerParams(const url: WideString; const referer: WideString; 
                                             timeout: Integer): Integer;
begin
  Result := DefaultInterface.SetHttpServerParams(url, referer, timeout);
end;

function TVintaSoftTwain.SetHttpProxyServerParams(const server: WideString; port: SYSINT): Integer;
begin
  Result := DefaultInterface.SetHttpProxyServerParams(server, port);
end;

function TVintaSoftTwain.SaveImageToHttp(index: Integer; const fieldName: WideString; 
                                         const fileName: WideString): Integer;
begin
  Result := DefaultInterface.SaveImageToHttp(index, fieldName, fileName);
end;

function TVintaSoftTwain.SetHttpFileFromDisk(const filePath: WideString): Integer;
begin
  Result := DefaultInterface.SetHttpFileFromDisk(filePath);
end;

function TVintaSoftTwain.GetImageAsDIB(index: Integer): OleVariant;
begin
  Result := DefaultInterface.GetImageAsDIB(index);
end;

function TVintaSoftTwain.AcquireModal: Integer;
begin
  Result := DefaultInterface.AcquireModal;
end;

function TVintaSoftTwain.DeleteImage(index: Integer): Integer;
begin
  Result := DefaultInterface.DeleteImage(index);
end;

function TVintaSoftTwain.GetImageAsHDIB(index: Integer): Integer;
begin
  Result := DefaultInterface.GetImageAsHDIB(index);
end;

function TVintaSoftTwain.DespeckleImage(index: Integer; level1: SYSINT; level2: SYSINT; 
                                        radius: SYSINT; level3: SYSINT): Integer;
begin
  Result := DefaultInterface.DespeckleImage(index, level1, level2, radius, level3);
end;

function TVintaSoftTwain.DetectImageBorder(index: Integer; borderSize: SYSINT): Integer;
begin
  Result := DefaultInterface.DetectImageBorder(index, borderSize);
end;

function TVintaSoftTwain.RotateImage(index: Integer; rotationAngle: Integer): Integer;
begin
  Result := DefaultInterface.RotateImage(index, rotationAngle);
end;

function TVintaSoftTwain.SetupSource: Integer;
begin
  Result := DefaultInterface.SetupSource;
end;

function TVintaSoftTwain.SetHttpCookie(const cookieValue: WideString): Integer;
begin
  Result := DefaultInterface.SetHttpCookie(cookieValue);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TVintaSoftTwain]);
end;

end.
