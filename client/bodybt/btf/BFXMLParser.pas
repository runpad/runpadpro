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
unit BFXMLParser;

{$I BF.inc}

interface

uses
  Windows,  SysUtils, Classes;

type
  TBFXMLValueType = (xvtString, xvtCDATA);
  TBFXMLFilterOperator = (xfoNOP, xfoEQ, xfoIEQ, xfoNE, xfoINE, xfoGE, xfoIGE,
                          xfoLE, xfoILE, xfoGT, xfoIGT, xfoLT, xfoILT);

  TBFXMLTree = class;

  TBFXMLFilterAtom = class(TObject)
  private
    FAttributeFilter: Boolean;
    FValue: string;
    FName: string;
    FOperator: TBFXMLFilterOperator;

    procedure SetName(const Value: string);
    procedure SetOperator(const Value: TBFXMLFilterOperator);
    procedure SetValue(const Value: string);
    procedure SetAttributeFilter(const Value: Boolean);

  public
    property Name: string read FName write SetName;
    property Operator:TBFXMLFilterOperator read FOperator write SetOperator;
    property Value: string read FValue write SetValue;
    property AttributeFilter: Boolean read FAttributeFilter write SetAttributeFilter;
  end;

  TBFXMLFilter = class(TObject)
  private
    FName: string;
    FFilters: TList;

    procedure SetName(const Value: string);
    procedure SetFilters(const Value: TList);

  public
    constructor Create(FilterStr: string);
    destructor Destroy; override;

    property Name: string read FName write SetName;
    property Filters: TList read FFilters write SetFilters;
  end;

  TBFXMLAttribute=class(TObject)
  private
    FName: string;
    FValue: Variant;

    procedure SetName(const Value: string);
    procedure SetValue(const Value: Variant);

  public
    constructor Create(AName: string; AValue: Variant);

    function Document: string;

    property Name:string read FName write SetName;
    property Value: Variant read FValue write SetValue;
  end;

  TBFXMLNode = class(TObject)
  private
    FName: string;
    FValue: Variant;
    FNodes: TList;
    FAttributes: TList;
    FParentNode: TBFXMLNode;
    FValueType: TBFXMLValueType;

    procedure SetName(const Value: string);
    procedure SetValue(const Value: Variant);
    procedure SetNodes(const Value: TList);
    procedure SetAttributes(const Value: TList);
    procedure SetParentNode(const Value: TBFXMLNode);
    procedure SetValueType(const Value: TBFXMLValueType);

  public
    constructor Create(AName: string; AValue: Variant; AParent: TBFXMLNode);
    destructor  Destroy; override;

    function AddNode(AName: string; AValue: Variant): TBFXMLNode;
    function AddNodeEx(AName: string; AValue: Variant): TBFXMLNode;
    function AddAttribute(AName: string; AValue: Variant): TBFXMLAttribute;
    function Document(ALevel: Integer): string;
    function GetNodePath: string;
    function GetNamedNode(AName: string): TBFXMLNode;
    function SelectSingleNode(Pattern: string): TBFXMLNode;
    function TransformNode(Stylesheet: TBFXMLNode): string;
    function Process(ALevel: Integer; Node: TBFXMLNode): string;
    function FindNamedNode(AName: string): TBFXMLNode;
    function GetNamedAttribute(AName: string): TBFXMLAttribute;
    function MatchFilter(ObjFilter: TBFXMLFilter): Boolean;
    function GetNameSpace: string;
    function HasChildNodes: Boolean;
    function CloneNode: TBFXMLNode;
    function FirstChild: TBFXMLNode;
    function LastChild: TBFXMLNode;
    function PreviousSibling: TBFXMLNode;
    function NextSibling: TBFXMLNode;
    function MoveAddNode(Dest: TBFXMLNode): TBFXMLNode;
    function MoveInsertNode(Dest: TBFXMLNode): TBFXMLNode;
    function RemoveChildNode(aNode: TBFXMLNode): TBFXMLNode;

    procedure DeleteNode(Index: Integer);
    procedure ClearNodes;
    procedure DeleteAttribute(Index: Integer);
    procedure ClearAttributes;
    procedure SelectNodes(Pattern: string; AList: TList);
    procedure FindNamedNodes(AName: string; AList: TList);
    procedure GetAllNodes(AList: TList);
    procedure FindNamedAttributes(AName: string; AList: TList);
    procedure MatchPattern(APattern: string; AList: TList);
    procedure GetNodeNames(AList: TStringList);
    procedure GetAttributeNames(AList: TStringList);

    property Name: string read FName write SetName;
    property Value: Variant read FValue write SetValue;
    property ValueType: TBFXMLValueType read FValueType write SetValueType;
    property Nodes: TList read FNodes write SetNodes;
    property ParentNode: TBFXMLNode read FParentNode write SetParentNode;
    property Attributes: TList read FAttributes write SetAttributes;
  end;

  TBFXMLTree = class(TBFXMLNode)
  private
    FLines: TStringlist;
    FNodeCount: Integer;

    function GetText: string;

    procedure SetLines(const Value: TStringlist);
    procedure SetText(const Value: string);

  public
    constructor Create(AName: string; AValue: Variant; AParent: TBFXMLNode);
    destructor Destroy; override;

    function  AsText: string;

    procedure ParseXML;
    procedure LoadFromFile(FIleName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(Stream: TStream);

    property Lines: TStringlist read FLines write SetLines;
    property NodeCount: Integer read FNodeCount;
    property Text: string read GetText write SetText;
  end;

  procedure PreProcessXML(AList: TStringlist);

implementation

const
  CR = Chr(13) + Chr(10);
  TAB = Chr(9);

function Q_PosStr(const FindString: string; SourceString: string; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX, EAX
        JE      @@qt
        TEST    EDX, EDX
        JE      @@qt0
        MOV     ESI, EAX
        MOV     EDI, EDX
        MOV     EAX, [EAX - 4]
        MOV     EDX, [EDX - 4]
        DEC     EAX
        SUB     EDX, EAX
        DEC     ECX
        SUB     EDX, ECX
        JNG     @@qt0
        MOV     EBX, EAX
        XCHG    EAX, EDX
        NOP
        ADD     EDI, ECX
        MOV     ECX, EAX
        MOV     AL, BYTE PTR [ESI]
@@lp1:  CMP     AL, BYTE PTR [EDI]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JNZ     @@lp1
@@qt0:  XOR     EAX, EAX
        JMP     @@qt
@@ms:   MOV     AL, BYTE PTR [ESI]
        MOV     EBX, EDX
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL, BYTE PTR [ESI + EBX]
        XOR     AL, BYTE PTR [EDI + EBX]
        JNE     @@ms
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX, [EDI + 1]
        SUB     EAX, [ESP]
@@qt:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;

procedure PreProcessXML(AList: TStringlist);
const
  CRLF = Chr(13) + Chr(10);
  TAB = Chr(9);

var
  OList: TStringlist;
  S: string;
  XTag: string;
  XText: string;
  XData: string;
  P1: Integer;
  P2: Integer;
  C: Integer;
  ALevel: Integer;

  function Clean(AText: string): string;
  begin
    Result := StringReplace(AText, CRLF, ' ', [rfReplaceAll]);
    Result := StringReplace(Result, TAB, ' ', [rfReplaceAll]);
    Result := Trim(Result);
  end;

  function CleanCDATA(AText: string): string;
  begin
    Result := StringReplace(AText, CRLF, '\n ', [rfReplaceAll]);
    Result := StringReplace(Result, TAB, '\t ', [rfReplaceAll]);
  end;

  function Spc: string;
  begin
    if ALevel < 1 then
      Result := ''
    else
      Result := StringOfChar(' ', 2 * ALevel);
  end;
  
begin
  OList := TStringlist.Create;
  S := AList.Text;
  XText := '';
  XTag := '';
  P1 := 1;
  C := Length(S);
  ALevel := 0;

  repeat
    P2 := Q_PosStr('<', S, P1);

    if P2 > 0 then begin
      XText := Trim(Copy(S, P1, P2 - P1));

      if XText <> '' then OList.Append('TX:' + Clean(XText));

      P1 := P2;
      if AnsiUpperCase(Copy(S, P1, 9)) = '<![CDATA[' then begin
        P2 := Q_PosStr(']]>', S, P1);
        XData := Copy(S, P1 + 9, P2 - P1 - 9);
        OList.Append('CD:' + CleanCDATA(XData));
        P1 := P2 + 2;

      end else begin
        P2 := Q_PosStr('>', S, P1);
        if P2 > 0 then begin
          XTag := Copy(S, P1 + 1, P2 - P1 - 1);
          P1 := P2;
          if XTag[1] = '/' then begin
            Delete(XTag, 1, 1);
            OList.Append('CT:' + Clean(XTag));
            Dec(ALevel);

          end else
            if XTag[Length(XTag)]= '/' then
              OList.Append('ET:' + Clean(XTag))

            else begin
              Inc(ALevel);
              OList.Append('OT:' + Clean(XTag));
            end;
        end;
      end;

    end else begin
      XText := Trim(Copy(S, P1, Length(S)));
      if XText <> '' then OList.Append('TX:' + Clean(XText));
      P1 := C;
    end;
    Inc(P1);

  until P1 > C;

  AList.Assign(OList);
  OList.Free;
end;

{ TBFXMLNode }

function TBFXMLNode.AddAttribute(AName: string; AValue: Variant): TBFXMLAttribute;
var
  N: TBFXMLAttribute;
begin
  N := TBFXMLAttribute.Create(AName, AValue);
  Attributes.Add(N);
  Result := N;
end;

function TBFXMLNode.AddNode(AName: string; AValue: Variant): TBFXMLNode;
var
  N: TBFXMLNode;
begin
  N := TBFXMLNode.Create(AName, AValue, Self);
  Nodes.Add(N);
  Result := N
end;

function TBFXMLNode.AddNodeEx(AName: string; AValue: Variant): TBFXMLNode;
var
  N: TBFXMLNode;
  S: string;
  SN: string;
  SV: string;
  C: Integer;
  P1: Integer;
  P2: Integer;
begin
  N := TBFXMLNode.Create(AName, AValue, Self);
  Nodes.Add(N);
  Result := N;
  C := Length(AName);

  P1 := Q_PosStr(' ', AName, 1);
  if P1 = 0 then Exit;

  S := Copy(AName, 1, P1 - 1);
  N.Name := s;

  repeat
    P2 := Q_PosStr('=', AName, P1);
    if P2 = 0 then Exit;

    SN := Trim(Copy(AName, P1, P2 - P1));
    P1 := P2;

    P1 := Q_PosStr('"', AName, P1);
    if P1 = 0 then Exit;

    P2 := Q_PosStr('"', AName, P1 + 1);
    if P2 = 0 then Exit;

    SV := Copy(AName, P1 + 1, P2 - P1 - 1);
    N.AddAttribute(SN, SV);
    P1 := P2 + 1;
  until P1 > C;
end;

function TBFXMLNode.GetNamedAttribute(AName: string): TBFXMLAttribute;
var
  I: Integer;
  N: TBFXMLAttribute;
begin
  Result := nil;
  if Attributes.Count = 0 then Exit;

  for I := 0 to Attributes.Count - 1 do begin
    N := TBFXMLAttribute(Attributes[I]);
    if N.Name = AName then begin
      Result := N;
      Exit;
    end;
  end;
end;

procedure TBFXMLNode.ClearAttributes;
var
  I: Integer;
begin
  if Attributes.Count <> 0 then begin
    for i:=0 to Attributes.Count - 1 do TBFXMLAttribute(Attributes[I]).Free;

    Attributes.Clear;
  end;
end;

procedure TBFXMLNode.ClearNodes;
var
  I: Integer;
begin
  I := Nodes.Count;

  if I <> 0 then begin
    for I := 0 to Nodes.Count - 1 do TBFXMLNode(Nodes[I]).Free;

    Nodes.Clear;
  end;
end;

constructor TBFXMLNode.Create(AName: string; AValue: Variant; AParent: TBFXMLNode);
begin
  FNodes := TList.Create;
  FName := AName;
  FValue := AValue;
  FValueType := xvtString;
  FParentNode := AParent;
  FAttributes := TList.Create;
end;

procedure TBFXMLNode.DeleteAttribute(Index: Integer);
begin
  TBFXMLAttribute(Attributes[Index]).Free;
end;

procedure TBFXMLNode.DeleteNode(Index: Integer);
begin
  TBFXMLNode(Nodes[Index]).Free;
end;

destructor TBFXMLNode.Destroy;
begin
  ClearNodes;
  FNodes.Free;
  ClearAttributes;
  FAttributes.Free;
  
  inherited;
end;

function TBFXMLNode.Document(ALevel: Integer): string;
var
  I: Integer;
  Spc: string;

  function ExpandCDATA(AValue: string): string;
  begin
    Result := StringReplace(AValue, '\n ', CR, [rfReplaceAll]);
    result := StringReplace(Result, '\t ', TAB, [rfReplaceAll]);
  end;

begin
  if ALevel > 0 then
    Spc := StringOfChar(' ', ALevel * 2)
  else
    Spc:='';

  Result := Spc + '<' + Name;
  if Attributes.Count > 0 then
    for I := 0 to Attributes.Count - 1 do
      Result := Result + TBFXMLAttribute(Attributes[I]).Document;

  if (Nodes.Count = 0) and (Value = '') then begin
    Result := Result + ' />' + CR;
    Exit;

  end else
    Result := Result + '>' + CR;

  if Value <> '' then 
    if ValueType=xvtString then
      Result := Result + Spc + '  ' + Value + CR
    else
      if ValueType = xvtCDATA then
        Result := Result + Spc + '  ' + '<![CDATA[' + ExpandCDATA(Value) + ']]>' + CR;

  if Nodes.Count <> 0 then
    for I := 0 to Nodes.Count - 1 do
      Result := Result + TBFXMLNode(Nodes[I]).Document(ALevel + 1);

  Result := Result + Spc + '</' + Name + '>' + CR;
end;

function TBFXMLNode.CloneNode: TBFXMLNode;
var
  I: Integer;
  N: TBFXMLNode;
begin
  Result := TBFXMLNode.Create(Name, Value, nil);
  Result.Name := Name;
  Result.Value := Value;

  if Attributes.Count > 0 then 
    for I := 0 to Attributes.Count - 1 do
      Result.AddAttribute(TBFXMLAttribute(Attributes[I]).Name, TBFXMLAttribute(Attributes[I]).Value);

  if Nodes.Count > 0 then
    for I := 0 to Nodes.Count - 1 do begin
      N := TBFXMLNode(Nodes[I]).CloneNode;
      Result.Nodes.Add(N);
    end;
end;

function TBFXMLNode.GetNamedNode(AName: string): TBFXMLNode;
var
  I: Integer;
  N: TBFXMLNode;
begin
  Result := nil;
  if Nodes.Count = 0 then Exit;

  for I := 0 to Nodes.Count - 1 do begin
    N := TBFXMLNode(Nodes[I]);

    if N.Name = AName then begin
      Result := N;
      Exit;
    end;
  end;
end;

procedure TBFXMLNode.SetAttributes(const Value: TList);
begin
  FAttributes := Value;
end;

procedure TBFXMLNode.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TBFXMLNode.SetNodes(const Value: TList);
begin
  FNodes := Value;
end;

procedure TBFXMLNode.SetParentNode(const Value: TBFXMLNode);
begin
  FParentNode := Value;
end;

procedure TBFXMLNode.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

function TBFXMLNode.FirstChild: TBFXMLNode;
begin
 if Nodes.Count > 0 then
   Result := TBFXMLNode(Nodes[0])
 else
   Result := nil;
end;

function TBFXMLNode.LastChild: TBFXMLNode;
begin
  if Nodes.Count > 0 then
    Result := TBFXMLNode(Nodes[Nodes.Count - 1])
  else
    Result := nil;
end;

function TBFXMLNode.NextSibling: TBFXMLNode;
var
  Index: Integer;
begin
  Result := nil;
  if ParentNode = nil then Exit;

  Index := ParentNode.Nodes.IndexOf(Self);

  if Index = -1 then Exit;

  if Index < ParentNode.Nodes.Count - 1 then Result := TBFXMLNode(ParentNode.Nodes[Index + 1]);
end;

function TBFXMLNode.PreviousSibling: TBFXMLNode;
var
  Index: Integer;
begin
  Result := nil;
  if ParentNode = nil then Exit;

  Index := ParentNode.Nodes.IndexOf(Self);

  if Index = -1 then Exit;

  if Index > 0 then Result := TBFXMLNode(ParentNode.Nodes[Index - 1]);
end;

function TBFXMLNode.MoveInsertNode(Dest: TBFXMLNode): TBFXMLNode;
var
  Index1: Integer;
  Index2: Integer;
begin
  Result := nil;
  if not Assigned(Dest.ParentNode) then Exit;

  Index1 := ParentNode.Nodes.IndexOf(Self);
  if Index1 = -1 then Exit;

  Index2 := Dest.ParentNode.Nodes.IndexOf(Dest);
  if Index2 = -1 then Exit;

  Dest.ParentNode.Nodes.Insert(Index2, Self);
  ParentNode.Nodes.Delete(Index1);
  ParentNode := Dest.ParentNode;

  Result := self;
end;

function TBFXMLNode.MoveAddNode(Dest: TBFXMLNode): TBFXMLNode;
var
  Index: Integer;
begin
  Result := nil;
  if not Assigned(Dest) then Exit;

  Index := ParentNode.Nodes.IndexOf(Self);
  if Index = -1 then Exit;

  Dest.Nodes.Add(Self);
  ParentNode.Nodes.Delete(Index);
  ParentNode := Dest;
  
  Result := Self;
end;

function TBFXMLNode.RemoveChildNode(ANode: TBFXMLNode): TBFXMLNode;
var
  Index: Integer;
begin
  Result := nil;
  Index := Nodes.IndexOf(ANode);
  if Index = -1 then Exit;

  Nodes.Delete(Index);
  ANode.Free;

  Result := Self;
end;

function TBFXMLNode.HasChildNodes: Boolean;
begin
  Result := Nodes.Count > 0;
end;

procedure TBFXMLNode.GetAttributeNames(AList: TStringList);
var
  I: Integer;
  C: Integer;
begin
  AList.Clear;
  C := Attributes.Count;
  if C = 0 then Exit;

  for I := 0 to C - 1 do AList.Append(TBFXMLAttribute(Attributes[I]).Name);
end;

procedure TBFXMLNode.GetNodeNames(AList: TStringList);
var
  I: Integer;
  C: Integer;
begin
  AList.Clear;
  C := Nodes.Count;
  if C = 0 then Exit;

  for I := 0 to C - 1 do AList.Append(TBFXMLNode(Nodes[I]).Name);
end;

function TBFXMLNode.GetNodePath: string;
var
  N: TBFXMLNode;
begin
  N := Self;
  Result := Name;

  while Assigned(N.ParentNode) do begin
    N := N.ParentNode;
    Result := N.Name + '/' + Result;
  end;
end;

function TBFXMLNode.FindNamedNode(AName: string): TBFXMLNode;
var
  I: Integer;
  N: TBFXMLNode;
begin
  Result := nil;
  if Nodes.Count = 0 then Exit;

  for I := 0 to Nodes.Count - 1 do begin
    N := TBFXMLNode(Nodes[I]);

    if N.Name = AName then begin
      Result := N;
      Exit;

    end else begin
      Result := N.FindNamedNode(AName);
      if Assigned(Result) then Exit;
    end;
  end;
end;

procedure TBFXMLNode.FindNamedNodes(AName: string; AList: TList);
var
  I: Integer;
  N: TBFXMLNode;
begin
  if Nodes.Count = 0 then Exit;
  for I := 0 to Nodes.Count - 1 do begin
    N := TBFXMLNode(Nodes[I]);
    if N.Name = AName then AList.Add(N);

    N.FindNamedNodes(AName, AList);
  end;
end;

procedure TBFXMLNode.GetAllNodes(AList: TList);
var
  I: Integer;
  N: TBFXMLNode;
begin
  if Nodes.Count = 0 then Exit;

  for I := 0 to Nodes.Count - 1 do begin
    N := TBFXMLNode(Nodes[I]);
    AList.Add(N);
    N.GetAllNodes(AList);
  end;
end;

procedure TBFXMLNode.FindNamedAttributes(AName: string; AList: TList);
var
  I: Integer;
  C: Integer;
  N: TBFXMLNode;
begin
  C := Attributes.Count;

  if C > 0 then
    for I := 0 to C - 1 do 
      if TBFXMLAttribute(Attributes[I]).Name = AName then begin
        AList.Add(Self);
        Break;
      end;

  if Nodes.Count = 0 then Exit;

  for I := 0 to Nodes.Count - 1 do begin
    N := TBFXMLNode(Nodes[I]);
    N.findNamedAttributes(AName, AList);
  end;
end;

procedure TBFXMLNode.MatchPattern(APattern: string; AList: TList);
begin
end;

procedure TBFXMLNode.SetValueType(const Value: TBFXMLValueType);
begin
  FValueType := Value;
end;

function TBFXMLNode.SelectSingleNode(Pattern: string): TBFXMLNode;
var
  NPattern: string;
  AFilter: string;
  P: Integer;
  I: Integer;
  C: Integer;
  N: TBFXMLNode;
  ObjFilter: TBFXMLFilter;
begin
  Result := nil;
  C := Nodes.Count;
  if C = 0 then Exit;

  P := Pos('/', Pattern);
  if P = 0 then begin
    ObjFilter := TBFXMLFilter.Create(Pattern);

    for I := 0 to C - 1 do begin
      N := TBFXMLNode(Nodes[I]);
      if N.MatchFilter(ObjFilter) then begin
        Result := N;
        ObjFilter.Free;
        Exit;
      end;
    end;

    ObjFilter.Free;
    Exit;

  end else begin
    AFilter := Copy(Pattern, 1, P - 1);
    NPattern := Copy(Pattern, P + 1, Length(Pattern));
    ObjFilter := TBFXMLFilter.Create(AFilter);

    for I := 0 to C - 1 do begin
      N := TBFXMLNode(Nodes[I]);
      if N.MatchFilter(ObjFilter) then begin
        Result := N.SelectSingleNode(NPattern);
        if Assigned(Result) then begin
          ObjFilter.Free;
          Exit;
        end;
      end;
    end;

    ObjFilter.Free;
  end;
end;

function TBFXMLNode.MatchFilter(ObjFilter: TBFXMLFilter): Boolean;
var
  I: Integer;
  J: Integer;
  AttName: string;
  A: TBFXMLAttribute;
  N: TBFXMLNode;
  Atom: TBFXMLFilterAtom;
  AttResult: Boolean;

  function EValAtom(AValue: string): Boolean;
  begin
    Result := False;
    case Atom.Operator of
      xfoNOP: Result := True;

      xfoEQ: Result := AValue = Atom.Value;

      xfoIEQ: Result := CompareText(AValue, Atom.Value) = 0;

      xfoNE: Result := AValue <> Atom.Value;

      xfoINE: Result := CompareText(AValue, Atom.Value) <> 0;

      xfoGT: try
               Result := StrToFloat(AValue) > StrToFloat(Atom.Value);
             except
             end;

      xfoIGT: Result := CompareText(AValue, Atom.Value) > 0;

      xfoLT: try
               Result := StrToFloat(AValue) < StrToFloat(Atom.Value);
             except
             end;

      xfoILT: Result := CompareText(AValue, Atom.Value) < 0;

      xfoGE: try
               Result := StrToFloat(AValue) >= StrToFloat(Atom.Value);
             except
             end;

      xfoIGE: Result := CompareText(AValue, Atom.Value) >= 0;

      xfoLE: try
               Result := StrToFloat(AValue) <= StrToFloat(Atom.Value);
             except
             end;

      xfoILE: Result := CompareText(AValue, Atom.Value) <= 0;
    end;
  end;

begin
  Result := False;
  if ObjFilter.Filters.Count = 0 then begin
    Result := ObjFilter.Name = Name;
    Exit;
  end;

  AttResult := False;
  for I := 0 to ObjFilter.Filters.Count - 1 do begin
    Atom := TBFXMLFilterAtom(ObjFilter.Filters[I]);
    if Atom.AttributeFilter then begin
      AttName := Atom.Name;
      if AttName = '*' then begin
        if Attributes.Count = 0 then Exit;

        for J := 0 to Attributes.Count - 1 do begin
          A := TBFXMLAttribute(Attributes[J]);
          AttResult := EValAtom(A.Value);
          if AttResult then Break;
        end;

        if not AttResult then Exit;

      end else begin
        A := GetNamedAttribute(AttName);
        if not Assigned(a) then Exit;
        if not EValAtom(A.Value) then Exit;
      end;

    end else begin
      AttName := Atom.Name;
      N := GetNamedNode(AttName);
      if not Assigned(N) then Exit;

      if not EValAtom(N.Value) then Exit;
    end;
  end;

  Result := True;
end;

procedure TBFXMLNode.SelectNodes(Pattern: string; AList: TList);
var
  NPattern: string;
  p: Integer;
  i: Integer;
  c: Integer;
  N: TBFXMLNode;
  AFilter: string;
  ObjFilter: TBFXMLFilter;
  Recurse: Boolean;
begin
  C := Nodes.Count;
  if C = 0 then Exit;

  if Copy(Pattern, 1, 2) = '//' then begin
    Delete(Pattern, 1, 2);
    Recurse := True;

  end else
    Recurse := False;

  P := Pos('/', Pattern);

  if P = 0 then begin
    AFilter := Pattern;
    ObjFilter := TBFXMLFilter.Create(AFilter);
    for I := 0 to C - 1 do begin
      N := TBFXMLNode(Nodes[I]);
      if N.MatchFilter(ObjFilter) then
        AList.Add(N)

      else
        if Recurse then
          N.SelectNodes('//' + Pattern, AList);
    end;
    ObjFilter.Free;

  end else begin
    AFilter := Copy(Pattern, 1, P - 1);
    if Copy(Pattern, P, 2) = '//' then
      NPattern := Copy(Pattern, P, Length(Pattern))

    else
      NPattern := Copy(Pattern, P + 1, Length(Pattern));

    ObjFilter := TBFXMLFilter.Create(AFilter);

    for I := 0 to c - 1 do begin
      N := TBFXMLNode(Nodes[I]);
      if N.MatchFilter(ObjFilter) then
        N.SelectNodes(NPattern, AList)

      else
        if Recurse then
          N.SelectNodes('//' + Pattern, AList);
    end;

    ObjFilter.free;
  end;
end;

function TBFXMLNode.TransformNode(Stylesheet: TBFXMLNode): string;
begin
  Result := Stylesheet.Process(0, Self);
end;

function TBFXMLNode.Process(ALevel: Integer; Node: TBFXMLNode): string;
var
  I: Integer;
  Spc: string;

  function ExpandCDATA(AValue: string): string;
  begin
    Result := StringReplace(AValue, '\n ', CR, [rfReplaceAll]);
    Result := StringReplace(Result, '\t ', TAB, [rfReplaceAll]);
  end;

begin
  if not Assigned(ParentNode) then begin
    if Nodes.Count <> 0 then
      for I := 0 to Nodes.Count - 1 do
        Result := Result + TBFXMLNode(Nodes[I]).Process(ALevel + 1, Node);

    Exit;
  end;

  if ALevel > 0 then
    Spc := StringOfChar(' ', ALevel * 2)
  else
    Spc := '';

  Result := Spc + '<' + Name;

  if Attributes.Count > 0 then
    for I := 0 to Attributes.Count - 1 do
      Result := Result + TBFXMLAttribute(Attributes[I]).Document;

  if (Nodes.Count = 0) and (Value = '') then begin
    Result := Result + ' />' + CR;
    Exit;

  end else
    Result := Result + '>' + CR;

  if Value <> '' then 
    if ValueType = xvtString then
      Result := Result + Spc + '  ' + Value + CR

    else
      if ValueType = xvtCDATA then
        Result := Result + Spc + '  ' + '<![CDATA[' + ExpandCDATA(Value) + ']]>' + CR;

  if Nodes.Count <> 0 then
    for I := 0 to Nodes.Count - 1 do
      Result := Result + TBFXMLNode(Nodes[I]).Process(ALevel + 1, Node);

  Result := Result + Spc + '</' + Name + '>' + CR;
end;

function TBFXMLNode.GetNameSpace: string;
var
  P: Integer;
begin
  P := Pos(':', FName);
  if P > 0 then
    Result := Copy(FName, 1, P - 1)
  else
    Result := '';
end;

{ TBFXMLTree }

constructor TBFXMLTree.Create(AName: string; AValue: Variant; AParent: TBFXMLNode);
begin
  inherited Create(AName, AValue, AParent);

  FLines := TStringList.Create;
end;

destructor TBFXMLTree.Destroy;
begin
  FLines.Free;

  inherited destroy;
end;

function TBFXMLTree.AsText: string;
var
  I: Integer;
  C: Integer;
begin
  C := Nodes.Count;
  if C = 0 then Exit;

  Result := '<' + Name;
  if Attributes.Count > 0 then
    for I := 0 to Attributes.Count - 1 do
      Result := Result + TBFXMLAttribute(Attributes[I]).Document;

  Result := Result + '>' + CR;
  for I := 0 to C - 1 do
    Result := Result + TBFXMLNode(Nodes[I]).Document(1);

  Result := Result + '</' + Name + '>' + CR;
end;

procedure TBFXMLTree.SaveToFile(FileName: string);
begin
  Lines.Text := Text;
  Lines.SaveToFile(FileName)
end;

procedure TBFXMLTree.SetLines(const Value: TStringlist);
begin
  FLines.Assign(Value);
end;

procedure TBFXMLTree.LoadFromStream(Stream: TStream);
begin
  ClearNodes;
  ClearAttributes;
  Lines.LoadFromStream(Stream);
  PreProcessXML(FLines);
  ParseXML;
end;

procedure TBFXMLTree.SaveToStream(Stream: TStream);
begin
  Lines.Text := AsText;
  Lines.SaveToStream(Stream);
end;

function TBFXMLTree.GetText: string;
var
  I: Integer;
  C: Integer;
begin
  C := Nodes.Count;
  if C = 0 then Exit;

  Result := '';
  for I := 0 to C - 1 do Result := Result + TBFXMLNode(Nodes[I]).Document(0);
end;

procedure TBFXMLTree.SetText(const Value: string);
begin
  ClearNodes;
  ClearAttributes;
  Lines.Text := Value;
  PreProcessXML(FLines);
  ParseXML;
end;

{ TBFXMLAttribute }

constructor TBFXMLAttribute.Create(AName: string; AValue: Variant);
begin
  FName := AName;
  FValue := AValue;
end;

function TBFXMLAttribute.Document: string;
var
  S: string;
begin
  S := Value;
  Result := ' ' + Name + '="' + S + '"';
end;

procedure TBFXMLAttribute.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TBFXMLAttribute.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

{ TBFXMLTree }

procedure TBFXMLTree.ParseXML;
var
  I: Integer;
  C: Integer;
  S: string;
  Token: string;
  AName: string;
  N: TBFXMLNode;
begin
  I := 0;
  FNodeCount := 0;
  ClearNodes;
  ClearAttributes;
  Name := 'root';
  N := Self;
  C := Lines.Count - 1;

  repeat
    S := Lines[I];
    Token := Copy(S, 1, 3);
    AName := Copy(S, 4, Length(S));
    if Token = 'OT:' then begin
      N := N.AddNodeEx(AName, '');
      Inc(FNodeCount);

    end else
      if Token = 'CT:' then
        N := N.ParentNode

      else
        if Token = 'ET:' then
          N.AddNodeEx(AName, '')

        else
          if Token = 'TX:' then begin
            N.Value := AName;
            N.ValueType := xvtString;

          end else
            if Token = 'CD:' then begin
              N.Value := AName;
              N.ValueType := xvtCDATA;
            end;
    Inc(I);
  until I > C;
end;

procedure TBFXMLTree.LoadFromFile(FileName: string);
begin
  ClearNodes;
  ClearAttributes;
  Lines.LoadFromFile(FileName);
  PreProcessXML(FLines);
  ParseXML;
end;

{ TBFXMLFilter }

constructor TBFXMLFilter.Create(FilterStr: string);
var
  TheFilter: string;
  P1: Integer;
  P2: Integer;
  AttName: string;
  AttValue: string;
  AttOperator: TBFXMLFilterOperator;
  Atom: TBFXMLFilterAtom;

  function TrimQuotes(S: string): string;
  var
    CC: Integer;
  begin
    Result := Trim(S);
    if S = '' then Exit;
    if (S[1] = '"') or (S[1] = '''') then Delete(Result, 1, 1);

    if S = '' then Exit;

    CC := Length(Result);
    if (Result[CC] = '"') or (Result[CC] = '''') then Delete(Result, CC, 1);
  end;

  function SplitNameValue(S: string): Boolean;
  var
    PP: Integer;
  begin
    PP := Q_PosStr(' $ne$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoNE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S,  PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ine$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoINE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ge$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoGE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ige$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoIGE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $gt$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoGT;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $igt$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoIGT;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $le$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoLE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := Trimquotes(Copy(S, PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ile$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoILE;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $lt$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoLT;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ilt$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoILT;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $eq$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoEQ;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 6, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    PP := Q_PosStr(' $ieq$ ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoIEQ;
      AttName := Trim(Copy(S, 1, PP - 1));
      Attvalue := TrimQuotes(Copy(S, PP + 7, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;
    
    PP := Q_PosStr(' = ', S, 1);
    if PP > 0 then begin
      AttOperator := xfoEQ;
      AttName := Trim(Copy(S, 1, PP - 1));
      AttValue := TrimQuotes(Copy(S, PP + 3, Length(S)));
      Result := (AttName <> '') and (AttValue <> '');
      Exit;
    end;

    AttOperator := xfoNOP;
    AttName := S;
    AttValue := '';
    Result := True;
    Exit;
  end;

begin
  Filters := TList.Create;
  P1 := Q_PosStr('[', FilterStr, 1);
  if P1 = 0 then begin
    Name := FilterStr;
    Exit;

  end else begin
    Name := Copy(FilterStr, 1, P1 - 1);
    Delete(FilterStr, 1, P1 - 1);
  end;

  repeat
    FilterStr := Trim(FilterStr);

    P1 := Q_PosStr('[', FilterStr, 1);
    if P1 = 0 then Exit;

    P2 := Q_PosStr(']', FilterStr, P1 + 1);
    if P2 = 0 then Exit;

    TheFilter := Copy(FilterStr, P1 + 1, P2 - P1 - 1);
    Delete(FilterStr, 1, P2);
    if TheFilter = '' then Exit;

    if TheFilter[1] = '@' then begin
      if not SplitNameValue(Copy(TheFilter, 2, Length(TheFilter))) then Exit;

      Atom := TBFXMLFilterAtom.Create;
      Atom.Name := AttName;
      Atom.Operator := AttOperator;
      Atom.Value := AttValue;
      Atom.AttributeFilter := True;
      Filters.Add(Atom);

    end else begin
        if not SplitNameValue(TheFilter) then Exit;
        Atom := TBFXMLFilterAtom.Create;
        Atom.Name := AttName;
        Atom.Operator := AttOperator;
        Atom.Value := AttValue;
        Atom.AttributeFilter := False;
        Filters.Add(Atom);
    end;
  until FilterStr = '';
end;

destructor TBFXMLFilter.Destroy;
var
  I: Integer;
begin
  if Filters.Count > 0 then
    for I := 0 to Filters.Count - 1 do
      TBFXMLFilterAtom(Filters[I]).Free;

  Filters.Free;
  
  inherited Destroy;
end;

procedure TBFXMLFilter.SetFilters(const Value: TList);
begin
  FFilters := Value;
end;

procedure TBFXMLFilter.SetName(const Value: string);
begin
  FName := Value;
end;

{ TBFXMLFilterAtom }

procedure TBFXMLFilterAtom.SetAttributeFilter(const Value: Boolean);
begin
  FAttributeFilter := Value;
end;

procedure TBFXMLFilterAtom.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TBFXMLFilterAtom.SetOperator(const Value: TBFXMLFilterOperator);
begin
  FOperator := Value;
end;

procedure TBFXMLFilterAtom.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
