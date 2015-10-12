program Immi_OPCHDAprj;

uses
  Forms,
  Windows,
  MemStructsU in '..\Units\MemStructsU.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  OPCHDAClient in 'OPCHDAClient.pas',
  FormHDAClientUE in 'FormHDAClientUE.pas' {FormHDAClient},
  OPCHDACallback in 'OPCHDACallback.pas',
  OPCHDA in 'OPCHDA.pas',
  Dm2UOPC in 'Dm2UOPC.pas' {Dm2OPC: TDataModule},
  ArhiveTblOPCs in 'ArhiveTblOPCs.pas';

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
