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
unit BFBluetoothMassSender;

{$I BF.inc}

interface

uses
  Classes, BFvCard, BFBase, Messages, BFDiscovery, BFAPI;

type
  // Company information and message.
  TBFCompanyInfo = class(TPersistent)
  private
    FvCard: TBFvCard;

    function GetEMail: string;
    function GetMessage: string;
    function GetName: string;
    function GetPhone: string;
    function GetURL: string;

    procedure SetEMail(const Value: string);
    procedure SetMessage(const Value: string);
    procedure SetName(const Value: string);
    procedure SetPhone(const Value: string);
    procedure SetURL(const Value: string);

  public
    constructor Create;
    destructor Destroy; override;

  published
    // company e-mail address
    property EMail: string read GetEMail write SetEMail;
    // Message text.
    property Message: string read GetMessage write SetMessage;
    // Company name
    property Name: string read GetName write SetName;
    // Company phone
    property Phone: string read GetPhone write SetPhone;
    // Company URL
    property URL: string read GetURL write SetURL;
  end;

  TBFMSSendResult = (srSuccess, srIgnored, srDeclined);

  TBFMSAcceptDeviceEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice; var Accept: Boolean) of object;
  TBFMSEvent = procedure(Sender: TObject) of object;
  TBFMSDiscoveryCompleteEvent = procedure(Sender: TObject; Count: Integer) of object;
  TBFMSNeedFileEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice; var FileName: string; var More: Boolean) of object;
  TBFMSSendStartEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice) of object;
  TBFMSSendCompleteEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice; Status: TBFMSSendResult) of object;
  TBFMSSendFileStartEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice; FileName: string) of object;
  TBFMSSendFileCompleteEvent = procedure(Sender: TObject; Device: TBFBluetoothDevice; FileName: string; Status: TBFMSSendResult) of object;
  TBFMSProgress = procedure (Sender: TObject; Device: TBFBluetoothDevice; FileName: string; Position: Integer; Size: Integer) of object;

  // This class designed for permanent discovering devices and send files to it.
  // It creates several threads and send files simultaneously to several
  // devices.
  // TBFBluetoothMassSender will useful for Bluetooth marketing and Bluetooth
  // Advertisement applications.
  // Component automatically detects is device require authentication and which
  // Profile it uses for files and vCard transferring.
  TBFBluetoothMassSender = class(TBFBaseComponent)
  private
    FCompanyInfo: TBFCompanyInfo;
    FDiscoveryRadio: TBFBluetoothRadio;
    FInterval: Word;
    FSendCompanyInfo: Boolean;
    FSendRadio: TBFBluetoothRadio;
    FThread: TBFBaseThread;

    FOnAcceptDevice: TBFMSAcceptDeviceEvent;
    FOnDiscoveryComplete: TBFMSDiscoveryCompleteEvent;
    FOnDiscoveryStarted: TBFMSEvent;
    FOnNeedFile: TBFMSNeedFileEvent;
    FOnProgress: TBFMSProgress;
    FOnSendComplete: TBFMSSendCompleteEvent;
    FOnSendFileComplete: TBFMSSendFileCompleteEvent;
    FOnSendFileStart: TBFMSSendFileStartEvent;
    FOnSendStart: TBFMSSendStartEvent;
    FOnSendvCardComplete: TBFMSSendCompleteEvent;
    FOnSendvCardStart: TBFMSSendStartEvent;
    FOnStarted: TBFMSEvent;
    FOnStopped: TBFMSEvent;

    function GetActive: Boolean;

    procedure DoAcceptDevice(Device: TBFBluetoothDevice; var Accept: Boolean);
    procedure DoDiscoveryComplete(Count: Integer);
    procedure DoDiscoveryStarted;
    procedure DoNeedFile(NeedFile: Pointer);
    procedure DoProgress(Progress: Pointer);
    procedure DoSendComplete(Complete: Pointer);
    procedure DoSendFileComplete(FileInfo: Pointer);
    procedure DoSendFileStart(FileInfo: Pointer);
    procedure DoSendStart(Device: TBFBluetoothDevice);
    procedure DoSendvCardComplete(Complete: Pointer);
    procedure DoSendvCardStart(Device: TBFBluetoothDevice);
    procedure DoStarted;
    procedure DoStopped;

    procedure SetActive(const Value: Boolean);
    procedure SetCompanyInfo(const Value: TBFCompanyInfo);
    procedure SetDiscoveryRadio(const Value: TBFBluetoothRadio);
    procedure SetInterval(const Value: Word);
    procedure SetSendRadio(const Value: TBFBluetoothRadio);

    procedure NMBFMassSenderEvent(var Message: TMessage); message BFNM_MASSSENDER_EVENT;

  public
    // Default contructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

    // Call this procedure to start sending procedure.
    procedure Start;
    // Call this method to stop sending procedure.
    procedure Stop;

    // Returns True if sending active otherwise returns False. Set to True to
    // start sending. Set to False to stop one.
    property Active: Boolean read GetActive write SetActive;
    // Radio on which discovery performs.
    property DiscoveryRadio: TBFBluetoothRadio read FDiscoveryRadio write SetDiscoveryRadio;
    // Radio on which send perform.
    property SendRadio: TBFBluetoothRadio read FSendRadio write SetSendRadio;

  published
    // Company information and message text.
    property CompanyInfo: TBFCompanyInfo read FCompanyInfo write SetCompanyInfo;
    // Interval between device discovering loops in seconds. Value should be
    // great or equal to one.
    property Interval: Word read FInterval write SetInterval default 1;
    // Sets to True to enable company information sending. Set to False to
    // disable this feature.
    property SendCompanyInfo: Boolean read FSendCompanyInfo write FSendCompanyInfo default True;

    // Occurs when device need acception
    property OnAcceptDevice: TBFMSAcceptDeviceEvent read FOnAcceptDevice write FOnAcceptDevice;
    // Occurs when complete discovery loop
    property OnDiscoveryComplete: TBFMSDiscoveryCompleteEvent read FOnDiscoveryComplete write FOnDiscoveryComplete;
    // Occurs when start discovery loop.
    property OnDiscoveryStarted: TBFMSEvent read FOnDiscoveryStarted write FOnDiscoveryStarted;
    // Occurs when need file information
    property OnNeedFile: TBFMSNeedFileEvent read FOnNeedFile write FOnNeedFile;
    // Occurs to show sending progress
    property OnProgress: TBFMSProgress read FOnProgress write FOnProgress;
    // Occurs when send complete for device
    property OnSendComplete: TBFMSSendCompleteEvent read FOnSendComplete write FOnSendComplete;
    // Occurs when file sent
    property OnSendFileComplete: TBFMSSendFileCompleteEvent read FOnSendFileComplete write FOnSendFileComplete;
    // Occus when file send start
    property OnSendFileStart: TBFMSSendFileStartEvent read FOnSendFileStart write FOnSendFileStart;
    // Occurs when start sending to device
    property OnSendStart: TBFMSSendStartEvent read FOnSendStart write FOnSendStart;
    // Occurs when vCard send complete for device
    property OnSendvCardComplete: TBFMSSendCompleteEvent read FOnSendvCardComplete write FOnSendvCardComplete;
    // Occurs when start sending vCard to device
    property OnSendvCardStart: TBFMSSendStartEvent read FOnSendvCardStart write FOnSendvCardStart;
    // Occurs when masssender started.
    property OnStarted: TBFMSEvent read FOnStarted write FOnStarted;
    // Occurs when masssender stopped.
    property OnStopped: TBFMSEvent read FOnStopped write FOnStopped;
  end;

  _TBFBluetoothMassSenderX = class(_TBFActiveXControl)
  private
    FBFBluetoothMassSender: TBFBluetoothMassSender;

    function GetActive: Boolean;
    function GetCompanyInfo: TBFCompanyInfo;
    function GetDiscoveryRadio: TBFBluetoothRadio;
    function GetInterval: Word;
    function GetSendCompanyInfo: Boolean;
    function GetSendRadio: TBFBluetoothRadio;

    function GetOnAcceptDevice: TBFMSAcceptDeviceEvent;
    function GetOnDiscoveryComplete: TBFMSDiscoveryCompleteEvent;
    function GetOnDiscoveryStarted: TBFMSEvent;
    function GetOnNeedFile: TBFMSNeedFileEvent;
    function GetOnProgress: TBFMSProgress;
    function GetOnSendComplete: TBFMSSendCompleteEvent;
    function GetOnSendFileComplete: TBFMSSendFileCompleteEvent;
    function GetOnSendFileStart: TBFMSSendFileStartEvent;
    function GetOnSendStart: TBFMSSendStartEvent;
    function GetOnSendvCardComplete: TBFMSSendCompleteEvent;
    function GetOnSendvCardStart: TBFMSSendStartEvent;
    function GetOnStarted: TBFMSEvent;
    function GetOnStopped: TBFMSEvent;

    procedure SetActive(const Value: Boolean);
    procedure SetCompanyInfo(const Value: TBFCompanyInfo);
    procedure SetDiscoveryRadio(const Value: TBFBluetoothRadio);
    procedure SetInterval(const Value: Word);
    procedure SetSendCompanyInfo(const Value: Boolean);
    procedure SetSendRadio(const Value: TBFBluetoothRadio);

    procedure SetOnAcceptDevice(const Value: TBFMSAcceptDeviceEvent);
    procedure SetOnDiscoveryComplete(const Value: TBFMSDiscoveryCompleteEvent);
    procedure SetOnDiscoveryStarted(const Value: TBFMSEvent);
    procedure SetOnNeedFile(const Value: TBFMSNeedFileEvent);
    procedure SetOnProgress(const Value: TBFMSProgress);
    procedure SetOnSendComplete(const Value: TBFMSSendCompleteEvent);
    procedure SetOnSendFileComplete(const Value: TBFMSSendFileCompleteEvent);
    procedure SetOnSendFileStart(const Value: TBFMSSendFileStartEvent);
    procedure SetOnSendStart(const Value: TBFMSSendStartEvent);
    procedure SetOnSendvCardComplete(const Value: TBFMSSendCompleteEvent);
    procedure SetOnSendvCardStart(const Value: TBFMSSendStartEvent);
    procedure SetOnStarted(const Value: TBFMSEvent);
    procedure SetOnStopped(const Value: TBFMSEvent);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    property Active: Boolean read GetActive write SetActive;
    property DiscoveryRadio: TBFBluetoothRadio read GetDiscoveryRadio write SetDiscoveryRadio;
    property SendRadio: TBFBluetoothRadio read GetSendRadio write SetSendRadio;

  published
    property CompanyInfo: TBFCompanyInfo read GetCompanyInfo write SetCompanyInfo;
    property Interval: Word read GetInterval write SetInterval;
    property SendCompanyInfo: Boolean read GetSendCompanyInfo write SetSendCompanyInfo;

    property OnAcceptDevice: TBFMSAcceptDeviceEvent read GetOnAcceptDevice write SetOnAcceptDevice;
    property OnDiscoveryComplete: TBFMSDiscoveryCompleteEvent read GetOnDiscoveryComplete write SetOnDiscoveryComplete;
    property OnDiscoveryStarted: TBFMSEvent read GetOnDiscoveryStarted write SetOnDiscoveryStarted;
    property OnNeedFile: TBFMSNeedFileEvent read GetOnNeedFile write SetOnNeedFile;
    property OnProgress: TBFMSProgress read GetOnProgress write SetOnProgress;
    property OnSendComplete: TBFMSSendCompleteEvent read GetOnSendComplete write SetOnSendComplete;
    property OnSendFileComplete: TBFMSSendFileCompleteEvent read GetOnSendFileComplete write SetOnSendFileComplete;
    property OnSendFileStart: TBFMSSendFileStartEvent read GetOnSendFileStart write SetOnSendFileStart;
    property OnSendStart: TBFMSSendStartEvent read GetOnSendStart write SetOnSendStart;
    property OnSendvCardComplete: TBFMSSendCompleteEvent read GetOnSendvCardComplete write SetOnSendvCardComplete;
    property OnSendvCardStart: TBFMSSendStartEvent read GetOnSendvCardStart write SetOnSendvCardStart;
    property OnStarted: TBFMSEvent read GetOnStarted write SetOnStarted;
    property OnStopped: TBFMSEvent read GetOnStopped write SetOnStopped;
  end;

