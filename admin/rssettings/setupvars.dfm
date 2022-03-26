object SetupVarsForm: TSetupVarsForm
  Left = 331
  Top = 127
  Width = 683
  Height = 609
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1088#1086#1092#1080#1083#1100' '#1085#1072#1089#1090#1088#1086#1077#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 13
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 200
    Height = 577
    Align = alLeft
    AutoExpand = True
    Ctl3D = True
    HideSelection = False
    HotTrack = True
    Indent = 19
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeViewChange
    OnCollapsing = TreeViewCollapsing
    OnEditing = TreeViewEditing
  end
  object PanelFace1: TPanel
    Left = 200
    Top = 0
    Width = 475
    Height = 577
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel2: TBevel
      Left = 0
      Top = 532
      Width = 475
      Height = 1
      Align = alBottom
      Shape = bsBottomLine
      Style = bsRaised
    end
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 475
      Height = 532
      ActivePage = TabSheet44
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      TabStop = False
      object TabSheet10: TTabSheet
        Tag = 1
        Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
        ImageIndex = 9
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label41: TLabel
            Left = 8
            Top = 160
            Width = 209
            Height = 13
            Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1087#1088#1080' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1080' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072': '
          end
          object GroupBox15: TGroupBox
            Left = 8
            Top = 11
            Width = 450
            Height = 97
            Caption = ' '#1060#1072#1081#1083#1086#1074#1099#1081' '#1089#1077#1088#1074#1077#1088' '
            TabOrder = 0
            object Label72: TLabel
              Left = 26
              Top = 40
              Width = 38
              Height = 13
              Caption = 'Label72'
            end
            object Label194: TLabel
              Left = 26
              Top = 65
              Width = 163
              Height = 13
              Caption = #1058#1072#1081#1084#1072#1091#1090' '#1086#1078#1080#1076#1072#1085#1080#1103' ('#1074' '#1089#1077#1082#1091#1085#1076#1072#1093'):'
            end
            object CheckBox162: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1054#1078#1080#1076#1072#1090#1100' '#1075#1086#1090#1086#1074#1085#1086#1089#1090#1080' '#1092#1072#1081#1083#1086#1074#1086#1075#1086' '#1089#1077#1088#1074#1077#1088#1072' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077':'
              TabOrder = 0
              OnClick = CheckBox162Click
            end
            object Edit85: TEdit
              Left = 208
              Top = 61
              Width = 41
              Height = 21
              MaxLength = 3
              TabOrder = 1
            end
          end
          object CheckBox7: TCheckBox
            Left = 8
            Top = 124
            Width = 450
            Height = 17
            Caption = 
              #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1076#1080#1085' '#1087#1088#1086#1094#1077#1089#1089#1086#1088' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072' '#1087#1086#1090#1086#1082#1086#1074' '#1087#1088#1086#1094#1077#1089#1089#1072' ' +
              #1096#1077#1083#1083#1072
            TabOrder = 1
          end
          object ComboBox4: TComboBox
            Left = 230
            Top = 156
            Width = 185
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 2
            Items.Strings = (
              #1042#1099#1082#1083#1102#1095#1080#1090#1100' '#1082#1086#1084#1087#1100#1102#1090#1077#1088
              #1057#1087#1103#1097#1080#1081' '#1088#1077#1078#1080#1084
              #1046#1076#1091#1097#1080#1081' '#1088#1077#1078#1080#1084)
          end
        end
      end
      object TabSheet44: TTabSheet
        Tag = 38
        Caption = #1040#1074#1072#1088#1080#1081#1085#1086#1077' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077
        ImageIndex = 1
        object Panel47: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label42: TLabel
            Left = 8
            Top = 16
            Width = 450
            Height = 41
            AutoSize = False
            Caption = 
              #1053#1072' '#1101#1090#1086#1081' '#1089#1090#1088#1072#1085#1080#1094#1077' '#1085#1072#1089#1090#1088#1072#1080#1074#1072#1077#1090#1089#1103' '#1072#1074#1072#1088#1080#1081#1085#1086#1077' ('#1073#1099#1089#1090#1088#1086#1077') '#1080#1083#1080' '#1074#1088#1077#1084#1077#1085#1085#1086#1077 +
              ' ('#1072#1085#1072#1083#1086#1075' '#1088#1077#1078#1080#1084#1072' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072' RunpadShell) '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077' '#1096#1077#1083#1083#1072'.'
            WordWrap = True
          end
          object Label43: TLabel
            Left = 8
            Top = 72
            Width = 379
            Height = 13
            Caption = 
              #1047#1072#1074#1077#1088#1096#1072#1090#1100' '#1089#1077#1072#1085#1089' '#1087#1088#1080' '#1087#1088#1086#1089#1090#1086#1077' '#1073#1086#1083#1077#1077' N-'#1084#1080#1085#1091#1090' '#1087#1088#1080' '#1074#1088#1077#1084#1077#1085#1085#1086#1084' '#1086#1090#1082#1083#1102#1095#1077#1085 +
              #1080#1080':'
          end
          object Label44: TLabel
            Left = 8
            Top = 112
            Width = 219
            Height = 13
            Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1089#1087#1086#1089#1086#1073#1099' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1103':'
          end
          object Label45: TLabel
            Left = 32
            Top = 176
            Width = 107
            Height = 13
            Caption = #1050#1086#1084#1073#1080#1085#1072#1094#1080#1103' '#1082#1083#1072#1074#1080#1096':'
          end
          object Label46: TLabel
            Left = 235
            Top = 173
            Width = 11
            Height = 20
            Caption = '+'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label47: TLabel
            Left = 331
            Top = 173
            Width = 11
            Height = 20
            Caption = '+'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Bevel1: TBevel
            Left = 8
            Top = 104
            Width = 300
            Height = 3
            Shape = bsTopLine
          end
          object Edit16: TEdit
            Left = 399
            Top = 68
            Width = 50
            Height = 21
            MaxLength = 4
            TabOrder = 0
          end
          object CheckBox46: TCheckBox
            Left = 8
            Top = 144
            Width = 450
            Height = 17
            Caption = #1063#1077#1088#1077#1079' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1091' '#1087#1086' '#1085#1072#1078#1072#1090#1080#1080' '#1082#1086#1084#1073#1080#1085#1072#1094#1080#1080' '#1082#1083#1072#1074#1080#1096':'
            TabOrder = 1
            OnClick = CheckBox46Click
          end
          object ComboBox5: TComboBox
            Left = 159
            Top = 172
            Width = 65
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 2
            Text = 'CTRL'
            Items.Strings = (
              'CTRL')
          end
          object ComboBox9: TComboBox
            Left = 255
            Top = 172
            Width = 65
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = 'ALT'
            Items.Strings = (
              'ALT')
          end
          object ComboBox12: TComboBox
            Left = 351
            Top = 172
            Width = 65
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 4
            Text = 'P'
            Items.Strings = (
              'P')
          end
          object Panel48: TPanel
            Left = 32
            Top = 200
            Width = 425
            Height = 145
            BevelOuter = bvNone
            TabOrder = 5
            object RadioButton1: TRadioButton
              Left = 8
              Top = 8
              Width = 400
              Height = 17
              Caption = #1042#1074#1086#1076' '#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1086#1075#1086' '#1087#1072#1088#1086#1083#1103':'
              TabOrder = 0
              OnClick = RadioButton1Click
            end
            object RadioButton2: TRadioButton
              Left = 8
              Top = 88
              Width = 400
              Height = 17
              Caption = #1042#1074#1086#1076' '#1087#1072#1088#1086#1083#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' Windows:'
              Enabled = False
              TabOrder = 1
            end
            object Edit36: TEdit
              Left = 32
              Top = 110
              Width = 137
              Height = 21
              Enabled = False
              MaxLength = 250
              TabOrder = 2
              Text = #1040#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088
            end
            object Panel49: TPanel
              Left = 24
              Top = 30
              Width = 401
              Height = 53
              BevelOuter = bvNone
              Enabled = False
              TabOrder = 3
              object Label48: TLabel
                Left = 8
                Top = 8
                Width = 41
                Height = 13
                Caption = #1055#1072#1088#1086#1083#1100':'
              end
              object Label51: TLabel
                Left = 8
                Top = 32
                Width = 57
                Height = 13
                Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1100':'
              end
              object Edit23: TEdit
                Left = 77
                Top = 4
                Width = 120
                Height = 21
                MaxLength = 250
                PasswordChar = '*'
                TabOrder = 0
              end
              object Edit26: TEdit
                Left = 77
                Top = 28
                Width = 120
                Height = 21
                MaxLength = 250
                PasswordChar = '*'
                TabOrder = 1
              end
              object CheckBox47: TCheckBox
                Left = 203
                Top = 18
                Width = 161
                Height = 17
                Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1101#1090#1086#1090' '#1087#1072#1088#1086#1083#1100
                TabOrder = 2
                OnClick = CheckBox47Click
              end
              object Edit37: TEdit
                Left = 204
                Top = 2
                Width = 121
                Height = 21
                Enabled = False
                TabOrder = 3
                Text = 'md5_hidden'
                Visible = False
              end
            end
          end
          object CheckBox56: TCheckBox
            Left = 8
            Top = 352
            Width = 450
            Height = 17
            Caption = #1063#1077#1088#1077#1079' '#1074#1089#1090#1072#1074#1082#1091' '#1092#1083#1101#1096'-'#1076#1080#1089#1082#1072
            TabOrder = 6
            OnClick = CheckBox56Click
          end
          object CheckBox59: TCheckBox
            Left = 8
            Top = 474
            Width = 450
            Height = 17
            Caption = #1063#1077#1088#1077#1079' iButton-'#1089#1095#1080#1090#1099#1074#1072#1090#1077#1083#1100
            Enabled = False
            TabOrder = 7
          end
          object Memo2: TMemo
            Left = 32
            Top = 376
            Width = 401
            Height = 57
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            MaxLength = 4000
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 8
            WordWrap = False
          end
          object Button4: TButton
            Left = 32
            Top = 435
            Width = 401
            Height = 21
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1085#1099#1077' '#1092#1083#1101#1096#1082#1080' '#1074' '#1089#1087#1080#1089#1086#1082
            TabOrder = 9
            OnClick = Button4Click
          end
        end
      end
      object TabSheet26: TTabSheet
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089
        ImageIndex = 4
        object Panel29: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet1: TTabSheet
        Tag = 2
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089': '#1044#1077#1089#1082#1090#1086#1087
        ImageIndex = 34
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox7: TGroupBox
            Left = 8
            Top = 8
            Width = 450
            Height = 344
            Caption = ' '#1056#1072#1073#1086#1095#1080#1081' '#1089#1090#1086#1083' '
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 24
              Width = 35
              Height = 13
              Caption = #1057#1093#1077#1084#1072':'
            end
            object Label3: TLabel
              Left = 8
              Top = 114
              Width = 122
              Height = 13
              Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1086#1085#1085#1099#1081' '#1073#1083#1086#1082':'
            end
            object Label134: TLabel
              Left = 8
              Top = 254
              Width = 93
              Height = 13
              Caption = #1057#1090#1072#1090#1091#1089#1085#1072#1103' '#1089#1090#1088#1086#1082#1072':'
            end
            object Label150: TLabel
              Left = 8
              Top = 314
              Width = 246
              Height = 13
              Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1086#1090#1082#1088#1099#1074#1072#1090#1100' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' '#1079#1072#1082#1083#1072#1076#1082#1091':'
            end
            object Memo1: TMemo
              Left = 8
              Top = 133
              Width = 313
              Height = 100
              MaxLength = 4000
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Button19: TButton
              Left = 331
              Top = 133
              Width = 100
              Height = 21
              Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
              TabOrder = 1
              OnClick = Button19Click
            end
            object Button20: TButton
              Left = 331
              Top = 159
              Width = 100
              Height = 21
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100
              TabOrder = 2
              OnClick = Button20Click
            end
            object Edit49: TEdit
              Left = 144
              Top = 249
              Width = 289
              Height = 21
              MaxLength = 250
              TabOrder = 3
            end
            object CheckBox8: TCheckBox
              Left = 8
              Top = 285
              Width = 425
              Height = 17
              Caption = #1047#1072#1090#1077#1084#1085#1103#1090#1100' '#1088#1072#1073#1086#1095#1080#1081' '#1089#1090#1086#1083' '#1082#1086#1075#1076#1072' '#1072#1082#1090#1080#1074#1085#1086' '#1086#1082#1085#1086' '#1089' '#1103#1088#1083#1099#1082#1072#1084#1080
              TabOrder = 4
            end
            object CheckBox65: TCheckBox
              Left = 8
              Top = 83
              Width = 425
              Height = 17
              Caption = 
                #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103' '#1086' '#1074#1086#1079#1084#1086#1078#1085#1099#1093' '#1086#1096#1080#1073#1082#1072#1093' '#1089#1093#1077#1084' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1089#1090#1086#1083 +
                #1072
              TabOrder = 5
            end
            object ComboBox13: TComboBox
              Left = 64
              Top = 19
              Width = 193
              Height = 21
              Style = csDropDownList
              DropDownCount = 10
              ItemHeight = 13
              TabOrder = 6
              OnChange = ComboBox13Change
              Items.Strings = (
                #1041#1077#1079' '#1089#1093#1077#1084
                #1057#1074#1086#1103' HTML-'#1089#1093#1077#1084#1072
                'HTML-'#1089#1093#1077#1084#1072' 1'
                'HTML-'#1089#1093#1077#1084#1072' 2'
                'HTML-'#1089#1093#1077#1084#1072' 3'
                'HTML-'#1089#1093#1077#1084#1072' 4'
                'Plugin-'#1089#1093#1077#1084#1072' 1')
            end
            object Edit38: TEdit
              Left = 64
              Top = 48
              Width = 370
              Height = 21
              MaxLength = 250
              TabOrder = 7
            end
            object Edit98: TEdit
              Left = 272
              Top = 310
              Width = 161
              Height = 21
              MaxLength = 250
              TabOrder = 8
            end
          end
          object GroupBox2: TGroupBox
            Left = 8
            Top = 363
            Width = 450
            Height = 128
            Caption = ' '#1057#1080#1089#1090#1077#1084#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '
            TabOrder = 1
            object Label12: TLabel
              Left = 8
              Top = 23
              Width = 142
              Height = 13
              Caption = #1042#1080#1076#1077#1086#1088#1077#1078#1080#1084' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102':'
            end
            object Label108: TLabel
              Left = 420
              Top = 51
              Width = 12
              Height = 13
              Caption = #1043#1094
            end
            object Label127: TLabel
              Left = 8
              Top = 51
              Width = 42
              Height = 13
              Caption = #1064#1080#1088#1080#1085#1072':'
            end
            object Label128: TLabel
              Left = 112
              Top = 51
              Width = 41
              Height = 13
              Caption = #1042#1099#1089#1086#1090#1072':'
            end
            object Label129: TLabel
              Left = 216
              Top = 51
              Width = 34
              Height = 13
              Caption = #1062#1074#1077#1090#1072':'
            end
            object Label130: TLabel
              Left = 286
              Top = 51
              Width = 17
              Height = 13
              Caption = #1073#1080#1090
            end
            object Label142: TLabel
              Left = 330
              Top = 51
              Width = 45
              Height = 13
              Caption = #1063#1072#1089#1090#1086#1090#1072':'
            end
            object Edit33: TEdit
              Left = 382
              Top = 44
              Width = 33
              Height = 21
              MaxLength = 3
              TabOrder = 3
            end
            object CheckBox27: TCheckBox
              Left = 8
              Top = 80
              Width = 425
              Height = 17
              Caption = #1042#1086#1089#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100' '#1074#1080#1076#1077#1086#1088#1077#1078#1080#1084' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' '#1096#1077#1083#1083#1072
              TabOrder = 4
            end
            object CheckBox127: TCheckBox
              Left = 8
              Top = 100
              Width = 425
              Height = 17
              Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1086#1084#1087#1086#1079#1080#1094#1080#1102' DWM Windows Vista'
              TabOrder = 5
            end
            object Edit94: TEdit
              Left = 56
              Top = 44
              Width = 41
              Height = 21
              MaxLength = 4
              TabOrder = 0
            end
            object Edit95: TEdit
              Left = 159
              Top = 44
              Width = 41
              Height = 21
              MaxLength = 4
              TabOrder = 1
            end
            object Edit96: TEdit
              Left = 256
              Top = 44
              Width = 25
              Height = 21
              MaxLength = 2
              TabOrder = 2
            end
          end
        end
      end
      object TabSheet3: TTabSheet
        Tag = 3
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089': '#1042#1080#1076
        ImageIndex = 2
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox3: TGroupBox
            Left = 8
            Top = 8
            Width = 450
            Height = 137
            Caption = ' '#1055#1072#1085#1077#1083#1100' '#1079#1072#1076#1072#1095' / '#1090#1088#1077#1081' '
            TabOrder = 0
            object Label121: TLabel
              Left = 8
              Top = 23
              Width = 106
              Height = 13
              Caption = #1057#1093#1077#1084#1072' '#1087#1072#1085#1077#1083#1080' '#1079#1072#1076#1072#1095':'
            end
            object Label2: TLabel
              Left = 8
              Top = 52
              Width = 141
              Height = 13
              Caption = #1062#1074#1077#1090' '#1087#1072#1085#1077#1083#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102':'
            end
            object Label5: TLabel
              Left = 8
              Top = 81
              Width = 254
              Height = 13
              Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100' '#1086#1082#1085#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1081' '#1085#1072' '#1087#1072#1085#1077#1083#1080' '#1079#1072#1076#1072#1095': '
            end
            object Label119: TLabel
              Left = 326
              Top = 81
              Width = 24
              Height = 13
              Caption = #1086#1082#1086#1085
            end
            object Label181: TLabel
              Left = 8
              Top = 106
              Width = 218
              Height = 13
              Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1080#1082#1086#1085#1086#1082' '#1074' '#1090#1088#1077#1077': '
            end
            object ComboBox10: TComboBox
              Left = 163
              Top = 19
              Width = 160
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 0
              Items.Strings = (
                'The Vista'
                'The Vista 2'
                'Windows Classic'
                'WinXP'
                'WinXP 2')
            end
            object Panel2: TPanel
              Left = 163
              Top = 46
              Width = 24
              Height = 24
              BevelOuter = bvLowered
              TabOrder = 1
              OnClick = Panel2Click
            end
            object Edit43: TEdit
              Left = 288
              Top = 77
              Width = 30
              Height = 21
              MaxLength = 2
              TabOrder = 2
            end
            object Edit75: TEdit
              Left = 288
              Top = 102
              Width = 30
              Height = 21
              MaxLength = 2
              TabOrder = 3
            end
          end
          object GroupBox6: TGroupBox
            Left = 8
            Top = 155
            Width = 450
            Height = 342
            Caption = ' '#1054#1082#1085#1086' '#1089' '#1103#1088#1083#1099#1082#1072#1084#1080' '
            TabOrder = 1
            object Label131: TLabel
              Left = 8
              Top = 24
              Width = 245
              Height = 13
              Caption = #1047#1072#1082#1088#1099#1074#1072#1090#1100' '#1086#1082#1085#1086' '#1089' '#1103#1088#1083#1099#1082#1072#1084#1080' '#1087#1088#1080' '#1087#1088#1086#1089#1090#1086#1077' '#1073#1086#1083#1077#1077
            end
            object Label132: TLabel
              Left = 300
              Top = 24
              Width = 55
              Height = 13
              Caption = #1084#1080#1085' (0-'#1085#1077#1090')'
            end
            object Label172: TLabel
              Left = 32
              Top = 240
              Width = 145
              Height = 13
              Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072#1083#1080':'
            end
            object Label173: TLabel
              Left = 32
              Top = 264
              Width = 134
              Height = 13
              Caption = #1056#1072#1089#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1074#1077#1088#1090#1080#1082#1072#1083#1080':'
            end
            object Label9: TLabel
              Left = 8
              Top = 182
              Width = 153
              Height = 13
              Caption = #1069#1092#1092#1077#1082#1090' '#1087#1088#1080' '#1082#1083#1080#1082#1077' '#1085#1072' '#1103#1088#1083#1099#1082#1077':'
            end
            object Label100: TLabel
              Left = 32
              Top = 314
              Width = 209
              Height = 13
              Caption = #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1099#1081' '#1088#1072#1079#1084#1077#1088' '#1080#1082#1086#1085#1086#1082'/'#1082#1072#1088#1090#1080#1085#1086#1082':'
            end
            object Label76: TLabel
              Left = 32
              Top = 290
              Width = 220
              Height = 13
              Caption = #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1099#1081' '#1088#1072#1079#1084#1077#1088' '#1080#1082#1086#1085#1086#1082'/'#1082#1072#1088#1090#1080#1085#1086#1082':'
            end
            object Label114: TLabel
              Left = 330
              Top = 240
              Width = 50
              Height = 13
              Caption = #1084#1072#1082#1089'. 300'
            end
            object Label115: TLabel
              Left = 330
              Top = 264
              Width = 50
              Height = 13
              Caption = #1084#1072#1082#1089'. 250'
            end
            object Label125: TLabel
              Left = 330
              Top = 290
              Width = 50
              Height = 13
              Caption = #1084#1072#1082#1089'. 256'
            end
            object Label126: TLabel
              Left = 330
              Top = 314
              Width = 50
              Height = 13
              Caption = #1084#1072#1082#1089'. 192'
            end
            object Edit3: TEdit
              Left = 265
              Top = 19
              Width = 28
              Height = 21
              MaxLength = 3
              TabOrder = 0
            end
            object CheckBox40: TCheckBox
              Left = 8
              Top = 90
              Width = 209
              Height = 17
              Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1091#1089#1090#1099#1077' '#1103#1088#1083#1099#1082#1080
              TabOrder = 2
            end
            object CheckBox9: TCheckBox
              Left = 8
              Top = 110
              Width = 425
              Height = 17
              Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1103#1088#1083#1099#1082#1086#1074' '#1089#1083#1077#1074#1072' '#1085#1072#1087#1088#1072#1074#1086
              TabOrder = 3
            end
            object CheckBox126: TCheckBox
              Left = 8
              Top = 130
              Width = 425
              Height = 17
              Caption = #1055#1086#1076#1089#1074#1077#1090#1082#1072' '#1103#1088#1083#1099#1082#1086#1074' '#1087#1088#1080' '#1085#1072#1074#1077#1076#1077#1085#1080#1080' '#1084#1099#1096#1100#1102
              TabOrder = 4
            end
            object CheckBox155: TCheckBox
              Left = 8
              Top = 212
              Width = 425
              Height = 17
              Caption = 
                #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1088#1072#1089#1089#1090#1086#1103#1085#1080#1103' '#1084#1077#1078#1076#1091' '#1103#1088#1083#1099#1082#1072#1084#1080'/'#1088#1072#1079#1084#1077#1088 +
                #1072
              TabOrder = 6
              OnClick = CheckBox155Click
            end
            object Edit70: TEdit
              Left = 264
              Top = 235
              Width = 49
              Height = 21
              MaxLength = 3
              TabOrder = 7
            end
            object Edit71: TEdit
              Left = 264
              Top = 259
              Width = 49
              Height = 21
              MaxLength = 3
              TabOrder = 8
            end
            object ComboBox2: TComboBox
              Left = 184
              Top = 178
              Width = 185
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 5
              Items.Strings = (
                #1085#1077#1090
                #1069#1092#1092#1077#1082#1090'1'
                #1069#1092#1092#1077#1082#1090'2')
            end
            object CheckBox44: TCheckBox
              Left = 8
              Top = 70
              Width = 425
              Height = 17
              Caption = #1042#1099#1089#1086#1082#1086#1077' '#1082#1072#1095#1077#1089#1090#1074#1086' '#1092#1086#1085#1086#1074#1086#1075#1086' '#1074#1080#1076#1077#1086' ('#1090#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1084#1086#1097#1085#1099#1093' CPU!)'
              TabOrder = 1
            end
            object Edit91: TEdit
              Left = 264
              Top = 309
              Width = 49
              Height = 21
              MaxLength = 3
              TabOrder = 10
            end
            object Edit92: TEdit
              Left = 264
              Top = 285
              Width = 49
              Height = 21
              MaxLength = 3
              TabOrder = 9
            end
            object CheckBox101: TCheckBox
              Left = 8
              Top = 150
              Width = 425
              Height = 17
              Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1103#1088#1083#1099#1082#1086#1074
              TabOrder = 11
            end
            object CheckBox102: TCheckBox
              Left = 8
              Top = 50
              Width = 425
              Height = 17
              Caption = 
                #1048#1079#1085#1072#1095#1072#1083#1100#1085#1086' '#1086#1082#1085#1086' '#1089' '#1103#1088#1083#1099#1082#1072#1084#1080' '#1088#1072#1079#1074#1077#1088#1085#1091#1090#1086' '#1085#1072' '#1074#1077#1089#1100' '#1101#1082#1088#1072#1085' ('#1084#1072#1082#1089#1080#1084#1080#1079#1080#1088#1086 +
                #1074#1072#1085#1086')'
              TabOrder = 12
            end
            object CheckBox103: TCheckBox
              Left = 232
              Top = 90
              Width = 209
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1072#1082#1078#1077' '#1087#1091#1090#1100' '#1082' '#1080#1082#1086#1085#1082#1077
              TabOrder = 13
            end
          end
        end
      end
      object TabSheet4: TTabSheet
        Tag = 4
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089': '#1052#1077#1085#1102
        ImageIndex = 3
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox12: TGroupBox
            Left = 8
            Top = 227
            Width = 450
            Height = 264
            Caption = ' '#1052#1077#1085#1102' CTRL+ALT+... '
            TabOrder = 0
            object Label10: TLabel
              Left = 8
              Top = 40
              Width = 330
              Height = 13
              Caption = #1044#1083#1103' '#1072#1082#1090#1080#1074#1072#1094#1080#1080' '#1101#1090#1086#1075#1086' '#1087#1091#1085#1082#1090#1072' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1072' '#1087#1077#1088#1077#1079#1072#1075#1088#1091#1079#1082#1072' '#1084#1072#1096#1080#1085#1099'!'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 8
              Top = 56
              Width = 430
              Height = 13
              Caption = 
                #1054#1087#1094#1080#1103' '#1085#1077' '#1073#1091#1076#1077#1090' '#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1083#1080#1095#1080#1080' '#1076#1088#1091#1075#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1087#1077#1088#1077#1093#1074#1072#1090#1072' C' +
                'TRL+ALT+DEL'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object CheckBox67: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1052#1077#1085#1102' '#1087#1086' CTRL+ALT+DEL ('#1090#1086#1083#1100#1082#1086' Win2000/XP/2003 x86)'
              TabOrder = 0
            end
            object CheckBox68: TCheckBox
              Left = 8
              Top = 114
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1044#1080#1089#1087#1077#1090#1095#1077#1088' '#1079#1072#1076#1072#1095'"'
              TabOrder = 1
            end
            object CheckBox69: TCheckBox
              Left = 8
              Top = 134
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1057#1085#1103#1090#1100' '#1074#1089#1077' '#1079#1072#1076#1072#1095#1080'"'
              TabOrder = 2
            end
            object CheckBox70: TCheckBox
              Left = 8
              Top = 154
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1077#1072#1085#1089#1077' GameClass"'
              TabOrder = 3
            end
            object CheckBox71: TCheckBox
              Left = 8
              Top = 174
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1055#1077#1088#1077#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1072#1096#1080#1085#1091'"'
              TabOrder = 4
            end
            object CheckBox72: TCheckBox
              Left = 8
              Top = 194
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1042#1099#1082#1083#1102#1095#1080#1090#1100' '#1084#1072#1096#1080#1085#1091'"'
              TabOrder = 5
            end
            object CheckBox73: TCheckBox
              Left = 8
              Top = 234
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1084#1086#1085#1080#1090#1086#1088' '#1085#1072' '#1074#1088#1077#1084#1103'"'
              TabOrder = 6
            end
            object CheckBox10: TCheckBox
              Left = 8
              Top = 214
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1077#1072#1085#1089' (LogOff)"'
              TabOrder = 7
            end
            object CheckBox16: TCheckBox
              Left = 153
              Top = 82
              Width = 125
              Height = 17
              Caption = 'CTRL+ALT+PGDN'
              TabOrder = 8
            end
            object CheckBox136: TCheckBox
              Left = 8
              Top = 82
              Width = 125
              Height = 17
              Caption = 'CTRL+ALT+END'
              TabOrder = 9
            end
            object CheckBox137: TCheckBox
              Left = 298
              Top = 82
              Width = 125
              Height = 17
              Caption = 'CTRL+ALT+INS'
              TabOrder = 10
            end
          end
          object GroupBox1: TGroupBox
            Left = 8
            Top = 8
            Width = 450
            Height = 207
            Caption = ' '#1052#1077#1085#1102' "'#1055#1059#1057#1050'" '
            TabOrder = 1
            object CheckBox11: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1077#1072#1085#1089' (LogOff)"'
              TabOrder = 0
            end
            object CheckBox12: TCheckBox
              Left = 8
              Top = 59
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1055#1077#1088#1077#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1072#1096#1080#1085#1091'"'
              TabOrder = 1
            end
            object CheckBox13: TCheckBox
              Left = 8
              Top = 79
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1042#1099#1082#1083#1102#1095#1080#1090#1100' '#1084#1072#1096#1080#1085#1091'"'
              TabOrder = 2
            end
            object CheckBox41: TCheckBox
              Left = 8
              Top = 99
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1077#1072#1085#1089#1077' GameClass"'
              TabOrder = 3
            end
            object CheckBox43: TCheckBox
              Left = 8
              Top = 119
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1052#1086#1081' '#1082#1086#1084#1087#1100#1102#1090#1077#1088'" '
              TabOrder = 4
            end
            object CheckBox62: TCheckBox
              Left = 8
              Top = 139
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1084#1086#1085#1080#1090#1086#1088' '#1085#1072' '#1074#1088#1077#1084#1103'"'
              TabOrder = 5
            end
            object CheckBox164: TCheckBox
              Left = 8
              Top = 159
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1050#1085#1080#1075#1072' '#1078#1072#1083#1086#1073' '#1080' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1081'"'
              TabOrder = 6
            end
            object CheckBox83: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1086#1090#1082#1088#1099#1074#1072#1090#1100' '#1084#1077#1085#1102' '#1087#1086' '#1082#1083#1072#1074#1080#1096#1077' "WIN"'
              TabOrder = 7
            end
            object CheckBox2: TCheckBox
              Left = 8
              Top = 179
              Width = 425
              Height = 17
              Caption = #1055#1091#1085#1082#1090' "'#1042#1099#1079#1086#1074' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1072'"'
              TabOrder = 8
            end
          end
        end
      end
      object TabSheet21: TTabSheet
        Tag = 5
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089': '#1059#1090#1080#1083#1080#1090#1099
        ImageIndex = 6
        OnShow = TabSheet21Show
        object Panel25: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label105: TLabel
            Left = 8
            Top = 16
            Width = 415
            Height = 13
            Caption = 
              #1057#1087#1080#1089#1086#1082' '#1091#1090#1080#1083#1080#1090', '#1076#1086#1089#1090#1091#1087#1085#1099#1093' '#1095#1077#1088#1077#1079' '#1084#1077#1085#1102' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080' '#1087#1072#1085#1077#1083#1100' '#1073#1099#1089#1090#1088#1086 +
              #1075#1086' '#1079#1072#1087#1091#1089#1082#1072':'
          end
          object Label106: TLabel
            Left = 8
            Top = 299
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label107: TLabel
            Left = 8
            Top = 323
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object ListView12: TListView
            Left = 8
            Top = 36
            Width = 345
            Height = 250
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView12SelectItem
          end
          object Edit30: TEdit
            Left = 80
            Top = 295
            Width = 273
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit30Change
          end
          object Edit31: TEdit
            Left = 80
            Top = 319
            Width = 246
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit31Change
          end
          object Button17: TButton
            Left = 332
            Top = 319
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 3
            OnClick = Button17Click
          end
        end
      end
      object TabSheet22: TTabSheet
        Tag = 6
        Caption = #1047#1072#1087#1091#1089#1082' '#1103#1088#1083#1099#1082#1086#1074
        ImageIndex = 20
        object Panel26: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox8: TGroupBox
            Left = 8
            Top = 250
            Width = 450
            Height = 129
            Caption = ' '#1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '
            TabOrder = 0
            object Label101: TLabel
              Left = 8
              Top = 46
              Width = 157
              Height = 13
              Caption = #1061#1088#1072#1085#1080#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' ('#1084#1077#1089#1103#1094#1077#1074'):'
            end
            object Label7: TLabel
              Left = 8
              Top = 98
              Width = 173
              Height = 13
              Caption = #1053#1077' '#1074#1082#1083#1102#1095#1072#1090#1100' '#1074' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1092#1072#1081#1083#1099':'
            end
            object CheckBox23: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1042#1077#1089#1090#1080' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1079#1072#1087#1091#1089#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1080' '#1089#1072#1081#1090#1086#1074' ('#1076#1083#1103' '#1089#1077#1088#1074#1077#1088#1072')'
              TabOrder = 0
            end
            object ComboBox8: TComboBox
              Left = 191
              Top = 41
              Width = 42
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 1
              Items.Strings = (
                '1'
                '2'
                '3'
                '4'
                '5'
                '6')
            end
            object CheckBox85: TCheckBox
              Left = 8
              Top = 69
              Width = 425
              Height = 17
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1074' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1087#1086#1087#1091#1083#1103#1088#1085#1086#1089#1090#1100' '#1089#1072#1081#1090#1086#1074
              TabOrder = 2
            end
            object Edit32: TEdit
              Left = 191
              Top = 93
              Width = 242
              Height = 21
              MaxLength = 200
              TabOrder = 3
            end
          end
          object GroupBox9: TGroupBox
            Left = 8
            Top = 124
            Width = 450
            Height = 114
            Caption = ' '#1069#1084#1091#1083#1103#1090#1086#1088#1099' CD '#1076#1080#1089#1082#1086#1074' '
            TabOrder = 1
            object Label52: TLabel
              Left = 232
              Top = 24
              Width = 210
              Height = 13
              AutoSize = False
              Caption = 'C:\TEMP'
            end
            object Label55: TLabel
              Left = 232
              Top = 44
              Width = 210
              Height = 13
              AutoSize = False
              Caption = 'C:\TEMP'
            end
            object Label56: TLabel
              Left = 8
              Top = 89
              Width = 329
              Height = 13
              Caption = #1044#1083#1103' Virtual CD '#1080' Virtual Drive '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1093' '#1085#1072#1089#1090#1088#1086#1077#1082' '#1085#1077' '#1085#1091#1078#1085#1086'!'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 232
              Top = 64
              Width = 210
              Height = 13
              AutoSize = False
              Caption = 'C:\TEMP'
            end
            object CheckBox24: TCheckBox
              Left = 8
              Top = 23
              Width = 210
              Height = 17
              Caption = #1055#1091#1090#1100' '#1082' Alcohol CD:'
              TabOrder = 0
              OnClick = CheckBox24Click
            end
            object CheckBox28: TCheckBox
              Left = 8
              Top = 43
              Width = 210
              Height = 17
              Caption = #1055#1091#1090#1100' '#1082' Daemon Tools Lite:'
              TabOrder = 1
              OnClick = CheckBox28Click
            end
            object CheckBox5: TCheckBox
              Left = 8
              Top = 63
              Width = 210
              Height = 17
              Caption = #1055#1091#1090#1100' '#1082' Daemon Tools Pro (Std/Adv):'
              TabOrder = 2
              OnClick = CheckBox5Click
            end
          end
          object GroupBox11: TGroupBox
            Left = 8
            Top = 8
            Width = 450
            Height = 105
            Caption = ' '#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '
            TabOrder = 2
            object CheckBox17: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1090#1086#1083#1100#1082#1086' '#1086#1076#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
              TabOrder = 0
            end
            object CheckBox163: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1103#1088#1083#1099#1082#1086#1074' '#1077#1089#1083#1080' '#1085#1077#1090' '#1089#1074#1103#1079#1080' '#1089' '#1073#1072#1079#1086#1081' SQL'
              TabOrder = 1
            end
            object CheckBox159: TCheckBox
              Left = 8
              Top = 59
              Width = 425
              Height = 17
              Caption = 
                #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1091#1090#1080#1083#1080#1090' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1077#1089#1083#1080' '#1085#1077#1090' '#1089#1074#1103#1079#1080' '#1089' '#1073#1072#1079#1086#1081' SQ' +
                'L'
              TabOrder = 2
            end
            object CheckBox95: TCheckBox
              Left = 8
              Top = 79
              Width = 425
              Height = 17
              Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1103#1088#1083#1099#1082#1086#1074' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1074' '#1088#1077#1078#1080#1084#1077' SafeMode'
              TabOrder = 3
            end
          end
        end
      end
      object TabSheet37: TTabSheet
        Tag = 7
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1083#1080#1094#1077#1085#1079#1080#1081
        ImageIndex = 36
        OnShow = TabSheet37Show
        object Panel39: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label174: TLabel
            Left = 8
            Top = 16
            Width = 399
            Height = 13
            Caption = 
              #1052#1077#1085#1077#1076#1078#1077#1088' '#1083#1080#1094#1077#1085#1079#1080#1081' '#1079#1072#1087#1088#1077#1097#1072#1077#1090' '#1079#1072#1087#1091#1089#1082' '#1073#1086#1083#1077#1077' N-'#1082#1086#1087#1080#1081' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1080' '#1080#1075#1088' ' +
              #1074' '#1089#1077#1090#1080':'
          end
          object Label175: TLabel
            Left = 8
            Top = 357
            Width = 131
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1080' '#1082#1086#1083'-'#1074#1086' '#1082#1086#1087#1080#1081':'
          end
          object Label176: TLabel
            Left = 8
            Top = 381
            Width = 102
            Height = 13
            Caption = #1060#1072#1081#1083#1099' '#1087#1088#1086#1075#1088#1072#1084#1084#1099':'
          end
          object Label177: TLabel
            Left = 8
            Top = 418
            Width = 231
            Height = 13
            Caption = #1057#1084'. '#1089#1087#1088#1072#1074#1082#1091' '#1076#1083#1103' '#1073#1086#1083#1077#1077' '#1076#1077#1090#1072#1083#1100#1085#1086#1075#1086' '#1086#1087#1080#1089#1072#1085#1080#1103'!'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label152: TLabel
            Left = 8
            Top = 40
            Width = 449
            Height = 41
            AutoSize = False
            Caption = 
              #1042#1085#1080#1084#1072#1085#1080#1077'! '#1044#1072#1085#1085#1099#1081' '#1089#1087#1086#1089#1086#1073' '#1103#1074#1083#1103#1077#1090#1089#1103' '#1091#1089#1090#1072#1088#1077#1074#1096#1080#1084'! '#1044#1083#1103' '#1073#1086#1083#1100#1096#1080#1085#1089#1090#1074#1072' '#1089#1086#1074 +
              #1088#1077#1084#1077#1085#1085#1099#1093' '#1080#1075#1088' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' "'#1052#1077#1085#1077#1076#1078#1077#1088' '#1083#1080#1094#1077#1085#1079#1080#1081' v2"'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object ListView15: TListView
            Left = 8
            Top = 94
            Width = 345
            Height = 250
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1080' '#1082#1086#1083'-'#1074#1086' '#1082#1086#1087#1080#1081
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1060#1072#1081#1083#1099
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView15SelectItem
          end
          object Edit72: TEdit
            Left = 153
            Top = 353
            Width = 200
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit72Change
          end
          object Edit73: TEdit
            Left = 153
            Top = 377
            Width = 200
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit73Change
          end
        end
      end
      object TabSheet50: TTabSheet
        Tag = 39
        Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1083#1080#1094#1077#1085#1079#1080#1081' v2'
        ImageIndex = 9
        object Panel55: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label151: TLabel
            Left = 8
            Top = 16
            Width = 449
            Height = 137
            AutoSize = False
            Caption = 
              #1044#1083#1103' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' "'#1087#1083#1072#1074#1072#1102#1097#1080#1093'" '#1083#1080#1094#1077#1085#1079#1080#1081' '#1076#1083#1103' '#1080#1075#1088' '#1089#1084'. '#1086#1087#1094#1080#1102' '#1103#1088#1083#1099#1082#1086#1074 +
              ' "'#1087#1083#1072#1074#1072#1102#1097#1072#1103' '#1083#1080#1094#1077#1085#1079#1080#1103'" '#1074' '#1087#1088#1086#1092#1080#1083#1103#1093' '#1082#1086#1085#1090#1077#1085#1090#1072'. '#1058#1072#1082#1086#1081' '#1084#1077#1093#1072#1085#1080#1079#1084' '#1087#1086#1079#1074#1086#1083 +
              #1103#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1085#1086#1077' '#1095#1080#1089#1083#1086' '#1082#1091#1087#1083#1077#1085#1085#1099#1093' '#1080#1075#1088#1086#1074#1099#1093' '#1083#1080#1094#1077#1085#1079#1080#1081' '#1084 +
              #1077#1078#1076#1091' '#1090#1088#1077#1073#1091#1077#1084#1099#1084#1080' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072#1084#1080' '#1087#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1080#1075#1088#1099'.'
            WordWrap = True
          end
        end
      end
      object TabSheet35: TTabSheet
        Tag = 8
        Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
        ImageIndex = 34
        object Panel37: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox32: TGroupBox
            Left = 8
            Top = 12
            Width = 450
            Height = 168
            Caption = ' '#1054#1082#1085#1086' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' / '#1093#1088#1072#1085#1080#1090#1077#1083#1103' '#1101#1082#1088#1072#1085#1072' '
            TabOrder = 0
            object Label146: TLabel
              Left = 8
              Top = 22
              Width = 124
              Height = 13
              Caption = #1055#1091#1090#1100' '#1082' '#1087#1072#1087#1082#1077' '#1080#1083#1080' '#1092#1072#1081#1083#1091':'
            end
            object Label147: TLabel
              Left = 8
              Top = 43
              Width = 44
              Height = 13
              Caption = 'Label147'
            end
            object Button24: TButton
              Left = 8
              Top = 68
              Width = 185
              Height = 25
              Caption = #1042#1099#1073#1088#1072#1090#1100' '#1086#1076#1080#1085#1086#1095#1085#1099#1081' '#1092#1072#1081#1083'...'
              TabOrder = 0
              OnClick = Button24Click
            end
            object Button25: TButton
              Left = 8
              Top = 98
              Width = 185
              Height = 25
              Caption = #1042#1099#1073#1088#1072#1090#1100' '#1087#1072#1087#1082#1091'...'
              TabOrder = 1
              OnClick = Button25Click
            end
            object Button26: TButton
              Left = 8
              Top = 128
              Width = 185
              Height = 25
              Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
              TabOrder = 2
              OnClick = Button26Click
            end
          end
          object GroupBox33: TGroupBox
            Left = 8
            Top = 191
            Width = 450
            Height = 70
            Caption = ' '#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '
            TabOrder = 1
            object CheckBox145: TCheckBox
              Left = 8
              Top = 21
              Width = 425
              Height = 17
              Caption = 
                #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1101#1082#1088#1072#1085' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1080' '#1087#1088#1080' '#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085#1080#1080' '#1095#1077#1088#1077#1079' API '#1080#1083#1080' '#1089#1077#1088#1074#1077 +
                #1088
              TabOrder = 0
            end
            object CheckBox96: TCheckBox
              Left = 8
              Top = 41
              Width = 425
              Height = 17
              Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1103#1088#1083#1099#1082#1086#1074' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' ('#1076#1083#1103' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103' '#1089' API)'
              TabOrder = 1
              OnClick = CheckBox96Click
            end
          end
          object GroupBox35: TGroupBox
            Left = 8
            Top = 273
            Width = 450
            Height = 109
            Caption = ' '#1055#1088#1086#1089#1090#1086#1081' '#1084#1072#1096#1080#1085#1099' '
            TabOrder = 2
            object Label112: TLabel
              Left = 8
              Top = 53
              Width = 235
              Height = 13
              Caption = #1042#1099#1082#1083#1102#1095#1072#1090#1100' '#1087#1080#1090#1072#1085#1080#1077' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072' '#1087#1088#1080' '#1087#1088#1086#1089#1090#1086#1077':'
            end
            object Label113: TLabel
              Left = 315
              Top = 53
              Width = 55
              Height = 13
              Caption = #1084#1080#1085' (0-'#1085#1077#1090')'
            end
            object Label144: TLabel
              Left = 8
              Top = 25
              Width = 244
              Height = 13
              Caption = #1042#1082#1083#1102#1095#1072#1090#1100' '#1093#1088#1072#1085#1080#1090#1077#1083#1100' '#1101#1082#1088#1072#1085#1072' '#1087#1088#1080' '#1087#1088#1086#1089#1090#1086#1077' '#1073#1086#1083#1077#1077':'
            end
            object Label145: TLabel
              Left = 315
              Top = 25
              Width = 55
              Height = 13
              Caption = #1084#1080#1085' (0-'#1085#1077#1090')'
            end
            object CheckBox1: TCheckBox
              Left = 8
              Top = 81
              Width = 425
              Height = 17
              Caption = 
                #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1089#1077#1072#1085#1089#1072' (LogOff) '#1074#1084#1077#1089#1090#1086' '#1086#1090#1082#1083#1102#1095#1077#1085#1080#1103' '#1087#1080#1090#1072#1085#1080 +
                #1103
              TabOrder = 0
            end
            object Edit35: TEdit
              Left = 280
              Top = 48
              Width = 28
              Height = 21
              MaxLength = 3
              TabOrder = 1
            end
            object Edit60: TEdit
              Left = 280
              Top = 20
              Width = 28
              Height = 21
              MaxLength = 3
              TabOrder = 2
            end
          end
          object GroupBox34: TGroupBox
            Left = 8
            Top = 394
            Width = 450
            Height = 104
            Caption = ' '#1042#1088#1077#1084#1077#1085#1085#1099#1077' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '
            TabOrder = 3
            object Label64: TLabel
              Left = 8
              Top = 51
              Width = 171
              Height = 13
              Caption = #1048#1085#1090#1077#1088#1074#1072#1083#1099' '#1088#1072#1079#1088#1077#1096#1077#1085#1085#1086#1081' '#1088#1072#1073#1086#1090#1099':'
            end
            object Label65: TLabel
              Left = 8
              Top = 76
              Width = 136
              Height = 13
              Caption = #1044#1077#1081#1089#1090#1074#1080#1077' '#1074#1085#1077' '#1080#1085#1090#1077#1088#1074#1072#1083#1086#1074':'
            end
            object CheckBox75: TCheckBox
              Left = 8
              Top = 24
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1092#1091#1085#1082#1094#1080#1102' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080
              TabOrder = 0
              OnClick = CheckBox75Click
            end
            object Edit68: TEdit
              Left = 190
              Top = 47
              Width = 217
              Height = 21
              MaxLength = 250
              TabOrder = 1
            end
            object ComboBox1: TComboBox
              Left = 190
              Top = 72
              Width = 217
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 2
              Items.Strings = (
                #1047#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1089#1077#1072#1085#1089#1072' (LogOff)'
                #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1080#1090#1072#1085#1080#1103' '#1084#1072#1096#1080#1085#1099)
            end
          end
        end
      end
      object TabSheet43: TTabSheet
        Tag = 37
        Caption = #1048#1085#1090#1077#1075#1088#1072#1094#1080#1103
        ImageIndex = 9
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 506
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label37: TLabel
            Left = 8
            Top = 16
            Width = 414
            Height = 26
            Caption = 
              #1047#1076#1077#1089#1100' '#1085#1072#1089#1090#1088#1072#1080#1074#1072#1102#1090#1089#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1080#1085#1090#1077#1075#1088#1072#1094#1080#1080' '#1089' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#1084#1080' '#1082#1086#1085#1090#1088#1086#1083#1103'.' +
              ' '#1054#1073#1099#1095#1085#1086' '#1080#1089#1087#1086#1083#1100#1079#1091#1102#1090#1089#1103' '#1074' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1085#1099#1093' '#1082#1083#1091#1073#1072#1093' '#1080' '#1080#1085#1090#1077#1088#1085#1077#1090'-'#1082#1072#1092#1077'.'
            WordWrap = True
          end
          object GroupBox19: TGroupBox
            Left = 8
            Top = 72
            Width = 450
            Height = 73
            Caption = ' GameClass '
            TabOrder = 0
            object Label38: TLabel
              Left = 8
              Top = 24
              Width = 428
              Height = 26
              Caption = 
                #1044#1083#1103' GameClass '#1074#1089#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1076#1077#1083#1072#1102#1090#1089#1103' '#1085#1072' '#1077#1075#1086' '#1089#1090#1086#1088#1086#1085#1077'. '#1047#1076#1077#1089#1100' '#1084#1086#1078#1085#1086 +
                ' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1083#1080#1096#1100' '#1086#1087#1094#1080#1102' "'#1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1082#1083#1080#1077#1085#1090#1072'" '#1085#1072' '#1074#1082#1083#1072#1076#1082 +
                #1077' "'#1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1055#1088#1086#1095#1080#1077'"'
              WordWrap = True
            end
          end
          object GroupBox26: TGroupBox
            Left = 8
            Top = 158
            Width = 450
            Height = 73
            Caption = ' AstalaVista2/AstalaVista1 '
            TabOrder = 1
            object Label39: TLabel
              Left = 8
              Top = 24
              Width = 432
              Height = 26
              Caption = 
                #1044#1083#1103' '#1080#1085#1090#1077#1075#1088#1072#1094#1080#1080' '#1089' '#1101#1090#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1086#1081' '#1080#1084#1077#1077#1090#1089#1103' '#1089#1087#1077#1094#1080#1072#1083#1100#1085#1072#1103' '#1091#1090#1080#1083#1080#1090#1072'. '#1053#1072 +
                #1081#1090#1080' '#1077#1077' '#1084#1086#1078#1085#1086' '#1085#1072' '#1092#1086#1088#1091#1084#1077' RunpadPro'
              WordWrap = True
            end
          end
          object GroupBox30: TGroupBox
            Left = 8
            Top = 245
            Width = 450
            Height = 84
            Caption = ' '#1055#1088#1086#1095#1080#1077' '
            TabOrder = 2
            object Label40: TLabel
              Left = 8
              Top = 24
              Width = 433
              Height = 39
              Caption = 
                #1044#1088#1091#1075#1080#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1076#1086#1083#1078#1085#1099' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' API '#1096#1077#1083#1083#1072' ('#1086#1087#1080#1089#1072#1085#1080#1077' '#1077#1089#1090#1100' '#1074' ' +
                #1089#1087#1088#1072#1074#1082#1077'), '#1091#1078#1077' '#1075#1086#1090#1086#1074#1099#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1089#1074#1103#1079#1082#1080' '#1084#1086#1078#1085#1086' '#1085#1072#1081#1090#1080' '#1083#1080#1073#1086' '#1085#1072' '#1092#1086#1088#1091#1084 +
                #1077' Runpad, '#1083#1080#1073#1086' '#1074' '#1080#1085#1090#1077#1088#1085#1077#1090#1077'.'
              WordWrap = True
            end
          end
        end
      end
      object TabSheet29: TTabSheet
        Tag = 9
        Caption = 'VIP-'#1082#1083#1080#1077#1085#1090#1099
        ImageIndex = 28
        object Panel31: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 500
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label4: TLabel
            Left = 182
            Top = 39
            Width = 45
            Height = 13
            Caption = 'C:\TEMP'
          end
          object Label13: TLabel
            Left = 8
            Top = 64
            Width = 233
            Height = 13
            Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1090#1100' '#1088#1072#1079#1084#1077#1088' '#1083#1080#1095#1085#1086#1081' '#1087#1072#1087#1082#1080' '#1082#1083#1080#1077#1085#1090#1072' '#1076#1086' '
          end
          object Label18: TLabel
            Left = 317
            Top = 64
            Width = 124
            Height = 13
            Caption = #1052#1041' (0 - '#1085#1077' '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1090#1100')'
          end
          object CheckBox86: TCheckBox
            Left = 8
            Top = 12
            Width = 450
            Height = 17
            Caption = #1042' '#1084#1077#1085#1102' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1088#1072#1073#1086#1090#1072' '#1089' '#1083#1080#1095#1085#1099#1084#1080' (VIP) '#1089#1077#1089#1089#1080#1103#1084#1080
            TabOrder = 0
          end
          object GroupBox20: TGroupBox
            Left = 8
            Top = 129
            Width = 450
            Height = 86
            Caption = ' '#1055#1077#1088#1077#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1087#1072#1087#1086#1082' '#1076#1083#1103' VIP-'#1082#1083#1080#1077#1085#1090#1086#1074' '
            TabOrder = 1
            object Label109: TLabel
              Left = 8
              Top = 63
              Width = 311
              Height = 13
              Caption = #1053#1077' '#1074#1089#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1084#1086#1075#1091#1090' '#1082#1086#1088#1088#1077#1082#1090#1085#1086' '#1088#1072#1073#1086#1090#1072#1090#1100' '#1089' '#1101#1090#1086#1081' '#1086#1087#1094#1080#1077#1081'!'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object CheckBox89: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1055#1077#1088#1077#1085#1072#1087#1088#1072#1074#1083#1103#1090#1100' '#1087#1072#1087#1082#1080' '#1085#1072' '#1083#1080#1095#1085#1091#1102' (VIP) '#1087#1072#1087#1082#1091' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
              TabOrder = 0
              OnClick = CheckBox89Click
            end
            object CheckBox90: TCheckBox
              Left = 24
              Top = 38
              Width = 120
              Height = 17
              Caption = #1052#1086#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
              TabOrder = 1
            end
            object CheckBox91: TCheckBox
              Left = 149
              Top = 38
              Width = 120
              Height = 17
              Caption = 'AppData'
              TabOrder = 2
            end
            object CheckBox92: TCheckBox
              Left = 276
              Top = 38
              Width = 120
              Height = 17
              Caption = 'Local AppData'
              TabOrder = 3
            end
          end
          object GroupBox36: TGroupBox
            Left = 8
            Top = 228
            Width = 450
            Height = 153
            Caption = ' '#1055#1072#1087#1082#1072' "'#1052#1086#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099'" '#1074' '#1086#1089#1090#1072#1083#1100#1085#1099#1093' '#1089#1083#1091#1095#1072#1103#1093' '
            TabOrder = 2
            object Label160: TLabel
              Left = 8
              Top = 21
              Width = 44
              Height = 13
              Caption = 'Label160'
            end
            object Label161: TLabel
              Left = 8
              Top = 127
              Width = 198
              Height = 13
              Caption = #1057#1084'. '#1089#1087#1088#1072#1074#1082#1091' '#1076#1083#1103' '#1076#1077#1090#1072#1083#1100#1085#1086#1075#1086' '#1086#1087#1080#1089#1072#1085#1080#1103'!'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object RadioButton6: TRadioButton
              Left = 8
              Top = 43
              Width = 425
              Height = 17
              Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1082#1072#1082' '#1077#1089#1090#1100' '#1074' '#1089#1080#1089#1090#1077#1084#1077
              TabOrder = 0
              OnClick = RadioButton6Click
            end
            object RadioButton7: TRadioButton
              Left = 8
              Top = 63
              Width = 425
              Height = 17
              Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
              TabOrder = 1
              OnClick = RadioButton7Click
            end
            object RadioButton8: TRadioButton
              Left = 8
              Top = 83
              Width = 425
              Height = 17
              Caption = #1055#1077#1088#1077#1085#1072#1087#1088#1072#1074#1080#1090#1100' '#1074' '#1087#1072#1087#1082#1091' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1085#1077' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103')'
              TabOrder = 2
              OnClick = RadioButton8Click
            end
            object RadioButton13: TRadioButton
              Left = 8
              Top = 103
              Width = 425
              Height = 17
              Caption = #1055#1077#1088#1077#1085#1072#1087#1088#1072#1074#1080#1090#1100' '#1074' '#1076#1088#1091#1075#1091#1102' '#1087#1072#1087#1082#1091
              TabOrder = 3
              OnClick = RadioButton13Click
            end
          end
          object CheckBox3: TCheckBox
            Left = 8
            Top = 37
            Width = 169
            Height = 17
            Caption = #1041#1072#1079#1086#1074#1099#1081' '#1087#1091#1090#1100' '#1082' VIP-'#1087#1072#1087#1082#1077':'
            TabOrder = 3
            OnClick = CheckBox3Click
          end
          object Edit5: TEdit
            Left = 251
            Top = 60
            Width = 57
            Height = 21
            MaxLength = 6
            TabOrder = 4
          end
          object CheckBox45: TCheckBox
            Left = 8
            Top = 95
            Width = 450
            Height = 17
            Caption = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1086#1083#1100' '#1087#1088#1080' VIP-'#1083#1086#1075#1080#1085#1077' '#1095#1077#1088#1077#1079' API '#1096#1077#1083#1083#1072' ('#1089#1084'. '#1089#1087#1088#1072#1074#1082#1091')'
            TabOrder = 5
          end
        end
      end
      object TabSheet36: TTabSheet
        Tag = 10
        Caption = #1054#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077
        ImageIndex = 35
        object Panel38: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 500
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object CheckBox153: TCheckBox
            Left = 8
            Top = 109
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1086#1090#1095#1077#1090' '#1086#1073' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1080' '#1087#1088#1080#1085#1090#1077#1088#1072' '#1076#1083#1103' '#1089#1077#1088#1074#1077#1088#1072
            TabOrder = 0
          end
          object GroupBox18: TGroupBox
            Left = 8
            Top = 12
            Width = 450
            Height = 81
            Caption = ' '#1057#1080#1089#1090#1077#1084#1099' '#1072#1091#1090#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1080' '
            TabOrder = 1
            object Label35: TLabel
              Left = 24
              Top = 48
              Width = 93
              Height = 13
              Cursor = crHandPoint
              Caption = #1063#1090#1086' '#1090#1072#1082#1086#1077' iButton?'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              OnClick = Label35Click
            end
            object Label36: TLabel
              Left = 144
              Top = 48
              Width = 61
              Height = 13
              Cursor = crHandPoint
              Caption = #1043#1076#1077' '#1082#1091#1087#1080#1090#1100'?'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsUnderline]
              ParentFont = False
              OnClick = Label36Click
            end
            object Image1: TImage
              Left = 336
              Top = 17
              Width = 96
              Height = 52
              AutoSize = True
              Center = True
              Picture.Data = {
                07544269746D6170B6170000424DB61700000000000036040000280000006000
                000034000000010008000000000080130000120B0000120B0000000100000000
                0000D1CFD400A09BA500FCFBFD00FBFAFC00F4F3F50013111400726B7400B4AC
                B500201E20003C3A3C00F3F1F300F7F6F700F6F5F600F0EFF000302D2E003B37
                38003D3A3A0039373700F1EFEF00F4F3F300F2F1F100EEEDED00EAE9E900EDEA
                E900F9F7F600E8E6E5007D7A7600403F3D0053525000949390005C5C57005757
                55003C3C3B00E9E9E600FDFDFB00E4E4E200E6E6E500E2E3DE00494A4700EAEB
                E800E5E6E300393A3800F8F9F700F6F7F500F4F5F300F3F4F200F2F3F100F1F2
                F000F0F1EF00939790001F231D00EDEFEC00ECEEEB00B2B5B100CFD3CE003A3D
                3A0040424000EEF1EE00EAEDEA00A2A4A200F9FAF900F7FAF800F5F8F600F4F7
                F500EFF2F000E8EBE900E7EAE800E6E9E700E2E5E3003C403E0044484600E6EC
                E900DAE0DD00EBEFED00FAFCFB00E9EBEA00E7E9E80077817D00C4C9C700B8C0
                BD005A605E00A8B1AE00B2BBB800E9ECEB00D7DAD9008F9996009FA9A600EFF3
                F200E7EBEA0097A19F0084898800F1F6F500EFF4F300E4E9E800E4EAE9005259
                580068717000DDE6E500AAB6B500929C9B009BA5A40098A8A7005D6868004249
                49009BAAAA00555B5B004A4F4F004E53530051555500BDC6C6005F6363005D61
                6100E1EAEA0065696900A5ABAB00C9CFCF0043454500E0E6E600EBF0F000F0F4
                F4003D3E3E00393A3A0036373700F7FAFA00F5F8F800F1F4F400EDF0F000EBEE
                EE00E0E3E3004B4C4C00FBFDFD00F6F8F800F4F6F600F3F5F500F2F4F400F0F2
                F200EEF0F000ECEEEE00EAECEC00E5E7E700E4E6E600E3E5E500F2F3F300F0F1
                F100EAEBEB00E8E9E90092A6A700626D6E0092A1A20096A5A60087949500A0AF
                B000919FA00095A1A200384243008FA0A2008292940092A2A400B0BEC000B5C3
                C500EAF2F300A6BFC3009DB4B800596567008A97990096A2A4004B515200BFCC
                CE005A606100CAD5D7008C9B9E00585D5E00879BA0008B9DA10085969A009AA6
                A900E9EDEE0082959A0087999E00788D94007D91980082969D0081939900B8CB
                D200A3AFB30085969D0096A8AF0078858A009CABB200717A7E00393D3F00464A
                4C0060646600839BAA0032373A00353A3D00869299003D42450045525B003E48
                4F006A737900838D94006B8FAA007D93A40094A2AC00596167002E323500667A
                8A005660680084929D00373E44003C4349008997A40070859900444D56004A53
                5C004E576000818F9D0041454900F6F7F800F0F1F200505B6700646D77004C5F
                76005A687900262B3100474C52002B2E320053565A00404F65005D646E002729
                2C005D6167003540520016181C0024262A00383A3E002F303200191B20001E20
                25003B425600232326002A2A2D0034343500F2F2F50058585900EDEDEE00E9E9
                EA00FEFEFE00F8F8F800F5F5F500F4F4F400EFEFEF00EDEDED00474747000000
                0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFF14141313131313FBFBFB868E868686868E86FBFB858585868686FB8686
                8686FB132D2D2D2D2C2C2D2D2C2E14142D2E2E2D2D5740408F8989898989897F
                7F8A8A7F7F7F7F7E7E888F8F8787575C5B5C777D858485843E83838383838383
                83FFFF14141313131313FB13138686868686868786FBFB868686868686FB8686
                86FBFAFB2D2D2D2D2D2D2E2E2D2F0D1430302F2F2F393939898989898989897F
                7F8A4B8A8A8A8A8A8A89887E7E8888575C5C5C5C868585858484853E3E838383
                83FFFF87878686868E8E8613138686868686868EFBFBFBFB8686868613138686
                8686132D2D2D2D2D2D2D2E2F2F2F8F8830303040FC8876898989897E897F8A53
                534B41538A8A534B908A7F8A8A8976767E575C5C5C7D86858586853E3E838383
                3DFFFF87575787878E8E86FBFBFBFBFBFBFBFBFBFAFA131313131313140A8E87
                878E13130A0A2E57572E30303040887E880D88887E7E8989898A4B4B4B4B4B41
                424242434C4343212127412727413A3A3A3A49885757878E868684843E3E8383
                3DFFFF8E8E8787878E8E86FBFBFBFBFBFBFBFBFBFBFB1313141413FBFB138E87
                8787141414142E40302F303030FC7E89FCFCFC7E8989897F7F8A4B4C4C414143
                434C4134393427282348484825442827392E3033F6888888878E868584848383
                3DFFFF13148787871413FBFBFBFBFB86868686131313138E8E862D2D2D14142F
                2F1414141414408840300D887E888989897E897F897F7F8A4B4B4B4243424343
                3439804EB863C9BDE6ABE4E4E4AB71BD5A3B4E442C3989FC402E8686853F3F3E
                3EFFFF14138E87878EFBFB131313138E8E8E8E0A0A14148787872E2E2F142F2F
                2F2F1414140D887E880DFC89898989897F897F8A7F8A4B4B414C4242414B398D
                A7CCDEDDC6C7D3C520792045782029797A4567C0725449393940578685843F3E
                3EFFFF8F8F8E86868E8E8E1414148E8E8E8E8E8F8F14148F8F2F2E2E87DC8F2F
                2F2F0D0D8F88887E7EFCFC7E89897F7F7F8A8A8A8A8A4B4B41434241398B6DBB
                DDE5C6E2BEF3291B74FE2638793745297A373738466959482F33302E7D853F3E
                3EFFFF8787878686878787141487578E8E8E8E578714141414142F2E8788880D
                0D0D0D887E8989897E89897F7F7F7F7F8A4B8A4B414B41414141347E9FCFDFDD
                D7742909811A5A1F4579EDE7EBE7F1EBE7E3F2F2ED796A60352F39392E7D3F3E
                3EFFFF878787868687878714148787878787878787141414142F2F2F308888FC
                FCFCFCFC8989898989897F8A8A8A8A8A8A4B4B414C4C4C43423444CCDFDFDDBF
                201B261E5A5A1FF1050EF374741BF30E08EEEE08E7EBE36771354140392E3F3E
                3EFFFF14148E8E8E8E878714141414141414141414141414141430FCFCFCFCFC
                FCFC7E7E897E7E898989898A8A4B414B4B4B4B41434141423473D5DFDFD8741B
                1B387874782646CEF11B7481743878F3F1EAEEEEEEEFF1E7C269598C302F2C2B
                2AFFFF1414878787875787141414140D0D0D0D0D0D0D0D0D0D0D0D1515151515
                15FC88887E89898A4B4B4B8A414C4C4B4B4141438B43423A4ECFDFDFA61B09F3
                F2F37A7AFE6C745FBF063B51515655BBC0BF09F2EFF1EFF1EBCEAB5157302D2B
                2AFFFF1414148787878F8F0D0D14140D0D0D0DFC0D0D0D0DFCFC888915151589
                897F7F7F7F7F7F8A8A8A4B8A4B41414158414C4343433473CFDFE0A61B79EBE3
                7AF3F3ECC56A6BBF5F00A0A99F62629768AABBC8C5E7E7E7EBE3CE9354FA2D2B
                18FFFF14141414141414140D0D0DFC151515FCFCFC15151515FD8A8A908A7F8A
                8A414141414141418A8A7F7F8A534141414142424217A9BBDFE681FEE3E77AED
                E3CEF3456BAB67F3EBC896BBBDC8607171DEC8BB9C4DDAF1C2CECEC2AA762C2B
                18FFFF14141414141414140D0D0DFC151515151515FDFDFDFDFD4B4B4B58424C
                4343434C4C4C4C434C414C4C41414242424343413354B3E0E01C26E30E0FF2E3
                0EEDC345EDEBF367BF60A4995998A45A4D606E6966BBADE4F2C2EDE3DDA918FA
                18FFFF1414141414140D0D0DFCFC15FDFDFDFDFDFD7F8A8A4B41414343438B8C
                8C8B8B8B8B8B8B8B8B424243434343434227345373BBE0DEF581E3ED7AE7EBE7
                EDCEE7EBE7BF93BDBB689F9F9E9E9E625156635A7169BDBCABE7BECED2623D18
                18FFFF14141414140DFCFCFC1515FDFDFDFDFDFD90584C4C438B8B8C8D8D8C8D
                8D8D8D8D8D8C8C8C8C43438B4343434217344851BDE0C86E1CC3E37AE7EBF1F2
                F208EFC5A8C89C98B89E9F9F9F9E9E9E9E9E9E62594DABBBA2E39AC3C2AC2A18
                18FFFF14141414140D1515FCFDFD8AFDFD9090914C8B8C8D8D8D8D8D44448D8D
                8D8D44448D8D8C2424434321214134245452B3DEDEBDC81F6AEB78F2EBF1EDEB
                EAE3A666BB94979E9F9F9F9F9F9F9F9F9F9E9F9F52515AE8A2ABE3D6C3B52B18
                18FFFF14141414FCFC151515FD8A534B414C8B8B8C8C44444444444444448D44
                44242424282824192717172723365296BDDEC8BDBDBD1F1CE1EBCEF2F1EDF2EE
                E3A6C8A4B89E9F9F9F9E9FA7A7A79F9F9F6D9F9F9E9E525AB9C1E7D6C3B52A2A
                18FFFF0D0D0D0DFCFC15FDFD1641438B8C8D8C8D8D4480808044444444282428
                242121171717212348366D5196BDDEDEC8BDBBBBBD1E6CECEFEBCEF2F1CEEBCE
                E2BDA5629E9EB8BC97525263BD6071E8E4ABE6BBB89F9F5263A1C2D6C3CC2218
                18FFFF0D0D0D14FCFC15FD918B8C444444448D8D8D2828242419192828254854
                364E4F355663965A4DC8DEE693DEC8BDBDBDC871F51FC5EFEBF2EDE2D7E9E1E2
                C89552B8D4D9C4C901070751726463A4C9BDE6A8D0DE95A74F9DC2C79AA1F82A
                2AFFFF0D0D0D0DFC15FD168B8C8C8D232828282323255436734F3556635ABD93
                D0D8D7C6C6D7D8DDD0E6DEC8C8BDBDC871AB1F1C6ADAEFE7E7EBEECFD5E9C6BB
                AF62D4CFDEE6060100480052AF989495686892AAC4DEBFBBA95AE1C7D748222A
                2AFFFF0D0DFCFC1515FDF78D544E6D6D4E6D4F35513B315A60A8D6C7D3D2D2D3
                C7D6D7D8D0CDE6E693DEC8C860C06CBF81818181BFE1F2EDEBEFD2C1E6D3BBBC
                BCD5E0DDD6E66D5451AAB2B1B5B198989B949565B8BCC4BFC94EE4C3BB7B3C2A
                2AFFFF0D0DFCFC15FCFD4872C85F6BAB7171717171716E6FF56CA6E2BFBFE26A
                6A6A6A6A6A8181BF8181FE741B1B1B74FEFE81C5E7E3C2E3E7EFE6D4D6D6B6CC
                CFDFF0E9D9B8A5B6B6B6B4B4B6B1ADAAAAAA9494A5689EBAD7625AE248F82A3C
                3DFFFF14140DFC15FC4352C074290F101010202037372010101110100F292929
                29111111117A11110F0F20781B74FE207929CEEBCEC2CEE3F2F1C8B6D3D8D1CA
                E0E9F0D5A496B1B4B4B3B6A4AAB2ADADACACAAAA959964B7B5BB1D55F83C2A3C
                3DFFFF87578F0D3015365A6B387820BEBEECC37A2979ECEC79ECECECECECBEBE
                45ECECECECC3ECBEECECC3D29AC5D2C3C3C3CECEC2CEE3E3E3EBC8C4D2CDCBCA
                E5E5D5C9AEB5B5B1B4B1AAAAAAADADB1AD9BAAAA956864B8A9E65247023C3D3D
                3CFFFF8E878714144C68ABDAC5C5C59AD3C5D2C59AD2D2BEC5D3C5BEBEBEBED2
                D29AD2C5C5D3C5C5C5C5DAA66C696CA66C6BC2CECEE3CEE3CEE3A898DAC8CAE0
                E9D5B3A4B5B3B4AEACACADB2ADADACB2AD9894989D656599A9C89FF8F9833D3D
                2AFFFF8E8787871343BBBFE4E46C6BA66B6CE469F55FA66A6C6C6C6BA66A6A6B
                6B6C6C6CE4E46B6C6A6C6B6C6AA66C6AABABA6C3E3CECECEC2C3BE59A3D5CAD2
                CFB3C4ACB5B3B1B2AEADB9ACADADB29B9B95A5A59D9D9D98A7BB9F223C3D3D3D
                3DFFFF8787878786FD556B6CBF67C581816C69A6BFBFBFBEEBEB455FA8A8A86F
                506F6F6F6E6FA86F6F6F50AB69BFC56A6BAB69A667CEE1C2BEC3EB715ACAE0E5
                CBC9B9B3B3B4B1AEB9B4AEADACADAD9B999595A59B9B95999E9C704A3D3D3D3D
                3DFFFF878787875713A793DABF6B9ABF1F1A1D314D6CDAC5E1EEEEC26C6E6E6E
                6E6E6F6E6E6F6F6F50506F50A8ABBFC5746A6B6A6CDACEC2C3C2F1F393C1DDCF
                AAB6B5B4B4B1B6B2ADB5B9B2B5AD9D639899956894AA9B949FA2F82A3D3D3D3D
                3DFFFF8787878787137F4F6667A69AE7F21B1E4D311D71BFDAC2EEEAF2816F6F
                6F6F6F6F6F6F6F5050A8A8A8ABABA8A6C538A66C6C6CBFC3CECECEECA6C1D6D4
                63B1B4B3B4B1B3B4B9B2ADB2AC9B9B9898949D959B9BADA262A9F83D3D3D3D3D
                3DFFFF87878787878EFBFC6DBD67C2EE05054650385071E4BFE2BEEB05F14669
                6F6E6E6E6E50506F6F6FA8A8A8A8A8A85F46BFA65F5F69A6BEC2C2C2A6ADC7AF
                98B5B4BBB4B1B6B6B4ACACB1AAAEAA949D98949D9B6595B895833C3D3D3D3D3D
                83FFFF87878787878713FB12546369C3EF32314DEEF1EDBEC5676BBFF2EA0879
                6C69ABABABABABABABABABAB69696969696C67676B5F5F696BD3C2C2ECC9AB64
                9DB5B6B4B4B1AEB4B6ACB5B1AA98AA94989498AD9294976870823D3D3D3D3D3D
                83FFFF87878787878787877D8E167359A36A4DC5EAEEEEEFE1BF6C5F6BECEEEA
                EBEBE7E1E1E1E1E1E1E3E3E1E7E7E7E7EBEBEBBEDABF6C6C5F696AECCEC05A5A
                68B4B4B3B4B1B6B6ACB4B6AAAA98989498AAAA9498659775F883833D3D3D8383
                83FFFF8F8F8F87878787878E8685F44C73564DA6D2E3E1E1C36A6B6CE4A6ECF2
                EE05EAEAEAEAEEEEEEEAEAEEEEEEEEEEEAEAEAEEBEBF6A6C6C5F6F6CC3CE606F
                B8B2B4B3BBB4B4B4B4B3B1B2AA9898949994AAAA959775F83E83838383838383
                83FFFF14148F8F8787878E8E8E7D85858753486D565AC8936E505050695F5F6B
                676767676767BF67DAC5C57467676767C5DA6767A66C6B6ABF6A6AA66AC3C2E4
                BD97ADB6B4B4B5B6B3B4B5B6AEAEADADADAAAA95A7764A3E3E83838383838383
                83FFFF14148F8F8787878E8E8E86867D7D850C04FC8C48364E4F4F4F4F525252
                5252526262516251515151515151516262524F4F4F4F4F4F62725655BB609ACE
                6A60659BB4B1ACB4B3B4B4B4B6B1ACB6B1929E6182033E3E8383838383838383
                83FFFF8F87878F8787878E8E8E8686868E8E77860404040A0A0A0A0A04040404
                0404040C0C04FA0C0C0B0B0BF9F93C0303030302020203020202030385754FBD
                BD645A639BB9B2B4B1B4B3B1B3B492976D617B4A7C7C3E3E8383838383838383
                83FFFF888787141487878787878E8E8E8E8E8E8E8E8E8E868585858585858484
                84848585858584843E3E3E3E3E3E3E848484848484848484843F3E833D3C827C
                3DF884486D626565686565689EA961574A3C3E3E3E3E3E3E3E3E3E3E3E838383
                3EFFFF8887871414878787878787878E8E8E8E8E8E8E8E868686868686868585
                85858686868685858484848484848484848484848484848484843E3E3E84847C
                3D0BF94AF87BB05D5E42535C7B823C2A833E84843E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFF14148F8F8F878787878787878787878E8E8E8E8E8E8E86868686868686
                86868686868685858585858484848484848484848484848484843E3E3E848484
                848484843E833D7B7B3C3C3DDBDBDB3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFF14148F8F8F878787878787878787878E8E8E8E8E8E8E86868686868686
                8686868686868585858585848484848484848484848484848484848484848484
                848484843E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFF1414148F8F8F8F87878787878787878E8E8E8E8E8E8E86868686868686
                8686868686868585858585848484848484848484848484848484848484848484
                848484843E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFF0D0D141414140D88888888878E8E8E8E878E8E8E8E8E8E8E8E8E8E8E8E
                8E86868686868686868686858585858584848484848484848484848484848484
                8484848484848484843E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFF0D0D1414140DFC888888888F8F8F8F878787878787878E8E8E8E8E8E8E
                8E86868686868686868686868685858584848484848484848484848484848484
                8484848484848484843E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E3E
                3EFFFFFCFC888888887E8888888F8F8F8F8F8787878787878787878787878E8E
                8E8E8E8686868686868686868686868685848484848484848484848484848484
                8484848484848484843E3E3E3E3E3E3E3E3E3E3E3E3E84843E3E3E8484848484
                3EFFFFFCFCFC7E7E7E7E888888887E8888888F8F878787878787878787878E8E
                8E8E8E8686868686868686868686868686868686868686868686858584848484
                84848484848484848484848484843E3E3E3E3E3E3E3E84843E3E3E8484848484
                3EFFFFFCFCFCFCFCFCFC888888887E8888888F8F878787878787878787878E8E
                8E8E8E8686868686868686868686868686868686868686868686868685848484
                84848484848484848484848484843E3E3E3E3E3E3E3E84848484848484848484
                3EFFFFFCFCFCFCFCFCFCFC7E7E8888880D0D8888888888888787878787878787
                8787878E8E8E8686868686868686868686868686868686868686868685858585
                85858585858584848484848484848484843E3E3E848484848484848484848484
                85FFFFFCFCFCFCFCFCFCFC7E7E8888880D0D887E888888888F8F8F8F8F8F8787
                8787878E8E8E8686868686868686868686868686868686868686868685858585
                8585858585858484848484848484848484858584848484848484848484848484
                85FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFF}
            end
            object CheckBox39: TCheckBox
              Left = 8
              Top = 24
              Width = 209
              Height = 17
              Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1087#1086#1076#1076#1077#1088#1078#1082#1091' iButton'
              TabOrder = 0
            end
          end
        end
      end
      object TabSheet42: TTabSheet
        Tag = 11
        Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1092#1072#1081#1083#1072#1084#1080
        ImageIndex = 41
        object Panel27: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox22: TGroupBox
            Left = 8
            Top = 9
            Width = 450
            Height = 112
            Caption = ' '#1055#1072#1087#1082#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '
            TabOrder = 0
            object Label16: TLabel
              Left = 238
              Top = 23
              Width = 45
              Height = 13
              Caption = 'C:\TEMP'
            end
            object Label79: TLabel
              Left = 8
              Top = 48
              Width = 86
              Height = 13
              Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1087#1072#1087#1082#1080
            end
            object Label80: TLabel
              Left = 172
              Top = 48
              Width = 24
              Height = 13
              Caption = #1076#1085#1077#1081
            end
            object Label87: TLabel
              Left = 7
              Top = 80
              Width = 78
              Height = 13
              Caption = #1060#1086#1088#1084#1072#1090' '#1087#1072#1087#1082#1080':'
            end
            object CheckBox19: TCheckBox
              Left = 8
              Top = 21
              Width = 220
              Height = 17
              Caption = #1055#1091#1090#1100' '#1082' '#1087#1072#1087#1082#1077' ('#1088#1077#1082#1086#1084#1077#1085#1076'. '#1089#1077#1090#1077#1074#1086#1081'):'
              TabOrder = 0
              OnClick = CheckBox19Click
            end
            object ComboBox6: TComboBox
              Left = 118
              Top = 43
              Width = 49
              Height = 21
              Style = csDropDownList
              DropDownCount = 15
              ItemHeight = 13
              TabOrder = 1
              Items.Strings = (
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '10'
                '11'
                '12'
                '13'
                '14'
                '15'
                '16'
                '17'
                '18'
                '19'
                '20'
                '21'
                '22'
                '23'
                '24'
                '25'
                '26'
                '27'
                '28'
                '29'
                '30')
            end
            object Edit21: TEdit
              Left = 118
              Top = 75
              Width = 216
              Height = 21
              MaxLength = 250
              TabOrder = 2
            end
          end
          object GroupBox14: TGroupBox
            Left = 8
            Top = 133
            Width = 450
            Height = 196
            Caption = ' '#1056#1077#1089#1091#1088#1089#1099' '
            TabOrder = 1
            object Label91: TLabel
              Left = 246
              Top = 41
              Width = 45
              Height = 13
              Caption = 'C:\TEMP'
            end
            object Label67: TLabel
              Left = 246
              Top = 81
              Width = 45
              Height = 13
              Caption = 'C:\TEMP'
            end
            object Label15: TLabel
              Left = 246
              Top = 121
              Width = 45
              Height = 13
              Caption = 'C:\TEMP'
            end
            object CheckBox51: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' Flash-'#1076#1080#1089#1082' ('#1073#1077#1079#1086#1087#1072#1089#1085#1086' '#1086#1090' '#1074#1080#1088#1091#1089#1086#1074'!)'
              TabOrder = 0
              OnClick = CheckBox51Click
            end
            object CheckBox52: TCheckBox
              Left = 8
              Top = 39
              Width = 235
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1077#1090#1077#1074#1086#1081' Flash-'#1076#1080#1089#1082':'
              TabOrder = 1
              OnClick = CheckBox52Click
            end
            object CheckBox32: TCheckBox
              Left = 8
              Top = 59
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1076#1080#1089#1082#1077#1090#1091' ('#1073#1077#1079#1086#1087#1072#1089#1085#1086' '#1086#1090' '#1074#1080#1088#1091#1089#1086#1074'!)'
              TabOrder = 2
              OnClick = CheckBox32Click
            end
            object CheckBox37: TCheckBox
              Left = 8
              Top = 79
              Width = 235
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1077#1090#1077#1074#1091#1102' '#1076#1080#1089#1082#1077#1090#1091':'
              TabOrder = 3
              OnClick = CheckBox37Click
            end
            object CheckBox33: TCheckBox
              Left = 8
              Top = 99
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' CD-ROM ('#1073#1077#1079#1086#1087#1072#1089#1085#1086' '#1086#1090' '#1074#1080#1088#1091#1089#1086#1074'!)'
              TabOrder = 4
              OnClick = CheckBox33Click
            end
            object CheckBox49: TCheckBox
              Left = 8
              Top = 119
              Width = 235
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1077#1090#1077#1074#1086#1081' CD-ROM:'
              TabOrder = 5
              OnClick = CheckBox49Click
            end
            object CheckBox141: TCheckBox
              Left = 8
              Top = 149
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1088#1072#1073#1086#1090#1099' '#1089' Flash'
              TabOrder = 6
            end
            object CheckBox156: TCheckBox
              Left = 8
              Top = 169
              Width = 425
              Height = 17
              Caption = 
                #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1087#1088#1086#1089#1084#1086#1090#1088#1072' DVD-'#1092#1080#1083#1100#1084#1086#1074' '#1089' ' +
                #1076#1080#1089#1082#1086#1074
              TabOrder = 7
            end
          end
        end
      end
      object TabSheet27: TTabSheet
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100
        ImageIndex = 9
        object Panel33: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet5: TTabSheet
        Tag = 12
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1057#1080#1089#1090#1077#1084#1072
        ImageIndex = 4
        OnShow = TabSheet5Show
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label19: TLabel
            Left = 8
            Top = 16
            Width = 107
            Height = 13
            Caption = #1057#1080#1089#1090#1077#1084#1085#1099#1077' '#1079#1072#1087#1088#1077#1090#1099':'
          end
          object CheckListBox1: TCheckListBox
            Left = 8
            Top = 34
            Width = 409
            Height = 404
            ItemHeight = 16
            Items.Strings = (
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1044#1080#1089#1087#1077#1090#1095#1077#1088' '#1047#1072#1076#1072#1095' Windows'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "'#1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103'"'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "'#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1088#1072#1073#1086#1095#1077#1081' '#1089#1090#1072#1085#1094#1080#1080'"'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "'#1042#1099#1093#1086#1076' '#1080#1079' '#1089#1080#1089#1090#1077#1084#1099'"'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "'#1047#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1088#1072#1073#1086#1090#1099'"'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1086#1088' '#1088#1077#1077#1089#1090#1088#1072' Windows'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "Switch User" (Vista)'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1084#1077#1085#1102' "'#1060#1072#1081#1083'" '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1072
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1086#1073#1097#1077#1075#1086' '#1089#1077#1090#1077#1074#1086#1075#1086' '#1076#1086#1089#1090#1091#1087#1072
              #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1089#1077#1090#1080
              #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1088#1072#1073#1086#1095#1077#1081' '#1075#1088#1091#1087#1087#1099
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1077#1090#1080
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1086#1085#1090#1077#1082#1089#1090#1085#1086#1077' '#1084#1077#1085#1102' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#39'Favorites'#39' '#1074' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#39'Help'#39' '#1074' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1072#1085#1077#1083#1077#1081' '#1074' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1090#1091#1083'-'#1073#1072#1088#1086#1074' '#1074' IE'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1074' IE/Explorer'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1083#1086#1082#1072#1083#1100#1085#1099#1077'/'#1089#1077#1090#1077#1074#1099#1077' '#1087#1091#1090#1080' '#1074' IE/Explorer'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1072#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1080#1089#1082#1086#1074' ('#1085#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103')'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1086#1085#1090#1077#1082#1089#1090#1085#1086#1077' '#1084#1077#1085#1102' '#1074' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1085#1072#1093
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077' '#1087#1088#1080#1085#1090#1077#1088#1086#1074
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1080#1085#1090#1077#1088#1086#1074
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080#1081' '#1089#1077#1090#1077#1074#1086#1081' '#1087#1086#1080#1089#1082' '#1087#1072#1087#1086#1082'/'#1087#1088#1080#1085#1090#1077#1088#1086#1074
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077'/'#1086#1090#1082#1083#1102#1095#1077#1085#1080#1077' '#1089#1077#1090#1077#1074#1099#1093' '#1076#1080#1089#1082#1086#1074
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' Windows Update'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1087#1072#1087#1086#1082' '#1074' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1085#1072#1093' Open/Save'
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1091#1076#1072#1083#1077#1085#1085#1086#1075#1086' '#1076#1086#1089#1090#1091#1087#1072' (Dial-up)')
            Style = lbOwnerDrawFixed
            TabOrder = 0
          end
        end
      end
      object TabSheet13: TTabSheet
        Tag = 13
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1060#1072#1081#1083#1099
        ImageIndex = 11
        object Panel20: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label61: TLabel
            Left = 8
            Top = 14
            Width = 246
            Height = 13
            Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1090#1080#1087#1099' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072' '#1074' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103#1093':'
          end
          object Label32: TLabel
            Left = 7
            Top = 67
            Width = 133
            Height = 13
            Caption = #1047#1072#1087#1088#1077#1097#1077#1085#1085#1099#1077' '#1087#1088#1086#1090#1086#1082#1086#1083#1099':'
          end
          object Label143: TLabel
            Left = 8
            Top = 200
            Width = 389
            Height = 13
            Caption = 
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1076#1080#1072#1083#1086#1075#1086#1074' '#1088#1072#1073#1086#1090#1099' '#1089' '#1092#1072#1081#1083#1072#1084#1080' '#1074' '#1101#1090#1080#1093' '#1087#1088#1080#1083#1086#1078#1077 +
              #1085#1080#1103#1093':'
          end
          object Edit10: TEdit
            Left = 8
            Top = 30
            Width = 425
            Height = 21
            MaxLength = 4000
            TabOrder = 0
          end
          object CheckBox34: TCheckBox
            Left = 8
            Top = 154
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1099#1077' '#1076#1080#1072#1083#1086#1075#1080' '#1088#1072#1073#1086#1090#1099' '#1089' '#1092#1072#1081#1083#1072#1084#1080
            TabOrder = 1
          end
          object CheckBox123: TCheckBox
            Left = 8
            Top = 94
            Width = 450
            Height = 17
            Caption = 
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1079#1072#1087#1088#1077#1097#1077#1085#1085#1099#1093' '#1092#1072#1081#1083#1086#1074' '#1080' '#1087#1088#1086#1090#1086#1082#1086#1083#1086#1074' '#1080#1079' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1087#1088 +
              #1086#1075#1088#1072#1084#1084
            TabOrder = 2
          end
          object CheckBox128: TCheckBox
            Left = 8
            Top = 134
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1091#1076#1072#1083#1077#1085#1080#1077'/'#1087#1077#1088#1077#1085#1086#1089' '#1087#1072#1087#1086#1082' '#1080#1079' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084
            TabOrder = 3
          end
          object Edit59: TEdit
            Left = 177
            Top = 62
            Width = 256
            Height = 21
            MaxLength = 240
            TabOrder = 4
          end
          object CheckBox38: TCheckBox
            Left = 8
            Top = 174
            Width = 450
            Height = 17
            Caption = 
              #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1082#1085#1086#1087#1082#1091' "'#1057#1086#1079#1076#1072#1090#1100' '#1087#1072#1087#1082#1091'" '#1074' '#1089#1080#1089#1090#1077#1084#1085#1099#1093' '#1076#1080#1072#1083#1086#1075#1072#1093' '#1088#1072#1073#1086#1090#1099' '#1089' '#1092 +
              #1072#1081#1083#1072#1084#1080
            TabOrder = 5
          end
          object CheckBox74: TCheckBox
            Left = 8
            Top = 114
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1083#1102#1073#1099#1093' '#1092#1072#1081#1083#1086#1074' '#1080#1079' '#1103#1088#1083#1099#1082#1086#1074'-'#1089#1089#1099#1083#1086#1082' '#1085#1072' '#1087#1072#1087#1082#1080
            TabOrder = 6
          end
          object Edit97: TEdit
            Left = 8
            Top = 216
            Width = 425
            Height = 21
            MaxLength = 250
            TabOrder = 7
          end
        end
      end
      object TabSheet6: TTabSheet
        Tag = 14
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1044#1080#1089#1082#1080
        ImageIndex = 5
        OnShow = TabSheet6Show
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label20: TLabel
            Left = 8
            Top = 10
            Width = 355
            Height = 13
            Caption = 
              #1047#1072#1087#1088#1077#1090#1080#1090#1100'/'#1089#1082#1088#1099#1090#1100' '#1076#1086#1089#1090#1091#1087' '#1082' '#1076#1080#1089#1082#1072#1084' '#1074' IE, Explorer '#1080' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1085 +
              #1072#1093':'
          end
          object Label22: TLabel
            Left = 8
            Top = 422
            Width = 353
            Height = 13
            Caption = #1053#1072#1089#1090#1086#1103#1090#1077#1083#1100#1085#1086' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1090#1089#1103' '#1088#1072#1079#1088#1077#1096#1080#1090#1100' '#1076#1080#1089#1082', '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1084#1099#1081' Flash !'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object GroupBox4: TGroupBox
            Left = 8
            Top = 30
            Width = 129
            Height = 380
            Caption = ' '#1047#1072#1087#1088#1077#1090#1080#1090#1100' '
            TabOrder = 0
            object CheckListBox2: TCheckListBox
              Left = 8
              Top = 20
              Width = 97
              Height = 292
              ItemHeight = 16
              Items.Strings = (
                'A:'
                'B:'
                'C:'
                'D:'
                'E:'
                'F:'
                'G:'
                'H:'
                'I:'
                'J:'
                'K:'
                'L:'
                'M:'
                'N:'
                'O:'
                'P:'
                'Q:'
                'R:'
                'S:'
                'T:'
                'U:'
                'V:'
                'W:'
                'X:'
                'Y:'
                'Z:')
              Style = lbOwnerDrawFixed
              TabOrder = 0
            end
            object Button5: TButton
              Left = 8
              Top = 322
              Width = 97
              Height = 20
              Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
              TabOrder = 1
              OnClick = Button5Click
            end
            object Button6: TButton
              Left = 8
              Top = 346
              Width = 97
              Height = 20
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077
              TabOrder = 2
              OnClick = Button6Click
            end
          end
          object GroupBox5: TGroupBox
            Left = 192
            Top = 30
            Width = 129
            Height = 380
            Caption = ' '#1057#1082#1088#1099#1090#1100' '
            TabOrder = 1
            object CheckListBox3: TCheckListBox
              Left = 8
              Top = 20
              Width = 97
              Height = 292
              ItemHeight = 16
              Items.Strings = (
                'A:'
                'B:'
                'C:'
                'D:'
                'E:'
                'F:'
                'G:'
                'H:'
                'I:'
                'J:'
                'K:'
                'L:'
                'M:'
                'N:'
                'O:'
                'P:'
                'Q:'
                'R:'
                'S:'
                'T:'
                'U:'
                'V:'
                'W:'
                'X:'
                'Y:'
                'Z:')
              Style = lbOwnerDrawFixed
              TabOrder = 0
            end
            object Button7: TButton
              Left = 8
              Top = 322
              Width = 97
              Height = 20
              Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
              TabOrder = 1
              OnClick = Button7Click
            end
            object Button8: TButton
              Left = 8
              Top = 346
              Width = 97
              Height = 20
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077
              TabOrder = 2
              OnClick = Button8Click
            end
          end
        end
      end
      object TabSheet7: TTabSheet
        Tag = 15
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1055#1088#1086#1075#1088#1072#1084#1084#1099
        ImageIndex = 6
        OnShow = TabSheet7Show
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label23: TLabel
            Left = 8
            Top = 16
            Width = 137
            Height = 13
            Caption = #1047#1072#1087#1088#1077#1090' '#1079#1072#1087#1091#1089#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1084':'
          end
          object Label30: TLabel
            Left = 8
            Top = 376
            Width = 53
            Height = 13
            Caption = 'EXE-'#1092#1072#1081#1083':'
          end
          object Label50: TLabel
            Left = 200
            Top = 16
            Width = 149
            Height = 13
            Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' (*):'
          end
          object Label53: TLabel
            Left = 200
            Top = 376
            Width = 53
            Height = 13
            Caption = 'EXE-'#1092#1072#1081#1083':'
          end
          object Label54: TLabel
            Left = 8
            Top = 416
            Width = 366
            Height = 13
            Caption = 
              '(*) '#1088#1072#1079#1088#1077#1096#1077#1085#1085#1099#1081' '#1089#1087#1080#1089#1086#1082' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1079#1072#1087#1091#1089#1082#1072' '#1080#1079' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1087#1088#1080#1083#1086#1078#1077#1085 +
              #1080#1081
          end
          object Label29: TLabel
            Left = 8
            Top = 440
            Width = 222
            Height = 13
            Caption = #1042' '#1089#1087#1080#1089#1082#1072#1093' '#1084#1086#1078#1085#1086' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1084#1072#1089#1082#1080' * '#1080' ?'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object ListView1: TListView
            Left = 8
            Top = 40
            Width = 161
            Height = 320
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 130
                MinWidth = 130
                Width = 130
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView1SelectItem
          end
          object Edit6: TEdit
            Left = 67
            Top = 372
            Width = 102
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit6Change
          end
          object ListView7: TListView
            Left = 200
            Top = 40
            Width = 161
            Height = 320
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 130
                MinWidth = 130
                Width = 130
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 2
            ViewStyle = vsReport
            OnSelectItem = ListView7SelectItem
          end
          object Edit11: TEdit
            Left = 259
            Top = 372
            Width = 102
            Height = 21
            MaxLength = 100
            TabOrder = 3
            OnChange = Edit11Change
          end
        end
      end
      object TabSheet9: TTabSheet
        Tag = 16
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1054#1082#1085#1072
        ImageIndex = 8
        OnShow = TabSheet9Show
        object Panel10: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label31: TLabel
            Left = 8
            Top = 16
            Width = 342
            Height = 13
            Caption = 'C'#1087#1080#1089#1086#1082' '#1086#1082#1086#1085', '#1082#1086#1090#1086#1088#1099#1077' '#1073#1091#1076#1091#1090' '#1079#1072#1082#1088#1099#1074#1072#1090#1100#1089#1103' '#1074' '#1088#1077#1078#1080#1084#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
          end
          object Label33: TLabel
            Left = 8
            Top = 298
            Width = 61
            Height = 13
            Caption = #1050#1083#1072#1089#1089' '#1086#1082#1085#1072':'
          end
          object Label34: TLabel
            Left = 8
            Top = 322
            Width = 57
            Height = 13
            Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082':'
          end
          object ListView3: TListView
            Left = 8
            Top = 34
            Width = 433
            Height = 250
            Checkboxes = True
            Columns = <
              item
                Caption = #1050#1083#1072#1089#1089' '#1086#1082#1085#1072
                MaxWidth = 180
                MinWidth = 180
                Width = 180
              end
              item
                Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1086#1082#1085#1072
                MaxWidth = 215
                MinWidth = 215
                Width = 215
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView3SelectItem
          end
          object Edit7: TEdit
            Left = 95
            Top = 294
            Width = 202
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit7Change
          end
          object Edit8: TEdit
            Left = 95
            Top = 318
            Width = 346
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit8Change
          end
          object Button11: TButton
            Left = 307
            Top = 294
            Width = 134
            Height = 21
            Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1082#1083#1072#1089#1089'...'
            TabOrder = 3
            OnClick = Button11Click
          end
          object CheckBox98: TCheckBox
            Left = 8
            Top = 360
            Width = 450
            Height = 17
            Caption = #1047#1072#1082#1088#1099#1074#1072#1090#1100' '#1086#1082#1085#1072', '#1076#1072#1078#1077' '#1077#1089#1083#1080' '#1086#1085#1080' '#1085#1077' '#1072#1082#1090#1080#1074#1085#1099
            TabOrder = 4
          end
        end
      end
      object TabSheet8: TTabSheet
        Tag = 17
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1058#1088#1077#1081
        ImageIndex = 7
        OnShow = TabSheet8Show
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label25: TLabel
            Left = 8
            Top = 16
            Width = 140
            Height = 13
            Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1099#1077' '#1080#1082#1086#1085#1082#1080' '#1074' '#1090#1088#1077#1077':'
          end
          object Label27: TLabel
            Left = 8
            Top = 368
            Width = 53
            Height = 13
            Caption = 'EXE-'#1092#1072#1081#1083':'
          end
          object Label17: TLabel
            Left = 200
            Top = 16
            Width = 115
            Height = 13
            Caption = #1057#1082#1088#1099#1090#1100' '#1080#1082#1086#1085#1082#1080' '#1074' '#1090#1088#1077#1077':'
          end
          object Label88: TLabel
            Left = 200
            Top = 368
            Width = 53
            Height = 13
            Caption = 'EXE-'#1092#1072#1081#1083':'
          end
          object ListView2: TListView
            Left = 8
            Top = 35
            Width = 169
            Height = 320
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 130
                MinWidth = 130
                Width = 130
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView2SelectItem
          end
          object Edit4: TEdit
            Left = 67
            Top = 364
            Width = 110
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit4Change
          end
          object ListView9: TListView
            Left = 200
            Top = 35
            Width = 169
            Height = 320
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 130
                MinWidth = 130
                Width = 130
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 2
            ViewStyle = vsReport
            OnSelectItem = ListView9SelectItem
          end
          object Edit22: TEdit
            Left = 259
            Top = 364
            Width = 110
            Height = 21
            MaxLength = 100
            TabOrder = 3
            OnChange = Edit22Change
          end
          object CheckBox14: TCheckBox
            Left = 8
            Top = 410
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1083#1080#1082#1080' '#1085#1072' '#1086#1087#1072#1089#1085#1099#1093' '#1080#1082#1086#1085#1082#1072#1093' '#1074' '#1090#1088#1077#1077
            TabOrder = 4
          end
        end
      end
      object TabSheet19: TTabSheet
        Tag = 18
        Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100': '#1055#1088#1086#1095#1080#1077
        ImageIndex = 9
        object Panel18: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label14: TLabel
            Left = 197
            Top = 198
            Width = 45
            Height = 13
            Caption = 'C:\TEMP'
          end
          object CheckBox125: TCheckBox
            Left = 8
            Top = 129
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1083#1080#1082#1080' '#1080' '#1085#1072#1078#1072#1090#1080#1103' '#1082#1083#1072#1074#1080#1096' '#1085#1072' '#1082#1086#1085#1089#1086#1083#1100#1085#1099#1093' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103#1093
            TabOrder = 0
          end
          object CheckBox18: TCheckBox
            Left = 8
            Top = 197
            Width = 177
            Height = 17
            Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1082#1083#1080#1077#1085#1090#1072':'
            TabOrder = 1
            OnClick = CheckBox18Click
          end
          object CheckBox80: TCheckBox
            Left = 8
            Top = 149
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1083#1072#1074#1080#1096#1080' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1087#1080#1090#1072#1085#1080#1077#1084' '#1085#1072' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1077
            TabOrder = 2
          end
          object CheckBox61: TCheckBox
            Left = 8
            Top = 169
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1097#1072#1090#1100' '#1082#1083#1072#1074#1080#1072#1090#1091#1088#1091' '#1080' '#1084#1099#1096#1100' '#1087#1088#1080' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1080' '#1084#1086#1085#1080#1090#1086#1088#1072
            TabOrder = 3
          end
          object CheckBox15: TCheckBox
            Left = 8
            Top = 12
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' Winamp v2/5'
            TabOrder = 4
          end
          object CheckBox113: TCheckBox
            Left = 8
            Top = 32
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' MediaPlayerClassic'
            TabOrder = 5
          end
          object CheckBox88: TCheckBox
            Left = 8
            Top = 52
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' PowerDVD'
            TabOrder = 6
          end
          object CheckBox22: TCheckBox
            Left = 8
            Top = 72
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' uTorrent/BitTorrent'
            TabOrder = 7
          end
          object CheckBox100: TCheckBox
            Left = 8
            Top = 92
            Width = 450
            Height = 17
            Caption = #1054#1073#1077#1079#1086#1087#1072#1089#1080#1090#1100' Garena'
            TabOrder = 8
          end
        end
      end
      object TabSheet31: TTabSheet
        Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082
        ImageIndex = 30
        object Panel36: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet2: TTabSheet
        Tag = 19
        Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082': '#1054#1073#1097#1080#1077
        ImageIndex = 24
        object Panel12: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label66: TLabel
            Left = 24
            Top = 72
            Width = 45
            Height = 13
            Caption = 'C:\TEMP'
          end
          object CheckBox120: TCheckBox
            Left = 8
            Top = 13
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' Drag&&Drop '#1080#1079' '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1072' '#1085#1072' '#1083#1102#1073#1086#1077' '#1086#1082#1085#1086
            TabOrder = 0
          end
          object CheckBox36: TCheckBox
            Left = 8
            Top = 53
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1088#1072#1089#1087#1072#1082#1086#1074#1099#1074#1072#1090#1100' '#1072#1088#1093#1080#1074#1099' (WinRar, 7zip):'
            TabOrder = 1
            OnClick = CheckBox36Click
          end
          object CheckBox57: TCheckBox
            Left = 8
            Top = 93
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1085#1072' '#1089#1098#1077#1084#1085#1099#1077' '#1085#1086#1089#1080#1090#1077#1083#1080' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1077
            TabOrder = 2
          end
          object CheckBox64: TCheckBox
            Left = 8
            Top = 113
            Width = 450
            Height = 17
            Caption = #1059#1076#1072#1083#1103#1090#1100' '#1074' '#1082#1086#1088#1079#1080#1085#1091' Windows'
            TabOrder = 3
          end
          object CheckBox76: TCheckBox
            Left = 8
            Top = 33
            Width = 450
            Height = 17
            Caption = 
              #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1086#1074' '#1080#1079' '#1087#1072#1087#1086#1082'-'#1103#1088#1083#1099#1082#1086#1074' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1089#1090#1086#1083#1072' '#1096#1077#1083 +
              #1083#1072
            TabOrder = 4
          end
          object CheckBox84: TCheckBox
            Left = 8
            Top = 133
            Width = 450
            Height = 17
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1082#1088#1099#1090#1099#1077' '#1092#1072#1081#1083#1099' '#1080' '#1087#1072#1087#1082#1080' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1077
            TabOrder = 5
          end
        end
      end
      object TabSheet16: TTabSheet
        Tag = 20
        Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082': '#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1087#1082#1080
        ImageIndex = 12
        OnShow = TabSheet16Show
        object Panel15: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label62: TLabel
            Left = 8
            Top = 13
            Width = 347
            Height = 13
            Caption = #1047#1076#1077#1089#1100' '#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1077#1090#1089#1103' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1089#1087#1080#1089#1086#1082' '#1087#1072#1087#1086#1082', '#1089' '#1082#1086#1090#1086#1088#1099#1084#1080
          end
          object Label73: TLabel
            Left = 8
            Top = 27
            Width = 322
            Height = 13
            Caption = #1084#1086#1078#1077#1090' '#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1095#1077#1088#1077#1079' '#1087#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
          end
          object Label74: TLabel
            Left = 8
            Top = 318
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label86: TLabel
            Left = 8
            Top = 342
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object Label28: TLabel
            Left = 8
            Top = 376
            Width = 298
            Height = 13
            Caption = #1042' '#1089#1082#1086#1073#1082#1072#1093' '#1084#1086#1078#1085#1086' '#1091#1082#1072#1079#1099#1074#1072#1090#1100' '#1072#1090#1088#1080#1073#1091#1090#1099' '#1087#1072#1087#1082#1080' ('#1089#1084'. '#1089#1087#1088#1072#1074#1082#1091')'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object ListView8: TListView
            Left = 8
            Top = 52
            Width = 345
            Height = 250
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView8SelectItem
          end
          object Edit19: TEdit
            Left = 80
            Top = 314
            Width = 273
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit19Change
          end
          object Edit20: TEdit
            Left = 80
            Top = 338
            Width = 246
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit20Change
          end
          object CheckBox58: TCheckBox
            Left = 8
            Top = 401
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1074' '#1101#1090#1080' '#1087#1072#1087#1082#1080' '#1080#1079' '#1076#1080#1072#1083#1086#1075#1086#1074#1099#1093' '#1086#1082#1086#1085' Open/Save'
            TabOrder = 3
          end
          object Button14: TButton
            Left = 332
            Top = 338
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 4
            OnClick = Button14Click
          end
        end
      end
      object TabSheet15: TTabSheet
        Tag = 21
        Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082': '#1056#1072#1089#1096#1080#1088#1077#1085#1080#1077' '#1084#1077#1085#1102
        ImageIndex = 12
        OnShow = TabSheet15Show
        object Panel22: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label68: TLabel
            Left = 8
            Top = 10
            Width = 317
            Height = 13
            Caption = #1047#1076#1077#1089#1100' '#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1077#1090#1089#1103' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103
          end
          object Label69: TLabel
            Left = 8
            Top = 24
            Width = 303
            Height = 13
            Caption = #1092#1072#1081#1083#1086#1074' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1087#1088#1103#1084#1086#1077' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077'):'
          end
          object Label70: TLabel
            Left = 8
            Top = 172
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label71: TLabel
            Left = 8
            Top = 196
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object Label77: TLabel
            Left = 8
            Top = 438
            Width = 336
            Height = 13
            Caption = #1042' '#1089#1082#1086#1073#1082#1072#1093' '#1087#1086#1089#1083#1077' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1084#1086#1078#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1080#1103'/'#1092#1072#1081#1083#1099
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object Label78: TLabel
            Left = 8
            Top = 235
            Width = 121
            Height = 13
            Caption = #1054#1073#1088#1072#1090#1085#1086#1077' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077':'
          end
          object Label82: TLabel
            Left = 8
            Top = 382
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label83: TLabel
            Left = 8
            Top = 406
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object ListView5: TListView
            Left = 8
            Top = 41
            Width = 345
            Height = 120
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView5SelectItem
          end
          object Edit14: TEdit
            Left = 80
            Top = 168
            Width = 240
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit14Change
          end
          object Edit15: TEdit
            Left = 80
            Top = 192
            Width = 240
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit15Change
          end
          object ListView6: TListView
            Left = 8
            Top = 252
            Width = 345
            Height = 120
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 3
            ViewStyle = vsReport
            OnSelectItem = ListView6SelectItem
          end
          object Edit17: TEdit
            Left = 80
            Top = 378
            Width = 240
            Height = 21
            MaxLength = 100
            TabOrder = 4
            OnChange = Edit17Change
          end
          object Edit18: TEdit
            Left = 80
            Top = 402
            Width = 240
            Height = 21
            MaxLength = 100
            TabOrder = 5
            OnChange = Edit18Change
          end
          object Button15: TButton
            Left = 328
            Top = 192
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 6
            OnClick = Button15Click
          end
          object Button16: TButton
            Left = 328
            Top = 402
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 7
            OnClick = Button16Click
          end
        end
      end
      object TabSheet18: TTabSheet
        Caption = #1041#1088#1072#1091#1079#1077#1088
        ImageIndex = 5
        object Panel44: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet23: TTabSheet
        Tag = 22
        Caption = #1041#1088#1072#1091#1079#1077#1088': '#1054#1073#1097#1080#1077
        ImageIndex = 37
        object Panel14: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label63: TLabel
            Left = 8
            Top = 39
            Width = 106
            Height = 13
            Caption = #1057#1090#1072#1088#1090#1086#1074#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072':'
          end
          object Label120: TLabel
            Left = 8
            Top = 65
            Width = 59
            Height = 13
            Caption = #1048#1079#1073#1088#1072#1085#1085#1086#1077':'
          end
          object Label49: TLabel
            Left = 8
            Top = 123
            Width = 245
            Height = 13
            Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083'-'#1074#1086' '#1086#1090#1082#1088#1099#1090#1099#1093' '#1086#1082#1086#1085' '#1073#1088#1072#1091#1079#1077#1088#1072':'
          end
          object Label8: TLabel
            Left = 8
            Top = 153
            Width = 134
            Height = 13
            Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1086#1082#1085#1072' '#1073#1088#1072#1091#1079#1077#1088#1072':'
          end
          object CheckBox129: TCheckBox
            Left = 8
            Top = 10
            Width = 450
            Height = 17
            Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1073#1088#1072#1091#1079#1077#1088' Internet'
            TabOrder = 0
            OnClick = CheckBox129Click
          end
          object Edit12: TEdit
            Left = 220
            Top = 34
            Width = 230
            Height = 21
            MaxLength = 256
            TabOrder = 1
          end
          object Edit44: TEdit
            Left = 220
            Top = 60
            Width = 230
            Height = 21
            MaxLength = 256
            TabOrder = 2
          end
          object ComboBox7: TComboBox
            Left = 297
            Top = 117
            Width = 52
            Height = 21
            Style = csDropDownList
            DropDownCount = 10
            ItemHeight = 13
            TabOrder = 3
            Items.Strings = (
              ' '
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12'
              '13'
              '14'
              '15'
              '16'
              '17'
              '18'
              '19'
              '20'
              '21'
              '22'
              '23'
              '24'
              '25'
              '26'
              '27'
              '28'
              '29'
              '30'
              '31'
              '32'
              '33'
              '34'
              '35'
              '36'
              '37'
              '38'
              '39'
              '40'
              '41'
              '42'
              '43'
              '44'
              '45'
              '46'
              '47'
              '48'
              '49'
              '50')
          end
          object CheckBox81: TCheckBox
            Left = 8
            Top = 181
            Width = 450
            Height = 17
            Caption = 
              #1055#1086#1076#1072#1074#1083#1103#1090#1100' '#1086#1082#1085#1072' '#1073#1088#1072#1091#1079#1077#1088#1072' '#1082#1086#1075#1076#1072' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090' '#1079#1072#1082#1083#1072#1076#1082#1072' '#1089' '#1080#1085#1090#1077#1088#1085#1077#1090'-'#1082#1086 +
              #1085#1090#1077#1085#1090#1086#1084
            TabOrder = 4
          end
          object CheckBox60: TCheckBox
            Left = 8
            Top = 201
            Width = 450
            Height = 17
            Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1077#1088#1077#1082#1086#1076#1080#1088#1086#1074#1082#1091' Rus->Eng '#1074' '#1072#1076#1088#1077#1089#1085#1086#1081' '#1089#1090#1088#1086#1082#1077
            TabOrder = 5
          end
          object CheckBox50: TCheckBox
            Left = 8
            Top = 221
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1089#1089#1099#1083#1086#1082' '#1087#1088#1080' '#1074#1099#1093#1086#1076#1077
            TabOrder = 6
          end
          object CheckBox63: TCheckBox
            Left = 8
            Top = 241
            Width = 450
            Height = 17
            Caption = #1058#1091#1083#1073#1072#1088#1099' '#1087#1086#1080#1089#1082#1086#1074#1099#1093' '#1089#1080#1089#1090#1077#1084
            TabOrder = 7
          end
          object GroupBox41: TGroupBox
            Left = 8
            Top = 273
            Width = 450
            Height = 118
            Caption = ' '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103' '
            TabOrder = 8
            object Label182: TLabel
              Left = 8
              Top = 56
              Width = 80
              Height = 13
              Caption = #1055#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088':'
            end
            object Label183: TLabel
              Left = 297
              Top = 56
              Width = 28
              Height = 13
              Caption = #1055#1086#1088#1090':'
            end
            object Label184: TLabel
              Left = 8
              Top = 86
              Width = 134
              Height = 13
              Caption = #1057#1094#1077#1085#1072#1088#1080#1081' '#1072#1074#1090#1086'-'#1085#1072#1089#1090#1088#1086#1081#1082#1080':'
            end
            object CheckBox157: TCheckBox
              Left = 8
              Top = 21
              Width = 425
              Height = 17
              Caption = #1048#1079#1084#1077#1085#1103#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' LAN-'#1089#1086#1077#1076#1080#1085#1077#1085#1080#1103':'
              TabOrder = 0
              OnClick = CheckBox157Click
            end
            object Edit76: TEdit
              Left = 104
              Top = 51
              Width = 161
              Height = 21
              MaxLength = 200
              TabOrder = 1
            end
            object Edit77: TEdit
              Left = 340
              Top = 51
              Width = 49
              Height = 21
              MaxLength = 6
              TabOrder = 2
            end
            object Edit78: TEdit
              Left = 160
              Top = 81
              Width = 229
              Height = 21
              MaxLength = 200
              TabOrder = 3
            end
          end
          object CheckBox6: TCheckBox
            Left = 8
            Top = 89
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1076#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1089#1072#1081#1090#1086#1074' '#1074' "'#1048#1079#1073#1088#1072#1085#1085#1086#1077'"'
            TabOrder = 9
          end
          object Edit2: TEdit
            Left = 220
            Top = 148
            Width = 230
            Height = 21
            MaxLength = 256
            TabOrder = 10
          end
        end
      end
      object TabSheet11: TTabSheet
        Tag = 23
        Caption = #1041#1088#1072#1091#1079#1077#1088': '#1041#1077#1079#1086#1087#1072#1089#1085#1086#1089#1090#1100
        ImageIndex = 36
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label24: TLabel
            Left = 8
            Top = 17
            Width = 164
            Height = 13
            Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1090#1080#1087#1099' '#1092#1072#1081#1083#1086#1074':'
          end
          object Label26: TLabel
            Left = 8
            Top = 43
            Width = 153
            Height = 13
            Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1087#1088#1086#1090#1086#1082#1086#1083#1099':'
          end
          object Label122: TLabel
            Left = 8
            Top = 69
            Width = 179
            Height = 13
            Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1077' '#1083#1086#1082#1072#1083#1100#1085#1099#1077' '#1088#1077#1089#1091#1088#1089#1099':'
          end
          object Label124: TLabel
            Left = 8
            Top = 95
            Width = 133
            Height = 13
            Caption = #1047#1072#1087#1088#1077#1097#1077#1085#1085#1099#1077' '#1087#1088#1086#1090#1086#1082#1086#1083#1099':'
          end
          object Label167: TLabel
            Left = 8
            Top = 121
            Width = 181
            Height = 13
            Caption = #1054#1090#1082#1088#1099#1074#1072#1090#1100' '#1089' '#1087#1086#1084#1086#1097#1100#1102' MediaPlayer:'
          end
          object Label168: TLabel
            Left = 8
            Top = 147
            Width = 175
            Height = 13
            Caption = #1053#1077' '#1079#1072#1075#1088#1091#1078#1072#1090#1100' '#1074#1085#1091#1090#1088#1080' '#1089#1090#1088#1072#1085#1080#1094#1099' IE:'
          end
          object Edit53: TEdit
            Left = 220
            Top = 12
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 0
          end
          object Edit54: TEdit
            Left = 220
            Top = 38
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 1
          end
          object Edit45: TEdit
            Left = 220
            Top = 64
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 2
          end
          object Edit46: TEdit
            Left = 220
            Top = 90
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 3
          end
          object Edit66: TEdit
            Left = 220
            Top = 116
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 4
          end
          object Edit67: TEdit
            Left = 220
            Top = 142
            Width = 230
            Height = 21
            MaxLength = 240
            TabOrder = 5
          end
          object CheckBox97: TCheckBox
            Left = 8
            Top = 177
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1081' ('#1074#1080#1088#1091#1089#1086#1074') '#1080#1079' '#1073#1088#1072#1091#1079#1077#1088#1072
            TabOrder = 6
          end
          object CheckBox167: TCheckBox
            Left = 8
            Top = 197
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' Macromedia-Flash ActiveX '#1082#1086#1085#1090#1088#1086#1083#1099' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
            TabOrder = 7
          end
          object CheckBox82: TCheckBox
            Left = 8
            Top = 217
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' HTML-'#1082#1086#1076#1072' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
            TabOrder = 8
          end
          object CheckBox25: TCheckBox
            Left = 8
            Top = 237
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1077#1095#1072#1090#1100' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
            TabOrder = 9
          end
          object CheckBox87: TCheckBox
            Left = 8
            Top = 257
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' FTP'
            TabOrder = 10
          end
        end
      end
      object TabSheet25: TTabSheet
        Tag = 24
        Caption = #1041#1088#1072#1091#1079#1077#1088': '#1057#1072#1081#1090#1099
        ImageIndex = 8
        OnShow = TabSheet25Show
        object Panel914: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label123: TLabel
            Left = 8
            Top = 352
            Width = 27
            Height = 13
            Caption = #1057#1072#1081#1090':'
          end
          object ListView13: TListView
            Left = 8
            Top = 33
            Width = 233
            Height = 135
            Checkboxes = True
            Columns = <
              item
                Caption = 'Site'
                MaxWidth = 210
                MinWidth = 210
                Width = 210
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView13SelectItem
          end
          object Edit93: TEdit
            Left = 48
            Top = 348
            Width = 193
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit93Change
          end
          object RadioButton913: TRadioButton
            Left = 8
            Top = 11
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1074#1089#1077' '#1089#1072#1081#1090#1099' '#1074' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1084' '#1073#1088#1072#1091#1079#1077#1088#1077' '#1082#1088#1086#1084#1077':'
            TabOrder = 2
            OnClick = RadioButton913Click
          end
          object RadioButton914: TRadioButton
            Left = 8
            Top = 179
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1074#1089#1077' '#1089#1072#1081#1090#1099' '#1074' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1084' '#1073#1088#1072#1091#1079#1077#1088#1077' '#1082#1088#1086#1084#1077':'
            TabOrder = 3
            OnClick = RadioButton914Click
          end
          object ListView14: TListView
            Left = 8
            Top = 201
            Width = 233
            Height = 135
            Checkboxes = True
            Columns = <
              item
                Caption = 'Site'
                MaxWidth = 210
                MinWidth = 210
                Width = 210
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 4
            ViewStyle = vsReport
            OnSelectItem = ListView14SelectItem
          end
        end
      end
      object TabSheet51: TTabSheet
        Tag = 40
        Caption = #1041#1088#1072#1091#1079#1077#1088': '#1057#1072#1081#1090#1099' ('#1087#1077#1088#1077#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077')'
        ImageIndex = 31
        OnShow = TabSheet51Show
        object Panel56: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label153: TLabel
            Left = 8
            Top = 192
            Width = 25
            Height = 13
            Caption = 'URL:'
          end
          object Label154: TLabel
            Left = 8
            Top = 24
            Width = 147
            Height = 13
            Caption = #1055#1077#1088#1077#1085#1072#1087#1088#1072#1074#1083#1103#1090#1100' '#1089' '#1101#1090#1080#1093' URL:'
          end
          object Label155: TLabel
            Left = 8
            Top = 232
            Width = 65
            Height = 13
            Caption = #1085#1072' '#1101#1090#1086#1090' URL:'
          end
          object ListView18: TListView
            Left = 8
            Top = 41
            Width = 233
            Height = 135
            Checkboxes = True
            Columns = <
              item
                Caption = 'Site'
                MaxWidth = 210
                MinWidth = 210
                Width = 210
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView18SelectItem
          end
          object Edit99: TEdit
            Left = 48
            Top = 188
            Width = 193
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit99Change
          end
          object Edit100: TEdit
            Left = 8
            Top = 248
            Width = 400
            Height = 21
            MaxLength = 250
            TabOrder = 2
          end
        end
      end
      object TabSheet30: TTabSheet
        Tag = 25
        Caption = #1041#1088#1072#1091#1079#1077#1088': '#1047#1072#1075#1088#1091#1079#1095#1080#1082
        ImageIndex = 29
        object Panel32: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label135: TLabel
            Left = 8
            Top = 91
            Width = 244
            Height = 13
            Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1077' '#1082#1086#1083'-'#1074#1086' '#1086#1090#1082#1088#1099#1090#1099#1093' '#1086#1082#1086#1085' '#1079#1072#1075#1088#1091#1079#1082#1080':'
          end
          object Label94: TLabel
            Left = 8
            Top = 119
            Width = 270
            Height = 13
            Caption = #1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1099#1081' '#1088#1072#1079#1084#1077#1088' '#1089#1082#1072#1095#1080#1074#1072#1077#1084#1099#1093' '#1092#1072#1081#1083#1086#1074' (0-'#1085#1077#1090'):'
          end
          object Label95: TLabel
            Left = 356
            Top = 119
            Width = 16
            Height = 13
            Caption = 'MB'
          end
          object Label97: TLabel
            Left = 8
            Top = 174
            Width = 243
            Height = 13
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1090#1086#1083#1100#1082#1086' '#1101#1090#1080#1093' '#1090#1080#1087#1086#1074' '#1092#1072#1081#1083#1086#1074':'
          end
          object Label166: TLabel
            Left = 8
            Top = 229
            Width = 348
            Height = 13
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1090#1080#1087#1099' '#1092#1072#1081#1083#1086#1074' '#1087#1086#1089#1083#1077' '#1079#1072#1075#1088#1091#1079#1082#1080':'
          end
          object Label190: TLabel
            Left = 8
            Top = 311
            Width = 229
            Height = 13
            Caption = #1054#1075#1088#1072#1085#1080#1095#1080#1074#1072#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1092#1072#1081#1083#1086#1074' '#1076#1086' '
          end
          object Label191: TLabel
            Left = 313
            Top = 311
            Width = 54
            Height = 13
            Caption = #1050#1041#1072#1081#1090'/'#1089#1077#1082
          end
          object Label195: TLabel
            Left = 8
            Top = 36
            Width = 402
            Height = 13
            Caption = 
              #1042#1089#1077#1075#1076#1072' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1081' '#1079#1072#1075#1088#1091#1079#1095#1080#1082' Windows '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1080#1093' ' +
              #1089#1072#1081#1090#1086#1074':'
          end
          object ComboBox11: TComboBox
            Left = 297
            Top = 85
            Width = 52
            Height = 21
            Style = csDropDownList
            DropDownCount = 10
            ItemHeight = 13
            TabOrder = 0
            Items.Strings = (
              ' '
              '1'
              '2'
              '3'
              '4'
              '5'
              '6'
              '7'
              '8'
              '9'
              '10'
              '11'
              '12'
              '13'
              '14'
              '15'
              '16'
              '17'
              '18'
              '19'
              '20'
              '21'
              '22'
              '23'
              '24'
              '25'
              '26'
              '27'
              '28'
              '29'
              '30'
              '31'
              '32'
              '33'
              '34'
              '35'
              '36'
              '37'
              '38'
              '39'
              '40'
              '41'
              '42'
              '43'
              '44'
              '45'
              '46'
              '47'
              '48'
              '49'
              '50')
          end
          object Edit25: TEdit
            Left = 297
            Top = 114
            Width = 52
            Height = 21
            MaxLength = 4
            TabOrder = 1
          end
          object CheckBox112: TCheckBox
            Left = 8
            Top = 145
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1079#1072#1087#1091#1089#1082' '#1079#1072#1075#1088#1091#1078#1077#1085#1085#1099#1093' '#1092#1072#1081#1083#1086#1074
            TabOrder = 2
          end
          object CheckBox99: TCheckBox
            Left = 8
            Top = 10
            Width = 450
            Height = 17
            Caption = 
              #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1081' '#1079#1072#1075#1088#1091#1079#1095#1080#1082' Windows IE ('#1080#1083#1080' '#1074#1085#1077#1096#1085#1080#1081') '#1074' '#1073#1088 +
              #1072#1091#1079#1077#1088#1077
            TabOrder = 3
          end
          object CheckBox66: TCheckBox
            Left = 8
            Top = 192
            Width = 16
            Height = 17
            TabOrder = 4
            OnClick = CheckBox66Click
          end
          object Edit27: TEdit
            Left = 26
            Top = 191
            Width = 327
            Height = 21
            MaxLength = 256
            TabOrder = 5
          end
          object Edit65: TEdit
            Left = 8
            Top = 246
            Width = 345
            Height = 21
            MaxLength = 256
            TabOrder = 6
          end
          object CheckBox150: TCheckBox
            Left = 8
            Top = 282
            Width = 450
            Height = 17
            Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1080
            TabOrder = 7
          end
          object Edit83: TEdit
            Left = 254
            Top = 306
            Width = 52
            Height = 21
            MaxLength = 4
            TabOrder = 8
          end
          object Edit86: TEdit
            Left = 8
            Top = 53
            Width = 345
            Height = 21
            MaxLength = 250
            TabOrder = 9
          end
        end
      end
      object TabSheet14: TTabSheet
        Caption = #1054#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1077
        ImageIndex = 12
        object Panel45: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet20: TTabSheet
        Tag = 26
        Caption = #1054#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1077': '#1040#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1072
        ImageIndex = 13
        OnShow = TabSheet20Show
        object Panel24: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label102: TLabel
            Left = 8
            Top = 292
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label103: TLabel
            Left = 8
            Top = 316
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object Label104: TLabel
            Left = 8
            Top = 11
            Width = 304
            Height = 13
            Caption = #1057#1087#1080#1089#1086#1082' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1093' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077':'
          end
          object Label111: TLabel
            Left = 8
            Top = 396
            Width = 195
            Height = 13
            Caption = #1042#1077#1073'-'#1089#1090#1088#1072#1085#1080#1094#1072' '#1087#1088#1080#1074#1077#1090#1089#1090#1074#1080#1103' ('#1085#1086#1074#1086#1089#1090#1077#1081'):'
          end
          object Label149: TLabel
            Left = 8
            Top = 339
            Width = 422
            Height = 13
            Caption = 
              #1042#1085#1080#1084#1072#1085#1080#1077'! '#1045#1089#1083#1080' '#1087#1091#1090#1100' '#1089#1086#1076#1077#1088#1078#1080#1090' '#1087#1088#1086#1073#1077#1083#1099', '#1090#1086' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1077#1075#1086' '#1079#1072#1082#1083#1102#1095#1080#1090 +
              #1100' '#1074' '#1082#1072#1074#1099#1095#1082#1080'!'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object CheckBox79: TCheckBox
            Left = 8
            Top = 363
            Width = 450
            Height = 17
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1091#1102' ('#1089#1090#1072#1085#1076#1072#1088#1090#1085#1091#1102') '#1072#1074#1090#1086#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1086#1075#1088#1072#1084#1084
            TabOrder = 0
          end
          object ListView11: TListView
            Left = 8
            Top = 31
            Width = 345
            Height = 250
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 1
            ViewStyle = vsReport
            OnSelectItem = ListView11SelectItem
          end
          object Edit28: TEdit
            Left = 80
            Top = 288
            Width = 273
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit28Change
          end
          object Edit29: TEdit
            Left = 80
            Top = 312
            Width = 246
            Height = 21
            MaxLength = 150
            TabOrder = 3
            OnChange = Edit29Change
          end
          object Button13: TButton
            Left = 332
            Top = 312
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 4
            OnClick = Button13Click
          end
          object Edit34: TEdit
            Left = 217
            Top = 391
            Width = 219
            Height = 21
            MaxLength = 230
            TabOrder = 5
          end
          object CheckBox30: TCheckBox
            Left = 8
            Top = 432
            Width = 450
            Height = 17
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' '#1083#1080#1094#1077#1085#1079#1080#1086#1085#1085#1086#1077' '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077' '#1089' '#1087#1086#1089#1077#1090#1080#1090#1077#1083#1077#1084':'
            TabOrder = 6
            OnClick = CheckBox30Click
          end
          object Edit13: TEdit
            Left = 8
            Top = 453
            Width = 305
            Height = 21
            MaxLength = 250
            TabOrder = 7
          end
          object Button1: TButton
            Left = 319
            Top = 453
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 8
            OnClick = Button1Click
          end
        end
      end
      object TabSheet32: TTabSheet
        Tag = 27
        Caption = #1054#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1077': '#1040#1074#1090#1086#1079#1072#1087#1091#1089#1082
        ImageIndex = 31
        object Panel34: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label116: TLabel
            Left = 8
            Top = 195
            Width = 135
            Height = 13
            Caption = '('#1080#1083#1080': mplayerc.exe %1 /dvd)'
          end
          object CheckBox116: TCheckBox
            Left = 8
            Top = 15
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1083#1103' AudioCD:'
            TabOrder = 0
            OnClick = CheckBox116Click
          end
          object Edit39: TEdit
            Left = 8
            Top = 35
            Width = 250
            Height = 21
            MaxLength = 250
            TabOrder = 1
          end
          object CheckBox117: TCheckBox
            Left = 8
            Top = 151
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1083#1103' DVD:'
            TabOrder = 2
            OnClick = CheckBox117Click
          end
          object Edit40: TEdit
            Left = 8
            Top = 171
            Width = 250
            Height = 21
            MaxLength = 250
            TabOrder = 3
          end
          object CheckBox118: TCheckBox
            Left = 8
            Top = 83
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1083#1103' '#1095#1080#1089#1090#1086#1075#1086' CD:'
            TabOrder = 4
            OnClick = CheckBox118Click
          end
          object Edit41: TEdit
            Left = 8
            Top = 103
            Width = 250
            Height = 21
            MaxLength = 250
            TabOrder = 5
          end
          object CheckBox53: TCheckBox
            Left = 8
            Top = 219
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1083#1103' Flash:'
            TabOrder = 6
            OnClick = CheckBox53Click
          end
          object Edit48: TEdit
            Left = 8
            Top = 239
            Width = 250
            Height = 21
            MaxLength = 250
            TabOrder = 7
          end
          object CheckBox29: TCheckBox
            Left = 8
            Top = 288
            Width = 450
            Height = 17
            Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082' '#1076#1083#1103' '#1092#1086#1090#1086#1082#1072#1084#1077#1088#1099':'
            Enabled = False
            TabOrder = 8
          end
          object Edit1: TEdit
            Left = 8
            Top = 308
            Width = 250
            Height = 21
            Enabled = False
            MaxLength = 250
            TabOrder = 9
            Text = #1085#1072#1089#1090#1088#1072#1080#1074#1072#1077#1090#1089#1103' '#1085#1072' '#1074#1082#1083#1072#1076#1082#1077' "'#1059#1090#1080#1083#1080#1090#1099': '#1055#1088#1086#1095#1080#1077'"'
          end
        end
      end
      object TabSheet17: TTabSheet
        Tag = 28
        Caption = #1054#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1077': '#1059#1076#1072#1083#1077#1085#1080#1077
        ImageIndex = 10
        OnShow = TabSheet17Show
        object Panel17: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label92: TLabel
            Left = 8
            Top = 16
            Width = 357
            Height = 13
            Caption = #1055#1072#1087#1082#1080' '#1080' '#1092#1072#1081#1083#1099', '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1075#1091#1090' '#1073#1099#1090#1100' '#1091#1076#1072#1083#1077#1085#1099' '#1087#1086' '#1082#1086#1084#1072#1085#1076#1077' '#1086#1090' '#1089#1077#1088#1074#1077#1088#1072':'
          end
          object Label93: TLabel
            Left = 8
            Top = 318
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object ListView10: TListView
            Left = 8
            Top = 40
            Width = 265
            Height = 265
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 230
                MinWidth = 230
                Width = 230
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView10SelectItem
          end
          object Edit24: TEdit
            Left = 67
            Top = 314
            Width = 174
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit24Change
          end
          object CheckBox54: TCheckBox
            Left = 8
            Top = 381
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1074#1088#1077#1084#1077#1085#1085#1091#1102' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102' Windows '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' (TEMP)'
            TabOrder = 2
          end
          object CheckBox55: TCheckBox
            Left = 8
            Top = 401
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102' '#1082#1101#1096#1072' Internet Explorer '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077
            TabOrder = 3
          end
          object Button12: TButton
            Left = 248
            Top = 314
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 4
            OnClick = Button12Click
          end
          object CheckBox94: TCheckBox
            Left = 8
            Top = 361
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1082#1086#1088#1079#1080#1085#1091' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077
            TabOrder = 5
          end
          object CheckBox146: TCheckBox
            Left = 8
            Top = 421
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1087#1072#1087#1082#1091' Cookies '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077
            TabOrder = 6
          end
          object CheckBox4: TCheckBox
            Left = 8
            Top = 441
            Width = 450
            Height = 17
            Caption = #1054#1095#1080#1097#1072#1090#1100' '#1086#1095#1077#1088#1077#1076#1100' '#1087#1077#1095#1072#1090#1080' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077
            TabOrder = 7
          end
        end
      end
      object TabSheet39: TTabSheet
        Tag = 29
        Caption = #1054#1073#1089#1083#1091#1078#1080#1074#1072#1085#1080#1077': '#1055#1088#1086#1095#1080#1077
        ImageIndex = 38
        OnShow = TabSheet39Show
        object Panel16: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox10: TGroupBox
            Left = 8
            Top = 10
            Width = 450
            Height = 113
            Caption = ' '#1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1075#1088#1086#1084#1082#1086#1089#1090#1080' '
            TabOrder = 0
            object Label59: TLabel
              Left = 8
              Top = 23
              Width = 57
              Height = 13
              Caption = 'Master max:'
            end
            object Label60: TLabel
              Left = 193
              Top = 23
              Width = 54
              Height = 13
              Caption = 'Wave max:'
            end
            object Label84: TLabel
              Left = 8
              Top = 54
              Width = 54
              Height = 13
              Caption = 'Master min:'
            end
            object Label85: TLabel
              Left = 193
              Top = 54
              Width = 51
              Height = 13
              Caption = 'Wave min:'
            end
            object TrackBarMasterMax: TTrackBar
              Left = 72
              Top = 18
              Width = 105
              Height = 29
              Max = 100
              PageSize = 1
              Frequency = 5
              TabOrder = 0
              TabStop = False
              OnChange = TrackBarMasterMaxChange
            end
            object TrackBarWaveMax: TTrackBar
              Left = 248
              Top = 18
              Width = 105
              Height = 29
              Max = 100
              PageSize = 1
              Frequency = 5
              TabOrder = 1
              TabStop = False
              OnChange = TrackBarWaveMaxChange
            end
            object CheckBox31: TCheckBox
              Left = 8
              Top = 86
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1092#1091#1085#1082#1094#1080#1102' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103' '#1075#1088#1086#1084#1082#1086#1089#1090#1080
              TabOrder = 2
              OnClick = CheckBox31Click
            end
            object TrackBarMasterMin: TTrackBar
              Left = 72
              Top = 49
              Width = 105
              Height = 29
              Max = 100
              PageSize = 1
              Frequency = 5
              TabOrder = 3
              TabStop = False
              OnChange = TrackBarMasterMinChange
            end
            object TrackBarWaveMin: TTrackBar
              Left = 248
              Top = 49
              Width = 105
              Height = 29
              Max = 100
              PageSize = 1
              Frequency = 5
              TabOrder = 4
              TabStop = False
              OnChange = TrackBarWaveMinChange
            end
          end
          object GroupBox17: TGroupBox
            Left = 8
            Top = 134
            Width = 450
            Height = 126
            Caption = ' '#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1084#1099#1096#1080' '
            TabOrder = 1
            object Label21: TLabel
              Left = 8
              Top = 46
              Width = 21
              Height = 13
              Caption = #1052#1080#1085
            end
            object Label117: TLabel
              Left = 155
              Top = 46
              Width = 27
              Height = 13
              Caption = #1052#1072#1082#1089
            end
            object CheckBox121: TCheckBox
              Left = 8
              Top = 20
              Width = 425
              Height = 17
              Caption = #1059#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' ('#1089#1082#1086#1088#1086#1089#1090#1100', '#1072#1082#1089#1077#1083#1077#1088#1072#1094#1080#1103'):'
              TabOrder = 0
              OnClick = CheckBox121Click
            end
            object TrackBar: TTrackBar
              Left = 32
              Top = 43
              Width = 121
              Height = 33
              PageSize = 1
              Position = 10
              TabOrder = 1
              TabStop = False
              ThumbLength = 17
            end
            object RadioButton9: TRadioButton
              Left = 8
              Top = 81
              Width = 80
              Height = 17
              Caption = #1053#1077#1090
              TabOrder = 2
            end
            object RadioButton10: TRadioButton
              Left = 8
              Top = 101
              Width = 80
              Height = 17
              Caption = #1053#1080#1079#1082#1072#1103
              TabOrder = 3
            end
            object RadioButton11: TRadioButton
              Left = 112
              Top = 81
              Width = 80
              Height = 17
              Caption = #1057#1088#1077#1076#1085#1103#1103
              TabOrder = 4
            end
            object RadioButton12: TRadioButton
              Left = 112
              Top = 101
              Width = 80
              Height = 17
              Caption = #1042#1099#1089#1086#1082#1072#1103
              TabOrder = 5
            end
          end
          object GroupBox39: TGroupBox
            Left = 8
            Top = 271
            Width = 450
            Height = 157
            Caption = ' '#1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1080#1089#1082#1086#1074' '
            TabOrder = 2
            object Label170: TLabel
              Left = 8
              Top = 56
              Width = 108
              Height = 13
              Caption = #1055#1088#1086#1074#1077#1088#1103#1077#1084#1099#1077' '#1076#1080#1089#1082#1080':'
            end
            object CheckBox154: TCheckBox
              Left = 8
              Top = 24
              Width = 323
              Height = 17
              Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1074#1077#1088#1082#1091' '#1076#1080#1089#1082#1086#1074' (ScanDisk) '#1082#1072#1078#1076#1099#1077' N-'#1095#1072#1089#1086#1074':'
              TabOrder = 0
              OnClick = CheckBox154Click
            end
            object Edit69: TEdit
              Left = 354
              Top = 19
              Width = 45
              Height = 21
              MaxLength = 3
              TabOrder = 1
            end
            object CheckListBox4: TCheckListBox
              Left = 157
              Top = 56
              Width = 97
              Height = 84
              ItemHeight = 16
              Items.Strings = (
                'A:'
                'B:'
                'C:'
                'D:'
                'E:'
                'F:'
                'G:'
                'H:'
                'I:'
                'J:'
                'K:'
                'L:'
                'M:'
                'N:'
                'O:'
                'P:'
                'Q:'
                'R:'
                'S:'
                'T:'
                'U:'
                'V:'
                'W:'
                'X:'
                'Y:'
                'Z:')
              Style = lbOwnerDrawFixed
              TabOrder = 2
            end
          end
        end
      end
      object TabSheet34: TTabSheet
        Caption = #1059#1090#1080#1083#1080#1090#1099
        ImageIndex = 33
        object Panel46: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet28: TTabSheet
        Tag = 30
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1044#1086#1082#1091#1084#1077#1085#1090#1099
        ImageIndex = 27
        object Panel30: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox21: TGroupBox
            Left = 8
            Top = 11
            Width = 450
            Height = 108
            Caption = ' '#1041#1077#1079#1086#1087#1072#1089#1085#1099#1081' Office '
            TabOrder = 0
            object CheckBox131: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' Office'
              TabOrder = 0
            end
            object CheckBox115: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1088#1072#1089#1096#1080#1088#1077#1085#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' '#1074' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1084' Office'
              TabOrder = 1
            end
            object CheckBox122: TCheckBox
              Left = 8
              Top = 59
              Width = 425
              Height = 17
              Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' '#1079#1072#1087#1091#1089#1082' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1081' ('#1074#1080#1088#1091#1089#1086#1074') '#1080#1079' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1075#1086' Office'
              TabOrder = 2
            end
            object CheckBox35: TCheckBox
              Left = 8
              Top = 79
              Width = 425
              Height = 17
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1085#1086#1077' '#1084#1077#1085#1102' '#1074' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1084' Office'
              TabOrder = 3
            end
          end
          object GroupBox24: TGroupBox
            Left = 8
            Top = 130
            Width = 450
            Height = 81
            Caption = ' '#1041#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1073#1083#1086#1082#1085#1086#1090' '
            TabOrder = 1
            object Label141: TLabel
              Left = 8
              Top = 50
              Width = 164
              Height = 13
              Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1090#1080#1087#1099' '#1092#1072#1081#1083#1086#1074':'
            end
            object CheckBox132: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1073#1083#1086#1082#1085#1086#1090
              TabOrder = 0
            end
            object Edit58: TEdit
              Left = 184
              Top = 45
              Width = 249
              Height = 21
              MaxLength = 240
              TabOrder = 1
            end
          end
          object GroupBox27: TGroupBox
            Left = 8
            Top = 221
            Width = 450
            Height = 68
            Caption = ' '#1055#1088#1086#1089#1084#1086#1090#1088#1097#1080#1082' PDF '
            TabOrder = 2
            object CheckBox134: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088#1097#1080#1082' PDF-'#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
              TabOrder = 0
            end
            object CheckBox138: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1088#1072#1073#1086#1095#1091#1102' '#1087#1072#1085#1077#1083#1100
              TabOrder = 1
            end
          end
        end
      end
      object TabSheet33: TTabSheet
        Tag = 31
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1052#1077#1076#1080#1072
        ImageIndex = 32
        object Panel35: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox23: TGroupBox
            Left = 8
            Top = 11
            Width = 450
            Height = 158
            Caption = ' '#1041#1077#1079#1086#1087#1072#1089#1085#1099#1081' Media Player '
            TabOrder = 0
            object Label138: TLabel
              Left = 8
              Top = 48
              Width = 164
              Height = 13
              Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1090#1080#1087#1099' '#1092#1072#1081#1083#1086#1074':'
            end
            object Label139: TLabel
              Left = 8
              Top = 74
              Width = 153
              Height = 13
              Caption = #1055#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1087#1088#1086#1090#1086#1082#1086#1083#1099':'
            end
            object Label140: TLabel
              Left = 8
              Top = 100
              Width = 113
              Height = 13
              Caption = #1058#1080#1087#1099' '#1092#1072#1081#1083#1086#1074' Winamp:'
            end
            object Label148: TLabel
              Left = 8
              Top = 126
              Width = 162
              Height = 13
              Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081' '#1084#1077#1076#1080#1072'-'#1087#1083#1077#1081#1077#1088':'
            end
            object CheckBox130: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' Media Player'
              TabOrder = 0
            end
            object Edit55: TEdit
              Left = 200
              Top = 43
              Width = 230
              Height = 21
              MaxLength = 240
              TabOrder = 1
            end
            object Edit56: TEdit
              Left = 200
              Top = 69
              Width = 230
              Height = 21
              MaxLength = 240
              TabOrder = 2
            end
            object Edit57: TEdit
              Left = 200
              Top = 95
              Width = 230
              Height = 21
              MaxLength = 240
              TabOrder = 3
            end
            object Edit61: TEdit
              Left = 200
              Top = 121
              Width = 203
              Height = 21
              MaxLength = 240
              TabOrder = 4
            end
            object Button27: TButton
              Left = 409
              Top = 121
              Width = 21
              Height = 21
              Caption = '...'
              TabOrder = 5
              OnClick = Button27Click
            end
          end
          object GroupBox25: TGroupBox
            Left = 8
            Top = 181
            Width = 450
            Height = 52
            Caption = ' '#1055#1088#1086#1089#1084#1086#1090#1088' Flash '
            TabOrder = 1
            object CheckBox135: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1087#1088#1086#1080#1075#1088#1099#1074#1072#1090#1077#1083#1100' Flash-'#1088#1086#1083#1080#1082#1086#1074
              TabOrder = 0
            end
          end
          object GroupBox28: TGroupBox
            Left = 8
            Top = 245
            Width = 450
            Height = 52
            Caption = ' '#1055#1088#1086#1089#1084#1086#1090#1088' '#1082#1072#1088#1090#1080#1085#1086#1082' '
            TabOrder = 2
            object CheckBox133: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1089#1090#1088#1086#1077#1085#1085#1099#1081' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1087#1088#1086#1089#1084#1086#1090#1088#1097#1080#1082' '#1082#1072#1088#1090#1080#1085#1086#1082
              TabOrder = 0
            end
          end
        end
      end
      object TabSheet40: TTabSheet
        Tag = 32
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1055#1086#1095#1090#1072
        ImageIndex = 39
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox37: TGroupBox
            Left = 8
            Top = 11
            Width = 450
            Height = 283
            Caption = ' '#1054#1090#1087#1088#1072#1074#1082#1072' '#1087#1080#1089#1077#1084' '
            TabOrder = 0
            object Label162: TLabel
              Left = 8
              Top = 72
              Width = 73
              Height = 13
              Caption = #1057#1077#1088#1074#1077#1088' SMTP:'
            end
            object Label163: TLabel
              Left = 8
              Top = 103
              Width = 76
              Height = 13
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
            end
            object Label164: TLabel
              Left = 248
              Top = 103
              Width = 41
              Height = 13
              Caption = #1055#1072#1088#1086#1083#1100':'
            end
            object Label165: TLabel
              Left = 8
              Top = 124
              Width = 425
              Height = 13
              Caption = 
                #1059#1082#1072#1079#1099#1074#1072#1081#1090#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080' '#1087#1072#1088#1086#1083#1100' '#1090#1086#1083#1100#1082#1086' '#1077#1089#1083#1080' '#1089#1077#1088#1074#1077#1088' '#1090#1088#1077#1073#1091#1077#1090' ' +
                #1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080'!'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object Label178: TLabel
              Left = 272
              Top = 72
              Width = 61
              Height = 13
              Caption = #1055#1086#1088#1090' SMTP:'
            end
            object Label185: TLabel
              Left = 8
              Top = 175
              Width = 42
              Height = 13
              Caption = #1054#1090' '#1082#1086#1075#1086':'
            end
            object Label186: TLabel
              Left = 200
              Top = 175
              Width = 87
              Height = 13
              Caption = #1054#1073#1088#1072#1090#1085#1099#1081' '#1072#1076#1088#1077#1089':'
            end
            object Label187: TLabel
              Left = 8
              Top = 231
              Width = 47
              Height = 13
              Caption = #1055#1086#1076#1087#1080#1089#1100':'
            end
            object Label202: TLabel
              Left = 8
              Top = 204
              Width = 29
              Height = 13
              Caption = #1050#1086#1084#1091':'
            end
            object CheckBox148: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = 
                #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1080#1089#1077#1084' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103'/'#1073#1088 +
                #1072#1091#1079#1077#1088
              TabOrder = 0
            end
            object Edit62: TEdit
              Left = 104
              Top = 66
              Width = 145
              Height = 21
              MaxLength = 240
              TabOrder = 1
            end
            object Edit63: TEdit
              Left = 104
              Top = 97
              Width = 113
              Height = 21
              MaxLength = 240
              TabOrder = 2
            end
            object Edit64: TEdit
              Left = 304
              Top = 97
              Width = 113
              Height = 21
              MaxLength = 240
              PasswordChar = '*'
              TabOrder = 3
            end
            object CheckBox149: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1080#1089#1077#1084
              TabOrder = 4
            end
            object Edit74: TEdit
              Left = 368
              Top = 66
              Width = 49
              Height = 21
              MaxLength = 5
              TabOrder = 5
            end
            object CheckBox158: TCheckBox
              Left = 8
              Top = 148
              Width = 425
              Height = 17
              Caption = #1046#1077#1089#1090#1082#1086' '#1079#1072#1076#1072#1074#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1080' '#1086#1090#1087#1088#1072#1074#1082#1077':'
              TabOrder = 6
              OnClick = CheckBox158Click
            end
            object Edit79: TEdit
              Left = 64
              Top = 169
              Width = 113
              Height = 21
              MaxLength = 200
              TabOrder = 7
            end
            object Edit80: TEdit
              Left = 304
              Top = 169
              Width = 113
              Height = 21
              MaxLength = 200
              TabOrder = 8
            end
            object Memo81: TMemo
              Left = 64
              Top = 229
              Width = 353
              Height = 40
              MaxLength = 240
              ScrollBars = ssVertical
              TabOrder = 9
            end
            object Edit81: TEdit
              Left = 64
              Top = 198
              Width = 217
              Height = 21
              MaxLength = 200
              TabOrder = 10
            end
          end
        end
      end
      object TabSheet24: TTabSheet
        Tag = 33
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1047#1072#1087#1080#1089#1100' '#1076#1080#1089#1082#1086#1074
        ImageIndex = 22
        object Panel28: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label118: TLabel
            Left = 8
            Top = 58
            Width = 338
            Height = 13
            Caption = #1047#1072#1087#1088#1077#1090#1080#1090#1100' CD-'#1079#1072#1087#1080#1089#1100' '#1092#1072#1081#1083#1086#1074', '#1079#1072#1097#1080#1097#1077#1085#1085#1099#1093' '#1072#1074#1090#1086#1088#1089#1082#1080#1084#1080' '#1087#1088#1072#1074#1072#1084#1080':'
          end
          object Label133: TLabel
            Left = 8
            Top = 103
            Width = 289
            Height = 13
            Caption = #1042#1099#1079#1099#1074#1072#1090#1100' '#1087#1088#1086#1075#1088#1072#1084#1084#1091' '#1087#1086#1089#1083#1077' '#1091#1089#1087#1077#1096#1085#1086#1081' '#1079#1072#1087#1080#1089#1080' CD-'#1076#1080#1089#1082#1072':'
          end
          object Label110: TLabel
            Left = 8
            Top = 176
            Width = 144
            Height = 13
            Caption = #1057#1077#1090#1077#1074#1072#1103' '#1087#1072#1087#1082#1072' '#1076#1083#1103' '#1086#1073#1088#1072#1079#1086#1074':'
          end
          object CheckBox119: TCheckBox
            Left = 8
            Top = 11
            Width = 450
            Height = 17
            Caption = #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' '#1079#1072#1087#1080#1089#1080' CD '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
            TabOrder = 0
          end
          object Edit42: TEdit
            Left = 8
            Top = 74
            Width = 345
            Height = 21
            MaxLength = 250
            TabOrder = 1
          end
          object Edit47: TEdit
            Left = 8
            Top = 119
            Width = 345
            Height = 21
            MaxLength = 250
            TabOrder = 2
          end
          object CheckBox93: TCheckBox
            Left = 8
            Top = 152
            Width = 450
            Height = 17
            Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1076#1080#1089#1082#1086#1074' '#1095#1077#1088#1077#1079' '#1089#1077#1090#1100' '
            TabOrder = 3
            OnClick = CheckBox93Click
          end
          object Edit52: TEdit
            Left = 160
            Top = 172
            Width = 168
            Height = 21
            MaxLength = 250
            TabOrder = 4
          end
          object Button22: TButton
            Left = 332
            Top = 172
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 5
            OnClick = Button22Click
          end
          object CheckBox139: TCheckBox
            Left = 8
            Top = 33
            Width = 450
            Height = 17
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1079#1072#1087#1080#1089#1072#1085#1085#1099#1093' '#1076#1080#1089#1082#1086#1074
            TabOrder = 6
          end
        end
      end
      object TabSheet12: TTabSheet
        Tag = 34
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1044#1080#1089#1087#1077#1090#1095#1077#1088' '#1079#1072#1076#1072#1095
        ImageIndex = 9
        OnShow = TabSheet12Show
        object Panel19: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label57: TLabel
            Left = 8
            Top = 16
            Width = 308
            Height = 13
            Caption = #1057#1087#1080#1089#1086#1082' '#1089#1082#1088#1099#1090#1099#1093' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1074' '#1073#1077#1079#1086#1087#1072#1089#1085#1086#1084' '#1076#1080#1089#1087#1077#1090#1095#1077#1088#1077' '#1079#1072#1076#1072#1095':'
          end
          object Label58: TLabel
            Left = 8
            Top = 308
            Width = 53
            Height = 13
            Caption = 'EXE-'#1092#1072#1081#1083':'
          end
          object ListView4: TListView
            Left = 8
            Top = 40
            Width = 185
            Height = 257
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 150
                MinWidth = 150
                Width = 150
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView4SelectItem
          end
          object Edit9: TEdit
            Left = 67
            Top = 304
            Width = 126
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit9Change
          end
          object CheckBox114: TCheckBox
            Left = 8
            Top = 351
            Width = 450
            Height = 17
            Caption = #1057#1085#1080#1084#1072#1090#1100' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103' '#1073#1077#1079' '#1086#1082#1086#1085' ('#1089#1082#1088#1099#1090#1099#1077') '#1087#1088#1080' '#1089#1085#1103#1090#1080#1080' '#1074#1089#1077#1093' '#1079#1072#1076#1072#1095
            TabOrder = 2
          end
        end
      end
      object TabSheet38: TTabSheet
        Tag = 35
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085
        ImageIndex = 37
        OnShow = TabSheet38Show
        object Panel43: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label136: TLabel
            Left = 8
            Top = 269
            Width = 53
            Height = 13
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label137: TLabel
            Left = 8
            Top = 293
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object Label192: TLabel
            Left = 8
            Top = 12
            Width = 442
            Height = 13
            Caption = 
              #1047#1076#1077#1089#1100' '#1091#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1077#1090#1089#1103' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1085#1090#1077#1085#1090#1072' '#1076#1083#1103' '#1087#1083#1072#1090#1085#1086#1081' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1074' '#1084#1086#1073 +
              #1080#1083#1100#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085':'
          end
          object Label196: TLabel
            Left = 8
            Top = 348
            Width = 173
            Height = 13
            Caption = #1040#1091#1076#1080#1086'-'#1092#1072#1081#1083#1099' '#1076#1083#1103' '#1087#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088#1072':'
          end
          object Label197: TLabel
            Left = 8
            Top = 372
            Width = 174
            Height = 13
            Caption = #1042#1080#1076#1077#1086'-'#1092#1072#1081#1083#1099' '#1076#1083#1103' '#1087#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088#1072':'
          end
          object Label198: TLabel
            Left = 8
            Top = 396
            Width = 193
            Height = 13
            Caption = #1060#1072#1081#1083#1099' '#1082#1072#1088#1090#1080#1085#1086#1082' '#1076#1083#1103' '#1087#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088#1072':'
          end
          object Label199: TLabel
            Left = 8
            Top = 318
            Width = 366
            Height = 13
            Caption = #1042' '#1089#1082#1086#1073#1082#1072#1093' '#1087#1086#1089#1083#1077' '#1085#1072#1079#1074#1072#1085#1080#1103' '#1091#1082#1072#1079#1099#1074#1072#1077#1090#1089#1103' '#1085#1086#1084#1077#1088' '#1089#1086#1087#1086#1089#1090#1072#1074#1083#1103#1077#1084#1086#1081' '#1080#1082#1086#1085#1082#1080
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object ListView16: TListView
            Left = 8
            Top = 30
            Width = 345
            Height = 227
            Checkboxes = True
            Columns = <
              item
                Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end
              item
                Caption = #1055#1091#1090#1100
                MaxWidth = 160
                MinWidth = 160
                Width = 160
              end>
            GridLines = True
            ReadOnly = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView16SelectItem
          end
          object Edit50: TEdit
            Left = 80
            Top = 265
            Width = 273
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit50Change
          end
          object Edit51: TEdit
            Left = 80
            Top = 289
            Width = 246
            Height = 21
            MaxLength = 100
            TabOrder = 2
            OnChange = Edit51Change
          end
          object Button21: TButton
            Left = 332
            Top = 289
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 3
            OnClick = Button21Click
          end
          object Edit84: TEdit
            Left = 240
            Top = 344
            Width = 217
            Height = 21
            MaxLength = 250
            TabOrder = 4
          end
          object Edit87: TEdit
            Left = 240
            Top = 368
            Width = 217
            Height = 21
            MaxLength = 250
            TabOrder = 5
          end
          object Edit88: TEdit
            Left = 240
            Top = 392
            Width = 217
            Height = 21
            MaxLength = 250
            TabOrder = 6
          end
          object CheckBox165: TCheckBox
            Left = 8
            Top = 424
            Width = 450
            Height = 17
            Caption = 
              #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' "'#1052#1086#1073#1080#1083#1100#1085#1099#1081' '#1082#1086#1085#1090#1077#1085#1090'" '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077 +
              #1083#1103
            TabOrder = 7
          end
        end
      end
      object TabSheet41: TTabSheet
        Tag = 36
        Caption = #1059#1090#1080#1083#1080#1090#1099': '#1055#1088#1086#1095#1080#1077
        ImageIndex = 40
        object Panel23: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox13: TGroupBox
            Left = 8
            Top = 10
            Width = 450
            Height = 124
            Caption = ' '#1056#1072#1073#1086#1090#1072' '#1089' Bluetooth / IrDA '
            TabOrder = 0
            object Label200: TLabel
              Left = 27
              Top = 91
              Width = 140
              Height = 13
              Caption = #1057#1077#1090#1077#1074#1072#1103' '#1087#1072#1087#1082#1072' '#1076#1083#1103' '#1092#1072#1081#1083#1086#1074':'
            end
            object CheckBox144: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' Bluetooth/IrDA '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
              TabOrder = 0
            end
            object CheckBox142: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1088#1072#1073#1086#1090#1099' '#1089' Bluetooth/IrDA'
              TabOrder = 1
            end
            object CheckBox166: TCheckBox
              Left = 8
              Top = 65
              Width = 425
              Height = 17
              Caption = #1042#1099#1087#1086#1083#1085#1103#1090#1100' Bluetooth-'#1087#1077#1088#1077#1076#1072#1095#1091' '#1095#1077#1088#1077#1079' '#1089#1077#1090#1100' '
              TabOrder = 2
              OnClick = CheckBox166Click
            end
            object Edit89: TEdit
              Left = 179
              Top = 87
              Width = 168
              Height = 21
              MaxLength = 250
              TabOrder = 3
            end
            object Button28: TButton
              Left = 351
              Top = 87
              Width = 21
              Height = 21
              Caption = '...'
              TabOrder = 4
              OnClick = Button28Click
            end
          end
          object GroupBox29: TGroupBox
            Left = 8
            Top = 146
            Width = 450
            Height = 96
            Caption = ' '#1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1081' '
            TabOrder = 1
            object Label201: TLabel
              Left = 8
              Top = 44
              Width = 265
              Height = 13
              Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1074' '#1089#1083#1077#1076#1091#1102#1097#1080#1093' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103#1093':'
            end
            object CheckBox140: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1087#1088#1086#1089#1084#1086#1090#1088' '#1089' '#1089#1077#1088#1074#1077#1088#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080' '#1089#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
              TabOrder = 0
            end
            object Edit90: TEdit
              Left = 8
              Top = 60
              Width = 361
              Height = 21
              MaxLength = 250
              TabOrder = 1
            end
          end
          object GroupBox31: TGroupBox
            Left = 8
            Top = 255
            Width = 450
            Height = 108
            Caption = ' '#1059#1090#1080#1083#1080#1090#1099' '#1074' '#1090#1088#1077#1077' '
            TabOrder = 2
            object CheckBox20: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = #1056#1077#1075#1091#1083#1103#1090#1086#1088' '#1075#1088#1086#1084#1082#1086#1089#1090#1080
              TabOrder = 0
            end
            object CheckBox48: TCheckBox
              Left = 8
              Top = 39
              Width = 425
              Height = 17
              Caption = #1056#1077#1075#1091#1083#1103#1090#1086#1088' '#1091#1088#1086#1074#1085#1103' '#1079#1072#1087#1080#1089#1080
              TabOrder = 1
            end
            object CheckBox21: TCheckBox
              Left = 8
              Top = 59
              Width = 425
              Height = 17
              Caption = #1048#1085#1076#1080#1082#1072#1090#1086#1088' '#1103#1079#1099#1082#1072
              TabOrder = 2
            end
            object CheckBox42: TCheckBox
              Left = 8
              Top = 79
              Width = 425
              Height = 17
              Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077' '#1086#1082#1085#1072
              TabOrder = 3
            end
          end
          object GroupBox16: TGroupBox
            Left = 8
            Top = 376
            Width = 449
            Height = 49
            Caption = ' '#1060#1086#1090#1086#1082#1072#1084#1077#1088#1072' '
            TabOrder = 3
            object CheckBox26: TCheckBox
              Left = 8
              Top = 19
              Width = 425
              Height = 17
              Caption = 
                #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1091#1090#1080#1083#1080#1090#1091' '#1092#1086#1090#1086#1082#1072#1084#1077#1088#1099' '#1074' '#1087#1088#1086#1074#1086#1076#1085#1080#1082', '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091' '#1080' '#1072#1074#1090#1086#1079 +
                #1072#1087#1091#1089#1082
              TabOrder = 0
            end
          end
        end
      end
      object TabSheet45: TTabSheet
        Tag = 1000
        Caption = 'Rollback ('#1054#1090#1082#1072#1090')'
        ImageIndex = 44
        object Panel50: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1091#1078#1085#1099#1081' '#1087#1086#1076#1088#1072#1079#1076#1077#1083
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object TabSheet49: TTabSheet
        Tag = 1001
        Caption = 'Rollback ('#1054#1090#1082#1072#1090'): AstalaVista/ShadowUser'
        ImageIndex = 48
        object Panel54: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label96: TLabel
            Left = 8
            Top = 40
            Width = 450
            Height = 73
            AutoSize = False
            Caption = 
              #1045#1089#1083#1080' Rollback ('#1086#1090#1082#1072#1090') '#1091#1078#1077' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' ('#1080#1083#1080' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074 +
              #1072#1090#1100') '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#1093' AstalaVista '#1080#1083#1080' ShadowUser, '#1090#1086' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1082#1083#1102 +
              #1095#1080#1090#1100' '#1101#1090#1091' '#1086#1087#1094#1080#1102' '#1080' '#1085#1077' '#1074#1082#1083#1102#1095#1072#1090#1100' '#1086#1090#1082#1072#1090' '#1079#1076#1077#1089#1100' '#1074' RunpadPro, '#1090'.'#1082'. '#1074' '#1087#1088#1086 +
              #1090#1080#1074#1085#1086#1084' '#1089#1083#1091#1095#1072#1077' '#1073#1091#1076#1077#1090' '#1088#1080#1089#1082' '#1082#1086#1085#1092#1083#1080#1082#1090#1072'. '#1055#1088#1080' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1080' '#1086#1090#1082#1072#1090#1072' '#1074' '#1076 +
              #1088#1091#1075#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084#1072#1093' '#1085#1091#1078#1085#1086' '#1087#1088#1086#1089#1090#1086' '#1085#1077' '#1074#1082#1083#1102#1095#1072#1090#1100' '#1077#1075#1086' '#1074' RunpadPro.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object CheckBox78: TCheckBox
            Left = 8
            Top = 11
            Width = 450
            Height = 17
            Caption = 
              'Rollback ('#1086#1090#1082#1072#1090') '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090#1089#1103' '#1074' Astalavista/ShadowUser, '#1072' '#1085#1077' Run' +
              'padPro'
            TabOrder = 0
          end
        end
      end
      object TabSheet47: TTabSheet
        Tag = 1002
        Caption = 'Rollback ('#1054#1090#1082#1072#1090'): '#1044#1080#1089#1082#1080
        ImageIndex = 46
        OnShow = TabSheet47Show
        object Panel52: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label81: TLabel
            Left = 8
            Top = 16
            Width = 287
            Height = 13
            Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1080#1089#1082#1080', '#1076#1083#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1073#1091#1076#1077#1090' '#1074#1099#1087#1086#1083#1085#1103#1090#1100#1089#1103' '#1086#1090#1082#1072#1090':'
          end
          object Label99: TLabel
            Left = 8
            Top = 37
            Width = 385
            Height = 13
            Caption = #1042#1085#1080#1084#1072#1085#1080#1077'! '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086' '#1087#1088#1086#1095#1090#1080#1090#1077' '#1089#1087#1088#1072#1074#1082#1091' '#1087#1086' '#1101#1090#1080#1084' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1084'!'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CheckListBox5: TCheckListBox
            Left = 8
            Top = 60
            Width = 97
            Height = 429
            ItemHeight = 16
            Items.Strings = (
              'A:'
              'B:'
              'C:'
              'D:'
              'E:'
              'F:'
              'G:'
              'H:'
              'I:'
              'J:'
              'K:'
              'L:'
              'M:'
              'N:'
              'O:'
              'P:'
              'Q:'
              'R:'
              'S:'
              'T:'
              'U:'
              'V:'
              'W:'
              'X:'
              'Y:'
              'Z:')
            Style = lbOwnerDrawFixed
            TabOrder = 0
          end
        end
      end
      object TabSheet48: TTabSheet
        Tag = 1003
        Caption = 'Rollback ('#1054#1090#1082#1072#1090'): '#1048#1089#1082#1083#1102#1095#1077#1085#1080#1103
        ImageIndex = 47
        OnShow = TabSheet48Show
        object Panel53: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label89: TLabel
            Left = 8
            Top = 16
            Width = 310
            Height = 13
            Caption = #1055#1072#1087#1082#1080', '#1076#1083#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1085#1077' '#1073#1091#1076#1077#1090' '#1074#1099#1087#1086#1083#1085#1103#1090#1100#1089#1103' '#1086#1090#1082#1072#1090' '#1080#1079#1084#1077#1085#1077#1085#1080#1081':'
          end
          object Label90: TLabel
            Left = 8
            Top = 338
            Width = 27
            Height = 13
            Caption = #1055#1091#1090#1100':'
          end
          object Label98: TLabel
            Left = 8
            Top = 37
            Width = 385
            Height = 13
            Caption = #1042#1085#1080#1084#1072#1085#1080#1077'! '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086' '#1087#1088#1086#1095#1090#1080#1090#1077' '#1089#1087#1088#1072#1074#1082#1091' '#1087#1086' '#1101#1090#1080#1084' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1084'!'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object ListView17: TListView
            Left = 8
            Top = 60
            Width = 265
            Height = 265
            Checkboxes = True
            Columns = <
              item
                Caption = 'EXE'
                MaxWidth = 230
                MinWidth = 230
                Width = 230
              end>
            ColumnClick = False
            ReadOnly = True
            RowSelect = True
            ShowColumnHeaders = False
            TabOrder = 0
            ViewStyle = vsReport
            OnSelectItem = ListView17SelectItem
          end
          object Edit82: TEdit
            Left = 67
            Top = 334
            Width = 174
            Height = 21
            MaxLength = 100
            TabOrder = 1
            OnChange = Edit82Change
          end
          object Button2: TButton
            Left = 248
            Top = 334
            Width = 21
            Height = 21
            Caption = '...'
            TabOrder = 2
            OnClick = Button2Click
          end
        end
      end
      object TabSheet46: TTabSheet
        Tag = 1004
        Caption = 'Rollback ('#1054#1090#1082#1072#1090'): '#1042#1082#1083'/'#1054#1090#1082#1083
        ImageIndex = 45
        object Panel51: TPanel
          Left = 0
          Top = 0
          Width = 467
          Height = 501
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object Label75: TLabel
            Left = 8
            Top = 35
            Width = 385
            Height = 13
            Caption = #1042#1085#1080#1084#1072#1085#1080#1077'! '#1054#1073#1103#1079#1072#1090#1077#1083#1100#1085#1086' '#1087#1088#1086#1095#1090#1080#1090#1077' '#1089#1087#1088#1072#1074#1082#1091' '#1087#1086' '#1101#1090#1080#1084' '#1085#1072#1089#1090#1088#1086#1081#1082#1072#1084'!'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -12
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CheckBox77: TCheckBox
            Left = 8
            Top = 11
            Width = 450
            Height = 17
            Caption = 
              #1042#1082#1083#1102#1095#1080#1090#1100' "'#1072#1074#1090#1086'-'#1086#1090#1082#1072#1090' '#1092#1072#1081#1083#1086#1074#1086#1081' '#1089#1080#1089#1090#1077#1084#1099' (Rollback) '#1087#1086#1089#1083#1077' '#1082#1072#1078#1076#1086#1081' '#1087#1077 +
              #1088#1077#1079#1072#1075#1088#1091#1079#1082#1080'"'
            TabOrder = 0
          end
        end
      end
    end
    object Panel40: TPanel
      Left = 0
      Top = 533
      Width = 475
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Panel41: TPanel
        Left = 290
        Top = 0
        Width = 185
        Height = 44
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonCancel: TButton
          Left = 94
          Top = 11
          Width = 75
          Height = 25
          Caption = #1054#1090#1084#1077#1085#1072
          ModalResult = 2
          TabOrder = 0
        end
        object ButtonOK: TButton
          Left = 10
          Top = 11
          Width = 75
          Height = 25
          Caption = 'OK'
          ModalResult = 1
          TabOrder = 1
        end
      end
      object Panel42: TPanel
        Left = 0
        Top = 0
        Width = 290
        Height = 44
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Button3: TBitBtn
          Left = 16
          Top = 3
          Width = 105
          Height = 38
          Caption = #1057#1087#1088#1072#1074#1082#1072
          TabOrder = 0
          OnClick = Button3Click
          Glyph.Data = {
            66070000424D6607000000000000660300002800000020000000200000000100
            08000000000000040000120B0000120B0000CC000000CC000000D0CED100FF00
            FF00EDECED00C7C4C600C3C0C100D6D1D200C3BFBF00D1CECE00FCFAFA00F5F3
            F300D1664F00C9614C00BD635100BBB6B500B0ABAA00D8D3D200CD6A5400CC6A
            5300C96C5600B3614F00C46C5700AD624F00A0675A00A26D6000A48C8600BAB2
            B000F8F4F300C46F5900C0705900C0715B0094625400B678680094645700A06E
            600096706600C4AFA900BAABA700D1CAC800BB694F00B2685200AC675100BA70
            5A00B56F5800B87763009E6959008F615300B68D8000BE948700C0988B00C3B6
            B200C3B9B600CEC4C100DB826100E2876500AD695000DA866700E28E6F00B26E
            57009D655000EDA48900EFAE970089655800A0776800CF9C8A00BF908000CEA3
            9300B8928400E1B3A200886F6600C5A29500DFB7A900B99A8F00A2877D00947C
            7300BFA09500A88D8300B5998F00CAAEA400ECCCC100B9A59E0086787300B9A7
            A100DAC5BE00DFCCC500DACCC700EDDED900A14B28009D4B2900924626009848
            2800A2502F00A55331009A503100924D3000AB5A3A0095503400AC5D3D00B463
            410099543700B0614100B9664500AD614100AC624300864D3500CD765300A45F
            4200C26F4F009D5B4000C7745200D87D5A00B76B4C00E0836000D97F5D00C574
            5400D37D5B00CB7858008B533C00A261470092574000AE694E00A2624900E58C
            6A00CB7D5E00AA694F00C2795C00AE6D5300E8917000935C47008E5B4700DD8F
            7000A46A5300CC866A00DA937600E99F8300AB756000ECA38700BF856E00B37D
            6700EDAA9000DE9F8700986F5F00B2837000AC7F6D00A27A6A00C2978500B88F
            7F00A17E70009B7A6D0081675D00E9BFAF00E3BEAF00F1CCBD00D9BEB300E9CE
            C300A59893009D918C00D5C6C000B4A7A2008C401E008C432300964928009B4D
            2C008F482A00944B2C008E492B00A355340099523400A05A3B009C583B00B265
            4400A8735C007C5645009B6D59007D5D4E00816D6400D1B1A300A38F86008E7F
            7800958A8500FFF4EF00B4B0AE00CBC9C800C1C0BF00D9DADD00BDBDC100D6D6
            D8007B7B7C006E6E6F00D2D2D300B7B7B800A8A8A9008F8F90008E8E8F007F7F
            8000FAFAFA00E1E1E100D9D9D900CCCCCC00C0C0C000B8B8B800B0B0B000A1A1
            A1009595950000000000010101010101010101010101BEC0BABBBBBAC0BE0101
            01010101010101010101010101010101010101BEBAC9C6C402C2C202C4C6C9BA
            BE01010101010101010101010101010101C8C0C602079B443D2D1E2022182502
            C6C0C801010101010101010101010101CABD02B49480783639291D1B12100C16
            2402BDCA0101010101010101010101BFBCC4AE675F6B78287715261B1410110A
            0B170FBCBF010101010101010101BFC3B6AB9FA45F6B78788D472E2814121011
            110A1331C3BF01010101010101CABCB6AB9F9FA45F62A842BC0FB72327141210
            1111111332BCCA0101010101C8BDC4AD9E9F9FA25D626B320304C6B91F141B14
            12101210150FC7C801010101C002505858585858A45FA84F04C704252B1C1B1B
            1B1B141B142102C0010101BEC7C77457595858A2A35F5F164F0D3240271C2A29
            1D1D1B1B1C2651C6BE0101C102B15BA1A1A1A258A3A3626262787766362A2A29
            1C2A291C391C2C02C10101C9BCAC655BA1A1A1A1A3A35C6B8F8F923A28362A7D
            2A2A39391C277733C901BEC6C977A9655B5AA1A1A1A1A0AABCBCBC3E697B3636
            362A39363627774804BEC0C4B2646EA9A95B5A5AA1A157820707BC4B6278787B
            7B7828282877151EC4C0BA02496A6E6E15A95E5A5AA1A1A532C603068C5D6975
            757878787869697F02BABBC2936C6A6A6A6EA95E5B5B5AA18EB80D0DC6925D6B
            6B69A869A7696B76C2BBBBC292736A6A6A6A6E6EA9605A5A5A8EC80D06BC4C5D
            A6A6A6A66B5FA67FC2BBBA0248727373736A6A6A776EA9605B56860D0405028F
            A3A6A6625FA6A67402BAC0C49A3773737371716A6A6A6E6EA9605A9105C4029C
            5D5CA6A6A6625F3DC4C0BEC60E847273737C7373716E646E6E6EA98802020902
            75625CA6A6A65DB0C6BE01C9BC413772727373736A3F42A9A9645E41C2C2081A
            216069696969A607C90101C1029D877234727273684EC2544590AF1AC2C2C202
            7765657869A88C02C10101BEC7C6433870347272684EC2C2C2C2C2C2C2C2C298
            63656565696232C7BE010101CA02198A343437727297C2C2C2C2C2C2C2C2557C
            A9776565A79202CA01010101BEC7C3523B343534708197B3C2C2C2C2B3967C64
            776E776382C40DC80101010101CABC00993B353434346D37848B8B847A6A6A6A
            6E6A613903BCCA01010101010101BFC300533C7E6F343434706D6D7373737373
            6A6489B5C3BF010101010101010101BFBCC3B59587796F34347272726D73686A
            6A47C4BCBF0101010101010101010101CAC802C59C4685796F6F346D6D73834A
            0302C7CA01010101010101010101010101C8BFC702C4B6314D302F452332C402
            B6BFC801010101010101010101010101010101BEC1C9C6C402C2C202C4C6C9BA
            BE010101010101010101010101010101010101010101BEBFBABBBBBAC0BE0101
            01010101010101010101}
          Margin = 5
          Spacing = 10
        end
      end
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 85
    Top = 11
  end
end
