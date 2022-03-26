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
unit BFFileTransferClient;

{$I BF.inc}

interface

uses
  Windows, Contnrs, BFOBEXClient, Classes, BFAPI, BFDiscovery, BFBase,
  BFClients;

type
  // Files access types.
  TBFFileAccess = (faRead, faWrite, faDelete);
  TBFFileAccesses = set of TBFFileAccess;

  // Representation of file object.
  TBFFile = class(TBFBaseClass)
  private
    FAccess: TBFFileAccesses;
    FFolder: Boolean;
    FModified: TDateTime;
    FName: string;
    FSize: DWORD;

    procedure ClearFields;

  public
    // Default constructor.
    constructor Create;

    // Assigns one instance of TBFFile to another.
    procedure Assign(AFile: TBFFile);

    // File access flags.
    property Access: TBFFileAccesses read FAccess;
    // True if it is a folder. False if it is a file.
    property Folder: Boolean read FFolder;
    // Date and time when file was modified.
    property Modified: TDateTime read FModified;
    // Object name.
    property Name: string read FName;
    // Object size (for folder 0).
    property Size: DWORD read FSize;
  end;

  // Files list.
  TBFFiles = class(TBFBaseClass)
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetFiles(const Index: Integer): TBFFile;

  public
    // Default constructor.
    constructor Create;
    // Default destructor.
    destructor Destroy; override;

    // Assigns one instance of the TBFFiles to another.
    procedure Assign(AFiles: TBFFiles);

    // Returns objects in the list.
    property Count: Integer read GetCount;
    // Returns object by its index.
    property Files[const Index: Integer]: TBFFile read GetFiles; default;
  end;

  // OBEX File Transfer Profile client. Allows you to manipulate
  // files on remote device.
  TBFFileTransferClient = class(TBFOBEXClient)
  private
    FAutoDetect: Boolean;
    FCEPath: string;
    FConnectionID: DWORD;
    FUseActiveSync: Boolean;

    procedure CloseActiveSync;
    procedure OpenActiveSync;
    procedure SetAutoDetect(const Value: Boolean);
    procedure SetUseActiveSync(const Value: Boolean);

  protected
    procedure InternalClose; override;
    procedure InternalOpen; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

    // Returns list of the files and folders in the current directory.
    // Application shuld dispose returned object.
    function Dir: TBFFiles;

    // Delete specified file or folder.
    procedure Delete(FileName: string);
    // Loads specified file into AObject array.
    procedure Get(FileName: string; var AObject: TBFByteArray);
    // Loads specified file from remote device and save it into local file with
    // the same name into directory provided in Dir param. ActiveX version
    // supports only this method.
    procedure LoadTo(FileName: string; Dir: string);
    // Save specified file into remote device in the current directory.
    procedure Put(Stream: TStream; FileName: string); overload;
    procedure Put(FileName: string); overload;
    // Changes current directory. If Dir = '' then go to the root directpory.
    // If Dir = '..' then move one level up. If Create = True then creates
    // new directory with specified name in the current directory.
    procedure SetPath(Dir: string; Create: Boolean);

  published
    // Set to true if you need auto detect used service
    property AutoDetect: Boolean read FAutoDetect write SetAutoDetect default True;
    // Set to true if want use ActiveSync connection
    property UseActiveSync: Boolean read FUseActiveSync write SetUseActiveSync default False; 
  end;

  _TBFFileTransferClientX = class(_TBFOBEXClientX)
  private
    function GetAutoDetect: Boolean;
    function GetUseActiveSync: Boolean;

    procedure SetAutoDetect(const Value: Boolean);
    procedure SetUseActiveSync(const Value: Boolean);

  protected
    function GetComponentClass: TBFCustomClientClass; override;

  public
    function Dir: TBFFiles;

    procedure Delete(FileName: string);
    procedure Get(FileName: string; var AObject: TBFByteArray);
    procedure LoadTo(FileName: string; Dir: string);
    procedure Put(Stream: TStream; FileName: string); overload;
    procedure Put(FileName: string); overload;
    procedure SetPath(Dir: string; Create: Boolean);

  published
    property AutoDetect: Boolean read GetAutoDetect write SetAutoDetect;
    property UseActiveSync: Boolean read GetUseActiveSync write SetUseActiveSync;
  end;

// Sends specified file to specified device. Returns True if file sended.
function FTPSendFile(ADevice: TBFBluetoothDevice; AFileName: string; AAuthentication: Boolean = True): Boolean; overload;
function FTPSendFile(ADevice: TBFIrDADevice; AFileName: string; AAuthentication: Boolean = True): Boolean; overload;
function FTPSendFile(AAddress: string; AFileName: string; ABluetooth: Boolean; AAuthentication: Boolean = True): Boolean; overload;
function FTPSendFile(AFileName: string): Boolean; overload;

implementation

uses
  SysUtils, BFXMLParser, {$IFDEF DELPHI6}Variants, DateUtils,{$ENDIF} Dialogs,
  BFStrings, Controls, BFD5Support{$IFDEF DELPHI5}, FileCtrl{$ENDIF};

var
  gActiveSyncUsed: Boolean = False;

function FTPSendFile(ADevice: TBFBluetoothDevice; AFileName: string; AAuthentication: Boolean = True): Boolean; overload;
begin
  Result := FTPSendFile(ADevice.Address, AFileName, True, AAuthentication);
end;

function FTPSendFile(ADevice: TBFIrDADevice; AFileName: string; AAuthentication: Boolean = True): Boolean; overload;
begin
  Result := FTPSendFile(ADevice.Address, AFileName, False, AAuthentication);
