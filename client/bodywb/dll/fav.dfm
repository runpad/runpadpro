object FavForm: TFavForm
  Left = 256
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077'/'#1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1072#1081#1090#1072
  ClientHeight = 155
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  OnShow = FormShow
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1072#1081#1090#1072':'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 97
    Height = 13
    Caption = #1040#1076#1088#1077#1089' '#1089#1072#1081#1090#1072' (URL):'
  end
  object EditName: TEdit
    Left = 8
    Top = 24
    Width = 249
    Height = 21
    TabOrder = 0
  end
  object EditURL: TEdit
    Left = 8
    Top = 72
    Width = 249
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 120
    Width = 105
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 152
    Top = 120
    Width = 105
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
