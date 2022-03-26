//
// Copyright (c) 2006-2007 Mike Petrichenko. Soft Service Company.
//                         All rights reserved.
//
//
// Use of this source code is subject to the terms of the Bluetooth Framework
// end-user license agreement (EULA) under which you licensed this SOFTWARE
// PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.PDF on your
// install media.
//
unit BFSDPParser;

{$I BF.inc}

interface

uses
  BFAPI, BFBase, Windows, Contnrs;

const
  SDP_ERROR_INVALID_SDP_VERSION = $0001;
  SDP_ERROR_INVALID_RECORD_HANDLE = $0002;
  SDP_ERROR_INVALID_REQUEST_SYNTAX = $0003;
  SDP_ERROR_INVALID_PDU_SIZE = $0004;
  SDP_ERROR_INVALID_CONTINUATION_STATE = $0005;
  SDP_ERROR_INSUFFICIENT_RESOURCES = $0006;

  SDP_ATTRIB_RECORD_HANDLE = $0000;
  SDP_ATTRIB_CLASS_ID_LIST = $0001;
  SDP_ATTRIB_RECORD_STATE = $0002;
  SDP_ATTRIB_SERVICE_ID = $0003;
  SDP_ATTRIB_PROTOCOL_DESCRIPTOR_LIST = $0004;
  SDP_ATTRIB_BROWSE_GROUP_LIST = $0005;
  SDP_ATTRIB_LANG_BASE_ATTRIB_ID_LIST = $0006;
  SDP_ATTRIB_INFO_TIME_TO_LIVE = $0007;
  SDP_ATTRIB_AVAILABILITY = $0008;
  SDP_ATTRIB_PROFILE_DESCRIPTOR_LIST = $0009;
  SDP_ATTRIB_DOCUMENTATION_URL = $000A;
  SDP_ATTRIB_CLIENT_EXECUTABLE_URL = $000B;
  SDP_ATTRIB_ICON_URL = $000C;
  SDP_ATTRIB_ADDITIONAL_PROTOCOL_DESCRIPTOR_LIST = $000D;

  SDP_DEFAULT_BASE_LANGUAGE = $0100;

  STRING_NAME_OFFSET = $0000;
  STRING_DESCRIPTION_OFFSET = $0001;
  STRING_PROVIDER_NAME_OFFSET = $0002;
  
  SDP_ATTRIB_SERVICE_NAME = SDP_DEFAULT_BASE_LANGUAGE + STRING_NAME_OFFSET;
  SDP_ATTRIB_SERVICE_DESCRIPTION = SDP_DEFAULT_BASE_LANGUAGE + STRING_DESCRIPTION_OFFSET;
  SDP_ATTRIB_PROVIDER_NAME = SDP_DEFAULT_BASE_LANGUAGE + STRING_PROVIDER_NAME_OFFSET;

  SDP_ATTRIB_PROFILE_SPECIFIC = $0200;

  SDP_ATTRIB_SDP_VERSION_NUMBER_LIST = $0200;
  SDP_ATTRIB_SDP_DATABASE_STATE = $0201;

  SDP_ATTRIB_BROWSE_GROUP_ID = $0200;

  SDP_ATTRIB_CORDLESS_EXTERNAL_NETWORK = $0301;

  SDP_ATTRIB_FAX_CLASS_1_SUPPORT = $0302;
  SDP_ATTRIB_FAX_CLASS_2_0_SUPPORT = $0303;
  SDP_ATTRIB_FAX_CLASS_2_SUPPORT = $0304;
  SDP_ATTRIB_FAX_AUDIO_FEEDBACK_SUPPORT = $0305;

  SDP_ATTRIB_HEADSET_REMOTE_AUDIO_VOLUME_CONTROL = $0302;

  SDP_ATTRIB_LAN_LPSUBNET = $0200;

  SDP_ATTRIB_OBJECT_PUSH_SUPPORTED_FORMATS_LIST = $0303;

  SDP_ATTRIB_SYNCH_SUPPORTED_DATA_STORES_LIST = $0301;

  SDP_ATTRIB_SERVICE_VERSION = $0300;

  PSM_SDP = $0001;
  PSM_RFCOMM = $0003;
  PSM_TCS_BIN = $0005;
  PSM_TCS_BIN_CORDLESS = $0007;

  SDP_ATTRIB_HID_DEVICE_RELEASE_NUMBER = $0200;
  SDP_ATTRIB_HID_PARSER_VERSION = $0201;
  SDP_ATTRIB_HID_DEVICE_SUBCLASS = $0202;
  SDP_ATTRIB_HID_COUNTRY_CODE = $0203;
  SDP_ATTRIB_HID_VIRTUAL_CABLE = $0204;
  SDP_ATTRIB_HID_RECONNECT_INITIATE = $0205;
  SDP_ATTRIB_HID_DESCRIPTOR_LIST = $0206;
  SDP_ATTRIB_HID_LANGID_BASE_LIST = $0207;
  SDP_ATTRIB_HID_SDP_DISABLE = $0208;
  SDP_ATTRIB_HID_BATTERY_POWER = $0209;
  SDP_ATTRIB_HID_REMOTE_WAKE = $020A;
  SDP_ATTRIB_HID_PROFILE_VERSION = $020B;
  SDP_ATTRIB_HID_SUPERVISION_TIMEOUT = $020C;
  SDP_ATTRIB_HID_NORMALLY_CONNECTABLE = $020D;
  SDP_ATTRIB_HID_BOOT_DEVICE = $020E;

  SDP_SIZE_INDEX_1_BYTE = $00;
  SDP_SIZE_INDEX_2_BYTES = $01;
  SDP_SIZE_INDEX_4_BYTES = $02;
  SDP_SIZE_INDEX_8_BYTES = $03;
  SDP_SIZE_INDEX_16_BYTES = $04;
  SDP_SIZE_INDEX_ADD_1_BYTE = $05;
  SDP_SIZE_INDEX_ADD_2_BYTES = $06;
  SDP_SIZE_INDEX_ADD_4_BYTES = $07;

  SDP_TYPE_NIL = $00;
  SDP_TYPE_UINT = $01;
  SDP_TYPE_INT = $02;
  SDP_TYPE_UUID = $03;
  SDP_TYPE_TEXT = $04;
  SDP_TYPE_BOOLEAN = $05;
  SDP_TYPE_BYTES_SEQUENCE = $06;
  SDP_TYPE_BYTES_SEQUENCE_ALTERNATIVE = $07;
  SDP_TYPE_URL = $08;

  SDP_TYPE_MASK = $F8;
  SDP_SIZE_INDEX_MASK = $07;

  SDP_ATTRIBUTE_BYTE = (SDP_TYPE_UINT shl $03) or SDP_SIZE_INDEX_2_BYTES;
  SDP_SEQUENCE_35_BYTE = (SDP_TYPE_BYTES_SEQUENCE shl $03) or SDP_SIZE_INDEX_ADD_1_BYTE;
  SDP_SEQUENCE_36_BYTE = (SDP_TYPE_BYTES_SEQUENCE shl $03) or SDP_SIZE_INDEX_ADD_2_BYTES;

  SDP_PARAM_NDX_L2CAP_PSM = $01;
  SDP_PARAM_NDX_RFCOMM_Channel = $01;
  SDP_PARAM_NDX_TCP_Port = $01;
  SDP_PARAM_NDX_UDP_Port = $01;
  SDP_PARAM_NDX_BNEP_Version = $01;
  SDP_PARAM_DX_BNEP_SupportedNetworkPacketTypeList = $02;

