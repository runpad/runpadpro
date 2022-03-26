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
unit BFVCard;

{$I BF.inc}

interface

uses
  Classes, BFBase;

type
  // Address type.
  TBFAddressType = (atDomestic, atInternational, atPostal, atParcel, atHome, atWork);
  // Address attributes.
  TBFAddressAttributes = set of TBFAddressType;
  // Phone type.
  TBFPhoneType = (ptPreferred, ptWork, ptHome, ptVoice, ptFax, ptMessaging, ptCellular, ptPager, ptBBS, ptModem, ptCar, ptISDN, ptVideo);
  // Phone number attributes.
  TBFPhoneAttributes = set of TBFPhoneType;
  // E-Mail type.
  TBFEmailType = (etDefault, etAOL, etAppleLink, etATTMail, etCompuserve, eteWorld, etInternet, etIBM, etMCI, etPowerShare, etProdigy, etTelex, etX400);

  // Company information.
  TBFCompanyRec = class(TBFBaseClass)
  private
    FAUnit: string;
    FName: string;

    procedure LoadFromStream(Stream: TStringList); overload;
    procedure SaveToStream(Stream: TStringList); overload;

  public
    // Default constructor.
    constructor Create;

    // Assign one instance of the TBFCompanyRec to another.
    procedure Assign(CompanyRec: TBFCompanyRec);
    // Clears company record.
    procedure Clear;

    // Unit name.
    property AUnit: string read FAUnit write FAUnit;
    // Company name.
    property Name: string read FName write FName;
  end;

  // Business card.
  TBFBusinessInfo = class(TBFBaseClass)
  private
    FCompany: TBFCompanyRec;
    FRole: string;
    FTitle: string;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    procedure SetCompany(const Value: TBFCompanyRec);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFBusinessInfo to another.
    procedure Assign(BusinessInfo: TBFBusinessInfo);
    // Clears business card.
    procedure Clear;

    // Company information.
    property Company: TBFCompanyRec read FCompany write SetCompany;
    // Role in the company.
    property Role: string read FRole write FRole;
    // Title in the company.
    property Title: string read FTitle write FTitle;
  end;

  // Address record.
  TBFAddressRec = class(TBFBaseClass)
  private
    FAttributes: TBFAddressAttributes;
    FCountry: string;
    FExtendedAddress: string;
    FLocality: string;
    FPOAddress: string;
    FPostalCode: string;
    FRegion: string;
    FStreet: string;

    procedure FillAttributes(Stream: TStringList);
    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFAddressRec to another.
    procedure Assign(AddressRec: TBFAddressRec);
    // Clears address record.
    procedure Clear;

    // Address attributes.
    property Attributes: TBFAddressAttributes read FAttributes write FAttributes;
    // Country name.
    property Country: string read FCountry write FCountry;
    // Extended address.
    property ExtendedAddress: string read FExtendedAddress write FExtendedAddress;
    // Locality.
    property Locality: string read FLocality write FLocality;
    // Post address.
    property POAddress: string read FPOAddress write FPOAddress;
    // Postal or ZIP code.
    property PostalCode: string read FPostalCode write FPostalCode;
    // Region.
    property Region: string read FRegion write FRegion;
    // Street name.
    property Street: string read FStreet write FStreet;
  end;

  // Delivery address record.
  TBFDeliveryInfo = class(TBFBaseClass)
  private
    FAddress1: TBFAddressRec;
    FAddress2: TBFAddressRec;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    procedure SetAddress1(const Value: TBFAddressRec);
    procedure SetAddress2(const Value: TBFAddressRec);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFDeliveryInfo to another.
    procedure Assign(DeliveryInfo: TBFDeliveryInfo);
    // Clears delivery information record.
    procedure Clear;

    // First address record.
    property Address1: TBFAddressRec read FAddress1 write SetAddress1;
    // Second address record.
    property Address2: TBFAddressRec read FAddress2 write SetAddress2;
  end;

  // Explanatory record.
  TBFExplanatoryInfo = class(TBFBaseClass)
  private
    FComment: TStringList;
    FURL1: string;
    FURL2: string;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    procedure SetComment(const Value: TStringList);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFExplanatoryInfo to another.
    procedure Assign(ExplanatoryInfo: TBFExplanatoryInfo);
    // Clears explanatory record.
    procedure Clear;

    // Comments.
    property Comment: TStringList read FComment write SetComment;
    // First URL link.
    property URL1: string read FURL1 write FURL1;
    // Second URL link.
    property URL2: string read FURL2 write FURL2;
  end;

  // Person name record.
  TBFNameRec = class(TBFBaseClass)
  private
    FAdditionalNames: string;
    FFamilyName: string;
    FGivenName: string;
    FPrefix: string;
    FSuffix: string;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFNameRec to another.
    procedure Assign(NameRec: TBFNameRec);
    // Clears person name record.
    procedure Clear;

    // Additional names.
    property AdditionalNames: string read FAdditionalNames write FAdditionalNames;
    // Family (Second) name.
    property FamilyName: string read FFamilyName write FFamilyName;
    // Given (First) name.
    property GivenName: string read FGivenName write FGivenName;
    // Name preffix.
    property Prefix: string read FPrefix write FPrefix;
    // Name suffix.
    property Suffix: string read FSuffix write FSuffix;
  end;

  // Person identification record.
  TBFIdentification = class(TBFBaseClass)
  private
    FFormattedName: string;
    FName: TBFNameRec;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    procedure SetName(const Value: TBFNameRec);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFIdentification to another.
    procedure Assign(Identification: TBFIdentification);
    // Clears identification record.
    procedure Clear;

    // Formated name.
    property FormattedName: string read FFormattedName write FFormattedName;
    // Person name record.
    property Name: TBFNameRec read FName write SetName;
  end;

  // E-Mail address record.
  TBFEmailRec = class(TBFBaseClass)
  private
    FAddress: string;
    FEmailType: TBFEmailType;

    procedure FillEmaiLType(Stream: TStringList);
    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFEmailRec to another.
    procedure Assign(EmailRec: TBFEmailRec);
    // Clears e-mail record.
    procedure Clear;

    // E-mail address.
    property Address: string read FAddress write FAddress;
    // E-mail address type.
    property EmailType: TBFEmailType read FEmailType write FEmailType;
  end;

  // Phone number record.
  TBFPhoneRec = class(TBFBaseClass)
  private
    FAttributes: TBFPhoneAttributes;
    FNumber: string;

    procedure FillAttributes(Stream: TStringList);
    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    
  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of the TBFPhoneRec to another.
    procedure Assign(PhoneRec: TBFPhoneRec);
    // Clears phone number record.
    procedure Clear;

    // Phone attributes.
    property Attributes: TBFPhoneAttributes read FAttributes write FAttributes;
    // Phone number.
    property Number: string read FNumber write FNumber;
  end;

  // Telecommunication information record.
  TBFTelecomInfo = class(TBFBaseClass)
  private
    FEmail1: TBFEmailRec;
    FEmail2: TBFEmailRec;
    FPhone1: TBFPhoneRec;
    FPhone2: TBFPhoneRec;
    FPhone3: TBFPhoneRec;

    procedure LoadFromStream(Stream: TStringList);
    procedure SaveToStream(Stream: TStringList);
    procedure SetEmail1(const Value: TBFEmailRec);
    procedure SetEmail2(const Value: TBFEmailRec);
    procedure SetPhone1(const Value: TBFPhoneRec);
    procedure SetPhone2(const Value: TBFPhoneRec);
    procedure SetPhone3(const Value: TBFPhoneRec);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFTelecomInfo to another.
    procedure Assign(TelecomInfo: TBFTelecomInfo);
    // Clears record.
    procedure Clear;

    // First e-mail address.
    property Email1: TBFEmailRec read FEmail1 write SetEmail1;
    // Second e-mail address.
    property Email2: TBFEmailRec read FEmail2 write SetEmail2;
    // First phone number.
    property Phone1: TBFPhoneRec read FPhone1 write SetPhone1;
    // Second phone number.
    property Phone2: TBFPhoneRec read FPhone2 write SetPhone2;
    // Third phone number.
    property Phone3: TBFPhoneRec read FPhone3 write SetPhone3;
  end;

  // vCard representation.
  TBFvCard = class(TBFBaseClass)
  private
    FBusinessInfo: TBFBusinessInfo;
    FDeliveryInfo: TBFDeliveryInfo;
    FExplanatoryInfo: TBFExplanatoryInfo;
    FIdentification: TBFIdentification;
    FTelecomInfo: TBFTelecomInfo;

    procedure SetBusinessInfo(const Value: TBFBusinessInfo);
    procedure SetDeliveryInfo(const Value: TBFDeliveryInfo);
    procedure SetExplanatoryInfo(const Value: TBFExplanatoryInfo);
    procedure SetIdentification(const Value: TBFIdentification);
    procedure SetTelecomInfo(const Value: TBFTelecomInfo);

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns obe instance of the TBFvCard to another.
    procedure Assign(Card: TBFvCard);
    // Clear vCard.
    procedure Clear;
    // Loads vCard from file.
    procedure LoadFromFile(FileName: string);
    // Loads vCard from stream. Do not supported by ActiveX.
    procedure LoadFromStream(Stream: TStringList); overload;
    procedure LoadFromStream(Stream: TStream); overload;
    // Saves vCard into the file.
    procedure SaveToFile(FileName: string);
    // Saves vCard into the stream. Do not supported by ActiveX.
    procedure SaveToStream(Stream: TStringList); overload;
    procedure SaveToStream(Stream: TStream); overload;

    // Business information.
    property BusinessInfo: TBFBusinessInfo read FBusinessInfo write SetBusinessInfo;
    // Delivery infromation.
    property DeliveryInfo: TBFDeliveryInfo read FDeliveryInfo write SetDeliveryInfo;
    // Explanatory information.
    property ExplanatoryInfo: TBFExplanatoryInfo read FExplanatoryInfo write SetExplanatoryInfo;
    // Identification.
    property Identification: TBFIdentification read FIdentification write SetIdentification;
    // Telecommunication information.
    property TelecomInfo: TBFTelecomInfo read FTelecomInfo write SetTelecomInfo;
  end;

  // List of vCards.
  TBFvCards = class(TBFBaseClass)
  private
    FList: TList;

    function GetCard(const Index: Integer): TBFvCard;
    function GetCount: Integer;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Returns index of the given vCard.
    function IndexOf(Card: TBFvCard): Integer;

    // Adds vCard into the list.
    procedure Add(Card: TBFvCard);
    // Assigns one instance of the TBFvCards to another.
    procedure Assign(ACards: TBFvCards);
    // Clears list.
    procedure Clear;
    // Delete vCard with specified index.
    procedure Delete(Index: Integer);
    // Loads vCards list from file.
    procedure LoadFromFile(FileName: string);
    // Loads vCards from stream. Do not supported by ActiveX.
    procedure LoadFromStream(Stream: TStringList); overload;
    procedure LoadFromStream(Stream: TStream); overload;
    // Saves vCards into the file.
    procedure SaveToFile(FileName: string);
    // Saves vCards into the stream. Do not supported by ActiveX.
    procedure SaveToStream(Stream: TStringList); overload;
    procedure SaveToStream(Stream: TStream); overload;

    // vCards zero based array.
    property Card[const Index: Integer]: TBFvCard read GetCard; default;
    // vCards count in the list.
    property Count: Integer read GetCount;
  end;