implementation

uses
  SysUtils, BFStrings, Windows, Contnrs, BFObjectPushClient, BFFileTransferClient,
  Forms{$IFDEF DELPHI5}, FileCtrl, BFClients, BFOBEXClient{$ENDIF};

type
  TDiscoveryThread = class(TBFBaseThread)
  private
    FDiscovery: TBFBluetoothDiscovery;
    FOwner: TBFBluetoothMassSender;

  protected
    procedure Execute; override;

  public
    constructor Create(AOwner: TBFBluetoothMassSender);
    destructor Destroy; override;
  end;

  TSendThread = class(TBFBaseThread)
  private
    FDevice: TBFBluetoothDevice;
    FOwner: TBFBluetoothMassSender;

    procedure OnProgress(Sender: TObject; AName: string; Index: Integer; Count: Integer; Position: Integer; Size: Integer; var Abort: Boolean);

  private
    procedure Execute; override;

  public
    constructor Create(AOwner: TBFBluetoothMassSender; ADevice: TBFBluetoothDevice);
  end;

  PDevicePoolRecord = ^TDevicePoolRecord;
  TDevicePoolRecord = record
    Device: TBFBluetoothDevice;
    Thread: TThread;
  end;

  PNeedFile = ^TNeedFile;
  TNeedFile = record
    Device: TBFBluetoothDevice;
    FileName: string;
    More: Boolean;
  end;

  PComplete = ^TComplete;
  TComplete = record
    Device: TBFBluetoothDevice;
    Status: TBFMSSendResult;
  end;

  PFileInfo = ^TFileInfo;
  TFileInfo = record
    Device: TBFBluetoothDevice;
    FileName: string;
    Status: TBFMSSendResult;
  end;

  PProgress = ^TProgress;
  TProgress = record
    Device: TBFBluetoothDevice;
    FileName: string;
    Position: Integer;
    Size: Integer;
  end;

  var
    CS: TRTLCriticalSection;
    Semaphore: THandle = INVALID_HANDLE_VALUE;
    Pool: TList = nil;

  { TDiscoveryThread }

  constructor TDiscoveryThread.Create(AOwner: TBFBluetoothMassSender);
  begin
    FDiscovery := TBFBluetoothDiscovery.Create(nil);
    FOwner := AOwner;

    FreeOnTerminate := False;

    inherited Create(False);
  end;

  destructor TDiscoveryThread.Destroy;
  begin
    FDiscovery.Free;

    inherited;
  end;

  procedure TDiscoveryThread.Execute;
  var
    Device: TBFBluetoothDevice;
    Devices: TBFBluetoothDevices;
    DevicesList: TObjectList;
    Cnt: Integer;

    procedure DiscoveryDevices;

      procedure CopyDevices;
      var
        Loop: Integer;
      begin
        if Assigned(Devices) then begin
          for Loop := 0 to Devices.Count - 1 do begin
            // Create new radio object.
            Device := TBFBluetoothDevice.Create(nil);
            Device.Assign(Devices[Loop]);

            // Add it to internal list.
            DevicesList.Add(Device);
          end;

          // Clearup returned devices list.
          Devices.Free;
        end;
      end;
      
    begin
      SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_DISCOVERY_STARTED, 0);

      try
        Devices := FDiscovery.Discovery(FOwner.FDiscoveryRadio, False, False);

      except
        Devices := nil;
      end;

      // Copy devices into internal list.
      CopyDevices;

      SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_DISCOVERY_COMPLETE, DevicesList.Count);
    end;

    procedure CheckDevicesPool;
    var
      Loop: Integer;

      function DeviceInPool(Device: TBFBluetoothDevice): Boolean;
      var
        Loop: Integer;
      begin
        Result := False;

        for Loop := 0 to Pool.Count - 1 do
          if PDevicePoolRecord(Pool[Loop])^.Device.Address = Device.Address then begin
            Result := True;

            Break;
          end;
      end;

    begin
      // Syncronize access to devices pool.
      EnterCriticalSection(CS);

      Loop := 0;

      while Loop < DevicesList.Count do 
        if DeviceInPool(TBFBluetoothDevice(DevicesList[Loop])) then
          DevicesList.Delete(Loop)

        else
          Inc(Loop);

      LeaveCriticalSection(CS);
    end;

    procedure AcceptDevices;
    var
      Loop: Integer;
    begin
      Loop := 0;

      while Loop < DevicesList.Count do
        if SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_ACCEPT_DEVICE, Integer(DevicesList[Loop])) = 0 then
          DevicesList.Delete(Loop)

        else
          Inc(Loop);
    end;

    procedure StartSending;
    var
      Loop: Integer;
      PoolRecord: PDevicePoolRecord;
    begin
      for Loop := 0 to DevicesList.Count - 1 do begin
        New(PoolRecord);

        with PoolRecord^ do begin
          Device := TBFBluetoothDevice.Create(nil);
          with Device do begin
            Assign(TBFBluetoothDevice(DevicesList[Loop]));
            Radio := FOwner.FSendRadio;
          end;

          Thread := TSendThread.Create(FOwner, Device);
        end;

        EnterCriticalSection(CS);
        Pool.Add(PoolRecord);
        LeaveCriticalSection(CS);

        PoolRecord^.Thread.Resume;
      end;
    end;

    function GetCnt: Integer;
    begin
      EnterCriticalSection(CS);

      Result := Pool.Count;

      LeaveCriticalSection(CS);
    end;

  begin
    {
      In theory each SendMessage can raise an exception. But I do not check it
      here. My code can't raise that - so excaption will in user code.
      Let user fucking with that!
    }
    // Initialization
    DevicesList := TObjectList.Create;
    Pool := TList.Create;

    InitializeCriticalSection(CS);
    Semaphore := CreateSemaphore(nil, 6, 6, nil);

    // Start
    SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_STARTED, 0);

    while not Terminated do begin
      // Discovering devices
      DiscoveryDevices;

      // Checking devices in pool
      CheckDevicesPool;

      // Here we have devices not processing at present.
      // Now check for accept for that devices.
      AcceptDevices;

      // Start sending data for devices.
      StartSending;

      // Clean devices list.
      DevicesList.Clear;

      // Waiting for next loop
      Sleep(FOwner.FInterval * 1000);
    end;

    // Waiting all threads.
    Cnt := GetCnt;
    while Cnt > 0 do begin
      Sleep(1000);

      Cnt := GetCnt;
    end;

    // Stop
    SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_STOPPED, 0);

    // Finalization
    CloseHandle(Semaphore);
    DeleteCriticalSection(CS);

    DevicesList.Free;
    Pool.Free;
  end;

  { TSendThread }

  constructor TSendThread.Create(AOwner: TBFBluetoothMassSender; ADevice: TBFBluetoothDevice);
  begin
    FDevice := ADevice;
    FOwner := AOwner;

    FreeOnTerminate := True;

    inherited Create(True);
  end;

  procedure TSendThread.Execute;
  var
    Auth: Boolean;
    Complete: TComplete;
    FileTransfer: TBFFileTransferClient;
    ObjectPush: TBFObjectPushClient;
    SendVCard: Boolean;
    AStatus: TBFMSSendResult;
    vCard: TBFvCard;
    Files: TStringList;

    procedure GetFiles;
    var
      NeedFile: TNeedFile;
    begin
      repeat
        with NeedFile do begin
          Device := FDevice;
          FileName := '';
          More := False;
        end;

        SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_NEED_FILE, Integer(@NeedFile));

        with NeedFile do
          if FileName = '' then
            More := False

          else
            Files.Add(FileName);

      until not NeedFile.More;
    end;

    procedure PreparevCard;
    begin
      vCard.Assign(FOwner.CompanyInfo.FvCard);
      SendVCard := FOwner.FSendCompanyInfo;
    end;

    function SendCard: TBFMSSendResult;
    var
      Complete: TComplete;
      Stream: TMemoryStream;
    begin
      // Prepare
      Result := srSuccess;
      Auth := False;

      // If must not send vCard - exit.
      if not SendVCard then Exit;

      Stream := TMemoryStream.Create;
      vCard.SaveToStream(Stream);

      SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_VCARD_START, Integer(FDevice));

      with ObjectPush do begin
        // Trying connect without Authentication
        try
          Open;

        except
          on E: Exception do begin
            Auth := (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0);

            if not Auth then
              if (Pos('10064', E.Message) > 0) or (Pos('10110', E.Message) > 0) then
                Result := srDeclined

              else
                Result := srIgnored;
          end;
        end;

        // Trying connect with authentication.
        if (Result = srSuccess) and Auth then begin
          if Active then Close;

          BluetoothTransport.Authentication := True;

          try
            Open;

          except
            on E: Exception do begin
              if (Pos('10064', E.Message) > 0) or (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0) or (Pos('10110', E.Message) > 0) then
                Result := srDeclined

              else
                Result := srIgnored;
            end;
          end;
        end;

        // Sending vCard
        if Result = srSuccess then
          try
            Put(Stream, 'card.vcf');

          except
            on E: Exception do begin
              if Pos('10053', E.Message) > 0 then
                Result := srIgnored

              else
                Result := srDeclined;
            end;
          end;

        // Cant send vCard - close, otherwise - leave acive.
        if Result <> srSuccess then
          if Active then
            Close;
      end;

      with Complete do begin
        Device := FDevice;
        Status := Result;
      end;
      SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_VCARD_COMPLETE, Integer(@Complete));

      // Clean-up
      Stream.Free;
    end;

    function SendFiles: TBFMSSendResult;
    var
      Loop: Integer;
      Forb: Boolean;
      FileInfo: TFileInfo;
      DoBreak: Boolean;
    begin
      // Initialization
      Result := srSuccess;
      Forb := False;

      // If no files then exit.
      if Files.Count = 0 then Exit;

      // Try ObjectPush without authentication
      with ObjectPush do begin
        try
          if not Active then Open;

        except
          on E: Exception do begin
            if Auth then
              Result := srDeclined

            else begin
              Auth := (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0);

              if not Auth then
                if (Pos('10110', E.Message) > 0) or (Pos('10064', E.Message) > 0) then
                  Result := srDeclined

                else
                  Result := srIgnored;
            end;
          end;
        end;

        // Try ObjectOush with Authentication
        if (Result = srSuccess) and Auth then begin
          if Active then Close;

          BluetoothTransport.Authentication := True;

          try
            Open;

          except
            on E: Exception do begin
              if (Pos('10064', E.Message) > 0) or (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0) or (Pos('10110', E.Message) > 0) then
                Result := srDeclined

              else
                Result := srIgnored;
            end;
          end;
        end;

        // Send files using ObjectPush
        DoBreak := False;
        if Result = srSuccess then
          for Loop := 0 to Files.Count - 1 do
            if FileExists(Files[Loop]) then begin
              with FileInfo do begin
                Device := FDevice;
                FileName := Files[Loop];
                Status := srSuccess;
              end;
              SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_FILE_START, Integer(@FileInfo));

              try
                Put(Files[Loop]);

              except
                on E: Exception do begin
                  Forb := Pos('Forbidden', E.Message) > 0;

                  if not Forb then Result := srDeclined;

                  DoBreak := True;
                end;
              end;

              with FileInfo do begin
                Device := FDevice;
                FileName := Files[Loop];
                Status := Result;
              end;
              SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_FILE_COMPLETE, Integer(@FileInfo));

              if DoBreak then Break;
            end;
      end;

      with ObjectPush do
        if Active then
          Close;

      // ObjectPush was not success
      if Forb then begin
        AStatus := srSuccess;

        // Try FileTransfer without authentication
        with FileTransfer do begin
          try
            Open;

            Auth := False;

          except
            on E: Exception do begin
              Auth := (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0);

              if not Auth then
                if Pos('10064', E.Message) > 0 then
                  Result := srDeclined

                else
                  Result := srIgnored;
            end;
          end;

          // Try FileTransfer with Authentication
          if Auth then begin
            if Active then Close;

            BluetoothTransport.Authentication := True;

            try
              Open;

            except
              on E: Exception do begin
                if (Pos('10064', E.Message) > 0) or (Pos('10013', E.Message) > 0) or (Pos('10051', E.Message) > 0) then
                  Result := srDeclined

                else
                  Result := srIgnored;
              end;
            end;
          end;

          // Send files using FileTransfer
          DoBreak := False;
          if Result = srSuccess then
            for Loop := 0 to Files.Count - 1 do
              if FileExists(Files[Loop]) then begin
                with FileInfo do begin
                  Device := FDevice;
                  FileName := Files[Loop];
                  Status := srSuccess;
                end;
                SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_FILE_START, Integer(@FileInfo));

                try
                  Put(Files[Loop]);

                except
                  on E: Exception do begin
                    Result := srDeclined;

                    DoBreak := True;
                  end;
                end;

                with FileInfo do begin
                  Device := FDevice;
                  FileName := Files[Loop];
                  Status := Result;
                end;
                SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_FILE_COMPLETE, Integer(@FileInfo));

                if DoBreak then Break;
              end;
        end;
      end;
    end;

    procedure UnpairDevice;
    begin
      try
        // My BT ADDR
        if FDevice.Address <> '(00:01:E3:51:C2:71)' then FDevice.Unpair;

      except
      end;
    end;

    procedure CleanupPool;
    var
      Loop: Integer;
    begin
      EnterCriticalSection(CS);

      for Loop := 0 to Pool.Count - 1 do
        if PDevicePoolRecord(Pool[Loop])^.Device.Address = FDevice.Address then begin
          PDevicePoolRecord(Pool[Loop])^.Device.Free;

          Dispose(PDevicePoolRecord(Pool[Loop]));

          Pool.Delete(Loop);

          Break;
        end;

      LeaveCriticalSection(CS);
    end;

  begin
    // Initialization.
    Files := TStringList.Create;
    vCard := TBFvCard.Create;

    ObjectPush := TBFObjectPushClient.Create(nil);
    with ObjectPush do begin
      PacketSize := 2048;
      ReadBuffer := 2048;
      WriteBuffer := 2048;

      with BluetoothTransport do begin
        Authentication := False;
        Device := FDevice;
      end;

      ReadTimeOut := 10000;
      WriteTimeOut := 10000;
    end;

    FileTransfer := TBFFileTransferClient.Create(nil);
    with FileTransfer do begin
      AutoDetect := False;
      PacketSize := 2048;
      ReadBuffer := 2048;
      WriteBuffer := 2048;

      with BluetoothTransport do begin
        Authentication := False;
        Device := FDevice;
      end;

      ReadTimeOut := 10000;
      WriteTimeOut := 10000;

      OnProgress := OnProgress;
    end;

    // Build files list for device.
    GetFiles;

    // Preparing vCard if needed.
    PreparevCard;

    // Waiting for sending possible
    WaitForSingleObject(Semaphore, INFINITE);

    SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_START, Integer(FDevice));

    // Sending data
    // vCard first
    AStatus := SendCard;

    // If vCard sent sending files.
    if AStatus = srSuccess then begin
      ObjectPush.OnProgress := OnProgress;
      AStatus := SendFiles;
    end;

    // Reporting status
    with Complete do begin
      Device := FDevice;
      Status := AStatus;
    end;
    SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_SEND_COMPLETE, Integer(@Complete));

    // Unpair device.
    UnpairDevice;

    // Allows other threads to send
    ReleaseSemaphore(Semaphore, 1, nil);

    // Finalization.
    with ObjectPush do begin
      if Active then Close;

      Free;
    end;

    with FileTransfer do begin
      if Active then Close;

      Free;
    end;

    vCard.Free;
    Files.Free;

    // Cleanup pool
    CleanupPool;
  end;

