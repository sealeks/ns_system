object NS_Logika_ServIO: TNS_Logika_ServIO
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'NS_Logika_ServIO'
  Interactive = True
  StartType = stSystem
  WaitHint = 50000
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 460
  Top = 171
  Height = 149
  Width = 231
end
