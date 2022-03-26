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
unit BFControls;

{$I BF.inc}

interface

uses
  BFBase, ExtCtrls, Classes;

type
  // TBFCharge is the visual control which draws battery charge level indicator.
  TBFCharge = class(TBFBaseControl)
  private
    FFlashLevel: Byte;
    FLevel: Byte;
    FShow: Boolean;
    FTimer: TTimer;

    function GetFlash: Boolean;
    function GetFlashInterval: Integer;

    procedure SetFlash(const Value: Boolean);
    procedure SetFlashInterval(const Value: Integer);
    procedure SetFlashLevel(const Value: Byte);
    procedure SetLevel(const Value: Byte);
    procedure TimerTimer(Sender: TObject);

  protected
    // Paints the control.
    procedure Paint; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;
    // Default destructor.
    destructor Destroy; override;

  published
    // Allow control flashing when Level < FlashLevel.
    property Flash: Boolean read GetFlash write SetFlash default False;
    // Flashing interval in milliseconds.
    property FlashInterval: Integer read GetFlashInterval write SetFlashInterval default 250;
    // Level when control starts flashing in percents. Must be between 0 and
    // 100.
    property FlashLevel: Byte read FFlashLevel write SetFlashLevel default 10;
    // Battery charge level in percents. Must be between 0 and 100.
    property Level: Byte read FLevel write SetLevel default 0;
    // Inherited Visible property.
    property Visible;
  end;

  // Draws netwrok signal level indicator.
  TBFSignal = class(TBFBaseControl)
  private
    FLevel: Byte;

    procedure SetLevel(const Value: Byte);

  protected
    // Draws the control.
    procedure Paint; override;

  public
    // Default constructor.
    constructor Create(AOwner: TComponent); override;

  published
    // Network signal level. Values means:
    //   Value       Reception level
    //   ----------------------------
    //     0         -113 dBm or less
    //     1         -111 dBm
    //     2 - 30    -109 to -53 dBm
    //     31        -51 dBm or more
    //     99        Unknown
    property Level: Byte read FLevel write SetLevel default 0;
    // Inherited Visible property.
    property Visible;
  end;

implementation

uses
  SysUtils, Forms, Controls, Graphics, BFStrings;

{ TBFCharge }

constructor TBFCharge.Create(AOwner: TComponent);
begin
  inherited;

  // Sets default width and height.
  Height := 12;
  Width := 66;

  // Initialize class members.
  FFlashLevel := 10;
  FLevel := 0;
  FShow := True;
  FTimer := TTimer.Create(nil);
  with FTimer do begin
    Interval := 250;
    Enabled := False;
    OnTimer := TimerTimer;
  end;
end;

destructor TBFCharge.Destroy;
begin
  // Destrys internal timer.
  FTimer.Free;

  inherited;
end;

function TBFCharge.GetFlash: Boolean;
begin
  Result := FTimer.Enabled;
end;

function TBFCharge.GetFlashInterval: Integer;
begin
  Result := FTimer.Interval;
end;

procedure TBFCharge.Paint;
var
  AWidth: Integer;
  AColor: TColor;
begin
  inherited;

 // Do not draw if not visible. 
  if not Visible then Exit;

  // Draws the control.
  with Canvas do begin
    Brush.Color := $F0F0F0;
    with Pen do begin
      Color := $000000;
      Width := 1;
    end;

    // External rectangle.
    FillRect(Rect(0, 0, Width, Height));
    Rectangle(0, 0, Width, Height);

    // If flashig then check should we draw internal part of the control or no.
    if FShow or (FLevel > FFlashLevel) then begin
      // Battery rectangle.
      Rectangle(6, 2, Width - 10 , Height - 2);
      Rectangle(Width - 8, 4, Width - 7, Height - 4);
      Brush.Color := $000000;
      FillRect(Rect(Width - 9, 4, Width - 7, Height - 4));

      // Determine which color use for drawing. Depended of the change level.
      if FLevel > 0 then begin
        if FLevel < 25 then
          AColor := clRed
        else
          if FLevel < 50 then
            AColor := clMaroon
          else
            if FLevel < 75 then
              AColor := clNavy
            else
              AColor := clGreen;

        // Sets a colors for drawing level indicator.
        Brush.Color := AColor;
        Pen.Color := AColor;

        // Draws level indicator.
        AWidth := Round((Width - 22) * FLevel / 100);
        Rectangle(9, 4, AWidth + 9, Height - 4);
        FillRect(Rect(9, 4, AWidth + 9, Height - 4));
      end;
    end;
  end;
