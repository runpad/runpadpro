object WOLForm: TWOLForm
  Left = 240
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1042#1082#1083#1102#1095#1077#1085#1080#1077' '#1084#1072#1096#1080#1085' (Wakeup On LAN)'
  ClientHeight = 522
  ClientWidth = 602
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 231
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1084#1072#1096#1080#1085#1099' '#1080#1079' '#1089#1087#1080#1089#1082#1072' '#1076#1083#1103' '#1074#1082#1083#1102#1095#1077#1085#1080#1103':'
  end
  object Image1: TImage
    Left = 8
    Top = 481
    Width = 32
    Height = 32
  end
  object Label2: TLabel
    Left = 8
    Top = 424
    Width = 585
    Height = 33
    AutoSize = False
    Caption = 
      #1042#1085#1080#1084#1072#1085#1080#1077'! '#1044#1083#1103' '#1090#1086#1075#1086', '#1095#1090#1086#1073#1099' '#1088#1072#1073#1086#1090#1072#1083#1086' '#1091#1076#1072#1083#1077#1085#1085#1086#1077' '#1074#1082#1083#1102#1095#1077#1085#1080#1077' '#1084#1072#1096#1080#1085' '#1085#1077#1086 +
      #1073#1093#1086#1076#1080#1084#1086' '#1091#1073#1077#1076#1080#1090#1100#1089#1103', '#1095#1090#1086' '#1074' '#1080#1093' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1093' BIOS '#1074#1082#1083#1102#1095#1077#1085#1072' '#1092#1091#1085#1082#1094#1080#1103' WOL' +
      ' (Wakeup On LAN)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object ListView: TListView
    Left = 8
    Top = 32
    Width = 585
    Height = 377
    Columns = <
      item
        Width = 25
      end
      item
        Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077
        Width = 100
      end
      item
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 100
      end
      item
        Caption = #1048#1084#1103
        Width = 100
      end
      item
        Caption = 'IP'
        Width = 100
      end
      item
        Caption = 'MAC'
        Width = 125
      end>
    ColumnClick = False
    GridLines = True
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    SmallImages = ImageList1
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = ListViewCompare
    OnEditing = ListViewEditing
    OnKeyDown = ListViewKeyDown
  end
  object ButtonTurnOn: TButton
    Left = 280
    Top = 488
    Width = 153
    Height = 25
    Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
    Default = True
    TabOrder = 1
    OnClick = ButtonTurnOnClick
  end
  object ButtonClearCache: TButton
    Left = 440
    Top = 488
    Width = 153
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
    TabOrder = 2
    OnClick = ButtonClearCacheClick
  end
  object ImageList1: TImageList
    Left = 512
    Top = 16
  end
end