type
  TBFSDPElement = class(TBFBaseClass)
  private
    FData: TBFByteArray;
    FDataType: Byte;
    FSize: DWORD;

    function GetAsByte: Byte;
    function GetAsWord: Word;
    function GetAsDWord: DWORD;

  public
    constructor Create;
    destructor Destroy; override;

    property AsByte: Byte read GetAsByte;
    property AsWord: Word read GetAsWord;
    property AsDWord: DWORD read GetAsDWord;
    property Data: TBFByteArray read FData;
    property DataType: Byte read FDataType;
    property Size: DWORD read FSize;
  end;

  TBFSDPAttributeElements = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetElements(const Index: Integer): TBFSDPElement;

  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Elements[const Index: Integer]: TBFSDPElement read GetElements; default;
  end;

  TBFSDPAttribute = class(TBFBaseClass)
  private
    FAttributeType: Word;
    FElements: TBFSDPAttributeElements;

  public
    constructor Create;
    destructor Destroy; override;

    property AttributeType: Word read FAttributeType;
    property Elements: TBFSDPAttributeElements read FElements;
  end;

  TBFSDPAttributes = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetAttributes(const Index: Integer): TBFSDPAttribute;
    function GetCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    property Attributes[const Index: Integer]: TBFSDPAttribute read GetAttributes; default;
    property Count: Integer read GetCount;
  end;

  TBFSDPServiceRecord = class(TBFBaseClass)
  private
    FAttributes: TBFSDPAttributes;
    FID: DWORD;

    function GetAttribute(const AttributeType: Word): TBFSDPAttribute;

  public
    constructor Create;
    destructor Destroy; override;

    property Attribute[const AttributeType: Word]: TBFSDPAttribute read GetAttribute;
    property Attributes: TBFSDPAttributes read FAttributes;
    property ID: DWORD read FID;
  end;

  TBFSDPServiceRecords = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetRecords(const Index: Integer): TBFSDPServiceRecord;

  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Records[const Index: Integer]: TBFSDPServiceRecord read GetRecords; default;
  end;

  TBFSDPParser = class(TBFBaseClass)
  private
    FRecords: TBFSDPServiceRecords;

    procedure Parse(const Data: TBFByteArray);

  public
    constructor Create(const Data: TBFByteArray);
    destructor Destroy; override;

    property Records: TBFSDPServiceRecords read FRecords;
  end;

