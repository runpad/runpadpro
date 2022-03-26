object DBBackupForm: TDBBackupForm
  Left = 279
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 336
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 286
    Width = 420
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel2: TBevel
      Left = 0
      Top = 0
      Width = 420
      Height = 5
      Align = alTop
      Shape = bsTopLine
    end
    object ButtonForward: TButton
      Left = 336
      Top = 15
      Width = 75
      Height = 25
      Caption = #1044#1072#1083#1077#1077' >>'
      Default = True
      TabOrder = 0
      OnClick = ButtonForwardClick
    end
    object ButtonCancel: TButton
      Left = 9
      Top = 15
      Width = 75
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 286
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 420
      Height = 286
      ActivePage = TabSheet2
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      TabStop = False
      object TabSheet0: TTabSheet
        TabVisible = False
        OnShow = TabSheet0Show
        object Label6: TLabel
          Left = 16
          Top = 24
          Width = 122
          Height = 13
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1077#1081#1089#1090#1074#1080#1077':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object RadioBackup: TRadioButton
          Left = 16
          Top = 56
          Width = 345
          Height = 17
          Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1082#1086#1087#1080#1080' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
          TabOrder = 0
        end
        object RadioRestore: TRadioButton
          Left = 16
          Top = 80
          Width = 345
          Height = 17
          Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1088#1077#1079#1077#1088#1074#1085#1086#1081' '#1082#1086#1087#1080#1080
          TabOrder = 1
        end
        object RadioPassword: TRadioButton
          Left = 16
          Top = 104
          Width = 345
          Height = 17
          Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1087#1072#1088#1086#1083#1103' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
          TabOrder = 2
        end
      end
      object TabSheet1: TTabSheet
        ImageIndex = 4
        TabVisible = False
        OnShow = TabSheet1Show
        object Label7: TLabel
          Left = 16
          Top = 24
          Width = 124
          Height = 13
          Caption = #1042#1099#1073#1086#1088' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 16
          Top = 69
          Width = 63
          Height = 13
          Caption = 'SQL-'#1089#1077#1088#1074#1077#1088':'
        end
        object Label8: TLabel
          Left = 16
          Top = 93
          Width = 67
          Height = 13
          Caption = #1058#1080#1087' '#1089#1077#1088#1074#1077#1088#1072':'
        end
        object Label23: TLabel
          Left = 240
          Top = 69
          Width = 140
          Height = 13
          Caption = #1058#1086#1083#1100#1082#1086' '#1083#1086#1082#1072#1083#1100#1085#1072#1103' '#1084#1072#1096#1080#1085#1072'!'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object EditServer: TEdit
          Left = 112
          Top = 64
          Width = 121
          Height = 21
          MaxLength = 250
          TabOrder = 0
          OnChange = EditServerChange
        end
        object ComboBoxServerType: TComboBox
          Left = 112
          Top = 88
          Width = 121
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = ComboBoxServerTypeChange
          Items.Strings = (
            'MS SQL Server'
            'MySQL')
        end
        object Panel1: TPanel
          Left = 16
          Top = 120
          Width = 385
          Height = 137
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          object Label22: TLabel
            Left = 8
            Top = 8
            Width = 340
            Height = 13
            Caption = #1042#1085#1080#1084#1072#1085#1080#1077'! MySQL '#1085#1077' '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1090#1089#1103' '#1074' '#1076#1072#1085#1085#1086#1081' '#1091#1090#1080#1083#1080#1090#1077'.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object Memo1: TMemo
            Left = 8
            Top = 24
            Width = 369
            Height = 105
            TabStop = False
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Lines.Strings = (
              #1044#1083#1103' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1079#1072#1073#1099#1090#1099#1093' '#1087#1072#1088#1086#1083#1077#1081' '#1089#1084'. '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1102' '#1085#1072' '#1089#1072#1081#1090#1077' '
              'mysql.com '#1074' '#1088#1072#1079#1076#1077#1083#1077' "How to Reset the Root Password".'
              #1044#1083#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1082#1086#1087#1080#1080' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' '#1089#1084'. '#1086#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' mysqldump '
              '("mysqldump - A Database Backup Program").')
            ReadOnly = True
            TabOrder = 0
          end
        end
      end
      object TabSheet2: TTabSheet
        ImageIndex = 1
        TabVisible = False
        OnShow = TabSheet2Show
        object Label1: TLabel
          Left = 16
          Top = 112
          Width = 76
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        end
        object Label2: TLabel
          Left = 16
          Top = 136
          Width = 41
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100':'
        end
        object Label4: TLabel
          Left = 16
          Top = 24
          Width = 345
          Height = 52
          Caption = 
            #1059#1082#1072#1078#1080#1090#1077' '#1080#1084#1103' '#1080' '#1087#1072#1088#1086#1083#1100' '#1057#1059#1065#1045#1057#1058#1042#1059#1070#1065#1045#1043#1054' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072' '#1041#1044'. '#1069#1090#1086' '#1090#1072#1082#1078#1077' ' +
            #1084#1086#1078#1077#1090' '#1073#1099#1090#1100' '#1080' '#1074#1089#1090#1088#1086#1077#1085#1085#1072#1103' '#1091#1095#1077#1090#1085#1072#1103' '#1079#1072#1087#1080#1089#1100' "sa" (MSSQL) '#1080#1083#1080' "root" (' +
            'MySQL). '#1045#1089#1083#1080' '#1088#1072#1085#1077#1077' '#1073#1099#1083' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085' GameClass, '#1090#1086' '#1083#1091#1095#1096#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072 +
            #1090#1100' '#1091#1095#1077#1090#1085#1091#1102' '#1079#1072#1087#1080#1089#1100' "manager" ('#1076#1083#1103' MSSQL).'
          WordWrap = True
        end
        object EditAdminLogin: TEdit
          Left = 112
          Top = 107
          Width = 121
          Height = 21
          MaxLength = 250
          TabOrder = 0
          OnChange = EditAdminLoginChange
        end
        object EditAdminPwd: TEdit
          Left = 112
          Top = 131
          Width = 121
          Height = 21
          MaxLength = 250
          PasswordChar = '*'
          TabOrder = 1
        end
      end
      object TabSheet3: TTabSheet
        ImageIndex = 3
        TabVisible = False
        OnShow = TabSheet3Show
        object Label5: TLabel
          Left = 16
          Top = 24
          Width = 216
          Height = 13
          Caption = #1042#1099#1073#1086#1088' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103' '#1073#1072#1079#1099':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 16
          Top = 56
          Width = 329
          Height = 13
          AutoSize = False
          Caption = 'Label9'
        end
        object Label21: TLabel
          Left = 16
          Top = 120
          Width = 377
          Height = 97
          AutoSize = False
          Caption = 
            #1042#1085#1080#1084#1072#1085#1080#1077'!!! '#1055#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1092#1072#1081#1083#1072' '#1074' '#1089#1080#1089#1090#1077#1084#1085#1086#1081' '#1087#1072#1087#1082#1077' C:\WINDOWS '#1080#1083#1080' '#1082#1086 +
            #1088#1085#1077#1074#1086#1081' C:\ '#1084#1086#1078#1077#1090' '#1073#1099#1090#1100' '#1086#1090#1082#1072#1079#1072#1085#1086' '#1074' '#1076#1086#1089#1090#1091#1087#1077'. '#1055#1086#1090#1086#1084#1091' '#1083#1091#1095#1096#1077' '#1074#1089#1077#1075#1086' '#1089#1086#1079 +
            #1076#1072#1090#1100' '#1089#1074#1086#1102' '#1087#1072#1087#1082#1091' '#1080' '#1074' '#1085#1077#1077' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1072#1081#1083'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object ButtonFileSave: TButton
          Left = 16
          Top = 80
          Width = 65
          Height = 21
          Caption = #1054#1073#1079#1086#1088'...'
          TabOrder = 0
          OnClick = ButtonFileSaveClick
        end
      end
      object TabSheet4: TTabSheet
        ImageIndex = 5
        TabVisible = False
        OnShow = TabSheet4Show
        object Label10: TLabel
          Left = 16
          Top = 24
          Width = 244
          Height = 13
          Caption = #1042#1099#1073#1086#1088' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1073#1072#1079#1099':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label11: TLabel
          Left = 16
          Top = 56
          Width = 329
          Height = 13
          AutoSize = False
          Caption = 'Label11'
        end
        object ButtonFileOpen: TButton
          Left = 16
          Top = 80
          Width = 65
          Height = 21
          Caption = #1054#1073#1079#1086#1088'...'
          TabOrder = 0
          OnClick = ButtonFileOpenClick
        end
      end
      object TabSheet5: TTabSheet
        ImageIndex = 2
        TabVisible = False
        OnShow = TabSheet5Show
        object MemoLog: TMemo
          Left = 0
          Top = 0
          Width = 412
          Height = 276
          TabStop = False
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          Lines.Strings = (
            #1053#1072#1078#1084#1080#1090#1077' "'#1044#1072#1083#1077#1077'" '#1076#1083#1103' '#1087#1088#1086#1076#1086#1083#1078#1077#1085#1080#1103)
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet6: TTabSheet
        ImageIndex = 6
        TabVisible = False
        OnShow = TabSheet6Show
        object Label12: TLabel
          Left = 16
          Top = 24
          Width = 316
          Height = 13
          Caption = #1055#1088#1080' '#1091#1090#1088#1072#1090#1077' '#1087#1072#1088#1086#1083#1103' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072' '#1041#1044' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086':'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label13: TLabel
          Left = 16
          Top = 64
          Width = 186
          Height = 13
          Caption = '1. '#1042#1088#1077#1084#1077#1085#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1089#1077#1088#1074#1077#1088' Runpad'
        end
        object Label14: TLabel
          Left = 16
          Top = 88
          Width = 262
          Height = 13
          Caption = '2. '#1057#1076#1077#1083#1072#1090#1100' '#1082#1086#1087#1080#1102' '#1073#1072#1079#1099' '#1089' '#1087#1086#1084#1086#1097#1100#1102' '#1076#1072#1085#1085#1086#1081' '#1091#1090#1080#1083#1080#1090#1099
        end
        object Label15: TLabel
          Left = 16
          Top = 112
          Width = 221
          Height = 13
          Caption = '3. '#1059#1076#1072#1083#1080#1090#1100' ('#1076#1077#1080#1085#1089#1090#1072#1083#1083#1080#1088#1086#1074#1072#1090#1100') SQL-'#1089#1077#1088#1074#1077#1088
        end
        object Label16: TLabel
          Left = 16
          Top = 136
          Width = 168
          Height = 13
          Caption = '4. '#1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' SQL-'#1089#1077#1088#1074#1077#1088' '#1089#1085#1086#1074#1072
        end
        object Label17: TLabel
          Left = 16
          Top = 160
          Width = 294
          Height = 13
          Caption = '5. '#1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1073#1072#1079#1091' Runpad '#1089' '#1087#1086#1084#1086#1097#1100#1102' '#1076#1072#1085#1085#1086#1081' '#1091#1090#1080#1083#1080#1090#1099
        end
        object Label18: TLabel
          Left = 16
          Top = 184
          Width = 290
          Height = 13
          Caption = '6. '#1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' '#1082#1086#1085#1092#1080#1075#1091#1088#1072#1094#1080#1080' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' Runpad'
        end
        object Label19: TLabel
          Left = 16
          Top = 208
          Width = 381
          Height = 13
          Caption = 
            '7. '#1042' '#1087#1088#1086#1075#1088#1072#1084#1084#1077' '#1075#1083#1086#1073#1072#1083#1100#1085#1099#1093' '#1085#1072#1089#1090#1088#1086#1077#1082' '#1079#1072#1085#1086#1074#1086' '#1089#1086#1079#1076#1072#1090#1100' '#1074#1089#1077#1093' '#1087#1086#1083#1100#1079#1086#1074#1072#1090 +
            #1077#1083#1077#1081
        end
        object Label20: TLabel
          Left = 16
          Top = 232
          Width = 183
          Height = 13
          Caption = '8. '#1057#1085#1086#1074#1072' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1077#1088#1074#1077#1088' Runpad'
        end
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = '*.*|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 116
    Top = 302
  end
  object SaveDialog: TSaveDialog
    FileName = 'runpad_pro_db.backup'
    Filter = '*.*|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 148
    Top = 302
  end
end
