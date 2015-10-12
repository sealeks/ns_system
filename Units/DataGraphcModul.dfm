object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 268
  Top = 363
  Height = 206
  Width = 448
  object Trend: TADOConnection
    ConnectOptions = coAsyncConnect
    LoginPrompt = False
    Mode = cmRead
    Provider = 'MSDASQL.1'
    BeforeConnect = TrendBeforeConnect
    Left = 72
    Top = 24
  end
end
