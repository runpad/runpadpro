unit MSHTMLCustomUI;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Variants;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  IID_IHostDialogHelper: TGUID = '{53DEC138-A51E-11D2-861E-00C04FA35C89}';
  CLASS_HostDialogHelper: TGUID = '{429AF92C-A51F-11D2-861E-00C04FA35C89}';
  IID_IDocHostUIHandler: TGUID = '{BD3F23C0-D43E-11CF-893B-00AA00BDCE1A}';
  IID_IDocHostUIHandler2: TGUID = '{3050F6D0-98B5-11CF-BB82-00AA00BDCE0B}';
  IID_ICustomDoc: TGUID = '{3050F3F0-98B5-11CF-BB82-00AA00BDCE0B}';
  IID_IDocHostShowUI: TGUID = '{C4D244B0-D43E-11CF-893B-00AA00BDCE1A}';
  IID_IHTMLOMWindowServices: TGUID = '{3050F5FC-98B5-11CF-BB82-00AA00BDCE0B}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum tagDOCHOSTUITYPE
type
  tagDOCHOSTUITYPE = TOleEnum;
const
  DOCHOSTUITYPE_BROWSE = $00000000;
  DOCHOSTUITYPE_AUTHOR = $00000001;

// Constants for enum tagDOCHOSTUIDBLCLK
type
  tagDOCHOSTUIDBLCLK = TOleEnum;
const
  DOCHOSTUIDBLCLK_DEFAULT = $00000000;
  DOCHOSTUIDBLCLK_SHOWPROPERTIES = $00000001;
  DOCHOSTUIDBLCLK_SHOWCODE = $00000002;

// Constants for enum tagDOCHOSTUIFLAG
type
  tagDOCHOSTUIFLAG = TOleEnum;
const
  DOCHOSTUIFLAG_DIALOG = $00000001;
  DOCHOSTUIFLAG_DISABLE_HELP_MENU = $00000002;
  DOCHOSTUIFLAG_NO3DBORDER = $00000004;
  DOCHOSTUIFLAG_SCROLL_NO = $00000008;
  DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE = $00000010;
  DOCHOSTUIFLAG_OPENNEWWIN = $00000020;
  DOCHOSTUIFLAG_DISABLE_OFFSCREEN = $00000040;
  DOCHOSTUIFLAG_FLAT_SCROLLBAR = $00000080;
  DOCHOSTUIFLAG_DIV_BLOCKDEFAULT = $00000100;
  DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY = $00000200;
  DOCHOSTUIFLAG_OVERRIDEBEHAVIORFACTORY = $00000400;
  DOCHOSTUIFLAG_CODEPAGELINKEDFONTS = $00000800;
  DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8 = $00001000;
  DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8 = $00002000;
  DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE = $00004000;
  DOCHOSTUIFLAG_ENABLE_INPLACE_NAVIGATION = $00010000;
  DOCHOSTUIFLAG_IME_ENABLE_RECONVERSION = $00020000;
  DOCHOSTUIFLAG_THEME = $00040000;
  DOCHOSTUIFLAG_NOTHEME = $00080000;
  DOCHOSTUIFLAG_NOPICS = $00100000;
  DOCHOSTUIFLAG_NO3DOUTERBORDER = $00200000;
  DOCHOSTUIFLAG_DISABLE_EDIT_NS_FIXUP = $00400000;
  DOCHOSTUIFLAG_LOCAL_MACHINE_ACCESS_CHECK = $00800000;
  DOCHOSTUIFLAG_DISABLE_UNTRUSTEDPROTOCOL = $01000000;

  DLCTL_DLIMAGES                           = $00000010;
  DLCTL_VIDEOS                             = $00000020;
  DLCTL_BGSOUNDS                           = $00000040;
  DLCTL_NO_SCRIPTS                         = $00000080;
  DLCTL_NO_JAVA                            = $00000100;
  DLCTL_NO_RUNACTIVEXCTLS                  = $00000200;
  DLCTL_NO_DLACTIVEXCTLS                   = $00000400;
  DLCTL_DOWNLOADONLY                       = $00000800;
  DLCTL_NO_FRAMEDOWNLOAD                   = $00001000;
  DLCTL_RESYNCHRONIZE                      = $00002000;
  DLCTL_PRAGMA_NO_CACHE                    = $00004000;
  DLCTL_NO_BEHAVIORS                       = $00008000;
  DLCTL_NO_METACHARSET                     = $00010000;
  DLCTL_URL_ENCODING_DISABLE_UTF8          = $00020000;
  DLCTL_URL_ENCODING_ENABLE_UTF8           = $00040000;
  DLCTL_NOFRAMES                           = $00080000;
  DLCTL_FORCEOFFLINE                       = $10000000;
  DLCTL_NO_CLIENTPULL                      = $20000000;
  DLCTL_SILENT                             = $40000000;
  DLCTL_OFFLINEIFNOTCONNECTED              = $80000000;
  DLCTL_OFFLINE                            = $80000000;


