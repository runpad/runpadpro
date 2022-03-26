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
unit BFSelectDevice;

{$I BF.inc}

interface

uses
  Forms, Graphics, ExtCtrls, BFDiscovery, BFBase, StdCtrls, Controls,
  ComCtrls, Classes, BFClients;

type
  TfmSelectDevice = class(TForm)
    PageControl: TPageControl;
    tsSelectTransport: TTabSheet;
    tsBluetooth: TTabSheet;
    tsIrDA: TTabSheet;
    tsCOMPort: TTabSheet;
    tsSummary: TTabSheet;
    laSelectTransport: TLabel;
    rbBluetooth: TRadioButton;
    rbIrDA: TRadioButton;
    rbCOMPort: TRadioButton;
    laBluetoothSelected: TLabel;
    laBTPressBrowse: TLabel;
    laBTCheckQuick: TLabel;
    laBTSelect: TLabel;
    edBTAddress: TEdit;
    btBrowseBT: TButton;
    cbQuickSearch: TCheckBox;
    laIrDASelected: TLabel;
    laIrDAPreeBrowse: TLabel;
    laSelectIrDA: TLabel;
    edIrDAAddress: TEdit;
    btBrowseIrDA: TButton;
    meSummary: TMemo;
    laCompleteTextLine1: TLabel;
    laCompleteTextLine2: TLabel;
    laCOMPortSelected: TLabel;
    laCOMPortInfo: TLabel;
    laCOMPortNumber: TLabel;
    cbCOMPort: TComboBox;
    imBluetooth: TImage;
    imIrDA: TImage;
    imCOM: TImage;
    laAction: TLabel;
    laTitle: TLabel;
    shTop: TShape;
    btBack: TButton;
    btNext: TButton;
    btCancel: TButton;
    stWait: TStaticText;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    btSettings: TButton;
    rbActiveSync: TRadioButton;
    procedure btBrowseBTClick(Sender: TObject);
    procedure btBrowseIrDAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btNextClick(Sender: TObject);
    procedure btBackClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btSettingsClick(Sender: TObject);

  private
    FBluetoothDevice: TBFBluetoothDevice;
    FBluetoothDiscovery: TBFBluetoothDiscovery;
    FClient: TBFCustomClient;
    FIrDADevice: TBFIrDADevice;
    FIrDADiscovery: TBFIrDADiscovery;

    procedure FillCOMPorts;

  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateCliented(AOwner: TComponent; Client: TBFCustomClient);
  end;

implementation

uses
  SysUtils, BFAPI, BFD5Support, BFStrings, BFCOMSettings, BFFileTransferClient,
  BFOBEXClient, BFBluetoothAudio;

{$R *.dfm}

procedure TfmSelectDevice.btBrowseBTClick(Sender: TObject);
begin
  if Assigned(FBluetoothDevice) then FBluetoothDevice.Free;
  // Chosing Bluetooth device.
  FBluetoothDevice := FBluetoothDiscovery.SelectDevice(cbQuickSearch.Checked);

  if Assigned(FBluetoothDevice) then edBTAddress.Text := FBluetoothDevice.Address;
end;

procedure TfmSelectDevice.btBrowseIrDAClick(Sender: TObject);
begin
  if Assigned(FIrDADevice) then FIrDADevice.Free;

  // Selecting IrDA Device.
  FIrDADevice := FIrDADiscovery.SelectDevice;

  if Assigned(FIrDADevice) then edIrDAAddress.Text := FIrDADevice.Address;
end;

procedure TfmSelectDevice.FormCreate(Sender: TObject);
begin
  FBluetoothDiscovery := TBFBluetoothDiscovery.Create(nil);
  FIrDADiscovery := TBFIrDADiscovery.Create(nil);
  
  with stWait do begin
    Parent := meSummary;
    Left := Round((meSummary.Width - Width) / 2);
    Top := Round((meSummary.Height - Height) / 2);
  end;

  with ProgressBar do begin
    Parent := meSummary;
    Left := Round((meSummary.Width - Width) / 2);
    Top := Round((meSummary.Height - Height) / 2) + 20;
  end;

  // Initialize
  PageControl.ActivePageIndex := 0;

  rbActiveSync.Visible := API.ActiveSync and (FClient is TBFFileTransferClient);
  rbCOMPort.Visible := not (FClient is TBFOBEXClient);
  with rbCOMPort do Enabled := Visible;

  // Check available transports.
  rbBluetooth.Enabled := atBluetooth in API.Transports;
  rbIrDA.Enabled := atIrDA in API.Transports;

  // Select default checked radio.
  if rbBluetooth.Enabled then
    rbBluetooth.Checked := True
  else
    if rbIrDA.Enabled then
      rbIrDA.Checked := True
    else
      with rbCOMPort do
        Checked := Enabled;

  // Fill COM port numbers
  FillCOMPorts;
end;

