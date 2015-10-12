program ServerLogika_Service;

uses
  SvcMgr,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ServiceMainForm in 'ServiceMainForm.pas' {ServiceKoyo: TService},
  ServerU in 'ServerU.pas' {FormComServer},
  rormres in 'rormres.pas' {FormRecept};
{$R *.RES}

begin
  InitialSys;
  Application.Initialize;
  Application.CreateForm(TServiceKoyo, ServiceKoyo);
  
  Application.Run;
end.