end;

function FTPSendFile(AAddress: string; AFileName: string; ABluetooth: Boolean; AAuthentication: Boolean = True): Boolean; overload;
begin
  Result := False;

  with TBFFileTransferClient.Create(nil) do begin
    if ABluetooth then
      with BluetoothTransport do begin
        Authentication := AAuthentication;
        Address := AAddress;
      end

    else begin
      Transport := atIrDA;
      IrDATransport.Address := AAddress;
    end;

    PacketSize := 2048;
    WriteBuffer := 2048;
    ReadBuffer := 2048;

    try
      Open;
      Put(AFileName);

      Result := True;

    except
    end;

    if Active then Close;

    Free;
  end;
end;

function FTPSendFile(AFileName: string): Boolean; overload;
begin
  Result := False;

  with TBFFileTransferClient.Create(nil) do begin
    UseActiveSync := True;

    PacketSize := 2048;
    WriteBuffer := 2048;
    ReadBuffer := 2048;

    try
      Open;
      Put(AFileName);

      Result := True;

    except
    end;

    if Active then Close;

    Free;
  end;
end;

{ TBFFile }

procedure TBFFile.Assign(AFile: TBFFile);
begin
  ClearFields;

  if Assigned(AFile) then begin
    FAccess := AFile.FAccess;
    FFolder := AFile.FFolder;
    FModified := AFile.Modified;
    FName := AFile.FName;
    FSize := AFile.FSize;
  end;
end;

procedure TBFFile.ClearFields;
begin
  FAccess := [];
  FFolder := False;
  FModified := 0;
  FName := '';
  FSize := 0;
end;

constructor TBFFile.Create;
begin
  ClearFields;
end;

{ TBFFiles }

procedure TBFFiles.Assign(AFiles: TBFFiles);
var
  Loop: Integer;
  AFile: TBFFile;
begin
  FList.Clear;

  if Assigned(AFiles) then
    for Loop := 0 to AFiles.Count - 1 do begin
      AFile := TBFFile.Create;
      AFile.Assign(AFiles[Loop]);
      FList.Add(AFile);
    end;
end;

constructor TBFFiles.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBFFiles.Destroy;
begin
  FList.Free;

  inherited;
end;

function TBFFiles.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TBFFiles.GetFiles(const Index: Integer): TBFFile;
begin
  Result := TBFFile(FList[Index]);
end;

{ TBFFileTransferClient }

constructor TBFFileTransferClient.Create(AOwner: TComponent);
begin
  inherited;

  with BluetoothTransport do begin
    Authentication := True;
    ServiceUUID := OBEXFileTransferServiceClass_UUID;
  end;

  FAutoDetect := True;
  FConnectionID := 0;
  FUseActiveSync := False;
end;

procedure TBFFileTransferClient.Delete(FileName: string);
var
  Data: TBFByteArray;
  TempFileName: WideString;
  Loop: Word;
  Index: Word;
  ceFileName: WideString;
  Attr: DWORD;
  Res: Boolean;
begin
  RaiseNotActive;

  if FUseActiveSync then begin
    ceFileName := WideString(FCEPath + '\' + FileName);

    Attr := CeGetFileAttributes(PWideChar(ceFileName));
    if Attr = $FFFFFFFF then begin
      SetLastError(CeGetLastError);
      RaiseLastOSError;
    end;

    if Attr and FILE_ATTRIBUTE_DIRECTORY <> 0 then
      Res := CeRemoveDirectory(PWideChar(ceFileName))

    else
      Res := CeDeleteFile(PWideChar(ceFileName));

    if not Res then begin
      SetLastError(CeGetLastError);
      RaiseLastOSError;
    end;

  end else
    try
      SetLength(Data, 11);
      Data[0] := $82;
      Data[1] := $00;
      Data[2] := $00;
      Data[3] := $CB;
      Data[4] := Hi(HiWord(FConnectionID));
      Data[5] := Lo(HiWord(FConnectionID));
      Data[6] := Hi(LoWord(FConnectionID));
      Data[7] := Lo(LoWord(FConnectionID));
      Data[8] := $01;
      Data[9] := $00;
      Data[10] := $00;

      TempFileName := WideString(ExtractFileName(FileName));
      if TempFileName[Length(TempFileName)] <> #$0000 then TempFileName := TempFileName + #$0000;

      Data[9] := Hi(LoWord(Length(TempFileName) * 2 + 3));
      Data[10] := Lo(LoWord(Length(TempFileName) * 2 + 3));

      SetLength(Data, Length(Data) + Length(TempFileName) * 2);

      Index := 11;
      for Loop := 1 to Length(TempFileName) do begin
        Data[Index] := Hi(Ord(TempFileName[Loop]));
        Data[Index + 1] := Lo(Ord(TempFileName[Loop]));
        Inc(Index, 2);
      end;

      Data[1] := Hi(LoWord(Length(Data)));
      Data[2] := Lo(LoWord(Length(Data)));

      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data);

    finally
      SetLength(Data, 0);
    end;
end;

