object FormDlgXY: TFormDlgXY
  Left = 402
  Top = 240
  Caption = 'Coordinates'
  ClientHeight = 117
  ClientWidth = 174
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 156
    Height = 49
    Shape = bsFrame
  end
  object LabX: TLabel
    Left = 16
    Top = 24
    Width = 10
    Height = 13
    Caption = '&X:'
    FocusControl = EdX
  end
  object LabY: TLabel
    Left = 88
    Top = 24
    Width = 10
    Height = 13
    Caption = '&Y:'
    FocusControl = EdY
  end
  object OKBtn: TButton
    Left = 8
    Top = 76
    Width = 64
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 98
    Top = 76
    Width = 64
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object EdX: TEdit
    Left = 32
    Top = 24
    Width = 40
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object EdY: TEdit
    Left = 104
    Top = 24
    Width = 40
    Height = 21
    TabOrder = 3
    Text = '0'
  end
end
