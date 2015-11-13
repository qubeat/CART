object DlgAboutCAR: TDlgAboutCAR
  Left = 323
  Height = 124
  Top = 177
  Width = 218
  BorderStyle = bsDialog
  Caption = 'About'
  ClientHeight = 124
  ClientWidth = 218
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '1.0.6.0'
  object Bevel1: TBevel
    Left = 8
    Height = 65
    Top = 8
    Width = 201
  end
  object Label1: TLabel
    Left = 16
    Height = 32
    Top = 16
    Width = 180
    AutoSize = False
    Caption = 'Reversible Cellular Automata (extended, with rule trees)'
    ParentColor = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Height = 14
    Top = 48
    Width = 61
    Caption = 'Beta Version'
    ParentColor = False
  end
  object Image1: TImage
    Left = 160
    Height = 33
    Top = 32
    Width = 33
    Picture.Data = {
      055449636F6EFE0200000000010001002020100000000000E802000016000000
      2800000020000000400000000100040000000000800200000000000000000000
      0000000000000000000000000000800000800000008080008000000080008000
      8080000080808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00
      FFFF0000FFFFFF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CCCCCCC000000000000EEEEEEE00
      0000CCCCCCC000000000000EEEEEEE000000CCCCCCC000000000000EEEEEEE00
      0000CCCCCCC000000000000EEEEEEE000000CCCCCCC000000000000EEEEEEE00
      AAAACCCCCCC000000000000EEEEEEE00AAAACCCCCCC000000000000EEEEEEE00
      AAAAAAA0000000000000000000000000AAAAAAA0000000000000000000000000
      AAAAAAA0000000000000000000000000AAAAAAA0000000000000000000000000
      AAAAAAA000000000000000000444444400000000000000000000000004444444
      0000000000000000000000000444444400000000000000000000000004444444
      0000000000000000000000000444442222222000000000000000000004444422
      2222200000000000000000000444442222222000000000000099999990000022
      2222200000000000009999999000002222222000000000000099999990000022
      2222200000000000009999999000002222222000000000000099999990000000
      0000000000000000009999999000000000000000000000000099999990000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FFFFFFFF80000001BFFFFFFDBFFFFFFDBFFFF01DBE03F01D
      BE03F01DBE03F01DBE03F01DBE03001DBE03001DBE0301FDBFFF01FDBFFF01FD
      BFFF01FDBFFF01FDBF80FFFDBF80FFFDBF80FFFDBF80FFFDBF8007FDBF8007FD
      BF8007FD807C07FD807C07FD807C07FD807C07FD807FFFFD807FFFFD807FFFFD
      80000001FFFFFFFF
    }
  end
  object OKBtn: TButton
    Left = 71
    Height = 25
    Top = 92
    Width = 75
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
