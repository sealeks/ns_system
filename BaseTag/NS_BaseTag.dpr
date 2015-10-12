program NS_BaseTag;

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
  KoyoServGroupU in 'KoyoServGroupU.pas',
  DDEGroupWraperU in 'DDEGroupWraperU.pas',
  OldGroupWraperU in 'OldGroupWraperU.pas',
  SocketWraperU in 'SocketWraperU.pas',
  AlarmItemWraperU in 'AlarmItemWraperU.pas',
  ArchiveItemWraperU in 'ArchiveItemWraperU.pas',
  EventWraperU in 'EventWraperU.pas',
  KoyoEthServGroupU in 'KoyoEthServGroupU.pas',
  FrmDfltNewU in 'FrmDfltNewU.pas' {frmdfltNew},
  OPCItemWraperU in 'OPCItemWraperU.pas',
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
  LogikaServGroupU in 'LogikaServGroupU.pas',
  KoyoServGroupsU in 'KoyoServGroupsU.pas',
  MetaWraperU in 'MetaWraperU.pas',
  FormMetaSelectU in 'FormMetaSelectU.pas' {FormMetaSelect},
  UpdateTrDfU in 'UpdateTrDfU.pas' {FormTrDfUpdate},
  SETServGroupU in 'SETServGroupU.pas',
  LogikaItemWrapU in 'LogikaItemWrapU.pas',
  SETItemWrapU in 'SETItemWrapU.pas';

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
  Application.CreateForm(TFormMetaSelect, FormMetaSelect);
  Application.CreateForm(TFormTrDfUpdate, FormTrDfUpdate);
  Application.Run;
end.
