object SetupContentForm: TSetupContentForm
  Left = 17
  Top = 121
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1088#1086#1092#1080#1083#1100' '#1082#1086#1085#1090#1077#1085#1090#1072
  ClientHeight = 773
  ClientWidth = 1242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 370
    Top = 0
    Width = 6
    Height = 773
    AutoSnap = False
    Beveled = True
    MinSize = 150
  end
  object Panel2: TPanel
    Left = 376
    Top = 0
    Width = 866
    Height = 773
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel2: TBevel
      Left = 0
      Top = 718
      Width = 866
      Height = 1
      Align = alBottom
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Panel40: TPanel
      Left = 0
      Top = 719
      Width = 866
      Height = 54
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Panel41: TPanel
        Left = 639
        Top = 0
        Width = 227
        Height = 54
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object ButtonCancel: TButton
          Left = 116
          Top = 14
          Width = 92
          Height = 30
          Caption = #1054#1090#1084#1077#1085#1072
          ModalResult = 2
          TabOrder = 1
        end
        object ButtonOK: TButton
          Left = 12
          Top = 14
          Width = 93
          Height = 30
          Caption = 'OK'
          TabOrder = 0
          OnClick = ButtonOKClick
        end
      end
      object Panel42: TPanel
        Left = 0
        Top = 0
        Width = 639
        Height = 54
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Button3: TBitBtn
          Left = 20
          Top = 4
          Width = 129
          Height = 46
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
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 866
      Height = 718
      ActivePage = TabSheet3
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 1
      TabStop = False
      object TabSheet1: TTabSheet
        Caption = '---'
        TabVisible = False
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 843
          Height = 708
          Align = alClient
          BevelOuter = bvNone
          Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1080#1083#1080' '#1089#1086#1079#1076#1072#1081#1090#1077' '#1079#1072#1082#1083#1072#1076#1082#1091'/'#1103#1088#1083#1099#1082
          TabOrder = 0
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Sheet options'
        ImageIndex = 1
        TabVisible = False
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 843
          Height = 708
          Align = alClient
          BiDiMode = bdLeftToRight
          Caption = ' -= '#1047#1072#1082#1083#1072#1076#1082#1072' =- '
          ParentBiDiMode = False
          TabOrder = 0
          object Label1: TLabel
            Left = 10
            Top = 20
            Width = 69
            Height = 16
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label2: TLabel
            Left = 10
            Top = 71
            Width = 87
            Height = 16
            Caption = #1060#1072#1081#1083' '#1080#1082#1086#1085#1082#1080':'
          end
          object Label3: TLabel
            Left = 10
            Top = 137
            Width = 121
            Height = 16
            Caption = #1062#1074#1077#1090' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103':'
          end
          object Label5: TLabel
            Left = 10
            Top = 199
            Width = 356
            Height = 48
            AutoSize = False
            Caption = 
              #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1074#1080#1076#1077#1086', '#1082#1072#1088#1090#1080#1085#1082#1080' ('#1080#1083#1080' '#1087#1072#1087#1082#1077' '#1089' '#1082#1072#1088#1090#1080#1085#1082#1072#1084#1080') '#1080#1083#1080' '#1087#1083#1072#1075#1080#1085 +
              #1072' '#1074#1080#1079#1091#1072#1083#1080#1079#1072#1094#1080#1080' '#1076#1083#1103' '#1092#1086#1085#1072' ('#1076#1083#1103' '#1073#1086#1083#1077#1077' '#1087#1086#1076#1088#1086#1073#1085#1086#1081' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1089#1084'. '#1089#1087#1088#1072 +
              #1074#1082#1091'):'
            WordWrap = True
          end
          object Label10: TLabel
            Left = 10
            Top = 455
            Width = 366
            Height = 16
            Caption = 'VIP-'#1082#1083#1080#1077#1085#1090#1099' '#1095#1077#1088#1077#1079' '#1090#1086#1095#1082#1091' '#1089' '#1079#1072#1087#1103#1090#1086#1081' ('#1080#1083#1080' * - '#1076#1083#1103' '#1074#1089#1077#1093' VIP):'
          end
          object Label11: TLabel
            Left = 10
            Top = 507
            Width = 215
            Height = 16
            Caption = #1060#1072#1081#1083' '#1089' '#1087#1088#1072#1074#1080#1083#1072#1084#1080' '#1076#1083#1103' '#1079#1072#1082#1083#1072#1076#1082#1080':'
          end
          object Label4: TLabel
            Left = 10
            Top = 167
            Width = 73
            Height = 16
            Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072':'
          end
          object Label23: TLabel
            Left = 10
            Top = 284
            Width = 300
            Height = 16
            Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089' preview-'#1082#1072#1088#1090#1080#1085#1082#1072#1084#1080' ('#1076#1083#1103' '#1089#1093#1077#1084'):'
          end
          object Edit1: TEdit
            Left = 10
            Top = 39
            Width = 369
            Height = 24
            MaxLength = 250
            TabOrder = 0
            Text = 'Edit1'
            OnChange = Edit1Change
          end
          object Edit2: TEdit
            Left = 10
            Top = 91
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 1
            Text = 'Edit2'
          end
          object Button1: TButton
            Left = 353
            Top = 91
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 2
            OnClick = Button1Click
          end
          object PanelColor: TPanel
            Left = 138
            Top = 130
            Width = 26
            Height = 26
            BevelInner = bvLowered
            BevelOuter = bvNone
            TabOrder = 12
            OnClick = PanelColorClick
          end
          object Edit3: TEdit
            Left = 10
            Top = 252
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 3
            Text = 'Edit3'
          end
          object Button2: TButton
            Left = 353
            Top = 252
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 4
            OnClick = Button2Click
          end
          object GroupBox3: TGroupBox
            Left = 10
            Top = 340
            Width = 369
            Height = 104
            Caption = ' '#1048#1085#1090#1077#1088#1074#1072#1083' '#1074#1080#1076#1080#1084#1086#1089#1090#1080' '#1079#1072#1082#1083#1072#1076#1082#1080' '
            TabOrder = 7
            object Label6: TLabel
              Left = 10
              Top = 27
              Width = 20
              Height = 16
              Caption = #1054#1090':'
            end
            object LabelTimeMin: TLabel
              Left = 266
              Top = 27
              Width = 49
              Height = 16
              Caption = '? '#1095#1072#1089#1086#1074
            end
            object Label8: TLabel
              Left = 10
              Top = 64
              Width = 20
              Height = 16
              Caption = #1044#1086':'
            end
            object LabelTimeMax: TLabel
              Left = 266
              Top = 64
              Width = 49
              Height = 16
              Caption = '? '#1095#1072#1089#1086#1074
            end
            object TrackBarTimeMin: TTrackBar
              Left = 39
              Top = 22
              Width = 222
              Height = 32
              Max = 24
              PageSize = 1
              TabOrder = 0
              ThumbLength = 18
              OnChange = TrackBarTimeMinChange
            end
            object TrackBarTimeMax: TTrackBar
              Left = 39
              Top = 59
              Width = 222
              Height = 32
              Max = 24
              PageSize = 1
              TabOrder = 1
              ThumbLength = 18
              OnChange = TrackBarTimeMaxChange
            end
          end
          object Edit4: TEdit
            Left = 10
            Top = 475
            Width = 369
            Height = 24
            MaxLength = 250
            TabOrder = 8
            Text = 'Edit4'
          end
          object Edit5: TEdit
            Left = 10
            Top = 527
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 9
            Text = 'Edit5'
          end
          object Button4: TButton
            Left = 353
            Top = 527
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 10
            OnClick = Button4Click
          end
          object CheckBoxInternet: TCheckBox
            Left = 10
            Top = 567
            Width = 369
            Height = 21
            Caption = #1069#1090#1086' '#1079#1072#1082#1083#1072#1076#1082#1072' '#1089' '#1080#1085#1090#1077#1088#1085#1077#1090'-'#1082#1086#1085#1090#1077#1085#1090#1086#1084
            TabOrder = 11
          end
          object PanelBGColor: TPanel
            Left = 138
            Top = 161
            Width = 26
            Height = 26
            BevelInner = bvLowered
            BevelOuter = bvNone
            TabOrder = 13
            OnClick = PanelBGColorClick
          end
          object Edit17: TEdit
            Left = 10
            Top = 304
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 5
            Text = 'Edit17'
          end
          object Button17: TButton
            Left = 353
            Top = 304
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 6
            OnClick = Button17Click
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Shortcut options'
        ImageIndex = 2
        TabVisible = False
        object GroupBox2: TGroupBox
          Left = 0
          Top = 0
          Width = 858
          Height = 708
          Align = alClient
          Caption = ' -= '#1071#1088#1083#1099#1082' =- '
          TabOrder = 0
          object Label7: TLabel
            Left = 10
            Top = 20
            Width = 69
            Height = 16
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
          end
          object Label9: TLabel
            Left = 10
            Top = 71
            Width = 233
            Height = 16
            Caption = #1048#1089#1087#1086#1083#1085#1103#1077#1084#1099#1081' '#1092#1072#1081#1083', '#1087#1072#1087#1082#1072' '#1080#1083#1080' URL:'
          end
          object Label12: TLabel
            Left = 10
            Top = 123
            Width = 198
            Height = 16
            Caption = #1040#1088#1075#1091#1084#1077#1085#1090#1099' '#1082#1086#1084#1072#1085#1076#1085#1086#1081' '#1089#1090#1088#1086#1082#1080':'
          end
          object Label13: TLabel
            Left = 10
            Top = 175
            Width = 254
            Height = 16
            Caption = #1056#1072#1073#1086#1095#1072#1103' '#1087#1072#1087#1082#1072' ('#1087#1091#1089#1090#1086' - '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102'):'
          end
          object Label14: TLabel
            Left = 10
            Top = 226
            Width = 258
            Height = 16
            Caption = #1060#1072#1081#1083' '#1089' '#1080#1082#1086#1085#1082#1086#1081' ('#1087#1091#1089#1090#1086' - '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102'):'
          end
          object Label15: TLabel
            Left = 276
            Top = 226
            Width = 100
            Height = 16
            Caption = #1048#1085#1076#1077#1082#1089' '#1080#1082#1086#1085#1082#1080':'
          end
          object Label16: TLabel
            Left = 10
            Top = 278
            Width = 193
            Height = 16
            Caption = #1055#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1079#1072#1087#1091#1089#1082#1072':'
          end
          object Label20: TLabel
            Left = 217
            Top = 278
            Width = 85
            Height = 16
            Caption = #1058#1080#1087' '#1079#1072#1087#1091#1089#1082#1072':'
          end
          object Label21: TLabel
            Left = 10
            Top = 489
            Width = 130
            Height = 16
            Caption = #1060#1072#1081#1083' '#1089' '#1086#1073#1088#1072#1079#1086#1084' CD:'
          end
          object Label22: TLabel
            Left = 10
            Top = 540
            Width = 130
            Height = 16
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1086#1073#1088#1072#1079#1086#1074':'
          end
          object Label24: TLabel
            Left = 10
            Top = 592
            Width = 111
            Height = 16
            Caption = #1060#1072#1081#1083' '#1089#1082#1088#1080#1085#1096#1086#1090#1072':'
          end
          object Label25: TLabel
            Left = 10
            Top = 644
            Width = 50
            Height = 16
            Caption = #1043#1088#1091#1087#1087#1072':'
          end
          object Label26: TLabel
            Left = 394
            Top = 592
            Width = 155
            Height = 16
            Caption = '"'#1055#1083#1072#1074#1072#1102#1097#1072#1103'" '#1083#1080#1094#1077#1085#1079#1080#1103':'
          end
          object Edit6: TEdit
            Left = 10
            Top = 39
            Width = 369
            Height = 24
            MaxLength = 250
            TabOrder = 0
            Text = 'Edit6'
            OnChange = Edit6Change
          end
          object Edit7: TEdit
            Left = 10
            Top = 91
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 1
            Text = 'Edit7'
            OnChange = Edit7Change
          end
          object Button5: TButton
            Left = 353
            Top = 91
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 2
            OnClick = Button5Click
          end
          object Edit8: TEdit
            Left = 10
            Top = 143
            Width = 369
            Height = 24
            MaxLength = 250
            TabOrder = 3
            Text = 'Edit8'
          end
          object Edit9: TEdit
            Left = 10
            Top = 194
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 4
            Text = 'Edit9'
          end
          object Button6: TButton
            Left = 353
            Top = 194
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 5
            OnClick = Button6Click
          end
          object Edit10: TEdit
            Left = 10
            Top = 246
            Width = 224
            Height = 24
            MaxLength = 250
            TabOrder = 6
            Text = 'Edit10'
          end
          object Button7: TButton
            Left = 234
            Top = 246
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 7
            OnClick = Button7Click
          end
          object Edit11: TEdit
            Left = 276
            Top = 246
            Width = 103
            Height = 24
            MaxLength = 7
            TabOrder = 8
            Text = 'Edit11'
          end
          object Edit12: TEdit
            Left = 10
            Top = 298
            Width = 188
            Height = 24
            MaxLength = 250
            TabOrder = 9
            Text = 'Edit12'
          end
          object CheckBoxOnlyOne: TCheckBox
            Left = 10
            Top = 332
            Width = 369
            Height = 21
            Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' '#1088#1077#1078#1080#1084' "'#1079#1072#1087#1091#1089#1082' '#1090#1086#1083#1100#1082#1086' '#1086#1076#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099'"'
            TabOrder = 11
          end
          object GroupBox4: TGroupBox
            Left = 10
            Top = 361
            Width = 369
            Height = 119
            Caption = ' '#1047#1072#1087#1091#1089#1082' '#1086#1090' '#1080#1084#1077#1085#1080'... '
            TabOrder = 12
            object Label17: TLabel
              Left = 10
              Top = 26
              Width = 119
              Height = 16
              Caption = #1044#1086#1084#1077#1085' ('#1077#1089#1083#1080' '#1077#1089#1090#1100'):'
            end
            object Label18: TLabel
              Left = 10
              Top = 55
              Width = 98
              Height = 16
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
            end
            object Label19: TLabel
              Left = 10
              Top = 85
              Width = 128
              Height = 16
              Caption = #1055#1072#1088#1086#1083#1100' ('#1085#1077' '#1087#1091#1089#1090#1086#1081'):'
            end
            object Edit13: TEdit
              Left = 148
              Top = 22
              Width = 168
              Height = 24
              MaxLength = 250
              TabOrder = 0
              Text = 'Edit13'
            end
            object Edit14: TEdit
              Left = 148
              Top = 52
              Width = 168
              Height = 24
              MaxLength = 250
              TabOrder = 1
              Text = 'Edit14'
            end
            object Edit15: TEdit
              Left = 148
              Top = 81
              Width = 168
              Height = 24
              MaxLength = 250
              TabOrder = 2
              Text = 'Edit15'
            end
          end
          object ComboBoxShowCmd: TComboBox
            Left = 217
            Top = 298
            Width = 162
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 10
            Items.Strings = (
              #1053#1086#1088#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1085#1086
              #1057#1082#1088#1099#1090#1086#1077' '#1086#1082#1085#1086
              #1056#1072#1079#1074#1077#1088#1085#1091#1090#1086#1077' '#1086#1082#1085#1086
              #1057#1074#1077#1088#1085#1091#1090#1086#1077' '#1086#1082#1085#1086)
          end
          object Edit16: TEdit
            Left = 10
            Top = 508
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 13
            Text = 'Edit16'
          end
          object Button8: TButton
            Left = 353
            Top = 508
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 14
            OnClick = Button8Click
          end
          object ComboBoxVCD: TComboBox
            Left = 10
            Top = 560
            Width = 343
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 15
            OnChange = ComboBoxVCDChange
            Items.Strings = (
              'Virtual Drive'
              'Virtual CD'
              'Alcohol'
              'Daemon-Tools Lite (DT)'
              'Daemon-Tools Pro Standard/Advanced (SCSI)'
              'Daemon-Tools Pro Standard/Advanced (DT)'
              'Daemon-Tools Lite (SCSI)')
          end
          object Edit18: TEdit
            Left = 10
            Top = 612
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 16
            Text = 'Edit18'
          end
          object Button11: TButton
            Left = 353
            Top = 612
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 17
            OnClick = Button11Click
          end
          object GroupBox5: TGroupBox
            Left = 394
            Top = 20
            Width = 434
            Height = 183
            Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
            TabOrder = 19
            object Memo1: TMemo
              Left = 2
              Top = 49
              Width = 430
              Height = 132
              Align = alBottom
              MaxLength = 4000
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Button9: TButton
              Left = 236
              Top = 18
              Width = 93
              Height = 24
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100
              TabOrder = 1
              OnClick = Button9Click
            end
            object Button10: TButton
              Left = 335
              Top = 18
              Width = 92
              Height = 24
              Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
              TabOrder = 2
              OnClick = Button10Click
            end
          end
          object GroupBox6: TGroupBox
            Left = 394
            Top = 210
            Width = 434
            Height = 184
            Caption = ' '#1057#1082#1088#1080#1087#1090' '#1076#1086' '#1089#1090#1072#1088#1090#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' (.bat/.cmd) '
            TabOrder = 20
            object Memo2: TMemo
              Left = 2
              Top = 50
              Width = 430
              Height = 132
              Align = alBottom
              MaxLength = 4000
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Button12: TButton
              Left = 236
              Top = 18
              Width = 93
              Height = 24
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100
              TabOrder = 1
              OnClick = Button12Click
            end
            object Button13: TButton
              Left = 335
              Top = 18
              Width = 92
              Height = 24
              Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
              TabOrder = 2
              OnClick = Button13Click
            end
          end
          object GroupBox7: TGroupBox
            Left = 394
            Top = 402
            Width = 434
            Height = 184
            Caption = ' '#1057#1082#1088#1080#1087#1090' '#1089#1086#1093#1088#1072#1085#1077#1085#1080#1103'/'#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1085#1072#1089#1090#1088#1086#1077#1082' '
            TabOrder = 21
            object Memo3: TMemo
              Left = 2
              Top = 50
              Width = 430
              Height = 132
              Align = alBottom
              MaxLength = 4000
              ScrollBars = ssVertical
              TabOrder = 0
            end
            object Button14: TButton
              Left = 236
              Top = 18
              Width = 93
              Height = 24
              Caption = #1054#1095#1080#1089#1090#1080#1090#1100
              TabOrder = 1
              OnClick = Button14Click
            end
            object Button15: TButton
              Left = 335
              Top = 18
              Width = 92
              Height = 24
              Caption = #1048#1079' '#1092#1072#1081#1083#1072'...'
              TabOrder = 2
              OnClick = Button15Click
            end
            object Button16: TButton
              Left = 10
              Top = 18
              Width = 92
              Height = 24
              Caption = #1054#1073#1088#1072#1079#1077#1094'...'
              TabOrder = 3
              OnClick = Button16Click
            end
          end
          object ComboBoxGroup: TComboBoxEx
            Left = 10
            Top = 663
            Width = 343
            Height = 25
            AutoCompleteOptions = [acoAutoAppend, acoUpDownKeyDropsList]
            ItemsEx = <>
            ItemHeight = 16
            MaxLength = 250
            TabOrder = 18
            DropDownCount = 12
          end
          object GroupBox8: TGroupBox
            Left = 394
            Top = 643
            Width = 434
            Height = 55
            TabOrder = 24
            object Button18: TButton
              Left = 13
              Top = 18
              Width = 200
              Height = 25
              Caption = #1069#1082#1089#1087#1086#1088#1090' '#1103#1088#1083#1099#1082#1072' '#1074' '#1092#1072#1081#1083'...'
              TabOrder = 0
              OnClick = Button18Click
            end
            object Button19: TButton
              Left = 221
              Top = 18
              Width = 200
              Height = 25
              Caption = #1048#1084#1087#1086#1088#1090' '#1103#1088#1083#1099#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072'...'
              TabOrder = 1
              OnClick = Button19Click
            end
          end
          object Edit19: TEdit
            Left = 394
            Top = 612
            Width = 343
            Height = 24
            MaxLength = 250
            TabOrder = 22
            Text = 'Edit19'
          end
          object Button20: TButton
            Left = 737
            Top = 612
            Width = 26
            Height = 26
            Caption = '...'
            TabOrder = 23
            OnClick = Button20Click
          end
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 370
    Height = 773
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object CoolBar1: TCoolBar
      Left = 0
      Top = 0
      Width = 370
      Height = 38
      AutoSize = True
      BandBorderStyle = bsNone
      BandMaximize = bmNone
      Bands = <
        item
          Control = ToolBar1
          ImageIndex = -1
          MinHeight = 38
          Width = 370
        end>
      EdgeBorders = []
      FixedOrder = True
      ShowText = False
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 366
        Height = 38
        AutoSize = True
        ButtonHeight = 38
        ButtonWidth = 39
        EdgeBorders = []
        Flat = True
        Images = ImageList1
        Indent = 2
        TabOrder = 0
        Transparent = True
        Wrapable = False
        object ButtonAddSheet: TToolButton
          Left = 2
          Top = 0
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1079#1072#1082#1083#1072#1076#1082#1091
          ImageIndex = 0
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonAddSheetClick
        end
        object ButtonAddShortcut: TToolButton
          Left = 41
          Top = 0
          Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1081' '#1103#1088#1083#1099#1082
          ImageIndex = 1
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonAddShortcutClick
        end
        object ButtonAddShortcutsFromFolder: TToolButton
          Left = 80
          Top = 0
          Hint = 
            #1044#1086#1073#1072#1074#1080#1090#1100' '#1075#1088#1091#1087#1087#1091' '#1103#1088#1083#1099#1082#1086#1074' '#1087#1091#1090#1077#1084' '#1080#1084#1087#1086#1088#1090#1072' '#1080#1079' '#1087#1072#1087#1082#1080' '#1089' .LNK, .URL '#1080' '#1087#1088 +
            '. '#1092#1072#1081#1083#1072#1084#1080
          ImageIndex = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonAddShortcutsFromFolderClick
        end
        object ButtonSep1: TToolButton
          Left = 119
          Top = 0
          Width = 8
          Caption = 'ButtonSep1'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object ButtonMoveUp: TToolButton
          Left = 127
          Top = 0
          Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1074#1077#1088#1093
          ImageIndex = 3
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonMoveUpClick
        end
        object ButtonMoveDown: TToolButton
          Left = 166
          Top = 0
          Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1085#1080#1079
          ImageIndex = 4
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonMoveDownClick
        end
        object ButtonSort: TToolButton
          Left = 205
          Top = 0
          Hint = #1054#1090#1089#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1086' '#1072#1083#1092#1072#1074#1080#1090#1091
          ImageIndex = 5
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonSortClick
        end
        object ButtonSep2: TToolButton
          Left = 244
          Top = 0
          Width = 8
          Caption = 'ButtonSep2'
          ImageIndex = 4
          Style = tbsSeparator
        end
        object ButtonDel: TToolButton
          Left = 252
          Top = 0
          Hint = #1059#1076#1072#1083#1080#1090#1100
          ImageIndex = 6
          ParentShowHint = False
          ShowHint = True
          OnClick = ButtonDelClick
        end
      end
    end
    object TreeView: TTreeView
      Left = 0
      Top = 38
      Width = 370
      Height = 735
      Align = alClient
      Ctl3D = True
      HideSelection = False
      Images = ImageListIcons
      Indent = 19
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 1
      OnChange = TreeViewChange
      OnChanging = TreeViewChanging
      OnEditing = TreeViewEditing
      OnKeyDown = TreeViewKeyDown
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 133
    Top = 51
  end
  object ImageList1: TImageList
    Height = 32
    Width = 32
    Left = 88
    Top = 48
    Bitmap = {
      494C010107000900040020002000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      00000000000036000000280000008000000060000000010020000000000000C0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D4860B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000B60D400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D0CAE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002323AF004545B10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4860B00E6AA3400D783000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000B60D4003476E600005CD7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D0CAE000C0BBB000808B1000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001716B1001E1DBD000504B2004545B100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D08C2200E6AA4000FFF2C300F0C15A00D4860B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000515151005858
      5800515151000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005151510058585800515151000000
      0000000000000000000000000000226CD0004081E600C3D2FF005A8EF0000B60
      D400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000D0CAE00100FC0004C4BD7006767DB001E1D
      B800000000000000000000000000000000000000000000000000000000000000
      0000000000001D1CB3005C5CD2006968DC003433CD000605B2004545B1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D08C2200E6A94200FFEFC200FFF1C900FFEFC300EBB14500D28916000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005D5D5D006B6B
      6B00676767005151510000000000000000000000000000000000000000000000
      000000000000000000000000000051515100676767006B6B6B005D5D5D000000
      00000000000000000000226CD0004285E600C2D4FF00C9D9FF00C3D5FF004585
      EB001665D2000000000000000000000000000000000000000000000000000000
      000000000000000000000D0CAE001211C1004D4DD9005E5DDE004140D9006160
      D8001D1CB3000000000000000000000000000000000000000000000000000000
      00001D1CB3006060D7003B3AD600302FD3006A69DE001A19BC002323AF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CE8F
      2D00E4A43C00FFE5A900FFE7AC00FFE8AE00FFE7AD00FFE6AA00E6A63C00D08C
      2200000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005E5E5E007272
      7200727272006060600000000000000000000000000000000000000000000000
      00000000000000000000000000006060600072727200727272005E5E5E000000
      0000000000002D72CE003C82E400A9C6FF00ACC7FF00AEC8FF00ADC8FF00AAC6
      FF003C82E600226CD00000000000000000000000000000000000000000000000
      0000000000000D0CAE000F0EBF005958DD005F5EE0002625D6002322D7004040
      DE006362DA001D1CB30000000000000000000000000000000000000000002322
      B8006262DA003F3EDC002120D5004B4BDC005858D2001111AF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CA964400E29A
      2500FDCF7400FFD78300FFDB8C00FFDC8E00FFDC8D00FFD78100FFD37900E094
      1A00CA9644000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000555555006E6E
      6E00757575006A6A6A0000000000000000000000000000000000000000000000
      00000000000000000000000000006A6A6A00757575006E6E6E00555555000000
      0000447DCA002573E20074A7FD0083AFFF008CB4FF008EB5FF008DB4FF0081AD
      FF0079AAFF001A6DE000447DCA00000000000000000000000000000000000000
      000000000000000000000E0DB3006564DD004544DE002524DA002726DC002827
      DD004544E3006564DC001D1CB3000000000000000000000000002424BA006868
      E1004443E2002726DC004140DF006261D9001D1CB30000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D4860B00D783
      0000D7830000D98B1100FFDE9D00FFCE6A00FFDFA000D8870900D7830000D783
      0000D4860B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006767
      670075757500757575006A6A6A00636363006060600060606000606060006060
      600060606000636363006A6A6A00757575007575750067676700000000000000
      00000B60D400005CD700005CD7001165D9009DC1FF006AA0FF00A0C3FF000961
      D800005CD700005CD7000B60D400000000000000000000000000000000000000
      00000000000000000000000000001313B5006363DB004E4DE4002B2AE1002C2B
      E2002D2CE4005756EA005A59D4002827B100000000002424BA006D6CE6003B3A
      E6002C2BE2004645E4006463DC001D1CB3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD68A00FFBB3A00FFD68A00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005E5E
      5E00727272007B7B7B0077777700727272006E6E6E006B6B6B006A6A6A006B6B
      6B006E6E6E0072727200777777007B7B7B00727272005E5E5E00000000000000
      0000000000000000000000000000005CD7008AB7FF003A85FF008AB7FF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001D1CB3006060DC005C5BEB00302F
      E7003130E9003231EA005F5EEF005655D4003D3CC4006F6FEA003F3EEB003130
      E9004241E900706FE5001817B500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD18200FFB32C00FFD28200D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005555
      55006E6E6E007C7C7C007C7C7C00757575006A6A6A0063636300606060006363
      63006A6A6A00757575007C7C7C007C7C7C006E6E6E0055555500000000000000
      0000000000000000000000000000005CD70082B4FF002C7FFF0082B3FF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001111AF005D5CDD00605F
      F0003A39EE003635EF003736F0006362F400706FF5004443F1003635EF004241
      EF00706FEA002524BA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFCD7A00FFAB1F00FFCD7B00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006767670078787800797979006D6D6D000000000000000000000000000000
      0000000000006D6D6D0079797900787878006767670000000000000000000000
      0000000000000000000000000000005CD7007AB1FF001F7BFF007BB2FF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001111AF005656
      D5007170F6003F3EF5003B3AF5003B3AF6003B3AF6003B3AF5004746F5007372
      EE002524BB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC97300FFA41300FFC97400D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005E5E5E0073737300787878006A6A6A000000000000000000000000000000
      0000000000006A6A6A0078787800737373005E5E5E0000000000000000000000
      0000000000000000000000000000005CD70073AEFF001376FF0074AFFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002323
      AF004746D1007574FB003F3EFB00403FFB00403FFB004342FB007272F8003837
      C300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC56C00FF9D0700FFC56D00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000555555006E6E6E00787878006E6E6E005555550000000000000000000000
      0000555555006E6E6E00787878006E6E6E005555550000000000000000000000
      0000000000000000000000000000005CD7006CABFF000772FF006DACFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002827
      B1005B5AD8007A7AFE00504FFE005251FE005251FE005756FE008282FA002928
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006767670077777700737373005E5E5E0000000000000000000000
      00005E5E5E007373730077777700676767000000000000000000000000000000
      0000000000000000000000000000005CD70069AAFF00006FFF0069AAFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001111AF005E5E
      D8008080FE006564FE006B6AFE006F6EFE007170FE006B6AFE006F6EFE008787
      F4002626BB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005E5E5E0073737300777777006767670000000000000000000000
      00006767670077777700737373005E5E5E000000000000000000000000000000
      0000000000000000000000000000005CD70069AAFF00006FFF0069AAFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D1CB3007A7AE8008A8A
      FE007675FE00807FFE008786FE00A3A2FE00B0B0FE008E8DFE007F7EFE007E7E
      FE008E8EF4002726BB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000555555006E6E6E00787878006E6E6E005C5C5C00000000005C5C
      5C006E6E6E00787878006E6E6E00555555000000000000000000000000000000
      0000000000000000000000000000005CD70069AAFF00006FFF0069AAFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001D1CB3007B7BE8008989FE008080
      FE008F8EFE009A9AFE00B6B5FE007070D8003534C000ABABF400A1A1FE008E8D
      FE008888FE008E8DF1002322B800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC66D00FF9D0700FFC56D00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063636300757575007272720068686800000000006868
      6800737373007777770067676700000000000000000000000000000000000000
      0000000000000000000000000000005CD7006DABFF000772FF006DACFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001514B6007A7AE8008483FE008484FE009797
      FE00A7A7FE00C2C2FF007B7BDA002827B100000000002A29BB00B7B6F500B1B0
      FE009695FE008B8BFE008585EA002E2DB8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFCB7700FFA61700FFCB7700D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000575757006F6F6F007575750071717100000000007171
      710077777700737373005E5E5E00000000000000000000000000000000000000
      0000000000000000000000000000005CD70077AFFF001778FF0077AFFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000F0EB4008585F4008181FE008180FE009797FE00ACAB
      FE00C6C5FF00A5A5E9001D1CB3000000000000000000000000001F1EB800AEAE
      F000B4B4FE009695FE009190FE008585EA002E2DB80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD08000FFAF2700FFD08000D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000676767007575750078787800757575007878
      7800787878006E6E6E0055555500000000000000000000000000000000000000
      0000000000000000000000000000005CD70080B3FF00277EFF0080B3FF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000D0CAE002524D5008786FE009E9DFE009292FE00A8A8FE00C6C6
      FF00A8A7E9001D1CB30000000000000000000000000000000000000000001211
      B3009F9EE900B3B2FE008E8EFE008887FE007979E4001D1CB300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD68900FFB93700FFD58900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000005E5E5E00727272007C7C7C007C7C7C007C7C
      7C00757575006363630000000000000000000000000000000000000000000000
      0000000000000000000000000000005CD70089B6FF003784FF0089B7FF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      000000000000000000000D0CAE004645E000A5A4FE00B2B2FE00BDBDFF00ABAB
      EB001D1CB3000000000000000000000000000000000000000000000000000000
      00001D1CB3009B9BE900AFAEFE009393FE009796FE002828CD002323AF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFDB9300FFC24700FFDB9300D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000515151006767670072727200757575007272
      7200686868005454540000000000000000000000000000000000000000000000
      0000000000000000000000000000005CD70093BBFF00478BFF0093BBFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000D0CAE005A5AE000BEBDFE00BDBDF5002B2A
      BB00000000000000000000000000000000000000000000000000000000000000
      0000000000001716B1007C7CDE00AEADFE006F6EF9001110BD004545B1000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFDF9800FFE19C00FFE19C00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000515151005C5C5C00606060005C5C
      5C00515151000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000005CD70098BBFF009CBDFF009CBDFF00005C
      D700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000D0CAE005857D6001A19B6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000001111AF003837CD001716BD004545B100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D4860B00D7830000D7830000D7830000D4860B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000B60D400005CD700005CD700005CD7000B60
      D400000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D0CAE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000002323AF004545B10000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000D9D
      0D0013A013001DA41D0019A3190019A3190019A319001DA41D0013A013000D9D
      0D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000013A0130028A9280028A9280028A9280028A9280028A9
      280013A013000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000013A0130028A9280028A9280028A9280028A9280028A9
      280013A013000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D4860B00D7830000D7830000D7830000D4860B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      000089F4AD00A3F6BF0099F5B80099F4B70099F5B800A3F6BF0089F4AD000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210062D7890079E49D006BE5930079E49D0062D7
      890021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210062D7890079E49D006BE5930079E49D0062D7
      890021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFDF9800FFE19C00FFE19C00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      000084EFA70071EB9A004DE680004DE680004DE6800071EB9A0083EEA7000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A621005CD684004DE6800045DE78004DE680005CD6
      840021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A621005CD684004DE6800045DE78004DE680005CD6
      840021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFDB9300FFC24700FFDB9300D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      00007EE9A2006BE5930045DE780045DE780045DE78006BE593007EE9A2000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000028A9280051D37C004FD37B003ED771004FD37B0051D3
      7C0028A928000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000028A9280051D37C004FD37B003ED771004FD37B0051D3
      7C0028A928000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD68900FFB93700FFD58900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      000079E49D0065DF8E003ED771003ED771003ED7710065DF8E0079E49C000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A621004DD2790047D1750035CC670047D175004DD2
      790021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A621004DD2790047D1750035CC670047D175004DD2
      790021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD08000FFAF2700FFD08000D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      000074DF98005FDA880037D06A0037D06A0037D06A005FDA880074DF98000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000019A3190021A6210028A9
      280028A9280028A9280021A6210047D1750042D0710033CC660042D0710047D1
      750021A6210028A9280028A9280028A9280021A6210013A01300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000019A3190021A6210028A9
      280028A9280028A9280021A6210047D1750042D0710033CC660042D0710047D1
      750021A6210028A9280028A9280028A9280021A6210013A01300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFCB7700FFA61700FFCB7700D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      000070DB94005CD6840033CC660033CC660033CC66005CD6840070DB94000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A928004DD2790045D0
      730045D0730045D0730045D073004DD279003DCE6D0035CC67003DCE6D004DD2
      790045D0730045D0730045D0730045D073004DD2790028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A928004DD2790045D0
      730045D0730045D0730045D073004DD279003DCE6D0035CC67003DCE6D004DD2
      790045D0730045D0730045D0730045D073004DD2790028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC66D00FF9D0700FFC56D00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D9D0D00009900000099000000990000009900000099000000990000039C
      060070DB93005CD6840033CC660033CC660033CC66005CD6840070DB9300039C
      06000099000000990000009900000099000000990000009900000D9D0D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A928005FD7870042D0
      710047D1750051D37C0054D47F0051D37C004FD37B004FD37B0051D37C0054D4
      7F0054D47F0051D37C004BD2780042D0710062D7890028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A928005FD7870042D0
      710047D1750051D37C0054D47F0051D37C004FD37B004FD37B0051D37C0054D4
      7F0054D47F0051D37C004BD2780042D0710062D7890028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000013A0130074E0980072DD960070DB940070DB930070DB930070DB930070DB
      93006EDA920047D1750033CC660033CC660033CC660047D175006EDA920070DB
      930070DB930070DB930070DB930070DB940071DC950074DF970013A013000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280063D98A0051D3
      7C005CD684005FD7870063D98B0065DB8C0067DD8E0068DE8F0067DD8E0066DC
      8E0065DB8C0062D889005CD6840054D47F006BDA900028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280063D98A0051D3
      7C005CD684005FD7870063D98B0065DB8C0067DD8E0068DE8F0067DD8E0066DC
      8E0065DB8C0062D889005CD6840054D47F006BDA900028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001DA41D0091E4AD0047D1750047D1750047D1750047D1750047D1750047D1
      750045D073003BCE6C003DCE6D0042D0710042D071003DCE6D0045D073004DD2
      790047D1750047D1750047D1750047D1750047D1750091E3AC001DA41D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280085E0A30079E4
      9C0079E49D0079E49D0081E9A40079E49D0076E59B0079E49C0076E59B0079E4
      9D0081E9A4007EE9A20079E49D0079E49C0088E1A50028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280085E0A30079E4
      9C0079E49D0079E49D0081E9A40079E49D0076E59B0079E49C0076E59B0079E4
      9D0081E9A4007EE9A20079E49D0079E49C0088E1A50028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC36900FF990000FFC36900D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000019A3190085E0A30033CC660035CC67003FCF6F004BD2780054D47F0059D6
      83005AD884005BD985005CD986005CD986005CD986005BD985005BD884005AD7
      830058D682004FD37B0044D0730038CD690033CC660085E0A30019A319000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280062D789006EDA
      92006EDA920070DB930070DB93008DEAAC008DEAAC0083EEA7008DEAAC008DEA
      AC0070DB930070DB93006EDA92006EDA92006BDA900028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000028A9280062D789006EDA
      92006EDA920070DB930070DB93008DEAAC008DEAAC0083EEA7008DEAAC008DEA
      AC0070DB930070DB93006EDA92006EDA92006BDA900028A92800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC56C00FF9D0700FFC56D00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000019A3190088E1A50051D37C005FD7870062D7890063D98A0065DB8C0066DC
      8E0068DE8F0069DF900069DF900069DF910069DF910069DF900068DE8F0067DD
      8E0065DB8D0063D98B0062D8890061D7890051D37C0088E1A50019A319000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000019A3190021A6210021A6
      210021A6210028A9280021A6210085E0A300A2F3BD0098F2B600A2F3BD0085E0
      A30021A6210028A9280021A6210021A6210021A6210019A31900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000019A3190021A6210021A6
      210021A6210028A9280021A6210085E0A300A2F3BD0098F2B600A2F3BD0085E0
      A30021A6210028A9280021A6210021A6210021A6210019A31900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFC97300FFA41300FFC97400D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000019A31900A6E8BC006BDA90006BDA91006DDC920070DE950071E0960073E2
      980074E3990075E49A0076E59B0076E59B0076E59B0075E49A0075E3990073E2
      980072E1970070DF95006EDD93006CDB91006BDA9000A6E8BC0021A621000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210085E0A300ADF8C600A3F6BF00ADF8C60085E0
      A30021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210085E0A300ADF8C600A3F6BF00ADF8C60085E0
      A30021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFCD7A00FFAB1F00FFCD7B00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001DA41D00B4EBC60090E3AC0092E5AE0094E7AF0095E9B10097EAB20098EB
      B4008DEAAC0081E9A40082E9A40082EAA50082EAA40082E9A4008DEAAC0098EC
      B40097EAB30096E9B20094E7B00092E6AE0090E4AC00B4EBC60028A928000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210088E1A500BCF9D000B3F8CA00BCF9D00088E1
      A50021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210088E1A500BCF9D000B3F8CA00BCF9D00088E1
      A50021A6210018799C0018799C0018799C0018799C0018799C0018799C001879
      9C0018799C0018799C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD18200FFB32C00FFD28200D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000013A0130092E4AD0094E6AF0096E8B10098EAB3009AEBB5009BEDB6009CEE
      B800A9F1C10098EFB5008DEEAE008EEEAE008DEEAE0098EFB500A9F1C1009DEF
      B8009BEDB7009AECB50098EAB40096E8B20094E6B00092E4AD001DA41D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210091E3AC00C8FCD900C0FBD400C8FCD90091E3
      AC0021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210091E3AC00C8FCD900C0FBD400C8FCD90091E3
      AC0021A62100188EB500188EB500188EB500188EB500188EB500188EB500188E
      B500188EB500188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D7830000FFD68A00FFBB3A00FFD68A00D7830000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000D9D0D00009900000099000000990000009900000099000000990000049D
      0700A3F2BD00ACF4C40098F2B60098F2B60098F2B600ACF4C400A3F2BE00049D
      07000099000000990000009900000099000000990000009900000D9D0D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210088E1A500C8F8D800C2F7D400C8F8D80088E1
      A50021A621000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000021A6210088E1A500C8F8D800C2F7D400C8F8D80088E1
      A50021A621006BD7FF006BD7FF006BD7FF006BD7FF006BD7FF006BD7FF0039B2
      DE009CF3FF00188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D4860B00D783
      0000D7830000D98B1100FFDE9D00FFCE6A00FFDFA000D8870900D7830000D783
      0000D4860B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000A9F4C200B4F6CA00A2F5BE00A3F5BE00A2F5BE00B4F6CA00A9F4C2000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000019A3190028A9280028A9280028A9280028A9280028A9
      280019A319000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000019A3190028A9280028A9280028A9280028A9280028A9
      280019A319007BE3FF007BE3FF007BE3FF007BE3FF007BE3FF007BDFFF0042B2
      DE009CFFFF00188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CA964400E29A
      2500FDCF7400FFD78300FFDB8C00FFDC8E00FFDC8D00FFD78100FFD37900E094
      1A00CA9644000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000AEF6C600BCF9D000ACF8C500ADF8C600ACF8C500BCF9D100AEF6C6000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD0063CBFF00188EB5009CFFFF0084E7
      FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084E7FF0084EBFF004AB6
      DE00A5F7FF00188EB50018799C00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CE8F
      2D00E4A43C00FFE5A900FFE7AC00FFE8AE00FFE7AD00FFE6AA00E6A63C00D08C
      2200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000B3F8CA00C4FAD600B6FACC00B6FACD00B6FACC00C4FAD600B3F8CA000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD0063CBFF00188EB5009CFFFF0094FB
      FF0094FBFF0094FBFF0094FBFF0094FBFF0094FBFF0094FBFF008CF3FF0052BE
      E7009CFFFF00188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000D08C2200E6A94200FFEFC200FFF1C900FFEFC300EBB14500D28916000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000B8F9CE00CBFCDB00BFFCD300BFFCD300BFFCD300CBFCDB00B8FACE000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD006BD3FF00188EB5009CFFFF009CFF
      FF009CFFFF009CFFFF00A5F7FF009CFFFF009CFFFF009CFFFF009CFFFF0063CB
      FF009CFFFF00188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D08C2200E6AA4000FFF2C300F0C15A00D4860B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000BCFBD100D5FDE200CCFDDC00CCFDDD00CCFDDC00D5FDE200BCFBD1000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD007BDFFF00188EB500FFFFFF00F7FB
      FF00F7FBFF00F7FBFF00F7FBFF00F7FBFF00FFFFFF00FFFFFF00FFFFFF0084D7
      F700F7FBFF00188EB50018799C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000D4860B00E6AA3400D783000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000099
      0000C0FBD400E4FEED00E2FEEB00E2FFEC00E2FEEB00E4FEED00C0FCD4000099
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD0084EBFF0084E7FF00188EB500188E
      B500188EB500188EB500188EB500188EB500188EB500188EB500188EB500188E
      B500188EB500188EB50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D4860B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000D9D
      0D00009900000099000000990000009900000099000000990000009900000D9D
      0D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD009CF3FF008CF7FF008CF7FF008CF7
      FF008CF7FF008CF3FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00107D
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000319EBD00FFFFFF009CFFFF009CFFFF009CFF
      FF009CFFFF00FFFFFF00188EB500188EB500188EB500188EB500188EB500107D
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000319EBD00FFFFFF00FFFFFF00FFFF
      FF00F7FBFF00319EBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000319EBD00319EBD00319E
      BD00319EBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000600000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000
      FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000
      FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000
      FFFEFFFFFFFFFFBFFFBFFE7F00000000FFFC7FFFFFFFFF1FFF1FFC3F00000000
      FFF83FFFC7FF1E0FFE0FF81F00000000FFF01FFFC3FE1C07FC07F01F00000000
      FFE00FFFC3FE1803F803E03F00000000FFC007FFC3FE1001FC01C07F00000000
      FFC007FFE0003001FE0080FF00000000FFF83FFFE0003E0FFF0001FF00000000
      FFF83FFFE0003E0FFF8003FF00000000FFF83FFFF0F87E0FFFC007FF00000000
      FFF83FFFF0F87E0FFFE00FFF00000000FFF83FFFF0707E0FFFE00FFF00000000
      FFF83FFFF870FE0FFFC007FF00000000FFF83FFFF870FE0FFF8003FF00000000
      FFF83FFFF820FE0FFF0001FF00000000FFF83FFFFC21FE0FFE0080FF00000000
      FFF83FFFFC21FE0FFC01C07F00000000FFF83FFFFE01FE0FF803E03F00000000
      FFF83FFFFE03FE0FFC07F01F00000000FFF83FFFFE03FE0FFE0FF81F00000000
      FFF83FFFFF07FE0FFF1FFC3F00000000FFF83FFFFFFFFE0FFFBFFE7F00000000
      FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000
      FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF00000000
      FFFFFFFFFFFFFFFFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFE00FFFFFFC07FFFFFC07FFFFF83FFFFFE00FFFFFFC07FFFFFC07FFFFF83FFF
      FFE00FFFFFFC07FFFFFC07FFFFF83FFFFFE00FFFFFFC07FFFFFC07FFFFF83FFF
      FFE00FFFFFFC07FFFFFC07FFFFF83FFFFFE00FFFFF80003FFF80003FFFF83FFF
      FFE00FFFFF80003FFF80003FFFF83FFFF000001FFF80003FFF80003FFFF83FFF
      F000001FEA80003FEA80003FFFF83FFFF000001FFF80003FFF80003FFFF83FFF
      F000001FEF80003FEF80003FFFF83FFFF000001FFF80003FFF80003FFFF83FFF
      F000001FEFFC07FFEFFC07FFFFF83FFFF000001FFFFC07FFFFFC0003FFF83FFF
      F000001FEFFC07FFEFFC0001FFF83FFFF000001FFFFC07FFFFFC0001FFC007FF
      FFE00FFFEFFC07FFEFFC0001FFC007FFFFE00FFFFFFFFFFFFFFE0001FFE00FFF
      FFE00FFFEFFFFFFFEFFE0001FFF01FFFFFE00FFFFFFFFFFFFFFE0001FFF83FFF
      FFE00FFFEFFFFFFFEFFE0001FFFC7FFFFFE00FFFFFFFFFFFFFFE0003FFFEFFFF
      FFE00FFFEFFFFFFFEFFE000FFFFFFFFFFFFFFFFFFFFFFFFFFFFE000FFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF87FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageListIcons: TImageList
    Left = 88
    Top = 88
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Shortcuts|*.shortcut'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 152
    Top = 104
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Shortcuts|*.shortcut'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 184
    Top = 104
  end
end
