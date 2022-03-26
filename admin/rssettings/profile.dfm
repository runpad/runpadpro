object ProfileForm: TProfileForm
  Left = 264
  Top = 110
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1087#1088#1086#1092#1080#1083#1103
  ClientHeight = 259
  ClientWidth = 274
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1092#1080#1083#1103':'
  end
  object Label2: TLabel
    Left = 8
    Top = 110
    Width = 132
    Height = 13
    Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1088#1086#1092#1080#1083#1103':'
  end
  object Label3: TLabel
    Left = 8
    Top = 160
    Width = 99
    Height = 13
    Caption = #1071#1079#1099#1082' '#1076#1083#1103' '#1087#1088#1086#1092#1080#1083#1103':'
  end
  object EditName: TEdit
    Left = 8
    Top = 24
    Width = 177
    Height = 21
    MaxLength = 250
    TabOrder = 0
  end
  object ComboBoxProfiles: TComboBox
    Left = 8
    Top = 75
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object ButtonOK: TButton
    Left = 110
    Top = 224
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 5
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 190
    Top = 224
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object CheckBoxUseBase: TCheckBox
    Left = 8
    Top = 56
    Width = 177
    Height = 17
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1072' '#1073#1072#1079#1077' '#1087#1088#1086#1092#1080#1083#1103':'
    TabOrder = 1
    OnClick = CheckBoxUseBaseClick
  end
  object ComboBoxMachineType: TComboBox
    Left = 8
    Top = 126
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      #1052#1072#1096#1080#1085#1072' '#1074' '#1080#1075#1088#1086#1074#1086#1084' '#1082#1083#1091#1073#1077
      #1052#1072#1096#1080#1085#1072' '#1074' '#1080#1085#1090#1077#1088#1085#1077#1090'-'#1082#1072#1092#1077
      #1054#1087#1077#1088#1072#1090#1086#1088#1089#1082#1072#1103' '#1084#1072#1096#1080#1085#1072
      #1052#1072#1096#1080#1085#1072' '#1074' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080'/'#1086#1092#1080#1089#1077
      #1058#1077#1088#1084#1080#1085#1072#1083#1100#1085#1099#1081' '#1089#1077#1088#1074#1077#1088
      #1044#1086#1084#1072#1096#1085#1080#1081' '#1082#1086#1084#1087#1100#1102#1090#1077#1088
      #1055#1088#1086#1095#1077#1077)
  end
  object ComboBoxLang: TComboBox
    Left = 8
    Top = 176
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      #1056#1091#1089#1089#1082#1080#1081
      'English'
      #1059#1082#1088#1072#1111#1085#1089#1100#1082#1072)
  end
end