implementation

uses
  SysUtils, BFD5Support;

const
  ADDRESS_STRINGS: array [TBFAddressType] of string[6] = ('DOM', 'INTL',
                                                          'POSTAL', 'PARCEL',
                                                          'HOME', 'WORK');
  PHONE_STRINGS: array [TBFPhoneType] of string[5] = ('PREF', 'WORK', 'HOME',
                                                      'VOICE', 'FAX', 'MSG',
                                                      'CELL', 'PAGER', 'BBS',
                                                      'MODEM', 'CAR', 'ISDN',
                                                      'VIDEO');
  EMAIL_STRINGS: array [TBFEmailType] of string[10] =
                  ('','AOL','APPLELINK','ATTMAIL','CIS','EWORLD','INTERNET',
                   'IBMMAIL','MCIMAIL','POWERSHARE','PRODIGY','TLX','X400');

function Encode(PropName: string; Values: array of string): string;
var
  Loop: Integer;
  Tmp: string;
  Ndx: Integer;
  Chars: Integer;
begin
  Result := '';
  Tmp := PropName + ';CHARSET=UTF-8;ENCODING=QUOTED-PRINTABLE:';

  for Loop := Low(Values) to High(Values) do begin
    if Loop > Low(Values) then Tmp := Tmp + ';';
    Tmp := Tmp + AnsiToUtf8(Values[Loop]);
  end;

  Ndx := Pos(':', Tmp) + 1;
  Result := Copy(Tmp, 1, Ndx - 1);
  Chars := Length(Result);
  while Ndx <= Length(Tmp) do begin
    if Chars + 3 >= 76 then begin
      Result := Result + '=' + #$0D#$0A;
      Chars := 0;
    end;

    if Tmp[Ndx] = ';' then begin
      Result := Result + ';';
      Inc(Chars);

    end else begin
      Result := Result + '=' + IntToHex(Ord(Tmp[Ndx]), 2);
      Inc(Chars, 3);
    end;

    Inc(Ndx);
  end;
