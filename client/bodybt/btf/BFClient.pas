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
unit BFClient;

{$I BF.inc}

interface

uses
  BFClients, BFAPI, Windows;

type
  // Simple client.
  TBFClient = class(TBFCustomClient)
  public
    // Reads data from the connection.
    procedure Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean = False); override;
    // Writes data to the connection.
    procedure Write(Data: TBFByteArray); override;
  end;

  _TBFClientX = class(_TBFCustomClientX)
  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    procedure Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean = False);
    procedure Write(Data: TBFByteArray); 
  end;

implementation

{ TBFClient }

procedure TBFClient.Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean = False);
begin
  inherited;
end;

procedure TBFClient.Write(Data: TBFByteArray);
begin
  inherited;
end;

{ TBFClientX }

function _TBFClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFClient;
end;

procedure _TBFClientX.Read(var Data: TBFByteArray; var Size: DWORD; WaitForData: Boolean);
begin
  TBFClient(FBFCustomClient).Read(Data, Size, WaitForData);
end;

procedure _TBFClientX.Write(Data: TBFByteArray);
begin
  TBFClient(FBFCustomClient).Write(Data);
end;

end.
