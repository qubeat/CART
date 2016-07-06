object CellsDlg: TCellsDlg
  Left = 216
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Cell Field Parameters'
  ClientHeight = 115
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 49
    Shape = bsFrame
  end
  object LabNx: TLabel
    Left = 16
    Top = 24
    Width = 16
    Height = 13
    Caption = 'N&x:'
    FocusControl = EdNx
  end
  object LabNy: TLabel
    Left = 88
    Top = 24
    Width = 16
    Height = 13
    Caption = 'N&y:'
    FocusControl = EdNy
  end
  object LabSz: TLabel
    Left = 176
    Top = 24
    Width = 23
    Height = 13
    Caption = '&Size:'
    FocusControl = EdSz
  end
  object LabGap: TLabel
    Left = 240
    Top = 24
    Width = 23
    Height = 13
    Caption = '&Gap:'
    FocusControl = EdGap
  end
  object Bevel2: TBevel
    Left = 152
    Top = 8
    Width = 9
    Height = 49
    Shape = bsRightLine
  end
  object OKBtn: TButton
    Left = 71
    Top = 76
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 167
    Top = 76
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object EdNx: TEdit
    Left = 32
    Top = 24
    Width = 33
    Height = 17
    TabOrder = 2
    Text = '50'
  end
  object EdNy: TEdit
    Left = 104
    Top = 24
    Width = 33
    Height = 17
    TabOrder = 3
    Text = '50'
  end
  object EdSz: TEdit
    Left = 200
    Top = 24
    Width = 25
    Height = 17
    TabOrder = 4
    Text = '5'
  end
  object EdGap: TEdit
    Left = 264
    Top = 24
    Width = 25
    Height = 17
    TabOrder = 5
    Text = '1'
  end
end
