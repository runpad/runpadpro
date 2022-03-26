object fmRequestPIN: TfmRequestPIN
  Left = 473
  Top = 247
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1072' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' Bluetooth-'#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
  ClientHeight = 175
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object shTop: TShape
    Left = 0
    Top = 0
    Width = 393
    Height = 73
    Align = alTop
    Pen.Style = psClear
  end
  object Bevel1: TBevel
    Left = 0
    Top = 134
    Width = 393
    Height = 41
    Align = alBottom
  end
  object laPIN: TLabel
    Left = 65
    Top = 98
    Width = 21
    Height = 13
    Caption = 'PIN:'
  end
  object laSubTitle: TLabel
    Left = 20
    Top = 27
    Width = 311
    Height = 39
    AutoSize = False
    Caption = 
      #1042#1074#1077#1076#1080#1090#1077' PIN-'#1082#1086#1076' '#1077#1089#1083#1080' '#1086#1085' '#1085#1077#1086#1073#1093#1086#1076#1080#1084', '#1080#1083#1080' '#1085#1072#1078#1084#1080#1090#1077' "'#1054#1090#1084#1077#1085#1072'" '#1076#1083#1103' '#1087#1088#1086#1076 +
      #1086#1083#1078#1077#1085#1080#1103' '#1088#1072#1073#1086#1090#1099' '#1073#1077#1079' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1080
    Transparent = True
    WordWrap = True
  end
  object laTitle: TLabel
    Left = 11
    Top = 10
    Width = 283
    Height = 13
    Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1072' '#1072#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103' Bluetooth-'#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Image: TImage
    Left = 358
    Top = 10
    Width = 24
    Height = 24
    AutoSize = True
    Picture.Data = {
      07544269746D617096010000424D960100000000000076000000280000001800
      0000180000000100040000000000200100000000000000000000100000000000
      0000000000000000800000800000008080008000000080008000808000008080
      8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
      FF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF888FFFFFFFFFFFFFFFFF87C6CC6C0
      0000FFFFFFFFFFFC66C8660B7BFB0FFFFFFFFF8666CF87B600BFB0FFFFFFF7C6
      66CFF7C0606BF30FFFFFFC6CC6CFF7B003B3B30FFFFF8C666CCFF7FBCB3BF30F
      FFFF7CCFF8CFF7BFB3B3B30FFFFF7667FFC8F67B6B6BF30FFFFF766C7F8FFFF7
      BBBBBF300FFF76666CFFF8CC77777BB30FFF76666C8FFCC66668F7BF300F7666
      6CFFF8CC6668FF7BB30F766C7F8FFFF8C668FFF7BF307667FFC8F7FF6C68FFFF
      7BB08CCFF8CFFC8F7CC8FFFFF770FC666CCFFFF8C6CFFFFFFFFFF66CC6CFFF8C
      666FFFFFFFFFF86666C8F8CC668FFFFFFFFFFFF666CF8C666FFFFFFFFFFFFFF8
      66C86666FFFFFFFFFFFFFFFFF866667FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF}
  end
  object btOK: TButton
    Left = 132
    Top = 143
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btCancel: TButton
    Left = 217
    Top = 143
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edPIN: TEdit
    Left = 92
    Top = 92
    Width = 121
    Height = 21
    TabOrder = 0
  end
end