function TBFFileTransferClient.Dir: TBFFiles;
var
  Data: TBFByteArray;
  Loop: Integer;
  AFile: TBFFile;
  Folders: TBFByteArray;
  Answer: Byte;
  Header: Byte;
  Index: Word;
  Size: Word;
  _Folders: TMemoryStream;
  XMLDoc: TBFXMLTree;
  Node1: TBFXMLNode;
  Node2: TBFXMLNode;
  XMLAttribute: TBFXMLAttribute;
  DateStr: string;
  Year: Word;
  Month: Byte;
  Day: Byte;
  Hour: Byte;
  Min: Byte;
  Sec: Byte;
  ceFindData: PCE_FIND_DATA_ARRAY;
  ceFound: DWORD;
  ceFlags: DWORD;
  ceSysTime: SYSTEMTIME;
  cePath: WideString;
begin
  RaiseNotActive;

  if FUseActiveSync then begin
    cePath := FCEPath + '\*.*';
    ceFindData := nil;
    ceFound := 0;
    ceFlags := FAF_ATTRIBUTES or FAF_CREATION_TIME or FAF_LASTACCESS_TIME or FAF_LASTWRITE_TIME or FAF_SIZE_HIGH or FAF_SIZE_LOW or FAF_NAME;

    if not CeFindAllFiles(PWideChar(cePath), ceFlags, ceFound, ceFindData) then begin
      SetLastError(CeGetLastError);
      RaiseLastOSError;
    end;

    Result := TBFFiles.Create;
    for Loop := 0 to ceFound - 1 do begin
      AFile := TBFFile.Create;

      if ceFindData^[Loop].dwFileAttributes and FILE_ATTRIBUTE_READONLY = 0 then
        AFile.FAccess := [faRead, faWrite, faDelete]

      else
        AFile.FAccess := [faRead];

      AFile.FFolder := ceFindData^[Loop].dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0;

      FileTimeToSystemTime(ceFindData^[Loop].ftLastWriteTime, ceSysTime);
      AFile.FModified := SystemTimeToDateTime(ceSysTime);
      AFile.FName := string(WideString(ceFindData^[Loop].cFileName));
      AFile.FSize := ceFindData^[Loop].nFileSizeLow;
      
      Result.FList.Add(AFile);
    end;

    CeRapiFreeBuffer(ceFindData);
    
  end else begin
    Result := TBFFiles.Create;

    SetLength(Data, 36);
    Data[0]  := $83;
    Data[1]  := $00;
    Data[2]  := $24;
    Data[3]  := $CB;
    Data[4]  := Hi(HiWord(FConnectionID));
    Data[5]  := Lo(HiWord(FConnectionID));
    Data[6]  := Hi(LoWord(FConnectionID));
    Data[7]  := Lo(LoWord(FConnectionID));
    Data[8]  := $42;
    Data[9]  := $00;
    Data[10] := $19;
    Data[11] := Ord('x');
    Data[12] := Ord('-');
    Data[13] := Ord('o');
    Data[14] := Ord('b');
    Data[15] := Ord('e');
    Data[16] := Ord('x');
    Data[17] := Ord('/');
    Data[18] := Ord('f');
    Data[19] := Ord('o');
    Data[20] := Ord('l');
    Data[21] := Ord('d');
    Data[22] := Ord('e');
    Data[23] := Ord('r');
    Data[24] := Ord('-');
    Data[25] := Ord('l');
    Data[26] := Ord('i');
    Data[27] := Ord('s');
    Data[28] := Ord('t');
    Data[29] := Ord('i');
    Data[30] := Ord('n');
    Data[31] := Ord('g');
    Data[32] := $00;
    Data[33] := $01;
    Data[34] := $00;
    Data[35] := $03;

    try
      SetLength(Folders, 0);

      repeat
        Write(Data);
        ReadOBEXPacket(Data);
        CheckOBEXError(Data);

        if Length(Data) = 0 then exit;
      
        Answer := Data[0];

        Index := 3;
        while Index < Length(Data) do begin
          Header := Data[Index];
          case Header and $C0 of
            $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
            $80: Size := 2;
            $C0: Size := 5;

          else
            Size := 0;
          end;

          if (Header = $48) or (Header = $49) then begin
            Inc(Index, 3);

            Size := Size - 3;
            SetLength(Folders, Word(Length(Folders)) + Size);

            for Loop := 0 to Size - 1 do Folders[Word(Length(Folders)) - Size + Word(Loop)] := Data[Index + Loop];

            Break;
          end;

          Inc(Index, Size);
        end;

        if Answer = $90 then begin
          SetLength(Data, 8);
          Data[0]  := $83;
          Data[1]  := $00;
          Data[2]  := $08;
          Data[3]  := $CB;
          Data[4]  := Hi(HiWord(FConnectionID));
          Data[5]  := Lo(HiWord(FConnectionID));
          Data[6]  := Hi(LoWord(FConnectionID));
          Data[7]  := Lo(LoWord(FConnectionID));
        end;
      until Answer = $A0;

      _Folders := TMemoryStream.Create;
      XMLDoc := TBFXMLTree.Create('', '', nil);
    
      try

        _Folders.Write(Folders[0], Length(Folders));
        _Folders.Position := 0;

        XMLDoc.LoadFromStream(_Folders);
        Node1 := XMLDoc.FindNamedNode('folder-listing');
        Node2 := Node1.FirstChild;

        while Assigned(Node2) do begin
          XMLAttribute := Node2.GetNamedAttribute('name');

          if Assigned(XMLAttribute) and (not VarIsEmpty(XMLAttribute.Value)) then begin
            AFile := TBFFile.Create;
            AFile.FFolder := AnsiUpperCase(string(Node2.Name)) = 'FOLDER';
            try
              AFile.FName := Utf8ToAnsi(String(XMLAttribute.Value));

            except
            end;

            XMLAttribute := Node2.GetNamedAttribute('size');
            if Assigned(XMLAttribute) and (not VarIsEmpty(XMLAttribute.Value)) then
              try
                AFile.FSize := StrToInt(string(XMLAttribute.Value));

              except
              end;

            XMLAttribute := Node2.GetNamedAttribute('modified');
            if Assigned(XMLAttribute) and (not VarIsEmpty(XMLAttribute.Value)) then
              try
                DateStr := string(XMLAttribute.Value);
                Year := StrToInt(Copy(DateStr, 1, 4));
                Month := StrToInt(Copy(DateStr, 5, 2));
                Day := StrToInt(Copy(DateStr, 7, 2));
                Hour := StrToInt(Copy(DateStr, 10, 2));
                Min := StrToInt(Copy(DateStr, 12, 2));
                Sec := StrToInt(Copy(DateStr, 14, 2));
                AFile.FModified := EncodeDateTime(Year, Month, Day, Hour, Min, Sec, 0);

              except
              end;

            XMLAttribute := Node2.GetNamedAttribute('user-perm');
            if Assigned(XMLAttribute) and (not VarIsEmpty(XMLAttribute.Value)) then begin
              DateStr := AnsiUpperCase(string(XMLAttribute.Value));
              if Pos('R', DateStr) > 0 then AFile.FAccess := AFile.FAccess + [faRead];
              if Pos('W', DateStr) > 0 then AFile.FAccess := AFile.FAccess + [faWrite];
              if Pos('D', DateStr) > 0 then AFile.FAccess := AFile.FAccess + [faDelete]; 
            end;

            Result.FList.Add(AFile);
          end;

          Node2 := Node2.NextSibling;
        end;

      finally
        _Folders.Free;
        XMLDoc.Free;
      end;

    except
      Result.Free;

      raise;
    end;
  end;
