program NS_DirectNetIOService;

uses
  SvcMgr,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ServiceMainForm in 'ServiceMainForm.pas' {NS_KoyoIOService: TService},
  ServerU in 'ServerU.pas' {FormComServer},
  rormres in 'rormres.pas' {FormRecept};

{$R *.RES}

begin
  InitialSys;
  Application.Initialize;

  Application.CreateForm(TNS_KoyoIOService, NS_KoyoIOService);
  Application.CreateForm(TFormComServer, FormComServer);
  Application.CreateForm(TFormRecept, FormRecept);
  Application.Run;
end.
