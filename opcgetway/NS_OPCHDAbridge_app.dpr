program NS_OPCHDAbridge_app;

uses
  Forms,
  Windows,
  MemStructsU in '..\Units\MemStructsU.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  OPCHDAClient in '..\Immi_ArchOPCHDA\OPCHDAClient.pas',
  FormHDAClientUE in '..\Immi_ArchOPCHDA\FormHDAClientUE.pas' {FormHDAClient},
  OPCHDACallback in '..\Immi_ArchOPCHDA\OPCHDACallback.pas',
  OPCHDA in '..\Immi_ArchOPCHDA\OPCHDA.pas',
  Dm2UOPC in '..\Immi_ArchOPCHDA\Dm2UOPC.pas' {Dm2OPC: TDataModule},
  ArhiveTblOPCs in '..\Immi_ArchOPCHDA\ArhiveTblOPCs.pas';

// PLCComPort in '..\VCL\PLCComPort\PLCComPort.pas',
 // debugClasses in '..\Units\debugClasses.pas';

{$R *.RES}

begin
 // SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS		);

  Application.Initialize;
  InitialSys;
  Application.ShowMainForm:=false;
  Application.CreateForm(TFormHDAClient, FormHDAClient);
  //  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
