object BodyNotepadForm: TBodyNotepadForm
  Left = 232
  Top = 119
  Width = 792
  Height = 561
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = #1041#1083#1086#1082#1085#1086#1090' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  Color = clBtnFace
  Constraints.MinHeight = 120
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 0
    Top = 48
    Width = 784
    Height = 486
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnChange = MemoChange
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 784
    Height = 48
    AutoSize = True
    Bands = <
      item
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 44
        Width = 780
      end>
    object ToolBar: TToolBar
      Left = 9
      Top = 0
      Width = 767
      Height = 44
      ButtonHeight = 44
      ButtonWidth = 81
      Caption = 'ToolBar'
      Customizable = True
      EdgeBorders = []
      Flat = True
      Images = ToolbarImages
      ShowCaptions = True
      TabOrder = 0
      Transparent = True
      Wrapable = False
      object CreateDocButton: TToolButton
        Left = 0
        Top = 0
        Hint = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
        Caption = #1057#1086#1079#1076#1072#1090#1100
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = CreateDocButtonClick
      end
      object OpenDocButton: TToolButton
        Left = 81
        Top = 0
        Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = OpenDocButtonClick
      end
      object SaveDocButton: TToolButton
        Left = 162
        Top = 0
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = SaveDocButtonClick
      end
      object SaveAsDocButton: TToolButton
        Left = 243
        Top = 0
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1089' '#1085#1086#1074#1099#1084' '#1080#1084#1077#1085#1077#1084
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = SaveAsDocButtonClick
      end
      object CloseDocButton: TToolButton
        Left = 324
        Top = 0
        Hint = #1047#1072#1082#1088#1099#1090#1100' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = CloseDocButtonClick
      end
      object PrintDocButton: TToolButton
        Left = 405
        Top = 0
        Caption = #1055#1077#1095#1072#1090#1100
        ImageIndex = 6
        OnClick = PrintDocButtonClick
      end
      object ExitButton: TToolButton
        Left = 486
        Top = 0
        Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        Caption = #1042#1099#1093#1086#1076
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = ExitButtonClick
      end
    end
  end
  object ToolbarImages: TImageList
    Height = 24
    Width = 24
    Left = 8
    Top = 56
  end
end
