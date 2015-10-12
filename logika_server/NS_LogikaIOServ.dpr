program NS_LogikaIOServ;

uses
  SvcMgr,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ServiceMainForm in 'ServiceMainForm.pas' {NS_Logika_ServIO: TService},
  ServerLogikaU in 'ServerLogikaU.pas' {FormLogikaServer};

{$R *.RES}

begin
  Application.Initialize;
  InitialSys;
  
  Application.CreateForm(TNS_Logika_ServIO, NS_Logika_ServIO);
  Application.Run;
end.