end;

type
  // Internal property parser.
  TBFPropertyParser = class
  private
    FNames: TStringList;
    FStream: TStringList;
    FValues: TStringList;

    procedure SetPropName(const Value: string);

  public
    constructor Create(Stream: TStringList);
    destructor Destroy; override;

    property PropName: string write SetPropName;
  end;

{ TBFPropertyParser }

constructor TBFPropertyParser.Create(Stream: TStringList);
begin
  FNames := TStringList.Create;
  FStream := Stream;
  FValues := TStringList.Create;
end;

destructor TBFPropertyParser.Destroy;
begin
  FNames.Free;
  FValues.Free;

  inherited;
end;

procedure TBFPropertyParser.SetPropName(const Value: string);
var
  Ndx: Integer;
  Loop: Integer;
  Line: string;
  Position: Integer;
  Names: string;
  Values: string;
  Ps: Integer;
  WideStr: WideString;
begin
  FNames.Clear;
  FValues.Clear;

  Ndx := -1;
  for Loop := 0 to FStream.Count - 1 do begin
    Line := AnsiUppercase(FStream[Loop]);
    Position := Pos(AnsiUppercase(Value), Line);

    if (Position = 1) and (Length(Line) > Length(Value)) and (Line[Length(Value) + 1] in [':', ';']) and (Copy(Line, 1, Length(Value)) = AnsiUppercase(Value))  then begin
      Ndx := Loop;
      Break;
    end;
  end;

  if Ndx > -1 then begin
    Line := FStream[Ndx];
    FStream.Delete(Ndx);

    if Pos('QUOTED-PRINTABLE', AnsiUppercase(Line)) > 0 then
      while Line[Length(Line)] = '=' do begin
        Delete(Line, Length(Line), 1);

        if FStream[Ndx][1] = ' ' then
          Line := Line + ' ' + Trim(FStream[Ndx])
        else
          Line := Line + FStream[Ndx];

        FStream.Delete(Ndx);
      end

    else
      while (Ndx < FStream.Count) and (FStream[Ndx][1] = ' ') do begin
        Line := Line + ' ' + Trim(FStream[Ndx]);
        FStream.Delete(Ndx);
      end;

    Names := '';
    Values := '';
    Line := Trim(Line);
    if Line <> '' then begin
      Names := Copy(Line, 1, Pos(':', Line) - 1);
      Values := Copy(Line, Pos(':', Line) + 1, Length(Line));

      if Pos('QUOTED-PRINTABLE', AnsiUppercase(Names)) > 0 then begin
        Values := Trim(Values);
        Line := '';

        while Length(Values) > 0 do
          if (Values[1] = '=') and (Length(Values) > 1) then begin
            Line := Line + Chr(StrToInt('$' + Values[2] + Values[3]));
            Delete(Values, 1, 3);

          end else begin
            if Values[1] <> '=' then Line := Line + Values[1];
            Delete(Values, 1, 1);
          end;

        Values := Line; 
      end;

      if Pos('UTF-8', Names) > 0 then Values := Utf8ToAnsi(Values);
      if Pos('ISO-8859-5', Names) > 0 then begin
        WideStr := '';
        for Ps := 1 to Length(Values) do WideStr := WideStr + WideChar($0360 + Ord(Values[Ps]));
        Values := string(WideStr);
      end;

      while Pos(';', Names) > 0 do begin
        FNames.Add(Copy(Names, 1, Pos(';', Names) - 1));
        Delete(Names, 1, Pos(';', Names));
      end;
      if Names <> '' then FNames.Add(Names);

      while Pos(';', Values) > 0 do begin
        FValues.Add(Copy(Values, 1, Pos(';', Values) - 1));
        Delete(Values, 1, Pos(';', Values));
      end;
      if Values <> '' then FValues.Add(Values);
    end;
  end;
