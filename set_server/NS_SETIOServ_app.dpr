program NS_SETIOServ_app;

uses
  Forms,
  ServerSETU in 'ServerSETU.pas' {FormSETServer},
  SETClasses in 'SETClasses.pas',
  SETThreadU in 'SETThreadU.pas',
  MemStructsU in '..\Units\memStructsU.pas',
  GroupsU in '..\Units\GroupsU.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  SETComPortU in 'SETComPortU.pas';

{$R *.RES}

begin
  Application.Initialize;
  InitialSys;
  Application.ShowMainForm:=false;  
  Application.Title := 'SET Сервер данных';
  Application.CreateForm(TFormSETServer, FormSETServer);
  Application.Run;
end.
