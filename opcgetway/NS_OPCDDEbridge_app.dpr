program NS_OPCDDEbridge_app;

uses
  Forms,
  Windows,
  MemStructsU in '..\Units\MemStructsU.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  OPCClient in 'OPCClient.pas',
  FormOPCClientUE in 'FormOPCClientUE.pas',
  DDEClient in 'DDEClient.pas',
  OPCCallback in 'OPCCallback.pas',
  OPCHDA in 'OPCHDA.pas';

// PLCComPort in '..\VCL\PLCComPort\PLCComPort.pas',
 // debugClasses in '..\Units\debugClasses.pas';

{$R *.RES}

begin
 // SetPriorityClass(GetCurrentProcess,NORMAL_PRIORITY_CLASS		);

  Application.Initialize;
  InitialSys;
  Application.ShowMainForm:=false;
  Application.CreateForm(TFormDDEClient, FormDDEClient);
  //  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
