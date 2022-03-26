object BodyRecycleForm: TBodyRecycleForm
  Left = 259
  Top = 107
  Width = 752
  Height = 536
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 744
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object CoolBar1: TCoolBar
      Left = 0
      Top = 0
      Width = 744
      Height = 56
      AutoSize = True
      BandMaximize = bmNone
      Bands = <
        item
          Control = ToolBar1
          ImageIndex = -1
          MinHeight = 52
          Width = 740
        end>
      FixedOrder = True
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 736
        Height = 52
        AutoSize = True
        ButtonHeight = 52
        ButtonWidth = 90
        Caption = 'ToolBar1'
        EdgeBorders = []
        Flat = True
        Images = ImageList1
        Indent = 10
        ShowCaptions = True
        TabOrder = 0
        Transparent = True
        object ButtonRefresh: TToolButton
          Left = 10
          Top = 0
          Caption = 'Refresh'
          ImageIndex = 0
          OnClick = ButtonRefreshClick
        end
        object ToolButton2: TToolButton
          Left = 100
          Top = 0
          Width = 15
          Caption = 'ToolButton2'
          ImageIndex = 1
          Style = tbsSeparator
        end
        object ButtonRestore: TToolButton
          Left = 115
          Top = 0
          Caption = 'Restore'
          ImageIndex = 1
          OnClick = ButtonRestoreClick
        end
        object ToolButton4: TToolButton
          Left = 205
          Top = 0
          Width = 15
          Caption = 'ToolButton4'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object ButtonEmpty: TToolButton
          Left = 220
          Top = 0
          Caption = 'Empty recycle bin'
          ImageIndex = 2
          OnClick = ButtonEmptyClick
        end
        object ToolButton3: TToolButton
          Left = 310
          Top = 0
          Width = 15
          Caption = 'ToolButton3'
          ImageIndex = 3
          Style = tbsSeparator
        end
        object ButtonDelete: TToolButton
          Left = 325
          Top = 0
          Caption = 'del_hidden'
          ImageIndex = 3
          Visible = False
          OnClick = ButtonDeleteClick
        end
      end
    end
  end
  object ShellListView: TShellListView
    Left = 0
    Top = 65
    Width = 744
    Height = 444
    AutoContextMenus = False
    AutoNavigate = False
    ObjectTypes = [otFolders, otNonFolders]
    Root = 'rfRecycleBin'
    Sorted = True
    Align = alClient
    ColumnClick = False
    OnDblClick = ShellListViewDblClick
    HideSelection = False
    RowSelect = True
    OnChange = ShellListViewChange
    OnContextPopup = ShellListViewContextPopup
    TabOrder = 0
    ViewStyle = vsReport
    OnKeyDown = ShellListViewKeyDown
    OnEditing = ShellListViewEditing
  end
  object ImageList1: TImageList
    Height = 32
    Width = 32
    Left = 496
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Left = 40
    Top = 176
    object MenuRestore: TMenuItem
      Caption = 'Restore'
      OnClick = MenuRestoreClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object MenuDelete: TMenuItem
      Caption = 'Delete'
      OnClick = MenuDeleteClick
    end
  end
end
