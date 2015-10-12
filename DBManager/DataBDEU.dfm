object DataBDE: TDataBDE
  Left = 641
  Top = 198
  Width = 283
  Height = 148
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Trend: TQuery
    DatabaseName = 'trend'
    Left = 24
    Top = 24
  end
  object TrendConnection: TDataSource
    DataSet = Trend
    Left = 24
    Top = 56
  end
  object Alarm: TQuery
    DataSource = AlarmConnection
    Left = 64
    Top = 24
  end
  object AlarmConnection: TDataSource
    Left = 64
    Top = 56
  end
end
