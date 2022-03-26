unit BodyOffice_TLB;

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
// File generated on 30.10.2008 11:10:05 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\runpad_dev\client\bodyoffice2000\BodyOffice.tlb (1)
// LIBID: {AC191C78-A32A-42BD-9F7D-FA73520BE449}
// LCID: 0
// Helpfile: 
// HelpString: BodyOffice2000 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  BodyOfficeMajorVersion = 1;
  BodyOfficeMinorVersion = 0;

  LIBID_BodyOffice: TGUID = '{AC191C78-A32A-42BD-9F7D-FA73520BE449}';

  IID_IDTExtensibility2: TGUID = '{B65AD801-ABAF-11D0-BB8B-00A0C90F2744}';
  CLASS_DTExtensibility2: TGUID = '{71D42717-EA87-48F1-B263-C5299F4FEF9F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDTExtensibility2 = interface;
  IDTExtensibility2Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DTExtensibility2 = IDTExtensibility2;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PPSafeArray1 = ^PSafeArray; {*}


// *********************************************************************//
// Interface: IDTExtensibility2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B65AD801-ABAF-11D0-BB8B-00A0C90F2744}
// *********************************************************************//
  IDTExtensibility2 = interface(IDispatch)
    ['{B65AD801-ABAF-11D0-BB8B-00A0C90F2744}']
    procedure OnConnection(const HostApp: IDispatch; ext_ConnectMode: Integer; 
                           const AddInInst: IDispatch; var custom: PSafeArray); safecall;
    procedure OnDisconnection(ext_DisconnectMode: Integer; var custom: PSafeArray); safecall;
    procedure OnAddInsUpdate(var custom: PSafeArray); safecall;
    procedure OnStartupComplete(var custom: PSafeArray); safecall;
    procedure BeginShutdown(var custom: PSafeArray); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDTExtensibility2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B65AD801-ABAF-11D0-BB8B-00A0C90F2744}
// *********************************************************************//
  IDTExtensibility2Disp = dispinterface
    ['{B65AD801-ABAF-11D0-BB8B-00A0C90F2744}']
    procedure OnConnection(const HostApp: IDispatch; ext_ConnectMode: Integer; 
                           const AddInInst: IDispatch; var custom: {??PSafeArray}OleVariant); dispid 1;
    procedure OnDisconnection(ext_DisconnectMode: Integer; var custom: {??PSafeArray}OleVariant); dispid 2;
    procedure OnAddInsUpdate(var custom: {??PSafeArray}OleVariant); dispid 3;
    procedure OnStartupComplete(var custom: {??PSafeArray}OleVariant); dispid 4;
    procedure BeginShutdown(var custom: {??PSafeArray}OleVariant); dispid 5;
  end;

// *********************************************************************//
// The Class CoDTExtensibility2 provides a Create and CreateRemote method to          
// create instances of the default interface IDTExtensibility2 exposed by              
// the CoClass DTExtensibility2. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDTExtensibility2 = class
    class function Create: IDTExtensibility2;
    class function CreateRemote(const MachineName: string): IDTExtensibility2;
  end;

implementation

uses ComObj;

class function CoDTExtensibility2.Create: IDTExtensibility2;
begin
  Result := CreateComObject(CLASS_DTExtensibility2) as IDTExtensibility2;
end;

class function CoDTExtensibility2.CreateRemote(const MachineName: string): IDTExtensibility2;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DTExtensibility2) as IDTExtensibility2;
end;

end.