procedure TSendThread.OnProgress(Sender: TObject; AName: string; Index: Integer; Count: Integer; Position: Integer; Size: Integer; var Abort: Boolean);
var
  Progress: TProgress;
begin
  Abort := False;

  Progress.Device := FDevice;
  Progress.FileName := AName;
  Progress.Position := Position;
  Progress.Size := Size;

  SendMessage(FOwner.Wnd, BFNM_MASSSENDER_EVENT, NM_SENDER_PROGRESS, Integer(@Progress));
end;

{ TBFCompanyInfo }

constructor TBFCompanyInfo.Create;
begin
  inherited;

  FvCard := TBFvCard.Create;

  with FvCard do begin
    with TelecomInfo.Email1 do begin
      Address := 'admin@btframework.com';
      EmailType := etInternet;
    end;
    Identification.Name.FamilyName := 'Welcome to tomorrow';
    BusinessInfo.Company.Name := 'Soft Service Company';
    with TelecomInfo.Phone1 do begin
      Attributes := [ptPreferred, ptWork, ptVoice];
      Number := '+79624569577';
    end;
    ExplanatoryInfo.URL1 := 'http://www.softservicecompany.com';
  end;
end;

destructor TBFCompanyInfo.Destroy;
begin
  FvCard.Free;

  inherited;