end;

{ TBFCompanyRec }

procedure TBFCompanyRec.Assign(CompanyRec: TBFCompanyRec);
begin
  Clear;

  if Assigned(CompanyRec) then begin
    FName := CompanyRec.FName;
    FAUnit := CompanyRec.FAUnit;
  end;
end;

procedure TBFCompanyRec.Clear;
begin
  FAUnit := '';
  FName := '';
end;

constructor TBFCompanyRec.Create;
begin
  Clear;
end;

procedure TBFCompanyRec.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do
      try
        PropName := 'ORG';

        if FValues.Count > 1 then FAUnit := FValues[1];
        if FValues.Count > 0 then FName := FValues[0];

      finally
        Free;
      end;
end;

procedure TBFCompanyRec.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then
    if FName + FAUnit <> '' then
      Stream.Add(Encode('ORG', [FName, FAUnit]));
end;

{ TBFBusinessInfo }

procedure TBFBusinessInfo.Assign(BusinessInfo: TBFBusinessInfo);
begin
  Clear;

  if Assigned(BusinessInfo) then begin
    FTitle := BusinessInfo.FTitle;
    FRole := BusinessInfo.FRole;
    FCompany.Assign(BusinessInfo.FCompany);
  end;
end;

procedure TBFBusinessInfo.Clear;
begin
  FTitle := '';
  FRole := '';
  FCompany.Clear;
end;

constructor TBFBusinessInfo.Create;
begin
  FCompany := TBFCompanyRec.Create;  
  Clear;
end;

destructor TBFBusinessInfo.Destroy;
begin
  FCompany.Free;
  
  inherited;
end;

procedure TBFBusinessInfo.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then begin
    FCompany.LoadFromStream(Stream);

    with TBFPropertyParser.Create(Stream) do
      try
        PropName := 'TITLE';

        if FValues.Count <> 0 then FTitle := FValues[0];

        PropName := 'ROLE';

        if FValues.Count <> 0 then FRole := FValues[0];

      finally
        Free;
      end;
  end;
end;

procedure TBFBusinessInfo.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    FCompany.SaveToStream(Stream);

    if FTitle <> '' then Stream.Add(Encode('TITLE', [FTitle]));
    if FRole <> '' then Stream.Add(Encode('ROLE', [FRole]));
  end;
end;

procedure TBFBusinessInfo.SetCompany(const Value: TBFCompanyRec);
begin
  FCompany.Assign(Value);
end;

{ TBFAddressRec }

procedure TBFAddressRec.Assign(AddressRec: TBFAddressRec);
begin
  Clear;

  if Assigned(AddressRec) then begin
    FAttributes := AddressRec.FAttributes;
    FPOAddress := AddressRec.FPOAddress;
    FExtendedAddress := AddressRec.FExtendedAddress;
    FStreet := AddressRec.FStreet;
    FLocality := AddressRec.FLocality;
    FRegion := AddressRec.FRegion;
    FPostalCode := AddressRec.FPostalCode;
    FCountry := AddressRec.FCountry;
  end;
end;

