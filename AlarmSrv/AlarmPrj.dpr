program AlarmPrj;

uses
  Forms,
  AlarmSrvFormU in 'AlarmSrvFormU.pas' {AlarmSrvForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAlarmSrvForm, AlarmSrvForm);
  Application.Run;
end.