end;

function TBFCompanyInfo.GetEMail: string;
begin
  Result := FvCard.TelecomInfo.Email1.Address;
end;

function TBFCompanyInfo.GetMessage: string;
begin
  Result := FvCard.Identification.Name.FamilyName;
end;

function TBFCompanyInfo.GetName: string;
begin
  Result := FvCard.BusinessInfo.Company.Name;
end;

function TBFCompanyInfo.GetPhone: string;
begin
  Result := FvCard.TelecomInfo.Phone1.Number;
end;

function TBFCompanyInfo.GetURL: string;
begin
  Result := FvCard.ExplanatoryInfo.URL1;
end;

procedure TBFCompanyInfo.SetEMail(const Value: string);
begin
  FvCard.TelecomInfo.Email1.Address := Value;
end;

procedure TBFCompanyInfo.SetMessage(const Value: string);
begin
  FvCard.Identification.Name.FamilyName := Value;
end;

procedure TBFCompanyInfo.SetName(const Value: string);
begin
  FvCard.BusinessInfo.Company.Name := Value;
end;

procedure TBFCompanyInfo.SetPhone(const Value: string);
begin
  FvCard.TelecomInfo.Phone1.Number := Value;
end;

procedure TBFCompanyInfo.SetURL(const Value: string);
begin
  FvCard.ExplanatoryInfo.URL1 := Value;