procedure TBFAddressRec.Clear;
begin
  FAttributes := [];
  FPOAddress := '';
  FExtendedAddress := '';
  FStreet := '';
  FLocality := '';
  FRegion := '';
  FPostalCode := '';
  FCountry := '';
end;

constructor TBFAddressRec.Create;
begin
  Clear;
end;

procedure TBFAddressRec.FillAttributes(Stream: TStringList);
var
  Loop: TBFAddressType;
begin
  if Assigned(Stream) then
    if Stream.Count > 0 then
      for Loop := atDomestic to atWork do
        if Stream.IndexOf(ADDRESS_STRINGS[Loop]) > -1 then
          Include(FAttributes, Loop);
end;

procedure TBFAddressRec.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'ADR';

      if FValues.Count > 6 then FCountry := FValues[6];
      if FValues.Count > 5 then FPostalCode := FValues[5];
      if FValues.Count > 4 then FRegion := FValues[4];
      if FValues.Count > 3 then FLocality := FValues[3];
      if FValues.Count > 2 then FStreet := FValues[2];
      if FValues.Count > 1 then FExtendedAddress := FValues[1];
      if FValues.Count > 0 then FPOAddress := FValues[0];

      FillAttributes(FNames);

      Free;
    end;
end;

procedure TBFAddressRec.SaveToStream(Stream: TStringList);
var
  Line: string;
  Loop: TBFAddressType;
begin
  if Assigned(Stream) then
    if FPOAddress + FExtendedAddress + FStreet + FLocality + FRegion + FPostalCode + FCountry <> '' then begin
      Line := 'ADR';
      for Loop := atDomestic to atWork do
        if Loop in Attributes then
          Line := Line + ';' + ADDRESS_STRINGS[Loop];

      Stream.Add(Encode(Line, [FPOAddress, FExtendedAddress, FStreet, FLocality, FRegion, FPostalCode, FCountry]));
    end;
end;

{ TBFDeliveryInfo }

procedure TBFDeliveryInfo.Assign(DeliveryInfo: TBFDeliveryInfo);
begin
  Clear;

  if Assigned(DeliveryInfo) then begin
    FAddress1.Assign(DeliveryInfo.FAddress1);
    FAddress2.Assign(DeliveryInfo.FAddress2);
  end;
end;

procedure TBFDeliveryInfo.Clear;
begin
  FAddress1.Clear;
  FAddress2.Clear;
end;

constructor TBFDeliveryInfo.Create;
begin
  FAddress1 := TBFAddressRec.Create;
  FAddress2 := TBFAddressRec.Create;
  Clear;
end;

destructor TBFDeliveryInfo.Destroy;
begin
  FAddress2.Free;
  FAddress1.Free;

  inherited;
end;

procedure TBFDeliveryInfo.LoadFromStream(Stream: TStringList);
begin
  Clear;
  if Assigned(Stream) then begin
    FAddress1.LoadFromStream(Stream);
    FAddress2.LoadFromStream(Stream);
  end;
end;

procedure TBFDeliveryInfo.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    FAddress1.SaveToStream(Stream);
    FAddress2.SaveToStream(Stream);
  end;
end;

procedure TBFDeliveryInfo.SetAddress1(const Value: TBFAddressRec);
begin
  FAddress1.Assign(Value);
end;

procedure TBFDeliveryInfo.SetAddress2(const Value: TBFAddressRec);
begin
  FAddress2.Assign(Value);
end;

{ TBFExplanatoryInfo }

procedure TBFExplanatoryInfo.Assign(ExplanatoryInfo: TBFExplanatoryInfo);
begin
  Clear;

  if Assigned(ExplanatoryInfo) then begin
    FComment.Assign(ExplanatoryInfo.Comment);
    FURL1 := ExplanatoryInfo.URL1;
    FURL2 := ExplanatoryInfo.URL2;
  end;
end;

procedure TBFExplanatoryInfo.Clear;
begin
  FComment.Clear;
  FURL1 := '';
  FURL2 := '';
end;

constructor TBFExplanatoryInfo.Create;
begin
  FComment := TStringList.Create;
  Clear;
end;

destructor TBFExplanatoryInfo.Destroy;
begin
  FComment.Free;
  
  inherited;
end;

procedure TBFExplanatoryInfo.LoadFromStream(Stream: TStringList);
var
  Loop: Integer;
begin
  Clear;

  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'NOTE';

      for Loop := 0 to FValues.Count - 1 do FComment.Add(FValues[Loop]);

      PropName := 'URL';

      if FValues.Count <> 0 then FURL1 := FValues[0];

      PropName := 'URL';

      if FValues.Count <> 0 then FURL2 := FValues[0];

      Free;
    end;
end;

procedure TBFExplanatoryInfo.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    if FComment.Count > 0 then Stream.Add(Encode('NOTE', [FComment.Text]));

    if FURL1 <> '' then Stream.Add('URL:' + FURL1);
    if FURL2 <> '' then Stream.Add('URL:' + FURL2);
  end;
end;

procedure TBFExplanatoryInfo.SetComment(const Value: TStringList);
begin
  FComment.Assign(Value);
end;

{ TBFNameRec }

