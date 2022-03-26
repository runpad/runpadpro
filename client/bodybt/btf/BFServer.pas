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
unit BFServer;

{$I BF.inc}

interface

uses
  BFAPI, BFServers, Classes;

type
  // OnData Event prototype.
  TBFServerEvent = procedure (Sender: TObject; Data: TBFByteArray) of object;

  // Simple server.
  TBFServer = class(TBFCustomServer)
  private
    FOnData: TBFServerEvent;

  protected
    procedure DoData(Data: TBFByteArray); override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

    // Writes data to the connection.
    procedure Write(Data: TBFByteArray); override;

  published
    // Even occurs when data available.
    property OnData: TBFServerEvent read FOnData write FOnData;
  end;

  _TBFServerX = class(_TBFCustomServerX)
  private
    function GetOnData: TBFServerEvent;

    procedure SetOnData(const Value: TBFServerEvent);
    
  protected
    function GetComponentClass: TBFCustomServerClass; override;

  public
    procedure Write(Data: TBFByteArray); 

  published
    property OnData: TBFServerEvent read GetOnData write SetOnData;
  end;

implementation

{ TBFServer }

constructor TBFServer.Create(AOwner: TComponent);
begin
  inherited;

  FOnData := nil;
end;

procedure TBFServer.DoData(Data: TBFByteArray);
begin
  inherited;

  if Assigned(FOnData) then
    try
      FOnData(Self, Data);
    except
    end;
end;

procedure TBFServer.Write(Data: TBFByteArray);
begin
  inherited;
end;

{ TBFServerX }

function _TBFServerX.GetComponentClass: TBFCustomServerClass;
begin
  Result := TBFServer;
end;

function _TBFServerX.GetOnData: TBFServerEvent;
begin
  Result := TBFServer(FBFCustomServer).OnData;
end;

procedure _TBFServerX.SetOnData(const Value: TBFServerEvent);
begin
  TBFServer(FBFCustomServer).OnData := Value;
end;

procedure _TBFServerX.Write(Data: TBFByteArray);
begin
  TBFServer(FBFCustomServer).Write(Data);
end;

end.