end;

{ TBFBluetoothMassSender }

constructor TBFBluetoothMassSender.Create(AOwner: TComponent);
begin
  inherited;

  FCompanyInfo := TBFCompanyInfo.Create;
  FDiscoveryRadio := nil;
  FInterval := 1;
  FSendCompanyInfo := True;
  FSendRadio := nil;
  FThread := nil;

  FOnAcceptDevice := nil;
  FOnDiscoveryComplete := nil;
  FOnDiscoveryStarted := nil;
  FOnNeedFile := nil;
  FOnProgress := nil;
  FOnSendComplete := nil;
  FOnSendFileComplete := nil;
  FOnSendFileStart := nil;
  FOnSendStart := nil;
  FOnSendvCardComplete := nil;
  FOnSendvCardStart := nil;
  FOnStarted := nil;
  FOnStopped := nil;
end;

destructor TBFBluetoothMassSender.Destroy;
begin
  Stop;

  FCompanyInfo.Free;
  if Assigned(FDiscoveryRadio) then FDiscoveryRadio.Free;
  if Assigned(FSendRadio) then FSendRadio.Free;

  inherited;
end;

procedure TBFBluetoothMassSender.DoAcceptDevice(Device: TBFBluetoothDevice; var Accept: Boolean);
begin
  if Assigned(FOnAcceptDevice) then FOnAcceptDevice(Self, Device, Accept); 
