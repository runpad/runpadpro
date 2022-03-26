unit PREVIEWLib_TLB;

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
// File generated on 14.10.2007 16:46:10 from Type Library described below.

// ************************************************************************  //
// Type Lib: shimgvw.dll (1)
// LIBID: {50F16B18-467E-11D1-8271-00C04FC3183B}
// LCID: 0
// Helpfile: 
// HelpString: Preview 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: Parameter 'var' of IPreview.Show changed to 'var_'
//   Hint: Parameter 'var' of IPreview3.Show changed to 'var_'
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
  PREVIEWLibMajorVersion = 1;
  PREVIEWLibMinorVersion = 0;

  LIBID_PREVIEWLib: TGUID = '{50F16B18-467E-11D1-8271-00C04FC3183B}';

  IID_IPreview: TGUID = '{50F16B25-467E-11D1-8271-00C04FC3183B}';
  IID_IPreview2: TGUID = '{0AE0A2B1-3A34-11D3-9626-00C04F8EEC8C}';
  IID_IPreview3: TGUID = '{497431AD-5481-4DF7-AE5D-130D9CD50DB3}';
  IID_IImgCmdTarget: TGUID = '{FF36E952-72E9-4EA0-92FB-B63FE5037D78}';
  DIID_DPreviewEvents: TGUID = '{1B490296-50DF-11D1-8B44-00C04FC3183B}';
  CLASS_Preview: TGUID = '{50F16B26-467E-11D1-8271-00C04FC3183B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPreview = interface;
  IPreviewDisp = dispinterface;
  IPreview2 = interface;
  IPreview2Disp = dispinterface;
  IPreview3 = interface;
  IImgCmdTarget = interface;
  DPreviewEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Preview = IPreview2;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUINT1 = ^LongWord; {*}


// *********************************************************************//
// Interface: IPreview
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {50F16B25-467E-11D1-8271-00C04FC3183B}
// *********************************************************************//
  IPreview = interface(IDispatch)
    ['{50F16B25-467E-11D1-8271-00C04FC3183B}']
    procedure ShowFile(const bstrFileName: WideString; iSelectCount: SYSINT); safecall;
    function Get_printable: Integer; safecall;
    procedure Set_printable(pVal: Integer); safecall;
    function Get_cxImage: Integer; safecall;
    function Get_cyImage: Integer; safecall;
    procedure Show(var_: OleVariant); safecall;
    property printable: Integer read Get_printable write Set_printable;
    property cxImage: Integer read Get_cxImage;
    property cyImage: Integer read Get_cyImage;
  end;

// *********************************************************************//
// DispIntf:  IPreviewDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {50F16B25-467E-11D1-8271-00C04FC3183B}
// *********************************************************************//
  IPreviewDisp = dispinterface
    ['{50F16B25-467E-11D1-8271-00C04FC3183B}']
    procedure ShowFile(const bstrFileName: WideString; iSelectCount: SYSINT); dispid 1;
    property printable: Integer dispid 2;
    property cxImage: Integer readonly dispid 3;
    property cyImage: Integer readonly dispid 4;
    procedure Show(var_: OleVariant); dispid 5;
  end;

// *********************************************************************//
// Interface: IPreview2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AE0A2B1-3A34-11D3-9626-00C04F8EEC8C}
// *********************************************************************//
  IPreview2 = interface(IPreview)
    ['{0AE0A2B1-3A34-11D3-9626-00C04F8EEC8C}']
    procedure Zoom(iSelectCount: SYSINT); safecall;
    procedure BestFit; safecall;
    procedure ActualSize; safecall;
    procedure SlideShow; safecall;
  end;

// *********************************************************************//
// DispIntf:  IPreview2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {0AE0A2B1-3A34-11D3-9626-00C04F8EEC8C}
// *********************************************************************//
  IPreview2Disp = dispinterface
    ['{0AE0A2B1-3A34-11D3-9626-00C04F8EEC8C}']
    procedure Zoom(iSelectCount: SYSINT); dispid 1610809344;
    procedure BestFit; dispid 1610809345;
    procedure ActualSize; dispid 1610809346;
    procedure SlideShow; dispid 1610809347;
    procedure ShowFile(const bstrFileName: WideString; iSelectCount: SYSINT); dispid 1;
    property printable: Integer dispid 2;
    property cxImage: Integer readonly dispid 3;
    property cyImage: Integer readonly dispid 4;
    procedure Show(var_: OleVariant); dispid 5;
  end;

