program IMMI_archServiceApp;

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
  ReportGroupLocatorU in 'ReportGroupLocatorU.pas';

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
