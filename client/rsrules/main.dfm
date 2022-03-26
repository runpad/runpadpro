object RulesForm: TRulesForm
  Left = 292
  Top = 106
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 500
  ClientWidth = 665
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 440
    Width = 665
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 321
      Height = 55
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonAgree: TButton
        Left = 200
        Top = 16
        Width = 105
        Height = 25
        Caption = 'ButtonAgree'
        Default = True
        TabOrder = 0
        OnClick = ButtonAgreeClick
      end
    end
    object Panel4: TPanel
      Left = 344
      Top = 0
      Width = 321
      Height = 55
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonDecline: TButton
        Left = 16
        Top = 16
        Width = 105
        Height = 25
        Caption = 'ButtonDecline'
        TabOrder = 0
        OnClick = ButtonDeclineClick
      end
    end
  end
  object PanelHost: TPanel
    Left = 0
    Top = 0
    Width = 665
    Height = 440
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
  end
end