end;

procedure TBFFileTransferClient.Get(FileName: string; var AObject: TBFByteArray);
var
  Data: TBFByteArray;
  TempFileName: WideString;
  Answer: Byte;
  Header: Byte;
  FileSize: DWORD;
  Size: Word;
  Abort: Boolean;
  Index: Word;
  Loop: Integer;
  ceFile: THandle;
  cePos: DWORD;
  ceBuf: array [0..511] of Byte;
  ceBufSize: DWORD;
begin
  SetLength(AObject, 0);
  FileSize := 0;
  Abort := False;

  RaiseNotActive;

  if FUseActiveSync then begin
    TempFileName := WideString(FCEPath + '\' + FileName);

    ceFile := CeCreateFile(PWideChar(TempFileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
    if ceFile = INVALID_HANDLE_VALUE then begin
      SetLastError(CeGetLastError);
      RaiseLastOSError;
    end;

    try
      FileSize := CeGetFileSize(ceFile, nil);
      if FileSize = $FFFFFFFF then begin
        SetLastError(CeGetLastError);
        RaiseLastOSError;
      end;

      cePos := 0;
      while cePos < FileSize do begin
        Abort := False;
        DoProgress(FileName, 1, 1, Length(AObject), FileSize, Abort);

        ceBufSize := SizeOf(ceBuf);
        FillChar(ceBuf, ceBufSize, 0);

        if not CeReadFile(ceFile, @ceBuf[0], ceBufSize, @ceBufSize, nil) then begin
          SetLastError(CeGetLastError);
          SetLength(AObject, 0);
          RaiseLastOSError;
        end;

        Loop := Length(AObject);
        SetLength(AObject, DWORD(Loop) + ceBufSize);
        CopyMemory(@AObject[Loop], @ceBuf[0], ceBufSize);
        Inc(cePos, ceBufSize);

        Abort := False;
        DoProgress(FileName, 1, 1, Length(AObject), FileSize, Abort);
      end;
      
    finally
      CeCloseHandle(ceFile);
    end;

  end else begin
    SetLength(Data, 11);
    Data[0]  := $83;
    Data[1]  := $00;
    Data[2]  := $0A;
    Data[3]  := $CB;
    Data[4]  := Hi(HiWord(FConnectionID));
    Data[5]  := Lo(HiWord(FConnectionID));
    Data[6]  := Hi(LoWord(FConnectionID));
    Data[7]  := Lo(LoWord(FConnectionID));
    Data[8]  := $01;
    Data[9]  := $00;
    Data[10] := $00;

    TempFileName := WideString(FileName);
    if TempFileName[Length(TempFileName)] <> #$0000 then TempFileName := TempFileName + #$0000;

    Data[9] := Hi(LoWord(Length(TempFileName) * 2 + 3));
    Data[10] := Lo(LoWord(Length(TempFileName) * 2 + 3));

    SetLength(Data, Length(Data) + Length(TempFileName) * 2);

    Index := 11;
    for Loop := 1 to Length(TempFileName) do begin
      Data[Index] := Hi(Ord(TempFileName[Loop]));
      Data[Index + 1] := Lo(Ord(TempFileName[Loop]));
      Inc(Index, 2);
    end;

    Data[1] := Hi(LoWord(Length(Data)));
    Data[2] := Lo(LoWord(Length(Data)));

    try
      try
        Answer := 0;
      
        repeat
          Write(Data);
          ReadOBEXPacket(Data);
          CheckOBEXError(Data);

          if Length(Data) = 0 then Break;

          Answer := Data[0];

          if FileSize = 0 then begin
            Index := 3;

            while Index < Length(Data) do begin
              Header := Data[Index];
              case Header and $C0 of
                $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
                $80: Size := 2;
                $C0: Size := 5;

              else
                Size := 0;
              end;

              if Header = $C3 then begin
                FileSize := Data[Index + 1] shl 24 or Data[Index + 2] shl 16 or Data[Index + 3] shl 8 or Data[Index + 4];
                Break;
              end;

              Inc(Index, Size);
            end;
          end;

          Index := 3;
          while Index < Length(Data) do begin
            Header := Data[Index];
            case Header and $C0 of
              $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
              $80: Size := 2;
              $C0: Size := 5;

            else
              Size := 0;
            end;

            if (Header = $48) or (Header = $49) then begin
              Inc(Index, 3);

              Size := Size - 3;
              SetLength(AObject, DWORD(Length(AObject)) + Size);

              for Loop := 0 to Size - 1 do AObject[DWORD(Length(AObject)) - Size + DWORD(Loop)] := Data[Index + Loop];

              Break;
            end;

            Inc(Index, Size);
          end;

          Abort := False; 
          DoProgress(FileName, 1, 1, Length(AObject), FileSize, Abort);

          if Abort then begin
            SetLength(Data, 8);
            Data[0] := $FF;
            Data[1] := $00;
            Data[2] := $08;
            Data[3] := $CB;
            Data[4] := Hi(HiWord(FConnectionID));
            Data[5] := Lo(HiWord(FConnectionID));
            Data[6] := Hi(LoWord(FConnectionID));
            Data[7] := Lo(LoWord(FConnectionID));

            Write(Data);
            ReadOBEXPacket(Data);
            try
              CheckOBEXError(Data, 3);

            except
              Close;

              raise;
            end;

            Break;

          end else
            if Answer = $90 then begin
              SetLength(Data, 8);
              Data[0]  := $83;
              Data[1]  := $00;
              Data[2]  := $08;
              Data[3]  := $CB;
              Data[4]  := Hi(HiWord(FConnectionID));
              Data[5]  := Lo(HiWord(FConnectionID));
              Data[6]  := Hi(LoWord(FConnectionID));
              Data[7]  := Lo(LoWord(FConnectionID));
            end;
        until Answer = $A0;

      except
        SetLength(AObject, 0);

        raise;
      end;

    finally
      SetLength(Data, 0);
    end;
  end;
end;

procedure TBFFileTransferClient.InternalClose;
var
  Data: TBFByteArray;
begin
  if FUseActiveSync then
    CloseActiveSync

  else begin
    if ((Transport = atCOM) and FOBEXActive) or (Transport <> atCOM) then begin
      SetLength(Data, 8);
      Data[0] := $81;
      Data[1] := $00;
      Data[2] := $08;
      Data[3] := $CB;
      Data[4] := Hi(HiWord(FConnectionID));
      Data[5] := Lo(HiWord(FConnectionID));
      Data[6] := Hi(LoWord(FConnectionID));
      Data[7] := Lo(LoWord(FConnectionID));

      try
        Write(Data);
        ReadOBEXPacket(Data);
      except
      end;
    end;

    FConnectionID := 0;

    inherited;
  end;
end;

procedure TBFFileTransferClient.InternalOpen;
var
  Data: TBFByteArray;
  Index: Word;
  Header: Byte;
  Size: Word;
  Services: TBFBluetoothServices;
  Loop: Integer;
  Found: Boolean;
  DevInfo: IVTBLUETOOTH_DEVICE_INFO;
  DevInfoSize: DWORD;
  ServiceClassLength: DWORD;
  ServiceClassList: SPPEX_SERVICE_INFO;
  Res: DWORD;
  Success: Boolean;
begin
  RaiseActive;

  if FUseActiveSync then
    OpenActiveSync

  else begin
    Success := False;

    case Transport of
      atBluetooth: if FAutoDetect and (TBFPublicBluetoothClientTransport(BluetoothTransport).DetectedPort = UNKNOWN_PORT) then
                     if BluetoothTransport.Radio.BluetoothAPI = baBlueSoleil then begin
                       // Checking nokia service first.
                       DevInfoSize := SizeOf(IVTBLUETOOTH_DEVICE_INFO);
                       FillChar(DevInfo, DevInfoSize, 0);

                       with DevInfo do begin
                         dwSize := DevInfoSize;
                         address := API.StringToBluetoothAddress(BluetoothTransport.Address);
                       end;

                       ServiceClassLength := SizeOf(SPPEX_SERVICE_INFO);
                       FillChar(ServiceClassList, ServiceClassLength, 0);

                       with ServiceClassList do begin
                         dwSize := ServiceClassLength;
                         serviceClassUuid128 := NokiaOBEXPCSuiteServiceClass_UUID;
                       end;

                       Res := BT_SearchSPPExServices(@DevInfo, ServiceClassLength, @ServiceClassList);

                       if Res = BTSTATUS_SUCCESS then
                         with BluetoothTransport do begin
                           ServiceUUID := NokiaOBEXPCSuiteServiceClass_UUID;
                           Service := string(ServiceClassList.szServiceName);
                         end

                       else begin
                         FillChar(ServiceClassList, ServiceClassLength, 0);

                         with ServiceClassList do begin
                           dwSize := ServiceClassLength;
                           serviceClassUuid128 := OBEXFileTransferServiceClass_UUID;
                         end;

                         Res := BT_SearchSPPExServices(@DevInfo, ServiceClassLength, @ServiceClassList);

                         if Res = BTSTATUS_SUCCESS then
                           with BluetoothTransport do begin
                             ServiceUUID := OBEXFileTransferServiceClass_UUID;
                             Service := string(ServiceClassList.szServiceName);
                           end;
                       end;

                     end else begin
                       Services := EnumServices(BluetoothTransport.Address, false, BluetoothTransport.Radio);

                       Found := False;

                       // Searching nokia service.
                       for Loop := 0 to Services.Count - 1 do
                         if CompareGUIDs(Services[Loop].UUID, NokiaOBEXPCSuiteServiceClass_UUID) then begin
                           with BluetoothTransport do begin
                             ServiceUUID := Services[Loop].UUID;
                             Service := Services[Loop].Name;
                           end;

                           Found := True;

                           Break;
                         end;

                       // Searching startdard service.
                       if not Found then
                         for Loop := 0 to Services.Count - 1 do
                           if CompareGUIDs(Services[Loop].UUID, OBEXFileTransferServiceClass_UUID) then begin
                             with BluetoothTransport do begin
                               ServiceUUID := Services[Loop].UUID;
                               Service := Services[Loop].Name;
                             end;

                             Break;
                           end;
                     end;
      atIrDA: if AutoDetect then begin
                IrDATransport.Service := 'PC Suite Services';

                try
                  inherited;

                  Success := True;
                except
                end;

                if not Success then IrDATransport.Service := 'OBEX';
              end;
    end;

    if not Success then inherited;

    SetLength(Data, 26);

    Data[0] := $80;
    Data[1] := $00;
    Data[2] := $1A;
    Data[3] := $10;
    Data[4] := $00;
    Data[5] := Hi(PacketSize);
    Data[6] := Lo(PacketSize);
    Data[7]  := $46; {Target = F9EC7BC4-953C-11D2-984E-525400DC9E09}
    Data[8]  := $00;
    Data[9]  := $13;
    Data[10] := $F9;
    Data[11] := $EC;
    Data[12] := $7B;
    Data[13] := $C4;
    Data[14] := $95;
    Data[15] := $3C;
    Data[16] := $11;
    Data[17] := $D2;
    Data[18] := $98;
    Data[19] := $4E;
    Data[20] := $52;
    Data[21] := $54;
    Data[22] := $00;
    Data[23] := $DC;
    Data[24] := $9E;
    Data[25] := $09;

    try
      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data, 7);

    except
      inherited InternalClose;

      raise;
    end;

    FServerPacketSize := Data[5] shl 8 or Data[6];

    Index := 7;
    while Index < Length(Data) do begin
      Header := Data[Index];
      case Header and $C0 of
        $00, $40: Size := Data[Index + 1] shl 8 or Data[Index + 2];
        $80: Size := 1;
        $C0: Size := 5;
      else
        Size := 0;
      end;

      if Header = $CB then begin
        FConnectionID := Data[Index + 1] shl 24 or Data[Index + 2] shl 16 or Data[Index + 3] shl 8 or Data[Index + 4];
        Break;

      end else
        Inc(Index, Size);
    end;
  end;
end;

procedure TBFFileTransferClient.LoadTo(FileName: string; Dir: string);
var
  Data: TBFByteArray;
  AFileName: string;
begin
  AFileName := FileName;
  if not DirectoryExists(Dir) then raise Exception.Create(StrInvalidDirectory);

  Get(FileName, Data);
  if Length(Data) > 0 then begin
    if Dir[Length(Dir)] <> '\' then Dir := Dir + '\';
    FileName := Dir + FileName;
    if FileExists(FileName) then
      if MessageDlg('File ' + FileName + ' already exists. Overwrite?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        DeleteFile(FileName)

      else begin
        SetLength(Data, 0);
        Exit;
      end;

      with TFileStream.Create(FileName, fmCreate or fmShareExclusive) do begin
        Write(PChar(Data)^, Length(Data));
        Free;
      end;

      SetLength(Data, 0);
  end;
end;

procedure TBFFileTransferClient.Put(Stream: TStream; FileName: string);
var
  Data: TBFByteArray;
  FileSize: DWORD;
  TempFileName: WideString;
  Loop: Word;
  Index: Word;
  Position: DWORD;
  Abort: Boolean;
  ceFile: THandle;
  ceBuf: array [0..511] of Byte;
  ceBufSize: DWORD;
begin
  RaiseNotActive;

  if not Assigned(Stream) then Exit;
  Stream.Seek(soFromBeginning, 0);
  FileSize := Stream.Size;

  if FUseActiveSync then begin
    TempFileName := WideString(FCEPath + '\' + FileName);

    ceFile := CeCreateFile(PWideChar(TempFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0);
    if ceFile = INVALID_HANDLE_VALUE then begin
      SetLastError(CeGetLastError);
      RaiseLastOSError;
    end;

    try
      Position := 0;
      while Position < FileSize do begin
        Abort := False;
        DoProgress(FileName, 1, 1, Position, FileSize, Abort);

        ceBufSize := SizeOf(ceBuf);
        FillChar(ceBuf, ceBufSize, 0);

        Index := 512;
        if Position + Index > FileSize then Index := FileSize - Position;
        Stream.Read(ceBuf[0], Index);
        Inc(Position, Index);

        if not CeWriteFile(ceFile, @ceBuf[0], Index, @Index, nil) then begin
          SetLastError(CeGetLastError);
          RaiseLastOSError;
        end;

        Abort := False;
        DoProgress(FileName, 1, 1, Position, FileSize, Abort);
      end;
      
    finally
      CeCloseHandle(ceFile);
    end;

  end else
    try
      SetLength(Data, 16);
      Data[0] := $02;
      Data[1] := $00;
      Data[2] := $00;
      Data[3] := $CB;
      Data[4] := Hi(HiWord(FConnectionID));
      Data[5] := Lo(HiWord(FConnectionID));
      Data[6] := Hi(LoWord(FConnectionID));
      Data[7] := Lo(LoWord(FConnectionID));
      Data[8] := $C3;
      Data[9] := Hi(HiWord(FileSize));
      Data[10] := Lo(HiWord(FileSize));
      Data[11] := Hi(LoWord(FileSize));
      Data[12] := Lo(LoWord(FileSize));
      Data[13] := $01;
      Data[14] := $00;
      Data[15] := $00;

      TempFileName := WideString(ExtractFileName(FileName));
      if TempFileName[Length(TempFileName)] <> #$0000 then TempFileName := TempFileName + #$0000;

      Data[14] := Hi(LoWord(Length(TempFileName) * 2 + 3));
      Data[15] := Lo(LoWord(Length(TempFileName) * 2 + 3));

      SetLength(Data, Length(Data) + Length(TempFileName) * 2);

      Index := 16;
      for Loop := 1 to Length(TempFileName) do begin
        Data[Index] := Hi(Ord(TempFileName[Loop]));
        Data[Index + 1] := Lo(Ord(TempFileName[Loop]));
        Inc(Index, 2);
      end;

      Data[1] := Hi(LoWord(Length(Data)));
      Data[2] := Lo(LoWord(Length(Data)));

      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data);

      Position := 0;
      Abort := False;

      while Position < FileSize do begin
        Abort := False;
        DoProgress(FileName, 1, 1, Position, FileSize, Abort);

        if Abort then begin
          SetLength(Data, 8);
          Data[0] := $FF;
          Data[1] := $00;
          Data[2] := $08;
          Data[3] := $CB;
          Data[4] := Hi(HiWord(FConnectionID));
          Data[5] := Lo(HiWord(FConnectionID));
          Data[6] := Hi(LoWord(FConnectionID));
          Data[7] := Lo(LoWord(FConnectionID));

          Write(Data);
          ReadOBEXPacket(Data);
          try
            CheckOBEXError(Data, 3);

          except
            Close;

            raise;
          end;

          Break;

        end else begin
          SetLength(Data, FServerPacketSize);
          Data[0] := $02;
          Data[1] := Hi(FServerPacketSize);
          Data[2] := Lo(FServerPacketSize);
          Data[3] := $CB;
          Data[4] := Hi(HiWord(FConnectionID));
          Data[5] := Lo(HiWord(FConnectionID));
          Data[6] := Hi(LoWord(FConnectionID));
          Data[7] := Lo(LoWord(FConnectionID));
          Data[8] := $48;
          Data[9] := Hi(FServerPacketSize - 8);
          Data[10] := Lo(FServerPacketSize - 8);

          Index := 11;
          while (Position < FileSize) and (Index < FServerPacketSize) do begin
            Stream.Read(PChar(@Data[Index])^, 1);
            Inc(Position);
            Inc(Index);
          end;

          Data[1] := Hi(Index);
          Data[2] := Lo(Index);
          Data[9] := Hi(Index - 8);
          Data[10] := Lo(Index - 8);
          if (Position = FileSize) then begin
            SetLength(Data, Index);
            Abort := False; 
            DoProgress(FileName, 1, 1, Position, FileSize, Abort);
          end;

          Write(Data);
          ReadOBEXPacket(Data);
          CheckOBEXError(Data, 3);
        end;
      end;

      SetLength(Data, 11);
      Data[0] := $82;
      Data[1] := $00;
      Data[2] := $0B;
      Data[3] := $CB;
      Data[4] := Hi(HiWord(FConnectionID));
      Data[5] := Lo(HiWord(FConnectionID));
      Data[6] := Hi(LoWord(FConnectionID));
      Data[7] := Lo(LoWord(FConnectionID));
      Data[8] := $49;
      Data[9] := $00;
      Data[10] := $03;

      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data, 3);

    finally
      SetLength(Data, 0);
    end;
end;

procedure TBFFileTransferClient.OpenActiveSync;
var
  Init: RAPIINIT;
  InitSize: DWORD;
begin
  if gActiveSyncUsed then raise Exception.Create(StrActiveSyncAlreadyActive);
  if not API.ActiveSync then raise Exception.Create(StrActiveSyncUnavailable);

  InitSize := SizeOf(RAPIINIT);
  FillChar(Init, InitSize, 0);
  Init.cbSize := InitSize;

  if CeRapiInitEx(@Init) <> S_OK then begin
    SetLastError(CeGetLastError);
    RaiseLastOSError;
  end;

  if WaitForSingleObject(Init.heRapiInit, 5000) = WAIT_TIMEOUT then begin
    CeRapiUnInit;
    SetLastError(WAIT_TIMEOUT);
    RaiseLastOSError;
  end;

  FCEPath := '';
  
  gActiveSyncUsed := True;
end;

procedure TBFFileTransferClient.Put(FileName: string);
var
  AFile: TFileStream;
begin
  RaiseNotActive;

  if not FileExists(FileName) then raise Exception.Create(StrFileNotFound);

  AFile := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);

  try
    Put(AFile, ExtractFileName(FileName));

  finally
    AFile.Free;
  end;
end;

procedure TBFFileTransferClient.SetAutoDetect(const Value: Boolean);
begin
  if Value <> FAutoDetect then begin
    RaiseActive;

    FAutoDetect := Value;

    TBFPublicBluetoothClientTransport(BluetoothTransport).DetectedPort := UNKNOWN_PORT;
  end;
end;

procedure TBFFileTransferClient.SetPath(Dir: string; Create: Boolean);
var
  Data: TBFByteArray;
  TempDir: WideString;
  Index: Word;
  Loop: Integer;
  Ndx: integer;
begin
  RaiseNotActive;

  if FUseActiveSync then
    if Dir = '' then
      FCEPath := ''

    else
      if Dir = '..' then begin
        if FCEPath > '' then begin
          Ndx := 0;
          for Loop := Length(FCEPath) downto 1 do
            if FCEPath[Loop] = '\' then begin
              Ndx := Loop;
              Break;
            end;

          if Ndx = 0 then
            FCEPath := ''

          else begin
            Dec(Ndx);
            SetLength(FCEPath, Ndx);
          end;
        end;

      end else
        if Create then begin
          TempDir := WideString(FCEPath + '\' + Dir);

          if not CeCreateDirectory(PWideChar(TempDir), nil) then begin
            SetLastError(CeGetLastError);
            RaiseLastOSError;
          end;

          FCEPath := FCEPath + '\' + Dir;

        end else
          FCEPath := FCEPath + '\' + Dir

  else begin
    SetLength(Data, 13);
    Data[0] := $85;
    Data[1] := $00;
    Data[2] := $0D;
    Data[3] := $02;
    Data[4] := $00;
    Data[5] := $CB;
    Data[6] := Hi(HiWord(FConnectionID));
    Data[7] := Lo(HiWord(FConnectionID));
    Data[8] := Hi(LoWord(FConnectionID));
    Data[9] := Lo(LoWord(FConnectionID));
    Data[10] := $01;

    if Dir = '' then begin
      Data[11] := $00;
      Data[12] := $03;

    end else
      if Dir = '..' then begin
        Data[3] := $03;
        Data[2] := $0A;
        SetLength(Data, 10);

      end else begin
        TempDir := WideString(Dir);
        if TempDir[Length(TempDir)] <> #$0000 then TempDir := TempDir + #$0000;

        SetLength(Data, Length(Data) + Length(TempDir) * 2);
        Data[1] := Hi(LoWord(Length(Data)));
        Data[2] := Lo(LoWord(Length(Data)));
        Data[11] := Hi(LoWord(Length(TempDir) * 2 + 3));
        Data[12] := Lo(LoWord(Length(TempDir) * 2 + 3));

        Index := 13;
        for Loop := 1 to Length(TempDir) do begin
          Data[Index] := Hi(Ord(TempDir[Loop]));
          Data[Index + 1] := Lo(Ord(TempDir[Loop]));
          Inc(Index, 2);
        end;

        if Create then Data[3] := $00;
      end;

    try
      Write(Data);
      ReadOBEXPacket(Data);
      CheckOBEXError(Data);

    finally
      SetLength(Data, 0);
    end;
  end;
end;

{ TBFFileTransferClientX }

procedure _TBFFileTransferClientX.Delete(FileName: string);
begin
  TBFFileTransferClient(FBFCustomClient).Delete(FileName);
end;

function _TBFFileTransferClientX.Dir: TBFFiles;
begin
  Result := TBFFileTransferClient(FBFCustomClient).Dir;
end;

procedure _TBFFileTransferClientX.Get(FileName: string; var AObject: TBFByteArray);
begin
  TBFFileTransferClient(FBFCustomClient).Get(FileName, AObject);
end;

function _TBFFileTransferClientX.GetAutoDetect: Boolean;
begin
  Result := TBFFileTransferClient(FBFCustomClient).AutoDetect;
end;

function _TBFFileTransferClientX.GetComponentClass: TBFCustomClientClass;
begin
  Result := TBFFileTransferClient;
end;

function _TBFFileTransferClientX.GetUseActiveSync: Boolean;
begin
  Result := TBFFileTransferClient(FBFCustomClient).UseActiveSync;
end;

procedure _TBFFileTransferClientX.LoadTo(FileName, Dir: string);
begin
  TBFFileTransferClient(FBFCustomClient).LoadTo(FileName, Dir);
end;

procedure _TBFFileTransferClientX.Put(Stream: TStream; FileName: string);
begin
  TBFFileTransferClient(FBFCustomClient).Put(Stream, FileName);
end;

procedure _TBFFileTransferClientX.Put(FileName: string);
begin
  TBFFileTransferClient(FBFCustomClient).Put(FileName);
end;

procedure _TBFFileTransferClientX.SetAutoDetect(const Value: Boolean);
begin
  TBFFileTransferClient(FBFCustomClient).AutoDetect := Value;
end;

procedure _TBFFileTransferClientX.SetPath(Dir: string; Create: Boolean);
begin
  TBFFileTransferClient(FBFCustomClient).SetPath(Dir, Create);
end;

procedure TBFFileTransferClient.SetUseActiveSync(const Value: Boolean);
begin
  if Value <> FUseActiveSync then begin
    RaiseActive;

    FUseActiveSync := Value;
  end;
end;

procedure _TBFFileTransferClientX.SetUseActiveSync(const Value: Boolean);
begin
  TBFFileTransferClient(FBFCustomClient).UseActiveSync := Value;
end;

procedure TBFFileTransferClient.CloseActiveSync;
begin
  CeRapiUnInit;
  
  gActiveSyncUsed := False;
end;

end.
