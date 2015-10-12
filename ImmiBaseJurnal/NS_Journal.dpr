program NS_Journal;

uses
  Forms,
  GlobalValue,
  StrUtils,
  System,
  SysUtils,
  ConfigurationSys in '..\Units\ConfigurationSys.pas',
  ConstDef in '..\Units\ConstDef.pas',
  MemStructsU in '..\Units\MemStructsU.pas',
  TimeSincronize in '..\Units\TimeSincronize.pas',
  fJournalU in 'fJournalU.pas' {fJournal};

{$R *.res}
var i: integer;
begin
  Application.Initialize;
  Application.CreateForm(TfJournal, fJournal);
  Application.Run;
end.