implementation

{ TBFSDPElement }

constructor TBFSDPElement.Create;
begin
  FData := nil;
  FDataType := 0;
  FSize := 0;
end;

destructor TBFSDPElement.Destroy;
begin
  FData := nil;
  
  inherited;
end;

function TBFSDPElement.GetAsByte: Byte;
begin
  Result := FData[0];
end;

function TBFSDPElement.GetAsDWord: DWORD;
begin
  Result := FData[0] * $01000000 + FData[1] * $010000 + FData[2] * $0100 + FData[3];
end;

function TBFSDPElement.GetAsWord: Word;
begin
  Result := FData[0] * $0100 + FData[1];
end;

{ TBFSDPAttributeElements }

constructor TBFSDPAttributeElements.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFSDPAttributeElements.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFSDPAttributeElements.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFSDPAttributeElements.GetElements(const Index: Integer): TBFSDPElement;
begin
  Result := TBFSDPElement(FList[Index]);
end;

{ TBFSDPAttribute }

constructor TBFSDPAttribute.Create;
begin
  FAttributeType := 0;
  FElements := TBFSDPAttributeElements.Create;
end;

destructor TBFSDPAttribute.Destroy;
begin
  FElements.Free;

  inherited;
end;

{ TBFSDPAttributes }

constructor TBFSDPAttributes.Create;
begin
   FList := TObjectList.Create;
end;

destructor TBFSDPAttributes.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFSDPAttributes.GetAttributes(const Index: Integer): TBFSDPAttribute;
begin
  Result := TBFSDPAttribute(FList[Index]);
end;

function TBFSDPAttributes.GetCount: Integer;
begin
  Result := FList.Count;
end;

{ TBFSDPServiceRecord }

constructor TBFSDPServiceRecord.Create;
begin
  FAttributes := TBFSDPAttributes.Create;
  FID := 0;
end;

destructor TBFSDPServiceRecord.Destroy;
begin
  FAttributes.Free;

  inherited;
end;

function TBFSDPServiceRecord.GetAttribute(const AttributeType: Word): TBFSDPAttribute;
var
  Loop: Integer;
begin
  Result := nil;

  for Loop := 0 to FAttributes.Count - 1 do
    if FAttributes[Loop].AttributeType = AttributeType then begin
      Result := FAttributes[Loop];
      Break;
    end;
end;

{ TBFSDPServiceRecords }

constructor TBFSDPServiceRecords.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFSDPServiceRecords.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFSDPServiceRecords.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFSDPServiceRecords.GetRecords(const Index: Integer): TBFSDPServiceRecord;
begin
  Result := TBFSDPServiceRecord(FList[Index]);
end;

{ TBFSDPParser }

constructor TBFSDPParser.Create(const Data: TBFByteArray);
begin
  FRecords := TBFSDPServiceRecords.Create;
  
  Parse(Data);
end;

destructor TBFSDPParser.Destroy;
begin
  FRecords.Free;

  inherited;
end;

procedure TBFSDPParser.Parse(const Data: TBFByteArray);
var
  ServiceRecord: TBFSDPServiceRecord;
  Size: Integer;
  Ndx: Integer;
  AByte: Byte;
  AttributeCode: Word;
  Attribute: TBFSDPAttribute;
  DataSizeByte: Byte;
  DataSize: DWORD;
  SizeIndex: Byte;
  TypeByte: Byte;
  Element: TBFSDPElement;
  ElementSizeIndex: Byte;
