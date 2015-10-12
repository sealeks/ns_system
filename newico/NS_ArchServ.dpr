program NS_ArchServ;

uses
  SvcMgr,
  GlobalValue,
  ActiveX,
  ComObj,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  Windows,
  MemStructsU,
  DM1Us in '..\arcServ\DM1Us.pas' {Dm1s: TDataModule},
  ActiveAlarmListU in '..\arcServ\ActiveAlarmListU.pas',
  ServiceArchU in '..\arcServ\ServiceArchU.pas' {ServiceArch: TService};

{$R *.RES}

begin
 // Coinitialize(nil);
 // CoInitFlags:= COINIT_MULTITHREADED;
  Application.Initialize;
  // CoInitFlags:= COINIT_MULTITHREADED;
  InitialSys;
  Application.CreateForm(TServiceArch, ServiceArch);
  Application.Run;
end.
