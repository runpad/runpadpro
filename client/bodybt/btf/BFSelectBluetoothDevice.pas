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
unit BFSelectBluetoothDevice;

{$I BF.inc}

interface

uses
  Forms, Classes, ImgList, Controls, ExtCtrls, StdCtrls, Graphics, ComCtrls;

type
  TfmSelectBluetoothDevice = class(TForm)
    ImageList: TImageList;
    ListView: TListView;
    laDevices: TLabel;
    laSubTitle: TLabel;
    laMainTitle: TLabel;
    Image: TImage;
    shTop: TShape;
    btOK: TButton;
    btCancel: TButton;
    stWait: TStaticText;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    
    procedure ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
  end;

implementation

uses
  BFDiscovery, BFAPI, SysUtils, BFStrings, BFD5Support{$IFDEF DELPHI5}, ComObj{$ENDIF};

{$R *.dfm}

procedure TfmSelectBluetoothDevice.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btOK.Enabled := Assigned(ListView.Selected);
end;

procedure TfmSelectBluetoothDevice.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
var
  ADevice: TBFBluetoothDevice;
  Loop: Integer;
begin
  // Shows hint with full device info.
  if Assigned(Item) then begin
    ADevice := TBFBluetoothDevice(Item.Data);

    // In theory it always assigned. But if something wrog?
    if Assigned(ADevice) then
      with ADevice do begin
        // Main device information.
        InfoTip := StrAddress + Address + CRLF +
                   StrName + Name + CRLF;

        // Extended device infotmation.
        InfoTip := InfoTip + '______________________________________' + CRLF +
                   StrAuthenticated + BFBoolToStr(Authenticated) + CRLF +
                   StrConnected + BFBoolToStr(Connected) + CRLF +
                   StrRemembered + BFBoolToStr(Remembered) + CRLF +
                   StrClassOfDevice + IntToHex(ClassOfDevice, 8) + CRLF +
                   StrClassOfDeviceName + ClassOfDeviceName + CRLF;
        // Never ask me why here is exception!!!
        // RTFM!!!
        try
          if LastSeen <> 0 then
            InfoTip := InfoTip + Format(StrLastSeen, [DateTimeToStr(LastSeen)]) + CRLF
          else
            InfoTip := InfoTip + Format(StrLastSeen, ['<' + StrUnknown + '>']) + CRLF;
        except
          InfoTip := InfoTip + Format(StrLastSeen, ['<' + StrUnknown + '>']) + CRLF;
        end;
        try
          if LastUsed <> 0 then
            InfoTip := InfoTip + Format(StrLastUsed, [DateTimeToStr(LastUsed)]) + CRLF
          else
            InfoTip := InfoTip + Format(StrLastUsed, ['<' + StrUnknown + '>']) + CRLF;
        except
          InfoTip := InfoTip + Format(StrLastUsed, ['<' + StrUnknown + '>']) + CRLF;
        end;

        // Radio
        InfoTip := InfoTip + '______________________________________' + CRLF;
        InfoTip := InfoTip + Format(StrRadioName, [Radio.Name]) + CRLF;
        InfoTip := InfoTip + Format(StrRadioAddress, [Radio.Address]) + CRLF;
        case Radio.BluetoothAPI of
          baBlueSoleil: InfoTip := InfoTip + Format(StrRadioAPI, ['BlueSoleil']) + CRLF;
          baWinSock: InfoTip := InfoTip + Format(StrRadioAPI, ['Microsoft']) + CRLF;
          baWidComm: InfoTip := InfoTip + Format(StrRadioAPI, ['WidComm']) + CRLF;
          baToshiba: InfoTip := InfoTip + Format(StrRadioAPI, ['Toshiba']) + CRLF;
        end;

        // Services.
        InfoTip := InfoTip + '______________________________________' + CRLF;
        if Services.Count > 0 then begin
          InfoTip := InfoTip + StrServices + CRLF;

          for Loop := 0 to Services.Count - 1 do begin
            InfoTip := InfoTip + '  ' + Services[Loop].Name;
            if Services[Loop].Comment <> '' then InfoTip := InfoTip + ' (' + Services[Loop].Comment + ')';
            InfoTip := InfoTip + CRLF + '   ' + GUIDToString(Services[Loop].UUID) + '  [' + IntToStr(Services[Loop].Channel) + ']';
            if Loop <> Services.Count - 1 then InfoTip := InfoTip + CRLF;
          end;

        end else
          InfoTip := InfoTip + StrServicesNotFound;
      end

    else
      InfoTip := '';

  end else
    InfoTip := '';
end;

procedure TfmSelectBluetoothDevice.FormCreate(Sender: TObject);
begin
  with stWait do begin
    Parent := ListView;
    Left := Round((ListView.Width - Width) / 2);
    Top := Round((ListView.Height - Height) / 2) - 50;
  end;

  with ProgressBar do begin
    Parent := ListView;
    Left := Round((ListView.Width - Width) / 2);
    Top := Round((ListView.Height - Height) / 2) - 20;
  end;
end;

procedure TfmSelectBluetoothDevice.FormDestroy(Sender: TObject);
begin
  if Tag <> 0 then TBFBluetoothDevices(Tag).Free;
end;

procedure TfmSelectBluetoothDevice.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btCancel.Enabled;
end;

procedure TfmSelectBluetoothDevice.TimerTimer(Sender: TObject);
begin
  with ProgressBar do
    if Visible then
      if Position + 1 > 100 then
        Position := 0

      else
        Position := Position + 1

    else
      Timer.Enabled := False;
end;

procedure TfmSelectBluetoothDevice.ListViewDblClick(Sender: TObject);
begin
  if btOK.Enabled then btOK.Click;
end;

end.