end;

procedure TBFCharge.SetFlash(const Value: Boolean);
begin
  FTimer.Enabled := Value;
  if not Value then begin
    FShow := True;
    Invalidate;
  end;
end;

procedure TBFCharge.SetFlashInterval(const Value: Integer);
begin
  FTimer.Interval := Value;
end;

procedure TBFCharge.SetFlashLevel(const Value: Byte);
begin
  if Value <> FFlashLevel then begin
    if Value > 100 then raise Exception.Create(StrValueMustBeBetween0100);
    FFlashLevel := Value;
    Invalidate;
  end;
end;

procedure TBFCharge.SetLevel(const Value: Byte);
begin
  if Value <> FLevel then begin
    if Value > 100 then raise Exception.Create(StrValueMustBeBetween0100);
    FLevel := Value;
    Invalidate;
  end;
end;

procedure TBFCharge.TimerTimer(Sender: TObject);
begin
  FShow := not FShow;
  Invalidate;
end;

{ TBFSignal }

constructor TBFSignal.Create(AOwner: TComponent);
begin
  inherited;

  // Sets width and height.
  Height := 12;
  Width := 66;

  // Initialize class members.
  FLevel := 0;
end;

procedure TBFSignal.Paint;
var
  Len: Integer;
  Percent: Integer;
  AColor: TColor;
  H: Integer;
  Cnt: Integer;
  Loop: Integer;
begin
  inherited;

  // Do not draw if not visible.
  if not Visible then Exit;

  // Draws the control.
  with Canvas do begin
    Brush.Color := $F0F0F0;
    with Pen do begin
      Color := $000000;
      Width := 1;
    end;

    // External rectangle.
    FillRect(Rect(0, 0, Width, Height));
    Rectangle(0, 0, Width, Height);

    if FLevel > 0 then begin
      // Calculate the indicator length.
      Percent := Round(100 * FLevel / 31);
      Len := Round((Width - 6) * Percent / 100);

      // Determine which color we should use for drawing the control.
      if Percent < 25 then
        AColor := clRed
      else
        if Percent < 50 then
          AColor := clMaroon
        else
          if Percent < 75 then
            AColor := clNavy
          else
            AColor := clGreen;

      // Sets a colors.
      Brush.Color := AColor;
      Pen.Color := AColor;

      // Draws indicator.
      H := Round((Height - 3) / 3);
      Cnt := Round(Len / 3);
      for Loop := 0 to Cnt - 1 do begin
        Rectangle(3 + Loop * 3, 2, 3 + Loop * 3 + 2, 2 + H - 1);
        FillRect(Rect(3 + Loop * 3, 2, 3 + Loop * 3 + 2, 2 + H - 1));

        if Loop - 2 >= 0 then begin
          Rectangle(3 + (Loop - 2) * 3, 2 + H, 3 + (Loop - 2) * 3 + 2, 2 + H * 2 - 1);
          FillRect(Rect(3 + (Loop - 2) * 3, 2 + H, 3 + (Loop - 2) * 3 + 2, 2 + H * 2 - 1));

          if Loop - 4 >= 0 then begin
            Rectangle(3 + (Loop - 4) * 3, 2 + H * 2, 3 + (Loop - 4) * 3 + 2, 2 + H * 3 - 1);
            FillRect(Rect(3 + (Loop - 4) * 3, 2 + H * 2, 3 + (Loop - 4) * 3 + 2, 2 + H * 3 - 1));
          end;
        end;
      end;
    end;
  end;
end;

procedure TBFSignal.SetLevel(const Value: Byte);
begin
  if Value <> FLevel then begin
    if (Value > 31) and (Value <> 99) then raise Exception.Create(StrInvalidPropertyValue);
    if Value = 99 then
      FLevel := 0
    else
      FLevel := Value;
    Invalidate;
  end;
end;

end.