end;

procedure TBFBluetoothMassSender.DoDiscoveryComplete(Count: Integer);
begin
  if Assigned(FOnDiscoveryComplete) then FOnDiscoveryComplete(Self, Count);
end;

procedure TBFBluetoothMassSender.DoDiscoveryStarted;
begin
  if Assigned(FOnDiscoveryStarted) then FOnDiscoveryStarted(Self);
end;

procedure TBFBluetoothMassSender.DoNeedFile(NeedFile: Pointer);
begin
  if Assigned(FOnNeedFile) then FOnNeedFile(Self, PNeedFile(NeedFile)^.Device, PNeedFile(NeedFile)^.FileName, PNeedFile(NeedFile)^.More); 
end;

procedure TBFBluetoothMassSender.DoProgress(Progress: Pointer);
var
  AProgress: PProgress;
begin
  AProgress := PProgress(Progress);
  if Assigned(FOnProgress) then
    with AProgress^ do
      FOnProgress(Self, Device, FileName, Position, Size);
end;

procedure TBFBluetoothMassSender.DoSendComplete(Complete: Pointer);
begin
  if Assigned(FOnSendComplete) then FOnSendComplete(Self, PComplete(Complete)^.Device, PComplete(Complete)^.Status);
end;

procedure TBFBluetoothMassSender.DoSendFileComplete(FileInfo: Pointer);
begin
  if Assigned(FOnSendFileComplete) then FOnSendFileComplete(Self, PFileInfo(FileInfo)^.Device, PFileInfo(FileInfo)^.FileName, PFileInfo(FileInfo)^.Status);
end;

procedure TBFBluetoothMassSender.DoSendFileStart(FileInfo: Pointer);
begin
  if Assigned(FOnSendFileStart) then FOnSendFileStart(Self, PFileInfo(FileInfo)^.Device, PFileInfo(FileInfo)^.FileName);
end;

procedure TBFBluetoothMassSender.DoSendStart(Device: TBFBluetoothDevice);
begin
  if Assigned(FOnSendStart) then FOnSendStart(Self, Device);
end;

procedure TBFBluetoothMassSender.DoSendvCardComplete(Complete: Pointer);
begin
  if Assigned(FOnSendvCardComplete) then FOnSendvCardComplete(Self, PComplete(Complete)^.Device, PComplete(Complete)^.Status);
end;

procedure TBFBluetoothMassSender.DoSendvCardStart(Device: TBFBluetoothDevice);
begin
  if Assigned(FOnSendvCardStart) then FOnSendvCardStart(Self, Device);
