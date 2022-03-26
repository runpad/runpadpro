object FormOptions: TFormOptions
  Left = 317
  Top = 109
  ActiveControl = TreeView
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 249
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnHelp = FormHelp
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonOk: TSpeedButton
    Left = 216
    Top = 216
    Width = 73
    Height = 25
    Caption = #1054'k'
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TSpeedButton
    Left = 296
    Top = 216
    Width = 73
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    OnClick = ButtonCancelClick
  end
  object Notebook: TNotebook
    Left = 112
    Top = 32
    Width = 257
    Height = 177
    PageIndex = 1
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'About'
      object LabelCaption: TLabel
        Left = 16
        Top = 16
        Width = 143
        Height = 16
        Caption = 'Runpad '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LabelVersion: TLabel
        Left = 16
        Top = 40
        Width = 92
        Height = 13
        Caption = #1042#1077#1088#1089#1080#1103' 4 (1.03)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object LabelCopyright: TLabel
        Left = 16
        Top = 56
        Width = 48
        Height = 13
        Caption = '(c) 2006'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object LabelHyperlink: TLabel
        Left = 112
        Top = 152
        Width = 130
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Caption = 'www.runpad-shell.com'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        OnClick = LabelHyperlinkClick
        OnMouseEnter = LabelHyperlinkMouseEnter
        OnMouseLeave = LabelHyperlinkMouseLeave
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Scale'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 8
        Width = 257
        Height = 81
        Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1087#1086#1087#1091#1083#1103#1088#1085#1086#1089#1090#1100
        TabOrder = 0
        object teRatingMax: TEdit
          Left = 120
          Top = 46
          Width = 41
          Height = 21
          HelpContext = 2
          Enabled = False
          TabOrder = 2
          Text = '1'
        end
        object rbRatingAuto: TRadioButton
          Left = 8
          Top = 24
          Width = 161
          Height = 17
          Hint = #1041#1091#1076#1077#1090' '#1074#1099#1073#1080#1088#1072#1090#1100#1089#1103' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1080#1079' '#1087#1086#1087#1091#1083#1103#1088#1085#1086#1089#1090#1077#1081' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1103#1088#1083#1099#1082#1086#1074
          HelpContext = 1
          Caption = #1055#1086#1076#1073#1080#1088#1072#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbRatingMaxClick
        end
        object rbRatingMax: TRadioButton
          Left = 8
          Top = 48
          Width = 105
          Height = 17
          Hint = 
            #1042' '#1074#1080#1076#1077' '#1082#1086#1085#1089#1090#1072#1085#1090#1099'. '#1045#1089#1083#1080' '#1087#1086#1087#1091#1083#1103#1088#1085#1086#1089#1090#1100' '#1073#1086#1083#1100#1096#1077' '#1079#1072#1076#1072#1085#1085#1086#1081', '#1090#1086' '#1086#1085#1072' '#1086#1090#1086#1073 +
            #1088#1072#1079#1080#1090#1089#1103' '#1074' '#1091#1082#1072#1079#1072#1085#1085#1086#1084' '#1087#1088#1077#1076#1077#1083#1077
          HelpContext = 2
          Caption = #1047#1072#1076#1072#1090#1100' ('#1074' '#1095#1072#1089#1072#1093'):'
          TabOrder = 1
          TabStop = True
          OnClick = rbRatingMaxClick
        end
        object udRatingMax: TUpDown
          Left = 161
          Top = 46
          Width = 15
          Height = 21
          HelpContext = 2
          Associate = teRatingMax
          Enabled = False
          Min = 1
          Position = 1
          TabOrder = 3
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 96
        Width = 257
        Height = 81
        Caption = #1042#1088#1077#1084#1103' '
        TabOrder = 1
        object lFrom: TLabel
          Left = 24
          Top = 56
          Width = 6
          Height = 13
          HelpContext = 3
          Caption = #1089
        end
        object lTill: TLabel
          Left = 136
          Top = 56
          Width = 12
          Height = 13
          HelpContext = 3
          Caption = #1076#1086
        end
        object dtpTimeFrom: TDateTimePicker
          Left = 40
          Top = 53
          Width = 89
          Height = 21
          HelpContext = 3
          Date = 38495.965338171300000000
          Time = 38495.965338171300000000
          TabOrder = 1
        end
        object dtpTimeTill: TDateTimePicker
          Left = 152
          Top = 53
          Width = 89
          Height = 21
          HelpContext = 3
          Date = 38495.965338171300000000
          Time = 38495.965338171300000000
          TabOrder = 2
        end
        object cbTime: TComboBox
          Left = 16
          Top = 24
          Width = 225
          Height = 21
          HelpContext = 3
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086' '#1074#1086#1079#1084#1086#1078#1085#1099#1081' '#1080#1085#1090#1077#1088#1074#1072#1083
          OnChange = cbTimeChange
          Items.Strings = (
            #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086' '#1074#1086#1079#1084#1086#1078#1085#1099#1081' '#1080#1085#1090#1077#1088#1074#1072#1083
            #1047#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1075#1086#1076
            #1047#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1090#1088#1080' '#1084#1077#1089#1103#1094#1072
            #1047#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1084#1077#1089#1103#1094
            #1047#1072' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1085#1077#1076#1077#1083#1102
            #1059#1082#1072#1079#1072#1090#1100' '#1080#1085#1090#1077#1088#1074#1072#1083' '#1074#1088#1091#1095#1085#1091#1102)
        end
      end
    end
  end
  object TreeView: TTreeView
    Left = 8
    Top = 8
    Width = 97
    Height = 233
    HideSelection = False
    Indent = 19
    ReadOnly = True
    ShowButtons = False
    ShowRoot = False
    TabOrder = 0
    OnChange = TreeViewChange
    Items.Data = {
      02000000240000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      0BCE20EFF0EEE3F0E0ECECE5200000000100000000000000FFFFFFFFFFFFFFFF
      000000000000000007CCE0F1F8F2E0E1}
  end
  object StaticText: TStaticText
    Left = 112
    Top = 8
    Width = 257
    Height = 25
    Alignment = taRightJustify
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077' '
    Color = clMedGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
  end
end
