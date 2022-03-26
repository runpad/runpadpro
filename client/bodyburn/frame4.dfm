object Page4: TPage4
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Align = alClient
  AutoScroll = False
  TabOrder = 0
  object Bevel1: TBevel
    Left = 0
    Top = 211
    Width = 443
    Height = 3
    Align = alBottom
    Shape = bsBottomLine
  end
  object Panel1: TPanel
    Left = 0
    Top = 214
    Width = 443
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 15
    TabOrder = 0
    object LabelProgress: TLabel
      Left = 15
      Top = 15
      Width = 413
      Height = 17
      Align = alClient
      Caption = #1055#1088#1086#1075#1088#1077#1089#1089' '#1087#1088#1086#1094#1077#1089#1089#1072':'
    end
    object ProgressBar: TProgressBar
      Left = 15
      Top = 32
      Width = 413
      Height = 16
      Align = alBottom
      TabOrder = 0
    end
  end
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 443
    Height = 211
    Align = alClient
    Columns = <
      item
        MaxWidth = 30
        MinWidth = 30
        Width = 30
      end
      item
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        Width = 480
      end>
    ColumnClick = False
    ReadOnly = True
    SmallImages = ImageList
    TabOrder = 1
    TabStop = False
    ViewStyle = vsReport
  end
  object ImageList: TImageList
    Left = 24
    Top = 32
  end
end
