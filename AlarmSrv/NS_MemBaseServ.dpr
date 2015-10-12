program NS_MemBaseServ;

uses
  SvcMgr,
  AlarmSrvU in 'AlarmSrvU.pas' {NS_MemBaseService: TService},
  MemStructsU in '..\Units\MemStructsU.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TNS_MemBaseService, NS_MemBaseService);
  Application.Run;
end.
