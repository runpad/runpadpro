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
unit BFProps;

{$I BF.inc}

interface

uses
  {$IFDEF DELPHI5}DsgnIntf{$ELSE}DesignIntf, DesignEditors{$ENDIF}, Classes;

type
  // Property editor for Bluetooth port property.
  TBFPortProperty = class(TIntegerProperty)
  public
    function GetValue: string; override;

    procedure SetValue(const Value: string); override;
  end;

  TBFCreatorPortProperty = class(TIntegerProperty)
  public
    function GetValue: string; override;

    procedure SetValue(const Value: string); override;
  end;

  TBFAudioPortProperty = class(TIntegerProperty)
  public
    function GetValue: string; override;

    procedure SetValue(const Value: string); override;
  end;

  // Property editor for Bluetooth service property.
  TBFServiceProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;

    procedure GetValues(Proc: TGetStrProc); override;
  end;

  // Property editor for Bluetooth address property.
  TBFBluetoothAddressProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;

    procedure Edit; override;
  end;

  TBFCreatorBluetoothAddressProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;

    procedure Edit; override;
  end;

  TBFAudioBluetoothAddressProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;

    procedure Edit; override;
  end;

  // Property editor for IrDA address property.
  TBFIrDAAddressProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;

    procedure Edit; override;
  end;

// Property registration procedure.
procedure Register;

implementation

uses
  Windows, BFClients, BFAPI, SysUtils, Forms, BFDiscovery, BFServers,
  BFBluetoothCOMPortCreator, BFBluetoothAudio;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(DWORD), TBFBluetoothClientTransport, 'Port', TBFPortProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothClientTransport, 'Service', TBFServiceProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothClientTransport, 'Address', TBFBluetoothAddressProperty);

  RegisterPropertyEditor(TypeInfo(string), TBFIrDAClientTransport, 'Address', TBFIrDAAddressProperty);

  RegisterPropertyEditor(TypeInfo(DWORD), TBFBluetoothServerTransport, 'Port', TBFPortProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothServerTransport, 'Service', TBFServiceProperty);

  RegisterPropertyEditor(TypeInfo(DWORD), TBFBluetoothCOMPortCreator, 'Port', TBFCreatorPortProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothCOMPortCreator, 'Service', TBFServiceProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothCOMPortCreator, 'Address', TBFCreatorBluetoothAddressProperty);

  RegisterPropertyEditor(TypeInfo(DWORD), TBFBluetoothAudio, 'Port', TBFAudioPortProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothAudio, 'Service', TBFServiceProperty);
  RegisterPropertyEditor(TypeInfo(string), TBFBluetoothAudio, 'Address', TBFAudioBluetoothAddressProperty);
end;

{ TBFPortProperty }

function TBFPortProperty.GetValue: string;
var
  Port: DWORD;
begin
  if GetComponent(0) is TBFBluetoothClientTransport then
    Port := TBFBluetoothClientTransport(GetComponent(0)).Port
  else
    Port := TBFBluetoothServerTransport(GetComponent(0)).Port;

  if Port = DWORD(BT_PORT_ANY) then
    Result := 'BT_PORT_ANY'

  else
    Result := IntToStr(Port);
end;

procedure TBFPortProperty.SetValue(const Value: string);
var
  Port: DWORD;
begin
  if Value = 'BT_PORT_ANY' then
    Port := DWORD(BT_PORT_ANY)
  else
    Port := StrToInt(Value);

  if GetComponent(0) is TBFBluetoothClientTransport then
    TBFBluetoothClientTransport(GetComponent(0)).Port := Port
  else
    TBFBluetoothServerTransport(GetComponent(0)).Port := Port;

  Modified;
end;

{ TBFServiceProperty }

function TBFServiceProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TBFServiceProperty.GetValues(Proc: TGetStrProc);
var
  Loop: Integer;
begin
  for Loop := 0 to UUID_STRINGS_COUNT - 1 do Proc(UUID_STRINGS_ARRAY[Loop].Name);
end;

{ TBFBluetoothAddressProperty }

