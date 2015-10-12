object frmEditCSV: TfrmEditCSV
  Left = 239
  Top = 156
  Width = 685
  Height = 199
  Caption = 'frmEditCSV'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 560
    Top = 0
    Width = 117
    Height = 172
    Align = alRight
    TabOrder = 0
    object Button1: TButton
      Left = 18
      Top = 8
      Width = 75
      Height = 25
      Caption = #1042#1074#1086#1076
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 18
      Top = 40
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 560
    Height = 172
    Align = alClient
    ColCount = 1
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    ColWidths = (
      64)
  end
end
