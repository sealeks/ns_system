object NS_ArchiveService: TNS_ArchiveService
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'NS_ArchiveService'
  ErrorSeverity = esIgnore
  Interactive = True
  WaitHint = 500000
  OnContinue = ServiceContinue
  OnPause = ServicePause
  OnShutdown = ServiceShutdown
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 240
  Top = 171
  Height = 150
  Width = 215
end
