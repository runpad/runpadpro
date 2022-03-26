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
unit BFAuthenticator;

{$I BF.inc}

interface

uses
  BFBase, Classes, BFAPI, Windows, Messages;

type
  // OnPINRequest event hanler prototype. Application should provide PIN for
  // authentication. The PIN should containts only numeric characters (0..9).
  // Also PIN cannot be larger than 16 digits. Epty PIN means that
  // authentication should be canceled.
  TBFPINRequestEvent = procedure(Sender: TObject; DeviceAddress: string; var PIN: string) of object;

  // Allows you to handle authentication request for Bluetooth devices.
  TBFAuthenticator = class(TBFBaseComponent)
  private
    FActive: Boolean;
    FDeviceInfo: BLUETOOTH_DEVICE_INFO;
    FDeviceInfoSize: DWORD;
    FHandle: HBLUETOOTH_AUTHENTICATION_REGISTRATION;
    FWasMSEnabled: Boolean;

    FOnPINRequest: TBFPINRequestEvent;

    function GetPassKey(AAddress: string): string;

    procedure BFNMAuthenticationEvent(var Message: TMessage); message BFNM_AUTHENTICATION_EVENT;
    procedure SetActive(const Value: Boolean);

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Call authentication procedure for WidComm drivers.
    // Application should never call this function. It is for internal use only.
    procedure BondWD(Adr: TBluetoothAddress);

    // Disables authentication requests handling.
    procedure Close;
    // Enables authentication requests handling.
    procedure Open;

    // Returns True if hanling enabled. Otherwise returns False. Sets to True
    // enabling authentication requests handling.
    property Active: Boolean read FActive write SetActive;

  published
    // Event occures when remote device request authentication. Application
    // should provide PIN code. If event handler not assigned and authentication
    // enabled (Active = True) then internal dialog will show.
    property OnPINRequest: TBFPINRequestEvent read FOnPINRequest write FOnPINRequest;
  end;

  _TBFAuthenticatorX = class(_TBFActiveXControl)
  private
    FBFAuthenticator: TBFAuthenticator;

    function GetActive: Boolean;
    function GetOnPINRequest: TBFPINRequestEvent;

    procedure SetActive(const Value: Boolean);
    procedure SetOnPINRequest(Value: TBFPINRequestEvent);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open;

    property Active: Boolean read GetActive write SetActive;

  published
    property OnPINRequest: TBFPINRequestEvent read GetOnPINRequest write SetOnPINRequest;
  end;

var
  // Global instance of TBFAuthenticator.
  gAuthenticator: TBFAuthenticator = nil;

implementation

uses
  SysUtils, BFRequestPIN, Forms, Controls, BFD5Support, BFStrings, Registry;

type
  PPinRequestMessage = ^TPinRequestMessage;
  TPinRequestMessage = packed record
    APIN: TBFPIN;
    AAddress: array [0..256] of Char;
  end;

// Authentication request callback function.
// NOTE: This function may called in different thread. So we must
// syncronize it thread with appolication main thread. To do that I uses
// SendMessage. Otherwise VLC may down.
function AuthCallBack(pvParam: Pointer; pDevice: PBLUETOOTH_DEVICE_INFO): BOOL; stdcall;
var
  Authenticator: TBFAuthenticator;
  PinRequestMessage: TPinRequestMessage;
  PassKey: WideString;
  Res: DWORD;
  ADevAddress: string;
  APinStr: string;
