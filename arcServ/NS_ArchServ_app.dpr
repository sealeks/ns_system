program NS_ArchServ_app;

uses
  Forms,
  GlobalValue,
  ActiveX,
  Comobj,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  Windows,
  MemStructsU,
  DM1Us in 'DM1Us.pas' {Dm1s: TDataModule},
  SysVariablesU in '..\Units\SysVariablesU.pas',
  ReportGroupLocatorU in 'ReportGroupLocatorU.pas',
  ActiveAlarmListU in 'ActiveAlarmListU.pas',
  ReportCntGroupLocatorU in 'ReportCntGroupLocatorU.pas';

{$R *.RES}

begin
 // Coinitialize(nil);
  CoInitFlags:= COINIT_MULTITHREADED;
  Application.Initialize;
  Application.ShowMainForm:=false;
  InitialSys;
  Application.CreateForm(Tdm1s, dm1);
  Application.Run;
end.