procedure TBFNameRec.Assign(NameRec: TBFNameRec);
begin
  Clear;

  if Assigned(NameRec) then begin
    FAdditionalNames := NameRec.FAdditionalNames;
    FFamilyName := NameRec.FFamilyName;
    FGivenName := NameRec.FGivenName;
    FPrefix := NameRec.FPrefix;
    FSuffix := NameRec.FSuffix;
  end;
end;

procedure TBFNameRec.Clear;
begin
  FAdditionalNames := '';
  FFamilyName := '';
  FGivenName := '';
  FPrefix := '';
  FSuffix := '';
end;

constructor TBFNameRec.Create;
begin
  Clear;
end;

procedure TBFNameRec.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'N';

      if FValues.Count > 4 then FSuffix := FValues[4];
      if FValues.Count > 3 then FPrefix := FValues[3];
      if FValues.Count > 2 then FAdditionalNames := FValues[2];
      if FValues.Count > 1 then FGivenName := FValues[1];
      if FValues.Count > 0 then FFamilyName := FValues[0];

      Free;
    end;
end;

procedure TBFNameRec.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then
    if FFamilyName + FGivenName + FAdditionalNames + FPrefix + FSuffix <> '' then
      Stream.Add(Encode('N', [FamilyName, FGivenName, FAdditionalNames, FPrefix, FSuffix]));
end;

{ TBFIdentification }

procedure TBFIdentification.Assign(Identification: TBFIdentification);
begin
  Clear;

  if Assigned(Identification) then begin
    FName.Assign(Identification.FName);
    FFormattedName := Identification.FFormattedName;
  end;
end;

procedure TBFIdentification.Clear;
begin
  FName.Clear;
  FFormattedName := '';
end;

constructor TBFIdentification.Create;
begin
  FName := TBFNameRec.Create;
  Clear;
end;

destructor TBFIdentification.Destroy;
begin
  FName.Free;

  inherited;
end;

procedure TBFIdentification.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then begin
    FName.LoadFromStream(Stream);

    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'FN';

      if FValues.Count > 0 then FFormattedName := FValues[0];

      Free;
    end;
  end;
end;

procedure TBFIdentification.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    if FFormattedName <> '' then Stream.Add(Encode('FN', [FFormattedName]));
    FName.SaveToStream(Stream);
  end;
end;

procedure TBFIdentification.SetName(const Value: TBFNameRec);
begin
  FName.Assign(Value);
end;

{ TBFEmailRec }

procedure TBFEmailRec.Assign(EmailRec: TBFEmailRec);
begin
  Clear;
  if Assigned(EmailRec) then begin
    FEmailType := EmailRec.FEmailType;
    FAddress := EmailRec.FAddress;
  end;
end;

procedure TBFEmailRec.Clear;
begin
  FEmailType := etDefault;
  FAddress := '';
end;

constructor TBFEmailRec.Create;
begin
  Clear;
end;

procedure TBFEmailRec.FillEmaiLType(Stream: TStringList);
var
  Loop: TBFEmailType;
begin
  if Assigned(Stream) then
    if Stream.Count > 0 then
      for Loop := etDefault to etX400 do
        if Stream.IndexOf(EMAIL_STRINGS[Loop]) > 0 then
          FEmailType := Loop;
end;

procedure TBFEmailRec.LoadFromStream(Stream: TStringList);
begin
  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'EMAIL';

      if FValues.Count > 0 then FAddress := FValues[0];

      FillEmailType(FNames);

      Free;
    end;
end;

procedure TBFEmailRec.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then
    if FAddress <> '' then
      Stream.Add('EMAIL;' + EMAIL_STRINGS[FEmailType] + ':' + FAddress);
end;

{ TBFPhoneRec }

procedure TBFPhoneRec.Assign(PhoneRec: TBFPhoneRec);
begin
  Clear;

  if Assigned(PhoneRec) then begin
    FAttributes := PhoneRec.FAttributes;
    FNumber := PhoneRec.FNumber;
  end;
end;

procedure TBFPhoneRec.Clear;
begin
  FAttributes := [];
  FNumber := '';
end;

constructor TBFPhoneRec.Create;
begin
  Clear;
end;

procedure TBFPhoneRec.FillAttributes(Stream: TStringList);
var
  Loop: TBFPhoneType;
begin
  if Assigned(Stream) then
    if Stream.Count > 0 then
      for Loop := ptPreferred to ptVideo do
        if Stream.IndexOf(PHONE_STRINGS[Loop]) > -1 then
          Include(FAttributes, Loop);
end;

procedure TBFPhoneRec.LoadFromStream(Stream: TStringList);
begin
  if Assigned(Stream) then
    with TBFPropertyParser.Create(Stream) do begin
      PropName := 'TEL';

      if FValues.Count > 0 then FNumber := FValues[0];

      FillAttributes(FNames);

      Free;
    end;
end;

procedure TBFPhoneRec.SaveToStream(Stream: TStringList);
var
  Loop: TBFPhoneType;
  Line: string;
begin
  if Assigned(Stream) then
    if FNumber <> '' then begin
      Line := 'TEL';

      for Loop := ptPreferred to ptVideo do
        if Loop in FAttributes then
          Line := Line + ';' + PHONE_STRINGS[Loop];

      Line := Line + ':' + FNumber;
      Stream.Add(Line);
    end;
