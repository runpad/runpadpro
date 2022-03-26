object RuleForm: TRuleForm
  Left = 265
  Top = 111
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077'/'#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1072#1074#1080#1083#1072
  ClientHeight = 249
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 61
    Height = 16
    Caption = #1055#1088#1072#1074#1080#1083#1086':'
  end
  object Label2: TLabel
    Left = 10
    Top = 69
    Width = 127
    Height = 16
    Caption = #1055#1088#1086#1092#1080#1083#1100' '#1085#1072#1089#1090#1088#1086#1077#1082':'
  end
  object Label3: TLabel
    Left = 10
    Top = 128
    Width = 127
    Height = 16
    Caption = #1055#1088#1086#1092#1080#1083#1100' '#1082#1086#1085#1090#1077#1085#1090#1072':'
  end
  object EditRule: TEdit
    Left = 10
    Top = 30
    Width = 474
    Height = 21
    MaxLength = 1000
    TabOrder = 0
  end
  object ComboBoxVars: TComboBox
    Left = 10
    Top = 89
    Width = 218
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
  end
  object ComboBoxCnt: TComboBox
    Left = 10
    Top = 148
    Width = 218
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 2
  end
  object ButtonOK: TButton
    Left = 293
    Top = 207
    Width = 92
    Height = 31
    Caption = #1054#1050
    Default = True
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 391
    Top = 207
    Width = 93
    Height = 31
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
end