begin
  Result := False;

  // Checks if correct component pointer passed.
  if Assigned(pvParam) then
    // Ususally it should be a pointer to TBFAuthenticator component. But
    // may be somethign else.
    try
      Authenticator := TBFAuthenticator(pvParam);

      // By default not pin.
      FillChar(PinRequestMessage, SizeOf(TPinRequestMessage), 0);
      ADevAddress := API.BlueSoleilAddressToString(pDevice^.Address.rgBytes);
      StrLCopy(PinRequestMessage.AAddress, PChar(ADevAddress), Length(ADevAddress));

      // Sending message to component that need PIN.
      SendMessage(Authenticator.Wnd, BFNM_AUTHENTICATION_EVENT, NM_AUTHENTICATION_PIN, Integer(@PinRequestMessage));

      APinStr := string(PinRequestMessage.APIN);
      // Check for correct PIN.
      if APinStr <> '' then begin
        PassKey := WideString(String(APinStr) + #$00); // Do not forgot add #0.

        // Sending PIN to the remote device.
        Res := BluetoothSendAuthenticationResponse(0, pDevice, PWideChar(PassKey));

        Result := Res = ERROR_SUCCESS;

        // If somthing wrong then raises exception.
        if not Result then PostMessage(Authenticator.Wnd, BFNM_AUTHENTICATION_EVENT, NM_AUTHENTICATION_RESULT, 0);
      end;
      
    except
    end;
end;

function IVT_PinRequest(lpAddr: PBYTE; lpPinLen: PBYTE; lpPinCode: PBYTE): DWORD; cdecl; export;
var
  PinRequestMessage: TPinRequestMessage;
  ADevAddress: string;
  APinStr: string;
begin
  if Assigned(gAuthenticator) then begin
    FillChar(PinRequestMessage, SizeOf(TPinRequestMessage), 0);
    ADevAddress := API.BlueSoleilAddressToString(PBluetoothAddress(lpAddr)^);
    StrLCopy(PinRequestMessage.AAddress, PChar(ADevAddress), Length(ADevAddress));

    SendMessage(gAuthenticator.Wnd, BFNM_AUTHENTICATION_EVENT, NM_AUTHENTICATION_PIN, Integer(@PinRequestMessage));

    APinStr := string(PinRequestMessage.APIN);

    if APinStr <> '' then begin
      lpPinLen^ := Length(APinStr);
      StrLCopy(PChar(lpPinCode), PChar(APinStr), Length(APinStr));

      Result := BTSTATUS_SUCCESS;

    end else
      Result := BTSTATUS_FAIL;

  end else
    Result := BTSTATUS_FAIL;
end;

{ TBFAuthenticator }

procedure TBFAuthenticator.BFNMAuthenticationEvent(var Message: TMessage);
var
  APin: PPinRequestMessage;
  APassKey: string;
  Len: DWORD;
  ADevAddress: string;
begin
  try
    if Message.wParam = NM_AUTHENTICATION_PIN then begin
      APin := PPinRequestMessage(Message.lParam);
      FillChar(APin^.APIN, SizeOf(APin^.APIN), 0);

      ADevAddress := string(APIN^.AAddress);
      APassKey := GetPassKey(ADevAddress);

      Len := Length(APassKey);
      if Len > MAX_PIN_CODE_LENGTH then Len := MAX_PIN_CODE_LENGTH;
      if APassKey <> '' then StrLCopy(APin^.APIN, PChar(APassKey), Len);
    end;

  finally
    Message.Result := Integer(True);
  end;
end;

procedure TBFAuthenticator.BondWD(Adr: TBluetoothAddress);
var
  Res: BOND_RETURN_CODE;
  APassKey: string;
begin
  // Only if active.
  if FActive then begin
    API.CheckTransport(atBluetooth);

    // Check is device bonded?
    if not WD_BondQuery(Adr) then begin
      APassKey := GetPassKey(API.BlueSoleilAddressToString(Adr));

      if APassKey <> '' then begin
        Res := WD_Bond(Adr, PChar(APassKey));
        if (Res <> SUCCESS) and (Res <> ALREADY_BONDED) then raise Exception.Create(StrUnablePairingWithDevice);
      end;
    end;
  end;
end;

procedure TBFAuthenticator.Close;

  procedure CloseIVT;
  begin
    BT_RegisterCallback(EVENT_PIN_CODE_REQUEST, nil);
  end;

  procedure CloseMS;
  begin
    BluetoothUnregisterAuthentication(FHandle);

    with TRegistry.Create do begin
      RootKey := HKEY_CURRENT_USER;

      try
        if OpenKey('Software\Microsoft\BluetoothAuthenticationAgent', False) then begin
          if FWasMSEnabled then
            WriteInteger('AcceptIncomingRequests', 1)
          else
            WriteInteger('AcceptIncomingRequests', 0);

          CloseKey;
        end;

      except
      end;

      Free;
    end;

    FWasMSEnabled := False;
  end;

  procedure CloseTos;
  begin
  end;

  procedure CloseWD;
  begin
  end;

begin
  if FActive then
    with API do begin
      if baBlueSoleil in BluetoothAPIs then CloseIVT;
      if baWinSock in BluetoothAPIs then CloseMS;
      if baWidComm in BluetoothAPIs then CloseWD;
      if baToshiba in BluetoothAPIs then CloseTos;
    end;

  gAuthenticator := nil;

  FActive := False;
end;

constructor TBFAuthenticator.Create(AOwner: TComponent);
begin
  inherited;

  // Initialization
  FActive := False;
  FDeviceInfoSize := SizeOf(BLUETOOTH_DEVICE_INFO);
  FillChar(FDeviceInfo, FDeviceInfoSize, 0);
  FHandle := 0;
  FWasMSEnabled := False;

  FOnPINRequest := nil;
end;

destructor TBFAuthenticator.Destroy;
begin
  Close;

  inherited;
end;

function TBFAuthenticator.GetPassKey(AAddress: string): string;
begin
  Result := '';

  if Assigned(FOnPINRequest) then
    // If we have assigned event handler we call
    // it.
    try
      FOnPINRequest(Self, AAddress, Result);
    except
    end

  else
    // Otherwise shows build-in dialog.
    with TfmRequestPIN.Create(Screen.ActiveForm) do begin
      if ShowModal = mrOK then Result := edPIN.Text;
      Free;
    end;
end;

procedure TBFAuthenticator.Open;

  procedure OpenIVT;
  var
    Res: DWORD;
  begin
    Res := BT_RegisterCallback(EVENT_PIN_CODE_REQUEST, @IVT_PinRequest);
    if Res <> BTSTATUS_SUCCESS then raise Exception.Create(BTSTATUS_STRINGS[Res]);
  end;

  procedure OpenMS;
  begin
    // Init params.
    FillChar(FDeviceInfo, FDeviceInfoSize, 0);
    FDeviceInfo.dwSize := FDeviceInfoSize;

    // Registering call back procedure.
    if BluetoothRegisterForAuthentication(@FDeviceInfo, FHandle, @AuthCallBack, Self) <> ERROR_SUCCESS then RaiseLastOSError;

    with TRegistry.Create do begin
      RootKey := HKEY_CURRENT_USER;

      try
        if OpenKey('Software\Microsoft\BluetoothAuthenticationAgent', True) then begin
          if ValueExists('AcceptIncomingRequests') then
            FWasMSEnabled := ReadInteger('AcceptIncomingRequests') <> 0
          else
            FWasMSEnabled := True;

          WriteInteger('AcceptIncomingRequests', 0);

          CloseKey;
        end;

      except
      end;
      
      Free;
    end;
  end;

  procedure OpenTos;
  begin
  end;

  procedure OpenWD;
  begin
  end;

begin
  API.CheckTransport(atBluetooth);

  // Check if instance exists.
  if Assigned(gAuthenticator) then raise Exception.Create(StrOnlyOneAuthenticatorInstance);

  if not FActive then
    with API do begin
      if baBlueSoleil in BluetoothAPIs then OpenIVT;
      if baWinSock in BluetoothAPIs then OpenMS;
      if baWidComm in BluetoothAPIs then OpenWD;
      if baToshiba in BluetoothAPIs then OpenTos;
    end;

  gAuthenticator := Self;

  FActive := True;
end;

procedure TBFAuthenticator.SetActive(const Value: Boolean);
begin
  if Value then
    Open
  else
    Close;
end;

{ TBFAuthenticatorX }

procedure _TBFAuthenticatorX.Close;
begin
  FBFAuthenticator.Close;
end;

constructor _TBFAuthenticatorX.Create(AOwner: TComponent);
begin
  inherited;

  FBFAuthenticator := TBFAuthenticator.Create(nil);
end;

destructor _TBFAuthenticatorX.Destroy;
begin
  FBFAuthenticator.Free;
  
  inherited;
end;

function _TBFAuthenticatorX.GetActive: Boolean;
begin
  Result := FBFAuthenticator.Active;
end;

function _TBFAuthenticatorX.GetOnPINRequest: TBFPINRequestEvent;
begin
  Result := FBFAuthenticator.OnPINRequest;
end;

procedure _TBFAuthenticatorX.Open;
begin
  FBFAuthenticator.Open;
end;

procedure _TBFAuthenticatorX.SetActive(const Value: Boolean);
begin
  FBFAuthenticator.Active := Value;
end;

procedure _TBFAuthenticatorX.SetOnPINRequest(Value: TBFPINRequestEvent);
begin
  FBFAuthenticator.OnPINRequest := Value;
end;

end.
