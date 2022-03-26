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
unit BFSerialEventsClient;

{$I BF.inc}

interface

uses
  BFSerialPortClient, Classes, BFClients;

type
  // Event procedure prototype for TBFSerialEventsClient.
  // EventData contains the string received from remote device.
  TBFSerialEvent = procedure (Sender: TObject; EventData: string) of object;

  // This component allows you to receive enevts from remote device.
  // Usefull for GPS receivers and other devices which do not
  // need both side communication.
  TBFSerialEventsClient = class(TBFSerialPortClient)
  private
    FOnEvent: TBFSerialEvent;

  protected
    procedure DoData; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

  published
    // Event occurs when data received from remote device.
    property OnEvent: TBFSerialEvent read FOnEvent write FOnEvent;
  end;

  _TBFSerialEventsClientX = class(_TBFSerialPortClientX)
  private
    function GetOnEvent: TBFSerialEvent;

    procedure SetOnEvent(const Value: TBFSerialEvent);

  protected
    function GetComponentClass: TBFCustomClientClass; override;

  published
    property OnEvent: TBFSerialEvent read GetOnEvent write SetOnEvent;
  end;

implementation

uses
  BFAPI, Windows;

{ TBFSerialEventsClient }

constructor TBFSerialEventsClient.Create(AOwner: TComponent);
begin
  inherited;

  FOnEvent := nil;
end;

procedure TBFSerialEventsClient.DoData;
var
  Data: TBFByteArray;
  Size: DWORD;
begin
  // Do not call inherited because we do not need any other way to receive data.
  Size := 255;
  SetLength(Data, Size);
  Read(Data, Size);
  try
    if Assigned(FOnEvent) then FOnEvent(Self, string(Data));

  finally
    SetLength(Data, 0);
  end;
end;

{ TBFSerialEventsClientX }

function _TBFSerialEventsClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFSerialEventsClient;
end;

function _TBFSerialEventsClientX.GetOnEvent: TBFSerialEvent;
begin
  Result := TBFSerialEventsClient(FBFCustomClient).OnEvent;
end;

procedure _TBFSerialEventsClientX.SetOnEvent(const Value: TBFSerialEvent);
begin
  TBFSerialEventsClient(FBFCustomClient).OnEvent := Value;
end;

end.
