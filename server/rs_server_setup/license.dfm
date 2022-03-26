object LicenseForm: TLicenseForm
  Left = 257
  Top = 108
  BorderStyle = bsDialog
  ClientHeight = 241
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo: TMemo
    Left = 0
    Top = 40
    Width = 322
    Height = 128
    MaxLength = 1000
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = MemoChange
  end
  object Button1: TButton
    Left = 8
    Top = 176
    Width = 121
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 208
    Width = 121
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 266
    Top = 208
    Width = 49
    Height = 25
    Caption = 'Button3'
    Default = True
    Enabled = False
    TabOrder = 3
    OnClick = Button3Click
  end
end
