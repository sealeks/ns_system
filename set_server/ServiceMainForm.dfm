object NS_SET_ServIO: TNS_SET_ServIO
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'NS_SET_ServIO'
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
