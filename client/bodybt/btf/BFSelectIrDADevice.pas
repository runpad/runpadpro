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
unit BFSelectIrDADevice;

{$I BF.inc}

interface

uses
  Forms, Classes, ImgList, Controls, ExtCtrls, StdCtrls, Graphics, ComCtrls;

type
  TfmSelectIrDADevice = class(TForm)
    ImageList: TImageList;
    ListView: TListView;
    laDevices: TLabel;
    laMainTitle: TLabel;
    laSubTitle: TLabel;
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
  BFDiscovery, BFAPI, SysUtils, BFStrings;

{$R *.dfm}

procedure TfmSelectIrDADevice.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  btOK.Enabled := Assigned(ListView.Selected);
end;

procedure TfmSelectIrDADevice.ListViewInfoTip(Sender: TObject; Item: TListItem; var InfoTip: String);
var
  ADevice: TBFIrDADevice;
begin
  // Shows hint with full device info.
  if Assigned(Item) then begin
    ADevice := TBFIrDADevice(Item.Data);

    // In theory it always assigned. But if something wrog?
    if Assigned(ADevice) then
      with ADevice do begin
        // Main device information.
        InfoTip := StrAddress + Address + CRLF +
                   StrName + Name + CRLF;
        // Extended device infotmation.
        InfoTip := InfoTip + '______________________________________' + CRLF +
                   StrCharSet + IntToHex(CharSet, 2) + CRLF +
                   StrHints + ' 1: 0x' + IntToHex(Hints1, 2) + CRLF +
                   StrHints + ' 2: 0x' + IntToHex(Hints2, 2);
      end

    else
      InfoTip := '';

  end else
    InfoTip := '';
end;

procedure TfmSelectIrDADevice.FormCreate(Sender: TObject);
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

procedure TfmSelectIrDADevice.FormDestroy(Sender: TObject);
begin
  if Tag <> 0 then TBFBluetoothDevices(Tag).Free;
end;

procedure TfmSelectIrDADevice.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := btCancel.Enabled;
end;

procedure TfmSelectIrDADevice.TimerTimer(Sender: TObject);
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

procedure TfmSelectIrDADevice.ListViewDblClick(Sender: TObject);
begin
  if btOK.Enabled then btOK.Click;
end;

end.
