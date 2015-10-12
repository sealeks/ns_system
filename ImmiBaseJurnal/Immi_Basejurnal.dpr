program Immi_Basejurnal;

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
  fJournalU in '..\ImmiBaseReport\fJournalU.pas' {fJournal};

{$R *.res}
var i: integer;
begin
  InitialSys;
  Application.Initialize;
  Sincronize;
  Application.CreateForm(TfJournal, fJournal);
  {  for i := 1 to ParamCount do
  begin
    if trim(LowerCase(ParamStr(i))) = 'non' then
     fJournal.BorderStyle:=bsNone else
     fJournal.Position:=poDesktopCenter;
  end;       }
  Application.Run;
end.
