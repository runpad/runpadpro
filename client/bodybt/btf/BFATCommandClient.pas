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
unit BFATCommandClient;

{$I BF.inc}

interface

uses
  BFSerialPortClient, BFClients;

type
  // Base class for AT-based clients. Application should neve use tis class.
  TBFATCommandsClient = class(TBFSerialPortClient)
  protected
    // Check AT command response and raise an exception if something wrong.
    procedure CheckATCommandRespose(Resp: string);
    procedure InternalOpen; override;

  public
    // Override inherited procedure and adds error checking.
    procedure ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false); override;
  end;

  _TBFATCommandsClientX = class(_TBFSerialPortClientX)
  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    procedure ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false);
  end;

implementation

uses
  BFAPI, SysUtils, Classes, BFStrings;

{ TBFATCommandsClient }

procedure TBFATCommandsClient.CheckATCommandRespose(Resp: string);
var
  Lines: TStringList;
  Loop: Integer;
begin
  Lines := nil;
  
  // Check if error. Otherwise it is OK.
  if Pos(RESP_ERROR, Resp) > 0 then
    try
      Lines := TStringList.Create;
      Lines.Text := Resp;

      for Loop := 0 to Lines.Count - 1 do
        if Pos(RESP_ERROR, Lines[Loop]) > 0 then
          raise Exception.CreateFmt(StrErrorExecutingATCommand, [Lines[Loop]]);

    finally
      if Assigned(Lines) then Lines.Free;
    end;
end;

procedure TBFATCommandsClient.ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false);
begin
  inherited;

  CheckATCommandRespose(Response);
end;

procedure TBFATCommandsClient.InternalOpen;
var
  Resp: string;
begin
  inherited;

  ExecuteATCommand('ATZ', Resp);
end;

{ TBFATCommandsClientX }

procedure _TBFATCommandsClientX.ExecuteATCommand(Command: string; var Response: string; NeedLF: Boolean = false);
begin
  TBFATCommandsClient(FBFCustomClient).ExecuteATCommand(Command, Response, NeedLF);
end;

function _TBFATCommandsClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFATCommandsClient;
end;

end.
