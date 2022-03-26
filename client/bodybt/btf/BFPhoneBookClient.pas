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
unit BFPhoneBookClient;

{I BF.inc}

interface

uses
  BFSyncClient, BFvCard, Classes, BFClients;

type
  // Allow you tro access to the phone book of mobile devices.
  TBFPhoneBookClient = class(TBFCustomSyncClient)
  private
    FCards: TBFvCards;

  protected
    procedure InternalClose; override;

  public
    constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;

    // Loads phone book from device.
    procedure Load;
    // Saves phone book to the device.
    procedure Save;

    // Records of the phone book.
    property Cards: TBFvCards read FCards;
  end;

  _TBFPhoneBookClientX = class(_TBFCustomSyncClientX)
  private
    function GetCards: TBFvCards;
  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    procedure Load;
    procedure Save;

    property Cards: TBFvCards read GetCards;
  end;

implementation

{ TBFPhoneBookClient }

constructor TBFPhoneBookClient.Create(AOnwer: TComponent);
begin
  inherited;

  FCards := TBFvCards.Create;
end;

destructor TBFPhoneBookClient.Destroy;
begin
  FCards.Free;

  inherited;
end;

procedure TBFPhoneBookClient.InternalClose;
begin
  inherited;

  FCards.Clear;
end;

procedure TBFPhoneBookClient.Load;
var
  Stream: TStringList;
  TmpStream: TStringList;
  Loop: Integer;
  Str: string;
  Card: TBFvCard;
begin
  Stream := TStringList.Create;
  try
    TmpStream := TStringList.Create;

    try
      ReadObject(soPhoneBook, Stream);

      for Loop := 0 to Stream.Count - 1 do begin
        Str := Stream[Loop];
        TmpStream.Add(Str);

        if Str = 'END:VCARD' then begin
          Card := TBFvCard.Create;
          Card.LoadFromStream(TmpStream);
          TmpStream.Clear;
          FCards.Add(Card);
        end;
      end;

    finally
      TmpStream.Free;
    end;

  finally
    Stream.Free;
  end;
end;

procedure TBFPhoneBookClient.Save;
var
  Loop: Integer;
  Stream: TStringList;
begin
  Stream := TStringList.Create;

  for Loop := 0 to FCards.Count - 1 do FCards.Card[Loop].SaveToStream(Stream);

  try
    WriteObject(soPhoneBook, Stream);

  finally
    Stream.Free;
  end;
end;

{ TBFPhoneBookClientX }

function _TBFPhoneBookClientX.GetCards: TBFvCards;
begin
  Result := TBFPhoneBookClient(FBFCustomClient).Cards;
end;

function _TBFPhoneBookClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFPhoneBookClient;
end;

procedure _TBFPhoneBookClientX.Load;
begin
  TBFPhoneBookClient(FBFCustomClient).Load;
end;

procedure _TBFPhoneBookClientX.Save;
begin
  TBFPhoneBookClient(FBFCustomClient).Save;
end;

end.