type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IHostDialogHelper = interface;
  IDocHostUIHandler = interface;
  IDocHostUIHandler2 = interface;
  ICustomDoc = interface;
  IDocHostShowUI = interface;
  IHTMLOMWindowServices = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  HostDialogHelper = IHostDialogHelper;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  wireHWND = ^_RemotableHandle; 
  wireHMENU = ^_RemotableHandle; 
  wireHGLOBAL = ^_userHGLOBAL; 
  wireCLIPFORMAT = ^_userCLIPFORMAT; 
  wireSTGMEDIUM = ^_userSTGMEDIUM; 
  wireFLAG_STGMEDIUM = ^_userFLAG_STGMEDIUM; 
  wireASYNC_STGMEDIUM = ^_userSTGMEDIUM; 
  POleVariant1 = ^OleVariant; {*}
  PWord1 = ^Word; {*}
  PUserType1 = ^TGUID; {*}
  PByte1 = ^Byte; {*}
  PUserType2 = ^tagBIND_OPTS2; {*}
  PUserType3 = ^_FILETIME; {*}
  PUserType4 = ^tagPOINT; {*}
  PUserType5 = ^tagRECT; {*}
  PUserType6 = ^tagMSG; {*}
  PUserType7 = ^tagFORMATETC; {*}
  PPUserType1 = ^wireFLAG_STGMEDIUM; {*}
  PPUserType2 = ^wireASYNC_STGMEDIUM; {*}


  __MIDL_IWinTypes_0009 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: Integer);
  end;

  _RemotableHandle = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0009;
  end;

  _LARGE_INTEGER = packed record
    QuadPart: Int64;
  end;

  _ULARGE_INTEGER = packed record
    QuadPart: Largeuint;
  end;

  _FILETIME = packed record
    dwLowDateTime: LongWord;
    dwHighDateTime: LongWord;
  end;

  tagSTATSTG = packed record
    pwcsName: PWideChar;
    type_: LongWord;
    cbSize: _ULARGE_INTEGER;
    mtime: _FILETIME;
    ctime: _FILETIME;
    atime: _FILETIME;
    grfMode: LongWord;
    grfLocksSupported: LongWord;
    clsid: TGUID;
    grfStateBits: LongWord;
    reserved: LongWord;
  end;

  _COAUTHIDENTITY = packed record
    User: ^Word;
    UserLength: LongWord;
    Domain: ^Word;
    DomainLength: LongWord;
    Password: ^Word;
    PasswordLength: LongWord;
    Flags: LongWord;
  end;

  _COAUTHINFO = packed record
    dwAuthnSvc: LongWord;
    dwAuthzSvc: LongWord;
    pwszServerPrincName: PWideChar;
    dwAuthnLevel: LongWord;
    dwImpersonationLevel: LongWord;
    pAuthIdentityData: ^_COAUTHIDENTITY;
    dwCapabilities: LongWord;
  end;

  _COSERVERINFO = packed record
    dwReserved1: LongWord;
    pwszName: PWideChar;
    pAuthInfo: ^_COAUTHINFO;
    dwReserved2: LongWord;
  end;

  tagBIND_OPTS2 = packed record
    cbStruct: LongWord;
    grfFlags: LongWord;
    grfMode: LongWord;
    dwTickCountDeadline: LongWord;
    dwTrackFlags: LongWord;
    dwClassContext: LongWord;
    locale: LongWord;
    pServerInfo: ^_COSERVERINFO;
  end;

  tagPOINT = packed record
    x: Integer;
    y: Integer;
  end;

  _DOCHOSTUIINFO = packed record
    cbSize: LongWord;
    dwFlags: LongWord;
    dwDoubleClick: LongWord;
    pchHostCss: ^Word;
    pchHostNS: ^Word;
  end;

  tagRECT = packed record
    left: Integer;
    top: Integer;
    right: Integer;
    bottom: Integer;
  end;

  _tagOLECMD = packed record
    cmdID: LongWord;
    cmdf: LongWord;
  end;

  _tagOLECMDTEXT = packed record
    cmdtextf: LongWord;
    cwActual: LongWord;
    cwBuf: LongWord;
    rgwz: ^Word;
  end;


  tagOleMenuGroupWidths = packed record
    width: array[0..5] of Integer;
  end;


  _FLAGGED_BYTE_BLOB = packed record
    fFlags: LongWord;
    clSize: LongWord;
    abData: ^Byte;
  end;

  __MIDL_IWinTypes_0003 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^_FLAGGED_BYTE_BLOB);
      2: (hInproc64: Int64);
  end;

  _userHGLOBAL = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0003;
  end;

  UINT_PTR = LongWord; 
  LONG_PTR = Integer; 

  tagMSG = packed record
    hwnd: wireHWND;
    message: SYSUINT;
    wParam: UINT_PTR;
    lParam: LONG_PTR;
    time: LongWord;
    pt: tagPOINT;
  end;


  tagDVTARGETDEVICE = packed record
    tdSize: LongWord;
    tdDriverNameOffset: Word;
    tdDeviceNameOffset: Word;
    tdPortNameOffset: Word;
    tdExtDevmodeOffset: Word;
    tdData: ^Byte;
  end;

  __MIDL_IWinTypes_0001 = record
    case Integer of
      0: (dwValue: LongWord);
      1: (pwszName: PWideChar);
  end;

  _userCLIPFORMAT = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0001;
  end;

  tagFORMATETC = packed record
    cfFormat: wireCLIPFORMAT;
    ptd: ^tagDVTARGETDEVICE;
    dwAspect: LongWord;
    lindex: Integer;
    tymed: LongWord;
  end;


  _BYTE_BLOB = packed record
    clSize: LongWord;
    abData: ^Byte;
  end;

  __MIDL_IWinTypes_0004 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^_BYTE_BLOB);
      2: (hInproc64: Int64);
  end;

  _userHMETAFILE = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0004;
  end;

  _remoteMETAFILEPICT = packed record
    mm: Integer;
    xExt: Integer;
    yExt: Integer;
    hMF: ^_userHMETAFILE;
  end;

  __MIDL_IWinTypes_0005 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^_remoteMETAFILEPICT);
      2: (hInproc64: Int64);
  end;

  _userHMETAFILEPICT = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0005;
  end;

  __MIDL_IWinTypes_0006 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^_BYTE_BLOB);
      2: (hInproc64: Int64);
  end;

  _userHENHMETAFILE = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0006;
  end;

  _userBITMAP = packed record
    bmType: Integer;
    bmWidth: Integer;
    bmHeight: Integer;
    bmWidthBytes: Integer;
    bmPlanes: Word;
    bmBitsPixel: Word;
    cbSize: LongWord;
    pBuffer: ^Byte;
  end;

  __MIDL_IWinTypes_0007 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^_userBITMAP);
      2: (hInproc64: Int64);
  end;

  _userHBITMAP = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0007;
  end;

  tagPALETTEENTRY = packed record
    peRed: Byte;
    peGreen: Byte;
    peBlue: Byte;
    peFlags: Byte;
  end;

  tagLOGPALETTE = packed record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: ^tagPALETTEENTRY;
  end;

  __MIDL_IWinTypes_0008 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: ^tagLOGPALETTE);
      2: (hInproc64: Int64);
  end;

  _userHPALETTE = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0008;
  end;

  __MIDL_IAdviseSink_0002 = record
    case Integer of
      0: (hBitmap: ^_userHBITMAP);
      1: (hPalette: ^_userHPALETTE);
      2: (hGeneric: ^_userHGLOBAL);
  end;

  _GDI_OBJECT = packed record
    ObjectType: LongWord;
    u: __MIDL_IAdviseSink_0002;
  end;

  __MIDL_IAdviseSink_0003 = record
    case Integer of
      0: (hMetaFilePict: ^_userHMETAFILEPICT);
      1: (hHEnhMetaFile: ^_userHENHMETAFILE);
      2: (hGdiHandle: ^_GDI_OBJECT);
      3: (hGlobal: ^_userHGLOBAL);
      4: (lpszFileName: PWideChar);
      5: (pstm: ^_BYTE_BLOB);
      6: (pstg: ^_BYTE_BLOB);
  end;

  _STGMEDIUM_UNION = packed record
    tymed: LongWord;
    u: __MIDL_IAdviseSink_0003;
  end;

  _userSTGMEDIUM = packed record
    __MIDL_0003: _STGMEDIUM_UNION;
    pUnkForRelease: IUnknown;
  end;


  _userFLAG_STGMEDIUM = packed record
    ContextFlags: Integer;
    fPassOwnership: Integer;
    Stgmed: _userSTGMEDIUM;
  end;


  tagSTATDATA = packed record
    formatetc: tagFORMATETC;
    advf: LongWord;
    pAdvSink: IAdviseSink;
    dwConnection: LongWord;
  end;

  _POINTL = packed record
    x: Integer;
    y: Integer;
  end;


