object ForceConfirmForm: TForceConfirmForm
  Left = 240
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1058#1080#1087' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 92
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonSoft: TButton
    Left = 16
    Top = 16
    Width = 201
    Height = 25
    Caption = #1054#1073#1099#1095#1085#1099#1081' ('#1084#1103#1075#1082#1080#1081') '#1088#1077#1078#1080#1084
    ModalResult = 7
    TabOrder = 0
  end
  object ButtonHard: TButton
    Left = 16
    Top = 48
    Width = 201
    Height = 25
    Caption = #1060#1086#1088#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' ('#1078#1077#1089#1090#1082#1080#1081') '#1088#1077#1078#1080#1084
    ModalResult = 6
    TabOrder = 1
  end
end
