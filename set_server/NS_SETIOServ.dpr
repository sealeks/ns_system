program NS_SETIOServ;

uses
  SvcMgr,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ServiceMainForm in 'ServiceMainForm.pas' {NS_SET_ServIO: TService},
  ServerSETU in 'ServerSETU.pas' {FormSETServer};

{$R *.RES}

begin
  Application.Initialize;
  InitialSys;
  
  Application.CreateForm(TNS_SET_ServIO, NS_SET_ServIO);
  Application.Run;
end.
