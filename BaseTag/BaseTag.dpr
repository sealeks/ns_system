program BaseTag;

uses
  Forms,
  main in 'main.pas' {Form1},
  FrmGrpNewU in 'FrmGrpNewU.pas' {FrmGrpNew},
  FrmGrpDblU in 'FrmGrpDblU.pas' {FrmGrpDbl},
  ViewDSDoc in 'ViewDSDoc.pas' {ESDImpFrm},
  configurationsys,
  ItemAdapterU in 'ItemAdapterU.pas',
  SimpleItemAdapterU in 'SimpleItemAdapterU.pas',
  ItemCoordinator in 'ItemCoordinator.pas',
  SimpleGroupAdapterU in 'SimpleGroupAdapterU.pas',
  OPCGroupAdapterU in 'OPCGroupAdapterU.pas',
  HDAGroupAdapterU in 'HDAGroupAdapterU.pas',
  HDAItemWraperU in 'HDAItemWraperU.pas',
  KoyoServGroupU in '..\New_serv\KoyoServGroupU.pas',
  DDEGroupWraperU in '..\New_serv\DDEGroupWraperU.pas',
  OldGroupWraperU in '..\New_serv\OldGroupWraperU.pas',
  SocketWraperU in 'SocketWraperU.pas',
  AlarmItemWraperU in '..\New_serv\AlarmItemWraperU.pas',
  ArchiveItemWraperU in '..\New_serv\ArchiveItemWraperU.pas',
  EventWraperU in '..\New_serv\EventWraperU.pas',
  KoyoEthServGroupU in 'KoyoEthServGroupU.pas',
  FrmDfltNewU in 'FrmDfltNewU.pas' {frmdfltNew},
  OPCItemWraperU in '..\New_serv\OPCItemWraperU.pas',
  SysGroupWrapU in 'SysGroupWrapU.pas',
  SysVarItemWrapU in 'SysVarItemWrapU.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  ProjectpropItWrapU in 'ProjectpropItWrapU.pas',
  DBConnetCofig in '..\DBManager\DBConnetCofig.pas' {FormDBConfig},
  OldProjectFormU in 'OldProjectFormU.pas' {OldProjectForm},
  ReportItemWraperU in 'ReportItemWraperU.pas',
  ArchGroupWrapU in 'ArchGroupWrapU.pas',
  PointerGroupWrapU in 'PointerGroupWrapU.pas',
  FormVarSelectU in 'FormVarSelectU.pas' {FormVarSelect},
  LogikaServGroupU in 'ico\LogikaServGroupU.pas',
  KoyoServGroupsU in 'KoyoServGroupsU.pas';

{$R *.res}

begin
  InitialSys();
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmGrpNew, FrmGrpNew);
  Application.CreateForm(TFrmGrpDbl, FrmGrpDbl);
  Application.CreateForm(TESDImpFrm, ESDImpFrm);
  Application.CreateForm(TfrmdfltNew, frmdfltNew);
  Application.CreateForm(TFormDBConfig, FormDBConfig);
  Application.CreateForm(TOldProjectForm, OldProjectForm);
  Application.CreateForm(TFormVarSelect, FormVarSelect);
  Application.Run;
end.
