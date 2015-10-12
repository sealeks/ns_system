object NS_MemBaseService: TNS_MemBaseService
  OldCreateOrder = False
  DisplayName = 'NS_MemBaseService'
  Interactive = True
  WaitHint = 5000000
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 512
  Top = 189
  Height = 150
  Width = 215
end