begin
  ServiceRecord := nil;
  Size := Length(Data);
  Ndx := 0;

  while (Ndx < Size) do begin
    AByte := Data[Ndx];

    if AByte = SDP_ATTRIBUTE_BYTE then begin
      Inc(Ndx);

      AttributeCode := Data[Ndx] * $0100 + Data[Ndx + 1];
      Inc(Ndx, 2);

      if AttributeCode = SDP_ATTRIB_RECORD_HANDLE then begin
        ServiceRecord := TBFSDPServiceRecord.Create;
        FRecords.FList.Add(ServiceRecord);
        ServiceRecord.FID := Data[Ndx + 1] * $01000000 + Data[Ndx + 2] * $010000 + Data[Ndx + 3] * $0100 + Data[Ndx + 4];

        Inc(Ndx, 5);

      end else begin
        Attribute := TBFSDPAttribute.Create;
        ServiceRecord.FAttributes.FList.Add(Attribute);
        Attribute.FAttributeType := AttributeCode;

        DataSizeByte := Data[Ndx];
        DataSize := 0;
        SizeIndex := DataSizeByte and SDP_SIZE_INDEX_MASK;

        case SizeIndex of
          SDP_SIZE_INDEX_1_BYTE: DataSize := 1;
          SDP_SIZE_INDEX_2_BYTES: DataSize := 2;
          SDP_SIZE_INDEX_4_BYTES: DataSize := 4;
          SDP_SIZE_INDEX_8_BYTES: DataSize := 8;
          SDP_SIZE_INDEX_16_BYTES: DataSize := 16;
          SDP_SIZE_INDEX_ADD_1_BYTE: DataSize := Data[Ndx + 1] + 1;
          SDP_SIZE_INDEX_ADD_2_BYTES: DataSize := Data[Ndx + 1] * $0100 + Data[Ndx + 2] + 2;
          SDP_SIZE_INDEX_ADD_4_BYTES: DataSize := Data[Ndx + 1] * $01000000 + Data[Ndx + 2] * $010000 + Data[Ndx + 3] * $0100 + Data[Ndx + 4] + 4;
        end;

        Inc(DataSize);

        while DataSize > 0 do begin
          TypeByte := Data[Ndx];
          Inc(Ndx);
          Dec(DataSize);

          if TypeByte = SDP_SEQUENCE_35_BYTE then begin
            Inc(Ndx);
            Dec(DataSize);

          end else
            if TypeByte = SDP_SEQUENCE_36_BYTE then begin
              Inc(Ndx, 2);
              Dec(DataSize, 2);

            end else begin
              Element := TBFSDPElement.Create;
              Attribute.FElements.FList.Add(Element);
              Element.FDataType := (TypeByte and SDP_TYPE_MASK) shr 3;
              ElementSizeIndex := TypeByte and SDP_SIZE_INDEX_MASK;

              case ElementSizeIndex of
                SDP_SIZE_INDEX_1_BYTE: Element.FSize := 1;
                SDP_SIZE_INDEX_2_BYTES: Element.FSize := 2;
                SDP_SIZE_INDEX_4_BYTES: Element.FSize := 4;
                SDP_SIZE_INDEX_8_BYTES: Element.FSize := 8;
                SDP_SIZE_INDEX_16_BYTES: Element.FSize := 16;
                SDP_SIZE_INDEX_ADD_1_BYTE: begin
                                             Element.FSize := Data[Ndx];
                                             Inc(Ndx);
                                             Dec(DataSize);
                                           end;
                SDP_SIZE_INDEX_ADD_2_BYTES: begin
                                              Element.FSize := Data[Ndx] * $0100 + Data[Ndx + 1];
                                              Inc(Ndx, 2);
                                              Dec(DataSize, 2);
                                            end;
                SDP_SIZE_INDEX_ADD_4_BYTES: begin
                                              Element.FSize := Data[Ndx] * $01000000 + Data[Ndx + 1] * $010000 + Data[Ndx + 2] * $0100 + Data[Ndx + 3];
                                              Inc(Ndx, 4);
                                              Dec(DataSize, 4);
                                            end;  
              end;

              if Element.FSize > 0 then Element.FData := Copy(Data, Ndx, Element.FSize);

              Inc(Ndx, Element.FSize);
              Dec(DataSize, Element.FSize);
            end;
        end;
      end;

    end else
      if AByte = SDP_SEQUENCE_35_BYTE then
        Inc(Ndx, 2)

      else
	Inc(Ndx, 3);
  end;
end;

end.
