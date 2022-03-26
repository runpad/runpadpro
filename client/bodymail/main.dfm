object BodyMailForm: TBodyMailForm
  Left = 279
  Top = 107
  Width = 632
  Height = 497
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
  OnConstrainedResize = FormConstrainedResize
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 451
    Width = 624
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 624
    Height = 46
    AutoSize = True
    BandMaximize = bmNone
    Bands = <
      item
        BorderStyle = bsSingle
        Break = False
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 38
        Width = 620
      end>
    ShowText = False
    object ToolBar1: TToolBar
      Left = 9
      Top = 2
      Width = 607
      Height = 38
      ButtonWidth = 50
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Images = ImageList
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      Wrapable = False
      object ButtonSend: TToolButton
        Left = 0
        Top = 0
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonSendClick
      end
      object ToolButton2: TToolButton
        Left = 50
        Top = 0
        Width = 20
        Caption = 'ToolButton2'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object ButtonImp: TToolButton
        Left = 70
        Top = 0
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonImpClick
      end
      object ButtonAtt: TToolButton
        Left = 120
        Top = 0
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonAttClick
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 46
    Width = 624
    Height = 405
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PanelImp: TPanel
      Left = 0
      Top = 0
      Width = 624
      Height = 22
      Align = alTop
      Alignment = taLeftJustify
      BevelOuter = bvNone
      BorderWidth = 10
      BorderStyle = bsSingle
      Color = clCream
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
    object PanelHeaders: TPanel
      Left = 0
      Top = 22
      Width = 624
      Height = 116
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object PanelNames: TPanel
        Left = 0
        Top = 0
        Width = 113
        Height = 116
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 10
          Top = 13
          Width = 49
          Height = 13
          Caption = 'your name'
        end
        object Label2: TLabel
          Left = 10
          Top = 39
          Width = 53
          Height = 13
          Caption = 'your e-mail:'
        end
        object Label3: TLabel
          Left = 10
          Top = 65
          Width = 48
          Height = 13
          Caption = 'recipients:'
        end
        object Label4: TLabel
          Left = 10
          Top = 91
          Width = 22
          Height = 13
          Caption = 'subj:'
        end
      end
      object PanelFields: TPanel
        Left = 113
        Top = 0
        Width = 511
        Height = 116
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object EditFromName: TEdit
          Left = 8
          Top = 8
          Width = 353
          Height = 21
          MaxLength = 250
          TabOrder = 0
        end
        object EditFromAddress: TEdit
          Left = 8
          Top = 34
          Width = 353
          Height = 21
          MaxLength = 250
          TabOrder = 1
        end
        object EditTo: TEdit
          Left = 8
          Top = 60
          Width = 353
          Height = 21
          MaxLength = 250
          TabOrder = 2
        end
        object EditSubject: TEdit
          Left = 8
          Top = 86
          Width = 353
          Height = 21
          MaxLength = 250
          TabOrder = 3
          OnChange = EditSubjectChange
        end
      end
    end
    object PanelAtt: TPanel
      Left = 0
      Top = 138
      Width = 624
      Height = 40
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      Visible = False
    end
    object PanelText: TPanel
      Left = 0
      Top = 178
      Width = 624
      Height = 227
      Align = alClient
      BevelOuter = bvNone
      BorderWidth = 5
      BorderStyle = bsSingle
      Color = clWindow
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      object Memo: TMemo
        Left = 5
        Top = 5
        Width = 610
        Height = 213
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object ImageList: TImageList
    Left = 513
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 473
    Top = 10
    object MenuDel: TMenuItem
      Caption = '_Remove_'
      OnClick = MenuDelClick
    end
  end
  object Encoder64: TIdEncoderMIME
    FillChar = '='
    Left = 441
    Top = 10
  end
  object IdSMTP: TIdSMTP
    MaxLineAction = maSplit
    ReadTimeout = 0
    OnWork = IdSMTPWork
    Port = 25
    AuthenticationType = atNone
    Left = 409
    Top = 10
  end
end
