program LocalBaseSevice;

uses
  SvcMgr,
  AlarmSrvU in 'AlarmSrvU.pas' {AlarmSrv: TService},
  MemStructsU in '..\Units\MemStructsU.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TAlarmSrv, AlarmSrv);
  Application.Run;
end.
