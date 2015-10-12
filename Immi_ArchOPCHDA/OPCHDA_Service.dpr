program OPCHDA_Service;

uses
  SvcMgr,
  ActiveX,Comobj,
  ServiceOPCHDAU in 'ServiceOPCHDAU.pas' {ServiceOPCHDA},
  GlobalValue,
  ConfigurationSys in '..\Units\ConfigurationSys.pas';

{$R *.RES}

begin
  CoInitFlags:= COINIT_MULTITHREADED;
  CoInitFlags:= COINIT_MULTITHREADED;
  CoInitialize(nil);
  Application.Initialize;
    InitialSys;
  Application.CreateForm(TServiceOPCHDA, ServiceOPCHDA);
  Application.Run;
end.
