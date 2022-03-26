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
unit BFAbout;

{$I BF.inc}

interface

uses
  Forms, Classes, Controls, ExtCtrls, StdCtrls, Graphics, jpeg;

type
  TfmAbout = class(TForm)
    imLogo: TImage;
    beTop: TBevel;
    laTitle: TLabel;
    laCopyright: TLabel;
    beMiddle: TBevel;
    beBottom: TBevel;
    laURLTitle: TLabel;
    laURL: TLabel;
    laEMailTitle: TLabel;
    laEMail: TLabel;
    laICQTitle: TLabel;
    laMSNTitle: TLabel;
    laPhoneTitle: TLabel;
    btOK: TButton;
    laICQ: TLabel;
    laMSN: TLabel;
    laPhone: TLabel;
    laPhone2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure laURLClick(Sender: TObject);
    procedure laEMailClick(Sender: TObject);
  end;

const
  VERSION = '5.2.2';  

// Shows the About dialog.
procedure ShowAbout;

implementation

uses
  ShellAPI, Windows, BFAPI;

{$R *.dfm}

procedure ShowAbout;
begin
  with TfmAbout.Create(Application.MainForm) do begin
    ShowModal;
    Free;
  end;
end;

procedure TfmAbout.FormCreate(Sender: TObject);
begin
  laTitle.Caption := 'Bluetooth Framework';

  with laTitle do Caption := Caption + CRLF + 'Version ' + VERSION;

  {$IFDEF TRIAL}
  Caption := Caption + ' Demo';
  with laTitle do Caption := Caption + 'd' + CRLF + 'Demo ';
  {$ENDIF}
end;

procedure TfmAbout.laURLClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(laURL.Caption), nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.laEMailClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar('mailto:' + laEMail.Caption), nil, nil, SW_SHOWNORMAL);
end;

end.
