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
unit BFStrings;

{$I BF.inc}

interface

resourcestring
  // BTSTATUS_STRINGS
  StrBTStatusStringGeneralFail = 'General failure.';
  StrBTStatusStringGeneralSuccess = 'General success.';
  StrBTStatusStringSystemError = 'System Error.';
  StrBTStatusStringBluetoothNotReady = 'Bluetooth Not Ready.';
  StrBTStatusStringBlusoleilAlreadyPaired = 'BlueSoleil is already paired with the device.';
  StrBTStatusStringAuthenticationFails = 'Authentication failed.';
  StrBTStatusStringBluetoothBusy = 'Bluetooth is busy with browsing services or connecting to a device.';
  StrBTStatusStringConnectionExists = 'The connection to the service is already established.';
  StrBTStatusStringConnectionNotExists = 'The connection does not exist or is released.';
  StrBTStatusStringParameterError = 'Parameter Error.';
  StrBTStatusStringServiceNotExists = 'Service does not Exists.';
  StrBTStatusStringDeviceNotExists = 'Device does not Exists.';

  // UUID_STRINGS_ARRAY
  StrServiceDiscoveryServer = 'Service Discovery Server';
  StrBrowseGroupDescriptor = 'Browse Group Descriptor';
  StrPublicBrowseGroup = 'Public Browse Group';
  StrSerialPort = 'Serial Port';
  StrLANAccessUsingPPP = 'LAN Access Using PPP';
  StrDialupNetworking = 'Dial-up Networking';
  StrIrMCSync = 'IrMC Sync';
  StrOBEXObjectPush = 'OBEX Object Push';
  StrOBEXFileTransfer = 'OBEX File Transfer';
  StrIrMCSyncCommand = 'IrMC Sync Command';
  StrHeadset = 'Headset';
  StrCordlessTelephony = 'Cordless Telephony';
  StrAudioSource = 'Audio Source';
  StrAudioSink = 'Audio Sink';
  StrAVRemoteControlTarget = 'AV Remote Control Target';
  StrAdvancedAudioDistribution = 'Advanced Audio Distribution';
  StrAVRemoteControl = 'AV Remote Control';
  StrVideoConferencing = 'Video Conferencing';
  StrIntercom = 'Intercom';
  StrFax = 'Fax';
  StrHeadsetAudioGateway = 'Headset Audio Gateway';
  StrWAP = 'WAP';
  StrWAPClient = 'WAP Client';
  StrPANU = 'PANU';
  StrNAP = 'NAP';
  StrGN = 'GN';
  StrDirectPrinting = 'Direct Printing';
  StrReferencePrinting = 'Reference Printing';
  StrImaging = 'Imaging';
  StrImagingResponder = 'Imaging Responder';
  StrImagingAutomaticArchive = 'Imaging Automatic Archive';
  StrImagingReferenceObjects = 'Imaging Reference Objects';
  StrHandsfree = 'Hands Free';
  StrHandsfreeAudioGateway = 'Hands Free Audio Gateway';
  StrDirectPrintingReferenceObjects = 'Direct Printing Reference Objects';
  StrReflectedUI = 'Reflected UI';
  StrBasicPringing = 'Basic Printing';
  StrPrintingStatus = 'Printing Status';
  StrHumanInterfaceDevice = 'Human Interface Device';
  StrHardcopyCableReplacement = 'Hardcopy Cable Replacement';
  StrHCRPrint = 'HCR Print';
  StrHCRScan = 'HCR Scan';
  StrCommonISDNAccess = 'Common ISDN Access';
  StrVideoConferencingGW = 'Video Conferencing GW';
  StrUDIMT = 'UDIMT';
  StrUDITA = 'UDITA';
  StrAudioVideo = 'Audio Video';
  StrSIMAccess = 'SIM Access';
  StrPnPInformation = 'PnP Information';
  StrGenericNetworking = 'Generic Networking';
  StrGenericFileTransfer = 'Generic File Transfer';
  StrGenericAudio = 'Generic Audio';
  StrGenericTelephony = 'Generic Telephony';
  StrNokiaOBEXPCSuite = 'Nokia OBEX PC Suite';
  StrSyncMLClient = 'SyncML Client';

  StrInvalidAddressFormat = 'Invalid %s address format.';
  StrTransportNotAvailable = '%s transport not available.';
  StrBluetooth = 'Bluetooth';
  StrIrDA = 'IrDA';
  StrCOM = 'COM port';

  StrUnknown = 'Unknown';

  StrErrorExecutingATCommand = 'Error executing AT command.' + #$0A#$0D + #$0A#$0D + '%s';

  StrNotSupportedByCurrentBluetoothAPI = 'Not supported by the current Bluetooth API.';
  StrUnablePairingWithDevice = 'Unable pairing with device.';
  StrOnlyOneAuthenticatorInstance = 'Only one instance of the active Authenticator allowed.';

  StrInvalidPortNumber = 'Invalid port number.';
  StrRemoteDeviceNotFound = 'Remote device not found or not connected.';
  StrUnableCreateCOMPort = 'Unable create COM port association.';
  StrClientConnected = 'Client already connected.';
  StrClientNotConnected = 'Client not connected.';
  StrBufferSizeInvalid = 'Buffer size must be great then 0.';
  StrServiceNotFound = 'Specified service not found.';

  StrValueMustBeBetween0100 = 'Value must be between 0 and 100.';
  StrInvalidPropertyValue = 'Invalid property value.';

  StrCanNotUpdateDeviceRecord = 'Can not update device record.';
  StrUnableToSetLocalRadioName = 'Unable to set local radio name.';
  StrUnableToReadLocalRadioInfo = 'Unable to retrieve local radio information.';

  StrInvalidDirectory = 'Invalid directory.';
  StrFileNotFound = 'File not found.';

  StrFeatureNotSupported = 'Feature not supported by the connected device.';

  StrErrorInitializeOBEXSession = 'Error initializing OBEX session. %s';
  StrInvalidPacketSize = 'Packet size must be great then 0.';

  StrTransportNotSupported = 'Transport not supported.';
  StrCanNotCreateServer = 'Can not create server.';
  StrServerActive = 'Server already active.';
  StrNoClientConnection = 'No client connections.';
  StrComPortTransportNotSupported = 'COM transport not supported.';

  StrInvalidPhoneNumber = 'Invalid phone number.';
  StrSMSTextRequire = 'SMS text required.';
  StrInvalidSMSType = 'Invalid SMS type.';
  StrPhoneNumberRequired = 'Phone number required.';

  StrObjectReadOnly = 'Object is read-only.';

  StrAddress = 'Address: ';
  StrName = 'Name: ';
  StrAuthenticated = 'Authenticated: ';
  StrConnected = 'Connected: ';
  StrRemembered = 'Remembered: ';
  StrClassOfDevice = 'ClassOfDevice: 0x';
  StrClassOfDeviceName = 'ClassOfDevice Name: ';
  StrLastSeen = 'Last seen: %s';
  StrLastUsed = 'Last used: %s';

  StrServices = 'SERVICES:';
  StrServicesNotFound = '<No services found.>';

  StrTransport = 'Класс: %s';
  StrDeviceAddress = 'Адрес: %s ';
  StrQuickSearch = 'Быстрый поиск: ';
  StrCOMPortNumber = 'COM-порт: ';
  StrNext = 'Далее >>';
  StrFinish = 'Готово';
  StrCharSet = 'CharSet: 0x';
  StrHints = 'Hints';

  // Class of device
  StrCODUnclissified = 'Unclassified';

  StrCODComputer = 'Computer %s';
  StrCODComputerDesktop = 'Desktop';
  StrCODComputerServer = 'Server';
  StrCODComputerLapTop = 'Laptop';
  StrCODComputerHanddeld = 'Handheld';
  StrCODComputerPalmSized = 'Palm Sized';
  StrCODComputerWearable = 'Wearable';

  StrCODPhone = 'Phone %s';
  StrCODPhoneCellurar = 'Cellular';
  StrCODPhoneCordless = 'Cordless';
  StrCODPhoneSmartphone = 'Smartphone';
  StrCODPhoneWiredmodem = 'Wired Modem';
  StrCODPhoneCommonISDNAccess = 'Common ISDN Access';
  StrCODPhoneSIMCatdReader = 'SIM Card Reader';

  StrCODLAP = 'LAP %s';
  StrCODLAPFull = 'Full';
  StrCODLAP17 = '17';
  StrCODLAP33 = '33';
  StrCODLAP50 = '50';
  StrCODLAP67 = '67';
  StrCODLAP83 = '83';
  StrCODLAP99 = '99';
  StrCODLAPNoSrv = 'No Service';

  StrCODAV = 'AV %s';
  StrCODAVHeadset = 'Headset';
  StrCODAVHandsFree = 'Hands Free';
  StrCODAVHeadAndHand = 'Head and Hand';
  StrCODAVMicrophone = 'Microphone';
  StrCODAVLoudspeaker = 'Loudspeaker';
  StrCODAVHeadphones = 'Headphones';
  StrCODAVPortableAudio = 'Portable Audio';
  StrCODAVCarAudio = 'Car Audio';
  StrCODAVSetTopBox = 'Set Top Box';
  StrCODAVHiFiAudio = 'HiFi Audio';
  StrCODAVVCR = 'VCR';
  StrCODAVVideoCamera = 'Video Camera';
  StrCODAVCamCoder = 'CamCoder';
  StrCODAVVideoMonitor = 'Video Monitor';
  StrCODAVVideoDispAndLoudSpk = 'Video Display and Loudspeaker';
  StrCODAVVideoConference = 'Video Conference';
  StrCODAVGameOrToy = 'Game or Toy';

  StrCODPeripheral = 'Peripheral %s';
  StrCODPeripheralKeyborad = 'Keyboard';
  StrCODPeripheralPoint = 'Point';
  StrCODPeripheralKeyOrPoint = 'Key or Point';
  StrCODPeripheralJoystick = 'Joystick';
  StrCODPeripheralGamepad = 'GamePad';
  StrCODPeripheralRemControl = 'Remote Control';
  StrCODPeripheralSense = 'Sense';

  StrCODImage = 'Image %s';
  StrCODImageDisplay = 'Display';
  StrCODImageCamera = 'Camera';
  StrCODImageScanner = 'Scanner';
  StrCODImagePrinter = 'Printer';

  StrCODUnknown = '<%s> device class';

  StrDeviceNameUnknown = '<Without name>';

  StrTrue = 'Да';
  StrFalse = 'Нет';

  StrStackUnsupported = '%s Bluetooth stack unsupported';
  StrToshiba = 'Toshiba';

  StrMSStackUnsupported = 'Microsoft Bluetooth stack not supported.';

  StrLocalRadioNotFounded = 'Local radio module not founded.';
  StrCantMakeDiscoverable = 'Can not make local radio discoverable.';

  StrSignalPowerDetectError = 'Error while detecting signal power.';

  StrSMSNotSupported = 'This device did not support SMS commands.';
  StrSMSMassSendingStarted = 'Mass sending started';
  StrSMSMassSendingNotStarted = 'Mass sending not started';

  StrUnknowPhonebook = 'Phonebook unknown';

  StrInvalidInterval = 'Interval should be great then 0.';
  StrBTUnavailable = 'Bluetooth transport unavailable.';
  StrMSStackUnavailable = 'Microsoft Bluetooth stack unavailable.';

  StrCantMakeConnactable = 'Can not make local radio connectable.';

  StrNonBlockingStarted = 'Non blocking discovery already started.';

  StrMSPortCreateError = 'Error creating COM port.';

  StrUnableChangeRadioName = 'Unable change local radio name.';
  StrRadioRequired = 'Вы должны сделать поиск устройств';
  StrRadioName = 'Radio name: %s';
  StrRadioAddress = 'Radio address: %s';
  StrRadioAPI = 'Radio driver: %s';
  StrMassSednerActive = 'Bluetooth MassSender is active.';
  StrMSApiReq = 'Microsoft Bluetooth API required for sending radio.';
  StrDiscoveryRadioReq = 'Discovery radio not specified.';
  StrSendRadioReq = 'Send radio not specified.';
  StrMemoryAllocationFailed = 'Memory allocation failed.';

  StrActiveSyncAlreadyActive = 'ActiveSync already in use.';
  StrActiveSyncUnavailable = 'ActiveSync unavailable.';
  StrActiveSyncConnect = 'Selected transport: ActiveSync.';

implementation

end.
