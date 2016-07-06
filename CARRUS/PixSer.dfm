object SerBmpDlg: TSerBmpDlg
  Left = 322
  Top = 137
  BorderStyle = bsDialog
  Caption = 'BMP Parameters'
  ClientHeight = 252
  ClientWidth = 220
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TButton
    Left = 23
    Top = 219
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 119
    Top = 219
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PageControlPix: TPageControl
    Left = 0
    Top = 8
    Width = 220
    Height = 197
    ActivePage = TabSheetSing
    TabOrder = 2
    object TabSheetSing: TTabSheet
      Caption = 'Single picture'
      object Bevel1: TBevel
        Left = 6
        Top = 3
        Width = 201
        Height = 161
        Shape = bsFrame
      end
      object CellsGrBox: TGroupBox
        Left = 14
        Top = 9
        Width = 185
        Height = 81
        Caption = ' &Cells Range '
        TabOrder = 0
        object LabXmin: TLabel
          Left = 8
          Top = 20
          Width = 26
          Height = 13
          Caption = 'X&min:'
          FocusControl = EdXmin
        end
        object LabYmin: TLabel
          Left = 96
          Top = 20
          Width = 26
          Height = 13
          Caption = 'Ymi&n:'
          FocusControl = EdYmin
        end
        object LabXmax: TLabel
          Left = 8
          Top = 52
          Width = 30
          Height = 13
          Caption = '&Xmax:'
          FocusControl = EdXmax
        end
        object LabYmax: TLabel
          Left = 96
          Top = 52
          Width = 30
          Height = 13
          Caption = '&Ymax:'
          FocusControl = EdYmax
        end
        object EdXmin: TEdit
          Left = 40
          Top = 20
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '0'
        end
        object EdYmin: TEdit
          Left = 128
          Top = 20
          Width = 33
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object EdXmax: TEdit
          Left = 40
          Top = 52
          Width = 33
          Height = 21
          TabOrder = 2
          Text = '10'
        end
        object EdYmax: TEdit
          Left = 128
          Top = 52
          Width = 33
          Height = 21
          TabOrder = 3
          Text = '10'
        end
      end
      object OutParBox: TGroupBox
        Left = 14
        Top = 96
        Width = 185
        Height = 61
        Caption = ' &Output Parameters '
        TabOrder = 1
        object LabW: TLabel
          Left = 16
          Top = 16
          Width = 32
          Height = 13
          Caption = '&Width:'
          FocusControl = EdW
        end
        object LabH: TLabel
          Left = 74
          Top = 16
          Width = 35
          Height = 13
          Caption = '&Height:'
          FocusControl = EdH
        end
        object Label1: TLabel
          Left = 134
          Top = 16
          Width = 26
          Height = 13
          Caption = '&Step:'
          FocusControl = EdStep
        end
        object EdW: TEdit
          Left = 16
          Top = 32
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '7'
        end
        object EdH: TEdit
          Left = 76
          Top = 32
          Width = 33
          Height = 21
          TabOrder = 1
          Text = '3'
        end
        object EdStep: TEdit
          Left = 136
          Top = 32
          Width = 33
          Height = 21
          TabOrder = 2
          Text = '1'
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Many pictures'
      ImageIndex = 1
      object Bevel2: TBevel
        Left = 6
        Top = 3
        Width = 201
        Height = 161
        Shape = bsFrame
      end
      object GroupBoxCells: TGroupBox
        Left = 14
        Top = 11
        Width = 187
        Height = 57
        Caption = ' Cells '
        TabOrder = 0
        object LabSz: TLabel
          Left = 16
          Top = 21
          Width = 23
          Height = 13
          Caption = '&Size:'
          FocusControl = EdSz
        end
        object LabGap: TLabel
          Left = 104
          Top = 21
          Width = 23
          Height = 13
          Caption = '&Gap:'
          FocusControl = EdGap
        end
        object EdSz: TEdit
          Left = 45
          Top = 21
          Width = 36
          Height = 21
          TabOrder = 0
          Text = '5'
        end
        object EdGap: TEdit
          Left = 133
          Top = 21
          Width = 36
          Height = 21
          TabOrder = 1
          Text = '1'
        end
      end
      object OutParBox2: TGroupBox
        Left = 14
        Top = 88
        Width = 185
        Height = 61
        Caption = ' &Output Parameters '
        TabOrder = 1
        object LabFmt: TLabel
          Left = 16
          Top = 16
          Width = 38
          Height = 13
          Caption = '&Format:'
          FocusControl = EdFmt
        end
        object LabOffs: TLabel
          Left = 74
          Top = 16
          Width = 35
          Height = 13
          Caption = '&Offset:'
          FocusControl = EdOffs
        end
        object LabCnt: TLabel
          Left = 128
          Top = 16
          Width = 33
          Height = 13
          Caption = '&Count:'
          FocusControl = EdCnt
        end
        object EdFmt: TEdit
          Left = 16
          Top = 32
          Width = 44
          Height = 21
          TabOrder = 0
          Text = '%3.3d'
        end
        object EdOffs: TEdit
          Left = 74
          Top = 32
          Width = 44
          Height = 21
          TabOrder = 1
          Text = '1'
        end
        object EdCnt: TEdit
          Left = 128
          Top = 32
          Width = 44
          Height = 21
          TabOrder = 2
          Text = '10'
        end
      end
    end
  end
end
