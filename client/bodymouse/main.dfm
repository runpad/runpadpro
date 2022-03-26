object BodyMouseForm: TBodyMouseForm
  Left = 321
  Top = 106
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1084#1099#1096#1080
  ClientHeight = 265
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 225
    Width = 32
    Height = 32
  end
  object ButtonOK: TButton
    Left = 189
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 270
    Top = 232
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = ButtonCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 337
    Height = 64
    Caption = ' '#1057#1082#1086#1088#1086#1089#1090#1100' '
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 27
      Width = 21
      Height = 13
      Caption = #1052#1080#1085
    end
    object Label2: TLabel
      Left = 214
      Top = 27
      Width = 27
      Height = 13
      Caption = #1052#1072#1082#1089
    end
    object TrackBar: TTrackBar
      Left = 37
      Top = 24
      Width = 174
      Height = 33
      PageSize = 1
      Position = 10
      TabOrder = 0
      TabStop = False
      ThumbLength = 17
      OnChange = TrackBarChange
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 81
    Width = 337
    Height = 64
    Caption = ' '#1040#1082#1089#1077#1083#1077#1088#1072#1094#1080#1103' ('#1091#1089#1082#1086#1088#1077#1085#1080#1077') '
    Columns = 2
    Items.Strings = (
      #1053#1077#1090
      #1053#1080#1079#1082#1072#1103
      #1057#1088#1077#1076#1085#1103#1103
      #1042#1099#1089#1086#1082#1072#1103)
    TabOrder = 3
    OnClick = RadioGroup1Click
  end
  object ButtonFixOn: TButton
    Left = 8
    Top = 160
    Width = 337
    Height = 21
    Caption = #1058#1086#1085#1082#1072#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1072' '#1095#1091#1074#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086#1089#1090#1080' (MouseFix) - '#1074#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 4
    OnClick = ButtonFixOnClick
  end
  object ButtonFixOff: TButton
    Left = 8
    Top = 184
    Width = 337
    Height = 21
    Caption = #1058#1086#1085#1082#1072#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1072' '#1095#1091#1074#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086#1089#1090#1080' (MouseFix) - '#1086#1090#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 5
    OnClick = ButtonFixOffClick
  end
  object XPManifest1: TXPManifest
    Left = 320
    Top = 8
  end
end
