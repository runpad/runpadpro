object InputPosForm: TInputPosForm
  Left = 254
  Top = 124
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 103
  ClientWidth = 284
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Edit1: TEdit
    Left = 0
    Top = 0
    Width = 121
    Height = 24
    AutoSize = False
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 24
    Top = 48
  end
end
