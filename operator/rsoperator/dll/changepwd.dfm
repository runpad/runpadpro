object ChangePwdForm: TChangePwdForm
  Left = 244
  Top = 113
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103' '#1074#1093#1086#1076#1072' '#1074' '#1073#1072#1079#1091
  ClientHeight = 169
  ClientWidth = 277
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 80
    Height = 13
    Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100':'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 113
    Height = 13
    Caption = #1053#1086#1074#1099#1081' ('#1053#1045' '#1055#1059#1057#1058#1054#1049'!):'
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 57
    Height = 13
    Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1100':'
  end
  object Image1: TImage
    Left = 16
    Top = 128
    Width = 32
    Height = 32
  end
  object ButtonOK: TButton
    Left = 112
    Top = 136
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 192
    Top = 136
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object EditOldPwd: TEdit
    Left = 144
    Top = 19
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object EditNewPwd: TEdit
    Left = 144
    Top = 59
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object EditNewPwd2: TEdit
    Left = 144
    Top = 83
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
  end
end
