object BodyExplForm: TBodyExplForm
  Left = 195
  Top = 104
  Width = 785
  Height = 537
  Caption = #1055#1088#1086#1074#1086#1076#1085#1080#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  Color = clBtnFace
  Constraints.MinHeight = 130
  Constraints.MinWidth = 260
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 13
  object Splitter: TSplitter
    Left = 209
    Top = 70
    Width = 2
    Height = 416
    Visible = False
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 486
    Width = 777
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object ShellTreeView: TShellTreeView
    Left = 0
    Top = 70
    Width = 209
    Height = 416
    ObjectTypes = [otFolders]
    Root = 'rfStartMenu'
    ShowRoot = true
    UseShellImages = True
    Align = alLeft
    AutoRefresh = False
    Ctl3D = True
    Indent = 19
    ParentColor = False
    ParentCtl3D = False
    PopupMenu = PopupMenuTree
    RightClickSelect = True
    TabOrder = 1
    Visible = False
    OnClick = ShellTreeViewClick
    OnKeyDown = ShellTreeViewKeyDown
    OnEditing = ShellTreeViewEditing
  end
  object CoolBar: TCoolBar
    Left = 0
    Top = 0
    Width = 777
    Height = 70
    AutoSize = True
    Bands = <
      item
        BorderStyle = bsSingle
        Break = False
        Control = ToolBar
        ImageIndex = -1
        MinHeight = 38
        Width = 773
      end
      item
        Control = ComboBox
        ImageIndex = -1
        MinHeight = 22
        Width = 773
      end>
    object ComboBox: TComboBoxEx
      Left = 9
      Top = 44
      Width = 760
      Height = 22
      AutoCompleteOptions = []
      ItemsEx = <>
      Style = csExDropDownList
      ItemHeight = 16
      TabOrder = 1
      OnSelect = ComboBoxSelect
      Images = ImageList
      DropDownCount = 15
    end
    object ToolBar: TToolBar
      Left = 9
      Top = 2
      Width = 446
      Height = 38
      Align = alNone
      AutoSize = True
      ButtonHeight = 38
      ButtonWidth = 39
      EdgeBorders = []
      Flat = True
      Images = ImageListTB
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Transparent = True
      object BtnNew: TToolButton
        Left = 0
        Top = 0
        ImageIndex = 0
        OnClick = BtnNewClick
      end
      object TB1: TToolButton
        Left = 39
        Top = 0
        Width = 8
        ImageIndex = 3
        Style = tbsSeparator
      end
      object BtnUp: TToolButton
        Left = 47
        Top = 0
        ImageIndex = 1
        OnClick = BtnUpClick
      end
      object BtnRefresh: TToolButton
        Left = 86
        Top = 0
        ImageIndex = 2
        OnClick = BtnRefreshClick
      end
      object TB2: TToolButton
        Left = 125
        Top = 0
        Width = 8
        Caption = 'TB2'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object BtnView: TToolButton
        Left = 133
        Top = 0
        ImageIndex = 3
        OnClick = BtnViewClick
      end
      object ToolButton1: TToolButton
        Left = 172
        Top = 0
        Width = 16
        Caption = 'ToolButton1'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object BtnBurn: TToolButton
        Left = 188
        Top = 0
        ImageIndex = 4
        OnClick = BtnBurnClick
      end
      object ToolButton3: TToolButton
        Left = 227
        Top = 0
        Width = 8
        Caption = 'ToolButton3'
        ImageIndex = 5
        Style = tbsSeparator
      end
      object BtnBTOut: TToolButton
        Left = 235
        Top = 0
        ImageIndex = 5
        OnClick = BtnBTOutClick
      end
      object BtnBTIn: TToolButton
        Left = 274
        Top = 0
        ImageIndex = 6
        OnClick = BtnBTInClick
      end
      object BtnMobile: TToolButton
        Left = 313
        Top = 0
        ImageIndex = 7
        OnClick = BtnMobileClick
      end
      object ToolButton4: TToolButton
        Left = 352
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 8
        Style = tbsSeparator
      end
      object BtnCamera: TToolButton
        Left = 360
        Top = 0
        ImageIndex = 9
        OnClick = BtnCameraClick
      end
      object ToolButton2: TToolButton
        Left = 399
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 9
        Style = tbsSeparator
      end
      object BtnMail: TToolButton
        Left = 407
        Top = 0
        ImageIndex = 8
        OnClick = BtnMailClick
      end
    end
  end
  object Panel1: TPanel
    Left = 211
    Top = 70
    Width = 566
    Height = 416
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object CoolBar2: TCoolBar
      Left = 519
      Top = 0
      Width = 47
      Height = 416
      Align = alRight
      AutoSize = True
      Bands = <
        item
          Control = ToolBar2
          ImageIndex = -1
          MinHeight = 39
          Width = 408
        end>
      BorderWidth = 1
      Vertical = True
      object ToolBar2: TToolBar
        Left = 0
        Top = 9
        Width = 39
        Height = 38
        Align = alNone
        AutoSize = True
        ButtonHeight = 38
        ButtonWidth = 39
        Caption = 'ToolBar2'
        EdgeBorders = []
        Flat = True
        Images = ImageListTB
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Transparent = True
        object BtnSearch: TToolButton
          Left = 0
          Top = 0
          ImageIndex = 10
          ParentShowHint = False
          ShowHint = True
          OnClick = BtnSearchClick
        end
      end
    end
    object ShellListView: TShellListView
      Left = 0
      Top = 0
      Width = 519
      Height = 416
      AutoContextMenus = False
      AutoNavigate = False
      ObjectTypes = [otFolders, otNonFolders]
      Root = 'rfStartMenu'
      Sorted = True
      Align = alClient
      OnDblClick = ShellListViewDblClick
      ReadOnly = False
      HideSelection = False
      MultiSelect = True
      OnChange = ShellListViewChange
      OnColumnClick = ShellListViewColumnClick
      OnContextPopup = ShellListViewContextPopup
      OnMouseDown = ShellListViewMouseDown
      OnMouseMove = ShellListViewMouseMove
      TabOrder = 1
      Visible = False
      ViewStyle = vsReport
      OnKeyDown = ShellListViewKeyDown
      OnEditing = ShellListViewEditing
    end
    object ListView: TListView
      Left = 0
      Top = 0
      Width = 519
      Height = 416
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = #1048#1084#1103
        end>
      ColumnClick = False
      IconOptions.AutoArrange = True
      LargeImages = ImageListBig
      ReadOnly = True
      SmallImages = ImageList
      TabOrder = 2
      ViewStyle = vsReport
      Visible = False
      OnContextPopup = ListViewContextPopup
      OnDblClick = ListViewDblClick
      OnEditing = ListViewEditing
      OnKeyDown = ListViewKeyDown
    end
  end
  object ShellPopupMenu: TPopupMenu
    Left = 712
    Top = 2
    object MenuOpen: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnClick = MenuOpenClick
    end
    object MenuOpenWith: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089' '#1087#1086#1084#1086#1097#1100#1102
    end
    object MenuWinampAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1087#1083#1077#1081#1083#1080#1089#1090' Winamp'
      OnClick = MenuWinampAddClick
    end
    object MenuPicture: TMenuItem
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      object MenuRotateCW: TMenuItem
        Caption = #1055#1086#1074#1086#1088#1086#1090' 90 '#1075#1088#1072#1076' CW'
        OnClick = MenuRotateCWClick
      end
      object MenuRotateCCW: TMenuItem
        Caption = #1055#1086#1074#1086#1088#1086#1090' 90 '#1075#1088#1072#1076' CCW'
        OnClick = MenuRotateCCWClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object MenuResizeSmall: TMenuItem
        Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1076#1086' 640'#1093'480'
        OnClick = MenuResizeSmallClick
      end
      object MenuResizeNormal: TMenuItem
        Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1076#1086' 800x600'
        OnClick = MenuResizeNormalClick
      end
      object MenuResizeBig: TMenuItem
        Caption = #1059#1084#1077#1085#1100#1096#1080#1090#1100' '#1076#1086' 1024x768'
        OnClick = MenuResizeBigClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object MenuConvertJPEG: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' JPEG'
        OnClick = MenuConvertJPEGClick
      end
      object MenuConvertBMP: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' BMP'
        OnClick = MenuConvertBMPClick
      end
      object MenuConvertTIFF: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' TIFF'
        OnClick = MenuConvertTIFFClick
      end
      object MenuConvertPNG: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' PNG'
        OnClick = MenuConvertPNGClick
      end
      object MenuConvertGIF: TMenuItem
        Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1074' GIF'
        OnClick = MenuConvertGIFClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuCopyPath: TMenuItem
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1087#1091#1090#1100' '#1074' '#1073#1091#1092#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      OnClick = MenuCopyPathClick
    end
    object MenuDirSize: TMenuItem
      Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1088#1072#1079#1084#1077#1088
      OnClick = MenuDirSizeClick
    end
    object MenuCreateFolder: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1087#1072#1087#1082#1091
      OnClick = MenuCreateFolderClick
    end
    object MenuCreateWith: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuCopy: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = MenuCopyClick
    end
    object MenuCut: TMenuItem
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      OnClick = MenuCutClick
    end
    object MenuPaste: TMenuItem
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      OnClick = MenuPasteClick
    end
    object MenuSelectAll: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = MenuSelectAllClick
    end
    object MenuSort: TMenuItem
      Caption = #1054#1090#1089#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
      object MenuSortByName: TMenuItem
        Caption = #1055#1086' '#1080#1084#1077#1085#1080
        OnClick = MenuSortByNameClick
      end
      object MenuSortBySize: TMenuItem
        Caption = #1055#1086' '#1088#1072#1079#1084#1077#1088#1091
        OnClick = MenuSortBySizeClick
      end
      object MenuSortByType: TMenuItem
        Caption = #1055#1086' '#1090#1080#1087#1091
        OnClick = MenuSortByTypeClick
      end
      object MenuSortByDate: TMenuItem
        Caption = #1055#1086' '#1076#1072#1090#1077
        OnClick = MenuSortByDateClick
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MenuRar: TMenuItem
      Caption = #1040#1088#1093#1080#1074#1080#1088#1086#1074#1072#1090#1100
      OnClick = MenuRarClick
    end
    object MenuDel: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = MenuDelClick
    end
    object MenuRename: TMenuItem
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      OnClick = MenuRenameClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuCopyToFlash: TMenuItem
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1085#1072
      OnClick = MenuCopyToFlashClick
    end
    object MenuCopyTo: TMenuItem
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074
      Visible = False
    end
    object MenuCopyFrom: TMenuItem
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1080#1079
      Visible = False
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object MenuBurn: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1087#1080#1089#1080' '#1085#1072' CD'
      OnClick = MenuBurnClick
    end
    object MenuMail: TMenuItem
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1087#1086' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1095#1090#1077
      OnClick = MenuMailClick
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object MenuBTOut: TMenuItem
      Caption = #1055#1077#1088#1077#1076#1072#1090#1100' '#1095#1077#1088#1077#1079' Bluetooth/IrDA'
      OnClick = MenuBTOutClick
    end
    object MenuBTIn: TMenuItem
      Caption = #1055#1088#1080#1085#1103#1090#1100' '#1095#1077#1088#1077#1079' Bluetooth/IrDA '#1089#1102#1076#1072
      OnClick = MenuBTInClick
    end
  end
  object ImageList: TImageList
    Left = 648
    Top = 2
  end
  object ImageListBig: TImageList
    Height = 32
    Width = 32
    Left = 616
    Top = 2
  end
  object ImageListTB: TImageList
    Height = 32
    Width = 32
    Left = 544
    Top = 2
  end
  object PopupMenuView: TPopupMenu
    AutoPopup = False
    Left = 98
    Top = 26
    object MenuViewIconic: TMenuItem
      Caption = #1047#1085#1072#1095#1082#1080
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuViewIconicClick
    end
    object MenuViewList: TMenuItem
      AutoCheck = True
      Caption = #1057#1087#1080#1089#1086#1082
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuViewListClick
    end
    object MenuViewTable: TMenuItem
      AutoCheck = True
      Caption = #1058#1072#1073#1083#1080#1094#1072
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuViewTableClick
    end
    object MenuViewThumbnail: TMenuItem
      AutoCheck = True
      Caption = #1069#1089#1082#1080#1079#1099
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuViewThumbnailClick
    end
  end
  object PopupMenu: TPopupMenu
    Left = 712
    Top = 40
    object MenuOpenMain: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnClick = MenuOpenMainClick
    end
    object MenuDVD: TMenuItem
      Caption = #1057#1084#1086#1090#1088#1077#1090#1100' DVD-'#1076#1080#1089#1082
      OnClick = MenuDVDClick
    end
    object MenuEject: TMenuItem
      Caption = #1048#1079#1074#1083#1077#1095#1100
      OnClick = MenuEjectClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object MenuFormat: TMenuItem
      Caption = #1060#1086#1088#1084#1072#1090#1080#1088#1086#1074#1072#1090#1100
      OnClick = MenuFormatClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object MenuFreeSpace: TMenuItem
      Caption = #1057#1074#1086#1073#1086#1076#1085#1086#1077' '#1084#1077#1089#1090#1086
      OnClick = MenuFreeSpaceClick
    end
  end
  object PopupMenuTree: TPopupMenu
    OnPopup = PopupMenuTreePopup
    Left = 72
    Top = 88
  end
end