end;

{ TBFTelecomInfo }

procedure TBFTelecomInfo.Assign(TelecomInfo: TBFTelecomInfo);
begin
  Clear;

  if Assigned(TelecomInfo) then begin
    FEmail1.Assign(TelecomInfo.FEmail1);
    FEmail2.Assign(TelecomInfo.FEmail2);

    FPhone1.Assign(TelecomInfo.FPhone1);
    FPhone2.Assign(TelecomInfo.FPhone2);
    FPhone3.Assign(TelecomInfo.FPhone3);
  end;
end;

procedure TBFTelecomInfo.Clear;
begin
  FEmail1.Clear;
  FEmail2.Clear;

  FPhone1.Clear;
  FPhone2.Clear;
  FPhone3.Clear;
end;

constructor TBFTelecomInfo.Create;
begin
  FEmail1 := TBFEmailRec.Create;
  FEmail2 := TBFEmailRec.Create;

  FPhone1 := TBFPhoneRec.Create;
  FPhone2 := TBFPhoneRec.Create;
  FPhone3 := TBFPhoneRec.Create;
end;

destructor TBFTelecomInfo.Destroy;
begin
  FEmail2.Free;
  FEmail1.Free;

  FPhone3.Free;
  FPhone2.Free;
  FPhone1.Free;

  inherited;
end;

procedure TBFTelecomInfo.LoadFromStream(Stream: TStringList);
begin
  Clear;

  if Assigned(Stream) then begin
    FEmail1.LoadFromStream(Stream);
    FEmail2.LoadFromStream(Stream);

    FPhone1.LoadFromStream(Stream);
    FPhone2.LoadFromStream(Stream);
    FPhone3.LoadFromStream(Stream);
  end;
end;

procedure TBFTelecomInfo.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    FEmail1.SaveToStream(Stream);
    FEmail2.SaveToStream(Stream);

    FPhone1.SaveToStream(Stream);
    FPhone2.SaveToStream(Stream);
    FPhone3.SaveToStream(Stream);
  end;
end;

procedure TBFTelecomInfo.SetEmail1(const Value: TBFEmailRec);
begin
  FEmail1.Assign(Value);
end;

procedure TBFTelecomInfo.SetEmail2(const Value: TBFEmailRec);
begin
  FEmail2.Assign(Value);
end;

procedure TBFTelecomInfo.SetPhone1(const Value: TBFPhoneRec);
begin
  FPhone1.Assign(Value);
end;

procedure TBFTelecomInfo.SetPhone2(const Value: TBFPhoneRec);
begin
  FPhone2.Assign(Value);
end;

procedure TBFTelecomInfo.SetPhone3(const Value: TBFPhoneRec);
begin
  FPhone3.Assign(Value);
end;                   

{ TBFvCard }

procedure TBFvCard.Assign(Card: TBFvCard);
begin
  Clear;

  if Assigned(Card) then begin
    FBusinessInfo.Assign(Card.FBusinessInfo);
    FDeliveryInfo.Assign(Card.FDeliveryInfo);
    FExplanatoryInfo.Assign(Card.FExplanatoryInfo);
    FIdentification.Assign(Card.FIdentification);
    FTelecomInfo.Assign(Card.FTelecomInfo);
  end;
end;

procedure TBFvCard.Clear;
begin
  FBusinessInfo.Clear;
  FDeliveryInfo.Clear;
  FExplanatoryInfo.Clear;
  FIdentification.Clear;
  FTelecomInfo.Clear;
end;

constructor TBFvCard.Create;
begin
  FBusinessInfo := TBFBusinessInfo.Create;
  FDeliveryInfo := TBFDeliveryInfo.Create;
  FExplanatoryInfo := TBFExplanatoryInfo.Create;
  FIdentification := TBFIdentification.Create;
  FTelecomInfo := TBFTelecomInfo.Create;
end;

destructor TBFvCard.Destroy;
begin
  FBusinessInfo.Free;
  FDeliveryInfo.Free;
  FExplanatoryInfo.Free;
  FIdentification.Free;
  FTelecomInfo.Free;
  
  inherited;
end;

procedure TBFvCard.LoadFromFile(FileName: string);
var
  Stream: TStringList;
begin
  Stream := TStringList.Create;

  try
    Stream.LoadFromFile(FileName);
    LoadFromStream(Stream);

  finally
    Stream.Free;
  end;
end;

procedure TBFvCard.LoadFromStream(Stream: TStringList);
var
  AStream: TStringList;
begin
  Clear;
  
  if Assigned(Stream) then begin
    AStream := TStringList.Create;
    AStream.Assign(Stream);

    try
      FBusinessInfo.LoadFromStream(AStream);
      FDeliveryInfo.LoadFromStream(AStream);
      FExplanatoryInfo.LoadFromStream(AStream);
      FIdentification.LoadFromStream(AStream);
      FTelecomInfo.LoadFromStream(AStream);

    finally
      AStream.Free;
    end;
  end;
end;

