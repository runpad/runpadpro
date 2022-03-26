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
unit BFCOMSettings;

{$I BF.inc}

interface

uses
  Forms, StdCtrls, Classes, Controls, ExtCtrls, BFClients;

type
  TfmCOMSettings = class(TForm)
    shTop: TShape;
    laTitle: TLabel;
    laAction: TLabel;
    laBaudRate: TLabel;
    cbBaudRate: TComboBox;
    laByteSize: TLabel;
    cbByteSize: TComboBox;
    laHardwareHandshake: TLabel;
    cbHardwareHandshake: TComboBox;
    laParity: TLabel;
    cbParity: TComboBox;
    laSoftwareHandshake: TLabel;
    cbSoftwareHandshake: TComboBox;
    laStopBits: TLabel;
    cbStopBits: TComboBox;
    btOK: TButton;
    btCancel: TButton;
    Bevel: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    FClient: TBFCustomClient;
  end;

implementation

{$R *.dfm}

procedure TfmCOMSettings.FormCreate(Sender: TObject);
begin
  FClient := TBFCustomClient(Owner);

  with FClient.COMPortTransport do begin
    cbBaudRate.ItemIndex := Integer(BaudRate);
    cbByteSize.ItemIndex := Integer(ByteSize);
    cbHardwareHandshake.ItemIndex := Integer(HardwareHandshake);
    cbParity.ItemIndex := Integer(Parity);
    cbSoftwareHandshake.ItemIndex := Integer(SoftwareHandshake);
    cbStopBits.ItemIndex := Integer(StopBits);
  end;
end;

procedure TfmCOMSettings.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;

  if ModalResult = mrOK then
    with FClient.COMPortTransport do begin
      BaudRate := TBFBaudRate(cbBaudRate.ItemIndex);
      ByteSize := TBFByteSize(cbByteSize.ItemIndex);
      HardwareHandshake := TBFHardwareHandshake(cbHardwareHandshake.ItemIndex);
      Parity := TBFParity(cbParity.ItemIndex);
      SoftwareHandshake := TBFSoftwareHandshake(cbSoftwareHandshake.ItemIndex);
      StopBits := TBFStopBits(cbStopBits.ItemIndex);
    end;
end;

end.
