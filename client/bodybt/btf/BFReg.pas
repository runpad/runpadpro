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
unit BFReg;

{$I BF.inc}

interface

procedure Register;

implementation

uses
  Classes, BFControls, BFAPI, BFDiscovery, BFAuthenticator, BFClients,
  BFClient, BFSerialPortClient, BFObjectPushClient, BFFileTransferClient,
  BFSyncClient, BFPhoneBookClient, BFGSMModemClient, BFXPMan, BFSerialEventsClient,
  BFBluetoothCOMPortCreator, BFServer, BFBluetoothMassSender, BFObjectPushServer,
  BFBluetoothAudio;

procedure Register;
begin
  RegisterComponents('Bluetooth Framework Controls', [TBFCharge, TBFSignal]);

  RegisterComponents('Bluetooth Framework System', [TBFAPIInfo, TBFAuthenticator]);
  RegisterComponents('Bluetooth Framework System', [TBFBluetoothDiscovery, TBFIrDADiscovery]);
  RegisterComponents('Bluetooth Framework System', [TBFXPMan]);

  RegisterComponents('Bluetooth Framework Clients', [TBFClient, TBFObjectPushClient]);
  RegisterComponents('Bluetooth Framework Clients', [TBFFileTransferClient, TBFSyncClient]);
  RegisterComponents('Bluetooth Framework Clients', [TBFPhoneBookClient, TBFSerialPortClient]);
  RegisterComponents('Bluetooth Framework Clients', [TBFGSMModemClient, TBFSerialEventsClient]);
  RegisterComponents('Bluetooth Framework Clients', [TBFBluetoothCOMPortCreator]);

  RegisterComponents('Bluetooth Framework Servers', [TBFServer, TBFObjectPushServer]);

  RegisterComponents('Bluetooth Framework Tools', [TBFBluetoothMassSender, TBFBluetoothAudio]);

  ////////////////////////////
  // FOR DEBUG ONLY. Comment our for release
  //
  // UNCOMMENT WHEN BUILD OCX VERSION
  //
  {
  RegisterComponents('Bluetooth Framework System_X', [_TBFAPIInfoX, _TBFAuthenticatorX]);
  RegisterComponents('Bluetooth Framework System_X', [_TBFBluetoothDiscoveryX, _TBFIrDADiscoveryX]);

  RegisterComponents('Bluetooth Framework Clients_X', [_TBFClientX, _TBFObjectPushClientX]);
  RegisterComponents('Bluetooth Framework Clients_X', [_TBFFileTransferClientX, _TBFSyncClientX]);
  RegisterComponents('Bluetooth Framework Clients_X', [_TBFPhoneBookClientX, _TBFSerialPortClientX]);
  RegisterComponents('Bluetooth Framework Clients_X', [_TBFGSMModemClientX, _TBFSerialEventsClientX]);
  RegisterComponents('Bluetooth Framework Clients_X', [_TBFBluetoothCOMPortCreatorX]);

  RegisterComponents('Bluetooth Framework Servers_X', [_TBFServerX, _TBFObjectPushServerX]);

  RegisterComponents('Bluetooth Framework Tools_X', [_TBFBluetoothMassSenderX, _TBFBluetoothAudioX]);
  }  
  ////////////
end;

end.
