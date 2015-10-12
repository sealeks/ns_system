object ServiceOPCGatway: TServiceOPCGatway
  OldCreateOrder = False
  DisplayName = 'IMMI_OPCGatway'
  Interactive = True
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 415
  Top = 399
  Height = 150
  Width = 215
end
