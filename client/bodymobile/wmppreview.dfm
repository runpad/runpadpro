object WMPPreviewForm: TWMPPreviewForm
  Left = 265
  Top = 107
  BorderStyle = bsDialog
  ClientHeight = 384
  ClientWidth = 512
  Color = clBlack
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
  object WMP: TWindowsMediaPlayer
    Left = 0
    Top = 0
    Width = 512
    Height = 384
    TabStop = False
    Align = alClient
    TabOrder = 0
    ControlData = {
      000300000800000000000500000000000000F03F030000000000050000000000
      0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
      08000200000000000300320000000B00000008000A000000660075006C006C00
      00000B0000000B0000000B00FFFF0B0000000B00000008000200000000000800
      020000000000080002000000000008000200000000000B000000EB340000B027
      0000}
  end
end
