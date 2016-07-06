object FormPix: TFormPix
  Left = 193
  Top = 125
  Width = 482
  Height = 287
  Caption = 'FormPix'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object StatusLine: TStatusBar
    Left = 0
    Top = 240
    Width = 474
    Height = 20
    Panels = <>
    SimplePanel = False
  end
  object ScrollPix: TScrollBox
    Left = 0
    Top = 0
    Width = 474
    Height = 240
    Align = alClient
    TabOrder = 1
    object Pix: TImage
      Left = 0
      Top = 0
      Width = 449
      Height = 217
    end
  end
end
