program prjNetShareSrv;

uses
  SvcMgr,
  NetShareSrvU in 'NetShareSrvU.pas' {IMMI_Net_Share: TService},
  NetShare in 'NetShare.pas' {frmNetShare};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'IMMI_Net_Share_Service';
  Application.CreateForm(TIMMI_Net_Share, IMMI_Net_Share);
  Application.Run;
end.
