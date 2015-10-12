program NS_OPCDDEbridgeService;

uses
  SvcMgr,
  ServiceOPCGatwayU in 'ServiceOPCGatwayU.pas' {ServiceOPCGatway},
  GlobalValue,
  ConfigurationSys in '..\Units\ConfigurationSys.pas';

{$R *.RES}

begin
  Application.Initialize;
    InitialSys;
  Application.CreateForm(TServiceOPCGatway, ServiceOPCGatway);
  Application.Run;
end.
