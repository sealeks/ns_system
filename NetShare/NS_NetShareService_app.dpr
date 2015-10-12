program NS_NetShareService_app;

uses
  Forms,
  NetShare in 'NetShare.pas' {frmNetShare},
  NetStructs in 'NetStructs.pas',
  frmTegListClientU in 'frmTegListClientU.pas' {frmTegListClient},
  frmTegListU in 'frmTegListU.pas' {frmTegList};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
  Application.Title := 'IMMI_Net_Share';
  Application.CreateForm(TfrmNetShare, frmNetShare);
  Application.CreateForm(TfrmTegListClient, frmTegListClient);
  Application.CreateForm(TfrmTegList, frmTegList);
  Application.Run;
end.
