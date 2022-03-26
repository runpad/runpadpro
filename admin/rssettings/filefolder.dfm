object FileFolderForm: TFileFolderForm
  Left = 257
  Top = 108
  BorderStyle = bsDialog
  ClientHeight = 95
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 321
    Height = 13
    AutoSize = False
    Caption = 'Label1'
  end
  object Edit1: TEdit
    Left = 8
    Top = 26
    Width = 257
    Height = 21
    MaxLength = 250
    TabOrder = 0
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 8
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 272
    Top = 26
    Width = 57
    Height = 21
    Caption = #1054#1073#1079#1086#1088' ...'
    TabOrder = 2
    OnClick = Button2Click
  end
end