// *********************************************************************//
// Interface: IHostDialogHelper
// Flags:     (0)
// GUID:      {53DEC138-A51E-11D2-861E-00C04FA35C89}
// *********************************************************************//
  IHostDialogHelper = interface(IUnknown)
    ['{53DEC138-A51E-11D2-861E-00C04FA35C89}']
    function ShowHTMLDialog(var hwndParent: _RemotableHandle; const pMk: IMoniker; 
                            var pvarArgIn: OleVariant; var pchOptions: Word; 
                            var pvarArgOut: OleVariant; const punkHost: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDocHostUIHandler
// Flags:     (0)
// GUID:      {BD3F23C0-D43E-11CF-893B-00AA00BDCE1A}
// *********************************************************************//
  IDocHostUIHandler = interface(IUnknown)
    ['{BD3F23C0-D43E-11CF-893B-00AA00BDCE1A}']
    function ShowContextMenu(dwID: LongWord; var ppt: tagPOINT; const pcmdtReserved: IUnknown; 
                             const pdispReserved: IDispatch): HResult; stdcall;
    function GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult; stdcall;
    function ShowUI(dwID: LongWord; const pActiveObject: IOleInPlaceActiveObject; 
                    const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; 
                    const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
    function HideUI: HResult; stdcall;
    function UpdateUI: HResult; stdcall;
    function EnableModeless(fEnable: Integer): HResult; stdcall;
    function OnDocWindowActivate(fActivate: Integer): HResult; stdcall;
    function OnFrameWindowActivate(fActivate: Integer): HResult; stdcall;
    function ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow; 
                          fRameWindow: Integer): HResult; stdcall;
    function TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: LongWord): HResult; stdcall;
    function GetOptionKeyPath(out pchKey: PWideChar; dw: LongWord): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(dwTranslate: LongWord; var pchURLIn: Word; out ppchURLOut: PWord1): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDocHostUIHandler2
