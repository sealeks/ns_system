object Service1: TService1
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'Service1'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  Left = 123
  Top = 100
  Height = 150
  Width = 215
  object Timer1: TTimer
    Left = 88
    Top = 56
  end
end