procedure TBFvCard.LoadFromStream(Stream: TStream);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;

  try
    StringList.LoadFromStream(Stream);
    LoadFromStream(StringList);

  finally
    StringList.Free;
  end;
end;

procedure TBFvCard.SaveToFile(FileName: string);
var
  Stream: TStringList;
begin
  Stream := TStringList.Create;

  SaveToStream(Stream);

  try
    Stream.SaveToFile(FileName);

  finally
    Stream.Free;
  end;
end;

procedure TBFvCard.SaveToStream(Stream: TStringList);
begin
  if Assigned(Stream) then begin
    with Stream do begin
      Add('BEGIN:VCARD');
      Add('VERSION:2.1');
    end;

    FBusinessInfo.SaveToStream(Stream);
    FDeliveryInfo.SaveToStream(Stream);
    FExplanatoryInfo.SaveToStream(Stream);
    FIdentification.SaveToStream(Stream);
    FTelecomInfo.SaveToStream(Stream);

    Stream.Add('END:VCARD');
  end;
end;                  

procedure TBFvCard.SaveToStream(Stream: TStream);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;

  try
    SaveToStream(StringList);
    StringList.SaveToStream(Stream);

  finally
    StringList.Free;
  end;
end;

procedure TBFvCard.SetBusinessInfo(const Value: TBFBusinessInfo);
begin
  FBusinessInfo.Assign(Value);
end;

procedure TBFvCard.SetDeliveryInfo(const Value: TBFDeliveryInfo);
begin
  FDeliveryInfo.Assign(Value);
end;

procedure TBFvCard.SetExplanatoryInfo(const Value: TBFExplanatoryInfo);
begin
  FExplanatoryInfo.Assign(Value);
end;

procedure TBFvCard.SetIdentification(const Value: TBFIdentification);
begin
  FIdentification.Assign(Value);
end;

procedure TBFvCard.SetTelecomInfo(const Value: TBFTelecomInfo);
begin
  FTelecomInfo.Assign(Value);
end;

{ TBFvCards }

procedure TBFvCards.Add(Card: TBFvCard);
begin
  if IndexOf(Card) = -1 then FList.Add(Card);
end;

procedure TBFvCards.Clear;
begin
  FList.Clear;
end;

constructor TBFvCards.Create;
begin
  FList := TList.Create;
end;

procedure TBFvCards.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TBFvCards.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFvCards.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFvCards.GetCard(const Index: Integer): TBFvCard;
begin
  Result := TBFvCard(FList[Index]);
end;

function TBFvCards.IndexOf(Card: TBFvCard): Integer;
begin
  Result := FList.IndexOf(Card);
end;

procedure TBFvCards.LoadFromFile(FileName: string);
var
  Stream: TStringList;
begin
  Stream := TStringList.Create;

  try
    Stream.LoadFromFile(FileName);
    LoadFromStream(Stream);

  finally
    Stream.Free;
  end;
end;

procedure TBFvCards.LoadFromStream(Stream: TStringList);
var
  Tmp: TStringList;
  Loop: Integer;
  Add: Boolean;
  Card: TBFvCard;
begin
  Clear;

  if Assigned(Stream) then begin
    Tmp := TStringList.Create;

    Loop := 0;
    Add := False;

    while Loop < Stream.Count do begin
      if AnsiUppercase(Stream[Loop]) = 'BEGIN:VCARD' then Add := True;

      if Add then begin
        Tmp.Add(Stream[Loop]);

        if AnsiUppercase(Stream[Loop]) = 'END:VCARD' then begin
          Add := False;
          Card := TBFvCard.Create;
          Card.LoadFromStream(Tmp);
          FList.Add(Card);
          Tmp.Clear;
        end;
      end;

      Inc(Loop);
    end;

    Tmp.Free;
  end;
end;

procedure TBFvCards.SaveToFile(FileName: string);
var
  Stream: TStringList;
begin
  Stream := TStringList.Create;

  SaveToStream(Stream);

  try
    Stream.SaveToFile(FileName);

  finally
    Stream.Free;
  end;
end;

procedure TBFvCards.SaveToStream(Stream: TStringList);
var
  Loop: Integer;
begin
  if Assigned(Stream) then begin
    Stream.Clear;

    for Loop := 0 to FList.Count - 1 do TBFvCard(FList[Loop]).SaveToStream(Stream);
  end;
end;

procedure TBFvCards.Assign(ACards: TBFvCards);
var
  Loop: Integer;
  ACard: TBFvCard;
begin
  Clear;

  if Assigned(ACards) then
    for Loop := 0 to ACards.Count - 1 do begin
      ACard := TBFvCard.Create;
      ACard.Assign(ACards[Loop]);
      FList.Add(ACard);
    end;
end;

procedure TBFvCards.LoadFromStream(Stream: TStream);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;

  try
    StringList.LoadFromStream(Stream);
    LoadFromStream(StringList);

  finally
    StringList.Free;
  end;
end;

procedure TBFvCards.SaveToStream(Stream: TStream);
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;

  try
    SaveToStream(StringList);
    StringList.SaveToStream(Stream);

  finally
    StringList.Free;
  end;
end;

end.
