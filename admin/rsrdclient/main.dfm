object RDForm: TRDForm
  Left = 267
  Top = 107
  Width = 745
  Height = 561
  HorzScrollBar.Smooth = True
  HorzScrollBar.Tracking = True
  VertScrollBar.Smooth = True
  VertScrollBar.Tracking = True
  Caption = '('#1050#1083#1072#1074#1080#1096#1072' "PAUSE" - '#1084#1077#1085#1102')'
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox: TPaintBox
    Left = 0
    Top = 0
    Width = 632
    Height = 453
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnPaint = PaintBoxPaint
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 32
    Top = 8
    object MenuScreenGray: TMenuItem
      Caption = #1054#1090#1090#1077#1085#1082#1080' '#1089#1077#1088#1086#1075#1086' (7-'#1073#1080#1090')'
      OnClick = MenuScreenGrayClick
    end
    object MenuScreenColor: TMenuItem
      Caption = #1062#1074#1077#1090' (7-'#1073#1080#1090')'
      OnClick = MenuScreenColorClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuFPS: TMenuItem
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103
    end
    object MenuFullscreen: TMenuItem
      Caption = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      OnClick = MenuFullscreenClick
    end
    object MenuSpectator: TMenuItem
      Caption = #1056#1077#1078#1080#1084' '#1085#1072#1073#1083#1102#1076#1072#1090#1077#1083#1103
      OnClick = MenuSpectatorClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnClick = N3Click
    end
  end
  object XPManifest1: TXPManifest
    Left = 64
    Top = 8
  end
end
