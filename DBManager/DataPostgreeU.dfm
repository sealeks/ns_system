object DataPostgree: TDataPostgree
  Left = 542
  Top = 134
  Width = 326
  Height = 141
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object TrendConnection: TZConnection
    Protocol = 'postgresql-8'
    Left = 40
    Top = 8
  end
  object TrendQuery: TZQuery
    Connection = TrendConnection
    Params = <>
    Left = 104
    Top = 8
  end
end