procedure TfmSelectDevice.btNextClick(Sender: TObject);
begin
  // Move to the next page.
  with PageControl do
    case ActivePageIndex of
      0: if rbBluetooth.Checked then
           ActivePageIndex := 1
         else
           if rbIrDA.Checked then
             ActivePageIndex := 2
           else
             if rbCOMPort.Checked then
               ActivePageIndex := 3

             else begin
               btNext.Caption := StrFinish;
               ActivePageIndex := 4;

               with meSummary.Lines do begin
                 Clear;

                 Add(StrActiveSyncConnect);
               end;
             end;

      1..3: begin
              btNext.Caption := StrFinish;
              ActivePageIndex := 4;

              with meSummary.Lines do begin
                Clear;

                if rbBluetooth.Checked then begin
                  Add(Format(StrTransport, [StrBluetooth]));
                  Add(Format(StrDeviceAddress, [edBTAddress.Text]));
                  Add(StrQuickSearch + BFBoolToStr(cbQuickSearch.Checked));

                end else
                  if rbIrDA.Checked then begin
                    Add(Format(StrTransport, [StrIrDA]));
                    Add(Format(StrDeviceAddress, [edIrDAAddress.Text]));

                  end else begin
                    Add(Format(StrTransport, [StrCOM]));
                    Add(StrCOMPortNumber + IntToStr(Integer(cbCOMPort.Items.Objects[cbCOMPort.ItemIndex])));
                  end;
              end;
            end;

      4: ModalResult := mrOK;
    end;
end;

procedure TfmSelectDevice.btBackClick(Sender: TObject);
begin
  // Moves to the prev. page.
  with PageControl do
    case ActivePageIndex of
      1..3: ActivePageIndex := 0;

      4: begin
           btNext.Caption := StrNext;
           if rbBluetooth.Checked then
             ActivePageIndex := 1
           else
             if rbIrDA.Checked then
               ActivePageIndex := 2
             else
               if rbCOMPort.Checked then
                 ActivePageIndex := 3
               else
                 ActivePageIndex := 0;
         end;
  end;
end;

constructor TfmSelectDevice.CreateCliented(AOwner: TComponent; Client: TBFCustomClient);
begin
  inherited Create(AOwner);

  FBluetoothDevice := nil;
  FClient := Client;
  FIrDADevice := nil;
end;

procedure TfmSelectDevice.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;

  // If OK then fill Client params and try to connect
  if ModalResult = mrOK then begin
    stWait.Visible := True;
    with ProgressBar do begin
      Position := 0;
      Visible := True;
    end;

    btBack.Enabled := False;
    btNext.Enabled := False;
    btCancel.Enabled := False;

    Timer.Enabled := True;
    Update;
    Application.ProcessMessages;

    try
      with TBFCustomClient(FClient) do begin
        if rbBluetooth.Checked then begin
          Transport := atBluetooth;
          BluetoothTransport.Address := edBTAddress.Text;
          BluetoothTransport.Device := FBluetoothDevice;

        end else
          if rbIrDA.Checked then begin
            Transport := atIrDA;
            IrDATransport.Address := edIrDAAddress.Text;
            IrDATransport.Device := FIrDADevice;

          end else
            if rbCOMPort.Checked then begin
              Transport := atCOM;
              COMPortTransport.Port := Lo(Integer(cbCOMPort.Items.Objects[cbCOMPort.ItemIndex]));

            end else
              TBFFileTransferClient(FClient).UseActiveSync := True;

        Open;
        CanClose := True;
      end;

    finally
      stWait.Visible := False;
      ProgressBar.Visible := False;
      Timer.Enabled := False;

      btBack.Enabled := True;
      btNext.Enabled := True;
      btCancel.Enabled := True;

      if not CanClose then
        with TBFCustomClient(FClient) do
          if Active then
            Close;
    end;

  end else
    CanClose := True;
end;

procedure TfmSelectDevice.TimerTimer(Sender: TObject);
begin
  with ProgressBar do
    if Position + 1 > 100 then
      Position := 0

    else
      Position := Position + 1;
end;

constructor TfmSelectDevice.Create(AOwner: TComponent);
begin
  inherited;

  FBluetoothDevice := nil;
  FClient := nil;
  FIrDADevice := nil;
end;

procedure TfmSelectDevice.FormDestroy(Sender: TObject);
begin
  if Assigned(FBluetoothDevice) then FBluetoothDevice.Free;
  if Assigned(FIrDADevice) then FIrDADevice.Free;

  FIrDADiscovery.Free;
  FBluetoothDiscovery.Free;
end;

procedure TfmSelectDevice.FillCOMPorts;
var
  Discovery: TBFBluetoothDiscovery;
  Ports: TBFCOMPorts;
  Loop: Integer;
begin
  cbCOMPort.Items.Clear;
  
  try
    Discovery := TBFBluetoothDiscovery.Create(Self);

    try
      Ports := Discovery.EnumCOMPorts;

      try
        for Loop := 0 to Ports.Count - 1 do
          with Ports[Loop] do
            cbCOMPort.Items.AddObject(Name, TObject(Number));

      finally
        Ports.Free;
      end;

    finally
      Discovery.Free;
    end;

  except
  end;

  if cbCOMPort.Items.Count > 0 then cbCOMPort.ItemIndex := 0;
end;

procedure TfmSelectDevice.btSettingsClick(Sender: TObject);
begin
  with TfmCOMSettings.Create(FClient) do begin
    ShowModal;
    Free;
  end;
end;

end.
