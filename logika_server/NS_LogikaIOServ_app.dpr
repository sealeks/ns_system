program NS_LogikaIOServ_app;

uses
  Forms,
  ServerLogikaU in 'ServerLogikaU.pas' {FormLogikaServer},
  LogikaClasses in 'LogikaClasses.pas',
  LogikaThreadU in 'LogikaThreadU.pas',
  MemStructsU in '..\Units\memStructsU.pas',
  GroupsU in '..\Units\GroupsU.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  LogikaComPortU in 'LogikaComPortU.pas';

{$R *.RES}

begin
  Application.Initialize;
  InitialSys;
  Application.ShowMainForm:=false;  
  Application.Title := 'Com Сервер данных';
  Application.CreateForm(TFormLogikaServer, FormLogikaServer);
  Application.Run;
end.
