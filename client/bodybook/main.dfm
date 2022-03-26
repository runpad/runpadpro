object BodyBookForm: TBodyBookForm
  Left = 294
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 322
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 139
    Width = 388
    Height = 5
    Align = alTop
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 0
    Top = 249
    Width = 388
    Height = 5
    Align = alBottom
    Shape = bsBottomLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 139
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelKind: TLabel
      Left = 8
      Top = 15
      Width = 47
      Height = 13
      Caption = 'LabelKind'
    end
    object LabelTitle: TLabel
      Left = 8
      Top = 47
      Width = 46
      Height = 13
      Caption = 'LabelTitle'
    end
    object LabelName: TLabel
      Left = 8
      Top = 79
      Width = 54
      Height = 13
      Caption = 'LabelName'
    end
    object LabelAge: TLabel
      Left = 8
      Top = 111
      Width = 45
      Height = 13
      Caption = 'LabelAge'
    end
    object ComboBoxKind: TComboBox
      Left = 120
      Top = 11
      Width = 257
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object EditTitle: TEdit
      Left = 120
      Top = 43
      Width = 257
      Height = 21
      MaxLength = 250
      TabOrder = 1
      Text = 'EditTitle'
    end
    object EditName: TEdit
      Left = 120
      Top = 75
      Width = 137
      Height = 21
      MaxLength = 250
      TabOrder = 2
      Text = 'EditName'
    end
    object ComboBoxAge: TComboBox
      Left = 120
      Top = 107
      Width = 137
      Height = 21
      Style = csDropDownList
      DropDownCount = 20
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 254
    Width = 388
    Height = 68
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Image1: TImage
      Left = 8
      Top = 11
      Width = 48
      Height = 48
    end
    object ButtonSend: TButton
      Left = 184
      Top = 20
      Width = 89
      Height = 30
      Caption = 'ButtonSend'
      Default = True
      TabOrder = 0
      OnClick = ButtonSendClick
    end
    object ButtonCancel: TButton
      Left = 288
      Top = 20
      Width = 89
      Height = 30
      Caption = 'ButtonCancel'
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 144
    Width = 388
    Height = 105
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Memo: TMemo
      Left = 0
      Top = 0
      Width = 388
      Height = 105
      Align = alClient
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object XPManifest1: TXPManifest
    Left = 88
    Top = 278
  end
end
