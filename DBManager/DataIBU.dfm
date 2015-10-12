object DataIB: TDataIB
  Left = 192
  Top = 107
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
  object TrendConnection: TIBDatabase
    DatabaseName = 'C:\Program Files\Borland\InterBase\bin\TRENDIBBASE'
    LoginPrompt = False
    IdleTimer = 0
    SQLDialect = 3
    TraceFlags = []
    Left = 128
    Top = 32
  end
  object Transaction: TIBTransaction
    Active = False
    DefaultDatabase = TrendConnection
    AutoStopAction = saNone
    Left = 144
    Top = 80
  end
  object TrendQuery: TIBQuery
    Database = TrendConnection
    Transaction = Transaction
    BufferChunks = 1000
    CachedUpdates = False
    Left = 48
    Top = 48
  end
end