// *********************************************************************//
// Interface: IPreview3
// Flags:     (0)
// GUID:      {497431AD-5481-4DF7-AE5D-130D9CD50DB3}
// *********************************************************************//
  IPreview3 = interface(IUnknown)
    ['{497431AD-5481-4DF7-AE5D-130D9CD50DB3}']
    function ShowFile(const bstrFileName: WideString): HResult; stdcall;
    function Show(var_: OleVariant): HResult; stdcall;
    function Zoom(iSelectCount: SYSINT): HResult; stdcall;
    function BestFit: HResult; stdcall;
    function ActualSize: HResult; stdcall;
    function SlideShow: HResult; stdcall;
    function Rotate(dwAngle: LongWord): HResult; stdcall;
    function SetWallpaper(const bstrPath: WideString): HResult; stdcall;
    function SaveAs(const bstrPath: WideString): HResult; stdcall;
    function Get_cxImage(out pVal: Integer): HResult; stdcall;
    function Get_cyImage(out pVal: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IImgCmdTarget
// Flags:     (0)
// GUID:      {FF36E952-72E9-4EA0-92FB-B63FE5037D78}
// *********************************************************************//
  IImgCmdTarget = interface(IUnknown)
    ['{FF36E952-72E9-4EA0-92FB-B63FE5037D78}']
    function GetMode(var pdw: LongWord): HResult; stdcall;
    function GetPageFlags(var pdw: LongWord): HResult; stdcall;
    function ZoomIn: HResult; stdcall;
    function ZoomOut: HResult; stdcall;
    function ActualSize: HResult; stdcall;
    function BestFit: HResult; stdcall;
    function Rotate(dwAngle: LongWord): HResult; stdcall;
    function NextPage: HResult; stdcall;
    function PreviousPage: HResult; stdcall;
  end;

// *********************************************************************//
// DispIntf:  DPreviewEvents
// Flags:     (4096) Dispatchable
// GUID:      {1B490296-50DF-11D1-8B44-00C04FC3183B}
// *********************************************************************//
  DPreviewEvents = dispinterface
    ['{1B490296-50DF-11D1-8B44-00C04FC3183B}']
    procedure OnClose; dispid 1;
    procedure OnPreviewReady; dispid 2;
    procedure OnError; dispid 3;
    procedure OnBestFitPress; dispid 4;
    procedure OnActualSizePress; dispid 5;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TPreview
// Help String      : Preview Class
// Default Interface: IPreview2
// Def. Intf. DISP? : No
// Event   Interface: DPreviewEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TPreview = class(TOleControl)
  private
    FOnClose: TNotifyEvent;
    FOnPreviewReady: TNotifyEvent;
    FOnError: TNotifyEvent;
    FOnBestFitPress: TNotifyEvent;
    FOnActualSizePress: TNotifyEvent;
    FIntf: IPreview2;
    function  GetControlInterface: IPreview2;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure ShowFile(const bstrFileName: WideString; iSelectCount: SYSINT);
    procedure Show(var_: OleVariant);
    procedure Zoom(iSelectCount: SYSINT);
    procedure BestFit;
    procedure ActualSize;
    procedure SlideShow;
    property  ControlInterface: IPreview2 read GetControlInterface;
    property  DefaultInterface: IPreview2 read GetControlInterface;
    property cxImage: Integer index 3 read GetIntegerProp;
    property cyImage: Integer index 4 read GetIntegerProp;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
    property printable: Integer index 2 read GetIntegerProp write SetIntegerProp stored False;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnPreviewReady: TNotifyEvent read FOnPreviewReady write FOnPreviewReady;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnBestFitPress: TNotifyEvent read FOnBestFitPress write FOnBestFitPress;
    property OnActualSizePress: TNotifyEvent read FOnActualSizePress write FOnActualSizePress;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TPreview.InitControlData;
const
  CEventDispIDs: array [0..4] of DWORD = (
    $00000001, $00000002, $00000003, $00000004, $00000005);
  CControlData: TControlData2 = (
    ClassID: '{50F16B26-467E-11D1-8271-00C04FC3183B}';
    EventIID: '{1B490296-50DF-11D1-8B44-00C04FC3183B}';
    EventCount: 5;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnClose) - Cardinal(Self);
end;

procedure TPreview.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IPreview2;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TPreview.GetControlInterface: IPreview2;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TPreview.ShowFile(const bstrFileName: WideString; iSelectCount: SYSINT);
begin
  DefaultInterface.ShowFile(bstrFileName, iSelectCount);
end;

procedure TPreview.Show(var_: OleVariant);
begin
  DefaultInterface.Show(var_);
end;

procedure TPreview.Zoom(iSelectCount: SYSINT);
begin
  DefaultInterface.Zoom(iSelectCount);
end;

procedure TPreview.BestFit;
begin
  DefaultInterface.BestFit;
end;

procedure TPreview.ActualSize;
begin
  DefaultInterface.ActualSize;
end;

procedure TPreview.SlideShow;
begin
  DefaultInterface.SlideShow;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TPreview]);
end;

end.
