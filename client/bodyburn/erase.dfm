object EraseDiscForm: TEraseDiscForm
  Left = 239
  Top = 107
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 109
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 267
    Height = 109
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvSpace
    Caption = #1048#1076#1077#1090' '#1086#1095#1080#1089#1090#1082#1072' '#1076#1080#1089#1082#1072'. '#1055#1086#1076#1086#1078#1076#1080#1090#1077'...'
    TabOrder = 0
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 16
    Top = 16
  end
end
