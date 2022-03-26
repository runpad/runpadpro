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
unit BFBase;

{$I BF.inc}

interface

uses
  Forms, Classes, Controls, Windows, Messages, SysUtils;

type
  // The base class for all non-viaual classes of the Bluetooth Framework.
  // Provides basically functionallity, window allocation and base features
  // support.
  TBFBaseComponent = class(TComponent)
  private
    // The internal window handle.
    FWnd: HWND;

  protected
    // Window procedure
    procedure WndProc(var Message: TMessage);

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    property Wnd: HWND read FWnd;
  end;

  // The base class for all visual components of the library. Do not contain
  // any functionallity but usefull in the future for class typecasts.
  TBFBaseControl = class(TCustomControl)
  end;

  _TBFActiveXControl = class(TBFBaseControl)
  protected
    function CanResize(var NewWidth: Integer; var NewHeight: Integer): Boolean; override;

    procedure Paint; override;

  public
    constructor Create(AOwner: TComponent); override;
  end;

  // The base class for all classes of the Bluetooth Framework. Do not contain
  // any functionallity but usefull in the future for class typecasts.
  TBFBaseClass = class
  end;

  // The base class for all threads of the Bluetooth Framework. Do not contain
  // any functionallity but usefull in the future for class typests.
  TBFBaseThread = class(TThread)
  end;

implementation

{$R BF.dcr}

uses
  BFAPI, Graphics{$IFDEF TRIAL}, BFAbout{$ENDIF};

{ TBFBaseComponent }

constructor TBFBaseComponent.Create(AOwner: TComponent);
begin
  inherited;

  // Allocates the internal window handle for VCL version of the Bluetooth
  // Framework.
  FWnd := AllocateHWnd(WndProc);
end;

destructor TBFBaseComponent.Destroy;
begin
  // Deallocates internal window handle for VCL version of the Bluetooth
  // Framework.
  DeallocateHWnd(FWnd);

  inherited;
end;

procedure TBFBaseComponent.WndProc(var Message: TMessage);
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

constructor _TBFActiveXControl.Create(AOwner: TComponent);
begin
  inherited;

  // Sets width and height for ActiveX version of the Bluetooth Framework.
  // Also hides control for run-time.
  Visible := False;
  Height := 24;
  Width := 24;
end;

function _TBFActiveXControl.CanResize(var NewWidth: Integer; var NewHeight: Integer): Boolean;
begin
  Result := True;  // Allowing resizing.

  NewWidth := 24;  // But fixing width
  NewHeight := 24; // and heigth.
end;

procedure _TBFActiveXControl.Paint;
var
  Icon: TBitmap;
begin
  inherited;

  try
    Icon := TBitmap.Create;
    try
      with Icon, Self.Canvas do begin
        LoadFromResourceName(HInstance, AnsiUppercase(Copy(Self.ClassName, 2, Length(Self.ClassName) - 2)));
        Icon.Transparent := True;
        Lock;
        Draw(0, 0, Icon);
        Unlock;
      end;

    finally
      Icon.Free;
    end;

  except
  end;
end;

{$IFDEF TRIAL}
{$IFNDEF ACTIVEX}
initialization
   ShowAbout;
{$ENDIF}
{$ENDIF}

end.

