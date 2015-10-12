object DataMSSQL: TDataMSSQL
  Left = 440
  Top = 153
  Width = 215
  Height = 150
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TrendConnection: TADOConnection
    LoginPrompt = False
    Mode = cmWrite
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 8
  end
  object TrendQuery: TADOQuery
    Connection = TrendConnection
    Parameters = <>
    Left = 96
    Top = 8
  end
end