// Flags:     (0)
// GUID:      {3050F6D0-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IDocHostUIHandler2 = interface(IDocHostUIHandler)
    ['{3050F6D0-98B5-11CF-BB82-00AA00BDCE0B}']
    function GetOverrideKeyPath(out pchKey: PWideChar; dw: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICustomDoc
// Flags:     (0)
// GUID:      {3050F3F0-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  ICustomDoc = interface(IUnknown)
    ['{3050F3F0-98B5-11CF-BB82-00AA00BDCE0B}']
    function SetUIHandler(const pUIHandler: IDocHostUIHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDocHostShowUI
// Flags:     (0)
// GUID:      {C4D244B0-D43E-11CF-893B-00AA00BDCE1A}
// *********************************************************************//
  IDocHostShowUI = interface(IUnknown)
    ['{C4D244B0-D43E-11CF-893B-00AA00BDCE1A}']
    function ShowMessage(var hwnd: _RemotableHandle; lpstrText: PWideChar; lpstrCaption: PWideChar; 
                         dwType: LongWord; lpstrHelpFile: PWideChar; dwHelpContext: LongWord; 
                         out plResult: LONG_PTR): HResult; stdcall;
    function ShowHelp(var hwnd: _RemotableHandle; pszHelpFile: PWideChar; uCommand: SYSUINT; 
                      dwData: LongWord; ptMouse: tagPOINT; const pDispatchObjectHit: IDispatch): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IHTMLOMWindowServices
// Flags:     (0)
// GUID:      {3050F5FC-98B5-11CF-BB82-00AA00BDCE0B}
// *********************************************************************//
  IHTMLOMWindowServices = interface(IUnknown)
    ['{3050F5FC-98B5-11CF-BB82-00AA00BDCE0B}']
    function moveTo(x: Integer; y: Integer): HResult; stdcall;
    function moveBy(x: Integer; y: Integer): HResult; stdcall;
    function resizeTo(x: Integer; y: Integer): HResult; stdcall;
    function resizeBy(x: Integer; y: Integer): HResult; stdcall;
  end;


implementation


end.
