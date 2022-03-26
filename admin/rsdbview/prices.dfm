object PricesForm: TPricesForm
  Left = 268
  Top = 106
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1090#1072#1088#1080#1092#1086#1074' '#1087#1086' '#1091#1089#1083#1091#1075#1072#1084
  ClientHeight = 341
  ClientWidth = 703
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 703
    Height = 341
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clAppWorkSpace
    TabOrder = 0
    object StringGrid: TStringGrid
      Left = 2
      Top = 2
      Width = 699
      Height = 337
      Align = alClient
      Ctl3D = False
      DefaultRowHeight = 18
      FixedCols = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs]
      ParentCtl3D = False
      TabOrder = 0
      OnSetEditText = StringGridSetEditText
    end
  end
end