end;

procedure TBFBluetoothMassSender.DoStarted;
begin
  if Assigned(FOnStarted) then FOnStarted(Self);
end;

procedure TBFBluetoothMassSender.DoStopped;
begin
  if Assigned(FOnStopped) then FOnStopped(Self);
end;

function TBFBluetoothMassSender.GetActive: Boolean;
begin
  Result := Assigned(FThread);
end;

procedure TBFBluetoothMassSender.NMBFMassSenderEvent(var Message: TMessage);
var
  Accept: Boolean;
begin
  case Message.WParam of
    NM_SENDER_ACCEPT_DEVICE: begin
                               Accept := True;
                               DoAcceptDevice(TBFBluetoothDevice(Message.LParam), Accept);
                               if Accept then
                                 Message.Result := 1
                               else
                                 Message.Result := 0;
                             end;
    NM_SENDER_DISCOVERY_STARTED: DoDiscoveryStarted;
    NM_SENDER_DISCOVERY_COMPLETE: DoDiscoveryComplete(Message.LParam);
    NM_SENDER_NEED_FILE: DoNeedFile(PNeedFile(Message.LParam));
    NM_SENDER_SEND_FILE_COMPLETE: DoSendFileComplete(PFileInfo(Message.LParam));
    NM_SENDER_SEND_FILE_START: DoSendFileStart(PFileInfo(Message.LParam));
    NM_SENDER_SEND_COMPLETE: DoSendComplete(PComplete(Message.LParam));
    NM_SENDER_SEND_START: DoSendStart(TBFBluetoothDevice(Message.LParam));
    NM_SENDER_SEND_VCARD_COMPLETE: DoSendvCardComplete(PComplete(Message.LParam));
    NM_SENDER_SEND_VCARD_START: DoSendvCardStart(TBFBluetoothDevice(Message.LParam));
    NM_SENDER_STARTED: DoStarted;
    NM_SENDER_STOPPED: DoStopped;
    NM_SENDER_PROGRESS: DoProgress(PProgress(Message.LParam));
  end;
end;

procedure TBFBluetoothMassSender.SetActive(const Value: Boolean);
begin
  if Value then
    Start

  else
    Stop;
end;

procedure TBFBluetoothMassSender.SetCompanyInfo(const Value: TBFCompanyInfo);
begin
end;

procedure TBFBluetoothMassSender.SetDiscoveryRadio(const Value: TBFBluetoothRadio);
begin
  if Active then raise Exception.Create(StrMassSednerActive);

  if Assigned(FDiscoveryRadio) then begin
    FDiscoveryRadio.Free;
    FDiscoveryRadio := nil;
  end;

  if Assigned(Value) then begin
    FDiscoveryRadio := TBFBluetoothRadio.Create;
    FDiscoveryRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothMassSender.SetInterval(const Value: Word);
begin
  if Value <> FInterval then begin
    if Value < 1 then raise Exception.Create(StrInvalidInterval);

    FInterval := Value;
  end;
end;

procedure TBFBluetoothMassSender.SetSendRadio(const Value: TBFBluetoothRadio);
begin
  if Active then raise Exception.Create(StrMassSednerActive);
  if Assigned(Value) then
    if Value.BluetoothAPI <> baWinSock then
      raise Exception.Create(StrMSApiReq);

  if Assigned(FSendRadio) then begin
    FSendRadio.Free;
    FSendRadio := nil;
  end;

  if Assigned(Value) then begin
    FSendRadio := TBFBluetoothRadio.Create;
    FSendRadio.Assign(Value);
  end;
end;

procedure TBFBluetoothMassSender.Start;
begin
  if not Active then begin
    if not (atBluetooth in API.Transports) then raise Exception.Create(StrBTUnavailable);
    if not (baWinSock in API.BluetoothAPIs) then raise Exception.Create(StrMSStackUnavailable);
    if not Assigned(FDiscoveryRadio) then raise Exception.Create(StrDiscoveryRadioReq);
    if not Assigned(FSendRadio) then raise Exception.Create(StrSendRadioReq);
    if FSendRadio.BluetoothAPI <> baWinSock then raise Exception.Create(StrMSApiReq); 

    FThread := TDiscoveryThread.Create(Self);
  end;
end;

procedure TBFBluetoothMassSender.Stop;
begin
  if Active then begin
    with FThread do begin
      Terminate;
      WaitFor;
      Free;
    end;

    FThread := nil;
  end;
end;

{ TBFBluetoothMassSenderX }

constructor _TBFBluetoothMassSenderX.Create(AOwner: TComponent);
begin
  inherited;

  FBFBluetoothMassSender := TBFBluetoothMassSender.Create(nil);
end;

destructor _TBFBluetoothMassSenderX.Destroy;
begin
  FBFBluetoothMassSender.Free;
  
  inherited;
end;

function _TBFBluetoothMassSenderX.GetActive: Boolean;
begin
  Result := FBFBluetoothMassSender.Active;
end;

function _TBFBluetoothMassSenderX.GetCompanyInfo: TBFCompanyInfo;
begin
  Result := FBFBluetoothMassSender.CompanyInfo;
end;

function _TBFBluetoothMassSenderX.GetOnDiscoveryComplete: TBFMSDiscoveryCompleteEvent;
begin
  Result := FBFBluetoothMassSender.FOnDiscoveryComplete;
end;

function _TBFBluetoothMassSenderX.GetDiscoveryRadio: TBFBluetoothRadio;
begin
  Result := FBFBluetoothMassSender.DiscoveryRadio;
end;

function _TBFBluetoothMassSenderX.GetOnDiscoveryStarted: TBFMSEvent;
begin
  Result := FBFBluetoothMassSender.OnDiscoveryStarted; 
end;

