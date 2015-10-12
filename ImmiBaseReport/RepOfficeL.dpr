program RepOfficeL;

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
  RepOfficeF in 'RepOfficeF.pas' {fJournal},
  AddPFU in 'AddPFU.pas' {AddPForm},
  RerEditU in 'RerEditU.pas' {RepEdit},
  UnitExpr in 'UnitExpr.pas' {FormExpr};

{$R *.res}
var i: integer;
begin
  InitialSys;
  Application.Initialize;
  Sincronize;
  Application.CreateForm(TfJournal, fJournal);
  Application.CreateForm(TFormExpr, FormExpr);
  {  for i := 1 to ParamCount do
  begin
    if trim(LowerCase(ParamStr(i))) = 'non' then
     fJournal.BorderStyle:=bsNone else
     fJournal.Position:=poDesktopCenter;
  end;       }
  Application.Run;
end.