procedure TBFBluetoothAddressProperty.Edit;
var
  Dev: TBFBluetoothDevice;
  Discovery: TBFBluetoothDiscovery;
begin
  Discovery := TBFBluetoothDiscovery.Create(Screen.ActiveForm);

  try
    Dev := Discovery.SelectDevice(True);

    if Assigned(Dev) then begin
      TBFBluetoothClientTransport(GetComponent(0)).Address := Dev.Address;
      Dev.Free;
    end;

  finally
    Discovery.Free;
  end;
end;

function TBFBluetoothAddressProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TBFIrDAAddressProperty }

procedure TBFIrDAAddressProperty.Edit;
var
  Dev: TBFIrDADevice;
  Discovery: TBFIrDADiscovery;
begin
  Discovery := TBFIrDADiscovery.Create(Application.MainForm);

  try
    Dev := Discovery.SelectDevice;

    if Assigned(Dev) then begin
      TBFIrDAClientTransport(GetComponent(0)).Address := Dev.Address;
      Dev.Free;
    end;

  finally
    Discovery.Free;
  end;
end;

function TBFIrDAAddressProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TBFCreatorPortProperty }

function TBFCreatorPortProperty.GetValue: string;
var
  Port: DWORD;
begin
  if GetComponent(0) is TBFBluetoothCOMPortCreator then begin
    Port := TBFBluetoothCOMPortCreator(GetComponent(0)).Port;

    if Port = DWORD(BT_PORT_ANY) then
      Result := 'BT_PORT_ANY'

    else
      Result := IntToStr(Port);
  end;
end;

procedure TBFCreatorPortProperty.SetValue(const Value: string);
var
  Port: DWORD;
begin
  if GetComponent(0) is TBFBluetoothCOMPortCreator then begin
    if Value = 'BT_PORT_ANY' then
      Port := DWORD(BT_PORT_ANY)
    else
      Port := StrToInt(Value);

    TBFBluetoothCOMPortCreator(GetComponent(0)).Port := Port;

    Modified;
  end;
end;

{ TBFCreatorBluetoothAddressProperty }

procedure TBFCreatorBluetoothAddressProperty.Edit;
var
  Dev: TBFBluetoothDevice;
  Discovery: TBFBluetoothDiscovery;
begin
  Discovery := TBFBluetoothDiscovery.Create(Screen.ActiveForm);

  try
    Dev := Discovery.SelectDevice(True);

    if Assigned(Dev) then begin
      TBFBluetoothCOMPortCreator(GetComponent(0)).Address := Dev.Address;
      Dev.Free;
    end;

  finally
    Discovery.Free;
  end;
end;

function TBFCreatorBluetoothAddressProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

{ TBFAudioPortProperty }

function TBFAudioPortProperty.GetValue: string;
var
  Port: DWORD;
begin
  if GetComponent(0) is TBFBluetoothAudio then begin
    Port := TBFBluetoothAudio(GetComponent(0)).Port;

    if Port = DWORD(BT_PORT_ANY) then
      Result := 'BT_PORT_ANY'

    else
      Result := IntToStr(Port);
  end;
end;

procedure TBFAudioPortProperty.SetValue(const Value: string);
var
  Port: DWORD;
begin
  if GetComponent(0) is TBFBluetoothAudio then begin
    if Value = 'BT_PORT_ANY' then
      Port := DWORD(BT_PORT_ANY)
    else
      Port := StrToInt(Value);

    TBFBluetoothCOMPortCreator(GetComponent(0)).Port := Port;

    Modified;
  end;
end;

{ TBFAudioBluetoothAddressProperty }

procedure TBFAudioBluetoothAddressProperty.Edit;
var
  Dev: TBFBluetoothDevice;
  Discovery: TBFBluetoothDiscovery;
begin
  Discovery := TBFBluetoothDiscovery.Create(Screen.ActiveForm);

  try
    Dev := Discovery.SelectDevice(True);

    if Assigned(Dev) then begin
      TBFBluetoothAudio(GetComponent(0)).Address := Dev.Address;
      Dev.Free;
    end;

  finally
    Discovery.Free;
  end;
end;

function TBFAudioBluetoothAddressProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

end.
