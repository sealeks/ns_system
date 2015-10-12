program NS_MemBaseServ_app;

uses
  Forms,
  AlarmSrvFormU in 'AlarmSrvFormU.pas' {AlarmSrvForm},
  SysCommansGroupU in '..\Units\SysCommansGroupU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.CreateForm(TAlarmSrvForm, AlarmSrvForm);
  Application.Run;
end.
