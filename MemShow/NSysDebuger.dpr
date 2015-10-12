program NSysDebuger;

uses
  Forms,
  main in 'main.pas' {Form1},
  MemStructsU in '..\Units\MemStructsU.pas',
  GlobalValue in '..\Units\GlobalValue.pas',
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  SetTag in 'SetTag.pas' {FormSetTag};

{$R *.RES}

begin
  InitialSys;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSetTag, FormSetTag);
  Application.Run;
end.
