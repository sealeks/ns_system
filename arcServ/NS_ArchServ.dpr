program NS_ArchServ;

uses
  SvcMgr,
  GlobalValue,
  ActiveX,
  ComObj,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  Windows,
  MemStructsU,
  DM1Us in 'DM1Us.pas' {Dm1s: TDataModule},
  ActiveAlarmListU in 'ActiveAlarmListU.pas',
  ServiceArchU in 'ServiceArchU.pas' {NS_ArchiveService: TService};

{$R *.RES}

begin
 // Coinitialize(nil);
 // CoInitFlags:= COINIT_MULTITHREADED;
  Application.Initialize;
  // CoInitFlags:= COINIT_MULTITHREADED;
  InitialSys;
  Application.CreateForm(TNS_ArchiveService, NS_ArchiveService);
  Application.Run;
end.
