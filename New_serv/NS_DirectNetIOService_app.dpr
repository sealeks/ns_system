program NS_DirectNetIOService_app;

uses
  Forms,
  ServerU in 'ServerU.pas' {FormComServer},
  serverClasses in 'serverClasses.pas',
  ServerThreadU in 'ServerThreadU.pas',
  MemStructsU in '..\Units\memStructsU.pas',
  GroupsU in '..\Units\GroupsU.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  PLCComPort in 'plccomport.pas',
  rormres in 'rormres.pas' {FormRecept};

{$R *.RES}

begin
  Application.Initialize;
    InitialSys;
  Application.ShowMainForm:=false;  
  Application.Title := 'Com Сервер данных';
  Application.CreateForm(TFormComServer, FormComServer);
  Application.CreateForm(TFormRecept, FormRecept);
  Application.Run;
end.
