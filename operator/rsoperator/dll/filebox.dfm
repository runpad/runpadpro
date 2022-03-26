object FileBoxForm: TFileBoxForm
  Left = 240
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 113
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
    Caption = 'Label1'
  end
  object ButtonOK: TButton
    Left = 229
    Top = 80
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 310
    Top = 80
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
    Width = 289
    Height = 22
    ItemsEx = <>
    ItemHeight = 16
    TabOrder = 0
    DropDownCount = 10
  end
  object ButtonSelectFile: TButton
    Left = 363
    Top = 32
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = ButtonSelectFileClick
  end
end