function _TBFBluetoothMassSenderX.GetInterval: Word;
begin
  Result := FBFBluetoothMassSender.Interval;
end;

function _TBFBluetoothMassSenderX.GetOnStarted: TBFMSEvent;
begin
  Result := FBFBluetoothMassSender.OnStarted;
end;

function _TBFBluetoothMassSenderX.GetOnStopped: TBFMSEvent;
begin
  Result := FBFBluetoothMassSender.OnStopped;
end;

function _TBFBluetoothMassSenderX.GetSendCompanyInfo: Boolean;
begin
  Result := FBFBluetoothMassSender.SendCompanyInfo;
end;

function _TBFBluetoothMassSenderX.GetSendRadio: TBFBluetoothRadio;
begin
  Result := FBFBluetoothMassSender.SendRadio;
end;

procedure _TBFBluetoothMassSenderX.SetActive(const Value: Boolean);
begin
  FBFBluetoothMassSender.Active := Value;
end;

procedure _TBFBluetoothMassSenderX.SetCompanyInfo(const Value: TBFCompanyInfo);
begin
  FBFBluetoothMassSender.CompanyInfo := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnDiscoveryComplete(const Value: TBFMSDiscoveryCompleteEvent);
begin
  FBFBluetoothMassSender.OnDiscoveryComplete := Value;
end;

procedure _TBFBluetoothMassSenderX.SetDiscoveryRadio(const Value: TBFBluetoothRadio);
begin
  FBFBluetoothMassSender.DiscoveryRadio := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnDiscoveryStarted(const Value: TBFMSEvent);
begin
  FBFBluetoothMassSender.OnDiscoveryStarted := Value;
end;

procedure _TBFBluetoothMassSenderX.SetInterval(const Value: Word);
begin
  FBFBluetoothMassSender.Interval := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnStarted(const Value: TBFMSEvent);
begin
  FBFBluetoothMassSender.OnStarted := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnStopped(const Value: TBFMSEvent);
begin
  FBFBluetoothMassSender.OnStopped := Value;
end;

procedure _TBFBluetoothMassSenderX.SetSendCompanyInfo(const Value: Boolean);
begin
  FBFBluetoothMassSender.SendCompanyInfo := Value;
end;

procedure _TBFBluetoothMassSenderX.SetSendRadio(const Value: TBFBluetoothRadio);
begin
  FBFBluetoothMassSender.SendRadio := Value;
end;

procedure _TBFBluetoothMassSenderX.Start;
begin
  FBFBluetoothMassSender.Start;
end;

procedure _TBFBluetoothMassSenderX.Stop;
begin
  FBFBluetoothMassSender.Stop;
end;

function _TBFBluetoothMassSenderX.GetOnAcceptDevice: TBFMSAcceptDeviceEvent;
begin
  Result := FBFBluetoothMassSender.OnAcceptDevice;
end;

procedure _TBFBluetoothMassSenderX.SetOnAcceptDevice(const Value: TBFMSAcceptDeviceEvent);
begin
  FBFBluetoothMassSender.OnAcceptDevice := Value;
end;

function _TBFBluetoothMassSenderX.GetOnNeedFile: TBFMSNeedFileEvent;
begin
  Result := FBFBluetoothMassSender.OnNeedFile;
end;

procedure _TBFBluetoothMassSenderX.SetOnNeedFile(const Value: TBFMSNeedFileEvent);
begin
  FBFBluetoothMassSender.OnNeedFile := Value;
end;

function _TBFBluetoothMassSenderX.GetOnSendComplete: TBFMSSendCompleteEvent;
begin
  Result := FBFBluetoothMassSender.OnSendComplete;
end;

function _TBFBluetoothMassSenderX.GetOnSendStart: TBFMSSendStartEvent;
begin
  Result := FBFBluetoothMassSender.OnSendStart;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendComplete(const Value: TBFMSSendCompleteEvent);
begin
  FBFBluetoothMassSender.OnSendComplete := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendStart(const Value: TBFMSSendStartEvent);
begin
  FBFBluetoothMassSender.OnSendStart := Value;
end;

function _TBFBluetoothMassSenderX.GetOnSendvCardComplete: TBFMSSendCompleteEvent;
begin
  Result := FBFBluetoothMassSender.OnSendvCardComplete;
end;

function _TBFBluetoothMassSenderX.GetOnSendvCardStart: TBFMSSendStartEvent;
begin
  Result := FBFBluetoothMassSender.FOnSendvCardStart;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendvCardComplete(const Value: TBFMSSendCompleteEvent);
begin
  FBFBluetoothMassSender.OnSendvCardComplete := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendvCardStart(const Value: TBFMSSendStartEvent);
begin
  FBFBluetoothMassSender.OnSendvCardStart := Value;
end;

function _TBFBluetoothMassSenderX.GetOnSendFileComplete: TBFMSSendFileCompleteEvent;
begin
  Result := FBFBluetoothMassSender.OnSendFileComplete;
end;

function _TBFBluetoothMassSenderX.GetOnSendFileStart: TBFMSSendFileStartEvent;
begin
  Result := FBFBluetoothMassSender.OnSendFileStart;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendFileComplete(const Value: TBFMSSendFileCompleteEvent);
begin
  FBFBluetoothMassSender.OnSendFileComplete := Value;
end;

procedure _TBFBluetoothMassSenderX.SetOnSendFileStart(const Value: TBFMSSendFileStartEvent);
begin
  FBFBluetoothMassSender.OnSendFileStart := Value;
end;

function _TBFBluetoothMassSenderX.GetOnProgress: TBFMSProgress;
begin
  Result := FBFBluetoothMassSender.OnProgress;
end;

procedure _TBFBluetoothMassSenderX.SetOnProgress(const Value: TBFMSProgress);
begin
  FBFBluetoothMassSender.OnProgress := Value;
end;

end.
