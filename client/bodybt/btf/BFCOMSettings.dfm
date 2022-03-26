object fmCOMSettings: TfmCOMSettings
  Left = 275
  Top = 104
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' COM-'#1087#1086#1088#1090#1072
  ClientHeight = 285
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object shTop: TShape
    Left = 0
    Top = 0
    Width = 353
    Height = 46
    Pen.Style = psClear
  end
  object laTitle: TLabel
    Left = 10
    Top = 5
    Width = 134
    Height = 13
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' COM-'#1087#1086#1088#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object laAction: TLabel
    Left = 53
    Top = 25
    Width = 238
    Height = 13
    Caption = #1047#1076#1077#1089#1100' '#1084#1086#1078#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' COM-'#1087#1086#1088#1090#1072':'
    Transparent = True
  end
  object laBaudRate: TLabel
    Left = 28
    Top = 60
    Width = 48
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100
  end
  object laByteSize: TLabel
    Left = 28
    Top = 88
    Width = 72
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1088' '#1089#1083#1086#1074#1072
  end
  object laHardwareHandshake: TLabel
    Left = 28
    Top = 116
    Width = 80
    Height = 13
    Caption = #1040#1087#1087#1072#1088#1072#1090#1085#1099#1081' HS'
  end
  object laParity: TLabel
    Left = 28
    Top = 144
    Width = 48
    Height = 13
    Caption = #1063#1077#1090#1085#1086#1089#1090#1100
  end
  object laSoftwareHandshake: TLabel
    Left = 28
    Top = 172
    Width = 91
    Height = 13
    Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1085#1099#1081' HS'
  end
  object laStopBits: TLabel
    Left = 28
    Top = 200
    Width = 78
    Height = 13
    Caption = #1057#1090#1086#1087#1086#1074#1099#1077' '#1073#1080#1090#1099
  end
  object Bevel: TBevel
    Left = 12
    Top = 228
    Width = 325
    Height = 9
    Shape = bsTopLine
  end
  object cbBaudRate: TComboBox
    Left = 144
    Top = 56
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      '110'
      '300'
      '600'
      '1200'
      '2400'
      '4800'
      '9600'
      '14400'
      '19200'
      '38400'
      '56000'
      '57600'
      '115200'
      '128000'
      '256000')
  end
  object cbByteSize: TComboBox
    Left = 144
    Top = 84
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      '4'
      '5'
      '6'
      '7'
      '8')
  end
  object cbHardwareHandshake: TComboBox
    Left = 144
    Top = 112
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'None'
      'RTS/CTS')
  end
  object cbParity: TComboBox
    Left = 144
    Top = 140
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'None'
      'Odd'
      'Even'
      'Mark'
      'Space')
  end
  object cbSoftwareHandshake: TComboBox
    Left = 144
    Top = 168
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'None'
      'XON/XOFF')
  end
  object cbStopBits: TComboBox
    Left = 144
    Top = 196
    Width = 117
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      '1'
      '1.5'
      '2')
  end
  object btOK: TButton
    Left = 168
    Top = 244
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object btCancel: TButton
    Left = 252
    Top = 244
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
end
