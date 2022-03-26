object UserMessageForm: TUserMessageForm
  Left = 240
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1102
  ClientHeight = 146
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 16
    Top = 22
    Width = 32
    Height = 32
  end
  object Label1: TLabel
    Left = 72
    Top = 16
    Width = 313
    Height = 13
    AutoSize = False
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103':'
  end
  object Label2: TLabel
    Left = 72
    Top = 72
    Width = 217
    Height = 13
    AutoSize = False
    Caption = #1042#1088#1077#1084#1103' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1074' '#1089#1077#1082#1091#1085#1076#1072#1093':'
  end
  object ButtonOK: TButton
    Left = 229
    Top = 112
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 310
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object ComboBoxEx: TComboBoxEx
    Left = 72
    Top = 32
    Width = 313
    Height = 22
    ItemsEx = <>
    ItemHeight = 16
    TabOrder = 0
    DropDownCount = 10
  end
  object ComboBoxTime: TComboBox
    Left = 296
    Top = 68
    Width = 89
    Height = 21
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 1
  end
end
