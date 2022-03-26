object MainForm: TMainForm
  Left = 301
  Top = 79
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Win+F12 - '#1089#1082#1088#1099#1090#1100'/'#1087#1086#1082#1072#1079#1072#1090#1100' '#1086#1082#1085#1086
  ClientHeight = 804
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 10
    Width = 188
    Height = 16
    Caption = 'URL '#1080#1083#1080' '#1087#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089#1093#1077#1084#1099':'
  end
  object Label2: TLabel
    Left = 10
    Top = 79
    Width = 66
    Height = 16
    Caption = #1047#1072#1082#1083#1072#1076#1082#1080':'
  end
  object Label3: TLabel
    Left = 10
    Top = 330
    Width = 69
    Height = 16
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Bevel1: TBevel
    Left = 10
    Top = 398
    Width = 184
    Height = 6
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 10
    Top = 69
    Width = 184
    Height = 6
    Shape = bsTopLine
  end
  object Label4: TLabel
    Left = 10
    Top = 416
    Width = 120
    Height = 16
    Caption = #1057#1090#1072#1090#1091#1089#1085#1072#1103' '#1089#1090#1088#1086#1082#1072':'
  end
  object Label5: TLabel
    Left = 10
    Top = 475
    Width = 65
    Height = 16
    Caption = 'VIP '#1089#1077#1072#1085#1089':'
  end
  object Label6: TLabel
    Left = 10
    Top = 594
    Width = 228
    Height = 16
    Caption = #1056#1077#1082#1083#1072#1084#1085#1086'-'#1080#1085#1092#1086#1088#1084#1072#1094#1080#1086#1085#1085#1099#1081' '#1090#1077#1082#1089#1090':'
  end
  object Label7: TLabel
    Left = 10
    Top = 359
    Width = 65
    Height = 16
    Caption = #1050#1072#1088#1090#1080#1085#1082#1072':'
  end
  object Label8: TLabel
    Left = 206
    Top = 475
    Width = 122
    Height = 16
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1084#1072#1096#1080#1085#1099':'
  end
  object Label9: TLabel
    Left = 9
    Top = 534
    Width = 335
    Height = 16
    Caption = #1052#1077#1089#1090#1086#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1084#1072#1096#1080#1085#1099' ('#1085#1072#1079#1074#1072#1085#1080#1077' '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080'):'
  end
  object EditURL: TEdit
    Left = 10
    Top = 30
    Width = 351
    Height = 24
    TabOrder = 0
    Text = 'EditURL'
  end
  object EditSheetName: TEdit
    Left = 79
    Top = 325
    Width = 209
    Height = 24
    TabOrder = 2
    Text = 'EditSheetName'
  end
  object EditStatus: TEdit
    Left = 10
    Top = 436
    Width = 351
    Height = 24
    TabOrder = 6
    Text = 'EditStatus'
    OnChange = EditStatusChange
  end
  object EditVIP: TEdit
    Left = 10
    Top = 495
    Width = 139
    Height = 24
    TabOrder = 7
    Text = 'EditVIP'
  end
  object MemoText: TMemo
    Left = 10
    Top = 614
    Width = 351
    Height = 120
    Lines.Strings = (
      #1069#1090#1086' '#1088#1077#1082#1083#1072#1084#1085#1086'-'#1080#1085#1092#1086#1088#1084#1072#1094#1080#1086#1085#1085#1099#1081' '#1073#1083#1086#1082', '#1074' '
      #1082#1086#1090#1086#1088#1099#1081' '#1084#1086#1078#1085#1086' '#1088#1072#1079#1084#1077#1097#1072#1090#1100' '#1087#1088#1072#1082#1090#1080#1095#1077#1089#1082#1080' '#1083#1102#1073#1099#1077' '
      '<b>HTML</b> - '#1090#1077#1075#1080'.<br><br>'
      ''
      #1041#1083#1086#1082' '#1084#1086#1078#1077#1090' '#1073#1099#1090#1100' '#1082#1072#1082' '#1086#1076#1085#1086#1089#1090#1088#1086#1095#1085#1099#1084', '#1090#1072#1082' '#1080' '
      #1084#1085#1086#1075#1086#1089#1090#1088#1086#1095#1085#1099#1084'.'
      #1052#1086#1078#1077#1090' '#1080' '#1086#1090#1089#1091#1090#1089#1090#1074#1086#1074#1072#1090#1100' ('#1090'.'#1077'. '#1073#1099#1090#1100' '#1087#1091#1089#1090#1099#1084')')
    ScrollBars = ssVertical
    TabOrder = 10
  end
  object ButtonRefresh: TButton
    Left = 89
    Top = 756
    Width = 158
    Height = 30
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1090#1088#1072#1085#1080#1094#1091
    Default = True
    TabOrder = 11
    OnClick = ButtonRefreshClick
  end
  object ListViewSheets: TListView
    Left = 10
    Top = 98
    Width = 351
    Height = 218
    AllocBy = 50
    Columns = <
      item
        Caption = #1085#1072#1079#1074#1072#1085#1080#1077
        Width = 142
      end
      item
        Caption = #1082#1072#1088#1090#1080#1085#1082#1072' ('#1086#1087#1094#1080#1086#1085#1072#1083#1100#1085#1086')'
        Width = 172
      end>
    ColumnClick = False
    HideSelection = False
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = ListViewSheetsChange
    OnEditing = ListViewSheetsEditing
  end
  object EditSheetPic: TEdit
    Left = 79
    Top = 354
    Width = 209
    Height = 24
    TabOrder = 3
    Text = 'EditSheetPic'
  end
  object EditMachineDesc: TEdit
    Left = 206
    Top = 495
    Width = 139
    Height = 24
    TabOrder = 8
    Text = 'EditMachineDesc'
  end
  object ButtonSet: TButton
    Left = 295
    Top = 325
    Width = 43
    Height = 26
    Caption = 'Set'
    TabOrder = 4
    OnClick = ButtonSetClick
  end
  object ButtonReset: TButton
    Left = 295
    Top = 354
    Width = 43
    Height = 26
    Caption = 'Reset'
    TabOrder = 5
    OnClick = ButtonResetClick
  end
  object EditMachineLoc: TEdit
    Left = 9
    Top = 554
    Width = 337
    Height = 24
    TabOrder = 9
    Text = 'EditMachineLoc'
  end
  object XPManifest1: TXPManifest
    Left = 176
    Top = 136
  end
end
